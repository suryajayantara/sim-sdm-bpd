<%-- 
    Document   : MasterNotificationAjax
    Created on : Jun 19, 2020, 11:36:35 AM
    Author     : Utk
--%>

<%@page import="com.dimata.harisma.form.masterdata.CtrlNotification"%>
<%@page import="com.dimata.harisma.entity.log.ChangeValue"%>
<%@page import="com.dimata.util.Command"%>
<%@page import="com.dimata.harisma.form.masterdata.CtrlDivision"%>
<%@page import="com.dimata.harisma.entity.admin.AppObjInfo"%>
<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_MASTERDATA, AppObjInfo.G2_MD_COMPANY, AppObjInfo.OBJ_DIVISION);%>
<%@ include file = "../main/checkuser.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String search_user = FRMQueryString.requestString(request, "search_user");
    String notifStatus = FRMQueryString.requestString(request, "notifStatus");
    int iCommand = FRMQueryString.requestInt(request, "command");
    int start = FRMQueryString.requestInt(request, "start");
    String whereClause = "";
    String order = PstNotification.fieldNames[PstNotification.FLD_NOTIFICATION_ID];
    Vector listNotification = new Vector();
    Vector listNotificationMapping = new Vector();
    ChangeValue changeValue = new ChangeValue();
    CtrlNotification ctrlNotification = new CtrlNotification(request);
    
    int recordToGet = 10;
    int vectSize = 0;
    //String status = "";
    if ((notifStatus.equals("0"))){
    notifStatus="'0'" ;
    }else if((notifStatus.equals("1"))) {
    notifStatus="'1'" ;
    }else{
    notifStatus="'1' OR '2'" ;   
    }

    if (!(search_user.equals("0"))){
        whereClause = PstNotification.fieldNames[PstNotification.FLD_NOTIFICATION_STATUS]+" = "+notifStatus+"";
       
    } else {
        whereClause = PstNotification.fieldNames[PstNotification.FLD_NOTIFICATION_STATUS]+" = "+notifStatus+"";
    }
    

    vectSize = PstNotification.getCount(whereClause);
    if ((iCommand == Command.FIRST) || (iCommand == Command.NEXT) || (iCommand == Command.PREV)
            || (iCommand == Command.LAST) || (iCommand == Command.LIST)) {
        start = ctrlNotification.actionList(iCommand, start, vectSize, recordToGet);
    }
    listNotification = PstNotification.list(start, recordToGet, whereClause, order);
    if (listNotification != null && listNotification.size()>0){
    %>
    <table class="tblStyle">
        <tr>
            <td class="title_tbl" style="background-color: #DDD;">No</td>
            <td class="title_tbl" style="background-color: #DDD;">Jenis Notifikasi</td>
            <td class="title_tbl" style="background-color: #DDD;">Notifikasi Sebelum hari H</td>
            <td class="title_tbl" style="background-color: #DDD;">User</td>
            <td class="title_tbl" style="background-color: #DDD;">Satuan Kerja</td>
            <td class="title_tbl" style="background-color: #DDD;">Status</td>
            <td class="title_tbl" style="background-color: #DDD;">Action</td>
        </tr>
        <%
        for (int i = 0; i < listNotification.size(); i++) {
            Notification notification = (Notification) listNotification.get(i);
            NotificationMapping notificationMapping = new NotificationMapping();
            
            String notifType = PstNotification.NotificationType[notification.getNotificationType()];
            String EmployeeUserList = "";
            try {
                listNotificationMapping = PstNotificationMapping.list(0,0,""+PstNotificationMapping.fieldNames[PstNotificationMapping.FLD_NOTIFICATION_ID]+" = "+notification.getOID(),"");
            //get employee list
           
            for(int x = 0; x < listNotificationMapping.size() ; x++ ){
                notificationMapping = (NotificationMapping) listNotificationMapping.get(x);
                AppUser appUser = (AppUser) PstAppUser.fetch(notificationMapping.getUserId());
                Employee employee = (Employee) PstEmployee.fetchExc(appUser.getEmployeeId());
                EmployeeUserList = EmployeeUserList +" ("+ appUser.getLoginId() +") " +employee.getFullName()+"<br>";
            }
            
            } catch (Exception e) {
                System.out.println("e=>"+e.toString());
            }
            
            String division = "";
            Vector listDivMap = PstNotificationMappingDivision.list(0, 0, ""+PstNotificationMappingDivision.fieldNames[PstNotificationMapping.FLD_NOTIFICATION_ID]+" = "+notification.getOID(), "");
            if (listDivMap.size()>0){
                for (int x=0; x < listDivMap.size();x++){
                    NotificationMappingDivision mapDiv = (NotificationMappingDivision) listDivMap.get(x);
                    try {
                        Division dv = PstDivision.fetchExc(mapDiv.getDivisionId());
                        if (division.length()>0){
                            division += ",";
                        }
                        division += ""+dv.getDivision();
                    } catch (Exception exc){}
                }
            } else {
                division = "Semua Satuan Kerja";
            }
            
            %>
            <tr>
                <td><%=(i+1)+start%></td>
                <td><%=notifType%></td>
                <td><%=notification.getNotificationDays()%></td>
                <td><%=EmployeeUserList%></td>
                <td><%=division%></td>
                <td><%=PstNotification.StatusValue[notification.getNotificationStatus()]%></td>
                <td>
                    <% if(privUpdate){ %>
                    <a class="btn-small-e" style="color:#FFF" href="javascript:cmdEdit('<%=notification.getOID()%>')">e</a>
                    <% } %>
                    &nbsp;
                    <% if(privDelete){ %>
                    <a class="btn-small-x" style="color:#FFF" href="javascript:cmdAsk('<%=notification.getOID()%>')">&times;</a>
                    <% } %>
                </td>
            </tr>
            <%
        
        }%>
    </table>
        <div>&nbsp;</div>
        <div id="record_count">
            <%
            if (vectSize >= recordToGet){
                %>
                List : <%=(start+1)%> &HorizontalLine; <%= (start+listNotification.size()) %> | 
                <%
            }
            %>
            Total : <%= vectSize %>
        </div>
        <div class="pagging">
            <a style="color:#F5F5F5" href="javascript:cmdListFirst('<%=start%>')" class="btn-small">First</a>
            <a style="color:#F5F5F5" href="javascript:cmdListPrev('<%=start%>')" class="btn-small">Previous</a>
            <a style="color:#F5F5F5" href="javascript:cmdListNext('<%=start%>')" class="btn-small">Next</a>
            <a style="color:#F5F5F5" href="javascript:cmdListLast('<%=start%>')" class="btn-small">Last</a>
        </div>
    <%
    }else{
    %>
    <table class="tblStyle">
    <tr>
            <td class="title_tbl" style="background-color: #DDD;">No</td>
            <td class="title_tbl" style="background-color: #DDD;">Jenis Notifikasi</td>
            <td class="title_tbl" style="background-color: #DDD;">Notifikasi Sebelum hari H</td>
            <td class="title_tbl" style="background-color: #DDD;">User</td>
            <td class="title_tbl" style="background-color: #DDD;">Satuan Kerja</td>
            <td class="title_tbl" style="background-color: #DDD;">Status</td>
            <td class="title_tbl" style="background-color: #DDD;">Action</td>
     </tr>
     <tr>
         <td class="title_tbl" colspan="7"><center>No Data Found</center></td>
     <tr>      
            
    </table>
    <%
}
%>
<%-- 
    Document   : department_ajax///
    Created on : Jan 7, 2016, 5:08:42 PM
    Author     : Dimata 007
--%>
<%@page import="com.dimata.util.Command"%>
<%@page import="com.dimata.harisma.form.masterdata.CtrlDepartment"%>
<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_MASTERDATA, AppObjInfo.G2_MD_COMPANY, AppObjInfo.OBJ_DEPARTMENT);%>
<%@ include file = "../main/checkuser.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String departName = FRMQueryString.requestString(request, "depart_name");
    String valid_status_select = FRMQueryString.requestString(request, "valid_status_select");
    int iCommand = FRMQueryString.requestInt(request, "command");
    int start = FRMQueryString.requestInt(request, "start");
    String whereClause = "";
    String order = PstDepartment.TBL_HR_DEPARTMENT+"."+PstDepartment.fieldNames[PstDepartment.FLD_DEPARTMENT];
    Vector listDepartment = new Vector();
    
    CtrlDepartment ctrlDepart = new CtrlDepartment(request);
    
    int recordToGet = 10;
    int vectSize = 0;
    
    if ((valid_status_select.equals("0"))){
    valid_status_select="'0'" ;
    }else if((valid_status_select.equals("1"))) {
    valid_status_select="'1'" ;
    }else{
    valid_status_select="'1' OR '2'" ;   
    }

    if (!(departName.equals("0"))){
        whereClause = PstDepartment.TBL_HR_DEPARTMENT+"."+PstDepartment.fieldNames[PstDepartment.FLD_DEPARTMENT]+" LIKE '%"+departName+"%'AND "+PstDepartment.TBL_HR_DEPARTMENT+"."+PstDepartment.fieldNames[PstDepartment.FLD_VALID_STATUS] +" LIKE "+valid_status_select+"";
    } else {
        whereClause = PstDepartment.TBL_HR_DEPARTMENT+"."+PstDepartment.fieldNames[PstDepartment.FLD_VALID_STATUS] +" LIKE "+valid_status_select+"";
    }
    vectSize = PstDepartment.getCount(whereClause);
    if ((iCommand == Command.FIRST) || (iCommand == Command.NEXT) || (iCommand == Command.PREV)
            || (iCommand == Command.LAST)) {
        start = ctrlDepart.actionList(iCommand, start, vectSize, recordToGet);
    }
    
    listDepartment = PstDepartment.list(start, recordToGet, whereClause, order);
    
    if (listDepartment != null && listDepartment.size()>0){
        %>
        <table class="tblStyle">
            <tr>
                <td class="title_tbl" style="background-color: #DDD;">No</td>
                <td class="title_tbl" style="background-color: #DDD;"><%=dictionaryD.getWord(I_Dictionary.DEPARTMENT)%></td>
                <td class="title_tbl" style="background-color: #DDD;"><%=dictionaryD.getWord(I_Dictionary.DIVISION)%></td>
                <td class="title_tbl" style="background-color: #DDD;"><%=dictionaryD.getWord(I_Dictionary.DESCRIPTION)%></td>
                <td class="title_tbl" style="background-color: #DDD;">HOD Join to <%=dictionaryD.getWord(I_Dictionary.DEPARTMENT)%></td>
                <td class="title_tbl" style="background-color: #DDD;">Valid Status</td>
                <td class="title_tbl" style="background-color: #DDD;">Action</td>
            </tr>
            <%
            for(int i=0; i<listDepartment.size(); i++){
                Department depart = (Department)listDepartment.get(i);
                Division division = new Division();
                try {
                    division = PstDivision.fetchExc(depart.getDivisionId());
                } catch (Exception e) {
                    System.out.println("=>"+e.toString());
                }
                %>
                <tr>
                    <td><%=(i+1)+start%></td>
                    <td><%=depart.getDepartment()%></td>
                    <td><%=division.getDivision()%></td>
                    <td><%= depart.getDescription() !=null && depart.getDescription().length() > 0 ? depart.getDescription():"-" %></td>
                    <td><%=depart.getJoinToDepartment()!=null ?depart.getJoinToDepartment():"-"%></td>
                    <td><%= PstDepartment.validStatusValue[depart.getValidStatus()] %></td>
                    <td><a class="btn-small-e" style="color:#FFF" href="javascript:cmdEdit('<%=depart.getOID()%>')" >e</a>&nbsp;<a class="btn-small-x" style="color:#FFF" href="javascript:cmdAsk('<%=depart.getOID()%>')">&times;</a></td>
                </tr>
                <%
            }
            %>
        </table>
        <div>&nbsp;</div>
        <div id="record_count">
            <%
            if (vectSize >= recordToGet){
                %>
                List : <%=(start+1)%> &HorizontalLine; <%= (start+listDepartment.size()) %> | 
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
    }
%>

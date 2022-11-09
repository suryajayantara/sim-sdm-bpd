<%-- 
    Document   : division_ajax
    Created on : Jan 7, 2016, 1:44:18 PM
    Author     : Dimata 007
--%>
<%@page import="com.dimata.harisma.entity.log.ChangeValue"%>
<%@page import="com.dimata.util.Command"%>
<%@page import="com.dimata.harisma.form.masterdata.CtrlDivision"%>
<%@page import="com.dimata.harisma.entity.admin.AppObjInfo"%>
<%@ include file = "../../main/javainit.jsp" %>
<% int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_MASTERDATA, AppObjInfo.G2_MD_COMPANY, AppObjInfo.OBJ_DIVISION);%>
<%@ include file = "../../main/checkuser.jsp" %>
<%@ page import ="java.util.*,
                  java.text.*,				  
                  com.dimata.qdep.form.*,				  
                  com.dimata.gui.jsp.*,
                  com.dimata.util.*,				  
                  com.dimata.harisma.entity.masterdata.*,				  				  
                  com.dimata.harisma.entity.employee.*,
                  com.dimata.harisma.entity.attendance.*,
                  com.dimata.harisma.entity.search.*,
                  com.dimata.harisma.form.masterdata.*,				  				  
                  com.dimata.harisma.form.attendance.*,
                  com.dimata.harisma.form.search.*,				  
                  com.dimata.harisma.session.attendance.*,
                  com.dimata.harisma.session.leave.SessLeaveApp,
                  com.dimata.harisma.session.leave.*,
                  com.dimata.harisma.session.attendance.SessLeaveManagement,
                  com.dimata.harisma.session.leave.RepItemLeaveAndDp"%>
<%@page contentType="application/x-msexcel" pageEncoding="UTF-8"%>
<%
    response.setHeader("Content-Disposition","attachment;filename= Unit_(Department).xls");
    String departName = FRMQueryString.requestString(request, "depart_name");
    String valid_status_select = FRMQueryString.requestString(request, "valid_status_select");
    int iCommand = FRMQueryString.requestInt(request, "command");
    int start = FRMQueryString.requestInt(request, "start");
    String whereClause = "";
    String order = "";
    Vector listDepartment = new Vector();
    
    CtrlDepartment ctrlDepart = new CtrlDepartment(request);
    
    int recordToGet = 0;
    int vectSize = 0;
    
    if ((valid_status_select.equals("0"))){
    valid_status_select="'0'" ;
    }else if((valid_status_select.equals("1"))) {
    valid_status_select="'1'" ;
    }else{
    valid_status_select="'1' OR '2'" ;   
    }

    if (!(departName.equals("0"))){
        whereClause = PstDepartment.fieldNames[PstDepartment.FLD_DEPARTMENT]+" LIKE '%"+departName+"%'AND DEPT."+PstDepartment.fieldNames[PstDepartment.FLD_VALID_STATUS] +" LIKE "+valid_status_select+"";
        order = PstDepartment.fieldNames[PstDepartment.FLD_DEPARTMENT];
        vectSize = PstDepartment.getCount(whereClause);
        listDepartment = PstDepartment.listDepartment(0, 0, whereClause, order);        
    } else {
        whereClause = PstDepartment.TBL_HR_DEPARTMENT+"."+PstDepartment.fieldNames[PstDepartment.FLD_VALID_STATUS] +" LIKE "+valid_status_select+"";
        vectSize = PstDepartment.getCount("");
        order = PstDepartment.fieldNames[PstDepartment.FLD_DEPARTMENT];
        listDepartment = PstDepartment.list(start, recordToGet, whereClause, order);
    }
   
    if (listDepartment != null && listDepartment.size()>0){
        %>
       <html>
        <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <!-- #BeginEditable "styles" -->
        <link rel="stylesheet" href="../../styles/main.css" type="text/css">
        <!-- #EndEditable --> <!-- #BeginEditable "stylestab" -->
        <link rel="stylesheet" href="../../styles/tab.css" type="text/css">
        <!-- #EndEditable --> <!-- #BeginEditable "headerscript" -->
        <!-- #EndEditable -->
    </head>
    <body>
        <table class="tblStyle" border="1">
            <tr style="text-align: center">
                <th class="title_tbl" style="background-color: #DDD;">No</th>
                <th class="title_tbl" style="background-color: #DDD;"><%=dictionaryD.getWord(I_Dictionary.DEPARTMENT)%></th>
                <th class="title_tbl" style="background-color: #DDD;"><%=dictionaryD.getWord(I_Dictionary.DIVISION)%></th>
                <th class="title_tbl" style="background-color: #DDD;"><%=dictionaryD.getWord(I_Dictionary.DESCRIPTION)%></th>
                <th class="title_tbl" style="background-color: #DDD;">HOD Join to <%=dictionaryD.getWord(I_Dictionary.DEPARTMENT)%></th>
                <th class="title_tbl" style="background-color: #DDD;">Valid Status</th>
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
                    <td><%=(i+1)%></td>
                    <td><%=depart.getDepartment()%></td>
                    <td><%=division.getDivision()%></td>
                    <td><%= depart.getDescription() !=null && depart.getDescription().length() > 0 ? depart.getDescription():"-" %></td>
                    <td><%=depart.getJoinToDepartment()!=null ?depart.getJoinToDepartment():"-"%></td>
                    <td><%= PstDepartment.validStatusValue[depart.getValidStatus()] %></td>
                </tr>
                <%
            }
            %>
        </table>
        <%
    }
%>
    </body>
</html>
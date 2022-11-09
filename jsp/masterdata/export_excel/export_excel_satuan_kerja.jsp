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
    response.setHeader("Content-Disposition","attachment;filename= Satuan_Kerja_(Divisi).xls");
    String divisionName = FRMQueryString.requestString(request, "division_name");
    String valid_status_select = FRMQueryString.requestString(request, "valid_status_select");
    int iCommand = FRMQueryString.requestInt(request, "command");
    int start = FRMQueryString.requestInt(request, "start");
    String whereClause = "";
    String order = "";
    Vector listDivision = new Vector();
    ChangeValue changeValue = new ChangeValue();
    CtrlDivision ctrlDivision = new CtrlDivision(request);
    
    int recordToGet = 0;
    int vectSize = 0;
    //String status = "";
    if ((valid_status_select.equals("0"))){
    valid_status_select="'0'" ;
    }else if((valid_status_select.equals("1"))) {
    valid_status_select="'1'" ;
    }else{
    valid_status_select="'1' OR '2'" ;   
    }

    if (!(divisionName.equals("0"))){
        whereClause = PstDivision.fieldNames[PstDivision.FLD_DIVISION]+" LIKE '%"+divisionName+"%' AND "+PstDivision.fieldNames[PstDivision.FLD_VALID_STATUS] +" LIKE "+valid_status_select+"";
        order = PstDivision.fieldNames[PstDivision.FLD_DIVISION];
        vectSize = PstDivision.getCount(whereClause);
        listDivision = PstDivision.list(0, 0, whereClause, order);        
    } else {
        
        whereClause = PstDivision.fieldNames[PstDivision.FLD_VALID_STATUS] +" LIKE "+valid_status_select+"";
        vectSize = PstDivision.getCount("");
        order = PstDivision.fieldNames[PstDivision.FLD_DIVISION];
        listDivision = PstDivision.list(start, recordToGet, whereClause, order);
    }

    
    if (listDivision != null && listDivision.size()>0){
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
            <td class="title_tbl" style="background-color: #DDD;">No</td>
            <td class="title_tbl" style="background-color: #DDD;"><%=dictionaryD.getWord(I_Dictionary.COMPANY)%></td>
            <td class="title_tbl" style="background-color: #DDD;"><%=dictionaryD.getWord(I_Dictionary.DIVISION)%></td>
            <td class="title_tbl" style="background-color: #DDD;"><%=dictionaryD.getWord(I_Dictionary.DESCRIPTION)%></td>
            <td class="title_tbl" style="background-color: #DDD;"><%=dictionaryD.getWord(I_Dictionary.TYPE)%></td>
            <td class="title_tbl" style="background-color: #DDD;">Tanda Tangan oleh</td>
            <td class="title_tbl" style="background-color: #DDD;">Valid Status</td>
        </tr>
        <%
        for (int i = 0; i < listDivision.size(); i++) {
            Division division = (Division) listDivision.get(i);
            Company company = new Company();
            try {
                company = PstCompany.fetchExc(division.getCompanyId());
            } catch (Exception e) {
                System.out.println("e=>"+e.toString());
            }
            DivisionType divType = new DivisionType();
            String divisionTypeName = "-";
            try {
                divType = PstDivisionType.fetchExc(division.getDivisionTypeId());
                divisionTypeName = divType.getTypeName();
            } catch (Exception e){
                //System.out.print("getDivisionType=>"+e.toString());//
            }
            %>
            <tr>
                <td><%=(i+1)%></td>
                <td><%=company.getCompany()%></td>
                <td><%=division.getDivision()%></td>
                <td><%=division.getDescription()%></td>
                <td><%=divisionTypeName%></td>
                <td><%= changeValue.getEmployeeName(division.getEmployeeId()) %></td>
                <td><%= PstDivision.validStatusValue[division.getValidStatus()] %></td>
               
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
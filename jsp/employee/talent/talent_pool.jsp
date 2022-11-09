<%-- 
    Document   : talent_pool
    Created on : Oct 4, 2016, 4:51:27 PM
    Author     : Dimata 007
--%>
<%@page import="com.dimata.harisma.entity.log.ChangeValue"%>
<%@ include file = "../../main/javainit.jsp" %>
<% int  appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_MENU_COMPETENCY, AppObjInfo.G2_MENU_TALENT_POOL, AppObjInfo.OBJ_MENU_TALENT_POOL); %>
<%@ include file = "../../main/checkuser.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    int iCommand = FRMQueryString.requestCommand(request);
    String empNum = FRMQueryString.requestString(request, "emp_num");
    String empName = FRMQueryString.requestString(request, "emp_name");
    long frmCompany = FRMQueryString.requestLong(request, "frm_company");
    long frmDivision = FRMQueryString.requestLong(request, "frm_division");
    long frmDepartment = FRMQueryString.requestLong(request, "frm_department");
    long frmSection = FRMQueryString.requestLong(request, "frm_section");
    ChangeValue changeValue = new ChangeValue();
    String whereClause = "";
    Vector whereVect = new Vector();
    Vector employeeList = new Vector();
    if (iCommand == Command.SEARCH){
        if (empNum.length()>0){
            whereClause = PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_NUM]+" LIKE '%"+empNum+"%'"; 
            whereVect.add(whereClause);
        }
        if (empName.length()>0){
            whereClause = PstEmployee.fieldNames[PstEmployee.FLD_FULL_NAME]+" LIKE '%"+empName+"%'";
            whereVect.add(whereClause);
        }
        if (frmCompany != 0){
            whereClause = PstEmployee.fieldNames[PstEmployee.FLD_COMPANY_ID]+"="+frmCompany;
            whereVect.add(whereClause);
        }
        if (frmDivision != 0){
            whereClause = PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID]+"="+frmDivision;
            whereVect.add(whereClause);
        }
        if (frmDepartment != 0){
            whereClause = PstEmployee.fieldNames[PstEmployee.FLD_DEPARTMENT_ID]+"="+frmDepartment;
            whereVect.add(whereClause);
        }
        if (frmSection != 0){
            whereClause = PstEmployee.fieldNames[PstEmployee.FLD_SECTION_ID]+"="+frmSection;
            whereVect.add(whereClause);
        }
        if (whereVect != null && whereVect.size()>0){
            whereClause = "";
            for (int i=0; i<whereVect.size(); i++){
                String data = (String)whereVect.get(i);
                whereClause = whereClause + data;
                if (i == whereVect.size()-1){
                    whereClause = whereClause + " ";
                } else {
                    whereClause = whereClause + " AND ";
                }
            }
        }
        employeeList = PstEmpTalentPool.listJoin(0, 0, whereClause, "");
    }
    
    String strUrl = "";
    strUrl  = "'0',";
    strUrl += "'0',";
    strUrl += "'0',";
    strUrl += "'0',";
    strUrl += "'frm_company',";
    strUrl += "'frm_division',";
    strUrl += "'frm_department',";
    strUrl += "'frm_section'";
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Talent Pool</title>
        <link rel="stylesheet" href="../../styles/main.css" type="text/css">
        <style type="text/css">
            body {
                font-family: sans-serif;
                font-size: 12px;
                color: #474747;
                background-color: #EEE;
                padding: 21px;
            }
            .box {
                background-color: #FFF;
                border: 1px solid #DDD;
                border-radius: 3px;
            }
            #judul {
                padding: 12px 0px;
                border-bottom: 1px solid #DDD;
            }
            #isi{
                padding: 12px 14px;
            }

            .title_tbl {
                font-weight: bold;
                padding-right: 11px;
                background-color: #DDD;
            }
            .title {
                background-color: #FFF;
                border-left: 1px solid #007592;
                padding: 11px;
            }
            .tbl-style {border-collapse: collapse; font-size: 12px;}
            .tbl-style td {padding: 7px 9px; border: 1px solid #CCC; font-size: 12px;}
            .tblStyle {border-collapse: collapse; font-size: 12px; background-color: #FFF;}
            .tblStyle td {padding: 7px 9px; border: 1px solid #CCC; font-size: 12px; }
            .btn {
                background-color: #00a1ec;
                border-radius: 3px;
                font-family: Arial;
                color: #EEE;
                font-size: 12px;
                padding: 7px 11px 7px 11px;
                text-decoration: none;
            }

            .btn:hover {
                color: #FFF;
                background-color: #007fba;
                text-decoration: none;
            }
            .btn-small {
                font-weight: bold;
                font-family: sans-serif;
                text-decoration: none;
                padding: 5px 9px; 
                background-color: #FFF; color: #575757; 
                font-size: 11px; cursor: pointer;
                border-radius: 3px;
                border:1px solid #DDD;
                margin: 5px 0px;
            }
            .btn-small:hover { background-color: #D5D5D5; color: #474747; border:1px solid #CCC;}
            .content-main {
                padding: 21px 11px;
                margin: 0px 23px 59px 23px;
            }
            #browse {
                background-color: #DDD;
                color:#575757;
                font-weight: bold;
                padding: 5px 7px;
                border-radius: 3px;
                margin: 1px 0px;
                cursor: pointer;
            }
            #item {
                background-color: #DDD;
                color:#575757;
                font-weight: bold;
                padding: 5px 7px;
                border-radius: 3px;
                margin: 1px 0px;
            }
            #close {
                background-color: #EB9898;
                color: #B83916;
                font-weight: bold;
                padding: 5px 7px;
                border-radius: 3px;
                cursor: pointer;
                margin: 1px 5px 1px 2px;
            }
            #menu_utama {padding: 9px 14px; border-left: 1px solid #0099FF; font-size: 14px; background-color: #F3F3F3;}
            #menu_title {color:#0099FF; font-size: 14px;}
            .caption {
                font-size: 12px;
                color: #474747;
                font-weight: bold;
                padding: 2px 0px 3px 0px;
            }
            .divinput {
                margin-bottom: 5px;
                padding-bottom: 5px;
            }
        </style>
        <script type="text/javascript">
function loadCompany(
    pCompanyId, pDivisionId, pDepartmentId, pSectionId,
    frmCompany, frmDivision, frmDepartment, frmSection
) {
    var strUrl = "";
    if (pCompanyId.length == 0) { 
        document.getElementById("div_result").innerHTML = "";
        return;
    } else {
        var xmlhttp = new XMLHttpRequest();
        xmlhttp.onreadystatechange = function() {
            if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                document.getElementById("div_result").innerHTML = xmlhttp.responseText;
            }
        };
        strUrl = "company_structure.jsp";
        strUrl += "?p_company_id="+pCompanyId;
        strUrl += "&p_division_id="+pDivisionId;
        strUrl += "&p_department_id="+pDepartmentId;
        strUrl += "&p_section_id="+pSectionId;
        
        strUrl += "&frm_company="+frmCompany;
        strUrl += "&frm_division="+frmDivision;
        strUrl += "&frm_department="+frmDepartment;
        strUrl += "&frm_section="+frmSection;
        xmlhttp.open("GET", strUrl, true);
        xmlhttp.send();
    }
}
    
function loadDivision(
    companyId, frmCompany, frmDivision, frmDepartment, frmSection
) {
    var strUrl = "";
    if (companyId.length == 0) { 
        document.getElementById("div_result").innerHTML = "";
        return;
    } else {
        var xmlhttp = new XMLHttpRequest();
        xmlhttp.onreadystatechange = function() {
            if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                document.getElementById("div_result").innerHTML = xmlhttp.responseText;
            }
        };
        strUrl = "company_structure.jsp";

        strUrl += "?company_id="+companyId;

        strUrl += "&frm_company="+frmCompany;
        strUrl += "&frm_division="+frmDivision;
        strUrl += "&frm_department="+frmDepartment;
        strUrl += "&frm_section="+frmSection;
        xmlhttp.open("GET", strUrl, true);

        xmlhttp.send();
    }
}
    
function loadDepartment(
    companyId, divisionId, frmCompany, 
    frmDivision, frmDepartment, frmSection
) {
    var strUrl = "";
    if ((companyId.length == 0)&&(divisionId.length == 0)) { 
        document.getElementById("div_result").innerHTML = "";
        return;
    } else {
        var xmlhttp = new XMLHttpRequest();
        xmlhttp.onreadystatechange = function() {
            if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                document.getElementById("div_result").innerHTML = xmlhttp.responseText;
            }
        };
        strUrl = "company_structure.jsp";
       
        strUrl += "?company_id="+companyId;
        strUrl += "&division_id="+divisionId;
        
        strUrl += "&frm_company="+frmCompany;
        strUrl += "&frm_division="+frmDivision;
        strUrl += "&frm_department="+frmDepartment;
        strUrl += "&frm_section="+frmSection;
        xmlhttp.open("GET", strUrl, true);
        xmlhttp.send();
    }
}
    
function loadSection(
    companyId, divisionId, departmentId,
    frmCompany, frmDivision, frmDepartment, frmSection
) {
    var strUrl = "";
    if ((companyId.length == 0)&&(divisionId.length == 0)&&(departmentId.length == 0)) { 
        document.getElementById("div_result").innerHTML = "";
        return;
    } else {
        var xmlhttp = new XMLHttpRequest();
        xmlhttp.onreadystatechange = function() {
            if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                document.getElementById("div_result").innerHTML = xmlhttp.responseText;
            }
        };
        strUrl = "company_structure.jsp";
       
        strUrl += "?company_id="+companyId;
        strUrl += "&division_id="+divisionId;
        strUrl += "&department_id="+departmentId;
        
        strUrl += "&frm_company="+frmCompany;
        strUrl += "&frm_division="+frmDivision;
        strUrl += "&frm_department="+frmDepartment;
        strUrl += "&frm_section="+frmSection;
        xmlhttp.open("GET", strUrl, true);
        xmlhttp.send();
    }
}

function pageLoad(){ 
    loadCompany(<%=strUrl%>);
} 

function cmdSearch(){
    document.frm.command.value="<%= Command.SEARCH %>";
    document.frm.action="";
    document.frm.submit();
}

function cmdViewDetail(oidEmp, oidPosition){
    document.frm.employee_id.value=oidEmp;
    document.frm.position_id.value=oidPosition;
    document.frm.action="info_detail.jsp";
    document.frm.target="_blank";
    document.frm.submit();
}
        </script>
    </head>
    <body onload="pageLoad()">
        <div class="header">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <%if (headerStyle && !verTemplate.equalsIgnoreCase("0")) {%> 
            <%@include file="../../styletemplate/template_header.jsp" %>
            <%} else {%>
            <tr> 
                <td ID="TOPTITLE" background="<%=approot%>/images/HRIS_HeaderBg3.jpg" width="100%" height="54"> 
                    <!-- #BeginEditable "header" --> 
                    <%@ include file = "../../main/header.jsp" %>
                    <!-- #EndEditable --> 
                </td>
            </tr>
            <tr> 
                <td  bgcolor="#9BC1FF" height="15" ID="MAINMENU" valign="middle"> <!-- #BeginEditable "menumain" --> 
                    <%@ include file = "../../main/mnmain.jsp" %>
                    <!-- #EndEditable --> </td>
            </tr>
            <tr> 
                <td  bgcolor="#9BC1FF" height="10" valign="middle"> 
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr> 
                            <td align="left"><img src="<%=approot%>/images/harismaMenuLeft1.jpg" width="8" height="8"></td>
                            <td align="center" background="<%=approot%>/images/harismaMenuLine1.jpg" width="100%"><img src="<%=approot%>/images/harismaMenuLine1.jpg" width="8" height="8"></td>
                            <td align="right"><img src="<%=approot%>/images/harismaMenuRight1.jpg" width="8" height="8"></td>
                        </tr>
                    </table>
                </td>
            </tr>
            <%}%>
            </table>
        </div>
        <div id="menu_utama">
            <span id="menu_title"><strong>Talent Pool</strong> <strong style="color:#333;"> / </strong>Pencarian</span>
        </div>
        <div class="content-main">
            <form name="frm" method ="post" action="">
                <input type="hidden" name="command" value="" />
                <input type="hidden" name="employee_id" value="" />
                <input type="hidden" name="position_id" value="" />
                <table>
                    <tr>
                        <td style="padding-right: 32px;" valign="top">
                            <div id="div_result"></div>
                        </td>
                        <td valign="top">
                            <div class="caption">NRK</div>
                            <div class="divinput"><input type="text" name="emp_num" /></div>
                            <div class="caption">Nama</div>
                            <div class="divinput"><input type="text" name="emp_name" size="50" /></div>
                        </td>
                    </tr>
                </table>

                <div>&nbsp;</div>
                <a href="javascript:cmdSearch()" style="color:#FFF;" class="btn">Cari</a>
                <div>&nbsp;</div>
            </form>
            <div>&nbsp;</div>

            <%
            if (employeeList != null && employeeList.size()>0){
                %>
                <div class="title">Daftar Talent Pool</div>
                <div>&nbsp;</div>
                <table class="tblStyle">
                    <tr>
                        <td class="title_tbl">No</td>
                        <td class="title_tbl">NRK</td>
                        <td class="title_tbl">Nama</td>
                        <td class="title_tbl">Satuan Kerja</td>
                        <td class="title_tbl">Unit</td>
                        <td class="title_tbl">Sub Unit</td>
                        <td class="title_tbl">View Detail</td>
                    </tr>
                
                <%
                for (int i=0; i<employeeList.size(); i++){
                    Employee emp = (Employee)employeeList.get(i);
                    %>
                    <tr>
                        <td><%= (i+1) %></td>
                        <td><%= emp.getEmployeeNum() %></td>
                        <td><%= emp.getFullName() %></td>
                        <td><%= changeValue.getDivisionName(emp.getDivisionId()) %></td>
                        <td><%= changeValue.getDepartmentName(emp.getDepartmentId()) %></td>
                        <td><%= changeValue.getSectionName(emp.getSectionId()) %></td>
                        <td><a href="javascript:cmdViewDetail('<%= emp.getOID() %>','<%= emp.getPositionId() %>')">Detail</a></td>
                    </tr>
                    <%
                }
                %>
                </table>
                <%
            }
            %>
        </div>
        <div class="footer-page">
            <table>
                <%if (headerStyle && !verTemplate.equalsIgnoreCase("0")) {%>
                <tr>
                    <td valign="bottom"><%@include file="../../footer.jsp" %></td>
                </tr>
                <%} else {%>
                <tr> 
                    <td colspan="2" height="20" ><%@ include file = "../../main/footer.jsp" %></td>
                </tr>
                <%}%>
            </table>
        </div>
    </body>
</html>

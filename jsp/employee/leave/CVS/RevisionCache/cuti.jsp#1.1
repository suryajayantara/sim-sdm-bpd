<%-- 
    Document   : cuti
    Created on : Feb 1, 2017, 7:39:29 PM
    Author     : mchen
--%>
<%@ include file = "../../main/javainit.jsp" %>
<%  int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_EMPLOYEE, AppObjInfo.G2_LEAVE_APPLICATION, AppObjInfo.OBJ_LEAVE_APPLICATION);%>
<%@ include file = "../../main/checkuser.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
    long oidEmpDoc = FRMQueryString.requestLong(request,"oid_emp_doc");
    String objectName = FRMQueryString.requestString(request,"object_name");
    String[] empCheck = FRMQueryString.requestStringValues(request, "emp_check");
   
    
    /* Check Administrator */
    long empCompanyId = 0;
    long empDivisionId = 0;
    if (appUserSess.getAdminStatus()==0){
        empCompanyId = emplx.getCompanyId();
        empDivisionId = emplx.getDivisionId();
    }
    String strUrl = "";
    strUrl  = "'"+empCompanyId+"',";
    strUrl += "'"+empDivisionId+"',";
    strUrl += "'0',";
    strUrl += "'0',";
    strUrl += "'frm_company_id',";
    strUrl += "'frm_division_id',";
    strUrl += "'frm_department_id',";
    strUrl += "'frm_section_id'";
              
    
    String whereClause = "";
    String order = "";
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Leave Application</title>
        <link rel="stylesheet" href="../../styles/main.css" type="text/css">
        <style type="text/css">
            .tblStyle {border-collapse: collapse; font-size: 12px; }
            .tblStyle td {padding: 5px 7px; border: 1px solid #CCC; font-size: 12px;}
            .title_tbl {font-weight: bold;background-color: #EEE; color: #575757;}
            .title_page {color:#0db2e1; font-weight: bold; font-size: 14px; background-color: #EEE; border-left: 1px solid #0099FF; padding: 12px 18px;}

            .tblStyleNoBorder {font-size: 12px; }
            .tblStyleNoBorder td {padding: 5px 7px; font-size: 12px; }
            
            body {color:#373737;}
            #menu_utama {padding: 9px 14px; border-left: 1px solid #0099FF; font-size: 14px; background-color: #F3F3F3;}
            #menu_title {color:#0099FF; font-size: 14px;}
            #menu_teks {color:#CCC;}

            .title_part {color:#FF7E00; background-color: #F7F7F7; border-left: 1px solid #0099FF; padding: 9px 11px;}
            
            body {background-color: #EEE;}
            .header {
                
            }
            .content-main {
                padding: 21px 11px;
                margin: 0px 23px 59px 23px;
            }
            .content-info {
                padding: 21px;
                border-bottom: 1px solid #E5E5E5;
            }
            .content-title {
                padding: 21px;
                border-bottom: 1px solid #E5E5E5;
                margin-bottom: 5px;
            }

            .content {
                padding: 21px;
            }
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
            
            .btn-green {
                background-color: #ace600;
                border-radius: 3px;
                font-family: Arial;
                color: #EEE;
                font-size: 12px;
                padding: 7px 11px 7px 11px;
                text-decoration: none;
            }

            .btn-green:hover {
                color: #FFF;
                background-color: #86b300;
                text-decoration: none;
            }
            
            .btn-red {
                background-color: #ff9999;
                border-radius: 3px;
                font-family: Arial;
                color: #EEE;
                font-size: 12px;
                padding: 7px 11px 7px 11px;
                text-decoration: none;
            }

            .btn-red:hover {
                color: #FFF;
                background-color: #ff6666;
                text-decoration: none;
            }
            
            .btn-grey {
                background-color: #C5C5C5;
                border-radius: 3px;
                font-family: Arial;
                color: #EEE;
                font-size: 12px;
                padding: 7px 11px 7px 11px;
                text-decoration: none;
            }

            .btn-grey:hover {
                color: #FFF;
                background-color: #B7B7B7;
                text-decoration: none;
            }
            
            .btn-small {
                font-family: sans-serif;
                text-decoration: none;
                padding: 5px 7px; 
                background-color: #676767; color: #F5F5F5; 
                font-size: 11px; cursor: pointer;
                border-radius: 3px;
            }
            .btn-small:hover { background-color: #474747; color: #FFF;}
            
            .btn-small-1 {
                font-family: sans-serif;
                text-decoration: none;
                padding: 5px 7px; 
                background-color: #EEE; color: #575757; 
                font-size: 11px; cursor: pointer;
                border-radius: 3px;
            }
            .btn-small-1:hover { background-color: #DDD; color: #474747;}
            
            .tbl-main {border-collapse: collapse; font-size: 11px; background-color: #FFF; margin: 0px;}
            .tbl-main td {padding: 4px 7px; border: 1px solid #DDD; }
            #tbl-title {font-weight: bold; background-color: #F5F5F5; color: #575757;}
            
            .tbl-small {border-collapse: collapse; font-size: 11px; background-color: #FFF;}
            .tbl-small td {padding: 2px 3px; border: 1px solid #DDD; }
            
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
            
            .mydate {
                font-weight: bold;
                color: #474747;
            }

            #confirm {
                padding: 5px 7px;
                background-color: #FF6666;
                color: #FFF;
                border-radius: 3px;
                font-size: 12px;
                font-weight: bold;
                margin-bottom: 5px;
            }
            #btn-confirm {
                padding: 3px 5px; border-radius: 2px;
                background-color: #CF5353; color: #FFF; 
                font-size: 11px; cursor: pointer;
            }
            .footer-page {
                font-size: 12px; 
            }
            h2 {
                padding: 0px 0px 21px 0px;
                margin: 0px 0px 21px 0px;
                border-bottom: 1px solid #DDD;
            }
            .box {
                border: 1px solid #DDD;
                background-color: #f5f5f5;
                margin: 5px 0px;
            }
            #box-title {
                font-size: 14px;
                font-weight: bold;
                color: #007fba;
                padding-bottom: 15px;
            }
            #box-content {
                color: #575757;
                padding: 14px 19px;
            }
            
            #caption, .caption {
                font-size: 12px;
                color: #474747;
                font-weight: bold;
                padding: 2px 0px 3px 0px;
            }
            #divinput, .divinput {
                margin-bottom: 5px;
                padding-bottom: 5px;
            }
            .item {
                background-color: #FFF;
                padding: 9px;
                margin: 9px 15px;
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
    var strUrl = "";
    var empNum = document.getElementById("emp_num").value;
    var empName = document.getElementById("emp_name").value;
    var comp = document.getElementById("company").value;
    var divi = document.getElementById("division").value;
    var dept = document.getElementById("department").value;
    var sect = document.getElementById("section").value;
    var posi = document.getElementById("position").value;
    var cate = document.getElementById("category").value;
    
    var oidEmpDoc = document.getElementById("oid_emp_doc").value;
    var objName = document.getElementById("object_name").value;
    
    if (empNum.length == 0){
        empNum = "0";
    }
    if (empName.length == 0){
        empName = "0";
    }
    
    var xmlhttp = new XMLHttpRequest();
    xmlhttp.onreadystatechange = function() {
        if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
            document.getElementById("div_list").innerHTML = xmlhttp.responseText;
        }
    };
    strUrl = "list_employee.jsp";
    strUrl += "?company="+comp;
    strUrl += "&division="+divi;
    strUrl += "&department="+dept;
    strUrl += "&section="+sect;

    strUrl += "&position="+posi;
    strUrl += "&category="+cate;
    strUrl += "&emp_num="+empNum;
    strUrl += "&emp_name="+empName;
    
    strUrl += "&oid_emp_doc="+oidEmpDoc;
    strUrl += "&object_name="+objName;
    
    xmlhttp.open("GET", strUrl, true);
    xmlhttp.send();
}
function check() {
    document.getElementsByClassName("myC").checked = true;
}

function uncheck() {
    document.getElementById("myCheck").checked = false;
}
function cmdGet(oid, empNum, fullname, diviName, deptName, sectName, postName){
    document.frm.employee_id.value = oid;
    document.frm.emp_num.value = empNum;
    document.frm.emp_name.value = fullname;
    document.frm.emp_division.value = diviName;
    document.frm.emp_dept.value = deptName;
    document.frm.emp_sect.value = sectName;
    document.frm.emp_post.value = postName;
    document.frm.command.value="<%= Command.VIEW %>";
    document.frm.action="leave_app_form.jsp";
    document.frm.submit();
}

function cmdGoToList(empId){
    document.frm.employee_id.value=empId;
    document.frm.halaman.value="cuti";
    document.frm.action="leave_list_emp.jsp";
    document.frm.submit();
}

function cmdGoApprove(){
    document.frm.action="leave_approve.jsp";
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
            <span id="menu_title">Pengajuan Cuti</span>
        </div>
        <div class="content-main">
            <form name="frm" method="post" action="">
                <!-- input pendukung -->
                <input type="hidden" name="command" value=""> 
                <input type="hidden" name="employee_id" value="" />
                <input type="hidden" name="emp_division" value="">
                <input type="hidden" name="emp_dept" value="">
                <input type="hidden" name="emp_sect" value="">
                <input type="hidden" name="emp_post" value="">
                <input type="hidden" id="oid_emp_doc" value="<%= oidEmpDoc %>" />
                <input type="hidden" id="object_name" value="<%= objectName %>" />
                <input type="hidden" name="halaman" value="">
                <table width="100%">
                    <tr>
                        <td valign="top" width="50%">
                            <div id="caption">Emp.Num</div>
                            <div id="divinput">
                                <input type="text" id="emp_num" name="emp_num" value="" size="50" />
                            </div>

                            <div id="caption">Nama</div>
                            <div id="divinput">
                                <input type="text" id="emp_name" name="emp_name" value="" size="50" />
                            </div>

                            <div id="div_result"></div>

                            <div id="caption">Jabatan</div>
                            <div id="divinput">
                                <select id="position" name="position">
                                    <option value="0">-select-</option>
                                    <%
                                    whereClause = PstPosition.fieldNames[PstPosition.FLD_VALID_STATUS]+"=";
                                    whereClause += PstPosition.VALID_ACTIVE;
                                    order = PstPosition.fieldNames[PstPosition.FLD_POSITION];
                                    Vector listPosition = PstPosition.list(0, 0, whereClause, order);
                                    if (listPosition != null && listPosition.size()>0){
                                        for(int i=0; i<listPosition.size(); i++){
                                            Position jabatan = (Position)listPosition.get(i);
                                            %>
                                            <option value="<%= jabatan.getOID() %>"><%= jabatan.getPosition() %></option>
                                            <%
                                        }
                                    }
                                    %>
                                </select>
                            </div>

                            <div id="caption">Kategori</div>
                            <div id="divinput">
                                <select id="category" name="category">
                                    <option value="0">-select-</option>
                                    <%
                                    Vector listCategory = PstEmpCategory.list(0, 0, "", "");
                                    if (listCategory != null && listCategory.size()>0){
                                        for(int i=0; i<listCategory.size(); i++){
                                            EmpCategory category = (EmpCategory)listCategory.get(i);
                                            %>
                                            <option value="<%= category.getOID() %>"><%= category.getEmpCategory() %></option>
                                            <%
                                        }
                                    }
                                    %>
                                </select>
                            </div>
                            <div>&nbsp;</div>
                            <a class="btn" style="color:#FFF" href="javascript:cmdSearch()">Search</a>
                        </td>
                        <td valign="top" width="50">
                            <div id="div_list"></div>
                        </td>
                    </tr>
                </table>
            </form>
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

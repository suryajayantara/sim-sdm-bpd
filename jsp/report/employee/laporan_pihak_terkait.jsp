<%-- 
    Document   : laporan_pihak_terkait
    Created on : Nov 2, 2016, 3:58:36 PM
    Author     : Dimata 007
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file = "../../main/javainit.jsp" %>
<%!
    public String getPositionName(long posId) {
        String position = "-";
        Position pos = new Position();
        try {
            pos = PstPosition.fetchExc(posId);
            position = pos.getPosition();
        } catch (Exception ex) {
            System.out.println("getPositionName ==> " + ex.toString());
        }
        return position;
    }
%>
<%
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
    
    int iCommand = FRMQueryString.requestCommand(request);
    String fldNrk = FRMQueryString.requestString(request, "field_nrk");
    String fldName = FRMQueryString.requestString(request, "field_name");
    long companyId = FRMQueryString.requestLong(request, "frm_company_id");
    long divisionId = FRMQueryString.requestLong(request, "frm_division_id");
    long departmentId  = FRMQueryString.requestLong(request, "frm_department_id");
    long sectionId = FRMQueryString.requestLong(request, "frm_section_id");
    String whereClause = "";
    Vector employeeList = new Vector();
    
    if (iCommand == Command.SEARCH){
        Vector whereVect = new Vector();
        
        if (fldNrk.length()>0){
            whereClause = PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_NUM]+"='"+fldNrk+"'";
            whereVect.add(whereClause);
        }
        if (fldName.length()>0){
            whereClause = PstEmployee.fieldNames[PstEmployee.FLD_FULL_NAME]+"='"+fldName+"'";
            whereVect.add(whereClause);
        }
        if (companyId != 0){
            whereClause = PstEmployee.fieldNames[PstEmployee.FLD_COMPANY_ID]+"="+companyId;
            whereVect.add(whereClause);
        }
        if (divisionId != 0){
            whereClause = PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID]+"="+divisionId;
            whereVect.add(whereClause);
        }
        if (departmentId != 0){
            whereClause = PstEmployee.fieldNames[PstEmployee.FLD_DEPARTMENT_ID]+"="+departmentId;
            whereVect.add(whereClause);
        }
        if (sectionId != 0){
            whereClause = PstEmployee.fieldNames[PstEmployee.FLD_SECTION_ID]+"="+sectionId;
            whereVect.add(whereClause);
        }
        
        whereClause = "";
        if (whereVect != null && whereVect.size()>0){
            for (int i=0; i<whereVect.size(); i++){
                String where = (String)whereVect.get(i);
                whereClause += where;
                if (i == (whereVect.size()-1)){
                    whereClause += " ";
                } else {
                    whereClause += " AND ";
                }
            }
        }
        
        employeeList = PstEmployee.list(0, 0, whereClause, PstEmployee.fieldNames[PstEmployee.FLD_FULL_NAME]);
    }
    
    String[] dataChar = {
        "a",
        "b",
        "c",
        "d",
        "e",
        "f",
        "g"
    };
    
    session.putValue("listPihakTerkait", employeeList);
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link rel="stylesheet" href="../../styles/main.css" type="text/css">
        <style type="text/css">
            .tblStyle {border-collapse: collapse; font-size: 12px; }
            .tblStyle td {padding: 5px 7px; border: 1px solid #CCC; font-size: 12px; background-color: #FFF;}
            .title_tbl {font-weight: bold;background-color: #DDD; color: #575757;}
            .title_page {color:#0db2e1; font-weight: bold; font-size: 14px; background-color: #EEE; border-left: 1px solid #0099FF; padding: 12px 18px;}

            body {color:#373737;}
            #menu_utama {padding: 9px 14px; border-left: 1px solid #0099FF; font-size: 14px; background-color: #F3F3F3;}
            #menu_title {color:#0099FF; font-size: 14px;}
            #menu_teks {color:#CCC;}
            
            #btn {
              background: #3498db;
              border: 1px solid #0066CC;
              border-radius: 3px;
              font-family: Arial;
              color: #ffffff;
              font-size: 12px;
              padding: 3px 9px 3px 9px;
            }

            #btn:hover {
              background: #3cb0fd;
              border: 1px solid #3498db;
            }
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
            #title-large {
                color: #575757;
                font-size: 16px;
                font-weight: bold;
            }
            #title-small {
                color:#797979;
                font-size: 11px;
            }
            .content {
                padding: 21px;
            }
            #box_title {
                padding:21px; 
                font-size: 14px; 
                color: #007fba;
                border-top: 1px solid #28A7D1;
                border-bottom: 1px solid #EEE;
            }
            #box_content {
                padding:21px; 
                font-size: 12px;
                color: #575757;
            }
            .box-info {
                padding:21px 43px; 
                background-color: #F7F7F7;
                border-bottom: 1px solid #CCC;
                -webkit-box-shadow: 0 1px 4px rgba(0, 0, 0, 0.065);
                 -moz-box-shadow: 0 1px 4px rgba(0, 0, 0, 0.065);
                      box-shadow: 0 1px 4px rgba(0, 0, 0, 0.065);
            }
            #box-item {
                font-weight: bold;
                margin: 3px 0px;
                padding: 5px 9px;
                color: #575757;
                background-color: #EEE;
                border:1px solid #DDD;
                border-right: none;
            }
            #box-times {
                font-weight: bold;
                margin: 3px 0px;
                padding: 5px 9px;
                color: #B09595;
                background-color: #EEE;
                border:1px solid #DDD;
                cursor: pointer;
            }
            #box-times:hover {
                font-weight: bold;
                margin: 3px 0px;
                padding: 5px 9px;
                color: #B09595;
                background-color: #FFD9D9;
                border:1px solid #D9B8B8;
            }
            #title-info-name {
                padding: 11px 15px;
                font-size: 35px;
                color: #535353;
            }
            #title-info-desc {
                padding: 7px 15px;
                font-size: 21px;
                color: #676767;
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
            
            #level_select {
                margin-bottom: 5px;
                padding-bottom: 5px;
                visibility: hidden;
            }
            
            #category_select {
                margin-bottom: 5px;
                padding-bottom: 5px;
                visibility: hidden;
            }
            
            #position_select {
                margin-bottom: 5px;
                padding-bottom: 5px;
                visibility: hidden;
            }
            
            #div_item_sch {
                background-color: #EEE;
                color: #575757;
                padding: 5px 7px;
            }
            
            #record_count{
                font-size: 12px;
                font-weight: bold;
                padding-bottom: 9px;
            }
            #box-form {
                background-color: #EEE; 
                border-radius: 5px;
            }
            .form-style {
                font-size: 12px;
                color: #575757;
                border: 1px solid #DDD;
                border-radius: 5px;
            }
            .form-title {
                padding: 11px 21px;
                text-align: left;
                border-bottom: 1px solid #DDD;
                background-color: #FFF;
                border-top-left-radius: 5px;
                border-top-right-radius: 5px;
                font-weight: bold;
            }
            .form-content {
                text-align: left;
                padding: 21px;
                background-color: #DDD;
            }
            .form-footer {
                border-top: 1px solid #DDD;
                padding: 11px 21px;
                background-color: #FFF;
                border-bottom-left-radius: 5px;
                border-bottom-right-radius: 5px;
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
                padding: 7px 0px 21px 0px;
                margin: 0px 0px 21px 0px;
                border-bottom: 1px solid #DDD;
            }
            .box {
                border: 1px solid #DDD;
                background-color: #f5f5f5;
                margin: 5px 0px;
            }
            #box-title {
                padding: 14px 19px;
                font-size: 13px;
                font-weight: bold;
                color: #007fba;
                border-bottom: 1px solid #ddd;
                background-color: #FFF;
            }
            #box-content {
                color: #575757;
                padding: 14px 19px;
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
    document.frm.action=""; 
    document.frm.command.value="<%= Command.SEARCH %>";
    document.frm.submit();
}

function cmdExportExcel(){
    document.frm.action="<%=approot%>/report/employee/export_excel/laporan_pihak_terkait_xls.jsp"; 
    document.frm.command.value="<%= Command.SEARCH %>";
    document.frm.target = "ReportExcel";
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
            <span id="menu_title">Laporan <strong style="color:#333;"> / </strong>Pihak Terkait</span>
        </div>
        <div class="content-main">
            <form name="frm" method="post" action="">
                <input type="hidden" name="command" value="" />
                <div class="caption">NRK</div>
                <div class="divinput">
                    <input type="text" name="field_nrk" value="" />
                </div>
                <div class="caption">Nama</div>
                <div class="divinput">
                    <input type="text" name="field_name" value="" size="50" />
                </div>
                <div id="div_result"></div>
                <div>&nbsp;</div>
                <a href="javascript:cmdSearch()" class="btn" style="color:#FFF;">Search</a>
                <a class="btn" style="color:#FFF;" href="javascript:cmdExportExcel()">Go To Export</a>
                <div>&nbsp;</div>
            </form>
            <div>&nbsp;</div>
            <div style="border-bottom: 1px solid #CCC;">&nbsp;</div>
            <div>&nbsp;</div>
            <%
            if (iCommand == Command.SEARCH){
            %>
            
            <center><h2>Daftar Rincian Pihak Terkait</h2></center>
            <table class="tblStyle">
                <tr valign="top" style="text-align: center; font-size: 12px"> <!--font 9 on excel-->
                    <td rowspan="3">
                        <strong>No.</strong>
                    </td>
                    <td rowspan="3">
                        <strong>Nama Pihak Terkait</strong>
                    </td>
                    <td colspan="4">
                        <strong>Hubungan Kepemilikan Saham</strong>
                    </td>
                    <td colspan="5">
                        <strong>Hubungan Kepengurusan</strong>
                    </td>
                    <td colspan="2">
                        <strong>Hubungan Keluarga</strong>
                    </td>
                    <td>
                        <strong>Hubungan Keuangan</strong>
                    </td>
                </tr>
                <tr valign="top" style=" text-align: center;font-size: 12px">
                    <td rowspan="2">
                        <strong>Pada Bank BPD Bali %</strong>
                    </td>
                    <td colspan="3">
                        <strong>Pada Perusahaan Lainnya</strong>
                    </td>
                    <td colspan="2">
                        <strong>Jabatan Pada Bank BPD Bali</strong>
                    </td>
                    <td colspan="3">
                        <strong>Jabatan Pada Perusahaan Lainnya</strong>
                    </td>
                    <td rowspan="2">
                        <strong>Nama Keluarga</strong>
                    </td>
                    <td rowspan="2">
                        <strong>Status (*)</strong>
                    </td>
                    <td rowspan="2">
                        <strong>Pada Pihak Lain & Pihak Penjamin</strong>
                    </td>
                </tr>
                <tr valign="top" style=" text-align: center;font-size: 12px">
                    <td>
                        <strong>Nama Perusahaan</strong>
                    </td>
                    <td>
                        <strong>Sektor Usaha</strong>
                    </td>
                    <td>
                        <strong>%</strong>
                    </td>
                    <td>
                        <strong>Jabatan</strong>
                    </td>
                    <td>
                        <strong>Sejak</strong>
                    </td>
                    <td>
                        <strong>Jabatan</strong>
                    </td>
                    <td>
                        <strong>Nama Perusahaan</strong>
                    </td>
                    <td>
                        <strong>Sektor Usaha</strong>
                    </td>
                </tr>
                <%
                if (employeeList != null && employeeList.size()>0){
                    for (int i=0; i<employeeList.size(); i++){
                        Employee emp = (Employee)employeeList.get(i);
                        
                        String since = PstCareerPath.getLastWorkFrom(emp.getOID());
                %>
                <tr style=" font-size: 13px">
                    <td><%= (i+1) %></td>
                    <td><%= emp.getFullName() %></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td><%= getPositionName(emp.getPositionId()) %></td>
                    <td><%=since%></td>

                    <td>&nbsp;</td>
                    <td>&nbsp;</td>

                    <td></td>
                    <td colspan="2">
                        <%
                        whereClause = PstFamilyMember.fieldNames[PstFamilyMember.FLD_EMPLOYEE_ID]+"="+emp.getOID();
                        Vector famList = PstFamilyMember.list(0, 0, whereClause, PstFamilyMember.fieldNames[PstFamilyMember.FLD_RELATIONSHIP]);
                        if (famList != null && famList.size()>0){
                        %>
                        <table class="tblStyle">
                            <%
                            for (int j=0; j < famList.size(); j++){
                                FamilyMember fam = (FamilyMember)famList.get(j);
                                Vector listRelationX = PstFamRelation.listRelationName(0,0,fam.getRelationship(),""); 
                                FamRelation famRelation = (FamRelation) listRelationX.get(0);
                            %>
                            <tr>
                                <td><strong>(<%= dataChar[famRelation.getFamRelationType()] %>)</strong> <%= fam.getFullName() %></td>
                                <td><%= famRelation.getFamRelation() %></td>
                            </tr>
                            <% } %>
                        </table>
                        <% 
                        }                     
                        %>
                    </td>
                    <td></td>
                </tr>
                <% 
                    }
                }
                %>
            </table> 
        <p style=" font-size: 13px">
        <strong>Keterangan (*) :</strong>	<br>
        a   = Orang Tua Kandung/ Tiri/ Angkat<br>
        b   = Saudara Kandung/ Tiri/ Angkat<br>
        c   = Suami atau istri<br>
        d   = Mertua atau Besan<br>
        e   = Anak Kandung/ Tiri/ Angkat<br>
        f   = Kakek atau Nenek Kandung/ Tiri/ Angkat<br>
        g   = Cucu Kandung/ Tiri/ Angkat<br>
        h   = Saudara Kandung/ Tiri/ Angkat dari Orang Tua<br>
        i   = Suami atau Istri dari Anak Kandung/ Tiri/ Angkat<br>
        j   = Kakek atau Nenek dari Suami atau Istri<br>
        k   = Suami atau Istri dari Cucu Kandung/ Tiri/ Angkat<br>
        l   = Saudara Kandung/ Tiri/ Angkat dari Suami atau Istri Beserta Suami atau Istrinya dari Saudara yang Bersangkutan
        </p>
            <% } %>
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

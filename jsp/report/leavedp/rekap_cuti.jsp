<%-- 
    Document   : rekap_cuti
    Created on : 24-Apr-2017, 10:08:41
    Author     : Gunadi
--%>

<%@page import="java.math.RoundingMode"%>
<%@page import="java.math.BigDecimal"%>
<%@page import="com.dimata.harisma.entity.attendance.LLStockManagement"%>
<%@page import="com.dimata.harisma.entity.attendance.PstLLStockManagement"%>
<%@page import="com.dimata.harisma.entity.attendance.AlStockManagement"%>
<%@page import="com.dimata.harisma.entity.attendance.PstAlStockManagement"%>
<%@page import="java.util.Hashtable"%>
<%@page import="com.dimata.gui.jsp.ControlCombo"%>
<%@page import="com.dimata.harisma.entity.masterdata.*"%>
<%@page import="com.dimata.harisma.entity.masterdata.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file = "../../main/javainit.jsp" %>
<% int  appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_MENU_REPORTS, AppObjInfo.G2_MENU_LEAVE_REPORT, AppObjInfo.OBJ_MENU_REKAP_CUTI); %>
<%@ include file = "../../main/checkuser.jsp" %>
<%!
    public int convertInteger(double val){
        BigDecimal bDecimal = new BigDecimal(val);
        bDecimal = bDecimal.setScale(0, RoundingMode.HALF_UP);
        return bDecimal.intValue();
    }

    public String[] leaveType = {
        "Cuti Khusus", "Cuti Hamil", "Cuti Penting", "Cuti Tahunan", "Cuti Besar"
    };
%>
<%
    /* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
    //boolean privPrint = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_PRINT));

    long hrdDepOid = Long.parseLong(String.valueOf(PstSystemProperty.getPropertyLongbyName(OID_HRD_DEPARTMENT)));
    boolean isHRDLogin = true ;
    
    long edpSectionOid = Long.parseLong(String.valueOf(PstSystemProperty.getPropertyLongbyName(OID_EDP_SECTION)));
    boolean isEdpLogin = edpSectionOid == sectionOfLoginUser.getOID() ? true : false;
    boolean isGeneralManager = positionType == PstPosition.LEVEL_GENERAL_MANAGER ? true : false;
    
    SessUserSession userSessionn = (SessUserSession)session.getValue(SessUserSession.HTTP_SESSION_NAME);
    AppUser appUserSess1 = userSessionn.getAppUser();
    String namaUser1 = appUserSess1.getFullName();
    
    /* Check Administrator */
    long oidCompany = 0;
    long oidDivision = 0;
    String strDisable = "";
    String strDisableNum = "";
    if (appUserSess.getAdminStatus()==0 && !privViewAllDivision){
        oidCompany = emplx.getCompanyId();
        oidDivision = emplx.getDivisionId();
        strDisable = "disabled=\"disabled\"";
    } if (namaUser1.equals("Employee")){
        strDisableNum = "disabled=\"disabled\"";
    }

//cek tipe browser, browser detection
    //String userAgent = request.getHeader("User-Agent");
    //boolean isMSIE = (userAgent!=null && userAgent.indexOf("MSIE") !=-1); 

%>
<%
    int iCommand = FRMQueryString.requestCommand(request);
    int iErrCode = FRMMessage.NONE;
    int start = FRMQueryString.requestInt(request, "start");
    String empNum = FRMQueryString.requestString(request, "emp_number");
    String empName = FRMQueryString.requestString(request, "full_name");
    long compId = FRMQueryString.requestLong(request, "company_id");
    String[] div = FRMQueryString.requestStringValues(request, "division_id");
    String[] dept = FRMQueryString.requestStringValues(request, "department");
    String[] sec = FRMQueryString.requestStringValues(request, "section");
    
    Vector<String> whereCollect = new Vector<String>();
    String whereClause = "";
    if (!empNum.equals("")){
        whereClause = PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_NUM]+ " = "+ empNum;
        whereCollect.add(whereClause);
    }
    if (!empName.equals("")){
        whereClause = PstEmployee.fieldNames[PstEmployee.FLD_FULL_NAME]+ " LIKE '%"+ empName+"%'";
        whereCollect.add(whereClause);
    }
    if (compId > 0){
        whereClause = PstEmployee.fieldNames[PstEmployee.FLD_COMPANY_ID]+ " = "+ compId;
        whereCollect.add(whereClause);
    }
    if (div != null){
        if (div.length>0){
            String inDivision = "";
            for (int i=0; i < div.length; i++){
                inDivision += "'"+div[i]+"' ," ;
            }
            inDivision = inDivision.substring(0, inDivision.length()-1);
            whereClause = PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID]+ " IN ("+ inDivision+")";
            whereCollect.add(whereClause);
        }
    }
    if (dept != null){
        if (dept.length>0  ){
            String inDept = "";
            for (int i=0; i < dept.length; i++){
                inDept += "'"+dept[i]+"' ," ;
            }
            inDept = inDept.substring(0, inDept.length()-1);
            whereClause = PstEmployee.fieldNames[PstEmployee.FLD_DEPARTMENT_ID]+ " IN ("+ inDept+")";
            whereCollect.add(whereClause);
        }
    }
    if (sec != null){
        if (sec.length>0 ){
            String inSec = "";
            for (int i=0; i < sec.length; i++){
                inSec += "'"+sec[i]+"' ," ;
            }
            inSec = inSec.substring(0, inSec.length()-1);
            whereClause = PstEmployee.fieldNames[PstEmployee.FLD_SECTION_ID]+ " IN ("+ inSec+")";
            whereCollect.add(whereClause);
        }
    }
    
    if (whereCollect != null && whereCollect.size()>0){
        whereClause = "";
        for (int i=0; i<whereCollect.size(); i++){
            String where = (String)whereCollect.get(i);
            whereClause += where;
            if (i < (whereCollect.size()-1)){
                 whereClause += " AND ";
            }
        }
    }
    
    Vector listEmployee = PstEmployee.list(0, 0, whereClause, "");
    
    
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Rekap Cuti</title>
        <link rel="stylesheet" href="../../styles/main.css" type="text/css">
         <%@ include file = "../../main/konfigurasi_jquery.jsp" %>    
        <script src="../../javascripts/jquery.min-1.6.2.js" type="text/javascript"></script>
        <script src="../../javascripts/chosen.jquery.js" type="text/javascript"></script>
        <link rel="stylesheet" href="../../stylesheets/chosen.css" >
        <style type="text/css">
            .tblStyle {border-collapse: collapse; font-size: 12px;}
            .tblStyle td {padding: 7px 9px; border: 1px solid #CCC; font-size: 12px;}
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
            .breadcrumb {
                background-color: #EEE;
                color:#0099FF;
                padding: 7px 9px;
            }
            .navbar {
                font-family: sans-serif;
                font-size: 12px;
                background-color: #0084ff;
                padding: 7px 9px;
                color : #FFF;
                border-top:1px solid #0084ff;
                border-bottom: 1px solid #0084ff;
            }
            .navbar ul {
                list-style-type: none;
                margin: 0;
                padding: 0;
            }

            .navbar li {
                padding: 7px 9px;
                display: inline;
                cursor: pointer;
            }
            
            .navbar li a {
                color : #F5F5F5;
                text-decoration: none;
            }
            
            .navbar li a:hover {
                color:#FFF;
            }
            
            .navbar li a:active {
                color:#FFF;
            }

            .navbar li:hover {
                background-color: #0b71d0;
                border-bottom: 1px solid #033a6d;
            }

            .active {
                background-color: #0b71d0;
                border-bottom: 1px solid #033a6d;
            }
            .title_part {color:#FF7E00; background-color: #F7F7F7; border-left: 1px solid #0099FF; padding: 9px 11px;}
            
            body {background-color: #EEE;}
            .header {
                
            }
            .content-main {
                padding: 21px 32px;
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
            .box {
                margin: 17px 7px;
                background-color: #FFF;
                color:#575757;
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
            
            #photo {
                padding: 7px; 
                background-color: #FFF; 
                border: 1px solid #DDD;
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
                background-color: #EEE; color: #575757; 
                font-size: 11px; cursor: pointer;
                border-radius: 3px;
                border: 1px solid #DDD;
            }
            .btn-small:hover { background-color: #DDD; color: #474747;}
            
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
            
            #caption {
                font-size: 12px;
                color: #474747;
                font-weight: bold;
                padding: 2px 0px 3px 0px;
            }
            #divinput {
                margin-bottom: 5px;
                padding-bottom: 5px;
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
            .formstyle {
                background-color: #FFF;
                padding: 21px;
                border-radius: 3px;
                margin: 3px 0px;
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
            .btn-small-e {
                font-family: sans-serif;
                text-decoration: none;
                padding: 3px 5px; 
                background-color: #92C8E8; color: #F5F5F5; 
                font-size: 11px; cursor: pointer;
                border-radius: 3px;
            }
            .btn-small-e:hover { background-color: #659FC2; color: #FFF;}
            
            .btn-small-x {
                font-family: sans-serif;
                text-decoration: none;
                padding: 3px 5px; 
                background-color: #EB9898; color: #F5F5F5; 
                font-size: 11px; cursor: pointer;
                border-radius: 3px;
            }
            .btn-small-x:hover { background-color: #D14D4D; color: #FFF;}
            
        </style>
        <script language="JavaScript">
        function cmdSearch(){
                
                    document.frpresence.command.value="<%=String.valueOf(Command.LIST)%>";
                    document.frpresence.action="rekap_cuti.jsp";
                    document.frpresence.submit();
        }    
        function cmdExport(){
                document.frpresence.command.value="<%=String.valueOf(Command.LIST)%>";
                document.frpresence.action="export_excel/meal_allowance.jsp";
                document.frpresence.submit();
        }    
        
        function loadFilterBy(filter_by, oidDocMasterFlow) {
                var xmlhttp = new XMLHttpRequest();DEP
                xmlhttp.onreadystatechange = function() {
                    if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                        document.getElementById("div_respon").innerHTML = xmlhttp.responseText;
                    }
                };
                xmlhttp.open("GET", "doc_flow_ajax.jsp?filter_by=" + filter_by+"&oid="+oidDocMasterFlow, true);
                xmlhttp.send();
            }
            
        function loadCompany(
                pCompanyId, pDivisionId, pDepartmentId, pSectionId,
                frmCompany, frmDivision, frmDepartment, frmSection
            ) {
                var strUrl = "";
                if (pCompanyId.length == 0) { 
                    document.getElementById("div_respon").innerHTML = "";
                    return;
                } else {
                    var xmlhttp = new XMLHttpRequest();
                    xmlhttp.onreadystatechange = function() {
                        if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                            document.getElementById("div_respon").innerHTML = xmlhttp.responseText;
                        }
                    };
                    strUrl = "doc_flow_ajax.jsp";
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
                companyId, frmCompany, frmDivision, frmDepartment, frmSection, filterBy
            ) {
                var strUrl = "";
                if (companyId.length == 0) { 
                    document.getElementById("div_respon").innerHTML = "";
                    return;
                } else {
                    var xmlhttp = new XMLHttpRequest();
                    xmlhttp.onreadystatechange = function() {
                        if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                            document.getElementById("div_respon").innerHTML = xmlhttp.responseText;
                        }
                    };
                    strUrl = "doc_flow_ajax.jsp";

                    strUrl += "?company_id="+companyId;

                    strUrl += "&frm_company="+frmCompany;
                    strUrl += "&frm_division="+frmDivision;
                    strUrl += "&frm_department="+frmDepartment;
                    strUrl += "&frm_section="+frmSection;
                    strUrl += "&filter_by="+filterBy;
                    xmlhttp.open("GET", strUrl, true);

                    xmlhttp.send();
                }
            }

            function loadDepartment(
                companyId, divisionId, frmCompany, 
                frmDivision, frmDepartment, frmSection, filterBy
            ) {
                var strUrl = "";
                if ((companyId.length == 0)&&(divisionId.length == 0)) { 
                    document.getElementById("div_respon").innerHTML = "";
                    return;
                } else {
                    var xmlhttp = new XMLHttpRequest();
                    xmlhttp.onreadystatechange = function() {
                        if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                            document.getElementById("div_respon").innerHTML = xmlhttp.responseText;
                        }
                    };
                    strUrl = "doc_flow_ajax.jsp";

                    strUrl += "?company_id="+companyId;
                    strUrl += "&division_id="+divisionId;

                    strUrl += "&frm_company="+frmCompany;
                    strUrl += "&frm_division="+frmDivision;
                    strUrl += "&frm_department="+frmDepartment;
                    strUrl += "&frm_section="+frmSection;
                    strUrl += "&filter_by="+filterBy;
                    xmlhttp.open("GET", strUrl, true);
                    xmlhttp.send();
                }
            }
        </script>
    </head>
    <body>
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
            <span id="menu_title"><strong>Laporan</strong> <strong style="color:#333;"> / </strong> <strong>Penggajian</strong> <strong style="color:#333;"> / </strong> Uang Makan </span>
        </div>
        <div class="content-main">
            <form name="frpresence" method="post" action="">
                <input type="hidden" name="command" value="<%=iCommand%>">
                <input type="hidden" name="start" value="<%=start%>">
                <div class="formstyle">
                    <table>
                        <tr>
                            <td valign="top" style="padding-right: 21px;">
                                <div id="caption">NRK</div>
                                <div id="divinput">
                                    <input type="text" name="emp_number" id="emp_number" value="" />
                                </div>
                                <div id="caption">Perusahaan</div>
                                <div id="divinput">
                                    <%

                                        Vector com_value = new Vector(1, 1);
                                        Vector com_key = new Vector(1, 1);
                                        String placeHolderComp = "";
                                        String multipleComp = "";
                                        if (oidDivision == 0){
                                            placeHolderComp = "data-placeholder='Select Perusahaan...'";
                                            multipleComp = "multiple";
                                        } 
                                        //String sWhereClause = PstSection.fieldNames[PstSection.FLD_DEPARTMENT_ID] + " = " + sSelectedDepartment;                                                       
                                        //Vector listSec = PstSection.list(0, 0, sWhereClause, " SECTION ");
                                        Vector listCom = PstCompany.list(0, 0, "", "");
                                        for (int i = 0; i < listCom.size(); i++) {
                                            Company company = (Company) listCom.get(i);
                                            com_key.add(company.getCompany());
                                            com_value.add(String.valueOf(company.getOID()));
                                        }
                                    %>
                                    <%= ControlCombo.draw("company_id", "chosen-select", null, "", com_value, com_key, multipleComp+" "+placeHolderComp+" style='width:100%'")%>
                                </div>
                                <div id="caption">Unit</div>
                                <div id="divinput">
                                    <%
                                        Vector dep_value = new Vector(1, 1);
                                        Vector dep_key = new Vector(1, 1);
                                        
                                        Vector listDep = new Vector();

                                        if (oidDivision == 0){
                                            listDep = PstDepartment.list(0, 0, "hr_department.VALID_STATUS=1", "");
                                        } else {
                                            listDep = PstDepartment.list(0, 0, "hr_department."+PstDepartment.fieldNames[PstDepartment.FLD_DIVISION_ID] + " = " + oidDivision + " AND hr_department.VALID_STATUS=1", "");
                                        }

                                        Hashtable hashDiv = PstDivision.listMapDivisionName(0, 0, "", "");
                                        long tempDivOid = 0 ;
                                        for (int i = 0; i < listDep.size(); i++) {
                                            Department dep = (Department) listDep.get(i);

                                            if (dep.getDivisionId() != tempDivOid){
                                                dep_key.add("--"+hashDiv.get(dep.getDivisionId())+"--");
                                                dep_value.add(String.valueOf(-1));
                                                tempDivOid = dep.getDivisionId();
                                            }

                                            dep_key.add(dep.getDepartment());
                                            dep_value.add(String.valueOf(dep.getOID()));
                                        }
                                    %>

                                    <%= ControlCombo.draw("department", "chosen-select", null, "", dep_key, dep_value, null, "size=8 multiple data-placeholder='Select Unit...' style='width:100%'") %> 
                                </div>
                            </td>
                            <td valign="top">
                                <div id="caption">Nama Karyawan</div>
                                <div id="divinput">
                                    <input type="text" name="full_name" id="full_name" value="" />                                
                                </div>
                                <div id="caption">Satuan Kerja</div>
                                <div id="divinput">
                                    <%

                                        Vector div_value = new Vector(1, 1);
                                        Vector div_key = new Vector(1, 1);
                                        
                                        Vector listDiv  = new Vector();
                                        String placeHolder = "";
                                        String multipleDiv = "";
                                        if (oidDivision == 0){
                                            listDiv = PstDivision.list(0, 0, "VALID_STATUS=1", "");
                                            placeHolder = "data-placeholder='Select Satuan Kerja...'";
                                            multipleDiv = "multiple";
                                        } else {
                                            listDiv = PstDivision.list(0, 0, PstDivision.fieldNames[PstDivision.FLD_DIVISION_ID] + " = " + emplx.getDivisionId()  + " AND VALID_STATUS=1", PstDivision.fieldNames[PstDivision.FLD_DIVISION_ID]);
                                        }

                                        for (int i = 0; i < listDiv.size(); i++) {
                                            Division division = (Division) listDiv.get(i);
                                            div_key.add(division.getDivision());
                                            div_value.add(String.valueOf(division.getOID()));
                                        }
                                    %>
                                        <%= ControlCombo.draw("division_id", "chosen-select", null, "", div_key, div_value, null, multipleDiv+" "+placeHolder+" style='width:100%'") %> 
                                </div>
                                <div id="caption">Sub Unit</div>
                                <div id="divinput">
                                    <%

                                        Vector sec_value = new Vector(1, 1);
                                        Vector sec_key = new Vector(1, 1);
                                        

                                        Vector listSec = new Vector();

                                        if (oidDivision == 0){
                                            listSec = PstSection.list(0, 0, "VALID_STATUS=1", "DEPARTMENT_ID");
                                        } else {
                                            listSec = PstSection.list(0, 0, PstSection.fieldNames[PstSection.FLD_DEPARTMENT_ID] + " = " + emplx.getDepartmentId(), "DEPARTMENT_ID");
                                        }

                                        Hashtable hashDepart = PstDepartment.listMapDepName(0, 0, "", "", "");
                                        long tempDepOid = 0 ;
                                        for (int i = 0; i < listSec.size(); i++) {
                                            Section section = (Section) listSec.get(i);

                                            if (section.getDepartmentId() != tempDepOid){
                                                sec_key.add("--"+hashDepart.get(""+section.getDepartmentId())+"--");
                                                sec_value.add(String.valueOf(-1));
                                                tempDepOid = section.getDepartmentId();
                                            }

                                            sec_key.add(section.getSection());
                                            sec_value.add(String.valueOf(section.getOID()));
                                        }
                                    %>
                                     <%= ControlCombo.draw("section", "chosen-select", null, "", sec_key, sec_value, null, "multiple data-placeholder='Select Sub Unit...' style='width:100%'") %> 
                                </div>    
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div>
                                    <a href="javascript:cmdSearch()" class="btn" style="color:#FFF;">Search</a>
                                </div>
                            </td> 
                        </tr>
                    </table>
                </div>
                <% if (iCommand == Command.LIST) {
                    if (listEmployee.size() > 0 ){ %>
                <table class="tblStyle">
                    <tr>
                        <td class="title_tbl" style="text-align:center; vertical-align:middle">No</td>
                        <td class="title_tbl" style="text-align:center; vertical-align:middle">NRK</td>
                        <td class="title_tbl" style="text-align:center; vertical-align:middle">Nama</td>
                        <td class="title_tbl" style="text-align:center; vertical-align:middle">Jabatan</td>
                        <td class="title_tbl" style="text-align:center; vertical-align:middle">Cuti Saat ini</td>
                        <td class="title_tbl" style="text-align:center; vertical-align:middle">Cuti Sebelumnya</td>
                        <td class="title_tbl" style="text-align:center; vertical-align:middle">Cuti Total</td>
                        <td class="title_tbl" style="text-align:center; vertical-align:middle">Cuti Digunakan</td>
                        <td class="title_tbl" style="text-align:center; vertical-align:middle">Sisa Cuti</td>
                    </tr>
                    <%
                    if (listEmployee != null && listEmployee.size() > 0) {
                        
                        for (int idxEmp = 0; idxEmp < listEmployee.size(); idxEmp++) {
                            Employee emp = (Employee) listEmployee.get(idxEmp);
                            
                            Vector alStockList = new Vector();
                            Vector llStockList = new Vector();
                            float alQty = 0;
                            float llQty = 0;
                            long alStockId = 0;
                            long llStockId = 0;
                            boolean alStatus = false;
                            boolean llStatus = false;  

                    
                            Position pos = new Position();
                            String position = "";
                            try{
                                pos = PstPosition.fetchExc(emp.getPositionId());
                                position = pos.getPosition();
                            } catch (Exception exc){

                            }

                            Level lvl = new Level();
                            String Level = "";
                            try{
                                lvl = PstLevel.fetchExc(emp.getLevelId());
                                Level = lvl.getLevel();
                            } catch (Exception exc){

                            }

                             String bgColor = "";
                             if((idxEmp%2)==0){
                                 bgColor = "#FFF";
                             } else {
                                 bgColor = "#F9F9F9";
                             }
                             
                            whereClause = PstAlStockManagement.fieldNames[PstAlStockManagement.FLD_EMPLOYEE_ID]+"="+emp.getOID();
                            whereClause += " AND "+PstAlStockManagement.fieldNames[PstAlStockManagement.FLD_AL_STATUS]+"=0";
                            alStockList = PstAlStockManagement.list(0, 0, whereClause, "");
                            if (alStockList != null && alStockList.size()>0){
                                AlStockManagement alStock = (AlStockManagement)alStockList.get(0);
                                alQty = alStock.getAlQty();
                                alStockId = alStock.getOID();
                                if (alQty > 0){
                                    alStatus = true;
                                }
                            }
                            whereClause = PstLLStockManagement.fieldNames[PstLLStockManagement.FLD_EMPLOYEE_ID]+"="+emp.getOID();
                            whereClause += " AND "+PstLLStockManagement.fieldNames[PstLLStockManagement.FLD_LL_STATUS]+"=0";
                            llStockList = PstLLStockManagement.list(0, 0, whereClause, "");
                            if (llStockList != null && llStockList.size()>0){
                                LLStockManagement llStock = (LLStockManagement)llStockList.get(0);
                                llQty = llStock.getLLQty();
                                llStockId = llStock.getOID();
                                if (llQty > 0){
                                    llStatus = true;
                                }
                            }
                             
                            %>
                                 <tr>
                                     <td style="background-color: <%=bgColor%>;"><%=""+ (idxEmp+1)%></td>
                                     <td style="background-color: <%=bgColor%>;"><%=""+ emp.getEmployeeNum()%></td>
                                     <td style="background-color: <%=bgColor%>;"><%=""+ emp.getFullName()%></td>
                                     <td style="background-color: <%=bgColor%>;"><%=""+ Level%></td>
                                     <%
                                    if (alQty > llQty){
                                        if (alStockList != null && alStockList.size()>0){
                                            for (int i=0; i<alStockList.size(); i++){
                                                AlStockManagement alStockManagement = (AlStockManagement)alStockList.get(i);
                                                %>
                                                    <td style="background-color: <%=bgColor%>;"><%= convertInteger(alStockManagement.getEntitled()) %></td>
                                                    <td style="background-color: <%=bgColor%>;"><%= convertInteger(alStockManagement.getPrevBalance()) %></td>
                                                    <td style="background-color: <%=bgColor%>;"><%= convertInteger(alStockManagement.getEntitled()+alStockManagement.getPrevBalance()) %></td>
                                                    <td style="background-color: <%=bgColor%>;"><%= convertInteger(alStockManagement.getQtyUsed()) %></td>
                                                    <td style="background-color: <%=bgColor%>;"><%= convertInteger((alStockManagement.getEntitled()+alStockManagement.getPrevBalance())-alStockManagement.getQtyUsed()) %></td>
                                                <%
                                            }
                                        }
                                    } else if (llQty > 0.0) {
                                        if (llStockList != null && llStockList.size()>0){
                                            for (int i=0; i<llStockList.size(); i++){
                                                LLStockManagement llStockManagement = (LLStockManagement)llStockList.get(i);
                                                %>
                                                    <td style="background-color: <%=bgColor%>;"><%= convertInteger(llStockManagement.getEntitled()) %></td>
                                                    <td style="background-color: <%=bgColor%>;"><%= convertInteger(llStockManagement.getPrevBalance()) %></td>
                                                    <td style="background-color: <%=bgColor%>;"><%= convertInteger(llStockManagement.getEntitled()+llStockManagement.getPrevBalance()) %></td>
                                                    <td style="background-color: <%=bgColor%>;"><%= convertInteger(llStockManagement.getQtyUsed()) %></td>
                                                    <td style="background-color: <%=bgColor%>;"><%= convertInteger((llStockManagement.getEntitled()+llStockManagement.getPrevBalance())-llStockManagement.getQtyUsed()) %></td>
                                                <%
                                            }
                                        }
                                    } else {
                                        %>
                                            <td style="background-color: <%=bgColor%>;">0</td>
                                            <td style="background-color: <%=bgColor%>;">0</td>
                                            <td style="background-color: <%=bgColor%>;">0</td>
                                            <td style="background-color: <%=bgColor%>;">0</td>
                                            <td style="background-color: <%=bgColor%>;">0</td>
                                        <%
                                    }
                                    %>
                                 </tr>
                            <%

                         }
                     }

                    %>
                        
                </table>
                <%
                    } else {
                %>
                    <h6><strong>Tidak ada data</strong></h6>
                <%
                    }
                }
                %>                
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
        <script type="text/javascript">
                var config = {
                    '.chosen-select'           : {},
                    '.chosen-select-deselect'  : {allow_single_deselect:true},
                    '.chosen-select-no-single' : {disable_search_threshold:10},
                    '.chosen-select-no-results': {no_results_text:'Oops, nothing found!'},
                    '.chosen-select-width'     : {width:"100%"}
                }
                for (var selector in config) {
                    $(selector).chosen(config[selector]);
                }
        </script>        
    </body>
</html>

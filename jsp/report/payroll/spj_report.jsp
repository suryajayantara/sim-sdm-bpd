<%-- 
    Document   : spj_report
    Created on : 10-Feb-2017, 14:55:14
    Author     : Gunadi
--%>
<%@page import="java.text.DecimalFormatSymbols"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="com.dimata.gui.jsp.ControlCombo"%>
<%@page import="com.dimata.harisma.entity.payroll.PstPaySlipComp"%>
<%@page import="com.dimata.harisma.entity.masterdata.sessemployee.EmployeeMinimalis"%>
<%@page import="com.dimata.harisma.entity.masterdata.sessdepartment.SessDepartment"%>
<%@page import="com.dimata.harisma.entity.masterdata.sessdivision.SessDivision"%>
<%@page import="com.dimata.harisma.entity.attendance.PstEmpSchedule"%>
<%@page import="com.dimata.harisma.entity.masterdata.payday.PstPayDay"%>
<%@page import="com.dimata.harisma.entity.payroll.PstPayEmpLevel"%>
<%@page import="com.dimata.harisma.entity.masterdata.payday.HashTblPayDay"%>
<%@page import="com.dimata.harisma.entity.leave.I_Leave"%>
<%@page import="com.dimata.harisma.session.payroll.I_PayrollCalculator"%>
<%@page import="com.dimata.harisma.entity.attendance.I_Atendance"%>
<%@page import="com.dimata.harisma.session.attendance.rekapitulasiabsensi.RekapitulasiAbsensi"%>
<%@page import="com.dimata.harisma.entity.payroll.PayPeriod"%>
<%@page import="com.dimata.harisma.entity.payroll.PstPayPeriod"%>
<%@page import="com.dimata.harisma.entity.masterdata.Company"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstCompany"%>
<%@page import="com.dimata.harisma.entity.masterdata.Division"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstDivision"%>
<%@page import="com.dimata.harisma.entity.masterdata.DocMasterFlow"%>
<%@page import="com.dimata.util.Command"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstDocMasterFlow"%>
<%@page import="com.dimata.qdep.form.FRMQueryString"%>
<%@page import="com.dimata.harisma.entity.admin.AppObjInfo"%>
<%@page import="java.util.Vector"%>
<%@page import="com.dimata.qdep.form.FRMMessage"%>
<%@page import="com.dimata.gui.jsp.ControlLine"%>
<%@ include file = "../../main/javainit.jsp" %>
<% int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_REPORTS, AppObjInfo.G2_PAYROLL_REPORT, AppObjInfo.OBJ_SPJ_REPORT);%>
<%@ include file = "../../main/checkuser.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    /* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
    //boolean privPrint = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_PRINT));

    long hrdDepOid = Long.parseLong(String.valueOf(PstSystemProperty.getPropertyLongbyName(OID_HRD_DEPARTMENT)));
    boolean isHRDLogin = true;

    long edpSectionOid = Long.parseLong(String.valueOf(PstSystemProperty.getPropertyLongbyName(OID_EDP_SECTION)));
    boolean isEdpLogin = edpSectionOid == sectionOfLoginUser.getOID() ? true : false;
    boolean isGeneralManager = positionType == PstPosition.LEVEL_GENERAL_MANAGER ? true : false;

    SessUserSession userSessionn = (SessUserSession) session.getValue(SessUserSession.HTTP_SESSION_NAME);
    AppUser appUserSess1 = userSessionn.getAppUser();
    String namaUser1 = appUserSess1.getFullName();

    /* Check Administrator */
    long oidCompany = 0;
    String inOidDivision = "";
    String inOidDepartment = "";
    String strDisable = "";
    String strDisableNum = "";
    if (appUserSess.getAdminStatus()==0){
        if (privViewDivGroup){
            oidCompany = emplx.getCompanyId();
            long oidDivGroup = Long.parseLong(PstSystemProperty.getValueByName("OID_DIVISION_TYPE_REGULAR"));
            String whereDiv = ""+PstDivision.fieldNames[PstDivision.FLD_DIVISION_TYPE_ID]+"="+oidDivGroup;
            Vector vListDivision = PstDivision.list(0,0,whereDiv,"");
            if (vListDivision.size()>0){
                for (int i=0; i< vListDivision.size();i++){
                    Division division = (Division) vListDivision.get(i);
                    inOidDivision += ","+division.getOID();
                }
                inOidDivision = inOidDivision.substring(1);
            }
        } else {
            oidCompany = emplx.getCompanyId();
            inOidDivision = ""+emplx.getDivisionId();
            strDisable = "disabled=\"disabled\"";
        }
    } if (namaUser1.equals("Employee")){
        strDisableNum = "disabled=\"disabled\"";
    }

//cek tipe browser, browser detection
    //String userAgent = request.getHeader("User-Agent");
    //boolean isMSIE = (userAgent!=null && userAgent.indexOf("MSIE") !=-1); 

%>
<%



    String source = FRMQueryString.requestString(request, "source");
    long periodId = FRMQueryString.requestLong(request, "periodId");
	long periodIdTo = FRMQueryString.requestLong(request, "periodIdTo");
    String[] stsEmpCategory = null;
    int sizeCategory = PstEmpCategory.listAll() != null ? PstEmpCategory.listAll().size() : 0;
    stsEmpCategory = new String[sizeCategory];
    String stsEmpCategorySel = "";
    int maxEmpCat = 0;
    for (int j = 0; j < sizeCategory; j++) {
        String name = "EMP_CAT_" + j;
        String val = FRMQueryString.requestString(request, name);
        stsEmpCategory[j] = val;
        if (val != null && val.length() > 0) {
            //stsEmpCategorySel.add(""+val); 
            stsEmpCategorySel = stsEmpCategorySel + val + ",";
        }
        maxEmpCat++;
    }

    PayPeriod period = new PayPeriod();
    try {
        period = PstPayPeriod.fetchExc(periodId);
    } catch (Exception exc) {
    }
	
	PayPeriod periodTo = new PayPeriod();
    try {
        periodTo = PstPayPeriod.fetchExc(periodIdTo);
    } catch (Exception exc) {
    }


    //    OID_DAILYWORKER
    long Dw = 0;
    try {
        String sDw = PstSystemProperty.getValueByName("OID_DAILYWORKER");
        Dw = Integer.parseInt(sDw);
    } catch (Exception ex) {
        System.out.println("VALUE_DAILYWORKER NOT Be SET" + ex);
    }
    
      String oidDocSpjKurang40 = "";
    try {
        oidDocSpjKurang40 = PstSystemProperty.getValueByName("OID_SPJKR40_DOC");
    } catch (Exception ex) {
        System.out.println("OID_SPJKR40_DOC NOT Be SET" + ex);
    }
    
    String oidDocSpjLebih40 = "";
    try {
        oidDocSpjLebih40 = PstSystemProperty.getValueByName("OID_SPJLB40_DOC");
    } catch (Exception ex) {
        System.out.println("OID_SPJLB40_DOC NOT Be SET" + ex);
    }
    
    int iCommand = FRMQueryString.requestCommand(request);
    int iErrCode = FRMMessage.NONE;
    int start = FRMQueryString.requestInt(request, "start");

    RekapitulasiAbsensi rekapitulasiAbsensi = new RekapitulasiAbsensi();
    rekapitulasiAbsensi.setCompanyId(FRMQueryString.requestLong(request, "company_id"));
    //rekapitulasiAbsensi.setDeptId(FRMQueryString.requestLong(request, "department"));
    rekapitulasiAbsensi.addArrDivision(FRMHandler.getParamsStringValuesStatic(request, "division_id"));
    rekapitulasiAbsensi.addArrDepartment(FRMHandler.getParamsStringValuesStatic(request, "department"));
    rekapitulasiAbsensi.addArrSection(FRMHandler.getParamsStringValuesStatic(request, "section"));
    rekapitulasiAbsensi.addArrPosition(FRMHandler.getParamsStringValuesStatic(request, "position"));

    //rekapitulasiAbsensi.setSectionId(FRMQueryString.requestLong(request, "section"));
    //rekapitulasiAbsensi.setDivisionId(FRMQueryString.requestLong(request, "division_id"));

    rekapitulasiAbsensi.setSourceTYpe(FRMQueryString.requestInt(request, "source_type"));
    rekapitulasiAbsensi.setPeriodId(FRMQueryString.requestLong(request, "periodId"));
    rekapitulasiAbsensi.setDtFrom(period.getStartDate());
	if (periodTo.getOID()>0){
		rekapitulasiAbsensi.setDtTo(periodTo.getEndDate());
	} else {
		rekapitulasiAbsensi.setDtTo(period.getEndDate());
	}
    
    if (rekapitulasiAbsensi.getSourceTYpe() == 1 && rekapitulasiAbsensi.getPeriodId() != 0) {
        PayPeriod payPeriod = new PayPeriod();
        try {
            payPeriod = PstPayPeriod.fetchExc(rekapitulasiAbsensi.getPeriodId());
        } catch (Exception e) {
        }
        rekapitulasiAbsensi.setDtFrom(payPeriod.getStartDate());
        rekapitulasiAbsensi.setDtTo(payPeriod.getEndDate());
    }

    rekapitulasiAbsensi.setEmpCategory(stsEmpCategorySel);
    rekapitulasiAbsensi.setFullName(FRMQueryString.requestString(request, "full_name"));
    rekapitulasiAbsensi.setPayrollNumber(FRMQueryString.requestString(request, "emp_number"));
    rekapitulasiAbsensi.setResignSts(FRMQueryString.requestInt(request, "statusResign"));
    rekapitulasiAbsensi.setViewschedule(FRMQueryString.requestInt(request, "viewschedule"));
    int viewschedule = FRMQueryString.requestInt(request, "viewschedule");
    int OnlyDw = FRMQueryString.requestInt(request, "OnlyDw");
    if (OnlyDw != 0 && OnlyDw == 1) {
        rekapitulasiAbsensi.setEmpCategory(Dw + ",");
    }

    String whereClausePeriod = "";
    if (rekapitulasiAbsensi.getDtTo() != null && rekapitulasiAbsensi.getDtFrom() != null) {
        whereClausePeriod = "\"" + Formater.formatDate(rekapitulasiAbsensi.getDtTo(), "yyyy-MM-dd HH:mm:ss") + "\" >="
                + PstPeriod.fieldNames[PstPeriod.FLD_START_DATE] + " AND "
                + PstPeriod.fieldNames[PstPeriod.FLD_END_DATE] + " >= \"" + Formater.formatDate(rekapitulasiAbsensi.getDtFrom(), "yyyy-MM-dd HH:mm:ss") + "\"";
    }

Vector listEmployee = new Vector();
    if (iCommand == Command.LIST){
        listEmployee  = PstEmpDoc.listSpj(rekapitulasiAbsensi);
    }

%>


<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>SPJ Report</title>
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
                
                var e = document.getElementById("periodId");
                var period = e.options[e.selectedIndex].value;
                if (period == 0){
                    alert("Pilih Periode!")
                } else {
                    document.frpresence.command.value="<%=String.valueOf(Command.LIST)%>";
                    document.frpresence.action="spj_report.jsp";
                    document.frpresence.submit();
                }
            }    
            function cmdExport(){
                document.frpresence.command.value="<%=String.valueOf(Command.LIST)%>";
                document.frpresence.action="export_excel/exportExcelSPJ.jsp";
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
            <span id="menu_title"><strong>Laporan</strong> <strong style="color:#333;"> / </strong> <strong>Penggajian</strong> <strong style="color:#333;"> / </strong> SPJ Report </span>
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
                                    <input type="text" name="emp_number" id="emp_number" value="<%= rekapitulasiAbsensi.getPayrollNumber()%>" />
                                </div>
                                <div id="caption">Perusahaan</div>
                                <div id="divinput">
                                    <%

                                        Vector com_value = new Vector(1, 1);
                                        Vector com_key = new Vector(1, 1);
                                        String placeHolderComp = "";
                                        String multipleComp = "";
                                        if (inOidDivision.equals("")) {
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
                                    <%= ControlCombo.draw("company_id", "chosen-select", null, "" + rekapitulasiAbsensi.getCompanyId(), com_value, com_key, multipleComp + " " + placeHolderComp + " style='width:100%'")%>
                                </div>
                                <div id="caption">Unit</div>
                                <div id="divinput">
                                    <%
                                        Vector dep_value = new Vector(1, 1);
                                        Vector dep_key = new Vector(1, 1);

                                        Vector listDep = new Vector();

                                        if (inOidDivision.equals("")) {
                                            listDep = PstDepartment.list(0, 0, "hr_department.VALID_STATUS=1", "");
                                        } else {
                                            listDep = PstDepartment.list(0, 0, "hr_department." + PstDepartment.fieldNames[PstDepartment.FLD_DIVISION_ID] + " IN (" + inOidDivision + ") AND hr_department.VALID_STATUS=1", "");
                                        }

                                        Hashtable hashDiv = PstDivision.listMapDivisionName(0, 0, "", "");
                                        long tempDivOid = 0;
                                        for (int i = 0; i < listDep.size(); i++) {
                                            Department dep = (Department) listDep.get(i);
                                            inOidDepartment += ","+dep.getOID();
                                            
                                            if (dep.getDivisionId() != tempDivOid) {
                                                dep_key.add("--" + hashDiv.get(dep.getDivisionId()) + "--");
                                                dep_value.add(String.valueOf(-1));
                                                tempDivOid = dep.getDivisionId();
                                            }

                                            dep_key.add(dep.getDepartment());
                                            dep_value.add(String.valueOf(dep.getOID()));
                                            inOidDepartment = inOidDepartment.substring(1);
                                        }
                                    %>

                                    <%= ControlCombo.drawStringArraySelected("department", "chosen-select", null, rekapitulasiAbsensi.getArrDepartment(0), dep_key, dep_value, null, "size=8 multiple data-placeholder='Select Unit...' style='width:100%'")%> 
                                </div>
                                <div id="caption">Periode</div>
                                <div id="divinput">
                                    <select name="periodId" id="periodId" value="<%=rekapitulasiAbsensi.getPeriodId()%>" class="chosen-select" data-placeholder="Select Periode...">
                                        <option value="0">Select Periode...</option>
                                        <%
                                            Vector listPeriod = PstPayPeriod.list(0, 0, "", "START_DATE DESC");
                                            for (int r = 0; r < listPeriod.size(); r++) {
                                                PayPeriod payPeriod = (PayPeriod) listPeriod.get(r);
                                        %>
                                        <% if (payPeriod.getOID() == rekapitulasiAbsensi.getPeriodId() ) { %>
                                        <option value="<%= String.valueOf(payPeriod.getOID())%>" selected><%= payPeriod.getPeriod()%></option>
                                        <% } else { %>
                                        <option value="<%= String.valueOf(payPeriod.getOID())%>"><%= payPeriod.getPeriod()%></option>
                                        <% } %>
                                        <% } %>
                                    </select>
									to
									<select name="periodIdTo" id="periodIdTo" value="<%=rekapitulasiAbsensi.getPeriodId()%>" class="chosen-select" data-placeholder="Select Periode...">
                                        <option value="0">Select Periode...</option>
                                        <%
                                            for (int r = 0; r < listPeriod.size(); r++) {
                                                PayPeriod payPeriod = (PayPeriod) listPeriod.get(r);
                                        %>
                                        <% if (payPeriod.getOID() == rekapitulasiAbsensi.getPeriodId() ) { %>
                                        <option value="<%= String.valueOf(payPeriod.getOID())%>" selected><%= payPeriod.getPeriod()%></option>
                                        <% } else { %>
                                        <option value="<%= String.valueOf(payPeriod.getOID())%>"><%= payPeriod.getPeriod()%></option>
                                        <% } %>
                                        <% } %>
                                    </select>
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

                                        Vector listDiv = new Vector();
                                        String placeHolder = "";
                                        String multipleDiv = "multiple";
                                        if (inOidDivision.equals("")) {
                                            listDiv = PstDivision.list(0, 0, "VALID_STATUS=1", "");
                                            placeHolder = "data-placeholder='Select Satuan Kerja...'";
                                            multipleDiv = "multiple";
                                        } else {
                                            listDiv = PstDivision.list(0, 0, PstDivision.fieldNames[PstDivision.FLD_DIVISION_ID] + " IN (" + inOidDivision + ") AND VALID_STATUS=1", PstDivision.fieldNames[PstDivision.FLD_DIVISION_ID]);
                                        }

                                        for (int i = 0; i < listDiv.size(); i++) {
                                            Division div = (Division) listDiv.get(i);
                                            div_key.add(div.getDivision());
                                            div_value.add(String.valueOf(div.getOID()));
                                        }
                                    %>
                                    <%= ControlCombo.drawStringArraySelected("division_id", "chosen-select", null, rekapitulasiAbsensi.getArrDivision(0), div_key, div_value, null, multipleDiv + " " + placeHolder + " style='width:100%'")%> 
                                </div>
                                <div id="caption">Sub Unit</div>
                                <div id="divinput">
                                    <%

                                        Vector sec_value = new Vector(1, 1);
                                        Vector sec_key = new Vector(1, 1);


                                        Vector listSec = new Vector();

                                        if (inOidDivision.equals("")) {
                                            listSec = PstSection.list(0, 0, "VALID_STATUS=1", "DEPARTMENT_ID");
                                        } else {
                                            listSec = PstSection.list(0, 0, PstSection.fieldNames[PstSection.FLD_DEPARTMENT_ID] + " IN (" + inOidDepartment+")", "DEPARTMENT_ID");
                                        }

                                        Hashtable hashDepart = PstDepartment.listMapDepName(0, 0, "", "", "");
                                        long tempDepOid = 0;
                                        for (int i = 0; i < listSec.size(); i++) {
                                            Section sec = (Section) listSec.get(i);

                                            if (sec.getDepartmentId() != tempDepOid) {
                                                sec_key.add("--" + hashDepart.get("" + sec.getDepartmentId()) + "--");
                                                sec_value.add(String.valueOf(-1));
                                                tempDepOid = sec.getDepartmentId();
                                            }

                                            sec_key.add(sec.getSection());
                                            sec_value.add(String.valueOf(sec.getOID()));
                                        }
                                    %>
                                    <%= ControlCombo.drawStringArraySelected("section", "chosen-select", null, rekapitulasiAbsensi.getArrSection(0), sec_key, sec_value, null, "multiple data-placeholder='Select Sub Unit...' style='width:100%'")%> 
                                </div>    
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div>
                                    <a href="javascript:cmdSearch()" class="btn" style="color:#FFF;">Search</a>
                                    <a href="javascript:cmdExport()" class="btn" style="color:#FFF;">Export XLS</a>
                                </div>
                            </td> 
                        </tr>
                    </table>
                </div>
                                
                <% if (iCommand == Command.LIST) {
                    if (listEmployee.size() > 0) {
          
                        
                %>
                <div class="formstyle" style="overflow-x:auto;">
                <h4><strong>Laporan SPJ Karyawan <%=period.getPeriod()%> <%=(periodTo.getOID() > 0 ? " - "+periodTo.getPeriod() : "")%></strong></h4>
                <table class="tblStyle">
                    <tr>
                        <td width="1%" rowspan="2" bgcolor="#FFFF33" align="center" valign="middle"><strong>No</strong></td>
                        <td width="1%" rowspan="2" bgcolor="#FFFF33" align="center" valign="middle"><strong>Nomor SPJ</strong></td>
                        <td width="4%" rowspan="2" bgcolor="#FFFF33" align="center" valign="middle"><strong>TIPE SPJ</strong></td>
                        <td width="4%" rowspan="2" bgcolor="#FFFF33" align="center" valign="middle"><strong>Tanggal SPJ</strong></td>
                        <td width="4%" rowspan="2" bgcolor="#FFFF33" align="center" valign="middle"><strong>Tanggal Berangkat</strong></td>
                        <td width="4%" rowspan="2" bgcolor="#FFFF33" align="center" valign="middle"><strong>Tanggal Kembali</strong></td>
                        <td width="4%" rowspan="2" bgcolor="#FFFF33" align="center" valign="middle"><strong>NRK / NKK</strong></td>
                        <td width="5%" rowspan="2" bgcolor="#FFFF33" align="center" valign="middle"><strong>Nama Petugas</strong></td>
                        <td width="5%" rowspan="2" bgcolor="#FFFF33" align="center" valign="middle"><strong>Grade Petugas</strong></td>
                        <td width="7%" rowspan="2" bgcolor="#FFFF33" align="center" valign="middle"><strong>Jabatan Petugas</strong></td>
                        <td width="5%" rowspan="2" bgcolor="#FFFF33" align="center" valign="middle"><strong>Divisi/Cabang Petugas</strong></td>
                        <td width="5%" rowspan="2" bgcolor="#FFFF33" align="center" valign="middle"><strong>Tempat Tujuan</strong></td>
                        <td width="7%" rowspan="2" bgcolor="#FFFF33" align="center" valign="middle"><strong>Keperluan</strong></td>
                        <td width="4%" rowspan="2" bgcolor="#FFFF33" align="center" valign="middle"><strong>angkutan</strong></td>
                        <td width="4%" rowspan="2" bgcolor="#FFFF33" align="center" valign="middle"><strong>Nama TTD</strong></td>
                        <td width="4%" rowspan="2" bgcolor="#FFFF33" align="center" valign="middle"><strong>Jabatan TTD</strong></td>
                        <td width="4%" rowspan="2" bgcolor="#FFFF33" align="center" valign="middle"><strong>BIAYA</strong></td>
                        <td width="4%" colspan="6" bgcolor="#FFFF33" align="center" valign="middle"><strong>Pengikut    internal</strong></td>
                        <td width="4%" bgcolor="#FFFF33" align="center" valign="middle"><strong>Pengikut External</strong></td>
                        <td width="4%" rowspan="2" bgcolor="#FFFF33" align="center" valign="middle"><strong>Total Biaya</strong></td>
                    </tr>
                    <tr>
                        <td bgcolor="#FFFF33"><strong>NRK / NKK</strong></td>
                        <td bgcolor="#FFFF33"><strong>Nama</strong></td>
                        <td bgcolor="#FFFF33"><strong>Grade</strong></td>
                        <td bgcolor="#FFFF33"><strong>Jabatan</strong></td>
                        <td bgcolor="#FFFF33"><strong>Divisi/Cabang</strong></td>
                        <td bgcolor="#FFFF33"><strong>Biaya</strong></td>
                        <td bgcolor="#FFFF33"><strong>Nama</strong></td>
                    </tr>
                    
                    <% for (int x=0; x<listEmployee.size(); x++){
                       EmpDocSpj empDocSpj = (EmpDocSpj) listEmployee.get(x);
                       
                       Employee employee = new Employee();
                       try {
                           employee = PstEmployee.fetchExc(empDocSpj.getEmployeeId());
                       }catch (Exception e){
                           System.out.println(" error out : "+e);
                       }
                       
                       Employee employeeTTD = new Employee();
                       try {
                           
                           long empId = PstEmpDocList.getEmployeeIdByObjectnameEmpDocId("TRAINNER3", empDocSpj.getEmpDocId());
                           employeeTTD = PstEmployee.fetchExc(empId);
                       }catch (Exception e){
                           System.out.println(" error out : "+e);
                       }
                       
                        Vector listpengikut = new Vector();
                       try {
                           String listpengikutS = PstEmpDocList.listEmployeeId(empDocSpj.getEmpDocId(), "TRAINNERLISTLINE");
                           listpengikut = PstEmployee.list(0, 0, PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID] + " IN ("+listpengikutS+")" , "");
                       }catch (Exception e){
                           System.out.println(" error out : "+e);
                       }
                        
                        double totalValue = PstEmpDocListExpense.getTotalExpensesEmployee(empDocSpj.getEmpDocId(), employee.getOID());
                        double totalSpj = PstEmpDocListExpense.getTotalExpenses(empDocSpj.getEmpDocId());
                        DecimalFormat kurs = (DecimalFormat) DecimalFormat.getCurrencyInstance();
                        DecimalFormatSymbols formatRp = new DecimalFormatSymbols();

                        formatRp.setCurrencySymbol("Rp. ");
                        formatRp.setMonetaryDecimalSeparator(',');
                        formatRp.setGroupingSeparator('.');

                        kurs.setDecimalFormatSymbols(formatRp);
                       
                    %>
                    
                    <tr>
                        <td rowspan="<%=(listpengikut.size() == 0 ? 1 : listpengikut.size())%>"><%=(x+1)%></td>
                        <td rowspan="<%=(listpengikut.size() == 0 ? 1 : listpengikut.size())%>"><%=empDocSpj.getDocNumber()%></td>
                        <td rowspan="<%=(listpengikut.size() == 0 ? 1 : listpengikut.size())%>"><%=(oidDocSpjLebih40.contains(""+empDocSpj.getDocMasterId())?"SPJ > 40KM":"SPJ < 40KM" )%></td>
                        <td rowspan="<%=(listpengikut.size() == 0 ? 1 : listpengikut.size())%>"><%=empDocSpj.getRequestDate()%></td>
                        <td rowspan="<%=(listpengikut.size() == 0 ? 1 : listpengikut.size())%>"><%=PstEmpDocField.getvalueByObjectnameEmpDocId("TGL_BERANGKAT", empDocSpj.getEmpDocId())%></td>
                        <td rowspan="<%=(listpengikut.size() == 0 ? 1 : listpengikut.size())%>"><%=PstEmpDocField.getvalueByObjectnameEmpDocId("TGL_KEMBALI", empDocSpj.getEmpDocId())%></td>
                        <td rowspan="<%=(listpengikut.size() == 0 ? 1 : listpengikut.size())%>"><%=employee.getEmployeeNum()%></td>
                        <td rowspan="<%=(listpengikut.size() == 0 ? 1 : listpengikut.size())%>"><%=empDocSpj.getFullName()%></td>
                        <td rowspan="<%=(listpengikut.size() == 0 ? 1 : listpengikut.size())%>"><%=PstGradeLevel.getGradeLevelName(""+employee.getGradeLevelId())%></td>
                        <td rowspan="<%=(listpengikut.size() == 0 ? 1 : listpengikut.size())%>"><%=PstPosition.getPositionName(""+empDocSpj.getPositionId())%></td>
                        <td rowspan="<%=(listpengikut.size() == 0 ? 1 : listpengikut.size())%>"><%=PstDivision.getDivisionName(employee.getDivisionId())%></td>
                        <td rowspan="<%=(listpengikut.size() == 0 ? 1 : listpengikut.size())%>"><%=PstEmpDocField.getvalueByObjectnameEmpDocId("TUJUAN", empDocSpj.getEmpDocId())%></td>
                        <td rowspan="<%=(listpengikut.size() == 0 ? 1 : listpengikut.size())%>"><%=PstEmpDocField.getvalueByObjectnameEmpDocId("KEPERLUAN", empDocSpj.getEmpDocId())%></td>
                        <td rowspan="<%=(listpengikut.size() == 0 ? 1 : listpengikut.size())%>"><%=PstEmpDocField.getvalueByObjectnameEmpDocId("ANGKUTAN", empDocSpj.getEmpDocId())%></td>
                        <td rowspan="<%=(listpengikut.size() == 0 ? 1 : listpengikut.size())%>"><%=employeeTTD.getFullName()%></td>
                        <td rowspan="<%=(listpengikut.size() == 0 ? 1 : listpengikut.size())%>"><%=PstPosition.getPositionName(""+employeeTTD.getPositionId())%></td>
                        <td rowspan="<%=(listpengikut.size() == 0 ? 1 : listpengikut.size())%>"><%=kurs.format(totalValue)%></td>
                       
                        <%
                        Employee employeeFirst = new Employee();
                        try{
                            employeeFirst = (Employee) listpengikut.get(0);
                        }catch(Exception e){
                            System.out.println(" exc : "+e);
                        }
                        
                        double totalValueFirst = PstEmpDocListExpense.getTotalExpensesEmployee(empDocSpj.getEmpDocId(), employeeFirst.getOID());
                        
                        formatRp.setCurrencySymbol("Rp. ");
                        formatRp.setMonetaryDecimalSeparator(',');
                        formatRp.setGroupingSeparator('.');

                        %>
                        <td><%=employeeFirst.getEmployeeNum()%></td>
                        <td><%=employeeFirst.getFullName()%></td>
                        <td><%=PstGradeLevel.getGradeLevelName(""+employeeFirst.getGradeLevelId())%></td>
                        <td><%=PstPosition.getPositionName(""+employeeFirst.getPositionId())%></td>
                        <td><%=PstDivision.getDivisionName(employeeFirst.getDivisionId())%></td>
                        <td><%=kurs.format(totalValueFirst)%></td>
                        <td>-</td>
                        <td rowspan="<%=(listpengikut.size() == 0 ? 1 : listpengikut.size())%>"><%=kurs.format(totalSpj)%></td>
                    </tr>
                    
                    <%
                    if (listpengikut.size()>1){
                        
                        for (int i=1; i<listpengikut.size(); i++){
                            Employee employeeList = (Employee) listpengikut.get(i);
                            double totalValueList = PstEmpDocListExpense.getTotalExpensesEmployee(empDocSpj.getEmpDocId(), employeeList.getOID());

                            formatRp.setCurrencySymbol("Rp. ");
                            formatRp.setMonetaryDecimalSeparator(',');
                            formatRp.setGroupingSeparator('.');
                    %>
                     <tr>
                        <td><%=employeeList.getEmployeeNum()%></td>
                        <td><%=employeeList.getFullName()%></td>
                        <td><%=PstGradeLevel.getGradeLevelName(""+employeeList.getGradeLevelId())%></td>
                        <td><%=PstPosition.getPositionName(""+employeeList.getPositionId())%></td>
                        <td><%=PstDivision.getDivisionName(employeeList.getDivisionId())%></td>
                        <td><%=kurs.format(totalValueList)%></td>
                        <td>-</td>
                    </tr>
                    <%
                        }
                    }
                    %>
                    <% } %>
                </table>

                <%
                } else {
                %>
                <h6><strong>Tidak ada data</strong></h6>
                <%     }
                    }
                %>
                </div>
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



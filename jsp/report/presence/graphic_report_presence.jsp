<%-- 
    Document   : graphic_report_presence
    Created on : Apr 18, 2019, 10:22:08 AM
    Author     : Dimata 007
--%>

<%@page import="org.json.JSONObject"%>
<%@page import="org.json.JSONArray"%>
<%@page import="com.dimata.harisma.session.attendance.SessEmpSchedule"%>
<%@page import="com.dimata.gui.jsp.ControlCombo"%>
<%@page import="com.dimata.util.Command"%>
<%@ include file = "../../main/javainit.jsp" %>
<% int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_MENU_REPORTS, AppObjInfo.G2_MENU_PAYROLL_REPORT, AppObjInfo.OBJ_MENU_OVERTIME_RPT);%>
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
    long oidDivision = 0;
    String strDisable = "";
    String strDisableNum = "";
    if (appUserSess.getAdminStatus() == 0 && !privViewAllDivision) {
        oidCompany = emplx.getCompanyId();
        oidDivision = emplx.getDivisionId();
        strDisable = "disabled=\"disabled\"";
    }
    if (namaUser1.equals("Employee")) {
        strDisableNum = "disabled=\"disabled\"";
    }

    //cek tipe browser, browser detection
    //String userAgent = request.getHeader("User-Agent");
    //boolean isMSIE = (userAgent!=null && userAgent.indexOf("MSIE") !=-1); 

%>

<%//
    int iCommand = FRMQueryString.requestCommand(request);
    String empNumber = FRMQueryString.requestString(request, "emp_number");
    String empName = FRMQueryString.requestString(request, "full_name");
    String[] oidComp = FRMQueryString.requestStringValues(request, "company_id");
    String[] oidDiv = FRMQueryString.requestStringValues(request, "division_id");
    String[] oidDept = FRMQueryString.requestStringValues(request, "department");
    String[] oidSec = FRMQueryString.requestStringValues(request, "section");
    String[] oidSchedule = FRMQueryString.requestStringValues(request, "schedule_id");
    String dateFrom = FRMQueryString.requestString(request, "date_from");
    String dateTo = FRMQueryString.requestString(request, "date_to");
    int prType = FRMQueryString.requestInt(request, "presence_type");
    String[] multipleTime = FRMQueryString.requestStringValues(request, "multi_time");
    int useGradientColor = FRMQueryString.requestInt(request, "gradient");
    int group = FRMQueryString.requestInt(request, "group");
    
    if (dateFrom.isEmpty()) {
        dateFrom = Formater.formatDate(new Date(), "yyyy-MM-dd 00:00");
    }
    
    if (dateTo.isEmpty()) {
        dateTo = Formater.formatDate(new Date(), "yyyy-MM-dd 17:00");
    }
    
    String[] groupTitle = {"Perusahaan","Satuan Kerja","Unit Kerja","Sub Unit","Symbol"};
    String[] groupBy = {"COMPANY_ID","DIVISION_ID","DEPARTMENT_ID","SECTION_ID","SCHEDULE_ID"};
    String[] orderBy = {"COMPANY_NAME","DIVISION_NAME","DEPARTMENT_NAME","SECTION_NAME","SYMBOL"};
    
    List<String> listHeader = new ArrayList();
    Vector<Vector> listDataPerGroup = new Vector();
    SessEmpSchedule empSchedule = new SessEmpSchedule();
    
    if (iCommand == Command.LIST) {
        empSchedule.setEmpNum(empNumber);
        empSchedule.setEmpFullName(empName);
        
        if (multipleTime != null) {
            int i = 0;
            for (String s : multipleTime) {
                if (listHeader.isEmpty()) {
                    listHeader.add("< " + s);
                }

                if (i <= multipleTime.length - 2) {
                    String minute[] = s.split(":");
                    int untilMinute = Integer.valueOf(minute[1]);
                    if (i > 0) {
                        untilMinute++;
                    }
                    String newMinute = String.valueOf(untilMinute).length() == 1 ? "0" + untilMinute : "" + untilMinute;
                    listHeader.add(minute[0] + ":" + newMinute + " - " + multipleTime[i + 1]);
                }

                if (i == multipleTime.length - 1) {
                    listHeader.add("> " + s);
                }
                i++;
            }
        }
        
        if (!dateFrom.isEmpty()) {
            empSchedule.setFromDate(Formater.formatDate(dateFrom, "yyyy-MM-dd HH:mm"));
        }
        if (!dateTo.isEmpty()) {
            empSchedule.setToDate(Formater.formatDate(dateTo, "yyyy-MM-dd HH:mm"));
        }
        
        String inCompany = (oidComp == null) ? "" : Arrays.toString(oidComp);
        inCompany = (inCompany.isEmpty()) ? "" : inCompany.substring(1, inCompany.length() - 1);
        empSchedule.setInCompany(inCompany);
        
        String inDivision = (oidDiv == null) ? "" : Arrays.toString(oidDiv);
        inDivision = (inDivision.isEmpty()) ? "" : inDivision.substring(1, inDivision.length() - 1);
        empSchedule.setInDivision(inDivision);

        String inDepartment = (oidDept == null) ? "" : Arrays.toString(oidDept);
        inDepartment = (inDepartment.isEmpty()) ? "" : inDepartment.substring(1, inDepartment.length() - 1);
        empSchedule.setInDepartment(inDepartment);

        String inSection = (oidSec == null) ? "" : Arrays.toString(oidSec);
        inSection = (inSection.isEmpty()) ? "" : inSection.substring(1, inSection.length() - 1);
        empSchedule.setInSection(inSection);
        
        String inSchedule = (oidSchedule == null) ? "" : Arrays.toString(oidSchedule);
        inSchedule = (inSchedule.isEmpty()) ? "" : inSchedule.substring(1, inSchedule.length() - 1);
        empSchedule.setInSchedule(inSchedule);
        
        listDataPerGroup = SessEmpSchedule.listPresenceByScheduleSymbolWithRangeDate(empSchedule, groupBy[group], orderBy[group], 1);
        
    }
    int removeTable = 0;

%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>HARISMA - Report Presence Chart</title>
        <link rel="stylesheet" href="../../styles/main.css" type="text/css">
        <%@ include file = "../../main/konfigurasi_jquery.jsp" %>    
        <script src="../../javascripts/jquery.min-1.6.2.js" type="text/javascript"></script>
        <script src="../../javascripts/chosen.jquery.js" type="text/javascript"></script>
        <link href="../../stylesheets/chosen.css" rel="stylesheet">
        <link href="../../styles/Highcharts-6.0.7/highcharts.css" rel="stylesheet">
        
        <style type="text/css">
            .tblStyle {border-collapse: collapse; font-size: 12px;}
            .tblStyle td {padding: 7px 9px; border: 1px solid #CCC; font-size: 12px;}
            .title_tbl {font-weight: bold;background-color: #00a1ec;; color: white;}
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
        
        <link rel="stylesheet" href="<%=approot%>/javascripts/datepicker/themes/jquery.ui.all.css"/>
        <link rel="stylesheet" href="<%=approot%>/javascripts/datepicker/themes/jquery.ui.timepicker.addon.css"/>

        <script src="<%=approot%>/javascripts/datepicker/jquery.ui.core.js"></script>
        <script src="<%=approot%>/javascripts/datepicker/jquery.ui.widget.js"></script>
        <script src="<%=approot%>/javascripts/datepicker/jquery.ui.datepicker.js"></script>
        <script src="<%=approot%>/javascripts/datepicker/jquery.ui.timepicker.addon.js"></script>
        
        <script src="../../styles/Highcharts-6.0.7/highcharts.js"></script>
        
        <script language="JavaScript">
            function cmdSearch() {
                document.frpresence.command.value = "<%=String.valueOf(Command.LIST)%>";
                document.frpresence.action = "graphic_report_presence.jsp";
                document.frpresence.submit();
            }
            function cmdExport() {
                document.frpresence.command.value = "<%=String.valueOf(Command.LIST)%>";
                document.frpresence.action = "export_excel/graphic_report_presence.jsp";
                document.frpresence.submit();
            }
        
            $(function () {
                $(".datetimepicker").datetimepicker({
                    dateFormat: "yy-mm-dd"}
                );
                $(".datepicker").datepicker({dateFormat: "yy-mm-dd"});
                
            });
            function addTime() {
                $("#multiple_time").append(""
                        + "<span style='display: inline-block'>"
                        + "<input type='text' size='15' class='' name='multi_time' value='00:00' style='margin-bottom: 4px'>"
                        + "&nbsp;"
                        + "<a onclick='javascript:removeTime(this)' class='btn' style='color:#FFF; font-size: 14px; padding: 3px 9px; background-color: #f05656; cursor: pointer'><b>-</b></a>"
                        + "&nbsp;"
                        + "</span>");
            }
            function changeTimeValue() {
                $('.pr_type').change(function(){
                    if ($(this).val() == 0){
                        $("#time1").val("07:30");
                        $("#time2").val("07:45");
                        $("#time3").val("08:00");
                    } else {
                        $("#time1").val("16:00");
                        $("#time2").val("16:15");
                        $("#time3").val("16:30");
                    }
                });
            }
            function removeTime(e) {
                e.parentNode.parentNode.removeChild(e.parentNode);
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
            <span id="menu_title">Laporan / Kehadiran / <strong>Grafik Kehadiran Karyawan</strong></span>
        </div>

        <div class="content-main">
            <form name="frpresence" method="post" action="">
                <input type="hidden" name="command" value="<%=iCommand%>">
                <input type="hidden" name="start" value="">
                
                <div class="formstyle">
                    <table>
                        <tr>
                            <td valign="top" style="padding-right: 20px;">
                                <div id="caption">Perusahaan</div>
                                <div id="divinput">
                                    <%

                                        Vector com_value = new Vector(1, 1);
                                        Vector com_key = new Vector(1, 1);
                                        String placeHolderComp = "";
                                        String multipleComp = "";
                                        if (oidDivision == 0) {
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
                                    <%= ControlCombo.draw("company_id", "chosen-select", null, "" + oidComp, com_value, com_key, multipleComp + " " + placeHolderComp + " style='width:100%'")%>
                                </div>
                                
                                <div id="caption">Unit Kerja</div>
                                <div id="divinput">
                                    <%
                                        Vector dep_value = new Vector(1, 1);
                                        Vector dep_key = new Vector(1, 1);

                                        Vector listDep = new Vector();

                                        if (oidDivision == 0) {
                                            listDep = PstDepartment.list(0, 0, "hr_department.VALID_STATUS=1", "");
                                        } else {
                                            listDep = PstDepartment.list(0, 0, "hr_department." + PstDepartment.fieldNames[PstDepartment.FLD_DIVISION_ID] + " = " + oidDivision + " AND hr_department.VALID_STATUS=1", "");
                                        }

                                        Hashtable hashDiv = PstDivision.listMapDivisionName(0, 0, "", "");
                                        long tempDivOid = 0;
                                        for (int i = 0; i < listDep.size(); i++) {
                                            Department dep = (Department) listDep.get(i);

                                            if (dep.getDivisionId() != tempDivOid) {
                                                dep_key.add("--" + hashDiv.get(dep.getDivisionId()) + "--");
                                                dep_value.add(String.valueOf(-1));
                                                tempDivOid = dep.getDivisionId();
                                            }

                                            dep_key.add(dep.getDepartment());
                                            dep_value.add(String.valueOf(dep.getOID()));
                                        }
                                    %>

                                    <%= ControlCombo.drawStringArraySelected("department", "chosen-select", null, oidDept, dep_key, dep_value, null, "size=8 multiple data-placeholder='Select Unit...' style='width:100%'")%> 
                                </div>
                                
                                <%--
                                <div id="caption">NRK</div>
                                <div id="divinput">
                                    <input type="text" name="emp_number" id="emp_number" value="<%=empNumber%>" style="width: 98%">
                                </div>
                                --%>
                                
                                <div id="caption">Symbol</div>
                                <div id="divinput">
                                    <%
                                        Vector symbol_value = new Vector(1, 1);
                                        Vector symbol_key = new Vector(1, 1);
                                        String placeHolderSchedule = "data-placeholder='Select Symbol...'";
                                        String multipleSchedule = "multiple";
                                        Vector<ScheduleSymbol> listSymbol = PstScheduleSymbol.list(0, 0, "", PstScheduleSymbol.fieldNames[PstScheduleSymbol.FLD_SYMBOL]);
                                        for (int i = 0; i < listSymbol.size(); i++) {
                                            ScheduleSymbol symbol = (ScheduleSymbol) listSymbol.get(i);
                                            symbol_key.add(symbol.getSymbol());
                                            symbol_value.add(String.valueOf(symbol.getOID()));
                                        }
                                    %>
                                    <%= ControlCombo.drawStringArraySelected("schedule_id", "chosen-select", null, oidSchedule, symbol_key, symbol_value, null, multipleSchedule + " " + placeHolderSchedule + " style='width:100%'")%>
                                </div>
                                <div id="caption">Group Berdasar</div>
                                <div id="divinput">
                                    <select name="group" class="chosen-select" style="width: 100%">
                                        <%
                                            for (int i=0; i < groupTitle.length;i++){
                                                %><option value="<%=i%>" <%=(group == i ? "selected" : "")%>><%=groupTitle[i]%></option><%
                                            }
                                        %>
                                    </select>
                                </div>
                            </td>
                            <td valign="top" style="padding-right: 20px;">
                                <div id="caption">Satuan Kerja</div>
                                <div id="divinput">
                                    <%

                                        Vector div_value = new Vector(1, 1);
                                        Vector div_key = new Vector(1, 1);

                                        Vector listDiv = new Vector();
                                        String placeHolder = "";
                                        String multipleDiv = "";
                                        if (oidDivision == 0) {
                                            listDiv = PstDivision.list(0, 0, "VALID_STATUS=1", "");
                                            placeHolder = "data-placeholder='Select Satuan Kerja...'";
                                            multipleDiv = "multiple";
                                        } else {
                                            listDiv = PstDivision.list(0, 0, PstDivision.fieldNames[PstDivision.FLD_DIVISION_ID] + " = " + emplx.getDivisionId() + " AND VALID_STATUS=1", PstDivision.fieldNames[PstDivision.FLD_DIVISION_ID]);
                                        }

                                        for (int i = 0; i < listDiv.size(); i++) {
                                            Division div = (Division) listDiv.get(i);
                                            div_key.add(div.getDivision());
                                            div_value.add(String.valueOf(div.getOID()));
                                        }
                                    %>
                                    <%= ControlCombo.drawStringArraySelected("division_id", "chosen-select", null, oidDiv, div_key, div_value, null, multipleDiv + " " + placeHolder + " style='width:100%'")%> 
                                </div>
                                
                                <div id="caption">Sub Unit</div>
                                <div id="divinput">
                                    <%

                                        Vector sec_value = new Vector(1, 1);
                                        Vector sec_key = new Vector(1, 1);

                                        Vector listSec = new Vector();

                                        if (oidDivision == 0) {
                                            listSec = PstSection.list(0, 0, "VALID_STATUS=1", "DEPARTMENT_ID");
                                        } else {
                                            listSec = PstSection.list(0, 0, PstSection.fieldNames[PstSection.FLD_DEPARTMENT_ID] + " = " + emplx.getDepartmentId(), "DEPARTMENT_ID");
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
                                    <%= ControlCombo.drawStringArraySelected("section", "chosen-select", null, oidSec, sec_key, sec_value, null, "multiple data-placeholder='Select Sub Unit...' style='width:100%'")%>
                                </div>
                                
                                <%--
                                <div id="caption">Nama Karyawan</div>
                                <div id="divinput">
                                    <input type="text" name="full_name" id="full_name" value="<%=empName%>" style="width: 98%">                                
                                </div>
                                --%>
                                
                                <div id="caption">Tanggal</div>
                                <div id="divinput">
                                    <input type="text" name="date_from" id="date_from" value="<%=dateFrom%>" class="datetimepicker" />
                                    <span id="caption">To</span>
                                    <input type="text" name="date_to" id="date_to" value="<%=dateTo%>" class="datetimepicker" />
                                </div>
                            </td>
                            <td valign="top" style="max-width: 400px">
                                <div id="caption">Waktu</div>
                                <div id="divinput">
                                    <%  String checkIn = "";
                                        String checkOut = "";
                                        if (prType== 0) {
                                            checkIn = "checked";
                                        } else {
                                            checkOut = "checked";
                                        }
                                    %>
                                    <input type="radio" name="presence_type" value="0" style="border-color:'#DDDDDD'" <%=checkIn%> class="pr_type" onclick="javascript:changeTimeValue()">&nbsp;Time In
                                    <input type="radio" name="presence_type" value="1" style="border-color:'#DDDDDD'" <%=checkOut%> class="pr_type" onclick="javascript:changeTimeValue()">&nbsp;Time Out
                                    <div id="multiple_time">
                                        <%
                                            if (multipleTime == null) {
                                        %>
                                        <span style="display: inline-block">
                                            <input type="text" size="15" class="" name="multi_time" value="07:30" style="margin-bottom: 4px" id="time1">
                                            <a onclick="javascript:removeTime(this)" class="btn" style="color:#FFF; font-size: 14px; padding: 3px 9px; background-color: #f05656; cursor: pointer"><b>-</b></a>
                                        </span>
                                        <span style="display: inline-block">
                                            <input type="text" size="15" class="" name="multi_time" value="07:45" style="margin-bottom: 4px" id="time2">
                                            <a onclick="javascript:removeTime(this)" class="btn" style="color:#FFF; font-size: 14px; padding: 3px 9px; background-color: #f05656; cursor: pointer"><b>-</b></a>
                                        </span>
                                        <span style="display: inline-block">
                                            <input type="text" size="15" class="" name="multi_time" value="08:00" style="margin-bottom: 4px" id="time3">
                                            <a onclick="javascript:removeTime(this)" class="btn" style="color:#FFF; font-size: 14px; padding: 3px 9px; background-color: #f05656; cursor: pointer"><b>-</b></a>
                                        </span>
                                        <%
                                            } else {
                                                int i = 1;
                                                for (String s : multipleTime) {
                                        %>
                                        <span style="display: inline-block">
                                            <input type="text" size="15" class="" name="multi_time" value="<%=s%>" style="margin-bottom: 4px" id="time<%=i%>">
                                            <a onclick="javascript:removeTime(this)" class="btn" style="color:#FFF; font-size: 14px; padding: 3px 9px; background-color: #f05656; cursor: pointer"><b>-</b></a>
                                        </span>
                                        <%
                                                i++;
                                                }
                                                
                                            }
                                        %>
                                    </div>
                                    <div style="margin-top: 3px">
                                        <a onclick="javascript:addTime()" class="btn" style="color:#FFF; font-size: 14px; padding: 3px 9px; background-color: #25ce0c; cursor: pointer"><b>+</b></a>
                                    </div>
                                </div>

                                <%--
                                <div id="caption">Warna Grafik</div>
                                <div id="divinput">
                                    <input type="radio" name="gradient" <%= (useGradientColor == 0 ? "checked" : "") %> value="0"> Acak
                                    <input type="radio" name="gradient" <%= (useGradientColor == 1 ? "checked" : "") %> value="1"> Hinjau > Merah
                                    <input type="radio" name="gradient" <%= (useGradientColor == 2 ? "checked" : "") %> value="2"> Biru > Merah
                                </div>
                                --%>
                            </td>
                        </tr>
                        <tr><td>&nbsp;</td></tr>
                        <tr>
                            <td>
                                <div>
                                    <a href="javascript:cmdSearch()" class="btn" style="color:#FFF;">Search</a>
                                    <a href="javascript:cmdExport()" class="btn" style="color:#FFF;">Print Preview</a>
                                </div>
                            </td> 
                        </tr>
                    </table>
                </div>

                <% if (iCommand == Command.LIST) { %>
                <h4 id="title"><strong>Grafik Kehadiran Karyawan</strong></h4>
                    
                <div style="overflow: auto;">
                    <table class="tblStyle" border="1" id="table">
                        <tr>
                            <td class="title_tbl" rowspan="2" style="text-align:center; vertical-align:middle">No.</td>
                            <td class="title_tbl" rowspan="2" style="text-align:center; vertical-align:middle"><%= groupTitle[group] %></td>
                            <td class="title_tbl" rowspan="2" style="text-align:center; vertical-align:middle">Jumlah Data</td>
                            <td class="title_tbl" colspan="<%= listHeader.size() + 2 %>" style="text-align:center; vertical-align:middle">Kriteria (%)</td>
                            <td class="title_tbl" rowspan="2" style="text-align:center; vertical-align:middle">Total (%)</td>
                        </tr>
                        <tr>
                            <%
                                for (String s : listHeader) {
                            %>
                            
                            <td class="title_tbl" style="text-align:center; vertical-align:middle; white-space: nowrap"><%= s %></td>
                            
                            <%
                                }
                            %>
                            <td class="title_tbl" style="text-align:center; vertical-align:middle">Data Absensi Kosong (Dengan Keterangan)</td>
                            <td class="title_tbl" style="text-align:center; vertical-align:middle">Data Absensi Kosong (Tanpa Keterangan)</td>
                        </tr>

                        <%
                            int no = 0;
                            int totalData = 0;
                            double totalInvalidWithNote = 0;
                            double totalInvalidWithoutNote = 0;
                            
                            //set total per time
                            Map<String, Double> mapTotalPerTime = new HashMap();
                            for (String s : listHeader) {
                                mapTotalPerTime.put(s, 0.0);
                            }
                            
                            
                            Vector tempCategories = new Vector();
                            Vector tempDataPerTime = new Vector();
                            Vector tempDetail = new Vector();
                            
                            String invWithNoteTitle = "Data Absensi Kosong (Dengan Ket.)";
                            String invWithoutNoteTitle = "Data Absensi Kosong (Tanpa Ket.)";
                            
                            for (Vector vGroup : listDataPerGroup) {
                                Company company = (Company) vGroup.get(0);
                                Division division = (Division) vGroup.get(1);
                                Department department = (Department) vGroup.get(2);
                                Section section = (Section) vGroup.get(3);
                                Employee employee = (Employee) vGroup.get(4);
                                ScheduleSymbol symbol = (ScheduleSymbol) vGroup.get(5);
                                
                                JSONArray jaCategories = new JSONArray(); //set total per group
                                JSONObject joDataPerTime = new JSONObject(); //set json data per time
                                
                                String groupName = "";
                                long groupId = 0;
                                if (groupBy[group].equals("COMPANY_ID")) {
                                    groupName = company.getCompany();
                                    groupId = company.getOID();
                                } else if (groupBy[group].equals("DIVISION_ID")) {
                                    groupName = division.getDivision();
                                    groupId = division.getOID();
                                } else if (groupBy[group].equals("DEPARTMENT_ID")) {
                                    groupName = department.getDepartment();
                                    groupId = department.getOID();
                                } else if (groupBy[group].equals("SECTION_ID")) {
                                    groupName = section.getSection();
                                    groupId = section.getOID();
                                } else if (groupBy[group].equals("EMPLOYEE_ID")) {
                                    groupName = "" + employee.getEmployeeNum() + " &nbsp; &nbsp; " + employee.getFullName();
                                    groupId = employee.getOID();
                                } else if (groupBy[group].equals("SCHEDULE_ID")) {
                                    groupName = "<center>All</center>";
                                    groupId = 0;
                                }
                                
                                Map<String, Integer> mapTime = SessEmpSchedule.mapPresencePerRangeTimePerDepartmentV2(empSchedule, listHeader, groupId, prType, groupBy[group]);
                                int totalEmp = 0;
                                Iterator it = mapTime.entrySet().iterator();
                                while (it.hasNext()) {
                                    Map.Entry pair = (Map.Entry)it.next();
                                    try {
                                        totalEmp += Integer.valueOf(""+pair.getValue());
                                    } catch (Exception exc){}
                                    //it.remove();
                                }
                                totalData += totalEmp;
                                out.print("<tr>");
                                out.print("<td style='background-color: #f1f1f1'>" + (no + 1) + ".</td>");
                                out.print("<td style='background-color: #f1f1f1'>" + groupName + "</td>");
                                out.print("<td style='background-color: #f1f1f1; text-align: center'>" + totalEmp + "</td>");
                                
                                double totalPresencePerGroup = 0;
                                int totalPresence = 0;
                                for (String s : listHeader) {
                                    int presence = mapTime.get(s) == null ? 0 : mapTime.get(s);
                                    totalPresence += presence;
                                    
                                    double presencePercentage = presence == 0 ? 0 : Double.valueOf(presence) / totalEmp * 100;
                                    totalPresencePerGroup += presencePercentage;
                                    
                                    out.print("<td style='text-align: center; background-color: white'>" + String.format("%.1f", presencePercentage) + "</td>");
                                    
                                    //SET TOTAL PER TIME
                                    double timeTotal = mapTotalPerTime.get(s);
                                    mapTotalPerTime.put(s, timeTotal + presencePercentage);
                                    
                                    //SET JSON VALUE FOR DATA PER TIME
                                    joDataPerTime.append(s, presencePercentage);
                                }
                                
                                
                                double invalidWithNote = 0;
                                double invalidWithoutNote = 0;
                                try {
                                    int invalidNote = mapTime.get("INVALID_OK") == null ? 0 : mapTime.get("INVALID_OK");
                                    invalidWithNote = invalidNote == 0 ? 0 : Double.valueOf(invalidNote) / totalEmp * 100;
                                    totalPresencePerGroup += invalidWithNote;
                                    totalInvalidWithNote += invalidWithNote;
                                } catch (Exception exc){}
                                
                                try {
                                    int invalidNoNote = mapTime.get("INVALID") == null ? 0 : mapTime.get("INVALID");
                                    invalidWithoutNote = invalidNoNote == 0 ? 0 : Double.valueOf(invalidNoNote) / totalEmp * 100;
                                    totalPresencePerGroup += invalidWithoutNote;
                                    totalInvalidWithoutNote += invalidWithoutNote;
                                } catch (Exception exc){}
                                
                                
                                
//                                if (totalPresence < symbol.getWorkDays()) {
//                                    //CEK JUMLAH INVALID DENGAN KETERANGAN
//                                    int invalid = SessEmpSchedule.getInvalidPresenceWithNote(empSchedule, groupId);
//                                    int cuti = SessEmpSchedule.getCutiPerDepartment(empSchedule, groupId);
//                                    if (cuti == 0 && symbol.getWorkDuration()== 0){
//                                        cuti = 1;
//                                    }
//                                    int invalidNote = invalid + cuti;
//                                    invalidWithNote = invalidNote == 0 ? 0 : Double.valueOf(invalidNote) / symbol.getWorkDays() * 100;
//                                    totalPresencePerGroup += invalidWithNote;
//                                    totalInvalidWithNote += invalidWithNote;
//                                    
//                                    //HITUNG JUMLAH INVALID TANPA KETERANGAN
//                                    int invalidNoNote = symbol.getWorkDays() - totalPresence - invalidNote;
//                                    invalidWithoutNote = invalidNoNote == 0 ? 0 : Double.valueOf(invalidNoNote) / symbol.getWorkDays() * 100;
//                                    totalPresencePerGroup += invalidWithoutNote;
//                                    totalInvalidWithoutNote += invalidWithoutNote;
//                                }
//                                
//                                //SET JSON VALUE FOR DATA PER TIME (TAMBAHAN)
                                joDataPerTime.append(invWithNoteTitle, invalidWithNote);
                                joDataPerTime.append(invWithoutNoteTitle, invalidWithoutNote);
//                                
                                out.print("<td style='text-align: center; background-color: white'>" + String.format("%.1f", invalidWithNote) + "</td>");
                                out.print("<td style='text-align: center; background-color: white'>" + String.format("%.1f", invalidWithoutNote) + "</td>");
                                out.print("<td style='text-align: center; background-color: white'>" + String.format("%.1f", totalPresencePerGroup) + "</td>");
                                out.print("</tr>");
                                no++;

                                //SET GRAFIK CATEGORY
                                jaCategories.put(groupName);
                                tempCategories.add(jaCategories);
                                tempDataPerTime.add(joDataPerTime);
                                if (groupBy[group].equals("SCHEDULE_ID")) {
                                    //JIKA GROUP BY SYMBOL PROSES LOOPING 1 KALI SAJA KARENA ISI DATA SAMA
                                    break;
                                }
                            }
                            
                            //==================== SET GRAFIK DATA ====================
                            
                            if (!listDataPerGroup.isEmpty()) {
                                //SET GRAFIK COLOR
                                JSONArray jaColor = new JSONArray();
                                //>>> auto change color
                                useGradientColor = 1;
                                if (multipleTime.length > 4) {
                                    useGradientColor = 2;
                                }
                                //<<<
                                if (useGradientColor > 0) {
                                    try {
                                        double x = 1D / multipleTime.length;
                                        int[] colorOption = {0, 100, 200};
                                        int baseColor = colorOption[useGradientColor];
                                        for (int i = 0; i <= multipleTime.length; i++) {
                                            double hue = (1 - (i * x)) * baseColor;
                                            jaColor.put("hsl(" + hue + ", 100%, 50%)");
                                        }
                                    } catch (Exception e) {
                                        useGradientColor = 0;
                                        System.out.print(e.getMessage());
                                    }
                                }

                                //SET GRAFIK SERIES DATA
                                for (int x =0; x < tempCategories.size(); x++){
                                    JSONObject joDataPerTime = (JSONObject) tempDataPerTime.get(x);
                                    JSONObject joSeriesData = new JSONObject();
                                    JSONArray jaSeries = new JSONArray();
                                    int i = 0;
                                    if (prType == 0){
                                        i = 0;
                                    } else {
                                        i = listHeader.size()-1;
                                    }
                                    for (String s : listHeader) {
                                        joSeriesData = new JSONObject();
                                        if (useGradientColor > 0) {
                                            joSeriesData.put("color", jaColor.get(i));
                                        }
                                        joSeriesData.put("name", s);
                                        joSeriesData.put("data", joDataPerTime.get(s));
                                        jaSeries.put(joSeriesData);
                                        if (prType == 0){
                                            i++;
                                        } else {
                                            i--;
                                        }
                                    }
                                    //>>> TAMBAHAN
                                    joSeriesData = new JSONObject();
                                    joSeriesData.put("color","hsl(280, 100%, 50%)");
                                    joSeriesData.put("name", invWithNoteTitle);
                                    joSeriesData.put("data", joDataPerTime.get(invWithNoteTitle));
                                    jaSeries.put(joSeriesData);

                                    joSeriesData = new JSONObject();
                                    joSeriesData.put("color","hsl(200, 100%, 50%)");
                                    joSeriesData.put("name", invWithoutNoteTitle);
                                    joSeriesData.put("data", joDataPerTime.get(invWithoutNoteTitle));
                                    jaSeries.put(joSeriesData);
                                    tempDetail.add(jaSeries);
                                }
                            }
                            
                            //==================== SET TOTAL DATA KEHADIRAN ====================
                            if (!listDataPerGroup.isEmpty()) {
                                out.print("<tr>");
                                out.print("<td colspan='2' style='text-align: center; background-color: #e3e3e3'><b>Total</b></td>");
                                out.print("<td style='text-align: center; background-color: #e3e3e3'><b>" + totalData + "</b></td>");
                                
                                double grandTotal = 0;
                                for (String s : listHeader) {
                                    double totalPerTime = mapTotalPerTime.get(s) / listDataPerGroup.size();
                                    grandTotal += totalPerTime;
                                    out.print("<td style='text-align: center; background-color: #e3e3e3'><b>" + String.format("%.1f", totalPerTime) + "</b></td>");
                                }
                                totalInvalidWithNote = totalInvalidWithNote / listDataPerGroup.size();
                                totalInvalidWithoutNote = totalInvalidWithoutNote / listDataPerGroup.size();
                                grandTotal += totalInvalidWithNote + totalInvalidWithoutNote;
                                
                                out.print("<td style='text-align: center; background-color: #e3e3e3'><b>" + String.format("%.1f", totalInvalidWithNote) + "</b></td>");
                                out.print("<td style='text-align: center; background-color: #e3e3e3'><b>" + String.format("%.1f", totalInvalidWithoutNote) + "</b></td>");
                                out.print("<td style='text-align: center; background-color: #e3e3e3'><b>" + String.format("%.1f", grandTotal) + "</b></td>");
                                out.print("</tr>");
                            }
                            
                        %>
                        
                        <% if (listDataPerGroup.isEmpty()) { %>
                        <tr>
                            <td colspan="<%= (listHeader.size() + 6) %>" style="text-align: center; background-color: #ccc">Tidak ada data</td>
                        </tr>
                        <% } %>
                    </table>
                </div>

                <!-- DRAW GRAFIK -->
                <% if (!listDataPerGroup.isEmpty()) { 
                    if (!tempCategories.isEmpty()) {
                        for (int i = 0 ; i < tempCategories.size(); i++){
                            JSONArray jaCategories = (JSONArray) tempCategories.get(i);
                            JSONArray jaSeries = (JSONArray) tempDetail.get(i);
                        %>
                            <br>
                            <div id="container<%=i%>"></div>
                            <script>
                                Highcharts.chart('container<%=i%>', {
                                    chart: {
                                        type: 'column'
                                    },
                                    title: {
                                        text: 'Grafik Kehadiran Karyawan'
                                    },
                                    subtitle: {
                                        text: '<%= Formater.formatDate(empSchedule.getFromDate(), "dd MMMM yyyy") %> - <%= Formater.formatDate(empSchedule.getToDate(), "dd MMMM yyyy") %>'
                                    },
                                    xAxis: {
                                        categories: <%= jaCategories %>,
                                        crosshair: true
                                    },
                                    yAxis: {
                                        min: 0,
                                        title: {
                                            text: 'Persentase kehadiran %'
                                        }
                                    },
                                    tooltip: {
                                        headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
                                        pointFormat: ''
                                                +'<tr>'
                                                +'<td style="color:{series.color};padding:0"><b>{series.name}</b></td>'
                                                +'<td><b>&nbsp;:&nbsp;</b></td>'
                                                +'<td style="padding:0;text-align:right"><b>{point.y:.1f} %</b></td>'
                                                +'</tr>',
                                        footerFormat: '</table>',
                                        shared: true,
                                        useHTML: true
                                    },
                                    plotOptions: {
                                        column: {
                                            pointPadding: 0.2,
                                            borderWidth: 0
                                        }
                                    },
                                    credits:{
                                      enabled: false  
                                    },
                                    series: <%= jaSeries %>
                                });
                            </script>
                        <%
                        }
                    }
                %>
                
                <% } %>

                <% } %>
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
                '.chosen-select': {},
                '.chosen-select-deselect': {allow_single_deselect: true},
                '.chosen-select-no-single': {disable_search_threshold: 10},
                '.chosen-select-no-results': {no_results_text: 'Oops, nothing found!'},
                '.chosen-select-width': {width: "100%"}
            };

            for (var selector in config) {
                $(selector).chosen(config[selector]);
            }

            var removeTbl = <%=removeTable%>;
            if (removeTbl === 1) {
                $("#table").remove();
                $("h4#title").text("No Data Available");
            }
        </script>
    </body>
</html>

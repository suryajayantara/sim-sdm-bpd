<%-- 
    Document   : rekap_kehadiran_per_symbol
    Created on : Apr 9, 2019, 1:35:50 PM
    Author     : Dimata 007
--%>

<%@page import="com.dimata.harisma.session.attendance.SessEmpSchedule"%>
<%@page import="com.dimata.util.Command"%>
<%@page import="com.dimata.util.Formater"%>
<%@page import="com.dimata.gui.jsp.ControlCombo"%>
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
    long oidCompanyany = 0;
    long oidDivisionision = 0;
    String strDisable = "";
    String strDisableNum = "";
    if (appUserSess.getAdminStatus() == 0 && !privViewAllDivision) {
        oidCompanyany = emplx.getCompanyId();
        oidDivisionision = emplx.getDivisionId();
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
    long oidPeriod = FRMQueryString.requestLong(request, "period_id");
    String[] oidMultiCompany = FRMQueryString.requestStringValues(request, "company_id");
    String[] oidMultiDivision = FRMQueryString.requestStringValues(request, "division_id");
    String[] oidMultDepartment = FRMQueryString.requestStringValues(request, "department_id");
    String[] oidMultSection = FRMQueryString.requestStringValues(request, "section_id");
    String[] oidMultSchedule = FRMQueryString.requestStringValues(request, "schedule_id");
    String empNumber = FRMQueryString.requestString(request, "emp_number");
    String empName = FRMQueryString.requestString(request, "full_name");
    String dateFrom = FRMQueryString.requestString(request, "date_from");
    String dateTo = FRMQueryString.requestString(request, "date_to");
    int group = FRMQueryString.requestInt(request, "group_by");
    
    if (dateFrom.isEmpty()) {
        dateFrom = Formater.formatDate(new Date(), "yyyy-MM-dd");
    }
    
    if (dateTo.isEmpty()) {
        dateTo = Formater.formatDate(new Date(), "yyyy-MM-dd");
    }
    
    if (iCommand == Command.NONE) {
        Date now = new Date();
        String wherePeriod = " MONTH(" + PstPeriod.fieldNames[PstPeriod.FLD_START_DATE] + ") = '" + Formater.formatDate(now, "MM") + "'"
                + " AND YEAR(" + PstPeriod.fieldNames[PstPeriod.FLD_START_DATE] + ") = '" + Formater.formatDate(now, "yyyy") + "'";
        Vector<Period> listPeriod = PstPeriod.list(0, 1, wherePeriod, "");
        for (Period p : listPeriod) {
            oidPeriod = p.getOID();
        }
    }

    String[] groupTitle = {"Perusahaan","Satuan Kerja","Unit Kerja","Sub Unit","Karyawan"};
    String[] groupBy = {"COMPANY_ID","DIVISION_ID","DEPARTMENT_ID","SECTION_ID","EMPLOYEE_ID"};
    String[] orderBy = {"COMPANY_NAME","DIVISION_NAME","DEPARTMENT_NAME","SECTION_NAME","EMPLOYEE_NAME"};
    
    Vector listHeaderSymbol = new Vector();
    Vector<Vector> listGroupName = new Vector();
    Vector<Vector> listDataPerGroup = new Vector();
    Map<Long, Map> mapGroupData = new HashMap();
    
    SessEmpSchedule empSchedule = new SessEmpSchedule();
    String inCompany = (oidMultiCompany == null) ? "" : Arrays.toString(oidMultiCompany);
    inCompany = (inCompany.isEmpty()) ? "" : inCompany.substring(1, inCompany.length() - 1);
    empSchedule.setInCompany(inCompany);

    String inDivision = (oidMultiDivision == null) ? "" : Arrays.toString(oidMultiDivision);
    inDivision = (inDivision.isEmpty()) ? "" : inDivision.substring(1, inDivision.length() - 1);
    empSchedule.setInDivision(inDivision);

    String inDepartment = (oidMultDepartment == null) ? "" : Arrays.toString(oidMultDepartment);
    inDepartment = (inDepartment.isEmpty()) ? "" : inDepartment.substring(1, inDepartment.length() - 1);
    empSchedule.setInDepartment(inDepartment);

    String inSection = (oidMultSection == null) ? "" : Arrays.toString(oidMultSection);
    inSection = (inSection.isEmpty()) ? "" : inSection.substring(1, inSection.length() - 1);
    empSchedule.setInSection(inSection);

    String inSchedule = (oidMultSchedule == null) ? "" : Arrays.toString(oidMultSchedule);
    inSchedule = (inSchedule.isEmpty()) ? "" : inSchedule.substring(1, inSchedule.length() - 1);
    empSchedule.setInSchedule(inSchedule);
    
    if (!dateFrom.isEmpty()) {
        empSchedule.setFromDate(Formater.formatDate(dateFrom, "yyyy-MM-dd"));
    }
    if (!dateTo.isEmpty()) {
        empSchedule.setToDate(Formater.formatDate(dateTo, "yyyy-MM-dd"));
    }
    
    if (iCommand == Command.LIST) {
        empSchedule.setPeriod(oidPeriod);
        empSchedule.setEmpNum(empNumber);
        empSchedule.setEmpFullName(empName);
        
        listHeaderSymbol = PstScheduleSymbol.list(0, 0, PstScheduleSymbol.fieldNames[PstScheduleSymbol.FLD_SCHEDULE_ID]+" IN ("+empSchedule.getInSchedule()+")", "");
        listGroupName = SessEmpSchedule.listPresenceByScheduleSymbolWithRangeDate(empSchedule, groupBy[group], orderBy[group], 1);
        listDataPerGroup = SessEmpSchedule.listPresenceByScheduleSymbolWithRangeDate(empSchedule, groupBy[group], orderBy[group], 0);
        
        long groupKey = 0;
        for (Vector vGroup : listGroupName) {
            Company company = (Company) vGroup.get(0);
            Division division = (Division) vGroup.get(1);
            Department department = (Department) vGroup.get(2);
            Section section = (Section) vGroup.get(3);
            Employee employee = (Employee) vGroup.get(4);
            ScheduleSymbol symbol = (ScheduleSymbol) vGroup.get(5);
            
            //CEK GROUP TYPE
            long idGroup = 0;
            if (groupBy[group].equals("COMPANY_ID")) {
                groupKey = company.getOID();
                idGroup = company.getOID();
            } else if (groupBy[group].equals("DIVISION_ID")) {
                groupKey = division.getOID();
                idGroup = division.getOID();
            } else if (groupBy[group].equals("DEPARTMENT_ID")) {
                groupKey = department.getOID();
                idGroup = department.getOID();
            } else if (groupBy[group].equals("SECTION_ID")) {
                groupKey = section.getOID();
                idGroup = section.getOID();
            } else if (groupBy[group].equals("EMPLOYEE_ID")) {
                groupKey = employee.getOID();
                idGroup = employee.getOID();
            } else if (groupBy[group].equals("SCHEDULE_ID")) {
                groupKey = 0;
                idGroup = 0;
            }
            
            //SET GROUP DATA
            Map<String, Integer> mapData = new HashMap();
            mapData = setGroupData(groupBy[group], idGroup, listDataPerGroup);

            //SET GROUP KEY
            mapGroupData.put(groupKey, mapData);
            
            if (groupBy[group].equals("SCHEDULE_ID")) {
                //JIKA GROUP BY SYMBOL MAKA DATA GROUP CUKUP DI SET 1 KALI SAJA
                break;
            }
        }
    }
    int removeTable = 0;
    
%>

<%!//
    public static Map<String, Integer> setGroupData(String groupBy, long idGroup, Vector<Vector> vectorData) {
        Map<String, Integer> listData = new HashMap();
        for (Vector vData : vectorData) {
            Company company = (Company) vData.get(0);
            Division division = (Division) vData.get(1);
            Department department = (Department) vData.get(2);
            Section section = (Section) vData.get(3);
            Employee employee = (Employee) vData.get(4);
            ScheduleSymbol symbol = (ScheduleSymbol) vData.get(5);
            
            if (groupBy.equals("COMPANY_ID")) {
                if (idGroup == company.getOID()) {
                    listData.put(symbol.getSymbol(), symbol.getWorkDays());
                }
            } else if (groupBy.equals("DIVISION_ID")) {
                if (idGroup == division.getOID()) {
                    listData.put(symbol.getSymbol(), symbol.getWorkDays());
                }
            } else if (groupBy.equals("DEPARTMENT_ID")) {
                if (idGroup == department.getOID()) {
                    listData.put(symbol.getSymbol(), symbol.getWorkDays());
                }
            } else if (groupBy.equals("SECTION_ID")) {
                if (idGroup == section.getOID()) {
                    listData.put(symbol.getSymbol(), symbol.getWorkDays());
                }
            } else if (groupBy.equals("EMPLOYEE_ID")) {
                if (idGroup == employee.getOID()) {
                    listData.put(symbol.getSymbol(), symbol.getWorkDays());
                }
            } else if (groupBy.equals("SCHEDULE_ID")) {
                listData.put(symbol.getSymbol(), symbol.getWorkDays());
            }
        }
        return listData;
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>HARISMA - Report Presence Per Schedule Symbol</title>
        <link rel="stylesheet" href="../../styles/main.css" type="text/css">
        <%@ include file = "../../main/konfigurasi_jquery.jsp" %>    
        <script src="../../javascripts/jquery.min-1.6.2.js" type="text/javascript"></script>
        <script src="../../javascripts/chosen.jquery.js" type="text/javascript"></script>
        <link rel="stylesheet" href="../../stylesheets/chosen.css" >
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
            
            .chosen-container {width: 100%!important}

        </style>
        <script language="JavaScript">
            function reloadForChange() {
                document.frpresence.command.value = "<%=String.valueOf(Command.NONE)%>";
                document.frpresence.action = "rekap_kehadiran_per_symbol.jsp";
                document.frpresence.submit();
            }
            function cmdSearch() {
                document.frpresence.command.value = "<%=String.valueOf(Command.LIST)%>";
                document.frpresence.action = "rekap_kehadiran_per_symbol.jsp";
                document.frpresence.submit();
            }
            function cmdExport() {
                document.frpresence.command.value = "<%=String.valueOf(Command.LIST)%>";
                document.frpresence.action = "export_excel/rekap_kehadiran_per_symbol.jsp";
                document.frpresence.submit();
            }

        </script>
        <link rel="stylesheet" href="<%=approot%>/javascripts/datepicker/themes/jquery.ui.all.css"/>
        <link rel="stylesheet" href="<%=approot%>/javascripts/datepicker/themes/jquery.ui.timepicker.addon.css"/>

        <script src="<%=approot%>/javascripts/datepicker/jquery.ui.core.js"></script>
        <script src="<%=approot%>/javascripts/datepicker/jquery.ui.widget.js"></script>
        <script src="<%=approot%>/javascripts/datepicker/jquery.ui.datepicker.js"></script>
        <script src="<%=approot%>/javascripts/datepicker/jquery.ui.timepicker.addon.js"></script>

        <script>
            $(function () {
                $("#datetimepicker").datetimepicker({
                    dateFormat: "yy-mm-dd"}
                );
                $(".datepicker").datepicker({dateFormat: "yy-mm-dd"});
            });
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
            <span id="menu_title">Laporan / Kehadiran / <strong>Kehadiran Berdasarkan Symbol</strong></span>
        </div>
        <div class="content-main">
            <form name="frpresence" method="post" action="">
                <input type="hidden" name="command" value="<%=iCommand%>">
                <input type="hidden" name="start" value="">
                <div class="formstyle">
                    <table>
                        <tr>
                            <td valign="top" style="width: 30%; padding-right: 21px;">
                                <div id="caption">Tanggal</div>
                                <div id="divinput">
                                    <input type="text" name="date_from" id="date_from" value="<%=dateFrom%>" class="datepicker" />
                                    <span id="caption">To</span>
                                    <input type="text" name="date_to" id="date_to" value="<%=dateTo%>" class="datepicker" />
                                </div>

                                <div id="caption">Unit Kerja</div>
                                <div id="divinput">
                                    <%
                                        Vector dep_value = new Vector(1, 1);
                                        Vector dep_key = new Vector(1, 1);
                                        
                                        String whereDepartment = PstDepartment.TBL_HR_DEPARTMENT + "." + PstDepartment.fieldNames[PstDepartment.FLD_VALID_STATUS] + " = " + PstDepartment.VALID_ACTIVE;
                                        if (empSchedule.getInDivision() != null && !empSchedule.getInDivision().isEmpty()) {
                                            whereDepartment += " AND " + PstDepartment.TBL_HR_DEPARTMENT + "." + PstDepartment.fieldNames[PstDepartment.FLD_DIVISION_ID] + " IN (" + empSchedule.getInDivision() + ")";
                                        }
                                        Vector listDep = listDep = PstDepartment.list(0, 0, whereDepartment, PstDepartment.fieldNames[PstDepartment.FLD_DEPARTMENT]);
                                        
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

                                    <%= ControlCombo.drawStringArraySelected("department_id", "chosen-select", null, oidMultDepartment, dep_key, dep_value, null, "multiple data-placeholder='Select Unit...' style='width:100%' onchange='reloadForChange()'")%> 
                                </div>

                                <div id="caption">NRK</div>
                                <div id="divinput">
                                    <input type="text" name="emp_number" id="emp_number" value="<%=empNumber%>" style="width: 98%">
                                </div>
                            </td>
                            <td valign="top" style="width: 30%; padding-right: 21px;">
                                <div id="caption">Perusahaan</div>
                                <div id="divinput">
                                    <%
                                        Vector com_value = new Vector(1, 1);
                                        Vector com_key = new Vector(1, 1);
                                        Vector listCom = PstCompany.list(0, 0, "", "");
                                        for (int i = 0; i < listCom.size(); i++) {
                                            Company company = (Company) listCom.get(i);
                                            com_key.add(company.getCompany());
                                            com_value.add(String.valueOf(company.getOID()));
                                        }
                                    %>
                                    <%= ControlCombo.drawStringArraySelected("company_id", "chosen-select", null, oidMultiCompany, com_key, com_value, null, "multiple data-placeholder='Select Company...' style='width:100%' onchange='reloadForChange()'")%> 
                                </div>

                                <div id="caption">Sub Unit</div>
                                <div id="divinput">
                                    <%

                                        Vector sec_value = new Vector(1, 1);
                                        Vector sec_key = new Vector(1, 1);

                                        String whereSection = PstSection.fieldNames[PstSection.FLD_VALID_STATUS] + " = " + PstSection.VALID_ACTIVE;
                                        if (empSchedule.getInDepartment() != null && !empSchedule.getInDepartment().isEmpty()) {
                                            whereSection += " AND " + PstSection.fieldNames[PstSection.FLD_DEPARTMENT_ID] + " IN (" + empSchedule.getInDepartment() + ")";
                                        }
                                        Vector listSec = PstSection.list(0, 0, whereSection, PstSection.fieldNames[PstSection.FLD_SECTION]);

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
                                    <%= ControlCombo.drawStringArraySelected("section_id", "chosen-select", null, oidMultSection, sec_key, sec_value, null, "multiple data-placeholder='Select Sub Unit...' style='width:100%' onchange='reloadForChange()'")%> 
                                </div>

                                <div id="caption">Nama Karyawan</div>
                                <div id="divinput">
                                    <input type="text" name="full_name" id="full_name" value="<%=empName%>" style="width: 98%">                                
                                </div>
                            </td>
                            <td valign="top" style="width: 30%;">
                                <div id="caption">Satuan Kerja</div>
                                <div id="divinput">
                                    <%

                                        Vector div_value = new Vector(1, 1);
                                        Vector div_key = new Vector(1, 1);

                                        String whereDivision = PstDivision.fieldNames[PstDivision.FLD_VALID_STATUS] + " = " + PstDivision.VALID_ACTIVE;
                                        if (empSchedule.getInCompany() != null && !empSchedule.getInCompany().isEmpty()) {
                                            whereDivision += " AND " + PstDivision.fieldNames[PstDivision.FLD_COMPANY_ID] + " IN (" + empSchedule.getInCompany() + ")";
                                        }
                                        Vector listDiv = PstDivision.list(0, 0, whereDivision, PstDivision.fieldNames[PstDivision.FLD_DIVISION]);
                                        String placeHolder = "data-placeholder='Select Satuan Kerja...'";
                                        String multipleDiv = "multiple";

                                        for (int i = 0; i < listDiv.size(); i++) {
                                            Division div = (Division) listDiv.get(i);
                                            div_key.add(div.getDivision());
                                            div_value.add(String.valueOf(div.getOID()));
                                        }
                                    %>
                                    <%= ControlCombo.drawStringArraySelected("division_id", "chosen-select", null, oidMultiDivision, div_key, div_value, null, multipleDiv + " " + placeHolder + " style='width:100%' onchange='reloadForChange()'")%> 
                                </div>

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
                                    <%= ControlCombo.drawStringArraySelected("schedule_id", "chosen-select", null, oidMultSchedule, symbol_key, symbol_value, null, multipleSchedule + " " + placeHolderSchedule + " style='width:100%'")%>
                                </div>

                                <div id="caption">Grup Berdasarkan</div>
                                <div id="divinput">
                                    <select name="group_by" id="" class="">
                                        <option <%= (group == 0 ? "selected" : "")%> value="0"><%= groupTitle[0] %></option>
                                        <option <%= (group == 1 ? "selected" : "")%> value="1"><%= groupTitle[1] %></option>
                                        <option <%= (group == 2 ? "selected" : "")%> value="2"><%= groupTitle[2] %></option>
                                        <option <%= (group == 3 ? "selected" : "")%> value="3"><%= groupTitle[3] %></option>
                                        <option <%= (group == 4 ? "selected" : "")%> value="4"><%= groupTitle[4] %></option>
                                    </select>
                                </div>
                            </td>
                        </tr>
                        <tr><td>&nbsp;</td></tr>
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
                <% if (iCommand == Command.LIST) { %>
                <h4 id="title"><strong>Laporan Kehadiran Karyawan Berdasarkan Symbol</strong></h4>
                
                <div style="overflow: auto;">
                    <table class="tblStyle" border="1" id="table">
                        <tr>
                            <td class="title_tbl" style="text-align:center; vertical-align:middle">No.</td>
                            <td class="title_tbl" style="text-align:center; vertical-align:middle"><%= groupTitle[group] %></td>
                            <%
                                for (int i=0; i < listHeaderSymbol.size(); i++) {
                                    ScheduleSymbol symbol = (ScheduleSymbol) listHeaderSymbol.get(i);
                            %>
                            <td class="title_tbl" style="text-align:center; vertical-align:middle"><%= symbol.getSymbol() %></td>
                            <%
                                }
                            %>
                            <td class="title_tbl" style="text-align:center; vertical-align:middle">Total</td>
                        </tr>

                        <%
                            int no = 0;
                            Vector listData = SessEmpSchedule.listRekapKehadiranBySymbol(empSchedule, oidMultSchedule, listHeaderSymbol, group);
                            int[] grandTotal = new int[listHeaderSymbol.size()];
                            for (int i=0; i < listData.size();i++){
                                Vector temp = (Vector) listData.get(i);
                                String name = (String) temp.get(0);
                                Map<String, Integer> mapTime = (Map<String, Integer>) temp.get(1);
                                
                                out.print("<tr>");
                                out.print("<td style='background-color: #f1f1f1'>" + (no + 1) + ".</td>");
                                out.print("<td style='background-color: #f1f1f1'>" + name + "</td>");
                                
                                int totalPerGroup = 0;
                                for (int xx=0; xx < listHeaderSymbol.size(); xx++) {
                                    ScheduleSymbol symbol = (ScheduleSymbol) listHeaderSymbol.get(xx);
                                    int total = (mapTime.get(symbol.getSymbol()) == null) ? 0 : mapTime.get(symbol.getSymbol());
                                    totalPerGroup += total;
                                    grandTotal[xx] = grandTotal[xx] + total;
                                    out.print("<td style='text-align: center; background-color: white'>" + total + "</td>");
                                }
                                out.print("<td style='text-align: center; background-color: #e3e3e3'><b>" + totalPerGroup + "</b></td>");
                                out.print("</tr>");
                                no++;
                            }
                            out.print("<tr>");
                            out.print("<td colspan='2' style='text-align: center; background-color: #e3e3e3'><b>Total Per Symbol</b></td>");
                            for (int i= 0; i < grandTotal.length; i++){
                                out.print("<td style='text-align: center; background-color: #e3e3e3'><b>"+grandTotal[i]+"</b></td>");
                            }
                            out.print("<td style='text-align: center; background-color: #e3e3e3'>&nbsp;</td>");
                            out.print("</tr>");
                            /*
                            for (Vector vGroup : listGroupName) {
                                Company company = (Company) vGroup.get(0);
                                Division division = (Division) vGroup.get(1);
                                Department department = (Department) vGroup.get(2);
                                Section section = (Section) vGroup.get(3);
                                Employee employee = (Employee) vGroup.get(4);

                                String groupName = "";
                                long groupKey = 0;
                                if (groupBy[group].equals("COMPANY_ID")) {
                                    groupName = company.getCompany();
                                    groupKey = company.getOID();
                                } else if (groupBy[group].equals("DIVISION_ID")) {
                                    groupName = division.getDivision();
                                    groupKey = division.getOID();
                                } else if (groupBy[group].equals("DEPARTMENT_ID")) {
                                    groupName = department.getDepartment();
                                    groupKey = department.getOID();
                                } else if (groupBy[group].equals("SECTION_ID")) {
                                    groupName = section.getSection();
                                    groupKey = section.getOID();
                                } else if (groupBy[group].equals("EMPLOYEE_ID")) {
                                    groupName = "" + employee.getEmployeeNum() + " &nbsp; &nbsp; " + employee.getFullName();
                                    groupKey = employee.getOID();
                                } else if (groupBy[group].equals("SCHEDULE_ID")) {
                                    groupName = "<center>All</center>";
                                    groupKey = 0;
                                }

                                out.print("<tr>");
                                out.print("<td style='background-color: #f1f1f1'>" + (no + 1) + ".</td>");
                                out.print("<td style='background-color: #f1f1f1'>" + groupName + "</td>");
                                int totalPerGroup = 0;
                                for (Vector vData : listHeaderSymbol) {
                                    ScheduleSymbol symbol = (ScheduleSymbol) vData.get(5);
                                    Map<String, Integer> data = mapGroupData.get(groupKey);
                                    int total = (data.get(symbol.getSymbol()) == null) ? 0 : data.get(symbol.getSymbol());
                                    totalPerGroup += total;
                                    out.print("<td style='text-align: center; background-color: white'>" + total + "</td>");
                                }
                                out.print("<td style='text-align: center; background-color: #e3e3e3'><b>" + totalPerGroup + "</b></td>");
                                out.print("</tr>");
                                no++;

                                if (groupBy[group].equals("SCHEDULE_ID")) {
                                    //JIKA GROUP BY SYMBOL PROSES LOOPING 1 KALI SAJA KARENA ISI DATA SAMA
                                    break;
                                }
                            }
                       
                            //show total per symbol
                            if (!listHeaderSymbol.isEmpty()) {
                                out.print("<tr>");
                                out.print("<td colspan='2' style='text-align: center; background-color: #e3e3e3'><b>Total Per Symbol</b></td>");
                                int grandTotal = 0;
                                for (Vector v : listHeaderSymbol) {
                                    ScheduleSymbol symbol = (ScheduleSymbol) v.get(5);
                                    grandTotal += symbol.getWorkDays();
                                    out.print("<td style='text-align: center; background-color: #e3e3e3'><b>" + symbol.getWorkDays() + "</b></td>");
                                }
                                out.print("<td style='text-align: center; background-color: #ccc'><b>" + grandTotal + "</b></td>");
                                out.print("</tr>");
                            }
                                    */
                        %>
                        
                        <% if (mapGroupData.isEmpty()) { %>
                        <tr>
                            <td colspan="3" style="text-align: center">Tidak ada data</td>
                        </tr>
                        <% } %>
                    </table>
                </div>
                
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

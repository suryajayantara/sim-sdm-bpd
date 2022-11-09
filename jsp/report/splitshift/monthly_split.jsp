<%@ page language="java" %>
<!-- package java -->
<%@ page import ="java.util.Date"%>
<%@ page import ="java.util.Vector"%>
<%@ page import ="java.util.Calendar"%>
<!-- package qdep -->
<%@ page import ="com.dimata.gui.jsp.*"%>
<%@ page import ="com.dimata.util.*"%>
<%@ page import ="com.dimata.qdep.form.*"%>
<!-- package harisma -->
<%@ page import ="com.dimata.harisma.entity.masterdata.*"%>
<%@ page import ="com.dimata.harisma.entity.employee.*"%>
<%@ page import ="com.dimata.harisma.session.attendance.*"%>

<%@ include file = "../../main/javainit.jsp" %>
<% int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_REPORTS, AppObjInfo.G2_SPLIT_SHIFT_REPORT, AppObjInfo.OBJ_SPLIT_SHIFT_MONTHLY_REPORT);%>
<%@ include file = "../../main/checkuser.jsp" %>

<%
    /* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
//boolean privPrint = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_PRINT));
%>
<!-- update by devin 2014-01-29  -->
<%
    /* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
//boolean privPrint = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_PRINT));
    long hrdDepOid = Long.parseLong(String.valueOf(PstSystemProperty.getPropertyLongbyName(OID_HRD_DEPARTMENT)));
    boolean isHRDLogin = hrdDepOid == departmentOid ? true : false;
    long edpSectionOid = Long.parseLong(String.valueOf(PstSystemProperty.getPropertyLongbyName(OID_EDP_SECTION)));
    boolean isEdpLogin = edpSectionOid == sectionOfLoginUser.getOID() ? true : false;
    boolean isGeneralManager = positionType == PstPosition.LEVEL_GENERAL_MANAGER ? true : false;
%>
<%!    int DATA_NULL = 0;
    int DATA_PRINT = 1;

    /**
     * create list object consist of : first index ==> status object (will
     * displayed or not) second index ==> object string will displayed third
     * index ==> object vector of string used in report on PDF format.
     */
    public Vector drawList(Vector listSplitShiftPresence, int dateOfMonth) {
        Vector result = new Vector(1, 1);
        if (listSplitShiftPresence != null && listSplitShiftPresence.size() > 0) {
            int startPeriod = Integer.parseInt(String.valueOf(PstSystemProperty.getValueByName("START_DATE_PERIOD")));
            ControlList ctrlist = new ControlList();
            ctrlist.setAreaWidth("100%");
            ctrlist.setListStyle("listgen");
            ctrlist.setTitleStyle("listgentitle");
            ctrlist.setCellStyle("listgensell");
            ctrlist.setHeaderStyle("listgentitle");
            ctrlist.addHeader("No", "2%", "2", "0");
            ctrlist.addHeader("Payroll", "6%", "2", "0");
            ctrlist.addHeader("Employee", "16%", "2", "0");
            ctrlist.addHeader("Duration (hours, minutes)", "70%", "0", "" + dateOfMonth);
            ctrlist.addHeader("" + startPeriod, "2%", "0", "0");
            for (int j = 0; j < dateOfMonth - 1; j++) {
                if (startPeriod == dateOfMonth) {
                    startPeriod = 1;
                    ctrlist.addHeader("" + startPeriod, "2%", "0", "0");
                } else {
                    startPeriod = startPeriod + 1;
                    ctrlist.addHeader("" + startPeriod, "2%", "0", "0");
                }

            }
            ctrlist.addHeader("Total", "3%", "2", "0");

            ctrlist.setLinkRow(0);
            ctrlist.setLinkSufix("");
            Vector lstData = ctrlist.getData();
            ctrlist.reset();

            // vector of data will used in pdf report
            Vector vectDataToPdf = new Vector(1, 1);

            int maxNightShiftPresence = listSplitShiftPresence.size();
            int dataAmount = 0;
            for (int i = 0; i < maxNightShiftPresence; i++) {
                SplitShiftMonthly splitShiftMonthly = (SplitShiftMonthly) listSplitShiftPresence.get(i);
                String empNum = splitShiftMonthly.getEmpNum();
                String empName = splitShiftMonthly.getEmpName();
                Vector empSchedules1st = splitShiftMonthly.getEmpSchedules1st();
                Vector empActualIn1st = splitShiftMonthly.getEmpIn1st();
                Vector empActualOut1st = splitShiftMonthly.getEmpOut1st();
                Vector empSchedules2nd = splitShiftMonthly.getEmpSchedules2nd();
                Vector empActualIn2nd = splitShiftMonthly.getEmpIn2nd();
                Vector empActualOut2nd = splitShiftMonthly.getEmpOut2nd();

                // check apakah dalam vector schedule ada schedule tipe SPLIT SHIFT ???			
                boolean containSchldSplitShift = SessSplitShift.containSchldSplitShift(empSchedules1st);
                int startPeriodSplit = Integer.parseInt(String.valueOf(PstSystemProperty.getValueByName("START_DATE_PERIOD")));
                startPeriodSplit = startPeriodSplit - 1;
                if (containSchldSplitShift) {
                    int totalSplitShift = 0;
                    int presenceNull = 0; // menghandle apakah presence dalam month terpilih null atau tidak														
                    Vector rowxMonth = new Vector(1, 1);
                    for (int isch = 0; isch < empSchedules1st.size(); isch++) {
                        if (startPeriodSplit == dateOfMonth) {
                            startPeriodSplit = 1;
                        } else {
                            startPeriodSplit = startPeriodSplit + 1;
                        }
                        String schldSymbol1st = PstScheduleSymbol.getScheduleSymbol(Long.parseLong(String.valueOf(empSchedules1st.get(startPeriodSplit - 1))), PstScheduleCategory.CATEGORY_SPLIT_SHIFT);
                        if (schldSymbol1st != null && schldSymbol1st.length() > 0) {
                            String strDuration = "";
                            Date dateActualIn1st = (Date) empActualIn1st.get(startPeriodSplit - 1);
                            Date dateActualOut1st = (Date) empActualOut1st.get(startPeriodSplit - 1);
                            Date dateActualIn2nd = (Date) empActualIn2nd.get(startPeriodSplit - 1);
                            Date dateActualOut2nd = (Date) empActualOut2nd.get(startPeriodSplit - 1);
                            if ((dateActualIn2nd != null && dateActualOut2nd != null) && (dateActualIn1st != null && dateActualOut1st != null)) {
                                long iDuration1st = dateActualOut1st.getTime() / 60000 - dateActualIn1st.getTime() / 60000;
                                long iDuration2nd = dateActualOut2nd.getTime() / 60000 - dateActualIn2nd.getTime() / 60000;
                                long iDuration = iDuration1st + iDuration2nd;
                                long iDurationHour = (iDuration - (iDuration % 60)) / 60;

                                                        // ngecek durasi waktu apakah 8 jam atau lebih
                                //if(iDurationHour>=8)
                                //{							
                                long iDurationMin = iDuration % 60;
                                String strDurationHour = iDurationHour + "h, ";
                                String strDurationMin = iDurationMin + "m";
                                strDuration = strDurationHour + strDurationMin;
                                presenceNull += 1;
                                //}	
                            } else {
                                strDuration = "";
                            }
                            rowxMonth.add(strDuration);

                            if (strDuration != null && strDuration.length() > 0) {
                                totalSplitShift += 1;
                            }
                        } else {
                            rowxMonth.add("");
                        }
                    }

                    if (presenceNull > 0 && totalSplitShift > 0) {
                        dataAmount += 1;
                        Vector rowx = new Vector(1, 1);
                        rowx.add("" + dataAmount);
                        rowx.add(empNum);
                        rowx.add(empName);
                        rowx.addAll(rowxMonth);
                        rowx.add(String.valueOf(totalSplitShift));
                        lstData.add(rowx);
                        vectDataToPdf.add(rowx);
                    }

                }
            }

            if (dataAmount > 0) {
                result.add(String.valueOf(DATA_PRINT));
                result.add(ctrlist.drawList());
                result.add(vectDataToPdf);
            } else {
                result.add(String.valueOf(DATA_NULL));
                result.add("<div class=\"msginfo\">&nbsp;&nbsp;No split shift data found ...</div>");
                result.add(new Vector(1, 1));
            }

        } else {
            result.add(String.valueOf(DATA_NULL));
            result.add("<div class=\"msginfo\">&nbsp;&nbsp;No split shift data found ...</div>");
            result.add(new Vector(1, 1));
        }
        return result;
    }
%>

<%
    int iCommand = FRMQueryString.requestCommand(request);
    long oidDepartment = FRMQueryString.requestLong(request, "department");
//update by devin 2014-01-29
    long oidCompany = FRMQueryString.requestLong(request, "hidden_companyId");
    long oidDivision = FRMQueryString.requestLong(request, "hidden_divisionId");
    String empNum = FRMQueryString.requestString(request, "emp_number");
    String fullName = FRMQueryString.requestString(request, "full_name");
    long oidSection = FRMQueryString.requestLong(request, "section");
    long periodId = FRMQueryString.requestLong(request, "period");
//Date date = FRMQueryString.requestDate(request,"month_year");
    SplitShiftMonthly splitShiftMonthly = new SplitShiftMonthly();
    Period pr = new Period();
    Date date = new Date();
    String periodName = "";
    try {
        pr = PstPeriod.fetchExc(periodId);
        date = pr.getStartDate();
        periodName = pr.getPeriod();

    } catch (Exception e) {
    }

// get maximum date of selected month
    Calendar newCalendar = Calendar.getInstance();
    newCalendar.setTime(date);
    int dateOfMonth = newCalendar.getActualMaximum(Calendar.DAY_OF_MONTH);

    Vector listSplitShiftPresence = new Vector(1, 1);
    if (iCommand == Command.LIST) {
        //listSplitShiftPresence = SessSplitShift.listSplitShiftDataMonthly(oidDepartment,date);
        // Untuk aplikasi yang membutuhkan parameter section, jika hanya membutuhkan parameter department pake yanga atas 
        listSplitShiftPresence = SessSplitShift.listSplitShiftDataMonthly(oidDepartment, oidCompany, oidDivision, date, oidSection, empNum, fullName);

    }

// process on drawlist
    Vector vectResult = drawList(listSplitShiftPresence, dateOfMonth);
    int dataStatus = Integer.parseInt(String.valueOf(vectResult.get(0)));
    String listData = String.valueOf(vectResult.get(1));
    Vector vectDataToPdf = (Vector) vectResult.get(2);

// design vector that handle data to store in session
    Vector vectPresence = new Vector(1, 1);
    vectPresence.add(date);
    vectPresence.add("" + oidDepartment);
    vectPresence.add(vectDataToPdf);
    vectPresence.add("" + dateOfMonth);

    if (session.getValue("SPLIT_SHIFT_MONTHLY") != null) {
        session.removeValue("SPLIT_SHIFT_MONTHLY");
    }
    session.putValue("SPLIT_SHIFT_MONTHLY", vectPresence);
%>
<!-- End of JSP Block -->
<html>
    <!-- #BeginTemplate "/Templates/main.dwt" --> 
    <head>
        <!-- #BeginEditable "doctitle" --> 
        <title>HARISMA - Split Shift Report</title>
        <script language="JavaScript">
            function cmdView() {
                document.frpresence.command.value = "<%=Command.LIST%>";
                document.frpresence.action = "monthly_split.jsp";
                document.frpresence.submit();
            }
            //update by devin 2014-01-29
            function cmdUpdateDiv() {
                document.frpresence.command.value = "<%=String.valueOf(Command.GOTO)%>";
                document.frpresence.action = "monthly_split.jsp";
                document.frpresence.target = "";
                document.frpresence.submit();
            }
            function cmdUpdatePos() {
                document.frpresence.command.value = "<%=String.valueOf(Command.GOTO)%>";
                document.frpresence.action = "monthly_split.jsp";
                document.frpresence.target = "";
                document.frpresence.submit();
            }
            function cmdUpdateSec() {
                document.frpresence.command.value = "<%=String.valueOf(Command.GOTO)%>";
                document.frpresence.action = "monthly_split.jsp";
                document.frpresence.target = "";
                document.frpresence.submit();
            }

            function cmdUpdateDep() {
                document.frpresence.command.value = "<%=String.valueOf(Command.GOTO)%>";
                document.frpresence.action = "monthly_split.jsp";
                document.frpresence.target = "";
                document.frpresence.submit();
            }
            function reportPdf() {
                var linkPage = "<%=printroot%>.report.attendance.MonthlySplitShiftPdf";
                //window.open(linkPage,"reportPage","height=600,width=800,status=no,toolbar=no,menubar=no,location=no");  			
                window.open(linkPage);
            }

            //-------------- script control line -------------------
            function MM_swapImgRestore() { //v3.0
                var i, x, a = document.MM_sr;
                for (i = 0; a && i < a.length && (x = a[i]) && x.oSrc; i++)
                    x.src = x.oSrc;
            }

            function MM_preloadImages() { //v3.0
                var d = document;
                if (d.images) {
                    if (!d.MM_p)
                        d.MM_p = new Array();
                    var i, j = d.MM_p.length, a = MM_preloadImages.arguments;
                    for (i = 0; i < a.length; i++)
                        if (a[i].indexOf("#") != 0) {
                            d.MM_p[j] = new Image;
                            d.MM_p[j++].src = a[i];
                        }
                }
            }

            function MM_findObj(n, d) { //v4.0
                var p, i, x;
                if (!d)
                    d = document;
                if ((p = n.indexOf("?")) > 0 && parent.frames.length) {
                    d = parent.frames[n.substring(p + 1)].document;
                    n = n.substring(0, p);
                }
                if (!(x = d[n]) && d.all)
                    x = d.all[n];
                for (i = 0; !x && i < d.forms.length; i++)
                    x = d.forms[i][n];
                for (i = 0; !x && d.layers && i < d.layers.length; i++)
                    x = MM_findObj(n, d.layers[i].document);
                if (!x && document.getElementById)
                    x = document.getElementById(n);
                return x;
            }

            function MM_swapImage() { //v3.0
                var i, j = 0, x, a = MM_swapImage.arguments;
                document.MM_sr = new Array;
                for (i = 0; i < (a.length - 2); i += 3)
                    if ((x = MM_findObj(a[i])) != null) {
                        document.MM_sr[j++] = x;
                        if (!x.oSrc)
                            x.oSrc = x.src;
                        x.src = a[i + 2];
                    }
            }
        </script>
        <!-- update by devin 2014-01-29 -->
        <style type="text/css">
            .tooltip {
                display:none;
                position:absolute;
                border:1px solid #333;
                background-color:#161616;
                border-radius:5px;
                padding:10px;
                color:#fff;
                font-size:12px Arial;
            }
        </style>
        <!-- update by devin 2014-01-29 -->
        <style type="text/css">

            .bdr{border-bottom:2px dotted #0099FF;}

            .highlight {
                color: #090;
            }

            .example {
                color: #08C;
                cursor: pointer;
                padding: 4px;
                border-radius: 4px;
            }

            .example:after {
                font-family: Consolas, Courier New, Arial, sans-serif;
                content: '?';
                margin-left: 6px;
                color: #08C;
            }

            .example:hover {
                background: #F2F2F2;
            }

            .example.dropdown-open {
                background: #888;
                color: #FFF;
            }

            .example.dropdown-open:after {
                color: #FFF;
            }

        </style>
        <!-- update by devin 2014-01-29 -->
        <script type="text/javascript">
            $(document).ready(function () {
                // Tooltip only Text
                $('.masterTooltip').hover(function () {
                    // Hover over code
                    var title = $(this).attr('title');
                    $(this).data('tipText', title).removeAttr('title');
                    $('<p class="tooltip"></p>')
                            .text(title)
                            .appendTo('body')
                            .fadeIn('fast');
                }, function () {
                    // Hover out code
                    $(this).attr('title', $(this).data('tipText'));
                    $('.tooltip').remove();
                }).mousemove(function (e) {
                    var mousex = e.pageX + 20; //Get X coordinates
                    var mousey = e.pageY + 10; //Get Y coordinates
                    $('.tooltip')
                            .css({top: mousey, left: mousex})
                });
            });
        </script>
        <!-- #EndEditable --> 
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
        <!-- #BeginEditable "styles" --> 
        <link rel="stylesheet" href="../../styles/main.css" type="text/css">
        <!-- #EndEditable --> <!-- #BeginEditable "stylestab" --> 
        <link rel="stylesheet" href="../../styles/tab.css" type="text/css">
        <!-- #EndEditable --> <!-- #BeginEditable "headerscript" --> 
        <!-- #EndEditable --> 
    </head>
    <body <%=noBack%> bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('<%=approot%>/images/BtnSearchOn.jpg')">
        <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%" bgcolor="#F9FCFF" >
            <%if (headerStyle && !verTemplate.equalsIgnoreCase("0")) {%> 
            <%@include file="../../styletemplate/template_header.jsp" %>
            <%} else {%>
            <tr> 
                <td ID="TOPTITLE" background="<%=approot%>/images/HRIS_HeaderBg3.jpg" width="100%" height="54"> 
                    <!-- #BeginEditable "header" --> 
                    <%@ include file = "../../main/header.jsp" %>
                    <!-- #EndEditable --> </td>
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
            <tr> 
                <td width="88%" valign="top" align="left"> 
                    <table width="100%" border="0" cellspacing="3" cellpadding="2">
                        <tr> 
                            <td width="100%"> 
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr> 
                                        <td height="20"> <font color="#FF6600" face="Arial"><strong> <!-- #BeginEditable "contenttitle" -->Attendance 
                                                &gt; Monthly Split Shift<!-- #EndEditable --> </strong></font> 
                                        </td>
                                    </tr>
                                    <tr> 
                                        <td> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr> 
                                                    <td  style="background-color:<%=bgColorContent%>; "> 
                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1" class="tablecolor">
                                                            <tr> 
                                                                <td valign="top"> 
                                                                    <table style="border:1px solid <%=garisContent%>" width="100%" border="0" cellspacing="1" cellpadding="1" class="tabbg">
                                                                        <tr> 
                                                                            <td valign="top"> <!-- #BeginEditable "content" -->
                                                                                <form name="frpresence" method="post" action="">
                                                                                    <input type="hidden" name="command" value="<%=iCommand%>">
                                                                                    <table width="60%" border="0" cellspacing="2" cellpadding="2">
                                                                                        <tr> 
                                                                                            <!-- update by devin 2014-01-29 -->
                                                                                            <td width="6%" nowrap="nowrap"><div align="left">Payrol Num </div></td>
                                                                                            <td width="30%" nowrap="nowrap">:
                                                                                                <input class="masterTooltip" type="text" size="40" name="emp_number"  value="<%= splitShiftMonthly.getEmpNum() != null ? splitShiftMonthly.getEmpNum() : empNum%>" title="You can Input Payroll Number more than one, ex-sample : 1111,2222" class="elemenForm" onKeyDown="javascript:fnTrapKD()">
                                                                                            </td>
                                                                                            <td width="5%" nowrap="nowrap"><div align="right"> Full Name </div> </td>
                                                                                            <td width="59%" nowrap="nowrap">:
                                                                                                <input class="masterTooltip" type="text" size="50" name="full_name"  value="<%= splitShiftMonthly.getEmpName() != null ? splitShiftMonthly.getEmpName() : fullName%>" title="You can Input Full Name more than one, ex-sample : saya,kamu" class="elemenForm" onKeyDown="javascript:fnTrapKD()">
                                                                                            </td>
                                                                                        </tr>
                                                                                        <!-- update by devin 2014-01-29 -->
                                                                                        <tr>
                                                                                            <td width="6%" nowrap="nowrap"><div align="left">Company </div></td>
                                                                                            <td width="30%" nowrap="nowrap">:
                                                                                                <%

                                                                                                    Vector comp_value = new Vector(1, 1);
                                                                                                    Vector comp_key = new Vector(1, 1);
                                                                                                    String whereComp = "";
                                                                                                    /*if(srcOvertime!=null && srcOvertime.getCompanyId()!=0){
                                                                                                     whereComp = PstCompany.fieldNames[PstCompany.FLD_COMPANY_ID] +"="+srcOvertime.getCompanyId();
                                                                                                     }*/
                                                                                                    Vector div_value = new Vector(1, 1);
                                                                                                    Vector div_key = new Vector(1, 1);

                                                                                                    Vector dept_value = new Vector(1, 1);
                                                                                                    Vector dept_key = new Vector(1, 1);
                                                                                                    if (processDependOnUserDept) {
                                                                                                        if (emplx.getOID() > 0) {
                                                                                                            if (isHRDLogin || isEdpLogin || isGeneralManager || isDirector) {
                                                                                                                //keyList = PstDepartment.genDepIDandNameWithCompanyDiv(0, 1000, "", true);
                                                                                                                comp_value.add("0");
                                                                                                                comp_key.add("select ...");

                                                                                                                div_value.add("0");
                                                                                                                div_key.add("select ...");

                                                                                                                dept_value.add("0");
                                                                                                                dept_key.add("select ...");
                                                                                                            } else {
                                                                                                                Position position = null;
                                                                                                                try {
                                                                                                                    position = PstPosition.fetchExc(emplx.getPositionId());
                                                                                                                } catch (Exception exc) {
                                                                                                                }
                                                                                                                if (position != null & position.getDisabedAppDivisionScope() == 0 & position.getPositionLevel() >= PstPosition.LEVEL_MANAGER) {
                                                                                                                    String whereDiv = " d." + PstDepartment.fieldNames[PstDepartment.FLD_DIVISION_ID] + "=" + emplx.getDivisionId() + "";
                                                                          //keyList = PstDepartment.genDepIDandNameWithCompanyDiv(0, 1000, whereDiv, true);
                                                                                                                    // comp_value.add("0");
                                                                                                                    // comp_key.add("select ...");

                                                                             //div_value.add("0");
                                                                                                                    //div_key.add("select ...");
                                                                                                                    dept_value.add("0");
                                                                                                                    dept_key.add("select ...");

                                                                                                                    whereComp = whereComp != null && whereComp.length() > 0 ? whereComp + " AND (" + whereDiv + ")" : whereDiv;

                                                                                                                } else {

                                                                                                                    String whereClsDep = "(" + PstDepartment.fieldNames[PstDepartment.FLD_DEPARTMENT_ID] + " = " + departmentOid
                                                                                                                            + ") OR (" + PstDepartment.fieldNames[PstDepartment.FLD_JOIN_TO_DEPARTMENT_ID] + " = " + departmentOid + ") ";
                                                                                                                    try {
                                                                                                                        String joinDept = PstSystemProperty.getValueByName("JOIN_DEPARMENT");
                                                                                                                        Vector depGroup = com.dimata.util.StringParser.parseGroup(joinDept);

                                                                                                                        int grpIdx = -1;
                                                                                                                        int maxGrp = depGroup == null ? 0 : depGroup.size();
                                                                                                                        int countIdx = 0;
                                                                                                                        int MAX_LOOP = 10;
                                                                                                                        int curr_loop = 0;
                                                                                                                        do { // find group department belonging to curretn user base in departmentOid
                                                                                                                            curr_loop++;
                                                                                                                            String[] grp = (String[]) depGroup.get(countIdx);
                                                                                                                            for (int g = 0; g < grp.length; g++) {
                                                                                                                                String comp = grp[g];
                                                                                                                                if (comp.trim().compareToIgnoreCase("" + departmentOid) == 0) {
                                                                                                                                    grpIdx = countIdx;   // A ha .. found here 
                                                                                                                                }
                                                                                                                            }
                                                                                                                            countIdx++;
                                                                                                                        } while ((grpIdx < 0) && (countIdx < maxGrp) && (curr_loop < MAX_LOOP)); // if found then exit

                                                                                                                        // compose where clause
                                                                                                                        if (grpIdx >= 0) {
                                                                                                                            String[] grp = (String[]) depGroup.get(grpIdx);
                                                                                                                            for (int g = 0; g < grp.length; g++) {
                                                                                                                                String comp = grp[g];
                                                                                                                                whereClsDep = whereClsDep + " OR (DEPARTMENT_ID = " + comp + ")";
                                                                                                                            }
                                                                                                                        }
                                                                                                                    } catch (Exception exc) {
                                                                                                                        System.out.println(" Parsing Join Dept" + exc);

                                                                                                                    }
                                                                          //keyList = PstDepartment.genDepIDandNameWithCompanyDiv(0, 1000, whereClsDep, false);

                                                                                                                    whereComp = whereComp != null && whereComp.length() > 0 ? whereComp + " AND (" + whereClsDep + ")" : whereClsDep;

                                                                                                                }
                                                                                                            }
                                                                                                        }
                                                                                                    } else {
                                                                                                        comp_value.add("0");
                                                                                                        comp_key.add("select ...");

                                                                                                        div_value.add("0");
                                                                                                        div_key.add("select ...");

                                                                                                        dept_value.add("0");
                                                                                                        dept_key.add("select ...");
                                                                                                    }
                                                                                                    Vector listCostDept = PstDepartment.listWithCompanyDiv(0, 0, whereComp);
                                                                                                    String prevCompany = "";
                                                                                                    String prevDivision = "";

                                                                                                    long prevCompanyTmp = 0;
                                                                                                    for (int i = 0; i < listCostDept.size(); i++) {
                                                                                                        Department dept = (Department) listCostDept.get(i);
                                                                                                        if (prevCompany.equals(dept.getCompany())) {
                                                                                                            if (prevDivision.equals(dept.getDivision())) {
                                                                                                                //if(srcOvertime!=null && srcOvertime.getCompanyId()!=0){
                                                                                                                dept_key.add(dept.getDepartment());
                                                                                                                dept_value.add(String.valueOf(dept.getOID()));
                                                                                                                //}
                                                                                                            } else {
                                                                                                                div_key.add(dept.getDivision());
                                                                                                                div_value.add("" + dept.getDivisionId());
                                                                                                                if (dept_key != null && dept_key.size() == 0) {
                                                                                                                    dept_key.add(dept.getDepartment());
                                                                                                                    dept_value.add(String.valueOf(dept.getOID()));
                                                                                                                }
                                                                                                                prevDivision = dept.getDivision();
                                                                                                            }
                                                                                                        } else {
                                                                                                            String chkAdaDiv = "";
                                                                                                            if (div_key != null && div_key.size() > 0) {
                                                                                                                chkAdaDiv = (String) div_key.get(0);
                                                                                                            }
                                                                                                            if ((div_key != null && div_key.size() == 0) || (chkAdaDiv.equalsIgnoreCase("select ..."))) {
                                                                                                                if (prevCompanyTmp != dept.getCompanyId()) {
                                                                                                                    comp_key.add(dept.getCompany());
                                                                                                                    comp_value.add("" + dept.getCompanyId());
                                                                                                                    prevCompanyTmp = dept.getCompanyId();
                                                                                                                }
                                                                   //untuk karyawan admin yg hanya bisa akses departement tertentu (ketika di awal)
                                                                                                                ////update
                                                                                                                if (processDependOnUserDept) {
                                                                                                                    if (emplx.getOID() > 0) {
                                                                                                                        if (isHRDLogin || isEdpLogin || isGeneralManager || isDirector) {
                                                                                                                            if (oidCompany != 0) {
                                                                                                                                div_key.add(dept.getDivision());
                                                                                                                                div_value.add("" + dept.getDivisionId());

                                                                                                                                dept_key.add(dept.getDepartment());
                                                                                                                                dept_value.add(String.valueOf(dept.getOID()));
                                                                                                                                prevCompany = dept.getCompany();
                                                                                                                                prevDivision = dept.getDivision();
                                                                                                                            }
                                                                                                                        } else {
                                                                                                                            Position position = null;
                                                                                                                            try {
                                                                                                                                position = PstPosition.fetchExc(emplx.getPositionId());
                                                                                                                            } catch (Exception exc) {
                                                                                                                            }
                                                                                                                            if (position != null & position.getDisabedAppDivisionScope() == 0 & position.getPositionLevel() >= PstPosition.LEVEL_MANAGER) {
                                                                                                                                if (oidCompany != 0) {
                                                                                                                                    div_key.add(dept.getDivision());
                                                                                                                                    div_value.add("" + dept.getDivisionId());

                                                                                                                                    dept_key.add(dept.getDepartment());
                                                                                                                                    dept_value.add(String.valueOf(dept.getOID()));
                                                                                                                                    prevCompany = dept.getCompany();
                                                                                                                                    prevDivision = dept.getDivision();
                                                                                                                                } //update by satrya 2013-09-19
                                                                                                                                else if ((div_key != null && div_key.size() == 0) || (chkAdaDiv.equalsIgnoreCase("select ..."))) {
                                                                                                                                    div_key.add(dept.getDivision());
                                                                                                                                    div_value.add("" + dept.getDivisionId());

                                                                                                                                    //update by satrya 2013-09-19
                                                                                                                                    dept_key.add(dept.getDepartment());
                                                                                                                                    dept_value.add(String.valueOf(dept.getOID()));

                                                                                                                                    prevCompany = dept.getCompany();
                                                                                                                                    prevDivision = dept.getDivision();
                                                                                                                                }

                                                                                                                            } else {

                                                                                                                                div_key.add(dept.getDivision());
                                                                                                                                div_value.add("" + dept.getDivisionId());

                                                                                                                                dept_key.add(dept.getDepartment());
                                                                                                                                dept_value.add(String.valueOf(dept.getOID()));
                                                                                                                                prevCompany = dept.getCompany();
                                                                                                                                prevDivision = dept.getDivision();
                                                                                                                            }
                                                                                                                        }
                                                                                                                    }
                                                                                                                } else {
                                                                                                                    if (oidCompany != 0) {
                                                                                                                        div_key.add(dept.getDivision());
                                                                                                                        div_value.add("" + dept.getDivisionId());

                                                                                                                        dept_key.add(dept.getDepartment());
                                                                                                                        dept_value.add(String.valueOf(dept.getOID()));
                                                                                                                        prevCompany = dept.getCompany();
                                                                                                                        prevDivision = dept.getDivision();
                                                                                                                    }
                                                                                                                }

                                                                                                            } else {
                                                                                                                if (prevCompanyTmp != dept.getCompanyId()) {
                                                                                                                    comp_key.add(dept.getCompany());
                                                                                                                    comp_value.add("" + dept.getCompanyId());
                                                                                                                    prevCompanyTmp = dept.getCompanyId();
                                                                                                                }

                                                                                                            }

                                                                                                        }
                                                                                                    }
                                                                                                %>
                                                                                                <%= ControlCombo.draw("hidden_companyId", "formElemen", null, "" + oidCompany, comp_value, comp_key, "onChange=\"javascript:cmdUpdateDiv()\"")%> </td>
                                                                                            <td width="5%" nowrap="nowrap"><div align="right"><%=dictionaryD.getWord(I_Dictionary.DIVISION)%></div> </td>
                                                                                            <td width="59%" nowrap="nowrap">:
                                                                                                <%

                                                                                                                   //update by satrya 2013-08-13
                                                                                                    //jika user memilih select kembali
                                                                                                    if (oidCompany == 0) {
                                                                                                        oidDivision = 0;
                                                                                                    }

                                                                                                    if (oidCompany != 0) {
                                                                                                        whereComp = "(" + (whereComp != null && whereComp.length() == 0 ? "1=1" : whereComp) + ") AND " + PstCompany.fieldNames[PstCompany.FLD_COMPANY_ID] + "=" + oidCompany + " AND d." + PstDepartment.fieldNames[PstDepartment.FLD_VALID_STATUS] + " = 1";
                                                                                                        listCostDept = PstDepartment.listWithCompanyDiv(0, 0, whereComp);
                                                                                                        prevCompany = "";
                                                                                                        prevDivision = "";

                                                                                                        div_value = new Vector(1, 1);
                                                                                                        div_key = new Vector(1, 1);

                                                                                                        dept_value = new Vector(1, 1);
                                                                                                        dept_key = new Vector(1, 1);

                                                                                                        prevCompanyTmp = 0;
                                                                                                        long tmpFirstDiv = 0;

                                                                                                        if (processDependOnUserDept) {
                                                                                                            if (emplx.getOID() > 0) {
                                                                                                                if (isHRDLogin || isEdpLogin || isGeneralManager || isDirector) {
                                                                                                                    //keyList = PstDepartment.genDepIDandNameWithCompanyDiv(0, 1000, "", true);
                                                                                                                    comp_value.add("0");
                                                                                                                    comp_key.add("select ...");

                                                                                                                    div_value.add("0");
                                                                                                                    div_key.add("select ...");

                                                                                                                    dept_value.add("0");
                                                                                                                    dept_key.add("select ...");
                                                                                                                } else {
                                                                                                                    Position position = null;
                                                                                                                    try {
                                                                                                                        position = PstPosition.fetchExc(emplx.getPositionId());
                                                                                                                    } catch (Exception exc) {
                                                                                                                    }
                                                                                                                    if (position != null & position.getDisabedAppDivisionScope() == 0 & position.getPositionLevel() >= PstPosition.LEVEL_MANAGER) {
                                                                                                       //div_value.add("0");
                                                                                                                        //div_key.add("select ...");

                                                                                                                        dept_value.add("0");
                                                                                                                        dept_key.add("select ...");

                                                                                                                    }
                                                                                                                }
                                                                                                            }
                                                                                                        } else {
                                                                                                            comp_value.add("0");
                                                                                                            comp_key.add("select ...");

                                                                                                            div_value.add("0");
                                                                                                            div_key.add("select ...");

                                                                                                            dept_value.add("0");
                                                                                                            dept_key.add("select ...");
                                                                                                        }
                                                                                                        long prevDivTmp = 0;
                                                                                                        for (int i = 0; i < listCostDept.size(); i++) {
                                                                                                            Department dept = (Department) listCostDept.get(i);
                                                                                                            if (prevCompany.equals(dept.getCompany())) {
                                                                                                                if (prevDivision.equals(dept.getDivision())) {
                                                                                                                    //update
                                                                                                                    if (oidDivision != 0) {
                                                                                                                        dept_key.add(dept.getDepartment());
                                                                                                                        dept_value.add(String.valueOf(dept.getOID()));
                                                                                                                    }
                                                                                                //lama
                                                                                                /*
                                                                                                                     dept_key.add(dept.getDepartment());
                                                                                                                     dept_value.add(String.valueOf(dept.getOID()));
                                                                                                                     */

                                                                                                                } else {
                                                                                                                    div_key.add(dept.getDivision());
                                                                                                                    div_value.add("" + dept.getDivisionId());
                                                                                                                    if (dept_key != null && dept_key.size() == 0) {
                                                                                                                        dept_key.add(dept.getDepartment());
                                                                                                                        dept_value.add(String.valueOf(dept.getOID()));
                                                                                                                    }
                                                                                                                    prevDivision = dept.getDivision();
                                                                                                                }
                                                                                                            } else {
                                                                                                                String chkAdaDiv = "";
                                                                                                                if (div_key != null && div_key.size() > 0) {
                                                                                                                    chkAdaDiv = (String) div_key.get(0);
                                                                                                                }
                                                                                                                if ((div_key != null && div_key.size() == 0) || (chkAdaDiv.equalsIgnoreCase("select ..."))) {
                                                                                             //comp_key.add(dept.getCompany());
                                                                                                                    //comp_value.add(""+dept.getCompanyId());

                                                                                                                    if (prevDivTmp != dept.getDivisionId()) {
                                                                                                                        div_key.add(dept.getDivision());
                                                                                                                        div_value.add("" + dept.getDivisionId());
                                                                                                                        prevDivTmp = dept.getDivisionId();
                                                                                                                    }

                                                                                                                    tmpFirstDiv = dept.getDivisionId();

                                                                                                   // dept_key.add(dept.getDepartment());
                                                                                                                    //   dept_value.add(String.valueOf(dept.getOID()));           
                                                                                                                    prevCompany = dept.getCompany();
                                                                                                                    prevDivision = dept.getDivision();
                                                                                                                }
                                                                                                                /*else{
                                                                                                                 if(prevCompanyTmp!=dept.getCompanyId()){
                                                                                                                 comp_key.add(dept.getCompany());
                                                                                                                 comp_value.add(""+dept.getCompanyId());
                                                                                                                 prevCompanyTmp=dept.getCompanyId();
                                                                                                                 }
              
                                                                                                                 }*/
                                                                                                                String chkAdaDpt = "";
                                                                                                                if (whereComp != null && whereComp.length() > 0) {
                                                                                                                    chkAdaDpt = "(" + (whereComp != null && whereComp.length() == 0 ? "1=1" : whereComp) + ") AND d." + PstDivision.fieldNames[PstDivision.FLD_DIVISION_ID] + "=" + oidDivision;
                                                                                                                }
                                                                                                                Vector listCheckAdaDept = PstDepartment.listWithCompanyDiv(0, 0, chkAdaDpt);
                                                                                                                if ((listCheckAdaDept == null || listCheckAdaDept.size() == 0)) {

                                                                                                                    if (processDependOnUserDept) {
                                                                                                                        if (emplx.getOID() > 0) {
                                                                                                                            if (isHRDLogin || isEdpLogin || isGeneralManager || isDirector) {

                                                                                                                            } else {
                                                                                                                                Position position = null;
                                                                                                                                try {
                                                                                                                                    position = PstPosition.fetchExc(emplx.getPositionId());
                                                                                                                                } catch (Exception exc) {
                                                                                                                                }

                                                                                                                                oidDivision = tmpFirstDiv;

                                                                                                                            }
                                                                                                                        }
                                                                                                                    } else {
                                                                                                                        oidDivision = tmpFirstDiv;

                                                                                                                    }

                                                                                                                }
                                                                                                            }
                                                                                                        }
                                                                                                    }
                                                                                                %>
                                                                                                <%= ControlCombo.draw("hidden_divisionId", "formElemen", null, "" + oidDivision, div_value, div_key, "onChange=\"javascript:cmdUpdateDep()\"")%> </td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td width="6%" align="right" nowrap><div align="left"><%=dictionaryD.getWord(I_Dictionary.DEPARTMENT)%></div></td>
                                                                                            <td width="30%" nowrap="nowrap"> :
                                                                                                <%

                                                                  //update by satrya 2013-08-13
                                                                                                    //jika user memilih select kembali
                                                                                                    if (oidDepartment == 0) {
                                                                                                        oidSection = 0;
                                                                                                    }
                                                                                                    if (oidDivision != 0) {
                                                                                                        if (whereComp != null && whereComp.length() > 0) {
                                                                                                            whereComp = "(" + whereComp + ") AND d." + PstDivision.fieldNames[PstDivision.FLD_DIVISION_ID] + "=" + oidDivision + " AND d." + PstDepartment.fieldNames[PstDepartment.FLD_VALID_STATUS] + " = 1";
                                                                                                        }

                                                                                                        listCostDept = PstDepartment.listWithCompanyDiv(0, 0, whereComp);
                                                                                                        prevCompany = "";
                                                                                                        prevDivision = "";

                                                                                                        div_value = new Vector(1, 1);
                                                                                                        div_key = new Vector(1, 1);

                                                                                                        dept_value = new Vector(1, 1);
                                                                                                        dept_key = new Vector(1, 1);

                                                                                                        prevCompanyTmp = 0;

                                                                                                        if (processDependOnUserDept) {
                                                                                                            if (emplx.getOID() > 0) {
                                                                                                                if (isHRDLogin || isEdpLogin || isGeneralManager || isDirector) {
                                                                                                                    //keyList = PstDepartment.genDepIDandNameWithCompanyDiv(0, 1000, "", true);
                                                                                                                    comp_value.add("0");
                                                                                                                    comp_key.add("select ...");

                                                                                                                    div_value.add("0");
                                                                                                                    div_key.add("select ...");

                                                                                                                    dept_value.add("0");
                                                                                                                    dept_key.add("select ...");
                                                                                                                } else {
                                                                                                                    Position position = null;
                                                                                                                    try {
                                                                                                                        position = PstPosition.fetchExc(emplx.getPositionId());
                                                                                                                    } catch (Exception exc) {
                                                                                                                    }
                                                                                                                    if (position != null & position.getDisabedAppDivisionScope() == 0 & position.getPositionLevel() >= PstPosition.LEVEL_MANAGER) {
                                                                             //div_value.add("0");
                                                                                                                        //div_key.add("select ...");

                                                                                                                        dept_value.add("0");
                                                                                                                        dept_key.add("select ...");

                                                                                                                    }
                                                                                                                }
                                                                                                            }
                                                                                                        } else {
                                                                                                            comp_value.add("0");
                                                                                                            comp_key.add("select ...");

                                                                                                            div_value.add("0");
                                                                                                            div_key.add("select ...");

                                                                                                            dept_value.add("0");
                                                                                                            dept_key.add("select ...");
                                                                                                        }

                                                                                                        for (int i = 0; i < listCostDept.size(); i++) {
                                                                                                            Department dept = (Department) listCostDept.get(i);
                                                                                                            if (prevCompany.equals(dept.getCompany())) {
                                                                                                                if (prevDivision.equals(dept.getDivision())) {
                                                                                                                    dept_key.add(dept.getDepartment());
                                                                                                                    dept_value.add(String.valueOf(dept.getOID()));
                                                                                                                } else {
                                                                                                                    div_key.add(dept.getDivision());
                                                                                                                    div_value.add("" + dept.getDivisionId());
                                                                                                                    if (dept_key != null && dept_key.size() == 0) {
                                                                                                                        dept_key.add(dept.getDepartment());
                                                                                                                        dept_value.add(String.valueOf(dept.getOID()));
                                                                                                                    }
                                                                                                                    prevDivision = dept.getDivision();
                                                                                                                }
                                                                                                            } else {
                                                                                                                String chkAdaDiv = "";
                                                                                                                if (div_key != null && div_key.size() > 0) {
                                                                                                                    chkAdaDiv = (String) div_key.get(0);
                                                                                                                }
                                                                                                                if ((div_key != null && div_key.size() == 0) || (chkAdaDiv.equalsIgnoreCase("select ..."))) {
                                                                                                                    comp_key.add(dept.getCompany());
                                                                                                                    comp_value.add("" + dept.getCompanyId());

                                                                                                                    div_key.add(dept.getDivision());
                                                                                                                    div_value.add("" + dept.getDivisionId());

                                                                                                                    dept_key.add(dept.getDepartment());
                                                                                                                    dept_value.add(String.valueOf(dept.getOID()));
                                                                                                                    prevCompany = dept.getCompany();
                                                                                                                    prevDivision = dept.getDivision();
                                                                                                                } else {
                                                                                                                    if (prevCompanyTmp != dept.getCompanyId()) {
                                                                                                                        comp_key.add(dept.getCompany());
                                                                                                                        comp_value.add("" + dept.getCompanyId());
                                                                                                                        prevCompanyTmp = dept.getCompanyId();
                                                                                                                    }

                                                                                                                }

                                                                                                            }
                                                                                                        }
                                                                                                    }
                                                                                                %>
                                                                                                <%= ControlCombo.draw("department", "formElemen", null, "" + oidDepartment, dept_value, dept_key, "onChange=\"javascript:cmdUpdatePos()\"")%> </td>
                                                                                            <td width="5%" align="left" nowrap valign="top"><div align="right"><%=dictionaryD.getWord(I_Dictionary.SECTION)%></div></td>
                                                                                            <td width="59%" nowrap="nowrap">:
                                                                                                <%

                                                                                                    Vector sec_value = new Vector(1, 1);
                                                                                                    Vector sec_key = new Vector(1, 1);
                                                                                                    sec_value.add("0");
                                                                                                    sec_key.add("select ...");

                                                                                                                        //String sWhereClause = PstSection.fieldNames[PstSection.FLD_DEPARTMENT_ID] + " = " + sSelectedDepartment;                                                       
                                                                                                    //Vector listSec = PstSection.list(0, 0, sWhereClause, " SECTION ");
                                                                                                    String secWhere = PstSection.fieldNames[PstSection.FLD_DEPARTMENT_ID] + "=" + oidDepartment + " AND " + PstSection.fieldNames[PstSection.FLD_VALID_STATUS] + " = 1";
                                                                                                    Vector listSec = PstSection.list(0, 0, secWhere, " SECTION ");
                                                                                                    for (int i = 0; i < listSec.size(); i++) {
                                                                                                        Section sec = (Section) listSec.get(i);
                                                                                                        sec_key.add(sec.getSection());
                                                                                                        sec_value.add(String.valueOf(sec.getOID()));
                                                                                                    }
                                                                                                %>
                                                                                                <%=ControlCombo.draw("section", null, "" + oidSection, sec_value, sec_key, "onChange=\"javascript:cmdUpdateSec()\"")%></td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td width="6%" align="right" nowrap><div align="left">Period </div></td>
                                                                                            <td width="30%" nowrap="nowrap"> : <%//=ControlDate.drawDateMY("month_year",date==null || iCommand == Command.NONE?new Date():date,"MMM yyyy","formElemen",0,installInterval)%>
                                                                                                <%
                                                                                                    Vector listPeriod = PstPeriod.list(0, 0, "", "PERIOD");
                                                                                                    Vector periodValue = new Vector(1, 1);
                                                                                                    Vector periodKey = new Vector(1, 1);
                                  //deptValue.add("0");
                                                                                                    //deptKey.add("ALL");

                                                                                                    for (int d = 0; d < listPeriod.size(); d++) {
                                                                                                        Period period = (Period) listPeriod.get(d);
                                                                                                        periodValue.add("" + period.getOID());
                                                                                                        periodKey.add(period.getPeriod());
                                                                                                    }
                                                                                                %> <%=ControlCombo.draw("period", null, "" + periodId, periodValue, periodKey)%>	


                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td width="9%" nowrap> 
                                                                                                <div align="left"></div>
                                                                                            </td>
                                                                                            <td width="88%"> 
                                                                                                <table border="0" cellspacing="0" cellpadding="0" width="137">
                                                                                                    <tr> 
                                                                                                        <td width="16"><a href="javascript:cmdView()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image10', '', '<%=approot%>/images/BtnSearchOn.jpg', 1)" id="aSearch"><img name="Image10" border="0" src="<%=approot%>/images/BtnSearch.jpg" width="24" height="24" alt="View Split Shift"></a></td>
                                                                                                        <td width="2"><img src="<%=approot%>/images/spacer.gif" width="4" height="1"></td>
                                                                                                        <td width="94" class="command" nowrap><a href="javascript:cmdView()">View 
                                                                                                                Split Shift</a></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>

                                                                                    <% if (iCommand == Command.LIST) {%>
                                                                                    <table width="100%" border="0" cellspacing="2" cellpadding="2">
                                                                                        <tr>
                                                                                            <td><hr></td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td>
                                                                                                <%
                                                                                                    out.println(listData);
                                                                                                %>																						
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%if (dataStatus == DATA_PRINT && privPrint) {%>
                                                                                        <tr>
                                                                                            <td>
                                                                                                <table width="18%" border="0" cellspacing="1" cellpadding="1">
                                                                                                    <tr>
                                                                                                        <td width="17%"><a href="javascript:reportPdf()"><img src="../../images/BtnNew.jpg" width="24" height="24" border="0" alt="Print Monthly Split Shift"></a></td>												  
                                                                                                        <td width="83%"><b><a href="javascript:reportPdf()" class="command">Print 
                                                                                                                    Monthly Split Shift</a></b> 
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%}%>										  
                                                                                    </table>
                                                                                    <%}%>									  									  
                                                                                </form>
                                                                                <!-- #EndEditable --> </td>
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr> 
                                                    <td>&nbsp; </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <%if (headerStyle && !verTemplate.equalsIgnoreCase("0")) {%>
            <tr>
                <td valign="bottom">
                    <!-- untuk footer -->
                    <%@include file="../../footer.jsp" %>
                </td>

            </tr>
            <%} else {%>
            <tr> 
                <td colspan="2" height="20" <%=bgFooterLama%>> <!-- #BeginEditable "footer" --> 
                    <%@ include file = "../../main/footer.jsp" %>
                    <!-- #EndEditable --> </td>
            </tr>
            <%}%>
        </table>
    </body>
    <!-- #BeginEditable "script" --> 
    <!-- #EndEditable --> <!-- #EndTemplate -->
</html>

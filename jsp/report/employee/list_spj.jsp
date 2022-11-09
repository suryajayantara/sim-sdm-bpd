
<%@page import="com.dimata.harisma.entity.report.lkpbu.Lkpbu"%>
<%@page import="com.dimata.harisma.form.report.lkpbu.FrmLkpbu"%>
<%@page import="com.dimata.harisma.form.report.lkpbu.CtrlLkpbu"%>
<%@page import="com.dimata.harisma.entity.report.lkpbu.PstLkpbu"%>
<%@ page language="java" %>
<!-- package java -->
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
<!-- package qdep -->
<%@ include file = "../../main/javainit.jsp" %>
<!-- JSP Block -->
<% int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_REPORTS, AppObjInfo.G2_LEAVE_REPORT, AppObjInfo.OBJ_LEAVE_DP_SUMMARY);%>
<%@ include file = "../../main/checkuser.jsp" %>

<%!    /**
     * create list of report items
     */
    public String drawList(int iCommand, Vector listResult) {
        ControlList ctrlist = new ControlList();
        ctrlist.setAreaWidth("100%");
        ctrlist.setListStyle("tblStyle");
        ctrlist.setTitleStyle("title_tbl");
        ctrlist.setCellStyle("listgensell");
        ctrlist.setHeaderStyle("title_tbl");
        ctrlist.setCellSpacing("0");

        ctrlist.addHeader("EMP_DOC_ID");
        ctrlist.addHeader("EMPLOYEE_ID");
        ctrlist.addHeader("EMP_DOC_LIST_ID");
        ctrlist.addHeader("OBJECTNAME");

        ctrlist.setLinkRow(-1);
        ctrlist.setLinkSufix("");
        Vector lstData = ctrlist.getData();
        Vector lstLinkData = ctrlist.getLinkData();
        ctrlist.setLinkPrefix("javascript:cmdEdit('");
        ctrlist.setLinkSufix("')");
        ctrlist.reset();

        Employee empFetch = new Employee();
        Position pos = new Position();
        Division div = new Division();

        Vector checkCarier = new Vector(1, 1);

        Date dateNow = new Date();

        String lkpbuLvlId = "";
        try {
            lkpbuLvlId = String.valueOf(PstSystemProperty.getValueByName("LKPBU_LEVEL_ID"));//menambahkan system properties
        } catch (Exception e) {
            System.out.println("Exeception ATTANDACE_ON_NO_SCHEDULE:" + e);
        }

        Vector rowx = new Vector(1, 1);
        for (int i = 0; i < listResult.size(); i++) {
            EmpDocList empDocList = (EmpDocList) listResult.get(i);

            rowx.add("");
            rowx.add("");
            rowx.add("");
            rowx.add("");

            lstData.add(rowx);
            lstLinkData.add("0");
        }

        return ctrlist.drawList();
    }
%>


<%    int iCommand = FRMQueryString.requestCommand(request);
    int year = FRMQueryString.requestInt(request, "year");
    int no = FRMQueryString.requestInt(request, "no");
    Date startDate = FRMQueryString.requestDate(request, "startDate");
    Date endDate = FRMQueryString.requestDate(request, "endDate");

    long oidPeriod = FRMQueryString.requestLong(request, "period_id");
    long oidLkpbu = FRMQueryString.requestLong(request, "hidden_lkpbu_id");

    Employee employee = new Employee();

    Vector listEmployee = new Vector();
    Vector listPengikut = new Vector();
    Vector listCheckResult = new Vector();
    Vector listCheckResultAfter = new Vector();
    Vector listCheckPE = new Vector();

    listEmployee = PstEmpDocList.listSPJ(oidPeriod);

//cari riwayat jabatan sekarang
//Vector listEmpPE = PstLkpbu.listPE();
//cari riwayat jabatan pada career path
//Vector listCPwithDate = new Vector();
    Vector listLkpbu = new Vector();
    Vector listBetween = new Vector();
    int iErrCode = FRMMessage.NONE;

    CtrlLkpbu ctrlLkpbu = new CtrlLkpbu(request);
    ControlLine ctrLine = new ControlLine();

    /*switch statement */
    iErrCode = ctrlLkpbu.action(iCommand, oidLkpbu);
    /* end switch*/
    FrmLkpbu frmLkpbu = ctrlLkpbu.getForm();


%>
<!-- End of JSP Block -->
<html>
    <!-- #BeginTemplate "/Templates/main.dwt" -->
    <head>
        <!-- #BeginEditable "doctitle" -->
        <title>HARISMA - Travel Assignment Report</title>
        <style type="text/css">
            #menu_utama {color: #0066CC; font-weight: bold; padding: 5px 14px; border-left: 1px solid #0066CC; font-size: 14px; background-color: #F7F7F7;}
            #mn_utama {color: #FF6600; padding: 5px 14px; border-left: 1px solid #999; font-size: 14px; background-color: #F5F5F5;}
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
            #tdForm {
                padding: 5px;
            }
            .tblStyle {border-collapse: collapse;font-size: 11px;}
            .tblStyle td {padding: 3px 5px; border: 1px solid #CCC;}
            .title_tbl {font-weight: bold;background-color: #DDD; color: #575757;}
        </style>
        <script language="JavaScript">

            function cmdAdd(no) {
                document.lkpbu.hidden_lkpbu_id.value = no;
                document.lkpbu.no.value = no;
                document.lkpbu.command.value = "<%=Command.ADD%>";
                document.lkpbu.action = "list_lkpbu_801.jsp";
                document.lkpbu.submit();
            }

            function cmdSave() {
                document.lkpbu.command.value = "<%=Command.SAVE%>";
                document.lkpbu.action = "list_lkpbu_801.jsp";
                document.lkpbu.submit();
            }

            function cmdEdit(no) {
                document.lkpbu.hidden_lkpbu_id.value = document.getElementById("lkpbu_" + no).value;
                document.lkpbu.command.value = "<%=Command.EDIT%>";
                document.lkpbu.action = "list_lkpbu_801.jsp";
                document.lkpbu.submit();
            }

            function cmdView()
            {
                document.lkpbu.command.value = "<%=String.valueOf(Command.LIST)%>";
                document.lkpbu.action = "list_spj.jsp";
                document.lkpbu.submit();
            }

            function cmdPrint()
            {
                pathUrl = "<%=approot%>/servlet/com.dimata.harisma.report.leave.LeaveApplicationReportPdf?oidLeaveApplication=0&approot=<%=approot%>";
                        //var linkPage = "<%//=printroot%>//.report.leave.LeaveDPStockReportXls?ms=<%//=String.valueOf((new Date()).getTime())%>//";
                        //window.open(linkPage);pathUrl
                        window.open(pathUrl);
                    }

                    function cmdPrintXls()
                    {
                        pathUrl = "<%=approot%>/servlet/com.dimata.harisma.report.leave.LeaveDpSumXls";
                        window.open(pathUrl);
                    }

                    function cmdExportExcel() {

                        var linkPage = "<%=approot%>/report/employee/export_excel/export_excel_list_lkpbu_801.jsp";
                        var newWin = window.open(linkPage, "attdReportDaily", "height=700,width=990,status=yes,toolbar=yes,menubar=no,resizable=yes,scrollbars=yes,location=yes");
                        newWin.focus();

                        //document.frpresence.action="rekapitulasi_absensi.jsp"; 
                        //document.frpresence.target = "SummaryAttendance";
                        //document.frpresence.submit();
                        //document.frpresence.target = "";
                    }

                    //-------------- script control line -------------------
                    function MM_swapImgRestore()
                    { //v3.0
                        var i, x, a = document.MM_sr;
                        for (i = 0; a && i < a.length && (x = a[i]) && x.oSrc; i++)
                            x.src = x.oSrc;
                    }

                    function MM_preloadImages()
                    { //v3.0
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

                    function MM_findObj(n, d)
                    { //v4.0
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

                    function MM_swapImage()
                    { //v3.0
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
                    //-->
        </script>
        <!-- #EndEditable -->
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
        <!-- #BeginEditable "styles" -->
        <link rel="stylesheet" href="../../styles/main.css" type="text/css">
        <!-- #EndEditable --> <!-- #BeginEditable "stylestab" -->
        <link rel="stylesheet" href="../../styles/tab.css" type="text/css">
        <!-- #EndEditable --> <!-- #BeginEditable "headerscript" -->
        <!-- #EndEditable -->
        <link rel="stylesheet" href="<%=approot%>/styles/calendar.css" type="text/css">
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
                                        <td height="20"> <font color="#FF6600" face="Arial"><strong> <!-- #BeginEditable "contenttitle" -->Report 
                                                &gt; Employee &gt; Travel Assignment Report<!-- #EndEditable --> 
                                            </strong></font> </td>
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
                                                                                <form name="lkpbu" method="post" action="">
                                                                                    <input type="hidden" name="command" value="<%=String.valueOf(iCommand)%>">
                                                                                    <input type="hidden" name="hidden_lkpbu_id" value="<%=oidLkpbu%>">
                                                                                    <input type="hidden" name="no" value="<%=no%>">
                                                                                    <table width="60%" border="0" cellspacing="2" cellpadding="2">
                                                                                        <tr> 
                                                                                            <td width="17%" nowrap>
                                                                                                <div align="left">Select Periode</div>
                                                                                                <%
                                                                                                    Vector perValue = new Vector(1, 1);
                                                                                                    Vector perKey = new Vector(1, 1);
                                                                                                    perKey.add("-");
                                                                                                    perValue.add(String.valueOf(0));
                                                                                                    Vector listPeriod = PstPeriod.list(0, 0, "", "" + PstPeriod.fieldNames[PstPeriod.FLD_START_DATE]);
                                                                                                    for (int i = 0; i < listPeriod.size(); i++) {
                                                                                                        Period period = (Period) listPeriod.get(i);
                                                                                                        perKey.add(period.getPeriod());
                                                                                                        perValue.add(String.valueOf(period.getOID()));
                                                                                                    }

                                                                                                %>
                                                                                                <%=  ControlCombo.draw("period_id", "formElemen", null, "" + oidPeriod, perValue, perKey)%>
                                                                                                <!--from --><!--%=ControlDate.drawDateWithStyle("startDate", startDate, 2, -30, "formElemen", "")%-->
                                                                                                <!--to --><!--%=ControlDate.drawDateWithStyle("endDate", endDate, 2, -30, "formElemen", "")%-->
                                                                                                </br>
                                                                                                </br>
                                                                                                <table border="0" cellspacing="0" cellpadding="0" width="197">
                                                                                                    <tr> 
                                                                                                        <td width="24"><a href="javascript:cmdView()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image10', '', '<%=approot%>/images/BtnSearchOn.jpg', 1)" id="aSearch"><img name="Image10" border="0" src="<%=approot%>/images/BtnSearch.jpg" width="24" height="24" alt="View Report LKPBU 801"></a></td>
                                                                                                        <td width="10"><img src="<%=approot%>/images/spacer.gif" width="4" height="1"></td>
                                                                                                        <td width="163" class="command" nowrap><a href="javascript:cmdView()">View Travel Assignment Report</a></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                            <td width="83%">
                                                                                            </td>
                                                                                            <td width="3%">&nbsp;</td>
                                                                                            <td width="78%"> 
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>									  


                                                                                    <%
                                                                                        if (iCommand == Command.LIST || iCommand == Command.ADD || iCommand == Command.SAVE || iCommand == Command.EDIT) {
                                                                                            if (listEmployee != null && listEmployee.size() > 0) {
                                                                                                String tglBerangkat = "";
                                                                                                String tglKembali = "";
                                                                                                String tujuan = "";
                                                                                                String keperluan = "";
                                                                                                String angkutan = "";

                                                                                                String nomorSPJ = "";
                                                                                                String tipeSPJ = "";
                                                                                                String gradePetugas = "";
                                                                                                String jabatanPetugas = "";
                                                                                                String divisiPetugas = "";
                                                                                                String jabatanTTD = "";
                                                                                                String tanggalSPJ = "";
                                                                                                //String gradePengikut = "";
                                                                                                String jabatanPengikut = "";
                                                                                                String pengikutExternal = "";
                                                                                                String[] pengikut2 = {""};

                                                                                                Date tanggalBerangkat = new Date();
                                                                                                Date tanggalKembali = new Date();

                                                                                                long oidSign = 0;

                                                                                                EmpDoc employeeDoc = new EmpDoc();
                                                                                                Employee emp = new Employee();
                                                                                                Employee empSign = new Employee();
                                                                                                Employee empPengikut = new Employee();
                                                                                                GradeLevel grade = new GradeLevel();
                                                                                                GradeLevel gradePengikut = new GradeLevel();
                                                                                                Position pos = new Position();
                                                                                                Position posSign = new Position();
                                                                                                Position posPengikut = new Position();
                                                                                                int rowSpan = 1;
                                                                                    %>
                                                                                    <table width="100%" border="0" cellspacing="2" cellpadding="2">
                                                                                        <tr>
                                                                                            <td><hr></td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                        <table class="tblStyle">
                                                                                            <tr>
                                                                                                <td rowspan="2" class="title_tbl" style="background-color: #DDD;" align="center">No</td>
                                                                                                <td rowspan="2" class="title_tbl" style="background-color: #DDD;" align="center">Nomor SPJ</td>
                                                                                                <td rowspan="2" class="title_tbl" style="background-color: #DDD;" align="center">Tipe SPJ</td>
                                                                                                <td rowspan="2" class="title_tbl" style="background-color: #DDD;" align="center">Tanggal SPJ</td>
                                                                                                <td rowspan="2" class="title_tbl" style="background-color: #DDD;" align="center">Tanggal Berangkat</td>
                                                                                                <td rowspan="2" class="title_tbl" style="background-color: #DDD;" align="center">Tanggal Kembali</td>
                                                                                                <td rowspan="2" class="title_tbl" style="background-color: #DDD;" align="center">NRK/NKK</td>
                                                                                                <td rowspan="2" class="title_tbl" style="background-color: #DDD;" align="center">Nama Petugas</td>
                                                                                                <td rowspan="2" class="title_tbl" style="background-color: #DDD;" align="center">Grade Petugas</td>
                                                                                                <td rowspan="2" class="title_tbl" style="background-color: #DDD;" align="center">Jabatan Petugas</td>
                                                                                                <td rowspan="2" class="title_tbl" style="background-color: #DDD;" align="center">Divisi / Cabang Petugas</td>
                                                                                                <td rowspan="2" class="title_tbl" style="background-color: #DDD;" align="center">Tempat Tujuan</td>
                                                                                                <td rowspan="2" class="title_tbl" style="background-color: #DDD;" align="center">Keperluan</td>
                                                                                                <td rowspan="2" class="title_tbl" style="background-color: #DDD;" align="center">Angkutan</td>
                                                                                                <td rowspan="2" class="title_tbl" style="background-color: #DDD;" align="center">Nama TTD</td>
                                                                                                <td rowspan="2" class="title_tbl" style="background-color: #DDD;" align="center">Jabatan TTD</td>
                                                                                                <td rowspan="2" class="title_tbl" style="background-color: #DDD;" align="center">Biaya</td>
                                                                                                <td colspan="5" class="title_tbl" style="background-color: #DDD;" align="center">Pengikut Internal</td>
                                                                                                <td class="title_tbl" style="background-color: #DDD;" align="center">Pengikut External</td>
                                                                                            </tr>
                                                                                            <tr>
                                                                                                <td class="title_tbl" style="background-color: #DDD;" align="center">NRK / NKK</td>
                                                                                                <td class="title_tbl" style="background-color: #DDD;" align="center">Nama</td>
                                                                                                <td class="title_tbl" style="background-color: #DDD;" align="center">Grade</td>
                                                                                                <td class="title_tbl" style="background-color: #DDD;" align="center">Jabatan</td>
                                                                                                <td class="title_tbl" style="background-color: #DDD;" align="center">Divisi/Cabang</td>
                                                                                                <td class="title_tbl" style="background-color: #DDD;" align="center">Nama</td>
                                                                                            </tr>
                                                                                            <% for (int i = 0; i < listEmployee.size(); i++) {
                                                                                                    EmpDocList empDoc = (EmpDocList) listEmployee.get(i);

                                                                                                    tglBerangkat = PstEmpDocField.getObject(empDoc.getEmp_doc_id(), "TGL_BERANGKAT");
                                                                                                    tglKembali = PstEmpDocField.getObject(empDoc.getEmp_doc_id(), "TGL_KEMBALI");
                                                                                                    tujuan = PstEmpDocField.getObject(empDoc.getEmp_doc_id(), "TUJUAN");
                                                                                                    keperluan = PstEmpDocField.getObject(empDoc.getEmp_doc_id(), "KEPERLUAN");
                                                                                                    angkutan = PstEmpDocField.getObject(empDoc.getEmp_doc_id(), "ANGKUTAN");
                                                                                                    pengikutExternal = PstEmpDocField.getObject(empDoc.getEmp_doc_id(), "PENGIKUT2");
                                                                                                    pengikutExternal = pengikutExternal.replaceAll("dan ", ",");
                                                                                                    pengikutExternal = pengikutExternal.startsWith(",") ? pengikutExternal.substring(1) : pengikutExternal;
                                                                                                    pengikut2 = pengikutExternal.split(",");

                                                                                                    try {
                                                                                                        employeeDoc = PstEmpDoc.fetchExc(empDoc.getEmp_doc_id());
                                                                                                        emp = PstEmployee.fetchExc(empDoc.getEmployee_id());
                                                                                                        grade = PstGradeLevel.fetchExc(emp.getGradeLevelId());
                                                                                                        pos = PstPosition.fetchExc(emp.getPositionId());
                                                                                                    } catch (Exception exc) {

                                                                                                    }

                                                                                                    gradePetugas = grade.getCodeLevel();
                                                                                                    jabatanPetugas = pos.getPosition();

                                                                                                    nomorSPJ = employeeDoc.getDoc_number();
                                                                                                    nomorSPJ = nomorSPJ.split("/", 2)[0];

                                                                                                    SimpleDateFormat sdf = new SimpleDateFormat("dd MMMM yyyy");
                                                                                                    SimpleDateFormat strFormat = new SimpleDateFormat("yyyy-MM-dd");
                                                                                                    tanggalSPJ = sdf.format(employeeDoc.getDate_of_issue());

                                                                                                    if (!(tglBerangkat.equals(""))) {
                                                                                                        tanggalBerangkat = strFormat.parse(tglBerangkat);
                                                                                                        tglBerangkat = sdf.format(tanggalBerangkat);
                                                                                                    } else {
                                                                                                        tglBerangkat = "-";
                                                                                                    }
                                                                                                    if (!(tglKembali.equals(""))) {
                                                                                                        tanggalKembali = strFormat.parse(tglKembali);
                                                                                                        tglKembali = sdf.format(tanggalKembali);
                                                                                                    } else {
                                                                                                        tglKembali = "-";
                                                                                                    }

                                                                                                    oidSign = PstEmpDocList.getOIDSign(empDoc.getEmp_doc_id());
                                                                                                    try {
                                                                                                        empSign = PstEmployee.fetchExc(oidSign);
                                                                                                        posSign = PstPosition.fetchExc(empSign.getPositionId());
                                                                                                    } catch (Exception exc) {

                                                                                                    }

                                                                                                    String whereStatus = PstEmpDocList.fieldNames[PstEmpDocList.FLD_EMP_DOC_ID] + " = " + empDoc.getEmp_doc_id() + " AND " + PstEmpDocList.fieldNames[PstEmpDocList.FLD_OBJECT_NAME] + " = 'TRAINNERLISTLINE'";
                                                                                                    listPengikut = PstEmpDocList.list(0, 0, whereStatus, "");
                                                                                                    if (listPengikut.size() > 0 || pengikut2.length > 0) {
                                                                                                        if (listPengikut.size() >= pengikut2.length) {
                                                                                                            rowSpan = listPengikut.size();
                                                                                                        } else {
                                                                                                            rowSpan = pengikut2.length;
                                                                                                        }
                                                                                                    } else {
                                                                                                        rowSpan = 1;
                                                                                                    }


                                                                                            %>
                                                                                            <tr>
                                                                                                <td class="listgensell" rowspan="<%=rowSpan%>" style="vertical-align: top"><%=i + 1%></td>
                                                                                                <td class="listgensell" rowspan="<%=rowSpan%>" style="vertical-align: top"><%=nomorSPJ%></td>
                                                                                                <td class="listgensell" rowspan="<%=rowSpan%>" style="vertical-align: top"></td>
                                                                                                <td class="listgensell" rowspan="<%=rowSpan%>" style="vertical-align: top"><%=tanggalSPJ%></td>
                                                                                                <td class="listgensell" rowspan="<%=rowSpan%>" style="vertical-align: top"><%=tglBerangkat%></td>
                                                                                                <td class="listgensell" rowspan="<%=rowSpan%>" style="vertical-align: top"><%=tglKembali%></td>
                                                                                                <td class="listgensell" rowspan="<%=rowSpan%>" style="vertical-align: top"><%=emp.getEmployeeNum()%></td>
                                                                                                <td class="listgensell" rowspan="<%=rowSpan%>" style="vertical-align: top"><%=emp.getFullName()%></td>
                                                                                                <td class="listgensell" rowspan="<%=rowSpan%>" style="vertical-align: top"><%=gradePetugas%></td>
                                                                                                <td class="listgensell" rowspan="<%=rowSpan%>" style="vertical-align: top"><%=jabatanPetugas%></td>
                                                                                                <td class="listgensell" rowspan="<%=rowSpan%>" style="vertical-align: top"></td>
                                                                                                <td class="listgensell" rowspan="<%=rowSpan%>" style="vertical-align: top"><%=tujuan%></td>
                                                                                                <td class="listgensell" rowspan="<%=rowSpan%>" style="vertical-align: top"><%=keperluan%></td>
                                                                                                <td class="listgensell" rowspan="<%=rowSpan%>" style="vertical-align: top"><%=angkutan%></td>
                                                                                                <td class="listgensell" rowspan="<%=rowSpan%>" style="vertical-align: top"><%=empSign.getFullName()%></td>
                                                                                                <td class="listgensell" rowspan="<%=rowSpan%>" style="vertical-align: top"><%=posSign.getPosition()%></td>
                                                                                                <td class="listgensell" rowspan="<%=rowSpan%>" style="vertical-align: top"></td>
                                                                                                <%
                                                                                                    if (listPengikut.size() > 0 || pengikut2.length > 0) {
                                                                                                        if (listPengikut.size() >= pengikut2.length){
                                                                                                        for (int x = 0; x < listPengikut.size(); x++) {
                                                                                                            EmpDocList empDocList = (EmpDocList) listPengikut.get(x);

                                                                                                            try {
                                                                                                                empPengikut = PstEmployee.fetchExc(empDocList.getEmployee_id());
                                                                                                                posPengikut = PstPosition.fetchExc(empPengikut.getPositionId());
                                                                                                                gradePengikut = PstGradeLevel.fetchExc(empPengikut.getGradeLevelId());
                                                                                                            } catch (Exception exc) {
                                                                                                            }

                                                                                                %>
                                                                                                <td class="listgensell"><%=empPengikut.getEmployeeNum()%></td>
                                                                                                <td class="listgensell"><%=empPengikut.getFullName()%></td>
                                                                                                <td class="listgensell"><%=gradePengikut.getCodeLevel()%></td>
                                                                                                <td class="listgensell"><%=posPengikut.getPosition()%></td>
                                                                                                <td class="listgensell"></td>
                                                                                                <%
                                                                                                    if (pengikut2.length == 0) {
                                                                                                %>
                                                                                                <td class="listgensell"></td>
                                                                                                <%
                                                                                                } else if (pengikut2.length > x) {
                                                                                                %>            
                                                                                                <td class="listgensell"><%=pengikut2[x]%></td>
                                                                                                <%
                                                                                                } else {
                                                                                                %>
                                                                                                <td class="listgensell"></td>
                                                                                                <%
                                                                                                    }
                                                                                                %>
                                                                                            </tr>
                                                                                            <tr>
                                                                                                <%
                                                                                                        }
                                                                                                        } else if (pengikut2.length > listPengikut.size()) {
                                                                                                            for (int x = 0; x < pengikut2.length; x++) {
                                                                                                                if (listPengikut.size() == 0) {
                                                                                                %>
                                                                                                <td class="listgensell"></td>
                                                                                                <td class="listgensell"></td>
                                                                                                <td class="listgensell"></td>
                                                                                                <td class="listgensell"></td>
                                                                                                <td class="listgensell"></td>
                                                                                                <td class="listgensell"><%=pengikut2[x]%></td>
                                                                                                <%
                                                                                                            } else if (listPengikut.size() > x){
                                                                                                            EmpDocList empDocList = (EmpDocList) listPengikut.get(x);

                                                                                                            try {
                                                                                                                empPengikut = PstEmployee.fetchExc(empDocList.getEmployee_id());
                                                                                                                posPengikut = PstPosition.fetchExc(empPengikut.getPositionId());
                                                                                                                gradePengikut = PstGradeLevel.fetchExc(empPengikut.getGradeLevelId());
                                                                                                            } catch (Exception exc) {
                                                                                                            }
                                                                                                %>
                                                                                                <td class="listgensell"><%=empPengikut.getEmployeeNum()%></td>
                                                                                                <td class="listgensell"><%=empPengikut.getFullName()%></td>
                                                                                                <td class="listgensell"><%=gradePengikut.getCodeLevel()%></td>
                                                                                                <td class="listgensell"><%=posPengikut.getPosition()%></td>
                                                                                                <td class="listgensell"></td>
                                                                                                <td class="listgensell"><%=pengikut2[x]%></td>
                                                                                                <%

                                                                                                            } else {
                                                                                                %>
                                                                                                <td class="listgensell"></td>
                                                                                                <td class="listgensell"></td>
                                                                                                <td class="listgensell"></td>
                                                                                                <td class="listgensell"></td>
                                                                                                <td class="listgensell"></td>
                                                                                                <td class="listgensell"><%=pengikut2[x]%></td>
                                                                                                <%
                                                                                                }
                                                                                                %>
                                                                                                </tr>
                                                                                            <tr>
                                                                                                <%
                                                                                                        }
                                                                                                
                                                                                                    }

                                                                                                } else {
                                                                                                %>
                                                                                                <td class="listgensell"></td>
                                                                                                <td class="listgensell"></td>
                                                                                                <td class="listgensell"></td>
                                                                                                <td class="listgensell"></td>
                                                                                                <td class="listgensell"></td>
                                                                                                <td class="listgensell"></td>
                                                                                                <%
                                                                                                    }
                                                                                                %>
                                                                                            </tr>
                                                                                            <%
                                                                                                }
                                                                                            %> 
                                                                                        </table>
                                                                                        <td></td>
                                                                                        </tr>
                                                                                        <%
                                                                                            if (listEmployee.size() > 0 && privPrint) {
                                                                                        %>
                                                                                        <tr>
                                                                                            <td class="command">
                                                                                                <table border="0" cellspacing="0" cellpadding="0" width="197">
                                                                                                    <tr>
                                                                                                        <td width="24"><a href="javascript:cmdExportExcel()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image110', '', '<%=approot%>/images/BtnNewOn.jpg', 1)" id="aSearch"><img name="Image110" border="0" src="<%=approot%>/images/BtnNew.jpg" width="24" height="24" alt="Print Report"></a></td>
                                                                                                        <td width="10"><img src="<%=approot%>/images/spacer.gif" width="4" height="1"></td>
                                                                                                        <td width="163" class="command" nowrap><a href="javascript:cmdExportExcel()">Export to Excel</a></td>
                                                                                                    </tr>
                                                                                                </table></td>
                                                                                        </tr>
                                                                                        <%
                                                                                            }
                                                                                        %>
                                                                                    </table>
                                                                                    <%
                                                                                            }
                                                                                        }
                                                                                    %>									  
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



<%@page import="com.dimata.harisma.form.report.lkpbu.FrmLkpbu"%>
<%@page import="com.dimata.harisma.entity.report.lkpbu.Lkpbu"%>
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
    public String drawList(Vector listResult) {
        ControlList ctrlist = new ControlList();
        ctrlist.setAreaWidth("100%");
        ctrlist.setListStyle("tblStyle");
        ctrlist.setTitleStyle("title_tbl");
        ctrlist.setCellStyle("listgensell");
        ctrlist.setHeaderStyle("title_tbl");
        ctrlist.setCellSpacing("0");



        ctrlist.addHeader("Sandi Pelapor", "25%", "0", "6");
        ctrlist.addHeader("Jenis Periode Pelaporan", "15%", "0", "3");
        ctrlist.addHeader("Periode Data Pelaporan", "15%", "0", "4");
        ctrlist.addHeader("Jenis Laporan", "15%", "0", "5");
        ctrlist.addHeader("No Form", "15%", "0", "2");
        ctrlist.addHeader("Jumlah Record Isi", "15%", "0", "3");

        ctrlist.addHeader("000000129", "25%", "0", "6");
        ctrlist.addHeader("M", "15%", "0", "3");
        ctrlist.addHeader("20160701", "15%", "0", "4");
        ctrlist.addHeader("A", "15%", "0", "5");
        ctrlist.addHeader("801", "15%", "0", "2");
        ctrlist.addHeader("9", "15%", "0", "3");

        ctrlist.addHeader("Status Data", "2%", "0", "0");
        ctrlist.addHeader("NIP", "2%", "0", "0");
        ctrlist.addHeader("Nama Pejabat Eksekutif", "2%", "0", "0");
        ctrlist.addHeader("Status Tenaga Kerja", "2%", "0", "0");
        ctrlist.addHeader("Nama Jabatan", "2%", "0", "0");
        ctrlist.addHeader("Alamat Rumah (Saat Ini)", "2%", "0", "0");

        ctrlist.addHeader("Alamat KTP atau Paspor atau KITAS (WNA)", "20%", "0", "0");
        ctrlist.addHeader("No. Telp", "2%", "0", "0");
        ctrlist.addHeader("No. Fax", "2%", "0", "0");
        ctrlist.addHeader("NPWP", "2%", "0", "0");
        ctrlist.addHeader("No. ID", "2%", "0", "0");

        ctrlist.addHeader("Tempat Lahir", "4%", "0", "0");
        ctrlist.addHeader("Tgl Lahir ", "4%", "0", "0");
        ctrlist.addHeader("Kewarganegaraan", "4%", "0", "0");
        ctrlist.addHeader("Jenis kelamin", "4%", "0", "0");
        ctrlist.addHeader("No. Surat Pelaporan", "4%", "0", "0");
        ctrlist.addHeader("Tanggal Surat Pelaporan ", "4%", "0", "0");

        ctrlist.addHeader("Status PE", "4%", "0", "0");
        ctrlist.addHeader("Nomor Surat Keputusan Pengangkatan/Penggantian/Penggantian Sementara", "20%", "0", "0");
        ctrlist.addHeader("Tanggal Efektif Pengangkatan/Penggantian/Penggantian Sementara", "20%", "0", "0");
        ctrlist.addHeader("Nomor Surat Keputusan Pemberhentian", "20%", "0", "0");
        ctrlist.addHeader("Tanggal Efektif Pemberhentian", "4%", "0", "0");
        ctrlist.addHeader("Keterangan", "4%", "0", "0");

        ctrlist.setLinkRow(-1);
        ctrlist.setLinkSufix("");
        Vector lstData = ctrlist.getData();
        Vector lstLinkData = ctrlist.getLinkData();
        ctrlist.setLinkPrefix("javascript:cmdEdit('");
        ctrlist.setLinkSufix("')");
        ctrlist.reset();

        Vector rowx = new Vector(1, 1);
        for (int i = 0; i < listResult.size(); i++) {
            Employee employee = (Employee) listResult.get(i);

            rowx = new Vector(1, 1);
            rowx.add("1");
            rowx.add("0000000000000000" + employee.getEmployeeNum());

            String fullname = employee.getFullName();
            String[] splits = fullname.split(",");
            ArrayList name = new ArrayList();
            for (int j = 0; j < splits.length; j++) {
                name.add(splits[j].trim());
            }
            rowx.add("" + splits[0]);
            rowx.add("1");
            rowx.add(employee.getPositionName() + " " + employee.getDepartmentName());
            rowx.add("" + employee.getAddress());
            rowx.add("" + employee.getAddressPermanent());
            rowx.add("" + employee.getPhone());
            rowx.add("");

            String npwp = employee.getNpwp();
            npwp = npwp.replaceAll("[-,.]", "");
            rowx.add("" + npwp);

            rowx.add("" + employee.getIndentCardNr());
            rowx.add(employee.getBirthPlace());
            rowx.add(Formater.formatDate(employee.getBirthDate(), "ddMMyyyy"));
            rowx.add("ID");
            if (employee.getSex() == 0) {
                rowx.add("1");
            } else {
                rowx.add("2");
            }

            rowx.add("");
            rowx.add("");
            rowx.add("1");
            rowx.add("");
            rowx.add(Formater.formatDate(employee.getCommencingDate(), "ddMMyyyy"));
            rowx.add("");
            rowx.add(Formater.formatDate(employee.getResignedDate(), "ddMMyyyy"));
            rowx.add("");

            lstData.add(rowx);
            lstLinkData.add("0");
        }

        return ctrlist.drawList();
    }
%>


<%
    
    int iCommand = FRMQueryString.requestCommand(request);
    long oidPeriod = FRMQueryString.requestLong(request, "period_id");
    String whereclause = "" + PstPeriod.fieldNames[PstPeriod.FLD_PERIOD_ID] + "=" + oidPeriod + "";
    Vector getPeriod = PstPeriod.list(0, 1, whereclause, "");
    String periodFrom = "";
    String periodTo = "";
    for (int i = 0; i < getPeriod.size(); i++) {
        Period period = (Period) getPeriod.get(i);
        periodFrom = String.valueOf(period.getStartDate());
        periodTo = String.valueOf(period.getEndDate());
    }

    // period = "";

    Vector listResult = new Vector(1, 1);
    listResult = PstCareerPath.listEmployeePECareerPath(periodFrom, periodTo);

    Vector listKadiv = new Vector(1, 1);

// for list

    Employee employee = new Employee();

    session.putValue("listresult", listResult);
//get value kadiv HRD
    String kadivPositionOid = PstSystemProperty.getValueByName("HR_DIR_POS_ID");
    String whereClauseOidPosition = "POSITION_ID='" + kadivPositionOid + "'";

    listKadiv = PstLkpbu.listPosition(whereClauseOidPosition);
    session.putValue("listkadiv", listKadiv);
    
    if (iCommand == Command.SAVE) {
        String[] lkpbuid = null;
        String[] employeeId = null;
        String[] periodId = null;
        String[] noPelaporan = null;
        String[] tglPelaporan = null;
        String[] noSK = null;
        String[] tglSK = null;
        String[] noPemberhentian = null;
        String[] tglPemberhentian = null;
        String[] keterangan = null;
        
        Vector vLKPBU801 = new Vector();
        try {
            lkpbuid = request.getParameterValues("lkpbuid");
            employeeId = new String[lkpbuid.length];
            periodId = new String[lkpbuid.length];
            noPelaporan = new String[lkpbuid.length];
            tglPelaporan = new String[lkpbuid.length];
            noSK = new String[lkpbuid.length];
            tglSK = new String[lkpbuid.length];
            noPemberhentian = new String[lkpbuid.length];
            tglPemberhentian = new String[lkpbuid.length];
            keterangan = new String[lkpbuid.length];
            
            for (int i=0; i<lkpbuid.length;i++){
                employeeId[i] = FRMQueryString.requestString(request,FrmLkpbu.fieldNames[FrmLkpbu.FRM_FIELD_EMPLOYEE_ID]+"_"+i);
                periodId[i] = FRMQueryString.requestString(request,FrmLkpbu.fieldNames[FrmLkpbu.FRM_FIELD_PERIOD_ID]+"_"+i);
                noPelaporan[i] = FRMQueryString.requestString(request,FrmLkpbu.fieldNames[FrmLkpbu.FRM_FIELD_NO_SURAT_PELAPORAN]+"_"+i);
                tglPelaporan[i] = FRMQueryString.requestString(request,FrmLkpbu.fieldNames[FrmLkpbu.FRM_FIELD_TANGGAL_SURAT_PELAPORAN]+"_"+i);
                noSK[i] = FRMQueryString.requestString(request,FrmLkpbu.fieldNames[FrmLkpbu.FRM_FIELD_NO_SK]+"_"+i);
                tglSK[i] = FRMQueryString.requestString(request,FrmLkpbu.fieldNames[FrmLkpbu.FRM_FIELD_TANGGAL_SK]+"_"+i);
                noPemberhentian[i] = FRMQueryString.requestString(request,FrmLkpbu.fieldNames[FrmLkpbu.FRM_FIELD_NO_SK_PEMBERHENTIAN]+"_"+i);
                tglPemberhentian[i] = FRMQueryString.requestString(request,FrmLkpbu.fieldNames[FrmLkpbu.FRM_FIELD_TANGGAL_SK_PEMBERHENTIAN]+"_"+i);
                keterangan[i] = FRMQueryString.requestString(request,FrmLkpbu.fieldNames[FrmLkpbu.FRM_FIELD_KETERANGAN]+"_"+i);
            }
            
            for (int i=0; i<lkpbuid.length;i++){
                Lkpbu lkpbu = new Lkpbu();
                lkpbu.setOID(Long.valueOf(lkpbuid[i]));
                lkpbu.setEmployeeId(Long.valueOf(employeeId[i]));
                lkpbu.setPeriodId(Long.valueOf(periodId[i]));
                lkpbu.setNoSuratPelaporan(noPelaporan[i]);
                lkpbu.setTanggalSuratPelaporan(tglPelaporan[i]);
                lkpbu.setNoSK(noSK[i]);
                lkpbu.setTanggalSK(tglSK[i]);
                lkpbu.setNoSKPemberhentian(noPemberhentian[i]);
                lkpbu.setTanggalSKPemberhentian(tglPemberhentian[i]);
                lkpbu.setKeterangan(keterangan[i]);
                try {
                    long oid = PstLkpbu.updateExc(lkpbu);
                } catch (Exception exc){
                    System.out.println(exc.toString());
                }
            }
            
        } catch (Exception exc){
            System.out.println(exc.toString());
        }
        
    }

%>
<!-- End of JSP Block -->
<html>
    <!-- #BeginTemplate "/Templates/main.dwt" -->
    <head>
        <!-- #BeginEditable "doctitle" -->
        <title>HARISMA - LKPBU 801 Report</title>
        <script language="JavaScript">
            <!--
            function cmdView()
            {
                document.lkpbu.command.value="<%=String.valueOf(Command.LIST)%>";
                document.lkpbu.action="list_lkpbu_801.jsp";
                document.lkpbu.submit();
            }
            
            function cmdSave()
            {
                document.lkpbu.command.value="<%=String.valueOf(Command.SAVE)%>";
                document.lkpbu.action="list_lkpbu_801.jsp";
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
            
            function cmdExportExcel()
            {
                document.lkpbu.command.value="<%=String.valueOf(Command.LIST)%>";
                document.lkpbu.action="<%=approot%>/report/employee/export_excel/export_excel_list_lkpbu_801.jsp";
                document.lkpbu.submit();
            }

//            function cmdExportExcel(){
//                var result = new Array();
//                for(var j = 0; j < <%=listResult.size()%>; j++){
//                    result[j] = document.getElementById("noSP_"+j).value+";"
//                        +document.getElementById("tglSP_"+j).value+";"
//                        +document.getElementById("noSKP_"+j).value+";"
//                        +document.getElementById("tglEP_"+j).value+";"
//                        +document.getElementById("noSKR_"+j).value+";"
//                        +document.getElementById("tglEPR_"+j).value+";"
//                        +document.getElementById("note_"+j).value+";";
//                    //x`alert(result[j]);
//                }
//                var oidPeriod = document.getElementsByName("period_id").value;
//                var linkPage = "<%=approot%>/report/employee/export_excel/export_excel_list_lkpbu_801.jsp?period_id="+oidPeriod;    
//                var newWin = window.open(linkPage,"attdReportDaily","height=700,width=990,status=yes,toolbar=yes,menubar=no,resizable=yes,scrollbars=yes,location=yes"); 			
//                newWin.focus();
//                }
            
                /* var result=[];
                alert("ok");
                for(var i = 0; i < 3; i++){
                    var noSP = document.getElementById("noSP_"+i).value;
                    var tglSP = document.getElementById("tglSP_"+i).value;
                    var noSKP = document.getElementById("noSKP_"+i).value;
                    var tglEP = document.getElementById("tglEP_"+i).value;
                    var noSKR = document.getElementById("noSKR_"+i).value;
                    var tglEPR = document.getElementById("tglEPR_"+i).value;
                    var note = document.getElementById("note_"+i).value;
                    alert(noSP+tglSP+noSKP+tglEP+noSKR+tglEPR+note);
                }*/
                
                /* for(var i = 0; i < 3; i++){
                    result[i] = document.getElementById("noSP_"+i).value+";"
                        +document.getElementById("tglSP_"+i).value+";"
                        +document.getElementById("noSKP_"+i).value+";"
                        +document.getElementById("tglEP_"+i).value+";"
                        +document.getElementById("noSKR_"+i).value+";"
                        +document.getElementById("tglEPR_"+i).value+";"
                        +document.getElementById("note_"+i).value+";";
                    alert(result[i]);
                    
                }*/ 
        
                

                //document.frpresence.action="rekapitulasi_absensi.jsp"; 
                //document.frpresence.target = "SummaryAttendance";
                //document.frpresence.submit();
                //document.frpresence.target = "";
            

            //-------------- script control line -------------------
            function MM_swapImgRestore() 
            { //v3.0
                var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
            }

            function MM_preloadImages() 
            { //v3.0
                var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
                    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
                        if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
                }

                function MM_findObj(n, d) 
                { //v4.0
                    var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
                        d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
                    if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
                    for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
                    if(!x && document.getElementById) x=document.getElementById(n); return x;
                }

                function MM_swapImage() 
                { //v3.0
                    var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
                        if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
                }
                //-->
        </script>
        <link rel="stylesheet" href="../../styles/main.css" type="text/css">
        <link rel="stylesheet" href="../../styles/tab.css" type="text/css">
        <link href="<%=approot%>/stylesheets/superTables.css" rel="Stylesheet" type="text/css" /> 
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
            .tableScroll{}
            #tbl {border-collapse: collapse;font-size: 11px;display: inline-block; height: 40%; width: 40%;overflow: auto;}
            .tblStyle td {padding: 3px 5px; border: 1px solid #CCC;}
            .title_tbl {font-weight: bold;background-color: #ffffff; color: #575757; width: 100%; height: 100%}
        </style>
        <link rel="stylesheet" href="<%=approot%>/javascripts/datepicker/themes/jquery.ui.all.css">
        <script src="<%=approot%>/javascripts/jquery.js"></script>
        <script src="<%=approot%>/javascripts/datepicker/jquery.ui.core.js"></script>
        <script src="<%=approot%>/javascripts/datepicker/jquery.ui.widget.js"></script>
        <script src="<%=approot%>/javascripts/datepicker/jquery.ui.datepicker.js"></script>
        <script>
                function pageLoad(){ $(".mydate").datepicker({ dateFormat: "yy-mm-dd" }); } 
        </script>
        <!-- #EndEditable -->
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
        <!-- #BeginEditable "styles" -->
        <link rel="stylesheet" href="../../styles/main.css" type="text/css">
        <!-- #EndEditable --> <!-- #BeginEditable "stylestab" -->
        <link rel="stylesheet" href="../../styles/tab.css" type="text/css">
        <!-- #EndEditable --> <!-- #BeginEditable "headerscript" -->
        <!-- #EndEditable -->
    </head><!---->
    <body onLoad="pageLoad()">
        <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%" bgcolor="#FFFFFF" >
            <%if (headerStyle && !verTemplate.equalsIgnoreCase("0")) {%> 
            <%@include file="../../styletemplate/template_header.jsp" %>
            <%} else {%>
            <tr> 
                <td ID="TOPTITLE" background="<%=approot%>/images/HRIS_HeaderBg3.jpg" width="100%" height="54" colspan="6"> 
                    <!-- #BeginEditable "header" --> 
                    <%@ include file = "../../main/header.jsp" %>
                    <!-- #EndEditable --> 
                </td>
            </tr>
            <tr> 
                <td  bgcolor="#9BC1FF" height="15" ID="MAINMENU" valign="middle" colspan="6"> <!-- #BeginEditable "menumain" --> 
                    <%@ include file = "../../main/mnmain.jsp" %>
                    <!-- #EndEditable --> 
                </td>
            </tr>
            <tr> 
                <td  bgcolor="#9BC1FF" height="10" valign="middle" colspan="6"> 
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
                <td width="88%" valign="top" align="left" colspan="6"> 
                    <table width="100%" border="0" cellspacing="3" cellpadding="2">
                        <tr> 
                            <td width="100%"> 
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr> 
                                        <td height="20"> 
                                            <font color="#FF6600" face="Arial">
                                            <strong> <!-- #BeginEditable "contenttitle" -->Report &gt; Employee &gt; LKPBU Form 801<!-- #EndEditable --></strong></font> 
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
                                                                                <form name="lkpbu" method="post" action="">
                                                                                    <input type="hidden" name="command" value="<%=String.valueOf(iCommand)%>">
                                                                                    <table width="60%" border="0" cellspacing="2" cellpadding="2">
                                                                                        <tr> 
                                                                                            <td valign="middle">
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
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td>
                                                                                                <table border="0" cellspacing="0" cellpadding="0" width="197">
                                                                                                    <tr> 
                                                                                                        <td width="24"><a href="javascript:cmdView()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image10','','<%=approot%>/images/BtnSearchOn.jpg',1)" id="aSearch"><img name="Image10" border="0" src="<%=approot%>/images/BtnSearch.jpg" width="24" height="24" alt="View Report LKPBU 801"></a></td>
                                                                                                        <td width="10"><img src="<%=approot%>/images/spacer.gif" width="4" height="1"></td>
                                                                                                        <td width="163" class="command" nowrap><a href="javascript:cmdView()">View LKPBU 801 Report</a></td>
                                                                                                        <%
                                                                                                            if (iCommand == Command.LIST || iCommand == Command.SAVE) {
                                                                                                        %>

                                                                                                        <td width="24"><a href="javascript:cmdExportExcel()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image110','','<%=approot%>/images/BtnNewOn.jpg',1)" id="aSearch"><img name="Image110" border="0" src="<%=approot%>/images/BtnNew.jpg" width="24" height="24" alt="Print Report"></a></td>
                                                                                                        <td width="10"><img src="<%=approot%>/images/spacer.gif" width="4" height="1"></td>
                                                                                                        <td width="163" class="command" nowrap><a href="javascript:cmdExportExcel()">Export to Excel</a></td>
                                                                                                        <%}%>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>									  


                                                                                    <%
                                                                                    if (iCommand == Command.LIST || iCommand == Command.SAVE) {
                                                                                        String sandiPelapor = PstSystemProperty.getValueByName("LKPBU_SANDI_PELAPOR");
                                                                                        String jenisPeriodPelaporan = PstSystemProperty.getValueByNameWithStringNull("LKPBU_801_PERIOD");
                                                                                        String jenisLaporan = PstSystemProperty.getValueByNameWithStringNull("JENIS_LAPORAN_801");
                                                                                        Period periode = new Period();
                                                                                        String datelap = "";
                                                                                        try {
                                                                                            periode = PstPeriod.fetchExc(oidPeriod);
                                                                                            Date periodelap = periode.getStartDate();
                                                                                            datelap = "" + periodelap;
                                                                                            datelap = datelap.replaceAll("-", "");

                                                                                        } catch (Exception exc) {
                                                                                        }
                                                                                        //String whereclause = 
                                                                                        //int periodPelaporan = PstPeriod.list(1, "", , "");
%>
                                                                                    <table  border="0" cellspacing="2" cellpadding="2">
                                                                                        <tr>
                                                                                            <td><hr></td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td>
                                                                                                <table class="tblStyle" >
                                                                                                    <tr>
                                                                                                        <td class="title_tbl" style="background-color: #33AAFF;" colspan="6" ><font color="white">Sandi Pelapor </td>
                                                                                                        <td class="title_tbl" style="background-color: #33AAFF;" colspan="3"><font color="white">Jenis Periode Pelaporan</td>
                                                                                                        <td class="title_tbl" style="background-color: #33AAFF;" colspan="4"><font color="white">Periode Data Pelaporan</td>
                                                                                                        <td class="title_tbl" style="background-color: #33AAFF;" colspan="6"><font color="white">Jenis Laporan</td>
                                                                                                        <td class="title_tbl" style="background-color: #33AAFF;" colspan="2"><font color="white">No Form</td>
                                                                                                        <td class="title_tbl" style="background-color: #33AAFF;" colspan="3"><font color="white">Jumlah Record Isi</td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td class="title_tbl" style="background-color: #FFF; text-align: center" colspan="6"><%= sandiPelapor%></td>
                                                                                                        <td class="title_tbl" style="background-color: #FFF; text-align: center" colspan="3"><%= jenisPeriodPelaporan%></td>
                                                                                                        <td class="title_tbl" style="background-color: #FFF; text-align: center" colspan="4"><%= datelap%></td>
                                                                                                        <td class="title_tbl" style="background-color: #FFF; text-align: center" colspan="6"><%= jenisLaporan%></td>
                                                                                                        <td class="title_tbl" style="background-color: #FFF; text-align: center" colspan="2">801</td>
                                                                                                        <td class="title_tbl" style="background-color: #FFF; text-align: center" colspan="3"><%= listResult.size()%></td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td class="title_tbl" style="background-color: #33AAFF;"><font color="white">Status Data</td>
                                                                                                        <td class="title_tbl" style="background-color: #33AAFF;"><font color="white">NIP</td>
                                                                                                        <td class="title_tbl" style="background-color: #33AAFF;"><font color="white">Nama Pejabat Eksekutif</td>
                                                                                                        <td class="title_tbl" style="background-color: #33AAFF;"><font color="white">Status Tenaga Kerja</td>
                                                                                                        <td class="title_tbl" style="background-color: #33AAFF;"><font color="white">Nama Jabatan</td>
                                                                                                        <td class="title_tbl" style="background-color: #33AAFF;"><font color="white">Alamat Rumah (Saat Ini)</td>

                                                                                                        <td class="title_tbl" style="background-color: #33AAFF;"><font color="white">Alamat KTP atau Paspor atau KITAS (WNA)</td>
                                                                                                        <td class="title_tbl" style="background-color: #33AAFF;"><font color="white">No. Telp</td>
                                                                                                        <td class="title_tbl" style="background-color: #33AAFF;"><font color="white">No. Fax</td>
                                                                                                        <td class="title_tbl" style="background-color: #33AAFF;"><font color="white">NPWP</td>
                                                                                                        <td class="title_tbl" style="background-color: #33AAFF;"><font color="white">No. ID</td>

                                                                                                        <td class="title_tbl" style="background-color: #33AAFF;"><font color="white">Tempat Lahir</td>
                                                                                                        <td class="title_tbl" style="background-color: #33AAFF;"><font color="white">Tgl Lahir</td>
                                                                                                        <td class="title_tbl" style="background-color: #33AAFF;"><font color="white">Kewarganegaraan</td>
                                                                                                        <td class="title_tbl" style="background-color: #33AAFF;"><font color="white">Jenis kelamin</td>
                                                                                                        <td class="title_tbl" style="background-color: #33AAFF;"><font color="white">No. Surat Pelaporan</td>
                                                                                                        <td class="title_tbl" style="background-color: #33AAFF;"><font color="white">Tanggal Surat Pelaporan</td>

                                                                                                        <td class="title_tbl" style="background-color: #33AAFF;"><font color="white">Status PE</td>
                                                                                                        <td class="title_tbl" style="background-color: #33AAFF;"><font color="white">Nomor Surat Keputusan Pengangkatan/Penggantian/Penggantian Sementara</td>
                                                                                                        <td class="title_tbl" style="background-color: #33AAFF;"><font color="white">Tanggal Efektif Pengangkatan/Penggantian/Penggantian Sementara</td>
                                                                                                        <td class="title_tbl" style="background-color: #33AAFF;"><font color="white">Nomor Surat Keputusan Pemberhentian</td>
                                                                                                        <td class="title_tbl" style="background-color: #33AAFF;"><font color="white">Tanggal Efektif Pemberhentian</td>
                                                                                                        <td class="title_tbl" style="background-color: #33AAFF;"><font color="white">Keterangan</td>
                                                                                                    </tr>
                                                                                                    <%
                                                                                                    if (listResult.size() > 0 && listResult != null) {
                                                                                                        for (int i = 0; i < listResult.size(); i++) {
                                                                                                            CareerPath cp = (CareerPath) listResult.get(i);

                                                                                                            Vector listCareerPath = new Vector();
                                                                                                            listCareerPath = PstCareerPath.listKadivCareer(cp.getEmployeeId(), periodTo);
                                                                                                            int statusData = 1;
                                                                                                            if (listCareerPath.size() > 0) {
                                                                                                                statusData = 2;
                                                                                                            }
                                                                                                            
                                                                                                            long lkpbuId = PstLkpbu.lkpbu801byEmployee(cp.getEmployeeId(), oidPeriod);
                                                                                                            Lkpbu lkpbu = new Lkpbu();
                                                                                                            Employee emp = new Employee();

                                                                                                            try {
                                                                                                                emp = PstEmployee.fetchExc(cp.getEmployeeId());
                                                                                                            } catch (Exception exc) {
                                                                                                            }
                                                                                                            
                                                                                                            Position pos = new Position();
                                                                                                            try {
                                                                                                                pos = PstPosition.fetchExc(cp.getPositionId());
                                                                                                            } catch (Exception exc){
                                                                                                                
                                                                                                            }
                                                                                                            
                                                                                                            Division division = new Division();
                                                                                                            try {
                                                                                                                if (pos.getJenisJabatan() != PstPosition.JENIS_PEJABAT_EKSEKUTIF){
                                                                                                                    String whereClause = ""+PstCareerPath.fieldNames[PstCareerPath.FLD_EMPLOYEE_ID]+"="+cp.getEmployeeId()
                                                                                                                                    +" AND "+PstCareerPath.fieldNames[PstCareerPath.FLD_HISTORY_GROUP]+" <> 1"
                                                                                                                                    +" AND "+PstCareerPath.fieldNames[PstCareerPath.FLD_HISTORY_GROUP]+" IN (0,1)"
                                                                                                                                    + " ORDER BY "+PstCareerPath.fieldNames[PstCareerPath.FLD_WORK_FROM]+" DESC LIMIT 1";
                                                                                                                    Vector listCareer = PstCareerPath.list(0,0,whereClause,"");
                                                                                                                    if(listCareer.size()>0){
                                                                                                                        CareerPath career = (CareerPath) listCareer.get(0);
                                                                                                                        
                                                                                                                        Date dt = new Date();
                                                                                                                        Calendar c = Calendar.getInstance(); 
                                                                                                                        c.setTime(career.getWorkTo()); 
                                                                                                                        c.add(Calendar.DATE, 1);
                                                                                                                        dt = c.getTime();
                                                                                                                        lkpbu.setNoSK("");
                                                                                                                        lkpbu.setTanggalSK("");
                                                                                                                        lkpbu.setNoSKPemberhentian(""+emp.getSkNomor());
                                                                                                                        lkpbu.setTanggalSKPemberhentian(""+Formater.formatDate(dt, "ddMMyyyy"));
                                                                                                                           
                                                                                                                        try{
                                                                                                                            division = PstDivision.fetchExc(career.getDivisionId());
                                                                                                                             pos = PstPosition.fetchExc(career.getPositionId());
                                                                                                                        } catch (Exception exc){}

                                                                                                                    }
                                                                                                                } else if (cp.getHistoryType() == PstCareerPath.DETASIR_TYPE){ 
                                                                                                                    int intPeriodFrom = PstCareerPath.getConvertDateToInt(periodFrom);
                                                                                                                    int intPeriodTo = PstCareerPath.getConvertDateToInt(periodTo);
                                                                                                                    int intWorkFrom = PstCareerPath.getConvertDateToInt(""+cp.getWorkFrom());
                                                                                                                    int intWorkTo = PstCareerPath.getConvertDateToInt(""+cp.getWorkTo());
                                                                                                                    
                                                                                                                    if ((intWorkFrom >= intPeriodFrom && intWorkFrom <= intPeriodTo) || (intWorkTo >= intPeriodFrom && intWorkTo <= intPeriodTo)){
                                                                                                                        lkpbu.setNoSK(""+cp.getNomorSk());
                                                                                                                        lkpbu.setTanggalSK(""+Formater.formatDate(cp.getWorkFrom(), "ddMMyyyy"));
                                                                                                                        lkpbu.setNoSKPemberhentian("");
                                                                                                                        lkpbu.setTanggalSKPemberhentian("");
                                                                                                                    } else {
                                                                                                                        Date dt = new Date();
                                                                                                                        Calendar c = Calendar.getInstance(); 
                                                                                                                        c.setTime(cp.getWorkTo()); 
                                                                                                                        c.add(Calendar.DATE, 1);
                                                                                                                        dt = c.getTime();
                                                                                                                        lkpbu.setNoSK("");
                                                                                                                        lkpbu.setTanggalSK("");
                                                                                                                        lkpbu.setNoSKPemberhentian(""+emp.getSkNomor());
                                                                                                                        lkpbu.setTanggalSKPemberhentian(""+Formater.formatDate(dt, "ddMMyyyy"));
                                                                                                                    }
                                                                                                                }else {
                                                                                                                    
                                                                                                                        lkpbu.setNoSK(""+cp.getNomorSk());
                                                                                                                        lkpbu.setTanggalSK(""+Formater.formatDate(cp.getWorkFrom(), "ddMMyyyy"));
                                                                                                                        lkpbu.setNoSKPemberhentian("");
                                                                                                                        lkpbu.setTanggalSKPemberhentian("");
                                                                                                                        
                                                                                                                    try{
                                                                                                                            division = PstDivision.fetchExc(cp.getDivisionId());                                                                                                                            
                                                                                                                    } catch (Exception exc){}
                                                                                                                }
                                                                                                            } catch (Exception exc){
                                                                                                                
                                                                                                            }
                                                                                                            
                                                                                                            if (lkpbuId != 0){
                                                                                                                try {
                                                                                                                    lkpbu = PstLkpbu.fetchExc(lkpbuId);
                                                                                                                } catch (Exception exc){
                                                                                                                    System.out.println(exc.toString());
                                                                                                                }
                                                                                                            } else {
                                                                                                                lkpbu.setEmployeeId(cp.getEmployeeId());
                                                                                                                lkpbu.setPeriodId(oidPeriod);
                                                                                                                lkpbu.setNoSuratPelaporan("");
                                                                                                                lkpbu.setTanggalSuratPelaporan("");
                                                                                                                lkpbu.setKeterangan("");
                                                                                                                try {
                                                                                                                    lkpbuId = PstLkpbu.insertExc(lkpbu);
                                                                                                                } catch (Exception  exc){
                                                                                                                    System.out.println(exc.toString());
                                                                                                                }
                                                                                                            }

                                                                                                            //nationality
                                                                                                            Nationality nat = new Nationality();
                                                                                                            String code = "";
                                                                                                            Division div = new Division();
                                                                                                            try {

                                                                                                                nat = PstNationality.fetchExc(emp.getNationalityId());
                                                                                                                code = PstNationality.typeCode[nat.getNationalityType()];
                                                                                                            } catch (Exception ee) {
                                                                                                            }
                                                                                                            
                                                                                                            //division
                                                                                                            try {
                                                                                                                div = PstDivision.fetchExc(cp.getDivisionId());
                                                                                                            } catch (Exception ee) {
                                                                                                            }
                                                                                                            //sex
                                                                                                            String sex = "";
                                                                                                            if (emp.getSex() == 0) {
                                                                                                                sex = "2";
                                                                                                            } else {
                                                                                                                sex = "1";
                                                                                                            }

                                                                                                            //History Type
                                                                                                            String statusPE = "";
                                                                                                            if (cp.getHistoryType() == PstCareerPath.CAREER_TYPE) {
                                                                                                                statusPE = "1";
                                                                                                            } else {
                                                                                                                statusPE = "2";
                                                                                                            }
                                                                                                            
                                                                                                            String jabatan="";
                                                                                                            if (cp.getHistoryType()==PstCareerPath.PEJABAT_SEMENTARA_TYPE){
                                                                                                                jabatan = "PJS ";
                                                                                                            }
                                                                                                            
                                                                                                            if(cp.getHistoryType()==PstCareerPath.DETASIR_TYPE){
                                                                                                                jabatan = "Pejabat Detasir PLT ";
                                                                                                            }
                                                                                                    %>
                                                                                                    <tr>
                                                                                                        <input type="hidden" name="lkpbuid" value="<%=lkpbuId%>">
                                                                                                        <input type="hidden" name="<%=FrmLkpbu.fieldNames[FrmLkpbu.FRM_FIELD_EMPLOYEE_ID]%>_<%=i%>" value="<%=cp.getEmployeeId()%>">
                                                                                                        <input type="hidden" name="<%=FrmLkpbu.fieldNames[FrmLkpbu.FRM_FIELD_PERIOD_ID]%>_<%=i%>" value="<%=oidPeriod%>">
                                                                                                        <td nowrap="" style="background-color: #FFF;" style="background-color: #FFF;"><%=statusData%></td>
                                                                                                        <td nowrap="" style="background-color: #FFF;">0000000000000000<%=emp.getEmployeeNum()%></td>
                                                                                                        <td nowrap="" style="background-color: #FFF;"><%=emp.getNameCard().toUpperCase()%></td>
                                                                                                        <td nowrap="" style="background-color: #FFF;"> <%= code%> </td>
                                                                                                        <td nowrap="" style="background-color: #FFF;"><%=jabatan.toUpperCase()%><%=pos.getAlias().toUpperCase()%> <%=division.getDivision().toUpperCase()%></td>
                                                                                                        <% if (!emp.getAddress().equals("null")) {%>
                                                                                                        <td nowrap="" style="background-color: #FFF;"> <%= emp.getAddress().toUpperCase()%> </td>
                                                                                                        <% } else {%>
                                                                                                        <td nowrap="" style="background-color: #FFF;">-</td><%}%>
                                                                                                        <% if (!emp.getAddressPermanent().equals("null")) {%>
                                                                                                        <td nowrap="" style="background-color: #FFF;"> <%= emp.getAddressPermanent().toUpperCase()%> </td>
                                                                                                        <%} else {%>
                                                                                                        <td nowrap="" style="background-color: #FFF;">-</td><%}%>
                                                                                                        <% if (!div.getTelphone().equals("null")) {%>
                                                                                                        <td nowrap="" style="background-color: #FFF;"> <%= (division.getTelphone().length() > 10 ? division.getTelphone().substring(0,10) : division.getTelphone())%> </td>
                                                                                                        <%} else {%>
                                                                                                        <td nowrap="" style="background-color: #FFF;">-</td><%}%>
                                                                                                        <%if (!div.getFaxNumber().equals("null")) {%>
                                                                                                        <td nowrap="" style="background-color: #FFF;"> <%= (division.getFaxNumber().length() > 10 ? division.getFaxNumber().substring(0,10) : division.getFaxNumber())%> </td>
                                                                                                        <%} else {%>
                                                                                                        <td nowrap="" style="background-color: #FFF;">-</td><%}%>
                                                                                                        <%
                                                                                                            String npwp = emp.getNpwp();
                                                                                                            npwp = npwp.replaceAll("[-,.]", "");
                                                                                                        %>
                                                                                                        <td nowrap="" style="background-color: #FFF;"> <%= npwp%> </td>
                                                                                                        <td nowrap="" style="background-color: #FFF;"> <%= emp.getIndentCardNr()%> </td>
                                                                                                        <td nowrap="" style="background-color: #FFF;"> <%= emp.getBirthPlace().toUpperCase()%> </td>
                                                                                                        <td nowrap="" style="background-color: #FFF;"> <%=Formater.formatDate(emp.getBirthDate(), "ddMMyyyy")%> </td>
                                                                                                        <td nowrap="" style="background-color: #FFF;"> <%= nat.getNationalityCode().toUpperCase()%> </td>
                                                                                                        <td nowrap="" style="background-color: #FFF;"> <%= sex%> </td>
                                                                                                        <td nowrap="" style="background-color: #FFF;"><input id="noSP_<%=i%>" name="<%=FrmLkpbu.fieldNames[FrmLkpbu.FRM_FIELD_NO_SURAT_PELAPORAN]%>_<%=i%>" type="text" placeholder="Inputkan No.Surat" value="<%=lkpbu.getNoSuratPelaporan().toUpperCase()%>"></td> 
                                                                                                        <td nowrap="" style="background-color: #FFF;"><input id="tglSP_<%=i%>" name="<%=FrmLkpbu.fieldNames[FrmLkpbu.FRM_FIELD_TANGGAL_SURAT_PELAPORAN]%>_<%=i%>" type="text" placeholder="Inputkan Tanggal" value="<%=lkpbu.getTanggalSuratPelaporan()%>"></td> 
                                                                                                        <td nowrap="" style="background-color: #FFF;"> <%= statusPE%> </td>
                                                                                                        <td nowrap="" style="background-color: #FFF;"><input id="noSKP_<%=i%>" name="<%=FrmLkpbu.fieldNames[FrmLkpbu.FRM_FIELD_NO_SK]%>_<%=i%>" type="text" placeholder="Inputkan No.Surat" value="<%=lkpbu.getNoSK().toUpperCase()%>"></td> 
                                                                                                        <td nowrap="" style="background-color: #FFF;"><input id="tglEP_<%=i%>" name="<%=FrmLkpbu.fieldNames[FrmLkpbu.FRM_FIELD_TANGGAL_SK]%>_<%=i%>" type="text" placeholder="Inputkan Tanggal" value="<%=lkpbu.getTanggalSK()%>"></td> 
                                                                                                        <td nowrap="" style="background-color: #FFF;"><input id="noSKR_<%=i%>" name="<%=FrmLkpbu.fieldNames[FrmLkpbu.FRM_FIELD_NO_SK_PEMBERHENTIAN]%>_<%=i%>" type="text" placeholder="Inputkan No.Surat" value="<%=lkpbu.getNoSKPemberhentian().toUpperCase()%>"></td> 
                                                                                                        <td nowrap="" style="background-color: #FFF;"><input id="tglEPR_<%=i%>" name="<%=FrmLkpbu.fieldNames[FrmLkpbu.FRM_FIELD_TANGGAL_SK_PEMBERHENTIAN]%>_<%=i%>" type="text" placeholder="Inputkan Tanggal" value="<%=lkpbu.getTanggalSKPemberhentian()%>"></td> 
                                                                                                        <td nowrap="" style="background-color: #FFF;"><input id="note_<%=i%>" name="<%=FrmLkpbu.fieldNames[FrmLkpbu.FRM_FIELD_KETERANGAN]%>_<%=i%>" type="text" placeholder="Inputkan Note" value="<%=lkpbu.getKeterangan().toUpperCase()%>"></td>
                                                                                                    </tr>

                                                                                                    <%
                                                                                                        }
                                                                                                    }
                                                                                                    %> 
                                                                                                </table>
                                                                                        <tr>
                                                                                            <td width="24" valign="middle"><a href="javascript:cmdSave()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image10','','<%=approot%>/images/BtnSaveOn.jpg',1)" id="aSave"><img name="Image10" border="0" src="<%=approot%>/images/BtnSave.jpg" width="24" height="24" alt="Save"></a><a href="javascript:cmdSave()">Save LKPBU 801 Report</a></td>
                                                                                            
                                                                                        </tr>
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                    <%
                                                                                    }
                                                                                    %>    

                                                                                </form>
                                                                            </td>
                                                                        </tr>
                                                                    </table>	
                                                                    <!-- #EndEditable --> 
                                                                </td>
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
            <%if (headerStyle && !verTemplate.equalsIgnoreCase("0")) {%>
            <tr>
                <td valign="bottom" colspan="6">
                    <!-- untuk footer -->
                    <%@include file="../../footer.jsp" %>
                </td>

            </tr>
            <%} else {%>
            <tr> 
                <td colspan="6" height="20" <%=bgFooterLama%>> <!-- #BeginEditable "footer" --> 
                    <%@ include file = "../../main/footer.jsp" %>
                    <!-- #EndEditable --> </td>
            </tr>
            <%}%>
        </table>
    </body>
    <!-- #BeginEditable "script" --> 
    <!-- #EndEditable --> <!-- #EndTemplate -->
</html>

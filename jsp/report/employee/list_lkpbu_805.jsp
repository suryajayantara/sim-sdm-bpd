<%-- 
    Document   : list_lkpbu_803
    Created on : Aug 12, 2015, 11:56:42 AM
    Author     : khirayinnura
--%>
<%@page import="com.dimata.harisma.entity.report.lkpbu.PstLkpbu805"%>
<%@page import="com.dimata.harisma.form.report.lkpbu.FrmLkpbu805"%>
<%@page import="com.dimata.harisma.form.report.lkpbu.CtrlLkpbu805"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.dimata.harisma.entity.report.lkpbu.Lkpbu805"%>
<%@page import="com.dimata.harisma.entity.report.lkpbu.PstLkpbu"%>
<%@page import="com.dimata.harisma.entity.report.lkpbu.Lkpbu"%>
<%@page import="com.dimata.harisma.form.employee.FrmEmployee"%>
<%@page import="com.dimata.harisma.entity.admin.AppObjInfo"%>
<%@ page language = "java" %>
<!-- package java -->
<%@ page import = "java.util.*" %>

<!-- package wihita -->
<%@ page import = "com.dimata.util.*" %>

<!-- package qdep -->
<%@ page import = "com.dimata.gui.jsp.*" %>
<%@ page import = "com.dimata.qdep.form.*" %>

<!--package harisma -->
<%@ page import = "com.dimata.harisma.entity.search.*" %>
<%@ page import = "com.dimata.harisma.form.search.*" %>
<%@ page import = "com.dimata.harisma.entity.employee.*" %>
<%@ page import = "com.dimata.harisma.entity.masterdata.*" %>
<%@ page import = "com.dimata.harisma.entity.admin.*" %>
<%@ page import = "com.dimata.harisma.session.employee.*" %>

<%@ include file = "../../main/javainit.jsp" %>
<% int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_EMPLOYEE, AppObjInfo.G2_DATABANK, AppObjInfo.OBJ_DATABANK);%>
<%@ include file = "../../main/checkuser.jsp" %>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<%!    public int count = 0;
    /*
     public String drawList(Vector vListResult) 
     { 
     ControlList ctrlist = new ControlList();
     ctrlist.setAreaWidth("100%");
     ctrlist.setListStyle("listgen");
     ctrlist.setTitleStyle("listgentitle");
     ctrlist.setCellStyle("listgensell");
     ctrlist.setHeaderStyle("listgentitle");
                
     ctrlist.addHeader("Jenis Pekerjaan","2%", "0", "0");               
     ctrlist.addHeader("Jenis Pendidikan","2%", "0", "0");
     ctrlist.addHeader("Status Pegawai","2%", "0", "0");
     ctrlist.addHeader("Tahun Realisasi","2%", "0", "0");
     ctrlist.addHeader("Jumlah Tenaga Kerja","5%", "0", "0");	
     ctrlist.addHeader("Tahun Prediksi 1","2%", "0", "0");
     ctrlist.addHeader("Tahun Prediksi 2","2%", "0", "0");
     ctrlist.addHeader("Tahun Prediksi 3","2%", "0", "0");
     ctrlist.addHeader("Tahun Prediksi 4","2%", "0", "0");
        
     ctrlist.setLinkRow(-1);
     ctrlist.setLinkSufix("");
     Vector lstData = ctrlist.getData();
     Vector lstLinkData = ctrlist.getLinkData();
     ctrlist.setLinkPrefix("javascript:cmdEdit('");
     ctrlist.setLinkSufix("')");
     ctrlist.reset();

     Vector rowx = new Vector(1,1);
        
     String jenisPegawai = "";
     String jenisUsia = "";
     String jenisJabatan = "";
     String jenisPendidikan = "";
     String jenisTenagaKerja = "";

     String codePegawai = "";
     String codeUsia = "";
     String codeJabatan = "";
     String codePendidikan = "";
     String codeTenagaKerja = "";

     int totalLaki = 0;
     int totalPerempuan = 0;
     int totalL = 0;
     int totalP = 0;
     int count = 0;

     for (int i = 0; i < vListResult.size(); i++) {
     Lkpbu lkpbu803 = (Lkpbu) vListResult.get(i);
     rowx = new Vector(1, 1);

     try {

     if (i == 0) {
     if (lkpbu803.getEmpCategory().equals("Tetap")) {
     jenisPegawai = "01";
     } else {
     jenisPegawai = "02";
     }

     jenisUsia = lkpbu803.getCodeUsia();
     if (jenisUsia == null) {
     jenisUsia = "";
     }

     jenisJabatan = lkpbu803.getJenisJabatan();
     if (jenisJabatan == null) {
     jenisJabatan = "";
     }

     jenisPendidikan = lkpbu803.getJenisPendidikan();
     if (jenisPendidikan == null) {
     jenisPendidikan = "";
     }

     jenisTenagaKerja = lkpbu803.getJenisPekerjaan();
     if (jenisTenagaKerja == null) {
     jenisTenagaKerja = "";
     }
     }

     if (lkpbu803.getEmpCategory().equals("Tetap")) {
     codePegawai = "01";
     } else {
     codePegawai = "02";
     }

     codeUsia = lkpbu803.getCodeUsia();
     if (codeUsia == null) {
     codeUsia = "";
     }

     codeJabatan = lkpbu803.getJenisJabatan();
     if (codeJabatan == null) {
     codeJabatan = "";
     }

     codePendidikan = lkpbu803.getJenisPendidikan();
     if (codePendidikan == null) {
     codePendidikan = "";
     }

     codeTenagaKerja = lkpbu803.getJenisPekerjaan();
     if (codeTenagaKerja == null) {
     codeTenagaKerja = "";
     }
     } catch (Exception exc) {

     }

     if (jenisPegawai.equals(codePegawai) && jenisUsia.equals(codeUsia) && jenisJabatan.equals(codeJabatan)
     && jenisPendidikan.equals(codePendidikan) && jenisTenagaKerja.equals(codeTenagaKerja)) {
     if (lkpbu803.getEmpSex() == 0) {
     totalLaki = totalLaki + 1;
     }
     if (lkpbu803.getEmpSex() == 1) {
     totalPerempuan = totalPerempuan + 1;
     }
     } else {
     count = count + 1;
     String code = "";
     if (codeTenagaKerja.length() == 1) {
     code = "0" + codeTenagaKerja;
     } else {
     code = codeTenagaKerja;
     }
     rowx.add("" + codePegawai);
     rowx.add("" + codeUsia);
     rowx.add("0" + codeJabatan);
     rowx.add("" + jenisPendidikan);
     rowx.add("" + code);
     rowx.add("" + totalLaki);
     rowx.add("" + totalPerempuan);

     totalLaki = 0;
     totalPerempuan = 0;
     if (lkpbu803.getEmpSex() == 0) {
     totalLaki = totalLaki + 1;
     }
     if (lkpbu803.getEmpSex() == 1) {
     totalPerempuan = totalPerempuan + 1;
     }
     try {

     if (lkpbu803.getEmpCategory().equals("Tetap")) {
     jenisPegawai = "01";
     } else {
     jenisPegawai = "02";
     }

     jenisUsia = lkpbu803.getCodeUsia();
     if (jenisUsia == null) {
     jenisUsia = "";
     }

     jenisJabatan = lkpbu803.getJenisJabatan();
     if (jenisJabatan == null) {
     jenisJabatan = "";
     }

     jenisPendidikan = lkpbu803.getJenisPendidikan();
     if (jenisPendidikan == null) {
     jenisPendidikan = "";
     }

     jenisTenagaKerja = lkpbu803.getJenisPekerjaan();
     if (jenisTenagaKerja == null) {
     jenisTenagaKerja = "";
     }

     if (lkpbu803.getEmpCategory().equals("Tetap")) {
     codePegawai = "01";
     } else {
     codePegawai = "02";
     }

     codeUsia = lkpbu803.getCodeUsia();
     if (codeUsia == null) {
     codeUsia = "";
     }

     codeJabatan = lkpbu803.getJenisJabatan();
     if (codeJabatan == null) {
     codeJabatan = "";
     }

     codePendidikan = lkpbu803.getJenisPendidikan();
     if (codePendidikan == null) {
     codePendidikan = "";
     }

     codeTenagaKerja = lkpbu803.getJenisPekerjaan();
     if (codeTenagaKerja == null) {
     codeTenagaKerja = "";
     }
     } catch (Exception exc) {

     }
     lstData.add(rowx);
     lstLinkData.add("0");
     }
                                        

               
     }           
        
        
     ctrlist.addFooter("Total&nbsp;&nbsp;", "0", "5");
     ctrlist.addFooter(String.valueOf(totalL), "0", "0");
     ctrlist.addFooter(String.valueOf(totalP), "0", "0");
     
     return ctrlist.drawListWithFooter();	
     }*/
%>

<%
    int iCommand = FRMQueryString.requestCommand(request);
    int year = FRMQueryString.requestInt(request, "year");
    long oidLkpbu = FRMQueryString.requestLong(request, "hidden_lkpbu_id");
    Lkpbu lkpbu = new Lkpbu();
    Vector vListResult = new Vector(1, 1);
    Vector listLkpbu = new Vector();

    int recordToGet = 15;
    String msgString = "";
    int iErrCode = FRMMessage.NONE;
    String whereClause = "YEAR(LKPBU_805_START_DATE) = '" + year + "'";
    String orderClause = "JENIS_PEKERJAAN, JENIS_PENDIDIKAN";
    CtrlLkpbu805 ctrlLkpbu805 = new CtrlLkpbu805(request);
    ControlLine ctrLine = new ControlLine();
    Vector listLkpbu805 = new Vector(1, 1);

    /* end switch list*/
    iErrCode = ctrlLkpbu805.action(iCommand, oidLkpbu, "", null);

    Lkpbu805 lkpbu805 = ctrlLkpbu805.getLkpbu805();
    msgString = ctrlLkpbu805.getMessage();

    FrmLkpbu805 frmLkpbu805 = ctrlLkpbu805.getForm();

    listLkpbu805 = PstLkpbu805.list(0, 0, whereClause, orderClause);
    HashMap<String, Lkpbu> mapLkpbu805 = new HashMap<String, Lkpbu>();
    if (iCommand == Command.LIST || iCommand == Command.EDIT || iCommand == Command.SAVE) {

        Vector listEmp = PstLkpbu.listEmployeee803(year);
        if (listEmp.size() == 0) {
            listEmp = PstLkpbu.listCurrentEmployeee803(year);
        }
        mapLkpbu805 = PstLkpbu.getLkpbu805V2(listEmp, year);


        vListResult = PstLkpbu.lkpbu(year);
        listLkpbu = PstLkpbu.getLkpbu805(vListResult);

        session.putValue("listLkpbu805", mapLkpbu805);
    }

    int[] data = new int[5];

    Arrays.sort(data);

    Vector listKadiv = new Vector(1, 1);
    //get value kadiv HRD
    String kadivPositionOid = PstSystemProperty.getValueByName("HR_DIR_POS_ID");
    String whereClauseOidPosition = "POSITION_ID='" + kadivPositionOid + "'";

    listKadiv = PstLkpbu.listPosition(whereClauseOidPosition);
    session.putValue("listkadiv", listKadiv);


    if (iCommand == Command.SAVE) {
        String[] lkpbuId = null;
        String[] yearRealisasi = null;
        String[] yearPrediksi1 = null;
        String[] yearPrediksi2 = null;
        String[] yearPrediksi3 = null;
        String[] yearPrediksi4 = null;
        String[] jenisPekerjaan = null;
        String[] jenisPendidikan = null;
        String[] statusPegawai = null;
        String[] code = null;
        String[] tahun = null;
        
        Vector vLkpbu805 = new Vector();
        try {
            lkpbuId = request.getParameterValues("lkpbuid");
            yearRealisasi = new String[lkpbuId.length];
            yearPrediksi1 = new String[lkpbuId.length];
            yearPrediksi2 = new String[lkpbuId.length];
            yearPrediksi3 = new String[lkpbuId.length];
            yearPrediksi4 = new String[lkpbuId.length];
            jenisPekerjaan = new String[lkpbuId.length];
            jenisPendidikan = new String[lkpbuId.length];
            statusPegawai = new String[lkpbuId.length];
            code = new String[lkpbuId.length];
            tahun = new String[lkpbuId.length];
            
            for (int i=0;i<lkpbuId.length;i++){
                yearRealisasi[i] = FRMQueryString.requestString(request, FrmLkpbu805.fieldNames[FrmLkpbu805.FRM_FIELD_LKPBU_805_YEAR_REALISASI]+"_"+i);
                yearPrediksi1[i] = FRMQueryString.requestString(request, FrmLkpbu805.fieldNames[FrmLkpbu805.FRM_FIELD_LKPBU_805_YEAR_PREDIKSI_1]+"_"+i);
                yearPrediksi2[i] = FRMQueryString.requestString(request, FrmLkpbu805.fieldNames[FrmLkpbu805.FRM_FIELD_LKPBU_805_YEAR_PREDIKSI_2]+"_"+i);
                yearPrediksi3[i] = FRMQueryString.requestString(request, FrmLkpbu805.fieldNames[FrmLkpbu805.FRM_FIELD_LKPBU_805_YEAR_PREDIKSI_3]+"_"+i);
                yearPrediksi4[i] = FRMQueryString.requestString(request, FrmLkpbu805.fieldNames[FrmLkpbu805.FRM_FIELD_LKPBU_805_YEAR_PREDIKSI_4]+"_"+i);
                jenisPekerjaan[i] = FRMQueryString.requestString(request, FrmLkpbu805.fieldNames[FrmLkpbu805.FRM_FIELD_JENIS_PEKERJAAN]+"_"+i);
                jenisPendidikan[i] = FRMQueryString.requestString(request, FrmLkpbu805.fieldNames[FrmLkpbu805.FRM_FIELD_JENIS_PENDIDIKAN]+"_"+i);
                statusPegawai[i] = FRMQueryString.requestString(request, FrmLkpbu805.fieldNames[FrmLkpbu805.FRM_FIELD_STATUS_PEGAWAI]+"_"+i);
                code[i] = FRMQueryString.requestString(request, FrmLkpbu805.fieldNames[FrmLkpbu805.FRM_FIELD_CODE]+"_"+i);
                tahun[i] = FRMQueryString.requestString(request, FrmLkpbu805.fieldNames[FrmLkpbu805.FRM_FIELD_YEAR]+"_"+i);
            }
            
            for (int i=0; i<lkpbuId.length;i++){
                Lkpbu805 saveLkpbu805 = new Lkpbu805();
                saveLkpbu805.setOID(Long.valueOf(lkpbuId[i]));
                saveLkpbu805.setLkpbu805YearRealisasi(Integer.valueOf(yearRealisasi[i]));
                saveLkpbu805.setLkpbu805YearPrediksi1(Integer.valueOf(yearPrediksi1[i]));
                saveLkpbu805.setLkpbu805YearPrediksi2(Integer.valueOf(yearPrediksi2[i]));
                saveLkpbu805.setLkpbu805YearPrediksi3(Integer.valueOf(yearPrediksi3[i]));
                saveLkpbu805.setLkpbu805YearPrediksi4(Integer.valueOf(yearPrediksi4[i]));
                saveLkpbu805.setJenisPekerjaan(jenisPekerjaan[i]);
                saveLkpbu805.setJenisPendidikan(jenisPendidikan[i]);
                saveLkpbu805.setStatusPegawai(statusPegawai[i]);
                saveLkpbu805.setCode(code[i]);
                saveLkpbu805.setYear(Integer.valueOf(tahun[i]));
                try {
                    long oid = PstLkpbu805.updateExc(saveLkpbu805);
                } catch (Exception exc){
                    System.out.println(exc.toString());
                }
            }
            
        } catch (Exception exc){}
        
    }

%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>HARISMA - LKPBU 805 Report</title>
        <script language="JavaScript">
            <%if (iCommand == Command.PRINT) {%>
                //com.dimata.harisma.report.listRequest	
                window.open("<%=printroot%>.report.listRequest.ListEmpEducationPdf");
            <%}%>

                function cmdAdd(){
                    document.frmemplkpbu.command.value="<%=Command.ADD%>";
                    document.frmemplkpbu.action="list_lkpbu_805.jsp";
                    document.frmemplkpbu.submit();
                }
                
                function cmdSave(){
                    document.getElementById('form').removeAttribute('target');
                    document.frmemplkpbu.command.value="<%=Command.SAVE%>";
                    document.frmemplkpbu.action="list_lkpbu_805.jsp";
                    document.frmemplkpbu.submit();
                }

                function cmdEdit(oid){
                    document.frmemplkpbu.hidden_lkpbu_id.value=oid;
                    document.frmemplkpbu.command.value="<%=Command.EDIT%>";
                    document.frmemplkpbu.action="list_lkpbu_805.jsp";
                    document.frmemplkpbu.submit();
                }

                function reportPdf(){
                    document.frmemplkpbu.command.value="<%=Command.PRINT%>";
                    document.frmemplkpbu.action="list_lkpbu_805.jsp";
                    document.frmemplkpbu.submit();
                }

                function cmdSearch(){
                    document.frmemplkpbu.command.value="<%=Command.LIST%>";
                    document.frmemplkpbu.action="list_lkpbu_805.jsp";
                    document.frmemplkpbu.submit();
                }

                function cmdSpecialQuery(){
                    document.frmemplkpbu.action="specialquery.jsp";
                    document.frmemplkpbu.submit();
                }

                function fnTrapKD(){
                    if (event.keyCode == 13) {
                        document.all.aSearch.focus();
                        cmdSearch();
                    }
                }
                function cmdExportExcel(){
                 
                    var linkPage = "<%=approot%>/report/employee/export_excel/export_excel_list_lkpbu_805.jsp?year="+<%=year%>;    
                    var newWin = window.open(linkPage,"attdReportDaily","height=700,width=990,status=yes,toolbar=yes,menubar=no,resizable=yes,scrollbars=yes,location=yes"); 			
                    newWin.focus();
                }
                
                function cmdView()
                {
                    document.getElementById('form').removeAttribute('target');
                    document.frmemplkpbu.command.value="<%=String.valueOf(Command.LIST)%>";
                    document.frmemplkpbu.action="list_lkpbu_805.jsp";
                    document.frmemplkpbu.submit();
                }
                
                function cmdViewDetail(arrayList){
                    var string = arrayList.replace(/[^\w,]/gi, '');
                    document.getElementById('form').setAttribute('target', '_blank')
                    document.frmemplkpbu.command.value="<%=String.valueOf(Command.LIST)%>";
                    document.frmemplkpbu.FRM_FIELD_EMPLOYEE_ID.value=string;
                    document.frmemplkpbu.FRM_FIELD_RESIGNED.value=2;
                    document.frmemplkpbu.action="<%=approot%>/employee/databank/employee_list.jsp";
                    document.frmemplkpbu.submit();
                }

                function MM_swapImgRestore() { //v3.0
                    var i,x,a=document.MM_sr; for(i=0;a && i < a.length && (x=a[i]) && x.oSrc;i++) x.src=x.oSrc;
                }

                function MM_preloadImages() { //v3.0
                    var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
                        var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i < a.length; i++)
                            if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
                    }

                    function MM_findObj(n, d) { //v4.0
                        var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0 && parent.frames.length) {
                            d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
                        if(!(x=d[n]) && d.all) x=d.all[n]; for (i=0;!x && i < d.forms.length;i++) x=d.forms[i][n];
                        for(i=0;!x && d.layers && i < d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
                        if(!x && document.getElementById) x=document.getElementById(n); return x;
                    }

                    function MM_swapImage() { //v3.0
                        var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
                            if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
                    }

                    function cmdUpdateLevp(){
                        document.frmemplkpbu.command.value="<%=Command.ADD%>";
                        document.frmemplkpbu.action="list_lkpbu_805.jsp"; 
                        document.frmemplkpbu.submit();
                    }
        </script>
        <!-- #BeginEditable "styles" --> 
        <link rel="stylesheet" href="../../styles/main.css" type="text/css">
        <!-- #EndEditable -->
        <!-- #BeginEditable "stylestab" --> 
        <link rel="stylesheet" href="../../styles/tab.css" type="text/css">
        <!-- #EndEditable -->
        <!-- #BeginEditable "headerscript" --> 
        <!-- #EndEditable -->
    </head>
    <body <%=noBack%> bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('<%=approot%>/images/BtnSearchOn.jpg','<%=approot%>/images/BtnNewOn.jpg')">
        <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%" bgcolor="#F9FCFF" >
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
            <tr> 
                <td width="88%" valign="top" align="left"> 
                    <table width="100%" border="0" cellspacing="3" cellpadding="2"> 
                        <tr> 
                            <td width="100%">
                                <table width="100%" border="0" cellspacing="0" cellpadding="0"> 
                                    <tr> 
                                        <td height="20">
                                            <font color="#FF6600" face="Arial"><strong>
                                                <!-- #BeginEditable "contenttitle" --> 
                                                Report &gt;Employee &gt; LKPBU Form 805 <!-- #EndEditable --> 
                                            </strong></font>
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
                                                                            <td valign="top">
                                                                                <!-- #BeginEditable "content" --> 
                                                                                <form name="frmemplkpbu" id="form" method="post" action="">
                                                                                    <input type="hidden" name="command" value="<%=iCommand%>">
                                                                                    <input type="hidden" name="hidden_lkpbu_id" value="<%=oidLkpbu%>">
                                                                                    <input type="hidden" name="FRM_FIELD_EMPLOYEE_ID" value="">
                                                                                    <input type="hidden" name="FRM_FIELD_SEX" value="2">
                                                                                    <input type="hidden" name="FRM_FIELD_RESIGNED" value="">
                                                                                    <table width="60%" border="0" cellspacing="2" cellpadding="2">
                                                                                        <tr> 
                                                                                            <td width="18%" nowrap> 
                                                                                                <div align="left"></div>
                                                                                            </td>
                                                                                            <!-- dedy_20150904 -->
                                                                                            <!--<td width="1%"><!--%=ControlDate.drawDateYear("year", year==0? Validator.getIntYear(new Date()) : year ,"formElemen", -40)%></td>-->
                                                                                            <td width="3%">&nbsp;</td>
                                                                                            <td width="78%"> 
                                                                                                <table border="0" cellspacing="0" cellpadding="0" width="197">
                                                                                                    <tr>
                                                                                                        <td><select name="year">
                                                                                                                <%
                                                                                                                    int tahun = Calendar.getInstance().get(Calendar.YEAR);
                                                                                                                    for (int i = tahun; 1990 < i; i--) {
                                                                                                                        if (year == i) {
                                                                                                                %>
                                                                                                                <option value="<%=i%>" selected><%=i%></option>
                                                                                                                <%
                                                                                                                } else {
                                                                                                                %>
                                                                                                                <option value="<%=i%>"><%=i%></option>
                                                                                                                <%
                                                                                                                        }
                                                                                                                    }
                                                                                                                %>
                                                                                                            </select>
                                                                                                        </td>    
                                                                                                        <td width="24"><a href="javascript:cmdView()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image10','','<%=approot%>/images/BtnSearchOn.jpg',1)" id="aSearch"><img name="Image10" border="0" src="<%=approot%>/images/BtnSearch.jpg" width="24" height="24" alt="View Report LKPBU 805"></a></td>
                                                                                                        <td width="10"><img src="<%=approot%>/images/spacer.gif" width="4" height="1"></td>
                                                                                                        <td width="163" class="command" nowrap><a href="javascript:cmdView()">View LKPBU 805 Report</a></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>									  


                                                                                    <%
                                                                                        if (iCommand == Command.LIST || iCommand == Command.EDIT || iCommand == Command.SAVE) {
                                                                                            String sandiPelapor = PstSystemProperty.getValueByName("LKPBU_SANDI_PELAPOR");
                                                                                    %>
                                                                                    <table width="100%" border="0" cellspacing="2" cellpadding="2">
                                                                                        <tr>
                                                                                            <td colspan="2"><hr></td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td colspan="2">
                                                                                                <table class="listgen" width="100%">
                                                                                                    <tr>
                                                                                                        <td class="listgentitle" style="text-align: center">Sandi Pelapor</td>
                                                                                                        <td class="listgentitle" style="text-align: center">Jenis Periode Pelaporan</td>
                                                                                                        <td class="listgentitle" style="text-align: center">Periode Data Pelaporan</td>
                                                                                                        <td class="listgentitle" style="text-align: center">Jenis Laporan</td>
                                                                                                        <td class="listgentitle" colspan="2" style="text-align: center">No Form</td>
                                                                                                        <td class="listgentitle" colspan="2" style="text-align: center">Jumlah Record Isi</td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td class="listgensell" style="text-align: center"><%="" + sandiPelapor%></td>
                                                                                                        <td class="listgensell" style="text-align: center">A</td>
                                                                                                        <td class="listgensell" style="text-align: center"><%=year + "0101"%></td>
                                                                                                        <td class="listgensell" style="text-align: center">A</td>
                                                                                                        <td class="listgensell" colspan="2" style="text-align: center">805</td>
                                                                                                        <td class="listgensell" colspan="2" style="text-align: center"><%=mapLkpbu805.size()%></td>                                                                                                
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td class="listgentitle" rowspan="2" style="text-align: center">Jenis Pekerjaan</td>
                                                                                                        <td class="listgentitle" rowspan="2" style="text-align: center">Jenis Pendidikan</td>
                                                                                                        <td class="listgentitle" rowspan="2" style="text-align: center">Status Pegawai</td>
                                                                                                        <td class="listgentitle" rowspan="2" style="text-align: center">Tahun Realisasi</td>
                                                                                                        <td class="listgentitle" colspan="4" style="text-align: center">Jumlah Tenaga Kerja</td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td class="listgentitle" style="text-align: center">Tahun Prediksi 1</td>
                                                                                                        <td class="listgentitle" style="text-align: center">Tahun Prediksi 2</td>
                                                                                                        <td class="listgentitle" style="text-align: center">Tahun Prediksi 3</td>
                                                                                                        <td class="listgentitle" style="text-align: center">Tahun Prediksi 4</td>
                                                                                                    </tr>

                                                                                                    <%
                                                                                                        if (!mapLkpbu805.isEmpty()) {
                                                                                                            String codePekerjaan = "";
                                                                                                            Lkpbu[] stringArray = new Lkpbu[listLkpbu.size()];
                                                                                                            for (int i = 0; i < listLkpbu.size(); i++) {
                                                                                                                stringArray[i] = (Lkpbu) listLkpbu.get(i);
                                                                                                            }
                                                                                                            Arrays.sort(stringArray, Lkpbu.LkpbuCompare);

                                                                                                            Map<String, Lkpbu> sorted = new TreeMap<String, Lkpbu>(mapLkpbu805);
                                                                                                            int index = 0;
                                                                                                            for (Lkpbu temp : sorted.values()) {

                                                                                                                long lkpbuId = PstLkpbu805.getLkpbu805Id(temp.getCode(), year);
                                                                                                                Lkpbu805 eLkpbu = new Lkpbu805();

                                                                                                                if (lkpbuId != 0) {
                                                                                                                    try {
                                                                                                                        eLkpbu = PstLkpbu805.fetchExc(lkpbuId);
                                                                                                                    } catch (Exception exc) {
                                                                                                                        System.out.println(exc.toString());
                                                                                                                    }
                                                                                                                } else {
                                                                                                                    eLkpbu.setJenisPekerjaan(temp.getJenisPekerjaan());
                                                                                                                    eLkpbu.setJenisPendidikan(temp.getJenisPendidikan());
                                                                                                                    eLkpbu.setStatusPegawai(temp.getStatusPegawai());
                                                                                                                    eLkpbu.setLkpbu805YearRealisasi(temp.getJumlahKaryawan());
                                                                                                                    eLkpbu.setCode(temp.getCode());
                                                                                                                    eLkpbu.setYear(year);
                                                                                                                    eLkpbu.setLkpbu805YearPrediksi1(0);
                                                                                                                    eLkpbu.setLkpbu805YearPrediksi2(0);
                                                                                                                    eLkpbu.setLkpbu805YearPrediksi3(0);
                                                                                                                    eLkpbu.setLkpbu805YearPrediksi4(0);
                                                                                                                    try {
                                                                                                                        lkpbuId = PstLkpbu805.insertExc(eLkpbu);
                                                                                                                    } catch (Exception exc) {
                                                                                                                        System.out.println(exc.toString());
                                                                                                                    }
                                                                                                                }
                                                                                                    %>
                                                                                                    <tr>
                                                                                                        <input type="hidden" name="lkpbuid" value="<%=lkpbuId%>">   
                                                                                                        <input type="hidden" name="<%=FrmLkpbu805.fieldNames[FrmLkpbu805.FRM_FIELD_JENIS_PEKERJAAN]%>_<%=index%>" value="<%=temp.getJenisPekerjaan()%>" />
                                                                                                        <input type="hidden" name="<%=FrmLkpbu805.fieldNames[FrmLkpbu805.FRM_FIELD_JENIS_PENDIDIKAN]%>_<%=index%>" value="<%=temp.getJenisPendidikan()%>" />
                                                                                                        <input type="hidden" name="<%=FrmLkpbu805.fieldNames[FrmLkpbu805.FRM_FIELD_STATUS_PEGAWAI]%>_<%=index%>" value="<%=temp.getStatusPegawai()%>" />
                                                                                                        <input type="hidden" name="<%=FrmLkpbu805.fieldNames[FrmLkpbu805.FRM_FIELD_LKPBU_805_YEAR_REALISASI]%>_<%=index%>" value="<%=temp.getJumlahKaryawan()%>" />
                                                                                                        <input type="hidden" name="<%=FrmLkpbu805.fieldNames[FrmLkpbu805.FRM_FIELD_CODE]%>_<%=index%>" value="<%=temp.getCode()%>" />
                                                                                                        <input type="hidden" name="<%=FrmLkpbu805.fieldNames[FrmLkpbu805.FRM_FIELD_YEAR]%>_<%=index%>" value="<%=year%>" />
                                                                                                        <td class="listgensell" style="text-align: center"><%=temp.getJenisPekerjaan()%></td>
                                                                                                        <td class="listgensell" style="text-align: center"><%= temp.getJenisPendidikan()%></td>
                                                                                                        <td class="listgensell" style="text-align: center"><%=temp.getStatusPegawai()%></td>
                                                                                                        <td class="listgensell" style="text-align: center"><a href="javascript:cmdViewDetail('<%=temp.getIdKaryawan()%>')"><%=(temp.getJumlahKaryawan() != 0 ? temp.getJumlahKaryawan() : 0)%></td>
                                                                                                        <td class="listgensell" style="text-align: center"><input style="text-align: center" id="year1_<%=index%>" name="<%=FrmLkpbu805.fieldNames[FrmLkpbu805.FRM_FIELD_LKPBU_805_YEAR_PREDIKSI_1]%>_<%=index%>" type="text" value="<%=eLkpbu.getLkpbu805YearPrediksi1()%>"></td>
                                                                                                        <td class="listgensell" style="text-align: center"><input style="text-align: center" id="year2_<%=index%>" name="<%=FrmLkpbu805.fieldNames[FrmLkpbu805.FRM_FIELD_LKPBU_805_YEAR_PREDIKSI_2]%>_<%=index%>" type="text" value="<%=eLkpbu.getLkpbu805YearPrediksi2()%>"></td>
                                                                                                        <td class="listgensell" style="text-align: center"><input style="text-align: center" id="year3_<%=index%>" name="<%=FrmLkpbu805.fieldNames[FrmLkpbu805.FRM_FIELD_LKPBU_805_YEAR_PREDIKSI_3]%>_<%=index%>" type="text" value="<%=eLkpbu.getLkpbu805YearPrediksi3()%>"></td>
                                                                                                        <td class="listgensell" style="text-align: center"><input style="text-align: center" id="year4_<%=index%>" name="<%=FrmLkpbu805.fieldNames[FrmLkpbu805.FRM_FIELD_LKPBU_805_YEAR_PREDIKSI_4]%>_<%=index%>" type="text" value="<%=eLkpbu.getLkpbu805YearPrediksi4()%>"></td>
                                                                                                        
                                                                                                    </tr>
                                                                                                    <%
                                                                                                        index++;
                                                                                                            }
                                                                                                        }
                                                                                                    %>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                                <tr>
                                                                                                    <td width="15%" valign="middle"><a href="javascript:cmdSave()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image10','','<%=approot%>/images/BtnSaveOn.jpg',1)" id="aSave"><img name="Image10" border="0" src="<%=approot%>/images/BtnSave.jpg" width="24" height="24" alt="Save"></a><a href="javascript:cmdSave()">Save LKPBU 805 Report</a></td>
                                                                                                    <td width="85%" valign="middle"><a href="javascript:cmdExportExcel()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image110','','<%=approot%>/images/BtnNewOn.jpg',1)" id="aSearch"><img name="Image110" border="0" src="<%=approot%>/images/BtnNew.jpg" width="24" height="24" alt="Print Report"></a><a href="javascript:cmdExportExcel()">Export Detail to Excel</a></td>
                                                                                                </tr>
                                                                                            
                                                                                    </table>
                                                                                    <%
                                                                                        }
                                                                                    %>
                                                                                </form>          
                                                                    </table>

                                                        </table>

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
<% if (headerStyle && !verTemplate.equalsIgnoreCase("0")) {%>
<tr>
    <td valign="bottom">
        <!-- untuk footer -->
        <%@include file="../../footer.jsp" %>
    </td>
</tr>
<%} else {%>
<tr> 
    <td colspan="2" height="20" > <!-- #BeginEditable "footer" --> 
        <%@ include file = "../../main/footer.jsp" %>
        <!-- #EndEditable --> </td>
</tr>
<%}%>
</table>
</body>
</html>


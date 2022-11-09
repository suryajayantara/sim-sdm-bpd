
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
<% int  appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_REPORTS, AppObjInfo.G2_LEAVE_REPORT, AppObjInfo.OBJ_LEAVE_DP_SUMMARY); %>
<%@ include file = "../../main/checkuser.jsp" %>

<%!
/**
 * create list of report items
 */
public String drawList(int iCommand, Vector listResult, String periodTo) 
{ 
        ControlList ctrlist = new ControlList();
        ctrlist.setAreaWidth("100%");
        ctrlist.setListStyle("tblStyle");
        ctrlist.setTitleStyle("title_tbl");
        ctrlist.setCellStyle("listgensell");
        ctrlist.setHeaderStyle("title_tbl");
        ctrlist.setCellSpacing("0");
                
        ctrlist.addHeader("NIP","", "0", "0");
        ctrlist.addHeader("Nama Perusahaan","", "0", "0");
        ctrlist.addHeader("Tanggal Mulai","", "0", "0");	
        ctrlist.addHeader("Tanggal Berakhir","", "0", "0");
        ctrlist.addHeader("Nama Jabatan atau Posisi","", "0", "0");
        
        ctrlist.setLinkRow(-1);
        ctrlist.setLinkSufix("");
        Vector lstData = ctrlist.getData();
        Vector lstLinkData = ctrlist.getLinkData();
        ctrlist.setLinkPrefix("javascript:cmdEdit('");
        ctrlist.setLinkSufix("')");
        ctrlist.reset();
        
        Employee empFetch = new Employee();
        Company comp = new Company();
        Position pos = new Position();
        Division div = new Division();
        
        Vector rowx = new Vector(1,1);
        for(int i = 0; i < listResult.size(); i++) {
            CareerPath careerPath = (CareerPath)listResult.get(i);
            
            String whereClause = " WHERE "+PstCareerPath.fieldNames[PstCareerPath.FLD_EMPLOYEE_ID]+"="+careerPath.getEmployeeId()
                                    + " AND "+ PstCareerPath.fieldNames[PstCareerPath.FLD_WORK_TO] +"<= '" + periodTo +"'"
                                    + " ORDER BY "+PstCareerPath.fieldNames[PstCareerPath.FLD_WORK_FROM];
             
            if(careerPath.getHistoryType() == PstCareerPath.CAREER_TYPE){
                whereClause += " DESC LIMIT 1";
            }
                Vector career = PstCareerPath.listCareerLkpbu(whereClause);
                
                for(int j = 0; j < career.size(); j++) {
                    CareerPath careerAll = (CareerPath)career.get(j);
                    rowx = new Vector(1,1);
                    try{
                        empFetch = PstEmployee.fetchExc(careerAll.getEmployeeId());
                    }catch(Exception ee){

                    }
                    
                    try{
                        comp = PstCompany.fetchExc(empFetch.getCompanyId());
                    }catch(Exception ee){

                    }

                    try{
                        div = PstDivision.fetchExc(careerAll.getDivisionId());
                    }catch(Exception ee){

                    }
                            
                    try{
                        pos = PstPosition.fetchExc(careerAll.getPositionId());
                    }catch(Exception ee){

                    }
                    
                    /*if(j == 0){*/
                    int jmlhNum = 20 - empFetch.getEmployeeNum().length();
                    String empNum = "";
                    for(int h = 0; h < jmlhNum; h++){
                        empNum = empNum + "0";
                    }
                    
                    Date dt = careerAll.getWorkTo();
                    Calendar c = Calendar.getInstance(); 
                    c.setTime(dt); 
                    c.add(Calendar.DATE, 1);
                    dt = c.getTime();
                    
                    rowx.add(empNum+empFetch.getEmployeeNum());
                    rowx.add(""+comp.getCompany());
                    rowx.add(""+Formater.formatDate(careerAll.getWorkFrom(), "ddMMyyyy"));
                    //rowx.add(""+careerAll.getWorkFrom());
                    //rowx.add(""+workToString);
                    rowx.add(""+Formater.formatDate(dt, "ddMMyyyy"));
                    rowx.add(""+pos.getAlias()+" "+div.getDivision());
                    
                    lstData.add(rowx);
                    lstLinkData.add("0");
                }
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

%>
<!-- End of JSP Block -->
<html>
<!-- #BeginTemplate "/Templates/main.dwt" -->
<head>
<!-- #BeginEditable "doctitle" -->
<title>HARISMA - LKPBU 801 Report</title>
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

function cmdAdd(no){
    document.lkpbu.hidden_lkpbu_id.value=no;
    document.lkpbu.no.value=no;
    document.lkpbu.command.value="<%=Command.ADD%>";
    document.lkpbu.action="list_lkpbu_802.jsp";
    document.lkpbu.submit();
}

function cmdSave(){
    document.lkpbu.command.value="<%=Command.SAVE%>";
    document.lkpbu.action="list_lkpbu_802.jsp";
    document.lkpbu.submit();
}

function cmdEdit(no){
    document.lkpbu.hidden_lkpbu_id.value=document.getElementById("lkpbu_"+no).value;
    document.lkpbu.command.value="<%=Command.EDIT%>";
    document.lkpbu.action="list_lkpbu_802.jsp";
    document.lkpbu.submit();
}

function cmdView()
{
	document.lkpbu.command.value="<%=String.valueOf(Command.LIST)%>";
	document.lkpbu.action="list_lkpbu_802.jsp";
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

function cmdExportExcel(){
                 
    document.lkpbu.command.value="<%=String.valueOf(Command.LIST)%>";
    document.lkpbu.action="<%=approot%>/report/employee/export_excel/export_excel_list_lkpbu_802.jsp";
    document.lkpbu.submit();

    //document.frpresence.action="rekapitulasi_absensi.jsp"; 
    //document.frpresence.target = "SummaryAttendance";
    //document.frpresence.submit();
    //document.frpresence.target = "";
}

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
     <%if(headerStyle && !verTemplate.equalsIgnoreCase("0")){%> 
           <%@include file="../../styletemplate/template_header.jsp" %>
            <%}else{%>
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
                  &gt; Employee &gt; LKPBU Form 802<!-- #EndEditable --> 
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
                                      <table width="60%" border="0" cellspacing="2" cellpadding="2">
                                        <tr> 
                                          <td width="17%" nowrap>
                                              <div align="left">Select Periode</div>
                                                <%
                                                Vector perValue = new Vector(1, 1);
                                                Vector perKey = new Vector(1, 1);
                                                perKey.add("-");
                                                perValue.add(String.valueOf(0));
                                                Vector listPeriod = PstPeriod.list(0, 0, "", ""+ PstPeriod.fieldNames[PstPeriod.FLD_START_DATE]);
                                                for (int i = 0; i < listPeriod.size(); i++) {
                                                    Period period = (Period) listPeriod.get(i);
                                                    perKey.add(period.getPeriod());
                                                    perValue.add(String.valueOf(period.getOID()));
                                                }

                                            %>
                                            <%=  ControlCombo.draw("period_id", "formElemen", null, ""+oidPeriod, perValue, perKey) %>
                                                <!--from --><!--%=ControlDate.drawDateWithStyle("startDate", startDate, 2, -30, "formElemen", "")%-->
                                                <!--to --><!--%=ControlDate.drawDateWithStyle("endDate", endDate, 2, -30, "formElemen", "")%-->
                                                </br>
                                                </br>
                                                <table border="0" cellspacing="0" cellpadding="0" width="197">
                                                    <tr> 
                                                      <td width="24"><a href="javascript:cmdView()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image10','','<%=approot%>/images/BtnSearchOn.jpg',1)" id="aSearch"><img name="Image10" border="0" src="<%=approot%>/images/BtnSearch.jpg" width="24" height="24" alt="View Report LKPBU 802"></a></td>
                                                      <td width="10"><img src="<%=approot%>/images/spacer.gif" width="4" height="1"></td>
                                                      <td width="163" class="command" nowrap><a href="javascript:cmdView()">View LKPBU 801 Report</a></td>
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
                                      if(iCommand == Command.LIST || iCommand == Command.ADD || iCommand == Command.SAVE || iCommand == Command.EDIT)
                                      {
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
                                            int jmlRecord = 0;
                                            for(int i = 0; i < listResult.size(); i++) {
                                                CareerPath cp = (CareerPath)listResult.get(i);
                                                Vector listCareerPath = PstCareerPath.listKadivCareer(cp.getEmployeeId(), periodTo);
                                                int statusData = 1;
                                                if (listCareerPath.size() > 0) {
                                                    statusData = 2;
                                                }
                                                String whereClause = " ";
                                                Vector careerCount = new Vector();
                                                if (cp.getHistoryType() == PstCareerPath.DETASIR_TYPE){
                                                    Date dt = cp.getWorkTo();
                                                    Calendar c = Calendar.getInstance(); 
                                                    c.setTime(dt); 
                                                    c.add(Calendar.DATE, 1);
                                                    dt = c.getTime();

                                                    int intWorkTo = PstCareerPath.getConvertDateToInt(""+Formater.formatDate(dt, "yyyy-MM-dd"));
                                                    int intPeriodFrom = PstCareerPath.getConvertDateToInt(periodFrom);
                                                    int intPeriodTo = PstCareerPath.getConvertDateToInt(periodTo);
                                                    if (intWorkTo>= intPeriodFrom && intWorkTo <= intPeriodTo){
                                                        whereClause = PstCareerPath.fieldNames[PstCareerPath.FLD_WORK_HISTORY_NOW_ID]+"="+cp.getOID();
                                                        careerCount = PstCareerPath.list(0, 0, whereClause, "");
                                                    } else {
                                                        careerCount = PstCareerPath.lastCareerPE(cp.getEmployeeId(), periodTo);
                                                    }
                                                } else {
                                                    whereClause = " "+PstCareerPath.fieldNames[PstCareerPath.FLD_EMPLOYEE_ID]+"="+cp.getEmployeeId()
                                                                    + " AND "+ PstCareerPath.fieldNames[PstCareerPath.FLD_WORK_TO] +"<= '" + periodTo +"'"
                                                                    + " AND "+ PstCareerPath.fieldNames[PstCareerPath.FLD_HISTORY_GROUP]+" IN ("+PstCareerPath.RIWAYAT_JABATAN+","+PstCareerPath.RIWAYAT_CAREER_N_GRADE+") "
                                                                    + " AND "+PstCareerPath.fieldNames[PstCareerPath.FLD_HISTORY_TYPE]+" IN("+PstCareerPath.CAREER_TYPE+","+PstCareerPath.PEJABAT_SEMENTARA_TYPE+")"
                                                                    + " ORDER BY "+PstCareerPath.fieldNames[PstCareerPath.FLD_WORK_FROM];

                                                    if(statusData == 2){
                                                        whereClause += " DESC LIMIT 1";
                                                    }
                                                     careerCount = PstCareerPath.list(0, 0, whereClause, "");
                                                }
                                                for(int j = 0; j < careerCount.size(); j++) {
                                                    jmlRecord++;
                                                }
                                            }
                                      %>
                                      <table width="100%" border="0" cellspacing="2" cellpadding="2">
                                        <tr>
                                          <td><hr></td>
                                        </tr>
                                        <tr>
                                          <td>
                                              <table class="tblStyle" >
                                                <tr>
                                                    <td class="title_tbl" style="background-color: #33AAFF;" colspan="2" ><font color="white"><strong>Sandi Pelapor </strong></td>
                                                    <td class="title_tbl" style="background-color: #33AAFF;"><font color="white"><strong>Jenis Periode Pelaporan</strong></td>
                                                    <td class="title_tbl" style="background-color: #33AAFF;"><font color="white"><strong>Periode Data Pelaporan</strong></td>
                                                    <td class="title_tbl" style="background-color: #33AAFF;"><font color="white"><strong>Jenis Laporan</strong></td>
                                                    <td class="title_tbl" style="background-color: #33AAFF;"><font color="white"><strong>No Form</strong></td>
                                                    <td class="title_tbl" style="background-color: #33AAFF;"><font color="white"><strong>Jumlah Record Isi</strong></td>
                                                </tr>
                                                <tr>
                                                    <td class="title_tbl" style="background-color: #FFF; text-align: center" colspan="2"><%= sandiPelapor%></td>
                                                    <td class="title_tbl" style="background-color: #FFF; text-align: center"><%= jenisPeriodPelaporan%></td>
                                                    <td class="title_tbl" style="background-color: #FFF; text-align: center"><%= datelap%></td>
                                                    <td class="title_tbl" style="background-color: #FFF; text-align: center"><%= jenisLaporan%></td>
                                                    <td class="title_tbl" style="background-color: #FFF; text-align: center">802</td>
                                                    <td class="title_tbl" style="background-color: #FFF; text-align: center"><%= jmlRecord%></td>
                                                </tr>
                                                <tr>
                                                    <td class="title_tbl" style="background-color: #33AAFF;"><font color="white"><strong>NIP</strong></td>
                                                    <td class="title_tbl" style="background-color: #33AAFF;"><font color="white"><strong>Nama Perusahaan</strong></td>
                                                    <td class="title_tbl" style="background-color: #33AAFF;"><font color="white"><strong>Tanggal Mulai</strong></td>
                                                    <td class="title_tbl" style="background-color: #33AAFF;"><font color="white"><strong>Tanggal Berakhir</strong></td>
                                                    <td class="title_tbl" style="background-color: #33AAFF;" colspan="3"><font color="white"><strong>Nama Jabatan atau Posisi</strong></td>
                                                </tr>
                                                <%
                                                    for(int i = 0; i < listResult.size(); i++) {
                                                        CareerPath careerPath = (CareerPath)listResult.get(i);
                                                        Vector listCareerPath = PstCareerPath.listKadivCareer(careerPath.getEmployeeId(), periodTo);
                                                        int statusData = 1;
                                                        if (listCareerPath.size() > 0) {
                                                            statusData = 2;
                                                        }
                                                        
                                                        String whereClause = " ";
                                                        Vector career = new Vector();
                                                        if (careerPath.getHistoryType() == PstCareerPath.DETASIR_TYPE){
                                                            Date dt = careerPath.getWorkTo();
                                                            Calendar c = Calendar.getInstance(); 
                                                            c.setTime(dt); 
                                                            c.add(Calendar.DATE, 1);
                                                            dt = c.getTime();
                                                            
                                                            int intWorkTo = PstCareerPath.getConvertDateToInt(""+Formater.formatDate(dt, "yyyy-MM-dd"));
                                                            int intPeriodFrom = PstCareerPath.getConvertDateToInt(periodFrom);
                                                            int intPeriodTo = PstCareerPath.getConvertDateToInt(periodTo);
                                                            if (intWorkTo>= intPeriodFrom && intWorkTo <= intPeriodTo){
                                                                whereClause = PstCareerPath.fieldNames[PstCareerPath.FLD_WORK_HISTORY_NOW_ID]+"="+careerPath.getOID();
                                                                career = PstCareerPath.list(0, 0, whereClause, "");
                                                            } else {
                                                                career = PstCareerPath.lastCareerPE(careerPath.getEmployeeId(), periodTo);
                                                            }
                                                        } else {
                                                            whereClause = " "+PstCareerPath.fieldNames[PstCareerPath.FLD_EMPLOYEE_ID]+"="+careerPath.getEmployeeId()
                                                                            + " AND "+ PstCareerPath.fieldNames[PstCareerPath.FLD_WORK_TO] +"<= '" + periodTo +"'"
                                                                            + " AND "+ PstCareerPath.fieldNames[PstCareerPath.FLD_HISTORY_GROUP]+" IN ("+PstCareerPath.RIWAYAT_JABATAN+","+PstCareerPath.RIWAYAT_CAREER_N_GRADE+") "
                                                                            + " AND "+PstCareerPath.fieldNames[PstCareerPath.FLD_HISTORY_TYPE]+" IN("+PstCareerPath.CAREER_TYPE+","+PstCareerPath.PEJABAT_SEMENTARA_TYPE+")"
                                                                            + " ORDER BY "+PstCareerPath.fieldNames[PstCareerPath.FLD_WORK_FROM];

                                                            if(statusData == 2){
                                                                whereClause += " DESC LIMIT 1";
                                                            }
                                                             career = PstCareerPath.list(0, 0, whereClause, "");
                                                        }
                                                        
                                                        for(int j = 0; j < career.size(); j++) {
                                                            CareerPath careerAll = (CareerPath)career.get(j);
                                                            
                                                            Employee empFetch = new Employee();
                                                            try{
                                                                empFetch = PstEmployee.fetchExc(careerAll.getEmployeeId());
                                                            }catch(Exception ee){

                                                            }
                                                            
                                                            Company comp = new Company();
                                                            try{
                                                                comp = PstCompany.fetchExc(empFetch.getCompanyId());
                                                            }catch(Exception ee){

                                                            }

                                                            Division div = new Division();
                                                            try{
                                                                div = PstDivision.fetchExc(careerAll.getDivisionId());
                                                            }catch(Exception ee){

                                                            }

                                                            Position pos = new Position();
                                                            try{
                                                                pos = PstPosition.fetchExc(careerAll.getPositionId());
                                                            }catch(Exception ee){

                                                            }

                                                            /*if(j == 0){*/
                                                            int jmlhNum = 20 - empFetch.getEmployeeNum().length();
                                                            String empNum = "";
                                                            for(int h = 0; h < jmlhNum; h++){
                                                                empNum = empNum + "0";
                                                            }
                                                            
                                                            String jabatan = "";
                                                            if (careerAll.getHistoryType() == PstCareerPath.PEJABAT_SEMENTARA_TYPE ){
                                                                jabatan = "PJS ";
                                                            } else if (careerAll.getHistoryType() == PstCareerPath.DETASIR_TYPE ){
                                                                jabatan = "Pejabat Detasir PLT ";
                                                            }

                                                            Date dt = careerAll.getWorkTo();
                                                            Calendar c = Calendar.getInstance(); 
                                                            c.setTime(dt); 
                                                            c.add(Calendar.DATE, 1);
                                                            dt = c.getTime();
                                                %>
                                                <tr>
                                                    <td nowrap="" style="background-color: #FFF;" style="background-color: #FFF;"><%=empNum+empFetch.getEmployeeNum()%></td>
                                                    <td nowrap="" style="background-color: #FFF;" style="background-color: #FFF;"><%=comp.getCompany()%></td>
                                                    <td nowrap="" style="background-color: #FFF;" style="background-color: #FFF;"><%=Formater.formatDate(careerAll.getWorkFrom(), "ddMMyyyy")%></td>
                                                    <td nowrap="" style="background-color: #FFF;" style="background-color: #FFF;"><%=Formater.formatDate(dt, "ddMMyyyy")%></td>
                                                    <td nowrap="" style="background-color: #FFF;" style="background-color: #FFF;" colspan="3"><%=jabatan+pos.getAlias()+" "+div.getDivision()%></td>
                                                </tr>
                                                <%
                                                        }
                                                    }
                                                %>
                                              </table>
                                          </td>
                                          <td></td>
                                        </tr>
                                        <%
                                            if(listResult.size()>0)
                                            {
                                        %>
                                        <tr>
                                          <td class="command">
                                            <table border="0" cellspacing="0" cellpadding="0" width="197">
                                              <tr>
                                                <td width="24"><a href="javascript:cmdExportExcel()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image110','','<%=approot%>/images/BtnNewOn.jpg',1)" id="aSearch"><img name="Image110" border="0" src="<%=approot%>/images/BtnNew.jpg" width="24" height="24" alt="Print Report"></a></td>
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
   <%if(headerStyle && !verTemplate.equalsIgnoreCase("0")){%>
            <tr>
                            <td valign="bottom">
                               <!-- untuk footer -->
                                <%@include file="../../footer.jsp" %>
                            </td>
                            
            </tr>
            <%}else{%>
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


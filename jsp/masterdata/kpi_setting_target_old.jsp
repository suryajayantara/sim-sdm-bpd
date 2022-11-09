<%-- 
    Document   : kpi_setting_target
    Created on : Oct 12, 2022, 2:47:43 PM
    Author     : User
--%>

<%@page import="com.dimata.harisma.entity.masterdata.PstPosition"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstKpiSettingPosition"%>
<%@page import="com.dimata.harisma.form.masterdata.FrmKpiSetting"%>
<%@page import="com.dimata.harisma.form.masterdata.CtrlKpiSetting"%>
<%@page import="com.dimata.qdep.form.FRMQueryString"%>
<%@page import="com.dimata.gui.jsp.ControlCombo"%>
<%@page import="com.dimata.qdep.entity.I_DocStatus"%>
<%@page import="com.dimata.harisma.entity.admin.AppObjInfo"%>
<%@ include file = "../main/javainit.jsp" %>
<%  int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_EMPLOYEE, AppObjInfo.G2_LEAVE_APPLICATION, AppObjInfo.OBJ_LEAVE_APPLICATION);%>
<%@ include file = "../main/checkuser.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
long oidKpiSetting = FRMQueryString.requestLong(request, FrmKpiSetting.fieldNames[FrmKpiSetting.FRM_FIELD_KPI_SETTING_ID]);

int iCommand = FRMQueryString.requestCommand(request);	
int company = FRMQueryString.requestInt(request, "company");
int position = FRMQueryString.requestInt(request, "position");
int tahun = FRMQueryString.requestInt(request, "tahun");
long companyId = FRMQueryString.requestLong(request, "company_search");
long positionId = FRMQueryString.requestLong(request, "position_search");
int tahunSrc = FRMQueryString.requestInt(request, "tahun_searching");

CtrlKpiSetting ctrlKpiSetting = new CtrlKpiSetting(request);
long iErrCode = ctrlKpiSetting.action(iCommand , oidKpiSetting, request);
KpiSetting kpiSetting = ctrlKpiSetting.getKpiSetting();

Vector listKpiSetting = new Vector();
//boolean selectDiv = true;
boolean selectComp = true;
boolean selectPosisi = true;
boolean selectTahun = true;

Vector valTahun = new Vector();
Vector keyTahun = new Vector();
Calendar calNow = Calendar.getInstance();
int startYear = calNow.get(Calendar.YEAR) -5;
int endYear = calNow.get(Calendar.YEAR) +3;
valTahun.add("0");
keyTahun.add("Select..");

for (int i=startYear ; i<=endYear ; i++){
    valTahun.add(""+i);
    keyTahun.add(""+i);
}

if (iCommand == Command.LIST){
    String whereClause = " 1=1 ";
    if (companyId > 0){
        whereClause += " AND "+PstKpiSetting.fieldNames[PstKpiSetting.FLD_COMPANY_ID]+" = '"+companyId+"'";
    }
    if (positionId > 0){
        whereClause += " AND tb_posisi."+PstKpiSettingPosition.fieldNames[PstKpiSettingPosition.FLD_POSITION_ID]+" = '"+positionId+"'";
    }
   if (tahun > 0){
        whereClause += " AND "+PstKpiSetting.fieldNames[PstKpiSetting.FLD_TAHUN]+" = '"+tahun+"'";
    }

    listKpiSetting = PstKpiSetting.listWithJoinPositionAndCompany(whereClause);
}

%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>KPI SETTING</title>
        
        <!--css button-->
        <style type="text/css">
            .btn-back {
                background-color: #575757;
                border-radius: 3px;
                font-family: Arial;
                color: #EEE;
                font-size: 12px;
                padding: 7px 11px 7px 11px;
                text-decoration: none;
            }
            .btn-edit {
                background-color: #FFAA05  ;
                border-radius: 3px;
                font-family: Arial;
                color: #EEE;
                font-size: 12px;
                padding: 7px 11px 7px 11px;
                text-decoration: none;
            }
            .btn-add {
                background-color: #10C538  ;
                border-radius: 3px;
                font-family: Arial;
                color: #EEE;
                font-size: 12px;
                padding: 7px 11px 7px 11px;
                text-decoration: none;
            }
            .font {
                font-family: Arial, Helvetica, sans-serif;
                font-size: 12px;
                font-style: normal;
                line-height: normal;
                font-weight: normal;
                font-variant: normal;
            }
            .btn-delete {
                background-color: #FF0000;
                border-radius: 3px;
                font-family: Arial;
                color: #EEE;
                font-size: 12px;
                padding: 7px 11px 7px 11px;
                text-decoration: none;
            }
            </style>
        <link rel="stylesheet" href="../styles/main.css" type="text/css">
        <link rel="stylesheet" href="../stylesheets/custom.css" >
		<script type="text/javascript">
            function cmdEdit(oid){
		document.frm.<%=FrmKpiSetting.fieldNames[FrmKpiSetting.FRM_FIELD_KPI_SETTING_ID]%>.value=oid;
                document.frm.command.value="<%= Command.EDIT %>";
                document.frm.action="kpi_setting_form.jsp";
                document.frm.submit();
            }
            function cmdAdd(){
                document.frm.<%=FrmKpiSetting.fieldNames[FrmKpiSetting.FRM_FIELD_KPI_SETTING_ID]%>.value=0;
                document.frm.command.value="<%= Command.ADD %>";
                document.frm.action="kpi_setting_form.jsp";
                document.frm.submit();
            }
            function cmdSearch(){
                document.frm.<%=FrmKpiSetting.fieldNames[FrmKpiSetting.FRM_FIELD_KPI_SETTING_ID]%>.value=0;
                document.frm.command.value="<%= Command.LIST %>";
                document.frm.action="kpi_setting_list.jsp";
                document.frm.submit();
            }
               function cmdBack(){
                document.frm.command.value ="<%=Command.LIST%>";
                document.frm.action="kpi_setting_list.jsp";
                document.frm.submit();
            }
            function cmdDelete(oid){
                document.frm.<%=FrmKpiSetting.fieldNames[FrmKpiSetting.FRM_FIELD_KPI_SETTING_ID]%>.value=oid;
                document.frm.command.value="<%= Command.DELETE %>";
                document.frm.action="kpi_setting_list.jsp";
                document.frm.submit();
            }
			
	
        </script>
        <link rel="stylesheet" href="<%=approot%>/javascripts/datepicker/tdemes/jquery.ui.all.css">
        <script src="<%=approot%>/javascripts/jquery.js"></script>
        <script src="<%=approot%>/javascripts/datepicker/jquery.ui.core.js"></script>
	<script src="<%=approot%>/javascripts/datepicker/jquery.ui.widget.js"></script>
	<script src="<%=approot%>/javascripts/datepicker/jquery.ui.datepicker.js"></script>
		<script src="../javascripts/chosen.jquery.js" type="text/javascript"></script>
                <link rel="stylesheet" href="<%=approot%>/styles/datatable/v1/jquery.dataTables.min.css" >
                <script src="<%=approot%>/styles/datatable/v1/jquery.dataTables.min.js"></script>
		<link rel="stylesheet" href="../stylesheets/chosen.css" >
     </head>
    <body>
        <div class="header">
            <table widtd="100%" border="0" cellspacing="0" cellpadding="0">
            <%if (headerStyle && !verTemplate.equalsIgnoreCase("0")) {%> 
            <%@include file="../styletemplate/template_header.jsp" %>
            <%} else {%>
            <tr> 
                <td ID="TOPTITLE" background="<%=approot%>/images/HRIS_HeaderBg3.jpg" widtd="100%" height="54"> 
                    <!-- #BeginEditable "header" --> 
                    <%@ include file = "../main/header.jsp" %>
                    <!-- #EndEditable --> 
                </td>
            </tr>
            <tr> 
                <td  bgcolor="#9BC1FF" height="15" ID="MAINMENU" valign="middle"> <!-- #BeginEditable "menumain" --> 
                    <%@ include file = "../main/mnmain.jsp" %>
                    <!-- #EndEditable --> </td>
            </tr>
            <tr> 
                <td  bgcolor="#9BC1FF" height="10" valign="middle"> 
                    <table widtd="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr> 
                            <td align="left"><img src="<%=approot%>/images/harismaMenuLeft1.jpg" widtd="8" height="8"></td>
                            <td align="center" background="<%=approot%>/images/harismaMenuLine1.jpg" widtd="100%"><img src="<%=approot%>/images/harismaMenuLine1.jpg" widtd="8" height="8"></td>
                            <td align="right"><img src="<%=approot%>/images/harismaMenuRight1.jpg" widtd="8" height="8"></td>
                        </tr>
                    </table>
                </td>
            </tr>
            <%}%>
            </table>
        </div>
        <div id="menu_utama">
            <span id="menu_title"> KPI Setting Target</span>
        </div>
            <form name="frm" metdod="post" action="">
                 <input type="hidden" name="command" value="<%= iCommand %>"> 
                <input type="hidden" name="<%=FrmKpiSetting.fieldNames[FrmKpiSetting.FRM_FIELD_KPI_SETTING_ID]%>">
        <div class="box">
            
            <!--judul ini merupakan judul dari KPI-->
            <div id="box-title">Pendapatan Bunga kredit Korporasi
            <a href="javascript:cmdBack()" style="color:#FFF;float: right;" class="btn-back">Kembali</a></div>
            <!--End-->
            <div id="box-content">
                <table>
                    <tr>
                        <td>
                        <br><div style="font-size: 12px;">No             :</div>
                        <br><div style="font-size: 12px;">Perusahaan     :</div>
                        <br><div style="font-size: 12px;">Jabatan        :</div>
                        <br><div style="font-size: 12px;">Status         :</div>
                        <br><div style="font-size: 12px;">Tanggal Mulai  :</div>
                        <br><div style="font-size: 12px;">Tanggal Selesai:</div>
                        <br><div style="font-size: 12px;">KPI Group      :</div>
                        <br><div style="font-size: 12px;">KPI            :</div>
                        <br><div style="font-size: 12px;">Tahun          :</div>
                        </td>
                    </tr>
                </table>
                <div>&nbsp;</div>
                <table class="tblStyle" style="width:100%">
                    <tr>
                      <td class="title_tbl"></td>
                      <td class="title_tbl">Satuan Kerja</td>
                      <td class="title_tbl">Unit Kerja</td>
                      <td class="title_tbl">Sub Unit</td>
                      <td class="title_tbl">Tahun</td>
                      <td class="title_tbl">periode</td>
                      <td class="title_tbl">Ka</td>
                      <td class="title_tbl">Target(%)</td>
                      <td class="title_tbl">Status</td>
                      <td class="title_tbl"></td>
                    </tr>
                  <tr>
                  <td>1</td>
                  <td>2</td>
                  <td>3</td>
                  <td>4</td>
                  <td>5</td>
                  <td>6</td>
                  <td>7</td>
                  <td>8</td>
                  <td>9</td>
                  <td>Edit || Delete</td>
                  </tr>
                  <tr>
                  <td></td>
                  <td colspan="9">

                  <table class="tblStyle" style="width:100%">
                      <td class="title_tbl">No</td>
                      <td class="title_tbl">NIK</td>
                      <td class="title_tbl">Nama</td>
                      <td class="title_tbl">Bobot Distribusi</td>
                      <td class="title_tbl">Action</td>
                  <tr>
                  <td>1</td>
                  <td>2352364634</td>
                  <td>Surya</td>
                  <td>70%</td>
                  <td><center>Edit || Delete</center></td>
                  </tr>
                  <tr>
                  <td>2</td>
                  <td>2352364634</td>
                  <td>Surya</td>
                  <td>70%</td>
                  <td><center>Edit || Delete</center></td>
                  </tr>

                  </table>
                </table>
                       <div>&nbsp;</div> 
                     <div>
                         <!--tombol kembali ini seharusnya tampil ketika user melakukan edit data pada tabel-->
                <a href="javascript:cmdBack()" style="color:#FFF;float: left;" class="btn-back">Kembali</a></div>
                </div>
            </div>
            </form>
        <div class="footer-page">
            <table>
                <%if (headerStyle && !verTemplate.equalsIgnoreCase("0")) {%>
                <tr>
                    <td valign="bottom"><%@include file="../footer.jsp" %></td>
                </tr>
                <%} else {%>
                <tr> 
                    <td colspan="2" height="20" ><%@ include file = "../main/footer.jsp" %></td>
                </tr>
                <%}%>
            </table>
        </div>
        <script type="text/javascript">
		var config = {
			'.chosen-select'           : {},
			'.chosen-select-deselect'  : {allow_single_deselect:true},
			'.chosen-select-no-single' : {disable_search_tdreshold:10},
			'.chosen-select-no-results': {no_results_text:'Oops, notding found!'},
			'.chosen-select-widtd'     : {widtd:"100%"}
		}
		for (var selector in config) {
			$(selector).chosen(config[selector]);
		}
                
        
	</script>    
    </body>
</html>

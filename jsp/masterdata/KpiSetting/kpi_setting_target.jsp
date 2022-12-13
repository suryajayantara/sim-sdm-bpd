<%-- 
    Document   : kpi_setting_target
    Created on : Oct 12, 2022, 2:47:43 PM
    Author     : User
--%>

<%@page import="com.dimata.harisma.form.masterdata.FrmKpiSettingGroup"%>
<%@page import="com.dimata.harisma.form.masterdata.CtrlKpiSettingGroup"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstPosition"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstKpiSettingPosition"%>
<%@page import="com.dimata.harisma.form.masterdata.FrmKpiSetting"%>
<%@page import="com.dimata.harisma.form.masterdata.CtrlKpiSetting"%>
<%@page import="com.dimata.qdep.form.FRMQueryString"%>
<%@page import="com.dimata.gui.jsp.ControlCombo"%>
<%@page import="com.dimata.qdep.entity.I_DocStatus"%>
<%@page import="com.dimata.harisma.entity.admin.AppObjInfo"%>
<%@ include file = "../../main/javainit.jsp" %>
<%  int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_EMPLOYEE, AppObjInfo.G2_LEAVE_APPLICATION, AppObjInfo.OBJ_LEAVE_APPLICATION);%>
<%@ include file = "../../main/checkuser.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%    long oidKpiSetting = FRMQueryString.requestLong(request, FrmKpiSetting.fieldNames[FrmKpiSetting.FRM_FIELD_KPI_SETTING_ID]);
    long oidKpiSettingGroup = FRMQueryString.requestLong(request, FrmKpiSettingGroup.fieldNames[FrmKpiSettingGroup.FRM_FIELD_KPI_GROUP_ID]);

    int iCommand = FRMQueryString.requestCommand(request);
    String urlBack = FRMQueryString.requestString(request, "urlBack");

    CtrlKpiSetting ctrlKpiSetting = new CtrlKpiSetting(request);
    long iErrCode = ctrlKpiSetting.action(iCommand, oidKpiSetting, request);
    KpiSetting kpiSetting = ctrlKpiSetting.getKpiSetting();
    if (iCommand == Command.SAVE) {
        iCommand = 0;
    }

    CtrlKpiSettingGroup ctrlKpiSettingGroup = new CtrlKpiSettingGroup(request);
    long iErrCodeSetttingGroup = ctrlKpiSettingGroup.action(iCommand, oidKpiSettingGroup, request);
    if (iCommand == Command.SAVE) {
        iCommand = 0;

    }

    Vector listKpiSettingTarget = new Vector();
    /*menampung data jabatan dalam vektor*/
    Vector vListPosisi = PstPosition.listWithJoinKpiSettingPosition(kpiSetting.getOID());

    Vector vKpiGroup = new Vector();

%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>KPI SETTING TARGET</title>


        <link rel="stylesheet" href="../../styles/main.css" type="text/css">
        <link rel="stylesheet" href="../../stylesheets/custom.css" >
        
        <link rel="stylesheet" href="../../styles/css_suryawan/CssSuryawan.css" type="text/css">
        <link rel="stylesheet" href="<%=approot%>/javascripts/datepicker/tdemes/jquery.ui.all.css">
        <script src="<%=approot%>/javascripts/jquery.js"></script>
        <script src="<%=approot%>/javascripts/datepicker/jquery.ui.core.js"></script>
        <script src="<%=approot%>/javascripts/datepicker/jquery.ui.widget.js"></script>
        <script src="<%=approot%>/javascripts/datepicker/jquery.ui.datepicker.js"></script>
        <script src="../../javascripts/chosen.jquery.js" type="text/javascript"></script>
        <link rel="stylesheet" href="<%=approot%>/styles/datatable/v1/jquery.dataTables.min.css" >
        <script src="<%=approot%>/styles/datatable/v1/jquery.dataTables.min.js"></script>
        <link rel="stylesheet" href="../../stylesheets/chosen.css" >
        <!--bootsrtrap untuk menu pop up-->
        <link href="../../styles/bootstrap 5.0/css/bootstrap.css" rel="stylesheet" type="text/css"/>
        <script href="../../styles/bootstrap 5.0/js/bootstrap.bundle.js" type="text/javascript"></script>
    </head>
    <body>
        <div class="header">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <%if (headerStyle && !verTemplate.equalsIgnoreCase("0")) {%> 
            <%@include file="../../styletemplate/template_header.jsp" %>
            <%} else {%>
            <tr> 
                <td ID="TOPTITLE" style="background:<%=approot%>/images/HRIS_HeaderBg3.jpg" width="100%" height="54"> 
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
                            <td align="center" style="background:<%=approot%>/images/harismaMenuLine1.jpg" width="100%"><img src="<%=approot%>/images/harismaMenuLine1.jpg" width="8" height="8"></td>
                            <td align="right"><img src="<%=approot%>/images/harismaMenuRight1.jpg" width="8" height="8"></td>
                        </tr>
                    </table>
                </td>
            </tr>
            <%}%>
            </table>
        </div>
        <div id="menu_utama">
            <span id="menu_title">KPI Setting Detail/KPI Setting Target</span>
        </div>
            <form name="frm" method="post" action="">
                 <input type="hidden" name="command" value="<%= iCommand %>"> 
                <input type="hidden" name="<%=FrmKpiSetting.fieldNames[FrmKpiSetting.FRM_FIELD_KPI_SETTING_ID]%>">
        <div class="box">
            <div class="content-main">
            <!--judul ini merupakan judul dari KPI-->
            <div id="box-title">Pendapatan Bunga kredit Korporasi
            <a href="javascript:cmdBack();" style="color:#FFF;float: right;" class="btn-back btn-back1">Kembali</a></div>
            <!--End-->
            <div id="box-content">
                <table>
                    <tr>
                        <td>
                        <br><div style="font-size: 12px;">Perusahaan:<%=PstCompany.getCompanyName(kpiSetting.getCompanyId())%></div>
                        <br><div style="font-size: 12px;">Jabatan        :
                        <%
                          Vector vListPosisi = PstPosition.listWithJoinKpiSettingPosition(kpiSetting.getOID());
                          for (int i=0; i < vListPosisi.size(); i++){
                              Position objPosisi = (Position)vListPosisi.get(i);
                              %>
                              <%=objPosisi.getPosition()%>,
                        <%
                          }
                        %>
                        </div>
                        <br><div style="font-size: 12px;">Status         :<%= I_DocStatus.fieldDocumentStatus[kpiSetting.getStatus()] %></div>
                        <br><div style="font-size: 12px;">Tanggal Mulai  :<%= kpiSetting.getStartDate() %></div>
                        <br><div style="font-size: 12px;">Tanggal Selesai:<%= kpiSetting.getValidDate()%></div>
                        <br><div style="font-size: 12px;">KPI Group      :</div>
                        <br><div style="font-size: 12px;">KPI            :</div>
                        <br><div style="font-size: 12px;">Tahun          :<%= kpiSetting.getTahun() %></div>
                        </td>
                    </tr>
                </table>
                <div style="border-top: 1px solid #DDD;">&nbsp;</div>
                <h3>KPI Target Per Satuan Kerja</h3>
                <div>&nbsp;</div>
                <a href="kpi_setting_target_form.jsp?<%= FrmKpiSetting.fieldNames[FrmKpiSetting.FRM_FIELD_KPI_SETTING_ID] %>=<%= kpiSetting.getOID() %>" style="color:#fff;" class="btn-add btn-add1">Tambah Data <strong><i class="fa fa-plus"></i></strong></a>
                <a href="" style="color:#fff;" class="btn-copy btn-copy1">Salin Data Target Sebelumnya <strong><i class="fa fa-copy"></i></strong></a>
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

                            <div style="font-size: 15px">:
                                <%
                                    for (int j = 0; j < vListPosisi.size(); j++) {
                                        Position objPosition = (Position) vListPosisi.get(j);
                                %>
                                <%= objPosition.getPosition()%>
                                <% if (j != vListPosisi.size() - 1) {%>
                                <br> &nbsp;
                                <%}%>
                                <%}%>
                            </div>
                            <div style="font-size: 15px">: <%= I_DocStatus.fieldDocumentStatus[kpiSetting.getStatus()]%></div>
                            <div style="font-size: 15px">: <%= kpiSetting.getStartDate()%></div>
                            <div style="font-size: 15px">: <%= kpiSetting.getValidDate()%></div>
                            <div style="font-size: 15px">: <%= kpiSetting.getTahun()%></div>
                            <div style="font-size: 15px">: 
                                <%
                                    String kpiGroupQuery = "hr_kpi_setting_type.`KPI_SETTING_ID`='" + oidKpiSetting + "' AND hr_kpi_setting_type.`KPI_TYPE_ID`='" + kpiType.getOID() + "'";
                                    vKpiGroup = PstKPI_Group.listWithJoinSettingAndType(kpiGroupQuery);
                                    if (vKpiGroup.size() > 0) {
                                        for (int j = 0; j < vKpiGroup.size(); j++) {
                                            KPI_Group objKpiGroup = (KPI_Group) vKpiGroup.get(j);
                                %>
                                <%=objKpiGroup.getGroup_title()%>
                            </div>
                            <%}
                                }%>
                        </div>
                    </div>
                    <%
                            }
                        }
                    %>
                    <div style="border-top: 1px solid #DDD;">&nbsp;</div>
                    <%
                        
                    %>
                    <h4>KPI Target Per Satuan Kerja</h4>
                    <div>&nbsp;</div>
                    <a href="javascript:cmdAdd('<%=kpiSetting.getOID() %>')" style="color:#fff;" class="btn-add btn-add1">Tambah Data Target<strong>&nbsp;<i class="fa fa-plus"></i></strong></a>
                    <!--<a href="" style="color:#fff;" class="btn-copy btn-copy1">Salin Data Target Sebelumnya <strong><i class="fa fa-copy"></i></strong></a>-->
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
                </div>
            </div>
        </div>
    </form>
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
                    '.chosen-select-no-single': {disable_search_tdreshold: 10},
                    '.chosen-select-no-results': {no_results_text: 'Oops, notding found!'},
                    '.chosen-select-widtd': {widtd: "100%"}
                }
                for (var selector in config) {
                    $(selector).chosen(config[selector]);
                }


    </script>
<script type="text/javascript">
                    function cmdEdit(oid) {
                        document.frm.<%=FrmKpiSetting.fieldNames[FrmKpiSetting.FRM_FIELD_KPI_SETTING_ID]%>.value = oid;
                        document.frm.command.value = "<%= Command.EDIT%>";
                        document.frm.action = "kpi_setting_form.jsp";
                        document.frm.submit();
                    }
                    function cmdAdd(oidKpiSetting) {
                        document.frm.<%=FrmKpiSetting.fieldNames[FrmKpiSetting.FRM_FIELD_KPI_SETTING_ID]%>.value = oidKpiSetting;
                        document.frm.command.value = "<%= Command.ADD%>";
                        document.frm.action = "kpi_setting_target_form.jsp";
                        document.frm.submit();
                    }

                    function cmdDelete(oid) {
                        document.frm.<%=FrmKpiSetting.fieldNames[FrmKpiSetting.FRM_FIELD_KPI_SETTING_ID]%>.value = oid;
                        document.frm.command.value = "<%= Command.DELETE%>";
                        document.frm.action = "kpi_setting_list.jsp";
                        document.frm.submit();
                    }
                    /*untuk tombol back yang dimana kondisi khususnya, memiliki 1 jsp, tapi jsp tersebut bisa di akses dari beberapa jsp lain*/
            <%if (urlBack.equals("kpi_setting_list_detail.jsp")) {%>
                    function cmdBack() {
                        document.frm.<%=FrmKpiSetting.fieldNames[FrmKpiSetting.FRM_FIELD_KPI_SETTING_ID]%>.value = "<%=oidKpiSetting%>";
                        document.frm.command.value = "<%= Command.EDIT%>";
                        document.frm.action = "kpi_setting_list_detail.jsp";
                        document.frm.submit();
                    }
            <%} else {%>
                    function cmdBack() {
                        document.frm.<%=FrmKpiSetting.fieldNames[FrmKpiSetting.FRM_FIELD_KPI_SETTING_ID]%>.value = "<%=oidKpiSetting%>";
                        document.frm.command.value = "<%= Command.EDIT%>";
                        document.frm.action = "kpi_setting_form.jsp";
                        document.frm.submit();
                    }
            <%}%>


        </script>    
</body>
</html>

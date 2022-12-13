<%-- 
    Document   : kpi_setting_list_detail
    Created on : Oct 18, 2022, 11:14:27 AM
    Author     : User
--%>

<%@page import="com.dimata.harisma.form.masterdata.CtrlKpiSettingList"%>
<%@page import="com.dimata.harisma.form.masterdata.CtrlKpiSettingGroup"%>
<%@page import="com.dimata.harisma.form.masterdata.FrmKpiSettingGroup"%>
<%@page import="com.dimata.harisma.form.masterdata.FrmKpiSettingList"%>
<%@page import="com.dimata.harisma.form.masterdata.FrmKpiSettingType"%>
<%@page import="com.dimata.harisma.form.masterdata.CtrlKpiSettingType"%>
<%@page import="com.dimata.harisma.entity.log.ChangeValue"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.dimata.harisma.form.masterdata.CtrlKpiSetting"%>
<%@page import="com.dimata.harisma.form.masterdata.FrmKpiSetting"%>
<%@page import="com.dimata.harisma.form.masterdata.CtrlPosition"%>
<%@page import="com.dimata.gui.jsp.ControlLine"%>
<%@page import="com.dimata.harisma.form.masterdata.FrmPosition"%>
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
    long oidKpiSettingType = FRMQueryString.requestLong(request, "kpi_setting_type_id");
    long oidKpiSettingList = FRMQueryString.requestLong(request, FrmKpiSettingList.fieldNames[FrmKpiSettingList.FRM_FIELD_KPI_SETTING_LIST_ID]);
    long oidKpiSettingGroup = FRMQueryString.requestLong(request, FrmKpiSettingGroup.fieldNames[FrmKpiSettingGroup.FRM_FIELD_KPI_GROUP_ID]);

    int iCommand = FRMQueryString.requestCommand(request);
    int tahun = Calendar.getInstance().get(Calendar.YEAR);
    long oidCompany = FRMQueryString.requestLong(request, "company");

    /*Ini Untuk array of string OID*/
    String oid_division[] = FRMQueryString.requestStringValues(request, "division");
    String oid_company[] = FRMQueryString.requestStringValues(request, "company");
    String oid_position[] = FRMQueryString.requestStringValues(request, "position");
    String oid_kpi_type[] = FRMQueryString.requestStringValues(request, "kpitype");

    /*Ini Untuk Variable Sementara(Temporary) */
    long positionId = FRMQueryString.requestLong(request, "position");

    /* ADD Data Kpi Setting */
//String sValidDate= FRMQueryString.requestString(request, FrmKpiSetting.fieldNames[FrmKpiSetting.FRM_FIELD_START_DATE]);
//sValidDate = sValidDate; 

    /*controller bisa untuk menampilkan data berdasarkan oid, bisa kok, sans, karena menggunakan icommand EDIT, 
    yang dimana di CTRL itu comand edit nge fetch data berdasarkan oid*/
    CtrlKpiSetting ctrlKpiSetting = new CtrlKpiSetting(request);
    long iErrCode = ctrlKpiSetting.action(iCommand, oidKpiSetting, request);
    KpiSetting kpiSetting = ctrlKpiSetting.getKpiSetting();
    if (iCommand == Command.SAVE) {
        iCommand = 0;
    }

    CtrlKpiSettingType ctrlKpiSettingType = new CtrlKpiSettingType(request);
    long iErrCodeSettingType = ctrlKpiSettingType.action(iCommand, oidKpiSettingType, request);
    if (iCommand == Command.SAVE) {
        iCommand = 0;
    }
    KpiSettingType kpiSettingType = ctrlKpiSettingType.getKpiSettingType();

    CtrlKpiSettingGroup ctrlKpiSettingGroup = new CtrlKpiSettingGroup(request);
    long iErrCodeSettingGroup = ctrlKpiSettingGroup.action(iCommand, oidKpiSettingGroup, request);
    if (iCommand == Command.SAVE) {
        iCommand = 0;
    }
    KpiSettingGroup kpiSettingGroup = ctrlKpiSettingGroup.getKpiSettingGroup();

    CtrlKpiSettingList ctrlKpiSettingList = new CtrlKpiSettingList(request);
    long iErrCodeSetttingList = ctrlKpiSettingList.action(iCommand, oidKpiSettingList, request);
    if (iCommand == Command.SAVE) {
        iCommand = 0;
    }
    KpiSettingList kpiSettingList = ctrlKpiSettingList.getKpiSettingList();

    /*menampilkan data kpi setting*/
    Vector listKpiSettingDetail = new Vector();

    /*menampung data jabatan dalam vektor*/
    Vector vListPosisi = PstPosition.listWithJoinKpiSettingPosition(kpiSetting.getOID());
    /*menampung data KPI Group dalam vektor*/
    Vector vKpiGroup = new Vector();
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>KPI SETTING LIST DETAIL</title>

        <link rel="stylesheet" href="../../styles/css_suryawan/CssSuryawan.css" type="text/css">
        <link rel="stylesheet" href="<%=approot%>/javascripts/datepicker/themes/jquery.ui.all.css">
        <script src="<%=approot%>/javascripts/jquery.js"></script>
        <script src="<%=approot%>/javascripts/datepicker/jquery.ui.core.js"></script>
        <script src="<%=approot%>/javascripts/datepicker/jquery.ui.widget.js"></script>
        <script src="<%=approot%>/javascripts/datepicker/jquery.ui.datepicker.js"></script>

        <link rel="stylesheet" href="../../../../styles/main.css" type="text/css">

        <!--css tanggal-->
        <link rel="stylesheet" href="<%=approot%>/javascripts/datepicker/themes/jquery.ui.all.css">
        <script src="<%=approot%>/javascripts/jquery.js"></script>
        <script src="<%=approot%>/javascripts/datepicker/jquery.ui.core.js"></script>
        <script src="<%=approot%>/javascripts/datepicker/jquery.ui.widget.js"></script>
        <script src="<%=approot%>/javascripts/datepicker/jquery.ui.datepicker.js"></script>
        <!--end-->
        <link rel="stylesheet" href="../../styles/main.css" type="text/css">
        <script src="../../javascripts/jquery.min-1.6.2.js" type="text/javascript"></script>
        <script src="<%=approot%>/javascripts/jquery.js"></script>
        <script src="../../javascripts/chosen.jquery.js" type="text/javascript"></script>

        <link rel="stylesheet" href="../../stylesheets/chosen.css" >
        <link rel="stylesheet" href="../../stylesheets/custom.css" >

        <link rel="stylesheet" href="../../styles/main.css" type="text/css">
        <link rel="stylesheet" href="../../stylesheets/custom.css" >
        <link href="../../styles/select2/css/select2.min.css" rel="stylesheet" type="text/css"/>
        <link href="../../styles/select2/css/select2-bootstrap4.min.css" rel="stylesheet" type="text/css"/>
        <link href="../../styles/select2/css/select2-bootstrap4.min.css" rel="stylesheet" type="text/css"/>
        <link rel="stylesheet" href="<%=approot%>/styles/sweetalert2.min.css">

        <!--bootsrtrap untuk menu pop up-->
        <link href="../../styles/bootstrap 5.0/css/bootstrap.css" rel="stylesheet" type="text/css"/>
        <script src="../../styles/bootstrap 5.0/js/bootstrap.bundle.js" type="text/javascript"></script>

        <!--end-->
        <link rel="stylesheet" href="../../stylesheets/chosen.css" >
        <link rel="stylesheet" href="../../stylesheets/custom.css" >
    </head>
    <body onload="prepare()" >
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
            <span id="menu_title"><strong>Kinerja</strong> <strong style="color:#333;"> / </strong>Master Data / KPI Setting List / KPI Setting List Detail</span>
        </div>
        <div class="content-main">
            <a href="javascript:cmdBack()" style="color:#FFF;" class="btn-back btn-back1">Kembali</a>
            <div class="formstyle" style="margin-top: 1rem;">
                <!--data ini akan muncul ketika user klik detail pada kpi setting list-->
                <div style="font-size: 15px">Company: <%=PstCompany.getCompanyName(kpiSetting.getCompanyId())%></div>
                <div style="font-size: 15px">Jabatan:
                    <%
                        for (int i = 0; i < vListPosisi.size(); i++) {
                            Position objPosition = (Position) vListPosisi.get(i);
                    %>
                    <%= objPosition.getPosition()%>,
                    <%}%>
                </div>
                <div style="font-size: 15px">Status: <%= I_DocStatus.fieldDocumentStatus[kpiSetting.getStatus()]%></div>
                <div style="font-size: 15px">Tanggal Mulai: <%= kpiSetting.getStartDate()%></div>
                <div style="font-size: 15px">Tanggal Selesai: <%= kpiSetting.getValidDate()%></div>
                <div style="font-size: 15px">Tahun: <%= kpiSetting.getTahun()%></div>
            </div>

            <%
                Vector vKpiSettingType = PstKpiSettingType.list(0, 0, PstKpiSettingType.fieldNames[PstKpiSettingType.FLD_KPI_SETTING_ID] + " = " + kpiSetting.getOID(), "");
                for (int i = 0; i < vKpiSettingType.size(); i++) {
                    KpiSettingType entKpiSettingType = (KpiSettingType) vKpiSettingType.get(i);
                    KPI_Type entKpiType = PstKPI_Type.fetchExc(entKpiSettingType.getKpiTypeId());
            %>
            <div class="formstyle" style="margin-top: 1rem;">
                <div><%= entKpiType.getType_name()%></div>
                <table class="tblStyle" style="width: 100%;">
                    <thead>
                        <tr>
                            <th class="title_tbl" style="text-align: center;" width="2%">No.</th>
                            <th class="title_tbl" style="text-align: center;">KPI Group</th>
                        </tr>
                    </thead>

                    <tbody>
                        <%
                            Vector vKpiSettingGroup = PstKpiSettingGroup.list(0, 0, PstKpiSettingGroup.fieldNames[PstKpiSettingGroup.FLD_KPI_SETTING_TYPE_ID] + " = " + entKpiSettingType.getKpiSettingTypeId(), "");
                            for (int j = 0; j < vKpiSettingGroup.size(); j++) {
                                KpiSettingGroup entKpiSettingGroup = (KpiSettingGroup) vKpiSettingGroup.get(j);
                                KPI_Group entKpiGroup = PstKPI_Group.fetchExc(entKpiSettingGroup.getKpiGroupId());
                        %>
                        <tr>
                            <td style="text-align: center;"><%= j + 1%></td>
                            <td><%= entKpiGroup.getGroup_title()%></td>
                        </tr>

                        <tr>
                            <td></td>
                            <td>
                                <table class="tblStyle" style="width: 100%;">
                                    <thead>
                                        <tr>
                                            <th class="title_tbl" width="2%"><center>No.</center></th>
                                            <th class="title_tbl"><center>Key Performance Indicator</center></th>
                                            <th class="title_tbl" width="10%"><center>Distribution Option</center></th>
                                            <th class="title_tbl" width="10%"><center>Satuan Ukur</center></th>
                                            <th class="title_tbl" width="2%"><center>Bobot</center></th>
                                            <th class="title_tbl" width="2%"><center>Target</center></th>
                                        </tr>
                                    </thead>

                                    <tbody>
                                        <%
                                            Vector vKpiSettingList = PstKpiSettingList.list(0, 0, PstKpiSettingList.fieldNames[PstKpiSettingList.FLD_KPI_SETTING_GROUP_ID] + " = " + entKpiSettingGroup.getOID(), "");
                                            for (int k = 0; k < vKpiSettingList.size(); k++) {
                                                KpiSettingList entKpiSettingList = (KpiSettingList) vKpiSettingList.get(k);
                                                KPI_List entKpiList = PstKPI_List.fetchExc(entKpiSettingList.getKpiListId());
                                                KpiDistribution entKpiDistribution = PstKpiDistribution.fetchExc(entKpiSettingList.getKpiDistributionId());
                                        %>
                                        <tr>
                                            <td><%= k + 1%></td>
                                            <td><%= entKpiList.getKpi_title()%></td>
                                            <td><%= entKpiDistribution.getDistribution()%></td>
                                            <td><%= PstKPI_List.strType[entKpiList.getInputType()] %></td>
                                            <td>-</td>
                                            <td style="text-align: center;">
                                                <form action="kpi_setting_target.jsp" method="POST">
                                                    <input type="hidden" name="<%= FrmKpiSettingList.fieldNames[FrmKpiSettingList.FRM_FIELD_KPI_SETTING_LIST_ID] %>" value="<%= entKpiSettingList.getOID() %>" />
                                                    <button type="submit" class="btn-small" style="color:#FFF; background-color: #ffc107; border: none;">Edit</button>
                                                </form>
                                            </td>
                                        </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
            <% } %>
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

        <script src="../../javascripts/jquery.min.js" type="text/javascript"></script>
        <script src="../../styles/select2/js/select2.full.min.js" type="text/javascript"></script>
        <script src="../../javascripts/bootstrap.bundle.min.js" type="text/javascript"></script>
        <script language="JavaScript">
            //var oBody = document.body;
            //var oSuccess = oBody.attachEvent('onkeydown',fnTrapKD);

            $(function () {
                //Initialize Select2 Elements
                $('.select2').select2()

                //Initialize Select2 Elements

                $('.select2bs4').select2({
                    theme: 'bootstrap4'
                })
            })
        </script>
        <script type="text/javascript">
            var config = {
                '.chosen-select': {},
                '.chosen-select-deselect': {allow_single_deselect: true},
                '.chosen-select-no-single': {disable_search_threshold: 10},
                '.chosen-select-no-results': {no_results_text: 'Oops, nothing found!'},
                '.chosen-select-width': {width: "100%"}
            }
            for (var selector in config) {
                $(selector).chosen(config[selector]);
            }
        </script>
        <script language="JavaScript">
            function pageLoad() {
                $(".mydate").datepicker({dateFormat: "yy-mm-dd"});
            }

            function cmdUpdateSec() {
                document.FRM_NAME_KPISETTING_LIST_DETAIL_LIST.command.value = "<%=String.valueOf(Command.GOTO)%>";
                document.FRM_NAME_KPISETTING_LIST_DETAIL.action = "kpi_setting_form.jsp";
                document.FRM_NAME_KPISETTING_LIST_DETAIL.submit();
            }

            function cmdCancel() {
                document.FRM_NAME_KPISETTING_LIST_DETAIL.command.value = "<%=Command.EDIT%>";
                document.FRM_NAME_KPISETTING_LIST_DETAIL.action = "kpi_setting_form.jsp";
                document.FRM_NAME_KPISETTING_LIST_DETAIL.oidKpiSetting.value = 0;
                document.FRM_NAME_KPISETTING_LIST_DETAIL.submit();
            }

            function cmdBack() {
                document.FRM_NAME_KPISETTING_LIST_DETAIL.command.value = "<%=Command.LIST%>";
                document.FRM_NAME_KPISETTING_LIST_DETAIL.action = "kpi_setting_list.jsp";
                document.FRM_NAME_KPISETTING_LIST_DETAIL.submit();
            }

            function cmdEditDetail(oid) {
                document.FRM_NAME_KPISETTING_LIST_DETAIL.command.value = "<%=Command.EDIT%>";
                document.FRM_NAME_KPISETTING_LIST_DETAIL.oidKpiSetting.value = oid;
                document.FRM_NAME_KPISETTING_LIST_DETAIL.action = "kpi_setting_form.jsp";
                document.FRM_NAME_KPISETTING_LIST_DETAIL.submit();
            }

            function cmdAdd() {
                document.FRM_NAME_KPISETTING_LIST_DETAIL.targetId.value = 0;
                document.FRM_NAME_KPISETTING_LIST_DETAIL.command.value = "<%= Command.ADD%>";
                document.FRM_NAME_KPISETTING_LIST_DETAIL.action = "kpi_setting_form.jsp";
                document.FRM_NAME_KPISETTING_LIST_DETAIL.submit();
            }

            function cmdSave() {
                document.FRM_NAME_KPISETTING_LIST_DETAIL.command.value = "<%=Command.SAVE%>";
                document.FRM_NAME_KPISETTING_LIST_DETAIL.action = "kpi_setting_form.jsp";
                document.FRM_NAME_KPISETTING_LIST_DETAIL.submit();
            }
            function cmdEdit(oid) {
                document.FRM_NAME_KPISETTING_LIST_DETAIL.<%=FrmKpiSetting.fieldNames[FrmKpiSetting.FRM_FIELD_KPI_SETTING_ID]%>.value = oid;
                document.FRM_NAME_KPISETTING_LIST_DETAIL.command.value = "<%= Command.EDIT%>";
                document.FRM_NAME_KPISETTING_LIST_DETAIL.action = "kpi_setting_target.jsp";
                document.FRM_NAME_KPISETTING_LIST_DETAIL.submit();
            }
        </script>
    </body>
</html>

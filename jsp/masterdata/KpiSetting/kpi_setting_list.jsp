<%-- 
    Document   : kpi_setting
    Created on : Sep 1, 2022, 1:33:38 PM
    Autdor     : suryawan
--%>


<%@page import="com.dimata.harisma.entity.masterdata.PstPosition"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstKpiSettingPosition"%>
<%@page import="com.dimata.harisma.form.masterdata.FrmKpiSetting"%>
<%@page import="com.dimata.harisma.form.masterdata.FrmKpiSettingType"%>
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

    int iCommand = FRMQueryString.requestCommand(request);
    int company = FRMQueryString.requestInt(request, "company");
    int position = FRMQueryString.requestInt(request, "position");
    int tahun = FRMQueryString.requestInt(request, "tahun");
    long companyId = FRMQueryString.requestLong(request, "company_search");
    long positionId = FRMQueryString.requestLong(request, "position_search");
    int tahunSrc = FRMQueryString.requestInt(request, "tahun_searching");

    CtrlKpiSetting ctrlKpiSetting = new CtrlKpiSetting(request);
    long iErrCode = ctrlKpiSetting.action(iCommand, oidKpiSetting, request);
    KpiSetting kpiSetting = ctrlKpiSetting.getKpiSetting();

    Vector listKpiSetting = new Vector();
//boolean selectDiv = true;
    boolean selectComp = true;
    boolean selectPosisi = true;
    boolean selectTahun = true;

    Vector valTahun = new Vector();
    Vector keyTahun = new Vector();
    Calendar calNow = Calendar.getInstance();
    int startYear = calNow.get(Calendar.YEAR) - 5;
    int endYear = calNow.get(Calendar.YEAR) + 3;
    valTahun.add("0");
    keyTahun.add("Select..");

    for (int i = startYear; i <= endYear; i++) {
        valTahun.add("" + i);
        keyTahun.add("" + i);
    }

    if (iCommand == Command.LIST) {
        String whereClause = " 1=1 ";
        if (companyId > 0) {
            whereClause += " AND " + PstKpiSetting.fieldNames[PstKpiSetting.FLD_COMPANY_ID] + " = '" + companyId + "'";
        }
        if (positionId > 0) {
            whereClause += " AND tb_posisi." + PstKpiSettingPosition.fieldNames[PstKpiSettingPosition.FLD_POSITION_ID] + " = '" + positionId + "'";
        }
        if (tahun > 0) {
            whereClause += " AND " + PstKpiSetting.fieldNames[PstKpiSetting.FLD_TAHUN] + " = '" + tahun + "'";
        }

        listKpiSetting = PstKpiSetting.listWithJoinPositionAndCompany(whereClause);
    }

%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>KPI SETTING</title>

        <link rel="stylesheet" href="../../styles/css_suryawan/CssSuryawan.css" type="text/css">
        <link rel="stylesheet" href="../../styles/main.css" type="text/css">
        <link rel="stylesheet" href="../../stylesheets/custom.css" >
        <script type="text/javascript">
            function cmdEdit(oid) {
                document.frm.<%=FrmKpiSetting.fieldNames[FrmKpiSetting.FRM_FIELD_KPI_SETTING_ID]%>.value = oid;
                document.frm.command.value = "<%= Command.EDIT%>";
                document.frm.action = "kpi_setting_form.jsp";
                document.frm.submit();
            }
            function cmdEditSettingTarget() {
                document.frm.<%=FrmKpiSetting.fieldNames[FrmKpiSetting.FRM_FIELD_KPI_SETTING_ID]%>.value = 0;
                document.frm.command.value = "<%= Command.EDIT%>";
                document.frm.action = "kpi_setting_target.jsp";
                document.frm.submit();
            }
            function cmdAdd() {
                document.frm.<%=FrmKpiSetting.fieldNames[FrmKpiSetting.FRM_FIELD_KPI_SETTING_ID]%>.value = 0;
                document.frm.command.value = "<%= Command.ADD%>";
                document.frm.action = "kpi_setting_form.jsp";
                document.frm.submit();
            }
            function cmdSearch() {
                document.frm.<%=FrmKpiSetting.fieldNames[FrmKpiSetting.FRM_FIELD_KPI_SETTING_ID]%>.value = 0;
                document.frm.command.value = "<%= Command.LIST%>";
                document.frm.action = "kpi_setting_list.jsp";
                document.frm.submit();
            }
            function cmdBack() {
                document.frm.<%=FrmKpiSetting.fieldNames[FrmKpiSetting.FRM_FIELD_KPI_SETTING_ID]%>.value = 0;
                document.frm.command.value = "<%= Command.BACK%>";
                document.frm.action = "kpi_setting_list.jsp";
                document.frm.submit();
            }
            function cmdDelete(oid) {
                document.frm.<%=FrmKpiSetting.fieldNames[FrmKpiSetting.FRM_FIELD_KPI_SETTING_ID]%>.value = oid;
                document.frm.command.value = "<%= Command.DELETE%>";
                document.frm.action = "kpi_setting_list.jsp";
                document.frm.submit();
            }
            function cmdDetail(oid) {
                document.frm.<%=FrmKpiSetting.fieldNames[FrmKpiSetting.FRM_FIELD_KPI_SETTING_ID]%>.value = oid;
                document.frm.command.value = "<%= Command.EDIT%>";
                document.frm.action = "kpi_setting_list_detail.jsp";
                document.frm.submit();
            }


        </script>
        <link rel="stylesheet" href="<%=approot%>/javascripts/datepicker/tdemes/jquery.ui.all.css">
        <script src="<%=approot%>/javascripts/jquery.js"></script>
        <script src="<%=approot%>/javascripts/datepicker/jquery.ui.core.js"></script>
        <script src="<%=approot%>/javascripts/datepicker/jquery.ui.widget.js"></script>
        <script src="<%=approot%>/javascripts/datepicker/jquery.ui.datepicker.js"></script>
        <script src="../../javascripts/chosen.jquery.js" type="text/javascript"></script>
        <link rel="stylesheet" href="<%=approot%>/styles/datatable/v1/jquery.dataTables.min.css" >
        <script src="<%=approot%>/styles/datatable/v1/jquery.dataTables.min.js"></script>
        <link rel="stylesheet" href="../../stylesheets/chosen.css">
    </head>
    <body>
        <div class="header">
            <table widtd="100%" border="0" cellspacing="0" cellpadding="0">
                <%if (headerStyle && !verTemplate.equalsIgnoreCase("0")) {%> 
                <%@include file="../../styletemplate/template_header.jsp" %>
                <%} else {%>
                <tr> 
                    <td ID="TOPTITLE" background="<%=approot%>/images/HRIS_HeaderBg3.jpg" widtd="100%" height="54"> 
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
            <span id="menu_title">Daftar KPI Setting</span>
        </div>
        <form name="frm" metdod="get" action="">
            <input type="hidden" name="command" value="<%= iCommand%>"> -
            <input type="hidden" name="typeform" value="1"> 
            <input type="hidden" name="<%=FrmKpiSetting.fieldNames[FrmKpiSetting.FRM_FIELD_KPI_SETTING_ID]%>">
            <div class="box">
                <div id="box-title">Pencarian</div>
                <div id="box-content">
                    <table>
                        <tr>
                            <td><strong>Company</strong></td>
                            <td>
                                <select name="company_search" id="company_search" class="chosen-select" >
                                    <%
                                        if (selectComp) {
                                    %>
                                    <option value="0">Select</option>
                                    <%
                                        }
                                    %>

                                    <%
                                        String whereComp = PstCompany.fieldNames[PstCompany.FLD_COMPANY_ID];

                                        if (appUserSess.getAdminStatus() == 0) {
                                            whereComp += " AND " + PstCompany.fieldNames[PstCompany.FLD_COMPANY_ID] + "=" + emplx.getCompanyId();
                                            selectComp = false;
                                        }
                                        Vector companyList = PstCompany.list(0, 0, whereComp, PstCompany.fieldNames[PstCompany.FLD_COMPANY]);
                                        if (companyList != null && companyList.size() > 0) {
                                            for (int i = 0; i < companyList.size(); i++) {
                                                Company comp = (Company) companyList.get(i);
    //                                            untuk fungsi selected
                                                if (comp.getOID() == companyId) {
                                    %>
                                    <option selected value="<%= comp.getOID()%>"><%= comp.getCompany()%></option>
                                    <%
                                    } else {
                                    %>
                                    <option value="<%= comp.getOID()%>"><%= comp.getCompany()%></option>
                                    <%
                                                }
                                            }
                                        }
                                    %>
                                </select> 
                            </td>
                        </tr>

                        <tr>
                            <td><strong>Jabatan</strong></td>
                            <td>
                                <select name="position_search" id="position_search" class="chosen-select">
                                    <%
                                        if (selectPosisi) {
                                    %>
                                    <option value="0">Select</option>
                                    <%
                                        }
                                    %>

                                    <%
                                        String wherePosisi = PstPosition.fieldNames[PstPosition.FLD_VALID_STATUS] + "=1";

                                        if (appUserSess.getAdminStatus() == 0) {
                                            wherePosisi += " AND " + PstPosition.fieldNames[PstPosition.FLD_POSITION_ID] + "=" + emplx.getPositionId();
                                            selectPosisi = false;
                                        }
                                        Vector positionList = PstPosition.list(0, 0, wherePosisi, PstPosition.fieldNames[PstPosition.FLD_POSITION]);
                                        if (positionList != null && positionList.size() > 0) {
                                            for (int i = 0; i < positionList.size(); i++) {
                                                Position posisi = (Position) positionList.get(i);
                                                if (posisi.getOID() == positionId) {
                                    %>
                                    <option selected value="<%= posisi.getOID()%>"><%= posisi.getPosition()%></option>
                                    <%
                                    } else {
                                    %>
                                    <option value="<%= posisi.getOID()%>"><%= posisi.getPosition()%></option>
                                    <%
                                                }
                                            }
                                        }
                                    %>
                                </select> 
                            </td>
                        </tr>
                        <tr>
                            <td><strong>Tahun</strong></td>
                            <td>
                                <%= ControlCombo.draw("tahun", "chosen-select", null, "" + tahun, valTahun, keyTahun, "style='widtd : 30%'")%> 
                            </td>
                        </tr>
                    </table>
                    <div>&nbsp;</div> 
                    <div>
                        <a href="javascript:cmdSearch()" style="color:#FFF;" class="btn">Cari</a>   
                        <a href="javascript:cmdAdd()" style="color:#FFF;" class="btn-add btn-add1">Tambah Kpi Setting Baru</a>
                        <% if (listKpiSetting.size() > 0) {
                        %>
                        <a href="javascript:cmdBack()" style="color:#FFF;" class="btn-back btn-back1">Kembali</a>
                        <%}%>
                    </div>
                </div>
            </div>
            <% if (listKpiSetting.size() > 0) {
            %>
            <div class="box">
                <div>

                </div>
                <div class="content-main">
                    <!--<a href="javascript:cmdEdit()" style="color:#FFF;" class="btn-edit">Edit</a>-->

                    <div>&nbsp;</div>
                    <table class="tblStyle" style="width: 100%;">
                        <tr>
                            <td class="title_tbl" colspan="8">Daftar KPI Setting</td>
                        </tr>
                        <tr>
                            <td class="title_tbl"><center>No</center></td>
                        <td class="title_tbl"><center>Perusahaan</center></td>
                        <td class="title_tbl"><center>Jabatan</center></td>
                        <td class="title_tbl"><center>Status</center></td>
                        <td class="title_tbl"><center>Tanggal Mulai</center></td>
                        <td class="title_tbl"><center>Tanggal Selesai</center></td>
                        <td class="title_tbl"><center>Tahun</center></td>
                        <td class="title_tbl"><center>Action</center></td>
                        </tr>
                        <%
                            if (listKpiSetting != null && listKpiSetting.size() > 0) {
                                for (int i = 0; i < listKpiSetting.size(); i++) {
                                    KpiSetting kpiSettingList = (KpiSetting) listKpiSetting.get(i);
                        %>
                        <tr>
                            <td style="background-color: #FFF;"><%= (i + 1)%></td>
                            <td style="background-color: #FFF;"><%= PstCompany.getCompanyName(kpiSettingList.getCompanyId())%></td>
                            <td style="background-color: #FFF;">
                                <%
                                    Vector vListPosisi = PstPosition.listWithJoinKpiSettingPosition(kpiSettingList.getOID());
                                    for (int j = 0; j < vListPosisi.size(); j++) {
                                        Position objPosition = (Position) vListPosisi.get(j);
                                %>

                                <%= objPosition.getPosition()%> <br><div>&nbsp;</div>

                                <%}%>

                            </td>
                            <td style="background-color: #FFF;"><%= I_DocStatus.fieldDocumentStatus[kpiSettingList.getStatus()]%></td>
                            <td style="background-color: #FFF;"><%= kpiSettingList.getStartDate()%></td>
                            <td style="background-color: #FFF;"><%= kpiSettingList.getValidDate()%></td>
                            <td style="background-color: #FFF;"><%= kpiSettingList.getTahun()%></td>
                            <td style="background-color: #FFF;">
                                <div class="responsive-container">

                                    <a href="javascript:cmdDetail('<%=kpiSettingList.getOID()%>')" style="color: #FFF;" class="btn-detail btn-detail1">Detail</a>&nbsp; 
                                    <a href="javascript:cmdEdit('<%=kpiSettingList.getOID()%>')" style="color: #FFF;" class="btn-edit btn-edit1">Edit</a> &nbsp;
                                    <a href="javascript:cmdDelete('<%=kpiSettingList.getOID()%>')" style="color: #FFF;" class="btn-delete btn-delete1">Delete</a>

                                </div>
                            </td>
                        </tr>
                        <%
                                }
                            }
                        %>
                    </table>

                    <% }%>


                    </form>
                </div>
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
                '.chosen-select-no-single': {disable_search_tdreshold: 10},
                '.chosen-select-no-results': {no_results_text: 'Oops, notding found!'},
                '.chosen-select-widtd': {widtd: "100%"}
            }
            for (var selector in config) {
                $(selector).chosen(config[selector]);
            }
            </script>    
    </body>
</html>


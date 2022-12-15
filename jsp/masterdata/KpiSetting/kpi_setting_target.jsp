<%-- 
    Document   : kpi_setting_target
    Created on : Oct 12, 2022, 2:47:43 PM
    Author     : User
--%>

<%@page import="com.dimata.harisma.form.masterdata.FrmKpiSettingList"%>
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
<%    long oidKpiSettingList = FRMQueryString.requestLong(request, FrmKpiSettingList.fieldNames[FrmKpiSettingList.FRM_FIELD_KPI_SETTING_LIST_ID]);

    int iCommand = FRMQueryString.requestCommand(request);
    String urlBack = FRMQueryString.requestString(request, "urlBack");
    
    KpiSetting entKpiSetting = new KpiSetting();
    KpiSettingList entKpiSettingList = new KpiSettingList();
    if(oidKpiSettingList > 0){
        entKpiSettingList = PstKpiSettingList.fetchExc(oidKpiSettingList);
        entKpiSetting = PstKpiSetting.fetchExc(entKpiSettingList.getKpiSettingId());
    }
    Vector listKpiSettingTarget = new Vector();

    /*menampung data jabatan dalam vektor*/
    Vector vListPosisi = PstPosition.listWithJoinKpiSettingPosition(entKpiSetting.getOID());

    Vector vKpiGroup = new Vector();

%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>KPI SETTING TARGET</title>


        <link rel="stylesheet" href="../../styles/main.css" type="text/css">
        <link rel="stylesheet" href="../../stylesheets/custom.css" >
        
        <script type="text/javascript">
            function cmdEdit(oid) {
                document.frm.<%=FrmKpiSetting.fieldNames[FrmKpiSetting.FRM_FIELD_KPI_SETTING_ID]%>.value = oid;
                document.frm.command.value = "<%= Command.EDIT%>";
                document.frm.action = "kpi_setting_form.jsp";
                document.frm.submit();
            }
            function cmdAdd() {
                document.frm.<%=FrmKpiSetting.fieldNames[FrmKpiSetting.FRM_FIELD_KPI_SETTING_ID]%>.value = 0;
                document.frm.command.value = "<%= Command.ADD%>";
                document.frm.action = "kpi_setting_form.jsp";
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
                document.frm.<%=FrmKpiSetting.fieldNames[FrmKpiSetting.FRM_FIELD_KPI_SETTING_ID]%>.value = "<%=entKpiSetting.getOID()%>";
                document.frm.command.value = "<%= Command.EDIT%>";
                document.frm.action = "kpi_setting_list_detail.jsp";
                document.frm.submit();
            }
            <%} else {%>
            function cmdBack() {
                document.frm.<%=FrmKpiSetting.fieldNames[FrmKpiSetting.FRM_FIELD_KPI_SETTING_ID]%>.value = "<%=entKpiSetting.getOID()%>";
                document.frm.command.value = "<%= Command.EDIT%>";
                document.frm.action = "kpi_setting_form.jsp";
                document.frm.submit();
            }
            <%}%>


        </script>
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
            
        <div class="content-main">
            <a href="javascript:cmdBack();" style="color:#FFF;" class="btn-back btn-back1">Kembali</a>
            <div class="formstyle" style="margin-top: 1rem;">
                <!--judul ini merupakan judul dari KPI-->
                <span>Pendapatan Bunga kredit Korporasi</span>
                <hr>
                <table>
                    <tr>
                        <td>
                            <br><div style="font-size: 12px;">Perusahaan:<%=PstCompany.getCompanyName(entKpiSetting.getCompanyId())%></div>
                            <br><div style="font-size: 12px;">Jabatan        :
                                <%
                                    vListPosisi = PstPosition.listWithJoinKpiSettingPosition(entKpiSetting.getOID());
                                    for (int i = 0; i < vListPosisi.size(); i++) {
                                        Position objPosisi = (Position) vListPosisi.get(i);
                                %>
                                <%=objPosisi.getPosition()%>,
                                <%
                                    }
                                %>
                            </div>
                            <br><div style="font-size: 12px;">Status         :<%= I_DocStatus.fieldDocumentStatus[entKpiSetting.getStatus()]%></div>
                            <br><div style="font-size: 12px;">Tanggal Mulai  :<%= entKpiSetting.getStartDate()%></div>
                            <br><div style="font-size: 12px;">Tanggal Selesai:<%= entKpiSetting.getValidDate()%></div>
                            <br><div style="font-size: 12px;">KPI Group      :</div>
                            <br><div style="font-size: 12px;">KPI            :</div>
                            <br><div style="font-size: 12px;">Tahun          :<%= entKpiSetting.getTahun()%></div>
                        </td>
                    </tr>
                </table>
            </div>

            <div style="display: flex; justify-content: space-between; margin-top: 2rem;">
                <span style="font-size: 15px"><strong>KPI Target Per Satuan Kerja</strong></span>
                <form action="kpi_setting_target_form.jsp" method="POST">
                    <input type="hidden" name="<%= FrmKpiSettingList.fieldNames[FrmKpiSettingList.FRM_FIELD_KPI_SETTING_LIST_ID] %>" value="<%= entKpiSettingList.getOID() %>">
                    <button type="submit" style="color:#fff; border: none;" class="btn-add btn-add1">Tambah Data Target <i class="fa fa-plus"></i></a>
                </form>
                <!--<a href="" style="color:#fff;" class="btn-copy btn-copy1">Salin Data Target Sebelumnya <strong><i class="fa fa-copy"></i></strong></a>-->
            </div>
            <div class="formstyle" style="margin-bottom: 1rem;">
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
                        </table>
                    </tr>
                </table> 
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
                        document.frm.<%=FrmKpiSetting.fieldNames[FrmKpiSetting.FRM_FIELD_KPI_SETTING_ID]%>.value = "<%=entKpiSetting.getOID()%>";
                        document.frm.command.value = "<%= Command.EDIT%>";
                        document.frm.action = "kpi_setting_list_detail.jsp";
                        document.frm.submit();
                    }
            <%} else {%>
                    function cmdBack() {
                        document.frm.<%=FrmKpiSetting.fieldNames[FrmKpiSetting.FRM_FIELD_KPI_SETTING_ID]%>.value = "<%=entKpiSetting.getOID()%>";
                        document.frm.command.value = "<%= Command.EDIT%>";
                        document.frm.action = "kpi_setting_form.jsp";
                        document.frm.submit();
                    }
            <%}%>


        </script>    
</body>
                            <tbody>
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
                                    <td style="text-align: center;">
                                        <a href="#" class="btn-small" style="color:#FFF; background-color: #ffc107;">Edit</a>
                                        <a href="#" class="btn-small" style="color:#FFF; background-color: #d9534f;">Delete</a>
                                    </td>
                                </tr>
                                <tr>
                                    <td></td>
                                    <td colspan="9">
                                        <!--employee table-->
                                        <table class="tblStyle" style="width:100%">
                                            <thead>
                                                <tr>
                                                    <th class="title_tbl">No.</th>
                                                    <th class="title_tbl">NIK</th>
                                                    <th class="title_tbl">Nama</th>
                                                    <th class="title_tbl">Bobot Distribusi</th>
                                                    <th class="title_tbl">Action</th>
                                                </tr>
                                            </thead>

                                            <tbody>
                                                <tr>
                                                    <td>1</td>
                                                    <td>2352364634</td>
                                                    <td>Surya</td>
                                                    <td>70%</td>
                                                    <td style="text-align: center;">
                                                        <a href="#" class="btn-small" style="color:#FFF; background-color: #ffc107;">Edit</a>
                                                        <a href="#" class="btn-small" style="color:#FFF; background-color: #d9534f;">Delete</a>
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </td>
                                </tr>
                            </tbody>
                        </table>  
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
    </body>
</html>

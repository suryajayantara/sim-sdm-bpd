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
    Vector vKpiSettingGroup = new Vector();
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
        <div class="box">
         <div class="content-main">
            <form name="FRM_NAME_KPISETTING_LIST_DETAIL" method ="post" action="">
                <input type="hidden" name="command" value="<%=iCommand%>">
                <input type="hidden" name="urlBack" value="kpi_setting_list_detail.jsp">
                <input type="hidden" name="<%=FrmKpiSetting.fieldNames[FrmKpiSetting.FRM_FIELD_KPI_SETTING_ID]%>">
                    <a href="javascript:cmdBack()" style="color:#FFF;" class="btn-back btn-back1">Kembali</a>
                    <div>&nbsp;</div>
                    <!--data ini akan muncul ketika user klik detail pada kpi setting list-->

                    <div style="border-bottom: 1px solid #DDD;">&nbsp;</div>
                    <div class="row">
                        <div class="col-2">
                            <div style="font-size: 17px">Perusahaan</div>
                            <div style="font-size: 17px">Jabatan</div>
                            <%
                                for (int i = 0; i < vListPosisi.size() - 1; i++) {
                            %>
                            <div style="font-size: 17px" class="text-white">S </div>
                            <%}%>
                            <div style="font-size: 17px">Status</div>
                            <div style="font-size: 17px">Tanggal Mulai</div>
                            <div style="font-size: 17px">Tanggal Selesai</div>
                            <div style="font-size: 17px">Tahun</div>
                        </div>
                        <div class="col-10">
                            <div style="font-size: 17px">: <%=PstCompany.getCompanyName(kpiSetting.getCompanyId())%></div>

                            <div style="font-size: 17px">:
                                <%
                                    for (int i = 0; i < vListPosisi.size(); i++) {
                                        Position objPosition = (Position) vListPosisi.get(i);
                                %>
                                <%= objPosition.getPosition()%>
                                <% if (i != vListPosisi.size() - 1) {%>
                                <br> &nbsp;
                                <%}%>
                                <%}%>
                            </div>
                            <div style="font-size: 17px">: <%= I_DocStatus.fieldDocumentStatus[kpiSetting.getStatus()]%></div>
                            <div style="font-size: 17px">: <%= kpiSetting.getStartDate()%></div>
                            <div style="font-size: 17px">: <%= kpiSetting.getValidDate()%></div>
                            <div style="font-size: 17px">: <%= kpiSetting.getTahun()%></div>
                        </div>
                    </div>
                    <div style="border-top: 1px solid #DDD;">&nbsp;</div>
                    <div>&nbsp;</div>
            </form>
        
       <%
            Vector vKpiSetting = PstKPI_Type.listWithJoinKpiSettingTypeAndKpiSetting(kpiSetting.getOID());
            long lastKpiTypeOID = 0;
            for (int i = 0; i < vKpiSetting.size(); i++) {
                KPI_Type kpiType = (KPI_Type) vKpiSetting.get(i);
                if (kpiType.getOID() > 0) {
                    if (kpiType.getOID() != lastKpiTypeOID) {

        %>
        <div class="formstyle mb-3">
            <form name="<%= FrmKpiSettingType.FRM_NAME_KPISETTINGTYPE%>_<%= kpiType.getKpiSettingTypeId()%>" method="get" id="FRM_NAME_KPISETTINGTYPE_<%= kpiType.getKpiSettingTypeId()%>">
               
                <input type="hidden" name="<%=FrmKpiSettingType.fieldNames[FrmKpiSettingType.FRM_FIELD_KPI_SETTING_TYPE_ID]%>" value="<%= kpiType.getOID()%>">
                <div class="row mb-3">
                    <div class="col d-flex justify-content-between">
                        <span style="font-size: 17px"> <%= kpiType.getType_name()%> </span>
                    </div>
                </div>      
            </form>
       <form name="FRM_NAME_KPISETTINGLIST" method ="post" action="">
                <input type="hidden" name="command" value="<%=iCommand%>">
                <input type="hidden" name="typeform" value="3">
                <input type="hidden" name="<%=FrmKpiSettingList.fieldNames[FrmKpiSettingList.FRM_FIELD_KPI_SETTING_LIST_ID]%>" value="<%=kpiSettingList.getOID()%>">
                <input type="hidden" name="<%=FrmKpiSettingGroup.fieldNames[FrmKpiSettingGroup.FRM_FIELD_KPI_GROUP_ID]%>" value="<%=oidKpiSettingGroup%>">
                <input type="hidden" name="<%=FrmKpiSetting.fieldNames[FrmKpiSetting.FRM_FIELD_KPI_SETTING_ID]%>" value="<%=kpiSetting.getOID() %>">
                <input type="hidden" name="<%=FrmKpiSettingList.fieldNames[FrmKpiSettingList.FRM_FIELD_KPI_LIST_ID]%>" value="<%=kpiSettingList.getKpiListId()%>">
                <input type="hidden" name="<%=FrmKpiSettingType.fieldNames[FrmKpiSettingType.FRM_FIELD_KPI_TYPE_ID]%>" value="<%=kpiType.getOID()%>">
                <table class="tblStyle" style="width: 100%;">
                    <thead>
                        <tr>
                            <th class="title_tbl" style="font-size: 17px">Kpi Group</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            String query = "KPI_SETTING_TYPE_ID = '" + kpiType.getKpiSettingTypeId() + "'";
                            vKpiSettingGroup = PstKpiSettingGroup.list(0, 0, query, "");
                            if (vKpiSettingGroup.size() > 0) {
                                for (int j = 0; j < vKpiSettingGroup.size(); j++) {
                                    KpiSettingGroup objKpiSettingGroup = (KpiSettingGroup) vKpiSettingGroup.get(j);
                                    KPI_Group objKpiGroup = PstKPI_Group.fetchExc(objKpiSettingGroup.getKpiGroupId());
                        %>
                        <tr style="background-color: #F3f3f3;">
                            <td class="p-3" value="<%= objKpiGroup.getOID()%>" style="font-size: 25px"><%= objKpiGroup.getGroup_title()%> </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <!-- table kpi list -->
                                <table style="width: 100%;">
                                    <thead style="text-align: center;">
                                        <tr>
                                            <th style="font-size: 17px">No.</th>
                                            <th style="font-size: 17px">Key Performance Indicator</th>
                                            <th style="font-size: 17px">Distribution Option</th>
                                            <th style="font-size: 17px">Satuan Ukur</th>
                                            <th style="font-size: 17px">Target</th>
                                            <th style="font-size: 17px">Bobot</th>
                                             
                                        </tr>
                                    </thead>
                                    <tbody>

                                        <%
                                            Vector vKpiSettingList = PstKpiSettingList.list(0, 0, "`KPI_SETTING_ID` = " + kpiSetting.getOID() + " AND `KPI_SETTING_GROUP_ID` = " + objKpiSettingGroup.getOID(), "");
                                            if (vKpiSettingList.size() > 0) {
                                                for (int k = 0; k < vKpiSettingList.size(); k++) {
                                                    KpiSettingList entKpiSettingList = (KpiSettingList) vKpiSettingList.get(k);
                                                    KPI_List entKpiList = PstKPI_List.fetchExc(entKpiSettingList.getKpiListId());
                                                    KpiDistribution entKpiDistribution = PstKpiDistribution.fetchExc(entKpiSettingList.getKpiDistributionId());
                                        %>
                                        <tr>
                                            <td><%= k + 1%></td>
                                            <td value="<%=entKpiList.getOID()%>"><%= entKpiList.getKpi_title()%></td>
                                            <td> <%= entKpiDistribution.getDistribution()%> </td>
                                            <td> - </td>
                                            <td width="5%" class="text-center">
                                                <!--button ini ditampilkan ketika user klik tombol simpan di bawah tabel kpi type-->
                                                <a href="javascript:cmdEditKpiSettingTarget('<%=kpiSetting.getOID()%>','<%=objKpiGroup.getOID() %>')" style="color: #FFF; background-color: #ffc107;"  class="btn-small">Edit</a>
                                            </td>
                                            <td> - </td>
                                        </tr>
                                        
                                        <%      }
                                        } else {
                                        %>
                                        <tr>
                                            <td colspan="8" class="text-center">Tidak ada data.</td>
                                        </tr>
                                        <%
                                            }
                                        %>
                                        <tr>
                                            <td class="title_tbl" colspan="5"><center><strong>Total</strong></center></td>
                                <td><center> - </center></td>
                                        </tr>
                                    
                                    </tbody>
                                </table>
                            </td>
                        </tr>
                        <%
                            }
                        } else {
                        %>
                        <tr>
                            <td class="text-center" colspan="7"> Data tidak ditemukan. </td>
                        </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
            </form>
            </form>
         
        </div>
       
        <%
            }
            lastKpiTypeOID = kpiType.getOID();
        } else {
        %>
         
        <div class="formstyle mb-3">
            <table class="tblStyle" style="width: 100%;">
                <thead class="text-center">
                    <tr>
                        <th class="title_tbl"  style="width: 20%;">Kpi Group</th>
                        <th class="title_tbl" style="width: 20%;">Key Performance Indicator</th>
                        <th class="title_tbl">Distribution Option</th>
                        <th class="title_tbl">Satuan Ukur</th>
                        <th class="title_tbl">Target</th>
                        <th class="title_tbl">Bobot</th>
                        <th class="title_tbl">Action</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td class="text-center" colspan="7">Data tidak ditemukan.</td>
                    </tr>
                </tbody>
            </table>
        </div>
        <%
                }
            }
        %>

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

//            function cmdUpdateDivision() {
//                document..FRM_NAME_KPISETTING_LIST_DETAIL.command.value = "<%= Command.ADD%>";
//                document..FRM_NAME_KPISETTING_LIST_DETAIL.action = "kpi_setting_form.jsp";
//                document..FRM_NAME_KPISETTING_LIST_DETAIL.submit();
//            }

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
            
            function cmdEditKpiSettingTarget(oidKpiSetting, oidKpiGroup) {
                document.FRM_NAME_KPISETTING_LIST_DETAIL.<%=FrmKpiSetting.fieldNames[FrmKpiSetting.FRM_FIELD_KPI_SETTING_ID]%>.value = oidKpiSetting;
                document.FRM_NAME_KPISETTING_LIST_DETAIL.<%=FrmKpiSettingGroup.fieldNames[FrmKpiSettingGroup.FRM_FIELD_KPI_GROUP_ID]%>.value = oidKpiGroup;
                document.FRM_NAME_KPISETTING_LIST_DETAIL.command.value = "<%= Command.EDIT%>";
                document.FRM_NAME_KPISETTING_LIST_DETAIL.action = "kpi_setting_target_form.jsp";
                document.FRM_NAME_KPISETTING_LIST_DETAIL.submit();
            }
        </script>
    </body>
</html>

<%-- 
    Document   : kpi_setting
    Created on : Sep 1, 2022, 1:33:38 PM
    Author     : suryawan
--%>


<%@page import="com.dimata.harisma.form.masterdata.CtrlKpiSettingGroup"%>
<%@page import="com.dimata.harisma.form.masterdata.FrmKpiSettingGroup"%>
<%@page import="com.dimata.harisma.form.masterdata.CtrlKPI_Group"%>
<%@page import="com.dimata.harisma.form.masterdata.FrmKPI_Group"%>
<%@page import="com.dimata.harisma.form.masterdata.FrmKpiSettingList"%>
<%@page import="com.dimata.harisma.form.masterdata.CtrlKpiSettingList"%>
<%@page import="com.dimata.harisma.form.masterdata.CtrlKPI_List"%>
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
    long oidKpiSettingType = FRMQueryString.requestLong(request, FrmKpiSettingType.fieldNames[FrmKpiSettingType.FRM_FIELD_KPI_SETTING_TYPE_ID]);
    long oidKpiSettingList = FRMQueryString.requestLong(request, FrmKpiSettingList.fieldNames[FrmKpiSettingList.FRM_FIELD_KPI_SETTING_LIST_ID]);
    long oidKpiGroupBuatNambahGroup = FRMQueryString.requestLong(request, FrmKpiSettingGroup.fieldNames[FrmKpiSettingGroup.FRM_FIELD_KPI_SETTING_GROUP_ID]);


    /*berfungsi untuk menyiman data sementara, yang di mana ini bisa dibilang adalah penerima oid tapi ini hardcore*/
    long kpiSettingId = (FRMQueryString.requestLong(request, "kpi_setting_id") == 0)? oidKpiSetting : FRMQueryString.requestLong(request, "kpi_setting_id");
    int iCommand = FRMQueryString.requestCommand(request);
    int tahun = Calendar.getInstance().get(Calendar.YEAR);
    long oidCompany = FRMQueryString.requestLong(request, "company");

    /*untuk memisah controller satu dengan lainnya, jadi ketika menyimpan data atau perlu action di controller berbeda, maka action akan diarahkan ke controller yang sesuai*/
    long typeform = FRMQueryString.requestLong(request, "typeform");

    /*Ini Untuk array of string OID*/
    String oid_division[] = FRMQueryString.requestStringValues(request, "division");
    String oid_company[] = FRMQueryString.requestStringValues(request, "company");
    String oid_position[] = FRMQueryString.requestStringValues(request, "position");
    String oid_kpi_type[] = FRMQueryString.requestStringValues(request, "kpitype");
    String oid_kpi_group[] = FRMQueryString.requestStringValues(request, "kpigroup");
    String oid_kpi[] = FRMQueryString.requestStringValues(request, "kpi");
    String oid_kpi_distribution[] = FRMQueryString.requestStringValues(request, "kpidistribution");

    /*Ini Untuk Variable Sementara(Temporary) */
    long positionId = FRMQueryString.requestLong(request, "position");
    String startDate = FRMQueryString.requestString(request, "start_date");
    String validDate = FRMQueryString.requestString(request, "valid_date");
    String grouptitle = FRMQueryString.requestString(request, "group_title");
    String description = FRMQueryString.requestString(request, "description");
    Long dtReq = FRMQueryString.requestLong(request, "requestDateDaily");
    java.util.Date requestDate = new Date();
    if (dtReq != 0) {
        requestDate = new Date(dtReq.longValue());
    }

    String whereClause = "";
    Date dateNow = new Date();
    ChangeValue changeValue = new ChangeValue();
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    String strDateNow = "";
    if (dtReq != 0) {
        strDateNow = sdf.format(requestDate);
    } else {
        strDateNow = sdf.format(dateNow);
    }

    String strDate = "";

    /* ADD Data Kpi Setting */
    //String sValidDate= FRMQueryString.requestString(request, FrmKpiSetting.fieldNames[FrmKpiSetting.FRM_FIELD_START_DATE]);
    //sValidDate = sValidDate; 

    CtrlKpiSettingGroup ctrlKpiSettingGroup = new CtrlKpiSettingGroup(request);
    if (typeform == 1){
    long iErrCodeSetttingGroup = ctrlKpiSettingGroup.action(iCommand, oidKpiGroupBuatNambahGroup, request);
    if (iCommand == Command.SAVE) {
        iCommand = 0;
    }
    }
    KpiSettingGroup kpiSettingGroup = ctrlKpiSettingGroup.getKpiSettingGroup();

    
    /*controller untuk simpan data kpi setting*/
    CtrlKpiSetting ctrlKpiSetting = new CtrlKpiSetting(request);
        long iErrCode = ctrlKpiSetting.action(iCommand, oidKpiSetting, request);
        if (iCommand == Command.SAVE) {
            iCommand = 0;
        }
    KpiSetting kpiSetting = ctrlKpiSetting.getKpiSetting();

    /*controller untuk simpan data kpi setting type*/
//    CtrlKpiSettingType ctrlKpiSettingType = new CtrlKpiSettingType(request);
//    if (typeform == 2) {
//        long iErrCode = ctrlKpiSetting.action(Command.EDIT, oidKpiSetting, request);
//        long iErrCodeSettingType = ctrlKpiSettingType.action(iCommand, oidKpiSettingType, request);
//        if (iCommand == Command.SAVE) {
//            iCommand = 0;
//        }
//        kpiSetting = ctrlKpiSetting.getKpiSetting();
//    }
//        KpiSettingType kpiSettingType = ctrlKpiSettingType.getKpiSettingType();
//        if (iCommand == Command.EDIT && kpiSettingType != null && kpiSettingType.exists()) {
//    }
//    

    /*digunakan untuk button edit agar sesuai dengan oid tabel utama,
     untuk form jabatan, harus dibuat fungsi array di pst kpi setting 
    baru karena sudah mengambil data dengan bentuk array string */
    if (iCommand == Command.EDIT || kpiSetting.getOID() != 0) {
        oid_position = PstKpiSettingPosition.arrayKpiSettingPositionOID(kpiSetting.getOID());
        oid_kpi_type = PstKpiSettingType.arrayListKpiSettingType(kpiSetting.getOID());
        startDate = Formater.formatDate(kpiSetting.getStartDate(), "yyyy-MM-dd");
        validDate = Formater.formatDate(kpiSetting.getValidDate(), "yyyy-MM-dd");
    }

    /*controller untuk save data kpi setting list*/
    CtrlKpiSettingList ctrlKpiSettingList = new CtrlKpiSettingList(request);
    long iErrCodeSetttingList = ctrlKpiSettingList.action(iCommand, oidKpiSettingList, request);
    if (iCommand == Command.SAVE) {
        iCommand = 0;
    }
    KpiSettingList kpiSettingList = ctrlKpiSettingList.getKpiSettingList();

    /*controlle untuk mengolah data kpi Setting Group*/

    
    
    if (oidCompany != 0) {
        kpiSetting.setCompanyId(oidCompany);
    } else {
        oidCompany = kpiSetting.getCompanyId();
    }

    // untuk mengambil data KPI Setting Type
    Vector kpiType = new Vector();
    try {
        if (oidKpiSettingType != 0) {
            String query = "KPI_TYPE_ID = '" + oidKpiSettingType + "'";
            kpiType = PstKPI_Type.list(0, 1, query, "");
        }
    } catch (Exception e) {
        System.out.println("Error fetch :" + e);
    }


%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>KPI SETTING LIST FORM</title>


        <link rel="stylesheet" href="../../styles/css_suryawan/CssSuryawan.css" type="text/css">
        <link rel="stylesheet" href="<%=approot%>/javascripts/datepicker/themes/jquery.ui.all.css">
        <script src="<%=approot%>/javascripts/jquery.js"></script>
        <script src="<%=approot%>/javascripts/datepicker/jquery.ui.core.js"></script>
        <script src="<%=approot%>/javascripts/datepicker/jquery.ui.widget.js"></script>
        <script src="<%=approot%>/javascripts/datepicker/jquery.ui.datepicker.js"></script>

        <link rel="stylesheet" href="../../styles/main.css" type="text/css">

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

        <link rel="stylesheet" href="../../styles/main.css" type="text/css">
        <link rel="stylesheet" href="../../stylesheets/custom.css" >
        <link href="../../styles/select2/css/select2.min.css" rel="stylesheet" type="text/css"/>
        <link href="../../styles/select2/css/select2-bootstrap4.min.css" rel="stylesheet" type="text/css"/>
        <link href="../../styles/select2/css/select2-bootstrap4.min.css" rel="stylesheet" type="text/css"/>
        <link rel="stylesheet" href="<%=approot%>/styles/sweetalert2.min.css">

        <!--bootsrtrap untuk menu pop up-->
        <link href="../../styles/bootstrap 5.0/css/bootstrap.css" rel="stylesheet" type="text/css"/>
        <script href="../../styles/bootstrap 5.0/js/bootstrap.bundle.js" type="text/javascript"></script>

        <!--end-->
        <link rel="stylesheet" href="../../stylesheets/chosen.css" >
        <link rel="stylesheet" href="../../stylesheets/custom.css" >

        <script language="JavaScript">

            function pageLoad() {
                $(".mydate").datepicker({dateFormat: "yy-mm-dd"});
            }

//            function cmdUpdateDivision() {
//                document.FRM_NAME_KPISETTING.command.value = "<%= Command.ADD%>";
//                document.FRM_NAME_KPISETTING.action = "kpi_setting_form.jsp";
//                document.FRM_NAME_KPISETTING.submit();
//            }
            function cmdUpdateSec() {
                document.FRM_NAME_KPISETTING.command.value = "<%=String.valueOf(Command.GOTO)%>";
                document.FRM_NAME_KPISETTING.action = "kpi_setting_form.jsp";
                document.FRM_NAME_KPISETTING.submit();
            }

            function cmdCancel() {
                document.FRM_NAME_KPISETTINGLISTFORM.command.value = "<%=Command.EDIT%>";
                document.FRM_NAME_KPISETTINGLISTFORM.action = "kpi_setting_form.jsp";
                document.FRM_NAME_KPISETTINGLISTFORM.oidKpiSetting.value = 0;
                document.FRM_NAME_KPISETTINGLISTFORM.submit();
            }

            function cmdBack() {
                document.FRM_NAME_KPISETTINGLISTFORM.command.value = "<%=Command.EDIT%>";
                document.FRM_NAME_KPISETTINGLISTFORM.action = "kpi_setting_form.jsp";
                document.FRM_NAME_KPISETTINGLISTFORM.submit();
            }

            function cmdEditDetail(oid) {
                document.FRM_NAME_KPISETTINGLISTFORM.command.value = "<%=Command.EDIT%>";
                document.FRM_NAME_KPISETTINGLISTFORM.oidKpiSetting.value = oid;
                document.FRM_NAME_KPISETTINGLISTFORM.action = "kpi_setting_form.jsp";
                document.FRM_NAME_KPISETTINGLISTFORM.submit();
            }

            function cmdAdd() {
                document.FRM_NAME_KPISETTINGLISTFORM.command.value = "<%= Command.ADD%>";
                document.FRM_NAME_KPISETTINGLISTFORM.action = "kpi_setting_form.jsp";
                document.FRM_NAME_KPISETTINGLISTFORM.submit();
            }
            function cmdAddKpiSettingList() {
                document.FRM_NAME_KPISETTINGLISTFORM.command.value = "<%= Command.ADD%>";
                document.FRM_NAME_KPISETTINGLISTFORM.action = "kpi_setting_list.jsp";
                document.FRM_NAME_KPISETTINGLISTFORM.submit();
            }
            function cmdAddKpiSettingList() {
                document.FRM_NAME_KPISETTINGLISTFORM.targetId.value = 0;
                document.FRM_NAME_KPISETTINGLISTFORM.command.value = "<%= Command.ADD%>";
                document.FRM_NAME_KPISETTINGLISTFORM.action = "kpi_setting_form.jsp";
                document.FRM_NAME_KPISETTINGLISTFORM.submit();
            }
            function cmdSave() {
                document.FRM_NAME_KPISETTINGLISTFORM.command.value = "<%=Command.SAVE%>";
                document.FRM_NAME_KPISETTINGLISTFORM.action = "kpi_setting_form.jsp";
                document.FRM_NAME_KPISETTINGLISTFORM.submit();
            }
//            function cmdSaveKpiSettingGroup() {
//                document.FRM_NAME_KPISETTINGLISTFORM.command.value = "<%=Command.SAVE%>";
//                document.FRM_NAME_KPISETTINGLISTFORM.action = "kpi_setting_list_form.jsp";
//                document.FRM_NAME_KPISETTINGLISTFORM.submit();
//            }
            function cmdSaveKpiType() {
                document.FRM_NAME_KPISETTINGLISTFORM.command.value = "<%=Command.SAVE%>";
                document.FRM_NAME_KPISETTINGLISTFORM.action = "kpi_setting_form.jsp";
                document.FRM_NAME_KPISETTINGLISTFORM.submit();
            }
            function cmdSaveKpiSettingList() {
                document.FRM_NAME_KPISETTINGLISTFORM.command.value = "<%=Command.SAVE%>";
                document.FRM_NAME_KPISETTINGLISTFORM.action = "kpi_setting_form.jsp";
                document.FRM_NAME_KPISETTINGLISTFORM.submit();
            }
            function cmdSaveKpi() {
                document.FRM_NAME_KPI.command.value = "<%=Command.SAVE%>";
                document.FRM_NAME_KPI.action = "kpi_setting_list_form.jsp";
                document.FRM_NAME_KPI.submit();
            }
            function cmdEdit(oid) {
                document.FRM_NAME_KPISETTINGLISTFORM.<%=FrmKpiSetting.fieldNames[FrmKpiSetting.FRM_FIELD_KPI_SETTING_ID]%>.value = oid;
                document.FRM_NAME_KPISETTINGLISTFORM.command.value = "<%= Command.EDIT%>";
                document.FRM_NAME_KPISETTINGLISTFORM.action = "kpi_setting_target.jsp";
                document.FRM_NAME_KPISETTINGLISTFORM.submit();
            }
            var popup;
            function init() {
                onload = "init()";
//                emp_department = document.frm_pay_emp_level.department.value;
                popup = window.open("kpi_distribution.jsp?emp_department="
                        , "SelectEmployee", "height=600,width=700,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes");
                popup.focus();
            }
            function masterKpiGroup() {
                onload = "masterKpiGroup()";
//                emp_department = document.frm_pay_emp_level.department.value;
                popup = window.open("../kpi_group.jsp?emp_department="
                        , "SelectEmployee", "height=600,width=700,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes");
                popup.focus();
            }
            function masterKpi() {
                onload = "masterKpi()";
//                emp_department = document.frm_pay_emp_level.department.value;
                popup = window.open("../kpi_list.jsp?emp_department="
                        , "SelectEmployee", "height=600,width=700,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes");
                popup.focus();
            }

        </script>
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


        <!--data ini akan muncul ketika user klik detail pada kpi setting list-->

        <div class="box">
            <form name="FRM_NAME_KPISETTINGLISTFORM" method ="post" action="">
                <input type="hidden" name="command" value="<%=iCommand%>">
                <input type="hidden" name="urlBack" value="kpi_setting_list_detail.jsp">
                <input type="hidden" name="<%=FrmKpiSetting.fieldNames[FrmKpiSetting.FRM_FIELD_KPI_SETTING_ID]%>">
                <div class="content-main">
                    <div>&nbsp;</div>
                    <!--data ini akan muncul ketika user klik detail pada kpi setting list-->
                    <%
                        for (int i = 0; i < kpiType.size(); i++) {
                            KPI_Type objKpiType = (KPI_Type) kpiType.get(i);
                    %>
                    <span><%= objKpiType.getType_name()%> - <%= PstCompany.getCompanyName(oidCompany)%></span>
                    <% }%>
                    <div style="border-bottom: 1px solid #DDD;">&nbsp;</div>
                    <div style="font-size: 15px">Jabatan: <%= oidCompany%>
                        <%
                            Vector vListPosisi = PstPosition.listWithJoinKpiSettingPosition(kpiSetting.getOID());
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
                    <div style="border-top: 1px solid #DDD;">&nbsp;</div>
                    <a href="javascript:cmdEdit()" style="color:#FFF;" class="btn-edit btn-edit1" >Edit Kpi Setting</a>
                    <a href="javascript:cmdAdd()" type="hidden" style="color:#FFF;" class="btn-simpan btn-simpan1" data-toggle="modal" data-target="#exampleModal"  >Tambah Group Baru  <strong><i class="fa fa-plus"></i></strong></a>
                    &nbsp;<a href="javascript:masterKpiGroup()" type="hidden" style="color:#FFF;" class="btn-add btn-add1" >Master Data Kpi Group <strong><i class="fa fa-plus"></i></strong></a>
                    &nbsp;<a href="javascript:masterKpi()" style="color:#FFF;" class="btn-add btn-add1">Master Data Kpi <strong><i class="fa fa-plus"></i></strong></a>
                    &nbsp;<a href="javascript:init()"  style="color:#FFF;" class="btn-add btn-add1" >Master Data Distribusi <strong><i class="fa fa-plus"></i></strong></a>
                    <!--Tampilan form setelah input data kpi type-->
                </div>  
            </form>
        </div>

        <div class="box mb-5">
            <div class="formstyle">
                <div class="d-flex justify-content-between">
                    <span> KPI Group : </span>
                    <div>
                        <a href="javascript:cmdAdd()" type="hidden" style="color:#FFF;" class="btn-add btn-add1 mx-2" data-toggle="modal" data-target="#exampleModal2" >Tambah KPI
                            <strong><i class="fa fa-plus"></i></strong>
                        </a>
                        <a href="#" type="hidden" style="color:#FFF;" class="btn-delete btn-delete1">
                            <strong><i class="fa fa-trash"></i></strong>
                        </a>
                    </div>
                </div>
                <form name="FRM_NAME_KPISETTINGLISTFORM" method ="post" action="">
                    <input type="hidden" name="command" value="<%=iCommand%>">
                    <input type="hidden" name="<%=FrmKpiSettingList.fieldNames[FrmKpiSettingList.FRM_FIELD_KPI_SETTING_LIST_ID]%>" value="<%=kpiSettingList.getOID()%>">
                    <div>&nbsp;</div>
                    <table class="tblStyle" style="width: 100%;">
                        <thead class="text-center">
                            <tr>
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
                                <td>
                                    <%-- <select style="width: 100%;" class="form-control form-control-sm custom-select">
                                        <option>Select</option>
                                        <%
                                            Vector listKpi = PstKPI_List.list(0, 0, "", "");
                                            for (int i = 0; i < listKpi.size(); i++) {
                                                KPI_List objKpi = (KPI_List) listKpi.get(i);
                                                String selected = "";
                                                if (oid_kpi != null) {
                                                    for (int j = 0; j < oid_kpi.length; j++) {
                                                        String oidKpi = "" + objKpi.getOID();
                                                        if (oidKpi.equals("" + oid_kpi[j])) {
                                                            selected = "selected";
                                                        }
                                                    }
                                            %>

                                        <option value="<%=objKpi.getOID()%>" <%=selectedKpi%>><%=objKpi.getKpi_title()%></option>
                                        <%
                                            }
        
                                    %>
        
                                    <option value="<%=objKpi.getOID()%>" <%=selected%>><%=objKpi.getKpi_title()%></option>
                                    <%
                                        }
                                    %>
                                </select> --%>
                                    Kpi Performance
                                </td>
                                <td>
                                    <%-- <select style="width: 100%;" class="form-control form-control-sm custom-select">
                                        <option>Select</option>
                                        <%
                                            Vector listKpiDistribution = PstKpiDistribution.list(0, 0, "", "");
                                            for (int i = 0; i < listKpiDistribution.size(); i++) {
                                                KpiDistribution objKpiDistribution = (KpiDistribution) listKpiDistribution.get(i);
                                                String selected = "";
                                                if (oid_kpi != null) {
                                                    for (int j = 0; j < oid_kpi.length; j++) {
                                                        String oidKpiDistribution = "" + objKpiDistribution.getOID();
                                                        if (oidKpiDistribution.equals("" + oid_kpi_distribution[j])) {
                                                            selected = "selected";
                                                        }
                                                    }

                                        %>

                                        <option value="<%=objKpiDistribution.getOID()%>" <%=selected%>><%=objKpiDistribution.getDistribution()%></option>
                                        <%
                                            }
        
                                    %>
        
                                    <option value="<%=objKpiDistribution.getOID()%>" <%=selected%>><%=objKpiDistribution.getDistribution()%></option>
                                    <%
                                        }
                                    %>
                                </select> --%>
                                    Distribution Option
                                </td>
                                <td>
                                    <%-- <select style="width: 100%;" class="form-control form-control-sm custom-select">
                                        <option value="">Select</option>
                                        <option value="0">Persentase</option>
                                        <option value="1">Waktu</option>
                                        <option value="2">Jumlah</option>
                                    </select> --%>
                                    Satuan Ukur
                                </td>
                                <td>
                                    <!--button ini ditampilkan ketika user klik tombol simpan di bawah tabel kpi type-->
                        <center>
                            <a href="javascript:cmdEdit('<%=kpiSetting.getOID()%>')" style="color: #FFF;" class="btn-edit btn-edit1">Edit</a>
                        </center>
                        </td>
                        <td>10</td>
                        <td>
                            <!--button ini ditampilkan ketika user klik tombol simpan di bawah tabel kpi type-->
                            <div class="responsive-container">
                                <a href="javascript:cmdEdit('<%=kpiSetting.getOID()%>')" style="color: #FFF;" class="btn-edit btn-edit1 mx-2">Edit</a>
                                <a href="javascript:cmdDelete('<%=kpiSetting.getOID()%>')" style="color: #FFF;" class="btn-delete btn-delete1">Delete</a>
                            </div>
                        </td>
                        </tr>
                        </tbody>
                    </table>
                </form>       
            </div>
        </div> 
        <div class="modal fade" id="exampleModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="exampleModalLabel">Pilih Kpi Group</h5>
                    </div>                            
                    <div class="modal-body">
                        <form name="FRM_NAME_KPISETTINGGROUP" method ="post" action="">
                            <input type="hidden" name="command" value="<%=Command.SAVE %>">
                            <input type="hidden" name="typeform" value="1">
                            <input type="hidden" name="<%=FrmKpiSettingGroup.fieldNames[FrmKpiSettingGroup.FRM_FIELD_KPI_SETTING_GROUP_ID]%>" value="<%=kpiSettingGroup.getKpiSettingGroupId() %>">
                            <input type="hidden" name="<%=FrmKpiSetting.fieldNames[FrmKpiSetting.FRM_FIELD_KPI_SETTING_ID]%>" value="<%=oidKpiSetting%>">
                            <div class="form-group">
                             <label for="exampleInputPassword">KPI Group</label>
                            <select name="<%=FrmKpiSettingGroup.fieldNames[FrmKpiSettingGroup.FRM_FIELD_KPI_SETTING_GROUP_ID]%>"style="width: 100%;" class="form-control form-control-sm custom-select">
                                    <option value="">=Select=</option>
                                    <%
                                        Vector listKpiGroup = PstKPI_Group.list(0, 0, "", "");
                                        for (int i = 0; i < listKpiGroup.size(); i++) {
                                            KPI_Group objKpiGroup = (KPI_Group) listKpiGroup.get(i);
                                            String selected = "";
                                            if (oid_kpi != null) {
                                                for (int j = 0; j < oid_kpi.length; j++) {
                                                    String oidKpiGroup = "" + objKpiGroup.getOID();
                                                    if (oidKpiGroup.equals("" + oid_kpi_group[j])) {
                                                        selected = "selected";
                                                    }
                                                }
                                            }

                                    %>

                                    <option value="<%=objKpiGroup.getOID()%>" <%=selected%>><%=objKpiGroup.getGroup_title() %></option>
                                    <%
                                        }
                                    %>


                                </select>
   
                                
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                                <a href="javascript:cmdSaveKpiSettingGroup()" style="color:#FFF;" class="btn-simpan btn-simpan1">Save changes</a>
                            </div>
                        </form> 
                    </div>
                </div>
            </div>
        </div>
        </div>
                                
        <div class="modal fade" id="exampleModal2" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="exampleModalLabel">Pilih Kpi</h5>
                    </div>                            
                    <div class="modal-body">
                        <form name="FRM_NAME_KPI" method ="post" action="">
                            <input type="hidden" name="command" value="<%=iCommand%>">
                            <input type="hidden" name="typeform" value="2">

                            <div class="form-group">
                                <label for="exampleInputPassword">Kpi</label>
                                <select name="<%=FrmKpiSettingType.fieldNames[FrmKpiSettingType.FRM_FIELD_KPI_TYPE_ID]%>"style="width: 100%;" class="form-control form-control-sm custom-select">
                                    <option value="">=Select=</option>
                                    <%
                                        Vector listKpi = PstKPI_List.list(0, 0, "", "");
                                        for (int i = 0; i < listKpi.size(); i++) {
                                            KPI_List objKpi = (KPI_List) listKpi.get(i);
                                            String selected = "";
                                            if (oid_kpi != null) {
                                                for (int j = 0; j < oid_kpi.length; j++) {
                                                    String oidKpi = "" + objKpi.getOID();
                                                    if (oidKpi.equals("" + oid_kpi[j])) {
                                                        selected = "selected";
                                                    }
                                                }
                                            }

                                    %>

                                    <option value="<%=objKpi.getOID()%>" <%=selected%>><%=objKpi.getKpi_title() %></option>
                                    <%
                                        }
                                    %>


                                </select>

                            </div>
                                    <div class="form-group">
                                        <label>Distribution</label>
                                        <select style="width: 100%;" class="form-control form-control-sm custom-select">
                                        <option>Select</option>
                                        <%
                                            Vector listKpiDistribution = PstKpiDistribution.list(0, 0, "", "");
                                            for (int i = 0; i < listKpiDistribution.size(); i++) {
                                                KpiDistribution objKpiDistribution = (KpiDistribution) listKpiDistribution.get(i);
                                                String selected = "";
                                                if (oid_kpi != null) {
                                                    for (int j = 0; j < oid_kpi.length; j++) {
                                                        String oidKpiDistribution = "" + objKpiDistribution.getOID();
                                                        if (oidKpiDistribution.equals("" + oid_kpi_distribution[j])) {
                                                            selected = "selected";
                                                        }
                                                    }
                                                }
                                        %>

                                        <option value="<%=objKpiDistribution.getOID()%>" <%=selected%>><%=objKpiDistribution.getDistribution()%></option>
                                        <%
                                            }
        
                                    %>
                                </select> 
                                    </div>
                                    <div class="form-group">
                                        <label>Satuan Ukur</label>
                                        <select style="width: 100%;" class="form-control form-control-sm custom-select">
                                        <option value="">Select</option>
                                        <option value="0">Persentase</option>
                                        <option value="1">Waktu</option>
                                        <option value="2">Jumlah</option>
                                    </select>
                                        
                                    </div>
                                <div class="form-group">
                                    <label>Bobot</label>
                                    <input type="number" style="width:20%"class="form-control">
                                </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                                <a href="javascript:cmdSaveKpiType()" style="color:#FFF;" class="btn-simpan btn-simpan1">Save changes</a>
                            </div>
                        </form> 
                    </div>
                </div>
            </div>
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
        <script>
            $(function () {
                $('#only-number').on('keydown', '#number', function (e) {
                    -1 !== $
                            .inArray(e.keyCode, [46, 8, 9, 27, 13, 110, 190]) || /65|67|86|88/
                            .test(e.keyCode) && (!0 === e.ctrlKey || !0 === e.metaKey)
                            || 35 <= e.keyCode && 40 >= e.keyCode || (e.shiftKey || 48 > e.keyCode || 57 < e.keyCode)
                            && (96 > e.keyCode || 105 < e.keyCode) && e.preventDefault()
                });
            })
        </script>
        <script>
            function cmdSaveKpiSettingGroup() {
//                document.FRM_NAME_KPISETTINGGROUP.command.value = "<%=Command.SAVE%>";
                document.FRM_NAME_KPISETTINGGROUP.action = "kpi_setting_list_form.jsp";
                document.FRM_NAME_KPISETTINGGROUP.submit();
            }
        </script>

</html>

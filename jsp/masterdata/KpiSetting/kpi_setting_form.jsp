<%-- 
    Document   : kpi_setting
    Created on : Sep 1, 2022, 1:33:38 PM
    Author     : suryawan
--%>


<%@page import="com.dimata.harisma.form.masterdata.CtrlKpiSettingGroup"%>
<%@page import="com.dimata.harisma.form.masterdata.FrmKpiSettingGroup"%>
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


<%    
    long oidKpiSetting = FRMQueryString.requestLong(request, FrmKpiSetting.fieldNames[FrmKpiSetting.FRM_FIELD_KPI_SETTING_ID]);
    long oidKpiSettingType = FRMQueryString.requestLong(request, FrmKpiSettingType.fieldNames[FrmKpiSettingType.FRM_FIELD_KPI_SETTING_TYPE_ID]);
    long oidKpiSettingList = FRMQueryString.requestLong(request, FrmKpiSettingList.fieldNames[FrmKpiSettingList.FRM_FIELD_KPI_SETTING_LIST_ID]);
    long oidKpiSettingGroup = FRMQueryString.requestLong(request, FrmKpiSettingGroup.fieldNames[FrmKpiSettingGroup.FRM_FIELD_KPI_GROUP_ID]);

    Vector vKpiSettingGroup = new Vector();

    /*berfungsi untuk menyiman data sementara, yang di mana ini bisa dibilang adalah penerima oid tapi ini hardcore*/
    long kpiSettingId = FRMQueryString.requestLong(request, "kpi_setting_id");
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

    Vector listKpiSetting = new Vector();
    boolean selectDiv = true;
    boolean selectComp = true;
    boolean selectPosisi = true;

    Vector valTahun = new Vector();
    Vector keyTahun = new Vector();

    Calendar calNow = Calendar.getInstance();
    int startYear = calNow.get(Calendar.YEAR) - 5;
    int endYear = calNow.get(Calendar.YEAR) + 3;

    valTahun.add("Select..");
    keyTahun.add("0");
    for (int i = startYear; i <= endYear; i++) {
        valTahun.add("" + i);
        keyTahun.add("" + i);
    }


    /* ADD Data Kpi Setting */
//String sValidDate= FRMQueryString.requestString(request, FrmKpiSetting.fieldNames[FrmKpiSetting.FRM_FIELD_START_DATE]);
//sValidDate = sValidDate; 

    /*controller untuk simpan data kpi setting*/
    CtrlKpiSetting ctrlKpiSetting = new CtrlKpiSetting(request);
    if (typeform == 1) {
        long iErrCode = ctrlKpiSetting.action(iCommand, oidKpiSetting, request);
        if (iCommand == Command.SAVE) {
            iCommand = 0;
        }
    }
    KpiSetting kpiSetting = ctrlKpiSetting.getKpiSetting();


    /*controller untuk simpan data kpi setting type*/
    CtrlKpiSettingType ctrlKpiSettingType = new CtrlKpiSettingType(request);
    if (typeform == 2) {
        long iErrCode = ctrlKpiSetting.action(Command.EDIT, oidKpiSetting, request);
        long iErrCodeSettingType = ctrlKpiSettingType.action(iCommand, oidKpiSettingType, request);
        if (iCommand == Command.SAVE) {
            iCommand = 0;
        }

        kpiSetting = ctrlKpiSetting.getKpiSetting();
    }
    KpiSettingType kpiSettingType = ctrlKpiSettingType.getKpiSettingType();
    if (iCommand == Command.EDIT && kpiSettingType != null && kpiSettingType.exists()) {

    }
    
    CtrlKpiSettingGroup ctrlKpiSettingGroup = new CtrlKpiSettingGroup(request);
    if (typeform == 3) {
        long iErrCode = ctrlKpiSettingGroup.action(iCommand, oidKpiSettingGroup, request);
        if (iCommand == Command.SAVE) {
            iCommand = 0;
        }
    }
    KpiSettingGroup kpiSettingGroup = ctrlKpiSettingGroup.getKpiSettingGroup();

    /*end*/

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

    
    if (oidCompany != 0) {
        kpiSetting.setCompanyId(oidCompany);
    } else {
        oidCompany = kpiSetting.getCompanyId();
    }

    String strDisable = "";
    if (appUserSess.getAdminStatus() == 0) {
        oidCompany = emplx.getCompanyId();
        if (!privViewAllDivision) {
            positionId = emplx.getPositionId();
            strDisable = "disabled=\"disabled\"";
        }

    }

    try {
        if(oidKpiSetting != 0){// untuk mengambil data kpi group setting
            String kpiGroupQuery = "hr_kpi_setting.`KPI_SETTING_ID` = '" + oidKpiSetting + "'";
            vKpiSettingGroup = PstKPI_Group.listWithJoinSetting(kpiGroupQuery);
        }
    } catch (Exception e) {
        System.out.println("Error fetch :" + e);
    }

%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>FORM KPI SETTING</title>


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
            <span id="menu_title"><strong>Kinerja</strong> <strong style="color:#333;"> / </strong>Master Data / KPI Setting</span>
        </div>
        <div class="content-main">
            <form name="FRM_NAME_KPISETTING" method ="post" action="">
                <input type="hidden" name="command" value="<%=iCommand%>">
                <input type="hidden" name="typeform" value="1">
                <input type="hidden" name="<%=FrmKpiSetting.fieldNames[FrmKpiSetting.FRM_FIELD_KPI_SETTING_ID]%>" value="<%=kpiSetting.getOID()%>">
                <input type="hidden" name="<%=FrmKpiSettingType.fieldNames[FrmKpiSettingType.FRM_FIELD_KPI_SETTING_TYPE_ID]%>" value="<%=kpiSettingType.getKpiSettingId()%>">             
                <input type="hidden" name="kpiSettingId" value="<%=oidKpiSetting%>">
                <input type="hidden" name="delete_for">
                <input type="hidden" name="urlBack" value="kpi_setting_form.jsp">
                <div class="formstyle">
                    <table width="100%">   
                        <div>&nbsp;</div>
                        <tr>
                            <td valign="top" width="35%">
                                <div id="caption">Company</div>
                                <div id="divinput">
                                    <select name="<%=FrmKpiSetting.fieldNames[FrmKpiSetting.FRM_FIELD_COMPANY_ID]%>" id="company" class="custom-select form-select-sm col-6" data-placeholder='Select Company...' onchange="javascript:cmdUpdateDivision()" style="width: 20%;">
                                        <option value="0">-select-</option>
                                        <%
                                            Vector listCompany = PstCompany.list(0, 0, "", PstCompany.fieldNames[PstCompany.FLD_COMPANY]);
                                            if (listCompany != null && listCompany.size() > 0) {
                                                for (int i = 0; i < listCompany.size(); i++) {
                                                    Company comp = (Company) listCompany.get(i);
                                                    if (kpiSetting.getCompanyId() == comp.getOID()) {
                                        %>
                                        <option selected="selected" value="<%=comp.getOID()%>"><%=comp.getCompany()%></option>
                                        <%
                                        } else {
                                        %>
                                        <option value="<%=comp.getOID()%>"><%= comp.getCompany()%></option>
                                        <%
                                                    }
                                                }
                                            }
                                        %>
                                    </select>
                                </div>
                                <div id="caption">Jabatan</div>
                                <div id="divinput">
                                    <select name="<%=FrmKpiSetting.fieldNames[FrmKpiSetting.FRM_FIELD_POSITION_ID]%>" style="width: 20%;" data-placeholder='Select Jabatan...'  multiple="multiple" class="select2 custom-select form-select-sm col-6" valie="<%=oidKpiSetting%>">
                                        <%
                                            Vector listPosition = PstPosition.list(0, 0, "", "");
                                            for (int i = 0; i < listPosition.size(); i++) {
                                                Position objPosition = (Position) listPosition.get(i);
                                                String selected = "";
                                                if (oid_position != null) {
                                                    for (int j = 0; j < oid_position.length; j++) {
                                                        String oidPosition = "" + objPosition.getOID();
                                                        if (oidPosition.equals("" + oid_position[j])) {
                                                            selected = "selected";
                                                        }
                                                    }
                                                }
                                        %>
                                        <option <%=selected%> value="<%= objPosition.getOID()%>"><%= objPosition.getPosition()%></option>
                                        <%
                                            }
                                        %>
                                    </select>

                                </div>
                                <div id="caption">Status</div>
                                <div id="divinput" value="<%=kpiSetting.getOID()%>">
                                    <%
                                        Vector val_status = new Vector(1, 1);
                                        Vector key_status = new Vector(1, 1);

                                        val_status.add(String.valueOf(I_DocStatus.DOCUMENT_STATUS_DRAFT));
                                        key_status.add(I_DocStatus.fieldDocumentStatus[I_DocStatus.DOCUMENT_STATUS_DRAFT]);

                                        if (oidKpiSetting > 0) {
                                            val_status.add(String.valueOf(I_DocStatus.DOCUMENT_STATUS_TO_BE_APPROVED));
                                            key_status.add(I_DocStatus.fieldDocumentStatus[I_DocStatus.DOCUMENT_STATUS_TO_BE_APPROVED]);

                                            val_status.add(String.valueOf(I_DocStatus.DOCUMENT_STATUS_CANCELLED));
                                            key_status.add(I_DocStatus.fieldDocumentStatus[I_DocStatus.DOCUMENT_STATUS_CANCELLED]);
                                        }
                                    %>
                                    <%= ControlCombo.draw(FrmKpiSetting.fieldNames[FrmKpiSetting.FRM_FIELD_STATUS], "custom-select form-select-sm", null, "" + kpiSetting.getStatus(), val_status, key_status, "style='width : 20%' id='status'")%> 
                                </div>
                                <div id="caption">Dari Tanggal</div>

                                <div id="divinput">
                                    <input style="width: 20%;" type="date" id="startDate" class="mydate form-control col-3" name="<%=FrmKpiSetting.fieldNames[FrmKpiSetting.FRM_FIELD_START_DATE]%>" value="<%= (startDate.equals("") ? strDateNow : startDate)%>"/>
                                    <span id="info1"></span>

                                </div>

                                <div id="caption">Sampai Tanggal</div>

                                <div id="divinput">
                                    <input type="date" id="validDate" class="mydate form-control" name="<%=FrmKpiSetting.fieldNames[FrmKpiSetting.FRM_FIELD_VALID_DATE]%>" value="<%= validDate%>" style="width: 20%;" />
                                </div>

                                <div id="caption">Tahun</div>
                                <div id="divinput" >
                                    <%= ControlCombo.draw(FrmKpiSetting.fieldNames[FrmKpiSetting.FRM_FIELD_TAHUN], "custom-select form-select-sm", null, "" + kpiSetting.getTahun(), valTahun, keyTahun, "style='width : 20%'")%> 
                                </div>
                            </td>
                        </tr>
                    </table>

                    <div style="border-top: 1px solid #DDD;">&nbsp;</div>
                    <a href="javascript:cmdSave()" style="color:#FFF;" class="btn-simpan btn-simpan1">Simpan</a>
                    <a href="javascript:cmdBack()" style="color:#FFF;" class="btn-back btn-back1">Kembali</a>
                    <%
                        if (kpiSetting.getOID() > 0) {
                    %>
                        <a href="javascript:cmdAdd()" type="hidden" style="color:#FFF;" class="btn-add btn-add1" data-toggle="modal" data-target="#exampleModal" >Pilih Kpi Type <strong><i class="fa fa-plus"></i></strong></a>
                    <%}%>
                    <div>&nbsp;</div>
                </div>
                <div>&nbsp;</div>
            </form> 
        </table>

        <%
            if (kpiSetting.getOID() > 0) {
        %>
        <!--Tampilan form setelah input data kpi type-->
        <%           
            Vector vKpiSetting = PstKPI_Type.listWithJoinKpiSettingTypeAndKpiSetting(kpiSetting.getOID());
            for (int i = 0; i < vKpiSetting.size(); i++) {
                KPI_Type kpiType = (KPI_Type) vKpiSetting.get(i);
                if(kpiType.getOID() > 0){
        %>
                <div class="formstyle mb-3">
                    <div class="row mb-3">
                        <div class="col d-flex justify-content-between">
                            <span> <%= kpiType.getType_name() %> </span>
                            <div>
                                <a href="javascript:init('<%=kpiSetting.getOID()%>', '<%=kpiType.getOID()%>')" type="hidden" style="color:#FFF;" class="btn-add btn-add1 mx-2" >Tambah Detail
                                    <strong><i class="fa fa-plus"></i></strong>
                                </a>
                                <a href="#" type="hidden" style="color:#FFF;" class="btn-delete btn-delete1">
                                    <strong><i class="fa fa-trash"></i></strong>
                                </a>
                            </div>
                        </div>
                    </div>
                    <form name="FRM_NAME_KPISETTINGLIST" method ="post" action="">
                        <input type="hidden" name="command" value="<%=iCommand%>">
                        <input type="hidden" name="typeform" value="3">
                        <input type="hidden" name="<%=FrmKpiSettingList.fieldNames[FrmKpiSettingList.FRM_FIELD_KPI_SETTING_LIST_ID]%>" value="<%=kpiSettingList.getOID()%>">
                        <input type="hidden" name="<%=FrmKpiSettingGroup.fieldNames[FrmKpiSettingGroup.FRM_FIELD_KPI_GROUP_ID]%>" value="<%=kpiSettingGroup.getKpiGroupId() %>">

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
                                <%
                                    if(vKpiSettingGroup.size() > 0){ 
                                        for(int j = 0; j < vKpiSettingGroup.size(); j++){
                                            KPI_Group objKpiGroup = (KPI_Group) vKpiSettingGroup.get(j);
                                %>
                                            <tr>
                                                <td class="p-3" value="<%= objKpiGroup.getOID() %>"> <%= objKpiGroup.getGroup_title() %> </td>
                                                <td> - </td>
                                                <td> - </td>
                                                <td> - </td>
                                                <td class="text-center">
                                                    <!--button ini ditampilkan ketika user klik tombol simpan di bawah tabel kpi type-->
                                                        <a href="javascript:cmdEdit('<%=kpiSetting.getOID()%>')" style="color: #FFF;" class="btn-edit btn-edit1">Edit</a>
                                                </td>
                                                <td> - </td>
                                                <td class="text-center">
                                                    <!--button ini ditampilkan ketika user klik tombol simpan di bawah tabel kpi type-->
                                                    <a href="javascript:cmdEdit('<%=kpiSetting.getOID()%>')" style="color: #FFF;" class="btn-edit btn-edit1">Edit</a> ||
                                                    <a href="javascript:cmdDeleteKpiGroup('<%=objKpiGroup.getOID() %>')" style="color: #FFF;" class="btn-delete btn-delete1">Delete</a>
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
                </div>
        <%
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
    <!-- Modal adalah javascript untuk memunculkan pop up saat klik button tambah kpi -->
    <div class="modal fade" id="exampleModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="exampleModalLabel">Pilih Kpi Type</h5>
                </div>
                <div class="modal-body">
                    <form name="FRM_NAME_KPISETTINGTYPE" method ="post" action="">
                        <input type="hidden" name="command" value="<%=iCommand%>">
                        <input type="hidden" name="typeform" value="2">
                        <input type="hidden" name="<%=FrmKpiSettingType.fieldNames[FrmKpiSettingType.FRM_FIELD_KPI_SETTING_TYPE_ID]%>" value="<%=kpiSettingType.getOID()%>">
                        <input type="hidden" name="oidKpiSettingType" value="<%=oidKpiSettingType%>">
                        <input type="hidden" name="<%=FrmKpiSettingType.fieldNames[FrmKpiSettingType.FRM_FIELD_KPI_SETTING_ID]%>" value="<%=kpiSetting.getOID()%>">
                        <div class="form-group">
                            <label for="exampleInputPassword1">Kpi Type</label>
                            <select name="<%=FrmKpiSettingType.fieldNames[FrmKpiSettingType.FRM_FIELD_KPI_TYPE_ID]%>" id="kpiTypeId" class="select2" style="width: 100%;">
                                <option value="">=Select=</option>
                                <%
                                    Vector listKpiType = PstKPI_Type.list(0, 0, "", "");
                                    for (int i = 0; i < listKpiType.size(); i++) {
                                        KPI_Type objKpiType = (KPI_Type) listKpiType.get(i);
                                        String selected = "";
                                        if (oid_kpi_type != null) {
                                            for (int j = 0; j < oid_kpi_type.length; j++) {
                                                String oidKpiType = "" + objKpiType.getOID();
                                                if (oidKpiType.equals("" + oid_kpi_type[j])) {
                                                    selected = "selected";
                                                }
                                            }
                                        }

                                %>
                                    <option value="<%=objKpiType.getOID()%>" <%=selected%>><%=objKpiType.getType_name()%></option>
                                <%
                                    }
                                %>
                            </select>
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
    <!--End-->	
</body>        
<%}%>

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
            document.FRM_NAME_KPISETTING.command.value = "<%=String.valueOf(Command.GOTO)%>";
            document.FRM_NAME_KPISETTING.action = "kpi_setting_form.jsp";
            document.FRM_NAME_KPISETTING.submit();
        }

        function cmdCancel() {
            document.FRM_NAME_KPISETTING.command.value = "<%=Command.EDIT%>";
            document.FRM_NAME_KPISETTING.action = "kpi_setting_form.jsp";
            document.FRM_NAME_KPISETTING.oidKpiSetting.value = 0;
            document.FRM_NAME_KPISETTING.submit();
        }

        function cmdBack() {
            document.FRM_NAME_KPISETTING.command.value = "<%=Command.LIST%>";
            document.FRM_NAME_KPISETTING.action = "kpi_setting_list.jsp";
            document.FRM_NAME_KPISETTING.submit();
        }

        function cmdEditDetail(oid) {
            document.FRM_NAME_KPISETTING.command.value = "<%=Command.EDIT%>";
            document.FRM_NAME_KPISETTING.oidKpiSetting.value = oid;
            document.FRM_NAME_KPISETTING.action = "kpi_setting_form.jsp";
            document.FRM_NAME_KPISETTING.submit();
        }

        function cmdAdd() {
            document.FRM_NAME_KPISETTING.command.value = "<%= Command.ADD%>";
            document.FRM_NAME_KPISETTING.action = "kpi_setting_form.jsp";
            document.FRM_NAME_KPISETTING.submit();
        }
        function cmdAddKpiSettingListForm(oid) {
            document.FRM_NAME_KPISETTING.<%=FrmKpiSetting.fieldNames[FrmKpiSetting.FRM_FIELD_KPI_SETTING_ID]%>.value = oid;
            document.FRM_NAME_KPISETTING.command.value = "<%= Command.EDIT%>";
            document.FRM_NAME_KPISETTING.action = "kpi_setting_list_form.jsp";
            document.FRM_NAME_KPISETTING.submit();
        }
        function cmdSave() {
            document.FRM_NAME_KPISETTING.command.value = "<%=Command.SAVE%>";
            document.FRM_NAME_KPISETTING.action = "kpi_setting_form.jsp";
            document.FRM_NAME_KPISETTING.submit();
        }
        function cmdSaveKpiType() {
            document.FRM_NAME_KPISETTINGTYPE.command.value = "<%=Command.SAVE%>";
            document.FRM_NAME_KPISETTINGTYPE.action = "kpi_setting_form.jsp";
            document.FRM_NAME_KPISETTINGTYPE.submit();
        }
        function cmdSaveKpiSettingList() {
            document.FRM_NAME_KPISETTING.command.value = "<%=Command.SAVE%>";
            document.FRM_NAME_KPISETTING.action = "kpi_setting_form.jsp";
            document.FRM_NAME_KPISETTING.submit();
        }
        function cmdEdit(oid) {
            document.FRM_NAME_KPISETTING.<%=FrmKpiSetting.fieldNames[FrmKpiSetting.FRM_FIELD_KPI_SETTING_ID]%>.value = oid;
            document.FRM_NAME_KPISETTING.command.value = "<%= Command.EDIT%>";
            document.FRM_NAME_KPISETTING.action = "kpi_setting_target.jsp";
            document.FRM_NAME_KPISETTING.submit();
        }
        
        function cmdDeleteKpiGroup(oid) {
                document.FRM_NAME_KPISETTINGLIST.<%=FrmKpiSettingGroup.fieldNames[FrmKpiSettingGroup.FRM_FIELD_KPI_GROUP_ID]%>.value = oid;
                document.FRM_NAME_KPISETTINGLIST.command.value = "<%=Command.DELETE %>";
                document.FRM_NAME_KPISETTINGLIST.action = "kpi_setting_form.jsp";
                document.FRM_NAME_KPISETTINGLIST.submit();
            }
        
        var popup; 

        function init(oidKpiSetting, oidKpiType) {
            document.FRM_NAME_KPISETTING.<%=FrmKpiSetting.fieldNames[FrmKpiSetting.FRM_FIELD_KPI_SETTING_ID]%>.value = oidKpiSetting;
            onload = "init()";
            //emp_department = document.frm_pay_emp_level.department.value;
            popup = window.open(
                "kpi_setting_list_form.jsp?FRM_FIELD_KPI_SETTING_ID=" + oidKpiSetting + "&FRM_FIELD_KPI_SETTING_TYPE_ID=" + oidKpiType, "SelectEmployee", "height=600,width=1200,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes"
            );
            popup.focus();
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
</html>


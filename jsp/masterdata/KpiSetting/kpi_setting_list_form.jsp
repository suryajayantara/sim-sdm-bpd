<%-- 
    Document   : kpi_setting
    Created on : Sep 1, 2022, 1:33:38 PM
    Author     : suryawan
--%>


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
<%    
    long oidKpiSetting = FRMQueryString.requestLong(request, FrmKpiSetting.fieldNames[FrmKpiSetting.FRM_FIELD_KPI_SETTING_ID]);
    long oidKpiSettingType = FRMQueryString.requestLong(request, FrmKpiSettingType.fieldNames[FrmKpiSettingType.FRM_FIELD_KPI_SETTING_TYPE_ID]);
    long oidKpiSettingList = FRMQueryString.requestLong(request, FrmKpiSettingList.fieldNames[FrmKpiSettingList.FRM_FIELD_KPI_SETTING_LIST_ID]);
    long oidKpiGroupBuatNambahGroup = FRMQueryString.requestLong(request, FrmKPI_Group.fieldNames[FrmKPI_Group.FRM_FIELD_KPI_GROUP_ID]);


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
    
    /*controller untuk simpan data kpi group*/
    CtrlKPI_Group ctrlKPI_Group = new CtrlKPI_Group(request);
    KPI_Group kpiGroup = ctrlKPI_Group.getdKPI_Group();
    if (typeform == 3) {
        long iErrCodeKpiGroup = ctrlKPI_Group.action(iCommand, oidKpiGroupBuatNambahGroup);
        if (iCommand == Command.SAVE) {
            iCommand = 0;
        }
        kpiSetting = ctrlKpiSetting.getKpiSetting();
    }
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
    
    // untuk mengambil data KPI Setting Type
    Vector kpiType = new Vector();
    try {
        if (oidKpiSettingType != 0) {
            String query = "KPI_TYPE_ID = '" + oidKpiSettingType + "'";
            kpiType = PstKPI_Type.list(0, 1, query, "");
        }
    } catch (Exception e) {
        System.out.println("Error fetch sale :" + e);
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
            function cmdSaveKpiGroup() {
                document.FRM_NAME_KPISETTINGLISTFORM.command.value = "<%=Command.SAVE%>";
                document.FRM_NAME_KPISETTINGLISTFORM.action = "kpi_setting_list_form.jsp";
                document.FRM_NAME_KPISETTINGLISTFORM.submit();
            }
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
                        for(int i = 0; i < kpiType.size(); i++){
                            KPI_Type objKpiType = (KPI_Type) kpiType.get(i);
                    %>
                            <span><%= objKpiType.getType_name() %> - <%=PstCompany.getCompanyName(kpiSetting.getCompanyId())%></span>
                    <% } %>
                    <div style="border-bottom: 1px solid #DDD;">&nbsp;</div>
                    <div style="font-size: 15px">Jabatan:
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
                    <a href="javascript:cmdAdd()" type="hidden" style="color:#FFF;" class="btn-simpan btn-simpan1" data-toggle="modal" data-target="#exampleModal2"  >Tambah Group Baru  <strong><i class="fa fa-plus"></i></strong></a>
                    &nbsp;<a href="javascript:cmdAdd()" type="hidden" style="color:#FFF;" class="btn-add btn-add1" data-toggle="modal" data-target="#exampleModal2"  >Master Data Kpi Group <strong><i class="fa fa-plus"></i></strong></a>
                    &nbsp;<a href="javascript:cmdAdd()" type="hidden" style="color:#FFF;" class="btn-add btn-add1"  data-toggle="modal" data-target="#exampleModal3" >Naster Data Kpi <strong><i class="fa fa-plus"></i></strong></a>
                    &nbsp;<a href="javascript:init()"  style="color:#FFF;" class="btn-add btn-add1" >Master Data Distribusi <strong><i class="fa fa-plus"></i></strong></a>
            <!--Tampilan form setelah input data kpi type-->
        </div>  
         </form>
    </div>
    <div class="box mb-5">
        <div class="formstyle">
            <form name="FRM_NAME_KPISETTINGLISTFORM" method ="post" action="">
                <input type="hidden" name="command" value="<%=iCommand%>">
                <input type="hidden" name="<%=FrmKpiSettingList.fieldNames[FrmKpiSettingList.FRM_FIELD_KPI_SETTING_LIST_ID]%>" value="<%=kpiSettingList.getOID()%>">
                <div>&nbsp;</div>
                <table class="tblStyle" style="width: 100%;">
                    <tr>
                        <!-- <td class="title_tbl" style="width: 20%;">Kpi Group</td> -->
                        <td class="title_tbl" style="width: 20%;">Key Performance Indicator</td>
                        <td class="title_tbl">Distribution Option</td>
                        <td class="title_tbl">Satuan Ukur</td>
                        <td class="title_tbl">Target</td>
                        <td class="title_tbl">Bobot</td>
                        <td class="title_tbl">Action</td>
                    </tr>
                    <tr>
                        <!-- <td>   
                            <select  style="width: 100%;" class="form-style">
                                <option>Select</option>
                                <%
                                    Vector listKpiGroup = PstKPI_Group.list(0, 0, "", "");
                                    for (int i = 0; i < listKpiGroup.size(); i++) {
                                        KPI_Group objKpiGroup = (KPI_Group) listKpiGroup.get(i);
                                        String selected = "";
                                        if (oid_kpi_group != null) {
                                            for (int j = 0; j < oid_kpi_group.length; j++) {
                                                String oidKpiGroup = "" + objKpiGroup.getOID();
                                                if (oidKpiGroup.equals("" + oid_kpi_group[j])) {
                                                    selected = "selected";
                                                }
                                            }
                                        }
    
                                %>
    
                                <option value="<%=objKpiGroup.getOID()%>" <%=selected%>><%=objKpiGroup.getGroup_title()%></option>
                                <%
                                    }
                                %>
                            </select>
                        </td> -->
                        <td>
                            <select style="width: 100%;" class="form-control form-control-sm custom-select">
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
                                        }
    
                                %>
    
                                <option value="<%=objKpi.getOID()%>" <%=selected%>><%=objKpi.getKpi_title()%></option>
                                <%
                                    }
                                %>
                            </select>
                        </td>
                        <td>
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
                        </td>
                        <td>
                            <select style="width: 100%;" class="form-control form-control-sm custom-select">
                                <option value="">Select</option>
                                <option value="0">Persentase</option>
                                <option value="1">Waktu</option>
                                <option value="2">Jumlah</option>
                            </select>
                        </td>
                        <td>
                            <!--button ini ditampilkan ketika user klik tombol simpan di bawah tabel kpi type-->
                    <center><a href="javascript:cmdEdit('<%=kpiSetting.getOID()%>')" style="color: #FFF;" class="btn-edit btn-edit1">Edit</a></center>
                    </td>
                    <td>
                        <!-- <div container mt-3> -->
                            <!-- <div class="form-group" id="only-number"> -->
                                <input type="text" class="form-control form-control-sm" id="number" placeholder="Input only number" style="width: 100%;">
                            <!-- </div> -->
                        <!-- </div> -->
                    </td>
                    <td>
                        <!--button ini ditampilkan ketika user klik tombol simpan di bawah tabel kpi type-->
                        <div class="responsive-container">
                            <a href="javascript:cmdEdit('<%=kpiSetting.getOID()%>')" style="color: #FFF;" class="btn-edit btn-edit1 mx-2">Edit</a>
                            <a href="javascript:cmdDelete('<%=kpiSetting.getOID()%>')" style="color: #FFF;" class="btn-delete btn-delete1">Delete</a>
                        </div>
                    </td>
                    </tr>
    
                </table>
                <div>&nbsp;</div>
                <a href="javascript:cmdSaveKpiSettingList()" style="color:#FFF;" class="btn-simpan btn-simpan1">Simpan</a>
                &nbsp;<a href="javascript:cmdBack()" style="color:#FFF;" class="btn-back btn-back1" >Kembali</a>
        </div>
    </div> 
</form>       
<!--Pop up untuk form tambah kpi group-->
<div class="modal fade" id="exampleModal2" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <center><strong>Tambah Kpi Group</strong></center>
            <div class="modal-body">
                <form name="FRM_NAME_KPI_GROUP" method ="post" action="">
                    <input type="hidden" name="command" value="<%= Command.SAVE %>">
                    <input type="hidden" name="typeform" value="3">
                    <input type="hidden" name="<%=FrmKpiSetting.fieldNames[FrmKpiSetting.FRM_FIELD_KPI_SETTING_ID]%>" value="<%=kpiSetting.getOID()%>">
                    <input type="hidden" name="<%=FrmKPI_Group.fieldNames[FrmKPI_Group.FRM_FIELD_KPI_GROUP_ID]%>" value="<%=kpiGroup.getOID()%>">
                    <div class="form-group">
                        <div>KPI Type</div>
                        <select name="<%= FrmKPI_Group.fieldNames[FrmKPI_Group.FRM_FIELD_KPI_TYPE_ID] %>" class="select2" style="width: 80%;">
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
                        <div>&nbsp;</div>
                        <div>KPI Tittle</div>
                        <input type="text" value="<%=grouptitle%>" name="<%=FrmKPI_Group.fieldNames[FrmKPI_Group.FRM_FIELD_GROUP_TITLE]%>" id="<%=FrmKPI_Group.fieldNames[FrmKPI_Group.FRM_FIELD_GROUP_TITLE]%>" style="width: 80%;">
                        </input>
                        <div>&nbsp;</div>
                        <div>Description</div>
                        <textarea style="width: 80%;" value="<%=description%>" name="<%=FrmKPI_Group.fieldNames[FrmKPI_Group.FRM_FIELD_DESCRIPTION]%>" id="<%=FrmKPI_Group.fieldNames[FrmKPI_Group.FRM_FIELD_DESCRIPTION]%>"></textarea>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                        <button onclick="cmdSaveKpiGroup()" style="color:#FFF;" class="btn-simpan btn-simpan1">Save changes</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>            

                    
<div class="modal fade" id="exampleModal3" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <center><strong>Tambah KPI</strong></center>
            <div class="modal-body">
                <form name="FRM_NAME_KPISETTINGLISTFORM" method ="post" action="">
                    <input type="hidden" name="command" value="<%=iCommand%>">
                    <input type="hidden" name="<%=FrmKpiSetting.fieldNames[FrmKpiSetting.FRM_FIELD_KPI_SETTING_ID]%>" value="<%=kpiSetting.getOID()%>">
                    <div class="form-group">
                        <div>KPI Group</div>
                        <select name="kpi_type" id="" multiple="multiple" class="select2" style="width: 80%;">
                            <option value="">=Select=</option>
                            <option value="">Kpi Group</option>
                            <option value="">Kpi Group1</option>
                        </select>
                        <div>KPI Tittle</div>
                        <input type="text" style="width: 80%;">
                        </input>
                        <div>Description</div>
                        <textarea style="width: 80%;">
                        </textarea>
                        <div>Valid From</div>
                        <input type="date"></input>
                        <div>Valid To</div>
                        <input type="date"></input>
                        <div>Input Type</div>
                        <select style="width: 30%;">
                            <option value="">Select</option>
                            <option value="">Persentase</option>
                        </select>
                        <div>Input Range Start</div>
                        <input type="number"></input>
                        <div>Input Range End</div>
                        <input type="number"></input>
                        <div>Korelasi</div>
                        <select style="width: 30%;">
                            <option value="">Select</option>
                            <option value="">Positif</option>
                            <option value="">Positif</option>
                            <option value="">Positif</option>
                            <option value="">Positif</option>
                        </select>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                        <a href="" style="color:#FFF;" class="btn-simpan btn-simpan1">Save changes</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<!--End-->
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

<%-- 
    Document   : kpi_setting
    Created on : Sep 1, 2022, 1:33:38 PM
    Author     : suryawan
--%>


<%@page import="com.dimata.harisma.entity.masterdata.PstKPI_List"%>
<%@page import="com.dimata.harisma.form.masterdata.FrmKpiDistribution"%>
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
<%    
    long oidKpiSetting = FRMQueryString.requestLong(request, FrmKpiSetting.fieldNames[FrmKpiSetting.FRM_FIELD_KPI_SETTING_ID]);
    long oidKpiSettingType = FRMQueryString.requestLong(request, FrmKpiSettingType.fieldNames[FrmKpiSettingType.FRM_FIELD_KPI_SETTING_TYPE_ID]);
    long oidKpiSettingList = FRMQueryString.requestLong(request, FrmKpiSettingList.fieldNames[FrmKpiSettingList.FRM_FIELD_KPI_LIST_ID]);
    long oidKpiSettingGroup = FRMQueryString.requestLong(request, FrmKpiSettingGroup.fieldNames[FrmKpiSettingGroup.FRM_FIELD_KPI_GROUP_ID]);
    long oidKpiTypeId = FRMQueryString.requestLong(request, FrmKpiSettingType.fieldNames[FrmKpiSettingType.FRM_FIELD_KPI_TYPE_ID]);
    long kpiSettingGroupId = FRMQueryString.requestLong(request, FrmKpiSettingGroup.fieldNames[FrmKpiSettingGroup.FRM_FIELD_KPI_SETTING_GROUP_ID]);
    
    Vector vKpiType = new Vector();
    Vector vKpiSetting = new Vector();
    Vector vCompany = new Vector();
    Vector vListPosisi = new Vector();
    Vector vKpiGroup = new Vector();
    Vector vKpiSettingGroup = new Vector();
    Vector vKpiList = new Vector();
    int year = 0;
    long companyOID = 0;
    String kpiTypeName = "";
    long kpiTypeOid = 0;
    long kpiSettingGroupOid = 0;
    String companyName = "";
    String positionName = "";
    Date startD = null, validD = null;

    /*berfungsi untuk menyiman data sementara, yang di mana ini bisa dibilang adalah penerima oid tapi ini hardcore*/
    long kpiSettingId = (FRMQueryString.requestLong(request, "kpi_setting_id") == 0) ? oidKpiSetting : FRMQueryString.requestLong(request, "kpi_setting_id");
    int iCommand = FRMQueryString.requestCommand(request);
    int tahun = Calendar.getInstance().get(Calendar.YEAR);
    long oidCompany = FRMQueryString.requestLong(request, "company");
    int iCommandInUrl = iCommand;
    long iErrCodeSetttingList = 0;

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
    if (typeform == 1) {
        long iErrCodeSetttingGroup = ctrlKpiSettingGroup.action(iCommand, oidKpiSettingGroup, request);
        if (iCommand == Command.SAVE) {                                                                                      
            iCommand = 0;       
        }
    }
    KpiSettingGroup kpiSettingGroup = ctrlKpiSettingGroup.getKpiSettingGroup();

    CtrlKpiSettingType ctrlKpiSettingType = new CtrlKpiSettingType(request);
    if (typeform == 4){
        long iErrCodeSettingType = ctrlKpiSettingType.action(iCommand, oidKpiSettingType, request);
    }
    KpiSettingType kpiSettingType = ctrlKpiSettingType.getKpiSettingType();
    
    /*controller untuk simpan data kpi setting*/
    CtrlKpiSetting ctrlKpiSetting = new CtrlKpiSetting(request);
    if (typeform == 3) {
        long iErrCode = ctrlKpiSetting.action(iCommand, oidKpiSetting, request);
        if (iCommand == Command.SAVE) {
            iCommand = 0;
        }
    }
    KpiSetting kpiSetting = ctrlKpiSetting.getKpiSetting();

    /*controller untuk save data kpi setting list*/
    CtrlKpiSettingList ctrlKpiSettingList = new CtrlKpiSettingList(request);
    if (typeform == 2) {
        iErrCodeSetttingList = ctrlKpiSettingList.action(iCommand, oidKpiSettingList, request);
        if (iCommand == Command.SAVE) {
            iCommand = 0;
        }
    }
    KpiSettingList kpiSettingList = ctrlKpiSettingList.getKpiSettingList();
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

    /*controlle untuk mengolah data kpi Setting Group*/
    try {
        if (oidKpiTypeId != 0) {
            String query = "KPI_TYPE_ID = '" + oidKpiTypeId + "'";
            vKpiType = PstKPI_Type.list(0, 1, query, "");
            for (int i = 0; i < vKpiType.size(); i++) {
                KPI_Type objKpiType = (KPI_Type) vKpiType.get(i);
                kpiTypeName = objKpiType.getType_name();
                kpiTypeOid = objKpiType.getOID();
                
            }
        }
        
        if (kpiSettingGroupId != 0) {
            String query = "KPI_SETTING_GROUP_ID = '" + kpiSettingGroupId + "'";
            vKpiSettingGroup = PstKpiSettingGroup.list(0, 1, query, "");
            for (int i = 0; i < vKpiSettingGroup.size(); i++) {
                KpiSettingGroup objKpiSettingGroup = (KpiSettingGroup) vKpiSettingGroup.get(i);
                kpiSettingGroupOid = objKpiSettingGroup.getOID();
                
            }
        }

        if (oidKpiSettingType != 0) {
            String query = "KPI_SETTING_TYPE_ID = '" + oidKpiSettingType + "'";
            vKpiSettingGroup = PstKpiSettingGroup.list(0, 0, query, "");
        }
        
        if (oidKpiTypeId != 0) {
            String query = "KPI_LIST_ID = '" + oidKpiTypeId + "'";
            vKpiList = PstKpiSettingList.list(0, 0, query, "");
        }
        
        if (oidKpiSetting != 0) {
            // untuk mengambil data jabatan
            String queryKpiSetting = "hr_kpi_setting.`KPI_SETTING_ID` = '" + oidKpiSetting + "'";
            vKpiSetting = PstKpiSetting.list(0, 1, queryKpiSetting, "");
            for (int i = 0; i < vKpiSetting.size(); i++) {
                KpiSetting objKpiSetting = (KpiSetting) vKpiSetting.get(i);
                companyOID = objKpiSetting.getCompanyId();
                startD = objKpiSetting.getStartDate();
                validD = objKpiSetting.getValidDate();
                year = objKpiSetting.getTahun();
            }

            // untuk mengambil data jabatan
            vListPosisi = PstPosition.listWithJoinKpiSettingPosition(oidKpiSetting);

            // untuk mengambil data kpi group setting
            String kpiGroupQuery = "hr_kpi_setting_type.`KPI_SETTING_ID`='"+oidKpiSetting+"' AND hr_kpi_setting_type.`KPI_TYPE_ID`='"+kpiTypeOid+"'";
            vKpiGroup = PstKPI_Group.listWithJoinKpiSettingAndKpiType(kpiGroupQuery);
        }
        
            Vector vKpiSettingNew = PstKPI_Type.listWithJoinKpiSettingTypeAndKpiSetting(kpiSetting.getOID());
            long lastKpiTypeOID = 0;
            for (int i = 0; i < vKpiSettingNew.size(); i++) {
                KPI_Type kpiType = (KPI_Type) vKpiSettingNew.get(i);
                if (kpiType.getOID() > 0) {
                    if (kpiType.getOID() != lastKpiTypeOID) {
                    }
                }
            }

        if (companyOID != 0) { // untuk mengambil data company
            String query = "GEN_ID = '" + companyOID + "'";
            vCompany = PstCompany.list(0, 1, query, "");
            for (int i = 0; i < vCompany.size(); i++) {
                Company objCompany = (Company) vCompany.get(i);
                companyName = objCompany.getCompany();
            }
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
        
        <!--alert-->
        <link rel="stylesheet" href="<%=approot%>/styles/sweetalert2.min.css">
        <script src="<%=approot%>/javascripts/sweetalert2.all.min.js"></script>
        <!--end-->
        
    </head>
    <body onload="refreshAndClose()">
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
            <form name="FRM_NAME_KPISETTING" method ="post" action="">
                <input type="hidden" name="command" value="<%=iCommand%>">
                <input type="hidden" name="urlBack" value="kpi_setting_list_detail.jsp">
                <input type="hidden" name="<%=FrmKpiSetting.fieldNames[FrmKpiSetting.FRM_FIELD_KPI_SETTING_ID]%>" value="<%=kpiSetting.getOID()%>">
                <div class="content-main">
                    <div>&nbsp;</div>
                    <!--data ini akan muncul ketika user klik detail pada kpi setting list-->
                    <span><%=kpiTypeName%> - <%= companyName%></span>
                    <div style="border-bottom: 1px solid #DDD;">&nbsp;</div>
                    <div class="row">
                        <div class="col-2">
                            <div style="font-size: 15px">Jabatan</div>
                            <%
                                for (int i = 0; i < vListPosisi.size() - 1; i++) {
                            %>
                            <div style="font-size: 15px;" class="text-white">S </div>

                            <% } %>
                            <div style="font-size: 15px">Status</div>
                            <div style="font-size: 15px">Tanggal Mulai</div>
                            <div style="font-size: 15px">Tanggal Selesai</div>
                            <div style="font-size: 15px">Tahun</div>
                        </div>
                        <div class="col-10">
                            <div style="font-size: 15px">:
                                <%
                                    for (int i = 0; i < vListPosisi.size(); i++) {
                                        Position objPosition = (Position) vListPosisi.get(i);
                                %>
                                <%= objPosition.getPosition()%>
                                <% if (i != vListPosisi.size() - 1) { %>
                                <br> &nbsp;
                                <% } %>
                                <% }%>
                            </div>
                            <div style="font-size: 15px">: <%= I_DocStatus.fieldDocumentStatus[kpiSetting.getStatus()]%></div>
                            <div style="font-size: 15px">: <%= startD%></div>
                            <div style="font-size: 15px">: <%= validD%></div>
                            <div style="font-size: 15px">: <%= year%></div>
                        </div>
                    </div>
                    <div style="border-top: 1px solid #DDD;">&nbsp;</div>
                    <a href="javascript:cmdEdit()" style="color:#FFF;" class="btn-edit btn-edit1" >Edit Kpi Setting</a>
                    &nbsp;<a href="javascript:cmdAdd()" type="hidden" style="color:#FFF;" class="btn-simpan btn-simpan1" data-toggle="modal" data-target="#exampleModal"  >Tambah Group Baru  <strong><i class="fa fa-plus"></i></strong></a>
                    &nbsp;<a href="javascript:masterKpiGroup()" type="hidden" style="color:#FFF;" class="btn-add btn-add1" >Master Data Kpi Group <strong><i class="fa fa-plus"></i></strong></a>
                    &nbsp;<a href="javascript:masterKpi()" style="color:#FFF;" class="btn-add btn-add1">Master Data Kpi <strong><i class="fa fa-plus"></i></strong></a>
                    &nbsp;<a href="javascript:init()"  style="color:#FFF;" class="btn-add btn-add1" >Master Data Distribusi <strong><i class="fa fa-plus"></i></strong></a>
                    <!--Tampilan form setelah input data kpi type-->
                </div>  
            </form>
        </div>
        <div>
        <form name="FRM_NAME_KPISETTINGLISTFORM" method ="post" action="">
            <input type="hidden" name="command" value="<%=iCommand%>">
            <input type="hidden" name="<%=FrmKpiSettingList.fieldNames[FrmKpiSettingList.FRM_FIELD_KPI_SETTING_LIST_ID]%>" value="<%=oidKpiTypeId %>">
            <input type="hidden" name="<%=FrmKpiSetting.fieldNames[FrmKpiSetting.FRM_FIELD_KPI_SETTING_ID]%>" value="<%=oidKpiSetting%>">
            <input type="hidden" name="<%=FrmKpiSettingGroup.fieldNames[FrmKpiSettingGroup.FRM_FIELD_KPI_GROUP_ID]%>" value="<%=oidKpiSettingGroup %>">
            <input type="hidden" name="<%=FrmKpiSettingGroup.fieldNames[FrmKpiSettingGroup.FRM_FIELD_KPI_SETTING_GROUP_ID]%>" value="<%=kpiSettingGroupOid %>">
            <input type="hidden" name="<%=FrmKpiSettingType.fieldNames[FrmKpiSettingType.FRM_FIELD_KPI_TYPE_ID] %>" value="<%= kpiTypeOid %>">
            <input type="hidden" name="typeform" value="1">
              
            <%
            for (int i = 0; i < vKpiSettingGroup.size(); i++) {
                KpiSettingGroup objKpiSettingGroup = (KpiSettingGroup)vKpiSettingGroup.get(i) ;
                KPI_Group objKpiGroup = PstKPI_Group.fetchExc(objKpiSettingGroup.getKpiGroupId());
                
            
        %>
            <div class="box mb-2">
                <div  class="formstyle">
                    <div class="d-flex justify-content-between">
                        <span value="<%= objKpiGroup.getOID() %>"> <%= objKpiGroup.getGroup_title()%> </span>
                        <div>
                            <a href="javascript:openModal('<%= objKpiGroup.getOID() %>', '<%= objKpiGroup.getGroup_title() %>','<%=objKpiSettingGroup.getOID() %>')" type="hidden" style="color:#FFF;" class="btn-add btn-add1 mx-2">Tambah KPI
                                <strong><i class="fa fa-plus"></i></strong>
                            </a>
                            <a href="javascript:cmdDeleteConfirmationKpiGroup('<%=objKpiGroup.getOID() %>', '<%= oidKpiSetting %>','<%=objKpiSettingGroup.getOID() %>')" type="hidden" style="color:#FFF;" class="btn-delete btn-delete1">
                                <strong><i class="fa fa-trash"></i></strong>
                            </a>
                        </div>
                    </div>

                    <div>&nbsp;</div>
                    <table class="tblStyle" style="width: 100%;">
                        <thead class="text-center">
                                <tr>
                                    <th class="title_tbl" style="width: 20%;"> Kpi Performance </th>
                                    <th class="title_tbl">Distribution Option</th>
                                    <th class="title_tbl">Satuan Ukur</th>
                                    <th class="title_tbl">Bobot Penilaian</th>
                                    <th class="title_tbl">Action</th>
                                    
                                </tr>
                        </thead>
                        <tbody>
                            <%
                                String queryKpiList = "hr_kpi_setting_group.`KPI_GROUP_ID`='"+ objKpiGroup.getOID() +"' AND hr_kpi_setting_list.`KPI_SETTING_ID` = '"+ oidKpiSetting +"'";
                                vKpiList = PstKPI_List.listWithJoinSettingAndGroup(queryKpiList);
                                if(vKpiList.size() > 0){
                                    for(int j = 0; j < vKpiList.size(); j++){
                                        KPI_List objKpiList = (KPI_List) vKpiList. get(j);
                                        KPI_List entKpiList = PstKPI_List.fetchExc(objKpiList.getOID());
                            %>
                            <tr>
                                <td value="<%=objKpiList.getOID() %>">
                                    <%= objKpiList.getKpi_title()%> 
                                    <%-- <i class="fa fa-question-circle-o fa-lg" aria-hidden="true" data-toggle="popover" data-trigger="click" data-content="<%= objKpiList.getDescription() %>"></i> --%>
                                </td>
                                <td>
                                    <%= objKpiList.getKpiDistributionName()%> 
                                </td>
                                <td>
                                    <!--button ini ditampilkan ketika user klik tombol simpan di bawah tabel kpi type-->
                                    <center>
                                        <%= PstKPI_List.strType[entKpiList.getInputType()] %>
                                    </center>
                                </td>
                                <td>
                                <center><input type="number"></center>
                                </td>
                                <td>
                                    <div class="responsive-container">
                                        <a href="javascript:cmdEdit('<%=kpiSetting.getOID()%>')" style="color: #FFF;" class="btn-edit btn-edit1 mx-2">Edit</a>
                                        <a href="javascript:cmdDeleteConfirmationKpiList('<%=oidKpiSetting%>', '<%=objKpiList.getOID()%>')" style="color: #FFF;" class="btn-delete btn-delete1">Delete</a>
                                    </div>
                                </td>
                            </tr>
                            <%    
                                    }
                               } else {
                            %>
                                <tr>
                                    <td colspan="6" class="text-center">Data tidak ditemukan.</td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>    
                </div>
            </div> 
                        <% }%>
        </form>
       </div>
        
        <div class="modal fade" id="exampleModal" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="exampleModalLabel">Pilih KPI Group</h5>
                    </div>                            
                    <div class="modal-body">
                        <form name="FRM_NAME_KPISETTINGGROUP" method ="get" action="">
                            <input type="hidden" name="command" value="<%= iCommand%>">
                            <input type="hidden" name="typeform" value="1">
                            <input type="hidden" name="<%=FrmKpiSettingGroup.fieldNames[FrmKpiSettingGroup.FRM_FIELD_KPI_SETTING_GROUP_ID]%>" value="<%=kpiSettingGroup.getKpiSettingGroupId()%>">
                            <input type="hidden" name="<%=FrmKpiSetting.fieldNames[FrmKpiSetting.FRM_FIELD_KPI_SETTING_ID]%>" value="<%=oidKpiSetting%>">
                            <input type="hidden" name="<%=FrmKpiSettingType.fieldNames[FrmKpiSettingType.FRM_FIELD_KPI_SETTING_TYPE_ID]%>" value="<%=oidKpiSettingType%>">
                            <input type="hidden" name="<%=FrmKpiSettingType.fieldNames[FrmKpiSettingType.FRM_FIELD_KPI_TYPE_ID]%>" value="<%=oidKpiTypeId%>">

                            <div class="form-group">
                                <label for="exampleInputPassword">KPI Group</label>
                                <select name="<%=FrmKpiSettingGroup.fieldNames[FrmKpiSettingGroup.FRM_FIELD_KPI_GROUP_ID]%>"style="width: 100%;" class="form-control form-control-sm custom-select select2">
                                    <option value="">=Select=</option>
                                    <%
                                        String kpiGroupQuery = "KPI_TYPE_ID = '" + oidKpiTypeId + "'";
                                        Vector listKpiGroup = PstKPI_Group.list(0, 0, kpiGroupQuery, "GROUP_TITLE");
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
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                                    <a href="javascript:cmdSaveKpiSettingGroup()" style="color:#FFF;" class="btn-simpan btn-simpan1">Save changes</a>
                                </div>
                            </div>
                        </form> 
                    </div>
                </div>
            </div>
        </div>

       <form name="FRM_NAME_KPISETTINGLIST" method ="post" action="">
            <input type="hidden" name="command" value="<%=iCommand%>">
            <input type="hidden" name="<%=FrmKpiSettingList.fieldNames[FrmKpiSettingList.FRM_FIELD_KPI_SETTING_LIST_ID]%>" value="<%=kpiSettingList.getOID()%>">
            <input type="hidden" name="<%=FrmKpiSetting.fieldNames[FrmKpiSetting.FRM_FIELD_KPI_SETTING_ID]%>" value="<%=oidKpiSetting%>">
            <input type="hidden" name="<%=FrmKpiSettingGroup.fieldNames[FrmKpiSettingGroup.FRM_FIELD_KPI_GROUP_ID]%>" value="<%=oidKpiSettingGroup%>">
            <input type="hidden" name="<%=FrmKpiSettingGroup.fieldNames[FrmKpiSettingGroup.FRM_FIELD_KPI_SETTING_GROUP_ID]%>" value="<%=kpiSettingGroupId%>" id="KpiSettingGroupId">
            <input type="hidden" name="typeform" value="2">
        <div class="modal fade" id="kpi-list-modal" data-backdrop="static" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-xl" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="exampleModalLabel2"><span id="kpi-group-name"></span></h5>
                    </div>                            
                    <div id="kpi-list-body" class="modal-body" style="max-height: 500px;">
                        
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                        <a class="btn btn-primary" href="javascript:check()">Check All</a>
                        <a class="btn btn-primary" href="javascript:uncheck()">Uncheck All</a>
                        <a href="javascript:cmdSaveKpiSettingList()" class="btn btn-primary" >Get Data</a>
                    </div> 
                </div>
            </div>
        </div>
       </form>
       
        <script src="../../javascripts/jquery.min.js" type="text/javascript"></script>
        <script src="../../styles/select2/js/select2.full.min.js" type="text/javascript"></script>
        <script src="../../javascripts/bootstrap.bundle.min.js" type="text/javascript"></script>
        <script language="JavaScript">

            
            $(document).ready(function(){
                $('[data-toggle="popover"]').popover();
                $('.select2').select2();
                $('.select2bs4').select2({
                    theme: 'bootstrap4'
                });
                
                // untuk mengubah command menjadi 0 setelah insert data agar saat reload data tidak terinput lagi
                <% if(iCommandInUrl == Command.SAVE){ %>
                    let url = new URL(window.location.href);
                    let params = new URLSearchParams(url.search);
                    params.set('command', <%= Command.EDIT %>);
                    window.history.pushState( {} , '', '?' +  params.toString());
                <% }%>
            });
            /*kumpulan tombol delete*/
            function cmdDeleteGroup(oidKpiGroup, oidKpiSetting, kpiSettingGroupOid) { 
                document.FRM_NAME_KPISETTINGLISTFORM.<%=FrmKpiSettingGroup.fieldNames[FrmKpiSettingGroup.FRM_FIELD_KPI_GROUP_ID]%>.value = oidKpiGroup;
                document.FRM_NAME_KPISETTINGLISTFORM.<%=FrmKpiSetting.fieldNames[FrmKpiSetting.FRM_FIELD_KPI_SETTING_ID]%>.value = oidKpiSetting;
                document.FRM_NAME_KPISETTINGLISTFORM.<%=FrmKpiSettingGroup.fieldNames[FrmKpiSettingGroup.FRM_FIELD_KPI_SETTING_GROUP_ID]%>.value = kpiSettingGroupOid;
                document.FRM_NAME_KPISETTINGLISTFORM.command.value = "<%=Command.DELETE %>";
                document.FRM_NAME_KPISETTINGLISTFORM.action = "kpi_setting_list_form.jsp";
                document.FRM_NAME_KPISETTINGLISTFORM.submit();
            }
            function cmdDeleteConfirmationKpiGroup(oidKpiGroup, oidKpiSetting, kpiSettingGroupOid) {
                Swal.fire({
                    title: 'Apakah Anda Yakin?',
                    text: "Anda Akan Menghapus Data Kpi Group Dengan Data Kpi Jika ada!",
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonColor: '#d33',
                    cancelButtonColor: '#3085d6',
                    confirmButtonText: 'Ya Hapus Data Kpi Group!'
                }).then((result) => {
                    if (result.isConfirmed) {
                        cmdDeleteGroup(oidKpiGroup, oidKpiSetting, kpiSettingGroupOid);
                    }
                })
            }
            function cmdDeleteKpiSettingList(oidKpiSetting, oidKpiList) {
      
                        var strUrl = "";
                        var xmlhttp = new XMLHttpRequest();
                        xmlhttp.onreadystatechange = function () {
                            if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                                
                                window.location.reload();
                            }
                        }
                        strUrl = "<%= approot%>/AjaxDeleteKpiSettingList";
                        strUrl += "?FRM_FIELD_KPI_SETTING_ID=" + oidKpiSetting;
                        strUrl += "&FRM_FIELD_KPI_LIST_ID=" + oidKpiList;
                        strUrl += "&isFormKpiSettingList=1";
                        strUrl += "&command=<%=Command.DELETE%>";

                        xmlhttp.open("GET", strUrl, true);
                        xmlhttp.send();
                    
                }
             function cmdDeleteConfirmationKpiList(oidKpiSetting, oidKpiList) {
                Swal.fire({
                    title: 'Apakah Anda Yakin?',
                    text: "Anda Akan Menghapus Data Kpi List!",
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonColor: '#d33',
                    cancelButtonColor: '#3085d6',
                    confirmButtonText: 'Ya Hapus Data Kpi List!'
                }).then((result) => {
                    if (result.isConfirmed) {
                        cmdDeleteKpiSettingList(oidKpiSetting, oidKpiList);
                    }
                })
            }
            function openModal(oidKpiGroup, groupName, oidkpiSettingGroup) {
                var strUrl = "";
                var xmlhttp = new XMLHttpRequest();
                xmlhttp.onreadystatechange = function() {
                    if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                        document.getElementById("kpi-list-body").innerHTML = xmlhttp.responseText;
                        $("#kpi-group-name").html(groupName);
                        $("#kpi-list-modal").modal("show");
                        document.FRM_NAME_KPISETTINGLIST.<%=FrmKpiSettingGroup.fieldNames[FrmKpiSettingGroup.FRM_FIELD_KPI_GROUP_ID]%>.value = oidKpiGroup;
                        document.getElementById("KpiSettingGroupId").value= oidkpiSettingGroup;
                    }
                }
                strUrl = "list_kpi_by_group.jsp";
                strUrl += "?FRM_FIELD_KPI_GROUP_ID="+oidKpiGroup;
                xmlhttp.open("GET", strUrl, true);
                xmlhttp.send();
            }

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

            function cmdSaveKpiSettingGroup() {
                document.FRM_NAME_KPISETTINGGROUP.command.value = "<%=Command.SAVE%>";
                document.FRM_NAME_KPISETTINGGROUP.action = "kpi_setting_list_form.jsp";
                document.FRM_NAME_KPISETTINGGROUP.submit();
            }
            function cmdSaveKpiSettingList() {
                document.FRM_NAME_KPISETTINGLIST.command.value = "<%=Command.SAVE%>";
                document.FRM_NAME_KPISETTINGLIST.action = "kpi_setting_list_form.jsp";
                document.FRM_NAME_KPISETTINGLIST.submit();
            }
            

            function check() {
                checkboxes = document.getElementsByName('FRM_FIELD_KPI_LIST_ID');  
                for(var i = 0; i < checkboxes.length; i++){  
                    if(checkboxes[i].type=='checkbox')  
                        checkboxes[i].checked = true;  
                }
            }
            
            function uncheck() {
                checkboxes = document.getElementsByName('FRM_FIELD_KPI_LIST_ID');  
                for(var i = 0; i < checkboxes.length; i++){  
                    if(checkboxes[i].type=='checkbox')  
                        checkboxes[i].checked = false;  
                }
            }

            function pageLoad() {
                $(".mydate").datepicker({dateFormat: "yy-mm-dd"});
            }

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
                document.FRM_NAME_KPISETTING.command.value = "<%= Command.ADD%>";
                document.FRM_NAME_KPISETTING.action = "kpi_setting_form.jsp";
                document.FRM_NAME_KPISETTING.submit();
            }


            function cmdSave() {
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
                // emp_department = document.frm_pay_emp_level.department.value;
                popup = window.open("../kpi_group.jsp?emp_department="
                        , "SelectEmployee", "height=600,width=700,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes");
                popup.focus();
            }
            function masterKpi() {
                onload = "masterKpi()";
                // emp_department = document.frm_pay_emp_level.department.value;
                popup = window.open("../kpi_list.jsp?emp_department="
                        , "SelectEmployee", "height=600,width=700,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes");
                popup.focus();
            }
            
            //untuk close pop up ketika kpi list ditambahkan
            function refreshAndClose() {
                <% if(iErrCodeSetttingList == 0 && iCommandInUrl == Command.SAVE){ %>                            
                        window.close();
                        if (window.opener && !window.opener.closed) {
                            window.opener.location.reload();
                        }
                <% } %>
            }
        </script>
        
</html>

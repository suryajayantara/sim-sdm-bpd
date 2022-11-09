<%-- 
    Document   : kpi_setting
    Created on : Sep 1, 2022, 1:33:38 PM
    Author     : suryawan
--%>


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
    long oidKpiSettingType = FRMQueryString.requestLong(request, "kpi_setting_type_id");

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
    long iErrCode = ctrlKpiSetting.action(iCommand, oidKpiSetting, request);
    if (iCommand == Command.SAVE){
        iCommand = 0;
    } 
    KpiSetting kpiSetting = ctrlKpiSetting.getKpiSetting();
    
    /*digunakan untuk button edit agar sesuai dengan oid tabel utama,
     untuk form jabatan, harus dibuat fungsi array di pst kpi setting 
    baru karena sudah mengambil data dengan bentuk array string */
    if (iCommand == Command.EDIT && kpiSetting != null && kpiSetting.exists()){
        oid_position = PstKpiSettingPosition.arrayKpiSettingPositionOID(kpiSetting.getOID());
        startDate = Formater.formatDate(kpiSetting.getStartDate(), "yyyy-MM-dd");
        validDate = Formater.formatDate(kpiSetting.getValidDate(), "yyyy-MM-dd");
        
    }
    

 /*controller untuk simpan data kpi setting type*/
    CtrlKpiSettingType ctrlKpiSettingType = new CtrlKpiSettingType(request);
    long iErrCode2 = ctrlKpiSettingType.action(iCommand, oidKpiSettingType, request);
    KpiSettingType kpiSettingType = ctrlKpiSettingType.getKpiSettingType();
    /*end*/

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

%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>FORM KPI SETTING</title>

        <style type="text/css">
            .btn-back {
                background-color: #575757;
                border-radius: 3px;
                font-family: Arial;
                color: #EEE;
                font-size: 12px;
                padding: 9.5px 11px 11px 11px;
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
                document.FRM_NAME_KPISETTING.targetId.value = 0;
                document.FRM_NAME_KPISETTING.command.value = "<%= Command.ADD%>";
                document.FRM_NAME_KPISETTING.action = "kpi_setting_form.jsp";
                document.FRM_NAME_KPISETTING.submit();
            }
            function cmdSave() {
                document.FRM_NAME_KPISETTING.command.value = "<%=Command.SAVE%>";
                document.FRM_NAME_KPISETTING.action = "kpi_setting_form.jsp";
                document.FRM_NAME_KPISETTING.submit();
            }
            function cmdSaveKpi() {
                document.FRM_NAME_KPISETTINGTYPE.command.value = "<%=Command.SAVE%>";
                document.FRM_NAME_KPISETTINGTYPE.action = "kpi_setting_form.jsp";
                document.FRM_NAME_KPISETTINGTYPE.submit();
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
        <div id="menu_utama">
            <span id="menu_title"><strong>Kinerja</strong> <strong style="color:#333;"> / </strong>Master Data / KPI Setting</span>
        </div>
        <div class="content-main">
            <form name="FRM_NAME_KPISETTING" method ="post" action="">
                <input type="hidden" name="command" value="<%=iCommand%>">
                <input type="hidden" name="<%=FrmKpiSetting.fieldNames[FrmKpiSetting.FRM_FIELD_KPI_SETTING_ID]%>" value="<%=kpiSetting.getOID()%>">
                <input type='hidden' name='detail_employee_id'>
                <input type="hidden" name="delete_for">

                <div class="formstyle">
                    <table width="100%">   
                        <div>&nbsp;</div>
                        <tr>
                            <td valign="top" width="35%">
                                <div id="caption">Company</div>
                                <div id="divinput">
                                    <select name="<%=FrmKpiSetting.fieldNames[FrmKpiSetting.FRM_FIELD_COMPANY_ID]%>" id="company" class="chosen-select" data-placeholder='Select Company...' onchange="javascript:cmdUpdateDivision()" >
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
                                    <select name="<%=FrmKpiSetting.fieldNames[FrmKpiSetting.FRM_FIELD_POSITION_ID]%>" style="width: 20%;" data-placeholder='Select Jabatan...'  multiple="multiple" class="select2" >
                                        <%
                                            Vector listPosition = PstPosition.list(0, 0, "", "");
                                            for (int i = 0; i < listPosition.size(); i++){
                                                Position objPosition = (Position) listPosition.get(i);
                                                String selected = "";
                                                if (oid_position != null){
                                                    for (int j = 0; j < oid_position.length; j++){
                                                        String oidPosition = ""+ objPosition.getOID();
                                                        if (oidPosition.equals(""+ oid_position[j])){
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
                                    <%= ControlCombo.draw(FrmKpiSetting.fieldNames[FrmKpiSetting.FRM_FIELD_STATUS], "chosen-select", null, "" + kpiSetting.getStatus(), val_status, key_status, "style='width : 20%' id='status'")%> 
                                </div>
                                <div id="caption">Dari Tanggal</div>

                                <div id="divinput">
                                    <input  type="date" id="startDate" class="mydate" name="<%=FrmKpiSetting.fieldNames[FrmKpiSetting.FRM_FIELD_START_DATE]%>" value="<%= (startDate.equals("") ? strDateNow : startDate)%>" />
                                    <span id="info1"></span>

                                </div>

                                <div id="caption">Sampai Tanggal</div>

                                <div id="divinput">

                                    <input type="date" id="validDate" class="mydate" name="<%=FrmKpiSetting.fieldNames[FrmKpiSetting.FRM_FIELD_VALID_DATE]%>" value="<%= validDate%>" />

                                </div>

                                <div id="caption">Tahun</div>
                                <div id="divinput" >
                                    <%= ControlCombo.draw(FrmKpiSetting.fieldNames[FrmKpiSetting.FRM_FIELD_TAHUN], "chosen-select", null, "" + kpiSetting.getTahun(), valTahun, keyTahun, "style='width : 20%'")%> 
                                </div>
                            </td>
                        </tr>
                    </table>
            </form>
            <div style="border-top: 1px solid #DDD;">&nbsp;</div>
            <a href="javascript:cmdSave()" style="color:#FFF;" class="btn">Simpan</a>
            <a href="javascript:cmdBack()" style="color:#FFF;" class="btn-back">Kembali</a>
            <%
                if (kpiSetting.getOID() > 0) {
            %>
            <a href="javascript:cmdAdd()" type="hidden" style="color:#FFF;" class="btn-add" class="btn btn-primary" data-toggle="modal" data-target="#exampleModal" >Pilih Kpi Type <strong><i class="fa fa-plus"></i></strong></a>
            <%}%>
            <div>&nbsp;</div>
        </div>
        <div>&nbsp;</div>
    </table>

    <!-- Modal adalah javascript untuk memunculkan pop up saat klik button tambah kpi -->

    <div class="modal fade" id="exampleModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">

                    <h5 class="modal-title" id="exampleModalLabel">Select Kpi Type</h5>

                </div>
                <div class="modal-body">
                    <form name="FRM_NAME_KPISETTINGTYPE" method ="post" action="">
                        <input type="hidden" name="command" value="<%=iCommand%>">
                        <input type="hidden" name="<%=FrmKpiSetting.fieldNames[FrmKpiSetting.FRM_FIELD_KPI_SETTING_ID]%>" value="<%=kpiSetting.getOID()%>">
                        <div class="form-group">
                            <label for="exampleInputPassword1">Kpi Type</label>
                            <select name="kpi_type" id="kpiTypeId" multiple="multiple" class="select2" style="width: 100%;">
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
                            <a href="javascript:cmdSaveKpi()" style="color:#FFF;" class="btn">Save changes</a>
                        </div>
                    </form>
                </div>
            </div>
           </div>
           </div>
            <!--End-->	
            
            <!--Tampilan form setelah input data kpi type-->
            <div class="formstyle">
               
                        <a href="javascript:cmdAdd()" type="hidden" style="color:#FFF;" class="btn-add" class="btn btn-primary" data-toggle="modal" data-target="#exampleModal2"  >Tambah Kpi Group <strong><i class="fa fa-plus"></i></strong></a>
                        &nbsp;<a href="javascript:cmdAdd()" type="hidden" style="color:#FFF;" class="btn-add" class="btn btn-primary" data-toggle="modal" data-target="#exampleModal3" >Tambah Kpi <strong><i class="fa fa-plus"></i></strong></a>
                        <div>&nbsp;</div>
                <table class="tblStyle" style="width: 100%;">
                    <tr>
                      <td class="title_tbl">Kpi Group</td>
                      <td class="title_tbl">Key Performance Indicator</td>
                      <td class="title_tbl">Distribution Option</td>
                      <td class="title_tbl">Satuan Ukur</td>
                      <td class="title_tbl">Target</td>
                      <td class="title_tbl">Bobot</td>
                      <td class="title_tbl">Action</td>
                    </tr>
                    <tr>
                    <td>
                    <select style="width: 100%;">
                      <option>Select</option>
                      <option>Alfreds Futterkiste</option>
                      <option>Alfreds Futterkiste</option>
                     </select>
                     </td>
                     <td>
                     <select style="width: 100%;">
                      <option>Select</option>
                      <option>Alfreds Futterkiste</option>
                      <option>Alfreds Futterkiste</option>
                     </select>
                     </td>
                      <td>
                     <select style="width: 100%;">
                      <option>Select</option>
                      <option>Alfreds Futterkiste</option>
                      <option>Alfreds Futterkiste</option>
                     </select>
                     </td>
                      <td>
                     <select style="width: 100%;">
                      <option>Select</option>
                      <option>RP</option>
                      <option>Automatic</option>
                     </select>
                     </td>
                      <td>
                        <!--button ini ditampilkan ketika user klik tombol simpan di bawah tabel kpi type-->
                    <center><a href="javascript:cmdEdit('<%=kpiSetting.getOID()%>')" style="color: #FFF;" class="btn-edit">Edit</a></center>
                     </td>
                      <td>
                     <select style="width: 100%;">
                      <option>Select</option>
                      <option>Alfreds Futterkiste</option>
                      <option>Alfreds Futterkiste</option>
                     </select>
                     </td>
                      <td>
                          <!--button ini ditampilkan ketika user klik tombol simpan di bawah tabel kpi type-->
                    <center><a href="javascript:cmdEdit('<%=kpiSetting.getOID()%>')" style="color: #FFF;" class="btn-edit">Edit</a> ||
                        <a href="javascript:cmdDelete('<%=kpiSetting.getOID()%>')" style="color: #FFF;" class="btn-delete">Delete</a></center>
                     </td>
                    </tr>

                  </table>
                     <div>&nbsp;</div>
                         <a href="javascript:cmdSaveKpi()" style="color:#FFF;" class="btn">Simpan</a>
                         &nbsp;<a href="javascript:cmdBack()" style="color:#FFF;" class="btn-back">Kembali</a>
                       </div>
                   </form>
              
           </table>     
           </div>
                       
            <!--Pop up untuk form tambah kpi group-->
            <div class="modal fade" id="exampleModal2" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <center><strong>Tambah Kpi Group</strong></center>
                <div class="modal-body">
                    <form name="FRM_NAME_KPISETTINGTYPE" method ="post" action="">
                        <input type="hidden" name="command" value="<%=iCommand%>">
                        <input type="hidden" name="<%=FrmKpiSetting.fieldNames[FrmKpiSetting.FRM_FIELD_KPI_SETTING_ID]%>" value="<%=kpiSetting.getOID()%>">
                        <div class="form-group">
                            <div>KPI Type</div>
                            <select name="kpi_type" id="" multiple="multiple" class="select2" style="width: 80%;">
                                <option value="">=Select=</option>
                                <option value="">sasaran kinerja</option>
                                <option value="">Sasaran kinerja berdasarkan divisi</option>
                            </select>
                            <div>&nbsp;</div>
                            <div>KPI Tittle</div>
                            <input type="text" style="width: 80%;">
                            </input>
                            <div>&nbsp;</div>
                            <div>Description</div>
                            <textarea style="width: 80%;">
                            </textarea>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                            <a href="javascript:cmdSaveKpi()" style="color:#FFF;" class="btn">Save changes</a>
                        </div>
                    </form>
                </div>
            </div>
           </div>
           </div>            
                        
           <!--Pop up untuk form tambah kpi-->      
           <div class="modal fade" id="exampleModal3" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <center><strong>Tambah KPI</strong></center>
                <div class="modal-body">
                    <form name="FRM_NAME_KPISETTINGTYPE" method ="post" action="">
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
                            <a href="javascript:cmdSaveKpi()" style="color:#FFF;" class="btn">Save changes</a>
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
            </body>
            </html>


<%-- Document : kpi_setting_target Created on : Oct 12, 2022, 2:47:43 PM Author
: User --%> 
<%@page import="com.dimata.qdep.entity.I_DocStatus"%>
<%@page import="com.dimata.harisma.form.masterdata.FrmSection"%>
<%@page import="com.dimata.harisma.form.masterdata.FrmDepartment"%>
<%@page import="com.dimata.harisma.form.masterdata.FrmDivision"%>
<%@page import="com.dimata.harisma.form.masterdata.FrmKpiTargetDetail"%>
<%@page import="com.dimata.harisma.form.masterdata.FrmKpiTarget"%>
<%@page import="com.dimata.gui.jsp.ControlCombo"%>
<%@page import="com.dimata.harisma.form.masterdata.FrmKpiSettingList"%>
<%@page import="com.dimata.harisma.entity.admin.AppObjInfo"%> 
<%@ include file = "../../main/javainit.jsp" %> 
<% int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_EMPLOYEE, AppObjInfo.G2_LEAVE_APPLICATION, AppObjInfo.OBJ_LEAVE_APPLICATION);%> 
<%@ include file = "../../main/checkuser.jsp" %> 
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%    
    long oidKpiSettingList = FRMQueryString.requestLong(request, FrmKpiSettingList.fieldNames[FrmKpiSettingList.FRM_FIELD_KPI_SETTING_LIST_ID]);
    int tahun = Calendar.getInstance().get(Calendar.YEAR);
    String divisionOID = "";
    String departementOID = "";
    
    KpiSettingList entKpiSettingList = new KpiSettingList();
    KPI_List entKpiList = new KPI_List();
    KpiSetting entKpiSetting = new KpiSetting();
    Company entCompany = new Company();
    Vector vKpiSettingPosition = new Vector();
    if(oidKpiSettingList > 0){
        entKpiSettingList = PstKpiSettingList.fetchExc(oidKpiSettingList);
        entKpiList = PstKPI_List.fetchExc(entKpiSettingList.getKpiListId());
        entKpiSetting = PstKpiSetting.fetchExc(entKpiSettingList.getKpiSettingId());
        entCompany = PstCompany.fetchExc(entKpiSetting.getCompanyId());

        vKpiSettingPosition = PstKpiSettingPosition.list(0, 0, PstKpiSettingPosition.fieldNames[PstKpiSettingPosition.FLD_KPI_SETTING_ID] + " = " + entKpiSetting.getOID(), "");
    }


    Vector valTahun = new Vector();
    Calendar calNow = Calendar.getInstance();
    for (int i = calNow.get(Calendar.YEAR); i >= 2000; i--) {
        valTahun.add("" + i);
    }
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <title>KPI Setting Target Form</title>

        <link
            href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css"
            rel="stylesheet"
            />
        <link rel="stylesheet" href="../../styles/main.css" type="text/css" />
        <link rel="stylesheet" href="../../stylesheets/custom.css" />
        <link
            rel="stylesheet"
            href="../../styles/css_suryawan/CssSuryawan.css"
            type="text/css"
            />
        <link rel="stylesheet" href="../../stylesheets/chosen.css" />
    </head>
    <body>
        <div class="header">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <%if (headerStyle && !verTemplate.equalsIgnoreCase("0")) {%> <%@include
                file="../../styletemplate/template_header.jsp" %> <%} else {%>
                <tr>
                    <td
                        ID="TOPTITLE"
                        style="background: <%=approot%>/images/HRIS_HeaderBg3.jpg"
                        width="100%"
                        height="54"
                        >
                        <!-- #BeginEditable "header" -->
                        <%@ include file = "../../main/header.jsp" %>
                        <!-- #EndEditable -->
                    </td>
                </tr>
                <tr>
                    <td bgcolor="#9BC1FF" height="15" ID="MAINMENU" valign="middle">
                        <!-- #BeginEditable "menumain" -->
                        <%@ include file = "../../main/mnmain.jsp" %>
                        <!-- #EndEditable -->
                    </td>
                </tr>
                <tr>
                    <td bgcolor="#9BC1FF" height="10" valign="middle">
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td align="left">
                                    <img
                                        src="<%=approot%>/images/harismaMenuLeft1.jpg"
                                        width="8"
                                        height="8"
                                        />
                                </td>
                                <td
                                    align="center"
                                    style="background: <%=approot%>/images/harismaMenuLine1.jpg"
                                    width="100%"
                                    >
                                    <img
                                        src="<%=approot%>/images/harismaMenuLine1.jpg"
                                        width="8"
                                        height="8"
                                        />
                                </td>
                                <td align="right">
                                    <img
                                        src="<%=approot%>/images/harismaMenuRight1.jpg"
                                        width="8"
                                        height="8"
                                        />
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <%}%>
            </table>
        </div>
        <div id="menu_utama">
            <span id="menu_title">KPI Setting Target Form / KPI Setting Target</span>
        </div>
        <form name="frm" method="post" action="">
            <div class="box">
                <div class="content-main">
                    <h6 class="fw-bold"><%= entCompany.getCompany()%></h6>
                    <h6><%= entKpiList.getKpi_title()%></h6>
                    <hr />

                    <div>
                        <div class="row">
                            <div class="col-10">
                                <div class="mb-3">
                                    <label for="exampleInputEmail1">Judul Target</label>
                                    <input
                                        type="text"
                                        class="form-control"
                                        name="<%=FrmKpiTarget.fieldNames[FrmKpiTarget.FRM_FIELD_TITLE]%>"
                                        id="target-title"
                                        />
                                </div>
                            </div>
                                        
                            <div class="col-2">
                                <div class="mb-3">
                                    <label for="exampleInputEmail1">Status</label>
                                    <%
                                        Vector val_status = new Vector(1, 1);
                                        Vector key_status = new Vector(1, 1);
                                        long oidTarget = 0;
                                        KpiTarget kpiTarget = new KpiTarget();

                                        val_status.add(String.valueOf(I_DocStatus.DOCUMENT_STATUS_DRAFT));
                                        key_status.add(I_DocStatus.fieldDocumentStatus[I_DocStatus.DOCUMENT_STATUS_DRAFT]);

                                        if (oidTarget > 0) {
                                            val_status.add(String.valueOf(I_DocStatus.DOCUMENT_STATUS_TO_BE_APPROVED));
                                            key_status.add(I_DocStatus.fieldDocumentStatus[I_DocStatus.DOCUMENT_STATUS_TO_BE_APPROVED]);

                                            val_status.add(String.valueOf(I_DocStatus.DOCUMENT_STATUS_CANCELLED));
                                            key_status.add(I_DocStatus.fieldDocumentStatus[I_DocStatus.DOCUMENT_STATUS_CANCELLED]);
                                        }
                                    %>
                                    <%= ControlCombo.draw(FrmKpiTarget.fieldNames[FrmKpiTarget.FRM_FIELD_STATUS_DOC], "form-control", null, "" + kpiTarget.getStatusDoc(), val_status, key_status, "id='doc-status'")%>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col">
                                <div class="mb-3">
                                    <label for="exampleInputEmail1">Tahun</label>
                                    <%= ControlCombo.draw(FrmKpiTarget.fieldNames[FrmKpiTarget.FRM_FIELD_TAHUN], "form-control", null, "" + tahun, valTahun, valTahun, " id='tahun'")%>
                                </div>
                            </div>

                            <div class="col">
                                <div class="mb-3">
                                    <label for="exampleInputEmail1">Periode</label>
                                    <%
                                        Vector periode_value = new Vector(1, 1);
                                        Vector periode_key = new Vector(1, 1);
                                        for (int i = 0; i < PstKpiTargetDetail.period.length; i++) {
                                            periode_key.add(PstKpiTargetDetail.period[i]);
                                            periode_value.add(String.valueOf(i));
                                        }

                                    %>
                                    <%=ControlCombo.draw(FrmKpiTargetDetail.fieldNames[FrmKpiTargetDetail.FRM_FIELD_PERIOD], "form-control", "~Pilih Periode~", "", periode_value, periode_key, " id='periode'")%> 
                                </div>
                            </div>

                            <div class="col">
                                <div class="mb-3">
                                    <label for="exampleInputEmail1">Periode Index</label>
                                    <select name="<%=FrmKpiTargetDetail.fieldNames[FrmKpiTargetDetail.FRM_FIELD_INDEX_PERIOD]%>" id="periode-index" class="form-control">

                                    </select>
                                </div>
                            </div>

                            <div class="col">
                                <div class="mb-3">
                                    <label for="exampleInputEmail1">Date From</label>
                                    <input
                                        type="date"
                                        class="form-control"
                                        id="date-from"
                                        name="<%=FrmKpiTargetDetail.fieldNames[FrmKpiTargetDetail.FRM_FIELD_DATE_FROM]%>"
                                        />
                                </div>
                            </div>

                            <div class="col">
                                <div class="mb-3">
                                    <label for="exampleInputEmail1">Date To</label>
                                    <input
                                        type="date"
                                        class="form-control"
                                        id="date-to"
                                        name="<%=FrmKpiTargetDetail.fieldNames[FrmKpiTargetDetail.FRM_FIELD_DATE_TO]%>"
                                        />
                                </div>
                            </div>
                        </div>

                        <!--looping data position-->
                        <%
                            if (vKpiSettingPosition.size() > 0) {
                                for (int i = 0; i < vKpiSettingPosition.size(); i++) {
                                    KpiSettingPosition entKpiSettingPosition = (KpiSettingPosition) vKpiSettingPosition.get(i);
                                    Position entPosition = PstPosition.fetchExc(entKpiSettingPosition.getPositionId());
                        %>
                        <div class="card mb-3">
                            <div class="card-title p-2" style="background-color: #ededed"><%= entPosition.getPosition()%></div>
                            <div class="card-body py-0">
                                <div class="mb-3">
                                    <div class="row datarow">
                                        <%
                                            Vector vPositionDivision = PstPositionDivision.list(0, 0, PstPositionDivision.fieldNames[PstPositionDivision.FLD_POSITION_ID] + " = " + entPosition.getOID(), "");
                                            if(vPositionDivision.size() > 0){
                                                for(int j = 0; j < vPositionDivision.size(); j++){
                                                    String comma = "";
                                                    PositionDivision entPositionDivision = (PositionDivision) vPositionDivision.get(j);
                                                    Division entDivision = PstDivision.fetchExc(entPositionDivision.getDivisionId());
                                                    if((j + 1) != vPositionDivision.size()){
                                                        comma = ",";
                                                    }
                                                    divisionOID += entDivision.getOID() + comma;
                                        %>
                                                    <div class="col-3 mb-3">
                                                        <table>
                                                            <tr>
                                                                <td colspan="2">
                                                                    <span class="fw-bold">Divisi</span>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td style="width: 1%; vertical-align: top;">
                                                                    <input 
                                                                        type="checkbox" 
                                                                        name="<%= FrmDivision.fieldNames[FrmDivision.FRM_FIELD_DIVISION_ID] %>-<%= i %>-<%= j %>" 
                                                                        class="division-checkbox division-checkbox-<%= i %>" 
                                                                        id="division-<%= i %>-<%= j %>"
                                                                        value="<%=entDivision.getOID()%>"
                                                                        />
                                                                </td>
                                                                <td>
                                                                    <label class="me-2 checkbox-inline" for="division-<%= i %>-<%= j %>"><%= entDivision.getDivision() %></label> <br/>
                                                                    <table class="mt-1 department-table" style="display: none" id="departementtable-<%= i %>-<%= j %>">
                                                                        <tr>
                                                                            <td colspan="2">
                                                                                <span class="fw-bold">Department</span><br/>
                                                                            </td>
                                                                        </tr>
                                                                        <%
                                                                            Vector vDepartment = PstDepartment.listVerySimple(PstDepartment.fieldNames[PstDepartment.FLD_DIVISION_ID]+ " = " + entDivision.getOID());
                                                                            for(int k = 0; k < vDepartment.size(); k++){
                                                                                Department entDepartment = (Department) vDepartment.get(k);
                                                                        %>
                                                                        <tr>
                                                                            <td style="width: 1%; vertical-align: top;">
                                                                                <input 
                                                                                    type="checkbox" 
                                                                                    name="<%= FrmDepartment.fieldNames[FrmDepartment.FRM_FIELD_DEPARTMENT_ID] %>-<%= i %>-<%= j %>-<%= k %>" 
                                                                                    class="department-checkbox department-checkbox-<%=entDivision.getOID()%>" 
                                                                                    id="department-<%= i %>-<%= j %>-<%= k %>"
                                                                                    value="<%=entDepartment.getOID()%>"/>
                                                                            </td>
                                                                            <td>
                                                                                <label class="me-2 checkbox-inline" for="department-<%= i %>-<%= j %>-<%= k %>"><%= entDepartment.getDepartment()%></label><br>
                                                                                <table class="mt-1" style="display: none" id="sectiontable-<%= i %>-<%= j %>-<%= k %>">
                                                                                    <%
                                                                                        Vector vSection = PstSection.list(0, 0, PstSection.fieldNames[PstSection.FLD_DEPARTMENT_ID]+ " = " + entDepartment.getOID(), "");
                                                                                        if(vSection.size() > 0){
                                                                                    %>
                                                                                        <tr>
                                                                                            <td colspan="2">
                                                                                                <span class="fw-bold">Section</span><br/>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%
                                                                                            for(int l = 0; l < vSection.size(); l++){
                                                                                                Section entSection = (Section) vSection.get(l);
                                                                                        %>
                                                                                        <tr>
                                                                                            <td style="width: 1%; vertical-align: top;">
                                                                                                <input 
                                                                                                    type="checkbox" 
                                                                                                    name="<%= FrmSection.fieldNames[FrmSection.FRM_FIELD_SECTION_ID] %>-<%= i %>-<%= j %>-<%= k %>-<%= l %>" 
                                                                                                    id="section-<%= i %>-<%= j %>-<%= k %>-<%= l %>"
                                                                                                    class="section-checkbox section-checkbox-<%=entDepartment.getOID()%>"
                                                                                                    value="<%=entSection.getOID()%>"
                                                                                                    />
                                                                                            </td>
                                                                                            <td>
                                                                                                <label class="me-2 checkbox-inline" for="section-<%= i %>-<%= j %>-<%= k %>-<%= l %>"><%= entSection.getSection()%></label>
                                                                                            </td>
                                                                                        </tr>
                                                                                    <%      }
                                                                                       } %>
                                                                                </table>
                                                                            </td>
                                                                        </tr>
                                                                        <% } %>
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </div>
                                        <%      }
                                           }else{ %>
                                               <p>Tidak ada data.</p>
                                        <% } %>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <% }
                        } else { %>
                        <div class="card mb-3">
                            <div class="card-body">
                                <p>Tidak ada data posisi.</p>
                            </div>
                        </div>
                        <% } %>
                    </div>
                    <div class="alert alert-danger alert-dismissible fade show" id="alert-error" role="alert" style="display: none;">
                        <strong>Error</strong> <span id="error-message"></span>
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                    <div class="alert alert-success alert-dismissible fade show" id="alert-success" role="alert" style="display: none;">
                        <strong>Sukses</strong> <span id="success-message"></span>
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                    <div class="progress mb-3" style="display: none;" id="progress-div">
                        <div class="progress-bar progress-bar-striped progress-bar-animated" role="progressbar" aria-label="Animated striped example" aria-valuenow="10" aria-valuemin="0" aria-valuemax="100" style="width: 10%" id="progress-bar"></div>
                    </div>
                    <div class="d-flex justify-content-center mt-0">
                        <button class="btn btn-primary" style="color: white" id="btn-create">
                            Create Target
                        </button>
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
                    <td colspan="2" height="20">
                        <%@ include file = "../../main/footer.jsp" %>
                    </td>
                </tr>
                <%}%>
            </table>
        </div>
        <script src="<%=approot%>/javascripts/jquery.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            $(function () {
                const PERIOD_BULAN = <%= PstKpiTargetDetail.PERIOD_BULAN%>;
                const PERIOD_TRIWULAN = <%= PstKpiTargetDetail.PERIOD_TRIWULAN%>;
                const PERIOD_CATURWULAN = <%= PstKpiTargetDetail.PERIOD_CATURWULAN%>;
                const PERIOD_SEMESTER = <%= PstKpiTargetDetail.PERIOD_SEMESTER%>;
                const PERIOD_TAHUN = <%= PstKpiTargetDetail.PERIOD_TAHUN%>;

                $("body").on("change", "#periode", function () {
                    const value = $(this).val();
                    let periodeIndex = 0;
                    let stringOption = "<option>~Pilih Periode Index~</option>";

                    switch (parseInt(value)) {
                        case PERIOD_BULAN:
                            periodeIndex = 12;
                            break;
                        case PERIOD_TRIWULAN:
                            periodeIndex = 4;
                            break;
                        case PERIOD_CATURWULAN:
                            periodeIndex = 3;
                            break;
                        case PERIOD_SEMESTER:
                            periodeIndex = 2;
                            break;
                        case PERIOD_TAHUN:
                            periodeIndex = 1;
                            break;
                    }
                    for (let i = 0; i < parseInt(periodeIndex); i++) {
                        stringOption += "<option value=" + i + ">" + (i + 1) + "</option>";
                    }
                    $("#periode-index").html(stringOption);
                });

                $("body").on("change", "#periode-index", function () {
                    const value = $(this).val();
                    const year = $("#tahun").val();
                    const periode = $("#periode").val();
                    let startMonth = null;
                    let endMonth = null;
                    let startDate = null;
                    let endDate = null;

                    switch (parseInt(periode)) {
                        case PERIOD_BULAN:
                            startMonth = value;
                            endMonth = value;
                            break;
                        case PERIOD_TRIWULAN:
                            switch (parseInt(value)) {
                                case 0:
                                    startMonth = 0;
                                    endMonth = 2;
                                    break;
                                case 1:
                                    startMonth = 3;
                                    endMonth = 5;
                                    break;
                                case 2:
                                    startMonth = 6;
                                    endMonth = 8;
                                    break;
                                case 3:
                                    startMonth = 9;
                                    endMonth = 11;
                                    break;
                            }
                            break;
                        case PERIOD_CATURWULAN:
                            switch (parseInt(value)) {
                                case 0:
                                    startMonth = 0;
                                    endMonth = 3;
                                    break;
                                case 1:
                                    startMonth = 4;
                                    endMonth = 7;
                                    break;
                                case 2:
                                    startMonth = 8;
                                    endMonth = 11;
                                    break;
                            }
                            break;
                        case PERIOD_SEMESTER:
                            switch (parseInt(value)) {
                                case 0:
                                    startMonth = 0;
                                    endMonth = 5;
                                    break;
                                case 1:
                                    startMonth = 6;
                                    endMonth = 11;
                                    break;
                            }
                            break;
                        case PERIOD_TAHUN:
                            startMonth = 0;
                            endMonth = 11;
                            break;
                    }

                    startDate = new Date(parseInt(year), parseInt(startMonth), 1);
                    endDate = new Date(parseInt(year), parseInt(endMonth) + 1, 0);

                    const intStartDay = ("0" + startDate.getDate()).slice(-2);
                    const intStartMonth = ("0" + (startDate.getMonth() + 1)).slice(-2);
                    const intEndDay = ("0" + endDate.getDate()).slice(-2);
                    const intEndMonth = ("0" + (endDate.getMonth() + 1)).slice(-2);

                    let validStartDate = startDate.getFullYear() + "-" + intStartMonth + "-" + intStartDay;
                    let validEndDate = endDate.getFullYear() + "-" + intEndMonth + "-" + intEndDay;

                    $("#date-from").val(validStartDate);
                    $("#date-to").val(validEndDate);
                });

                $("body").on("change", ".division-checkbox", function(){
                    const indexI = $(this).attr("id").split("-")[1];
                    const indexJ = $(this).attr("id").split("-")[2];
                    if(this.checked) {
                        $("#departementtable-" + indexI + "-" + indexJ).fadeIn();
                    } else {
                        $("#departementtable-" + indexI + "-" + indexJ).fadeOut();
                    }
                });

                $("body").on("change", ".department-checkbox", function(){
                    const indexI = $(this).attr("id").split("-")[1];
                    const indexJ = $(this).attr("id").split("-")[2];
                    const indexK = $(this).attr("id").split("-")[3];
                    if(this.checked) {
                        $("#sectiontable-" + indexI + "-" + indexJ + "-" + indexK).fadeIn();
                    } else {
                        $("#sectiontable-" + indexI + "-" + indexJ + "-" + indexK).fadeOut();
                    }
                });
                
                $("body").on("click", "#btn-create", function(e){
                    e.preventDefault();
                    $("#alert-error").fadeOut();
                    $("#progress-div").show();
                    const targetTitle = $("#target-title").val();
                    const docStatus = $("#doc-status").val();
                    const tahun = $("#tahun").val();
                    const periode = $("#periode").val();
                    const periodeIndex = parseInt($("#periode-index").val()) + 1;
                    const dateFrom = $("#date-from").val();
                    const dateTo = $("#date-to").val();
                    let checkedDivisionCount = 0;
                    
                    // menyiapkan data untuk di post
                    $(".datarow").each(function(indexRow, objectRow){
                        let current = 0;
                        const totalLoop = $(".division-checkbox-" + indexRow + ":checked").size();
                        $(".division-checkbox-" + indexRow + ":checked").each(function(indexDivision, objectDivision){ 
                            if ($(objectDivision).is(":checked")){
                                current =  indexDivision + 1;
                                let checkedDepartmentCount = 0;
                                const divisionOID = $(objectDivision).val();
                                checkedDivisionCount++;
                                
                                $(".department-checkbox-" + divisionOID).each(function(indexDepartement, objectDepartement){
                                    if($(objectDepartement).is(":checked")){
                                        let checkedSectionCount = 0;
                                        const departemenOID = $(objectDepartement).val();
                                        checkedDepartmentCount++;
                                        
                                        $(".section-checkbox-" + departemenOID).each(function(indexSection, objectSection){
                                            if($(objectSection).is(":checked")){
                                                checkedSectionCount++;
                                                const sectionOID =  $(objectSection).val();
                                                
                                                ajaxPost(data(divisionOID, departemenOID, sectionOID), current, totalLoop);
                                            }
                                        });
                                        if(checkedSectionCount === 0){
                                            ajaxPost(data(divisionOID, departemenOID, 0), current, totalLoop);
                                        }
                                    }
                                });
                                if(checkedDepartmentCount === 0){
                                    ajaxPost(data(divisionOID, 0, 0), current, totalLoop);
                                }
                            }
                        });
                    });
                    if(checkedDivisionCount === 0){
                        $("#alert-error").children("#error-message").text("Mohon centang setidaknya satu divisi");
                        $("#alert-error").fadeIn();
                        return;
                    }
                    
                    function ajaxPost(data, current, total) {
                        $.ajax({
                            url: "<%=approot%>/AjaxTargetPerKpi",
                            type: 'POST',
                            async: false,
                            data: data,
                            success: function(data) {
                                let progress = (current / total) * 100;
                                $("#progress-bar").attr("aria-valuenow", progress);
                                $("#progress-bar").css("width", progress + "%");
                                if(progress === 100){
                                    $("#alert-success").children("#success-message").text("Data berhasil disimpan.");
                                    $("#alert-success").fadeIn();
                                }
                            },
                            error: function(){
                                alert("Terjadi kesalahan pada server.");
                            }
                        });
                    }

                    function data(divisionOID, departmentOID, sectionOID){
                        const thisDivisionOID = divisionOID;
                        const thisDepartmentOID = departmentOID;
                        const thisSectionOID = sectionOID;
                        return {
                            <%=FrmKpiSettingList.fieldNames[FrmKpiSettingList.FRM_FIELD_KPI_SETTING_ID]%> : <%=entKpiSettingList.getOID()%>,
                            <%=FrmKpiTarget.fieldNames[FrmKpiTarget.FRM_FIELD_TITLE]%> : targetTitle,
                            <%=FrmKpiTarget.fieldNames[FrmKpiTarget.FRM_FIELD_STATUS_DOC]%> : docStatus,
                            <%=FrmKpiTarget.fieldNames[FrmKpiTarget.FRM_FIELD_TAHUN]%> : tahun,
                            <%=FrmKpiTargetDetail.fieldNames[FrmKpiTargetDetail.FRM_FIELD_PERIOD]%> : periode,
                            <%=FrmKpiTargetDetail.fieldNames[FrmKpiTargetDetail.FRM_FIELD_INDEX_PERIOD]%> : periodeIndex,
                            <%=FrmKpiTargetDetail.fieldNames[FrmKpiTargetDetail.FRM_FIELD_DATE_FROM]%> : dateFrom,
                            <%=FrmKpiTargetDetail.fieldNames[FrmKpiTargetDetail.FRM_FIELD_DATE_TO]%> : dateTo,
                            <%=FrmDivision.fieldNames[FrmDivision.FRM_FIELD_DIVISION_ID]%> : thisDivisionOID,
                            <%=FrmDepartment.fieldNames[FrmDepartment.FRM_FIELD_DEPARTMENT_ID]%> : thisDepartmentOID,
                            <%=FrmSection.fieldNames[FrmSection.FRM_FIELD_SECTION_ID]%> : thisSectionOID
                        };
                    }
                });
            });
        </script>
    </body>
</html>

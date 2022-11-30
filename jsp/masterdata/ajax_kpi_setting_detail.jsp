<%-- Document : ajax_kpi_setting_detail Created on : Nov 28, 2022, 3:08:38 PM
Author : kadek --%> 
<%@page import="com.dimata.harisma.entity.masterdata.PstKpiSettingList"%>
<%@page import="com.dimata.harisma.entity.masterdata.KpiSettingList"%>
<%@page import="com.dimata.harisma.entity.masterdata.Company"%> 
<%@page import="com.dimata.harisma.entity.masterdata.PstCompany"%> 
<%@page import="com.dimata.harisma.entity.masterdata.PstPosition"%> 
<%@page import="com.dimata.harisma.entity.masterdata.Position"%> 
<%@page import="com.dimata.harisma.entity.masterdata.KpiSettingPosition"%> 
<%@page import="com.dimata.harisma.entity.masterdata.PstKpiSettingPosition"%> 
<%@page import="java.util.Vector"%> 
<%@page import="java.util.Date"%> 
<%@page import="java.text.DateFormat"%> 
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.dimata.util.Formater"%> 
<%@page import="com.dimata.harisma.entity.masterdata.PstKpiSetting"%> 
<%@page import="com.dimata.harisma.entity.masterdata.KpiSetting"%> 
<%@page import="com.dimata.qdep.form.FRMQueryString"%> 
<%@page import="com.dimata.qdep.entity.I_DocStatus"%> 
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<% 
    /* value of structure */ 
    long kpiSettingId = FRMQueryString.requestLong(request, "kpi_setting_id"); 
    KpiSetting entKpiSetting = new KpiSetting(); 
    Vector vKpiSettingPosition = new Vector(); 
    Company entCompany = new Company(); 
    int kpiListCount = 0;
    String[] fieldDocumentStatus = { "Draft", "To Be Approved", "Final", "Revised", "Proceed", "Closed", "Cancelled", "Posted", "Paid" }; 
    String startDate = ""; 
    String validDate = ""; 
    String position = ""; 
    try { 
        if (kpiSettingId != 0) { 
            // mengambil data kpi setting 
            entKpiSetting = PstKpiSetting.fetchExc(kpiSettingId); 
            kpiListCount = PstKpiSettingList.getCountKpiList("KPI_SETTING_ID = '"+ kpiSettingId +"'");
            String whereClause = "KPI_SETTING_ID = '" + kpiSettingId + "'"; 
            vKpiSettingPosition = PstKpiSettingPosition.list(0, 0, whereClause, ""); 
            for (int i = 0; i < vKpiSettingPosition.size(); i++) {
                KpiSettingPosition entKpiSettingPosition = (KpiSettingPosition) vKpiSettingPosition.get(0); 
                Position entPosition = PstPosition.fetchExc(entKpiSettingPosition.getPositionId()); 
                position += entPosition.getPosition() + ", "; 
            } 
            // mengambil data company 
            entCompany = PstCompany.fetchExc(entKpiSetting.getCompanyId()); 
        } 
        DateFormat dateFormat = new SimpleDateFormat("dd-MM-yyyy"); 
        Date objStartDate = entKpiSetting.getStartDate(); 
        Date objValidDate = entKpiSetting.getValidDate();
        startDate = dateFormat.format(objStartDate); 
        validDate = dateFormat.format(objValidDate); 
    } catch (Exception e) { } 
%>

<div class="row">
  <div class="col-lg-3">Company</div>
  <div class="col-lg-9">: <%= entCompany.getCompany()%></div>
</div>
<div class="row">
  <div class="col-lg-3">Position</div>
  <div class="col-lg-9">: <%= position%></div>
</div>
<div class="row">
  <div class="col-lg-3">Status</div>
  <div class="col-lg-9">
    : <%= fieldDocumentStatus[entKpiSetting.getStatus()] %>
  </div>
</div>
<div class="row">
  <div class="col-lg-3">Periode</div>
  <div class="col-lg-9">: <%= startDate%> s/d <%= validDate %></div>
</div>
<div class="row">
  <div class="col-lg-3">Jumlah KPI Terdaftar</div>
  <div class="col-lg-9">: <%= kpiListCount %></div>
</div>

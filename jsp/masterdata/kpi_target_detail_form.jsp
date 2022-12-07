<%-- Document : kpi_target_detail_form Created on : Dec 5, 2022, 10:58:42 AM
Author : kadek --%> 
<%@page import="com.dimata.harisma.form.masterdata.FrmKpiTargetDetailEmployee"%>
<%@page import="com.dimata.harisma.form.employee.FrmEmployee"%>
<%@page import="com.dimata.harisma.form.masterdata.FrmKpiTarget"%>
<%@page import="com.dimata.harisma.form.masterdata.CtrlKpiTargetDetail"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstKpiTargetDetail"%>
<%@page import="com.dimata.harisma.form.masterdata.FrmKpiTargetDetail"%>
<%@page import="com.dimata.gui.jsp.ControlCombo"%> <%@page
import="com.dimata.qdep.entity.I_DocStatus"%> <%@page
import="com.dimata.harisma.entity.admin.AppObjInfo"%> <%@ include file =
"../main/javainit.jsp" %> <% int appObjCode =
AppObjInfo.composeObjCode(AppObjInfo.G1_EMPLOYEE,
AppObjInfo.G2_LEAVE_APPLICATION, AppObjInfo.OBJ_LEAVE_APPLICATION);%> <%@
include file = "../main/checkuser.jsp" %> <%@page contentType="text/html"
pageEncoding="UTF-8"%>
<!DOCTYPE html>
<% 
    int iCommand = FRMQueryString.requestCommand(request); 
    long oidKpiTarget = FRMQueryString.requestLong(request, FrmKpiTarget.fieldNames[FrmKpiTarget.FRM_FIELD_KPI_TARGET_ID]);
    Vector vKpiTargetDetail = PstKpiTargetDetail.list(0, 0, PstKpiTarget.fieldNames[PstKpiTarget.FLD_KPI_TARGET_ID] + " = " + oidKpiTarget, "");
    
    CtrlKpiTargetDetail ctrlKpiTargetDetail = new CtrlKpiTargetDetail(request);
    KpiTargetDetail kpiTargetDetail = ctrlKpiTargetDetail.getKpiTargetDetail();
%>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>Kpi Target Detail Form</title>
    <link rel="stylesheet" href="../styles/main.css" type="text/css" />
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css"
      rel="stylesheet"
    />
    <link
      rel="stylesheet"
      href="<%=approot%>/javascripts/datepicker/themes/jquery.ui.all.css"
    />
    <link
      rel="stylesheet"
      href="<%=approot%>/styles/datatable/v1/jquery.dataTables.min.css"
    />
    <link rel="stylesheet" href="../stylesheets/chosen.css" >
    <link rel="stylesheet" href="../stylesheets/custom.css" >
  </head>
  <body>
    <div class="header">
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <%if (headerStyle && !verTemplate.equalsIgnoreCase("0")) {%> <%@include
        file="../styletemplate/template_header.jsp" %> <%} else {%>
        <tr>
          <td
            ID="TOPTITLE"
            background="<%=approot%>/images/HRIS_HeaderBg3.jpg"
            width="100%"
            height="54"
          >
            <!-- #BeginEditable "header" -->
            <%@ include file = "../main/header.jsp" %>
            <!-- #EndEditable -->
          </td>
        </tr>
        <tr>
          <td bgcolor="#9BC1FF" height="15" ID="MAINMENU" valign="middle">
            <!-- #BeginEditable "menumain" -->
            <%@ include file = "../main/mnmain.jsp" %>
            <!-- #EndEditable -->
          </td>
        </tr>
        <tr>
          <td bgcolor="#9BC1FF" height="10" valign="middle">
            <table width="100%" bo rder="0" cellspacing="0" cellpadding="0">
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
                  background="<%=approot%>/images/harismaMenuLine1.jpg"
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
        <span id="menu_title"><strong>Kpi Target Detail Form</strong> <strong style="color:#333;"> / </strong>Target & Distribusi</span>
    </div>

    <div class="content-main">
        <div class="formstyle">
            <small class="fst-italic">note: data telah tersimpan jika baris berwarna hijau</small>
            <table class="tblStyle" style="width: 100%;">
                <thead>
                    <tr>
                        <td style="width: 5%; text-align: center"><strong>No</strong></td>
                        <td style="width: 55%; text-align: center"><strong>KPI</strong></td>
                        <td style="width: 10%; text-align: center"><strong>Periode</strong></td>
                        <td style="width: 10%; text-align: center"><strong>Periode Index</strong></td>
                        <td style="width: 10%; text-align: center"><strong>Target</strong></td>
                        <td style="width: 10%; text-align: center"><strong>Weight Value</strong></td>
                    </tr>
                </thead>
                <tbody>
                    <%
                        for(int i = 0; i < vKpiTargetDetail.size(); i++){
                            String isCompletedTarget = "";
                            KpiTargetDetail entKpiTargetDetail = (KpiTargetDetail) vKpiTargetDetail.get(i);
                            KPI_List entKpiList = PstKPI_List.fetchExc(entKpiTargetDetail.getKpiId());
                            if((entKpiTargetDetail.getAmount() > 0) && (entKpiTargetDetail.getPeriod() >= 0) && (entKpiTargetDetail.getWeightValue() > 0)){
                                isCompletedTarget = "style='background-color: #BDF5C3;'";
                            }
                    %>
                    <tr <%= isCompletedTarget %>>
                        <form name="<%= FrmKpiTargetDetail.FRM_NAME_KPI_TARGET_DETAIL %>" class="form-target-detail" id="formtargetdetail-<%= entKpiTargetDetail.getOID() %>">
                            <input type="hidden" name="<%= FrmKpiTargetDetail.fieldNames[FrmKpiTargetDetail.FRM_FIELD_KPI_TARGET_DETAIL_ID] %>" value="<%= entKpiTargetDetail.getOID() %>">
                            <td class="text-center"><%= i+1 %></td>
                            <td><strong><%= entKpiList.getKpi_title() %></strong></td>
                            <td class="text-center">
                                <%
                                    Vector periode_value = new Vector(1, 1);
                                    Vector periode_key = new Vector(1, 1);
                                    for (int j = 0; j < PstKpiTargetDetail.period.length; j++) {
                                        periode_key.add(PstKpiTargetDetail.period[j]);
                                        periode_value.add(String.valueOf(j));
                                    }
                                %>
                                <%=ControlCombo.draw(FrmKpiTargetDetail.fieldNames[FrmKpiTargetDetail.FRM_FIELD_PERIOD], "select-period", null, "" + entKpiTargetDetail.getPeriod(), periode_value, periode_key, "id='periode-"+entKpiTargetDetail.getOID()+"' data-placeholder='Select Group...'")%>
                            </td>
                            <td class="text-center"><input type="number" name="FRM_FIELD_PERIOD_INDEX" placeholder="Periode Index" class="ms-2 input-period-index" id="periodeindex-<%= entKpiTargetDetail.getOID() %>"></td>
                            <td class="text-center">
                                <input class="input-target-jumlah" type="text" name="<%= FrmKpiTargetDetail.fieldNames[FrmKpiTargetDetail.FRM_FIELD_AMOUNT] %>" value="<%= Math.round(entKpiTargetDetail.getAmount()) %>" placeholder="Target Jumlah" class="me-2" id="targetjumlah-<%= entKpiTargetDetail.getOID() %>">
                            </td>
                            <td class="text-center">
                                <div class="d-flex">
                                    <input class="input-weight-value me-2" type="text" name="<%= FrmKpiTargetDetail.fieldNames[FrmKpiTargetDetail.FRM_FIELD_WEIGHT_VALUE] %>" value="<%= Math.round(entKpiTargetDetail.getWeightValue()) %>" placeholder="Weight Value" id="weightvalue-<%= entKpiTargetDetail.getOID() %>">
                                    <div class="spinner-border spinner-border-sm" role="status" style="display: none;" id="loading-<%= entKpiTargetDetail.getOID() %>">
                                      <span class="visually-hidden">Loading...</span>
                                    </div>
                                </div>
                            </td>
                        </form>
                    </tr>

                    <tr>
                        <td>&nbsp;</td>
                        <td colspan="5">
                            <table class="tblStyle" style="width: 100%">
                                <tr>
                                    <td style="width: 5%; text-align: center" ><strong>No</strong></td>
                                    <td style="width: 10%; text-align: center"><strong>NRK</strong></td>
                                    <td style="width: 30%; text-align: center"><strong>Nama</strong></td>
                                    <td style="width: 30%; text-align: center"><strong>Satuan Kerja</strong></td>
                                    <td style="width: 10%; text-align: center"><strong>Bobot Distribusi</strong></td>
                                </tr>
                                <%
                                    Vector vKpiTargetDetailEmployee = PstKpiTargetDetailEmployee.list(0, 0, PstKpiTargetDetailEmployee.fieldNames[PstKpiTargetDetailEmployee.FLD_KPI_TARGET_DETAIL_ID] + " = " + entKpiTargetDetail.getOID(), "");
                                    for(int j = 0; j < vKpiTargetDetailEmployee.size(); j++){
                                        String isCompletedEmploye = "";
                                        KpiTargetDetailEmployee entKpiTargetDetailEmployee = (KpiTargetDetailEmployee) vKpiTargetDetailEmployee.get(j);
                                        Employee entEmployee = PstEmployee.fetchExc(entKpiTargetDetailEmployee.getEmployeeId());
                                        if(entKpiTargetDetailEmployee.getBobot() != 0){
                                            isCompletedEmploye = "style='background-color: #BDF5C3;'";
                                        }
                                %>
                                <tr <%= isCompletedEmploye %>>
                                    <form name="<%= FrmKpiTargetDetailEmployee.FRM_NAME_KPI_TARGET_DETAIL_EMPLOYEE %>" class="form-target-detail-employe" id="formtargetdetailemploye-<%= entKpiTargetDetailEmployee.getOID() %>">
                                        <input type="hidden" name="<%= FrmKpiTargetDetailEmployee.fieldNames[FrmKpiTargetDetailEmployee.FRM_FIELD_KPI_TARGET_DETAIL_EMPLOYEE_ID] %>" value="<%= entKpiTargetDetailEmployee.getOID() %>">
                                        <td><%= j+1 %></td>
                                        <td><%= entEmployee.getEmployeeNum() %></td>
                                        <td><%= entEmployee.getFullName() %></td>
                                        <td><%= PstEmployee.getDivisionName(entEmployee.getDivisionId()) %></td>
                                        <td>
                                            <div class="d-flex">
                                                <input type="number" name="<%= FrmKpiTargetDetailEmployee.fieldNames[FrmKpiTargetDetailEmployee.FRM_FIELD_BOBOT] %>" value="<%= Math.round(entKpiTargetDetailEmployee.getBobot()) %>" id="bobot-<%= entKpiTargetDetailEmployee.getOID() %>" class="input-bobot">
                                                <div class="spinner-border spinner-border-sm" role="status" style="display: none;" id="loading-<%= entKpiTargetDetailEmployee.getOID() %>">
                                                  <span class="visually-hidden">Loading...</span>
                                                </div>
                                            </div>
                                        </td>
                                    </form>
                                </tr>
                                <% } %>
                            </table>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
            <hr>
            <div class="d-flex justify-content-center">
                <a href="#" class="btn" style="color:#FFF;" id="btn-save">Simpan</a>
            </div>
        </div>
    </div>

    <script src="<%=approot%>/javascripts/jquery.js"></script>
    <script src="<%=approot%>/javascripts/datepicker/jquery.ui.core.js"></script>
    <script src="<%=approot%>/javascripts/datepicker/jquery.ui.widget.js"></script>
    <script src="<%=approot%>/javascripts/datepicker/jquery.ui.datepicker.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
  </body>
    <script
      src="../javascripts/chosen.jquery.js"
      type="text/javascript"
    ></script>
    <script src="<%=approot%>/styles/datatable/v1/jquery.dataTables.min.js"></script>
    <script type="text/javascript">      
        $("body").on("change", ".select-period, .input-period-index, .input-target-jumlah, .input-weight-value", function(e){
            let isReady = {};
            const targetDetailOID = $(this).attr("id").split("-")[1];
            const periode = parseInt($("#periode-"+targetDetailOID).val());
            const periodindex = parseInt($("#periodindex-"+targetDetailOID).val());
            const targetjumlah = parseInt($("#targetjumlah-"+targetDetailOID).val());
            const weightvalue = parseInt($("#weightvalue-"+targetDetailOID).val());
            
            if(periode < 0){
                isReady.periode = false;
            }
            if(periodindex <= 0){
                isReady.periodeindex = false;
            }
            if(targetjumlah <= 0){
                isReady.targetjumlah = false;
            }
            if(weightvalue <= 0){
                isReady.weightvalue = false;
            }
            if(Object.keys(isReady).length <= 0){
                const form = $("#formtargetdetail-"+targetDetailOID);
                $.ajax({
                  url: "<%= approot %>/AjaxKpiTargetDetailForm",
                  data: form.serialize(),
                  type: 'POST',
                  beforeSend: function() {
                        $("#loading-" + targetDetailOID).fadeIn("slow");
                  },
                  success: function(res) {
                        form.parent().css("background-color", "#BDF5C3");
                  },
                  error: function(err) {
                        form.parent().css("background-", "#F7D8D8");
                  },
                  complete: function() {
                        $("#loading-" + targetDetailOID).fadeOut("slow");
                  }
                });
            }
            
        });
        
        $("body").on("change", ".input-bobot", function(e){
            const targetDetailEmployeOID = $(this).attr("id").split("-")[1];
            const bobot = $(this).val();
            
            if(bobot > 0 && bobot !== ""){
                const form = $("#formtargetdetailemploye-"+targetDetailEmployeOID);
                $.ajax({
                  url: "<%= approot %>/AjaxKpiTargetDetailEmployeForm",
                  data: form.serialize(),
                  type: 'POST',
                  beforeSend: function() {
                        $("#loading-" + targetDetailEmployeOID).fadeIn("slow");
                  },
                  success: function(res) {
                        form.parent().css("background-color", "#BDF5C3");
                  },
                  error: function(err) {
                        form.parent().css("background-", "#F7D8D8");
                  },
                  complete: function() {
                        $("#loading-" + targetDetailEmployeOID).fadeOut("slow");
                  }
                });
            }
        });
        
        $("body").on("click", "#btn-save", function(e){
            e.preventDefault();
            alert("Data telah disimpan");
            location.reload();
        });
    </script>
  </body>
</html>

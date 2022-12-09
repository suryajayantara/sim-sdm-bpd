<%-- Document : kpi_setting_target Created on : Oct 12, 2022, 2:47:43 PM Author
: User --%> 
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
    
    KpiSettingList entKpiSettingList = PstKpiSettingList.fetchExc(oidKpiSettingList);
    KPI_List entKpiList = PstKPI_List.fetchExc(entKpiSettingList.getKpiListId());
    KpiSetting entKpiSetting = PstKpiSetting.fetchExc(entKpiSettingList.getKpiSettingId());
    Company entCompany = PstCompany.fetchExc(entKpiSetting.getCompanyId());
    
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
      <input
        type="hidden"
        name="<%=FrmKpiSettingList.fieldNames[FrmKpiSettingList.FRM_FIELD_KPI_SETTING_ID]%>"
      />
      <div class="box">
        <div class="content-main">
          <h6><%= entCompany.getCompany() %> - <%= entKpiList.getKpi_title() %></h6>
          <hr />
          <div>
            <div class="row">
              <div class="col">
                <div class="mb-3">
                  <label for="exampleInputEmail1">Judul Target</label>
                  <input
                    type="text"
                    class="form-control"
                    aria-label="Sizing example input"
                    aria-describedby="inputGroup-sizing-sm"
                  />
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
                  <select name="" id="periode-index" class="form-control">
                    
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
                  />
                </div>
              </div>
            </div>

            <div class="row">
              <div class="card">
                <div class="card-title">Posisi</div>
                <div class="card-body">
                  <div class="mb-3">
                    <span class="fw-bold">Divisi</span><br />
                    <input type="checkbox" />
                    <label class="me-2" for="">Cabang badung</label>

                    <input type="checkbox" />
                    <label class="me-2" for="">Cabang Denpasar</label>

                    <input type="checkbox" />
                    <label class="me-2" for="">Cabang Sanur</label>

                    <input type="checkbox" />
                    <label class="me-2" for="">Cabang Kuta</label>
                  </div>

                  <hr />

                  <div class="mb-3">
                    <span class="fw-bold">Departemen</span><br />
                    <input type="checkbox" />
                    <label class="me-2" for="">Cabang badung</label>

                    <input type="checkbox" />
                    <label class="me-2" for="">Cabang Denpasar</label>

                    <input type="checkbox" />
                    <label class="me-2" for="">Cabang Sanur</label>

                    <input type="checkbox" />
                    <label class="me-2" for="">Cabang Kuta</label>
                  </div>

                  <hr />

                  <div class="mb-3">
                    <span class="fw-bold">Section</span><br />
                    <input type="checkbox" />
                    <label class="me-2" for="">Cabang badung</label>

                    <input type="checkbox" />
                    <label class="me-2" for="">Cabang Denpasar</label>

                    <input type="checkbox" />
                    <label class="me-2" for="">Cabang Sanur</label>

                    <input type="checkbox" />
                    <label class="me-2" for="">Cabang Kuta</label>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <div class="d-flex justify-content-center mt-3">
            <button class="btn btn-primary" style="color: white">
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
        $(function(){
            const PERIOD_BULAN = <%= PstKpiTargetDetail.PERIOD_BULAN %>;
            const PERIOD_TRIWULAN = <%= PstKpiTargetDetail.PERIOD_TRIWULAN %>;
            const PERIOD_CATURWULAN = <%= PstKpiTargetDetail.PERIOD_CATURWULAN %>;
            const PERIOD_SEMESTER = <%= PstKpiTargetDetail.PERIOD_SEMESTER %>;
            const PERIOD_TAHUN = <%= PstKpiTargetDetail.PERIOD_TAHUN %>;
        
            $("body").on("change", "#periode", function(){
                const value = $(this).val();
                let periodeIndex = 0;
                let stringOption = "<option>~Pilih Periode Index~</option>";

                switch(parseInt(value)) {
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
                    stringOption += "<option value="+ i +">"+ (i + 1) +"</option>";
                }
                $("#periode-index").html(stringOption);
            });

            $("body").on("change", "#periode-index", function(){
                const value = $(this).val();
                const year = $("#tahun").val();
                const periode = $("#periode").val();
                let startMonth = null;
                let endMonth = null;
                let startDate = null;
                let endDate = null;
                
                switch(parseInt(periode)) {
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
        });
    </script>
  </body>
</html>

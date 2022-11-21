<%-- 
    Document   : kpi_emp_search
    Created on : Nov 27, 2019, 2:03:49 PM
    Author     : IanRizky
--%>
<%@page import="com.dimata.util.Command"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstKpiTargetDetailEmployee"%>
<%@page import="com.dimata.harisma.entity.masterdata.KpiTargetDetailEmployee"%>
<%@page import="com.dimata.qdep.form.FRMQueryString"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file = "../main/javainit.jsp" %>
<% //int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_DOKUMEN_SURAT, AppObjInfo.G2_MASTER_DOCUMENT, AppObjInfo.OBJ_DOCUMENT_MASTER);
    int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_REPORTS, AppObjInfo.G2_PRESENCE_REPORT, AppObjInfo.OBJ_PRESENCE_DAILY_REPORT);
%>
<%@ include file = "../main/checkuser.jsp" %>
<!DOCTYPE html>
<%    long oidTarget = FRMQueryString.requestLong(request, "targetId");
    long oidTargetDetail = FRMQueryString.requestLong(request, "oidTargetDetail");
    String[] empCheck = FRMQueryString.requestStringValues(request, "emp_check");
    long oidKpi = FRMQueryString.requestLong(request, "oidKPI");
    long oidInsert = 0;
    String appendData = "";
    boolean isSave = false;
    String kpiName = "";
    long oidKpiGroup = 0;
    KPI_Group kpiGroup = new KPI_Group();
    KpiTarget kpiTarget = new KpiTarget();
    KpiTargetDetail kpiTargetDetail = new KpiTargetDetail();
    
    if (empCheck != null) {
        for (int i = 0; i < empCheck.length; i++) {
            double empBobot = FRMQueryString.requestDouble(request, "emp_bobot_" + empCheck[i]);
            KpiTargetDetailEmployee employee = new KpiTargetDetailEmployee();
            employee.setKpiTargetDetailId(oidTargetDetail);
            employee.setEmployeeId(Long.valueOf(empCheck[i]));
            employee.setBobot(empBobot);
            try {
                oidInsert = PstKpiTargetDetailEmployee.insertExc(employee);
                Employee emp = new Employee();
                try {
                    emp = PstEmployee.fetchExc(employee.getEmployeeId());
                } catch (Exception exc) {

                }
                if (appendData.length() == 0) {
                    appendData += emp.getFullName() + " <a href=\\\"javascript:cmdDelete('" + oidInsert + "')\\\"> x </a>";
                } else {
                    appendData += ", " + emp.getFullName() + " <a href=\"javascript:cmdDelete('" + oidInsert + "')\"> x </a>";
                }
                isSave = true;
            } catch (Exception e) {
                System.out.println(e.toString());
            }
        }
    }

    if (oidKpi > 0) {
        KPI_List objKpiList = PstKPI_List.fetchExc(oidKpi);
        kpiName = objKpiList.getKpi_title();
    }
    
    if (oidTargetDetail > 0) {
        kpiTargetDetail = PstKpiTargetDetail.fetchExc(oidTargetDetail);
        oidKpiGroup = kpiTargetDetail.getKpiGroupId();

        if(oidKpiGroup > 0){
            kpiGroup =  PstKPI_Group.fetchExc(oidKpiGroup);
        }
    }

    String strDisable = "";
    long oidCompany = 0;
    long divisionId = 0;
    if (appUserSess.getAdminStatus() == 0) {
        oidCompany = emplx.getCompanyId();
        if (!privViewAllDivision) {
            divisionId = emplx.getDivisionId();
            strDisable = "disabled=\"disabled\"";
        }

    }

    String strUrl = "";
    strUrl = "'" + oidCompany + "',";
    strUrl += "'" + divisionId + "',";
    strUrl += "'0',";
    strUrl += "'0',";
    strUrl += "'frm_company_id',";
    strUrl += "'frm_division_id',";
    strUrl += "'frm_department_id',";
    strUrl += "'frm_section_id'";

    String whereClause = "";
    String order = "";
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Document Employee Search</title>
        <link rel="stylesheet" href="../styles/main.css" type="text/css">
        <style type="text/css">
            body {
                margin: 0;
                padding: 0;
                font-size: 12px;
                font-family: sans-serif;
            }
            .header {
                background-color: #EEE;
                padding: 21px;
                border-bottom: 1px solid #DDD;
            }
            .content {
                padding: 21px;
            }
            #caption, .caption {
                font-size: 12px;
                color: #474747;
                font-weight: bold;
                padding: 2px 0px 3px 0px;
            }
            #divinput, .divinput {
                margin-bottom: 5px;
                padding-bottom: 5px;
            }

            .btn {
                background-color: #00a1ec;
                border-radius: 3px;
                font-family: Arial;
                color: #EEE;
                font-size: 12px;
                padding: 7px 11px 7px 11px;
                text-decoration: none;
            }

            .btn:hover {
                color: #FFF;
                background-color: #007fba;
                text-decoration: none;
            }

            .item {
                background-color: #EEE;
                padding: 9px;
                margin: 9px 15px;
            }
        </style>
        <script type="text/javascript">

            <% if (isSave) {%>
            opener.location.href = '<%=approot%>/masterdata/KPI_target.jsp?targetId=<%=oidTarget%>&command=<%=Command.EDIT%>';
                close();
            <% }%>

                function loadCompany(
                        pCompanyId, pDivisionId, pDepartmentId, pSectionId,
                        frmCompany, frmDivision, frmDepartment, frmSection
                        ) {
                    var strUrl = "";
                    if (pCompanyId.length == 0) {
                        document.getElementById("div_result").innerHTML = "";
                        return;
                    } else {
                        var xmlhttp = new XMLHttpRequest();
                        xmlhttp.onreadystatechange = function () {
                            if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                                document.getElementById("div_result").innerHTML = xmlhttp.responseText;
                            }
                        };
                        strUrl = "company_structure.jsp";
                        strUrl += "?p_company_id=" + pCompanyId;
                        strUrl += "&p_division_id=" + pDivisionId;
                        strUrl += "&p_department_id=" + pDepartmentId;
                        strUrl += "&p_section_id=" + pSectionId;

                        strUrl += "&frm_company=" + frmCompany;
                        strUrl += "&frm_division=" + frmDivision;
                        strUrl += "&frm_department=" + frmDepartment;
                        strUrl += "&frm_section=" + frmSection;
                        xmlhttp.open("GET", strUrl, true);
                        xmlhttp.send();
                    }
                }

                function loadDivision(
                        companyId, frmCompany, frmDivision, frmDepartment, frmSection
                        ) {
                    var strUrl = "";
                    if (companyId.length == 0) {
                        document.getElementById("div_result").innerHTML = "";
                        return;
                    } else {
                        var xmlhttp = new XMLHttpRequest();
                        xmlhttp.onreadystatechange = function () {
                            if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                                document.getElementById("div_result").innerHTML = xmlhttp.responseText;
                            }
                        };
                        strUrl = "company_structure.jsp";

                        strUrl += "?company_id=" + companyId;

                        strUrl += "&frm_company=" + frmCompany;
                        strUrl += "&frm_division=" + frmDivision;
                        strUrl += "&frm_department=" + frmDepartment;
                        strUrl += "&frm_section=" + frmSection;
                        xmlhttp.open("GET", strUrl, true);

                        xmlhttp.send();
                    }
                }

                function loadDepartment(
                        companyId, divisionId, frmCompany,
                        frmDivision, frmDepartment, frmSection
                        ) {
                    var strUrl = "";
                    if ((companyId.length == 0) && (divisionId.length == 0)) {
                        document.getElementById("div_result").innerHTML = "";
                        return;
                    } else {
                        var xmlhttp = new XMLHttpRequest();
                        xmlhttp.onreadystatechange = function () {
                            if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                                document.getElementById("div_result").innerHTML = xmlhttp.responseText;
                            }
                        };
                        strUrl = "company_structure.jsp";

                        strUrl += "?company_id=" + companyId;
                        strUrl += "&division_id=" + divisionId;

                        strUrl += "&frm_company=" + frmCompany;
                        strUrl += "&frm_division=" + frmDivision;
                        strUrl += "&frm_department=" + frmDepartment;
                        strUrl += "&frm_section=" + frmSection;
                        xmlhttp.open("GET", strUrl, true);
                        xmlhttp.send();
                    }
                }

                function loadSection(
                        companyId, divisionId, departmentId,
                        frmCompany, frmDivision, frmDepartment, frmSection
                        ) {
                    var strUrl = "";
                    if ((companyId.length == 0) && (divisionId.length == 0) && (departmentId.length == 0)) {
                        document.getElementById("div_result").innerHTML = "";
                        return;
                    } else {
                        var xmlhttp = new XMLHttpRequest();
                        xmlhttp.onreadystatechange = function () {
                            if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                                document.getElementById("div_result").innerHTML = xmlhttp.responseText;
                            }
                        };
                        strUrl = "company_structure.jsp";

                        strUrl += "?company_id=" + companyId;
                        strUrl += "&division_id=" + divisionId;
                        strUrl += "&department_id=" + departmentId;

                        strUrl += "&frm_company=" + frmCompany;
                        strUrl += "&frm_division=" + frmDivision;
                        strUrl += "&frm_department=" + frmDepartment;
                        strUrl += "&frm_section=" + frmSection;
                        xmlhttp.open("GET", strUrl, true);
                        xmlhttp.send();
                    }
                }

        function cmdAppend() {        
                    opener.appendData("container_<%=oidTargetDetail%>", "<%=appendData%>"); // or opener.location.href = opener.location.href;
                    window.close(); // or self.close();
                }

                function pageLoad() {
            <%if (isSave) {%>
                    cmdAppend();
            <%} else {%>
                    loadCompany(<%=strUrl%>);
            <%}%>
                }

                function cmdSearch() {
                    var strUrl = "";
                    var empNum = document.getElementById("emp_num").value;
                    var empName = document.getElementById("emp_name").value;
                    var comp = document.getElementById("company").value;
                    var divi = document.getElementById("division").value;
                    var dept = document.getElementById("department").value;
                    var sect = document.getElementById("section").value;
                    var posi = document.getElementById("position").value;
                    var cate = document.getElementById("category").value;

                    var oidTargetDetail = document.getElementById("oidTargetDetail").value;

                    if (empNum.length == 0) {
                        empNum = "0";
                    }
                    if (empName.length == 0) {
                        empName = "0";
                    }

                    var xmlhttp = new XMLHttpRequest();
                    xmlhttp.onreadystatechange = function () {
                        if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                            document.getElementById("div_list").innerHTML = xmlhttp.responseText;
                        }
                    };
                    strUrl = "list_employee.jsp";
                    strUrl += "?company=" + comp;
                    strUrl += "&division=" + divi;
                    strUrl += "&department=" + dept;
                    strUrl += "&section=" + sect;

                    strUrl += "&position=" + posi;
                    strUrl += "&category=" + cate;
                    strUrl += "&emp_num=" + empNum;
                    strUrl += "&emp_name=" + empName;
                    strUrl += "&date_from =" + kpiTargetDetail.getDateFrom();
                    strUrl += "&date_to =" + kpiTargetDetail.getDateTo();

                    strUrl += "&oidTargetDetail=" + oidTargetDetail;

                    xmlhttp.open("GET", strUrl, true);
                    xmlhttp.send();
                }
                function check() {
                    document.getElementsByClassName("myC").checked = true;
                }

                function uncheck() {
                    document.getElementById("myCheck").checked = false;
                }
                function cmdGet() {
                    document.frm.action = "kpi_emp_search.jsp";
                    document.frm.submit();
                }

                function cmdGoToSurat(oidEmpDoc, objectName) {
                    document.frm.action = "search_app_letter.jsp?oid_emp_doc=" + oidEmpDoc + "&object_name=" + objectName;
                    document.frm.submit();
                }

        </script>
    </head>
    <body onload="pageLoad()">
        <div class="header">
            <h2 style="color:#999">Pencarian Karyawan</h2>
            <h4 style="color:#999">Kpi Group : <%=  kpiGroup.getGroup_title() %> </h4>
            <h4 style="color:#999">Kpi : <%= kpiName %> </h4>
            <%
                if (oidInsert != 0) {
            %>
            <div style="padding: 9px; background-color: #DDD;">Data Berhasil disimpan</div>
            <%
                }
            %>
        </div>
        <div class="content">
            <form name="frm" method="post" action="">
                <input type="hidden" id="oidTargetDetail" name="oidTargetDetail" value="<%= oidTargetDetail%>" />
                <input type="hidden" id="targetId" name="targetId" value="<%= oidTarget%>" />
                <table width="100%">
                    <tr>
                        <td valign="top" width="50%">
                            <div id="caption">Emp.Num</div>
                            <div id="divinput">
                                <input type="text" id="emp_num" name="emp_num" value="" size="50" />
                            </div>

                            <div id="caption">Nama</div>
                            <div id="divinput">
                                <input type="text" id="emp_name" name="emp_name" value="" size="50" />
                            </div>

                            <div id="div_result"></div>

                            <div id="caption">Jabatan</div>
                            <div id="divinput">
                                <select id="position" name="position">
                                    <%
                                        String[] pos = PstKpiListPosition.getKpiPosition(oidKpi);

                                        whereClause = PstPosition.fieldNames[PstPosition.FLD_VALID_STATUS] + "=";
                                        whereClause += PstPosition.VALID_ACTIVE;
                                        if (pos.length > 0) {
                                            String inWherePos = "";
                                            for (int i = 0; i < pos.length; i++) {
                                                if (i == 0) {
                                                    inWherePos = inWherePos + "'" + pos[i] + "'";
                                                } else {
                                                    inWherePos = inWherePos + ",'" + pos[i] + "'";
                                                }
                                            }
                                            whereClause += " AND " + PstPosition.fieldNames[PstPosition.FLD_POSITION_ID] + " IN (" + inWherePos + ")";
                                        } else {
                                    %><option value="0">-select-</option><%
                                                                                    }
                                                                                    order = PstPosition.fieldNames[PstPosition.FLD_POSITION];
                                                                                    Vector listPosition = PstPosition.list(0, 0, whereClause, order);
                                                                                    if (listPosition != null && listPosition.size() > 0) {
                                                                                        for (int i = 0; i < listPosition.size(); i++) {
                                                                                            Position jabatan = (Position) listPosition.get(i);
                                    %>
                                    <option value="<%= jabatan.getOID()%>"><%= jabatan.getPosition()%></option>
                                    <%
                                            }
                                        }
                                    %>
                                </select>
                            </div>

                            <div id="caption">Kategori</div>
                            <div id="divinput">
                                <select id="category" name="category">
                                    <option value="0">-select-</option>
                                    <%
                                        Vector listCategory = PstEmpCategory.list(0, 0, "", "");
                                        if (listCategory != null && listCategory.size() > 0) {
                                            for (int i = 0; i < listCategory.size(); i++) {
                                                EmpCategory category = (EmpCategory) listCategory.get(i);
                                    %>
                                    <option value="<%= category.getOID()%>"><%= category.getEmpCategory()%></option>
                                    <%
                                            }
                                        }
                                    %>
                                </select>
                            </div>
                            <div>&nbsp;</div>
                            <a class="btn" style="color:#FFF" href="javascript:cmdSearch()">Search</a>
                        </td>
                        <td valign="top" width="50">
                            <div id="div_list"></div>
                        </td>
                    </tr>
                </table>
            </form>
        </div>
    </body>
</html>

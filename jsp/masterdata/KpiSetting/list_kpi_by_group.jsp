<%-- 
    Document   : list_kpi_by_group
    Created on : Nov 18, 2022, 8:38:26 PM
    Author     : kadek
--%>
<%@page import="java.util.Vector"%>
<%@page import="com.dimata.harisma.form.masterdata.FrmKpiSettingList"%>
<%@page import="com.dimata.harisma.form.masterdata.FrmKPI_Group"%>
<%@page import="com.dimata.harisma.entity.log.ChangeValue"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file = "../../main/javainit.jsp" %>
<%    /* value of structure */
    long oidKpiGroup = FRMQueryString.requestLong(request, FrmKPI_Group.fieldNames[FrmKPI_Group.FRM_FIELD_KPI_GROUP_ID]);
    long oidKpiSettingList = FRMQueryString.requestLong(request, FrmKpiSettingList.fieldNames[FrmKpiSettingList.FRM_FIELD_KPI_SETTING_LIST_ID]);

    String oid_kpi[] = FRMQueryString.requestStringValues(request, "kpi");
    String oid_kpi_distribution[] = FRMQueryString.requestStringValues(request, "kpidistribution");

    Vector vKpiList = new Vector();
    Vector vKpiGroup = new Vector();
    String groupName = "";
    try {
        if (oidKpiGroup != 0) {
            // untuk mengambil data KPI List berdasarkan KPI grup
            String query = "hr_kpi_group.`KPI_GROUP_ID` = '" + oidKpiGroup + "'";
            vKpiList = PstKPI_List.listWithJoinGroup(query);

            // untuk mengambil data KPI grup
            String queryForGroup = "KPI_GROUP_ID = '" + oidKpiGroup + "'";
            vKpiGroup = PstKPI_Group.list(0, 1, queryForGroup, "");
            for (int i = 0; i < vKpiGroup.size(); i++) {
                KPI_Group objKpiGroup = (KPI_Group) vKpiGroup.get(i);
                groupName = objKpiGroup.getGroup_title();
            }
        }
    } catch (Exception e) {
    }
    if (vKpiList != null && vKpiList.size() > 0) {
%>
<%
    for (int i = 0; i < vKpiList.size(); i++) {
        KPI_List objKpiList = (KPI_List) vKpiList.get(i);
        boolean checked = false;
        if (oid_kpi != null) {
            for (int j = 0; j < oid_kpi.length; j++) {
                String oidKpiList = "" + objKpiList.getOID();
                if (oidKpiList.equals("" + oid_kpi[j])) {
                    checked = true;
                }
            }
        }

%>
<div class="item">
    <table>
        <tr>
            <td>
                <input value="<%= objKpiList.getOID()%>" name="<%=FrmKpiSettingList.fieldNames[FrmKpiSettingList.FRM_FIELD_KPI_LIST_ID]%>" type="checkbox" id="myCheck" checked="<%= checked %>">&nbsp;
            </td>
            <td>

                <div <%=checked%>><strong><%= objKpiList.getKpi_title()%></strong></div>
            </td>
        </tr>
    </table>
</div>
<%}%>
<div class="mt-3">
    <td>
        <label>Distribution</label>
        <select value="" name="<%=FrmKpiSettingList.fieldNames[FrmKpiSettingList.FRM_FIELD_KPI_DISTRIBUTION_ID]%>" style="width: 100%;" class="form-control form-control-sm custom-select">
            <%
                Vector listKpiDistribution = PstKpiDistribution.list(0, 0, "", "");
                for (int j = 0; j < listKpiDistribution.size(); j++) {
                    KpiDistribution objKpiDistribution = (KpiDistribution) listKpiDistribution.get(j);
                    String selected = "";
                    if (oid_kpi_distribution != null) {
                        for (int k = 0; k < oid_kpi_distribution.length; k++) {
                            String oidKpiDistribution = "" + objKpiDistribution.getOID();
                            if (oidKpiDistribution.equals("" + oid_kpi_distribution[k])) {
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
</div>
<%} else {
%>
Tidak Ada Data
<%
    }
%>




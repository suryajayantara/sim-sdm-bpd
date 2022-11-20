<%-- 
    Document   : list_kpi_by_group
    Created on : Nov 18, 2022, 8:38:26 PM
    Author     : kadek
--%>
<%@page import="com.dimata.harisma.form.masterdata.FrmKPI_Group"%>
<%@page import="com.dimata.harisma.entity.log.ChangeValue"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file = "../../main/javainit.jsp" %>
<%
    /* value of structure */
    long oidKpiGroup = FRMQueryString.requestLong(request, FrmKPI_Group.fieldNames[FrmKPI_Group.FRM_FIELD_KPI_GROUP_ID]);

    Vector vKpiList = new Vector();
    Vector vKpiGroup = new Vector();
    String groupName = "";
    try {
        if (oidKpiGroup != 0) {
            // untuk mengambil data KPI List berdasarkan KPI grup
            String query = "hr_kpi_group.`KPI_GROUP_ID` = '" + oidKpiGroup + "'";
            vKpiList = PstKPI_List.listWithJoinGroup(query);
            
            // untuk mengambil data KPI grup
            String queryForGroup = "KPI_GROUP_ID = '"+ oidKpiGroup +"'";
            vKpiGroup = PstKPI_Group.list(0, 1, queryForGroup, "");
            for(int i = 0; i < vKpiGroup.size(); i++){
                KPI_Group objKpiGroup = (KPI_Group) vKpiGroup.get(i);
                groupName = objKpiGroup.getGroup_title();
            }
        }
    } catch (Exception e) {
    }
%>

<%
    if (vKpiList != null && vKpiList.size()>0){
    %>
        <%
            for (int i = 0; i < vKpiList.size(); i++){
                KPI_List objKpiList = (KPI_List) vKpiList.get(i);
                %>
                <div class="item">
                    <table>
                        <tr>
                            <td>
                                <input type="checkbox" id="myCheck" name="KPI_ID" value="<%= objKpiList.getOID() %>" checked>&nbsp;
                            </td>
                            <td>
                                <div><strong><%= objKpiList.getKpi_title() %></strong></div>
                            </td>
                        </tr>
                    </table>
                </div>
                <%
            }
        } else {
        %>
    Tidak Ada Data
    <%
    }
%>

            


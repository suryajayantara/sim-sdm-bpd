<%-- 
    Document   : list_employe_by_target_id
    Created on : Dec 7, 2022, 4:48:16 PM
    Author     : kadek
--%>

<%@page import="com.dimata.harisma.entity.employee.Employee"%>
<%@page import="com.dimata.harisma.entity.masterdata.KpiTargetDetailEmployee"%>
<%@page import="com.dimata.util.Command"%>
<%@page import="com.dimata.harisma.entity.employee.PstEmployee"%>
<%@page import="java.util.Vector"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstKpiTargetDetailEmployee"%>
<%@page import="com.dimata.harisma.form.masterdata.FrmKpiTargetDetail"%>
<%@page import="com.dimata.qdep.form.FRMQueryString"%>
<%    /* value of structure */
    long oidKpiTargetDetail = FRMQueryString.requestLong(request, FrmKpiTargetDetail.fieldNames[FrmKpiTargetDetail.FRM_FIELD_KPI_TARGET_DETAIL_ID]);
    long detailId = FRMQueryString.requestLong(request, "detail_employee_id");
    int iCommand = FRMQueryString.requestCommand(request);
    String whereTargetDetailEmp = PstKpiTargetDetailEmployee.fieldNames[PstKpiTargetDetailEmployee.FLD_KPI_TARGET_DETAIL_ID] + "=" + oidKpiTargetDetail;
    Vector listEmployeeTarget = PstKpiTargetDetailEmployee.list(0, 0, whereTargetDetailEmp, "");

%>
<td colspan="2">&nbsp;</td>
<td colspan="3">
<table class="tblStyle" style="width: 100%">
    <tr>
        <td style="width: 5%; text-align: center" ><strong>No</strong></td>
        <td style="width: 10%; text-align: center"><strong>NRK</strong></td>
        <td style="width: 30%; text-align: center"><strong>Nama</strong></td>
        <td style="width: 30%; text-align: center"><strong>Satuan Kerja</strong></td>
        <td style="width: 10%; text-align: center"><strong>Bobot Distribusi</strong></td>
        <td style="width: 10%; text-align: center"><strong>Action</strong></td>
    </tr>
    <%
        int no = 0;
        for (int xx = 0; xx < listEmployeeTarget.size(); xx++) {
            no++;
            KpiTargetDetailEmployee kpiTargetDetailEmployee = (KpiTargetDetailEmployee) listEmployeeTarget.get(xx);
            Employee empDetail = new Employee();
            try {
                empDetail = PstEmployee.fetchExc(kpiTargetDetailEmployee.getEmployeeId());
            } catch (Exception exc) {
            }

    %>
    <tr>
        <td><%=no%></td>
        <td><%=empDetail.getEmployeeNum()%></td>
        <td><%=empDetail.getFullName()%></td>
        <td><%=PstEmployee.getDivisionName(empDetail.getDivisionId())%></td>
        <% if (iCommand == Command.EDIT && detailId == kpiTargetDetailEmployee.getOID()) {%>
        <td><input type='text' name='bobot' value='<%=kpiTargetDetailEmployee.getBobot()%>'></td>
        <td><a href="javascript:cmdSaveEmp('<%=kpiTargetDetailEmployee.getOID()%>')" class="btn-small-e" style="color:#FFF;">s</a> 
            <a href="javascript:cmdBackEmp('<%=kpiTargetDetailEmployee.getOID()%>')" class="btn-small-x" style="color:#FFF;">b</a></td>
            <% } else {%>
        <td><%=kpiTargetDetailEmployee.getBobot()%></td>
        <td style="text-align: center">
            <!--<a href="javascript:cmdEditEmp('<%=kpiTargetDetailEmployee.getOID()%>')" class="btn-small-e" style="color:#FFF;">e</a>--> 
            <a href="javascript:cmdDeleteEmp('<%=kpiTargetDetailEmployee.getOID()%>')" class="btn-small-x" style="color:#FFF;">x</a>
        </td>
            <% }  %>

    </tr>
    <%
        }
    %>
</table>

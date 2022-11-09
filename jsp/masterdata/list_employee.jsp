<%-- 
    Document   : list_employee
    Created on : Nov 27, 2019, 2:29:38 PM
    Author     : IanRizky
--%>
<%@page import="com.dimata.harisma.entity.log.ChangeValue"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file = "../main/javainit.jsp" %>
<%
/* value of structure */
long companyId = FRMQueryString.requestLong(request, "company");
long divisionId = FRMQueryString.requestLong(request, "division");
long departmentId = FRMQueryString.requestLong(request, "department");
long sectionId = FRMQueryString.requestLong(request, "section");

long positionId = FRMQueryString.requestLong(request, "position");
long empCategoryId = FRMQueryString.requestLong(request, "category");

String empNum = FRMQueryString.requestString(request, "emp_num");
String empName = FRMQueryString.requestString(request, "emp_name");

long oidTargetDetail = FRMQueryString.requestLong(request,"oidTargetDetail");
    
String whereClause = "";
ChangeValue changeValue = new ChangeValue();
Vector listWhere = new Vector();

    whereClause = " "+PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID]+" NOT IN (SELECT "+
            PstKpiTargetDetailEmployee.fieldNames[PstKpiTargetDetailEmployee.FLD_EMPLOYEE_ID]+" FROM "+
            PstKpiTargetDetailEmployee.TBL_KPI_TARGET_DETAIL_EMPLOYEE+" WHERE "
            + PstKpiTargetDetailEmployee.fieldNames[PstKpiTargetDetailEmployee.FLD_KPI_TARGET_DETAIL_ID]  +" = " +oidTargetDetail+ " )";
    listWhere.add(whereClause);
if (companyId != 0){
    whereClause = " "+PstEmployee.fieldNames[PstEmployee.FLD_COMPANY_ID]+"="+companyId;
    listWhere.add(whereClause);
}
if (divisionId != 0){
    whereClause = " "+PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID]+"="+divisionId;
    listWhere.add(whereClause);
}
if (departmentId != 0){
    whereClause = " "+PstEmployee.fieldNames[PstEmployee.FLD_DEPARTMENT_ID]+"="+departmentId;
    listWhere.add(whereClause);
}
if (sectionId != 0){
    whereClause = " "+PstEmployee.fieldNames[PstEmployee.FLD_SECTION_ID]+"="+sectionId;
    listWhere.add(whereClause);
}
if (positionId != 0){
    whereClause = " "+PstEmployee.fieldNames[PstEmployee.FLD_POSITION_ID]+"="+positionId;
    listWhere.add(whereClause);
}
if (empCategoryId != 0){
    whereClause = " "+PstEmployee.fieldNames[PstEmployee.FLD_EMP_CATEGORY_ID]+"="+empCategoryId;
    listWhere.add(whereClause);
}
if (empNum.length()>0 && !empNum.equals("0")){
    whereClause = " "+PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_NUM]+"='"+empNum+"'";
    listWhere.add(whereClause);
}
if (empName.length()>0 && !empName.equals("0")){
    whereClause = " "+PstEmployee.fieldNames[PstEmployee.FLD_FULL_NAME]+" LIKE '%"+empName+"'%";
    listWhere.add(whereClause);
}
if (listWhere != null && listWhere.size()>0){
    whereClause = "";
    for (int i=0; i<listWhere.size(); i++){
        String where = (String)listWhere.get(i);
        whereClause += where;
        if (i < (listWhere.size()-1)){
             whereClause += " AND ";
        }
    }
}
Vector listEmployee = PstEmployee.list(0, 0, whereClause, PstEmployee.fieldNames[PstEmployee.FLD_FULL_NAME]);
%>

<%
    if (listEmployee != null && listEmployee.size()>0){
        %>
        <input type="hidden" name="oidTargetDetail" value="<%= oidTargetDetail %>" />
        <%
        for (int i=0; i<listEmployee.size(); i++){
            Employee emp = (Employee)listEmployee.get(i);
            %>
            <div class="item">
                <table>
                    <tr>
                        <td>
                            <input type="checkbox" id="myCheck" name="emp_check" value="<%= emp.getOID() %>" />&nbsp;
                        </td>
                        <td>
                            <div><strong><%= emp.getEmployeeNum() %> | <%= emp.getFullName() %></strong></div>
                            <div><%= changeValue.getPositionName(emp.getPositionId())  %></div>
                        </td>
                        <td>
                            <input type="text" name="emp_bobot_<%=emp.getOID()%>" placeholder="Bobot Distribusi" />&nbsp;
                        </td>
                    </tr>
                </table>
            </div>
            <%
        }
        %>
        <div style="text-align: right; padding: 9px 15px;">
            <a class="btn" style="color:#FFF" href="javascript:check()">Check All</a>
            <a class="btn" style="color:#FFF" href="javascript:uncheck()">Uncheck All</a>
            <a class="btn" style="color:#FFF" href="javascript:cmdGet()">Get Data</a>
        </div>    
        <%
    } else {
    %>
    Tidak Ada Data
    <%
    }
%>

            

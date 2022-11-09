<%-- 
    Document   : list_employee
    Created on : Jan 19, 2017, 2:45:48 PM
    Author     : Dimata 007
--%>
<%@page import="com.dimata.harisma.entity.log.ChangeValue"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file = "../../main/javainit.jsp" %>
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

long oidEmpDoc = FRMQueryString.requestLong(request,"oid_emp_doc");
String objectName = FRMQueryString.requestString(request,"object_name");
ChangeValue changeValue = new ChangeValue();
String whereClause = "";
Vector listWhere = new Vector();
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
    whereClause = " "+PstEmployee.fieldNames[PstEmployee.FLD_FULL_NAME]+" LIKE'%"+empName+"%'";
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
        <input type="hidden" name="oid_emp_doc" value="<%= oidEmpDoc %>" />
        <input type="hidden" name="object_name" value="<%= objectName %>" />
        <%
        for (int i=0; i<listEmployee.size(); i++){
            Employee emp = (Employee)listEmployee.get(i);
            String divisionName = changeValue.getDivisionName(emp.getDivisionId());
            String departmentName = changeValue.getDepartmentName(emp.getDepartmentId());
            String sectionName = changeValue.getSectionName(emp.getSectionId());
            String positionName = changeValue.getPositionName(emp.getPositionId());
            %>
            <div class="item">
                <table>
                    <tr>
                        <td>
                            <div><strong><%= emp.getEmployeeNum() %> | <%= emp.getFullName() %></strong></div>
                            <div><%= changeValue.getPositionName(emp.getPositionId())  %></div>
                            <div>&nbsp;</div>
                            <div>
                                <a class="btn" style="color:#FFF" href="javascript:cmdGet('<%= emp.getOID() %>', '<%= emp.getEmployeeNum() %>','<%= emp.getFullName() %>','<%= divisionName %>','<%= departmentName %>','<%= sectionName %>','<%= positionName %>')">Ajukan Cuti</a>
                                <a class="btn" style="color:#FFF" href="javascript:cmdGoToList('<%= emp.getOID() %>')">Lihat Daftar Cuti</a>
                            </div>
                        </td>
                         <!--<td>
                           <input type="checkbox" id="myCheck" name="emp_check" value="<= emp.getOID() %>" />&nbsp;
                            
                        </td>-->
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
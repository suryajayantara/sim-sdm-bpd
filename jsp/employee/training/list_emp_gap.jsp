<%-- 
    Document   : list_emp_gap
    Created on : 15-Aug-2016, 14:19:53
    Author     : Acer
--%>


<%@page import="com.dimata.harisma.entity.log.ChangeValue"%>
<%@page import="com.dimata.harisma.entity.employee.TrainingHistory"%>
<%@page import="com.dimata.harisma.entity.employee.PstTrainingHistory"%>
<%@page import="com.dimata.harisma.entity.employee.Employee"%>
<%@page import="com.dimata.harisma.entity.employee.PstEmployee"%>
<%@page import="com.dimata.harisma.entity.masterdata.Position"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstPosition"%>
<%@page import="com.dimata.harisma.entity.masterdata.Level"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstLevel"%>
<%@page import="com.dimata.harisma.entity.masterdata.TrainType"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstTrainType"%>
<%@page import="com.dimata.harisma.entity.masterdata.Training"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstTraining"%>
<%@page import="java.util.Vector"%>
<%@page import="com.dimata.qdep.form.FRMQueryString"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
/* value of structure */
long companyId = FRMQueryString.requestLong(request, "company_id");
long divisionId = FRMQueryString.requestLong(request, "division_id");
long departmentId = FRMQueryString.requestLong(request, "department_id");
long sectionId = FRMQueryString.requestLong(request, "section_id");

long positionId = FRMQueryString.requestLong(request, "position_id");
long nrk = FRMQueryString.requestLong(request, "nrk");
long name = FRMQueryString.requestLong(request, "name");


Vector listEmployee = new Vector();
String whereClause = "";
String orderBy = PstEmployee.fieldNames[PstEmployee.FLD_FULL_NAME];
Vector<String> whereCollect = new Vector<String>();
Vector<String> whereCollectNotYet = new Vector<String>();
ChangeValue changeValue = new ChangeValue();

if (companyId != 0){
    whereClause = ""+PstEmployee.fieldNames[PstEmployee.FLD_COMPANY_ID]+"="+companyId;
    whereCollect.add(whereClause);
}
if (divisionId != 0){
    whereClause = ""+PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID]+"="+divisionId;
    whereCollect.add(whereClause);
}
if (departmentId != 0){
    whereClause = ""+PstEmployee.fieldNames[PstEmployee.FLD_DEPARTMENT_ID]+"="+departmentId;
    whereCollect.add(whereClause);
}
if (sectionId != 0){
    whereClause = ""+PstEmployee.fieldNames[PstEmployee.FLD_SECTION_ID]+"="+sectionId;
    whereCollect.add(whereClause);
}
if (positionId != 0){
    whereClause = ""+PstEmployee.fieldNames[PstEmployee.FLD_POSITION_ID]+"="+positionId;
    whereCollect.add(whereClause);
}
if (nrk != 0){
    whereClause = ""+PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_NUM]+"="+nrk;
    whereCollect.add(whereClause);
}
if (name != 0){
    whereClause = ""+PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_NUM]+"="+name;
    whereCollect.add(whereClause);
}
if (whereCollect != null && whereCollect.size()>0){
    whereClause = "";
    for (int i=0; i<whereCollect.size(); i++){
        String where = (String)whereCollect.get(i);
        whereClause += where;
        if (i < (whereCollect.size()-1)){
             whereClause += " AND ";
        }
    }
}

    listEmployee = PstEmployee.list(0, 0, whereClause, orderBy);


    if (listEmployee != null && listEmployee.size()>0){
        %>
        <table class="tblStyle">
        <tr>
            <td class="title_tbl">No</td>
            <td class="title_tbl">Emp. num</td>
            <td class="title_tbl">Nama Karyawan</td>
            <td class="title_tbl">Position</td>
            <td class="title_tbl">Action</td>
        </tr>
        <%
        for(int i=0; i<listEmployee.size(); i++){
            Employee emp = (Employee)listEmployee.get(i);
            
            Employee employee = new Employee();
            Position position = new Position();
            
            
            String empNum = "";
            String empName = "";
            String empPosition = "";
            String empLevel = "";
            String trType = "";
            try{
                employee = PstEmployee.fetchExc(emp.getOID());
                empNum = employee.getEmployeeNum();
                empName = employee.getFullName();
                position = PstPosition.fetchExc(employee.getPositionId());
                empPosition = position.getPosition();
                
                
            } catch (Exception exc){
                System.out.println("error"+exc);
            }
            %>
            <tr>
                <td><%= (i+1) %></td>
                <td><%= empNum %></td>
                <td><%= empName %></td>
                <td><%= empPosition %></td>
                <td><a class="btn-small-1" style="color:#575757;" href="javascript:cmdViewGap('<%=emp.getOID()%>')">View</a></td>
            </tr>
            <%
        }
        %>
        </table>
        <%
    }
 
%>

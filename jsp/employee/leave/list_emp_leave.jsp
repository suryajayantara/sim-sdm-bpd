<%-- 
    Document   : list_emp_leave
    Created on : 26-Aug-2016, 18:46:03
    Author     : Acer
--%>

<%@page import="com.dimata.harisma.entity.masterdata.PstDepartment"%>
<%@page import="com.dimata.harisma.entity.masterdata.Department"%>
<%@page import="com.dimata.harisma.entity.leave.LeaveApplication"%>
<%@page import="java.util.Hashtable"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstDivision"%>
<%@page import="com.dimata.harisma.entity.masterdata.Division"%>
<%@page import="com.dimata.harisma.entity.leave.PstLeaveApplication"%>
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
String[] oidDiv = FRMQueryString.requestStringValues(request, "division_id");
String[] oidDept = FRMQueryString.requestStringValues(request, "department_id");
String[] oidSec = FRMQueryString.requestStringValues(request, "section_id");

long positionId = FRMQueryString.requestLong(request, "position_id");
int year = FRMQueryString.requestInt(request, "year");
int category = FRMQueryString.requestInt(request, "category");
int empcategory = FRMQueryString.requestInt(request, "empcategory");

Vector listEmployeeLeave = new Vector();
Vector listEmployee = new Vector();

String whereTrain = "";
String whereClause = "";
String whereClauseEmp = "";
String orderBy = PstLeaveApplication.fieldNames[PstLeaveApplication.FLD_EMPLOYEE_ID];
Vector<String> whereCollect = new Vector<String>();
Vector<String> whereCollectEmp = new Vector<String>();
Hashtable<String, LeaveApplication> leaveMap = new Hashtable<String, LeaveApplication>();
ChangeValue changeValue = new ChangeValue();


if(category == 0){
    whereClauseEmp = " TLA.TYPE_LEAVE_CATEGORY = 3 ";
    whereCollect.add(whereClauseEmp);
} else if (category == 1){
    whereClauseEmp = " TLA.TYPE_LEAVE_CATEGORY = 4 ";
    whereCollect.add(whereClauseEmp);
}    
if (companyId != 0){
    whereClauseEmp = " EMP."+PstEmployee.fieldNames[PstEmployee.FLD_COMPANY_ID]+"="+companyId;
    whereCollect.add(whereClauseEmp);
    whereClause = PstEmployee.fieldNames[PstEmployee.FLD_COMPANY_ID]+"="+companyId;
    if(empcategory == 0 || empcategory == 1){
        whereCollectEmp.add(whereClauseEmp);
    } else {
        whereCollectEmp.add(whereClause);
    }
}

if (oidDiv != null){
    String inDiv = "";
    for (int i=0; i < oidDiv.length; i++){
        inDiv = inDiv + ","+ oidDiv[i];
    }
    inDiv = inDiv.substring(1);
    whereClauseEmp = " emp."+PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID]+" IN("+inDiv+")";
    whereCollect.add(whereClauseEmp);
    whereClause = PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID]+" IN ("+inDiv+")";
        if(empcategory == 0 || empcategory == 1){
        whereCollectEmp.add(whereClauseEmp);
    } else {
        whereCollectEmp.add(whereClause);
    }
}
if (oidDept != null){
    String inDept = "";
    for (int i=0; i < oidDept.length; i++){
        inDept = inDept + ","+ oidDept[i];
    }
    inDept = inDept.substring(1);
    whereClauseEmp = " emp."+PstEmployee.fieldNames[PstEmployee.FLD_DEPARTMENT_ID]+" IN ("+inDept+")";
    whereCollect.add(whereClauseEmp);
    whereClause = PstEmployee.fieldNames[PstEmployee.FLD_DEPARTMENT_ID]+" IN ("+inDept+")";
    if(empcategory == 0 || empcategory == 1){
        whereCollectEmp.add(whereClauseEmp);
    } else {
        whereCollectEmp.add(whereClause);
    }
}
if (oidSec != null){
    String inSec = "";
    for (int i=0; i < oidSec.length; i++){
        inSec = inSec + ","+ oidSec[i];
    }
    inSec = inSec.substring(1);
    whereClauseEmp = " emp."+PstEmployee.fieldNames[PstEmployee.FLD_SECTION_ID]+" IN ("+inSec+")";
    whereCollect.add(whereClauseEmp);
    whereClause = PstEmployee.fieldNames[PstEmployee.FLD_SECTION_ID]+" IN ("+inSec+")";
    if(empcategory == 0 || empcategory == 1){
        whereCollectEmp.add(whereClauseEmp);
    } else {
        whereCollectEmp.add(whereClause);
    }
}

if (positionId != 0){
    whereClauseEmp = " EMP."+PstEmployee.fieldNames[PstEmployee.FLD_POSITION_ID]+"="+positionId;
    whereCollect.add(whereClauseEmp);
    whereClause = PstEmployee.fieldNames[PstEmployee.FLD_POSITION_ID]+"="+positionId;
        if(empcategory == 0 || empcategory == 1){
        whereCollectEmp.add(whereClauseEmp);
    } else {
        whereCollectEmp.add(whereClause);
    }
}
if (year != 0){
    whereClauseEmp += " AND TLA.SUBMISSION_DATE BETWEEN '"+year+"-01-01' AND '"+year+"-12-31' ";
    whereCollect.add(whereClauseEmp);
}
if (whereCollect != null && whereCollect.size()>0){
    whereClauseEmp = "";
    for (int i=0; i<whereCollect.size(); i++){
        String where = (String)whereCollect.get(i);
        whereClauseEmp += where;
        if (i < (whereCollect.size()-1)){
             whereClauseEmp += " AND ";
        }
    }
}
if (whereClauseEmp.length() > 0){
    leaveMap = PstLeaveApplication.listEmployeeLeave(0, 0, whereClauseEmp, orderBy);
}

if (whereCollectEmp != null && whereCollectEmp.size()>0){
    whereClause = "";
    for (int i=0; i<whereCollectEmp.size(); i++){
        String where = (String)whereCollectEmp.get(i);
        whereClause += where;
        if (i < (whereCollectEmp.size()-1)){
             whereClause += " AND ";
        }
    }
}
if(empcategory == 2){
    listEmployee = PstEmployee.list(0, 0, whereClause, PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_NUM]);
} else {    
    if(category == 0){
        if (whereClause.equals("")){
            whereClause =  "AL.`AL_QTY` > 0 AND AL.`ENTITLE_DATE` BETWEEN '"+year+"-01-01' AND '"+year+"-12-31'";                        
        } else {
            whereClause =  "AL.`AL_QTY` > 0 AND AL.`ENTITLE_DATE` BETWEEN '"+year+"-01-01' AND '"+year+"-12-31' AND " + whereClause;            
        }

        listEmployee = PstEmployee.listEmployeeALEligible(0, 0, whereClause, PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_NUM]);
    } else if (category == 1){
        if (!(whereClause.equals(""))){
            whereClause = "LL.`LL_QTY` > 0 AND LL.`ENTITLE_DATE` BETWEEN '"+year+"-01-01' AND '"+year+"-12-31'";            
        } else {
            whereClause = "LL.`LL_QTY` > 0 AND LL.`ENTITLE_DATE` BETWEEN '"+year+"-01-01' AND '"+year+"-12-31' AND " + whereClause;            
        }

        listEmployee = PstEmployee.listEmployeeLLEligible(0, 0, whereClause, PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_NUM]);
    }    
}   
    


    if (listEmployee != null && listEmployee.size()>0){
        %>
        <table class="tblStyle">
        <tr>
            <td class="title_tbl">No</td>
            <td class="title_tbl">Emp. num</td>
            <td class="title_tbl">Nama Karyawan</td>
            <td class="title_tbl">Division</td>
            <td class="title_tbl">Department</td>
            <td class="title_tbl">Position</td>
            
            <% if(category == 0){ %>
            <td class="title_tbl">Cuti Tahunan</td>
            <% } else { %>
            <td class="title_tbl">Cuti Besar</td>
            <% } %>
        </tr>
        <%
        int jum = 0;
        for(int i=0; i<listEmployee.size(); i++){
            Employee emp = (Employee)listEmployee.get(i);
            
            Division div = new Division();
            Position position = new Position();
            Department dep =  new Department();
            
            String empId = String.valueOf(emp.getOID());
            String empDepartment = "";
            String empPosition = "";
            String empDivision = "";
            String trType = "";
            String status = "";
            LeaveApplication lv = new LeaveApplication();
            try{
                div = PstDivision.fetchExc(emp.getDivisionId());
                empDivision = div.getDivision();
                position = PstPosition.fetchExc(emp.getPositionId());
                empPosition = position.getPosition();
                dep = PstDepartment.fetchExc(emp.getDepartmentId());
                empDepartment = dep.getDepartment();
                
                lv = leaveMap.get(empId);
                
                if(category == 0){
                    if (lv != null &&  lv.getAlAllowance() == 1){
                        status = "<font color=\"#40FF00\">&#10004</font>";
                    } else {
                        status = "<font color=\"#FF0000\">&#10006</font>";
                    }
                } else {
                    if (lv != null &&  lv.getLlAllowance() == 1){
                        status = "<font color=\"#40FF00\">&#10004</font>";
                    } else {
                        status = "<font color=\"#FF0000\">&#10006</font>";
                    }
                }
            } catch (Exception exc){
                System.out.println("error"+exc);
            }
            
            if ( empcategory == 0){
                if(category == 0){
                    if (lv != null && lv.getAlAllowance() == 1){ 
                        jum = jum + 1;
                        %>
                       <tr>
                           <td><%= jum %></td>
                           <td><%= emp.getEmployeeNum() %></td>
                           <td><%= emp.getFullName() %></td>
                           <td><%= empDivision %></td>
                           <td><%= empDepartment %></td>
                           <td><%= empPosition %></td>
                           <td align="center"><%= status %></td>
                       </tr>
                       <%
                    }
                } else if (category == 1){  
                    if (lv != null && lv.getLlAllowance() == 1){
                        jum = jum + 1;
                        %>
                       <tr>
                           <td><%= jum %></td>
                           <td><%= emp.getEmployeeNum() %></td>
                           <td><%= emp.getFullName() %></td>
                           <td><%= empDivision %></td>
                           <td><%= empDepartment %></td>
                           <td><%= empPosition %></td>
                           <td align="center"><%= status %></td>
                       </tr>
                       <%
                    }
                }
            }
                 
            else if (empcategory == 1){
                if(category == 0){
                    if (lv == null || lv.getAlAllowance() == 0){ 
                        jum = jum + 1;
                        %>
                       <tr>
                           <td><%= jum %></td>
                           <td><%= emp.getEmployeeNum() %></td>
                           <td><%= emp.getFullName() %></td>
                           <td><%= empDivision %></td>
                           <td><%= empDepartment %></td>
                           <td><%= empPosition %></td>
                           <td align="center"><%= status %></td>
                       </tr>
                       <%
                    }
                } else if (category == 1){  
                    if (lv == null || lv.getLlAllowance() == 0){
                        jum = jum + 1;
                        %>
                       <tr>
                           <td><%= jum %></td>
                           <td><%= emp.getEmployeeNum() %></td>
                           <td><%= emp.getFullName() %></td>
                           <td><%= empDivision %></td>
                           <td><%= empDepartment %></td>
                           <td><%= empPosition %></td>
                           <td align="center"><%= status %></td>
                       </tr>
                       <%
                    }
                }  
            } else {
            jum = jum + 1;
            %>
            <tr>
                <td><%= jum %></td>
                <td><%= emp.getEmployeeNum() %></td>
                <td><%= emp.getFullName() %></td>
                <td><%= empDivision %></td>
                <td><%= empDepartment %></td>
                <td><%= empPosition %></td>
                <td align="center"><%= status %></td>
            </tr>
            <% }
        }
        %>
        </table>
        <%
    } else {
%>
<h>No Employee Eligible</h>
<%  } %>

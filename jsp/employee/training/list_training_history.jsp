<%-- 
    Document   : list_training_history
    Created on : Aug 15, 2016, 3:36:15 PM
    Author     : Dimata 007
--%>

<%@page import="com.dimata.harisma.entity.employee.PstTrainingActivityActual"%>
<%@page import="com.dimata.harisma.entity.employee.TrainingActivityActual"%>
<%@page import="com.dimata.harisma.entity.log.ChangeValue"%>
<%@page import="com.dimata.harisma.entity.employee.PstTrainingHistory"%>
<%@page import="com.dimata.harisma.entity.employee.Employee"%>
<%@page import="com.dimata.harisma.entity.employee.PstEmployee"%>
<%@page import="java.util.Vector"%>
<%@page import="com.dimata.qdep.form.FRMQueryString"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
/* value of structure */
long companyId = FRMQueryString.requestLong(request, "company_id");
long divisionId = FRMQueryString.requestLong(request, "division_id");
long departmentId = FRMQueryString.requestLong(request, "department_id");
long sectionId = FRMQueryString.requestLong(request, "section_id");
String empName = FRMQueryString.requestString(request, "emp_name");
String empNum = FRMQueryString.requestString(request, "emp_num");

Vector listEmployee = new Vector();
Vector listTrainingHistory = new Vector();
String whereClauseEmp = "";
String whereTrain = "";
String whereClause = "";
Vector<String> whereCollect = new Vector<String>();
ChangeValue changeValue = new ChangeValue();

if (companyId != 0){
    whereClauseEmp = " "+PstEmployee.fieldNames[PstEmployee.FLD_COMPANY_ID]+"="+companyId;
    whereCollect.add(whereClauseEmp);
}
if (divisionId != 0){
    whereClauseEmp = " "+PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID]+"="+divisionId;
    whereCollect.add(whereClauseEmp);
}
if (departmentId != 0){
    whereClauseEmp = " "+PstEmployee.fieldNames[PstEmployee.FLD_DEPARTMENT_ID]+"="+departmentId;
    whereCollect.add(whereClauseEmp);
}
if (sectionId != 0){
    whereClauseEmp = " "+PstEmployee.fieldNames[PstEmployee.FLD_SECTION_ID]+"="+sectionId;
    whereCollect.add(whereClauseEmp);
}
if (empName.length() > 1){
    whereClauseEmp = " "+PstEmployee.fieldNames[PstEmployee.FLD_FULL_NAME]+" LIKE '%"+empName+"%'";
    whereCollect.add(whereClauseEmp);
}
if (empNum.length() > 1){
    whereClauseEmp = " "+PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_NUM]+"='"+empNum+"'";
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
    listEmployee = PstEmployee.list(0, 0, whereClauseEmp, "");
    whereClauseEmp = "";
    if (listEmployee != null && listEmployee.size()>0){
        for(int e=0; e<listEmployee.size(); e++){
            Employee emp = (Employee)listEmployee.get(e);
            whereClauseEmp += emp.getOID()+",";
        }
        whereClauseEmp = whereClauseEmp.substring(0, whereClauseEmp.length()-1);
    }
    //listTrainingHistory = PstTrainingHistory.listJoinEmpTrainingVersi1(whereClauseEmp);
}
String whereInEmp = "";
%>

<%
    if (listEmployee.size()>0){
        for (int x=0; x< listEmployee.size();x++){
            Employee emp = (Employee) listEmployee.get(x);
            listTrainingHistory = PstTrainingHistory.listJoinEmpTrainingVersi1(""+emp.getOID());
            if (listTrainingHistory.size()>0){
%>
            <table border="0">
                <tr>
                    <td style="font-size:12px"><strong>NRK</strong></td>
                    <td style="font-size:12px"><strong>:</strong></td>
                    <td style="font-size:12px"><strong><%=emp.getEmployeeNum()%></strong></td>
                    <td style="font-size:12px">&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</td>
                    <td style="font-size:12px"><strong>Satuan Kerja</strong></td>
                    <td style="font-size:12px"><strong>:</strong></td>
                    <td style="font-size:12px"><strong><%=PstEmployee.getDivisionName(emp.getDivisionId())%></strong></td>
                </tr>
                <tr>
                    <td style="font-size:12px"><strong>Nama</strong></td>
                    <td style="font-size:12px"><strong>:</strong></td>
                    <td style="font-size:12px"><strong><%=emp.getFullName()%></strong></td>
                    <td style="font-size:12px">&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</td>
                    <td style="font-size:12px"><strong>Unit</strong></td>
                    <td style="font-size:12px"><strong>:</strong></td>
                    <td style="font-size:12px"><strong><%=PstEmployee.getDepartmentName(emp.getDepartmentId())%></strong></td>
                </tr>
                <tr>
                    <td style="font-size:12px"><strong>Jabatan</strong></td>
                    <td style="font-size:12px"><strong>:</strong></td>
                    <td style="font-size:12px"><strong><%=PstEmployee.getPositionName(emp.getPositionId())%></strong></td>
                    <td style="font-size:12px">&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</td>
                    <td style="font-size:12px"><strong>Level</strong></td>
                    <td style="font-size:12px"><strong>:</strong></td>
                    <td style="font-size:12px"><strong><%=PstEmployee.getLevelName(emp.getLevelId())%></strong></td>
                </tr>
            </table>
            <table class="tblStyle">
                <tr>
                    <td class="title_tbl">No</td>
                    <td class="title_tbl">Satuan Kerja</td>
                    <td class="title_tbl">Judul Pelatihan</td>
                    <td class="title_tbl">Program Pelatihan</td>
                    <td class="title_tbl">Tanggal Pelaksana</td>
                    <td class="title_tbl">Tempat</td>
                    <td class="title_tbl">Penyelengara</td>
                </tr>
                <%
                
                if (listTrainingHistory != null && listTrainingHistory.size()>0){
                    for (int i=0; i < listTrainingHistory.size(); i++){
                        String[] data = (String[])listTrainingHistory.get(i);
                        TrainingActivityActual actual = new TrainingActivityActual();
                        try {
                            actual = PstTrainingActivityActual.fetchExc(Long.valueOf(data[6]));
                        } catch(Exception e){
                            System.out.print("=>"+e.toString());
                        }
                %>
                <tr>
                    <td style="background-color: #FFF"><%=(i+1)%></td>
                    <td style="background-color: #FFF"><%= changeValue.getDivisionName(Long.valueOf(data[2])) %></td>
                    <td style="background-color: #FFF"><%= data[4] %></td>
                    <td style="background-color: #FFF"><%= data[5] %></td>
                    <td style="background-color: #FFF"><%= data[7] %></td>
                    <td style="background-color: #FFF"><%= actual.getVenue() %></td>
                    <td style="background-color: #FFF"><%= data[8] %></td>
                </tr>
                <% }
                }
                %>
            </table>
<%
            }
        }
    }
%>

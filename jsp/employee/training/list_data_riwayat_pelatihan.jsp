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
String startDate = FRMQueryString.requestString(request, "start_date");
String endDate = FRMQueryString.requestString(request, "end_date");

Vector listEmployee = new Vector();
Vector listTrainingHistory = new Vector();
String whereClauseEmp = "";
String whereTrainHistory = "";
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
if (startDate.length() > 0 && startDate.length() > 0){
    whereTrainHistory = " AND (( "+PstTrainingHistory.TBL_HR_TRAINING_HISTORY+"."+PstTrainingHistory.fieldNames[PstTrainingHistory.FLD_START_DATE]+" BETWEEN  '"+startDate+"' AND  '"+endDate+"' ) OR ";
    whereTrainHistory += " ( "+PstTrainingHistory.TBL_HR_TRAINING_HISTORY+"."+PstTrainingHistory.fieldNames[PstTrainingHistory.FLD_END_DATE]+" BETWEEN  '"+startDate+"' AND  '"+endDate+"' ) ) ";
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
    int count = 1;
    %>
                    
    <div style="font-size: 16px; font-weight: bold; padding: 3px 5px; border-left: 1px solid #007fba;" >Daftar hasil pencarian 
             <a href="javascript:cmdPrint()" class="btn" style="color:#FFF; float: right;">Print Excel</a>
    </div> 
    <br>
   
    
    <table id="resutdata" name="resultdata" class="tblStyle" style="width: 100%">
       
        <thead> 
            
        
                <tr>
                    <td class="title_tbl">No</td>
                    <td class="title_tbl">Nomor Induk Pegawai (NIP) </td>
                    <td class="title_tbl">Nomor Identitas</td>
                    <td class="title_tbl">Jenis Pelatihan/Sertifikasi</td>
                    <td class="title_tbl">TITLE</td>
                    <td class="title_tbl">TANGGAL MULAI</td>
                    <td class="title_tbl">TANGGAL SELESAI</td>
                    <td class="title_tbl">Nama Institusi Penyelenggara</td>
                    <td class="title_tbl">TRAINING PROGRAM</td>
                    <td class="title_tbl">REMARK</td>
                </tr>
        </thead>
    <tbody>

<%
    if (listEmployee.size()>0){
        for (int x=0; x< listEmployee.size();x++){
            Employee emp = (Employee) listEmployee.get(x);
            listTrainingHistory = PstTrainingHistory.listJoinEmpTrainingVersi2(""+emp.getOID(),whereTrainHistory);
            if (listTrainingHistory.size()>0){
%>
<!--            <table border="0">
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
            </table>-->
         
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
                    <td style="background-color: #FFF"><%=(count++)%></td>
                    <td style="background-color: #FFF"><%=emp.getEmployeeNum()%></td>
                    <td style="background-color: #FFF"><%=emp.getIndentCardNr()%></td>
                    <%if(data[7] != null){ %>
                    <td style="background-color: #FFF"><%=data[7]%></td>
                    <%}else{%>
                    <td style="background-color: #FFF">-</td>
                    <%}%>
                    <td style="background-color: #FFF"><%=data[4]%></td>
                    <td style="background-color: #FFF"><%=String.valueOf(data[8])%></td>
                    <td style="background-color: #FFF"><%=String.valueOf(data[9])%></td>
                    <td style="background-color: #FFF"><%=actual.getTrainner() %></td>
                    <td style="background-color: #FFF"><%=data[5] %></td>
                    <td style="background-color: #FFF"><%=data[10] %></td>
                   
                </tr>
                <% }
                }
                %>
             
            
<%
            }

    }


    }

 
%>
    </tbody>
    <script>
     
        </script>

 </table>
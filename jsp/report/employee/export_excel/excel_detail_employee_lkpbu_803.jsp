<%-- 
    Document   : excel_detail_employee_lkpbu_803
    Created on : 20-Oct-2017, 10:37:09
    Author     : Gunadi
--%>
<%@page import="com.dimata.qdep.form.FRMQueryString"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstDivision"%>
<%@page import="com.dimata.harisma.entity.masterdata.Division"%>
<%@page import="com.dimata.harisma.entity.employee.PstEmployee"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstEducation"%>
<%@page import="com.dimata.harisma.entity.masterdata.Education"%>
<%@page import="com.dimata.harisma.entity.employee.EmpEducation"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstPosition"%>
<%@page import="com.dimata.harisma.entity.report.lkpbu.Lkpbu"%>
<%@page import="com.dimata.util.Formater"%>
<%@page import="com.dimata.harisma.entity.masterdata.EmpCategory"%>
<%@page import="com.dimata.harisma.entity.masterdata.Position"%>
<%@page import="com.dimata.harisma.entity.employee.Employee"%>
<%@page import="java.util.Vector"%>
<%@page import="com.dimata.harisma.entity.report.lkpbu.PstLkpbu"%>
<%
response.setHeader("Content-Disposition","attachment; filename=lkpbu_803_detail.xls ");
    int year = FRMQueryString.requestInt(request,"year");
    Vector listLkpbu803 = PstLkpbu.listEmployeee803(year);
    if (listLkpbu803.size() == 0){
       listLkpbu803 = PstLkpbu.listCurrentEmployeee803(year);
    }

%>
<%@page contentType="application/vnd.ms-excel" pageEncoding="UTF-8"%><!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <% if (listLkpbu803.size()> 0) { 
        %>
        <table border="1">
            <tr>
                <td>NRK</td>
                <td>Nama</td>
                <td>Satuan Kerja</td>
                <td>Kategori</td>
                <td>Code</td>
                <td>Umur</td>
                <td>Code</td>
                <td>Jabatan</td>
                <td>Jenis Jabatan</td>
                <td>Code</td>
                <td>Pendidikan Terakhir</td>
                <td>Code</td>
                <td>Jenis Pekerjaan</td>
                <td>Code</td>
                <td>Jenis Kelamin</td>
                <td>Code</td>
            </tr>
            <%
                for (int i=0; i <listLkpbu803.size(); i++){
                    Vector temp = (Vector) listLkpbu803.get(i);
                    Employee employee = (Employee) temp.get(0);
                    Position pos = (Position) temp.get(1);
                    EmpCategory empCat = (EmpCategory) temp.get(2);
                    EmpEducation empEducation = (EmpEducation) temp.get(3);
                    Division div = (Division) temp.get(4);
                    
                    String date=Formater.formatDate(employee.getBirthDate(),"yyyy");
                    int ageInt = Integer.parseInt(date);
                    int age = 2016 - ageInt;
                    String codeUsia = (String) temp.get(5);
                    
                    Education education = new Education();
                    try {
                        education = PstEducation.fetchExc(empEducation.getEducationId());
                    } catch (Exception exc){}
                    
            %>
            <tr>
                <td>="<%=employee.getEmployeeNum()%>"</td>
                <td><%=employee.getFullName()%></td>
                <td><%=div.getDivision()%></td>
                <td><%=empCat.getEmpCategory()%></td>
                <td><%=empCat.getCode()%></td>
                <td><%=age%></td>
                <td><%=codeUsia%></td>
                <td><%=pos.getPosition()%></td>
                <td><%=PstPosition.strJenisJabatan[pos.getJenisJabatan()]%></td>
                <td><%=PstPosition.strJenisJabatanInt[pos.getJenisJabatan()]%></td>
                <td><%=education.getEducation()%></td>
                <td><%=education.getKode()%></td>
                <td><%=PstPosition.strTenagaKerja[pos.getTenagaKerja()]%></td>
                <td><%=PstPosition.strTenagaKerjaint[pos.getTenagaKerja()]%></td>
                <td><%=PstEmployee.sexKey[employee.getSex()]%></td>
                <td><%=employee.getSex()%></td>
            </tr>
            <%
                }
            %>
        </table>
        <%  } %>
    </body>
</html>

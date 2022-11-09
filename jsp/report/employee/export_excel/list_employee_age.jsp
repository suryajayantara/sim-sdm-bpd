<%-- 
    Document   : list_employee_age
    Created on : Apr 9, 2019, 11:13:00 AM
    Author     : Dimata 007
--%>

<%@page import="com.dimata.harisma.entity.masterdata.PstDivision"%>
<%@page import="com.dimata.harisma.entity.masterdata.Division"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstLevel"%>
<%@page import="com.dimata.harisma.entity.masterdata.Level"%>
<%@page import="org.apache.commons.lang.ArrayUtils"%>
<%@page import="com.dimata.harisma.entity.employee.PstEmployee"%>
<%@page import="com.dimata.util.Command"%>
<%@page import="com.dimata.harisma.entity.employee.Employee"%>
<%@page import="java.util.Vector"%>
<%@page import="com.dimata.util.Formater"%>
<%@page import="java.util.Date"%>
<%@page import="com.dimata.qdep.form.FRMQueryString"%>
<%@page import="com.dimata.gui.jsp.ControlCombo"%>
<%@page contentType="application/vnd.ms-excel" pageEncoding="UTF-8"%>

<%//
    int iCommand = FRMQueryString.requestCommand(request);
    String empNumber = FRMQueryString.requestString(request, "emp_number");
    String empName = FRMQueryString.requestString(request, "full_name");
    long oidComp = FRMQueryString.requestLong(request, "company_id");
    String[] oidDiv = FRMQueryString.requestStringValues(request, "division_id");
    String[] oidDept = FRMQueryString.requestStringValues(request, "department");
    String[] oidSec = FRMQueryString.requestStringValues(request, "section");
    String dateFrom = FRMQueryString.requestString(request, "date_from");
    String dateTo = FRMQueryString.requestString(request, "date_to");
    int usia = FRMQueryString.requestInt(request, "age");
    String[] range = FRMQueryString.requestStringValues(request, "range");
    int includeResign = FRMQueryString.requestInt(request, "resign");

    if (dateFrom.isEmpty()) {
        dateFrom = Formater.formatDate(new Date(), "yyyy-MM-dd");
    }

    if (dateTo.isEmpty()) {
        dateTo = Formater.formatDate(new Date(), "yyyy-MM-dd");
    }

    if (range == null) {
        range = new String[1];
        range[0] = "0";
    }

    Vector<String> whereCollect = new Vector();
    String whereClauseEmp = "";
    Vector<Employee> listEmployee = new Vector();

    if (iCommand == Command.LIST) {

        if (!empNumber.equals("")) {
            whereClauseEmp = PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_NUM] + " = '" + empNumber + "'";
            whereCollect.add(whereClauseEmp);
        }

        if (!empName.equals("")) {
            whereClauseEmp = PstEmployee.fieldNames[PstEmployee.FLD_FULL_NAME] + " = '" + empName + "'";
            whereCollect.add(whereClauseEmp);
        }

        if (oidComp != 0) {
            whereClauseEmp = PstEmployee.fieldNames[PstEmployee.FLD_COMPANY_ID] + " = '" + oidComp + "'";
            whereCollect.add(whereClauseEmp);
        }

        if (oidDiv != null) {
            String inDiv = "";
            for (int i = 0; i < oidDiv.length; i++) {
                inDiv = inDiv + "," + oidDiv[i];
            }
            inDiv = inDiv.substring(1);
            whereClauseEmp = PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID] + " IN (" + inDiv + ")";
            whereCollect.add(whereClauseEmp);
        }

        if (oidDept != null) {
            String inDept = "";
            for (int i = 0; i < oidDept.length; i++) {
                inDept = inDept + "," + oidDept[i];
            }
            inDept = inDept.substring(1);
            whereClauseEmp = PstEmployee.fieldNames[PstEmployee.FLD_DEPARTMENT_ID] + " IN (" + inDept + ")";
            whereCollect.add(whereClauseEmp);
        }

        if (oidSec != null) {
            String inSec = "";
            for (int i = 0; i < oidSec.length; i++) {
                inSec = inSec + "," + oidSec[i];
            }
            inSec = inSec.substring(1);
            whereClauseEmp = PstEmployee.fieldNames[PstEmployee.FLD_SECTION_ID] + " IN (" + inSec + ")";
            whereCollect.add(whereClauseEmp);
        }

        if (!dateFrom.isEmpty()) {
            try {
                whereClauseEmp = "";
                if (ArrayUtils.contains(range, "0")) {
                    whereClauseEmp = "TIMESTAMPDIFF(YEAR, " + PstEmployee.fieldNames[PstEmployee.FLD_BIRTH_DATE] + ", '" + dateFrom + "') = " + usia;
                }
                if (ArrayUtils.contains(range, "1")) {
                    whereClauseEmp += whereClauseEmp.isEmpty() ? "" : " OR ";
                    whereClauseEmp += "TIMESTAMPDIFF(YEAR, " + PstEmployee.fieldNames[PstEmployee.FLD_BIRTH_DATE] + ", '" + dateFrom + "') < " + usia;
                }
                if (ArrayUtils.contains(range, "2")) {
                    whereClauseEmp += whereClauseEmp.isEmpty() ? "" : " OR ";
                    whereClauseEmp += "TIMESTAMPDIFF(YEAR, " + PstEmployee.fieldNames[PstEmployee.FLD_BIRTH_DATE] + ", '" + dateFrom + "') > " + usia;
                }
                whereClauseEmp = "(" + whereClauseEmp + ")";
                whereCollect.add(whereClauseEmp);
            } catch (Exception e) {
                System.out.println(e.getMessage());
            }
        }

        /*
         if (!dateTo.isEmpty()) {
         try {
         Date dEnd = Formater.formatDate(dateTo, "yyyy-MM-dd");
         Calendar cal = Calendar.getInstance();
         cal.setTime(dEnd);
         cal.add(Calendar.YEAR, -usia);
         Date newEnd = cal.getTime();
         whereClauseEmp = PstEmployee.fieldNames[PstEmployee.FLD_BIRTH_DATE] + " <= '" + Formater.formatDate(newEnd, "yyyy-MM-dd") + "'";
         whereCollect.add(whereClauseEmp);
         } catch (Exception e) {
         System.out.println(e.getMessage());
         }
         }
         */
        
        if (includeResign == 0) {
            whereClauseEmp = PstEmployee.fieldNames[PstEmployee.FLD_RESIGNED] + " = " + includeResign;
            whereCollect.add(whereClauseEmp);
        }
        
        if (whereCollect != null && whereCollect.size() > 0) {
            whereClauseEmp = "";
            for (int i = 0; i < whereCollect.size(); i++) {
                String where = (String) whereCollect.get(i);
                whereClauseEmp += where;
                if (i < (whereCollect.size() - 1)) {
                    whereClauseEmp += " AND ";
                }
            }
        }

        String order = PstEmployee.fieldNames[PstEmployee.FLD_FULL_NAME];
        listEmployee = PstEmployee.list(0, 0, whereClauseEmp, order);
    }
    
    response.setHeader("Content-Disposition","attachment; filename=laporan_karyawan_berdasarkan_usia.xls ");
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <table class="tblStyle" border="1" id="table">
            <tr>
                <td colspan="7"><strong>Laporan Karyawan Berdasarkan Usia Per Tanggal <%= dateFrom %></strong></td>
            </tr>
            <tr>
                <td class="title_tbl" style="text-align:center; vertical-align:middle">No</td>
                <td class="title_tbl" style="text-align:center; vertical-align:middle">NRK</td>
                <td class="title_tbl" style="text-align:center; vertical-align:middle">Nama</td>
                <td class="title_tbl" style="text-align:center; vertical-align:middle">Jabatan</td>
                <td class="title_tbl" style="text-align:center; vertical-align:middle">Divisi</td>
                <td class="title_tbl" style="text-align:center; vertical-align:middle">Tanggal Lahir</td>
                <td class="title_tbl" style="text-align:center; vertical-align:middle">Usia</td>
            </tr>
            <%                        int No = 0;
                for (Employee emp : listEmployee) {
                    Level lvl = new Level();
                    try {
                        lvl = PstLevel.fetchExc(emp.getLevelId());
                    } catch (Exception exc) {
                    }

                    Division div = new Division();
                    try {
                        div = PstDivision.fetchExc(emp.getDivisionId());
                    } catch (Exception exc) {
                    }

                    int age = PstEmployee.getEmployeeAgePerDate(emp.getOID(), Formater.formatDate(dateFrom, "yyyy-MM-dd"));

                    String bgColor = "";
                    if ((No % 2) == 0) {
                        bgColor = "#FFF";
                    } else {
                        bgColor = "#F9F9F9";
                    }
            %>
            <tr>
                <td style="background-color: <%=bgColor%>; text-align:center; vertical-align:middle"><%=No + 1%>.</td>
                <td style="background-color: <%=bgColor%>; text-align:left; vertical-align:middle" ><%=emp.getEmployeeNum()%></td>
                <td style="background-color: <%=bgColor%>; text-align:left; vertical-align:middle"><%=emp.getFullName()%></td>
                <td style="background-color: <%=bgColor%>; text-align:left; vertical-align:middle"><%=lvl.getLevel()%></td>
                <td style="background-color: <%=bgColor%>; text-align:left; vertical-align:middle"><%=div.getDivision()%></td>
                <td style="background-color: <%=bgColor%>; text-align:left; vertical-align:middle"><%=emp.getBirthDate()%></td>
                <td style="background-color: <%=bgColor%>; text-align:center; vertical-align:middle"><%=age%></td>
            </tr>
            <%
                    No++;
                }
            %>
        </table>
    </body>
</html>

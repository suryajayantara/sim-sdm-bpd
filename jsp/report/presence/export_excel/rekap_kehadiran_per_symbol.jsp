<%-- 
    Document   : rekap_kehadiran_per_symbol
    Created on : Apr 13, 2019, 10:01:34 AM
    Author     : Dimata 007
--%>

<%@page import="com.dimata.harisma.session.attendance.SessEmpSchedule"%>
<%@page import="com.dimata.util.Formater"%>
<%@page import="com.dimata.util.Command"%>
<%@ include file = "../../../main/javainit.jsp" %>
<% int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_MENU_REPORTS, AppObjInfo.G2_MENU_PAYROLL_REPORT, AppObjInfo.OBJ_MENU_OVERTIME_RPT);%>
<%@ include file = "../../../main/checkuser.jsp" %>
<%@page contentType="application/vnd.ms-excel" pageEncoding="UTF-8"%>

<%//
    int iCommand = FRMQueryString.requestCommand(request);
    long oidPeriod = FRMQueryString.requestLong(request, "period_id");
    String[] oidCompany = FRMQueryString.requestStringValues(request, "company_id");
    String[] oidDivision = FRMQueryString.requestStringValues(request, "division_id");
    String[] oidDepartment = FRMQueryString.requestStringValues(request, "department_id");
    String[] oidSection = FRMQueryString.requestStringValues(request, "section_id");
    String[] oidSchedule = FRMQueryString.requestStringValues(request, "schedule_id");
    String empNumber = FRMQueryString.requestString(request, "emp_number");
    String empName = FRMQueryString.requestString(request, "full_name");
    String dateFrom = FRMQueryString.requestString(request, "date_from");
    String dateTo = FRMQueryString.requestString(request, "date_to");
    int group = FRMQueryString.requestInt(request, "group_by");
    
    if (dateFrom.isEmpty()) {
        dateFrom = Formater.formatDate(new Date(), "yyyy-MM-dd");
    }
    
    if (dateTo.isEmpty()) {
        dateTo = Formater.formatDate(new Date(), "yyyy-MM-dd");
    }
    
    if (iCommand == Command.NONE) {
        Date now = new Date();
        String wherePeriod = " MONTH(" + PstPeriod.fieldNames[PstPeriod.FLD_START_DATE] + ") = '" + Formater.formatDate(now, "MM") + "'"
                + " AND YEAR(" + PstPeriod.fieldNames[PstPeriod.FLD_START_DATE] + ") = '" + Formater.formatDate(now, "yyyy") + "'";
        Vector<Period> listPeriod = PstPeriod.list(0, 1, wherePeriod, "");
        for (Period p : listPeriod) {
            oidPeriod = p.getOID();
        }
    }

    String[] groupTitle = {"Perusahaan","Satuan Kerja","Unit Kerja","Sub Unit","Karyawan"};
    String[] groupBy = {"COMPANY_ID","DIVISION_ID","DEPARTMENT_ID","SECTION_ID","EMPLOYEE_ID"};
    String[] orderBy = {"COMPANY_NAME","DIVISION_NAME","DEPARTMENT_NAME","SECTION_NAME","EMPLOYEE_NAME"};
    
    Vector listHeaderSymbol = new Vector();
    Vector<Vector> listGroupName = new Vector();
    Vector<Vector> listDataPerGroup = new Vector();
    Map<Long, Map> mapGroupData = new HashMap();
    
    SessEmpSchedule empSchedule = new SessEmpSchedule();
    if (iCommand == Command.LIST) {
        empSchedule.setPeriod(oidPeriod);
        empSchedule.setEmpNum(empNumber);
        empSchedule.setEmpFullName(empName);
        
        String inCompany = (oidCompany == null) ? "" : Arrays.toString(oidCompany);
        inCompany = (inCompany.isEmpty()) ? "" : inCompany.substring(1, inCompany.length() - 1);
        empSchedule.setInCompany(inCompany);

        String inDivision = (oidDivision == null) ? "" : Arrays.toString(oidDivision);
        inDivision = (inDivision.isEmpty()) ? "" : inDivision.substring(1, inDivision.length() - 1);
        empSchedule.setInDivision(inDivision);

        String inDepartment = (oidDepartment == null) ? "" : Arrays.toString(oidDepartment);
        inDepartment = (inDepartment.isEmpty()) ? "" : inDepartment.substring(1, inDepartment.length() - 1);
        empSchedule.setInDepartment(inDepartment);

        String inSection = (oidSection == null) ? "" : Arrays.toString(oidSection);
        inSection = (inSection.isEmpty()) ? "" : inSection.substring(1, inSection.length() - 1);
        empSchedule.setInSection(inSection);
        
        String inSchedule = (oidSchedule == null) ? "" : Arrays.toString(oidSchedule);
        inSchedule = (inSchedule.isEmpty()) ? "" : inSchedule.substring(1, inSchedule.length() - 1);
        empSchedule.setInSchedule(inSchedule);
        
        
        if (!dateFrom.isEmpty()) {
            empSchedule.setFromDate(Formater.formatDate(dateFrom, "yyyy-MM-dd"));
        }
        if (!dateTo.isEmpty()) {
            empSchedule.setToDate(Formater.formatDate(dateTo, "yyyy-MM-dd"));
        }
        
        listHeaderSymbol = PstScheduleSymbol.list(0, 0, PstScheduleSymbol.fieldNames[PstScheduleSymbol.FLD_SCHEDULE_ID]+" IN ("+empSchedule.getInSchedule()+")", "");
        listGroupName = SessEmpSchedule.listPresenceByScheduleSymbolWithRangeDate(empSchedule, groupBy[group], orderBy[group], 1);
        listDataPerGroup = SessEmpSchedule.listPresenceByScheduleSymbolWithRangeDate(empSchedule, groupBy[group], orderBy[group], 0);
        
        long groupKey = 0;
        for (Vector vGroup : listGroupName) {
            Company company = (Company) vGroup.get(0);
            Division division = (Division) vGroup.get(1);
            Department department = (Department) vGroup.get(2);
            Section section = (Section) vGroup.get(3);
            Employee employee = (Employee) vGroup.get(4);
            ScheduleSymbol symbol = (ScheduleSymbol) vGroup.get(5);
            
            //CEK GROUP TYPE
            long idGroup = 0;
            if (groupBy[group].equals("COMPANY_ID")) {
                groupKey = company.getOID();
                idGroup = company.getOID();
            } else if (groupBy[group].equals("DIVISION_ID")) {
                groupKey = division.getOID();
                idGroup = division.getOID();
            } else if (groupBy[group].equals("DEPARTMENT_ID")) {
                groupKey = department.getOID();
                idGroup = department.getOID();
            } else if (groupBy[group].equals("SECTION_ID")) {
                groupKey = section.getOID();
                idGroup = section.getOID();
            } else if (groupBy[group].equals("EMPLOYEE_ID")) {
                groupKey = employee.getOID();
                idGroup = employee.getOID();
            } else if (groupBy[group].equals("SCHEDULE_ID")) {
                groupKey = 0;
                idGroup = 0;
            }
            
            //SET GROUP DATA
            Map<String, Integer> mapData = new HashMap();
            mapData = setGroupData(groupBy[group], idGroup, listDataPerGroup);

            //SET GROUP KEY
            mapGroupData.put(groupKey, mapData);
            
            if (groupBy[group].equals("SCHEDULE_ID")) {
                //JIKA GROUP BY SYMBOL MAKA DATA GROUP CUKUP DI SET 1 KALI SAJA
                break;
            }
        }
    }
    int removeTable = 0;
    response.setHeader("Content-Disposition", "attachment; filename=rekap_kehadiran_per_symbol.xls ");
%>

<%!//
    public static Map<String, Integer> setGroupData(String groupBy, long idGroup, Vector<Vector> vectorData) {
        Map<String, Integer> listData = new HashMap();
        for (Vector vData : vectorData) {
            Company company = (Company) vData.get(0);
            Division division = (Division) vData.get(1);
            Department department = (Department) vData.get(2);
            Section section = (Section) vData.get(3);
            Employee employee = (Employee) vData.get(4);
            ScheduleSymbol symbol = (ScheduleSymbol) vData.get(5);
            
            if (groupBy.equals("COMPANY_ID")) {
                if (idGroup == company.getOID()) {
                    listData.put(symbol.getSymbol(), symbol.getWorkDays());
                }
            } else if (groupBy.equals("DIVISION_ID")) {
                if (idGroup == division.getOID()) {
                    listData.put(symbol.getSymbol(), symbol.getWorkDays());
                }
            } else if (groupBy.equals("DEPARTMENT_ID")) {
                if (idGroup == department.getOID()) {
                    listData.put(symbol.getSymbol(), symbol.getWorkDays());
                }
            } else if (groupBy.equals("SECTION_ID")) {
                if (idGroup == section.getOID()) {
                    listData.put(symbol.getSymbol(), symbol.getWorkDays());
                }
            } else if (groupBy.equals("EMPLOYEE_ID")) {
                if (idGroup == employee.getOID()) {
                    listData.put(symbol.getSymbol(), symbol.getWorkDays());
                }
            } else if (groupBy.equals("SCHEDULE_ID")) {
                listData.put(symbol.getSymbol(), symbol.getWorkDays());
            }
        }
        return listData;
    }
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
                <td style="text-align: center" colspan="<%= listHeaderSymbol.size() + 1%>">
                    <b>Laporan Kehadiran Karyawan Berdasarkan Symbol</b>
                </td>
            </tr>
            <tr>
                <td class="title_tbl" style="text-align:center; vertical-align:middle"><b><%= groupTitle[group]%></b></td>
                <%
                    for (int i=0; i < listHeaderSymbol.size(); i++) {
                        ScheduleSymbol symbol = (ScheduleSymbol) listHeaderSymbol.get(i);
                %>
                <td class="title_tbl" style="text-align:center; vertical-align:middle"><b><%= symbol.getSymbol()%></b></td>
                <%
                    }
                %>
            </tr>

            <%
                int no = 0;
                Vector listData = SessEmpSchedule.listRekapKehadiranBySymbol(empSchedule, oidSchedule, listHeaderSymbol, group);
                int[] grandTotal = new int[listHeaderSymbol.size()];
                for (int i=0; i < listData.size();i++){
                    Vector temp = (Vector) listData.get(i);
                    String name = (String) temp.get(0);
                    Map<String, Integer> mapTime = (Map<String, Integer>) temp.get(1);

                    out.print("<tr>");
                    out.print("<td>" + name + "</td>");

                    int totalPerGroup = 0;
                    for (int xx=0; xx < listHeaderSymbol.size(); xx++) {
                        ScheduleSymbol symbol = (ScheduleSymbol) listHeaderSymbol.get(xx);
                        int total = (mapTime.get(symbol.getSymbol()) == null) ? 0 : mapTime.get(symbol.getSymbol());
                        totalPerGroup += total;
                        grandTotal[xx] = grandTotal[xx] + total;
                        out.print("<td>" + total + "</td>");
                    }
                    out.print("</tr>");
                    no++;
                }
                out.print("<tr>");
                out.print("<td><b>Total Per Symbol</b></td>");
                for (int i= 0; i < grandTotal.length; i++){
                    out.print("<td><b>"+grandTotal[i]+"</b></td>");
                }
                out.print("</tr>");
            %>
            <% if (listGroupName.isEmpty()) { %>
            <tr>
                <td colspan="2" style="text-align: center">Tidak ada data</td>
            </tr>
            <% }%>
        </table>
    </body>
</html>

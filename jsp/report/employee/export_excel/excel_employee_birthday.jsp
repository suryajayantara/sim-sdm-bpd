<%-- 
    Document   : excel_employee_birthday
    Created on : Feb 24, 2021, 1:42:52 PM
    Author     : gndiw
--%>
<%@page import="com.dimata.util.Formater"%>
<%@page import="java.math.RoundingMode"%>
<%@page import="java.math.BigDecimal"%>
<%@page import="com.dimata.harisma.entity.attendance.LLStockManagement"%>
<%@page import="com.dimata.harisma.entity.attendance.PstLLStockManagement"%>
<%@page import="com.dimata.harisma.entity.attendance.AlStockManagement"%>
<%@page import="com.dimata.harisma.entity.attendance.PstAlStockManagement"%>
<%@page import="java.util.Hashtable"%>
<%@page import="com.dimata.gui.jsp.ControlCombo"%>
<%@page import="com.dimata.harisma.entity.masterdata.*"%>
<%@page import="com.dimata.harisma.entity.masterdata.*"%>
<%@ include file = "../../../main/javainit.jsp" %>
<% int  appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_MENU_REPORTS, AppObjInfo.G2_MENU_LEAVE_REPORT, AppObjInfo.OBJ_MENU_REKAP_CUTI); %>
<%@ include file = "../../../main/checkuser.jsp" %>
<%
    int iCommand = FRMQueryString.requestCommand(request);
    int iErrCode = FRMMessage.NONE;
    int start = FRMQueryString.requestInt(request, "start");
    String empNum = FRMQueryString.requestString(request, "emp_number");
    String empName = FRMQueryString.requestString(request, "full_name");
    long compId = FRMQueryString.requestLong(request, "company_id");
    String[] div = FRMQueryString.requestStringValues(request, "division_id");
    String[] dept = FRMQueryString.requestStringValues(request, "department");
    String[] sec = FRMQueryString.requestStringValues(request, "section");
    String bulan = FRMQueryString.requestString(request, "month");
    
    Vector<String> whereCollect = new Vector<String>();
    String whereClause = "";
    whereClause = PstEmployee.fieldNames[PstEmployee.FLD_RESIGNED]+" = 0";
    whereCollect.add(whereClause);
    if (!bulan.equals("")){
        whereClause = "DATE_FORMAT("+PstEmployee.fieldNames[PstEmployee.FLD_BIRTH_DATE]+ ",'%m') = '"+ bulan+"'";
        whereCollect.add(whereClause);
    }
    if (!empNum.equals("")){
        whereClause = PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_NUM]+ " = "+ empNum;
        whereCollect.add(whereClause);
    }
    if (!empName.equals("")){
        whereClause = PstEmployee.fieldNames[PstEmployee.FLD_FULL_NAME]+ " LIKE '%"+ empName+"%'";
        whereCollect.add(whereClause);
    }
    if (compId > 0){
        whereClause = PstEmployee.fieldNames[PstEmployee.FLD_COMPANY_ID]+ " = "+ compId;
        whereCollect.add(whereClause);
    }
    if (div != null){
        if (div.length>0){
            String inDivision = "";
            for (int i=0; i < div.length; i++){
                inDivision += "'"+div[i]+"' ," ;
            }
            inDivision = inDivision.substring(0, inDivision.length()-1);
            whereClause = PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID]+ " IN ("+ inDivision+")";
            whereCollect.add(whereClause);
        }
    }
    if (dept != null){
        if (dept.length>0  ){
            String inDept = "";
            for (int i=0; i < dept.length; i++){
                inDept += "'"+dept[i]+"' ," ;
            }
            inDept = inDept.substring(0, inDept.length()-1);
            whereClause = PstEmployee.fieldNames[PstEmployee.FLD_DEPARTMENT_ID]+ " IN ("+ inDept+")";
            whereCollect.add(whereClause);
        }
    }
    if (sec != null){
        if (sec.length>0 ){
            String inSec = "";
            for (int i=0; i < sec.length; i++){
                inSec += "'"+sec[i]+"' ," ;
            }
            inSec = inSec.substring(0, inSec.length()-1);
            whereClause = PstEmployee.fieldNames[PstEmployee.FLD_SECTION_ID]+ " IN ("+ inSec+")";
            whereCollect.add(whereClause);
        }
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
    
    Vector listEmployee = PstEmployee.list(0, 0, whereClause, "");
    
    response.setHeader("Content-Disposition","attachment; filename=laporan_ulang_tahun_karyawan.xls ");
%>
<%@page contentType="application/vnd.ms-excel" pageEncoding="UTF-8"%><!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <% if (listEmployee.size() > 0 ){ %>
            <table border="1">
                <tr>
                    <td style="text-align: center"><b>No</b></td>
                    <td style="text-align: center"><b>NRK</b></td>
                    <td style="text-align: center"><b>Nama</b></td>
                    <td style="text-align: center"><b>Jabatan</b></td>
                    <td style="text-align: center"><b>Satuan Kerja</b></td>
                    <td style="text-align: center"><b>Unit</b></td>
                    <td style="text-align: center"><b>Tanggal Lahir</b></td>
                </tr>
                <%
                    for (int idxEmp = 0; idxEmp < listEmployee.size(); idxEmp++) {
                        Employee emp = (Employee) listEmployee.get(idxEmp);
                            
                    
                        Position pos = new Position();
                        String position = "";
                        try{
                            pos = PstPosition.fetchExc(emp.getPositionId());
                            position = pos.getPosition();
                        } catch (Exception exc){

                        }
                %>
                    <tr>
                        <td><%=""+ (idxEmp+1)%></td>
                        <td>="<%=""+ emp.getEmployeeNum()%>"</td>
                        <td><%=""+ emp.getFullName()%></td>
                        <td><%=""+ position%></td>
                        <td><%=""+ PstEmployee.getDivisionName(emp.getDivisionId())%></td>
                        <td><%=""+ PstEmployee.getDepartmentName(emp.getDepartmentId())%></td>
                       <td><%=""+ Formater.formatDate(emp.getBirthDate())%></td>                                     
                    </tr>
                <%
                    }
                %>
            </table>
         <%  } %>
    </body>
</html>

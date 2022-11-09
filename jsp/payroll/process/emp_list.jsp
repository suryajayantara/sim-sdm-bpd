<%-- 
    Document   : emp_list
    Created on : Mar 21, 2017, 11:19:08 AM
    Author     : mchen
--%>
<%@ include file = "../../main/javainit.jsp" %>
<% int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_PAYROLL, AppObjInfo.G2_PAYROLL_PROCESS, AppObjInfo.OBJ_PAYROLL_PROCESS_PRINT);%>
<%@ include file = "../../main/checkuser.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
    String empName = FRMQueryString.requestString(request, "emp_name");
    /* get data user login*/
    Vector employeeList = new Vector();
    long employeeId = emplx.getOID();
    long divisionId = 0;
    String whereClause = "";
    long sdmDivisionOid = Long.parseLong(String.valueOf(PstSystemProperty.getPropertyLongbyName(OID_SDM_DIVISION)));
    if (emplx.getDivisionId() == sdmDivisionOid){
        divisionId = 0;
    } else {
        divisionId = emplx.getDivisionId();
    }
    if (divisionId != 0){
        whereClause = PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID]+"="+divisionId;
        if (empName != null && empName.length()>0){
            whereClause += " AND "+PstEmployee.fieldNames[PstEmployee.FLD_FULL_NAME]+" LIKE '%"+empName+"%'";
        }
    } else {
        if (empName != null && empName.length()>0){
            whereClause = PstEmployee.fieldNames[PstEmployee.FLD_FULL_NAME]+" LIKE '%"+empName+"%'";
        }
    }
    employeeList = PstEmployee.list(0, 0, whereClause, PstEmployee.fieldNames[PstEmployee.FLD_FULL_NAME]);
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Daftar Karyawan</title>
        <style type="text/css">
            body {
                background-color: #EEE;
                font-family: sans-serif;
                color: #575757;
                padding: 21px;
            }
            .tblStyle {border-collapse: collapse; font-size: 12px; }
            .tblStyle td {padding: 5px 7px; border: 1px solid #CCC; font-size: 12px; }
            .title_tbl {font-weight: bold;background-color: #DDD; color: #575757;}
            .btn {
                background-color: #00a1ec;
                border-radius: 3px;
                font-family: Arial;
                color: #EEE;
                font-size: 12px;
                padding: 7px 9px 7px 9px;
                text-decoration: none;
            }

            .btn:hover {
                color: #FFF;
                background-color: #007fba;
                text-decoration: none;
            }
            input {
                padding: 5px 7px;
                border-radius: 3px;
                border: 1px solid #DDD;
            }
        </style>
        <script type="text/javascript">
            function cmdSearch(){
                document.frm.action="emp_list.jsp";
                document.frm.submit();
            }
            function cmdGetItem(empId, empName) {
                self.opener.document.frm.emp_id.value = empId;
                self.opener.document.getElementById("emp-span").innerHTML = empName;
                self.close();
            }
        </script>
    </head>
    <body>
        <h1>Daftar Karyawan</h1>
        <form name="frm" action="" method="post">
        <input type="text" name="emp_name" placeholder="nama karyawan..." size="40" />
        <a href="javascript:cmdSearch()" class="btn" style="color:#FFF;">Cari</a>
        </form>
        <div>&nbsp;</div>
        <table class="tblStyle">
            <tr>
                <td class="title_tbl">NRK</td>
                <td class="title_tbl">Nama</td>
                <td class="title_tbl">Pilih</td>
            </tr>
            <%
                if (employeeList != null && employeeList.size()>0){
                    for(int i=0; i<employeeList.size(); i++){
                        Employee emp = (Employee)employeeList.get(i);
                        %>
                        <tr>
                            <td><%= emp.getEmployeeNum() %></td>
                            <td><%= emp.getFullName() %></td>
                            <td><a href="javascript:cmdGetItem('<%= emp.getOID() %>', '<%= emp.getFullName() %>')">Pilih</a></td>
                        </tr>
                        <%
                    }
                }
            %>
        </table>
        
    </body>
</html>

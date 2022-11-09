<%-- 
    Document   : division_emp_list
    Created on : Sep 28, 2016, 9:40:39 AM
    Author     : Dimata 007
--%>

<%@page import="com.dimata.harisma.entity.log.ChangeValue"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file = "../main/javainit.jsp" %>
<%
    long oidDivision = FRMQueryString.requestLong(request, "division_id");
    String whereClause = PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID]+"="+oidDivision;
    Vector empList = PstEmployee.list(0, 0, whereClause, PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_NUM]);
    ChangeValue changeValue = new ChangeValue();
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Daftar Karyawan</title>
        <style type="text/css">
            body {
                font-family: sans-serif;
                font-size: 12px;
                color: #575757;
                background-color: #EEE;
            }
            .box {
                border: 1px solid #CCC;
                background-color: #FFF;
                border-radius: 3px;
                padding: 9px;
                margin-bottom: 3px;
                cursor: pointer;
            }
            .box:hover {
                background-color: #EEE;
            }
            #title {
                font-weight: bold;
                color: #007592;
            }
            #position {
                color: #575757;
            }
        </style>
        
    </head>
    <body>
        <%
        if (empList != null && empList.size()>0){
            for (int i=0; i<empList.size(); i++){
                Employee emp = (Employee)empList.get(i);
                %>
                <div class="box" onclick="javascript:cmdGetItem('<%=emp.getOID()%>','<%=emp.getFullName()%>')">
                    <div id="title"><%= emp.getEmployeeNum() +" | "+ emp.getFullName() %></div>
                    <div id="position"><%= changeValue.getPositionName(emp.getPositionId()) %></div>
                </div>
                <%
            }
        }
        %>
    </body>
</html>

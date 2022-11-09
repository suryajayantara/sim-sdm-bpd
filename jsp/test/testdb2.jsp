<%-- 
    Document   : testdb
    Created on : Oct 11, 2009, 10:15:52 PM
    Author     : Ketut Kartika T
--%>

<%@page import="com.dimata.harisma.entity.search.SrcEmployee"%>
<%@page import="com.dimata.harisma.session.leave.SessLeaveApplication"%>
<%@page import="java.util.Vector"%>
<%@page import="com.dimata.util.Formater"%>
<%@page import="java.util.Date"%>
<%@page contentType="text/html" pageEncoding="Shift_JIS"%>
<%
    Date startDate = Formater.formatDate("2021-03-01", "yyyy-MM-dd");
    Date endDate = Formater.formatDate("2021-03-30", "yyyy-MM-dd");
    SrcEmployee srcEmployee = new SrcEmployee();
    Vector listRekap = SessLeaveApplication.rekapCuti("2020-01-01", "2020-01-31", srcEmployee);
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=Shift_JIS">
        <title>JSP Page</title>
    </head>
    <body> 
        
    </body>
</html>

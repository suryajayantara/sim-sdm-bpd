<%@page import="java.util.Vector"%>
<%@page import="com.dimata.harisma.session.attendance.SessEmpSchedule"%>
<%@page import="com.dimata.harisma.entity.payroll.PstPayPeriod"%>
<%@page import="com.dimata.harisma.entity.payroll.PayPeriod"%>
<%@ page language="java" %>
<%@ page import="com.dimata.util.*"%>

<%
    
    PayPeriod payPeriod = PstPayPeriod.fetchExc(504404772601024630L);
    Vector list = SessEmpSchedule.listRekapKehadiran(payPeriod);
%>
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body bgcolor="#FFFFFF" text="#000000">

</body>
</html>

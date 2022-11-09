<%-- 
    Document   : kpi_target_ajax
    Created on : Nov 26, 2019, 4:33:21 PM
    Author     : IanRizky
--%>

<%@page import="com.dimata.qdep.form.FRMQueryString"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
	String dataFor = FRMQueryString.requestString(request, "FRM_FIELD_DATA_FOR");
	long groupId = FRMQueryString.requestLong(request, "groupId");
	
	if (dataFor.equals("kpiList")){
		%>
		<option value="1">tetot</option>
		<%
	}
%>

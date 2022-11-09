<%-- 
    Document   : option_training
    Created on : Jun 14, 2016, 3:40:22 PM
    Author     : Dimata 007
--%>

<%@page import="com.dimata.harisma.entity.employee.PstTrainingHistory"%>
<%@page import="com.dimata.qdep.form.FRMQueryString"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    /* value of structure */
    long typeId = FRMQueryString.requestLong(request, "type_id");

%>
<select name="train_program" id="train_program">
    <option value="0">-Select-</option>
    <%= PstTrainingHistory.drawTrainingProgram(typeId) %>
</select>
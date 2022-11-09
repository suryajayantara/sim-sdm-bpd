<%-- 
    Document   : message_log
    Created on : Jun 7, 2016, 10:13:33 AM
    Author     : Dimata 007
--%>

<%@page import="com.dimata.harisma.entity.log.PstLogSysHistory"%>
<%@page import="com.dimata.harisma.entity.log.LogSysHistory"%>
<%@page import="com.dimata.harisma.entity.log.MessageLog"%>
<%@page import="com.dimata.harisma.entity.log.PstMessageLog"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file = "../../main/javainit.jsp" %>
<%
    String entityName = FRMQueryString.requestString(request, "entity_name");
    long userId = FRMQueryString.requestLong(request, "user_id");
    String whereClause = PstMessageLog.fieldNames[PstMessageLog.FLD_ENTITY_NAME]+"='"+entityName+"'";
    whereClause += " AND "+PstMessageLog.fieldNames[PstMessageLog.FLD_USER_ID]+"="+userId;
    Vector listMessage = PstMessageLog.list(0, 0, whereClause, "");
%>
<%
    if (listMessage != null && listMessage.size()>0){
        %>
        <div class="box-message">
            <table>
                <%
                for(int i=0; i<listMessage.size(); i++){
                    MessageLog message = (MessageLog)listMessage.get(i);
                    LogSysHistory logData = new LogSysHistory();
                    try {
                        logData = PstLogSysHistory.fetchExc(message.getLogId());
                    } catch(Exception e){
                        System.out.println("logData=>"+e.toString());
                    }
                    if (logData != null){
                        %>
                        <tr>
                            <td><%= logData.getLogDetail() %></td>
                            <td>: Approve || Not Approve</td>
                            <td>&times;</td>
                        </tr>
                        <%
                    }
                }
                %>
            </table>
        </div>
        <%
    }
%>
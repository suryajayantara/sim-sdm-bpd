<%-- 
    Document   : user_ajax
    Created on : Feb 25, 2016, 2:11:26 PM
    Author     : Dimata 007
--%>

<%@page import="com.dimata.harisma.entity.admin.AppUser"%>
<%@page import="com.dimata.harisma.entity.admin.PstAppUser"%>
<%@page import="java.util.Vector"%>
<%@page import="com.dimata.qdep.form.FRMQueryString"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String loginName = FRMQueryString.requestString(request, "login_name");
    int iCommand = FRMQueryString.requestCommand(request);
    Vector listUser = new Vector();
    String whereClause = "";
    String order = "";
    
    if (loginName.equals("0")){
        order = PstAppUser.fieldNames[PstAppUser.FLD_LOGIN_ID];
        listUser = PstAppUser.listPartObj(0, 0, "", order);
    } else {
        whereClause = PstAppUser.fieldNames[PstAppUser.FLD_LOGIN_ID]+" LIKE '%"+loginName+"%'";
        order = PstAppUser.fieldNames[PstAppUser.FLD_LOGIN_ID];
        listUser = PstAppUser.listPartObj(0, 0, whereClause, order); 
    }
%>
<table class="tblStyle">
    <tr>
        <td class="title_tbl">No</td>
        <td class="title_tbl">Login Name</td>
        <td class="title_tbl">Nama</td>
    </tr>
    <%
    if (listUser != null && listUser.size()>0){
        for (int i=0; i<listUser.size(); i++){
            AppUser appUser = (AppUser)listUser.get(i);
            %>
            <tr>
                <td><%=i+1%></td>
                <td><%= appUser.getLoginId() %></td>
                <td><div id="uname" onclick="javascript:cmdGetItem('<%= appUser.getOID() %>','<%= appUser.getLoginId() %>')"><%= appUser.getFullName() %></div></td>
            </tr>
            <%
        }
    }
    %>
</table>

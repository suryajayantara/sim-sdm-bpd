<%-- 
    Document   : experience_search
    Created on : 02-Aug-2016, 19:52:52
    Author     : Acer
--%>

<%@page import="com.dimata.qdep.form.FRMQueryString"%>
<%@page import="com.dimata.harisma.entity.masterdata.Position"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstPosition"%>
<%@page import="com.dimata.harisma.form.masterdata.FrmMappingPosition"%>
<%@page import="java.util.Vector"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
    int iCommand = FRMQueryString.requestCommand(request);
    String comm = request.getParameter("comm");
    String positionName = FRMQueryString.requestString(request, "position_name");
    String whereClause = PstPosition.fieldNames[PstPosition.FLD_POSITION]+" LIKE '%"+positionName+"%'";
    String order = ""+PstPosition.fieldNames[PstPosition.FLD_POSITION];
    Vector listPosition = new Vector();
    if (positionName.length() > 0){
       listPosition = PstPosition.list(0, 0, whereClause, order); 
    } else {
       listPosition = PstPosition.list(0, 0, "", order); 
    }
    
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Position List</title>
        <style type="text/css">
            body {
                color:#575757;
                font-size: 11px;
                font-family: sans-serif;
                background-color: #F5F5F5;
            }
            .item {
                padding: 3px;
                border:1px solid #CCC;
                border-radius: 3px;
                background-color: #EEE;
                margin: 3px;
                cursor: pointer;
            }
            .teks {
                font-size: 11px;
                color:#474747;
                padding: 5px; 
                border:1px solid #CCC;
                border-radius: 3px;
                margin: 3px;
            }
        </style>
        <script language="javascript">
        function cmdChoose(oid) {
            self.opener.document.frmposition.experience_id.value = oid;
            self.opener.document.frmposition.command.value = "<%=comm%>";                 
            //self.close();
            self.opener.document.frmposition.submit();
        }
    </script>
    </head>
    <body>
        <h1 style="border-bottom: 1px solid #0599ab; padding-bottom: 12px;">Position List</h1>
        <form method="post" name="frm" action="">
            <input class="teks" placeholder="search position..." type="text" name="position_name" size="50" />
        </form>
        <%
        if (listPosition != null && listPosition.size()>0){
            for(int i=0; i<listPosition.size(); i++){
                Position position = (Position)listPosition.get(i);
                %>
                <div class="item" onclick="cmdChoose('<%=position.getOID()%>')"><%=position.getPosition()%></div>
                <%
            }
        }
        %>
    </body>
</html>
<%-- 
    Document   : setup_jv_comp
    Created on : Dec 13, 2016, 3:11:59 PM
    Author     : Dimata 007
--%>

<%@page import="com.dimata.util.Command"%>
<%@page import="com.dimata.aiso.entity.masterdata.Perkiraan"%>
<%@page import="com.dimata.aiso.entity.masterdata.PstPerkiraan"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file = "../main/javainit.jsp" %>
<!DOCTYPE html>
<%
    int iCommand = FRMQueryString.requestCommand(request);
    String compSelect = FRMQueryString.requestString(request, "comp_select");
    long oidCompCode = FRMQueryString.requestLong(request, "oid_comp_code");
    if (iCommand == Command.SAVE){
        String[] data = compSelect.split(",");
        ComponentMapJv compMap = new ComponentMapJv();
        compMap.setCompCodeId(oidCompCode);
        compMap.setComponentId(Long.valueOf(data[0]));
        compMap.setComponentName(data[1]);
        try {
            PstComponentMapJv.insertExc(compMap);
        } catch (Exception e){
            System.out.println(e.toString());
        }
    }
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Component CoA</title>  
        
        <style type="text/css">
            body {
                background-color: #EEE;
                color: #575757;
                font-family: sans-serif;
                padding: 25px;
            }
            select {
                border: 1px solid #CCC;
                padding: 5px 7px;
                border-radius: 3px;
            }
            .btn {
                background-color: #00a1ec;
                border-radius: 3px;
                font-family: Arial;
                color: #EEE;
                font-size: 12px;
                padding: 7px 11px 7px 11px;
                text-decoration: none;
            }

            .btn:hover {
                color: #FFF;
                background-color: #007fba;
                text-decoration: none;
            }
        </style>
        <script type="text/javascript">
            function cmdSave(){
                document.frm.command.value="<%= Command.SAVE %>";
                document.frm.action="";
                document.frm.submit();
            }
            function cmdRefresh(){
                self.opener.document.frm.command_custom.value = "0";
                self.opener.document.frm.action="";
                self.opener.document.frm.submit();
            }
        </script>
        <link rel="stylesheet" href="../stylesheets/chosen.css" >
        <script src="../javascripts/jquery.min-1.6.2.js" type="text/javascript"></script>
        <script src="../javascripts/chosen.jquery.js" type="text/javascript"></script>
    </head>
    <body>
        <h1 style="color:#474747">Component Chart of Account</h1>
        <form name="frm" method="post" action="">
            <input type="hidden" name="command" value="<%=iCommand%>">
            <input type="hidden" name="oid_comp_code" value="<%= oidCompCode %>" />
        <select name="comp_select" class="chosen-select">
            <option value="0">-SELECT-</option>
            <%
            String whereClause = "";
            Vector perkiraanList = PstPerkiraan.list(0, 0, whereClause, "");
            if (perkiraanList != null && perkiraanList.size()>0){
                for (int i=0; i<perkiraanList.size(); i++){
                    Perkiraan perkiraan = (Perkiraan)perkiraanList.get(i);
                    %>
                    <option value="<%= perkiraan.getOID() %>,<%= perkiraan.getNama() %>">[<%= (perkiraan.getKodePerkiraan() != null ? perkiraan.getKodePerkiraan() : "-")%>] <%= perkiraan.getNama() %></option>
                    <%
                }
            }
            %>
        </select>
        <a href="javascript:cmdSave()" class="btn" style="color:#FFF">Simpan</a>
        <a href="javascript:cmdRefresh()" class="btn" style="color:#FFF">Refresh</a>
        </form>
         <script type="text/javascript">
            var config = {
                '.chosen-select': {},
                '.chosen-select-deselect': {allow_single_deselect: true},
                '.chosen-select-no-single': {disable_search_threshold: 10},
                '.chosen-select-no-results': {no_results_text: 'Oops, nothing found!'},
                '.chosen-select-width': {width: "100%"}
            };
            
            for (var selector in config) {
                $(selector).chosen(config[selector]);
            }
        </script>
    </body>
   
</html>

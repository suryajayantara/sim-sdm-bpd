<%-- 
    Document   : setup_jv_division
    Created on : Dec 13, 2016, 3:10:59 PM
    Author     : Dimata 007
--%>

<%@page import="com.dimata.util.Command"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file = "../main/javainit.jsp" %>
<!DOCTYPE html>
<%
    int iCommand = FRMQueryString.requestCommand(request);
    String divisionSelect = FRMQueryString.requestString(request, "division_select");
    long oidDivCode = FRMQueryString.requestLong(request, "oid_div_code");
    if (iCommand == Command.SAVE){
        String[] data = divisionSelect.split(",");
        DivisionMapJv divMap = new DivisionMapJv();
        divMap.setDivisionId(Long.valueOf(data[0]));
        divMap.setDivisionName(data[1]);
        divMap.setDivisionCodeId(oidDivCode);
        try {
            PstDivisionMapJv.insertExc(divMap);
        } catch (Exception e){
            System.out.println(e.toString());
        }
    }
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Pilih Satuan Kerja</title>
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
    </head>
    <body>
        <h1 style="color:#474747">Satuan Kerja</h1>
        <form name="frm" method="post" action="">
            <input type="hidden" name="command" value="<%=iCommand%>">
            <input type="hidden" name="oid_div_code" value="<%= oidDivCode %>" />
        <select name="division_select">
            <option value="0">-SELECT</option>
        <%
        String whereClause = PstDivision.fieldNames[PstDivision.FLD_VALID_STATUS]+"="+PstDivision.VALID_ACTIVE;
        String order = PstDivision.fieldNames[PstDivision.FLD_DIVISION];
        Vector divisionList = PstDivision.list(0, 0, whereClause, order);
        if (divisionList != null && divisionList.size()>0){
            for (int i=0; i<divisionList.size(); i++){
                Division divisi = (Division)divisionList.get(i);
                %>
                <option value="<%= divisi.getOID() %>,<%=divisi.getDivision()%>"><%= divisi.getDivision() %></option>
                <%
            }
        }
        %>
        </select>
        <a href="javascript:cmdSave()" class="btn" style="color:#FFF">Simpan</a>
        <a href="javascript:cmdRefresh()" class="btn" style="color:#FFF">Refresh</a>
        </form>
    </body>
</html>

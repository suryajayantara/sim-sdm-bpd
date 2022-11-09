<%-- 
    Document   : division_emp
    Created on : Sep 28, 2016, 9:22:18 AM
    Author     : Dimata 007
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file = "../main/javainit.jsp" %>
<!DOCTYPE html>
<%
    long oidDivision = FRMQueryString.requestLong(request, "division_id");

    Vector divisionList = PstDivision.list(0, 0, "", PstDivision.fieldNames[PstDivision.FLD_DIVISION]);
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Pencarian Karyawan</title>
        <style type="text/css">
            body {
                margin: 0;
                padding: 0;
                font-family: sans-serif;
                font-size: 12px;
                color: #474747;
                background-color: #E5E5E5;
            }
            select {
                border: 1px solid #DDD;
                padding: 5px 7px;
                border-radius: 3px;
            }
            .header {
                background-color: #DDD;
                padding: 21px;
                border-bottom: 1px solid #CCC;
            }
            #div_respon {
                padding: 21px;
            }
        </style>
        <script type="text/javascript">
           function loadList(division_id) {
                if (division_id.length == 0) { 
                    division_id = "0";
                } 
                var xmlhttp = new XMLHttpRequest();
                xmlhttp.onreadystatechange = function() {
                    if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                        document.getElementById("div_respon").innerHTML = xmlhttp.responseText;
                    }
                };
                xmlhttp.open("GET", "division_emp_list.jsp?division_id=" + division_id, true);
                xmlhttp.send();
                
            }

            function cmdGetItem(oid, name) {
                self.opener.document.getElementById("emp_name").value=name;
                self.opener.document.frmdivision.FRM_FIELD_EMPLOYEE_ID.value=oid;
                self.close();
            }
        </script>
    </head>
    <body onload="loadList('<%= oidDivision %>')">
        <div class="header">
        <h1 style="color:#474747">Pencarian Karyawan</h1>
        <select name="division_select" onchange="javascript:loadList(this.value)">
            <option value="0">-SELECT-</option>
            <%
            if (divisionList != null && divisionList.size()>0){
                for (int i=0; i<divisionList.size(); i++){
                    Division division = (Division)divisionList.get(i);
                    if (oidDivision == division.getOID()){
                        %>
                        <option selected="selected" value="<%= division.getOID() %>"><%= division.getDivision() %></option>
                        <%
                    } else {
                        %>
                        <option value="<%= division.getOID() %>"><%= division.getDivision() %></option>
                        <%
                    }
                }
            }
            %>
        </select>
        </div>
        <div>&nbsp;</div>
        <div id="div_respon"></div>
    </body>
</html>

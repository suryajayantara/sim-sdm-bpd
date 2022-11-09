<%-- 
    Document   : user_data
    Created on : Feb 18, 2016, 12:50:12 PM
    Author     : Dimata 007
--%>

<%@ include file = "../../main/javainit.jsp" %>
<%  int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_SYSTEM, AppObjInfo.G2_SYSTEM_MANAGEMENT, AppObjInfo.OBJ_SYSTEM_PROPERTIES); %>
<%@ include file = "../../main/checkuser.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    int iCommand = FRMQueryString.requestCommand(request);
    Vector listUser = new Vector();
    listUser = PstAppUser.listPartObj(0, 0, "", "");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>User Data</title>
        <style type="text/css">
            .tblStyle {border-collapse: collapse; }
            .tblStyle td {padding: 5px 7px; border: 1px solid #CCC; font-size: 12px; }
            .title_tbl {font-weight: bold;background-color: #DDD; color: #575757;}
            .title_page {color:#0db2e1; font-weight: bold; font-size: 14px; background-color: #EEE; border-left: 1px solid #0099FF; padding: 12px 18px;}
            #user {
                background-color: #474747; 
                color: #EEE; padding: 5px 11px; 
                border-radius: 3px;
                
            }
            body {
                color:#373737;
                padding: 21px;
                font-family: sans-serif;
            }
            input {
                padding: 5px 9px;
                border: 1px solid #CCC;
                color: #0099FF;
                border-radius: 3px;
            }
            #uname {
                color:#3498db;
                cursor: pointer;
            }
        </style>
        <script type="text/javascript">
            function loadList(loginName) {
                if (loginName.length == 0) { 
                    loginName = "0";
                } 
                var xmlhttp = new XMLHttpRequest();
                xmlhttp.onreadystatechange = function() {
                    if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                        document.getElementById("div_respon").innerHTML = xmlhttp.responseText;
                    }
                };
                xmlhttp.open("GET", "user_ajax.jsp?login_name=" + loginName, true);
                xmlhttp.send();
                
            }
            function prepare(){
                loadList("0");
            }
            function cmdGetItem(oid, fullname) {
                self.opener.document.frm.user_id.value = oid;
                self.opener.document.getElementById("fullname").innerHTML = fullname;
                self.opener.document.getElementById("close-x").innerHTML = "<span id=\"close\" onclick=\"javascript:cmdDelUser()\">&times;</span>";
                self.close();
            }
        </script>
    </head>
    <body onload="prepare()">
        <h1>User Data</h1>
        <div><input type="text" name="login_name" onkeyup="loadList(this.value)" placeholder="Type Login Name..." size="51" /></div>
        <div>&nbsp;</div>
        <div id="div_respon"></div>
    </body>
</html>

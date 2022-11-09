<%-- 
    Document   : edit_comp_day
    Created on : 20-Feb-2017, 09:32:18
    Author     : Gunadi
--%>


<%@page import="com.dimata.harisma.entity.payroll.PayComponent"%>
<%@page import="com.dimata.harisma.entity.payroll.PstPayComponent"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file = "../../main/javainit.jsp" %>
<!DOCTYPE html>
<%
    long oidComp = FRMQueryString.requestLong(request,"oid_comp");
    int dayLength = FRMQueryString.requestInt(request,"day");
    
    long oidInsert = 0;
    if (dayLength > 0){
        try {
            PstEmpDocListExpense.updateDay(dayLength, oidComp);
            oidInsert = 1;
        } catch (Exception exc){
            oidInsert = 0;
        }
    }
               
    
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Document Employee Search</title>
        <link rel="stylesheet" href="../../styles/main.css" type="text/css">
         <%@ include file = "../../main/konfigurasi_jquery.jsp" %>    
        <script src="../../javascripts/jquery.min-1.6.2.js" type="text/javascript"></script>
        <script src="../../javascripts/chosen.jquery.js" type="text/javascript"></script>
        <link rel="stylesheet" href="../../stylesheets/chosen.css" >
        <style type="text/css">
            body {
                margin: 0;
                padding: 0;
                font-size: 12px;
                font-family: sans-serif;
            }
            .header {
                background-color: #EEE;
                padding: 21px;
                border-bottom: 1px solid #DDD;
            }
            .content {
                padding: 21px;
            }
            #caption, .caption {
                font-size: 12px;
                color: #474747;
                font-weight: bold;
                padding: 2px 0px 3px 0px;
            }
            #divinput, .divinput {
                margin-bottom: 5px;
                padding-bottom: 5px;
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
            
            .item {
                background-color: #EEE;
                padding: 9px;
                margin: 9px 15px;
            }
        </style>
<script type="text/javascript">

function check() {
    document.getElementsByClassName("myC").checked = true;
}

function uncheck() {
    document.getElementById("myCheck").checked = false;
}
function cmdSave(){
    document.frm.action="edit_comp_day.jsp";
    document.frm.submit();
}

function cmdGoToSurat(oidEmpDoc, objectName){
    document.frm.action="search_app_letter.jsp?oid_emp_doc="+oidEmpDoc+"&object_name="+objectName;
    document.frm.submit();
}

</script>
    </head>
    <body onload="pageLoad()">
        <div class="header">
            <h2 style="color:#999">Tambah Komponen</h2>
            <%
            if (oidInsert != 0){
                %>
                <div style="padding: 9px; background-color: #DDD;">Data Berhasil disimpan</div>
                <%
            }
            %>
        </div>
        <div class="content">
            <form name="frm" method="post" action="">
                <input type="hidden" name="oid_comp" value="<%= oidComp %>" />
                <table width="100%">
                    <tr>
                        <td valign="top" width="50%">
                            <div id="caption">Jumlah Hari</div>
                            <div id="divinput">
                                <input type="text" name="day" id="day" value=""/>
                            </div>
                            <div>&nbsp;</div>
                            <a class="btn" style="color:#FFF" href="javascript:cmdSave()">Simpan</a>
                        </td>
                        <td valign="top" width="50">
                            <div id="div_list"></div>
                        </td>
                    </tr>
                </table>
            </form>
        </div>
    </body>
</html>

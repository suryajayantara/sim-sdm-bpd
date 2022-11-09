<%-- 
    Document   : potongan_list
    Created on : Mar 21, 2017, 12:08:00 PM
    Author     : mchen
--%>
<%@page import="com.dimata.harisma.entity.payroll.PayComponent"%>
<%@page import="com.dimata.harisma.entity.payroll.PstPayComponent"%>
<%@ include file = "../../main/javainit.jsp" %>
<% int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_PAYROLL, AppObjInfo.G2_PAYROLL_PROCESS, AppObjInfo.OBJ_PAYROLL_PROCESS_PRINT);%>
<%@ include file = "../../main/checkuser.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
    String compName = FRMQueryString.requestString(request, "comp_name");
    Vector deductionList = new Vector();
    String whereClause = PstPayComponent.fieldNames[PstPayComponent.FLD_COMP_TYPE]+"="+PstPayComponent.TYPE_DEDUCTION;
    if (compName != null && compName.length()>0){
        whereClause += " AND "+PstPayComponent.fieldNames[PstPayComponent.FLD_COMP_NAME]+" LIKE '%"+compName+"%'";
    }
    deductionList = PstPayComponent.list(0, 0, whereClause, "");
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Komponen Potongan</title>
        <style type="text/css">
            body {
                background-color: #EEE;
                font-family: sans-serif;
                color: #575757;
                padding: 21px;
            }
            .tblStyle {border-collapse: collapse; font-size: 12px; }
            .tblStyle td {padding: 5px 7px; border: 1px solid #CCC; font-size: 12px; }
            .title_tbl {font-weight: bold;background-color: #DDD; color: #575757;}
            .btn {
                background-color: #00a1ec;
                border-radius: 3px;
                font-family: Arial;
                color: #EEE;
                font-size: 12px;
                padding: 7px 9px 7px 9px;
                text-decoration: none;
            }

            .btn:hover {
                color: #FFF;
                background-color: #007fba;
                text-decoration: none;
            }
            input {
                padding: 5px 7px;
                border-radius: 3px;
                border: 1px solid #DDD;
            }
        </style>
        <script type="text/javascript">
            function cmdSearch(){
                document.frm.action="potongan_list.jsp";
                document.frm.submit();
            }
            function cmdGetItem(compId, compName) {
                self.opener.document.frm.comp_id.value = compId;
                self.opener.document.getElementById("comp-span").innerHTML = compName;
                self.close();
            }
        </script>
    </head>
    <body>
        <h1>Komponen Potongan</h1>
        <form name="frm" action="" method="post">
        <input type="text" name="comp_name" placeholder="nama potongan..." size="32" />
        <a href="javascript:cmdSearch()" class="btn" style="color:#FFF;">Cari</a>
        </form>
        <div>&nbsp;</div>
        <table class="tblStyle">
            <tr>
                <td class="title_tbl">Code</td>
                <td class="title_tbl">Komponen</td>
                <td class="title_tbl">Pilih</td>
            </tr>
            <%
                if (deductionList != null && deductionList.size()>0){
                    for(int i=0; i<deductionList.size(); i++){
                        PayComponent payComp = (PayComponent)deductionList.get(i);
                        %>
                        <tr>
                            <td><%= payComp.getCompCode() %></td>
                            <td><%= payComp.getCompName() %></td>
                            <td><a href="javascript:cmdGetItem('<%= payComp.getOID() %>','<%= payComp.getCompName() %>')">Pilih</a></td>
                        </tr>
                        <%
                    }
                }
            %>
        </table>
    </body>
</html>

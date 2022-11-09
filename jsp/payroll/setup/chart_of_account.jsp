<%-- 
    Document   : chart_of_account
    Created on : Jun 30, 2016, 9:22:10 AM
    Author     : Dimata 007
--%>

<%@page import="com.dimata.harisma.form.masterdata.FrmComponentCoaMap"%>
<%@page import="com.dimata.aiso.entity.masterdata.Perkiraan"%>
<%@page import="com.dimata.aiso.entity.masterdata.PstPerkiraan"%>
<%@page import="com.dimata.aiso.form.masterdata.FrmPerkiraan"%>
<%@page import="com.dimata.aiso.form.masterdata.CtrlPerkiraan"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file = "../../main/javainit.jsp" %> 
<% int  appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_PAYROLL, AppObjInfo.G2_PAYROLL_SETUP, AppObjInfo.OBJ_PAYROLL_SETUP_GENERAL); %>
<%@ include file = "../../main/checkuser.jsp" %>
<!DOCTYPE html>
<%
    int iCommand = FRMQueryString.requestCommand(request);
    long oidCoa = FRMQueryString.requestLong(request, "oid_coa");
    int tandaDebitCredit = FRMQueryString.requestInt(request, "tanda_debit_credit");
    int iErrCode = 0;
    CtrlPerkiraan ctrlPerkiraan = new CtrlPerkiraan(request);
    iErrCode = ctrlPerkiraan.action(iCommand, oidCoa);
    Perkiraan perkiraan = ctrlPerkiraan.getPerkiraan();
    String whereClause = PstPerkiraan.fieldNames[PstPerkiraan.FLD_TANDA_DEBET_KREDIT]+"=0 "
            + " AND "+PstPerkiraan.fieldNames[PstPerkiraan.FLD_ID_PARENT]+" = 0 ";
    Vector listPerkiraanDebit = PstPerkiraan.list(0, 0, whereClause, "");
    whereClause = PstPerkiraan.fieldNames[PstPerkiraan.FLD_TANDA_DEBET_KREDIT]+"=1 "
            + " AND "+PstPerkiraan.fieldNames[PstPerkiraan.FLD_ID_PARENT]+" = 0 ";
    Vector listPerkiraanCredit = PstPerkiraan.list(0, 0, whereClause, "");
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Chart Of Account</title>
        <link rel="stylesheet" href="../../styles/main.css" type="text/css">
        <style type="text/css">
            .tblStyle {border-collapse: collapse; font-size: 12px; }
            .tblStyle td {padding: 5px 7px; border: 1px solid #CCC; font-size: 12px; }
            .title_tbl {font-weight: bold;background-color: #DDD; color: #575757;}
            .title_page {color:#0db2e1; font-weight: bold; font-size: 14px; background-color: #EEE; border-left: 1px solid #0099FF; padding: 12px 18px;}

            body {color:#373737;}
            #menu_utama {padding: 9px 14px; border-left: 1px solid #0099FF; font-size: 14px; background-color: #F3F3F3;}
            #menu_title {color:#0099FF; font-size: 14px;}
            #menu_teks {color:#CCC;}
            
            #btn {
              background: #3498db;
              border: 1px solid #0066CC;
              border-radius: 3px;
              font-family: Arial;
              color: #ffffff;
              font-size: 12px;
              padding: 3px 9px 3px 9px;
            }

            #btn:hover {
              background: #3cb0fd;
              border: 1px solid #3498db;
            }
            .title_part {color:#FF7E00; background-color: #F7F7F7; border-left: 1px solid #0099FF; padding: 9px 11px;}
            
            body {background-color: #FFF;}
            .header {
                
            }
            .content-main {
                padding: 21px 11px;
                margin: 0px 23px 59px 23px;
            }
            .content-info {
                padding: 21px;
                border-bottom: 1px solid #E5E5E5;
            }
            .content-title {
                padding: 21px;
                border-bottom: 1px solid #E5E5E5;
                margin-bottom: 5px;
            }
            #title-large {
                color: #575757;
                font-size: 16px;
                font-weight: bold;
            }
            #title-small {
                color:#797979;
                font-size: 11px;
            }
            .content {
                padding: 21px;
            }
            .box {
                padding: 9px 11px;
                margin: 5px 11px 5px 0px;
                background-color: #F5F5F5;
                border:1px solid #DDD;
                border-radius: 4px;
                color:#575757;
            }
            #box_title {
                padding:21px; 
                font-size: 14px; 
                color: #007fba;
                border-top: 1px solid #28A7D1;
                border-bottom: 1px solid #EEE;
            }
            #box_content {
                padding:21px; 
                font-size: 12px;
                color: #575757;
            }
            .box-info-debit {
                padding:12px;
                background-color: #C0ECFA; 
                color: #38839C;
                margin: 5px 0px;
                margin-top: 0px;
                text-align: center;
                font-size: 16px;
                border-radius: 5px;
                cursor: pointer;
            }
            .box-info-debit:hover {
                color:#FFF;
                background-color: #85C3D6;
            }
            .box-info-credit {
                padding:12px;
                background-color: #E2FAC5; 
                color: #5A8C1D;
                margin: 5px 0px;
                margin-top: 0px;
                text-align: center;
                font-size: 16px;
                border-radius: 5px;
                cursor: pointer;
            }
            .box-info-credit:hover {
                color:#FFF;
                background-color: #B0CF53;
            }
            #box-item {
                font-weight: bold;
                margin: 3px 0px;
                padding: 5px 9px;
                color: #575757;
                background-color: #EEE;
                border:1px solid #DDD;
                border-right: none;
            }
            #box-times {
                font-weight: bold;
                margin: 3px 0px;
                padding: 5px 9px;
                color: #B09595;
                background-color: #EEE;
                border:1px solid #DDD;
                cursor: pointer;
            }
            #box-times:hover {
                font-weight: bold;
                margin: 3px 0px;
                padding: 5px 9px;
                color: #B09595;
                background-color: #FFD9D9;
                border:1px solid #D9B8B8;
            }
            #title-info-name {
                padding: 11px 15px;
                font-size: 35px;
                color: #535353;
            }
            #title-info-desc {
                padding: 7px 15px;
                font-size: 21px;
                color: #676767;
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
            
            .btn-small {
                font-family: sans-serif;
                text-decoration: none;
                padding: 5px 7px; 
                background-color: #676767; color: #F5F5F5; 
                font-size: 11px; cursor: pointer;
                border-radius: 3px;
            }
            .btn-small:hover { background-color: #474747; color: #FFF;}
            
            .btn-small-1 {
                font-family: sans-serif;
                text-decoration: none;
                padding: 5px 7px; 
                background-color: #EEE; color: #575757; 
                font-size: 11px; cursor: pointer;
                border-radius: 3px;
            }
            .btn-small-1:hover { background-color: #DDD; color: #474747;}
            
            .tbl-main {border-collapse: collapse; font-size: 11px; background-color: #FFF; margin: 0px;}
            .tbl-main td {padding: 4px 7px; border: 1px solid #DDD; }
            #tbl-title {font-weight: bold; background-color: #F5F5F5; color: #575757;}
            
            .tbl-small {border-collapse: collapse; font-size: 11px; background-color: #FFF;}
            .tbl-small td {padding: 2px 3px; border: 1px solid #DDD; }
            
            #caption {
                font-size: 12px;
                color: #474747;
                font-weight: bold;
                padding: 2px 0px 3px 0px;
            }
            #divinput {
                margin-bottom: 5px;
                padding-bottom: 5px;
            }
            #debit_value {
                font-size: 12px;
                color: #38839C;
                background-color: #C0ECFA;
                font-weight: bold;
                border-radius: 3px;
                padding: 9px;
            }
            #credit_value {
                font-size: 12px;
                background-color: #E2FAC5; 
                color: #5A8C1D;
                font-weight: bold;
                border-radius: 3px;
                padding: 9px;
            }
            .mydate {
                font-weight: bold;
                color: #474747;
            }
            
            #level_select {
                margin-bottom: 5px;
                padding-bottom: 5px;
                visibility: hidden;
            }
            
            #category_select {
                margin-bottom: 5px;
                padding-bottom: 5px;
                visibility: hidden;
            }
            
            #position_select {
                margin-bottom: 5px;
                padding-bottom: 5px;
                visibility: hidden;
            }
            
            #div_item_sch {
                background-color: #EEE;
                color: #575757;
                padding: 5px 7px;
            }
            
            #record_count{
                font-size: 12px;
                font-weight: bold;
                padding-bottom: 9px;
            }
            #box-form {
                background-color: #EEE; 
                border-radius: 5px;
            }
            .form-style {
                font-size: 12px;
                color: #575757;
                border: 1px solid #DDD;
                border-radius: 5px;
            }
            .form-title {
                color:#474747;
                padding: 11px 21px;
                text-align: left;
                background-color: #CCC;
                border-top-left-radius: 5px;
                border-top-right-radius: 5px;
                font-weight: bold;
            }
            .form-content {
                text-align: left;
                padding: 21px;
                background-color: #EEE;
            }
            .form-footer {
                padding: 21px;
                background-color: #CCC;
                border-bottom-left-radius: 5px;
                border-bottom-right-radius: 5px;
            }
            #confirm {
                padding: 5px 7px;
                background-color: #FF6666;
                color: #FFF;
                border-radius: 3px;
                font-size: 12px;
                font-weight: bold;
                margin-bottom: 5px;
            }
            #btn-confirm {
                padding: 3px 5px; border-radius: 2px;
                background-color: #CF5353; color: #FFF; 
                font-size: 11px; cursor: pointer;
            }
            .footer-page {
                font-size: 12px; 
            }
            h2 {
                padding: 7px 0px 21px 0px;
                margin: 0px 0px 21px 0px;
                border-bottom: 1px solid #DDD;
            }
            .delete {
                background-color: #FAD7DB;
                border-radius: 3px;
                color: #BA5B66;
                font-weight: bold;
                padding: 11px;
            }
        </style>
        <script type="text/javascript">
            function cmdSaveCoa(){
                document.frm.command.value = "<%=Command.SAVE%>";
                document.frm.action = "chart_of_account.jsp";
                document.frm.submit();
            }
            function cmdCancel(){
                document.frm.command.value = "<%=Command.NONE%>";
                document.frm.action = "chart_of_account.jsp";
                document.frm.submit();
            }
            function cmdAddDebit(){
                document.frm.command.value = "<%=Command.ADD%>";
                document.frm.tanda_debit_credit.value = "0";
                document.frm.action = "chart_of_account.jsp";
                document.frm.submit();
            }
            
            function cmdAddCredit(){
                document.frm.command.value = "<%=Command.ADD%>";
                document.frm.tanda_debit_credit.value = "1";
                document.frm.action = "chart_of_account.jsp";
                document.frm.submit();
            }
            function cmdEdit(oid, tanda){
                document.frm.command.value = "<%=Command.EDIT%>";
                document.frm.oid_coa.value = oid;
                document.frm.tanda_debit_credit.value = tanda;
                document.frm.action = "chart_of_account.jsp";
                document.frm.submit();
            }
            function cmdAsk(oid){
                document.frm.command.value = "<%= Command.ASK %>";
                document.frm.oid_coa.value = oid;
                document.frm.action = "chart_of_account.jsp";
                document.frm.submit();
            }
            function cmdDelete(oid){
                document.frm.command.value = "<%= Command.DELETE %>";
                document.frm.oid_coa.value = oid;
                document.frm.action = "chart_of_account.jsp";
                document.frm.submit();
            }
            function cmdNoDelete(){
                document.frm.command.value = "<%= Command.NONE %>";
                document.frm.action = "chart_of_account.jsp";
                document.frm.submit();
            }
            function openDialogMapping(oid){
                window.open("<%=approot%>/payroll/setup/coa_mapping.jsp?<%=FrmComponentCoaMap.fieldNames[FrmComponentCoaMap.FRM_FIELD_ID_PERKIRAAN]%>="+oid, null, "height=500,width=700, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes"); 
            }
        </script>
    </head>
    <body>
        <div class="header">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <%if (headerStyle && !verTemplate.equalsIgnoreCase("0")) {%> 
            <%@include file="../../styletemplate/template_header.jsp" %>
            <%} else {%>
            <tr> 
                <td ID="TOPTITLE" background="<%=approot%>/images/HRIS_HeaderBg3.jpg" width="100%" height="54"> 
                    <!-- #BeginEditable "header" --> 
                    <%@ include file = "../../main/header.jsp" %>
                    <!-- #EndEditable --> 
                </td>
            </tr>
            <tr> 
                <td  bgcolor="#9BC1FF" height="15" ID="MAINMENU" valign="middle"> <!-- #BeginEditable "menumain" --> 
                    <%@ include file = "../../main/mnmain.jsp" %>
                    <!-- #EndEditable --> </td>
            </tr>
            <tr> 
                <td  bgcolor="#9BC1FF" height="10" valign="middle"> 
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr> 
                            <td align="left"><img src="<%=approot%>/images/harismaMenuLeft1.jpg" width="8" height="8"></td>
                            <td align="center" background="<%=approot%>/images/harismaMenuLine1.jpg" width="100%"><img src="<%=approot%>/images/harismaMenuLine1.jpg" width="8" height="8"></td>
                            <td align="right"><img src="<%=approot%>/images/harismaMenuRight1.jpg" width="8" height="8"></td>
                        </tr>
                    </table>
                </td>
            </tr>
            <%}%>
            </table>
        </div>
        <div id="menu_utama">
            <span id="menu_title">Chart of Account</span>
        </div>
        <div class="content-main">
            <form name="frm" method="post" action="">
                <input type="hidden" name="command" value="<%= iCommand %>" />
                <input type="hidden" name="oid_coa" value="<%= oidCoa %>" />
                <input type="hidden" name="tanda_debit_credit" value="<%= tandaDebitCredit %>" />
                
                <table>
                    <tr>
                        <td valign="top">
                            <table>
                                <tr>
                                    <td colspan="2">
                                        <%
                                        if (iCommand == Command.ADD || iCommand == Command.EDIT){
                                            
                                        %>
                                        <div class="form-title">Form Input Chart of Account</div>
                                        <div class="form-content">
                                            <div id="caption">Account code</div>
                                            <div id="divinput">
                                                <input type="text" name="<%= FrmPerkiraan.fieldNames[FrmPerkiraan.FRM_KODE_PERKIRAAN] %>" value="<%= (perkiraan.getKodePerkiraan() != null ? perkiraan.getKodePerkiraan() : "-")%>" />
                                            </div>
                                            <div id="caption">Account number</div>
                                            <div id="divinput">
                                                <input type="text" name="<%= FrmPerkiraan.fieldNames[FrmPerkiraan.FRM_NOPERKIRAAN] %>" value="<%= perkiraan.getNoPerkiraan() %>" />
                                            </div>
                                            <div id="caption">Account name</div>
                                            <div id="divinput">
                                                <input type="text" name="<%= FrmPerkiraan.fieldNames[FrmPerkiraan.FRM_NAMA] %>" size="70" value="<%= perkiraan.getNama() %>" /><br/>
                                                <input type="hidden" name="<%= FrmPerkiraan.fieldNames[FrmPerkiraan.FRM_ACCOUNT_NAME_ENGLISH] %>" value="en" />
                                            </div>
                                            <div id="caption">Level</div>
                                            <div id="divinput">
                                                <select name="<%= FrmPerkiraan.fieldNames[FrmPerkiraan.FRM_LEVEL] %>" class="chosen-select">
                                                    <option value="1" <%=perkiraan.getLevel() == 1 ? "selected" : ""%>>1</option>
                                                    <option value="2" <%=perkiraan.getLevel() == 2 ? "selected" : ""%>>2</option>
                                                    <option value="3" <%=perkiraan.getLevel() == 3 ? "selected" : ""%>>3</option>
                                                </select>
                                            </div>
                                            <div id="caption">Status</div>
                                            <div id="divinput">
                                                <select name="<%= FrmPerkiraan.fieldNames[FrmPerkiraan.FRM_POSTABLE] %>" class="chosen-select">
                                                    <option value="0" <%=perkiraan.getPostable()== 0 ? "selected" : ""%>>Header</option>
                                                    <option value="1" <%=perkiraan.getLevel() == 1 ? "selected" : ""%>>Postable</option>
                                                </select>
                                            </div>
                                            <div id="caption">Parent</div>
                                            <div id="divinput">
                                                <% 
                                                    String whereHeader = PstPerkiraan.fieldNames[PstPerkiraan.FLD_POSTABLE]+" = 0 AND "+
                                                            PstPerkiraan.fieldNames[PstPerkiraan.FLD_TANDA_DEBET_KREDIT]+"="+tandaDebitCredit;
                                                    Vector listHeader = PstPerkiraan.list(0, 0, whereHeader, "");
                                                %>
                                                <select name="<%= FrmPerkiraan.fieldNames[FrmPerkiraan.FRM_IDPARENT] %>" class="chosen-select">
                                                    <option value="0">None</option>
                                                    <%
                                                        for (int i=0; i < listHeader.size(); i++){
                                                            Perkiraan per = (Perkiraan) listHeader.get(i);
                                                            %> <option value="<%=per.getOID()%>">[<%=per.getNoPerkiraan()%>] <%=per.getNama()%></option> <%
                                                        }
                                                    %>
                                                </select>
                                            </div>
                                            <input type="hidden" name="<%= FrmPerkiraan.fieldNames[FrmPerkiraan.FRM_POSTABLE] %>" value="0" />
                                            <input type="hidden" name="<%= FrmPerkiraan.fieldNames[FrmPerkiraan.FRM_LEVEL] %>" value="1" />
                                            <input type="hidden" name="<%= FrmPerkiraan.fieldNames[FrmPerkiraan.FRM_TANDA_DEBET_KREDIT] %>" id="tanda" size="30" value="<%= tandaDebitCredit %>" />
                                            <% if (tandaDebitCredit == 0){ %>
                                            <div id="debit_value">Debit</div>
                                            <% } else {%>
                                            <div id="credit_value">Credit</div>
                                            <% } %>
                                        </div>
                                        <div class="form-footer">
                                            <a class="btn" style="color:#FFF" href="javascript:cmdSaveCoa()">Save</a>
                                            <a class="btn" style="color:#FFF" href="javascript:cmdCancel()">Cancel</a>
                                        </div>
                                        <% } %>
                                    </td>
                                </tr>
                                <% if (iCommand == Command.ASK ){ %>
                                <tr>
                                    <td colspan="2">
                                        <div class="delete">
                                            Are you sure to delete data? 
                                            <a href="javascript:cmdDelete('<%= oidCoa %>')">Yes</a> | 
                                            <a href="javascript:cmdNoDelete()">No</a>
                                        </div>
                                    </td>
                                </tr>
                                <% } %>
                                <tr>
                                    <td valign="top">
                                        <div  onclick="javascript:cmdAddDebit()" class="box-info-debit">Add Debit</div>
                                    </td>
                                    <td valign="top">
                                        <div onclick="javascript:cmdAddCredit()" class="box-info-credit">Add Credit</div>
                                    </td>
                                </tr>
                                <tr>
                                    <td valign="top">
                                        <table class="tblStyle">
                                            <tr>
                                                <td class="title_tbl">Account</td>
                                                <td class="title_tbl">Kode</td>
                                                <td class="title_tbl">Title</td>
                                                <td class="title_tbl">Status</td>
                                                <td class="title_tbl">Mapping</td>
                                                <td class="title_tbl">Action</td>
                                            </tr>
                                        <%
                                            if (listPerkiraanDebit != null && listPerkiraanDebit.size()>0){
                                                for(int i=0; i<listPerkiraanDebit.size(); i++){
                                                    Perkiraan perkiraanDebit = (Perkiraan)listPerkiraanDebit.get(i);
                                                    String wCheck = PstComponentCoaMap.fieldNames[PstComponentCoaMap.FLD_ID_PERKIRAAN]+"="+perkiraanDebit.getOID();
                                                    Vector listCoaCheck = PstComponentCoaMap.list(0, 0, wCheck, "");
                                                    String color = "";
                                                    if (listCoaCheck != null && listCoaCheck.size()>0){
                                                        color = "style=\"color:#B5D408;\"";
                                                    } else {
                                                        color = "style=\"color:#797979;\"";
                                                    }
                                            %>
                                            <tr>
                                                <td><%= perkiraanDebit.getNoPerkiraan() %></td>
                                                <td><%= (perkiraanDebit.getKodePerkiraan() != null ? perkiraanDebit.getKodePerkiraan() : "-")%></td>
                                                <td><%= perkiraanDebit.getNama() %></td>
                                                <td><%= perkiraanDebit.getPostable() == 1 ? "Postable" : "Header" %></td>
                                                <% if (perkiraanDebit.getPostable() == 0 ){ %>
                                                <td>&nbsp;</td>
                                                <% } else { %>
                                                <td><a <%= color %> href="javascript:openDialogMapping('<%= perkiraanDebit.getOID() %>')">Mapping</a></td>
                                                <% } %>
                                                <td>
                                                    <a href="javascript:cmdEdit('<%= perkiraanDebit.getOID() %>', '0')">edit</a> | 
                                                    <a href="javascript:cmdAsk('<%= perkiraanDebit.getOID() %>')">delete</a>
                                                </td>
                                            </tr>
                                            <% 
                                                String whereChild = PstPerkiraan.fieldNames[PstPerkiraan.FLD_ID_PARENT]+"="+perkiraanDebit.getOID();
                                                Vector listChild = PstPerkiraan.list(0, 0, whereChild, "");
                                                for (int x=0; x < listChild.size(); x++){
                                                    Perkiraan perChild = (Perkiraan) listChild.get(x);
                                                    String wCheckChild = PstComponentCoaMap.fieldNames[PstComponentCoaMap.FLD_ID_PERKIRAAN]+"="+perChild.getOID();
                                                    Vector listCoaCheckChild = PstComponentCoaMap.list(0, 0, wCheckChild, "");
                                                    String colorChild = "";
                                                    if (listCoaCheckChild != null && listCoaCheckChild.size()>0){
                                                        colorChild = "style=\"color:#B5D408;\"";
                                                    } else {
                                                        colorChild = "style=\"color:#797979;\"";
                                                    }
                                                    %>
                                                    <tr>
                                                        <td>&nbsp;&nbsp;<%=perChild.getNoPerkiraan()%></td>
                                                        <td><%= (perChild.getKodePerkiraan() != null ? perChild.getKodePerkiraan() : "-")%></td>
                                                        <td><%= perChild.getNama() %></td>
                                                        <td><%= perChild.getPostable() == 1 ? "Postable" : "Header" %></td>
                                                        <td><a <%= colorChild %> href="javascript:openDialogMapping('<%= perChild.getOID() %>')">Mapping</a></td>
                                                        <td>
                                                            <a href="javascript:cmdEdit('<%= perChild.getOID() %>', '0')">edit</a> | 
                                                            <a href="javascript:cmdAsk('<%= perChild.getOID() %>')">delete</a>
                                                        </td>
                                                    </tr>
                                                    <%
                                                }
                                                
                                            
                                                } 
                                            }
                                            %>
                                        </table>
                                    </td>
                                    <td valign="top">
                                        <table class="tblStyle">
                                            <tr>
                                                <td class="title_tbl">Account</td>
                                                <td class="title_tbl">Kode</td>
                                                <td class="title_tbl">Title</td>
                                                <td class="title_tbl">Status</td>
                                                <td class="title_tbl">Mapping</td>
                                                <td class="title_tbl">Action</td>
                                            </tr>
                                            <%
                                            if (listPerkiraanCredit != null && listPerkiraanCredit.size()>0){
                                                for(int i=0; i<listPerkiraanCredit.size(); i++){
                                                    Perkiraan perkiraanCredit = (Perkiraan)listPerkiraanCredit.get(i);
                                                    String wCheck = PstComponentCoaMap.fieldNames[PstComponentCoaMap.FLD_ID_PERKIRAAN]+"="+perkiraanCredit.getOID();
                                                    Vector listCoaCheck = PstComponentCoaMap.list(0, 0, wCheck, "");
                                                    String color = "";
                                                    if (listCoaCheck != null && listCoaCheck.size()>0){
                                                        color = "style=\"color:#B5D408;\"";
                                                    } else {
                                                        color = "style=\"color:#797979;\"";
                                                    }
                                            %>
                                            <tr>
                                                <td><%= perkiraanCredit.getNoPerkiraan() %></td>
                                                <td><%= (perkiraanCredit.getKodePerkiraan() != null ? perkiraanCredit.getKodePerkiraan() : "-")%></td>
                                                <td><%= perkiraanCredit.getNama() %></td>
                                                <td><%= perkiraanCredit.getPostable() == 1 ? "Postable" : "Header" %></td>
                                                <% if (perkiraanCredit.getPostable() == 0 ){ %>
                                                <td>&nbsp;</td>
                                                <% } else { %>
                                                <td><a <%= color %> href="javascript:openDialogMapping('<%= perkiraanCredit.getOID() %>')">Mapping</a></td>
                                                <% } %>
                                                <td>
                                                    <a href="javascript:cmdEdit('<%= perkiraanCredit.getOID() %>','1')">edit</a> | 
                                                    <a href="javascript:cmdAsk('<%= perkiraanCredit.getOID() %>')">delete</a>
                                                </td>
                                            </tr>
                                            <%
                                            
                                                String whereChild = PstPerkiraan.fieldNames[PstPerkiraan.FLD_ID_PARENT]+"="+perkiraanCredit.getOID();
                                                Vector listChild = PstPerkiraan.list(0, 0, whereChild, "");
                                                for (int x=0; x < listChild.size(); x++){
                                                    Perkiraan perChild = (Perkiraan) listChild.get(x);
                                                    String wCheckChild = PstComponentCoaMap.fieldNames[PstComponentCoaMap.FLD_ID_PERKIRAAN]+"="+perChild.getOID();
                                                    Vector listCoaCheckChild = PstComponentCoaMap.list(0, 0, wCheckChild, "");
                                                    String colorChild = "";
                                                    if (listCoaCheckChild != null && listCoaCheckChild.size()>0){
                                                        colorChild = "style=\"color:#B5D408;\"";
                                                    } else {
                                                        colorChild = "style=\"color:#797979;\"";
                                                    }
                                                    %>
                                                    <tr>
                                                        <td>&nbsp;&nbsp;<%=perChild.getNoPerkiraan()%></td>
                                                        <td><%= (perChild.getKodePerkiraan() != null ? perChild.getKodePerkiraan() : "-")%></td>
                                                        <td><%= perChild.getNama() %></td>
                                                        <td><%= perChild.getPostable() == 1 ? "Postable" : "Header" %></td>
                                                        <td><a <%= colorChild %> href="javascript:openDialogMapping('<%= perChild.getOID() %>')">Mapping</a></td>
                                                        <td>
                                                            <a href="javascript:cmdEdit('<%= perChild.getOID() %>', '0')">edit</a> | 
                                                            <a href="javascript:cmdAsk('<%= perChild.getOID() %>')">delete</a>
                                                        </td>
                                                    </tr>
                                                    <%
                                                }
                                            
                                                }
                                            }
                                            %>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </td>
                        <td valign="top">
                            
                        </td>
                    </tr>
                </table>
            </form>
        </div>
        <div class="footer-page">
            <table>
                <%if (headerStyle && !verTemplate.equalsIgnoreCase("0")) {%>
                <tr>
                    <td valign="bottom"><%@include file="../../footer.jsp" %></td>
                </tr>
                <%} else {%>
                <tr> 
                    <td colspan="2" height="20" ><%@ include file = "../../main/footer.jsp" %></td>
                </tr>
                <%}%>
            </table>
        </div>
    </body>
</html>

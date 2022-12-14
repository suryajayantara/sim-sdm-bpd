
<%@page import="com.dimata.harisma.entity.log.ChangeValue"%>
<%@page import="java.text.SimpleDateFormat"%>
<%
            /*
             * Page Name  		:  position.jsp
             * Created on 		:  [date] [time] AM/PM
             *
             * @author  		: gadnyana
             * @version  		: 01
             */

            /*******************************************************************
             * Page Description 	: [project description ... ]
             * Imput Parameters 	: [input parameter ...]
             * Output 			: [output ...]
             *******************************************************************/
%>
<%@ page language = "java" %>
<!-- package java -->
<%@ page import = "java.util.*" %>
<!-- package dimata -->
<%@ page import = "com.dimata.util.*" %>
<!-- package qdep -->
<%@ page import = "com.dimata.gui.jsp.*" %>
<%@ page import = "com.dimata.qdep.form.*" %>
<!--package harisma -->
<%@ page import = "com.dimata.harisma.entity.masterdata.*" %>
<%@ page import = "com.dimata.harisma.form.masterdata.*" %>
<%@ page import = "com.dimata.harisma.entity.admin.*" %>

<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_MASTERDATA, AppObjInfo.G2_MD_COMPANY, AppObjInfo.OBJ_DIVISION);%>
<%@ include file = "../main/checkuser.jsp" %>
<%
            /* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
//boolean privAdd=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
//boolean privUpdate=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
//boolean privDelete=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
%>
<!-- Jsp Block -->
<%!    public String drawList(Vector objectClass, long divisionId, I_Dictionary dictionaryD ) {
        ControlList ctrlist = new ControlList();
        ctrlist.setAreaWidth("100%");
        ctrlist.setListStyle("tblStyle");
        ctrlist.setTitleStyle("title_tbl");
        ctrlist.setCellStyle("listgensell");
        ctrlist.setHeaderStyle("title_tbl");
        ctrlist.setCellSpacing("0");
        ctrlist.addHeader(dictionaryD.getWord(I_Dictionary.COMPANY), "");
        ctrlist.addHeader(dictionaryD.getWord(I_Dictionary.DIVISION), "");
        ctrlist.addHeader(dictionaryD.getWord(I_Dictionary.DESCRIPTION), "");
        ctrlist.addHeader(dictionaryD.getWord(I_Dictionary.TYPE), "");
        ctrlist.addHeader("Employee", "");
        ctrlist.setLinkRow(1);
        ctrlist.setLinkSufix("");
        Vector lstData = ctrlist.getData();
        Vector lstLinkData = ctrlist.getLinkData();
        ctrlist.setLinkPrefix("javascript:cmdEdit('");
        ctrlist.setLinkSufix("')");
        ctrlist.reset();
        int index = -1;

        for (int i = 0; i < objectClass.size(); i++) {
            Division division = (Division) objectClass.get(i);
            Vector rowx = new Vector();
            if (divisionId == division.getOID()) {
                index = i;
            }
            Company company = new Company();
            try {
                company = PstCompany.fetchExc(division.getCompanyId());
            } catch (Exception e) {
            }
            rowx.add(company.getCompany());
            rowx.add(division.getDivision());
            rowx.add(division.getDescription());
            DivisionType divType = new DivisionType();
            String divisionTypeName = "-";
            try {
                divType = PstDivisionType.fetchExc(division.getDivisionTypeId());
                divisionTypeName = divType.getTypeName();
            } catch (Exception e){
                //System.out.print("getDivisionType=>"+e.toString());//
            }
            rowx.add(divisionTypeName);
            rowx.add(division.getEmployeeId());
            lstData.add(rowx);
            lstLinkData.add(String.valueOf(division.getOID()));
        }
        return ctrlist.draw(index);
    }

%>
<%
            int iCommand = FRMQueryString.requestCommand(request);
            int start = FRMQueryString.requestInt(request, "start");
            int prevCommand = FRMQueryString.requestInt(request, "prev_command");
            long oidDivision = FRMQueryString.requestLong(request, "hidden_division_id");

            /*variable declaration*/
            int recordToGet = 50;
            String msgString = "";
            int iErrCode = FRMMessage.NONE;
            String whereClause = "";
            String orderClause = " COMPANY_ID, DIVISION ";
            ChangeValue changeValue = new ChangeValue();
            CtrlDivision ctrlDivision = new CtrlDivision(request);
            ControlLine ctrLine = new ControlLine();
            Vector listDivision = new Vector(1, 1);

            /*switch statement */
            iErrCode = ctrlDivision.action(iCommand, oidDivision);
            /* end switch*/
            FrmDivision frmDivision = ctrlDivision.getForm();

            /*count list All Position*/
            int vectSize = PstDivision.getCount(whereClause);

            Division division = ctrlDivision.getDivision();
            msgString = ctrlDivision.getMessage();

            /*switch list Division*/
            if ((iCommand == Command.SAVE) && (iErrCode == FRMMessage.NONE)) {
                //start = PstDivision.findLimitStart(division.getOID(),recordToGet, whereClause);
                oidDivision = division.getOID();
            }

            if ((iCommand == Command.FIRST || iCommand == Command.PREV)
                    || (iCommand == Command.NEXT || iCommand == Command.LAST)) {
                start = ctrlDivision.actionList(iCommand, start, vectSize, recordToGet);
            }
            /* end switch list*/

            /* get record to display */
            listDivision = PstDivision.list(start, recordToGet, whereClause, orderClause);

            /*handle condition if size of record to display = 0 and start > 0 	after delete*/
            if (listDivision.size() < 1 && start > 0) {
                if (vectSize - recordToGet > recordToGet) {
                    start = start - recordToGet;   //go to Command.PREV
                } else {
                    start = 0;
                    iCommand = Command.FIRST;
                    prevCommand = Command.FIRST; //go to Command.FIRST
                }
                listDivision = PstDivision.list(start, recordToGet, whereClause, orderClause);
            }

            I_Dictionary dictionaryD = userSession.getUserDictionary();
                                        dictionaryD.loadWord();
%>
<html><!-- #BeginTemplate "/Templates/main.dwt" -->
    <head>
        <!-- #BeginEditable "doctitle" -->
        <title>HARISMA - Master Data Division</title>
        <script language="JavaScript">
            function cmdSearch(){
                document.frmdivision.command.value="<%= Command.SEARCH %>";
                document.frmdivision.action="division.jsp";
                document.frmdivision.submit();
            }

            function cmdAdd(){
                document.frmdivision.hidden_division_id.value="0";
                document.frmdivision.command.value="<%=Command.ADD%>";
                document.frmdivision.prev_command.value="<%=prevCommand%>";
                document.frmdivision.action="division.jsp";
                document.frmdivision.submit();
            }

            function cmdAsk(oidDivision){
                document.frmdivision.hidden_division_id.value=oidDivision;
                document.frmdivision.command.value="<%=Command.ASK%>";
                document.frmdivision.prev_command.value="<%=prevCommand%>";
                document.frmdivision.action="division.jsp";
                document.frmdivision.submit();
            }

            function cmdConfirmDelete(oidDivision){
                document.frmdivision.hidden_division_id.value=oidDivision;
                document.frmdivision.command.value="<%=Command.DELETE%>";
                document.frmdivision.prev_command.value="<%=prevCommand%>";
                document.frmdivision.action="division.jsp";
                document.frmdivision.submit();
            }
            function cmdSave(){
                document.frmdivision.command.value="<%=Command.SAVE%>";
                document.frmdivision.prev_command.value="<%=prevCommand%>";
                document.frmdivision.action="division.jsp";
                document.frmdivision.submit();
            }

            function cmdEdit(oidDivision){
                document.frmdivision.hidden_division_id.value=oidDivision;
                document.frmdivision.command.value="<%=Command.EDIT%>";
                document.frmdivision.prev_command.value="<%=prevCommand%>";
                document.frmdivision.action="division.jsp";
                document.frmdivision.submit();
            }

            function cmdCancel(oidDivision){
                document.frmdivision.hidden_division_id.value=oidDivision;
                document.frmdivision.command.value="<%=Command.EDIT%>";
                document.frmdivision.prev_command.value="<%=prevCommand%>";
                document.frmdivision.action="division.jsp";
                document.frmdivision.submit();
            }

            function cmdBack(){
                document.frmdivision.command.value="<%=Command.BACK%>";
                document.frmdivision.action="division.jsp";
                document.frmdivision.submit();
            }
            function cmdValid(){
                window.open("set_all_valid.jsp?master=division", null, "height=550,width=500, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");  
            }
            function cmdExportExcel(){
                    var xmlhttp = new XMLHttpRequest();
                    xmlhttp.onreadystatechange = function() {
                        if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                            document.getElementById("div_respon").innerHTML = xmlhttp.responseText;
                        }
                    };
                    var valid_status_select = document.frmdivision.valid_status_select.value;
                    var division_name = document.frmdivision.division_name.value;
                    if (division_name.length <= 0) { 
                    division_name = "0";
                    }
                    var linkPage = "<%=approot%>/masterdata/export_excel/export_excel_satuan_kerja.jsp?division_name="+division_name+"&valid_status_select="+ valid_status_select;    
                    var newWin = window.open(linkPage,"attdReportDaily","height=700,width=990,status=yes,toolbar=yes,menubar=no,resizable=yes,scrollbars=yes,location=yes"); 			
                    newWin.focus();
                    xmlhttp.open("GET", linkPage, true);
                    xmlhttp.send();
                }

        </script>
        <!-- #EndEditable -->
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
        <!-- #BeginEditable "styles" -->
        <link rel="stylesheet" href="../styles/main.css" type="text/css">
        <!-- #EndEditable -->
        <!-- #BeginEditable "stylestab" -->
        <link rel="stylesheet" href="../styles/tab.css" type="text/css">
        <!-- #EndEditable -->
        <!-- #BeginEditable "headerscript" -->
        <script type="text/javascript">
           function loadList(division_name) {
                valid_status_select = document.frmdivision.valid_status_select.value;
                if (division_name.length == 0) { 
                    division_name = "0";
                    
                } 
                var xmlhttp = new XMLHttpRequest();
                xmlhttp.onreadystatechange = function() {
                    if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                        document.getElementById("div_respon").innerHTML = xmlhttp.responseText;
                    }
                };
                
                xmlhttp.open("GET", "division_ajax.jsp?division_name=" + division_name+"&valid_status_select="+ valid_status_select, true);
                xmlhttp.send();
                
            }
            
            function prepare(){
                loadList("0");
            }
            
            function cmdListFirst(start){
                var division_name = document.frmdivision.division_name.value;
                var xmlhttp = new XMLHttpRequest();
                xmlhttp.onreadystatechange = function() {
                    if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                        document.getElementById("div_respon").innerHTML = xmlhttp.responseText;
                    }
                };
                xmlhttp.open("GET", "division_ajax.jsp?division_name="+division_name+"&valid_status_select="+ valid_status_select+"&command=" + <%=Command.FIRST%> + "&start="+start, true);
                xmlhttp.send();
            }

            function cmdListPrev(start){
                var division_name = document.frmdivision.division_name.value;
                var xmlhttp = new XMLHttpRequest();
                xmlhttp.onreadystatechange = function() {
                    if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                        document.getElementById("div_respon").innerHTML = xmlhttp.responseText;
                    }
                };
                xmlhttp.open("GET", "division_ajax.jsp?division_name="+division_name+"&valid_status_select="+ valid_status_select+"&command=" + <%=Command.PREV%> + "&start="+start, true);
                xmlhttp.send();
            }

            function cmdListNext(start){
                var division_name = document.frmdivision.division_name.value;
                var xmlhttp = new XMLHttpRequest();
                xmlhttp.onreadystatechange = function() {
                    if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                        document.getElementById("div_respon").innerHTML = xmlhttp.responseText;
                    }
                };
                xmlhttp.open("GET", "division_ajax.jsp?division_name="+division_name+"&valid_status_select="+ valid_status_select+"&command=" + <%=Command.NEXT%> + "&start="+start, true);
                xmlhttp.send();
            }

            function cmdListLast(start){
                var division_name = document.frmdivision.division_name.value;
                var xmlhttp = new XMLHttpRequest();
                xmlhttp.onreadystatechange = function() {
                    if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                        document.getElementById("div_respon").innerHTML = xmlhttp.responseText;
                    }
                };
                xmlhttp.open("GET", "division_ajax.jsp?division_name="+division_name+"&valid_status_select="+ valid_status_select+"&command=" + <%=Command.LAST%> + "&start="+start, true);
                xmlhttp.send();
            }
            
            function browse(divisionId){
                newWindow=window.open("division_emp.jsp?division_id="+divisionId,"DivisionEmp", "height=600, width=500, status=yes, toolbar=no, menubar=no, location=center, scrollbars=yes");
                newWindow.focus();
            }
        </script>
        <style type="text/css">
            .tblStyle {border-collapse: collapse; font-size: 12px;}
            .tblStyle td {padding: 7px 9px; border: 1px solid #CCC; font-size: 12px; background-color: #FFF;}
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
            .breadcrumb {
                background-color: #EEE;
                color:#0099FF;
                padding: 7px 9px;
            }
            .navbar {
                font-family: sans-serif;
                font-size: 12px;
                background-color: #0084ff;
                padding: 7px 9px;
                color : #FFF;
                border-top:1px solid #0084ff;
                border-bottom: 1px solid #0084ff;
            }
            .navbar ul {
                list-style-type: none;
                margin: 0;
                padding: 0;
            }

            .navbar li {
                padding: 7px 9px;
                display: inline;
                cursor: pointer;
            }
            
            .navbar li a {
                color : #F5F5F5;
                text-decoration: none;
            }
            
            .navbar li a:hover {
                color:#FFF;
            }
            
            .navbar li a:active {
                color:#FFF;
            }

            .navbar li:hover {
                background-color: #0b71d0;
                border-bottom: 1px solid #033a6d;
            }

            .active {
                background-color: #0b71d0;
                border-bottom: 1px solid #033a6d;
            }
            .title_part {color:#FF7E00; background-color: #F7F7F7; border-left: 1px solid #0099FF; padding: 9px 11px;}
            
            body {background-color: #EEE;}
            .header {
                
            }
            .content-main {
                padding: 21px 32px;
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
                margin: 17px 7px;
                background-color: #FFF;
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
            .box-info {
                padding:21px 43px; 
                background-color: #F7F7F7;
                border-bottom: 1px solid #CCC;
                -webkit-box-shadow: 0 1px 4px rgba(0, 0, 0, 0.065);
                 -moz-box-shadow: 0 1px 4px rgba(0, 0, 0, 0.065);
                      box-shadow: 0 1px 4px rgba(0, 0, 0, 0.065);
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
            
            #photo {
                padding: 7px; 
                background-color: #FFF; 
                border: 1px solid #DDD;
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
                padding: 11px 21px;
                text-align: left;
                border-bottom: 1px solid #DDD;
                background-color: #FFF;
                border-top-left-radius: 5px;
                border-top-right-radius: 5px;
                font-weight: bold;
            }
            .form-content {
                text-align: left;
                padding: 21px;
                background-color: #DDD;
            }
            .form-footer {
                border-top: 1px solid #DDD;
                padding: 11px 21px;
                background-color: #FFF;
                border-bottom-left-radius: 5px;
                border-bottom-right-radius: 5px;
            }
            #confirm {
                padding: 13px 17px;
                background-color: #FF6666;
                color: #FFF;
                border-radius: 3px;
                font-size: 12px;
                font-weight: bold;
                visibility: hidden;
            }
            #btn-confirm {
                padding: 4px 9px; border-radius: 3px;
                background-color: #CF5353; color: #FFF; 
                font-size: 11px; cursor: pointer;
            }
            .footer-page {
                font-size: 12px;
            }
            .btn-small-e {
                font-family: sans-serif;
                text-decoration: none;
                padding: 3px 5px; 
                background-color: #92C8E8; color: #F5F5F5; 
                font-size: 11px; cursor: pointer;
                border-radius: 3px;
            }
            .btn-small-e:hover { background-color: #659FC2; color: #FFF;}
            
            .btn-small-x {
                font-family: sans-serif;
                text-decoration: none;
                padding: 3px 5px; 
                background-color: #EB9898; color: #F5F5F5; 
                font-size: 11px; cursor: pointer;
                border-radius: 3px;
            }
            .btn-small-x:hover { background-color: #D14D4D; color: #FFF;}
            
        </style>
        <!-- #EndEditable -->
<link rel="stylesheet" href="<%=approot%>/javascripts/datepicker/themes/jquery.ui.all.css">
<script src="<%=approot%>/javascripts/jquery.js"></script>
<script src="<%=approot%>/javascripts/datepicker/jquery.ui.core.js"></script>
<script src="<%=approot%>/javascripts/datepicker/jquery.ui.widget.js"></script>
<script src="<%=approot%>/javascripts/datepicker/jquery.ui.datepicker.js"></script>
<script>
$(function() {
    $( "#datepicker1" ).datepicker({ dateFormat: "yy-mm-dd" });
    $( "#datepicker2" ).datepicker({ dateFormat: "yy-mm-dd" });
});
</script>
    </head>

    <body onload="prepare()">
        <div class="header">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <%if (headerStyle && !verTemplate.equalsIgnoreCase("0")) {%> 
            <%@include file="../styletemplate/template_header.jsp" %>
            <%} else {%>
            <tr> 
                <td ID="TOPTITLE" background="<%=approot%>/images/HRIS_HeaderBg3.jpg" width="100%" height="54"> 
                    <!-- #BeginEditable "header" --> 
                    <%@ include file = "../main/header.jsp" %>
                    <!-- #EndEditable --> 
                </td>
            </tr>
            <tr> 
                <td  bgcolor="#9BC1FF" height="15" ID="MAINMENU" valign="middle"> <!-- #BeginEditable "menumain" --> 
                    <%@ include file = "../main/mnmain.jsp" %>
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
            <span id="menu_title">Masterdata <strong style="color:#333;"> / </strong><%=dictionaryD.getWord(I_Dictionary.DIVISION) %></span>
        </div>
        <div class="content-main">
            <form name="frmdivision" method ="post" action="">
            <input type="hidden" name="command" value="<%=iCommand%>">
            <input type="hidden" name="vectSize" value="<%=vectSize%>">
            <input type="hidden" name="start" value="<%=start%>">
            <input type="hidden" name="prev_command" value="<%=prevCommand%>">
            <input type="hidden" name="hidden_division_id" value="<%=oidDivision%>">
            <table>
                <tr>
                    <td valign="top">
                        <a class="btn" style="color:#FFF" href="javascript:cmdValid()">Set Valid Status</a>
                        <%
                            if ((iCommand != Command.ADD && iCommand != Command.ASK && iCommand != Command.EDIT) && (frmDivision.errorSize() < 1)) {
                                if (privAdd) {
                                    %>
                                    <a class="btn" style="color:#FFF" href="javascript:cmdAdd()">Tambah Data</a>
                                    <%
                                }
                            }
                        %>
                        <input type="text" style="padding:6px 7px" name="division_name" onkeyup="loadList(this.value)" placeholder="Cari Satuan Kerja..." size="70" />
                        <b> Valid Status</b>
                        <select id="valid_status_select" name="valid_status_select"  onkeyup="loadList('')" onchange="loadList('')" >
                            <option value="2">-All-</option>
                            <option selected value="<%=PstDivision.VALID_ACTIVE%>"><%= PstDivision.validStatusValue[PstDivision.VALID_ACTIVE] %></option>
                            <option value="<%=PstDivision.VALID_HISTORY%>"><%= PstDivision.validStatusValue[PstDivision.VALID_HISTORY] %></option>
                        </select>
                        <a class="btn" style="color:#FFF" href="javascript:cmdExportExcel()">Export Excel</a>
                        <div>&nbsp;</div>
                        <div id="div_respon"></div>
                        <div>&nbsp;</div>
                    </td>
                </tr>
                    <td valign="top">
                        <%if ((iCommand == Command.ADD) || (iCommand == Command.SAVE) && (frmDivision.errorSize() > 0) || (iCommand == Command.EDIT) || (iCommand == Command.ASK)) {%>
                <tr>
                        
                            
                                <table border="0" cellspacing="2" cellpadding="2">
                                    <tr>
                                        <td height="100%">
                                            <table border="0" cellspacing="2" cellpadding="2">
                                                <tr align="left">
                                                    <td valign="middle">&nbsp;</td>
                                                    <td valign="middle" class="comment">*)entry required </td>
                                                </tr>
                                                <tr align="left">
                                                    <td valign="middle">
                                                        <%=dictionaryD.getWord(I_Dictionary.DIVISION)%></td>
                                                    <td valign="middle">
                                                        <input type="text" name="<%=frmDivision.fieldNames[FrmDivision.FRM_FIELD_DIVISION]%>"  value="<%= division.getDivision()%>" class="elemenForm" size="50">
                                                        *<%=frmDivision.getErrorMsg(FrmDivision.FRM_FIELD_DIVISION)%>
                                                    </td>
                                                </tr>
                                                <tr align="left">
                                                    <td valign="middle"><%=dictionaryD.getWord(I_Dictionary.COMPANY)%></td>
                                                    <td valign="middle">
                                                        <%
                                                            Vector compKey = new Vector(1, 1);
                                                            Vector compValue = new Vector(1, 1);
                                                            Vector listComp = PstCompany.list(0, 0, "", "COMPANY");
                                                            for (int i = 0; i < listComp.size(); i++) {
                                                                Company company = (Company) listComp.get(i);
                                                                compKey.add(company.getCompany());
                                                                compValue.add("" + company.getOID());
                                                            }
                                                        %>
                                                        <%=ControlCombo.draw(frmDivision.fieldNames[FrmDivision.FRM_FIELD_COMPANY_ID], "formElemen", null, "" +division.getCompanyId(), compValue, compKey)%>
                                                        * <%=frmDivision.getErrorMsg(frmDivision.FRM_FIELD_COMPANY_ID)%>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td valign="middle">
                                                        <%=dictionaryD.getWord(I_Dictionary.DIVISION)+" "+dictionaryD.getWord("DESCRIPTION")%> </td>
                                                    <td valign="middle">
                                                        <textarea name="<%=frmDivision.fieldNames[FrmDivision.FRM_FIELD_DESCRIPTION]%>" class="elemenForm" cols="30" rows="3"><%= division.getDescription()%></textarea>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td valign="middle">
                                                        Division Type Id
                                                    </td>
                                                    <td valign="middle">
                                                        <select name="<%=frmDivision.fieldNames[FrmDivision.FRM_FIELD_DIVISION_TYPE_ID]%>">
                                                            <option value="0">-select-</option>
                                                            <%
                                                            Vector listDivisionType = PstDivisionType.list(0, 0, "", "");
                                                            if (listDivisionType != null && listDivisionType.size()>0){
                                                                for(int ldt=0; ldt<listDivisionType.size(); ldt++){
                                                                    DivisionType divT = (DivisionType)listDivisionType.get(ldt);
                                                                    if (division.getDivisionTypeId()== divT.getOID()){
                                                                        %>
                                                                        <option selected="selected" value="<%=divT.getOID()%>"><%=divT.getTypeName()%></option>
                                                                        <%
                                                                    } else {
                                                                        %>
                                                                        <option value="<%=divT.getOID()%>"><%=divT.getTypeName()%></option>
                                                                        <%
                                                                    }
                                                                }
                                                            }
                                                            %>

                                                        </select>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td valign="middle">Level Satuan Kerja</td>
                                                    <td valign="middle">
                                                        <select name="<%=frmDivision.fieldNames[FrmDivision.FRM_FIELD_LEVEL_DIVISION]%>">
                                                            <%
                                                            for(int x = 0 ; x < PstDivision.divisionLevel.length ; x++){
                                                                
                                                                if (division.getLevelDivision()==x){
                                                                    %>
                                                                    <option value="<%=x%>" selected="selected"><%=PstDivision.divisionLevelName[x]%></option>
                                                                    <%
                                                                } else {
                                                                    %>
                                                                     <option value="<%=x%>" ><%=PstDivision.divisionLevelName[x]%></option>
                                                                    <%
                                                                }
                                                            }
                                                            %>
                                                        </select>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td valign="middle">Valid Status</td>
                                                    <td valign="middle">
                                                        <select name="<%=frmDivision.fieldNames[FrmDivision.FRM_FIELD_VALID_STATUS]%>">
                                                            <%
                                                            if (division.getValidStatus()==PstDivision.VALID_ACTIVE){
                                                                %>
                                                                <option value="<%=PstDivision.VALID_ACTIVE%>" selected="selected">Active</option>
                                                                <option value="<%=PstDivision.VALID_HISTORY%>">History</option>
                                                                <%
                                                            } else {
                                                                %>
                                                                <option value="<%=PstDivision.VALID_ACTIVE%>">Active</option>
                                                                <option value="<%=PstDivision.VALID_HISTORY%>" selected="selected">History</option>
                                                                <%
                                                            }
                                                            %>
                                                        </select>
                                                    </td>
                                                </tr>
                                                <tr>
                                                        <td valign="top">Masa berlaku</td>
                                                        <td valign="top">
                                                            <%
                                                            String DATE_FORMAT_NOW = "yyyy-MM-dd";
                                                            Date dateStart = division.getValidStart() == null ? new Date() : division.getValidStart();
                                                            Date dateEnd = division.getValidEnd() == null ? new Date() : division.getValidEnd();
                                                            SimpleDateFormat sdf = new SimpleDateFormat(DATE_FORMAT_NOW);
                                                            String strValidStart = sdf.format(dateStart);
                                                            String strValidEnd = sdf.format(dateEnd);
                                                            %>
                                                            <input type="text" name="<%=frmDivision.fieldNames[frmDivision.FRM_FIELD_VALID_START]%>" id="datepicker1" value="<%=strValidStart%>" />&nbsp;to
                                                            &nbsp;<input type="text" name="<%=frmDivision.fieldNames[frmDivision.FRM_FIELD_VALID_END]%>" id="datepicker2" value="<%=strValidEnd%>" />
                                                        </td>
                                                    </tr>
                                                <tr>
                                                    <td colspan="2">
                                                        <div class="note">
                                                            <strong>note:</strong> fill some of field below, if you choose Branch of Company
                                                        </div>
                                                    </td>
                                                </tr>

                                                <tr>
                                                    <td valign="middle">
                                                        Address
                                                    </td>
                                                    <td valign="middle">
                                                        <input type="text" name="<%=frmDivision.fieldNames[FrmDivision.FRM_FIELD_ADDRESS]%>" size="50" value="<%=division.getAddress()%>" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td valign="middle">
                                                        City
                                                    </td>
                                                    <td valign="middle">
                                                       <input type="text" name="<%=frmDivision.fieldNames[FrmDivision.FRM_FIELD_CITY]%>" size="50" value="<%=division.getCity()%>" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td valign="middle">
                                                        NPWP
                                                    </td>
                                                    <td valign="middle">
                                                       <input type="text" name="<%=frmDivision.fieldNames[FrmDivision.FRM_FIELD_NPWP]%>" size="50" value="<%=division.getNpwp()%>" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td valign="middle">
                                                        Nama Pemotong
                                                    </td>
                                                    <td valign="middle">
                                                       <input type="text" name="<%=frmDivision.fieldNames[FrmDivision.FRM_FIELD_PEMOTONG]%>" size="50" value="<%=division.getPemotong()%>" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td valign="middle">
                                                        Province
                                                    </td>
                                                    <td valign="middle">
                                                       <input type="text" name="<%=frmDivision.fieldNames[FrmDivision.FRM_FIELD_PROVINCE]%>" size="50" value="<%=division.getProvince()%>" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td valign="middle">
                                                        Region
                                                    </td>
                                                    <td valign="middle">
                                                       <input type="text" name="<%=frmDivision.fieldNames[FrmDivision.FRM_FIELD_REGION]%>" size="50" value="<%=division.getRegion()%>" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td valign="middle">
                                                        Sub Region
                                                    </td>
                                                    <td valign="middle">
                                                       <input type="text" name="<%=frmDivision.fieldNames[FrmDivision.FRM_FIELD_SUB_REGION]%>" size="50" value="<%=division.getSubRegion()%>" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td valign="middle">
                                                        Village
                                                    </td>
                                                    <td valign="middle">
                                                       <input type="text" name="<%=frmDivision.fieldNames[FrmDivision.FRM_FIELD_VILLAGE]%>" size="50" value="<%=division.getVillage()%>" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td valign="middle">
                                                        Area
                                                    </td>
                                                    <td valign="middle">
                                                       <input type="text" name="<%=frmDivision.fieldNames[FrmDivision.FRM_FIELD_AREA]%>" size="50" value="<%=division.getArea()%>" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td valign="middle">
                                                        Telephone
                                                    </td>
                                                    <td valign="middle">
                                                       <input type="text" name="<%=frmDivision.fieldNames[FrmDivision.FRM_FIELD_TELEPHONE]%>" size="50" value="<%=division.getTelphone()%>" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td valign="middle">
                                                        Fax Number
                                                    </td>
                                                    <td valign="middle">
                                                       <input type="text" name="<%=frmDivision.fieldNames[FrmDivision.FRM_FIELD_FAX_NUMBER]%>" size="50" value="<%=division.getFaxNumber()%>" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td valign="middle">
                                                        Sign slip by
                                                    </td>
                                                    <td valign="middle">
                                                        <input type="hidden" name="<%=frmDivision.fieldNames[FrmDivision.FRM_FIELD_EMPLOYEE_ID]%>" size="50" value="<%=division.getEmployeeId()%>" />
                                                        <input type="text" id="emp_name" name="emp_name" size="40" value="<%= changeValue.getEmployeeName(division.getEmployeeId()) %>" />&nbsp;<a href="javascript:browse('<%=oidDivision%>')" id="btn">Browse</a>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                                <%
                                    ctrLine.setLocationImg(approot + "/images");
                                    ctrLine.initDefault();
                                    ctrLine.setTableWidth("80%");
                                    String scomDel = "javascript:cmdAsk('" + oidDivision + "')";
                                    String sconDelCom = "javascript:cmdConfirmDelete('" + oidDivision + "')";
                                    String scancel = "javascript:cmdEdit('" + oidDivision + "')";
                                    ctrLine.setBackCaption("Back to List");
                                    ctrLine.setCommandStyle("buttonlink");
                                    ctrLine.setBackCaption("Back to List");
                                    ctrLine.setSaveCaption("Save");
                                    ctrLine.setConfirmDelCaption("Yes Delete");
                                    ctrLine.setDeleteCaption("Delete");

                                    if (privDelete) {
                                        ctrLine.setConfirmDelCommand(sconDelCom);
                                        ctrLine.setDeleteCommand(scomDel);
                                        ctrLine.setEditCommand(scancel);
                                    } else {
                                        ctrLine.setConfirmDelCaption("");
                                        ctrLine.setDeleteCaption("");
                                        ctrLine.setEditCaption("");
                                    }

                                    if (privAdd == false && privUpdate == false) {
                                        ctrLine.setSaveCaption("");
                                    }

                                    if (privAdd == false) {
                                        ctrLine.setAddCaption("");
                                    }

                                    if (iCommand == Command.ASK) {
                                        ctrLine.setDeleteQuestion(msgString);
                                    }
                                %>
                                <%= ctrLine.drawImage(iCommand, iErrCode, msgString)%>
                            </div>
                        
                        <% } %>
                    </td>
                </tr>
            </table>
            
                        
                    
            
            </form>
        </div>
        <div class="footer-page">
            <table>
                <%if (headerStyle && !verTemplate.equalsIgnoreCase("0")) {%>
                <tr>
                    <td valign="bottom"><%@include file="../footer.jsp" %></td>
                </tr>
                <%} else {%>
                <tr> 
                    <td colspan="2" height="20" ><%@ include file = "../main/footer.jsp" %></td>
                </tr>
                <%}%>
            </table>
        </div>
        
    </body>
</html>

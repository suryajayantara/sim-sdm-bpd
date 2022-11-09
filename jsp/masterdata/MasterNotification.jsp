<%-- 
    Document   : MasterNotification
    Created on : Jun 19, 2020, 11:12:49 AM
    Author     : Utk
--%>


<%@page import="com.dimata.harisma.entity.log.ChangeValue"%>
<%@page import="java.text.SimpleDateFormat"%>
<%
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
            int iCommand = FRMQueryString.requestCommand(request);
            int start = FRMQueryString.requestInt(request, "start");
            int prevCommand = FRMQueryString.requestInt(request, "prev_command");
            long oidNotificaation = FRMQueryString.requestLong(request, "hidden_notification_id");

            /*variable declaration*/
            int recordToGet = 50;
            String msgString = "";
            int iErrCode = FRMMessage.NONE;
            String whereClause = "";
            String orderClause = ""+PstNotification.fieldNames[PstNotification.FLD_NOTIFICATION_ID];
            ChangeValue changeValue = new ChangeValue();
            CtrlNotification ctrlNotification = new CtrlNotification(request);
            ControlLine ctrLine = new ControlLine();
            

            /*switch statement */
            iErrCode = ctrlNotification.action(iCommand,oidNotificaation,request);
            /* end switch*/
            FrmNotification frmNotification = ctrlNotification.getForm();
            
            /*count list All Position*/
            int vectSize = PstDivision.getCount(whereClause);

            Notification notification = ctrlNotification.getNotification();
           
            msgString = ctrlNotification.getMessage();

            /*switch list Division*/
            if ((iCommand == Command.SAVE) && (iErrCode == FRMMessage.NONE)) {
                //start = PstDivision.findLimitStart(division.getOID(),recordToGet, whereClause);
                oidNotificaation = notification.getOID();
            }

            if ((iCommand == Command.FIRST || iCommand == Command.PREV)
                    || (iCommand == Command.NEXT || iCommand == Command.LAST)) {
                start = ctrlNotification.actionList(iCommand, start, vectSize, recordToGet);
            }
            /* end switch list*/
            Vector listNotification = new Vector();
            /* get record to display */
            listNotification = PstNotification.list(start, recordToGet, whereClause, orderClause);

            /*handle condition if size of record to display = 0 and start > 0 	after delete*/
            if (listNotification.size() < 1 && start > 0) {
                if (vectSize - recordToGet > recordToGet) {
                    start = start - recordToGet;   //go to Command.PREV
                } else {
                    start = 0;
                    iCommand = Command.FIRST;
                    prevCommand = Command.FIRST; //go to Command.FIRST
                }
                listNotification = PstNotification.list(start, recordToGet, whereClause, orderClause);
            }

            I_Dictionary dictionaryD = userSession.getUserDictionary();
                                        dictionaryD.loadWord();
                                        
        if(iCommand == Command.SAVE){
                  
        }
%>
<html><!-- #BeginTemplate "/Templates/main.dwt" -->
    <head>
        <!-- #BeginEditable "doctitle" -->
        <title>HARISMA - Master Notification</title>
        <script language="JavaScript">
            function cmdSearch(){
                document.FRM_NOTIFICATION.command.value="<%= Command.SEARCH %>";
                document.FRM_NOTIFICATION.action="MasterNotification.jsp";
                document.FRM_NOTIFICATION.submit();
            }

            function cmdAdd(){
                document.FRM_NOTIFICATION.hidden_notification_id.value="0";
                document.FRM_NOTIFICATION.command.value="<%=Command.ADD%>";
                document.FRM_NOTIFICATION.prev_command.value="<%=prevCommand%>";
                document.FRM_NOTIFICATION.action="MasterNotification.jsp";
                document.FRM_NOTIFICATION.submit();
            }

            function cmdAsk(oidNotification){
                document.FRM_NOTIFICATION.hidden_notification_id.value=oidNotification;
                document.FRM_NOTIFICATION.command.value="<%=Command.ASK%>";
                document.FRM_NOTIFICATION.prev_command.value="<%=prevCommand%>";
                document.FRM_NOTIFICATION.action="MasterNotification.jsp";
                document.FRM_NOTIFICATION.submit();
            }

            function cmdConfirmDelete(oidNotification){
                document.FRM_NOTIFICATION.hidden_notification_id.value=oidNotification;
                document.FRM_NOTIFICATION.command.value="<%=Command.DELETE%>";
                document.FRM_NOTIFICATION.prev_command.value="<%=prevCommand%>";
                document.FRM_NOTIFICATION.action="MasterNotification.jsp";
                document.FRM_NOTIFICATION.submit();
            }
            function cmdSave(){
                document.FRM_NOTIFICATION.command.value="<%=Command.SAVE%>";
                document.FRM_NOTIFICATION.prev_command.value="<%=prevCommand%>";
                document.FRM_NOTIFICATION.action="MasterNotification.jsp";
                document.FRM_NOTIFICATION.submit();
            }

            function cmdEdit(oidNotification){
                document.FRM_NOTIFICATION.hidden_notification_id.value=oidNotification;
                document.FRM_NOTIFICATION.command.value="<%=Command.EDIT%>";
                document.FRM_NOTIFICATION.prev_command.value="<%=prevCommand%>";
                document.FRM_NOTIFICATION.action="MasterNotification.jsp";
                document.FRM_NOTIFICATION.submit();
            }

            function cmdCancel(oidNotification){
                document.FRM_NOTIFICATION.hidden_notification_id.value=oidNotification;
                document.FRM_NOTIFICATION.command.value="<%=Command.EDIT%>";
                document.FRM_NOTIFICATION.prev_command.value="<%=prevCommand%>";
                document.FRM_NOTIFICATION.action="MasterNotification.jsp";
                document.FRM_NOTIFICATION.submit();
            }

            function cmdBack(){
                document.FRM_NOTIFICATION.command.value="<%=Command.BACK%>";
                document.FRM_NOTIFICATION.action="MasterNotification.jsp";
                document.FRM_NOTIFICATION.submit();
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
           var notifStatus = document.FRM_NOTIFICATION.status_select.value;

           function loadList(search_user) {
             notifStatus = document.FRM_NOTIFICATION.status_select.value;
                if (search_user.length == 0) { 
                    search_user = "0";
                    
                } 
                var xmlhttp = new XMLHttpRequest();
                xmlhttp.onreadystatechange = function() {
                    if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                        document.getElementById("list_respon").innerHTML = xmlhttp.responseText;
                    }
                };
                
                xmlhttp.open("GET", "MasterNotificationAjax.jsp?search_user=" + search_user+"&notifStatus="+ notifStatus, true);
                xmlhttp.send();
                
            }
            
            function prepare(){
                loadList("0");
            }
            
            function cmdListFirst(start){
                var search_user = document.FRM_NOTIFICATION.search_user.value;
                var xmlhttp = new XMLHttpRequest();
                xmlhttp.onreadystatechange = function() {
                    if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                        document.getElementById("list_respon").innerHTML = xmlhttp.responseText;
                    }
                };
                xmlhttp.open("GET", "MasterNotificationAjax.jsp?search_user="+search_user+"&notifStatus="+ notifStatus+"&command=" + <%=Command.FIRST%> + "&start="+start, true);
                xmlhttp.send();
            }

            function cmdListPrev(start){
                var search_user = document.FRM_NOTIFICATION.search_user.value;
                var xmlhttp = new XMLHttpRequest();
                xmlhttp.onreadystatechange = function() {
                    if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                        document.getElementById("list_respon").innerHTML = xmlhttp.responseText;
                    }
                };
                xmlhttp.open("GET", "MasterNotificationAjax.jsp?search_user="+search_user+"&notifStatus="+ notifStatus+"&command=" + <%=Command.PREV%> + "&start="+start, true);
                xmlhttp.send();
            }

            function cmdListNext(start){
                var search_user = document.FRM_NOTIFICATION.search_user.value;
                var xmlhttp = new XMLHttpRequest();
                xmlhttp.onreadystatechange = function() {
                    if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                        document.getElementById("list_respon").innerHTML = xmlhttp.responseText;
                    }
                };
                xmlhttp.open("GET", "MasterNotificationAjax.jsp?search_user="+search_user+"&notifStatus="+ notifStatus+"&command=" + <%=Command.NEXT%> + "&start="+start, true);
                xmlhttp.send();
            }

            function cmdListLast(start){
                var search_user = document.FRM_NOTIFICATION.search_user.value;
                var xmlhttp = new XMLHttpRequest();
                xmlhttp.onreadystatechange = function() {
                    if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                        document.getElementById("list_respon").innerHTML = xmlhttp.responseText;
                    }
                };
                xmlhttp.open("GET", "MasterNotificationAjax.jsp?search_user="+search_user+"&notifStatus="+ notifStatus+"&command=" + <%=Command.LAST%> + "&start="+start, true);
                xmlhttp.send();
            }
            
//            function browse(divisionId){
//                newWindow=window.open("MasterNotificationAjax.jsp?division_id="+divisionId,"DivisionEmp", "height=600, width=500, status=yes, toolbar=no, menubar=no, location=center, scrollbars=yes");
//                newWindow.focus();
//            }
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
             /* Tooltip container */
            .tooltip {
              position: relative;
              display: inline-block;
              border-bottom: 1px dotted black; /* If you want dots under the hoverable text */
            }

            /* Tooltip text */
            .tooltip .tooltiptext {
              visibility: hidden;
              width: 120px;
              background-color: #555;
              color: #fff;
              text-align: center;
              padding: 5px 0;
              border-radius: 6px;

              /* Position the tooltip text */
              position: absolute;
              z-index: 1;
              bottom: 125%;
              left: 50%;
              margin-left: -60px;

              /* Fade in tooltip */
              opacity: 0;
              transition: opacity 0.3s;
            }

            /* Tooltip arrow */
            .tooltip .tooltiptext::after {
              content: "";
              position: absolute;
              top: 100%;
              left: 50%;
              margin-left: -5px;
              border-width: 5px;
              border-style: solid;
              border-color: #555 transparent transparent transparent;
            }

            /* Show the tooltip text when you mouse over the tooltip container */
            .tooltip:hover .tooltiptext {
              visibility: visible;
              opacity: 1;
            } 
        </style>
        <!-- #EndEditable -->
<link rel="stylesheet" href="<%=approot%>/javascripts/datepicker/themes/jquery.ui.all.css">
<script src="<%=approot%>/javascripts/jquery.js"></script>
<script src="<%=approot%>/javascripts/datepicker/jquery.ui.core.js"></script>
<script src="<%=approot%>/javascripts/datepicker/jquery.ui.widget.js"></script>
<script src="../../javascripts/jquery.min-1.6.2.js" type="text/javascript"></script>
<script src="<%=approot%>/javascripts/datepicker/jquery.ui.datepicker.js"></script>
        <link rel="stylesheet" href="../styles/main.css" type="text/css">
        <%@ include file = "../main/konfigurasi_jquery.jsp" %>    
        <script src="../javascripts/jquery.min-1.6.2.js" type="text/javascript"></script>
        <script src="../javascripts/chosen.jquery.js" type="text/javascript"></script>
        <link rel="stylesheet" href="../stylesheets/chosen.css" > 
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
            <span id="menu_title">Masterdata <strong style="color:#333;"> / </strong>Notification</span>
        </div>
        <div class="content-main">
            <form name="FRM_NOTIFICATION" method ="post" action="">
            <input type="hidden" name="command" value="<%=iCommand%>">
            <input type="hidden" name="vectSize" value="<%=vectSize%>">
            <input type="hidden" name="start" value="<%=start%>">
            <input type="hidden" name="prev_command" value="<%=prevCommand%>">
            <input type="hidden" name="hidden_notification_id" value="<%=oidNotificaation%>">
            <table>
                <tr>
                    <td valign="top">
                        <%
                            if ((iCommand != Command.ADD && iCommand != Command.ASK && iCommand != Command.EDIT) && (frmNotification.errorSize() < 1)) {
                                if (privAdd) {
                                    %>
                                    <a class="btn" style="color:#FFF" href="javascript:cmdAdd()">Tambah Data</a>
                                    <%
                                }
                            }
                        %>
                        <input type="hidden" style="padding:6px 7px" name="search_user" onkeyup="loadList(this.value)" placeholder="Cari User..." size="70" />
                        <b> Status</b>
                        <select id="status_select" name="status_select"  onkeyup="loadList('')" onchange="loadList('')" >
                            <option selected value="2">-All-</option>
                            <option value="<%=PstNotification.STATUS_ACTIVE %>"><%= PstNotification.StatusValue[PstNotification.STATUS_ACTIVE] %></option>
                            <option value="<%=PstNotification.STATUS_NON_ACTIVE%>"><%= PstNotification.StatusValue[PstNotification.STATUS_NON_ACTIVE] %></option>
                        </select>
                        <div>&nbsp;</div>
                        <div id="list_respon"></div>
                        <div>&nbsp;</div>
                    </td>
                </tr>
                    <td valign="top">
                        <%if ((iCommand == Command.ADD) || (iCommand == Command.SAVE) && (frmNotification.errorSize() > 0) || (iCommand == Command.EDIT) || (iCommand == Command.ASK)) {
                        %>
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
                                                    <td valign="middle">Notification</td>
                                                    <td valign="middle">
                                                        <select name="<%=frmNotification.fieldNames[FrmNotification.FRM_FIELD_NOTIFICATION_TYPE]%>">
                                                            <option value="0" <%=(notification.getNotificationType() == 0) ? "selected" : "" %> ><%=PstNotification.NotificationType[0]%></option>
                                                            <option value="1" <%=(notification.getNotificationType() == 1) ? "selected" : "" %> ><%=PstNotification.NotificationType[1]%></option>
                                                            <option value="2" <%=(notification.getNotificationType() == 2) ? "selected" : "" %> ><%=PstNotification.NotificationType[2]%></option>
                                                            <option value="3" <%=(notification.getNotificationType() == 3) ? "selected" : "" %> ><%=PstNotification.NotificationType[3]%></option>
                                                            <option value="4" <%=(notification.getNotificationType() == 4) ? "selected" : "" %> ><%=PstNotification.NotificationType[4]%></option>
                                                            <option value="5" <%=(notification.getNotificationType() == 5) ? "selected" : "" %> ><%=PstNotification.NotificationType[5]%></option>
                                                            <option value="6" <%=(notification.getNotificationType() == 6) ? "selected" : "" %> ><%=PstNotification.NotificationType[6]%></option>
                                                            <option value="7" <%=(notification.getNotificationType() == 7) ? "selected" : "" %> ><%=PstNotification.NotificationType[7]%></option>
                                                            <option value="8" <%=(notification.getNotificationType() == 8) ? "selected" : "" %> ><%=PstNotification.NotificationType[8]%></option>
                                                            <option value="9" <%=(notification.getNotificationType() == 9) ? "selected" : "" %> ><%=PstNotification.NotificationType[9]%></option>
                                                            <option value="10" <%=(notification.getNotificationType() == 10) ? "selected" : "" %> ><%=PstNotification.NotificationType[10]%></option>
                                                            <option value="11" <%=(notification.getNotificationType() == 11) ? "selected" : "" %> ><%=PstNotification.NotificationType[11]%></option>
                                                        </select>
                                                    </td>
                                                </tr>
                                                <tr align="left">
                                                    <td valign="middle">Notifikasi Sebelum hari H </td>
                                                    <td valign="middle">
                                                       <input type="number" name="<%=frmNotification.fieldNames[FrmNotification.FRM_FIELD_NOTIFICATION_DAYS]%>" size="5" value="<%=notification.getNotificationDays()%>" /> 
                                                    </td>
                                                </tr>
                                                <tr align="left">
                                                    <td valign="middle">
                                                        <div class="tooltip">Kondisi Khusus <b>*</b> 
                                                            <span class="tooltiptext">
                                                                Penggunaan untuk : <br>
                                                                - Masa Kerja untuk Penghargaan Karyawan<br>
                                                                - Usia MBT & Pensiun<br>
                                                                - Lama Pejabat Sementara<br>
                                                                - Lama Jabatan yg sama
                                                            </span>
                                                            
                                                        </div></td>
                                                    <td valign="middle">
                                                       <input type="number" name="<%=frmNotification.fieldNames[FrmNotification.FRM_FIELD_SPECIAL_CASE]%>" size="5" value="<%=notification.getSpecialCase()%>" /> 
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td valign="middle">
                                                        User </td>
                                                    <td valign="middle">
                                                        <%
                                                        Vector UserKey = new Vector(1, 1);
                                                        Vector UserValue = new Vector(1, 1);
                                                        try{
                                                        Vector listUser = PstAppUser.listFullObj(0, 0, "", ""+PstAppUser.fieldNames[PstAppUser.FLD_LOGIN_ID]);
                                                         for (int i = 0; i < listUser.size(); i++) {
                                                                AppUser appUser = (AppUser) listUser.get(i);
                                                                try {
                                                                Employee employee = (Employee) PstEmployee.fetchExc(appUser.getEmployeeId());
                                                                UserKey.add(" ( "+appUser.getLoginId()+" ) "+" - "+employee.getFullName());
                                                                UserValue.add("" + appUser.getOID());
                                                                } catch (Exception exc){}
                                                            }
                                                        }catch(Exception exc){
                                                            System.out.println("exc :"+exc);
                                                        }
                                                        %>
                                                        <select name="user_id" class="chosen-select" multiple required>
                                                           <% 
                                                               for(int y = 0 ; y < UserValue.size() ; y ++){
                                                                   Vector listNotifMapping  = new Vector();
                                                                   listNotifMapping = (Vector) PstNotificationMapping.list(0, 0, ""+PstNotificationMapping.fieldNames[PstNotificationMapping.FLD_NOTIFICATION_ID]+" = "+notification.getOID(), "");
                                                                   String selected = "";
                                                                   for(int u = 0; u < listNotifMapping.size(); u++){
                                                                       NotificationMapping notificationMapping = (NotificationMapping) listNotifMapping.get(u);
                                                                       if(notificationMapping.getUserId() == Long.valueOf(UserValue.get(y).toString())){
                                                                          selected = " selected " ;
                                                                       }
                                                                   }
                                                           %>
                                                           <option value="<%=UserValue.get(y)%>" <%= selected %>  ><%=UserKey.get(y)%></option>
                                                           <% }
                                                           %>
                                                        </select>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td valign="middle">
                                                        Satuan Kerja </td>
                                                    <td valign="middle">
                                                        <%
                                                        Vector divKey = new Vector(1, 1);
                                                        Vector divValue = new Vector(1, 1);
                                                        try{
                                                        Vector listDivision = PstDivision.list(0, 0, PstDivision.fieldNames[PstDivision.FLD_VALID_STATUS]+"=1", ""+PstDivision.fieldNames[PstDivision.FLD_DIVISION]);
                                                         for (int i = 0; i < listDivision.size(); i++) {
                                                                Division div = (Division) listDivision.get(i);
                                                                try {
                                                                divKey.add(""+div.getDivision());
                                                                divValue.add("" + div.getOID());
                                                                } catch (Exception exc){}
                                                            }
                                                        }catch(Exception exc){
                                                            System.out.println("exc :"+exc);
                                                        }
                                                        %>
                                                        <select name="division_id" class="chosen-select" multiple required>
                                                           <% 
                                                               for(int y = 0 ; y < divValue.size() ; y ++){
                                                                   Vector listDivMapping  =  (Vector) PstNotificationMappingDivision.list(0, 0, ""+PstNotificationMappingDivision.fieldNames[PstNotificationMappingDivision.FLD_NOTIFICATION_ID]+" = "+notification.getOID(), "");
                                                                   String selected = "";
                                                                   for(int u = 0; u < listDivMapping.size(); u++){
                                                                       NotificationMappingDivision notificationMapping = (NotificationMappingDivision) listDivMapping.get(u);
                                                                       if(notificationMapping.getDivisionId()== Long.valueOf(divValue.get(y).toString())){
                                                                          selected = " selected " ;
                                                                       }
                                                                   }
                                                           %>
                                                           <option value="<%=divValue.get(y)%>" <%= selected %>  ><%=divKey.get(y)%></option>
                                                           <% }
                                                           %>
                                                        </select>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td valign="middle">Status</td>
                                                    <td valign="middle">
                                                        <select name="<%=frmNotification.fieldNames[FrmNotification.FRM_FIELD_NOTIFICATION_STATUS]%>">
                                                            <%
                                                            if (notification.getNotificationStatus()== PstNotification.STATUS_NON_ACTIVE){
                                                                %>
                                                                <option value="<%=PstNotification.STATUS_ACTIVE%>" ><%=PstNotification.StatusValue[PstNotification.STATUS_ACTIVE]%></option>
                                                                <option value="<%=PstNotification.STATUS_NON_ACTIVE%>" selected="selected"><%=PstNotification.StatusValue[PstNotification.STATUS_NON_ACTIVE]%></option>
                                                                <%
                                                            } else {
                                                                %>
                                                                <option value="<%=PstNotification.STATUS_ACTIVE%>" selected="selected"><%=PstNotification.StatusValue[PstNotification.STATUS_ACTIVE]%></option>
                                                                <option value="<%=PstNotification.STATUS_NON_ACTIVE%>" ><%=PstNotification.StatusValue[PstNotification.STATUS_NON_ACTIVE]%></option>
                                                                <%
                                                            }
                                                            %>
                                                        </select>
                                                    </td>
                                                </tr>
                                                
                                                <tr>
                                          
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                                <%
                                    ctrLine.setLocationImg(approot + "/images");
                                    ctrLine.initDefault();
                                    ctrLine.setTableWidth("80%");
                                    String scomDel = "javascript:cmdAsk('" + oidNotificaation + "')";
                                    String sconDelCom = "javascript:cmdConfirmDelete('" + oidNotificaation + "')";
                                    String scancel = "javascript:cmdEdit('" + oidNotificaation + "')";
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
         <script type="text/javascript">
                var config = {
                    '.chosen-select'           : {},
                    '.chosen-select-deselect'  : {allow_single_deselect:true},
                    '.chosen-select-no-single' : {disable_search_threshold:10},
                    '.chosen-select-no-results': {no_results_text:'Oops, nothing found!'},
                    '.chosen-select-width'     : {width:"100%"}
                };
                for (var selector in config) {
                    $(selector).chosen(config[selector]);
                }
        </script>
    </body>
       
</html>

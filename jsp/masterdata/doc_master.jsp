<%-- 
    Document   : doc_master
    Created on : Aug 26, 2016, 9:14:01 AM
    Author     : Dimata 007
--%>

<%@page import="com.dimata.harisma.form.masterdata.FrmEmpDocCompMap"%>
<%@page import="com.dimata.harisma.entity.log.ChangeValue"%>
<%@page import="com.dimata.harisma.form.masterdata.FrmDocMaster"%>
<%@page import="com.dimata.gui.jsp.ControlLine"%>
<%@page import="com.dimata.harisma.form.masterdata.CtrlDocMaster"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_DOKUMEN_SURAT, AppObjInfo.G2_MASTER_DOCUMENT, AppObjInfo.OBJ_DOCUMENT_MASTER);%>
<%@ include file = "../main/checkuser.jsp" %>
<!DOCTYPE html>
<%
int iCommand = FRMQueryString.requestCommand(request);
int start = FRMQueryString.requestInt(request, "start");
int prevCommand = FRMQueryString.requestInt(request, "prev_command");
long oidDocMaster = FRMQueryString.requestLong(request, "doc_master_oid");
long oidTipeSurat = FRMQueryString.requestLong(request, "tipeSurat");
String title = FRMQueryString.requestString(request, "search");
/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = FRMMessage.NONE;
String whereClause = "";
String orderClause = "";
ChangeValue changeValue = new ChangeValue();
CtrlDocMaster ctrlDocMaster = new CtrlDocMaster(request);
ControlLine ctrLine = new ControlLine();
Vector listDocMaster = new Vector(1,1);

iErrCode = ctrlDocMaster.action(iCommand , oidDocMaster);
/* end switch*/
FrmDocMaster frmDocMaster = ctrlDocMaster.getForm();

/*count list All GroupRank*/
int vectSize = PstDocMaster.getCount(whereClause);

/*switch list GroupRank*/
if((iCommand == Command.FIRST || iCommand == Command.PREV )||
  (iCommand == Command.NEXT || iCommand == Command.LAST)){
                start = ctrlDocMaster.actionList(iCommand, start, vectSize, recordToGet);
 } 
/* end switch list*/

DocMaster docMaster = ctrlDocMaster.getdDocMaster();
msgString =  ctrlDocMaster.getMessage();

/* get record to display */
listDocMaster = PstDocMaster.list(start,recordToGet, whereClause , orderClause);

/*handle condition if size of record to display = 0 and start > 0 	after delete*/
if (listDocMaster.size() < 1 && start > 0) {
    if (vectSize - recordToGet > recordToGet) {
        start = start - recordToGet;   //go to Command.PREV
    } else {
        start = 0;
        iCommand = Command.FIRST;
        prevCommand = Command.FIRST; //go to Command.FIRST
    }
    listDocMaster = PstDocMaster.list(start, recordToGet, whereClause, orderClause);
}

if (iCommand == Command.SAVE) {
    iCommand = 0;
}
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Master Document</title>
        <link rel="stylesheet" href="../styles/main.css" type="text/css">
        <style type="text/css">
            .tblStyle {border-collapse: collapse; font-size: 12px;}
            .tblStyle td {padding: 7px 9px; border: 1px solid #CCC; font-size: 12px;}
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
                background-color: #EEE; color: #575757; 
                font-size: 11px; cursor: pointer;
                border-radius: 3px;
                border: 1px solid #DDD;
            }
            .btn-small:hover { background-color: #DDD; color: #474747;}
            
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
            .formstyle {
                background-color: #FFF;
                padding: 21px;
                border-radius: 3px;
                margin: 3px 0px;
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
<script language="JavaScript">
function cmdAdd(){
	document.frmDocMaster.doc_master_oid.value="0";
	document.frmDocMaster.command.value="<%=Command.ADD%>";
	document.frmDocMaster.prev_command.value="<%=prevCommand%>";
	document.frmDocMaster.action="doc_master.jsp";
	document.frmDocMaster.submit();
}

function cmdAsk(oidGroupRank){
	document.frmDocMaster.doc_master_oid.value=oidGroupRank;
	document.frmDocMaster.command.value="<%=Command.ASK%>";
	document.frmDocMaster.prev_command.value="<%=prevCommand%>";
	document.frmDocMaster.action="doc_master.jsp";
	document.frmDocMaster.submit();
}

function cmdAskDelete(DocMasterId){
    document.frmDocMaster.doc_master_oid.value=DocMasterId;
    document.frmDocMaster.command.value="<%=Command.ASK%>";
    document.frmDocMaster.action="doc_master.jsp";
    document.frmDocMaster.submit();
}

function cmdDelete(DocMasterId){
    document.frmDocMaster.doc_master_oid.value=DocMasterId;
    document.frmDocMaster.command.value="<%=Command.DELETE%>";
    document.frmDocMaster.action="doc_master.jsp";
    document.frmDocMaster.submit();
}

function cmdNoDelete(){
    document.frmDocMaster.command.value="<%=Command.NONE%>";
    document.frmDocMaster.action="doc_master.jsp";
    document.frmDocMaster.submit();
}

function cmdListFirst(start){
    loadList('0', '0', '0', '<%=Command.FIRST%>', start);
}

function cmdFlow(DocMasterId){
	//document.frmDocMaster.command.value="<%=Command.REFRESH%>";
	document.frmDocMaster.prev_command.value="<%=prevCommand%>";
	document.frmDocMaster.action="doc_master_flow_new.jsp?DocMasterId="+DocMasterId;
	document.frmDocMaster.submit();
    
	//window.open("<%=approot%>/masterdata/doc_master_flow.jsp?DocMasterId="+DocMasterId+"", null, "height=550,width=600, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");       
}
function cmdSign(DocMasterId){
	document.frmDocMaster.prev_command.value="<%=prevCommand%>";
	document.frmDocMaster.target="_blank";
	document.frmDocMaster.action="doc_master_sign.jsp?DocMasterId="+DocMasterId;
	document.frmDocMaster.submit();
}
function cmdTemplate(docMasterId){
    window.open("doc_template.jsp?doc_master_id="+docMasterId);
	/*window.open("<%=approot%>/masterdata/doc_master_template.jsp?DocMasterId="+DocMasterId+"", null, "height=550,width=600, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");*/   
}
function cmdExpense(DocMasterId){
	window.open("<%=approot%>/masterdata/doc_master_expense.jsp?DocMasterId="+DocMasterId+"", null, "height=550,width=600, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");       
}
function cmdAction(DocMasterId){
	window.open("<%=approot%>/masterdata/doc_master_action.jsp?FRM_FIELD_DOC_MASTER_ID="+DocMasterId+"", null, "height=550,width=600, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");       
}
function cmdUserMapping(DocMasterId){
	newWindow=window.open("user_mapping.jsp?DOC_MASTER_ID="+DocMasterId,"UserData", "height=600,width=500,status=yes,toolbar=no,menubar=no,location=center,scrollbars=yes");
	newWindow.focus();
}
function cmdPayCompMapping(DocMasterId){
	newWindow=window.open("pay_component_mapping.jsp?<%=FrmEmpDocCompMap.fieldNames[FrmEmpDocCompMap.FRM_FIELD_DOC_MASTER_ID]%>="+DocMasterId,"PayComp", "height=600,width=500,status=yes,toolbar=no,menubar=no,location=center,scrollbars=yes");
	newWindow.focus();
}
function cmdConfirmDelete(oidDocMaster){
	document.frmDocMaster.doc_master_oid.value=oidDocMaster;
	document.frmDocMaster.command.value="<%=Command.DELETE%>";
	document.frmDocMaster.prev_command.value="<%=prevCommand%>";
	document.frmDocMaster.action="doc_master.jsp";
	document.frmDocMaster.submit();
}

function cmdSave(){
	document.frmDocMaster.command.value="<%=Command.SAVE%>";
	document.frmDocMaster.prev_command.value="<%=prevCommand%>";
	document.frmDocMaster.action="doc_master.jsp";
	document.frmDocMaster.submit();
}

function cmdEdit(oidDocMaster){
	document.frmDocMaster.doc_master_oid.value=oidDocMaster;
	document.frmDocMaster.command.value="<%=Command.EDIT%>";
	document.frmDocMaster.prev_command.value="<%=prevCommand%>";
	document.frmDocMaster.action="doc_master.jsp";
	document.frmDocMaster.submit();
}

function cmdCancel(oidDocMaster){
	document.frmDocMaster.doc_master_oid.value=oidDocMaster;
	document.frmDocMaster.command.value="<%=Command.EDIT%>";
	document.frmDocMaster.prev_command.value="<%=prevCommand%>";
	document.frmDocMaster.action="doc_master.jsp";
	document.frmDocMaster.submit();
}

function cmdBack(){
	document.frmDocMaster.command.value="<%=Command.BACK%>";
	document.frmDocMaster.action="doc_master.jsp";
	document.frmDocMaster.submit();
}
function cmdSearch(){

	document.frmDocMaster.action="doc_master.jsp";
	document.frmDocMaster.submit();
}

function cmdListFirst(){
	document.frmDocMaster.command.value="<%=Command.FIRST%>";
	document.frmDocMaster.prev_command.value="<%=Command.FIRST%>";
	document.frmDocMaster.action="doc_master.jsp";
	document.frmDocMaster.submit();
}

function cmdListPrev(){
	document.frmDocMaster.command.value="<%=Command.PREV%>";
	document.frmDocMaster.prev_command.value="<%=Command.PREV%>";
	document.frmDocMaster.action="doc_master.jsp";
	document.frmDocMaster.submit();
}

function cmdListNext(){
	document.frmDocMaster.command.value="<%=Command.NEXT%>";
	document.frmDocMaster.prev_command.value="<%=Command.NEXT%>";
        document.frmDocMaster.tipeSurat.value=<%= oidTipeSurat %>;
	document.frmDocMaster.action="doc_master.jsp";
	document.frmDocMaster.submit();
}

function cmdListLast(){
	document.frmDocMaster.command.value="<%=Command.LAST%>";
	document.frmDocMaster.prev_command.value="<%=Command.LAST%>";
	document.frmDocMaster.action="doc_master.jsp";
	document.frmDocMaster.submit();
}

function cmdListCateg(oidDocMaster){
	document.frmDocMaster.doc_master_oid.value=oidDocMaster;
	document.frmDocMaster.command.value="<%=Command.LIST%>";
	document.frmDocMaster.action="doc_master.jsp";
	document.frmdoctype.submit();
}
function prepare(){
                loadList("0");
            }
function loadList(search) {
                tipeSurat = document.frmDocMaster.tipeSurat.value;
                if (search.length == 0) { 
                    search = "0";
                    
                } 
                var xmlhttp = new XMLHttpRequest();
                xmlhttp.onreadystatechange = function() {
                    if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                        document.getElementById("div_respon").innerHTML = xmlhttp.responseText;
                    }
                };
                
                xmlhttp.open("GET", "doc_master_ajax.jsp?search=" +search+"&tipeSurat="+ tipeSurat, true);
                xmlhttp.send();
                
            }
function cmdListFirst(start){                
                var xmlhttp = new XMLHttpRequest();
                xmlhttp.onreadystatechange = function() {
                    if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                        document.getElementById("div_respon").innerHTML = xmlhttp.responseText;
                    }
                };
                xmlhttp.open("GET", "doc_master_ajax.jsp?search=0&tipeSurat="+ tipeSurat+"&command=" + <%=Command.FIRST%> + "&start="+start, true);
                xmlhttp.send();
            }
function cmdListPrev(start){
                var xmlhttp = new XMLHttpRequest();
                xmlhttp.onreadystatechange = function() {
                    if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                        document.getElementById("div_respon").innerHTML = xmlhttp.responseText;
                    }
                };
                xmlhttp.open("GET", "doc_master_ajax.jsp?search=0&tipeSurat="+ tipeSurat+"&command=" + <%=Command.PREV%> + "&start="+start, true);
                xmlhttp.send();
            }
function cmdListNext(start){
                var xmlhttp = new XMLHttpRequest();
                xmlhttp.onreadystatechange = function() {
                    if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                        document.getElementById("div_respon").innerHTML = xmlhttp.responseText;
                    }
                };
                xmlhttp.open("GET", "doc_master_ajax.jsp?search=0&tipeSurat="+ tipeSurat+"&command=" + <%=Command.NEXT%> + "&start="+start, true);
                xmlhttp.send();
            }
function cmdListLast(start){
                var xmlhttp = new XMLHttpRequest();
                xmlhttp.onreadystatechange = function() {
                    if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                        document.getElementById("div_respon").innerHTML = xmlhttp.responseText;
                    }
                };
                xmlhttp.open("GET", "doc_master_ajax.jsp?search=0&tipeSurat="+ tipeSurat+"&command=" + <%=Command.LAST%> + "&start="+start, true);
                xmlhttp.send();
            }
</script>
    </head>
    <body onload="prepare()" >
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
            <span id="menu_title"><strong>Masterdata</strong> <strong style="color:#333;"> / </strong>Document</span>
        </div>
        <div class="content-main">
            <form name="frmDocMaster" method ="post" action="">
                <input type="hidden" name="command" value="<%=iCommand%>">
                <input type="hidden" name="vectSize" value="<%=vectSize%>">
                <input type="hidden" name="start" value="<%=start%>">
                <input type="hidden" name="prev_command" value="<%=prevCommand%>">
                <input type="hidden" name="doc_master_oid" value="<%=oidDocMaster%>">
                
                <table>   
                    <tr>
                        <td></td>
                        <td><b>Searching Title<b></td>
                        <td><b>Type Name<b></td>
                    </tr>
                    <tr>
                        <td>
                            <a href="javascript:cmdAdd()" class="btn" style="color:#FFF;">Add New Master</a>
                        </td>
                        <td>
                            <input type="text" style="padding:6px 7px" name="search" onkeyup="loadList(this.value)" placeholder="Ketik Judul Surat..." size="70" />
                        </td>
                        <td>
                            <select name="tipeSurat" id="tipeSurat" onkeyup="loadList('')" onchange="loadList('')">
                            <option value="0">-select-</option>
                            <%
                            Vector listdoctype = PstDocType.list(0, 0, "", "");
                            if (listdoctype != null && listdoctype.size()>0){
                                for(int i=0; i<listdoctype.size(); i++){
                                    DocType docType = (DocType) listdoctype.get(i);
                                    if (docType.getOID() == docMaster.getDoc_type_id()){
                                    %>
                                    <option selected="selected" value="<%= docType.getOID() %>"><%= docType.getType_name() %></option>
                                    <%    
                                    } else {
                                    %>
                                    <option value="<%= docType.getOID() %>"><%= docType.getType_name() %></option>
                                    <%
                                    }    
                                }
                            }
                            %>
                        </select>
                        </td>
                    </tr>
                </table>
                
                <div>&nbsp;</div>
                <% if (iCommand == Command.ASK){ %>
                <div id="confirm">
                    Are you sure? 
                    <a href="javascript:cmdDelete('<%= oidDocMaster %>')" id="btn-confirm">Yes</a> | 
                    <a href="javascript:cmdNoDelete()" id="btn-confirm">No</a>
                </div>
                <% } %>
                <% if (iCommand == Command.ADD || iCommand == Command.EDIT ) { %>
                <div class="formstyle">
                    <div id="caption">Tipe surat</div>
                    <div id="divinput">
                        <select name="<%= FrmDocMaster.fieldNames[FrmDocMaster.FRM_FIELD_DOC_TYPE_ID] %>">
                            <option value="0">-select-</option>
                            <%
                            //Vector listdoctype = PstDocType.list(0, 0, "", "");
                            if (listdoctype != null && listdoctype.size()>0){
                                for(int i=0; i<listdoctype.size(); i++){
                                    DocType docType = (DocType) listdoctype.get(i);
                                    if (docType.getOID() == docMaster.getDoc_type_id()){
                                    %>
                                    <option selected="selected" value="<%= docType.getOID() %>"><%= docType.getType_name() %></option>
                                    <%    
                                    } else {
                                    %>
                                    <option value="<%= docType.getOID() %>"><%= docType.getType_name() %></option>
                                    <%
                                    }    
                                }
                            }
                            %>
                        </select>
                    </div>
                    <div id="caption">Judul</div>
                    <div id="divinput">
                        <input type="text" name="<%= FrmDocMaster.fieldNames[FrmDocMaster.FRM_FIELD_TITLE] %>" value="<%=docMaster.getDoc_title()%>" />
                    </div>
                    <div id="caption">Deskripsi</div>
                    <div id="divinput">
                        <textarea name="<%= FrmDocMaster.fieldNames[FrmDocMaster.FRM_FIELD_DESCRIPTION] %>" cols="50" value="<%=docMaster.getDescription()%>"></textarea>
                    </div>
                    <div id="caption">Satuan Kerja</div>
                    <div id="divinput">
                        <select name="<%= FrmDocMaster.fieldNames[FrmDocMaster.FRM_FIELD_DIVISION_ID] %>">
                            <option value="0">-SELECT-</option>
                            <%
                            whereClause = PstDivision.fieldNames[PstDivision.FLD_VALID_STATUS]+"="+PstDivision.VALID_ACTIVE;
                            Vector divisionList = PstDivision.list(0, 0, whereClause, PstDivision.fieldNames[PstDivision.FLD_DIVISION]);
                            if (divisionList != null && divisionList.size()>0){
                                for (int i=0; i<divisionList.size(); i++){
                                    Division divisi = (Division)divisionList.get(i);
                                    if (docMaster.getDivisionId()==divisi.getOID()){
                                        %>
                                        <option selected="selected" value="<%= divisi.getOID() %>"><%= divisi.getDivision() %></option>
                                        <%
                                    } else {
                                        %>
                                        <option value="<%= divisi.getOID() %>"><%= divisi.getDivision() %></option>
                                        <%
                                    }
                                    
                                }
                            }
                            %>
                        </select>
                        
                    </div>
                    <div>
                        <a href="javascript:cmdSave()" class="btn" style="color:#FFF;">Save</a>
                        <a href="javascript:cmdBack()" class="btn" style="color:#FFF;">Back</a>
                    </div>
                </div>
                <% } %>
                <div>&nbsp;</div>
                <div id="div_respon"></div>
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

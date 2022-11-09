<%-- 
    Document   : emp_document_leave
    Created on : Sep 12, 2019, 5:13:23 PM
    Author     : IanRizky
--%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.dimata.harisma.form.masterdata.CtrlEmpDoc"%>
<%@page import="com.dimata.harisma.form.masterdata.FrmEmpDoc"%>
<%@page import="com.dimata.harisma.report.EmployeeAmountXLS"%>
<%@ include file = "../../main/javainit.jsp" %> 
<% int  appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_DOKUMEN_SURAT, AppObjInfo.G2_EMP_DOCUMENT, AppObjInfo.OBJ_EMP_DOCUMENT); %>
<%@ include file = "../../main/checkuser.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<%
    int iCommand = FRMQueryString.requestCommand(request);
    long oidEmpDoc = FRMQueryString.requestLong(request, "emp_doc_id");
    long sdmDivisionOid = Long.parseLong(String.valueOf(PstSystemProperty.getPropertyLongbyName(OID_SDM_DIVISION)));
	long leaveId = FRMQueryString.requestLong(request, FrmEmpDoc.fieldNames[FrmEmpDoc.FRM_FIELD_LEAVE_APPLICATION_ID]);
    
    CtrlEmpDoc ctrlEmpDoc = new CtrlEmpDoc(request);
    int iErrCode = ctrlEmpDoc.action(iCommand , oidEmpDoc);
    EmpDoc empDoc = ctrlEmpDoc.getEmpDoc();
    Vector listDocMaster = new Vector();
	
	String message = ctrlEmpDoc.getMessage();
	if (message.length()>0){
		iCommand = Command.ADD;
	}
    
	String whereMapping = PstDocMasterUser.fieldNames[PstDocMasterUser.FLD_USER_ID]+"="+userSession.getAppUser().getOID();
	Vector listMapping = PstDocMasterUser.list(0, 0, whereMapping, "");
	if (listMapping.size()>0){
		listDocMaster = PstDocMaster.listJoinMapUser(0, 0, "U."+PstDocMasterUser.fieldNames[PstDocMasterUser.FLD_USER_ID]+"="+userSession.getAppUser().getOID(), "");
	} else if (emplx.getDivisionId() == sdmDivisionOid){
        listDocMaster = PstDocMaster.list(0, 0, "", "");
    } else {
        String whereClause = PstDocMaster.fieldNames[PstDocMaster.FLD_DIVISION_ID]+" IN("+emplx.getDivisionId()+", 0)"; /* 0 = satuan kerja bebas */
        listDocMaster = PstDocMaster.list(0, 0, whereClause, "");
    }
    
    /* Check Administrator */
    long empCompanyId = empDoc.getCompanyId();
    long empDivisionId = empDoc.getDivisionId();
    boolean selectDiv = true;
    String whereDiv = PstDivision.fieldNames[PstDivision.FLD_VALID_STATUS]+"=1";
        empCompanyId = emplx.getCompanyId();
        empDivisionId = emplx.getDivisionId();
        
        if (empDivisionId != 0 && appUserSess.getAdminStatus()==0){
            whereDiv += " AND "+ PstDivision.fieldNames[PstDivision.FLD_DIVISION_ID]+"="+empDivisionId;
            selectDiv = false;
        }
    
    
    Vector divisionList = PstDivision.list(0, 0, whereDiv, PstDivision.fieldNames[PstDivision.FLD_DIVISION]);
    
    
    String strUrl = "";
    strUrl  = "'"+empCompanyId+"',";
    strUrl += "'"+empDivisionId+"',";
    strUrl += "'0',";
    strUrl += "'0',";
    strUrl += "'"+FrmEmpDoc.fieldNames[FrmEmpDoc.FRM_FIELD_COMPANY_ID]+"',";
    strUrl += "'"+FrmEmpDoc.fieldNames[FrmEmpDoc.FRM_FIELD_DIVISION_ID]+"',";
    strUrl += "'"+FrmEmpDoc.fieldNames[FrmEmpDoc.FRM_FIELD_DEPARTMENT_ID]+"',";
    strUrl += "'"+FrmEmpDoc.fieldNames[FrmEmpDoc.FRM_FIELD_SECTION_ID]+"'";
    
    Date dateNow = new Date();
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    String strDateNow = sdf.format(dateNow);
    
    if (iCommand == Command.SAVE && empDoc != null){
        String redirectUrl = "EmpDocumentDetails.jsp?EmpDocument_oid="+empDoc.getOID();
        response.sendRedirect(redirectUrl);
    }
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Employee Document</title>
        <link rel="stylesheet" href="../../styles/main.css" type="text/css">
        <style type="text/css">
            .tblStyle {border-collapse: collapse; font-size: 12px; }
            .tblStyle td {padding: 5px 7px; border: 1px solid #CCC; font-size: 12px; background-color: #FFF;}
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
            
            body {background-color: #EEE;}
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
            
            .caption {
                font-size: 12px;
                color: #474747;
                font-weight: bold;
                padding: 2px 0px 3px 0px;
            }
            .divinput {
                margin-bottom: 5px;
                padding-bottom: 5px;
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
            h2 {
                padding: 7px 0px 21px 0px;
                margin: 0px 0px 21px 0px;
                border-bottom: 1px solid #DDD;
            }
            .box {
                border: 1px solid #DDD;
                background-color: #f5f5f5;
                margin: 5px 0px;
            }
            #box-title {
                padding: 14px 19px;
                font-size: 13px;
                font-weight: bold;
                color: #007fba;
                border-bottom: 1px solid #ddd;
                background-color: #FFF;
            }
            #box-content {
                color: #575757;
                padding: 14px 19px;
            }
        </style>
        <script type="text/javascript">
           function loadList(doc_master, doc_title, doc_num, command, start, divisi, fromDate, toDate) {
                var xmlhttp = new XMLHttpRequest();
                xmlhttp.onreadystatechange = function() {
                    if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                        document.getElementById("list-data").innerHTML = xmlhttp.responseText;
                    }
                };
                var sort_by = document.getElementById("sort_by").value;
                var url = "list_emp_doc.jsp?";
                url += "doc_master="+doc_master;
                url += "&doc_title="+doc_title;
                url += "&doc_num="+doc_num;
                url += "&command="+command;
                url += "&start="+start;
                url += "&division_id="+divisi;
                url += "&sort_by="+sort_by;
				url += "&date_from="+fromDate;
				url += "&date_to="+toDate;
                xmlhttp.open("GET", url, true);
                xmlhttp.send();
                
            }
            
            function cmdSearch(){
                var doc_master = document.getElementById("doc_master_src").value;
                var doc_title = document.getElementById("doc_title_src").value; 
                var doc_num = document.getElementById("doc_num_src").value;
                var divisi = document.getElementById("division_search").value;
				var fromDate = document.getElementById("date_from").value;
				var toDate = document.getElementById("date_to").value;
                var command = "0"; 
                var start = "0";
                loadList(doc_master, doc_title, doc_num, command, start, divisi, fromDate, toDate);
            }
            
            function cmdAdd(){
                document.frm.emp_doc_id.value="0";
                document.frm.command.value="<%=Command.ADD%>";
                document.frm.action="emp_document.jsp";
                document.frm.submit();
            }
            
            function cmdEdit(oid){
                document.frm.emp_doc_id.value=oid;
                document.frm.command.value="<%=Command.EDIT%>";
                document.frm.action="emp_document.jsp";
                document.frm.submit();
            }
            
            function cmdSave(){
                document.frm.command.value="<%=Command.SAVE%>";
                document.frm.action="emp_document.jsp";
                document.frm.submit();
            }
            
            function cmdCancel(){
                document.frm.command.value="<%=Command.NONE%>";
                document.frm.action="emp_document.jsp";
                document.frm.submit();
            }
            
            function cmdAsk(oid){
                document.frm.emp_doc_id.value=oid;
                document.frm.command.value="<%=Command.ASK%>";
                document.frm.action="emp_document.jsp";
                document.frm.submit();
            }
            
            function cmdDelete(oid){
                document.frm.emp_doc_id.value=oid;
                document.frm.command.value="<%=Command.DELETE%>";
                document.frm.action="emp_document.jsp";
                document.frm.submit();
            }
            
            function cmdNoDelete(){
                document.frm.command.value="<%=Command.NONE%>";
                document.frm.action="emp_document.jsp";
                document.frm.submit();
            }

            function cmdListFirst(start){
                loadList('0', '0', '0', '<%=Command.FIRST%>', start);
            }

            function cmdListPrev(start){
                loadList('0', '0', '0', '<%=Command.PREV%>', start);
            }

            function cmdListNext(start){
                loadList('0', '0', '0', '<%=Command.NEXT%>', start);
            }

            function cmdListLast(start){
                loadList('0', '0', '0', '<%=Command.LAST%>', start);
            }
            function cmdDetail(oid){
                window.open("EmpDocumentDetails.jsp?EmpDocument_oid="+oid);
                /*window.open("emp_doc_detail.jsp?EmpDocument_oid="+oid);*/
            }
        </script>
        <link rel="stylesheet" href="<%=approot%>/javascripts/datepicker/themes/jquery.ui.all.css">
        <script src="<%=approot%>/javascripts/jquery.js"></script>
        <script src="<%=approot%>/javascripts/datepicker/jquery.ui.core.js"></script>
	<script src="<%=approot%>/javascripts/datepicker/jquery.ui.widget.js"></script>
	<script src="<%=approot%>/javascripts/datepicker/jquery.ui.datepicker.js"></script>
		<script src="../../javascripts/chosen.jquery.js" type="text/javascript"></script>
		<link rel="stylesheet" href="../../stylesheets/chosen.css" >
	<script>
	$(function() {
		$( ".datepicker" ).datepicker({ dateFormat: "yy-mm-dd" });
	});
	</script> 
        <script>
function loadCompany(
    pCompanyId, pDivisionId, pDepartmentId, pSectionId,
    frmCompany, frmDivision, frmDepartment, frmSection
) {
    var strUrl = "";
    if (pCompanyId.length == 0) { 
		document.getElementById("div_result").innerHTML = "";
        return;
    } else {
		var xmlhttp = new XMLHttpRequest();
        xmlhttp.onreadystatechange = function() {
			if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                document.getElementById("div_result").innerHTML = xmlhttp.responseText;
            }
        };
        strUrl = "company_structure.jsp";
        strUrl += "?p_company_id="+pCompanyId;
        strUrl += "&p_division_id="+pDivisionId;
        strUrl += "&p_department_id="+pDepartmentId;
        strUrl += "&p_section_id="+pSectionId;
        
        strUrl += "&frm_company="+frmCompany;
        strUrl += "&frm_division="+frmDivision;
        strUrl += "&frm_department="+frmDepartment;
        strUrl += "&frm_section="+frmSection;
        xmlhttp.open("GET", strUrl, true);
        xmlhttp.send();
    }
}
    
function loadDivision(
    companyId, frmCompany, frmDivision, frmDepartment, frmSection
) {
    var strUrl = "";
    if (companyId.length == 0) { 
        document.getElementById("div_result").innerHTML = "";
        return;
    } else {
        var xmlhttp = new XMLHttpRequest();
        xmlhttp.onreadystatechange = function() {
            if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                document.getElementById("div_result").innerHTML = xmlhttp.responseText;
            }
        };
        strUrl = "company_structure.jsp";

        strUrl += "?company_id="+companyId;

        strUrl += "&frm_company="+frmCompany;
        strUrl += "&frm_division="+frmDivision;
        strUrl += "&frm_department="+frmDepartment;
        strUrl += "&frm_section="+frmSection;
        xmlhttp.open("GET", strUrl, true);

        xmlhttp.send();
    }
}
    
function loadDepartment(
    companyId, divisionId, frmCompany, 
    frmDivision, frmDepartment, frmSection
) {
    var strUrl = "";
    if ((companyId.length == 0)&&(divisionId.length == 0)) { 
        document.getElementById("div_result").innerHTML = "";
        return;
    } else {
        var xmlhttp = new XMLHttpRequest();
        xmlhttp.onreadystatechange = function() {
            if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                document.getElementById("div_result").innerHTML = xmlhttp.responseText;
            }
        };
        strUrl = "company_structure.jsp";
       
        strUrl += "?company_id="+companyId;
        strUrl += "&division_id="+divisionId;
        
        strUrl += "&frm_company="+frmCompany;
        strUrl += "&frm_division="+frmDivision;
        strUrl += "&frm_department="+frmDepartment;
        strUrl += "&frm_section="+frmSection;
        xmlhttp.open("GET", strUrl, true);
        xmlhttp.send();
    }
}
    
function loadSection(
    companyId, divisionId, departmentId,
    frmCompany, frmDivision, frmDepartment, frmSection
) {
    var strUrl = "";
    if ((companyId.length == 0)&&(divisionId.length == 0)&&(departmentId.length == 0)) { 
        document.getElementById("div_result").innerHTML = "";
        return;
    } else {
        var xmlhttp = new XMLHttpRequest();
        xmlhttp.onreadystatechange = function() {
            if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                document.getElementById("div_result").innerHTML = xmlhttp.responseText;
            }
        };
        strUrl = "company_structure.jsp";
       
        strUrl += "?company_id="+companyId;
        strUrl += "&division_id="+divisionId;
        strUrl += "&department_id="+departmentId;
        
        strUrl += "&frm_company="+frmCompany;
        strUrl += "&frm_division="+frmDivision;
        strUrl += "&frm_department="+frmDepartment;
        strUrl += "&frm_section="+frmSection;
        xmlhttp.open("GET", strUrl, true);
        xmlhttp.send();
    }
}

            
        function pageLoad(){
            //var divisi = document.getElementById("division").value;
            $(".mydate").datepicker({ dateFormat: "yy-mm-dd" }); 
            //loadList('0', '0', '0', '0', '0', divisi);
			loadCompany(<%=strUrl%>);
        } 
	</script>
    </head>
    <body onload="pageLoad()">
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
            <span id="menu_title">Document <strong style="color:#333;"> / </strong>Employee Document</span>
        </div>
        <div class="content-main">
            <form name="frm" method="post" action="">
                <input type="hidden" name="command" value="<%=iCommand%>">
                <input type="hidden" name="emp_doc_id" value="<%=oidEmpDoc%>">
                <input type="hidden" name="<%= FrmEmpDoc.fieldNames[FrmEmpDoc.FRM_FIELD_LEAVE_APPLICATION_ID]%>" value="<%=leaveId%>">
				<div class="box">
					<div id="box-title">Form Input Dokumen</div>
					<div id="box-content">
						<table>
							<tr>
								<td valign="top" style="padding-right: 21px;">
									<div class="caption">Master Dokumen</div>
									<div class="divinput">
										<select name="<%= FrmEmpDoc.fieldNames[FrmEmpDoc.FRM_FIELD_DOC_MASTER_ID] %>" class="chosen-select">
											<option value="0">-SELECT-</option>
											<%
											for (int i = 0; i < listDocMaster.size(); i++) {
												DocMaster docMaster = (DocMaster) listDocMaster.get(i);
												if (docMaster.getOID() == empDoc.getDoc_master_id()){
													%>
													<option selected="selected" value="<%= docMaster.getOID() %>"><%= docMaster.getDoc_title() %></option>
													<%
												} else {
													%>
													<option value="<%= docMaster.getOID() %>"><%= docMaster.getDoc_title() %></option>
													<%
												}
											}
											%>
										</select>
									</div>
									<div id="div_result"></div>
								</td>
								<td valign="top">
									<div class="caption">Judul Dokumen</div>
									<div class="divinput">
										<input type="text" name="<%= FrmEmpDoc.fieldNames[FrmEmpDoc.FRM_FIELD_DOC_TITLE] %>" size="50" value="<%= empDoc.getDoc_title() %>" />
									</div>

									<div class="caption">Nomor Dokumen</div>
									<div class="divinput">
										<input type="text" name="<%= FrmEmpDoc.fieldNames[FrmEmpDoc.FRM_FIELD_DOC_NUMBER] %>" size="50" value="<%= empDoc.getDoc_number() %>" />
										&nbsp;<font color="red"><%=message%></font>
									</div>

									<div class="caption">Tanggal Dokumen</div>
									<div class="divinput">
										<input type="text" class="mydate" name="<%= FrmEmpDoc.fieldNames[FrmEmpDoc.FRM_FIELD_REQUEST_DATE_STRING] %>" value="<%= empDoc.getRequest_date() == null ? strDateNow : empDoc.getRequest_date() %>" />
									</div>

									<div class="caption">Tanggal Berlaku</div>
									<div class="divinput">
										<input type="text" class="mydate" name="<%= FrmEmpDoc.fieldNames[FrmEmpDoc.FRM_FIELD_DATE_OF_ISSUE_STRING] %>" value="<%= empDoc.getDate_of_issue() == null ? strDateNow : empDoc.getDate_of_issue() %>" />
									</div>
								</td>
							</tr>
							<tr>
								<td colspan="2">
									<div>&nbsp;</div>

								</td>
							</tr>
							<tr>
								<td colspan="2">
									<div>&nbsp;</div>
									<a href="javascript:cmdSave()" class="btn" style="color:#FFF">Simpan</a>
									<a href="javascript:cmdCancel()" class="btn" style="color:#FFF">Batal</a>
									<div>&nbsp;</div>
								</td>
							</tr>
						</table>
					</div>
				</div>
                
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
	<script type="text/javascript">
		var config = {
			'.chosen-select'           : {},
			'.chosen-select-deselect'  : {allow_single_deselect:true},
			'.chosen-select-no-single' : {disable_search_threshold:10},
			'.chosen-select-no-results': {no_results_text:'Oops, nothing found!'},
			'.chosen-select-width'     : {width:"100%"}
		}
		for (var selector in config) {
			$(selector).chosen(config[selector]);
		}
	</script>
</html>
<%-- 
    Document   : user_mapping
    Created on : Sep 2, 2019, 10:36:21 AM
    Author     : IanRizky
--%>


<%@page import="com.dimata.util.Command"%>
<%@page import="com.dimata.harisma.form.payroll.FrmValue_Mapping"%>
<%@ include file = "../main/javainit.jsp" %>
<%  int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_SYSTEM, AppObjInfo.G2_SYSTEM_MANAGEMENT, AppObjInfo.OBJ_SYSTEM_PROPERTIES); %>
<%@ include file = "../main/checkuser.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    int iCommand = FRMQueryString.requestCommand(request);
	long docMasterId = FRMQueryString.requestLong(request, "DOC_MASTER_ID");
	long userId = FRMQueryString.requestLong(request, "USER_ID");
	
	if (iCommand == Command.SAVE){
		DocMasterUser docMasterUser = new DocMasterUser();
		docMasterUser.setDocMasterId(docMasterId);
		docMasterUser.setUserId(userId);
		try {
			PstDocMasterUser.insertExc(docMasterUser);
		} catch (Exception exc){}
	}
	
	if (iCommand == Command.DELETE){
		try {
			PstDocMasterUser.deleteExc(docMasterId, userId);
		} catch (Exception exc){}
	}
	
    Vector listUser = new Vector();
    listUser = PstAppUser.listPartObj(0, 0, "", "");
	
	Vector listMapp = PstDocMasterUser.list(0, 0, PstDocMasterUser.fieldNames[PstDocMasterUser.FLD_DOC_MASTER_ID]+"="+docMasterId, "");

%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<%@ include file = "../main/konfigurasi_jquery.jsp" %>  
		<script src="../javascripts/jquery.min-1.6.2.js" type="text/javascript"></script>
        <script src="../javascripts/chosen.jquery.js" type="text/javascript"></script>
		<link rel="stylesheet" href="../stylesheets/chosen.css" >
        <title>User Data</title>
        <style type="text/css">
            .tblStyle {border-collapse: collapse; font-size: 12px; }
            .tblStyle td {padding: 5px 7px; border: 1px solid #CCC; font-size: 12px; }
            .title_tbl {font-weight: bold; background-color: #DDD; color: #575757;}
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
            #title-box {
                color: #007fba;
                border-bottom: 1px solid #DDD; 
                font-weight: bold; 
                font-size: 14px;
                padding-bottom: 9px;
            }
            .content {
                padding: 21px;
            }
            .box {
                padding: 15px 17px;
                margin: 5px;
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
            h2 {
                padding: 7px 0px 21px 0px;
                margin: 0px 0px 21px 0px;
                border-bottom: 1px solid #DDD;
            }
        </style>
		<script language="JavaScript">
			function cmdAdd(){
				document.frm.command.value="<%=Command.SAVE%>";
				document.frm.action="user_mapping.jsp";
				document.frm.submit();
			}
			function cmdDelete(userId){
				var check = confirm("Delete?");
				if (check){
					document.frm.command.value="<%=Command.DELETE%>";
					document.frm.USER_ID.value=userId;
					document.frm.action="user_mapping.jsp";
					document.frm.submit();
				}	
			}
		</script>
    </head>
    <body>
		<form name="frm" method="post">
			<input type="hidden" name="DOC_MASTER_ID" value="<%=docMasterId%>">
			<input type="hidden" name="command" value="<%=iCommand%>">
			<h1>User yang dapat mengakses dokumen : </h1>
			<div>
				<select name="USER_ID" class="chosen-select">
					<% 
					for (int i=0; i < listUser.size(); i++){
						AppUser appUser = (AppUser) listUser.get(i);
					%>
						<option value="<%=appUser.getOID()%>"><%=appUser.getLoginId()%></option>
					<%
					}
					%>
				</select>
				<a href="javascript:cmdAdd()" style="color:#FFF;" class="btn">Add</a>
			</div>
			<div style="margin-top: 10px">
				<table class="tblStyle">
					<tr>
						<td class="title_tbl">No</td>
						<td class="title_tbl">User</td>
						<td class="title_tbl">Action</td>
					</tr>
					<%
						for (int i=0; i < listMapp.size(); i++){
							DocMasterUser docMasterUser = (DocMasterUser) listMapp.get(i);
							AppUser appUser = new AppUser();
							try {
								appUser = PstAppUser.fetch(docMasterUser.getUserId());
							} catch (Exception exc){}
							%>
							<tr>
								<td><%=(i+1)%></td>
								<td><%=appUser.getLoginId()%></td>
								<td style="text-align: center"><a href="javascript:cmdDelete('<%=appUser.getOID()%>')" style="color:#fff;" class="btn-small">x</a></td>
							</tr>
							<%
						}
					%>
				</table>
			</div>
		</form>
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
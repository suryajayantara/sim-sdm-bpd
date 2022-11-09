<%-- 
    Document   : doc_master_sign
    Created on : Sep 4, 2019, 1:50:10 PM
    Author     : IanRizky
--%>
<%@page import="com.dimata.harisma.form.masterdata.FrmDocMasterSign"%>
<%@page import="com.dimata.harisma.form.masterdata.CtrlDocMasterSign"%>
<%@page import="com.dimata.harisma.entity.masterdata.Division"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstDivision"%>
<%@page import="com.dimata.harisma.entity.masterdata.DocMasterSign"%>
<%@page import="com.dimata.util.Command"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstDocMasterSign"%>
<%@page import="com.dimata.qdep.form.FRMQueryString"%>
<%@page import="com.dimata.harisma.entity.admin.AppObjInfo"%>
<%@page import="java.util.Vector"%>
<%@page import="com.dimata.harisma.form.masterdata.CtrlDocMasterSign"%>
<%@page import="com.dimata.qdep.form.FRMMessage"%>
<%@page import="com.dimata.gui.jsp.ControlLine"%>
<%@page import="com.dimata.harisma.form.masterdata.FrmDocMasterSign"%>
<%@ include file = "../main/javainit.jsp" %>
<% int  appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_MASTERDATA, AppObjInfo.G2_MD_PERFORMANCE_APPRAISAL, AppObjInfo.OBJ_GROUP_RANK); %>
<%@ include file = "../main/checkuser.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    int iCommand = FRMQueryString.requestCommand(request);
    int start = FRMQueryString.requestInt(request, "start");
    int prevCommand = FRMQueryString.requestInt(request, "prev_command");
    long oidDocMaster = FRMQueryString.requestLong(request, "DocMasterId");
    long oidDocMasterSign = FRMQueryString.requestLong(request, "doc_master_sign_id");
    
    /*variable declaration*/
    int recordToGet = 0;
    String msgString = "";
    int iErrCode = FRMMessage.NONE;
    String whereClause = "";
    String orderClause = "";
    CtrlDocMasterSign ctrlDocMasterSign = new CtrlDocMasterSign(request);
    ControlLine ctrLine = new ControlLine();
    Vector listDocMasterSign = new Vector(1,1);

    iErrCode = ctrlDocMasterSign.action(iCommand , oidDocMasterSign);
    /* end switch*/
    FrmDocMasterSign frmDocMasterSign = ctrlDocMasterSign.getForm();

    /*count list All GroupRank*/
    int vectSize = PstDocMasterSign.getCount(whereClause);

    /*switch list GroupRank*/
    if((iCommand == Command.FIRST || iCommand == Command.PREV )||
      (iCommand == Command.NEXT || iCommand == Command.LAST)){
                    start = ctrlDocMasterSign.actionList(iCommand, start, vectSize, recordToGet);
     } 
    /* end switch list*/

    DocMasterSign docMasterSign = ctrlDocMasterSign.getdDocMasterSign();
    msgString =  ctrlDocMasterSign.getMessage();

    whereClause = PstDocMasterSign.fieldNames[PstDocMasterSign.FLD_DOC_MASTER_ID] + " = " + oidDocMaster;
    
    /* get record to display */
    listDocMasterSign = PstDocMasterSign.list(start,recordToGet, whereClause , orderClause);

    /*handle condition if size of record to display = 0 and start > 0 	after delete*/
    if (listDocMasterSign.size() < 1 && start > 0) {
        if (vectSize - recordToGet > recordToGet) {
            start = start - recordToGet;   //go to Command.PREV
        } else {
            start = 0;
            iCommand = Command.FIRST;
            prevCommand = Command.FIRST; //go to Command.FIRST
        }
        listDocMasterSign = PstDocMasterSign.list(start, recordToGet, whereClause, orderClause);
    }

    if (iCommand == Command.SAVE) {
        iCommand = 0;
    }
    
    /* Check Administrator */
    long empCompanyId = 0;
    long empDivisionId = 0;
    if (appUserSess.getAdminStatus()==0){
        empCompanyId = emplx.getCompanyId();
        empDivisionId = emplx.getDivisionId();
    }
    
    String strUrl = "";
    strUrl  = "'"+empCompanyId+"',";
    strUrl += "'"+empDivisionId+"',";
    strUrl += "'0',";
    strUrl += "'0',";
    strUrl += "'company_id',";
    strUrl += "'division_id',";
    strUrl += "'department_id',";
    strUrl += "'frm_section_id'";
    
    int filter = 0;
    if(docMasterSign.getEmployeeId()> 0){
        filter = 2;
    } else if (docMasterSign.getPositionId() > 0){ 
        filter = 1;
    } 
    
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Document Flow</title>
        <link rel="stylesheet" href="../styles/main.css" type="text/css">
         <%@ include file = "../main/konfigurasi_jquery.jsp" %>    
        <script src="../javascripts/jquery.min-1.6.2.js" type="text/javascript"></script>
        <script src="../javascripts/chosen.jquery.js" type="text/javascript"></script>
        <link rel="stylesheet" href="../stylesheets/chosen.css" >
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
        function cmdSave(){
                document.frmDocMasterSign.command.value="<%=Command.SAVE%>";
                document.frmDocMasterSign.prev_command.value="<%=prevCommand%>";
                document.frmDocMasterSign.action="doc_master_sign.jsp";
                document.frmDocMasterSign.submit();
        }    
            
        function cmdAdd(){
                document.frmDocMasterSign.doc_master_sign_id.value="0";
                document.frmDocMasterSign.command.value="<%=Command.ADD%>";
                document.frmDocMasterSign.prev_command.value="<%=prevCommand%>";
                document.frmDocMasterSign.action="doc_master_sign.jsp";
                document.frmDocMasterSign.submit();
        }

        function cmdAsk(oidGroupRank){
                document.frmDocMasterSign.doc_master_sign_id.value=oidGroupRank;
                document.frmDocMasterSign.command.value="<%=Command.ASK%>";
                document.frmDocMasterSign.prev_command.value="<%=prevCommand%>";
                document.frmDocMasterSign.action="doc_master_sign.jsp";
                document.frmDocMasterSign.submit();
        }

        function cmdAskDelete(oid){
            document.frmDocMasterSign.doc_master_sign_id.value=oid;
            document.frmDocMasterSign.command.value="<%=Command.ASK%>";
            document.frmDocMasterSign.action="doc_master_sign.jsp";
            document.frmDocMasterSign.submit();
        }

        function cmdDelete(DocMasterId){
            document.frmDocMasterSign.doc_master_sign_id.value=DocMasterId;
            document.frmDocMasterSign.command.value="<%=Command.DELETE%>";
            document.frmDocMasterSign.action="doc_master_sign.jsp";
            document.frmDocMasterSign.submit();
        }

        function cmdNoDelete(){
            document.frmDocMasterSign.command.value="<%=Command.NONE%>";
            document.frmDocMasterSign.action="doc_master_sign.jsp";
            document.frmDocMasterSign.submit();
        }

        function cmdListFirst(start){
            loadList('0', '0', '0', '<%=Command.FIRST%>', start);
        }

        function cmdConfirmDelete(oid){
                document.frmDocMasterSign.doc_master_sign_id.value=oid;
                document.frmDocMasterSign.command.value="<%=Command.DELETE%>";
                document.frmDocMasterSign.prev_command.value="<%=prevCommand%>";
                document.frmDocMasterSign.action="doc_master_sign.jsp";
                document.frmDocMasterSign.submit();
        }

        function cmdSave(){
                document.frmDocMasterSign.command.value="<%=Command.SAVE%>";
                document.frmDocMasterSign.prev_command.value="<%=prevCommand%>";
                document.frmDocMasterSign.action="doc_master_sign.jsp";
                document.frmDocMasterSign.submit();
        }

        function cmdEdit(oid){
                document.frmDocMasterSign.doc_master_sign_id.value=oid;
                document.frmDocMasterSign.command.value="<%=Command.EDIT%>";
                document.frmDocMasterSign.prev_command.value="<%=prevCommand%>";
                document.frmDocMasterSign.action="doc_master_sign.jsp";
                document.frmDocMasterSign.submit();
        }

        function cmdCancel(oid){
                document.frmDocMasterSign.doc_master_sign_id.value=oidDocMasterSign;
                document.frmDocMasterSign.command.value="<%=Command.EDIT%>";
                document.frmDocMasterSign.prev_command.value="<%=prevCommand%>";
                document.frmDocMasterSign.action="doc_master_sign.jsp";
                document.frmDocMasterSign.submit();
        }

        function cmdBackToList(){
                document.frmDocMasterSign.command.value="<%=Command.LIST%>";
                document.frmDocMasterSign.action="doc_master.jsp";
                document.frmDocMasterSign.submit();
        }

        function cmdListFirst(){
                document.frmDocMasterSign.command.value="<%=Command.FIRST%>";
                document.frmDocMasterSign.prev_command.value="<%=Command.FIRST%>";
                document.frmDocMasterSign.action="doc_master_sign.jsp";
                document.frmDocMasterSign.submit();
        }

        function cmdListPrev(){
                document.frmDocMasterSign.command.value="<%=Command.PREV%>";
                document.frmDocMasterSign.prev_command.value="<%=Command.PREV%>";
                document.frmDocMasterSign.action="doc_master_sign.jsp";
                document.frmDocMasterSign.submit();
        }

        function cmdListNext(){
                document.frmDocMasterSign.command.value="<%=Command.NEXT%>";
                document.frmDocMasterSign.prev_command.value="<%=Command.NEXT%>";
                document.frmDocMasterSign.action="doc_master_sign.jsp";
                document.frmDocMasterSign.submit();
        }

        function cmdListLast(){
                document.frmDocMasterSign.command.value="<%=Command.LAST%>";
                document.frmDocMasterSign.prev_command.value="<%=Command.LAST%>";
                document.frmDocMasterSign.action="doc_master_sign.jsp";
                document.frmDocMasterSign.submit();
        }

        function cmdListCateg(oid){
                document.frmDocMasterSign.doc_master_sign_id.value=oidDocMasterSign;
                document.frmDocMasterSign.command.value="<%=Command.LIST%>";
                document.frmDocMasterSign.action="doc_master_sign.jsp";
                document.frmdoctype.submit();
        }
        
        function cmdSearchEmp(){
//        document.frmDocMasterSign.command.value="<%=String.valueOf(Command.GOTO)%>";
//        document.frmDocMasterSign.action="<%=approot%>/employee/search/SearchMasterFlow.jsp?formName=frmDocMasterSign&empPathId=<%=FrmDocMasterSign.fieldNames[FrmDocMasterSign.FRM_FIELD_EMPLOYEE_ID]%>", null, "height=550,width=600, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes";
//        document.frmDocMasterSign.submit();
//	//emp_number = document.frmDocMasterSign.EMP_NUMBER.value;
	window.open("<%=approot%>/employee/search/SearchMasterFlow.jsp?formName=frmDocMasterSign&empPathId=<%=FrmDocMasterSign.fieldNames[FrmDocMasterSign.FRM_FIELD_EMPLOYEE_ID]%>", null, "height=550,width=600, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");       
}
		
		function chosenSelect(){
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
		}
        
        function loadFilterBy(filter_by, oidDocMasterSign) {
                var xmlhttp = new XMLHttpRequest();
                xmlhttp.onreadystatechange = function() {
                    if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                        document.getElementById("div_respon").innerHTML = xmlhttp.responseText;
						chosenSelect();
                    }
                };
                xmlhttp.open("GET", "doc_sign_ajax.jsp?filter_by=" + filter_by+"&oid="+oidDocMasterSign, true);
                xmlhttp.send();
            }
            
            function pageLoad(){ 
                loadFilterBy(<%=filter%>,'<%=oidDocMasterSign%>');
				chosenSelect();
            } 
        </script>
    </head>
    <body onLoad="loadFilterBy(<%=filter%>,'<%=oidDocMasterSign%>')">
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
            <span id="menu_title"><strong>Masterdata</strong> <strong style="color:#333;"> / </strong> <strong>Document</strong> <strong style="color:#333;"> / </strong> Document Sign </span>
        </div>
        <div class="content-main">
            <form name="frmDocMasterSign" method="post" action="">
                <input type="hidden" name="command" value="<%=iCommand%>">
                <input type="hidden" name="start" value="<%=start%>">
                <input type="hidden" name="prev_command" value="<%=prevCommand%>">
                <input type="hidden" name="DocMasterId" value="<%=oidDocMaster%>">
                <input type="hidden" name="doc_master_sign_id" value="<%=oidDocMasterSign%>">
                <a href="javascript:cmdAdd()" class="btn" style="color:#FFF;">Tambah Document Sign</a>
				<a href="javascript:cmdBackToList()" class="btn" style="color:#FFF;">Back</a>
                <div>&nbsp;</div>
                <% if (iCommand == Command.ASK){ %>
                <div id="confirm">
                    Are you sure? 
                    <a href="javascript:cmdDelete('<%= oidDocMasterSign %>')" id="btn-confirm">Yes</a> | 
                    <a href="javascript:cmdNoDelete()" id="btn-confirm">No</a>
                </div>
                <% } %>
                <% if (iCommand == Command.ADD || iCommand == Command.EDIT ) { %>
                <div class="formstyle">
                    <table>
                        <tr>
                            <td valign="top" style="padding-right: 21px;">
                                <input type="hidden" name="<%= FrmDocMasterSign.fieldNames[FrmDocMasterSign.FRM_FIELD_DOC_MASTER_ID] %>" value="<%=oidDocMaster%>" >
                                <div id="caption">Index</div>
                                <div id="divinput">
                                    <select name="<%= FrmDocMasterSign.fieldNames[FrmDocMasterSign.FRM_FIELD_SIGN_INDEX] %>">
                                        <%
                                            for (int idx=0; idx < 10; idx++){
                                                if (docMasterSign.getSignIndex() == idx){
                                                    %> <option selected="selected" value="<%= idx %>"><%=idx%></option><%
                                                } else {
                                                    %> <option value="<%= idx %>"><%=idx%></option><%
                                                }
                                            }
                                        %>
                                    </select>
                                </div>
                                <div id="caption">Satuan Kerja</div>
                                <div id="divinput">
                                    <select name="<%= FrmDocMasterSign.fieldNames[FrmDocMasterSign.FRM_FIELD_SIGN_FOR_DIVISION_ID] %>">
                                        <option value="0">-SELECT-</option>
                                        <%
                                        whereClause = PstDivision.fieldNames[PstDivision.FLD_VALID_STATUS]+"="+PstDivision.VALID_ACTIVE;
                                        Vector divisionList = PstDivision.list(0, 0, whereClause, PstDivision.fieldNames[PstDivision.FLD_DIVISION]);
                                        if (divisionList != null && divisionList.size()>0){
                                            for (int i=0; i<divisionList.size(); i++){
                                                Division divisi = (Division)divisionList.get(i);
                                                if (docMasterSign.getSignForDivisionId()==divisi.getOID()){
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
                            </td>
                            <td valign="top">
                                <div id="caption">Filter By</div>
                                <div id="divinput">
                                    <select name="filter_by" id="filter_by" onchange="loadFilterBy(this.value,<%=oidDocMasterSign%>)">
                                        <%
                                            for (int i=0;i < PstDocMasterSign.filterBy.length;i++){
                                                if (filter == i){
                                        %>
                                                <option value="<%=i%>" selected="selected"><%=PstDocMasterSign.filterBy[i]%></option>
                                        <% } else {%>
                                                <option value="<%=i%>"><%=PstDocMasterSign.filterBy[i]%></option>
                                        <%      }
                                            }
                                        %>
                                    </select>
                                </div>
                                <div id="div_respon"></div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div>
                                    <a href="javascript:cmdSave()" class="btn" style="color:#FFF;">Save</a>
                                    <a href="javascript:cmdBack()" class="btn" style="color:#FFF;">Back</a>
                                </div>
                            </td> 
                        </tr>
                    </table>
                </div>
                <% } if (listDocMasterSign.size() > 0 ) {%>
                <table class="tblStyle">
                    <tr>
                        <td class="title_tbl" style="text-align:center; vertical-align:middle" colspan="1" rowspan="2">No</td>
                        <td class="title_tbl" style="text-align:center; vertical-align:middle" colspan="1" rowspan="2">Index</td>
                        <td class="title_tbl" style="text-align:center; vertical-align:middle" colspan="1" rowspan="2">Satuan Kerja</td>
                        <td class="title_tbl" style="text-align:center; vertical-align:middle" colspan="2" rowspan="1">Filter by</td>
                        <td class="title_tbl" style="text-align:center; vertical-align:middle" colspan="1" rowspan="2">Action</td>
                    </tr>
                    <tr>
                        <td class="title_tbl" style="text-align:center; vertical-align:middle">Jabatan</td>
                        <td class="title_tbl" style="text-align:center; vertical-align:middle">Karyawan</td>
                    </tr>
                    <%
                        String bgColor = "#FFF;";
                        for (int idx=0; idx < listDocMasterSign.size(); idx++){
                            DocMasterSign docSign = (DocMasterSign)listDocMasterSign.get(idx);
                            
                            Position pos = new Position();
                            try {
                                pos = PstPosition.fetchExc(docSign.getPositionId());
                            } catch (Exception exc){ System.out.println(exc.toString());}                            
                            
                            Employee emp = new Employee();
                            try {
                                emp = PstEmployee.fetchExc(docSign.getEmployeeId());
                            } catch (Exception exc){  System.out.println(exc.toString());}                             
                            
                            Division divFor = new Division();
                            try{
                                divFor = PstDivision.fetchExc(docSign.getSignForDivisionId());
                            } catch (Exception exc){ System.out.println(exc.toString());}
                            
                    %>
                        <tr>
                            
                            <td style="background-color: #FFF;"><%=idx+1%></td>
							<td style="background-color: #FFF;"><%=docSign.getSignIndex()%></td>
                            <td style="background-color: #FFF;"><%=divFor.getDivision()%></td>
                             <td style="background-color: #FFF;"><%=!(pos.getPosition().equals(""))  ? pos.getPosition() : "-"%></td>
                            <td style="background-color: #FFF;"><%=!(emp.getFullName().equals(""))  ? emp.getFullName() : "-"%></td>                            
                            <td style="background-color: #FFF;">
                                <a class="btn-small" href="javascript:cmdEdit('<%=docSign.getOID()%>')" style="color: #575757;">Edit</a>
                                <a class="btn-small" href="javascript:cmdAskDelete('<%=docSign.getOID()%>')" style="color: #575757;">Delete</a>
                            </td>
                        </tr>
                         <% } %>
                </table>
                <% } %>
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
                }
                for (var selector in config) {
                    $(selector).chosen(config[selector]);
                }
        </script>        
    </body>
</html>



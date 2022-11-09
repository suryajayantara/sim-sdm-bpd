<%-- 
    Document   : doc_master_flow_new
    Created on : 10-Feb-2017, 14:55:14
    Author     : Gunadi
--%>
<%@page import="com.dimata.harisma.entity.masterdata.Division"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstDivision"%>
<%@page import="com.dimata.harisma.entity.masterdata.DocMasterFlow"%>
<%@page import="com.dimata.util.Command"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstDocMasterFlow"%>
<%@page import="com.dimata.qdep.form.FRMQueryString"%>
<%@page import="com.dimata.harisma.entity.admin.AppObjInfo"%>
<%@page import="java.util.Vector"%>
<%@page import="com.dimata.harisma.form.masterdata.CtrlDocMasterFlow"%>
<%@page import="com.dimata.qdep.form.FRMMessage"%>
<%@page import="com.dimata.gui.jsp.ControlLine"%>
<%@page import="com.dimata.harisma.form.masterdata.FrmDocMasterFlow"%>
<%@ include file = "../main/javainit.jsp" %>
<% int  appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_MASTERDATA, AppObjInfo.G2_MD_PERFORMANCE_APPRAISAL, AppObjInfo.OBJ_GROUP_RANK); %>
<%@ include file = "../main/checkuser.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    int iCommand = FRMQueryString.requestCommand(request);
    int start = FRMQueryString.requestInt(request, "start");
    int prevCommand = FRMQueryString.requestInt(request, "prev_command");
    long oidDocMaster = FRMQueryString.requestLong(request, "DocMasterId");
    long oidDocMasterFlow = FRMQueryString.requestLong(request, "doc_master_flow_id");
    
    /*variable declaration*/
    int recordToGet = 0;
    String msgString = "";
    int iErrCode = FRMMessage.NONE;
    String whereClause = "";
    String orderClause = "";
    CtrlDocMasterFlow ctrlDocMasterFlow = new CtrlDocMasterFlow(request);
    ControlLine ctrLine = new ControlLine();
    Vector listDocMasterFlow = new Vector(1,1);

    iErrCode = ctrlDocMasterFlow.action(iCommand , oidDocMasterFlow);
    /* end switch*/
    FrmDocMasterFlow frmDocMasterFlow = ctrlDocMasterFlow.getForm();

    /*count list All GroupRank*/
    int vectSize = PstDocMasterFlow.getCount(whereClause);

    /*switch list GroupRank*/
    if((iCommand == Command.FIRST || iCommand == Command.PREV )||
      (iCommand == Command.NEXT || iCommand == Command.LAST)){
                    start = ctrlDocMasterFlow.actionList(iCommand, start, vectSize, recordToGet);
     } 
    /* end switch list*/

    DocMasterFlow docMasterFlow = ctrlDocMasterFlow.getdDocMasterFlow();
    msgString =  ctrlDocMasterFlow.getMessage();

    whereClause = PstDocMasterFlow.fieldNames[PstDocMasterFlow.FLD_DOC_MASTER_ID] + " = " + oidDocMaster;
    
    /* get record to display */
    listDocMasterFlow = PstDocMasterFlow.list(start,recordToGet, whereClause , orderClause);

    /*handle condition if size of record to display = 0 and start > 0 	after delete*/
    if (listDocMasterFlow.size() < 1 && start > 0) {
        if (vectSize - recordToGet > recordToGet) {
            start = start - recordToGet;   //go to Command.PREV
        } else {
            start = 0;
            iCommand = Command.FIRST;
            prevCommand = Command.FIRST; //go to Command.FIRST
        }
        listDocMasterFlow = PstDocMasterFlow.list(start, recordToGet, whereClause, orderClause);
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
    strUrl += "'"+FrmDocMasterFlow.fieldNames[FrmDocMasterFlow.FRM_FIELD_COMPANY_ID]+"',";
    strUrl += "'"+FrmDocMasterFlow.fieldNames[FrmDocMasterFlow.FRM_FIELD_DIVISION_ID]+"',";
    strUrl += "'"+FrmDocMasterFlow.fieldNames[FrmDocMasterFlow.FRM_FIELD_DEPARTMENT_ID]+"',";
    strUrl += "'frm_section_id'";
    
    int filter = 0;
    if(docMasterFlow.getEmployee_id() > 0){
        filter = 6;
    } else if (docMasterFlow.getPosition_id() > 0){ 
        filter = 5;
    } else if (docMasterFlow.getLevel_id() > 0){
        filter = 4;
    } else if (docMasterFlow.getDepartment_id() > 0){
        filter = 3;
    } else if (docMasterFlow.getDivision_id() > 0){
        filter = 2;
    } else if (docMasterFlow.getCompany_id() > 0){
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
                document.frmDocMasterFlow.command.value="<%=Command.SAVE%>";
                document.frmDocMasterFlow.prev_command.value="<%=prevCommand%>";
                document.frmDocMasterFlow.action="doc_master_flow_new.jsp";
                document.frmDocMasterFlow.submit();
        }    
            
        function cmdAdd(){
                document.frmDocMasterFlow.doc_master_flow_id.value="0";
                document.frmDocMasterFlow.command.value="<%=Command.ADD%>";
                document.frmDocMasterFlow.prev_command.value="<%=prevCommand%>";
                document.frmDocMasterFlow.action="doc_master_flow_new.jsp";
                document.frmDocMasterFlow.submit();
        }

        function cmdAsk(oidGroupRank){
                document.frmDocMasterFlow.doc_master_flow_id.value=oidGroupRank;
                document.frmDocMasterFlow.command.value="<%=Command.ASK%>";
                document.frmDocMasterFlow.prev_command.value="<%=prevCommand%>";
                document.frmDocMasterFlow.action="doc_master_flow_new.jsp";
                document.frmDocMasterFlow.submit();
        }

        function cmdAskDelete(oid){
            document.frmDocMasterFlow.doc_master_flow_id.value=oid;
            document.frmDocMasterFlow.command.value="<%=Command.ASK%>";
            document.frmDocMasterFlow.action="doc_master_flow_new.jsp";
            document.frmDocMasterFlow.submit();
        }

        function cmdDelete(DocMasterId){
            document.frmDocMasterFlow.doc_master_flow_id.value=DocMasterId;
            document.frmDocMasterFlow.command.value="<%=Command.DELETE%>";
            document.frmDocMasterFlow.action="doc_master_flow_new.jsp";
            document.frmDocMasterFlow.submit();
        }

        function cmdNoDelete(){
            document.frmDocMasterFlow.command.value="<%=Command.NONE%>";
            document.frmDocMasterFlow.action="doc_master_flow_new.jsp";
            document.frmDocMasterFlow.submit();
        }

        function cmdListFirst(start){
            loadList('0', '0', '0', '<%=Command.FIRST%>', start);
        }

        function cmdConfirmDelete(oid){
                document.frmDocMasterFlow.doc_master_flow_id.value=oid;
                document.frmDocMasterFlow.command.value="<%=Command.DELETE%>";
                document.frmDocMasterFlow.prev_command.value="<%=prevCommand%>";
                document.frmDocMasterFlow.action="doc_master_flow_new.jsp";
                document.frmDocMasterFlow.submit();
        }

        function cmdSave(){
                document.frmDocMasterFlow.command.value="<%=Command.SAVE%>";
                document.frmDocMasterFlow.prev_command.value="<%=prevCommand%>";
                document.frmDocMasterFlow.action="doc_master_flow_new.jsp";
                document.frmDocMasterFlow.submit();
        }

        function cmdEdit(oid){
                document.frmDocMasterFlow.doc_master_flow_id.value=oid;
                document.frmDocMasterFlow.command.value="<%=Command.EDIT%>";
                document.frmDocMasterFlow.prev_command.value="<%=prevCommand%>";
                document.frmDocMasterFlow.action="doc_master_flow_new.jsp";
                document.frmDocMasterFlow.submit();
        }

        function cmdCancel(oid){
                document.frmDocMasterFlow.doc_master_flow_id.value=oidDocMasterFlow;
                document.frmDocMasterFlow.command.value="<%=Command.EDIT%>";
                document.frmDocMasterFlow.prev_command.value="<%=prevCommand%>";
                document.frmDocMasterFlow.action="doc_master_flow_new.jsp";
                document.frmDocMasterFlow.submit();
        }

        function cmdBack(){
                document.frmDocMasterFlow.command.value="<%=Command.BACK%>";
                document.frmDocMasterFlow.action="doc_master_flow_new.jsp";
                document.frmDocMasterFlow.submit();
        }

        function cmdListFirst(){
                document.frmDocMasterFlow.command.value="<%=Command.FIRST%>";
                document.frmDocMasterFlow.prev_command.value="<%=Command.FIRST%>";
                document.frmDocMasterFlow.action="doc_master_flow_new.jsp";
                document.frmDocMasterFlow.submit();
        }

        function cmdListPrev(){
                document.frmDocMasterFlow.command.value="<%=Command.PREV%>";
                document.frmDocMasterFlow.prev_command.value="<%=Command.PREV%>";
                document.frmDocMasterFlow.action="doc_master_flow_new.jsp";
                document.frmDocMasterFlow.submit();
        }

        function cmdListNext(){
                document.frmDocMasterFlow.command.value="<%=Command.NEXT%>";
                document.frmDocMasterFlow.prev_command.value="<%=Command.NEXT%>";
                document.frmDocMasterFlow.action="doc_master_flow_new.jsp";
                document.frmDocMasterFlow.submit();
        }

        function cmdListLast(){
                document.frmDocMasterFlow.command.value="<%=Command.LAST%>";
                document.frmDocMasterFlow.prev_command.value="<%=Command.LAST%>";
                document.frmDocMasterFlow.action="doc_master_flow_new.jsp";
                document.frmDocMasterFlow.submit();
        }

        function cmdListCateg(oid){
                document.frmDocMasterFlow.doc_master_flow_id.value=oidDocMasterFlow;
                document.frmDocMasterFlow.command.value="<%=Command.LIST%>";
                document.frmDocMasterFlow.action="doc_master_flow_new.jsp";
                document.frmdoctype.submit();
        }
        
        function cmdSearchEmp(){
//        document.frmDocMasterFlow.command.value="<%=String.valueOf(Command.GOTO)%>";
//        document.frmDocMasterFlow.action="<%=approot%>/employee/search/SearchMasterFlow.jsp?formName=frmDocMasterFlow&empPathId=<%=FrmDocMasterFlow.fieldNames[FrmDocMasterFlow.FRM_FIELD_EMPLOYEE_ID]%>", null, "height=550,width=600, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes";
//        document.frmDocMasterFlow.submit();
//	//emp_number = document.frmDocMasterFlow.EMP_NUMBER.value;
	window.open("<%=approot%>/employee/search/SearchMasterFlow.jsp?formName=frmDocMasterFlow&empPathId=<%=FrmDocMasterFlow.fieldNames[FrmDocMasterFlow.FRM_FIELD_EMPLOYEE_ID]%>", null, "height=550,width=600, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");       
}
        
        function loadFilterBy(filter_by, oidDocMasterFlow) {
                var xmlhttp = new XMLHttpRequest();
                xmlhttp.onreadystatechange = function() {
                    if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                        document.getElementById("div_respon").innerHTML = xmlhttp.responseText;
                    }
                };
                xmlhttp.open("GET", "doc_flow_ajax.jsp?filter_by=" + filter_by+"&oid="+oidDocMasterFlow, true);
                xmlhttp.send();
            }
            
        function loadCompany(
                pCompanyId, pDivisionId, pDepartmentId, pSectionId,
                frmCompany, frmDivision, frmDepartment, frmSection
            ) {
                var strUrl = "";
                if (pCompanyId.length == 0) { 
                    document.getElementById("div_respon").innerHTML = "";
                    return;
                } else {
                    var xmlhttp = new XMLHttpRequest();
                    xmlhttp.onreadystatechange = function() {
                        if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                            document.getElementById("div_respon").innerHTML = xmlhttp.responseText;
                        }
                    };
                    strUrl = "doc_flow_ajax.jsp";
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
                companyId, frmCompany, frmDivision, frmDepartment, frmSection, filterBy
            ) {
                var strUrl = "";
                if (companyId.length == 0) { 
                    document.getElementById("div_respon").innerHTML = "";
                    return;
                } else {
                    var xmlhttp = new XMLHttpRequest();
                    xmlhttp.onreadystatechange = function() {
                        if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                            document.getElementById("div_respon").innerHTML = xmlhttp.responseText;
                        }
                    };
                    strUrl = "doc_flow_ajax.jsp";

                    strUrl += "?company_id="+companyId;

                    strUrl += "&frm_company="+frmCompany;
                    strUrl += "&frm_division="+frmDivision;
                    strUrl += "&frm_department="+frmDepartment;
                    strUrl += "&frm_section="+frmSection;
                    strUrl += "&filter_by="+filterBy;
                    xmlhttp.open("GET", strUrl, true);

                    xmlhttp.send();
                }
            }

            function loadDepartment(
                companyId, divisionId, frmCompany, 
                frmDivision, frmDepartment, frmSection, filterBy
            ) {
                var strUrl = "";
                if ((companyId.length == 0)&&(divisionId.length == 0)) { 
                    document.getElementById("div_respon").innerHTML = "";
                    return;
                } else {
                    var xmlhttp = new XMLHttpRequest();
                    xmlhttp.onreadystatechange = function() {
                        if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                            document.getElementById("div_respon").innerHTML = xmlhttp.responseText;
                        }
                    };
                    strUrl = "doc_flow_ajax.jsp";

                    strUrl += "?company_id="+companyId;
                    strUrl += "&division_id="+divisionId;

                    strUrl += "&frm_company="+frmCompany;
                    strUrl += "&frm_division="+frmDivision;
                    strUrl += "&frm_department="+frmDepartment;
                    strUrl += "&frm_section="+frmSection;
                    strUrl += "&filter_by="+filterBy;
                    xmlhttp.open("GET", strUrl, true);
                    xmlhttp.send();
                }
            }
            
            function pageLoad(){ 
                loadFilterBy(<%=filter%>,'<%=oidDocMasterFlow%>');
            } 
        </script>
    </head>
    <body onLoad="loadFilterBy(<%=filter%>,'<%=oidDocMasterFlow%>')">
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
            <span id="menu_title"><strong>Masterdata</strong> <strong style="color:#333;"> / </strong> <strong>Document</strong> <strong style="color:#333;"> / </strong> Document Flow </span>
        </div>
        <div class="content-main">
            <form name="frmDocMasterFlow" method="post" action="">
                <input type="hidden" name="command" value="<%=iCommand%>">
                <input type="hidden" name="start" value="<%=start%>">
                <input type="hidden" name="prev_command" value="<%=prevCommand%>">
                <input type="hidden" name="DocMasterId" value="<%=oidDocMaster%>">
                <input type="hidden" name="doc_master_flow_id" value="<%=oidDocMasterFlow%>">
                <a href="javascript:cmdAdd()" class="btn" style="color:#FFF;">Tambah Document Flow</a>
                <div>&nbsp;</div>
                <% if (iCommand == Command.ASK){ %>
                <div id="confirm">
                    Are you sure? 
                    <a href="javascript:cmdDelete('<%= oidDocMasterFlow %>')" id="btn-confirm">Yes</a> | 
                    <a href="javascript:cmdNoDelete()" id="btn-confirm">No</a>
                </div>
                <% } %>
                <% if (iCommand == Command.ADD || iCommand == Command.EDIT ) { %>
                <div class="formstyle">
                    <table>
                        <tr>
                            <td valign="top" style="padding-right: 21px;">
                                <input type="hidden" name="<%= FrmDocMasterFlow.fieldNames[FrmDocMasterFlow.FRM_FIELD_DOC_MASTER_ID] %>" value="<%=oidDocMaster%>" >
                                <div id="caption">Judul</div>
                                <div id="divinput">
                                    <input type="text" name="<%= FrmDocMasterFlow.fieldNames[FrmDocMasterFlow.FRM_FIELD_FLOW_TITLE] %>" value="<%=docMasterFlow.getFlow_title() != null ? docMasterFlow.getFlow_title() : "" %>" />
                                </div>
                                <div id="caption">Index</div>
                                <div id="divinput">
                                    <select name="<%= FrmDocMasterFlow.fieldNames[FrmDocMasterFlow.FRM_FIELD_FLOW_INDEX] %>">
                                        <%
                                            for (int idx=0; idx < 10; idx++){
                                                if (docMasterFlow.getFlow_index() == idx){
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
                                    <select name="<%= FrmDocMasterFlow.fieldNames[FrmDocMasterFlow.FRM_FIELD_FILTER_FOR_DIVISION_ID] %>">
                                        <option value="0">-SELECT-</option>
                                        <%
                                        whereClause = PstDivision.fieldNames[PstDivision.FLD_VALID_STATUS]+"="+PstDivision.VALID_ACTIVE;
                                        Vector divisionList = PstDivision.list(0, 0, whereClause, PstDivision.fieldNames[PstDivision.FLD_DIVISION]);
                                        if (divisionList != null && divisionList.size()>0){
                                            for (int i=0; i<divisionList.size(); i++){
                                                Division divisi = (Division)divisionList.get(i);
                                                if (docMasterFlow.getFilter_for_division_id() ==divisi.getOID()){
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
                                    <select name="filter_by" id="filter_by" onchange="loadFilterBy(this.value,<%=oidDocMasterFlow%>)">
                                        <%
                                            for (int i=0;i < PstDocMasterFlow.filterBy.length;i++){
                                                if (filter == i){
                                        %>
                                                <option value="<%=i%>" selected="selected"><%=PstDocMasterFlow.filterBy[i]%></option>
                                        <% } else {%>
                                                <option value="<%=i%>"><%=PstDocMasterFlow.filterBy[i]%></option>
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
                <% } if (listDocMasterFlow.size() > 0 ) {%>
                <table class="tblStyle">
                    <tr>
                        <td class="title_tbl" style="text-align:center; vertical-align:middle" colspan="1" rowspan="2">No</td>
                        <td class="title_tbl" style="text-align:center; vertical-align:middle" colspan="1" rowspan="2">Title</td>
                        <td class="title_tbl" style="text-align:center; vertical-align:middle" colspan="1" rowspan="2">Index</td>
                        <td class="title_tbl" style="text-align:center; vertical-align:middle" colspan="1" rowspan="2">Satuan Kerja</td>
                        <td class="title_tbl" style="text-align:center; vertical-align:middle" colspan="6" rowspan="1">Filter by</td>
                        <td class="title_tbl" style="text-align:center; vertical-align:middle" colspan="1" rowspan="2">Action</td>
                    </tr>
                    <tr>
                        <td class="title_tbl" style="text-align:center; vertical-align:middle">Perusahaan</td>
                        <td class="title_tbl" style="text-align:center; vertical-align:middle">Satuan Kerja</td>
                        <td class="title_tbl" style="text-align:center; vertical-align:middle">Unit</td>
                        <td class="title_tbl" style="text-align:center; vertical-align:middle">Level</td>
                        <td class="title_tbl" style="text-align:center; vertical-align:middle">Jabatan</td>
                        <td class="title_tbl" style="text-align:center; vertical-align:middle">Karyawan</td>
                    </tr>
                    <%
                        String bgColor = "#FFF;";
                        for (int idx=0; idx < listDocMasterFlow.size(); idx++){
                            DocMasterFlow docFlow = (DocMasterFlow)listDocMasterFlow.get(idx);
                            Company company = new Company();
                            try {
                                company = PstCompany.fetchExc(docFlow.getCompany_id());
                            } catch (Exception exc){ System.out.println(exc.toString());}
                            
                            Division division = new Division();
                            try {
                                division = PstDivision.fetchExc(docFlow.getDivision_id());
                            } catch (Exception exc){ System.out.println(exc.toString());}                            
                            
                            Department dept = new Department();
                            try {
                                dept = PstDepartment.fetchExc(docFlow.getDepartment_id());
                            } catch (Exception exc){ System.out.println(exc.toString());}
                                                       
                            Level lvl = new Level();
                            try {
                                lvl = PstLevel.fetchExc(docFlow.getLevel_id());
                            } catch (Exception exc){ System.out.println(exc.toString());}                            
                            
                            Position pos = new Position();
                            try {
                                pos = PstPosition.fetchExc(docFlow.getPosition_id());
                            } catch (Exception exc){ System.out.println(exc.toString());}                            
                            
                            Employee emp = new Employee();
                            try {
                                emp = PstEmployee.fetchExc(docFlow.getEmployee_id());
                            } catch (Exception exc){  System.out.println(exc.toString());}                             
                            
                            Division divFor = new Division();
                            try{
                                divFor = PstDivision.fetchExc(docFlow.getFilter_for_division_id());
                            } catch (Exception exc){ System.out.println(exc.toString());}
                            
                        
                    %>
                        <tr>
                            
                            <td style="background-color: #FFF;"><%=idx+1%></td>
                            <td style="background-color: #FFF;"><%=docFlow.getFlow_title()%></td>
                            <td style="background-color: #FFF;"><%=docFlow.getFlow_index()%></td>
                            <td style="background-color: #FFF;"><%=divFor.getDivision()%></td>
                            <td style="background-color: #FFF;"><%=!(company.getCompany().equals("")) ? company.getCompany() : "-"%></td>
                            <td style="background-color: #FFF;"><%=!(division.getDivision().equals(""))  ? division.getDivision() : "-"%></td>
                            <td style="background-color: #FFF;"><%=!(dept.getDepartment().equals(""))  ? dept.getDepartment() : "-"%></td>
                            <td style="background-color: #FFF;"><%=!(lvl.getLevel().equals(""))  ? lvl.getLevel() : "-"%></td>
                            <td style="background-color: #FFF;"><%=!(pos.getPosition().equals(""))  ? pos.getPosition() : "-"%></td>
                            <td style="background-color: #FFF;"><%=!(emp.getFullName().equals(""))  ? emp.getFullName() : "-"%></td>                            
                            <td style="background-color: #FFF;">
                                <a class="btn-small" href="javascript:cmdEdit('<%=docFlow.getOID()%>')" style="color: #575757;">Edit</a>
                                <a class="btn-small" href="javascript:cmdAskDelete('<%=docFlow.getOID()%>')" style="color: #575757;">Delete</a>
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



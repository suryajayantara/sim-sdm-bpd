<%-- 
    Document   : leave_app_search
    Created on : 11-Aug-2017, 14:39:24
    Author     : Gunadi
--%>
<%@page import="com.dimata.harisma.form.masterdata.FrmEmpDoc"%>
<%@page import="com.dimata.harisma.entity.attendance.LlStockTaken"%>
<%@page import="com.dimata.harisma.entity.attendance.PstLlStockTaken"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.dimata.qdep.db.DBHandler"%>
<%@page import="com.dimata.qdep.db.DBResultSet"%>
<%@page import="java.math.RoundingMode"%>
<%@page import="java.math.BigDecimal"%>
<%@page import="com.dimata.harisma.entity.attendance.AlStockTaken"%>
<%@page import="com.dimata.harisma.entity.attendance.PstAlStockTaken"%>
<%@ page language = "java" %>
<!-- package java -->
<%@ page import = "java.util.*" %>
<!-- package wihita -->
<%@ page import = "com.dimata.util.*" %>
<!-- package qdep -->
<%@ page import = "com.dimata.gui.jsp.*" %>
<%@ page import = "com.dimata.qdep.form.*" %>
<!--package harisma -->
<%@ page import = "com.dimata.harisma.entity.masterdata.*" %>
<%@ page import = "com.dimata.harisma.entity.leave.*" %>
<%@ page import = "com.dimata.harisma.entity.admin.*" %>
<%@ page import = "com.dimata.harisma.entity.search.*" %>
<%@ page import = "com.dimata.harisma.form.search.*" %>
<%@ page import = "com.dimata.harisma.session.leave.*" %>
<%@ include file = "../../main/javainit.jsp" %>
<%  int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_EMPLOYEE, AppObjInfo.G2_LEAVE_APPLICATION, AppObjInfo.OBJ_LEAVE_APPLICATION);%>
<%@ include file = "../../main/checkuser.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%!
    public int convertInteger(double val){
        BigDecimal bDecimal = new BigDecimal(val);
        bDecimal = bDecimal.setScale(0, RoundingMode.HALF_UP);
        return bDecimal.intValue();
    }
    
    public String[] leaveType = {
        "Cuti Khusus", "Cuti Hamil", "Cuti Penting", "Cuti Tahunan", "Cuti Besar"
    };

    public void doUpdateLeaveApp(long oid) {
        DBResultSet dbrs = null;
        try {
            String sql = "UPDATE hr_leave_application SET doc_status="+PstLeaveApplication.FLD_STATUS_APPlICATION_CANCELED;
            sql += " WHERE leave_application_id="+oid;
            DBHandler.updateParsial(sql);
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
    }
    
    public void doUpdateLeaveAppToBeCancel(long oid) {
        DBResultSet dbrs = null;
        try {
            String sql = "UPDATE hr_leave_application SET doc_status="+PstLeaveApplication.FLD_STATUS_APPlICATION_TO_BE_CANCEL;
            sql += " WHERE leave_application_id="+oid;
            DBHandler.updateParsial(sql);
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
    }

    public void doUpdateAlStockManagement(float qtyUsed, long oid) {
        DBResultSet dbrs = null;
        try {
            String sql = "UPDATE hr_al_stock_management SET qty_used="+ qtyUsed;
            sql += " WHERE al_stock_id="+oid;
            DBHandler.updateParsial(sql);
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
    }

    public void doUpdateLlStockManagement(float qtyUsed, long oid) {
        DBResultSet dbrs = null;
        try {
            String sql = "UPDATE hr_ll_stock_management SET qty_used="+ qtyUsed;
            sql += " WHERE ll_stock_id="+oid;
            DBHandler.updateParsial(sql);
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
    }

    
%>
<%
    ControlLine ctrLine = new ControlLine();
    Control ctrlLeave = new Control();
    int recordToGet = 20;
    int vectSize = 0;
    int start = FRMQueryString.requestInt(request, "start");
    int iCommand = FRMQueryString.requestCommand(request);
    SrcLeaveApp objSrcLeaveApp = new SrcLeaveApp();
    FrmSrcLeaveApp objFrmSrcLeaveApp = new FrmSrcLeaveApp();
    Vector records=null;
    SessLeaveApplication sessLeaveApplication = new SessLeaveApplication();
    int type_form = FRMQueryString.requestInt(request, "" + PstLeaveApplication.fieldNames[PstLeaveApplication.FLD_TYPE_FROM_LEAVE]);
    
    if ((iCommand == Command.NEXT) || (iCommand == Command.FIRST) || (iCommand == Command.PREV) || (iCommand == Command.LAST) || (iCommand == Command.BACK)) {
        try {
            objSrcLeaveApp = (SrcLeaveApp) session.getValue(SessLeaveApplication.SESS_SRC_LEAVE_APPLICATION);
            if (objSrcLeaveApp == null) {
                objSrcLeaveApp = new SrcLeaveApp();
            }
        } catch (Exception e) {
            objSrcLeaveApp = new SrcLeaveApp();
        }
    }

    vectSize = sessLeaveApplication.searchCountLeaveApplication(objSrcLeaveApp, 0, 0);

    if ((iCommand == Command.FIRST) || (iCommand == Command.NEXT) || (iCommand == Command.PREV) || (iCommand == Command.LAST) || (iCommand == Command.LIST)) {
        start = ctrlLeave.actionList(iCommand, start, vectSize, recordToGet);
    }

    if (iCommand == Command.LIST || (iCommand==Command.NEXT) || (iCommand==Command.FIRST) || (iCommand==Command.PREV) || (iCommand==Command.LAST) || (iCommand==Command.BACK)){
        objFrmSrcLeaveApp = new FrmSrcLeaveApp(request, objSrcLeaveApp);
        objFrmSrcLeaveApp.requestEntityObject(objSrcLeaveApp);
        records = sessLeaveApplication.searchLeaveApplicationList(objSrcLeaveApp, start, recordToGet);
        vectSize = sessLeaveApplication.searchCountLeaveApplication(objSrcLeaveApp, 0, 0);
        session.putValue(SessLeaveApplication.SESS_SRC_LEAVE_APPLICATION, objSrcLeaveApp);
    }
    
    SessUserSession userSessionn = (SessUserSession)session.getValue(SessUserSession.HTTP_SESSION_NAME);
    AppUser appUserSess1 = userSessionn.getAppUser();
    String namaUser1 = appUserSess1.getFullName();
    
    /* Check Administrator */
    long oidCompany = 0;
    String inOidDivision = "";
    String inOidDepartment = "";
    String strDisable = "";
    String strDisableNum = "";
    if (appUserSess.getAdminStatus()==0){
        if (privViewDivGroup){
            oidCompany = emplx.getCompanyId();
            long oidDivGroup = Long.parseLong(PstSystemProperty.getValueByName("OID_DIVISION_TYPE_REGULAR"));
            String whereDiv = ""+PstDivision.fieldNames[PstDivision.FLD_DIVISION_TYPE_ID]+"="+oidDivGroup;
            Vector vListDivision = PstDivision.list(0,0,whereDiv,"");
            if (vListDivision.size()>0){
                for (int i=0; i< vListDivision.size();i++){
                    Division division = (Division) vListDivision.get(i);
                    inOidDivision += ","+division.getOID();
                }
                inOidDivision = inOidDivision.substring(1);
            }
        } else {
            oidCompany = emplx.getCompanyId();
            inOidDivision = ""+emplx.getDivisionId();
            strDisable = "disabled=\"disabled\"";
        }
    } if (namaUser1.equals("Employee")){
        strDisableNum = "disabled=\"disabled\"";
    }
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Leave Search</title>
        <link rel="stylesheet" href="../../styles/main.css" type="text/css">
         <%@ include file = "../../main/konfigurasi_jquery.jsp" %>    
        <script src="../../javascripts/jquery.min-1.6.2.js" type="text/javascript"></script>
        <script src="../../javascripts/chosen.jquery.js" type="text/javascript"></script>
        <link rel="stylesheet" href="../../stylesheets/chosen.css" >
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
        function cmdSearch(){
                    document.frmsrcleaveapp.command.value="<%=String.valueOf(Command.LIST)%>";
                    document.frmsrcleaveapp.action="leave_app_search.jsp";
                    document.frmsrcleaveapp.start="0";
                    document.frmsrcleaveapp.submit();
        }   
        function cmdExportExcel(){
                    document.frmsrcleaveapp.command.value="<%=String.valueOf(Command.LIST)%>";
                    document.frmsrcleaveapp.action="excel_leave_app.jsp";
                    document.frmsrcleaveapp.start="0";
                    document.frmsrcleaveapp.submit();
        }    
		
		function cmdCreateDocument(leaveId){
			document.frmsrcleaveapp.action="<%=approot%>/employee/document/emp_document_leave.jsp?<%= FrmEmpDoc.fieldNames[FrmEmpDoc.FRM_FIELD_LEAVE_APPLICATION_ID]%>="+leaveId;
			document.frmsrcleaveapp.submit();
		}
		
		function cmdViewDocument(docId){
			document.frmsrcleaveapp.action="<%=approot%>/employee/document/EmpDocumentDetails.jsp?EmpDocument_oid="+docId;
			document.frmsrcleaveapp.submit();
		}
        
        function cmdListFirst()
        {
                document.frmsrcleaveapp.command.value="<%=Command.FIRST%>";
                document.frmsrcleaveapp.action="leave_app_search.jsp";
                document.frmsrcleaveapp.submit();
        }

        function cmdListPrev()
        {
                document.frmsrcleaveapp.command.value="<%=Command.PREV%>";
                document.frmsrcleaveapp.action="leave_app_search.jsp";
                document.frmsrcleaveapp.submit();
        }

        function cmdListNext()  
        {
                document.frmsrcleaveapp.command.value="<%=Command.NEXT%>";
                document.frmsrcleaveapp.action="leave_app_search.jsp";
                document.frmsrcleaveapp.submit();
        }

        function cmdListLast()
        {
                document.frmsrcleaveapp.command.value="<%=Command.LAST%>";
                document.frmsrcleaveapp.action="leave_app_search.jsp";
                document.frmsrcleaveapp.submit();
        }
        function cmdCancelByEmp(leaveId, empId){
            document.frm.command.value="<%= Command.DELETE %>";
            document.frm.leave_id.value = leaveId;
            document.frm.employee_id.value = empId;
            document.frm.action="leave_list_emp.jsp";
            document.frm.submit();
        }
        function cmdCancelByAdmin(leaveId){
            document.frm.command.value="<%= Command.APPROVE %>";
            document.frm.leave_id.value = leaveId;
            document.frm.action="leave_list_emp.jsp";
            document.frm.submit();
        }
        function cmdCancelRequest(leaveId, empId){
            document.frm.command.value="<%= Command.APPROVE %>";
            document.frm.leave_id.value = leaveId;
            document.frm.employee_id.value = empId;
            document.frm.action="leave_list_emp.jsp";
            document.frm.submit();
        }
        function cmdEdit(leaveId, empId, startDate, endDate){
            document.frm.command.value="<%= Command.EDIT %>";
            document.frm.leave_id.value = leaveId;
            document.frm.employee_id.value = empId;
            document.frm.date_from.value = startDate;
            document.frm.date_to.value = endDate;
            document.frm.action="leave_app_form.jsp";
            document.frm.submit();
        }
        function cmdViewApproval(leaveId){
            newWindow=window.open("view_approval.jsp?leave_id="+leaveId,"ViewApproval", "height=400, width=500, status=yes, toolbar=no, menubar=no, location=center, scrollbars=yes");
            newWindow.focus();
        }
        function cmdPrint(oid)
                { 
                    pathUrl = "<%=approot%>/LeaveForm?oidLeaveApplication="+oid+"&approot=<%=approot%>&TYPE_FORM_LEAVE=<%=type_form%>";
                    window.open(pathUrl);
                }
                function cmdPrintPdf(oid)
                    { 
                        pathUrl = "<%=approot%>/LeaveFormPdf?oidLeaveApplication="+oid+"&approot=<%=approot%>&TYPE_FORM_LEAVE=<%=type_form%>";
                        window.open(pathUrl);
                    }	
        function cmdOK(messageId){
            document.frm.command.value="<%= Command.CONFIRM %>";
            document.frm.message_id.value = messageId;
            document.frm.action="leave_list_emp.jsp";
            document.frm.submit();
        } 
        function cmdViewReason(message){
            setTimeout(function(){
                alert(message);
            }, 1000);
        }
        
        </script>
                <link rel="stylesheet" href="<%=approot%>/javascripts/datepicker/themes/jquery.ui.all.css"/>
<link rel="stylesheet" href="<%=approot%>/javascripts/datepicker/themes/jquery.ui.timepicker.addon.css"/>

<script src="<%=approot%>/javascripts/datepicker/jquery.ui.core.js"></script>
<script src="<%=approot%>/javascripts/datepicker/jquery.ui.widget.js"></script>
<script src="<%=approot%>/javascripts/datepicker/jquery.ui.datepicker.js"></script>
<script src="<%=approot%>/javascripts/datepicker/jquery.ui.timepicker.addon.js"></script>

<script>
$(function() {
    $( "#datetimepicker" ).datetimepicker({
        dateFormat: "yy-mm-dd" }
    );
    $( ".datepicker" ).datepicker({ dateFormat: "yy-mm-dd" });
});
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
            <span id="menu_title"><strong>Cuti</strong> <strong style="color:#333;"> /  Pencarian Cuti </span>
        </div>
        <div class="content-main">
            <form name="frmsrcleaveapp" method="post" action="">
                <div class="formstyle">
                    <input type="hidden" name="command" value="">
                    <input type="hidden" name="start" value="<%= start %>">
                    <input type="hidden" name="<%=objFrmSrcLeaveApp.fieldNames[objFrmSrcLeaveApp.FRM_FIELD_TYPE_FORM]%>" value="<%=PstLeaveApplication.LEAVE_APPLICATION%>"> 
                    <table>
                        <tr>
                            <td valign="top" style="padding-right: 21px;">
                                <div id="caption">NRK</div>
                                <div id="divinput">
                                    <input type="text" name="<%=objFrmSrcLeaveApp.fieldNames[objFrmSrcLeaveApp.FRM_FIELD_EMP_NUMBER]%>"  value="<%= objSrcLeaveApp.getEmpNum()%>" />
                                </div>
                                <div id="caption">Perusahaan</div>
                                <div id="divinput">
                                    <%

                                        Vector com_value = new Vector(1, 1);
                                        Vector com_key = new Vector(1, 1);
                                        String placeHolderComp = "";
                                        String multipleComp = "";
                                        if (inOidDivision.equals("")){
                                            placeHolderComp = "data-placeholder='Select Perusahaan...'";
                                            multipleComp = "multiple";
                                        } 
                                        //String sWhereClause = PstSection.fieldNames[PstSection.FLD_DEPARTMENT_ID] + " = " + sSelectedDepartment;                                                       
                                        //Vector listSec = PstSection.list(0, 0, sWhereClause, " SECTION ");
                                        Vector listCom = PstCompany.list(0, 0, "", "");
                                        for (int i = 0; i < listCom.size(); i++) {
                                            Company company = (Company) listCom.get(i);
                                            com_key.add(company.getCompany());
                                            com_value.add(String.valueOf(company.getOID()));
                                        }
                                    %>
                                    <%= ControlCombo.draw(FrmSrcLeaveApp.fieldNames[FrmSrcLeaveApp.FRM_FIELD_COMPANY_ID], "chosen-select", null, "" + objSrcLeaveApp.getCompanyId(), com_value, com_key, multipleComp+" "+placeHolderComp+" style='width:100%'")%>
                                </div>
                                <div id="caption">Unit</div>
                                <div id="divinput">
                                    <%
                                        Vector dep_value = new Vector(1, 1);
                                        Vector dep_key = new Vector(1, 1);
                                        
                                        Vector listDep = new Vector();

                                        if (inOidDivision.equals("")){
                                            listDep = PstDepartment.list(0, 0, "hr_department.VALID_STATUS=1", "");
                                        } else {
                                            listDep = PstDepartment.list(0, 0, "hr_department."+PstDepartment.fieldNames[PstDepartment.FLD_DIVISION_ID] + " IN (" + inOidDivision + ") AND hr_department.VALID_STATUS=1", "");
                                        }

                                        Hashtable hashDiv = PstDivision.listMapDivisionName(0, 0, "", "");
                                        long tempDivOid = 0 ;
                                        for (int i = 0; i < listDep.size(); i++) {
                                            Department dep = (Department) listDep.get(i);
                                            inOidDepartment += ","+dep.getOID();

                                            if (dep.getDivisionId() != tempDivOid){
                                                dep_key.add("--"+hashDiv.get(dep.getDivisionId())+"--");
                                                dep_value.add(String.valueOf(-1));
                                                tempDivOid = dep.getDivisionId();
                                            }

                                            dep_key.add(dep.getDepartment());
                                            dep_value.add(String.valueOf(dep.getOID()));
                                        }
                                        inOidDepartment = inOidDepartment.substring(1);
                                    %>

                                    <%= ControlCombo.drawStringArraySelected(FrmSrcLeaveApp.fieldNames[FrmSrcLeaveApp.FRM_FIELD_ARR_DEPARTMENT], "chosen-select", null, objSrcLeaveApp.getArrDepartment(0), dep_key, dep_value, null, "size=8 multiple data-placeholder='Select Unit...' style='width:100%'") %> 
                                </div>  
								<div id="caption">Jenis Cuti</div>
                                <div id="divinput">
									<%
										Vector jenis_value = new Vector(1, 1);
                                        Vector jenis_key = new Vector(1, 1);
										for (int t=0; t<PstLeaveApplication.fieldTypeLeaveCategory.length; t++){
											jenis_key.add(""+leaveType[t] );
                                            jenis_value.add(""+t);
                                        }
                                    %>
									<%= ControlCombo.drawStringArraySelected(FrmSrcLeaveApp.fieldNames[FrmSrcLeaveApp.FRM_FIELD_ARR_JENIS_CUTI], "chosen-select", null, objSrcLeaveApp.getArrJenisCuti(0), jenis_key, jenis_value, null, "size=8 multiple data-placeholder='Select Jenis Cuti...' style='width:100%'") %> 
                                </div>
                            </td>
                            <td valign="top">
                                <div id="caption">Nama Karyawan</div>
                                <div id="divinput">
                                    <input type="text" name="<%=objFrmSrcLeaveApp.fieldNames[objFrmSrcLeaveApp.FRM_FIELD_FULLNAME]%>"  value="<%= objSrcLeaveApp.getFullName()%>" value="" />                                
                                </div>
                                <div id="caption">Satuan Kerja</div>
                                <div id="divinput">
                                    <%

                                        Vector div_value = new Vector(1, 1);
                                        Vector div_key = new Vector(1, 1);
                                        
                                        Vector listDiv  = new Vector();
                                        String placeHolder = "";
                                        String multipleDiv = "";
                                        if (inOidDivision.equals("")){
                                            listDiv = PstDivision.list(0, 0, "VALID_STATUS=1", "");
                                            placeHolder = "data-placeholder='Select Satuan Kerja...'";
                                            multipleDiv = "multiple";
                                        } else {
                                            listDiv = PstDivision.list(0, 0, PstDivision.fieldNames[PstDivision.FLD_DIVISION_ID] + " IN (" + inOidDivision + ") AND VALID_STATUS=1", PstDivision.fieldNames[PstDivision.FLD_DIVISION_ID]);
                                        }

                                        for (int i = 0; i < listDiv.size(); i++) {
                                            Division div = (Division) listDiv.get(i);
                                            div_key.add(div.getDivision());
                                            div_value.add(String.valueOf(div.getOID()));
                                        }
                                    %>
                                        <%= ControlCombo.drawStringArraySelected(FrmSrcLeaveApp.fieldNames[FrmSrcLeaveApp.FRM_FIELD_ARR_DIVISION], "chosen-select", null, objSrcLeaveApp.getArrDivision(0), div_key, div_value, null, multipleDiv+" "+placeHolder+" style='width:100%'") %> 
                                </div>
                                <div id="caption">Sub Unit</div>
                                <div id="divinput">
                                    <%

                                        Vector sec_value = new Vector(1, 1);
                                        Vector sec_key = new Vector(1, 1);
                                        

                                        Vector listSec = new Vector();

                                        if (inOidDivision.equals("")){
                                            listSec = PstSection.list(0, 0, "VALID_STATUS=1", "DEPARTMENT_ID");
                                        } else {
                                            listSec = PstSection.list(0, 0, PstSection.fieldNames[PstSection.FLD_DEPARTMENT_ID] + " IN (" + inOidDepartment+")", "DEPARTMENT_ID");
                                        }

                                        Hashtable hashDepart = PstDepartment.listMapDepName(0, 0, "", "", "");
                                        long tempDepOid = 0 ;
                                        for (int i = 0; i < listSec.size(); i++) {
                                            Section sec = (Section) listSec.get(i);

                                            if (sec.getDepartmentId() != tempDepOid){
                                                sec_key.add("--"+hashDepart.get(""+sec.getDepartmentId())+"--");
                                                sec_value.add(String.valueOf(-1));
                                                tempDepOid = sec.getDepartmentId();
                                            }

                                            sec_key.add(sec.getSection());
                                            sec_value.add(String.valueOf(sec.getOID()));
                                        }
                                    %>
                                     <%= ControlCombo.drawStringArraySelected(FrmSrcLeaveApp.fieldNames[FrmSrcLeaveApp.FRM_FIELD_ARR_SECTION], "chosen-select", null, objSrcLeaveApp.getArrSection(0), sec_key, sec_value, null, "multiple data-placeholder='Select Sub Unit...' style='width:100%'") %> 
                                </div>    
                                <div id="caption">Jabatan</div>
                                <div id="divinput">
                                    <%

                                        Vector pos_value = new Vector(1, 1);
                                        Vector pos_key = new Vector(1, 1);
                                        

                                        Vector listPos = PstPosition.list(0, 0, PstPosition.fieldNames[PstPosition.FLD_VALID_STATUS] + " = 1 ", "");

                                        for (int i = 0; i < listPos.size(); i++) {
                                            Position pos = (Position) listPos.get(i);
                                            pos_key.add(pos.getPosition());
                                            pos_value.add(String.valueOf(pos.getOID()));
                                        }
                                    %>
                                     <%= ControlCombo.drawStringArraySelected(FrmSrcLeaveApp.fieldNames[FrmSrcLeaveApp.FRM_FIELD_ARR_POSITION], "chosen-select", null, objSrcLeaveApp.getArrPosition(0), pos_key, pos_value, null, "multiple data-placeholder='Select Jabatan...' style='width:100%'") %> 
                                </div>   
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <div id="caption">Status Cuti</div>
                                <div id="divinput">
                                    <table border="0" cellspacing="0" cellpadding="0" width="100%" >
                                        <tr>
                                            <td width="5%">
                                                <input type="checkbox" name="<%=objFrmSrcLeaveApp.fieldNames[objFrmSrcLeaveApp.FRM_FIELD_DOC_STATUS_DRAFT]%>" <%=(objSrcLeaveApp.isDraft() ? "checked" : "")%> value="1">
                                                <i><font color="#000000">Draft</font></i>
                                            </td>
                                            <td width="5%">
                                                <input type="checkbox" name="<%=objFrmSrcLeaveApp.fieldNames[objFrmSrcLeaveApp.FRM_FIELD_DOC_STATUS_TO_BE_APPROVE]%>" <%=(objSrcLeaveApp.isToBeApprove() ? "checked" : "")%> value="1">
                                                <i><font color="#000000">To Be Approve</font></i>
                                            </td>
                                            <td width="5%">
                                                <input type="checkbox" name="<%=objFrmSrcLeaveApp.fieldNames[objFrmSrcLeaveApp.FRM_FIELD_DOC_STATUS_APPROVED]%>" <%=(objSrcLeaveApp.isApproved() ? "checked" : "")%> value="1">
                                                <i><font color="#000000">Approved</font></i>
                                            </td>
                                            <td width="5%">
                                                <input type="checkbox" name="<%=objFrmSrcLeaveApp.fieldNames[objFrmSrcLeaveApp.FRM_FIELD_DOC_STATUS_EXECUTED]%>" <%=(objSrcLeaveApp.isExecuted() ? "checked" : "")%> value="1">
                                                <i><font color="#000000">Executed</font></i>
                                            </td>
                                            <td width="5%">
                                                <input type="checkbox" name="<%=objFrmSrcLeaveApp.fieldNames[objFrmSrcLeaveApp.FRM_FIELD_DOC_STATUS_TO_BE_CANCELED]%>" <%=(objSrcLeaveApp.isToBeCanceled() ? "checked" : "")%> value="1">
                                                <i><font color="#000000">To Be Canceled</font></i>
                                            </td>
                                            <td width="5%">
                                                <input type="checkbox" name="<%=objFrmSrcLeaveApp.fieldNames[objFrmSrcLeaveApp.FRM_FIELD_DOC_STATUS_CANCELED]%>" <%=(objSrcLeaveApp.isCanceled() ? "checked" : "")%> value="1">
                                                <i><font color="#000000">Canceled</font></i>
                                            </td>
                                            <td width="5%">
                                                <input type="checkbox" name="<%=objFrmSrcLeaveApp.fieldNames[objFrmSrcLeaveApp.FRM_FIELD_DOC_STATUS_DECLINED]%>" <%=(objSrcLeaveApp.isDeclined() ? "checked" : "")%> value="1">
                                                <i><font color="#000000">Declined</font></i>
                                            </td>
                                            
                                            
                                        </tr>
                                    </table>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div id="caption">Tanggal Pengajuan</div>
                                <div id="divinput">
                                            <input type="checkbox" name="<%=objFrmSrcLeaveApp.fieldNames[objFrmSrcLeaveApp.FRM_FIELD_SUBMISSION]%>" <%=(objSrcLeaveApp.isSubmission() ? "checked" : "")%> value="1">
                                            <i><font color="#FF0000">Select all date</font></i>
                                            &nbsp;&nbsp;
                                            <%=ControlDatePopup.writeDate(FrmSrcLeaveApp.fieldNames[FrmSrcLeaveApp.FRM_FIELD_SUBMISSION_DATE], objSrcLeaveApp.getSubmissionDate())%>
                                </div>
                            </td>
                            <td>
                                <div id="caption">Tanggal Cuti</div>
                                <div id="divinput">
                                    <input type="text" name="<%=FrmSrcLeaveApp.fieldNames[FrmSrcLeaveApp.FRM_FIELD_SELECTED_DATE_FROM_LEAVE]%>" id="date_from" value="<%=(objSrcLeaveApp.getSelectedFrom() != null ? objSrcLeaveApp.getSelectedFrom(): "")%>" class="datepicker" /> <strong>To</strong> <input type="text" name="<%=FrmSrcLeaveApp.fieldNames[FrmSrcLeaveApp.FRM_FIELD_SELECTED_DATE_TO_LEAVE]%>" id="date_to" value="<%=(objSrcLeaveApp.getSelectedTo() != null ? objSrcLeaveApp.getSelectedTo() :"")%>" class="datepicker" />
                                </div>    
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div>
                                    <a href="javascript:cmdSearch()" class="btn" style="color:#FFF;">Search</a>
                                    <a href="javascript:cmdExportExcel()" class="btn" style="color:#FFF;">Export Excel</a>
                                </div>
                            </td> 
                        </tr>
                    </table>
                </div>
            </form>
            <div class="formstyle">
                <%
                    if((records!=null)&&(records.size()>0))
                    {
                %>
                <table class="tblStyle">
                    <tr>
                        <td class="title_tbl">No</td>
                        <td class="title_tbl">NRK</td>
                        <td class="title_tbl">Nama</td>
                        <td class="title_tbl">Tanggal Pengajuan</td>
                        <td class="title_tbl">Tanggal Cuti</td>
                        <td class="title_tbl">Tanggal Berakhir</td>
                        <td class="title_tbl">Lama Hari</td>
                        <td class="title_tbl">Jenis Cuti</td>
                        <td class="title_tbl">Keterangan</td>
                        <td class="title_tbl">Status</td>
                        <td class="title_tbl">Action</td>
                    </tr>
                    <%
                        String whereClause = "";
                        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                        long scheduleSymbol = 0;
                        for (int i=0; i<records.size(); i++){
                            Vector temp = (Vector) records.get(i);
                
                            Employee employee = (Employee) temp.get(0);
                            LeaveApplication leave = (LeaveApplication) temp.get(1);
                            Department department = (Department) temp.get(2);
                            String startCuti = "";
                            String endCuti = "";
                            int qtyCuti = 0;
                            String where = PstAlStockTaken.fieldNames[PstAlStockTaken.FLD_LEAVE_APPLICATION_ID]+"="+leave.getOID();
                            Vector listALStockTaken = PstAlStockTaken.list(0, 0, where, "");
                            if (listALStockTaken != null && listALStockTaken.size()>0){
                                AlStockTaken alStockTaken = (AlStockTaken)listALStockTaken.get(0);
                                startCuti = sdf.format(alStockTaken.getTakenDate());
                                endCuti = sdf.format(alStockTaken.getTakenFinnishDate());
                                qtyCuti = convertInteger(alStockTaken.getTakenQty());
                            } else {
                                where = PstLlStockTaken.fieldNames[PstLlStockTaken.FLD_LEAVE_APPLICATION_ID]+"="+leave.getOID();
                                Vector listLlStockTaken = PstLlStockTaken.list(0, 0, where, "");
                                if (listLlStockTaken != null && listLlStockTaken.size()>0){
                                    LlStockTaken llStockTaken = (LlStockTaken)listLlStockTaken.get(0);
                                    startCuti = sdf.format(llStockTaken.getTakenDate());
                                    endCuti = sdf.format(llStockTaken.getTakenFinnishDate());
                                    qtyCuti = convertInteger(llStockTaken.getTakenQty());
                                } else {
                                    where = PstSpecialUnpaidLeaveTaken.fieldNames[PstSpecialUnpaidLeaveTaken.FLD_LEAVE_APLICATION_ID]+"="+leave.getOID();
                                    Vector listSlStockTaken = PstSpecialUnpaidLeaveTaken.list(0, 0, where, "");
                                    if (listSlStockTaken != null && listSlStockTaken.size()>0){
                                        SpecialUnpaidLeaveTaken slStockTaken = (SpecialUnpaidLeaveTaken)listSlStockTaken.get(0);
                                        scheduleSymbol = slStockTaken.getScheduledId();
                                        startCuti = sdf.format(slStockTaken.getTakenDate());
                                        endCuti = sdf.format(slStockTaken.getTakenFinnishDate());
                                        qtyCuti = convertInteger(slStockTaken.getTakenQty());
                                    }
                                }
                            }
                            %>
                            <tr>
                                <td style="background-color: #FFF;"><%= ((start+i)+1) %></td>
                                <td style="background-color: #FFF;"><%= employee.getEmployeeNum() %></td>
                                <td style="background-color: #FFF;"><%= employee.getFullName() %></td>
                                <td style="background-color: #FFF;"><%= leave.getSubmissionDate() %></td>
                                <td style="background-color: #FFF;"><%= startCuti %></td>
                                <td style="background-color: #FFF;"><%= endCuti %></td>
                                <td style="background-color: #FFF;"><%= qtyCuti %></td>
                                <%
                                    if (leave.getTypeLeaveCategory() != 0){
                                %>
                                <td style="background-color: #FFF;"><%= leaveType[leave.getTypeLeaveCategory()] %></td>
                                <%
                                    } else {
                                        ScheduleSymbol symbol = new ScheduleSymbol();
                                        try {
                                            symbol = PstScheduleSymbol.fetchExc(scheduleSymbol);
                                        } catch (Exception exc){
                                            
                                        }
                                %>
                                <td style="background-color: #FFF;"><%= symbol.getSchedule() %></td>
                                <%
                                    }
                                %>
                                <td style="background-color: #FFF;"><%= leave.getLeaveReason() %></td>
                                <td style="background-color: #FFF;"><%= PstLeaveApplication.fieldStatusApplication[leave.getDocStatus()] %></td>
                                <td style="background-color: #FFF;">
                                    <%
                                    if (leave.getDocStatus()==0){
                                        %>
                                        <a href="javascript:cmdEdit('<%= leave.getOID() %>','<%= employee.getOID() %>','<%= startCuti %>','<%= endCuti %>')">Edit</a> |
                                        <%
                                    }
                                    if (leave.getDocStatus() == 0){
                                        %>
                                        <a href="javascript:cmdCancelByEmp('<%= leave.getOID() %>','<%= employee.getOID() %>')">Cancel</a> |
                                        <%
                                    } else {
                                        if (leave.getDocStatus() == PstLeaveApplication.FLD_STATUS_APPlICATION_APPROVED || leave.getDocStatus() == PstLeaveApplication.FLD_STATUS_APPlICATION_TO_BE_APPROVE){
                                        %>
                                        <a href="javascript:cmdCancelRequest('<%= leave.getOID() %>','<%= employee.getOID() %>')">Cancel</a> |
                                        <%
                                        }
                                    }
                                    %>
                                    
                                    <a href="javascript:cmdPrint('<%=leave.getOID()%>')">Print</a>
                                    <a href="javascript:cmdPrintPdf('<%=leave.getOID()%>')"> | Print Pdf</a>
                                    <a href="javascript:cmdViewApproval('<%= leave.getOID() %>')"> | View Approver</a>
									<% if (leave.getTypeLeaveCategory() == 3 || leave.getTypeLeaveCategory() == 4 || leave.getTypeLeaveCategory() == 1){ 
									
										String whereDoc = PstEmpDoc.fieldNames[PstEmpDoc.FLD_LEAVE_APPLICATION_ID]+"="+leave.getOID();
										Vector listDoc = PstEmpDoc.list(0, 0, whereDoc, "");
										if (listDoc.size()>0){
											EmpDoc empDoc = (EmpDoc) listDoc.get(0);
									%>
										<a href="javascript:cmdViewDocument('<%= empDoc.getOID() %>')"> | Lihat Berita Acara</a>
									<% 
										} else if (leave.getEmpDocId() > 0) {
									%>
                                                                                <a href="javascript:cmdViewDocument('<%= leave.getEmpDocId() %>')"> | Lihat Berita Acara</a>
                                                                        <% 
										} else {
									%>
										<a href="javascript:cmdCreateDocument('<%= leave.getOID() %>')"> | Buat Berita Acara</a>
									<% 
										}	
											}
										%>
                                    <%
                                       if (leave.getDocStatus() == PstLeaveApplication.FLD_STATUS_APPLICATION_DECLINED ){
                                            whereClause = PstMessageEmp.fieldNames[PstMessageEmp.FLD_LEAVE_APPLICATION_ID]+"="+leave.getOID();
                                            Vector listMessageEmp = PstMessageEmp.list(0, 0, whereClause, "");
                                            String text = "";
                                            if (listMessageEmp != null && listMessageEmp.size()>0){
                                                 MessageEmp messageEmp = (MessageEmp)listMessageEmp.get(0);
                                                 text = messageEmp.getMessage();
                                            }
                                           
                                    %>
                                    <a href="javascript:cmdViewReason('<%= text %>')"> | View Reason</a>
                                    
                                    <% } %>
                                    
                                </td>
                            </tr>
                            <%
                        }
                    %>
                </table>
                <table width="100%" cellspacing="0" cellpadding="3">
                    <tr> 
                          <td> 
                            <% 
                            ctrLine.setLocationImg(approot+"/images");
                            ctrLine.initDefault();
                            out.println(ctrLine.drawImageListLimit(iCommand,vectSize,start,recordToGet));
                            %>
                          </td>
                    </tr>
                  </table>
                <%
                    }
                %>
            </div>
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



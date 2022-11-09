<%-- 
    Document   : leave_accumulation_report
    Created on : Jan 15, 2021, 3:06:57 PM
    Author     : gndiw
--%>

<%@page import="com.dimata.gui.jsp.ControlDatePopup"%>
<%@page import="com.dimata.harisma.entity.search.SrcLeaveApp"%>
<%@page import="com.dimata.harisma.form.search.FrmSrcLeaveApp"%>
<%@page import="com.dimata.harisma.entity.admin.AppObjInfo"%>
<%@page import="com.dimata.harisma.entity.attendance.PstLLStockManagement"%>
<%@page import="com.dimata.harisma.entity.attendance.AlStockManagement"%>
<%@page import="com.dimata.harisma.entity.attendance.PstAlStockManagement"%>
<%@page import="com.dimata.harisma.entity.log.ChangeValue"%>
<%@page import="com.dimata.harisma.entity.leave.PstLeaveApplication"%>
<%@page import="com.dimata.harisma.entity.leave.LeaveApplication"%>
<%@page import="com.dimata.gui.jsp.ControlCombo"%>
<%@page import="com.dimata.harisma.form.search.FrmSrcTraining"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file = "../../main/javainit.jsp" %>
<% int  appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_MENU_REPORTS, AppObjInfo.G2_MENU_LEAVE_REPORT, AppObjInfo.OBJ_MENU_LEAVE_REPORT); %>
<%@ include file = "../../main/checkuser.jsp" %>
<%
    String inOidDivision = "";
    String inOidDepartment = "";
    SrcLeaveApp objSrcLeaveApp = new SrcLeaveApp();
    FrmSrcLeaveApp objFrmSrcLeaveApp = new FrmSrcLeaveApp();
    int iCommand = FRMQueryString.requestCommand(request);
    long companyId = FRMQueryString.requestLong(request, "company_id");
    String[] oidDiv = FRMQueryString.requestStringValues(request, "division_id");
    String[] oidDept = FRMQueryString.requestStringValues(request, "department_id");
    String[] oidSec = FRMQueryString.requestStringValues(request, "section_id");
%>
<!DOCTYPE html>
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
                                <div id="caption">Tanggal Cuti</div>
                                <div id="divinput">
                                    <input type="text" name="<%=FrmSrcLeaveApp.fieldNames[FrmSrcLeaveApp.FRM_FIELD_SELECTED_DATE_FROM_LEAVE]%>" id="date_from" value="<%=(objSrcLeaveApp.getSelectedFrom() != null ? objSrcLeaveApp.getSelectedFrom(): "")%>" class="datepicker" /> <strong>To</strong> <input type="text" name="<%=FrmSrcLeaveApp.fieldNames[FrmSrcLeaveApp.FRM_FIELD_SELECTED_DATE_TO_LEAVE]%>" id="date_to" value="<%=(objSrcLeaveApp.getSelectedTo() != null ? objSrcLeaveApp.getSelectedTo() :"")%>" class="datepicker" />
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


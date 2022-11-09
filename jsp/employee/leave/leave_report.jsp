<%-- 
    Document   : leave_report
    Created on : 26-Aug-2016, 18:41:01
    Author     : Acer
--%>

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
<!DOCTYPE html>
<%
    String strUrl = "";
    strUrl  = "'0',";
    strUrl += "'0',";
    strUrl += "'0',";
    strUrl += "'0',";
    strUrl += "'frm_company_id',";
    strUrl += "'frm_division_id',";
    strUrl += "'frm_department_id',";
    strUrl += "'frm_section_id'";
    
    SessUserSession userSessionn = (SessUserSession)session.getValue(SessUserSession.HTTP_SESSION_NAME);
    AppUser appUserSess1 = userSessionn.getAppUser();
    String namaUser1 = appUserSess1.getFullName();
    
    /* Check Administrator */
    long oidCompany = 0;
    long oidDivision = 0;
    String strDisable = "";
    String strDisableNum = "";
    if (appUserSess.getAdminStatus()==0 && !privViewAllDivision){
        oidCompany = emplx.getCompanyId();
        oidDivision = emplx.getDivisionId();
        strDisable = "disabled=\"disabled\"";
    } if (namaUser1.equals("Employee")){
        strDisableNum = "disabled=\"disabled\"";
    }
    

%>
<%
	int iCommand = FRMQueryString.requestCommand(request);
    long companyId = FRMQueryString.requestLong(request, "company_id");
    String[] oidDiv = FRMQueryString.requestStringValues(request, "division_id");
    String[] oidDept = FRMQueryString.requestStringValues(request, "department_id");
    String[] oidSec = FRMQueryString.requestStringValues(request, "section_id");

    String[] positionId = FRMQueryString.requestStringValues(request, "position_id");
    int year = FRMQueryString.requestInt(request, "year");
    int category = FRMQueryString.requestInt(request, "category");
    int empcategory = FRMQueryString.requestInt(request, "empcategory");

    Vector listEmployeeLeave = new Vector();
    Vector listEmployee = new Vector();

    String whereTrain = "";
    String whereClause = "";
    String whereClauseEmp = "";
    String orderBy = PstLeaveApplication.fieldNames[PstLeaveApplication.FLD_EMPLOYEE_ID];
    Vector<String> whereCollect = new Vector<String>();
    Vector<String> whereCollectEmp = new Vector<String>();
    Hashtable<String, LeaveApplication> leaveMap = new Hashtable<String, LeaveApplication>();
    ChangeValue changeValue = new ChangeValue();


    if(category == 0){
        whereClauseEmp = " (TLA.TYPE_LEAVE_CATEGORY = 3 OR TLA.TYPE_LEAVE_CATEGORY = 1)";
        whereCollect.add(whereClauseEmp);
    } else if (category == 1){
        whereClauseEmp = " (TLA.TYPE_LEAVE_CATEGORY = 4 OR TLA.TYPE_LEAVE_CATEGORY = 1)";
        whereCollect.add(whereClauseEmp);
    }    
    if (companyId != 0){
        whereClauseEmp = " EMP."+PstEmployee.fieldNames[PstEmployee.FLD_COMPANY_ID]+"="+companyId;
        whereCollect.add(whereClauseEmp);
        whereClause = PstEmployee.fieldNames[PstEmployee.FLD_COMPANY_ID]+"="+companyId;
        if(empcategory == 0 || empcategory == 1){
            whereCollectEmp.add(whereClauseEmp);
        } else {
            whereCollectEmp.add(whereClause);
        }
    }

    if (oidDiv != null){
        String inDiv = "";
        for (int i=0; i < oidDiv.length; i++){
            inDiv = inDiv + ","+ oidDiv[i];
        }
        inDiv = inDiv.substring(1);
        whereClauseEmp = " EMP."+PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID]+" IN("+inDiv+")";
        whereCollect.add(whereClauseEmp);
        whereClause = PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID]+" IN ("+inDiv+")";
            if(empcategory == 0 || empcategory == 1){
            whereCollectEmp.add(whereClauseEmp);
        } else {
            whereCollectEmp.add(whereClause);
        }
    }
    if (oidDept != null){
        String inDept = "";
        for (int i=0; i < oidDept.length; i++){
            inDept = inDept + ","+ oidDept[i];
        }
        inDept = inDept.substring(1);
        whereClauseEmp = " EMP."+PstEmployee.fieldNames[PstEmployee.FLD_DEPARTMENT_ID]+" IN ("+inDept+")";
        whereCollect.add(whereClauseEmp);
        whereClause = PstEmployee.fieldNames[PstEmployee.FLD_DEPARTMENT_ID]+" IN ("+inDept+")";
        if(empcategory == 0 || empcategory == 1){
            whereCollectEmp.add(whereClauseEmp);
        } else {
            whereCollectEmp.add(whereClause);
        }
    }
    if (oidSec != null){
        String inSec = "";
        for (int i=0; i < oidSec.length; i++){
            inSec = inSec + ","+ oidSec[i];
        }
        inSec = inSec.substring(1);
        whereClauseEmp = " EMP."+PstEmployee.fieldNames[PstEmployee.FLD_SECTION_ID]+" IN ("+inSec+")";
        whereCollect.add(whereClauseEmp);
        whereClause = PstEmployee.fieldNames[PstEmployee.FLD_SECTION_ID]+" IN ("+inSec+")";
        if(empcategory == 0 || empcategory == 1){
            whereCollectEmp.add(whereClauseEmp);
        } else {
            whereCollectEmp.add(whereClause);
        }
    }
    
    if (positionId != null){
        String inPos = "";
        for (int i=0; i < positionId.length; i++){
            inPos = inPos + ","+ positionId[i];
        }
        inPos = inPos.substring(1);
        whereClauseEmp = " EMP."+PstEmployee.fieldNames[PstEmployee.FLD_POSITION_ID]+" IN ("+inPos+")";
        whereCollect.add(whereClauseEmp);
        whereClause = PstEmployee.fieldNames[PstEmployee.FLD_POSITION_ID]+" IN ("+inPos+")";
        if(empcategory == 0 || empcategory == 1){
            whereCollectEmp.add(whereClauseEmp);
        } else {
            whereCollectEmp.add(whereClause);
        }
    }

    if (year != 0){
        whereClauseEmp += " AND TLA.SUBMISSION_DATE BETWEEN '"+year+"-01-01' AND '"+year+"-12-31' ";
        whereCollect.add(whereClauseEmp);
    }
    if (whereCollect != null && whereCollect.size()>0){
        whereClauseEmp = "";
        for (int i=0; i<whereCollect.size(); i++){
            String where = (String)whereCollect.get(i);
            whereClauseEmp += where;
            if (i < (whereCollect.size()-1)){
                 whereClauseEmp += " AND ";
            }
        }
    }
    if (whereClauseEmp.length() > 0){
        leaveMap = PstLeaveApplication.listEmployeeLeave(0, 0, whereClauseEmp+" AND TLA.DOC_STATUS != 4", orderBy);
    }

    if (whereCollectEmp != null && whereCollectEmp.size()>0){
        whereClause = "";
        for (int i=0; i<whereCollectEmp.size(); i++){
            String where = (String)whereCollectEmp.get(i);
            whereClause += where;
            if (i < (whereCollectEmp.size()-1)){
                 whereClause += " AND ";
            }
        }
    }
    if(empcategory == 2){
        listEmployee = PstEmployee.list(0, 0, whereClause, PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_NUM]);
    } else {    
        if(category == 0){
            if (whereClause.equals("")){
                whereClause =  "AL.`AL_QTY` > 0 AND AL.`AL_STATUS` = 0";                        
            } else {
                whereClause =  "AL.`AL_QTY` > 0 AND AL.`AL_STATUS` = 0 AND " + whereClause;            
            }

            listEmployee = PstEmployee.listEmployeeALEligible(0, 0, whereClause, PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_NUM]);
        } else if (category == 1){
            if ((whereClause.equals(""))){
                whereClause = "LL.`LL_QTY` > 0 AND LL.`LL_STATUS` = 0";            
            } else {
                whereClause = "LL.`LL_QTY` > 0 AND LL.`LL_STATUS` = 0 AND " + whereClause;            
            }

            listEmployee = PstEmployee.listEmployeeLLEligible(0, 0, whereClause, PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_NUM]);
        }    
    } 
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Laporan Cuti</title>
        <link rel="stylesheet" href="../../styles/main.css" type="text/css">
        <%@ include file = "../../main/konfigurasi_jquery.jsp" %>    
        <script src="../../javascripts/jquery.min-1.6.2.js" type="text/javascript"></script>
        <script src="../../javascripts/chosen.jquery.js" type="text/javascript"></script>
        <link rel="stylesheet" href="../../stylesheets/chosen.css" >
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
        function cmdSearch(){
                    document.frm.command.value="<%=String.valueOf(Command.LIST)%>";
                    document.frm.action="leave_report.jsp";
                    document.frm.submit();
        }    
        function cmdExport(){
                document.frpresence.command.value="<%=String.valueOf(Command.LIST)%>";
                document.frpresence.action="export_excel/overtime_report.jsp";
                document.frpresence.submit();
        }    
        
        </script>
        
<script type="text/javascript">


function cmdGetTraining(oidType){
    var xmlhttp = new XMLHttpRequest();
    xmlhttp.onreadystatechange = function() {
        if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
            document.getElementById("option-train").innerHTML = xmlhttp.responseText;
        }
    };
    var strUrl = "option_training.jsp?type_id="+oidType;
    xmlhttp.open("GET", strUrl, true);
    xmlhttp.send();
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
            <span id="menu_title">Leave Report <strong style="color:#333;"> / </strong>Pencarian</span>
        </div>
        <div class="content-main">
            <form name="frm" method="post" action="">
                <input type="hidden" name="command" value="<%=iCommand%>">
                <input type="hidden" name="start" value="">
                <div class="box">
                    <div id="title-box">Pencarian Laporan Cuti</div>
                    <table width="100%">
                        <tr>
                            <td valign="top" width="40%">
                                <div class="caption">
                                    <%=dictionaryD.getWord(I_Dictionary.COMPANY)%>
                                </div>
                                <div id="divinput">
                                    <%

                                        Vector com_value = new Vector(1, 1);
                                        Vector com_key = new Vector(1, 1);
                                        String placeHolderComp = "";
                                        String multipleComp = "";
                                        if (oidDivision == 0){
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
                                    <%= ControlCombo.draw("company_id", "chosen-select", null,""+companyId , com_value, com_key, multipleComp+" "+placeHolderComp+" style='width:80%' id='company'")%>
                                </div>
                                <div class="caption">
                                    <%=dictionaryD.getWord(I_Dictionary.DIVISION)%>
                                </div>
                                <div id="divinput">
                                    <%

                                        Vector div_value = new Vector(1, 1);
                                        Vector div_key = new Vector(1, 1);
                                        
                                        Vector listDiv  = new Vector();
                                        String placeHolder = "";
                                        String multipleDiv = "";
                                        if (oidDivision == 0){
                                            listDiv = PstDivision.list(0, 0, "VALID_STATUS=1", "");
                                            placeHolder = "data-placeholder='Select Satuan Kerja...'";
                                            multipleDiv = "multiple";
                                        } else {
                                            listDiv = PstDivision.list(0, 0, PstDivision.fieldNames[PstDivision.FLD_DIVISION_ID] + " = " + emplx.getDivisionId()  + " AND VALID_STATUS=1", PstDivision.fieldNames[PstDivision.FLD_DIVISION_ID]);
                                        }

                                        for (int i = 0; i < listDiv.size(); i++) {
                                            Division div = (Division) listDiv.get(i);
                                            div_key.add(div.getDivision());
                                            div_value.add(String.valueOf(div.getOID()));
                                        }
                                    %>
                                        <%= ControlCombo.drawStringArraySelected("division_id", "chosen-select", null, oidDiv, div_key, div_value, null, multipleDiv+" "+placeHolder+" style='width:80%' id='division'") %> 
                                </div>
                                <div class="caption">
                                    <%=dictionaryD.getWord(I_Dictionary.DEPARTMENT)%>
                                </div>
                                <div id="divinput">
                                    <%
                                        Vector dep_value = new Vector(1, 1);
                                        Vector dep_key = new Vector(1, 1);
                                        
                                        Vector listDep = new Vector();

                                        if (oidDivision == 0){
                                            listDep = PstDepartment.list(0, 0, "hr_department.VALID_STATUS=1", "");
                                        } else {
                                            listDep = PstDepartment.list(0, 0, "hr_department."+PstDepartment.fieldNames[PstDepartment.FLD_DIVISION_ID] + " = " + oidDivision + " AND hr_department.VALID_STATUS=1", "");
                                        }

                                        Hashtable hashDiv = PstDivision.listMapDivisionName(0, 0, "", "");
                                        long tempDivOid = 0 ;
                                        for (int i = 0; i < listDep.size(); i++) {
                                            Department dep = (Department) listDep.get(i);

                                            if (dep.getDivisionId() != tempDivOid){
                                                dep_key.add("--"+hashDiv.get(dep.getDivisionId())+"--");
                                                dep_value.add(String.valueOf(-1));
                                                tempDivOid = dep.getDivisionId();
                                            }

                                            dep_key.add(dep.getDepartment());
                                            dep_value.add(String.valueOf(dep.getOID()));
                                        }
                                    %>

                                    <%= ControlCombo.drawStringArraySelected("department_id", "chosen-select", null, oidDept, dep_key, dep_value, null, "size=8 multiple data-placeholder='Select Unit...' style='width:80%' id='department'") %> 
                                </div>
                                <div class="caption">
                                    <%=dictionaryD.getWord(I_Dictionary.SECTION)%>
                                </div>
                                <div id="divinput">
                                    <%

                                        Vector sec_value = new Vector(1, 1);
                                        Vector sec_key = new Vector(1, 1);
                                        

                                        Vector listSec = new Vector();

                                        if (oidDivision == 0){
                                            listSec = PstSection.list(0, 0, "VALID_STATUS=1", "DEPARTMENT_ID");
                                        } else {
                                            listSec = PstSection.list(0, 0, PstSection.fieldNames[PstSection.FLD_DEPARTMENT_ID] + " = " + emplx.getDepartmentId(), "DEPARTMENT_ID");
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
                                     <%= ControlCombo.drawStringArraySelected("section_id", "chosen-select", null, oidSec, sec_key, sec_value, null, "multiple data-placeholder='Select Sub Unit...' style='width:80%' id='section'") %> 
                                </div>
                            </td>
                            <td valign="top" width="60%">
                                <div class="caption">
                                    <%=dictionaryD.getWord(I_Dictionary.POSITION)%>
                                </div>
                                <div id="divinput">
                                    <%

                                        Vector pos_value = new Vector(1, 1);
                                        Vector pos_key = new Vector(1, 1);
                                        
                                        Vector listPosition = PstPosition.list(0, 0, "", PstPosition.fieldNames[PstPosition.FLD_POSITION]);

                                        for (int i = 0; i < listPosition.size(); i++) {
                                            Position pos = (Position) listPosition.get(i);
                                            pos_key.add(pos.getPosition());
                                            pos_value.add(String.valueOf(pos.getOID()));
                                        }
                                    %>
                                     <%= ControlCombo.drawStringArraySelected("position_id", "chosen-select", null, positionId, pos_key, pos_value, null, "multiple data-placeholder='Select Position...' style='width:50%' id='position'") %> 
                                </div>
                                <div class="caption">
                                    Tahun
                                </div>
                                <div class="divinput">
                                    <select name="year" id="year" class="chosen-select" style='width:10%'>
                                        <% 
                                        int tahun = Calendar.getInstance().get(Calendar.YEAR);
                                        for (int i=tahun; 1990<i; i--){
                                            String selected = "";
                                            if (i == year){
                                                selected = "selected";
                                            }
                                        %>

                                        <option value="<%=i%>" <%=selected%>><%=i%></option>

                                        <%
                                        }
                                        %>
                                    </select>
                                </div>
                                <div class="caption">
                                    Jenis Cuti
                                </div>
                                <div class="divinput">
                                    <select name="category" id="category" class="chosen-select" style='width:20%'>
                                        <option value="0" <%=(category == 0 ? "selected" : "")%>>Cuti Tahunan</option>
                                        <option value="1" <%=(category == 1 ? "selected" : "")%>>Cuti Besar</option>
                                    </select>
                                </div>
                                <div class="caption">
                                    Jenis Karyawan
                                </div>
                                <div class="divinput">
                                    <select name="empcategory" id="empcategory" class="chosen-select" style='width:20%'>
                                        <option value="0" <%=(empcategory == 0 ? "selected" : "")%>>Sudah Mengambil</option>
                                        <option value="1" <%=(empcategory == 1 ? "selected" : "")%>>Belum Mengambil</option>
                                        <option value="2" <%=(empcategory == 2 ? "selected" : "")%>>Semua</option>
                                    </select>
                                </div>    
                                
                            </td>
                        </tr>
                    </table>
                    <div style="border-top: 1px solid #DDD;">&nbsp;</div>
                    <a href="javascript:cmdSearch()" style="color:#FFF;" class="btn">Search</a>
                    <div>&nbsp;</div>
                </div>
                <div class="box">
                    <div id="title-box">Hasil Pencarian</div>
                    <div>&nbsp;</div>
                    <%
                        if (listEmployee != null && listEmployee.size()>0 && iCommand == Command.LIST){
                            %>
                            <table class="tblStyle">
                            <tr>
                                <td class="title_tbl">No</td>
                                <td class="title_tbl">Emp. num</td>
                                <td class="title_tbl">Nama Karyawan</td>
                                <td class="title_tbl">Division</td>
                                <td class="title_tbl">Department</td>
                                <td class="title_tbl">Position</td>

                                <% if(category == 0){ %>
                                <td class="title_tbl">Cuti Tahunan</td>
                                <% } else { %>
                                <td class="title_tbl">Cuti Besar</td>
                                <% } %>
                            </tr>
                            <%
                            int jum = 0;
                            for(int i=0; i<listEmployee.size(); i++){
                                Employee emp = (Employee)listEmployee.get(i);

                                Division div = new Division();
                                Position position = new Position();
                                Department dep =  new Department();

								boolean alStatus = false;
								boolean llStatus = false;
								/* for leave information */
								String whereClauseAl = PstAlStockManagement.fieldNames[PstAlStockManagement.FLD_EMPLOYEE_ID]+"="+emp.getOID();
								whereClauseAl += " AND "+PstAlStockManagement.fieldNames[PstAlStockManagement.FLD_AL_STATUS]+"=0";
								Vector alStockList = PstAlStockManagement.list(0, 0, whereClauseAl, "");
								if (alStockList != null && alStockList.size()>0){
									alStatus = true;
								}
								String whereClauseLL = PstLLStockManagement.fieldNames[PstLLStockManagement.FLD_EMPLOYEE_ID]+"="+emp.getOID();
								whereClauseLL += " AND "+PstLLStockManagement.fieldNames[PstLLStockManagement.FLD_LL_STATUS]+"=0";
								Vector llStockList = PstLLStockManagement.list(0, 0, whereClauseLL, "");
								if (llStockList != null && llStockList.size()>0){
									llStatus = true;
								}
								
                                String empId = String.valueOf(emp.getOID());
                                String empDepartment = "";
                                String empPosition = "";
                                String empDivision = "";
                                String trType = "";
                                String status = "";
                                LeaveApplication lv = new LeaveApplication();
                                try{
                                    div = PstDivision.fetchExc(emp.getDivisionId());
                                    empDivision = div.getDivision();
                                    position = PstPosition.fetchExc(emp.getPositionId());
                                    empPosition = position.getPosition();
                                    dep = PstDepartment.fetchExc(emp.getDepartmentId());
                                    empDepartment = dep.getDepartment();

                                    lv = leaveMap.get(empId);

                                    if(category == 0){
                                        if (lv != null &&  (lv.getTypeLeaveCategory() == 3 || (lv.getTypeLeaveCategory() == 1 && alStatus)) && (lv.getDocStatus() == 2 || lv.getDocStatus() == 3)){
                                            status = "<font color=\"#40FF00\">&#10004</font>";
                                        } else {
                                            status = "<font color=\"#FF0000\">&#10006</font>";
                                        }
                                    } else {
                                        if (lv != null &&  (lv.getTypeLeaveCategory() == 4 || (lv.getTypeLeaveCategory() == 1 && llStatus)) && (lv.getDocStatus() == 2 || lv.getDocStatus() == 3)){
                                            status = "<font color=\"#40FF00\">&#10004</font>";
                                        } else {
                                            status = "<font color=\"#FF0000\">&#10006</font>";
                                        }
                                    }
                                } catch (Exception exc){
                                    System.out.println("error"+exc);
                                }

                                if ( empcategory == 0){
                                    if(category == 0){
                                        if (lv != null && (lv.getTypeLeaveCategory() == 3 || (lv.getTypeLeaveCategory() == 1 && alStatus)) && (lv.getDocStatus() == 2 || lv.getDocStatus() == 3)){ 
                                            jum = jum + 1;
                                            %>
                                           <tr>
                                               <td><%= jum %></td>
                                               <td><%= emp.getEmployeeNum() %></td>
                                               <td><%= emp.getFullName() %></td>
                                               <td><%= empDivision %></td>
                                               <td><%= empDepartment %></td>
                                               <td><%= empPosition %></td>
                                               <td align="center"><%= status %></td>
                                           </tr>
                                           <%
                                        }
                                    } else if (category == 1){  
                                        if (lv != null && (lv.getTypeLeaveCategory() == 4 || (lv.getTypeLeaveCategory() == 1 && llStatus)) && (lv.getDocStatus() == 2 || lv.getDocStatus() == 3)){
                                            jum = jum + 1;
                                            %>
                                           <tr>
                                               <td><%= jum %></td>
                                               <td><%= emp.getEmployeeNum() %></td>
                                               <td><%= emp.getFullName() %></td>
                                               <td><%= empDivision %></td>
                                               <td><%= empDepartment %></td>
                                               <td><%= empPosition %></td>
                                               <td align="center"><%= status %></td>
                                           </tr>
                                           <%
                                        }
                                    }
                                }

                                else if (empcategory == 1){
                                    if(category == 0){
                                        if (lv == null || (lv.getTypeLeaveCategory() != 3 && (lv.getTypeLeaveCategory() != 1 && alStatus) ) && (lv.getDocStatus() == 2 || lv.getDocStatus() == 3)){ 
                                            jum = jum + 1;
                                            %>
                                           <tr>
                                               <td><%= jum %></td>
                                               <td><%= emp.getEmployeeNum() %></td>
                                               <td><%= emp.getFullName() %></td>
                                               <td><%= empDivision %></td>
                                               <td><%= empDepartment %></td>
                                               <td><%= empPosition %></td>
                                               <td align="center"><%= status %></td>
                                           </tr>
                                           <%
                                        }
                                    } else if (category == 1){  
                                        if (lv == null || (lv.getTypeLeaveCategory() != 4 && (lv.getTypeLeaveCategory() != 1 && llStatus)) && (lv.getDocStatus() == 2 || lv.getDocStatus() == 3)){
                                            jum = jum + 1;
                                            %>
                                           <tr>
                                               <td><%= jum %></td>
                                               <td><%= emp.getEmployeeNum() %></td>
                                               <td><%= emp.getFullName() %></td>
                                               <td><%= empDivision %></td>
                                               <td><%= empDepartment %></td>
                                               <td><%= empPosition %></td>
                                               <td align="center"><%= status %></td>
                                           </tr>
                                           <%
                                        }
                                    }  
                                } else {
                                jum = jum + 1;
                                %>
                                <tr>
                                    <td><%= jum %></td>
                                    <td><%= emp.getEmployeeNum() %></td>
                                    <td><%= emp.getFullName() %></td>
                                    <td><%= empDivision %></td>
                                    <td><%= empDepartment %></td>
                                    <td><%= empPosition %></td>
                                    <td align="center"><%= status %></td>
                                </tr>
                                <% }
                            }
                            %>
                            </table>
                            <%
                        } else {
                    %>
                    <h>No Employee Eligible</h>
                    <%  } %>
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

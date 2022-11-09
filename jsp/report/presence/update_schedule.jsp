<%-- 
    Document   : leave_report
    Created on : 26-Aug-2016, 18:41:01
    Author     : Acer
--%>

<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.dimata.harisma.entity.attendance.PstEmpSchedule"%>
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
	String date = FRMQueryString.requestString(request, "date");
	String[] arrayOid = FRMQueryString.requestStringValues(request, "emp_array");
	long schId = FRMQueryString.requestLong(request, "schedule_id");
	
	if (iCommand == Command.UPDATE){
		if (arrayOid != null){
			Period period = new Period();
			Date dt=new SimpleDateFormat("yyyy-MM-dd").parse(date);  
			try {
				period = PstPeriod.getPeriodBySelectedDate(dt);
			} catch (Exception exc){}
			
		    for (int i=0; i < arrayOid.length; i++){
				PstEmpSchedule.updateSchedule(period.getOID(), Long.valueOf(arrayOid[i]), dt, schId);
			}
       }
		iCommand = Command.LIST;
	}

    Vector listEmployeeLeave = new Vector();
    Vector listEmployee = new Vector();

    String whereClause = "";
    String whereClauseEmp = "";
    Vector<String> whereCollect = new Vector<String>();
    ChangeValue changeValue = new ChangeValue();
    if (companyId != 0){
        whereClauseEmp =PstEmployee.fieldNames[PstEmployee.FLD_COMPANY_ID]+"="+companyId;
        whereCollect.add(whereClauseEmp);
    
    }

    if (oidDiv != null){
        String inDiv = "";
        for (int i=0; i < oidDiv.length; i++){
            inDiv = inDiv + ","+ oidDiv[i];
        }
        inDiv = inDiv.substring(1);
        whereClauseEmp =PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID]+" IN("+inDiv+")";
        whereCollect.add(whereClauseEmp);
    
    }
    if (oidDept != null){
        String inDept = "";
        for (int i=0; i < oidDept.length; i++){
            inDept = inDept + ","+ oidDept[i];
        }
        inDept = inDept.substring(1);
        whereClauseEmp =PstEmployee.fieldNames[PstEmployee.FLD_DEPARTMENT_ID]+" IN ("+inDept+")";
        whereCollect.add(whereClauseEmp);
    }
    if (oidSec != null){
        String inSec = "";
        for (int i=0; i < oidSec.length; i++){
            inSec = inSec + ","+ oidSec[i];
        }
        inSec = inSec.substring(1);
        whereClauseEmp =PstEmployee.fieldNames[PstEmployee.FLD_SECTION_ID]+" IN ("+inSec+")";
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
	
	listEmployee = PstEmployee.list(0, 0, whereClauseEmp, "");
    
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Update Schedule</title>
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
		<link rel="stylesheet" href="<%=approot%>/javascripts/datepicker/themes/jquery.ui.all.css"/>
<link rel="stylesheet" href="<%=approot%>/javascripts/datepicker/themes/jquery.ui.timepicker.addon.css"/>

<script src="<%=approot%>/javascripts/datepicker/jquery.ui.core.js"></script>
<script src="<%=approot%>/javascripts/datepicker/jquery.ui.widget.js"></script>
<script src="<%=approot%>/javascripts/datepicker/jquery.ui.datepicker.js"></script>
<script src="<%=approot%>/javascripts/datepicker/jquery.ui.timepicker.addon.js"></script>
        <script language="JavaScript">
        function cmdSearch(){
                    document.frm.command.value="<%=String.valueOf(Command.LIST)%>";
                    document.frm.action="update_schedule.jsp";
                    document.frm.submit();
        }    
        function cmdUpdate(){
                document.frm.command.value="<%=String.valueOf(Command.UPDATE)%>";
                document.frm.action="update_schedule.jsp";
                document.frm.submit();
        }    
		
		function pilihsemua()
		{
			var daftarku = document.getElementsByName("emp_array");
			var jml=daftarku.length;
			var b=0;
			for (b=0;b<jml;b++)
			{
				daftarku[b].checked=true;

			}
		}

		function bersihkan()
		{
			var daftarku = document.getElementsByName("emp_array");
			var jml=daftarku.length;
			var b=0;
			for (b=0;b<jml;b++)
			{
				daftarku[b].checked=false;

			}
		}
        
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
            <span id="menu_title">Absensi <strong style="color:#333;"> / </strong>Update Schedule</span>
        </div>
        <div class="content-main">
            <form name="frm" method="post" action="">
                <input type="hidden" name="command" value="<%=iCommand%>">
                <input type="hidden" name="start" value="">
                <div class="box">
                    <div id="title-box">Pencarian Laporan Cuti</div>
                    <table width="50%">
                        <tr>
                            <td valign="top" width="30%">
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
								<div class="caption">
									Date
								</div>
								<div id="divinput" style="width: 30%">
									<input type="text" name="date" class="datepicker" value="<%=(date.equals("") ? Formater.formatDate(new Date(), "yyyy-MM-dd") : date)%>">
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
							<div class="caption">
								Schedule
							</div>
							<div id="divinput" style="width: 30%">
								<%
									Vector sch_value = new Vector(1, 1);
									Vector sch_key = new Vector(1, 1);

									Vector listSchedule = PstScheduleSymbol.listAll();

									for (int i = 0; i < listSchedule.size(); i++) {
										ScheduleSymbol symbol = (ScheduleSymbol) listSchedule.get(i);
										sch_key.add(symbol.getSchedule());
										sch_value.add(String.valueOf(symbol.getOID()));
									}
								%>

								 <%= ControlCombo.draw("schedule_id", "chosen-select", null,""+0 , sch_value, sch_key, "data-placeholder='Select Schedule...' style='width:80%' id='schedule'")%>
							</div>
							<br>
							<div>
                            <table class="tblStyle">
                            <tr>
								<td class="title_tbl"><a href="javascript:pilihsemua()">Check All</a> ||
								<a href="javascript:bersihkan()">Uncheck All</a></td>
                                <td class="title_tbl">Emp. num</td>
                                <td class="title_tbl">Nama Karyawan</td>
                                <td class="title_tbl">Division</td>
                                <td class="title_tbl">Department</td>
                                <td class="title_tbl">Position</td>
								<td class="title_tbl">Schedule</td>
                            </tr>
                            <%
                            int jum = 0;
                            for(int i=0; i<listEmployee.size(); i++){
                                Employee emp = (Employee)listEmployee.get(i);

                                Division div = new Division();
                                Position position = new Position();
                                Department dep =  new Department();

                                String empId = String.valueOf(emp.getOID());
                                String empDepartment = "";
                                String empPosition = "";
                                String empDivision = "";
								
								Period period = new Period();
								String symbol = "";
								try {
									Date dt=new SimpleDateFormat("yyyy-MM-dd").parse(date);  
									period = PstPeriod.getPeriodBySelectedDate(dt);
									Calendar cal = Calendar.getInstance();
									cal.setTime(dt);
									long scheduleId = PstEmpSchedule.getSchedule(cal.get(Calendar.DAY_OF_MONTH), emp.getOID(), dt);
									ScheduleSymbol sch = PstScheduleSymbol.fetchExc(scheduleId);
									symbol = sch.getSymbol();
								} catch (Exception exc){}
                                
								
								
                                try{
                                    div = PstDivision.fetchExc(emp.getDivisionId());
                                    empDivision = div.getDivision();
                                    position = PstPosition.fetchExc(emp.getPositionId());
                                    empPosition = position.getPosition();
                                    dep = PstDepartment.fetchExc(emp.getDepartmentId());
                                    empDepartment = dep.getDepartment();

                                } catch (Exception exc){
                                    System.out.println("error"+exc);
                                }
								%>
                                <tr>
                                    <td><center><input type="checkbox" name='emp_array' value="<%= emp.getOID()%>" id='chkapp'></center></td>
                                    <td><%= emp.getEmployeeNum() %></td>
                                    <td><%= emp.getFullName() %></td>
                                    <td><%= empDivision %></td>
                                    <td><%= empDepartment %></td>
                                    <td><%= empPosition %></td>
                                    <td align="center"><%=symbol%></td>
                                </tr>
                                <% 
                            }
                            %>
                            </table>
							</div>
							<div style="border-top: 1px solid #DDD;">&nbsp;</div>
							<a href="javascript:cmdUpdate()" style="color:#FFF;" class="btn">Update</a>
                            <%
                        } else {
                    %>
                    <h>No Data</h>
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

<%-- 
    Document   : overtime_report
    Created on : 17-May-2017, 15:10:59
    Author     : Gunadi
--%>

<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.dimata.harisma.entity.payroll.PaySlipComp"%>
<%@page import="com.dimata.harisma.entity.payroll.PstPaySlipComp"%>
<%@page import="com.dimata.harisma.entity.payroll.PaySlip"%>
<%@page import="com.dimata.harisma.entity.payroll.PstPaySlip"%>
<%@page import="com.dimata.harisma.entity.payroll.PayPeriod"%>
<%@page import="com.dimata.harisma.entity.payroll.PstPayPeriod"%>
<%@page import="com.dimata.harisma.entity.overtime.PstOvertime"%>
<%@page import="com.dimata.harisma.entity.payroll.PstOvt_Type"%>
<%@page import="com.dimata.harisma.entity.overtime.OvertimeDetail"%>
<%@page import="com.dimata.harisma.entity.overtime.PstOvertimeDetail"%>
<%@page import="com.dimata.gui.jsp.ControlCombo"%>
<%@ include file = "../../main/javainit.jsp" %>
<% int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_MENU_REPORTS, AppObjInfo.G2_MENU_PAYROLL_REPORT, AppObjInfo.OBJ_MENU_OVERTIME_RPT); %>
<%@ include file = "../../main/checkuser.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    /* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
    //boolean privPrint = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_PRINT));

    long hrdDepOid = Long.parseLong(String.valueOf(PstSystemProperty.getPropertyLongbyName(OID_HRD_DEPARTMENT)));
    boolean isHRDLogin = true ;
    
    long edpSectionOid = Long.parseLong(String.valueOf(PstSystemProperty.getPropertyLongbyName(OID_EDP_SECTION)));
    boolean isEdpLogin = edpSectionOid == sectionOfLoginUser.getOID() ? true : false;
    boolean isGeneralManager = positionType == PstPosition.LEVEL_GENERAL_MANAGER ? true : false;
    
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

//cek tipe browser, browser detection
    //String userAgent = request.getHeader("User-Agent");
    //boolean isMSIE = (userAgent!=null && userAgent.indexOf("MSIE") !=-1); 

%>
<%!
    public int getOvertimeType(Date dtParam, long religionId) {
        int result = 0;
        Vector listPH = new Vector();
        
        listPH = PstPublicHolidays.list(0, 0, "'"+Formater.formatDate(dtParam, "yyyy-MM-dd")+"' BETWEEN  holiday_date AND holiday_date_to", "holiday_status");
        boolean ovtEndOfYear = PstOvertime.endOfYearOvertime(dtParam);
        
        if (ovtEndOfYear){
            result = PstOvt_Type.END_OF_YEAR;
        }else if(listPH.size() > 0){
            for(int i = 0; i < listPH.size(); i++){
                PublicHolidays pH = (PublicHolidays)listPH.get(i);
                if(pH.getiHolidaySts() == 1 || religionId == pH.getiHolidaySts()){
                    result = PstOvt_Type.HOLIDAY;
                    i = listPH.size();
                }
            }
        } else {
            String[] stDays = {
		"Sunday","Monday","Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"
            };
            
            Calendar objCal = Calendar.getInstance();
            objCal.setTime(dtParam);
            
            String day = stDays[objCal.get(Calendar.DAY_OF_WEEK)-1];
            if(day == stDays[0] || day == stDays[6]){
                result = PstOvt_Type.SCHEDULE_OFF;
            } else {
                result = PstOvt_Type.WORKING_DAY;
            }
        }
        
        return result;
    }
%>
<%
    int iCommand = FRMQueryString.requestCommand(request);
    String empNumber = FRMQueryString.requestString(request, "emp_number");
    String empName = FRMQueryString.requestString(request, "full_name");
    long oidComp = FRMQueryString.requestLong(request, "company_id");
    String[] oidDiv = FRMQueryString.requestStringValues(request, "division_id");
    String[] oidDept = FRMQueryString.requestStringValues(request, "department");
    String[] oidSec = FRMQueryString.requestStringValues(request, "section");
    String dateFrom = FRMQueryString.requestString(request, "date_from");
    String dateTo = FRMQueryString.requestString(request, "date_to");
    int type = FRMQueryString.requestInt(request, "type");
    int periodType = FRMQueryString.requestInt(request, "period_type");
    
    Vector<String> whereCollect = new Vector<String>();
    String whereClauseEmp = "";
    
    if(!empNumber.equals("")){
        whereClauseEmp = " emp."+PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_NUM]+" = '"+empNumber+"'";
        whereCollect.add(whereClauseEmp);
    }
    if(!empName.equals("")){
        whereClauseEmp = " emp."+PstEmployee.fieldNames[PstEmployee.FLD_FULL_NAME]+" = '"+empName+"'";
        whereCollect.add(whereClauseEmp);
    }
    if (oidComp != 0){
        whereClauseEmp = " emp."+PstEmployee.fieldNames[PstEmployee.FLD_COMPANY_ID]+" ="+oidComp;
        whereCollect.add(whereClauseEmp);
    }
    if (oidDiv != null){
        String inDiv = "";
        for (int i=0; i < oidDiv.length; i++){
			try {
				Division div = PstDivision.fetchExc(Long.valueOf(oidDiv[i]));
				inDiv = inDiv + ", '"+ div.getDivision()+"'";
			} catch (Exception exc){
				
			}
        }
        inDiv = inDiv.substring(1);
        whereClauseEmp = " ps."+PstPaySlip.fieldNames[PstPaySlip.FLD_DIVISION]+" IN("+inDiv+")";
        whereCollect.add(whereClauseEmp);
    }
    if (oidDept != null){
        String inDept = "";
        for (int i=0; i < oidDept.length; i++){
			try {
				Department dept = PstDepartment.fetchExc(Long.valueOf(oidDept[i]));
				inDept = inDept + ", '"+ dept.getDepartment()+"'";
			} catch (Exception exc){
				
			}
        }
        inDept = inDept.substring(1);
        whereClauseEmp = " ps."+PstPaySlip.fieldNames[PstPaySlip.FLD_DEPARTMENT]+" IN ("+inDept+")";
        whereCollect.add(whereClauseEmp);
    }
    if (oidSec != null){
        String inSec = "";
        for (int i=0; i < oidSec.length; i++){
			try {
				Section sec = PstSection.fetchExc(Long.valueOf(oidSec[i]));
				inSec = inSec + ", '"+ sec.getSection()+"'";
			} catch (Exception exc){
				
			}
        }
        inSec = inSec.substring(1);
        whereClauseEmp = " ps."+PstPaySlip.fieldNames[PstPaySlip.FLD_SECTION]+" IN ("+inSec+")";
        whereCollect.add(whereClauseEmp);
    }
    if (!dateFrom.equals("") && !dateTo.equals("")){
        whereClauseEmp = " odt."+PstOvertimeDetail.fieldNames[PstOvertimeDetail.FLD_DATE_FROM]+" BETWEEN "
        + "'" +dateFrom+" 00:00:00' AND '"+dateTo+" 23:59:00'" ;
        whereCollect.add(whereClauseEmp);
    }
	
	long oidPeriod = 0;
	try {
		Date date=new SimpleDateFormat("yyyy-MM-dd").parse(dateTo);  
                if (periodType == 0){
                    PayPeriod payPeriod1 = PstPayPeriod.getNextPayPeriodBySelectedDate(date);
                    oidPeriod = payPeriod1.getOID();
                } else {
                    PayPeriod payPeriod1 = PstPayPeriod.getPayPeriodBySelectedDate(date);
                    oidPeriod = payPeriod1.getOID();
                }
	} catch (Exception exc){}
	
    
    whereCollect.add(" odt."+PstOvertimeDetail.fieldNames[PstOvertimeDetail.FLD_STATUS]+"= 4");
    
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
    
    String listEmpTime = PstOvertimeDetail.listEmpReport(0, 0, whereClauseEmp, "", oidPeriod);
    String [] arrayEmp = listEmpTime.split(",");
    
    int removeTable = 0;
    
    String brutoCompCode = PstSystemProperty.getValueByNameWithStringNull("BRUTO_COMP_CODE_FOR_OVERTIME");
    double brutoPercentage = 0;
    try {
        brutoPercentage = Double.parseDouble(PstSystemProperty.getValueByNameWithStringNull("BRUTO_PERCENTAGE_FOR_OVERTIME"));
    } catch (Exception exc){
        
    }
    
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Laporan Lembur</title>
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
                    document.frpresence.command.value="<%=String.valueOf(Command.LIST)%>";
                    document.frpresence.action="overtime_report.jsp";
                    document.frpresence.submit();
        }    
        function cmdExport(){
                document.frpresence.command.value="<%=String.valueOf(Command.LIST)%>";
                document.frpresence.action="export_excel/overtime_report.jsp";
                document.frpresence.submit();
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
            <span id="menu_title"><strong>Laporan</strong> <strong style="color:#333;"> / </strong> <strong>Lembur</strong> <strong style="color:#333;"> / </strong> Laporan Lembur </span>
        </div>
        <div class="content-main">
            <form name="frpresence" method="post" action="">
                <input type="hidden" name="command" value="<%=iCommand%>">
                <input type="hidden" name="start" value="">
                <div class="formstyle">
                    <table>
                        <tr>
                            <td valign="top" style="padding-right: 21px;">
                                <div id="caption">NRK</div>
                                <div id="divinput">
                                    <input type="text" name="emp_number" id="emp_number" value="<%=empNumber%>" />
                                </div>
                                <div id="caption">Perusahaan</div>
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
                                    <%= ControlCombo.draw("company_id", "chosen-select", null, "" + oidComp, com_value, com_key, multipleComp+" "+placeHolderComp+" style='width:100%'")%>
                                </div>
                                <div id="caption">Unit</div>
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

                                    <%= ControlCombo.drawStringArraySelected("department", "chosen-select", null, oidDept, dep_key, dep_value, null, "size=8 multiple data-placeholder='Select Unit...' style='width:100%'") %> 
                                </div>
                                <div id="caption">Periode</div>
                                <div id="divinput">
                                    <input type="text" name="date_from" id="date_from" value="<%=dateFrom%>" class="datepicker" /> <strong>To</strong> <input type="text" name="date_to" id="date_to" value="<%=dateTo%>" class="datepicker" />
                                    <br>
                                    <input type="radio" name="period_type" value="0" <%=( periodType == 0 ? "checked" : "" )%>> Periode Berikutnya
                                    <input type="radio" name="period_type" value="1" <%=( periodType == 1 ? "checked" : "" )%>> Periode saat ini
                                </div>    
                            </td>
                            <td valign="top">
                                <div id="caption">Nama Karyawan</div>
                                <div id="divinput">
                                    <input type="text" name="full_name" id="full_name" value="<%=empName%>" />                                
                                </div>
                                <div id="caption">Satuan Kerja</div>
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
                                        <%= ControlCombo.drawStringArraySelected("division_id", "chosen-select", null, oidDiv, div_key, div_value, null, multipleDiv+" "+placeHolder+" style='width:100%'") %> 
                                </div>
                                <div id="caption">Sub Unit</div>
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
                                     <%= ControlCombo.drawStringArraySelected("section", "chosen-select", null, oidSec, sec_key, sec_value, null, "multiple data-placeholder='Select Sub Unit...' style='width:100%'") %> 
                                </div>
                                <div id="divinput">
                                    <input type="radio" name="type" value="0" checked> Normal
                                    <input type="radio" name="type" value="1"> Akhir Tahun
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div>
                                    <a href="javascript:cmdSearch()" class="btn" style="color:#FFF;">Search</a>
                                    <a href="javascript:cmdExport()" class="btn" style="color:#FFF;">Export XLS</a>
                                </div>
                            </td> 
                        </tr>
                    </table>
                </div>
<% if (iCommand == Command.LIST && arrayEmp != null) {
 %>
        <h4 id="title"><strong>Laporan Lembur</strong></h4>
        <table class="tblStyle" border="1" id="table">
            <tr>
                <td class="title_tbl" style="text-align:center; vertical-align:middle" rowspan="2">No</td>
                <td class="title_tbl" style="text-align:center; vertical-align:middle" rowspan="2">NRK</td>
                <td class="title_tbl" style="text-align:center; vertical-align:middle" rowspan="2">Nama</td>
                <td class="title_tbl" style="text-align:center; vertical-align:middle" rowspan="2">Jabatan</td>
                <td class="title_tbl" style="text-align:center; vertical-align:middle" rowspan="2">Divisi</td>
                <% if (type == 0) {%>
                <td class="title_tbl" style="text-align:center; vertical-align:middle" colspan="2">Hari Biasa</td>
                <td class="title_tbl" style="text-align:center; vertical-align:middle" colspan="3">Hari Sabtu/Minggu</td>
                <td class="title_tbl" style="text-align:center; vertical-align:middle" rowspan="2">Lembur Istimewa Hari Raya / Libur Nasional</td>
                <% } else { %>
                <td class="title_tbl" style="text-align:center; vertical-align:middle" rowspan="2">Lembur Akhir Tahun</td>
                <% } %>
                <td class="title_tbl" style="text-align:center; vertical-align:middle" colspan="2">Lembur</td>
            </tr>
            <tr>
                <% if (type == 0) {%>
                    <td class="title_tbl" style="text-align:center; vertical-align:middle">Satu Jam Pertama</td>
                    <td class="title_tbl" style="text-align:center; vertical-align:middle">Diatas Satu Jam</td>
                    <td class="title_tbl" style="text-align:center; vertical-align:middle">Delapan Jam Pertama</td>
                    <td class="title_tbl" style="text-align:center; vertical-align:middle">Jam Kesembilan</td>
                    <td class="title_tbl" style="text-align:center; vertical-align:middle">Jam Kesepuluh Keatas</td>
                <% }%>
                <td class="title_tbl" style="text-align:center; vertical-align:middle">Rek. Simpeda</td>
                <td class="title_tbl" style="text-align:center; vertical-align:middle">Uang Lembur (Rp)</td>
            </tr>
            <%
                int No = 0;
                double total = 0.0;
                for (int i=0; i< arrayEmp.length; i++){
                    Employee emp = new Employee();
                    try {
                        emp = PstEmployee.fetchExc(Long.valueOf(arrayEmp[i]));
                    } catch (Exception exc){}
                    
                    Level lvl = new Level();
                    try {
                        lvl = PstLevel.fetchExc(emp.getLevelId());
                    } catch (Exception exc){}
                    
                    Division div = new Division();
                    try{
                        div = PstDivision.fetchExc(emp.getDivisionId());
                    } catch (Exception exc){}
                    
                    String bgColor = "";
                    if((i%2)==0){
                        bgColor = "#FFF";
                    } else {
                        bgColor = "#F9F9F9";
                    }
                    
                    
                    double durasi = 0.0;
                    double paidDuration = 0.0;
                    double totIdxWD = 0.0;
                    double totIdxH = 0.0;
                    double totIdxSO = 0.0;

                    double durasiWD = 0.0;
                    double JamWDP = 0.0;
                    double JamWDK = 0.0;

                    double durasiH = 0.0;
                    double durasiEoY = 0.0;

                    double durasiSO = 0.0;
                    double jamVIIISO = 0.0;
                    double jamIXSO = 0.0;
                    double jamXSO = 0.0;

                    int overType = 0;
                    String noRek = "";
                    double allowance = 0.0;
                    double allowanceEoY = 0.0;
                    
                    String whereClause = "emp."+PstOvertimeDetail.fieldNames[PstOvertimeDetail.FLD_EMPLOYEE_ID]+ " = " + emp.getOID() + " AND odt."+PstOvertimeDetail.fieldNames[PstOvertimeDetail.FLD_DATE_FROM]+" BETWEEN "
                                        + "'" +dateFrom+" 00:00:00' AND '"+dateTo+" 23:59:00' AND odt."+PstOvertimeDetail.fieldNames[PstOvertimeDetail.FLD_STATUS]+"=4" ;
                    Vector listOvt = PstOvertimeDetail.list3(0, 0, whereClause, "");
                    String division = "-";
					
					if (oidPeriod != 0){
						String wherePaySlip = PstPaySlip.fieldNames[PstPaySlip.FLD_PERIOD_ID]+"="+oidPeriod
										+ " AND " + PstPaySlip.fieldNames[PstPaySlip.FLD_EMPLOYEE_ID]+"="+emp.getOID();
						Vector listPayslip = PstPaySlip.list(0, 0, wherePaySlip, "");
						if (listPayslip.size()>0){
							PaySlip paySlip = (PaySlip) listPayslip.get(0);
							division = paySlip.getDivision();
						}
					}
					
                    for(int j=0; j<listOvt.size(); j++){
                        OvertimeDetail empTime2 = (OvertimeDetail) listOvt.get(j);

                        durasi = empTime2.getTotDuration();

                        overType = getOvertimeType(empTime2.getDateFrom(), emp.getReligionId());
                        
                        double minHolidayDuration = 0.0;
                        try{        
                            minHolidayDuration = Double.parseDouble(PstSystemProperty.getValueByName("MIN_HOLIDAY_OVT_DURATION"));
                        } catch (Exception exc){}

                        if (overType == PstOvt_Type.HOLIDAY && durasi < minHolidayDuration){
                            overType = PstOvt_Type.SCHEDULE_OFF;
                        }

                        if(overType == PstOvt_Type.WORKING_DAY){
                            //durasiWD = durasiWD + durasi;
                            if(durasi > 1){
                                JamWDK = JamWDK + (durasi-1);
                                JamWDP = JamWDP + 1;
                            } 
                            if(durasi == 1){
                                JamWDP = JamWDP + 1;
                            }
                            //durasiWD = 0;
                        } else if(overType == PstOvt_Type.SCHEDULE_OFF){
                            //durasiSO = durasiSO + durasi;
                            if(durasi > 9){
                                jamVIIISO = jamVIIISO + 8;
                                jamIXSO = jamIXSO + 1;
                                jamXSO = jamXSO + (durasi-9);
                            } 
                            if(durasi == 9){
                                jamVIIISO = jamVIIISO + 8;
                                jamIXSO = jamIXSO + 1;
                            } 
                            if(durasi <= 8){
                                jamVIIISO = jamVIIISO + durasi;
                            }
                            //durasiSO = 0;
                        } else if(overType == PstOvt_Type.HOLIDAY){
                            durasiH = durasiH + durasi;
                            // durasiH = 0;
                        } else if(overType == PstOvt_Type.END_OF_YEAR) {
                            durasiEoY = durasiEoY + durasi;
                        }
                        
                        if (overType == PstOvt_Type.END_OF_YEAR){
                            allowanceEoY = allowanceEoY + empTime2.getTot_Idx();
                        } else {
                            allowance = allowance + empTime2.getTot_Idx();
                        }
						
						
						
                        // ini cek apa uang lemburnya lebih banyak dari gaji bruto
                        String wherePeriod = "'"+dateFrom+"' BETWEEN "+PstPayPeriod.fieldNames[PstPayPeriod.FLD_START_DATE]
                                        + " AND " +PstPayPeriod.fieldNames[PstPayPeriod.FLD_END_DATE];
                        Vector listPayPeriod = PstPayPeriod.list(0, 0, wherePeriod, "");
                        if (listPayPeriod.size()>0){
                            PayPeriod period = (PayPeriod) listPayPeriod.get(0);
                            String wherePaySlip = PstPaySlip.fieldNames[PstPaySlip.FLD_PERIOD_ID]+"="+period.getOID()
                                            + " AND " + PstPaySlip.fieldNames[PstPaySlip.FLD_EMPLOYEE_ID]+"="+emp.getOID();
                            Vector listPayslip = PstPaySlip.list(0, 0, wherePaySlip, "");
                            if (listPayslip.size()>0){
                                PaySlip paySlip = (PaySlip) listPayslip.get(0);
								//division = paySlip.getDivision();
                                String whereSlipComp = PstPaySlipComp.fieldNames[PstPaySlipComp.FLD_COMP_CODE]+"='"+brutoCompCode+"' AND "
                                                    + PstPaySlipComp.fieldNames[PstPaySlipComp.FLD_PAY_SLIP_ID]+"="+paySlip.getOID();
                                Vector listSlipComp = PstPaySlipComp.list(0, 0, whereSlipComp, "");
                                if (listSlipComp.size()>0){
                                    PaySlipComp slipComp = (PaySlipComp) listSlipComp.get(0);
                                    double maxValue = slipComp.getCompValue() * (brutoPercentage / 100);
                                    if (overType == PstOvt_Type.END_OF_YEAR){
                                        if (allowanceEoY > maxValue){
                                            allowanceEoY = maxValue;
                                        }
                                    } else {
                                        if (allowance > maxValue){
                                            allowance = maxValue;
                                        }
                                    }
                                }
                            }
                        }
                       // totIdx = getOvIdx(emp.getOID(), durasi, overType);
                    }
                        
            if (allowance != 0.0 && type==0){    
                total = total + allowance;
            %>
            <tr>
                <td style="background-color: <%=bgColor%>; text-align:center; vertical-align:middle"><%=No+1%></td>
                <td style="background-color: <%=bgColor%>; text-align:center; vertical-align:middle" ><%=emp.getEmployeeNum()%></td>
                <td style="background-color: <%=bgColor%>; text-align:center; vertical-align:middle"><%=emp.getFullName()%></td>
                <td style="background-color: <%=bgColor%>; text-align:center; vertical-align:middle"><%=lvl.getLevel()%></td>
                <td style="background-color: <%=bgColor%>; text-align:center; vertical-align:middle"><%=division%></td>
                <td style="background-color: <%=bgColor%>; text-align:center; vertical-align:middle"><%=String.valueOf(Formater.formatNumber(Math.round(JamWDP),"#,###.##"))%></td>
                <td style="background-color: <%=bgColor%>; text-align:center; vertical-align:middle"><%=String.valueOf(Formater.formatNumber(Math.round(JamWDK),"#,###.##"))%></td>
                <td style="background-color: <%=bgColor%>; text-align:center; vertical-align:middle"><%=String.valueOf(Formater.formatNumber(Math.round(jamVIIISO),"#,###.##"))%></td>
                <td style="background-color: <%=bgColor%>; text-align:center; vertical-align:middle"><%=String.valueOf(Formater.formatNumber(Math.round(jamIXSO),"#,###.##"))%></td>
                <td style="background-color: <%=bgColor%>; text-align:center; vertical-align:middle"><%=String.valueOf(Formater.formatNumber(Math.round(jamXSO),"#,###.##"))%></td>
                <td style="background-color: <%=bgColor%>; text-align:center; vertical-align:middle"><%=String.valueOf(Formater.formatNumber(Math.round(durasiH),"#,###.##"))%></td>
                <td style="background-color: <%=bgColor%>; text-align:center; vertical-align:middle"><%=emp.getNoRekening()%></td>
                <td style="background-color: <%=bgColor%>; text-align:center; vertical-align:middle"><%=Formater.formatNumber(allowance,"#,###.##")%></td>
            </tr>
            <%
                No++;
                       } else if (allowanceEoY != 0.0 && type == 1){
                           total = total + allowanceEoY;
                         %>
                        <tr>
                            <td style="background-color: <%=bgColor%>; text-align:center; vertical-align:middle"><%=No+1%></td>
                            <td style="background-color: <%=bgColor%>; text-align:center; vertical-align:middle" ><%=emp.getEmployeeNum()%></td>
                            <td style="background-color: <%=bgColor%>; text-align:center; vertical-align:middle"><%=emp.getFullName()%></td>
                            <td style="background-color: <%=bgColor%>; text-align:center; vertical-align:middle"><%=lvl.getLevel()%></td>
                            <td style="background-color: <%=bgColor%>; text-align:center; vertical-align:middle"><%=division%></td>
                            <td style="background-color: <%=bgColor%>; text-align:center; vertical-align:middle"><%=String.valueOf(Formater.formatNumber(Math.round(durasiEoY),"#,###.##"))%></td>
							<td style="background-color: <%=bgColor%>; text-align:center; vertical-align:middle"><%=emp.getNoRekening()%></td>
                            <td style="background-color: <%=bgColor%>; text-align:center; vertical-align:middle"><%=Formater.formatNumber(allowanceEoY,"#,###.##")%></td>                
                        </tr>
                        <%  
                        No++;
                       }
                }
                
                 try{
                    String ovtComp = PstSystemProperty.getValueByNameWithStringNull("OVERTIME_INJECT_COMPONENT");
                    String ovtDuration = PstSystemProperty.getValueByName("OVERTIME_INJECT_DURATION");
                    String wherePeriod ="'"+ dateTo +"' BETWEEN "+PstPayPeriod.fieldNames[PstPayPeriod.FLD_START_DATE]+" AND "+PstPayPeriod.fieldNames[PstPayPeriod.FLD_END_DATE];
                    Vector listPeriod = PstPayPeriod.list(0, 0, wherePeriod, "");
                    if (listPeriod.size() > 0){
                          PayPeriod payPeriod = (PayPeriod) listPeriod.get(0);                         
                          Vector listPaySlip = PstPaySlip.srcPaySlipByComp(payPeriod.getOID(), ovtComp);
                          if (listPaySlip.size() > 0){
                              for (int x=0; x < listPaySlip.size(); x++){
                                PaySlip paySlip = (PaySlip) listPaySlip.get(x);
                                Employee emp = new Employee();
                                try {
                                    emp = PstEmployee.fetchExc(paySlip.getEmployeeId());
                                } catch (Exception exc){

                                }

                                Level lvl = new Level();
                                  try {
                                      lvl = PstLevel.fetchExc(emp.getLevelId());
                                  } catch (Exception exc){}

                                  Division div = new Division();
                                  String division = "";
                                  try{
                                      String whereSlip = PstPaySlip.fieldNames[PstPaySlip.FLD_PERIOD_ID]+"="+oidPeriod+" AND "
                                              +PstPaySlip.fieldNames[PstPaySlip.FLD_EMPLOYEE_ID]+"="+emp.getOID();
                                      Vector listSlip = PstPaySlip.list(0, 0, whereSlip, "");
                                      if (listSlip.size()>0){
                                          PaySlip slip = (PaySlip) listSlip.get(0);
                                          division = slip.getDivision();
                                      }
                                      //div = PstDivision.fetchExc(emp.getDivisionId());
                                  } catch (Exception exc){}

                                  String bgColor = "";
                                  if((x%2)==0){
                                      bgColor = "#FFF";
                                  } else {
                                      bgColor = "#F9F9F9";
                                  }


                                Double duration = 0.0;
                                Double allowance = 0.0;                               
                                String whereDur = PstPaySlipComp.fieldNames[PstPaySlipComp.FLD_PAY_SLIP_ID]+ " = "+paySlip.getOID()+ " AND "
                                                  + PstPaySlipComp.fieldNames[PstPaySlipComp.FLD_COMP_CODE] + " = '"+ovtDuration+"'";
                                Vector listDur = PstPaySlipComp.list(0, 0, whereDur, "");
                                if (listDur.size()>0){
                                    PaySlipComp paySlipComp = (PaySlipComp) listDur.get(0);
                                    duration = duration + paySlipComp.getCompValue();
                                }  

                                String whereComp = PstPaySlipComp.fieldNames[PstPaySlipComp.FLD_PAY_SLIP_ID]+ " = "+paySlip.getOID()+ " AND "
                                                  + PstPaySlipComp.fieldNames[PstPaySlipComp.FLD_COMP_CODE] + " = '"+ovtComp+"'";
                                Vector listComp = PstPaySlipComp.list(0,0,whereComp,"");
                                if (listComp.size()>0 && type == 0){
                                    PaySlipComp paySlipComp = (PaySlipComp) listComp.get(0);
                                    allowance = allowance + paySlipComp.getCompValue();
                                    total = total + allowance;
                                    %>
                                    <tr>
                                        <td style="background-color: <%=bgColor%>; text-align:center; vertical-align:middle"><%=No+1%></td>
                                        <td style="background-color: <%=bgColor%>; text-align:center; vertical-align:middle" ><%=emp.getEmployeeNum()%></td>
                                        <td style="background-color: <%=bgColor%>; text-align:center; vertical-align:middle"><%=emp.getFullName()%></td>
                                        <td style="background-color: <%=bgColor%>; text-align:center; vertical-align:middle"><%=lvl.getLevel()%></td>
                                        <td style="background-color: <%=bgColor%>; text-align:center; vertical-align:middle"><%=division%></td>
                                        <td style="background-color: <%=bgColor%>; text-align:center; vertical-align:middle">0</td>
                                        <td style="background-color: <%=bgColor%>; text-align:center; vertical-align:middle">0</td>
                                        <td style="background-color: <%=bgColor%>; text-align:center; vertical-align:middle">0</td>
                                        <td style="background-color: <%=bgColor%>; text-align:center; vertical-align:middle">0</td>
                                        <td style="background-color: <%=bgColor%>; text-align:center; vertical-align:middle">0</td>
                                        <td style="background-color: <%=bgColor%>; text-align:center; vertical-align:middle"><%=String.valueOf(Formater.formatNumber(Math.round(duration),"#,###.##"))%></td>
                                        <td style="background-color: <%=bgColor%>; text-align:center; vertical-align:middle"><%=emp.getNoRekening()%></td>
                                        <td style="background-color: <%=bgColor%>; text-align:center; vertical-align:middle"><%=Formater.formatNumber(allowance,"#,###.##")%></td>
                                    </tr>
                                    <%
                                    No++;
                                }



                            }
                        }
                    }
                } catch (Exception exc){

                }
                
                if (No == 0){
                    removeTable = 1;
                }
            %>
            <tr>
				<%
					if (type == 0){ 
				%>
                    <td colspan="12" rowspan="1">&nbsp;</td>
				<%
					} else {
				%>
                    <td colspan="7" rowspan="1">&nbsp;</td>
				<%
					}
				%>
                    <td><%=Formater.formatNumber(total,"#,###.##")%></td>
            </tr>
        </table>
<%              
            }
         
%>
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
                
                var removeTbl = <%=removeTable%>;
                if (removeTbl === 1){
                    $("#table").remove();
                    $("h4#title").text("No Data Available");
                }
                
                
        </script>        
    </body>
</html>



<%-- 
    Document   : masa_kerja
    Created on : Feb 1, 2020, 10:55:11 AM
    Author     : IanRizky
--%>

<%@page import="com.dimata.util.DateCalc"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.dimata.gui.jsp.ControlCombo"%>
<%@ include file = "../../main/javainit.jsp" %>
<% int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_REPORTS, AppObjInfo.G2_PAYROLL_REPORT, AppObjInfo.OBJ_MEAL_ALLOWANCE_RPT); %>
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

//cek tipe browser, browser detection
    //String userAgent = request.getHeader("User-Agent");
    //boolean isMSIE = (userAgent!=null && userAgent.indexOf("MSIE") !=-1); 

%>
<%

    int iCommand = FRMQueryString.requestCommand(request);
    
    String[] arrCompany = FRMQueryString.requestStringValues(request, "companyId");
    String[] arrDivision = FRMQueryString.requestStringValues(request, "divisionId");
    String[] arrDepartment = FRMQueryString.requestStringValues(request, "departmentId");
    String[] arrSection = FRMQueryString.requestStringValues(request, "sectionId");
    String date = FRMQueryString.requestString(request, "date");
    long positionId = FRMQueryString.requestLong(request, "positionId");
    long lvlId = FRMQueryString.requestLong(request, "levelId");
	int reportType = FRMQueryString.requestInt(request, "reportType");
    
    Vector listEmployee = new Vector();
    if (iCommand == Command.LIST){
        Vector<String> whereCollectEmp = new Vector<String>();
        String whereEmployee = "";
        String inCompany = "";
        String inDivision = "";
        String inDepartment = "";
        String inSection = "";
        
        if (arrCompany != null){
            for (int i=0; i < arrCompany.length; i++){
                inCompany = inCompany + ","+ arrCompany[i];
            }
            inCompany = inCompany.substring(1);
            whereCollectEmp.add(PstEmployee.fieldNames[PstEmployee.FLD_COMPANY_ID]+" IN ("+inCompany+")");
        }
        if (arrDivision != null){
            for (int i=0; i < arrDivision.length; i++){
                inDivision = inDivision + ","+ arrDivision[i];
            }
            inDivision = inDivision.substring(1);
            whereCollectEmp.add(PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID]+" IN ("+inDivision+")");
        }
        if (arrDepartment != null){
            for (int i=0; i < arrDepartment.length; i++){
                inDepartment = inDepartment + ","+ arrDepartment[i];
            }
            inDepartment = inDepartment.substring(1);
            whereCollectEmp.add(PstEmployee.fieldNames[PstEmployee.FLD_DEPARTMENT_ID]+" IN ("+inDepartment+")");        
        }
        if (arrSection != null){
            for (int i=0; i < arrSection.length; i++){
                inSection = inSection + ","+ arrSection[i];
            }
            inSection = inSection.substring(1);
            whereCollectEmp.add(PstEmployee.fieldNames[PstEmployee.FLD_SECTION_ID]+" IN ("+inSection+")");        
        }
        
        if (positionId != 0){
            whereCollectEmp.add(PstEmployee.fieldNames[PstEmployee.FLD_POSITION_ID]+" = "+positionId);   
        }
		
		if (lvlId != 0){
			whereCollectEmp.add(PstEmployee.fieldNames[PstEmployee.FLD_LEVEL_ID]+" = "+lvlId);   
		}
        
        if (whereCollectEmp != null && whereCollectEmp.size()>0){
            for (int i=0; i<whereCollectEmp.size(); i++){
                String where = (String)whereCollectEmp.get(i);
                whereEmployee += where;
                if (i < (whereCollectEmp.size()-1)){
                     whereEmployee += " AND ";
                }
            }
        }
        
        listEmployee = PstEmployee.list(0, 0, whereEmployee, PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_NUM]);
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Riwayat Jabatan</title>
        <link rel="stylesheet" href="../../styles/main.css" type="text/css">
         <%@ include file = "../../main/konfigurasi_jquery.jsp" %>    
        <script src="../../javascripts/jquery.min-1.6.2.js" type="text/javascript"></script>
        <script src="../../javascripts/chosen.jquery.js" type="text/javascript"></script>
        <link rel="stylesheet" href="../../stylesheets/chosen.css" >
        <link rel="stylesheet" href="<%=approot%>/javascripts/datepicker/themes/jquery.ui.all.css"/>
        <link rel="stylesheet" href="<%=approot%>/javascripts/datepicker/themes/jquery.ui.timepicker.addon.css"/>

        <script src="<%=approot%>/javascripts/datepicker/jquery.ui.core.js"></script>
        <script src="<%=approot%>/javascripts/datepicker/jquery.ui.widget.js"></script>
        <script src="<%=approot%>/javascripts/datepicker/jquery.ui.datepicker.js"></script>
        <script src="<%=approot%>/javascripts/datepicker/jquery.ui.timepicker.addon.js"></script>
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
                document.frpresence.action="masa_jabatan_terakhir.jsp";
                document.frpresence.submit();
            }    
            function cmdExport(){
                    document.frpresence.command.value="<%=String.valueOf(Command.LIST)%>";
                    document.frpresence.action="export_excel/export_excel_position_history.jsp";
                    document.frpresence.submit();
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
            <span id="menu_title"><strong>Laporan</strong> <strong style="color:#333;"> / </strong> <strong>Karyawan</strong> <strong style="color:#333;"> / </strong> Riwayat Jabatan </span>
        </div>
        <div class="content-main">
            <form name="frpresence" method="post" action="">
                <input type="hidden" name="command" value="<%=iCommand%>">
                <div class="formstyle">
                    <table>
                        <tr>
                            <td valign="top" style="padding-right: 21px;">
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
                                    <%= ControlCombo.draw("companyId", "chosen-select", null, "" + arrCompany, com_value, com_key, multipleComp+" "+placeHolderComp+" style='width:100%'")%>
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
                                                dep_key.add(hashDiv.get(dep.getDivisionId()));
                                                dep_value.add(String.valueOf(-1));
                                                tempDivOid = dep.getDivisionId();
                                            }

                                            dep_key.add(dep.getDepartment());
                                            dep_value.add(String.valueOf(dep.getOID()));
                                        }
                                        inOidDepartment = inOidDepartment.substring(1);
                                    %>

                                    <%= ControlCombo.drawStringArraySelectedOptGroup("departmentId", "chosen-select", null, arrDepartment, dep_key, dep_value, null, "size=8 multiple data-placeholder='Select Unit...' style='width:100%'") %> 
                                </div>
                                <div id="caption">Tanggal Pencarian</div>
                                <div id="divinput">
                                    <input type="text" name="date" id="date" value="<%=(date.equals("") ? Formater.formatDate(new Date(), "yyyy-MM-dd") : date)%>" class="datepicker" />
                                </div>
                                <div id="caption">Jenis Report</div>
                                <div id="divinput">
                                    <input name="reportType" value="0" <%=(reportType == 0 ? "checked" : "")%> type="radio"> Posisi Terakhir
                                    <input name="reportType" value="1" <%=(reportType == 1 ? "checked" : "")%> type="radio"> Level Sama
                                    <input name="reportType" value="2" <%=(reportType == 2 ? "checked" : "")%> type="radio"> Satuan Kerja Saat Ini
                                </div>
                            </td>
                            <td valign="top">
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
                                        <%= ControlCombo.drawStringArraySelected("divisionId", "chosen-select", null, arrDivision, div_key, div_value, null, multipleDiv+" "+placeHolder+" style='width:100%'") %> 
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
                                                sec_key.add(hashDepart.get(""+sec.getDepartmentId()));
                                                sec_value.add(String.valueOf(-1));
                                                tempDepOid = sec.getDepartmentId();
                                            }

                                            sec_key.add(sec.getSection());
                                            sec_value.add(String.valueOf(sec.getOID()));
                                        }
                                    %>
                                     <%= ControlCombo.drawStringArraySelectedOptGroup("sectionId", "chosen-select", null, arrSection, sec_key, sec_value, null, "multiple data-placeholder='Select Sub Unit...' style='width:100%'") %> 
                                </div>
                                <div id="caption">Jabatan</div>
                                <div id="divinput">
                                    <%
                                        Vector pos_key = new Vector(1,1);
                                        Vector pos_val = new Vector(1,1);

                                        Vector listPosition = PstPosition.list(0, 0, "VALID_STATUS = 1", "POSITION");
                                        pos_key.add("Select..");
                                        pos_val.add(String.valueOf(0));
                                        for (int i = 0; i < listPosition.size(); i++) {
                                            Position pos = (Position) listPosition.get(i);
                                            pos_key.add(pos.getPosition());
                                            pos_val.add(String.valueOf(pos.getOID()));
                                        }
                                    %>
                                    <%= ControlCombo.draw("positionId", "chosen-select", null, ""+positionId, pos_val, pos_key) %>
                                </div>
                                <div id="caption">Level</div>
                                <div id="divinput">
                                    <%
                                        Vector level_key = new Vector(1,1);
                                        Vector level_val = new Vector(1,1);

                                        Vector listLevel = PstLevel.list(0, 0, "", "LEVEL");
                                        level_key.add("Select..");
                                        level_val.add(String.valueOf(0));
                                        for (int i = 0; i < listLevel.size(); i++) {
                                            Level lvl = (Level) listLevel.get(i);
                                            level_key.add(lvl.getLevel());
                                            level_val.add(String.valueOf(lvl.getOID()));
                                        }
                                    %>
                                    <%= ControlCombo.draw("levelId", "chosen-select", null, ""+lvlId, level_val, level_key) %>
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
            <% if (iCommand == Command.LIST) {
                    if (listEmployee.size() > 0){
						switch(reportType){
							case 0:
							%>
							<table class="tblStyle" width="100%">
								<tr>
									<td class="title_tbl" style="text-align:center; vertical-align:middle">No</td>
									<td class="title_tbl" style="text-align:center; vertical-align:middle">NRK</td>
									<td class="title_tbl" style="text-align:center; vertical-align:middle">Nama</td>
									<td class="title_tbl" style="text-align:center; vertical-align:middle">Satuan Kerja</td>
									<td class="title_tbl" style="text-align:center; vertical-align:middle">Jabatan</td>
									<td class="title_tbl" style="text-align:center; vertical-align:middle">Level</td>
									<td class="title_tbl" style="text-align:center; vertical-align:middle">Mulai Menjabat</td>
									<td class="title_tbl" style="text-align:center; vertical-align:middle">Lama Menjabat (Bulan)</td>
								</tr>
							<%
							for (int i=0; i<listEmployee.size();i++){
								Employee emp = (Employee) listEmployee.get(i);
								String bgColor = "";
								if((i%2)==0){
									bgColor = "#FFF";
								} else {
									bgColor = "#F9F9F9";
								}

								String startMenjabat = PstCareerPath.getLastWorkFrom(emp.getOID());
								if (startMenjabat == null || startMenjabat.equals("")){
									startMenjabat = ""+emp.getCommencingDate();
								}
								SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
								Date dtStart = sdf.parse(startMenjabat);
								Date dtSearch = sdf.parse(date);

								int month = DateCalc.monthDifference(dtStart, dtSearch);

								%>
									<tr>
										<td style="background-color: <%=bgColor%>;"><%=""+ (i+1)%></td>
										<td style="background-color: <%=bgColor%>;"><%=emp.getEmployeeNum()%></td>
										<td style="background-color: <%=bgColor%>;"><%=emp.getFullName()%></td>
										<td style="background-color: <%=bgColor%>;"><%=PstEmployee.getDivisionName(emp.getDivisionId())%></td>
										<td style="background-color: <%=bgColor%>;"><%=PstEmployee.getPositionName(emp.getPositionId())%></td>
										<td style="background-color: <%=bgColor%>;"><%=PstEmployee.getLevelName(emp.getLevelId())%></td>
										<td style="background-color: <%=bgColor%>;"><%=startMenjabat%></td>
										<td style="background-color: <%=bgColor%>;"><%=month%></td>
									</tr>
								<%
							}
							%>
							</table>
							<%
							break;
							case 1:
							%>
							<table class="tblStyle" width="100%">
								<tr>
									<td class="title_tbl" style="text-align:center; vertical-align:middle">No</td>
									<td class="title_tbl" style="text-align:center; vertical-align:middle">NRK</td>
									<td class="title_tbl" style="text-align:center; vertical-align:middle">Nama</td>
									<td class="title_tbl" style="text-align:center; vertical-align:middle">Satuan Kerja</td>
									<td class="title_tbl" style="text-align:center; vertical-align:middle">Jabatan</td>
									<td class="title_tbl" style="text-align:center; vertical-align:middle">Level</td>
									<td class="title_tbl" style="text-align:center; vertical-align:middle">Mulai Menjabat</td>
									<td class="title_tbl" style="text-align:center; vertical-align:middle">Lama Pada Level Sama (Bulan)</td>
								</tr>
							<%
							for (int i=0; i<listEmployee.size();i++){
								Employee emp = (Employee) listEmployee.get(i);
								String bgColor = "";
								if((i%2)==0){
									bgColor = "#FFF";
								} else {
									bgColor = "#F9F9F9";
								}

								String startMenjabat = PstCareerPath.getLastWorkFrom(emp.getOID());
								if (startMenjabat == null || startMenjabat.equals("")){
									startMenjabat = ""+emp.getCommencingDate();
								}
								SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
								Date dtStart = sdf.parse(startMenjabat);
								Date dtSearch = sdf.parse(date);

								int month = DateCalc.monthDifference(dtStart, dtSearch);
								
								Vector vectLvl = new Vector();
								vectLvl = PstCareerPath.getLevelSama(emp.getOID(), emp.getLevelId());
								for (int x=0; x < vectLvl.size();x++){
									CareerPath careerPath = (CareerPath) vectLvl.get(x);
									month = month + DateCalc.monthDifference(careerPath.getWorkFrom(), careerPath.getWorkTo());
								}

								%>
									<tr>
										<td style="background-color: <%=bgColor%>;"><%=""+ (i+1)%></td>
										<td style="background-color: <%=bgColor%>;"><%=emp.getEmployeeNum()%></td>
										<td style="background-color: <%=bgColor%>;"><%=emp.getFullName()%></td>
										<td style="background-color: <%=bgColor%>;"><%=PstEmployee.getDivisionName(emp.getDivisionId())%></td>
										<td style="background-color: <%=bgColor%>;"><%=PstEmployee.getPositionName(emp.getPositionId())%></td>
										<td style="background-color: <%=bgColor%>;"><%=PstEmployee.getLevelName(emp.getLevelId())%></td>
										<td style="background-color: <%=bgColor%>;"><%=startMenjabat%></td>
										<td style="background-color: <%=bgColor%>;"><%=month%></td>
									</tr>
								<%
							}
							%>
							</table>
							<%
							break;
							case 2:
							%>
							<table class="tblStyle" width="100%">
								<tr>
									<td class="title_tbl" style="text-align:center; vertical-align:middle">No</td>
									<td class="title_tbl" style="text-align:center; vertical-align:middle">NRK</td>
									<td class="title_tbl" style="text-align:center; vertical-align:middle">Nama</td>
									<td class="title_tbl" style="text-align:center; vertical-align:middle">Satuan Kerja</td>
									<td class="title_tbl" style="text-align:center; vertical-align:middle">Jabatan</td>
									<td class="title_tbl" style="text-align:center; vertical-align:middle">Level</td>
									<td class="title_tbl" style="text-align:center; vertical-align:middle">Mulai Menjabat</td>
									<td class="title_tbl" style="text-align:center; vertical-align:middle">Satuan Kerja Saat Ini (Bulan)</td>
								</tr>
							<%
							for (int i=0; i<listEmployee.size();i++){
								Employee emp = (Employee) listEmployee.get(i);
								String bgColor = "";
								if((i%2)==0){
									bgColor = "#FFF";
								} else {
									bgColor = "#F9F9F9";
								}

								String startMenjabat = PstCareerPath.getLastWorkFrom(emp.getOID());
								if (startMenjabat == null || startMenjabat.equals("")){
									startMenjabat = ""+emp.getCommencingDate();
								}
								SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
								Date dtStart = sdf.parse(startMenjabat);
								Date dtSearch = sdf.parse(date);

								int month = DateCalc.monthDifference(dtStart, dtSearch);
								
								Vector vectLvl = new Vector();
								vectLvl = PstCareerPath.getDivisiSama(emp.getOID(), emp.getDivisionId());
								for (int x=0; x < vectLvl.size();x++){
									CareerPath careerPath = (CareerPath) vectLvl.get(x);
									month = month + DateCalc.monthDifference(careerPath.getWorkFrom(), careerPath.getWorkTo());
									startMenjabat = ""+careerPath.getWorkFrom();
								}

								%>
									<tr>
										<td style="background-color: <%=bgColor%>;"><%=""+ (i+1)%></td>
										<td style="background-color: <%=bgColor%>;"><%=emp.getEmployeeNum()%></td>
										<td style="background-color: <%=bgColor%>;"><%=emp.getFullName()%></td>
										<td style="background-color: <%=bgColor%>;"><%=PstEmployee.getDivisionName(emp.getDivisionId())%></td>
										<td style="background-color: <%=bgColor%>;"><%=PstEmployee.getPositionName(emp.getPositionId())%></td>
										<td style="background-color: <%=bgColor%>;"><%=PstEmployee.getLevelName(emp.getLevelId())%></td>
										<td style="background-color: <%=bgColor%>;"><%=startMenjabat%></td>
										<td style="background-color: <%=bgColor%>;"><%=month%></td>
									</tr>
								<%
							}
							%>
							</table>
							<%
							break;
						}
                    }
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
                $( ".datepicker" ).datepicker({ dateFormat: "yy-mm-dd" });
        </script>        
    </body>
</html>

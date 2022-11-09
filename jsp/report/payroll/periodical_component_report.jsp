<%-- 
    Document   : periodical_component_report
    Created on : 04-Oct-2017, 13:32:29
    Author     : Gunadi
--%>

<%@page import="com.dimata.harisma.session.payroll.TaxCalculator"%>
<%@page import="com.dimata.harisma.session.payroll.SessPeriodicalComp"%>
<%@page import="com.dimata.harisma.entity.payroll.PayComponent"%>
<%@page import="com.dimata.harisma.entity.payroll.PstPayComponent"%>
<%@page import="com.dimata.gui.jsp.ControlCombo"%>
<%@page import="com.dimata.harisma.entity.payroll.PayPeriod"%>
<%@page import="com.dimata.harisma.entity.payroll.PstPayPeriod"%>
<%@page import="com.dimata.harisma.form.search.FrmSrcPeriodicalComp"%>
<%@page import="com.dimata.harisma.entity.search.SrcPeriodicalComp"%>
<%@ include file = "../../main/javainit.jsp" %>
<% int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_REPORTS, AppObjInfo.G2_PAYROLL_REPORT, AppObjInfo.OBJ_PERIODICAL_COMP_REPORT); %>
<%@ include file = "../../main/checkuser.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
    /* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
    //boolean privPrint = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_PRINT));

    long hrdDepOid = Long.parseLong(String.valueOf(PstSystemProperty.getPropertyLongbyName(OID_HRD_DEPARTMENT)));
    boolean isHRDLogin = true;

    long edpSectionOid = Long.parseLong(String.valueOf(PstSystemProperty.getPropertyLongbyName(OID_EDP_SECTION)));
    boolean isEdpLogin = edpSectionOid == sectionOfLoginUser.getOID() ? true : false;
    boolean isGeneralManager = positionType == PstPosition.LEVEL_GENERAL_MANAGER ? true : false;

    SessUserSession userSessionn = (SessUserSession) session.getValue(SessUserSession.HTTP_SESSION_NAME);
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
    Vector listEmployee= new Vector();
    int vectSize = 0;
    SrcPeriodicalComp objSrcPeriodicalComp = new SrcPeriodicalComp();
    FrmSrcPeriodicalComp objFrmSrcPeriodicalComp = new FrmSrcPeriodicalComp();
    SessPeriodicalComp sessPeriodicalComp = new SessPeriodicalComp();
    int a1 = FRMQueryString.requestInt(request, "a1");
    
    if (iCommand == Command.LIST){
        objFrmSrcPeriodicalComp = new FrmSrcPeriodicalComp(request, objSrcPeriodicalComp);
        objFrmSrcPeriodicalComp.requestEntityObject(objSrcPeriodicalComp);
        listEmployee = sessPeriodicalComp.listEmployee(objSrcPeriodicalComp, 0, 0);
        //vectSize = sessLeaveApplication.searchCountLeaveApplication(objSrcLeaveApp, 0, 0);
    }
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Periodical Component Report</title>
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
                
//                var e = document.getElementById("periodId");
//                var period = e.options[e.selectedIndex].value;
//                if (period == 0){
//                    alert("Pilih Periode!")
//                } else {
//                    document.frpresence.command.value="<%=String.valueOf(Command.LIST)%>";
//                    document.frpresence.action="meal_allowance_report.jsp";
//                    document.frpresence.submit();
//                }

                    document.frpresence.command.value="<%=String.valueOf(Command.LIST)%>";
                    document.frpresence.action="periodical_component_report.jsp";
                    document.frpresence.submit();
        }    
        function cmdExport(){
                document.frpresence.command.value="<%=String.valueOf(Command.LIST)%>";
                document.frpresence.action="export_excel/periodical_component_report_xls.jsp";
                document.frpresence.submit();
        }    
        function showMe (box) {

        var chboxs = document.getElementsByName("a1");
        var vis = "hidden";
        for(var i=0;i<chboxs.length;i++) { 
            if(chboxs[i].checked){
             vis = "visible";
                break;
            }
        }
        document.getElementById(box).style.visibility = vis;


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
            <span id="menu_title"><strong>Laporan</strong> <strong style="color:#333;"> / </strong> <strong>Penggajian</strong> <strong style="color:#333;"> / </strong> Periodical Component Report </span>
        </div>
        <div class="content-main">
            <form name="frpresence" method="post" action="">
                <input type="hidden" name="command" value="<%=iCommand%>">
                <div class="formstyle">
                    <table>
                        <tr>
                            <td valign="top" style="padding-right: 21px;">
                                <div id="caption">NRK</div>
                                <div id="divinput">
                                    <input type="text" name="<%=objFrmSrcPeriodicalComp.fieldNames[objFrmSrcPeriodicalComp.FRM_FIELD_EMP_NUMBER]%>" id="emp_number" value="<%= objSrcPeriodicalComp.getEmpNum()%>" />
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
                                    <%= ControlCombo.drawStringArraySelected(objFrmSrcPeriodicalComp.fieldNames[objFrmSrcPeriodicalComp.FRM_FIELD_ARR_COMPANY], "chosen-select", null, objSrcPeriodicalComp.getArrCompany(0), com_key, com_value, null, "size=8 multiple data-placeholder='Select Company...' style='width:100%'") %>
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

                                    <%= ControlCombo.drawStringArraySelected(objFrmSrcPeriodicalComp.fieldNames[objFrmSrcPeriodicalComp.FRM_FIELD_ARR_DEPARTMENT], "chosen-select", null, objSrcPeriodicalComp.getArrDepartment(0), dep_key, dep_value, null, "size=8 multiple data-placeholder='Select Unit...' style='width:100%'") %> 
                                </div>
                                <div id="caption">Jabatan</div>
                                <div id="divinput">
                                    <%

                                        Vector pos_value = new Vector(1, 1);
                                        Vector pos_key = new Vector(1, 1);
                                        
                                        Vector listPos = PstPosition.list(0, 0, "", "");
                                        for (int i = 0; i < listPos.size(); i++) {
                                            Position position = (Position) listPos.get(i);
                                            pos_key.add(position.getPosition());
                                            pos_value.add(String.valueOf(position.getOID()));
                                        }
                                    %>
                                    <%= ControlCombo.drawStringArraySelected(objFrmSrcPeriodicalComp.fieldNames[objFrmSrcPeriodicalComp.FRM_FIELD_ARR_POSITION], "chosen-select", null, objSrcPeriodicalComp.getArrPosition(0), com_key, com_value, null, "size=8 multiple data-placeholder='Select Position...' style='width:100%'") %>
                                </div>
                                <div id="caption">Periode</div>
                                <div id="divinput">
                                    <select name="<%=objFrmSrcPeriodicalComp.fieldNames[objFrmSrcPeriodicalComp.FRM_FIELD_PERIOD_FROM]%>" id="periodId" class="chosen-select" data-placeholder="Periode From...">
                                        <option value="0">Select Periode...</option>
                                        <%
                                        Vector listPeriodFrom = PstPayPeriod.list(0, 0, "", "START_DATE DESC");
                                        for (int r = 0; r < listPeriodFrom.size(); r++) {
                                            PayPeriod payPeriod = (PayPeriod) listPeriodFrom.get(r);
                                            if (objSrcPeriodicalComp.getPeriodFrom() == payPeriod.getOID()){
                                                %><option value="<%= String.valueOf(payPeriod.getOID()) %>" selected><%= payPeriod.getPeriod() %></option><%
                                            } else {
                                                %><option value="<%= String.valueOf(payPeriod.getOID()) %>"><%= payPeriod.getPeriod() %></option><%
                                            }
                                        }
                                        %>
                                    </select>
                                    <strong>To</strong>
                                    <select name="<%=objFrmSrcPeriodicalComp.fieldNames[objFrmSrcPeriodicalComp.FRM_FIELD_PERIOD_TO]%>" id="periodId" class="chosen-select" data-placeholder="Periode To...">
                                        <option value="0">Select Periode...</option>
                                        <%
                                        Vector listPeriodTo = PstPayPeriod.list(0, 0, "", "START_DATE DESC");
                                        for (int r = 0; r < listPeriodTo.size(); r++) {
                                            PayPeriod payPeriod = (PayPeriod) listPeriodTo.get(r);
                                            if (objSrcPeriodicalComp.getPeriodTo() == payPeriod.getOID()){
                                                %><option value="<%= String.valueOf(payPeriod.getOID()) %>" selected><%= payPeriod.getPeriod() %></option><%
                                            } else {
                                                %><option value="<%= String.valueOf(payPeriod.getOID()) %>"><%= payPeriod.getPeriod() %></option><%
                                            }
                                        }
                                        %>
                                    </select>                                    
                                </div>
                                <div id="divinput">
                                    <% 
                                    String checkA1 = "";
                                    String checkResign = "";
                                    String visible = "hidden";
                                    if (a1 == 1){
                                        checkA1 = "checked";
                                        visible = "visible";
                                    }
                                        
                                    if(objSrcPeriodicalComp.getStatusResign() == 1){
                                        checkResign = "checked";
                                    }
                                    %>
                                    <input type="checkbox" name="a1" value="1" <%=checkA1%> onclick="showMe('hidden')">Compare With Other Component
                                    <input type="checkbox" name="<%=objFrmSrcPeriodicalComp.fieldNames[objFrmSrcPeriodicalComp.FRM_FIELD_RESIGN_STATUS]%>" value="1" <%=checkResign%> >Status Resign
                                </div>    
                            </td>
                            <td valign="top">
                                <div id="caption">Nama Karyawan</div>
                                <div id="divinput">
                                    <input type="text" name="<%=objFrmSrcPeriodicalComp.fieldNames[objFrmSrcPeriodicalComp.FRM_FIELD_FULLNAME]%>" id="full_name" value="<%=objSrcPeriodicalComp.getFullName()%>" />                                
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
                                        <%= ControlCombo.drawStringArraySelected(objFrmSrcPeriodicalComp.fieldNames[objFrmSrcPeriodicalComp.FRM_FIELD_ARR_DIVISION], "chosen-select", null, objSrcPeriodicalComp.getArrDivision(0), div_key, div_value, null, multipleDiv+" "+placeHolder+" style='width:100%'") %> 
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
                                     <%= ControlCombo.drawStringArraySelected(objFrmSrcPeriodicalComp.fieldNames[objFrmSrcPeriodicalComp.FRM_FIELD_ARR_SECTION], "chosen-select", null, objSrcPeriodicalComp.getArrSection(0), sec_key, sec_value, null, "multiple data-placeholder='Select Sub Unit...' style='width:100%'") %> 
                                </div>
                                <div id="caption">Komponen</div>
                                <div id="divinput">
                                    <%
                                        Vector comp_value = new Vector(1, 1);
                                        Vector comp_key = new Vector(1, 1);
                                        
                                        Vector listBenefit = PstPayComponent.list(0, 0, PstPayComponent.fieldNames[PstPayComponent.FLD_COMP_TYPE]+"=1", "");
                                        Vector listDeduction = PstPayComponent.list(0, 0, PstPayComponent.fieldNames[PstPayComponent.FLD_COMP_TYPE]+"=2", "");                                        
                                        if (listBenefit.size()>0){
                                            comp_key.add("--Benefit--");
                                            comp_value.add(String.valueOf(-1));
                                            for (int i = 0; i < listBenefit.size(); i++) {
                                                PayComponent payComp = (PayComponent) listBenefit.get(i);
                                                comp_key.add(payComp.getCompName());
                                                comp_value.add(String.valueOf(payComp.getOID()));
                                            }
                                        }
                                        
                                        if (listDeduction.size()>0){
                                            comp_key.add("--Deduction--");
                                            comp_value.add(String.valueOf(-1));
                                            for (int i = 0; i < listDeduction.size(); i++) {
                                                PayComponent payComp = (PayComponent) listDeduction.get(i);
                                                comp_key.add(payComp.getCompName());
                                                comp_value.add(String.valueOf(payComp.getOID()));
                                            }
                                        }
                                        
                                    %>
                                    <%= ControlCombo.drawStringArraySelected(objFrmSrcPeriodicalComp.fieldNames[objFrmSrcPeriodicalComp.FRM_FIELD_ARR_COMPONENT], "chosen-select", null, objSrcPeriodicalComp.getArrComponent(0), comp_key, comp_value, null, "multiple data-placeholder='Select Componen...' style='width:100%'") %>
                                </div>
                                <div id="hidden" style="visibility: <%=visible%>">
                                    <div id="caption">Compare With</div>
                                    <div id="divinput">
                                        <%= ControlCombo.draw(objFrmSrcPeriodicalComp.fieldNames[objFrmSrcPeriodicalComp.FRM_FIELD_COMPARE_COMP_ID], "chosen-select", null, "" + objSrcPeriodicalComp.getCompareCompId(), comp_value, comp_key, "data-placeholder='Select Component...' style='width:100%'")%>
                                    </div>
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
                <% 
                    if (listEmployee.size() > 0 && listEmployee != null){
                        Vector listPeriod = PstPayPeriod.getPayPeriodBySelectedPeriodV(objSrcPeriodicalComp.getPeriodFrom(), objSrcPeriodicalComp.getPeriodTo());
                        
                        String compCode = "";
                        String compName = "";
                        
                        if (objSrcPeriodicalComp.getArrComponent(0)!=null){
                            String[] componentId = objSrcPeriodicalComp.getArrComponent(0);
                            if (! (componentId!=null && (componentId[0].equals("0")))) {
                                for (int i=0; i < componentId.length; i++){
                                    PayComponent payComp = new PayComponent();
                                    try {
                                        payComp = PstPayComponent.fetchExc(Long.valueOf(componentId[i]));
                                    } catch (Exception exc){
                                        System.out.println(exc.toString());
                                    }
                                    compCode = compCode + "," + payComp.getCompCode();
                                    compName = compName + "," + payComp.getCompName();
                                }
                                compCode = compCode.substring(1);
                                compName = compName.substring(1);
                            }
                        }
                        
                        
                        double[] totalValue = new double[listPeriod.size()];
                        double totalJumlah = 0;
                        double totalCompare = 0;
                        double totalSelish = 0;
                %>
                <table border="0">
                    <tr>
                        <td colspan="2"><strong style="font-size: 18px;">REKAP PENGHASILAN</strong></td>
                    </tr>
                    <tr>
                        <td colspan="2"><strong style="font-size: 18px;">KOMPONEN "<%=compCode%>" <%=compName%></strong></td>                        
                    </tr>  
                </table>
                <table class="tblStyle">
                    <tr>
                        <td rowspan="2" class="title_tbl">NRK</td>
                        <td rowspan="2" class="title_tbl">Nama</td>
                        <td colspan="<%=listPeriod.size()%>" class="title_tbl" style="text-align: center">PERIODE</td>
                        <td rowspan="2" class="title_tbl">JUMLAH</td>
                        <%
                            if (a1==1){
                        %>
                            <td rowspan="2" class="title_tbl">KOMPARASI</td>
                            <td rowspan="2" class="title_tbl">SELISIH</td>
                        <%
                            }
                        %>
                    </tr>
                    <tr>
                        <%
                            for (int p=0;p<listPeriod.size();p++){
                                Long periodId = (Long) listPeriod.get(p);
                                PayPeriod payPeriod = new PayPeriod();
                                try {
                                    payPeriod = PstPayPeriod.fetchExc(periodId);
                                } catch (Exception exc){
                                    exc.printStackTrace();
                                }
                        %>
                            <td class="title_tbl"><%=payPeriod.getPeriod()%></td>
                        <%
                            }
                        %>
                    </tr>
                    <%
                        for (int i=0; i<listEmployee.size();i++){
                            Employee emp = (Employee) listEmployee.get(i);
                    %>
                    <tr>
                        <td style="background-color: #FFF;"><%=emp.getEmployeeNum()%></td>
                        <td style="background-color: #FFF;"><%=emp.getFullName()%></td>
                        <%
                            double total =0;
                            for (int p=0;p<listPeriod.size();p++){
                                Long periodId = (Long) listPeriod.get(p);
                                PayPeriod payPeriod = new PayPeriod();
                                try {
                                    payPeriod = PstPayPeriod.fetchExc(periodId);
                                } catch (Exception exc){
                                    exc.printStackTrace();
                                }
                                
                                double value= sessPeriodicalComp.getValue(objSrcPeriodicalComp,periodId,emp.getOID() );
                                total = total+value;
                                totalValue[p]=totalValue[p]+value;
                                
                        %>
                            <td style="background-color: #FFF;"><%=Formater.formatNumber(value, "")%></td>
                        <%
                            } totalJumlah = totalJumlah + total;
                        %>
                            <td style="background-color: #FFF;"><%=Formater.formatNumber(total, "")%></td>
                        <%
                            if (a1==1){
                                double lastValue = 0;
                                for (int p=0;p<listPeriod.size();p++){
                                    Long periodId = (Long) listPeriod.get(p);
                                    double value = sessPeriodicalComp.getValueCompare(objSrcPeriodicalComp,periodId,emp.getOID());
                                    if (value != 0){
                                        lastValue = value;
                                    }
                                }
                                totalCompare=totalCompare+lastValue;
                                totalSelish=totalSelish+(total-lastValue);
                                    %>
                                        <td style="background-color: #FFF;"><%=Formater.formatNumber(lastValue, "")%></td>
                                        <td style="background-color: #FFF;"><%=Formater.formatNumber((total-lastValue), "")%></td>
                                    <%
                            }
                        %>
                    </tr>
                    <%
                        }
                    %>
                    <tr>
                        <td colspan="2" style="background-color: #FFF; text-align: center;" >Jumlah</td>
                        <%
                            for (int p=0;p<listPeriod.size();p++){
                        %>
                            <td style="background-color: #FFF;" ><%=Formater.formatNumber(totalValue[p], "")%></td>
                        <%
                            } 
                        %>
                            <td style="background-color: #FFF;" ><%=Formater.formatNumber(totalJumlah, "")%></td>
                        <%
                        if (a1==1){
                               %>
                                    <td style="background-color: #FFF;"><%=Formater.formatNumber(totalCompare, "")%></td>
                                    <td style="background-color: #FFF;"><%=Formater.formatNumber(totalSelish, "")%></td>
                                <% 
                            }
                        %>
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
        </script>        
    </body>
</html>

<%-- 
    Document   : gap_competency
    Created on : Jun 29, 2021, 9:49:18 PM
    Author     : gndiw
--%>

<%@page import="com.dimata.harisma.session.employee.SessRptCompetency"%>
<%@page import="com.dimata.harisma.session.employee.SessEmployee"%>
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
<% int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_MENU_COMPETENCY, AppObjInfo.G2_MENU_LAPORAN_KOMPETENSI, AppObjInfo.OBJ_MENU_RPT_GAP_COMPETENCY);%>
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
    long oidCompetency = 0;
    long oidDivision = 0;
    String strDisable = "";
    String strDisableNum = "";
    if (appUserSess.getAdminStatus()==0 && !privViewAllDivision){
        oidDivision = emplx.getDivisionId();
        strDisable = "disabled=\"disabled\"";
    } if (namaUser1.equals("Employee")){
        strDisableNum = "disabled=\"disabled\"";
    }
    

%>
<%
    int iCommand = FRMQueryString.requestCommand(request);
    String empNum = FRMQueryString.requestString(request, "emp_num");
    String empName = FRMQueryString.requestString(request, "emp_name");
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

    if (empNum.length()>0){
        whereClauseEmp = "EMP."+PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_NUM]+"= '"+empNum+"'";
        whereCollect.add(whereClauseEmp);
    }
    
    if (empName.length()>0){
        whereClauseEmp = "EMP."+PstEmployee.fieldNames[PstEmployee.FLD_FULL_NAME]+" LIKE '%"+empName+"%'";
        whereCollect.add(whereClauseEmp);
    }
    
    if (companyId != 0){
        whereClauseEmp = "EMP."+PstEmployee.fieldNames[PstEmployee.FLD_COMPANY_ID]+"="+companyId;
        whereCollect.add(whereClauseEmp);
    }

    if (oidDiv != null){
        String inDiv = "";
        for (int i=0; i < oidDiv.length; i++){
            inDiv = inDiv + ","+ oidDiv[i];
        }
        inDiv = inDiv.substring(1);
        whereClauseEmp = "EMP."+PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID]+" IN("+inDiv+")";
        whereCollect.add(whereClauseEmp);
    }
    if (oidDept != null){
        String inDept = "";
        for (int i=0; i < oidDept.length; i++){
            inDept = inDept + ","+ oidDept[i];
        }
        inDept = inDept.substring(1);
        whereClauseEmp = "EMP."+PstEmployee.fieldNames[PstEmployee.FLD_DEPARTMENT_ID]+" IN ("+inDept+")";
        whereCollect.add(whereClauseEmp);
    }
    if (oidSec != null){
        String inSec = "";
        for (int i=0; i < oidSec.length; i++){
            inSec = inSec + ","+ oidSec[i];
        }
        inSec = inSec.substring(1);
        whereClauseEmp = "EMP."+PstEmployee.fieldNames[PstEmployee.FLD_SECTION_ID]+" IN ("+inSec+")";
        whereCollect.add(whereClauseEmp);
    }
    
    if (positionId != null){
        String inPos = "";
        for (int i=0; i < positionId.length; i++){
            inPos = inPos + ","+ positionId[i];
        }
        inPos = inPos.substring(1);
        whereClauseEmp = "EMP."+PstEmployee.fieldNames[PstEmployee.FLD_POSITION_ID]+" IN ("+inPos+")";
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
    
    listEmployee = SessEmployee.employeeGapReport(whereClauseEmp);
    SessRptCompetency sessRptCompetency = new SessRptCompetency();
    
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Laporan Gap Kompetensi</title>
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
                    document.frm.target="";
                    document.frm.action="gap_competency.jsp";
                    document.frm.submit();
        }    
        function cmdExport(){
                document.frpresence.command.value="<%=String.valueOf(Command.LIST)%>";
                document.frpresence.action="export_excel/overtime_report.jsp";
                document.frpresence.submit();
        }    
        function cmdDetail(oid){
		document.frm.employee_id.value=oid;
		document.frm.action="gap_competency_detail.jsp";
                document.frm.target="_blank";
		document.frm.submit();
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
            <span id="menu_title">Laporan Kompetensi <strong style="color:#333;"> / </strong> Gap Kompetensi <strong style="color:#333;"> / </strong>Pencarian</span>
        </div>
        <div class="content-main">
            <form name="frm" method="post" action="">
                <input type="hidden" name="command" value="<%=iCommand%>">
                <input type="hidden" name="start" value="">
                <input type="hidden" name="employee_id" value="">
                <div class="box">
                    <div id="title-box">Pencarian Gap Kompetensi</div>
                    <table width="100%">
                        <tr>
                            <td valign="top" width="33%">
                                <div class="caption">
                                    NRK
                                </div>
                                <div id="divinput">
                                    <input type="text" id="emp_num" name="emp_num" size="50" value="<%=empNum%>"/>
                                </div>
                                <div class="caption">
                                    Nama Karyawan
                                </div>
                                <div id="divinput">
                                    <input type="text" id="emp_name" name="emp_name" size="50" value="<%=empName%>"/>
                                </div>
                            </td>
                            <td valign="top" width="33%">
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
                            </td>
                            <td valign="top" width="33%">
                                <div class="caption">
                                    <%=dictionaryD.getWord(I_Dictionary.DEPARTMENT)%>
                                </div>
                                <div id="divinput">
                                    <%

                                        Vector dep_value = new Vector(1, 1);
                                        Vector dep_key = new Vector(1, 1);
                                        
                                        Vector listDep  = new Vector();
                      //                  if (oidDivision == 0){
                                            listDep = PstDepartment.list(0, 0, "hr_department.VALID_STATUS=1", "");
                       //                 } 
                      //                  else {
                      //                      listDep = PstDepartment.list(0, 0, "j."+PstDepartment.fieldNames[PstDepartment.FLD_DIVISION_ID] + " = " + emplx.getDivisionId()  + " AND j.VALID_STATUS=1", "j."+PstDepartment.fieldNames[PstDepartment.FLD_DIVISION_ID]);
                      //                  }

                                        for (int i = 0; i < listDep.size(); i++) {
                                            Department dep = (Department) listDep.get(i);
                                            dep_key.add(dep.getDepartment());
                                            dep_value.add(String.valueOf(dep.getOID()));
                                        }
                                    %>
                                        <%= ControlCombo.drawStringArraySelected("department_id", "chosen-select", null, oidDept, dep_key, dep_value, null, "multiple data-placeholder='Select Unit Kerja...' style='width:80%' id='division'") %> 
                                </div>
                                <div class="caption">
                                    <%=dictionaryD.getWord(I_Dictionary.SECTION)%>
                                </div>
                                <div id="divinput">
                                <%

                                    Vector sec_value = new Vector(1, 1);
                                    Vector sec_key = new Vector(1, 1);


                                    Vector listSec = new Vector();

                      //              if (oidDivision == 0){
                                        listSec = PstSection.list(0, 0, "VALID_STATUS=1", "DEPARTMENT_ID");
                      //             } else {
                      //                  listSec = PstSection.list(0, 0, PstSection.fieldNames[PstSection.FLD_DEPARTMENT_ID] + " = " + emplx.getDepartmentId(), "DEPARTMENT_ID");
                      //              }

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
                                <%= ControlCombo.drawStringArraySelected("section_id", "chosen-select", null, oidSec, sec_key, sec_value, null, "multiple data-placeholder='Select Sub Unit...' style='width:50%' id='position'") %> 
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
                            <table class="tblStyle" style="width: 100%">
                                <tr>
                                    <td class="title_tbl">NO</td>
                                    <td class="title_tbl">NRK</td>
                                    <td class="title_tbl">Nama Karyawan</td>
                                    <td class="title_tbl">Level</td>
                                    <td class="title_tbl">Jabatan</td>
                                    <td class="title_tbl">Mulai Jabatan</td>
                                    <td class="title_tbl">Satuan Kerja</td>
                                    <td class="title_tbl">Unit Kerja</td>
                                    <td class="title_tbl">Sub Unit</td>
                                    <td class="title_tbl">Gap Kompetensi (Telah Dinilai)</td>
                                    <td class="title_tbl">Pencapaian Kompetensi (Telah Dinilai)</td>
                                    <td class="title_tbl">Gap Kompetensi (Belum Dinilai)</td>
                                    <td class="title_tbl">Pencapaian Kompetensi (Belum Dinilai)</td>
                                </tr>
                            <%
                            int jum = 0;
                            for(int i=0; i<listEmployee.size(); i++){
                                Vector temp = (Vector) listEmployee.get(i);
                                Employee emp = (Employee) temp.get(0);
                                Division div = (Division) temp.get(1);
                                Department dep = (Department) temp.get(2);
                                Position pos = (Position) temp.get(3);
                                Section sec = (Section) temp.get(4);
                                CareerPath his = (CareerPath) temp.get(5);
                                
                                String level = "-";
                                try {
                                    level = PstLevel.fetchExc(emp.getLevelId()).getLevel();
                                } catch (Exception exc){}
                                
                                %>
                                <tr>
                                    <td><%= (i+1) %></td>
                                    <td><a href="javascript:cmdDetail('<%=emp.getOID()%>')"><%= emp.getEmployeeNum() %></a></td>
                                    <td><%= emp.getFullName() %></td>
                                    <td><%= level %></td>
                                    <td><%= pos.getPosition() %></td>
                                    <td><%= his.getWorkFrom() %></td>
                                    <td><%= div.getDivision() %></td>
                                    <td><%= dep.getDepartment()%></td>
                                    <td><%= sec.getSection().length() > 0 ? sec.getSection() : "-" %></td>
                                    <td><%= SessRptCompetency.getTotalGapGroupAll(emp.getOID(), emp.getPositionId(), emp.getLevelId(), div.getLevelDivision(), dep.getLevelDepartment(), sec.getLevelSection(), 0) %></td>
                                    <td><%= (int) SessRptCompetency.getPencapaianKompetensi(emp.getOID(), emp.getPositionId(), emp.getLevelId(), div.getLevelDivision(), dep.getLevelDepartment(), sec.getLevelSection()) %>%</td>
                                    <td><%= SessRptCompetency.getTotalGapGroupAll(emp.getOID(), emp.getPositionId(), emp.getLevelId(), div.getLevelDivision(), dep.getLevelDepartment(), sec.getLevelSection(), 1) %></td>
                                    <td><%= (int) SessRptCompetency.getPencapaianKompetensiBelumDinilai(emp.getOID(), emp.getPositionId(), emp.getLevelId(), div.getLevelDivision(), dep.getLevelDepartment(), sec.getLevelSection()) %>%</td>
                                </tr>
                                <%
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

<%-- 
    Document   : list_emp_approved
    Created on : Mar 16, 2017, 2:07:29 PM
    Author     : mchen
--%>
<%@page import="com.dimata.harisma.entity.leave.I_Leave"%>
<%@page import="com.dimata.harisma.session.leave.SessLeaveApplication"%>
<%@page import="com.dimata.gui.jsp.ControlCombo"%>
<%@page import="com.dimata.harisma.entity.leave.SpecialUnpaidLeaveTaken"%>
<%@page import="com.dimata.harisma.entity.leave.PstSpecialUnpaidLeaveTaken"%>
<%@page import="com.dimata.harisma.form.leave.CtrlLeaveApplication"%>
<%@page import="com.dimata.harisma.entity.log.ChangeValue"%>
<%@page import="com.dimata.harisma.entity.leave.LeaveApplication"%>
<%@page import="com.dimata.harisma.entity.leave.PstLeaveApplication"%>
<%@ include file = "../../main/javainit.jsp" %>
<%  int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_EMPLOYEE, AppObjInfo.G2_LEAVE_APPLICATION, AppObjInfo.OBJ_LEAVE_APPLICATION);%>
<%@ include file = "../../main/checkuser.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%!
    public String[] leaveType = {
        "Cuti Khusus", "Cuti Hamil", "Cuti Penting", "Cuti Tahunan", "Cuti Besar"
    };
%>
<%
    int iCommand = FRMQueryString.requestCommand(request);
    long oidLeave = FRMQueryString.requestLong(request, "oid_leave");
    ChangeValue changeValue = new ChangeValue();
    
    SessUserSession userSessionn = (SessUserSession)session.getValue(SessUserSession.HTTP_SESSION_NAME);
    AppUser appUserSess1 = userSessionn.getAppUser();
    String namaUser1 = appUserSess1.getFullName();
    
    /* Check Administrator */
    long oidCompany = 0;
    long oidDivision = 0;
    String strDisable = "";
    String strDisableNum = "";
    if (appUserSess.getAdminStatus()==0){
        oidCompany = emplx.getCompanyId();
        oidDivision = emplx.getDivisionId();
        strDisable = "disabled=\"disabled\"";
    } if (namaUser1.equals("Employee")){
        strDisableNum = "disabled=\"disabled\"";
    }
    
    I_Leave leaveConfig = null;
    try {
        leaveConfig = (I_Leave) (Class.forName(PstSystemProperty.getValueByName("LEAVE_CONFIG")).newInstance());
    } catch (Exception e) {
        System.out.println("Exception : " + e.getMessage());
    }
    
//    CtrlLeaveApplication ctrlLeaveApplication = new CtrlLeaveApplication(request);
//    ctrlLeaveApplication.action(iCommand, oidLeave, null, approot, emplx != null ? emplx.getOID() : 0);
    
    if (iCommand == Command.POST){
        String[] leave_application_id = null;
        leave_application_id = request.getParameterValues("app_id");

        if(emplx!=null && emplx.getOID()!=0 && leave_application_id != null && leave_application_id.length > 0){         

            boolean[] is_process = null;	
            String[] data_executed = null;		

            data_executed = request.getParameterValues("execute");
            is_process = new boolean[leave_application_id.length];

            Vector leaveAppIdProces = new Vector();
            boolean status_excecution;

            for(int i=0; i<leave_application_id.length; i++){
                int ix = FRMQueryString.requestInt(request, "executed"+i);
                if(ix==1){
                    long appid = 0;
                    try{
                        appid = Long.parseLong(leave_application_id[i]);
                    }catch(Exception e){
                        System.out.println("Exception "+e.toString());
                    }
                    //update by satrya 2014-04-08

                    if(emplx.getOID()!=0 && appid!=0 && leaveConfig!=null && leaveConfig.getConfigurationLeaveApprovall()==I_Leave.LEAVE_CONFIG_AFTER_APPROVALL_HRD_YES_EXECUTE){
                        try{
                                status_excecution = SessLeaveApplication.processExecute(appid);
                                LeaveApplication leaveApplication = PstLeaveApplication.fetchExc(appid);  
                                //LeaveApplication objApplication = new LeaveApplication();
                                //frmLeaveApplication.requestEntityObjectVer2(objApplication);
                                leaveApplication.setHrManApproval(emplx.getOID());
                                leaveApplication.setHrManApproveDate(new Date());  
                                PstLeaveApplication.updateExc(leaveApplication); 
                                CtrlLeaveApplication.sendEmail(leaveApplication,approot,emplx.getOID()); 
                        }catch(Exception exc){
                            System.out.println("Exc error execute all leave"+exc);
                        }
                    }else{
                        status_excecution = SessLeaveApplication.processExecute(appid);
                     }
                    leaveAppIdProces.add(leave_application_id[i]);
                }    
            }        
        }
    }

    

    
    /* check dateFrom apakah lebih dari dateNow */
    
    int statusUser = 0;
    String whereUG = PstUserGroup.fieldNames[PstUserGroup.FLD_USER_ID] + "=" + appUserSess.getOID();
    Vector userGroupList = PstUserGroup.list(0, 0, whereUG, "");
    if (userGroupList != null && userGroupList.size() > 0) {
        for (int i = 0; i < userGroupList.size(); i++) {
            UserGroup userGroup = (UserGroup) userGroupList.get(i);
            String whereG = PstAppGroup.fieldNames[PstAppGroup.FLD_GROUP_ID] + "=" + userGroup.getGroupID();
            Vector groupList = PstAppGroup.list(0, 0, whereG, "");
            if (groupList != null && groupList.size() > 0) {
                AppGroup appGroup = (AppGroup) groupList.get(0);
                if (appGroup.getGroupName().equals("Admin Cabang")) {
                    statusUser = 1;
                } else if (appGroup.getGroupName().equals("Head")) {
                    statusUser = 2;
                } else if (appGroup.getGroupName().equals("Direksi")) {
                    statusUser = 2;
                }

            }
        }
    }
    
    long divisionId = 0;
    if ( statusUser ==1){
        divisionId = emplx.getDivisionId();
    }
    
    long oidComp = FRMQueryString.requestLong(request, "company_id");
    String[] oidDiv = FRMQueryString.requestStringValues(request, "division_id");
    String[] oidDept = FRMQueryString.requestStringValues(request, "department");
    String[] oidSec = FRMQueryString.requestStringValues(request, "section");
    String dateFrom = FRMQueryString.requestString(request, "date_from");
    String dateTo = FRMQueryString.requestString(request, "date_to");
    int type = FRMQueryString.requestInt(request, "type");
    
    Vector<String> whereCollect = new Vector<String>();
    String whereClauseEmp = "";
    
    if (oidComp != 0){
        whereClauseEmp = " emp."+PstEmployee.fieldNames[PstEmployee.FLD_COMPANY_ID]+" ="+oidComp;
        whereCollect.add(whereClauseEmp);
    }
    if (oidDiv != null){
        String inDiv = "";
        for (int i=0; i < oidDiv.length; i++){
            inDiv = inDiv + ","+ oidDiv[i];
        }
        inDiv = inDiv.substring(1);
        whereClauseEmp = " emp."+PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID]+" IN("+inDiv+")";
        whereCollect.add(whereClauseEmp);
    }
    if (oidDept != null){
        String inDept = "";
        for (int i=0; i < oidDept.length; i++){
            inDept = inDept + ","+ oidDept[i];
        }
        inDept = inDept.substring(1);
        whereClauseEmp = " emp."+PstEmployee.fieldNames[PstEmployee.FLD_DEPARTMENT_ID]+" IN ("+inDept+")";
        whereCollect.add(whereClauseEmp);
    }
    if (oidSec != null){
        String inSec = "";
        for (int i=0; i < oidSec.length; i++){
            inSec = inSec + ","+ oidSec[i];
        }
        inSec = inSec.substring(1);
        whereClauseEmp = " emp."+PstEmployee.fieldNames[PstEmployee.FLD_SECTION_ID]+" IN ("+inSec+")";
        whereCollect.add(whereClauseEmp);
    }
    
    whereCollect.add("lv."+PstLeaveApplication.fieldNames[PstLeaveApplication.FLD_DOC_STATUS]+"="+PstLeaveApplication.FLD_STATUS_APPlICATION_APPROVED);
    
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
    
    String whereClause = PstLeaveApplication.fieldNames[PstLeaveApplication.FLD_DOC_STATUS]+"="+PstLeaveApplication.FLD_STATUS_APPlICATION_APPROVED;
    Vector listLeave = PstLeaveApplication.listApproved(whereClauseEmp);
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>List of Employee Approved</title>
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
        <script type="text/javascript">
            function cmdExecute(){
                document.frm.command.value="<%= Command.POST %>";
                document.frm.action="list_emp_approved.jsp";
                document.frm.submit();
            }
            function cmdSearch(){
                    document.frm.command.value="<%=String.valueOf(Command.LIST)%>";
                    document.frm.action="list_emp_approved.jsp";
                    document.frm.submit();
        }  
        function SetAllCheckBoxes(FormName, CheckValue){
	    if(!document.forms[FormName])
		return;
            <%  
               if(listLeave!=null){ 
                for(int i = 0 ; i < listLeave.size() ; i++){
                    String nameInp = "executed"+i; 
                    %>  
                            document.forms[FormName].<%=nameInp%>.checked = CheckValue;
                    <%
                    
                 }
               }else{ 
            %>
                    return;
                    <%}%>
        }  
        </script>
    </head>
    <body onload="pageLoad()">
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
            <span id="menu_title">Daftar Cuti yang telah di-approve</span>
        </div>
        <div class="content-main">
            <form name="frm" method="post" action="">
                <!-- input pendukung -->
                <input type="hidden" name="command" value="<%=iCommand%>"> 
                <input type="hidden" name="oid_leave" value="">
                <div class="formstyle">
                    <table>
                        <tr>
                            <td valign="top" style="padding-right: 21px;">
                                <div id="caption">NRK</div>
                                <div id="divinput">
                                    <input type="text" name="emp_number" id="emp_number" value="" />
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
                                  
                            </td>
                            <td valign="top">
                                <div id="caption">Nama Karyawan</div>
                                <div id="divinput">
                                    <input type="text" name="full_name" id="full_name" value="" />                                
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
                                
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div>
                                    <a href="javascript:cmdSearch()" class="btn" style="color:#FFF;">Search</a>
                                </div>
                            </td> 
                        </tr>
                    </table>
                </div>
                <% if ((iCommand == Command.LIST || iCommand == Command.POST) && listLeave.size()> 0) {%>                
                <div class="formstyle">
                    <div>
                    <table class="tblStyle">
                        <tr>
                            <td class="title_tbl">No</td>
                            <td class="title_tbl">NRK</td>
                            <td class="title_tbl">Nama Karyawan</td>
                            <td class="title_tbl">Satuan Kerja</td>
                            <td class="title_tbl">Tanggal Pengajuan</td>
                            <td class="title_tbl">Jenis Cuti</td>
                            <td class="title_tbl">Keterangan</td>
                            <td class="title_tbl">Status</td>
                            <td class="title_tbl"><a href="Javascript:SetAllCheckBoxes('frm', true)">Select</a> | <a href="Javascript:SetAllCheckBoxes('frm', false)">Deselect</a></td>
                        </tr>
                        <%
                        if (listLeave != null && listLeave.size()>0){
                            long scheduleSymbol = 0;
                            for (int i=0; i<listLeave.size(); i++){
                                LeaveApplication leave = (LeaveApplication)listLeave.get(i);
                                Employee emp = new Employee();
                                try {
                                    emp = PstEmployee.fetchExc(leave.getEmployeeId());
                                } catch(Exception e){
                                    System.out.println(e.toString());
                                }
                                %>
                                <tr>
                                    <td style="background-color: #FFF;"><%= (i+1) %></td>
                                    <td style="background-color: #FFF;"><%= emp.getEmployeeNum() %></td>
                                    <td style="background-color: #FFF;"><%= emp.getFullName()%></td>
                                    <td style="background-color: #FFF;"><%= changeValue.getDivisionName(emp.getDivisionId()) %></td>
                                    <td style="background-color: #FFF;"><%= leave.getSubmissionDate() %></td>
                                    <%
                                        if (leave.getTypeLeaveCategory() != 0){
                                    %>
                                    <td style="background-color: #FFF;"><%= leaveType[leave.getTypeLeaveCategory()] %></td>
                                    <%
                                        } else {
                                            String where = PstSpecialUnpaidLeaveTaken.fieldNames[PstSpecialUnpaidLeaveTaken.FLD_LEAVE_APLICATION_ID]+"="+leave.getOID();
                                            Vector listSlStockTaken = PstSpecialUnpaidLeaveTaken.list(0, 0, where, "");
                                            if (listSlStockTaken != null && listSlStockTaken.size()>0){
                                                SpecialUnpaidLeaveTaken slStockTaken = (SpecialUnpaidLeaveTaken)listSlStockTaken.get(0);
                                                scheduleSymbol = slStockTaken.getScheduledId();
                                            }
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
                                        <input type="hidden" name="app_id" value="<%= leave.getOID() %>">
                                        <input type="hidden" name="execute<%=i%>"><center><input type="checkbox" name="executed<%=i%>" value="1" ></center>
                                        <!--<a href="javascript:cmdExecute('<%= leave.getOID() %>')">Execute</a>-->
                                    </td>
                                </tr>
                        <% 
                            }
                        }
                        %>
                    </table>
                    </div>
                    <div>&nbsp;</div>
                    <div>
                        <a href="javascript:cmdExecute()" class="btn" style="color:#FFF;">Execute</a>
                    </div>
                </div>
                    <% } %>
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

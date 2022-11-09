<%-- 
    Document   : leave_app_form
    Created on : Jan 17, 2017, 2:56:18 PM
    Author     : Dimata 007
--%>
<%@page import="com.dimata.harisma.entity.leave.SpecialUnpaidLeaveTaken"%>
<%@page import="com.dimata.harisma.entity.leave.PstSpecialUnpaidLeaveTaken"%>
<%@page import="com.dimata.harisma.entity.attendance.PstLlStockTaken"%>
<%@page import="com.dimata.harisma.entity.attendance.LlStockTaken"%>
<%@page import="com.dimata.harisma.entity.attendance.PstAlStockTaken"%>
<%@page import="com.dimata.harisma.report.EmployeeAmountXLS"%>
<%@page import="java.text.ParseException"%>
<%@page import="java.util.concurrent.TimeUnit"%>
<%@page import="com.dimata.harisma.entity.attendance.AlStockTaken"%>
<%@page import="java.math.RoundingMode"%>
<%@page import="java.math.BigDecimal"%>
<%@page import="com.dimata.harisma.entity.attendance.LLStockManagement"%>
<%@page import="com.dimata.harisma.entity.attendance.PstLLStockManagement"%>
<%@page import="com.dimata.harisma.entity.attendance.AlStockManagement"%>
<%@page import="com.dimata.harisma.entity.attendance.PstAlStockManagement"%>
<%@page import="com.dimata.harisma.entity.log.ChangeValue"%>
<%@page import="com.dimata.harisma.entity.leave.PstLeaveApplication"%>
<%@page import="com.dimata.harisma.entity.leave.LeaveApplication"%>
<%@page import="java.text.SimpleDateFormat"%>
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
%>
<%
    int iCommand = FRMQueryString.requestCommand(request);
    long oidLeaveApplication = FRMQueryString.requestLong(request, "leave_id");
    long employeeId = FRMQueryString.requestLong(request, "employee_id");
    String leaveReason = FRMQueryString.requestString(request, "leave_reason");
    int typeLeaveCategory = FRMQueryString.requestInt(request, "type_leave_category");
    String dateFrom = FRMQueryString.requestString(request, "date_from");
    String dateTo = FRMQueryString.requestString(request, "date_to");
    
    String empNum = FRMQueryString.requestString(request, "emp_num");
    String empName = FRMQueryString.requestString(request, "emp_name");
    String empDivision = FRMQueryString.requestString(request, "emp_division");
    String empDept = FRMQueryString.requestString(request, "emp_dept");
    String empSect = FRMQueryString.requestString(request, "emp_sect");
    String empPost = FRMQueryString.requestString(request, "emp_post");
    
    Long dtReq = FRMQueryString.requestLong(request, "requestDateDaily");
    java.util.Date requestDate = new Date();
    if (dtReq != 0){
        requestDate = new Date(dtReq.longValue());
    }
    
    String whereClause = "";
    Date dateNow = new Date();
    ChangeValue changeValue = new ChangeValue();
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    String strDateNow = "";
    
    if(dtReq != 0){
        strDateNow = sdf.format(requestDate);
    } else {
        strDateNow = sdf.format(dateNow);
    }
    
    /* [begin] data untuk comboBox jenis cuti spesial */
    String whereSchedule = "";
    String oidSpecialLeave = "";
    String oidUnpaidLeave = "";
    try {
        oidSpecialLeave = String.valueOf(PstSystemProperty.getValueByName("OID_SPECIAL"));
    } catch (Exception E) {
        oidSpecialLeave = "0";
        System.out.println("EXCEPTION SYS PROP OID_SPECIAL : " + E.toString());
    }
    try {
        oidUnpaidLeave = String.valueOf(PstSystemProperty.getValueByName("OID_UNPAID"));
    } catch (Exception E) {
        oidUnpaidLeave = "0";
        System.out.println("EXCEPTION SYS PROP OID_UNPAID : " + E.toString());
    }
    whereSchedule = "("+PstScheduleSymbol.fieldNames[PstScheduleSymbol.FLD_SCHEDULE_CATEGORY_ID] + " = " + oidSpecialLeave
    + " OR " + PstScheduleSymbol.fieldNames[PstScheduleSymbol.FLD_SCHEDULE_CATEGORY_ID] + " = " + oidUnpaidLeave+") AND "
    + PstScheduleSymbol.fieldNames[PstScheduleSymbol.FLD_SHOW_ON_USER_LEAVE]+ " = 1";
    Vector listSchedule = PstScheduleSymbol.list(0, 0, whereSchedule, null);
    /* [end] data untuk comboBox jenis cuti spesial */

    if (appUserSess.getLoginId().equals("Employee")){
        employeeId = emplx.getOID();
        empNum = emplx.getEmployeeNum();
        empName = emplx.getFullName();
        empDivision = changeValue.getDivisionName(emplx.getDivisionId());
        empDept = changeValue.getDepartmentName(emplx.getDepartmentId());
        empSect = changeValue.getSectionName(emplx.getSectionId());
        empPost = changeValue.getPositionName(emplx.getPositionId());
    }
    if (empNum.equals("") && employeeId != 0){
        try {
            Employee emp = PstEmployee.fetchExc(employeeId);
            empNum = emp.getEmployeeNum();
            empName = emp.getFullName();
            empDivision = changeValue.getDivisionName(emp.getDivisionId());
            empDept = changeValue.getDepartmentName(emp.getDepartmentId());
            empSect = changeValue.getSectionName(emp.getSectionId());
            empPost = changeValue.getPositionName(emp.getPositionId());
        } catch(Exception e){
            System.out.println(e.toString());
        }
    }
    /* Jika leave id != 0 dan iCommand == EDIT */
	Employee emp = PstEmployee.fetchExc(employeeId);
    if (iCommand == Command.EDIT && oidLeaveApplication != 0){
        try {
            empNum = emp.getEmployeeNum();
            empName = emp.getFullName();
            empDivision = changeValue.getDivisionName(emp.getDivisionId());
            empDept = changeValue.getDepartmentName(emp.getDepartmentId());
            empSect = changeValue.getSectionName(emp.getSectionId());
            empPost = changeValue.getPositionName(emp.getPositionId());
            
            LeaveApplication leaveApp = PstLeaveApplication.fetchExc(oidLeaveApplication);
            leaveReason = leaveApp.getLeaveReason();
            typeLeaveCategory = leaveApp.getTypeLeaveCategory();
        } catch(Exception e){
            System.out.println(""+e.toString());
        }
        
    }
    Vector alStockList = new Vector();
    Vector llStockList = new Vector();
    float alQty = 0;
    float llQty = 0;
    long alStockId = 0;
    long llStockId = 0;
    boolean alStatus = false;
    boolean llStatus = false;
    /* for leave information */
    if (employeeId != 0){    
        whereClause = PstAlStockManagement.fieldNames[PstAlStockManagement.FLD_EMPLOYEE_ID]+"="+employeeId;
        whereClause += " AND "+PstAlStockManagement.fieldNames[PstAlStockManagement.FLD_AL_STATUS]+"=0";
        alStockList = PstAlStockManagement.list(0, 0, whereClause, "");
        if (alStockList != null && alStockList.size()>0){
            AlStockManagement alStock = (AlStockManagement)alStockList.get(0);
            alQty = alStock.getAlQty();
            alStockId = alStock.getOID();
            if (alQty > 0){
                alStatus = true;
            }
        }
        whereClause = PstLLStockManagement.fieldNames[PstLLStockManagement.FLD_EMPLOYEE_ID]+"="+employeeId;
        whereClause += " AND "+PstLLStockManagement.fieldNames[PstLLStockManagement.FLD_LL_STATUS]+"=0";
        llStockList = PstLLStockManagement.list(0, 0, whereClause, "");
        if (llStockList != null && llStockList.size()>0){
            LLStockManagement llStock = (LLStockManagement)llStockList.get(0);
            llQty = llStock.getLLQty();
            llStockId = llStock.getOID();
            if (llQty > 0){
                llStatus = true;
            }
        }
    }
    int docStatus = PstLeaveApplication.FLD_STATUS_APPlICATION_DRAFT;
    if (iCommand == Command.SAVE){
        docStatus = PstLeaveApplication.FLD_STATUS_APPlICATION_DRAFT;
    }
    
    if (iCommand == Command.SUBMIT){
        docStatus = PstLeaveApplication.FLD_STATUS_APPlICATION_TO_BE_APPROVE;
    }
    
    if (iCommand == Command.SAVE || iCommand == Command.SUBMIT){
        /* Save Draft || To Be Approve */
        /*
        type form leave : 
        LEAVE_APPLICATION = 0;
        EXCUSE_APPLICATION = 1;

        type leave category:
        None, Hamil, Penting, AL, LL
        */
        /* cek kategori cuti */
        /*
        * 0 = None
        * 1 = Cuti Hamil
        * 2 = Cuti Penting
        * 3 = Cuti Tahunan
        * 4 = Cuti Besar 
        */
        long leaveAppId = oidLeaveApplication;
        int codeUpdate = 0;
        long alSTakenId = 0;
        long llSTakenId = 0;
        if (leaveAppId != 0){
            /* update to Leave Application */
            codeUpdate = 1;
            LeaveApplication leaveApp = new LeaveApplication();
            leaveApp.setOID(leaveAppId);
            leaveApp.setSubmissionDate(dateNow);
            leaveApp.setEmployeeId(employeeId);
            leaveApp.setLeaveReason(leaveReason);
            leaveApp.setDocStatus(docStatus);
            leaveApp.setTypeFormLeave(0);
            leaveApp.setTypeLeaveCategory(typeLeaveCategory);
            try {
                leaveAppId = PstLeaveApplication.updateExc(leaveApp);
            } catch(Exception e){
                System.out.print("System=>"+e.toString());
            }
            String where = PstAlStockTaken.fieldNames[PstAlStockTaken.FLD_LEAVE_APPLICATION_ID]+"="+leaveAppId;
                   where += " AND "+PstAlStockTaken.fieldNames[PstAlStockTaken.FLD_EMPLOYEE_ID]+"="+employeeId;
            Vector listAlSTaken = PstAlStockTaken.list(0, 0, where, "");
            if (listAlSTaken != null && listAlSTaken.size()>0){
                AlStockTaken alSTaken = (AlStockTaken)listAlSTaken.get(0);
                alSTakenId = alSTaken.getOID();
            }
            where = PstLlStockTaken.fieldNames[PstLlStockTaken.FLD_LEAVE_APPLICATION_ID]+"="+leaveAppId;
                   where += " AND "+PstLlStockTaken.fieldNames[PstLlStockTaken.FLD_EMPLOYEE_ID]+"="+employeeId;
            Vector listLlSTaken = PstLlStockTaken.list(0, 0, where, "");
            if (listLlSTaken != null && listLlSTaken.size()>0){
                LlStockTaken llSTaken = (LlStockTaken)listLlSTaken.get(0);
                llSTakenId = llSTaken.getOID();
            }
        } else {
            /* insert to Leave Application */
            LeaveApplication leaveApp = new LeaveApplication();
            leaveApp.setSubmissionDate(dateNow);
            leaveApp.setEmployeeId(employeeId);
            leaveApp.setLeaveReason(leaveReason);
            leaveApp.setDocStatus(docStatus);
            leaveApp.setTypeFormLeave(0);
            leaveApp.setTypeLeaveCategory(typeLeaveCategory);
            try {
                leaveAppId = PstLeaveApplication.insertExc(leaveApp);
            } catch(Exception e){
                System.out.print("System=>"+e.toString());
            }
        }
        
        
        Date tglFrom = sdf.parse(dateFrom);
        Date tglTo = sdf.parse(dateTo);
        
        EmployeeAmountXLS countDate = new EmployeeAmountXLS();
        Vector rangeDate = countDate.getRangeOfDate(dateFrom, dateTo);
        int intRangeDate = rangeDate.size();
        
        switch(typeLeaveCategory){
            case 0: 
                if (alQty != 0){
                    AlStockTaken alSTaken = new AlStockTaken();
                    if (codeUpdate != 0 && alSTakenId != 0){
                        alSTaken.setOID(alSTakenId);
                    }
                    alSTaken.setEmployeeId(employeeId);
                    alSTaken.setTakenDate(tglFrom);
                    alSTaken.setTakenFinnishDate(tglTo);
                    alSTaken.setTakenQty(intRangeDate);
                    alSTaken.setAlStockId(alStockId);
                    alSTaken.setLeaveApplicationId(leaveAppId);
                    try {
                        if (codeUpdate != 0 && alSTakenId != 0){
                            PstAlStockTaken.updateExc(alSTaken);
                        } else {
                            PstAlStockTaken.insertExc(alSTaken);
                        }
                    } catch(Exception e){
                        System.out.print("System=>"+e.toString());
                    }
                }
                break;
            case 1:
                if (alQty != 0){
                    AlStockTaken alSTaken = new AlStockTaken();
                    if (codeUpdate != 0 && alSTakenId != 0){
                        alSTaken.setOID(alSTakenId);
                    }
                    alSTaken.setEmployeeId(employeeId);
                    alSTaken.setTakenDate(tglFrom);
                    alSTaken.setTakenFinnishDate(tglTo);
                    alSTaken.setTakenQty(intRangeDate);
                    alSTaken.setAlStockId(alStockId);
                    alSTaken.setLeaveApplicationId(leaveAppId);
                    try {
                        if (codeUpdate != 0 && alSTakenId != 0){
                            PstAlStockTaken.updateExc(alSTaken);
                        } else {
                            PstAlStockTaken.insertExc(alSTaken);
                        }
                    } catch(Exception e){
                        System.out.print("System=>"+e.toString());
                    }
                }
                break;
            case 2:
                if (alQty > llQty){
                    AlStockTaken alSTaken = new AlStockTaken();
                    if (codeUpdate != 0 && alSTakenId != 0){
                        alSTaken.setOID(alSTakenId);
                    }
                    alSTaken.setEmployeeId(employeeId);
                    alSTaken.setTakenDate(tglFrom);
                    alSTaken.setTakenFinnishDate(tglTo);
                    alSTaken.setTakenQty(intRangeDate);
                    alSTaken.setAlStockId(alStockId);
                    alSTaken.setLeaveApplicationId(leaveAppId);
                    try {
                        if (codeUpdate != 0 && alSTakenId != 0){
                            PstAlStockTaken.updateExc(alSTaken);
                        } else {
                            PstAlStockTaken.insertExc(alSTaken);
                        }
                    } catch(Exception e){
                        System.out.print("System=>"+e.toString());
                    }
                } else {
                    LlStockTaken llSTaken = new LlStockTaken();
                    if (codeUpdate != 0 && llSTakenId != 0){
                        llSTaken.setOID(llSTakenId);
                    }
                    llSTaken.setEmployeeId(employeeId);
                    llSTaken.setTakenDate(tglFrom);
                    llSTaken.setTakenFinnishDate(tglTo);
                    llSTaken.setTakenQty(intRangeDate);
                    llSTaken.setLlStockId(llStockId);
                    llSTaken.setLeaveApplicationId(leaveAppId);
                    try {
                        if (codeUpdate != 0 && llSTakenId != 0){
                            PstLlStockTaken.updateExc(llSTaken);
                        } else {
                            PstLlStockTaken.insertExc(llSTaken);
                        }
                    } catch(Exception e){
                        System.out.print("System=>"+e.toString());
                    }
                }
                break;
            case 3:
                if (alQty != 0){
                    AlStockTaken alSTaken = new AlStockTaken();
                    if (codeUpdate != 0 && alSTakenId != 0){
                        alSTaken.setOID(alSTakenId);
                    }
                    alSTaken.setEmployeeId(employeeId);
                    alSTaken.setTakenDate(tglFrom);
                    alSTaken.setTakenFinnishDate(tglTo);
                    alSTaken.setTakenQty(intRangeDate);
                    alSTaken.setAlStockId(alStockId);
                    alSTaken.setLeaveApplicationId(leaveAppId);
                    try {
                        if (codeUpdate != 0 && alSTakenId != 0){
                            PstAlStockTaken.updateExc(alSTaken);
                        } else {
                            PstAlStockTaken.insertExc(alSTaken);
                        }
                    } catch(Exception e){
                        System.out.print("System=>"+e.toString());
                    }
                }
                break;
            case 4:
                if (llQty != 0){
                    LlStockTaken llSTaken = new LlStockTaken();
                    if (codeUpdate != 0 && llSTakenId != 0){
                        llSTaken.setOID(llSTakenId);
                    }
                    llSTaken.setEmployeeId(employeeId);
                    llSTaken.setTakenDate(tglFrom);
                    llSTaken.setTakenFinnishDate(tglTo);
                    llSTaken.setTakenQty(intRangeDate);
                    llSTaken.setLlStockId(llStockId);
                    llSTaken.setLeaveApplicationId(leaveAppId);
                    try {
                        if (codeUpdate != 0 && llSTakenId != 0){
                            PstLlStockTaken.updateExc(llSTaken);
                        } else {
                            PstLlStockTaken.insertExc(llSTaken);
                        }
                    } catch(Exception e){
                        System.out.print("System=>"+e.toString());
                    }
                }
                break;
        }
        /* redirect page */
        String redirectURL = approot+"/employee/leave/leave_list_emp.jsp?employee_id="+employeeId;
        response.sendRedirect(redirectURL);
    }

%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Form Pengajuan</title>
        <link rel="stylesheet" href="../../styles/main.css" type="text/css">
        <style type="text/css">
            .tblStyle {border-collapse: collapse; font-size: 12px; }
            .tblStyle td {padding: 5px 7px; border: 1px solid #CCC; font-size: 12px;}
            .title_tbl {font-weight: bold;background-color: #EEE; color: #575757;}
            .title_page {color:#0db2e1; font-weight: bold; font-size: 14px; background-color: #EEE; border-left: 1px solid #0099FF; padding: 12px 18px;}

            .tblStyleNoBorder {font-size: 12px; }
            .tblStyleNoBorder td {padding: 5px 7px; font-size: 12px; }
            
            body {color:#373737;}
            #menu_utama {padding: 9px 14px; border-left: 1px solid #0099FF; font-size: 14px; background-color: #F3F3F3;}
            #menu_title {color:#0099FF; font-size: 14px;}
            #menu_teks {color:#CCC;}

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

            .content {
                padding: 21px;
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
            
            .btn-green {
                background-color: #ace600;
                border-radius: 3px;
                font-family: Arial;
                color: #EEE;
                font-size: 12px;
                padding: 7px 11px 7px 11px;
                text-decoration: none;
            }

            .btn-green:hover {
                color: #FFF;
                background-color: #86b300;
                text-decoration: none;
            }
            
            .btn-red {
                background-color: #ff9999;
                border-radius: 3px;
                font-family: Arial;
                color: #EEE;
                font-size: 12px;
                padding: 7px 11px 7px 11px;
                text-decoration: none;
            }

            .btn-red:hover {
                color: #FFF;
                background-color: #ff6666;
                text-decoration: none;
            }
            
            .btn-grey {
                background-color: #C5C5C5;
                border-radius: 3px;
                font-family: Arial;
                color: #EEE;
                font-size: 12px;
                padding: 7px 11px 7px 11px;
                text-decoration: none;
            }

            .btn-grey:hover {
                color: #FFF;
                background-color: #B7B7B7;
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
            h2 {
                padding: 0px 0px 21px 0px;
                margin: 0px 0px 21px 0px;
                border-bottom: 1px solid #DDD;
            }
            .box {
                border: 1px solid #DDD;
                background-color: #f5f5f5;
                margin: 5px 0px;
            }
            #box-title {
                font-size: 14px;
                font-weight: bold;
                color: #007fba;
                padding-bottom: 15px;
            }
            #box-content {
                color: #575757;
                padding: 14px 19px;
            }
            #info1, #info2 {
                font-size: 11px;
                color: #CF5353;
            }
        </style>
        <link rel="stylesheet" href="<%=approot%>/javascripts/datepicker/themes/jquery.ui.all.css">
        <script src="<%=approot%>/javascripts/jquery.js"></script>
        <script src="<%=approot%>/javascripts/datepicker/jquery.ui.core.js"></script>
	<script src="<%=approot%>/javascripts/datepicker/jquery.ui.widget.js"></script>
	<script src="<%=approot%>/javascripts/datepicker/jquery.ui.datepicker.js"></script>
        <script type="text/javascript">
            function pageLoad(){
                $(".mydate").datepicker({ dateFormat: "yy-mm-dd" });
            }
            function cmdEmpSearch(){
                window.open("<%=approot%>/employee/leave/emp_search.jsp", null, "height=570,width=890, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");       
            }
            function cmdSaveAsDraft(){
                document.frm.command.value="<%= Command.VIEW /*Command.SAVE*/ %>";
    
                document.frm.action="leave_app_review.jsp";
                document.frm.submit();
            }
            function cmdSubmit(){
                if (document.getElementById("datefrom").value != "" && document.getElementById("dateto").value != ""){
                        document.frm.command.value="<%= Command.VIEW%>";
                        document.frm.action="leave_app_review.jsp";
                        document.frm.submit();
                } else {
                    if (document.getElementById("datefrom").value == ""){
                        document.getElementById("info1").innerHTML="tanggal mulai harus diisi";
                    }
                    if (document.getElementById("dateto").value == ""){
                        document.getElementById("info2").innerHTML="tanggal akhir harus diisi";
                    }
                }
    
}
            function cmdLeaveList(empId){
                document.frm.employee_id.value=empId;
                document.frm.halaman.value="leave_app_form";
                document.frm.action="leave_list_emp.jsp";
                document.frm.submit();
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
            <span id="menu_title">Cuti <strong style="color:#333;"> / </strong>Form Pengajuan</span>
        </div>
        <div class="content-main">
            <form name="frm" method="post" action="">
                <input type="hidden" name="command" value="<%= iCommand %>"> 
                <input type="hidden" name="leave_id" value="<%= oidLeaveApplication %>" />
                <!-- input pendukung -->
                <input type="hidden" name="emp_num" value="<%= empNum %>">
                <input type="hidden" name="emp_name" value="<%= empName %>">
                <input type="hidden" name="emp_division" value="<%= empDivision %>">
                <input type="hidden" name="emp_dept" value="<%= empDept %>">
                <input type="hidden" name="emp_sect" value="<%= empSect %>">
                <input type="hidden" name="emp_post" value="<%= empPost %>">
                <input type="hidden" name="halaman" value="">
                <div id="box-content" style="background-color: #EEE;">
                    <div id="box-title">Informasi Karyawan</div>                    
                    <table class="tblStyleNoBorder">
                        <tr>
                            <td><strong>NRK</strong></td>
                            <td><div id="emp_num"><%= empNum %></div><input type="hidden" name="employee_id" value="<%= employeeId %>" /></td>
                        </tr>
                        <tr>
                            <td><strong>Nama</strong></td>
                            <td><div id="emp_name"><%= empName %></div></td>
                        </tr>
                        <tr>
                            <td><strong>Satuan Karja</strong></td>
                            <td><div id="emp_division"><%= empDivision %></div></td>
                        </tr>
                        <tr>
                            <td><strong>Unit</strong></td>
                            <td><div id="emp_department"><%= empDept %></div></td>
                        </tr>
                        <tr>
                            <td><strong>Sub Unit</strong></td>
                            <td><div id="emp_section"><%= empSect %></div></td>
                        </tr>
                        <tr>
                            <td><strong>Position</strong></td>
                            <td><div id="emp_position"><%= empPost %></div></td>
                        </tr>
                    </table>
                </div>
                <div id="box-content" style="background-color: #FFF">
                    <div id="box-title">Informasi Cuti</div>
                    <table class="tblStyle">
                        <tr>
                            <td class="title_tbl">Cuti Saat ini</td>
                            <td class="title_tbl">Cuti Sebelumnya</td>
                            <td class="title_tbl">Cuti Total</td>
                            <td class="title_tbl">Cuti Digunakan</td>
                            <td class="title_tbl">Sisa Cuti</td>
                        </tr>
                        <%
                        if (alQty > llQty){
                            if (alStockList != null && alStockList.size()>0){
                                for (int i=0; i<alStockList.size(); i++){
                                    AlStockManagement alStockManagement = (AlStockManagement)alStockList.get(i);
                                    %>
                                    <tr>
                                        <td><%= convertInteger(alStockManagement.getEntitled()) %></td>
                                        <td><%= convertInteger(alStockManagement.getPrevBalance()) %></td>
                                        <td><%= convertInteger(alStockManagement.getEntitled()+alStockManagement.getPrevBalance()) %></td>
                                        <td><%= convertInteger(alStockManagement.getQtyUsed()) %></td>
                                        <td><%= convertInteger(alStockManagement.getAlQty()-alStockManagement.getQtyUsed()) %></td>
                                    </tr>
                                    <%
                                }
                            }
                        } else {
                            if (llStockList != null && llStockList.size()>0){
                                for (int i=0; i<llStockList.size(); i++){
                                    LLStockManagement llStockManagement = (LLStockManagement)llStockList.get(i);
                                    %>
                                    <tr>
                                        <td><%= convertInteger(llStockManagement.getEntitled()) %></td>
                                        <td><%= convertInteger(llStockManagement.getPrevBalance()) %></td>
                                        <td><%= convertInteger(llStockManagement.getEntitled()+llStockManagement.getPrevBalance()) %></td>
                                        <td><%= convertInteger(llStockManagement.getQtyUsed()) %></td>
                                        <td><%= convertInteger(llStockManagement.getLLQty()-llStockManagement.getQtyUsed()) %></td>
                                    </tr>
                                    <%
                                }
                            }
                        }
                        %>
                    </table>
                    <p style="font-size: 11px">
                        <%
                            String infoCutiBesar = "";
                            String infoCutiTh = "";
                            boolean canAL = false;
                            boolean canLL = false;
                            int year = Calendar.getInstance().get(Calendar.YEAR);
                            if (llStatus){
                                //Vector dataLlQty = PstLlStockTaken.getLlTakenQty(llStockId);
                                String where = PstLeaveApplication.fieldNames[PstLeaveApplication.FLD_EMPLOYEE_ID]+" = "+employeeId+" AND "+PstLeaveApplication.fieldNames[PstLeaveApplication.FLD_TYPE_LEAVE_CATEGORY]+" IN ("
                                            +PstLeaveApplication.FLD_TYPE_LEAVE_CATEGORY_LONG+ ", "+PstLeaveApplication.FLD_TYPE_LEAVE_CATEGORY_MATERNITY+") AND "+PstLeaveApplication.fieldNames[PstLeaveApplication.FLD_SUBMISSION_DATE]+" LIKE '%"+year+"%'"
                                            + " AND "+PstLeaveApplication.fieldNames[PstLeaveApplication.FLD_DOC_STATUS] +" IN ("+PstLeaveApplication.FLD_STATUS_APPlICATION_APPROVED+","+PstLeaveApplication.FLD_STATUS_APPlICATION_EXECUTED+")" ;
                                Vector listCB = PstLeaveApplication.list(0,0,where,"");
                                if (listCB != null && listCB.size()>0){
                                    infoCutiBesar = "Sudah digunakan";
                                } else {
                                    infoCutiBesar = "Belum digunakan";
                                    canLL = true;
                                }                                
                            } else {
                                infoCutiBesar = "Belum mempunyai hak cuti besar";

                            }
                            /*===*/
                            if (alStatus){
                                //Vector dataAlQty = PstAlStockTaken.getAlTakenQty(alStockId);
                                String where = PstLeaveApplication.fieldNames[PstLeaveApplication.FLD_EMPLOYEE_ID]+" = "+employeeId+" AND "+PstLeaveApplication.fieldNames[PstLeaveApplication.FLD_TYPE_LEAVE_CATEGORY]+" IN ("
                                            + PstLeaveApplication.FLD_TYPE_LEAVE_CATEGORY_ANNUAL +", "+PstLeaveApplication.FLD_TYPE_LEAVE_CATEGORY_MATERNITY+") AND "+PstLeaveApplication.fieldNames[PstLeaveApplication.FLD_SUBMISSION_DATE]+" LIKE '%"+year+"%' "
                                            + " AND "+PstLeaveApplication.fieldNames[PstLeaveApplication.FLD_DOC_STATUS] +" IN ("+PstLeaveApplication.FLD_STATUS_APPlICATION_APPROVED+","+PstLeaveApplication.FLD_STATUS_APPlICATION_EXECUTED+")" ;
                                Vector listCT = PstLeaveApplication.list(0,0,where,"");
                                if (listCT != null && listCT.size()>0){
                                    infoCutiTh = "Sudah digunakan";
                                } else {
                                    infoCutiTh = "Belum digunakan";
                                    canAL = true;
                                }
                            } else {
                                infoCutiTh = "Belum ada cuti tahunan";
                            }
                        %>
                        Status Cuti Besar : <%= infoCutiBesar %><br>
                        Status Cuti Tahunan : <%= infoCutiTh %> 
                    </p>
                </div>
                <div id="box-content" style="background-color: #EEE;">
                    <div id="box-title">Form Input Cuti</div>
                    <p style="font-size: 11px">*) Jenis Cuti Selain Cuti Besar, Tahunan, Hamil, & Penting Tidak mengurangi stok cuti</p>
                    <table class="tblStyleNoBorder">
                        <tr>
                            <td><strong>Tanggal Pengajuan</strong></td>
                            <td><input type="text" name="pengajuan_date" value="<%= strDateNow %>" disabled="disabled" /></td>
                        </tr>
                        <tr>
                            <td><strong>Jenis Cuti</strong></td>
                            <td>
                                <select name="type_leave_category" id="type">
                                    <%
                                        Hashtable hashLeave = new Hashtable();
                                        for (int t=0; t<PstLeaveApplication.fieldTypeLeaveCategory.length; t++){
                                            if ( t== 0 || t==1){
                                                %>
                                                <%
                                            } else if ((t == PstLeaveApplication.FLD_TYPE_LEAVE_CATEGORY_ANNUAL && canAL) || t == typeLeaveCategory){
                                                if (typeLeaveCategory == t){
                                                    %>
                                                    <option selected="selected" value="<%=t%>"><%= PstLeaveApplication.fieldTypeLeaveCategory[t] %></option>
                                                    <%
                                                } else {
                                                    %>
                                                    <option value="<%=t%>"><%= leaveType[t] %></option>
                                                    <%
                                                }
                                            } else if ((t == PstLeaveApplication.FLD_TYPE_LEAVE_CATEGORY_LONG && canLL) || t == typeLeaveCategory){
                                                if (typeLeaveCategory == t){
                                                    %>
                                                    <option selected="selected" value="<%=t%>"><%= PstLeaveApplication.fieldTypeLeaveCategory[t] %></option>
                                                    <%
                                                } else {
                                                    %>
                                                    <option value="<%=t%>"><%= leaveType[t] %></option>
                                                    <%
                                                }
                                            } else if (t != PstLeaveApplication.FLD_TYPE_LEAVE_CATEGORY_LONG && t != PstLeaveApplication.FLD_TYPE_LEAVE_CATEGORY_ANNUAL) {
                                                if (typeLeaveCategory == t){
                                                    %>
                                                    <option selected="selected" value="<%=t%>"><%= PstLeaveApplication.fieldTypeLeaveCategory[t] %></option>
                                                    <%
                                                } else {
                                                    %>
                                                    <option value="<%=t%>"><%= leaveType[t] %></option>
                                                    <%
                                                }
                                            }
                                        }
                                    %>
                                    <%
                                    if (listSchedule != null && listSchedule.size()>0){
                                        for (int i=0; i<listSchedule.size(); i++){
                                            ScheduleSymbol scheduleSymbol = (ScheduleSymbol) listSchedule.get(i);
                                            if (typeLeaveCategory == 0 && oidLeaveApplication != 0){
                                                String where = PstSpecialUnpaidLeaveTaken.fieldNames[PstSpecialUnpaidLeaveTaken.FLD_LEAVE_APLICATION_ID]+"="+oidLeaveApplication;
                                                    where += " AND "+PstSpecialUnpaidLeaveTaken.fieldNames[PstSpecialUnpaidLeaveTaken.FLD_EMPLOYEE_ID]+"="+employeeId;
                                                Vector listSlSTaken = PstSpecialUnpaidLeaveTaken.list(0, 0, where, "");
                                                if (listSlSTaken != null && listSlSTaken.size()>0){
                                                    SpecialUnpaidLeaveTaken slSTaken = (SpecialUnpaidLeaveTaken)listSlSTaken.get(0);
                                                    if (slSTaken.getScheduledId() == scheduleSymbol.getOID()){
                                                    %>
                                                        <option value="<%= scheduleSymbol.getOID() %>" selected="selected"><%= scheduleSymbol.getSchedule() %></option>     
                                                    <%
                                                    } else {
                                                        %><option value="<%= scheduleSymbol.getOID() %>"><%= scheduleSymbol.getSchedule() %></option><%
                                                    }
                                                }
                                               } else {
                                            %>
                                            <option value="<%= scheduleSymbol.getOID() %>"><%= scheduleSymbol.getSchedule() %></option>
                                            <%
                                            }
                                        }
                                    }
									if (emp.getSex() == 1){
										if (typeLeaveCategory == PstLeaveApplication.FLD_TYPE_LEAVE_CATEGORY_MATERNITY){
											%>
											<option selected="selected" value="<%=PstLeaveApplication.FLD_TYPE_LEAVE_CATEGORY_MATERNITY%>"><%= PstLeaveApplication.fieldTypeLeaveCategory[PstLeaveApplication.FLD_TYPE_LEAVE_CATEGORY_MATERNITY] %></option>
											<%
										} else {
											%>
											<option value="<%=PstLeaveApplication.FLD_TYPE_LEAVE_CATEGORY_MATERNITY%>"><%= leaveType[PstLeaveApplication.FLD_TYPE_LEAVE_CATEGORY_MATERNITY] %></option>
											<%
										}
									}
                                    %>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td><strong>Alasan Cuti</strong></td>
                            <td><textarea name="leave_reason" cols="20"><%= leaveReason %></textarea></td>
                        </tr>
                        <tr>
                            <td><strong>Dari Tanggal</strong></td>
                            <td>
                                <input type="text" id="datefrom" class="mydate" name="date_from" value="<%= (dateFrom.equals("") ? strDateNow : dateFrom)%>" />
                                <span id="info1"></span>
                            </td>
                        </tr>
                        <tr>
                            <td><strong>Sampai Tanggal</strong></td>
                            <td>
                                <input type="text" id="dateto" class="mydate" name="date_to" value="<%=  (dateTo.equals("") ? strDateNow : dateTo) %>" />
                                <span id="info2"></span>
                            </td>
                        </tr>
                    </table>
                    
                </div>
                <div id="box-content" style="background-color: #FFF">
                    <!--<a href="javascript:cmdSaveAsDraft()" class="btn-green" style="color:#FFF;">Save as Draft</a>-->
                    <a href="javascript:cmdSubmit()" class="btn" style="color:#FFF;">Submit</a>
                    <a href="javascript:cmdLeaveList('<%= employeeId %>')" class="btn-grey" style="color:#FFF;">List of Leave</a>
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
    </body>
</html>

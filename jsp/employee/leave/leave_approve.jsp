<%-- 
    Document   : leave_approve
    Created on : Feb 3, 2017, 1:11:18 PM
    Author     : mchen
--%>
<%@page import="com.dimata.harisma.entity.attendance.LlStockTaken"%>
<%@page import="com.dimata.harisma.entity.attendance.PstLlStockTaken"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.math.RoundingMode"%>
<%@page import="java.math.BigDecimal"%>
<%@page import="com.dimata.harisma.entity.attendance.AlStockTaken"%>
<%@page import="com.dimata.harisma.entity.attendance.PstAlStockTaken"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="com.dimata.qdep.db.DBHandler"%>
<%@page import="com.dimata.qdep.db.DBResultSet"%>
<%@page import="com.dimata.gui.jsp.ControlCombo"%>
<%@page import="com.dimata.harisma.session.leave.LeaveConfigBpd"%>
<%@page import="com.dimata.harisma.entity.leave.LeaveApplication"%>
<%@page import="com.dimata.harisma.entity.leave.PstLeaveApplication"%>
<%@ include file = "../../main/javainit.jsp" %>
<%  int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_EMPLOYEE, AppObjInfo.G2_LEAVE_APPLICATION, AppObjInfo.OBJ_LEAVE_APPLICATION);%>
<%@ include file = "../../main/checkuser.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%!
    public long divisionId = 0;
    public String[] leaveType = {
        "Cuti Khusus", "Cuti Hamil", "Cuti Penting", "Cuti Tahunan", "Cuti Besar"
    };
    public int convertInteger(double val){
        BigDecimal bDecimal = new BigDecimal(val);
        bDecimal = bDecimal.setScale(0, RoundingMode.HALF_UP);
        return bDecimal.intValue();
    }
    /*
SELECT hr_employee.POSITION_ID FROM hr_employee
WHERE hr_employee.EMPLOYEE_ID=101306; //get position id //

SELECT * FROM hr_mapping_position
WHERE hr_mapping_position.TYPE_OF_LINK=3 AND hr_mapping_position.DOWN_POSITION_ID=504404619213373526; // get up position id //

SELECT hr_position.POSITION_ID, hr_position.POSITION, hr_employee.EMPLOYEE_ID, hr_employee.FULL_NAME
FROM hr_position 
INNER JOIN hr_employee ON hr_employee.POSITION_ID=hr_position.POSITION_ID
WHERE hr_position.POSITION_ID=1784659104; // get employee id //
    */
    public long getPositionIdByEmpId(long employeeId) {
        long positionId = 0;
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT hr_employee.POSITION_ID, hr_employee.DIVISION_ID FROM hr_employee ";
            sql += " WHERE hr_employee.EMPLOYEE_ID="+employeeId;
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                positionId = rs.getLong(PstEmployee.fieldNames[PstEmployee.FLD_POSITION_ID]);
                divisionId = rs.getLong(PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID]);
            }
            rs.close();
            return positionId;
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return positionId;
    }

    public long getUpPositionId(long positionId) {
        long upPositionId = 0;
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT * FROM hr_mapping_position ";
            sql += " WHERE hr_mapping_position.TYPE_OF_LINK=3 AND ";
            sql += " hr_mapping_position.DOWN_POSITION_ID="+positionId;
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                upPositionId = rs.getLong(PstMappingPosition.fieldNames[PstMappingPosition.FLD_UP_POSITION_ID]);
            }
            rs.close();
            return upPositionId;
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return upPositionId;
    }

    public long getEmpIdByPositionId(long positionId) {
        Vector listEmp = new Vector();
        DBResultSet dbrs = null;
        long empId = 0;
        long empTemp = 0;
        try {
            String sql = "SELECT hr_position.POSITION_ID, hr_position.POSITION, ";
            sql += " hr_employee.EMPLOYEE_ID, hr_employee.FULL_NAME, hr_employee.DIVISION_ID ";
            sql += " FROM hr_position ";
            sql += " INNER JOIN hr_employee ON hr_employee.POSITION_ID=hr_position.POSITION_ID ";
            sql += " WHERE hr_position.POSITION_ID="+positionId;
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                if (rs.getLong(PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID])==divisionId){
                    empId = rs.getLong(PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID]);
                } else {
                    empTemp = rs.getLong(PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID]);
                }
            }
            if (empId == 0 && empTemp != 0){
                empId = empTemp;
            }
            rs.close();
            
            return empId;
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return empId;
    }

/*
public String getApproval(long empId, int inc){
    String str = "a";
    if (empId != 0 && inc < 6){
        long posId = getPositionIdByEmpId(empId);
        long upPosId = getUpPositionId(posId);
        long employeId = getEmpIdByPositionId(upPosId);
        if (employeId != 0){
            int loop = inc;
            loop++;
            str = "("+employeId+") "+ getApproval(employeId, loop);
        }
    }

    return str;
}
*/

    public String getApproval(long empId, int inc, long leaveAppId, long userLoggin){
        String str = "";
        LeaveApplication leaveApplication = new LeaveApplication();
        int fieldApp = 0;
        try {
            leaveApplication = PstLeaveApplication.fetchExc(leaveAppId);
            fieldApp = getFieldApproval(leaveApplication.getApproval_1(), 
            leaveApplication.getApproval_2(), leaveApplication.getApproval_3(), 
            leaveApplication.getApproval_4(), leaveApplication.getApproval_5(), 
            leaveApplication.getApproval_6());
        } catch(Exception e){
            System.out.println(e.toString());
        }
        if (empId != 0 && inc < 6){
            long posId = getPositionIdByEmpId(empId);
            long upPosId = getUpPositionId(posId);
            long employeeId = getEmpIdByPositionId(upPosId);
            if (employeeId != 0){
                int loop = inc;
                loop++;
                if (employeeId != userLoggin){
                    //getApproval(employeeId, loop, leaveAppId, userLoggin);
                    str = "<a class=\"btn-grey\" style=\"color:#FFF\" href=\"javascript:cmdViewApproval('"+leaveAppId+"')\">View</a>";
                } else {
                    /* Jika employeeId == useLoggin */
                    if (leaveApplication.getOID() != 0){
                        if (leaveApplication.getApproval_1() == userLoggin 
                        || leaveApplication.getApproval_2() == userLoggin 
                        || leaveApplication.getApproval_3() == userLoggin
                        || leaveApplication.getApproval_4() == userLoggin
                        || leaveApplication.getApproval_5() == userLoggin
                        || leaveApplication.getApproval_6() == userLoggin){
                            str = "<a class=\"btn-grey\" style=\"color:#FFF\" href=\"javascript:cmdViewApproval('"+leaveAppId+"')\">View</a>";
                        } else {
                            int check = checkNextApproval(userLoggin);
                            str = "<a class=\"btn-green\" style=\"color:#38a109\" href=\"javascript:cmdApprove('"+userLoggin+"','"+leaveAppId+"','"+fieldApp+"','"+check+"')\">Approve</a>";
                        }
                    }
                }
            } else {
                /* jika up position ada (top link) dan employee == 0*/
                upPosId = getUpPositionId(upPosId);
                employeeId = getEmpIdByPositionId(upPosId);
                if (employeeId == userLoggin){
                    str = "<a class=\"btn-green\" style=\"color:#38a109\" href=\"javascript:cmdApprove('"+userLoggin+"','"+leaveAppId+"','"+fieldApp+"','2')\">Approve</a>";
                } else {
                    str = "<a class=\"btn-grey\" style=\"color:#FFF\" href=\"javascript:cmdViewApproval('"+leaveAppId+"')\">View</a>";
                }
            }
        }
        
        return str;
    }

    public int getFieldApproval(long approval1, long approval2, long approval3, long approval4, long approval5, long approval6){
        int fieldApp = 0;
        if (approval1 == 0 
        & approval2 == 0 
        & approval3 == 0
        & approval4 == 0
        & approval5 == 0
        & approval6 == 0){
            fieldApp = 1;
        }
        if (approval1 != 0 
        & approval2 == 0 
        & approval3 == 0
        & approval4 == 0
        & approval5 == 0
        & approval6 == 0){
            fieldApp = 2;
        }
        if (approval1 != 0 
        & approval2 != 0 
        & approval3 == 0
        & approval4 == 0
        & approval5 == 0
        & approval6 == 0){
            fieldApp = 3;
        }
        if (approval1 != 0 
        & approval2 != 0 
        & approval3 != 0
        & approval4 == 0
        & approval5 == 0
        & approval6 == 0){
            fieldApp = 4;
        }
        if (approval1 != 0 
        & approval2 != 0 
        & approval3 != 0
        & approval4 != 0
        & approval5 == 0
        & approval6 == 0){
            fieldApp = 5;
        }
        if (approval1 != 0 
        & approval2 != 0 
        & approval3 != 0
        & approval4 != 0
        & approval5 != 0
        & approval6 == 0){
            fieldApp = 6;
        }
        return fieldApp;
    }

    public long checkTopLink(long positionId) {
        DBResultSet dbrs = null;
        long empId = 0;
        try {
            String sql = "SELECT hr_position.POSITION_ID, hr_position.POSITION, ";
            sql += " hr_employee.EMPLOYEE_ID, hr_employee.FULL_NAME, hr_employee.DIVISION_ID ";
            sql += " FROM hr_position ";
            sql += " INNER JOIN hr_employee ON hr_employee.POSITION_ID=hr_position.POSITION_ID ";
            sql += " WHERE hr_position.POSITION_ID="+positionId;
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                if (rs.getLong(PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID])==divisionId){
                    empId = rs.getLong(PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID]);
                } 
            }
            rs.close();
            return empId;
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return empId;
    }

    public int checkNextApproval(long empId){
        int status = 0;
        boolean check = false;
        if (empId != 0){
            long posId = getPositionIdByEmpId(empId);
            long upPosId = getUpPositionId(posId);
            check = checkPositionDivision(upPosId);
            long employeeId = checkTopLink(upPosId);
            if (employeeId != 0){
                status = 1;
            } else {
                if (check){
                    status = 1;
                } else {
                    upPosId = getUpPositionId(upPosId);
                    employeeId = getEmpIdByPositionId(upPosId);
                    if (employeeId != 0){
                        status = 2;
                    }
                }
            }
        }

        return status;
    }

    public boolean checkPositionDivision(long positionId){
        boolean status = false;
        DBResultSet dbrs = null;
        long posDivId = 0;
        try {
            String sql = "SELECT * FROM hr_position_division WHERE position_id="+positionId;
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                posDivId = rs.getLong(PstPositionDivision.fieldNames[PstPositionDivision.FLD_DIVISION_ID]);
            }
            rs.close();
            if (posDivId == divisionId){
                status = true;
            }
            return status;
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return status;
    }
%>
<%
    Vector leaveAppList = new Vector();
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    int iCommand = FRMQueryString.requestCommand(request);
    long employeeId = FRMQueryString.requestLong(request, "employee_id");
    long leaveId = FRMQueryString.requestLong(request, "leave_id");
    int fieldApp = FRMQueryString.requestInt(request, "field_approval");
    int checkApproval = FRMQueryString.requestInt(request, "check_approval");
    
    if (iCommand == Command.APPROVE){
        try {
            String oidFieldApp = "";
            String dateFieldApp = "";
            Date now = new Date();
            String dateNow = sdf.format(now);
            switch(fieldApp){
                case 1: 
                    oidFieldApp = "approval_1";
                    dateFieldApp = "approval_1_date";
                    break;
                case 2: 
                    oidFieldApp = "approval_2";
                    dateFieldApp = "approval_2_date";
                    break;
                case 3: 
                    oidFieldApp = "approval_3";
                    dateFieldApp = "approval_3_date";
                    break;
                case 4: 
                    oidFieldApp = "approval_4";
                    dateFieldApp = "approval_4_date";
                    break;
                case 5: 
                    oidFieldApp = "approval_5";
                    dateFieldApp = "approval_5_date";
                    break;
                case 6: 
                    oidFieldApp = "approval_6";
                    dateFieldApp = "approval_6_date";
                    break;
            }
            String sql = "UPDATE hr_leave_application SET "+oidFieldApp+"="+employeeId+", "+dateFieldApp+"='"+dateNow+"'";
            if (checkApproval != 1){
                sql += ", doc_status=2 ";
            }
            sql += " WHERE leave_application_id="+leaveId;
            DBHandler.execUpdate(sql);
        } catch(Exception e){
            System.out.println(e.toString());
        }
    }
    /* get data leave application status to be approve */
    leaveAppList = PstLeaveApplication.listLeaveAppEmp("");
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Leave Approve</title>
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
                background-color: #b0f991;
                border-radius: 3px;
                font-family: Arial;
                color: #EEE;
                font-size: 11px;
                padding: 3px 5px;
                text-decoration: none;
            }

            .btn-green:hover {
                color: #FFF;
                background-color: #83ef53;
                text-decoration: none;
            }
            
            .btn-red {
                background-color: #ff9999;
                border-radius: 3px;
                font-family: Arial;
                color: #EEE;
                font-size: 11px;
                padding: 3px 5px;
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
                font-size: 11px;
                padding: 3px 5px;
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
            
            #caption, .caption {
                font-size: 12px;
                color: #474747;
                font-weight: bold;
                padding: 2px 0px 3px 0px;
            }
            #divinput, .divinput {
                margin-bottom: 5px;
                padding-bottom: 5px;
            }
            .item {
                background-color: #FFF;
                padding: 9px;
                margin: 9px 15px;
            }
        </style>
        <script type="text/javascript">
            function cmdApprove(empApproved, oidLeaveApp, fieldApproval, checkApp){
                document.frm.command.value="<%= Command.APPROVE %>";
                document.frm.employee_id.value=empApproved;
                document.frm.leave_id.value=oidLeaveApp;
                document.frm.field_approval.value=fieldApproval;
                document.frm.check_approval.value=checkApp;
                document.frm.action="leave_approve.jsp";
                document.frm.submit();
            }
            function cmdViewApproval(leaveId){
                newWindow=window.open("view_approval.jsp?leave_id="+leaveId,"ViewApproval", "height=400, width=500, status=yes, toolbar=no, menubar=no, location=center, scrollbars=yes");
                newWindow.focus();
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
            <span id="menu_title">Approve Cuti</span>
        </div>
        <div class="content-main">
            <form name="frm" method="post" action="">
                <!-- input pendukung -->
                <input type="hidden" name="command" value="">
                <input type="hidden" name="employee_id" value="">
                <input type="hidden" name="leave_id" value="">
                <input type="hidden" name="field_approval" value="">
                <input type="hidden" name="check_approval" value="">
                <table class="tblStyle">
                    <tr>
                        <td class="title_tbl" colspan="11">
                            <h2>Tabel Daftar To Be Approve</h2>
                            <!--Ada 3 orang yang membutuhkan approve dari Anda. <a href="javascript:cmdApproveAll()">Lakukan Approve</a>-->
                        </td>
                    </tr>
                    <tr>
                        <!--<td class="title_tbl">&nbsp;</td>-->
                        <td class="title_tbl">No</td>
                        <td class="title_tbl">NRK</td>
                        <td class="title_tbl">Nama</td>
                        <td class="title_tbl">Tgl Pengajuan</td>
                        <td class="title_tbl">Tgl Cuti</td>
                        <td class="title_tbl">Tgl Berakhir</td>
                        <td class="title_tbl">Qty</td>
                        <td class="title_tbl">Jenis Cuti</td>
                        <td class="title_tbl">Alasan</td>
                        <td class="title_tbl">Action</td>
                    </tr>
                    <%
                        if (leaveAppList != null && leaveAppList.size()>0){
                            for (int i=0; i<leaveAppList.size(); i++){
                                String[] data = (String[])leaveAppList.get(i);
                                String startCuti = "";
                                String endCuti = "";
                                int qtyCuti = 0;
                                String where = PstAlStockTaken.fieldNames[PstAlStockTaken.FLD_LEAVE_APPLICATION_ID]+"="+data[0];
                                Vector listALStockTaken = PstAlStockTaken.list(0, 0, where, "");
                                if (listALStockTaken != null && listALStockTaken.size()>0){
                                    AlStockTaken alStockTaken = (AlStockTaken)listALStockTaken.get(0);
                                    startCuti = sdf.format(alStockTaken.getTakenDate());
                                    endCuti = sdf.format(alStockTaken.getTakenFinnishDate());
                                    qtyCuti = convertInteger(alStockTaken.getTakenQty());
                                } else {
                                    where = PstLlStockTaken.fieldNames[PstLlStockTaken.FLD_LEAVE_APPLICATION_ID]+"="+data[0];
                                    Vector listLlStockTaken = PstLlStockTaken.list(0, 0, where, "");
                                    if (listLlStockTaken != null && listLlStockTaken.size()>0){
                                        LlStockTaken llStockTaken = (LlStockTaken)listLlStockTaken.get(0);
                                        startCuti = sdf.format(llStockTaken.getTakenDate());
                                        endCuti = sdf.format(llStockTaken.getTakenFinnishDate());
                                        qtyCuti = convertInteger(llStockTaken.getTakenQty());
                                    }
                                }
                                long oidEmp = 0;
                                if (data[7].equals("0")
                                & data[8].equals("0")
                                & data[9].equals("0")
                                & data[10].equals("0")
                                & data[11].equals("0")
                                & data[12].equals("0")){
                                    oidEmp = Long.valueOf(data[6]);
                                }
                                if (!data[7].equals("0")
                                & data[8].equals("0")
                                & data[9].equals("0")
                                & data[10].equals("0")
                                & data[11].equals("0")
                                & data[12].equals("0")){
                                    oidEmp = Long.valueOf(data[7]);
                                }
                                if (!data[7].equals("0")
                                & !data[8].equals("0")
                                & data[9].equals("0")
                                & data[10].equals("0")
                                & data[11].equals("0")
                                & data[12].equals("0")){
                                    oidEmp = Long.valueOf(data[8]);
                                }
                                if (!data[7].equals("0")
                                & !data[8].equals("0")
                                & !data[9].equals("0")
                                & data[10].equals("0")
                                & data[11].equals("0")
                                & data[12].equals("0")){
                                    oidEmp = Long.valueOf(data[9]);
                                }
                                if (!data[7].equals("0")
                                & !data[8].equals("0")
                                & !data[9].equals("0")
                                & !data[10].equals("0")
                                & data[11].equals("0")
                                & data[12].equals("0")){
                                    oidEmp = Long.valueOf(data[10]);
                                }
                                if (!data[7].equals("0")
                                & !data[8].equals("0")
                                & !data[9].equals("0")
                                & !data[10].equals("0")
                                & !data[11].equals("0")
                                & data[12].equals("0")){
                                    oidEmp = Long.valueOf(data[11]);
                                }
                                %>
                                <tr>
                                    <!--<td style="background-color: #FFF;"><input type="checkbox" name="chx" value="" /></td>-->
                                    <td style="background-color: #FFF;"><%= (i+1) %></td>
                                    <td style="background-color: #FFF;"><%= data[3] %></td>
                                    <td style="background-color: #FFF;"><%= data[4] %></td>
                                    <td style="background-color: #FFF;"><%= data[5] %></td>
                                    <td style="background-color: #FFF;"><%= startCuti %></td>
                                    <td style="background-color: #FFF;"><%= endCuti %></td>
                                    <td style="background-color: #FFF;"><%= qtyCuti %></td>
                                    <td style="background-color: #FFF;"><%= leaveType[Integer.valueOf(data[1])]  %></td>
                                    <td style="background-color: #FFF;"><%= data[2] %></td>
                                    <td style="background-color: #FFF;">
                                        <%= getApproval(oidEmp, 0, Long.valueOf(data[0]), emplx.getOID()) %>
                                        <a class="btn-red" style="color:#FFF" href="javascript:cmdDecline()">Decline</a>
                                    </td>
                                </tr>
                                <%
                            }
                        }
                    %>
                </table>
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

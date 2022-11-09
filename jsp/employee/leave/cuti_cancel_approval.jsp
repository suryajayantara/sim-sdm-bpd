<%-- 
    Document   : cuti_cancel_approval
    Created on : 21-Mar-2017, 11:52:54
    Author     : Gunadi
--%>


<%@page import="com.dimata.harisma.entity.leave.SpecialUnpaidLeaveTaken"%>
<%@page import="com.dimata.harisma.entity.leave.PstSpecialUnpaidLeaveTaken"%>
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
    public void doUpdateLeaveApp(long oid) {
        DBResultSet dbrs = null;
        try {
            String sql = "UPDATE hr_leave_application SET doc_status="+PstLeaveApplication.FLD_STATUS_APPlICATION_CANCELED;
            sql += " WHERE leave_application_id="+oid;
            DBHandler.updateParsial(sql);
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
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
        doUpdateLeaveApp(leaveId);
    }
    /* get data leave application status to be approve */
    String whereClause = PstLeaveApplication.getToBeCancelNotifFilter(emplx.getOID());
    if (whereClause.length()>0){
        whereClause = "hr_leave_application.LEAVE_APPLICATION_ID IN(" + whereClause.substring(0, whereClause.length()-1) + ")";
    }
    leaveAppList = PstLeaveApplication.listLeaveAppEmpCancel(whereClause);
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
            .box-message {
                background-color: #FFF;
                border: 1px solid #DDD;
                border-radius: 5px;
                padding: 21px;
                margin-bottom: 12px;
            }
        </style>
        <script type="text/javascript">
            function cmdApprove(oidLeaveApp){
                document.frm.command.value="<%= Command.APPROVE %>";
                document.frm.leave_id.value=oidLeaveApp;
                document.frm.action="cuti_cancel_approval.jsp";
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
                <%
                    if (leaveAppList != null && leaveAppList.size()>0){
                %>
                <table class="tblStyle">
                    
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
                            long scheduleSymbol = 0;
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
                                    } else {
                                        where = PstSpecialUnpaidLeaveTaken.fieldNames[PstSpecialUnpaidLeaveTaken.FLD_LEAVE_APLICATION_ID]+"="+data[0];
                                        Vector listSlStockTaken = PstSpecialUnpaidLeaveTaken.list(0, 0, where, "");
                                        if (listSlStockTaken != null && listSlStockTaken.size()>0){
                                            SpecialUnpaidLeaveTaken slStockTaken = (SpecialUnpaidLeaveTaken)listSlStockTaken.get(0);
                                            scheduleSymbol = slStockTaken.getScheduledId();
                                            startCuti = sdf.format(slStockTaken.getTakenDate());
                                            endCuti = sdf.format(slStockTaken.getTakenFinnishDate());
                                            qtyCuti = convertInteger(slStockTaken.getTakenQty());
                                        }
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
                                    <%
                                    if (Integer.valueOf(data[1]) != 0){
                                    %>
                                    <td style="background-color: #FFF;"><%= leaveType[Integer.valueOf(data[1])]  %></td>
                                    <%
                                        } else {
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
                                    <td style="background-color: #FFF;"><%= data[2] %></td>
                                    <td style="background-color: #FFF;">
                                        <a class="btn-green" style="color:#38a109" href="javascript:cmdApprove('<%=data[0]%>')">Approve</a>
                                    </td>
                                </tr>
                                <%
                            }
                        
                    %>
                </table>
                    <%
                        } else {
                    %>
                    <h3><strong>No Data</strong></h3>
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
    </body>
</html>
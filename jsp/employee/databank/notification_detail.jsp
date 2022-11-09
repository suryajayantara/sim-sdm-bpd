<%-- 
    Document   : end_contract
    Created on : Jun 24, 2020, 9:50:33 AM
    Author     : Utk
--%>

<%@page import="com.dimata.util.DateCalc"%>
<%@page import="com.dimata.harisma.entity.leave.I_Leave"%>
<%@page import="com.dimata.harisma.entity.leave.PstMessageEmp"%>
<%@page import="com.dimata.harisma.entity.leave.MessageEmp"%>
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
<%  //int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_EMPLOYEE, AppObjInfo.G2_LEAVE_APPLICATION, AppObjInfo.OBJ_LEAVE_APPLICATION);%>
<%//@ include file = "../../main/checkuser.jsp" %>
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
    Vector leaveAppList = new Vector();
    SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
    int iCommand = FRMQueryString.requestCommand(request);
    long notifId = FRMQueryString.requestLong(request, "notifId");
    long userid = FRMQueryString.requestLong(request, "userid");
    String message = FRMQueryString.requestString(request, "message");

   
    /* get data end contrct by lenght day from master notification */
    Vector records = new Vector();
    Notification nf= new Notification();
    try{
        nf= PstNotification.fetchExc(notifId);
        switch (nf.getNotificationType()){
            case PstNotification.NOTIF_KARYAWAN_HABIS_KONTRAK:
                int lenghtDay = PstNotification.checkLenghtNotifByUser(userid,PstNotification.NOTIF_KARYAWAN_HABIS_KONTRAK, nf.getOID());
                String inDivision = PstNotification.getUserDivisionMap(PstNotification.NOTIF_KARYAWAN_HABIS_KONTRAK, nf.getOID());
                String whereClauseEndContract = " "+PstEmployee.fieldNames[PstEmployee.FLD_END_CONTRACT]+" BETWEEN DATE_FORMAT(NOW(), '%Y-%m-%e') AND "+
                        "DATE_ADD(DATE_FORMAT(NOW(), '%Y-%m-%e'), INTERVAL "+lenghtDay+" DAY)"+
                        " AND "+PstEmployee.fieldNames[PstEmployee.FLD_RESIGNED]+" = "+PstEmployee.ACTIVE;
                if (inDivision.length()>0){
                    whereClauseEndContract += " AND "+PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID]+" IN ("+inDivision+")";
                }
                records = PstEmployee.list(0,0,whereClauseEndContract,"");
                break;
            case PstNotification.NOTIF_PENGHARAGAAN_KARYAWAN:
                lenghtDay = PstNotification.checkLenghtNotifByUser(userid,PstNotification.NOTIF_PENGHARAGAAN_KARYAWAN, nf.getOID());
                int year = PstNotification.checkSpecialCaseNotifByUser(userid,PstNotification.NOTIF_PENGHARAGAAN_KARYAWAN, nf.getOID());
                inDivision = PstNotification.getUserDivisionMap(PstNotification.NOTIF_PENGHARAGAAN_KARYAWAN, nf.getOID());
                String whereClause = " TIMESTAMPDIFF(YEAR,"+PstEmployee.fieldNames[PstEmployee.FLD_COMMENCING_DATE]+",DATE_ADD(DATE_FORMAT(NOW(), '%Y-%m-%e'), INTERVAL "+lenghtDay+" DAY)) = "+year+
                        " AND DATE_ADD("+PstEmployee.fieldNames[PstEmployee.FLD_COMMENCING_DATE]+", INTERVAL "+year+" YEAR) BETWEEN NOW() AND DATE_ADD(DATE_FORMAT(NOW(), '%Y-%m-%e'),INTERVAL "+lenghtDay+" DAY)"+
                        " AND "+PstEmployee.fieldNames[PstEmployee.FLD_RESIGNED]+" = "+PstEmployee.ACTIVE;
                if (inDivision.length()>0){
                    whereClause += " AND "+PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID]+" IN ("+inDivision+")";
                }
                records = PstEmployee.list(0,0,whereClause,"");
                break;
            case PstNotification.NOTIF_KARYAWAN_MBT:
                lenghtDay = PstNotification.checkLenghtNotifByUser(userid,PstNotification.NOTIF_KARYAWAN_MBT, nf.getOID());
                year = PstNotification.checkSpecialCaseNotifByUser(userid,PstNotification.NOTIF_KARYAWAN_MBT, nf.getOID());
                inDivision = PstNotification.getUserDivisionMap(PstNotification.NOTIF_KARYAWAN_MBT, nf.getOID());
                whereClause = " TIMESTAMPDIFF(YEAR,"+PstEmployee.fieldNames[PstEmployee.FLD_BIRTH_DATE]+",DATE_ADD(DATE_FORMAT(NOW(), '%Y-%m-%e'), INTERVAL "+lenghtDay+" DAY)) = "+year+
                        " AND "+PstEmployee.fieldNames[PstEmployee.FLD_RESIGNED]+" = "+PstEmployee.ACTIVE;
                if (inDivision.length()>0){
                    whereClause += " AND "+PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID]+" IN ("+inDivision+")";
                }
                records = PstEmployee.list(0,0,whereClause,"");
                break;
            case PstNotification.NOTIF_KARYAWAN_PENSIUN:
                lenghtDay = PstNotification.checkLenghtNotifByUser(userid,PstNotification.NOTIF_KARYAWAN_PENSIUN, nf.getOID());
                year = PstNotification.checkSpecialCaseNotifByUser(userid,PstNotification.NOTIF_KARYAWAN_PENSIUN, nf.getOID());
                inDivision = PstNotification.getUserDivisionMap(PstNotification.NOTIF_KARYAWAN_PENSIUN, nf.getOID());
                whereClause = " TIMESTAMPDIFF(YEAR,"+PstEmployee.fieldNames[PstEmployee.FLD_BIRTH_DATE]+",DATE_ADD(DATE_FORMAT(NOW(), '%Y-%m-%e'), INTERVAL "+lenghtDay+" DAY)) = "+year+
                        " AND "+PstEmployee.fieldNames[PstEmployee.FLD_RESIGNED]+" = "+PstEmployee.ACTIVE;
                if (inDivision.length()>0){
                    whereClause += " AND "+PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID]+" IN ("+inDivision+")";
                }
                records = PstEmployee.list(0,0,whereClause,"");
                break;
            case PstNotification.NOTIF_ULANG_TAHUN_KARYAWAN:
                lenghtDay = PstNotification.checkLenghtNotifByUser(userid,PstNotification.NOTIF_ULANG_TAHUN_KARYAWAN, nf.getOID());
                inDivision = PstNotification.getUserDivisionMap(PstNotification.NOTIF_ULANG_TAHUN_KARYAWAN, nf.getOID());
                whereClause = " DATE_FORMAT("+PstEmployee.fieldNames[PstEmployee.FLD_BIRTH_DATE]+", '%m-%e') BETWEEN DATE_FORMAT(NOW(), '%m-%e') AND "+
                        "DATE_FORMAT(DATE_ADD(NOW(), INTERVAL "+lenghtDay+" DAY), '%m-%e')"+
                        " AND "+PstEmployee.fieldNames[PstEmployee.FLD_RESIGNED]+" = "+PstEmployee.ACTIVE;
                if (inDivision.length()>0){
                    whereClause += " AND "+PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID]+" IN ("+inDivision+")";
                }
                records = PstEmployee.list(0,0,whereClause,"");
                break;
            case PstNotification.NOTIF_KARYAWAN_PEJABAT_SEMENTARA:
                lenghtDay = PstNotification.checkLenghtNotifByUser(userid,PstNotification.NOTIF_KARYAWAN_PEJABAT_SEMENTARA, nf.getOID());
                year = PstNotification.checkSpecialCaseNotifByUser(userid,PstNotification.NOTIF_KARYAWAN_PEJABAT_SEMENTARA, nf.getOID());
                inDivision = PstNotification.getUserDivisionMap(PstNotification.NOTIF_KARYAWAN_PEJABAT_SEMENTARA, nf.getOID());
                whereClause = " TIMESTAMPDIFF(MONTH,"+PstCareerPath.fieldNames[PstCareerPath.FLD_WORK_FROM]+",DATE_ADD(DATE_FORMAT(NOW(), '%Y-%m-%e'), INTERVAL "+lenghtDay+" DAY)) = "+year+
                        " AND "+PstCareerPath.fieldNames[PstCareerPath.FLD_WORK_HISTORY_NOW_ID]+" = 0 AND "+PstCareerPath.fieldNames[PstCareerPath.FLD_HISTORY_TYPE]+"= 1";
                if (inDivision.length()>0){
                    whereClause += " AND "+PstCareerPath.fieldNames[PstCareerPath.FLD_DIVISION_ID]+" IN ("+inDivision+")";
                }
                records = PstCareerPath.listView(0,0,whereClause,"");
                break;
            case PstNotification.NOTIF_KARYAWAN_LAMA_PADA_JABATAN_TERTENTU:
                lenghtDay = PstNotification.checkLenghtNotifByUser(userid,PstNotification.NOTIF_KARYAWAN_LAMA_PADA_JABATAN_TERTENTU, nf.getOID());
                year = PstNotification.checkSpecialCaseNotifByUser(userid,PstNotification.NOTIF_KARYAWAN_LAMA_PADA_JABATAN_TERTENTU, nf.getOID());
                inDivision = PstNotification.getUserDivisionMap(PstNotification.NOTIF_KARYAWAN_LAMA_PADA_JABATAN_TERTENTU, nf.getOID());
                whereClause = " TIMESTAMPDIFF(YEAR,"+PstCareerPath.fieldNames[PstCareerPath.FLD_WORK_FROM]+",DATE_ADD(DATE_FORMAT(NOW(), '%Y-%m-%e'), INTERVAL "+lenghtDay+" DAY)) >= "+year+
                        " AND "+PstEmployee.fieldNames[PstEmployee.FLD_RESIGNED]+" = "+PstEmployee.ACTIVE;
                records = PstCareerPath.getlistEmpPerMasaJabatan(year,inDivision);
                break;
            case PstNotification.NOTIF_BEARKHIRNYA_SERTIFIKASI:
                lenghtDay = PstNotification.checkLenghtNotifByUser(userid,PstNotification.NOTIF_BEARKHIRNYA_SERTIFIKASI, nf.getOID());
                records  = (Vector) PstTrainingHistory.listNotifTrainingHistory(lenghtDay);
                break;
            case PstNotification.NOTIF_CUTI_TAHUNAN_ATAU_CUTI_BESAR:
                lenghtDay = PstNotification.checkLenghtNotifByUser(userid,PstNotification.NOTIF_CUTI_TAHUNAN_ATAU_CUTI_BESAR, nf.getOID());
                inDivision = PstNotification.getUserDivisionMap(PstNotification.NOTIF_CUTI_TAHUNAN_ATAU_CUTI_BESAR, nf.getOID());
                whereClause = "lv.`TYPE_LEAVE_CATEGORY` IN (3,4,1) "
                        + " AND ((tk.`TAKEN_DATE` BETWEEN DATE_FORMAT(NOW(), '%Y-%m-%e') AND DATE_ADD(DATE_FORMAT(NOW(), '%Y-%m-%e'), INTERVAL "+lenghtDay+" DAY)) OR "
                        + " (ll.`TAKEN_DATE` BETWEEN DATE_FORMAT(NOW(), '%Y-%m-%e') AND DATE_ADD(DATE_FORMAT(NOW(), '%Y-%m-%e'), INTERVAL "+lenghtDay+" DAY)))"
                        + " AND lv.DOC_STATUS IN (1,2,3) AND doc.`LEAVE_APPLICATION_ID` IS NULL";
                if (inDivision.length()>0){
                    whereClause += " AND emp."+PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID]+" IN ("+inDivision+")";
                }
                records = PstLeaveApplication.listJoin(0,0,whereClause,"");
                break;
            case PstNotification.NOTIF_STOK_CUTI_MINUS:
                inDivision = PstNotification.getUserDivisionMap(PstNotification.NOTIF_STOK_CUTI_MINUS, nf.getOID());
                whereClause = "";
                if (inDivision.length()>0){
                    whereClause += " AND emp."+PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID]+" IN ("+inDivision+")";
                }
                records = PstNotification.listEmpStockMinus(whereClause);
                break;
            case PstNotification.NOTIF_VALID_UNTIL_WARNING:
                lenghtDay = PstNotification.checkLenghtNotifByUser(userid,PstNotification.NOTIF_VALID_UNTIL_WARNING, nf.getOID());
                inDivision = PstNotification.getUserDivisionMap(PstNotification.NOTIF_VALID_UNTIL_WARNING, nf.getOID());
                whereClause = " warn.`VALID_UNTIL` BETWEEN   CURDATE()  AND (CURDATE()+INTERVAL "+lenghtDay+" DAY) ";
                if (inDivision.length()>0){
                    whereClause += " AND emp."+PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID]+" IN ("+inDivision+")";
                }
                records = PstNotification.listEmpWarningNotif(whereClause);
                break;
            case PstNotification.NOTIF_VALID_UNTIL_REPRIMAND:
                lenghtDay = PstNotification.checkLenghtNotifByUser(userid,PstNotification.NOTIF_VALID_UNTIL_REPRIMAND, nf.getOID());
                inDivision = PstNotification.getUserDivisionMap(PstNotification.NOTIF_VALID_UNTIL_REPRIMAND, nf.getOID());
                whereClause = " reprimand.`VALID_UNTIL` BETWEEN   CURDATE()  AND (CURDATE()+INTERVAL "+lenghtDay+" DAY) ";
                if (inDivision.length()>0){
                    whereClause += " AND emp."+PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID]+" IN ("+inDivision+")";
                }
                records = PstNotification.listEmpReprimandNotif(whereClause);
                break;
        }
    }catch(Exception exc){
        System.out.println("err get List End Contract :"+exc);
    }  
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Notif End Contract</title>
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
         function cmdDetail(oid){
		document.frm.employee_oid.value=oid;
		document.frm.command.value="<%=Command.EDIT%>";
		document.frm.prev_command.value="<%=Command.EDIT%>";
		document.frm.action="employee_edit.jsp";
		document.frm.submit();
	}
        function cmdExport(){
            window.open("export_excel/notification_excel.jsp?notifId=<%=notifId%>&userid=<%=userid%>");
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
            <% 
            switch (nf.getNotificationType()){
                case PstNotification.NOTIF_KARYAWAN_HABIS_KONTRAK:
                    %><span id="menu_title">Daftar Kontrak Berakhir</span> <%
                    break;
                case PstNotification.NOTIF_PENGHARAGAAN_KARYAWAN:
                    %><span id="menu_title">Daftar Penghargaan Masa Kerja</span> <%
                    break;
                case PstNotification.NOTIF_KARYAWAN_MBT:
                    %><span id="menu_title">Daftar Karyawan Memasuki MBT</span> <%
                    break;
                case PstNotification.NOTIF_KARYAWAN_PENSIUN:
                    %><span id="menu_title">Daftar Karyawan Memasuki Pensiun</span> <%
                    break;
                case PstNotification.NOTIF_ULANG_TAHUN_KARYAWAN:
                    %><span id="menu_title">Daftar Karyawan Ulang Tahun</span> <%
                    break;
                case PstNotification.NOTIF_KARYAWAN_PEJABAT_SEMENTARA:
                    %><span id="menu_title">Daftar Karyawan PJS</span> <%
                    break;
                case PstNotification.NOTIF_KARYAWAN_LAMA_PADA_JABATAN_TERTENTU:
                    %><span id="menu_title">Daftar Karyawan Masa Jabatan</span> <%
                    break;
                case PstNotification.NOTIF_BEARKHIRNYA_SERTIFIKASI:
                    %><span id="menu_title">Daftar Karyawan Sertifikasi Berakhir</span> <%
                    break;
                case PstNotification.NOTIF_CUTI_TAHUNAN_ATAU_CUTI_BESAR:
                    %><span id="menu_title">Daftar Cuti Besar atau Tahunan</span> <%
                    break;
                case PstNotification.NOTIF_STOK_CUTI_MINUS:
                    %><span id="menu_title">Daftar Stok Cuti Minus</span> <%
                    break;
                case PstNotification.NOTIF_VALID_UNTIL_WARNING:
                    %><span id="menu_title">Daftar Berakhirnya Peringatan Karyawan </span> <%
                    break;
                case PstNotification.NOTIF_VALID_UNTIL_REPRIMAND:
                    %><span id="menu_title">Daftar Berakhirnya Teguran Karyawan</span> <%
                    break;
            }
            %>
        </div>
        <a href="javascript:cmdExport()" class="btn" style="color:#FFF; margin: 23px 23px 59px 23px;">Export XLS</a>
        <div class="content-main">
            <form name="frm" method="post" action="">
                <!-- input pendukung -->
                <input type="hidden" name="command" value="">
                <input type="hidden" name="prev_command" value="">
                <input type="hidden" name="employee_oid" value="">
                <input type="hidden" name="employee_rep" value="">
                <input type="hidden" name="leave_id" value="">
                <input type="hidden" name="field_approval" value="">
                <input type="hidden" name="check_approval" value="">
                <input type="hidden" name="notifId" value="<%=notifId%>">
                <input type="hidden" name="userid" value="<%=userid%>">
                
                <% 
                    if (records != null && records.size()>0){
                        switch (nf.getNotificationType()){
                            case PstNotification.NOTIF_KARYAWAN_HABIS_KONTRAK:
                                %>
                                <table class="tblStyle">
                                    <tr>
                                        <!--<td class="title_tbl">&nbsp;</td>-->
                                        <td class="title_tbl">No</td>
                                        <td class="title_tbl">NRK</td>
                                        <td class="title_tbl">Nama Lengkap</td>
                                        <td class="title_tbl">Satuan Kerja</td>
                                        <td class="title_tbl">Jabatan</td>
                                        <td class="title_tbl">Akhir Kontrak</td>
                                    </tr>
                                
                                <%
                                for (int i=0; i<records.size(); i++){
                                    Employee employee = (Employee) records.get(i);
                                    Division div = new Division();
                                    Position position = new Position();
                                    try {
                                        div = PstDivision.fetchExc(employee.getDivisionId());
                                        position = PstPosition.fetchExc(employee.getPositionId());
                                    } catch (Exception exc){}
                                    %>
                                        <tr>
                                            <!--<td style="background-color: #FFF;"><input type="checkbox" name="chx" value="" /></td>-->
                                            <td style="background-color: #FFF;"><%=i+1%></td>
                                            <td style="background-color: #FFF;"><%=employee.getEmployeeNum()%></td>
                                            <td style="background-color: #FFF;"><%=employee.getFullName()%></td>
                                            <td style="background-color: #FFF;"><%=div.getDivision()%></td>
                                            <td style="background-color: #FFF;"><%=position.getPosition()%></td>
                                            <td style="background-color: #FFF;"><%=Formater.formatDate(employee.getEnd_contract(),"dd MMM yyyy")%></td>
                                        </tr>
                                    <%
                                }
                              %>    
                              </table>
                                <%
                                break;
                            case PstNotification.NOTIF_PENGHARAGAAN_KARYAWAN:
                                %>
                                <table class="tblStyle">
                                    <tr>
                                        <!--<td class="title_tbl">&nbsp;</td>-->
                                        <td class="title_tbl">No</td>
                                        <td class="title_tbl">NRK</td>
                                        <td class="title_tbl">Nama Lengkap</td>
                                        <td class="title_tbl">Satuan Kerja</td>
                                        <td class="title_tbl">Jabatan</td>
                                        <td class="title_tbl">Mulai Bekerja</td>
                                        <td class="title_tbl">Masa Kerja</td>
                                    </tr>
                                
                                <%
                                for (int i=0; i<records.size(); i++){
                                    Employee employee = (Employee) records.get(i);
                                    Division div = new Division();
                                    Position position = new Position();
                                    try {
                                        div = PstDivision.fetchExc(employee.getDivisionId());
                                        position = PstPosition.fetchExc(employee.getPositionId());
                                    } catch (Exception exc){}
                                    
                                    int year = DateCalc.yearDiff(employee.getCommencingDate(), new Date());
                                    
                                    
                                    %>
                                        <tr>
                                            <!--<td style="background-color: #FFF;"><input type="checkbox" name="chx" value="" /></td>-->
                                            <td style="background-color: #FFF;"><%=i+1%></td>
                                            <td style="background-color: #FFF;"><%=employee.getEmployeeNum()%></td>
                                            <td style="background-color: #FFF;"><%=employee.getFullName()%></td>
                                            <td style="background-color: #FFF;"><%=div.getDivision()%></td>
                                            <td style="background-color: #FFF;"><%=position.getPosition()%></td>
                                            <td style="background-color: #FFF;"><%=Formater.formatDate(employee.getCommencingDate(),"dd MMM yyyy")%></td>
                                            <td style="background-color: #FFF;"><%=year%></td>
                                        </tr>
                                    <%
                                }
                              %>    
                              </table>
                                <%
                                break;
                            case PstNotification.NOTIF_KARYAWAN_MBT:
                                %>
                                <table class="tblStyle">
                                    <tr>
                                        <!--<td class="title_tbl">&nbsp;</td>-->
                                        <td class="title_tbl">No</td>
                                        <td class="title_tbl">NRK</td>
                                        <td class="title_tbl">Nama Lengkap</td>
                                        <td class="title_tbl">Satuan Kerja</td>
                                        <td class="title_tbl">Jabatan</td>
                                        <td class="title_tbl">Tanggal Lahir</td>
                                        <td class="title_tbl">Usia</td>
                                    </tr>
                                
                                <%
                                for (int i=0; i<records.size(); i++){
                                    Employee employee = (Employee) records.get(i);
                                    Division div = new Division();
                                    Position position = new Position();
                                    try {
                                        div = PstDivision.fetchExc(employee.getDivisionId());
                                        position = PstPosition.fetchExc(employee.getPositionId());
                                    } catch (Exception exc){}
                                    
                                    int year = DateCalc.yearDiff(employee.getBirthDate(), new Date());
                                    
                                    %>
                                        <tr>
                                            <!--<td style="background-color: #FFF;"><input type="checkbox" name="chx" value="" /></td>-->
                                            <td style="background-color: #FFF;"><%=i+1%></td>
                                            <td style="background-color: #FFF;"><%=employee.getEmployeeNum()%></td>
                                            <td style="background-color: #FFF;"><%=employee.getFullName()%></td>
                                            <td style="background-color: #FFF;"><%=div.getDivision()%></td>
                                            <td style="background-color: #FFF;"><%=position.getPosition()%></td>
                                            <td style="background-color: #FFF;"><%=Formater.formatDate(employee.getBirthDate(),"dd MMM yyyy")%></td>
                                            <td style="background-color: #FFF;"><%=year%></td>
                                        </tr>
                                    <%
                                }
                              %>    
                              </table>
                                <%
                                break;
                            case PstNotification.NOTIF_KARYAWAN_PENSIUN:
                                %>
                                <table class="tblStyle">
                                    <tr>
                                        <!--<td class="title_tbl">&nbsp;</td>-->
                                        <td class="title_tbl">No</td>
                                        <td class="title_tbl">NRK</td>
                                        <td class="title_tbl">Nama Lengkap</td>
                                        <td class="title_tbl">Satuan Kerja</td>
                                        <td class="title_tbl">Jabatan</td>
                                        <td class="title_tbl">Tanggal Lahir</td>
                                        <td class="title_tbl">Usia</td>
                                    </tr>
                                
                                <%
                                for (int i=0; i<records.size(); i++){
                                    Employee employee = (Employee) records.get(i);
                                    Division div = new Division();
                                    Position position = new Position();
                                    try {
                                        div = PstDivision.fetchExc(employee.getDivisionId());
                                        position = PstPosition.fetchExc(employee.getPositionId());
                                    } catch (Exception exc){}
                                    
                                    int year = DateCalc.yearDiff(employee.getBirthDate(), new Date());
                                    
                                    %>
                                        <tr>
                                            <!--<td style="background-color: #FFF;"><input type="checkbox" name="chx" value="" /></td>-->
                                            <td style="background-color: #FFF;"><%=i+1%></td>
                                            <td style="background-color: #FFF;"><%=employee.getEmployeeNum()%></td>
                                            <td style="background-color: #FFF;"><%=employee.getFullName()%></td>
                                            <td style="background-color: #FFF;"><%=div.getDivision()%></td>
                                            <td style="background-color: #FFF;"><%=position.getPosition()%></td>
                                            <td style="background-color: #FFF;"><%=Formater.formatDate(employee.getBirthDate(),"dd MMM yyyy")%></td>
                                            <td style="background-color: #FFF;"><%=year%></td>
                                        </tr>
                                    <%
                                }
                              %>    
                              </table>
                                <%
                                break;
                            case PstNotification.NOTIF_ULANG_TAHUN_KARYAWAN:
                                %>
                                <table class="tblStyle">
                                    <tr>
                                        <!--<td class="title_tbl">&nbsp;</td>-->
                                        <td class="title_tbl">No</td>
                                        <td class="title_tbl">NRK</td>
                                        <td class="title_tbl">Nama Lengkap</td>
                                        <td class="title_tbl">Satuan Kerja</td>
                                        <td class="title_tbl">Jabatan</td>
                                        <td class="title_tbl">Tanggal Lahir</td>
                                        <td class="title_tbl">Usia</td>
                                    </tr>
                                
                                <%
                                for (int i=0; i<records.size(); i++){
                                    Employee employee = (Employee) records.get(i);
                                    Division div = new Division();
                                    Position position = new Position();
                                    try {
                                        div = PstDivision.fetchExc(employee.getDivisionId());
                                        position = PstPosition.fetchExc(employee.getPositionId());
                                    } catch (Exception exc){}
                                    
                                    int year = DateCalc.yearDiff(employee.getBirthDate(), new Date());
                                    
                                    %>
                                        <tr>
                                            <!--<td style="background-color: #FFF;"><input type="checkbox" name="chx" value="" /></td>-->
                                            <td style="background-color: #FFF;"><%=i+1%></td>
                                            <td style="background-color: #FFF;"><%=employee.getEmployeeNum()%></td>
                                            <td style="background-color: #FFF;"><%=employee.getFullName()%></td>
                                            <td style="background-color: #FFF;"><%=div.getDivision()%></td>
                                            <td style="background-color: #FFF;"><%=position.getPosition()%></td>
                                            <td style="background-color: #FFF;"><%=Formater.formatDate(employee.getBirthDate(),"dd MMM yyyy")%></td>
                                            <td style="background-color: #FFF;"><%=year%></td>
                                        </tr>
                                    <%
                                }
                              %>    
                              </table>
                                <%
                                break;
                            case PstNotification.NOTIF_KARYAWAN_PEJABAT_SEMENTARA:
                                %>
                                <table class="tblStyle">
                                    <tr>
                                        <!--<td class="title_tbl">&nbsp;</td>-->
                                        <td class="title_tbl">No</td>
                                        <td class="title_tbl">NRK</td>
                                        <td class="title_tbl">Nama Lengkap</td>
                                        <td class="title_tbl">Satuan Kerja</td>
                                        <td class="title_tbl">Jabatan</td>
                                        <td class="title_tbl">Mulai Menjabat</td>
                                        <td class="title_tbl">Lama Menjabat (Bulan)</td>
                                    </tr>
                                
                                <%
                                for (int i=0; i<records.size(); i++){
                                    CareerPath wh = (CareerPath) records.get(i);
                                    Employee employee = new Employee();
                                    Division div = new Division();
                                    Position position = new Position();
                                    try {
                                        employee = PstEmployee.fetchExc(wh.getEmployeeId());
                                        div = PstDivision.fetchExc(employee.getDivisionId());
                                        position = PstPosition.fetchExc(employee.getPositionId());
                                    } catch (Exception exc){}
                                    
                                    double month = DateCalc.monthDifferenceDouble(wh.getWorkFrom(), new Date());
                                    
                                    %>
                                        <tr>
                                            <!--<td style="background-color: #FFF;"><input type="checkbox" name="chx" value="" /></td>-->
                                            <td style="background-color: #FFF;"><%=i+1%></td>
                                            <td style="background-color: #FFF;"><%=employee.getEmployeeNum()%></td>
                                            <td style="background-color: #FFF;"><%=employee.getFullName()%></td>
                                            <td style="background-color: #FFF;"><%=div.getDivision()%></td>
                                            <td style="background-color: #FFF;"><%=position.getPosition()%></td>
                                            <td style="background-color: #FFF;"><%=Formater.formatDate(wh.getWorkFrom(),"dd MMM yyyy")%></td>
                                            <td style="background-color: #FFF;"><%=month%></td>
                                        </tr>
                                    <%
                                }
                              %>    
                              </table>
                                <%
                                break;
                            case PstNotification.NOTIF_KARYAWAN_LAMA_PADA_JABATAN_TERTENTU:
%>
                                <table class="tblStyle">
                                    <tr>
                                        <!--<td class="title_tbl">&nbsp;</td>-->
                                        <td class="title_tbl">No</td>
                                        <td class="title_tbl">NRK</td>
                                        <td class="title_tbl">Nama Lengkap</td>
                                        <td class="title_tbl">Satuan Kerja</td>
                                        <td class="title_tbl">Jabatan</td>
                                        <td class="title_tbl">Mulai Menjabat</td>
                                        <td class="title_tbl">Lama Menjabat (Tahun)</td>
                                    </tr>
                                
                                <%
                                for (int i=0; i<records.size(); i++){
                                    CareerPath wh = (CareerPath) records.get(i);
                                    Employee employee = new Employee();
                                    Division div = new Division();
                                    Position position = new Position();
                                    try {
                                        employee = PstEmployee.fetchExc(wh.getEmployeeId());
                                        div = PstDivision.fetchExc(employee.getDivisionId());
                                        position = PstPosition.fetchExc(employee.getPositionId());
                                    } catch (Exception exc){}
                                    
                                    %>
                                        <tr>
                                            <!--<td style="background-color: #FFF;"><input type="checkbox" name="chx" value="" /></td>-->
                                            <td style="background-color: #FFF;"><%=i+1%></td>
                                            <td style="background-color: #FFF;"><%=employee.getEmployeeNum()%></td>
                                            <td style="background-color: #FFF;"><%=employee.getFullName()%></td>
                                            <td style="background-color: #FFF;"><%=div.getDivision()%></td>
                                            <td style="background-color: #FFF;"><%=position.getPosition()%></td>
                                            <td style="background-color: #FFF;"><%=Formater.formatDate(wh.getWorkFrom(),"dd MMM yyyy")%></td>
                                            <td style="background-color: #FFF;"><%=(int) wh.getSalary()%></td>
                                        </tr>
                                    <%
                                }
                              %>    
                              </table>
                                <%
                                break;
                            case PstNotification.NOTIF_BEARKHIRNYA_SERTIFIKASI:
                                %>
                                <table class="tblStyle">
                                    <tr>
                                        <!--<td class="title_tbl">&nbsp;</td>-->
                                        <td class="title_tbl">No</td>
                                        <td class="title_tbl">NRK</td>
                                        <td class="title_tbl">Nama Lengkap</td>
                                        <td class="title_tbl">Satuan Kerja</td>
                                        <td class="title_tbl">Jabatan</td>
                                        <td class="title_tbl">Pelatihan</td>
                                        <td class="title_tbl">Tanggal Pelatihan</td>
                                        <td class="title_tbl">Masa Waktu (Tahun)</td>
                                    </tr>
                                
                                <%
                                for (int i=0; i<records.size(); i++){
                                    TrainingHistory hist = (TrainingHistory) records.get(i);
                                    Employee employee = new Employee();
                                    Division div = new Division();
                                    Position position = new Position();
                                    Training tr = new Training();
                                    try {
                                        employee = PstEmployee.fetchExc(hist.getEmployeeId());
                                        div = PstDivision.fetchExc(employee.getDivisionId());
                                        position = PstPosition.fetchExc(employee.getPositionId());
                                        tr = PstTraining.fetchExc(hist.getTrainingId());
                                    } catch (Exception exc){}
                                    
                                    int year = DateCalc.yearDiff(hist.getEndDate(), new Date());
                                    
                                    %>
                                        <tr>
                                            <!--<td style="background-color: #FFF;"><input type="checkbox" name="chx" value="" /></td>-->
                                            <td style="background-color: #FFF;"><%=i+1%></td>
                                            <td style="background-color: #FFF;"><%=employee.getEmployeeNum()%></td>
                                            <td style="background-color: #FFF;"><%=employee.getFullName()%></td>
                                            <td style="background-color: #FFF;"><%=div.getDivision()%></td>
                                            <td style="background-color: #FFF;"><%=position.getPosition()%></td>
                                            <td style="background-color: #FFF;"><%=tr.getName()%></td>
                                            <td style="background-color: #FFF;"><%=Formater.formatDate(hist.getStartDate(),"dd MMM yyyy")%></td>
                                            <td style="background-color: #FFF;"><%=year%></td>
                                        </tr>
                                    <%
                                }
                              %>    
                              </table>
                                <%
                                break;
                            case PstNotification.NOTIF_CUTI_TAHUNAN_ATAU_CUTI_BESAR:
                                %>
                                <table class="tblStyle">
                                    <tr>
                                        <!--<td class="title_tbl">&nbsp;</td>-->
                                        <td class="title_tbl">No</td>
                                        <td class="title_tbl">NRK</td>
                                        <td class="title_tbl">Nama Lengkap</td>
                                        <td class="title_tbl">Satuan Kerja</td>
                                        <td class="title_tbl">Jabatan</td>
                                        <td class="title_tbl">Tanggal Cuti</td>
                                        <td class="title_tbl">Tanggal Berakhir</td>
                                        <td class="title_tbl">Lama Hari</td>
                                        <td class="title_tbl">Jenis Cuti</td>
                                        <td class="title_tbl">Keterangan</td>
                                    </tr>
                                
                                <%
                                for (int i=0; i<records.size(); i++){
                                    LeaveApplication leave = (LeaveApplication) records.get(i);
                                    Employee employee = new Employee();
                                    Division div = new Division();
                                    Position position = new Position();
                                    String startCuti = "";
                                    String endCuti = "";
                                    int qtyCuti = 0;
                                    try {
                                        employee = PstEmployee.fetchExc(leave.getEmployeeId());
                                        div = PstDivision.fetchExc(employee.getDivisionId());
                                        position = PstPosition.fetchExc(employee.getPositionId());
                                        
                                        String where = PstAlStockTaken.fieldNames[PstAlStockTaken.FLD_LEAVE_APPLICATION_ID]+"="+leave.getOID();
                                        Vector listALStockTaken = PstAlStockTaken.list(0, 0, where, "");
                                        if (listALStockTaken != null && listALStockTaken.size()>0){
                                            AlStockTaken alStockTaken = (AlStockTaken)listALStockTaken.get(0);
                                            startCuti = sdf.format(alStockTaken.getTakenDate());
                                            endCuti = sdf.format(alStockTaken.getTakenFinnishDate());
                                            qtyCuti = convertInteger(alStockTaken.getTakenQty());
                                        } else {
                                            where = PstLlStockTaken.fieldNames[PstLlStockTaken.FLD_LEAVE_APPLICATION_ID]+"="+leave.getOID();
                                            Vector listLlStockTaken = PstLlStockTaken.list(0, 0, where, "");
                                            if (listLlStockTaken != null && listLlStockTaken.size()>0){
                                                LlStockTaken llStockTaken = (LlStockTaken)listLlStockTaken.get(0);
                                                startCuti = sdf.format(llStockTaken.getTakenDate());
                                                endCuti = sdf.format(llStockTaken.getTakenFinnishDate());
                                                qtyCuti = convertInteger(llStockTaken.getTakenQty());
                                            } 
                                        }
                                    } catch (Exception exc){}
                                    
                                    %>
                                        <tr>
                                            <!--<td style="background-color: #FFF;"><input type="checkbox" name="chx" value="" /></td>-->
                                            <td style="background-color: #FFF;"><%=i+1%></td>
                                            <td style="background-color: #FFF;"><%=employee.getEmployeeNum()%></td>
                                            <td style="background-color: #FFF;"><%=employee.getFullName()%></td>
                                            <td style="background-color: #FFF;"><%=div.getDivision()%></td>
                                            <td style="background-color: #FFF;"><%=position.getPosition()%></td>
                                            <td style="background-color: #FFF;"><%= startCuti %></td>
                                            <td style="background-color: #FFF;"><%= endCuti %></td>
                                            <td style="background-color: #FFF;"><%= qtyCuti %></td>
                                            <%
                                                if (leave.getTypeLeaveCategory() != 0){
                                            %>
                                            <td style="background-color: #FFF;"><%= leaveType[leave.getTypeLeaveCategory()] %></td>
                                            <%
                                                }
                                            %>
                                            <td style="background-color: #FFF;"><%= leave.getLeaveReason() %></td>
                                        </tr>
                                    <%
                                }
                              %>    
                              </table>
                                <%
                                break;
                            case PstNotification.NOTIF_STOK_CUTI_MINUS:
                                %>
                                <table class="tblStyle">
                                    <tr>
                                        <!--<td class="title_tbl">&nbsp;</td>-->
                                        <td class="title_tbl">No</td>
                                        <td class="title_tbl">NRK</td>
                                        <td class="title_tbl">Nama Lengkap</td>
                                        <td class="title_tbl">Satuan Kerja</td>
                                        <td class="title_tbl">Jabatan</td>
                                        <td class="title_tbl">Stok Cuti</td>
                                    </tr>
                                
                                <%
                                for (int i=0; i<records.size(); i++){
                                    Vector temp = (Vector) records.get(i);
                                    Employee employee = (Employee) temp.get(0);
                                    String stok = (String) temp.get(1);
                                    Division div = new Division();
                                    Position position = new Position();
                                    try {
                                        div = PstDivision.fetchExc(employee.getDivisionId());
                                        position = PstPosition.fetchExc(employee.getPositionId());
                                    } catch (Exception exc){}
                                    
                                    int year = DateCalc.yearDiff(employee.getBirthDate(), new Date());
                                    
                                    %>
                                        <tr>
                                            <!--<td style="background-color: #FFF;"><input type="checkbox" name="chx" value="" /></td>-->
                                            <td style="background-color: #FFF;"><%=i+1%></td>
                                            <td style="background-color: #FFF;"><%=employee.getEmployeeNum()%></td>
                                            <td style="background-color: #FFF;"><%=employee.getFullName()%></td>
                                            <td style="background-color: #FFF;"><%=div.getDivision()%></td>
                                            <td style="background-color: #FFF;"><%=position.getPosition()%></td>
                                            <td style="background-color: #FFF;"><%=stok%></td>
                                        </tr>
                                    <%
                                }
                              %>    
                              </table>
                                <%
                                break;
                            case PstNotification.NOTIF_VALID_UNTIL_WARNING:
                                %>
                                <table class="tblStyle">
                                    <tr>
                                        <!--<td class="title_tbl">&nbsp;</td>-->
                                        <td class="title_tbl">No</td>
                                        <td class="title_tbl">NRK</td>
                                        <td class="title_tbl">Nama Lengkap</td>
                                        <td class="title_tbl">Satuan Kerja</td>
                                        <td class="title_tbl">Jabatan</td>
                                        <td class="title_tbl">Tanggal Peringatan</td>
                                        <td class="title_tbl">Pemberi Peringatan</td>
                                        <td class="title_tbl">Level Peringatan</td>
                                        <td class="title_tbl">Tanggal Berakhir Peringatan</td>
                                    </tr>
                                
                                <%
                                for (int i=0; i<records.size(); i++){
                                    EmpWarning empWarning = (EmpWarning) records.get(i);
                                    String empNum = PstEmployee.getEmployeeNumber(empWarning.getEmployeeId());
                                    String empName = PstEmployee.getEmployeeName(empWarning.getEmployeeId());
                                    String empDivision = PstEmployee.getDivisionName(empWarning.getDivisionId());
                                    String empPosition = PstEmployee.getPositionName(empWarning.getPositionId());
                                    Warning warning = PstWarning.fetchExc(empWarning.getWarnLevelId());
                                    %>
                                        <tr>
                                            <!--<td style="background-color: #FFF;"><input type="checkbox" name="chx" value="" /></td>-->
                                            <td style="background-color: #FFF;"><%=i+1%></td>
                                            <td style="background-color: #FFF;"><%=empNum%></td>
                                            <td style="background-color: #FFF;"><%=empName%></td>
                                            <td style="background-color: #FFF;"><%=empDivision%></td>
                                            <td style="background-color: #FFF;"><%=empPosition%></td>
                                            <td style="background-color: #FFF;"><%=Formater.formatDate(empWarning.getBreakDate(),"yyyy-MM-dd")%></td>
                                            <td style="background-color: #FFF;"><%=empWarning.getWarningBy()%></td>
                                            <td style="background-color: #FFF;"><%=warning.getWarnDesc()%></td>
                                            <td style="background-color: #FFF;"><%=Formater.formatDate(empWarning.getValidityDate(),"yyyy-MM-dd")%></td>
                                        </tr>
                                    <%
                                }
                              %>    
                              </table>
                                <%
                                break;
                            case PstNotification.NOTIF_VALID_UNTIL_REPRIMAND:
                                %>
                                <table class="tblStyle">
                                    <tr>
                                        <td class="title_tbl">No</td>
                                        <td class="title_tbl">NRK</td>
                                        <td class="title_tbl">Nama Lengkap</td>
                                        <td class="title_tbl">Satuan Kerja</td>
                                        <td class="title_tbl">Jabatan</td>
                                        <td class="title_tbl">Tanggal Teguran</td>
                                        <td class="title_tbl">Level Teguran</td>
                                        <td class="title_tbl">Tanggal Berakhir Teguran</td>
                                    </tr>
                                
                                <%
                                for (int i=0; i<records.size(); i++){
                                    EmpReprimand empReprimand = (EmpReprimand) records.get(i);
                                    String empNum = PstEmployee.getEmployeeNumber(empReprimand.getEmployeeId());
                                    String empName = PstEmployee.getEmployeeName(empReprimand.getEmployeeId());
                                    String empDivision = PstEmployee.getDivisionName(empReprimand.getDivisionId());
                                    String empPosition = PstEmployee.getPositionName(empReprimand.getPositionId());
                                    Reprimand reprimand = PstReprimand.fetchExc(empReprimand.getReprimandLevelId());
                                    %>
                                        <tr>
                                            <td style="background-color: #FFF;"><%=i+1%></td>
                                            <td style="background-color: #FFF;"><%=empNum%></td>
                                            <td style="background-color: #FFF;"><%=empName%></td>
                                            <td style="background-color: #FFF;"><%=empDivision%></td>
                                            <td style="background-color: #FFF;"><%=empPosition%></td>
                                            <td style="background-color: #FFF;"><%=empReprimand.getReprimandDate()%></td>
                                            <td style="background-color: #FFF;"><%=reprimand.getReprimandDesc()%></td>
                                            <td style="background-color: #FFF;"><%=empReprimand.getValidityDate()%></td>
                                        </tr>
                                    <%
                                }
                              %>    
                              </table>
                                <%
                                break;
                        }
                %>
                    <%
                        } else {
                    %>
                    <h5><strong>No Data Available</strong></h5>
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
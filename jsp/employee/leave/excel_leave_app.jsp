<%-- 
    Document   : excel_leave_app
    Created on : May 8, 2020, 1:33:17 PM
    Author     : gndiw
--%>
<%@page import="java.math.RoundingMode"%>
<%@page import="java.math.BigDecimal"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstScheduleSymbol"%>
<%@page import="com.dimata.harisma.entity.masterdata.ScheduleSymbol"%>
<%@page import="com.dimata.harisma.entity.leave.SpecialUnpaidLeaveTaken"%>
<%@page import="com.dimata.harisma.entity.leave.PstSpecialUnpaidLeaveTaken"%>
<%@page import="com.dimata.harisma.entity.attendance.LlStockTaken"%>
<%@page import="com.dimata.harisma.entity.attendance.PstLlStockTaken"%>
<%@page import="com.dimata.harisma.entity.attendance.AlStockTaken"%>
<%@page import="com.dimata.harisma.entity.attendance.PstAlStockTaken"%>
<%@page import="com.dimata.harisma.entity.masterdata.Department"%>
<%@page import="com.dimata.harisma.entity.leave.LeaveApplication"%>
<%@page import="com.dimata.harisma.entity.employee.Employee"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.dimata.harisma.entity.leave.PstLeaveApplication"%>
<%@page import="com.dimata.qdep.form.FRMQueryString"%>
<%@page import="com.dimata.harisma.session.leave.SessLeaveApplication"%>
<%@page import="java.util.Vector"%>
<%@page import="com.dimata.harisma.form.search.FrmSrcLeaveApp"%>
<%@page import="com.dimata.harisma.entity.search.SrcLeaveApp"%>
<%@page import="com.dimata.qdep.db.DBResultSet"%>
<%@page import="com.dimata.qdep.db.DBHandler"%>
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
    
    public void doUpdateLeaveAppToBeCancel(long oid) {
        DBResultSet dbrs = null;
        try {
            String sql = "UPDATE hr_leave_application SET doc_status="+PstLeaveApplication.FLD_STATUS_APPlICATION_TO_BE_CANCEL;
            sql += " WHERE leave_application_id="+oid;
            DBHandler.updateParsial(sql);
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
    }

    public void doUpdateAlStockManagement(float qtyUsed, long oid) {
        DBResultSet dbrs = null;
        try {
            String sql = "UPDATE hr_al_stock_management SET qty_used="+ qtyUsed;
            sql += " WHERE al_stock_id="+oid;
            DBHandler.updateParsial(sql);
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
    }

    public void doUpdateLlStockManagement(float qtyUsed, long oid) {
        DBResultSet dbrs = null;
        try {
            String sql = "UPDATE hr_ll_stock_management SET qty_used="+ qtyUsed;
            sql += " WHERE ll_stock_id="+oid;
            DBHandler.updateParsial(sql);
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
    }

    
%>
<%
 response.setHeader("Content-Disposition","attachment; filename=rekap_cuti.xls ");  
 SrcLeaveApp objSrcLeaveApp = new SrcLeaveApp();
    FrmSrcLeaveApp objFrmSrcLeaveApp = new FrmSrcLeaveApp();
    Vector records=null;
    SessLeaveApplication sessLeaveApplication = new SessLeaveApplication();
    int type_form = FRMQueryString.requestInt(request, "" + PstLeaveApplication.fieldNames[PstLeaveApplication.FLD_TYPE_FROM_LEAVE]);
    objFrmSrcLeaveApp = new FrmSrcLeaveApp(request, objSrcLeaveApp);
        objFrmSrcLeaveApp.requestEntityObject(objSrcLeaveApp);
    records = sessLeaveApplication.searchLeaveApplicationList(objSrcLeaveApp, 0, 0);
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <style type="text/css">
            .tblStyle {border-collapse: collapse; font-size: 16px;}
            .tblStyle td {padding: 7px 9px; border: 1px solid #CCC; font-size: 16px;}
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
    </head>
    <body>
        <%
            if((records!=null)&&(records.size()>0))
            {
                %>
                <table class="tblStyle">
                    <tr>
                        <td class="title_tbl">No</td>
                        <td class="title_tbl">NRK</td>
                        <td class="title_tbl">Nama</td>
                        <td class="title_tbl">Tanggal Pengajuan</td>
                        <td class="title_tbl">Tanggal Cuti</td>
                        <td class="title_tbl">Tanggal Berakhir</td>
                        <td class="title_tbl">Lama Hari</td>
                        <td class="title_tbl">Jenis Cuti</td>
                        <td class="title_tbl">Keterangan</td>
                        <td class="title_tbl">Status</td>
                    </tr>
                    <%
                        String whereClause = "";
                        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                        long scheduleSymbol = 0;
                        for (int i=0; i<records.size(); i++){
                            Vector temp = (Vector) records.get(i);
                
                            Employee employee = (Employee) temp.get(0);
                            LeaveApplication leave = (LeaveApplication) temp.get(1);
                            Department department = (Department) temp.get(2);
                            String startCuti = "";
                            String endCuti = "";
                            int qtyCuti = 0;
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
                                } else {
                                    where = PstSpecialUnpaidLeaveTaken.fieldNames[PstSpecialUnpaidLeaveTaken.FLD_LEAVE_APLICATION_ID]+"="+leave.getOID();
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
                            %>
                            <tr>
                                <td style="background-color: #FFF;"><%= ((i)+1) %></td>
                                <td style="background-color: #FFF;">="<%= employee.getEmployeeNum() %>"</td>
                                <td style="background-color: #FFF;"><%= employee.getFullName() %></td>
                                <td style="background-color: #FFF;"><%= leave.getSubmissionDate() %></td>
                                <td style="background-color: #FFF;"><%= startCuti %></td>
                                <td style="background-color: #FFF;"><%= endCuti %></td>
                                <td style="background-color: #FFF;"><%= qtyCuti %></td>
                                <%
                                    if (leave.getTypeLeaveCategory() != 0){
                                %>
                                <td style="background-color: #FFF;"><%= leaveType[leave.getTypeLeaveCategory()] %></td>
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
                                <td style="background-color: #FFF;"><%= leave.getLeaveReason() %></td>
                                <td style="background-color: #FFF;"><%= PstLeaveApplication.fieldStatusApplication[leave.getDocStatus()] %></td>
                                
                            </tr>
                            <%
                        }
                    %>
                </table>
                <%
                    }
                %>
    </body>
</html>

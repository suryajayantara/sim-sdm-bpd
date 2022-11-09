<%-- 
    Document   : notification_excel
    Created on : Oct 14, 2020, 10:26:17 AM
    Author     : gndiw
--%>
<%@page import="com.dimata.harisma.entity.masterdata.PstReprimand"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstWarning"%>
<%@page import="com.dimata.harisma.entity.employee.EmpWarning"%>
<%@page import="com.dimata.harisma.entity.masterdata.Warning"%>
<%@page import="com.dimata.harisma.entity.masterdata.Reprimand"%>
<%@page import="com.dimata.harisma.entity.masterdata.Reprimand"%>
<%@page import="com.dimata.harisma.entity.employee.EmpReprimand"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstTraining"%>
<%@page import="com.dimata.harisma.entity.masterdata.Training"%>
<%@page import="com.dimata.harisma.entity.employee.TrainingHistory"%>
<%@page import="com.dimata.harisma.entity.employee.CareerPath"%>
<%@page import="java.util.Date"%>
<%@page import="com.dimata.util.Formater"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstPosition"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstDivision"%>
<%@page import="com.dimata.harisma.entity.masterdata.Position"%>
<%@page import="com.dimata.harisma.entity.masterdata.Division"%>
<%@page import="com.dimata.harisma.entity.employee.Employee"%>
<%@page import="com.dimata.harisma.entity.employee.PstTrainingHistory"%>
<%@page import="com.dimata.harisma.entity.employee.PstCareerPath"%>
<%@page import="com.dimata.harisma.entity.employee.PstEmployee"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstNotification"%>
<%@page import="com.dimata.harisma.entity.masterdata.Notification"%>
<%@page import="com.dimata.qdep.form.FRMQueryString"%>
<%@page import="java.util.Vector"%>
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
    String reportName = "";
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
                reportName = "karyawan_akan_habis_kontrak";
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
                reportName = "penghargaan_karyawan";
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
                reportName = "karyawan_akan_mbt";
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
                reportName = "karyawan_akan_pensiun";
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
                reportName = "karyawan_ulang_tahun";
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
                reportName = "karyawan_pejabat_sementara";
                break;
            case PstNotification.NOTIF_KARYAWAN_LAMA_PADA_JABATAN_TERTENTU:
                lenghtDay = PstNotification.checkLenghtNotifByUser(userid,PstNotification.NOTIF_KARYAWAN_LAMA_PADA_JABATAN_TERTENTU, nf.getOID());
                year = PstNotification.checkSpecialCaseNotifByUser(userid,PstNotification.NOTIF_KARYAWAN_LAMA_PADA_JABATAN_TERTENTU, nf.getOID());
                inDivision = PstNotification.getUserDivisionMap(PstNotification.NOTIF_KARYAWAN_LAMA_PADA_JABATAN_TERTENTU, nf.getOID());
                whereClause = " TIMESTAMPDIFF(YEAR,"+PstCareerPath.fieldNames[PstCareerPath.FLD_WORK_FROM]+",DATE_ADD(DATE_FORMAT(NOW(), '%Y-%m-%e'), INTERVAL "+lenghtDay+" DAY)) >= "+year+
                        " AND "+PstEmployee.fieldNames[PstEmployee.FLD_RESIGNED]+" = "+PstEmployee.ACTIVE;
                records = PstCareerPath.getlistEmpPerMasaJabatan(year,inDivision);
                reportName = "lama_jabatan";
                break;
            case PstNotification.NOTIF_BEARKHIRNYA_SERTIFIKASI:
                lenghtDay = PstNotification.checkLenghtNotifByUser(userid,PstNotification.NOTIF_BEARKHIRNYA_SERTIFIKASI, nf.getOID());
                records  = (Vector) PstTrainingHistory.listNotifTrainingHistory(lenghtDay);
                reportName = "berakhir_sertifikasi";
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
                reportName = "pembayaran_cuti";
                break;
            case PstNotification.NOTIF_STOK_CUTI_MINUS:
                inDivision = PstNotification.getUserDivisionMap(PstNotification.NOTIF_STOK_CUTI_MINUS, nf.getOID());
                whereClause = "";
                if (inDivision.length()>0){
                    whereClause += " AND emp."+PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID]+" IN ("+inDivision+")";
                }
                records = PstNotification.listEmpStockMinus(whereClause);
                reportName = "stok_cuti_minus";
                break;
            case PstNotification.NOTIF_VALID_UNTIL_WARNING:
                lenghtDay = PstNotification.checkLenghtNotifByUser(userid,PstNotification.NOTIF_VALID_UNTIL_WARNING, nf.getOID());
                inDivision = PstNotification.getUserDivisionMap(PstNotification.NOTIF_STOK_CUTI_MINUS, nf.getOID());
                whereClause = " warn.`VALID_UNTIL` BETWEEN   CURDATE()  AND (CURDATE()+INTERVAL "+lenghtDay+" DAY) ";
                if (inDivision.length()>0){
                    whereClause += " AND warn."+PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID]+" IN ("+inDivision+")";
                }
                records = PstNotification.listEmpWarningNotif(whereClause);
                reportName = "surat_peringatan_yang_akan_berakhir";
                break;
            case PstNotification.NOTIF_VALID_UNTIL_REPRIMAND:
                lenghtDay = PstNotification.checkLenghtNotifByUser(userid,PstNotification.NOTIF_VALID_UNTIL_REPRIMAND, nf.getOID());
                inDivision = PstNotification.getUserDivisionMap(PstNotification.NOTIF_STOK_CUTI_MINUS, nf.getOID());
                whereClause = " reprimand.`VALID_UNTIL` BETWEEN   CURDATE()  AND (CURDATE()+INTERVAL "+lenghtDay+" DAY) ";
                if (inDivision.length()>0){
                    whereClause += " AND reprimand."+PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID]+" IN ("+inDivision+")";
                }
                records = PstNotification.listEmpReprimandNotif(whereClause);
                reportName = "surat_teguran_yang_akan_berakhir";
                break;
        }
    }catch(Exception exc){
        System.out.println("err get List End Contract :"+exc);
    }  
    
    
    response.setHeader("Content-Disposition","attachment; filename="+reportName+".xls ");
%>
<%@page contentType="application/x-msexcel" pageEncoding="UTF-8"%>
<html>
    <head>
        <style type="text/css">
            .tblStyle {border-collapse: collapse; }
            .tblStyle td {padding: 5px 7px; border: 1px solid #CCC;}
            .title_tbl {font-weight: bold;background-color: #EEE; color: #575757;}
        </style>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
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

                        double year = DateCalc.yearDiff(wh.getWorkFrom(), new Date());

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
                                            <td style="background-color: #FFF;"><%=Formater.formatDate(empReprimand.getReprimandDate(),"yyyy-MM-dd")%></td>
                                            <td style="background-color: #FFF;"><%=reprimand.getReprimandDesc()%></td>
                                            <td style="background-color: #FFF;"><%=Formater.formatDate(empReprimand.getValidityDate(),"yyyy-MM-dd")%></td>
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
</html>

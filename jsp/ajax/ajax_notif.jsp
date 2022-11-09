<%-- 
    Document   : ajax_notif
    Created on : Dec 24, 2019, 10:00:31 AM
    Author     : Dimata 007
--%>

<%@page import="com.dimata.harisma.entity.log.PstLogSysHistory"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="com.dimata.qdep.db.DBHandler"%>
<%@page import="com.dimata.qdep.db.DBResultSet"%>
<%@page import="com.dimata.harisma.entity.employee.PstTrainingHistory"%>
<%@page import="com.dimata.util.Formater"%>
<%@page import="com.dimata.harisma.report.EmployeeDetailPdf"%>
<%@page import="com.dimata.harisma.entity.admin.AppUser"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstNotificationMapping"%>

<%@page import="com.dimata.harisma.entity.masterdata.PstKPI_Employee_Achiev"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstKpiTarget"%>
<%@page import="com.dimata.harisma.entity.overtime.PstOvertime"%>
<%@page import="com.dimata.qdep.form.FRMQueryString"%>
<%@page import="org.json.JSONObject"%>
<%@page import="com.dimata.harisma.entity.leave.PstSpecialUnpaidLeaveTaken"%>
<%@page import="com.dimata.harisma.entity.masterdata.ScheduleSymbol"%>
<%@page import="com.dimata.harisma.entity.leave.PstLeaveApplication"%>
<%@page import="java.util.Vector"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstScheduleSymbol"%>
<%@page import="com.dimata.system.entity.system.PstSystemProperty"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file = "../main/javainit.jsp" %>
<%!
    public static int getCountLeave(String whereClause) {
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT COUNT(lv." + PstLeaveApplication.fieldNames[PstLeaveApplication.FLD_LEAVE_APPLICATION_ID] + ") FROM `hr_leave_application` AS lv"
                    + " LEFT JOIN hr_emp_doc doc ON lv.`LEAVE_APPLICATION_ID` = doc.LEAVE_APPLICATION_ID "
                    + " LEFT JOIN hr_al_stock_taken AS tk ON tk.`LEAVE_APPLICATION_ID` = lv.`LEAVE_APPLICATION_ID` "
                    + " LEFT JOIN `hr_ll_stock_taken` AS ll ON ll.`LEAVE_APPLICATION_ID` = lv.`LEAVE_APPLICATION_ID` "
                    + " INNER JOIN `hr_employee` AS emp ON lv.`EMPLOYEE_ID` = emp.`EMPLOYEE_ID` ";
            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " WHERE " + whereClause;
            }

            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            int count = 0;
            while (rs.next()) {
                count = rs.getInt(1);
            }

            rs.close();
            return count;
        } catch (Exception e) {
            return 0;
        } finally {
            DBResultSet.close(dbrs);
        }
    }
    
%>
<%//
    //String approot = FRMQueryString.requestString(request, "approot");
    long employeeId = FRMQueryString.requestLong(request, "employeeId");
    long divisionId = FRMQueryString.requestLong(request, "divisionId");
    AppUser appUser = userSession.getAppUser();
    
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
    String whereSchedule = "(" + PstScheduleSymbol.fieldNames[PstScheduleSymbol.FLD_SCHEDULE_CATEGORY_ID] + " = " + oidSpecialLeave
            + " OR " + PstScheduleSymbol.fieldNames[PstScheduleSymbol.FLD_SCHEDULE_CATEGORY_ID] + " = " + oidUnpaidLeave + ") AND "
            + PstScheduleSymbol.fieldNames[PstScheduleSymbol.FLD_SHOW_ON_USER_LEAVE] + " = 1";
    Vector listSchedule = PstScheduleSymbol.list(0, 0, whereSchedule, null);

    int totalNotif = 0;
    String linkNotif = "";
    
    //start add by Eri Yudi - 2020-06-22
//==================================== Note for Notification Type ============================================================
//         "Notifikasi Approval yang mencakup seluruh modul seperti Approval Cuti, Lembur, Penilaian kinerja dan lainnya", = 0
//         "Notifikasi Karyawan yang akan habis kontrak",                                                                  = 1
//         "Notifikasi Pembayaran Cuti Tahunan/Cuti Besar",                                                                = 2
//         "Notifikasi Penghargaan Karyawan (15 Tahun, 25 Tahun, 30 Tahun dan 35 Tahun)",                                  = 3
//         "Notifikasi Karyawan yang akan Memasuki masa MBT",                                                              = 4
//         "Notifikasi Karyawan yang akan memasuki masa Pensiun",                                                          = 5
//         "Notifikasi Karyawan Pejabat Sementara",                                                                        = 6
//         "Notifikasi Ulang Tahun Karyawan",                                                                              = 7
//         "Notifikasi Karyawan yang telah lama pada satu jabatan tertentu lama jabatan dapat diatur secara dinamis",      = 8
//         "Notifikasi Berakhirnya Sertifikasi tertentu"                                                                   = 9
   
    Vector listNotification = PstNotification.listJoin(appUser.getOID());
    for (int n=0; n < listNotification.size(); n++){
        Notification nf = (Notification) listNotification.get(n);
        switch (nf.getNotificationType()){
            case PstNotification.NOTIF_KARYAWAN_HABIS_KONTRAK:
                int lenghtDay = PstNotification.checkLenghtNotifByUser(appUser.getOID(),PstNotification.NOTIF_KARYAWAN_HABIS_KONTRAK, nf.getOID());
                String inDivision = PstNotification.getUserDivisionMap(PstNotification.NOTIF_KARYAWAN_HABIS_KONTRAK, nf.getOID());
                String whereClauseEndContract = " "+PstEmployee.fieldNames[PstEmployee.FLD_END_CONTRACT]+" BETWEEN DATE_FORMAT(NOW(), '%Y-%m-%e') AND "+
                        "DATE_ADD(DATE_FORMAT(NOW(), '%Y-%m-%e'), INTERVAL "+lenghtDay+" DAY)"+
                        " AND "+PstEmployee.fieldNames[PstEmployee.FLD_RESIGNED]+" = "+PstEmployee.ACTIVE;
                if (inDivision.length()>0){
                    whereClauseEndContract += " AND "+PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID]+" IN ("+inDivision+")";
                }
                int cntEndContract = PstEmployee.getCount(whereClauseEndContract);
                if(cntEndContract > 0){   
                    totalNotif += 1;
                    linkNotif += "<a href='javascript:cmdGoNotifDetail(\""+appUser.getOID()+"\",\""+nf.getOID()+"\")'> "+cntEndContract+" Karyawan akan Habis Kontrak dalam "+(lenghtDay > 0 ? lenghtDay+" hari kedepan" : "hari ini")+"</a>";
                }
                break;
            case PstNotification.NOTIF_PENGHARAGAAN_KARYAWAN:
                lenghtDay = PstNotification.checkLenghtNotifByUser(appUser.getOID(),PstNotification.NOTIF_PENGHARAGAAN_KARYAWAN, nf.getOID());
                inDivision = PstNotification.getUserDivisionMap(PstNotification.NOTIF_PENGHARAGAAN_KARYAWAN, nf.getOID());
                int year = PstNotification.checkSpecialCaseNotifByUser(appUser.getOID(),PstNotification.NOTIF_PENGHARAGAAN_KARYAWAN, nf.getOID());
                String whereClause = " TIMESTAMPDIFF(YEAR,"+PstEmployee.fieldNames[PstEmployee.FLD_COMMENCING_DATE]+",DATE_ADD(DATE_FORMAT(NOW(), '%Y-%m-%e'), INTERVAL "+lenghtDay+" DAY)) = "+year+
                        " AND DATE_ADD("+PstEmployee.fieldNames[PstEmployee.FLD_COMMENCING_DATE]+", INTERVAL "+year+" YEAR) BETWEEN NOW() AND DATE_ADD(DATE_FORMAT(NOW(), '%Y-%m-%e'),INTERVAL "+lenghtDay+" DAY)"+
                        " AND "+PstEmployee.fieldNames[PstEmployee.FLD_RESIGNED]+" = "+PstEmployee.ACTIVE;
                if (inDivision.length()>0){
                    whereClause += " AND "+PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID]+" IN ("+inDivision+")";
                }
                int cntEnpMasaKerja = PstEmployee.getCount(whereClause);
                if(cntEnpMasaKerja > 0){   
                    totalNotif += 1;
                    linkNotif += "<a href='javascript:cmdGoNotifDetail(\""+appUser.getOID()+"\",\""+nf.getOID()+"\")'> "+cntEnpMasaKerja+" Karyawan telah melalui "+year+" tahun masa kerja dalam "+(lenghtDay > 0 ? lenghtDay+" hari kedepan" : "hari ini")+"</a>";
                }
                break;
            case PstNotification.NOTIF_KARYAWAN_MBT:
                lenghtDay = PstNotification.checkLenghtNotifByUser(appUser.getOID(),PstNotification.NOTIF_KARYAWAN_MBT, nf.getOID());
                inDivision = PstNotification.getUserDivisionMap(PstNotification.NOTIF_KARYAWAN_MBT, nf.getOID());
                year = PstNotification.checkSpecialCaseNotifByUser(appUser.getOID(),PstNotification.NOTIF_KARYAWAN_MBT, nf.getOID());
                whereClause = " TIMESTAMPDIFF(YEAR,"+PstEmployee.fieldNames[PstEmployee.FLD_BIRTH_DATE]+",DATE_ADD(DATE_FORMAT(NOW(), '%Y-%m-%e'), INTERVAL "+lenghtDay+" DAY)) = "+year+
                        " AND "+PstEmployee.fieldNames[PstEmployee.FLD_RESIGNED]+" = "+PstEmployee.ACTIVE;
                if (inDivision.length()>0){
                    whereClause += " AND "+PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID]+" IN ("+inDivision+")";
                }
                int cntEnpMBT = PstEmployee.getCount(whereClause);
                if(cntEnpMBT > 0){   
                    totalNotif += 1;
                    linkNotif += "<a href='javascript:cmdGoNotifDetail(\""+appUser.getOID()+"\",\""+nf.getOID()+"\")'> "+cntEnpMBT+" Karyawan akan memasuki MBT dalam "+(lenghtDay > 0 ? lenghtDay+" hari kedepan" : "hari ini")+"</a>";
                }
                break;
            case PstNotification.NOTIF_KARYAWAN_PENSIUN:
                lenghtDay = PstNotification.checkLenghtNotifByUser(appUser.getOID(),PstNotification.NOTIF_KARYAWAN_PENSIUN, nf.getOID());
                year = PstNotification.checkSpecialCaseNotifByUser(appUser.getOID(),PstNotification.NOTIF_KARYAWAN_PENSIUN, nf.getOID());
                inDivision = PstNotification.getUserDivisionMap(PstNotification.NOTIF_KARYAWAN_PENSIUN, nf.getOID());
                whereClause = " TIMESTAMPDIFF(YEAR,"+PstEmployee.fieldNames[PstEmployee.FLD_BIRTH_DATE]+",DATE_ADD(DATE_FORMAT(NOW(), '%Y-%m-%e'), INTERVAL "+lenghtDay+" DAY)) = "+year+
                        " AND "+PstEmployee.fieldNames[PstEmployee.FLD_RESIGNED]+" = "+PstEmployee.ACTIVE;
                if (inDivision.length()>0){
                    whereClause += " AND "+PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID]+" IN ("+inDivision+")";
                }
                int cntEmpPensiun = PstEmployee.getCount(whereClause);
                if(cntEmpPensiun > 0){   
                    totalNotif += 1;
                    linkNotif += "<a href='javascript:cmdGoNotifDetail(\""+appUser.getOID()+"\",\""+nf.getOID()+"\")'> "+cntEmpPensiun+" Karyawan akan memasuki Pensiun dalam "+(lenghtDay > 0 ? lenghtDay+" hari kedepan" : "hari ini")+"</a>";
                }
                break;
            case PstNotification.NOTIF_ULANG_TAHUN_KARYAWAN:
                lenghtDay = PstNotification.checkLenghtNotifByUser(appUser.getOID(),PstNotification.NOTIF_ULANG_TAHUN_KARYAWAN, nf.getOID());
                inDivision = PstNotification.getUserDivisionMap(PstNotification.NOTIF_ULANG_TAHUN_KARYAWAN, nf.getOID());
                whereClause = " DATE_FORMAT("+PstEmployee.fieldNames[PstEmployee.FLD_BIRTH_DATE]+", '%m-%e') BETWEEN DATE_FORMAT(NOW(), '%m-%e') AND "+
                        "DATE_FORMAT(DATE_ADD(NOW(), INTERVAL "+lenghtDay+" DAY), '%m-%e')"+
                        " AND "+PstEmployee.fieldNames[PstEmployee.FLD_RESIGNED]+" = "+PstEmployee.ACTIVE;
                if (inDivision.length()>0){
                    whereClause += " AND "+PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID]+" IN ("+inDivision+")";
                }
                int cntBirth = PstEmployee.getCount(whereClause);
                if(cntBirth > 0){   
                    totalNotif += 1;
                    linkNotif += "<a href='javascript:cmdGoNotifDetail(\""+appUser.getOID()+"\",\""+nf.getOID()+"\")'> "+cntBirth+" Karyawan akan berulang tahun dalam "+(lenghtDay > 0 ? lenghtDay+" hari kedepan" : "hari ini")+"</a>";
                }
                break;
            case PstNotification.NOTIF_KARYAWAN_PEJABAT_SEMENTARA:
                lenghtDay = PstNotification.checkLenghtNotifByUser(appUser.getOID(),PstNotification.NOTIF_KARYAWAN_PEJABAT_SEMENTARA, nf.getOID());
                year = PstNotification.checkSpecialCaseNotifByUser(appUser.getOID(),PstNotification.NOTIF_KARYAWAN_PEJABAT_SEMENTARA, nf.getOID());
                inDivision = PstNotification.getUserDivisionMap(PstNotification.NOTIF_KARYAWAN_PEJABAT_SEMENTARA, nf.getOID());
                whereClause = " TIMESTAMPDIFF(MONTH,"+PstCareerPath.fieldNames[PstCareerPath.FLD_WORK_FROM]+",DATE_ADD(DATE_FORMAT(NOW(), '%Y-%m-%e'), INTERVAL "+lenghtDay+" DAY)) = "+year+
                        " AND "+PstCareerPath.fieldNames[PstCareerPath.FLD_WORK_HISTORY_NOW_ID]+" = 0 AND "+PstCareerPath.fieldNames[PstCareerPath.FLD_HISTORY_TYPE]+"= 1";
                if (inDivision.length()>0){
                    whereClause += " AND "+PstCareerPath.fieldNames[PstCareerPath.FLD_DIVISION_ID]+" IN ("+inDivision+")";
                }
                int cntPjs = PstCareerPath.getCountView(whereClause);
                if(cntPjs > 0){   
                    totalNotif += 1;
                    linkNotif += "<a href='javascript:cmdGoNotifDetail(\""+appUser.getOID()+"\",\""+nf.getOID()+"\")'> "+cntPjs+" Karyawan PJS telah menjabat selama "+year+" bulan dalam "+(lenghtDay > 0 ? lenghtDay+" hari kedepan" : "hari ini")+"</a>";
                }
                break;
            case PstNotification.NOTIF_KARYAWAN_LAMA_PADA_JABATAN_TERTENTU:
                lenghtDay = PstNotification.checkLenghtNotifByUser(appUser.getOID(),PstNotification.NOTIF_KARYAWAN_LAMA_PADA_JABATAN_TERTENTU, nf.getOID());
                year = PstNotification.checkSpecialCaseNotifByUser(appUser.getOID(),PstNotification.NOTIF_KARYAWAN_LAMA_PADA_JABATAN_TERTENTU, nf.getOID());
                inDivision = PstNotification.getUserDivisionMap(PstNotification.NOTIF_KARYAWAN_LAMA_PADA_JABATAN_TERTENTU, nf.getOID());
                whereClause = " TIMESTAMPDIFF(YEAR,"+PstCareerPath.fieldNames[PstCareerPath.FLD_WORK_FROM]+",DATE_ADD(DATE_FORMAT(NOW(), '%Y-%m-%e'), INTERVAL "+lenghtDay+" DAY)) >= "+year+
                        " AND "+PstEmployee.fieldNames[PstEmployee.FLD_RESIGNED]+" = "+PstEmployee.ACTIVE;
                int cntLama = PstCareerPath.getCountlistEmpPerMasaJabatan(year, inDivision);
                if(cntLama > 0){   
                    totalNotif += 1;
                    linkNotif += "<a href='javascript:cmdGoNotifDetail(\""+appUser.getOID()+"\",\""+nf.getOID()+"\")'> "+cntLama+" Karyawan menjabat jabatan sama selama "+year+" tahun dalam "+(lenghtDay > 0 ? lenghtDay+" hari kedepan" : "hari ini")+"</a>";
                }
                break;
            case PstNotification.NOTIF_BEARKHIRNYA_SERTIFIKASI:
                lenghtDay = PstNotification.checkLenghtNotifByUser(appUser.getOID(),PstNotification.NOTIF_BEARKHIRNYA_SERTIFIKASI, nf.getOID());
                Vector listTrainingHistory  = (Vector) PstTrainingHistory.listNotifTrainingHistory(lenghtDay);
                int countKaryawanBerakhirSertifikasi = listTrainingHistory.size();
                if(countKaryawanBerakhirSertifikasi > 0){  
                    totalNotif += 1;
                    linkNotif += "<a href='javascript:cmdGoNotifDetail(\""+appUser.getOID()+"\",\""+nf.getOID()+"\")'> "+countKaryawanBerakhirSertifikasi+" Karyawan akan berakhir sertifikasi dalam "+(lenghtDay > 0 ? lenghtDay+" hari kedepan" : "hari ini")+"</a>";

                }
                break;
            case PstNotification.NOTIF_CUTI_TAHUNAN_ATAU_CUTI_BESAR:
                lenghtDay = PstNotification.checkLenghtNotifByUser(appUser.getOID(),PstNotification.NOTIF_CUTI_TAHUNAN_ATAU_CUTI_BESAR, nf.getOID());
                whereClause = "lv.`TYPE_LEAVE_CATEGORY` IN (3,4,1) "
                        + " AND ((tk.`TAKEN_DATE` BETWEEN DATE_FORMAT(NOW(), '%Y-%m-%e') AND DATE_ADD(DATE_FORMAT(NOW(), '%Y-%m-%e'), INTERVAL "+lenghtDay+" DAY)) OR "
                        + " (ll.`TAKEN_DATE` BETWEEN DATE_FORMAT(NOW(), '%Y-%m-%e') AND DATE_ADD(DATE_FORMAT(NOW(), '%Y-%m-%e'), INTERVAL "+lenghtDay+" DAY)))"
                        + " AND lv.DOC_STATUS IN (1,2,3) AND doc.`LEAVE_APPLICATION_ID` IS NULL";
                inDivision = PstNotification.getUserDivisionMap(PstNotification.NOTIF_CUTI_TAHUNAN_ATAU_CUTI_BESAR, nf.getOID());
                if (inDivision.length()>0){
                    whereClause += " AND emp."+PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID]+" IN ("+inDivision+")";
                }
                int cntCuti = getCountLeave(whereClause);
                if(cntCuti > 0){  
                    totalNotif += 1;
                    linkNotif += "<a href='javascript:cmdGoNotifDetail(\""+appUser.getOID()+"\",\""+nf.getOID()+"\")'> "+cntCuti+" Cuti Besar atau Tahunan belum dibuatkan Berita Acara</a>";

                }
                break;
            case PstNotification.NOTIF_STOK_CUTI_MINUS:
                inDivision = PstNotification.getUserDivisionMap(PstNotification.NOTIF_STOK_CUTI_MINUS, nf.getOID());
                whereClause = "";
                if (inDivision.length()>0){
                    whereClause += " AND emp."+PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID]+" IN ("+inDivision+")";
                }
                int count = PstNotification.countEmpLeaveMinus(whereClause);
                if (count > 0){
                    totalNotif += 1;
                    linkNotif += "<a href='javascript:cmdGoNotifDetail(\""+appUser.getOID()+"\",\""+nf.getOID()+"\")'> "+count+" Karyawan Memiliki Stok Cuti Minus</a>";
                }
                break;
            case PstNotification.NOTIF_VALID_UNTIL_WARNING:
                lenghtDay = PstNotification.checkLenghtNotifByUser(appUser.getOID(),PstNotification.NOTIF_VALID_UNTIL_WARNING, nf.getOID());
                inDivision = PstNotification.getUserDivisionMap(PstNotification.NOTIF_VALID_UNTIL_WARNING, nf.getOID());
                whereClause = " warn.`VALID_UNTIL` BETWEEN   CURDATE()  AND (CURDATE()+INTERVAL "+lenghtDay+" DAY) ";
                if (inDivision.length()>0){
                    whereClause += " AND emp."+PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID]+" IN ("+inDivision+")";
                }
                int countNotifWarning = PstNotification.countEmpWarningNotif(whereClause);
                if (countNotifWarning > 0){
                    totalNotif += 1;
                    linkNotif += "<a href='javascript:cmdGoNotifDetail(\""+appUser.getOID()+"\",\""+nf.getOID()+"\")'> "+countNotifWarning+" Karyawan Memiliki Surat Peringatan yang akan berakhir</a>";
                }
                break;
            case PstNotification.NOTIF_VALID_UNTIL_REPRIMAND:
                lenghtDay = PstNotification.checkLenghtNotifByUser(appUser.getOID(),PstNotification.NOTIF_VALID_UNTIL_REPRIMAND, nf.getOID());
                inDivision = PstNotification.getUserDivisionMap(PstNotification.NOTIF_VALID_UNTIL_REPRIMAND, nf.getOID());
                whereClause = " reprimand.`VALID_UNTIL` BETWEEN   CURDATE()  AND (CURDATE()+INTERVAL "+lenghtDay+" DAY) ";
                if (inDivision.length()>0){
                    whereClause += " AND emp."+PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID]+" IN ("+inDivision+")";
                }
                int countNotifReprimand = PstNotification.countEmpReprimandNotif(whereClause);
                if (countNotifReprimand > 0){
                    totalNotif += 1;
                    linkNotif += "<a href='javascript:cmdGoNotifDetail(\""+appUser.getOID()+"\",\""+nf.getOID()+"\")'> "+countNotifReprimand+" Karyawan Memiliki Surat Teguran yang akan berakhir</a>";
                }
                break;
        }
    }
    
    boolean viewNotifEndContract = PstNotification.checkPrivNotification(appUser.getOID(),PstNotification.NOTIF_KARYAWAN_HABIS_KONTRAK); // habis kontrak
    boolean viewPenghargaan = PstNotification.checkPrivNotification(appUser.getOID(), PstNotification.NOTIF_PENGHARAGAAN_KARYAWAN);
    boolean viewPensiunKaryawan = PstNotification.checkPrivNotification(appUser.getOID(),PstNotification.NOTIF_KARYAWAN_PENSIUN); // pension
    boolean viewUlangTahunKaryawan = PstNotification.checkPrivNotification(appUser.getOID(),PstNotification.NOTIF_ULANG_TAHUN_KARYAWAN); // ulang tahun
    boolean viewKaryawanMBT =  PstNotification.checkPrivNotification(appUser.getOID(),PstNotification.NOTIF_KARYAWAN_MBT);
    boolean viewKaryawanBerakhirSertifikasi =  PstNotification.checkPrivNotification(appUser.getOID(),PstNotification.NOTIF_BEARKHIRNYA_SERTIFIKASI);
    
    
    //end add by Eri Yudi                  
                        
    for (int i = 0; i < PstLeaveApplication.fieldTypeLeaveCategory.length; i++) {
        if (i == PstLeaveApplication.FLD_TYPE_LEAVE_CATEGORY_SPECIAL) {
            if (listSchedule.size() > 0) {
                for (int x = 0; x < listSchedule.size(); x++) {
                    ScheduleSymbol scheduleSymbol = (ScheduleSymbol) listSchedule.get(x);
                    String whereSch = PstSpecialUnpaidLeaveTaken.TBL_SPECIAL_UNPAID_LEAVE_TAKEN + "." + PstSpecialUnpaidLeaveTaken.fieldNames[PstSpecialUnpaidLeaveTaken.FLD_SCHEDULED_ID] + "=" + scheduleSymbol.getOID();
                    int leaveNotif = PstLeaveApplication.getLeaveNotification(employeeId, divisionId, whereSch);
                    if (leaveNotif != 0) {
                        totalNotif += leaveNotif;
                        linkNotif += "<a href='javascript:cmdGoToApproval(" + i + ", \"" + scheduleSymbol.getOID() + "\")'>" + leaveNotif + " Orang " + scheduleSymbol.getSchedule() + "</a>";
                    }
                }
            }
        } else {
            String whereLv = PstLeaveApplication.TBL_LEAVE_APPLICATION + "." + PstLeaveApplication.fieldNames[PstLeaveApplication.FLD_TYPE_LEAVE_CATEGORY] + "=" + i;
            int leaveNotif = PstLeaveApplication.getLeaveNotification(employeeId, divisionId, whereLv);
            if (leaveNotif != 0) {
                totalNotif += leaveNotif;
                linkNotif += "<a href='javascript:cmdGoToApproval(" + i + ",0)'>" + leaveNotif + " Orang " + PstLeaveApplication.fieldTypeLeaveCategory[i] + "</a>";
            }
        }
    }
	
	int leaveNotifCancel = PstLeaveApplication.getToBeCancelNotif(employeeId);
	if (leaveNotifCancel != 0){
		totalNotif += leaveNotifCancel;
		linkNotif += "<a href='javascript:cmdGoToApproveCancel()'>" + leaveNotifCancel + " Orang Membatalkan Cuti </a>";
	}

 //hide by eri 2020-06-24 untuk atasi eror
	int ovtNotifCancel = PstOvertime.getOvertimeNotif(employeeId, divisionId);
	if (ovtNotifCancel != 0){
		totalNotif += ovtNotifCancel;
		String overtimeNum = PstOvertime.getOvertimeNotifNum(employeeId, divisionId);
		linkNotif += "<a href='javascript:cmdGoToOvertime(\""+overtimeNum+"\")'>" + ovtNotifCancel + " Form Lembur </a>";
	}

	int kpiNotif = PstKpiTarget.getNotification(employeeId, divisionId, "");
	if (kpiNotif != 0){
		totalNotif += kpiNotif;
		linkNotif += "<a href='javascript:cmdGoToApprovalKpi()'>" + kpiNotif + " Orang Mengajukan KPI </a>";
	}
	
	int kpiAchievNotif = PstKPI_Employee_Achiev.getNotification(employeeId, divisionId, "");
	if (kpiAchievNotif != 0){
		totalNotif += kpiAchievNotif;
		linkNotif += "<a href='javascript:cmdGoToApprovalKpiAchiev()'>" + kpiAchievNotif + " Orang Input KPI Achievment </a>";
	}
        
        int dataChangeNotif = PstLogSysHistory.getDataChangeNotification(employeeId, divisionId);
        if (dataChangeNotif != 0){
		totalNotif += dataChangeNotif;
		linkNotif += "<a href='javascript:cmdGoToApprovalData()'>" + dataChangeNotif + " Data menunggu approval </a>";
	}
	
    JSONObject object = new JSONObject();
    try {
        object.put("total", totalNotif);
        object.put("link", linkNotif);
    } catch (Exception e) {

    }
%>

<%=object%>
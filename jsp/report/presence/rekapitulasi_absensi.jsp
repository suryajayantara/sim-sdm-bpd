<%-- 
    Document   : rekapitulasi_absensi
    Created on : Jan, 2015, 10:42:46 AM
    Author     : Priska
--%>


<%@page import="com.dimata.harisma.entity.payroll.PayPeriod"%>
<%@page import="com.dimata.harisma.entity.payroll.PstPayPeriod"%>
<%@page import="com.dimata.harisma.entity.payroll.PstPaySlipComp"%>
<%@page import="com.dimata.harisma.entity.payroll.PstPayComponent"%>
<%@page import="com.dimata.harisma.session.leave.LeaveConfigDinamis"%>
<%@page import="com.dimata.harisma.entity.payroll.PstPayEmpLevel"%>
<%@page import="org.apache.jasper.tagplugins.jstl.core.ForEach"%>
<%@page import="com.dimata.harisma.entity.masterdata.payday.PstPayDay"%>
<%@page import="com.dimata.harisma.entity.masterdata.payday.HashTblPayDay"%>
<%@page import="com.dimata.harisma.session.attendance.rekapitulasiabsensi.RekapitulasiAbsensi"%>
<%@page import="com.dimata.harisma.entity.masterdata.sesssection.SessSection"%>
<%@page import="com.dimata.harisma.entity.masterdata.sessemployee.EmployeeMinimalis"%>
<%@page import="com.dimata.harisma.entity.masterdata.sessemployee.SessEmployee"%>
<%@page import="com.dimata.harisma.entity.masterdata.sessdepartment.SessDepartment"%>
<%@page import="com.dimata.harisma.entity.masterdata.sessdivision.SessDivision"%>
<%@page import="com.dimata.harisma.report.attendance.TmpListParamAttdSummary"%>
<%@page import="com.dimata.harisma.report.attendance.AttendanceSummaryXls"%>
<%@page import="com.dimata.harisma.form.payroll.FrmPayInput"%>
<%@page import="com.dimata.harisma.entity.overtime.TableHitungOvertimeDetail"%>
<%@page import="com.dimata.harisma.entity.payroll.PstPaySlip"%>
<%@page import="com.dimata.harisma.entity.payroll.PstPayInput"%>
<%@page import="com.dimata.harisma.session.leave.SessLeaveApp"%>
<%@page import="com.dimata.harisma.entity.overtime.HashTblOvertimeDetail"%>
<%@page import="com.dimata.harisma.entity.payroll.PayComponent"%>
<%@page import="com.dimata.harisma.session.payroll.I_PayrollCalculator"%>
<%@page import="com.lowagie.text.Document"%>
<%@page import="com.dimata.qdep.db.DBHandler"%>
<%@page import="org.apache.poi.hssf.record.ContinueRecord"%>
<%@page import="com.dimata.qdep.entity.I_DocStatus"%>
<%@page import="com.dimata.harisma.entity.overtime.Overtime"%>
<%@page import="com.dimata.harisma.entity.overtime.OvertimeDetail"%>
<%@page import="com.dimata.harisma.entity.overtime.PstOvertimeDetail"%>
<%@page import="org.apache.jasper.tagplugins.jstl.core.Catch"%>
<%@page import="com.dimata.harisma.entity.attendance.PstEmpSchedule"%>
<%@ page language="java" %>

<%@ page import ="java.util.*"%>
<%@ page import = "java.util.Date" %>
<%@ page import = "java.text.*" %>

<%@ page import ="com.dimata.gui.jsp.*"%>
<%@ page import ="com.dimata.util.*"%>
<%@ page import ="com.dimata.qdep.form.*"%>

<%@ page import ="com.dimata.harisma.entity.masterdata.*"%>
<%@ page import ="com.dimata.harisma.entity.employee.*"%>
<%@ page import = "com.dimata.harisma.form.attendance.*" %>
<%@ page import ="com.dimata.harisma.session.attendance.*"%>
<%@ page import = "com.dimata.harisma.entity.attendance.*" %>
<%@ page import = "com.dimata.harisma.entity.attendance.*" %>
<%@ page import = "com.dimata.harisma.form.attendance.*" %>
<%@ page import = "com.dimata.harisma.session.attendance.*" %>
<%@ page import = "com.dimata.harisma.entity.admin.*" %>
<%@ page import = "com.dimata.harisma.entity.search.*" %>
<%@ page import = "com.dimata.harisma.form.search.*" %>
<%@ page import = "com.dimata.harisma.entity.employee.*" %>
<%@ page import = "com.dimata.harisma.entity.leave.*" %>
<%@ page import = "com.dimata.harisma.form.leave.*" %>
<%@ include file = "../../main/javainit.jsp" %>

<%!    
    private static Vector logicParser(String text) {
        Vector vector = LogicParser.textSentence(text);
        for (int i = 0; i < vector.size(); i++) {
            String code = (String) vector.get(i);
            if (((vector.get(vector.size() - 1)).equals(LogicParser.SIGN))
                    && ((vector.get(vector.size() - 1)).equals(LogicParser.ENGLISH))) {
                vector.remove(vector.size() - 1);
            }
        }
        return vector;
    }
%>
<% int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_REPORTS, AppObjInfo.G2_PRESENCE_REPORT, AppObjInfo.OBJ_PRESENCE_REPORT);
    int appObjCodePresenceEdit = AppObjInfo.composeObjCode(AppObjInfo.G1_EMPLOYEE, AppObjInfo.G2_ATTENDANCE, AppObjInfo.OBJ_PRESENCE);
    boolean privUpdatePresence = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodePresenceEdit, AppObjInfo.COMMAND_UPDATE));
%>
<%@ include file = "../../main/checkuser.jsp" %>
<%
    /* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
    //boolean privPrint = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_PRINT));

    long hrdDepOid = Long.parseLong(String.valueOf(PstSystemProperty.getPropertyLongbyName(OID_HRD_DEPARTMENT)));
    boolean isHRDLogin = true ;
    
    long edpSectionOid = Long.parseLong(String.valueOf(PstSystemProperty.getPropertyLongbyName(OID_EDP_SECTION)));
    boolean isEdpLogin = edpSectionOid == sectionOfLoginUser.getOID() ? true : false;
    boolean isGeneralManager = positionType == PstPosition.LEVEL_GENERAL_MANAGER ? true : false;

//cek tipe browser, browser detection
    //String userAgent = request.getHeader("User-Agent");
    //boolean isMSIE = (userAgent!=null && userAgent.indexOf("MSIE") !=-1); 

%>
<%!    public String drawList(JspWriter outJsp,RekapitulasiAbsensi rekapitulasiAbsensi,Vector listCompany,Hashtable hashDivision,Hashtable hashDepartment,Hashtable hashSection,Hashtable hashEmployee,Hashtable hashEmployeeSection,Hashtable listAttdAbsensi,Vector vReason, int viewschedule) {
        String result = "";
        if(rekapitulasiAbsensi==null){
            return result; 
        }
        
         String K = "";
        ControlList ctrlist = new ControlList();
        ctrlist.setAreaWidth("100%");
        ctrlist.setListStyle("listgen");
        ctrlist.setTitleStyle("listgentitle");
        ctrlist.setCellStyle("listgensell");
        //ctrlist.setCellStyles("listgensellstyles");
        ctrlist.setRowSelectedStyles("rowselectedstyles");
        ctrlist.setHeaderStyle("listheaderJs");
        //ctrlist.setStyleSelectableTableValue("id=\"selectable\""); 
        ctrlist.setMaxFreezingTable(2);
        //mengambil nama dari kode komponent
        
        ctrlist.addHeader("Head Count", "5%", "2", "0");
        ctrlist.addHeader("NRK", "5%", "2", "0");
        ctrlist.addHeader("Nama", "5%", "2", "0");
        ctrlist.addHeader("Jabatan", "5%", "2", "0");
        ctrlist.addHeader("Hari K", "3%", "2", "0");
        ctrlist.addHeader("Hadir", "3%", "2", "0"); 
        //ctrlist.addHeader("Tugas Belajar", "3%", "2", "0"); 
        //ctrlist.addHeader("Dinas Luar", "3%", "2", "0"); 
        ctrlist.addHeader("Cuti Besar", "3%", "2", "0"); 
        ctrlist.addHeader("Cuti Tahunan", "3%", "2", "0"); 
        ctrlist.addHeader("Cuti Penting", "3%", "2", "0"); 
        ctrlist.addHeader("Sakit", "3%", "2", "0"); 
        ctrlist.addHeader("Cuti Hamil", "3%", "2", "0"); 
        //ctrlist.addHeader("Detasir", "3%", "2", "0"); 
        //ctrlist.addHeader("Dispen", "3%", "2", "0"); 
        //ctrlist.addHeader("Belum ada ket.", "3%", "2", "0"); 
        
        
        if(vReason!=null && vReason.size()>0){
            for(int d=0;d<vReason.size();d++){
                Reason reason = (Reason)vReason.get(d);
                ctrlist.addHeader(""+reason.getKodeReason(), "5%", "2", "0"); 
            }
        }
        ctrlist.addHeader("No. Rek", "3%", "2", "0"); 
        ctrlist.addHeader("Total Uang Makan", "5%", "2", "0");

        //priska 20150619
        long dayOFF =0;
            try{
                dayOFF = Long.parseLong(PstSystemProperty.getValueByName("OID_DAY_OFF"));
             }catch(Exception ex){
                 System.out.println("OID_DAY_OFF NOT Be SET"+ex);
                 dayOFF = 0;
             }
        
         long extraDayOFF =0;
            try{
              extraDayOFF = Long.parseLong(PstSystemProperty.getValueByName("OID_EXTRA_OFF"));
             }catch(Exception ex){
                 System.out.println("OID_DAY_OFF NOT Be SET"+ex);
                 extraDayOFF = 0;
             }
         
            long intAl =0;
            try{
                String sintAl = PstSystemProperty.getValueByName("VALUE_ANNUAL_LEAVE"); 
                intAl = Integer.parseInt(sintAl);
             }catch(Exception ex){
                 System.out.println("VALUE_ANNUAL_LEAVE NOT Be SET"+ex);
                 intAl = 0;
             }
                
                long intDp =0;
            try{
                String sintDp = PstSystemProperty.getValueByName("VALUE_DAY_OF_PAYMENT"); 
                intDp = Integer.parseInt(sintDp);
             }catch(Exception ex){
                 System.out.println("VALUE_DAY_OF_PAYMENT NOT Be SET"+ex);
                 intDp = 0;
             }
            
            long intB =0;
            try{
                String sintB = PstSystemProperty.getValueByName("VALUE_B_REASON_SYMBOL"); 
                intB = Integer.parseInt(sintB);
             }catch(Exception ex){
                 System.out.println("VALUE_DAY_OF_PAYMENT NOT Be SET"+ex);
                 intB = 0;
             } 
         
                    
        long diffStartToFinish = 0;
        int itDate = 0;



        ctrlist.setLinkRow(0);
        ctrlist.setLinkSufix("");
        ctrlist.setLinkPrefix("javascript:cmdEdit('");
        ctrlist.setLinkSufix("')");
        ctrlist.reset();
        int index = -1;
        String empNumTest = "";
        int no = 0;
        int totalpercompany = 0;
        try {
            if (rekapitulasiAbsensi.getDtFrom() != null && rekapitulasiAbsensi.getDtTo() != null && listCompany!=null && listCompany.size()>0) {
                ctrlist.drawListHeaderWithJsVer2(outJsp);//header
                // membuat variable
                RekapitulasiPresenceDanSchedule rekapitulasiPresenceDanSchedule = new RekapitulasiPresenceDanSchedule();
                //listAttdAbsensi = PstEmpSchedule.getListAttendaceRekap(attdConfig,leaveConfig,selectedDateFrom, selectedDateTo, getListEmployeeId, vctSchIDOff, hashSchOff, iPropInsentifLevel, holidaysTable, hashPositionLevel, payrollCalculatorConfig,hashPeriod,hashTblOvertimeDetail);
                 
                if (listCompany != null && listCompany.size() > 0) { 
                    for (int idxcom = 0; idxcom < listCompany.size(); idxcom++) {
                        Company company = (Company) listCompany.get(idxcom);
                        Vector rowx = new Vector();
                        rowx.add("");
                        rowx.add("<font color=\"red\"> <B># " + company.getCompany() + "</B></font>");
                        rowx.add("");
                        rowx.add("");
                        rowx.add("");
                        rowx.add("");
                        //rowx.add("");
                        //rowx.add("");
                        rowx.add("");
                        rowx.add("");
                        rowx.add("");
                        rowx.add("");
                        rowx.add("");
                        //rowx.add("");
                        //rowx.add("");
                        //rowx.add("");
                        
                        
                        if(vReason!=null && vReason.size()>0){
                            for(int d=0;d<vReason.size();d++){
                                rowx.add(""); 
                            }
                        }
                        rowx.add("");
                        rowx.add("");
                        
                        ctrlist.drawListRowJsVer2(outJsp, 0, rowx, idxcom);
                        int TotalEmployeePerCompany=0;
                        RekapitulasiAbsensiGrandTotal rekapitulasiAbsensiGrandTotalPerCompany = new RekapitulasiAbsensiGrandTotal();
                        if (hashDivision != null && hashDivision.size() > 0) {
                            SessDivision sessDivision = (SessDivision) hashDivision.get(company.getOID());
                            if (sessDivision != null && sessDivision.getListDivision() != null) {
                                for (int idxDiv = 0; idxDiv < sessDivision.getListDivision().size(); idxDiv++) {
                                    Division division = (Division) sessDivision.getListDivision().get(idxDiv);
                                    rowx = new Vector();
                                    rowx.add("");
                                    rowx.add(" &nbsp;> " + division.getDivision());
                                    rowx.add("");
                                    rowx.add("");
                                    rowx.add("");
                                    rowx.add("");
                                    //rowx.add("");
                                    //rowx.add("");
                                    rowx.add("");
                                    rowx.add("");
                                    rowx.add("");
                                    rowx.add("");
                                    rowx.add("");
                                    //rowx.add("");
                                    //rowx.add("");
                                    //rowx.add("");
                                    
                                    
                                    if(vReason!=null && vReason.size()>0){
                                        for(int d=0;d<vReason.size();d++){
                                            rowx.add(""); 
                                        }
                                    }
                                    
                                    rowx.add("");
                                    rowx.add("");
                                    
                                    ctrlist.drawListRowJsVer2(outJsp, 0, rowx, idxDiv);

                                    if (hashDepartment != null && hashDepartment.size() > 0) {
                                        SessDepartment sessDepartment = (SessDepartment) hashDepartment.get(division.getOID());
                                        if (sessDepartment != null && sessDepartment.getListDepartment() != null && sessDepartment.getListDepartment().size() > 0) {
                                            for (int idxDept = 0; idxDept < sessDepartment.getListDepartment().size(); idxDept++) {
                                                Department department = (Department) sessDepartment.getListDepartment().get(idxDept);
                                                //dept
                                                if(department.getOID()==3006L){
                                                    boolean dx=true;
                                                    if(dx){
                                                        int becek=0;
                                                    } 
                                                }
                                                rowx = new Vector();
                                                rowx.add("");
                                                rowx.add(" &nbsp;&nbsp;<b>>> " + department.getDepartment()+"</b>");
                                                rowx.add("");
                                                rowx.add("");
                                                rowx.add("");
                                                rowx.add("");
                                                //rowx.add("");
                                                //rowx.add("");
                                                rowx.add("");
                                                rowx.add("");
                                                rowx.add("");
                                                rowx.add("");
                                                rowx.add("");
                                                //rowx.add("");
                                                //rowx.add("");
                                                //rowx.add("");
                                                
                                                
                                                if(vReason!=null && vReason.size()>0){
                                                    for(int d=0;d<vReason.size();d++){
                                                        rowx.add(""); 
                                                    }
                                                }
                                                
                                                rowx.add("");
                                                rowx.add("");

                                                ctrlist.drawListRowJsVer2(outJsp, 0, rowx, idxDept);

                                                //nanti cek ada kah employee di dept ini sectionnya
                                               int TotalEmployeePerDeptnSection=0;
                                               RekapitulasiAbsensiGrandTotal rekapitulasiAbsensiGrandTotal = new RekapitulasiAbsensiGrandTotal();
                                                if (hashEmployee != null && hashEmployee.size() > 0) { 
                                                    SessEmployee sessEmployee = (SessEmployee) hashEmployee.get(department.getOID());
                                                    Vector sessEmployeeClone =sessEmployee != null && sessEmployee.getListEmployee() != null && sessEmployee.getListEmployee().size() > 0? new Vector(sessEmployee.getListEmployee()):null;
                                                    if (sessEmployeeClone!=null) {
                                                        int noEMployeeNoSection=1;
                                                        
                                                        for (int idxEmp = 0; idxEmp < sessEmployeeClone.size(); idxEmp++) {
                                                           
                                                            EmployeeMinimalis employeeMinimalis = (EmployeeMinimalis) sessEmployeeClone.get(idxEmp);
                                                            //employee cek ada secktion
                                                           rekapitulasiPresenceDanSchedule = new RekapitulasiPresenceDanSchedule(); 
                                                            
                                                            if(employeeMinimalis.getSectionId()==0){
                                                                int hk = 0 ;
                                                                Vector reasonnew = new Vector();
                                                                if(listAttdAbsensi!=null && listAttdAbsensi.size()>0 && listAttdAbsensi.containsKey(""+employeeMinimalis.getOID())){
                                                                 rekapitulasiPresenceDanSchedule = (RekapitulasiPresenceDanSchedule)listAttdAbsensi.get(""+employeeMinimalis.getOID());
                                                                 listAttdAbsensi.remove(""+employeeMinimalis.getOID());
                                                                 //rekapitulasiAbsensiGrandTotal = new RekapitulasiAbsensiGrandTotal();
                                                                 
                                                                 if(vReason!=null && vReason.size()>0){
                                                                    for(int d=0;d<vReason.size();d++){
                                                                        Reason reason = (Reason)vReason.get(d);
                                                                        int totReason=rekapitulasiPresenceDanSchedule.getTotalReason(reason.getNo());

                                                                        if (reason.getNo() == intAl || reason.getNo() == intDp || reason.getNo() == intB ){                                                                                         
                                                                         hk = hk + totReason; 
                                                                        }
                                                                        //rowx.add(""+totReason);
                                                                         reasonnew.add(""+totReason);

                                                                        if(rekapitulasiAbsensiGrandTotal!=null && rekapitulasiAbsensiGrandTotal.getReason().containsKey(""+reason.getNo())){
                                                                        int totRes= rekapitulasiAbsensiGrandTotal.getTotalReason(reason.getNo())+totReason;
                                                                            rekapitulasiAbsensiGrandTotal.addReason(reason.getNo(), totRes);
                                                                        }else{
                                                                            rekapitulasiAbsensiGrandTotal.addReason(reason.getNo(), totReason);
                                                                        }
                                                                                                                                              
                                                                    }
                                                                }
                                                                 //rekapitulasiPresenceDanSchedule.setTotalWorkingDays((rekapitulasiPresenceDanSchedule.getTotalWorkingDays()));
                                                                 rekapitulasiPresenceDanSchedule.setRealTotalReason((hk)); 
                                                                 
                                                                 rekapitulasiAbsensiGrandTotal.setWorkingDays(rekapitulasiAbsensiGrandTotal.getWorkingDays()+rekapitulasiPresenceDanSchedule.getTotalWorkingDays());
                                                                 rekapitulasiAbsensiGrandTotal.setHK(rekapitulasiAbsensiGrandTotal.getHK()+rekapitulasiPresenceDanSchedule.getTotalpresencelateearlyonly());
                                                                 rekapitulasiAbsensiGrandTotal.setH(rekapitulasiAbsensiGrandTotal.getH()+rekapitulasiPresenceDanSchedule.getDayOffSchedule());
                                                                
                                                                 
                                                                 rekapitulasiAbsensiGrandTotal.setLateLebihLimaMenit(rekapitulasiAbsensiGrandTotal.getLateLebihLimaMenit()+rekapitulasiPresenceDanSchedule.getTotalLateLebihLimaMenit());
                                                                 rekapitulasiAbsensiGrandTotal.setAnnualLeave(rekapitulasiAbsensiGrandTotal.getAnnualLeave()+rekapitulasiPresenceDanSchedule.getAnnualLeave());
                                                                 rekapitulasiAbsensiGrandTotal.setdPayment(rekapitulasiAbsensiGrandTotal.getdPayment()+rekapitulasiPresenceDanSchedule.getdPayment());
                                                                 rekapitulasiAbsensiGrandTotal.setUnpaidLeave(rekapitulasiAbsensiGrandTotal.getUnpaidLeave() +rekapitulasiPresenceDanSchedule.getUnpaidLeave());
                                                                 rekapitulasiAbsensiGrandTotal.setSpecialLeave(rekapitulasiAbsensiGrandTotal.getSpecialLeave()+rekapitulasiPresenceDanSchedule.getSpecialLeave());
                                                                 rekapitulasiAbsensiGrandTotal.setSo4j(rekapitulasiAbsensiGrandTotal.getSo4j()+rekapitulasiPresenceDanSchedule.getTotalScheduleOpname4jam());
                                                                 rekapitulasiAbsensiGrandTotal.setSo8j(rekapitulasiAbsensiGrandTotal.getSo8j()+rekapitulasiPresenceDanSchedule.getTotalScheduleOpname8jam());
                                                                 rekapitulasiAbsensiGrandTotal.setS(rekapitulasiAbsensiGrandTotal.getS()+rekapitulasiPresenceDanSchedule.getTotalS());
                                                                 rekapitulasiAbsensiGrandTotal.setSplitShift(rekapitulasiAbsensiGrandTotal.getSplitShift()+rekapitulasiPresenceDanSchedule.getSplitShift());
                                                                 rekapitulasiAbsensiGrandTotal.setNightShift(rekapitulasiAbsensiGrandTotal.getNightShift()+rekapitulasiPresenceDanSchedule.getNightShift());
                                                                 rekapitulasiAbsensiGrandTotal.setPH(rekapitulasiAbsensiGrandTotal.getPH()+rekapitulasiPresenceDanSchedule.getDayPH());
                                                                 rekapitulasiAbsensiGrandTotal.setCH(rekapitulasiAbsensiGrandTotal.getCH()+rekapitulasiPresenceDanSchedule.getcH());
                                                                 rekapitulasiAbsensiGrandTotal.setCP(rekapitulasiAbsensiGrandTotal.getCP()+rekapitulasiPresenceDanSchedule.getcP());
                                                                 rekapitulasiAbsensiGrandTotal.setCAl(rekapitulasiAbsensiGrandTotal.getCAl()+rekapitulasiPresenceDanSchedule.getcAl());
                                                                 rekapitulasiAbsensiGrandTotal.setCH(rekapitulasiAbsensiGrandTotal.getCLl()+rekapitulasiPresenceDanSchedule.getcLl());
                                                                 
                                                                 rekapitulasiAbsensiGrandTotalPerCompany.setWorkingDays(rekapitulasiAbsensiGrandTotalPerCompany.getWorkingDays()+rekapitulasiPresenceDanSchedule.getTotalWorkingDays());
                                                                 rekapitulasiAbsensiGrandTotalPerCompany.setHK(rekapitulasiAbsensiGrandTotalPerCompany.getHK()+rekapitulasiPresenceDanSchedule.getTotalpresencelateearlyonly());
                                                                 rekapitulasiAbsensiGrandTotalPerCompany.setH(rekapitulasiAbsensiGrandTotalPerCompany.getH()+rekapitulasiPresenceDanSchedule.getDayOffSchedule());
                                                                 rekapitulasiAbsensiGrandTotalPerCompany.setLateLebihLimaMenit(rekapitulasiAbsensiGrandTotalPerCompany.getLateLebihLimaMenit()+rekapitulasiPresenceDanSchedule.getTotalLateLebihLimaMenit());
                                                                 rekapitulasiAbsensiGrandTotalPerCompany.setAnnualLeave(rekapitulasiAbsensiGrandTotalPerCompany.getAnnualLeave()+rekapitulasiPresenceDanSchedule.getAnnualLeave());
                                                                 rekapitulasiAbsensiGrandTotalPerCompany.setdPayment(rekapitulasiAbsensiGrandTotalPerCompany.getdPayment()+rekapitulasiPresenceDanSchedule.getdPayment());
                                                                 rekapitulasiAbsensiGrandTotalPerCompany.setSpecialLeave(rekapitulasiAbsensiGrandTotalPerCompany.getSpecialLeave()+rekapitulasiPresenceDanSchedule.getSpecialLeave());
                                                                 rekapitulasiAbsensiGrandTotalPerCompany.setUnpaidLeave(rekapitulasiAbsensiGrandTotalPerCompany.getUnpaidLeave()+rekapitulasiPresenceDanSchedule.getUnpaidLeave());
                                                                 rekapitulasiAbsensiGrandTotalPerCompany.setSo4j(rekapitulasiAbsensiGrandTotalPerCompany.getSo4j()+rekapitulasiPresenceDanSchedule.getTotalScheduleOpname4jam());
                                                                 rekapitulasiAbsensiGrandTotalPerCompany.setSo8j(rekapitulasiAbsensiGrandTotalPerCompany.getSo8j()+rekapitulasiPresenceDanSchedule.getTotalScheduleOpname8jam());
                                                                 rekapitulasiAbsensiGrandTotalPerCompany.setS(rekapitulasiAbsensiGrandTotalPerCompany.getS()+rekapitulasiPresenceDanSchedule.getTotalS());
                                                                 rekapitulasiAbsensiGrandTotalPerCompany.setSplitShift(rekapitulasiAbsensiGrandTotalPerCompany.getSplitShift()+rekapitulasiPresenceDanSchedule.getSplitShift());
                                                                 rekapitulasiAbsensiGrandTotalPerCompany.setNightShift(rekapitulasiAbsensiGrandTotalPerCompany.getNightShift()+rekapitulasiPresenceDanSchedule.getNightShift());
                                                                 rekapitulasiAbsensiGrandTotalPerCompany.setPH(rekapitulasiAbsensiGrandTotalPerCompany.getPH()+rekapitulasiPresenceDanSchedule.getDayPH());
                                                                 
                                                                 rekapitulasiAbsensiGrandTotalPerCompany.setCH(rekapitulasiAbsensiGrandTotalPerCompany.getCH()+rekapitulasiPresenceDanSchedule.getcH());
                                                                 rekapitulasiAbsensiGrandTotalPerCompany.setCP(rekapitulasiAbsensiGrandTotalPerCompany.getCP()+rekapitulasiPresenceDanSchedule.getcP());
                                                                 rekapitulasiAbsensiGrandTotalPerCompany.setCAl(rekapitulasiAbsensiGrandTotalPerCompany.getCAl()+rekapitulasiPresenceDanSchedule.getcAl());
                                                                 rekapitulasiAbsensiGrandTotalPerCompany.setCH(rekapitulasiAbsensiGrandTotalPerCompany.getCLl()+rekapitulasiPresenceDanSchedule.getcLl());
                                                                }
                                                                TotalEmployeePerDeptnSection = TotalEmployeePerDeptnSection+1;
                                                                TotalEmployeePerCompany = TotalEmployeePerCompany + 1; 
                                                                rowx = new Vector();

                                                                Position pos = new Position();
                                                                String position = "";
                                                                try{
                                                                    pos = PstPosition.fetchExc(employeeMinimalis.getPositionId());
                                                                    position = pos.getPosition();
                                                                } catch (Exception exc){

                                                                }
                                                                
                                                                rowx.add("" + (noEMployeeNoSection++));
                                                                rowx.add(""+employeeMinimalis.getEmployeeNum());
                                                                rowx.add(""+employeeMinimalis.getFullName());
                                                                rowx.add(""+position);
                                                                rowx.add(""+rekapitulasiPresenceDanSchedule.getTotalWorkingDays());
                                                                rowx.add(""+rekapitulasiPresenceDanSchedule.getTotalpresencelateearlyonly());
                                                                //rowx.add("TB");
                                                                //rowx.add("DL");
                                                                rowx.add(""+rekapitulasiPresenceDanSchedule.getcLl());
                                                                rowx.add(""+rekapitulasiPresenceDanSchedule.getcAl());
                                                                rowx.add(""+rekapitulasiPresenceDanSchedule.getcP());
                                                                rowx.add(""+rekapitulasiPresenceDanSchedule.getTotalS());
                                                                rowx.add(""+rekapitulasiPresenceDanSchedule.getcH());
                                                                //rowx.add("Detasir");
                                                               //rowx.add("Dispen");
                                                               //rowx.add("Belum ada ket");
                                                                
                                                                
                                                                if(reasonnew!=null && reasonnew.size()>0){
                                                                    for(int d=0;d<reasonnew.size();d++){
                                                                        String reasonn = (String) reasonnew.get(d);
                                                                        rowx.add(""+reasonn) ;
                                                                    }
                                                                } else {
                                                                    for(int d=0;d<vReason.size();d++){
                                                                        rowx.add(""+0) ;
                                                                    }
                                                                }
                                                                double uangMakan = 0;

                                                                Employee emp = new Employee();
                                                                String noRek = "";
                                                                
                                                                try{
                                                                    emp = PstEmployee.fetchExc(employeeMinimalis.getOID());
                                                                    noRek = emp.getNoRekening();
                                                                } catch (Exception exc){

                                                                }
                                                                
                                                                rowx.add(""+noRek);
                                                                uangMakan = PstPaySlipComp.getCompValueEmployee(employeeMinimalis.getOID(), rekapitulasiAbsensi.getPeriodId(), "BNF22");
                                                                rowx.add(""+Formater.formatNumberMataUang(uangMakan, "Rp"));
                                                                
                                                                ctrlist.drawListRowJsVer2(outJsp, 0, rowx, idxEmp);
                                                            }
                                                        }
                                                        
                                                        if(hashSection==null ||  (hashSection != null && hashSection.size() > 0 && hashSection.containsKey(""+department.getOID())==false)){
                                                                rowx = new Vector();
                                                                                                                      
                                                                
                                                                rowx.add("" + (noEMployeeNoSection-1));
                                                                rowx.add("");
                                                                rowx.add("<b>Total Department</b>");  
                                                                rowx.add("");
                                                                rowx.add(""+rekapitulasiAbsensiGrandTotal.getWorkingDays());
                                                                rowx.add(""+rekapitulasiAbsensiGrandTotal.getHK());
                                                                //rowx.add("TB");
                                                                //rowx.add("DL");
                                                                rowx.add(""+rekapitulasiAbsensiGrandTotal.getCLl());
                                                                rowx.add(""+rekapitulasiAbsensiGrandTotal.getCAl());
                                                                rowx.add(""+rekapitulasiAbsensiGrandTotal.getCP());
                                                                rowx.add(""+rekapitulasiAbsensiGrandTotal.getS());
                                                                rowx.add(""+rekapitulasiAbsensiGrandTotal.getCH());
                                                                //rowx.add("Detasir");
                                                                //rowx.add("Dispen");
                                                                //rowx.add("Belum ada ket");
                                                                
                                                                
                                                                 if(vReason!=null && vReason.size()>0){
                                                                    for(int d=0;d<vReason.size();d++){
                                                                        Reason reason = (Reason)vReason.get(d);
                                                                        int totReason=rekapitulasiAbsensiGrandTotal.getGrandTotalReason(reason.getNo());
                                                                        rowx.add(""+totReason);
                                                                    }
                                                                }
                                                                
                                                                rowx.add("No Rek");
                                                                rowx.add("Uang Makan");
                                                                
                                                                
                                                                ctrlist.drawListRowJsVer2(outJsp, 0, rowx, 0); 
                                                        
                                                        }
                                                        
                                                    }
                                                }
                                               
                                                    if (hashSection != null && hashSection.size() > 0 && hashSection.containsKey(""+department.getOID())) {
                                                            SessSection sessSection = (SessSection) hashSection.get(""+department.getOID());
                                                            Vector vSection = sessSection != null && sessSection.getListSection() != null && sessSection.getListSection().size() > 0?new Vector(sessSection.getListSection()):null;
                                                            if (vSection!=null) {
                                                                int loopBarisSection=0;
                                                                for (int idxSec = 0; idxSec < vSection.size(); idxSec++) {
                                                                    Section dSection = (Section) vSection.get(idxSec);
                                                                    //dept
                                                                    loopBarisSection = loopBarisSection + 1;
                                                                    vSection.remove(idxSec);
                                                                    idxSec = idxSec -1;
                                                                    rowx = new Vector();
                                                                    rowx.add("");
                                                                    rowx.add(" &nbsp;&nbsp;<b>>>> " + dSection.getSection()+"</b>");
                                                                    rowx.add("");
                                                                    rowx.add("");
                                                                    rowx.add("");
                                                                    rowx.add("");
                                                                    //rowx.add("");
                                                                    //rowx.add("");
                                                                    rowx.add("");
                                                                    rowx.add("");
                                                                    rowx.add("");
                                                                    rowx.add("");
                                                                    rowx.add("");
                                                                    //rowx.add("");
                                                                    //rowx.add("");
                                                                    //rowx.add("");
                                                                    
                                                                   
                                                                    if(vReason!=null && vReason.size()>0){
                                                                        for(int d=0;d<vReason.size();d++){
                                                                            rowx.add(""); 
                                                                        }
                                                                    }
                                                                    
                                                                    rowx.add("");
                                                                    rowx.add("");
                                                                    
                                                                    ctrlist.drawListRowJsVer2(outJsp, 0, rowx, loopBarisSection);
                                                                    //end dept

                                                                    //nanti cek ada kah employee di dept ini sectionnya
                                                                    int noEMployeeNoSection=1;
                                                                    if (hashEmployeeSection != null && hashEmployeeSection.size() > 0) {
                                                                        SessEmployee sessEmployee = (SessEmployee) hashEmployeeSection.get(dSection.getOID());
                                                                        if (sessEmployee != null && sessEmployee.getListEmployee() != null && sessEmployee.getListEmployee().size() > 0) {
                                                                            RekapitulasiAbsensiGrandTotal rekapitulasiAbsensiGrandTotalSec = new RekapitulasiAbsensiGrandTotal();
                                                                            int loopBarieEMpSec=0;
                                                                            int axx = 0;
                                                                            Vector cloneListEMp = sessEmployee.getListEmployee()!=null && sessEmployee.getListEmployee().size()>0?new Vector(sessEmployee.getListEmployee()):new Vector();
                                                                            for (int idxEmpSec = 0; idxEmpSec < cloneListEMp.size(); idxEmpSec++) {
                                                                                axx += 1;
                                                                                EmployeeMinimalis employeeMinimalis = (EmployeeMinimalis) cloneListEMp.get(idxEmpSec);
                                                                                K = employeeMinimalis.getEmployeeNum()+"-"+idxEmpSec;
                                                                                //employee cek ada secktion
                                                                                rekapitulasiPresenceDanSchedule = new RekapitulasiPresenceDanSchedule(); 
                                                                                
                                                                                if(employeeMinimalis.getSectionId()!=0){
                                                                                    Vector reasonnew = new Vector();
                                                                                    int hk = 0;
                                                                                    if(listAttdAbsensi!=null && listAttdAbsensi.size()>0 && listAttdAbsensi.containsKey(""+employeeMinimalis.getOID())){
                                                                                     rekapitulasiPresenceDanSchedule = (RekapitulasiPresenceDanSchedule)listAttdAbsensi.get(""+employeeMinimalis.getOID());
                                                                                     listAttdAbsensi.remove(""+employeeMinimalis.getOID());
                                                                                     //rekapitulasiAbsensiGrandTotal = new RekapitulasiAbsensiGrandTotal();
                                                                                     //rekapitulasiAbsensiGrandTotal.setHK(rekapitulasiAbsensiGrandTotal.getHK()+rekapitulasiPresenceDanSchedule.getTotalpresencelateearlyonly());
                                                                                     
                                                                                      if(vReason!=null && vReason.size()>0){
                                                                                        for(int d=0;d<vReason.size();d++){
                                                                                            Reason reason = (Reason)vReason.get(d);
                                                                                            int totReason=rekapitulasiPresenceDanSchedule.getTotalReason(reason.getNo());
                                                                                            if (reason.getNo() == intAl || reason.getNo() == intDp || reason.getNo() == intB ){
                                                                                            hk = hk + totReason; 
                                                                                               }
                                                                                            //rowx.add(""+totReason);
                                                                                            reasonnew.add(""+totReason);
                                                                                            if(rekapitulasiAbsensiGrandTotalSec!=null && rekapitulasiAbsensiGrandTotalSec.getReason().containsKey(""+reason.getNo())){
                                                                                                int totRes= rekapitulasiAbsensiGrandTotalSec.getTotalReason(reason.getNo())+totReason;
                                                                                                rekapitulasiAbsensiGrandTotalSec.addReason(reason.getNo(), totRes);
                                                                                            }else{
                                                                                                rekapitulasiAbsensiGrandTotalSec.addReason(reason.getNo(), totReason);
                                                                                            }
                                                                                            if(rekapitulasiAbsensiGrandTotal!=null && rekapitulasiAbsensiGrandTotal.getReason().containsKey(""+reason.getNo())){
                                                                                                int totRes= rekapitulasiAbsensiGrandTotal.getTotalReason(reason.getNo())+totReason;
                                                                                                rekapitulasiAbsensiGrandTotal.addReason(reason.getNo(), totRes);
                                                                                            }else{
                                                                                                rekapitulasiAbsensiGrandTotal.addReason(reason.getNo(), totReason);
                                                                                            }
                                                                                            
                                             
                                                                                        }
                                                                                    }
                                                                                     
                                                                                     //rekapitulasiPresenceDanSchedule.setTotalWorkingDays((rekapitulasiPresenceDanSchedule.getTotalWorkingDays()));
                                                                                     rekapitulasiPresenceDanSchedule.setRealTotalReason((hk));   
                                                                                     
                                                                                     rekapitulasiAbsensiGrandTotal.setWorkingDays(rekapitulasiAbsensiGrandTotal.getWorkingDays()+rekapitulasiPresenceDanSchedule.getTotalWorkingDays());
                                                                                     rekapitulasiAbsensiGrandTotal.setHK(rekapitulasiAbsensiGrandTotal.getHK()+rekapitulasiPresenceDanSchedule.getTotalpresencelateearlyonly());
                                                                                     rekapitulasiAbsensiGrandTotal.setH(rekapitulasiAbsensiGrandTotal.getH()+rekapitulasiPresenceDanSchedule.getDayOffSchedule());
                                                                                     rekapitulasiAbsensiGrandTotal.setLateLebihLimaMenit(rekapitulasiAbsensiGrandTotal.getLateLebihLimaMenit()+rekapitulasiPresenceDanSchedule.getTotalLateLebihLimaMenit());
                                                                                     rekapitulasiAbsensiGrandTotal.setAnnualLeave(rekapitulasiAbsensiGrandTotal.getAnnualLeave()+rekapitulasiPresenceDanSchedule.getAnnualLeave());
                                                                                     rekapitulasiAbsensiGrandTotal.setdPayment(rekapitulasiAbsensiGrandTotal.getdPayment()+rekapitulasiPresenceDanSchedule.getdPayment());
                                                                                     
                                                                                     rekapitulasiAbsensiGrandTotal.setUnpaidLeave(rekapitulasiAbsensiGrandTotal.getUnpaidLeave()+rekapitulasiPresenceDanSchedule.getUnpaidLeave());
                                                                                     rekapitulasiAbsensiGrandTotal.setSpecialLeave(rekapitulasiAbsensiGrandTotal.getSpecialLeave()+rekapitulasiPresenceDanSchedule.getSpecialLeave());
                                                                                     
                                                                                     rekapitulasiAbsensiGrandTotal.setSo4j(rekapitulasiAbsensiGrandTotal.getSo4j()+rekapitulasiPresenceDanSchedule.getTotalScheduleOpname4jam());
                                                                                     rekapitulasiAbsensiGrandTotal.setSo8j(rekapitulasiAbsensiGrandTotal.getSo8j()+rekapitulasiPresenceDanSchedule.getTotalScheduleOpname8jam());
                                                                                     rekapitulasiAbsensiGrandTotal.setS(rekapitulasiAbsensiGrandTotal.getS()+rekapitulasiPresenceDanSchedule.getTotalS());
                                                                                     rekapitulasiAbsensiGrandTotal.setSplitShift(rekapitulasiAbsensiGrandTotal.getSplitShift()+rekapitulasiPresenceDanSchedule.getSplitShift());
                                                                                     rekapitulasiAbsensiGrandTotal.setNightShift(rekapitulasiAbsensiGrandTotal.getNightShift()+rekapitulasiPresenceDanSchedule.getNightShift());
                                                                                     rekapitulasiAbsensiGrandTotal.setPH(rekapitulasiAbsensiGrandTotal.getPH()+rekapitulasiPresenceDanSchedule.getDayPH());
                                                                                     rekapitulasiAbsensiGrandTotal.setCH(rekapitulasiAbsensiGrandTotal.getCH()+rekapitulasiPresenceDanSchedule.getcH());
                                                                                     rekapitulasiAbsensiGrandTotal.setCP(rekapitulasiAbsensiGrandTotal.getCP()+rekapitulasiPresenceDanSchedule.getcP());
                                                                                     rekapitulasiAbsensiGrandTotal.setCAl(rekapitulasiAbsensiGrandTotal.getCAl()+rekapitulasiPresenceDanSchedule.getcAl());
                                                                                     rekapitulasiAbsensiGrandTotal.setCH(rekapitulasiAbsensiGrandTotal.getCLl()+rekapitulasiPresenceDanSchedule.getcLl());

                                                                                     
                                                                                     rekapitulasiAbsensiGrandTotalSec.setWorkingDays(rekapitulasiAbsensiGrandTotalSec.getWorkingDays()+rekapitulasiPresenceDanSchedule.getTotalWorkingDays());
                                                                                     rekapitulasiAbsensiGrandTotalSec.setHK(rekapitulasiAbsensiGrandTotalSec.getHK()+rekapitulasiPresenceDanSchedule.getTotalpresencelateearlyonly());
                                                                                     //rekapitulasiAbsensiGrandTotalSec.setHK(rekapitulasiAbsensiGrandTotalSec.getHK()+rekapitulasiPresenceDanSchedule.getTotalWorkingDays());
                                                                                     rekapitulasiAbsensiGrandTotalSec.setH(rekapitulasiAbsensiGrandTotalSec.getH()+rekapitulasiPresenceDanSchedule.getDayOffSchedule());
                                                                                     
                                                                                     rekapitulasiAbsensiGrandTotalSec.setLateLebihLimaMenit(rekapitulasiAbsensiGrandTotalSec.getLateLebihLimaMenit()+rekapitulasiPresenceDanSchedule.getTotalLateLebihLimaMenit());
                                                                                     rekapitulasiAbsensiGrandTotalSec.setAnnualLeave(rekapitulasiAbsensiGrandTotalSec.getAnnualLeave()+rekapitulasiPresenceDanSchedule.getAnnualLeave());
                                                                                     rekapitulasiAbsensiGrandTotalSec.setdPayment(rekapitulasiAbsensiGrandTotalSec.getdPayment()+rekapitulasiPresenceDanSchedule.getdPayment());
                                                                                     rekapitulasiAbsensiGrandTotalSec.setUnpaidLeave(rekapitulasiAbsensiGrandTotalSec.getUnpaidLeave()+rekapitulasiPresenceDanSchedule.getUnpaidLeave());
                                                                                     rekapitulasiAbsensiGrandTotalSec.setSpecialLeave(rekapitulasiAbsensiGrandTotalSec.getSpecialLeave()+rekapitulasiPresenceDanSchedule.getSpecialLeave());
                                                                                     
                                                                                     rekapitulasiAbsensiGrandTotalSec.setSo4j(rekapitulasiAbsensiGrandTotalSec.getSo4j()+rekapitulasiPresenceDanSchedule.getTotalScheduleOpname4jam());
                                                                                     rekapitulasiAbsensiGrandTotalSec.setSo8j(rekapitulasiAbsensiGrandTotalSec.getSo8j()+rekapitulasiPresenceDanSchedule.getTotalScheduleOpname8jam());
                                                                                     rekapitulasiAbsensiGrandTotalSec.setS(rekapitulasiAbsensiGrandTotalSec.getS()+rekapitulasiPresenceDanSchedule.getTotalS());
                                                                                     rekapitulasiAbsensiGrandTotalSec.setSplitShift(rekapitulasiAbsensiGrandTotalSec.getSplitShift()+rekapitulasiPresenceDanSchedule.getSplitShift());
                                                                                     rekapitulasiAbsensiGrandTotalSec.setNightShift(rekapitulasiAbsensiGrandTotalSec.getNightShift()+rekapitulasiPresenceDanSchedule.getNightShift());
                                                                                     rekapitulasiAbsensiGrandTotalSec.setPH(rekapitulasiAbsensiGrandTotalSec.getPH()+rekapitulasiPresenceDanSchedule.getDayPH());
                                                                                     rekapitulasiAbsensiGrandTotalSec.setCH(rekapitulasiAbsensiGrandTotalSec.getCH()+rekapitulasiPresenceDanSchedule.getcH());
                                                                                     rekapitulasiAbsensiGrandTotalSec.setCP(rekapitulasiAbsensiGrandTotalSec.getCP()+rekapitulasiPresenceDanSchedule.getcP());
                                                                                     rekapitulasiAbsensiGrandTotalSec.setCAl(rekapitulasiAbsensiGrandTotalSec.getCAl()+rekapitulasiPresenceDanSchedule.getcAl());
                                                                                     rekapitulasiAbsensiGrandTotalSec.setCH(rekapitulasiAbsensiGrandTotalSec.getCLl()+rekapitulasiPresenceDanSchedule.getcLl());
                                                                 
                                                                                     rekapitulasiAbsensiGrandTotalPerCompany.setWorkingDays(rekapitulasiAbsensiGrandTotalPerCompany.getWorkingDays()+rekapitulasiPresenceDanSchedule.getTotalWorkingDays());
                                                                                     rekapitulasiAbsensiGrandTotalPerCompany.setHK(rekapitulasiAbsensiGrandTotalPerCompany.getHK()+rekapitulasiPresenceDanSchedule.getTotalpresencelateearlyonly());
                                                                                     rekapitulasiAbsensiGrandTotalPerCompany.setH(rekapitulasiAbsensiGrandTotalPerCompany.getH()+rekapitulasiPresenceDanSchedule.getDayOffSchedule());
                                                                                     rekapitulasiAbsensiGrandTotalPerCompany.setLateLebihLimaMenit(rekapitulasiAbsensiGrandTotalPerCompany.getLateLebihLimaMenit()+rekapitulasiPresenceDanSchedule.getTotalLateLebihLimaMenit());
                                                                                     rekapitulasiAbsensiGrandTotalPerCompany.setAnnualLeave(rekapitulasiAbsensiGrandTotalPerCompany.getAnnualLeave()+rekapitulasiPresenceDanSchedule.getAnnualLeave());
                                                                                     rekapitulasiAbsensiGrandTotalPerCompany.setdPayment(rekapitulasiAbsensiGrandTotalPerCompany.getdPayment()+rekapitulasiPresenceDanSchedule.getdPayment());
                                                                                     rekapitulasiAbsensiGrandTotalPerCompany.setSpecialLeave(rekapitulasiAbsensiGrandTotalPerCompany.getSpecialLeave()+rekapitulasiPresenceDanSchedule.getSpecialLeave());
                                                                                     rekapitulasiAbsensiGrandTotalPerCompany.setUnpaidLeave(rekapitulasiAbsensiGrandTotalPerCompany.getUnpaidLeave()+rekapitulasiPresenceDanSchedule.getUnpaidLeave());
                                                                                     rekapitulasiAbsensiGrandTotalPerCompany.setSo4j(rekapitulasiAbsensiGrandTotalPerCompany.getSo4j()+rekapitulasiPresenceDanSchedule.getTotalScheduleOpname4jam());
                                                                                     rekapitulasiAbsensiGrandTotalPerCompany.setSo8j(rekapitulasiAbsensiGrandTotalPerCompany.getSo8j()+rekapitulasiPresenceDanSchedule.getTotalScheduleOpname8jam());
                                                                                     rekapitulasiAbsensiGrandTotalPerCompany.setS(rekapitulasiAbsensiGrandTotalPerCompany.getS()+rekapitulasiPresenceDanSchedule.getTotalS());
                                                                                     rekapitulasiAbsensiGrandTotalPerCompany.setSplitShift(rekapitulasiAbsensiGrandTotalPerCompany.getSplitShift()+rekapitulasiPresenceDanSchedule.getSplitShift());
                                                                                     rekapitulasiAbsensiGrandTotalPerCompany.setNightShift(rekapitulasiAbsensiGrandTotalPerCompany.getNightShift()+rekapitulasiPresenceDanSchedule.getNightShift());
                                                                                     rekapitulasiAbsensiGrandTotalPerCompany.setPH(rekapitulasiAbsensiGrandTotalPerCompany.getPH()+rekapitulasiPresenceDanSchedule.getDayPH());
                                                                                     rekapitulasiAbsensiGrandTotalPerCompany.setCH(rekapitulasiAbsensiGrandTotalPerCompany.getCH()+rekapitulasiPresenceDanSchedule.getcH());
                                                                                     rekapitulasiAbsensiGrandTotalPerCompany.setCP(rekapitulasiAbsensiGrandTotalPerCompany.getCP()+rekapitulasiPresenceDanSchedule.getcP());
                                                                                     rekapitulasiAbsensiGrandTotalPerCompany.setCAl(rekapitulasiAbsensiGrandTotalPerCompany.getCAl()+rekapitulasiPresenceDanSchedule.getcAl());
                                                                                     rekapitulasiAbsensiGrandTotalPerCompany.setCH(rekapitulasiAbsensiGrandTotalPerCompany.getCH()+rekapitulasiPresenceDanSchedule.getcH());
                                                                 
                                                                                }
                                                                                    loopBarieEMpSec = loopBarieEMpSec + 1;
                                                                                    
                                                                                    TotalEmployeePerDeptnSection = TotalEmployeePerDeptnSection+1;
                                                                                    TotalEmployeePerCompany = TotalEmployeePerCompany + 1;
                                                                                    cloneListEMp.remove(idxEmpSec);
                                                                                    idxEmpSec = idxEmpSec -1;
                                                                                    rowx = new Vector();
                                                                                    
                                                                                    Position pos = new Position();
                                                                                    String position = "";

                                                                                    try {
                                                                                        pos = PstPosition.fetchExc(employeeMinimalis.getPositionId());
                                                                                        position = pos.getPosition();
                                                                                    } catch (Exception exc){

                                                                                    }
                                                                                    
                                                                                    rowx.add("" + (noEMployeeNoSection++));
                                                                                    rowx.add(""+employeeMinimalis.getEmployeeNum());
                                                                                    rowx.add(""+employeeMinimalis.getFullName());
                                                                                    rowx.add(""+employeeMinimalis.getPositionId());
                                                                                    rowx.add(""+rekapitulasiPresenceDanSchedule.getTotalWorkingDays());
                                                                                    rowx.add(""+rekapitulasiPresenceDanSchedule.getTotalpresencelateearlyonly());
                                                                                    //rowx.add("TB");
                                                                                    //rowx.add("DL");
                                                                                    rowx.add(""+rekapitulasiPresenceDanSchedule.getcLl());
                                                                                    rowx.add(""+rekapitulasiPresenceDanSchedule.getcAl());
                                                                                    rowx.add(""+rekapitulasiPresenceDanSchedule.getcP());
                                                                                    rowx.add(""+rekapitulasiPresenceDanSchedule.getTotalS());
                                                                                    rowx.add(""+rekapitulasiPresenceDanSchedule.getcH());
                                                                                    //rowx.add("Detasir");
                                                                                    //rowx.add("Dispen");
                                                                                    //rowx.add("Belum ada ket");
                                                                                    
                                                                                    
                                                                                     if(reasonnew!=null && reasonnew.size()>0){
                                                                                        for(int d=0;d<reasonnew.size();d++){
                                                                                            String reasonn = (String) reasonnew.get(d);
                                                                                            rowx.add(""+reasonn) ;
                                                                                        }
                                                                                    } else {
                                                                                        for(int d=0;d<vReason.size();d++){
                                                                                            rowx.add(""+0) ;
                                                                                        }
                                                                                    }

                                                                                    Employee emp = new Employee();
                                                                                    String noRek = "";

                                                                                    try {
                                                                                        emp = PstEmployee.fetchExc(employeeMinimalis.getOID());
                                                                                        noRek = emp.getNoRekening();
                                                                                    } catch (Exception exc){

                                                                                    }
                                                                                    
                                                                                    rowx.add(""+noRek);
                                                                                    double uangMakan = 0;
                                                                                    uangMakan = PstPaySlipComp.getCompValueEmployee(employeeMinimalis.getOID(), rekapitulasiAbsensi.getPeriodId(), "BNF22");
                                                                                    rowx.add(""+Formater.formatNumberMataUang(uangMakan, "Rp"));
                                                                                    //rowx.add("Uang Makan");

                                                                                    
                                                                                    ctrlist.drawListRowJsVer2(outJsp, 0, rowx, loopBarieEMpSec);
                                                                                     //end employee list but no section
                                                                                }
                                                                                 ///ini berati employee'nya ada section
                                                                                     //hashEmployeeAdaSection.put(employeeMinimalis.getSectionId(), employeeMinimalis);
                                                                                     //nanti buatlah hashtableEmployee tanpa section dan hasth ada section
                                                                                     //untuk pencarian hari kehadiran, absensi dll pakai fungsi summary attdance nnti itu vector,loop verctor tsb, jika employeeId'nya sama maka hapus lah
                                                                            }//end employee
                                                                            
                                                                            rowx = new Vector();
                                                                            rowx.add("" + (noEMployeeNoSection-1));
                                                                            rowx.add("");
                                                                            rowx.add("<b>Total Section</b>");  
                                                                            rowx.add("");
                                                                            rowx.add(""+rekapitulasiAbsensiGrandTotalSec.getWorkingDays());
                                                                            rowx.add(""+rekapitulasiAbsensiGrandTotalSec.getHK());
                                                                            //rowx.add("TB");
                                                                            //rowx.add("DL");
                                                                            rowx.add(""+rekapitulasiAbsensiGrandTotalSec.getCLl());
                                                                            rowx.add(""+rekapitulasiAbsensiGrandTotalSec.getCAl());
                                                                            rowx.add(""+rekapitulasiAbsensiGrandTotalSec.getCP());
                                                                            rowx.add(""+rekapitulasiAbsensiGrandTotalSec.getS());
                                                                            rowx.add(""+rekapitulasiAbsensiGrandTotalSec.getCH());
                                                                            //rowx.add("Detasir");
                                                                            //rowx.add("Dispen");
                                                                            //rowx.add("Belum ada ket");
                                                                            
                                                                            
                                                                            int totReason = 0;
                                                                            if(vReason!=null && vReason.size()>0){
                                                                                for(int d=0;d<vReason.size();d++){
                                                                                    Reason reason = (Reason)vReason.get(d);
                                                                                    totReason=rekapitulasiAbsensiGrandTotalSec.getGrandTotalReason(reason.getNo());
                                                                                    rowx.add(""+totReason);
                                                                                }
                                                                            }
                                                                            
                                                                            rekapitulasiAbsensiGrandTotalSec.setTotalAlasan(totReason);
                                                                            rowx.add("No Rek");
                                                                            rowx.add("Uang Makan");
                                                                            
                                                                            ctrlist.drawListRowJsVer2(outJsp, 0, rowx, 0); 
                                                                            
                                                                        }//end list emp
                                                                    }//end hasEmployee
                                                                    
                                                                    
                                                                }
                                                            }
                                                            
                                                            //total dept yg ada sectionnya
                                                                            rowx = new Vector();
                                                                            //rowx.add("" + (TotalEmployeePerDeptnSection-1));
                                                                            rowx.add("" + (TotalEmployeePerDeptnSection));
                                                                            rowx.add("");
                                                                            rowx.add("<b>Total Department</b>");  
                                                                            rowx.add("");
                                                                            rowx.add(""+rekapitulasiAbsensiGrandTotal.getWorkingDays());
                                                                            rowx.add(""+rekapitulasiAbsensiGrandTotal.getHK());
                                                                            //rowx.add("TB");
                                                                            //rowx.add("DL");
                                                                            rowx.add(""+rekapitulasiAbsensiGrandTotal.getCLl());
                                                                            rowx.add(""+rekapitulasiAbsensiGrandTotal.getCAl());
                                                                            rowx.add(""+rekapitulasiAbsensiGrandTotal.getCP());
                                                                            rowx.add(""+rekapitulasiAbsensiGrandTotal.getS());
                                                                            rowx.add(""+rekapitulasiAbsensiGrandTotal.getCH());
                                                                            //rowx.add("Detasir");
                                                                            //rowx.add("Dispen");
                                                                            //rowx.add("Belum ada ket");
                                                                            
                                                                           
                                                                            if(vReason!=null && vReason.size()>0){
                                                                                for(int d=0;d<vReason.size();d++){
                                                                                    Reason reason = (Reason)vReason.get(d);
                                                                                    int totReason=rekapitulasiAbsensiGrandTotal.getGrandTotalReason(reason.getNo());
                                                                                    rowx.add(""+totReason);
                                                                                }
                                                                            }
                                                                            rowx.add("No Rek");
                                                                            rowx.add("Uang Makan");
                                                                            
                                                                            
                                                                            ctrlist.drawListRowJsVer2(outJsp, 0, rowx, 0); 
                                                        }
                                            }
                                        }
                                    }
                                }//end loop division
                            }
                        }//end hashDivision
                        ///ini untuk grand total masing" company
                        rowx = new Vector();
                        rowx.add("" + (TotalEmployeePerCompany));
                        rowx.add("");
                        rowx.add("<b>Grand Total ---->>>>></b>");  
                        rowx.add("");
                        rowx.add(""+rekapitulasiAbsensiGrandTotalPerCompany.getWorkingDays());
                        rowx.add(""+rekapitulasiAbsensiGrandTotalPerCompany.getHK());
                        //rowx.add("TB");
                        //rowx.add("DL");
                        rowx.add(""+rekapitulasiAbsensiGrandTotalPerCompany.getCLl());
                        rowx.add(""+rekapitulasiAbsensiGrandTotalPerCompany.getCAl());
                        rowx.add(""+rekapitulasiAbsensiGrandTotalPerCompany.getCP());
                        rowx.add(""+rekapitulasiAbsensiGrandTotalPerCompany.getS());
                        rowx.add(""+rekapitulasiAbsensiGrandTotalPerCompany.getCH());
                        //rowx.add("Detasir");
                        //rowx.add("Dispen");
                        //rowx.add("Belum ada ket");
                        
                       
                        if(vReason!=null && vReason.size()>0){
                            for(int d=0;d<vReason.size();d++){
                                Reason reason = (Reason)vReason.get(d);
                                int totReason=rekapitulasiAbsensiGrandTotalPerCompany.getGrandTotalReason(reason.getNo());
                                rowx.add(""+totReason); 
                            }
                        }
                        rowx.add("No Rek");
                        rowx.add("Uang Makan");
                         ctrlist.drawListRowJsVer2(outJsp, 0, rowx, 0); 
                    }//end company
                }

                result = "";
                ctrlist.drawListEndTableJsVer2(outJsp);
            } else {
                result = "<i>Belum ada data dalam sistem ...</i>";
            }

        } catch (Exception ex) {
            System.out.println("Exception export summary Attd" + " Emp:" + empNumTest + "-" + K +" " + ex);
        }
        return result;
    }

%>

<%!    public String drawListRincian(JspWriter outJsp,RekapitulasiAbsensi rekapitulasiAbsensi,Vector listCompany,Hashtable hashDivision,Hashtable hashDepartment,Hashtable hashSection,Hashtable hashEmployee,Hashtable hashEmployeeSection,Hashtable listAttdAbsensi,HashTblPayDay hashTblPayDay,long oidEmployeeDw, int viewschedule, Hashtable listPayDayfromSalLevel,int OnlyDw) {
        String result = "";
        if(rekapitulasiAbsensi==null){
            return result; 
        }
        
        long dayOFF =0;
            try{
                dayOFF = Long.parseLong(PstSystemProperty.getValueByName("OID_DAY_OFF"));
             }catch(Exception ex){
                 System.out.println("OID_DAY_OFF NOT Be SET"+ex);
                 dayOFF = 0;
             }
          //    OID_DAILYWORKER
           long Dw = 0;
            try{
                String sDw = PstSystemProperty.getValueByName("OID_DAILYWORKER"); 
                Dw = Integer.parseInt(sDw);
             }catch(Exception ex){
                 System.out.println("VALUE_DAILYWORKER NOT Be SET"+ex);
             } 
         long extraDayOFF =0;
            try{
              extraDayOFF = Long.parseLong(PstSystemProperty.getValueByName("OID_EXTRA_OFF"));
             }catch(Exception ex){
                 System.out.println("OID_DAY_OFF NOT Be SET"+ex);
                 extraDayOFF = 0;
             }
         
        
             
        ControlList ctrlist = new ControlList();
        ctrlist.setAreaWidth("100%");
        ctrlist.setListStyle("listgen");
        ctrlist.setTitleStyle("listgentitle");
        ctrlist.setCellStyle("listgensell");
        //ctrlist.setCellStyles("listgensellstyles");
        ctrlist.setRowSelectedStyles("rowselectedstyles");
        ctrlist.setHeaderStyle("listheaderJs");
        //ctrlist.setStyleSelectableTableValue("id=\"selectable\""); 
        ctrlist.setMaxFreezingTable(2);
        //mengambil nama dari kode komponent
        ctrlist.addHeader("Head Count", "5%", "2", "0");
        ctrlist.addHeader("No", "5%", "2", "0");
        ctrlist.addHeader("Nama", "5%", "2", "0");
        String dtStart="-";
        String dtEnd="-";
        if(rekapitulasiAbsensi!=null && rekapitulasiAbsensi.getDtFrom()!=null && rekapitulasiAbsensi.getDtTo()!=null){
            dtStart = Formater.formatDate(rekapitulasiAbsensi.getDtFrom(), "dd MMM yyyy");
            dtEnd = Formater.formatDate(rekapitulasiAbsensi.getDtTo(), "dd MMM yyyy");
        }
        ctrlist.addHeader(""+dtStart+" s/d "+dtEnd, "20%", "0", "1"); 
        ctrlist.addHeader("HK ON PRESENCE", "5%", "0", "0");
        
         ctrlist.addHeader("PER DAY", "5%", "2", "0");
         ctrlist.addHeader("JUMLAH TOTAL", "5%", "2", "0");

      
        long diffStartToFinish = 0;
        int itDate = 0;
        if (rekapitulasiAbsensi.getDtFrom() != null && rekapitulasiAbsensi.getDtTo() != null) { 
            diffStartToFinish = rekapitulasiAbsensi.getDtTo().getTime() - rekapitulasiAbsensi.getDtFrom().getTime();
            if (diffStartToFinish >= 0) {
                itDate = Integer.parseInt(String.valueOf(diffStartToFinish / 86400000)) + 1;
                ctrlist.addHeader("Working Schedule <br>" + Formater.formatDate(rekapitulasiAbsensi.getDtFrom(), "dd MMM yyyy") + " s/d " + Formater.formatDate(rekapitulasiAbsensi.getDtTo(), "dd MMM yyyy"), "20%", "0", "" + itDate);
                for (int idx = 0; idx < itDate; idx++) {
                    Date selectedDate = new Date(rekapitulasiAbsensi.getDtFrom().getYear(), rekapitulasiAbsensi.getDtFrom().getMonth(), (rekapitulasiAbsensi.getDtFrom().getDate() + idx));
                    Date selectedDatePrev = new Date(rekapitulasiAbsensi.getDtFrom().getYear(), rekapitulasiAbsensi.getDtFrom().getMonth(), (rekapitulasiAbsensi.getDtFrom().getDate() + (idx >= 0 ? idx - 1 : idx)));
                    SimpleDateFormat formatterDay = new SimpleDateFormat("EE");
                    String dayString = formatterDay.format(selectedDate);
                    // hanya untuk cobactrlist.addHeader(Formater.formatDate(selectedDate, "dd"), "5%", "0", "0");
                    if (idx != 0 && selectedDate.getYear() == selectedDatePrev.getYear()) {

                        if (dayString.equalsIgnoreCase("Sat")) {
                            ctrlist.addHeader("<font color=\"darkblue\">" + Formater.formatDate(selectedDate, "dd") + "</font>", "5%", "0", "0");
                        } else if (dayString.equalsIgnoreCase("Sun")) {
                            //ctrlist.addHeader("<font color=\"red\">" + Formater.formatDate(selectedDate, "EE") + "<br>" + Formater.formatDate(selectedDate, "MMM dd"), "5%" + "</font>");
                            ctrlist.addHeader("<font color=\"red\">" + Formater.formatDate(selectedDate, "dd") + "</font>", "5%", "0", "0");
                        } else {
                            //ctrlist.addHeader(Formater.formatDate(selectedDate, "EE") + "<br>" + Formater.formatDate(selectedDate, "MMM dd"), "5%");
                            ctrlist.addHeader(Formater.formatDate(selectedDate, "dd"), "5%", "0", "0");
                        }

                    } else {
                        if (dayString.equalsIgnoreCase("Sat")) {
                            //ctrlist.addHeader("<font color=\"darkblue\">" + Formater.formatDate(selectedDate, "EE") + "<br>" + Formater.formatDate(selectedDate, "MMM dd,yy"), "5%", "5%" + "</font>");
                            ctrlist.addHeader("<font color=\"darkblue\">" + Formater.formatDate(selectedDate, "dd") + "</font>", "5%", "0", "0");
                        } else if (dayString.equalsIgnoreCase("Sun")) {
                            //ctrlist.addHeader("<font color=\"red\">" + Formater.formatDate(selectedDate, "EE") + "<br>" + Formater.formatDate(selectedDate, "MMM dd,yy"), "5%", "5%" + "</font>");
                            ctrlist.addHeader("<font color=\"red\">" + Formater.formatDate(selectedDate, "dd") + "</font>", "5%", "0", "0");
                        } else {
                            //ctrlist.addHeader(Formater.formatDate(selectedDate, "EE") + "<br>" + Formater.formatDate(selectedDate, "MMM dd,yy"), "5%");
                            ctrlist.addHeader(Formater.formatDate(selectedDate, "dd"), "5%", "0", "0");
                        }
                    }

                }
            }
        }



        ctrlist.setLinkRow(0);
        ctrlist.setLinkSufix("");
        ctrlist.setLinkPrefix("javascript:cmdEdit('");
        ctrlist.setLinkSufix("')");
        ctrlist.reset();
        int index = -1;
        String empNumTest = "";
        int no = 0;
        try {
            if (rekapitulasiAbsensi.getDtFrom() != null && rekapitulasiAbsensi.getDtTo() != null) {
                ctrlist.drawListHeaderWithJsVer2(outJsp);//header
                // membuat variable
                RekapitulasiPresenceDanSchedule rekapitulasiPresenceDanSchedule = new RekapitulasiPresenceDanSchedule();
                //listAttdAbsensi = PstEmpSchedule.getListAttendaceRekap(attdConfig,leaveConfig,selectedDateFrom, selectedDateTo, getListEmployeeId, vctSchIDOff, hashSchOff, iPropInsentifLevel, holidaysTable, hashPositionLevel, payrollCalculatorConfig,hashPeriod,hashTblOvertimeDetail);
                 
                if (listCompany != null && listCompany.size() > 0) { 
                    for (int idxcom = 0; idxcom < listCompany.size(); idxcom++) {
                        Company company = (Company) listCompany.get(idxcom);
                        Vector rowx = new Vector();
                        rowx.add("");
                        rowx.add("<font color=\"red\"> <B># " + company.getCompany() + "</B></font>");
                        
                        rowx.add("");
                        rowx.add("");
                        rowx.add("");
                        rowx.add("");
                        
                        for (int idx = 0; idx < itDate; idx++) {
                            rowx.add("");
                        }
                     
                        ctrlist.drawListRowJsVer2(outJsp, 0, rowx, idxcom);
                        int TotalEmployeePerCompany=0;
                        RekapitulasiAbsensiGrandTotal rekapitulasiAbsensiGrandTotalPerCompany = new RekapitulasiAbsensiGrandTotal();
                        if (hashDivision != null && hashDivision.size() > 0) {
                            SessDivision sessDivision = (SessDivision) hashDivision.get(company.getOID());
                            if (sessDivision != null && sessDivision.getListDivision() != null) {
                                for (int idxDiv = 0; idxDiv < sessDivision.getListDivision().size(); idxDiv++) {
                                    Division division = (Division) sessDivision.getListDivision().get(idxDiv);
                                    rowx = new Vector();
                                    rowx.add("");
                                    rowx.add(" &nbsp;> " + division.getDivision());
                                   
                                    rowx.add("");
                                    rowx.add("");
                                    rowx.add("");
                                    rowx.add("");
                                   
                                    for (int idx = 0; idx < itDate; idx++) {
                                        rowx.add("");
                                    }
                                    ctrlist.drawListRowJsVer2(outJsp, 0, rowx, idxDiv);

                                    if (hashDepartment != null && hashDepartment.size() > 0) {
                                        SessDepartment sessDepartment = (SessDepartment) hashDepartment.get(division.getOID());
                                        if (sessDepartment != null && sessDepartment.getListDepartment() != null && sessDepartment.getListDepartment().size() > 0) {
                                            for (int idxDept = 0; idxDept < sessDepartment.getListDepartment().size(); idxDept++) {
                                                Department department = (Department) sessDepartment.getListDepartment().get(idxDept);
                                                //dept
                                                if(department.getOID()==3006L){
                                                    boolean dx=true;
                                                    if(dx){
                                                        int becek=0;
                                                    } 
                                                }
                                                rowx = new Vector();
                                                rowx.add("");
                                                rowx.add(" &nbsp;&nbsp;<b>>> " + department.getDepartment()+"</b>");
                                               
                                                rowx.add("");
                                                rowx.add("");
                                                rowx.add("");
                                                rowx.add("");
                                                
                                                for (int idx = 0; idx < itDate; idx++) {
                                                    rowx.add("");
                                                }
                                                ctrlist.drawListRowJsVer2(outJsp, 0, rowx, idxDept);
                                                //end dept

                                                //nanti cek ada kah employee di dept ini sectionnya
                                               int TotalEmployeePerDeptnSection=0;
                                               RekapitulasiAbsensiGrandTotal rekapitulasiAbsensiGrandTotal = new RekapitulasiAbsensiGrandTotal();
                                                if (hashEmployee != null && hashEmployee.size() > 0) { 
                                                    SessEmployee sessEmployee = (SessEmployee) hashEmployee.get(department.getOID());
                                                    if (sessEmployee != null && sessEmployee.getListEmployee() != null && sessEmployee.getListEmployee().size() > 0) {
                                                        int noEMployeeNoSection=1;
                                                        
                                                        for (int idxEmp = 0; idxEmp < sessEmployee.getListEmployee().size(); idxEmp++) {
                                                            EmployeeMinimalis employeeMinimalis = (EmployeeMinimalis) sessEmployee.getListEmployee().get(idxEmp);
                                                            //employee cek ada secktion
                                                           rekapitulasiPresenceDanSchedule = new RekapitulasiPresenceDanSchedule(); 
                                                            
                                                            if(employeeMinimalis.getSectionId()==0){
                                                                
                                                               TotalEmployeePerDeptnSection = TotalEmployeePerDeptnSection+1;
                                                               TotalEmployeePerCompany = TotalEmployeePerCompany + 1; 
                                                               
                                                               //menghitung per department
                                                                if(listAttdAbsensi!=null && listAttdAbsensi.size()>0 && listAttdAbsensi.containsKey(""+employeeMinimalis.getOID()) ){
                                                                        rekapitulasiPresenceDanSchedule = (RekapitulasiPresenceDanSchedule)listAttdAbsensi.get(""+employeeMinimalis.getOID());
                                                                        listAttdAbsensi.remove(""+employeeMinimalis.getOID());
                                                                        //rekapitulasiAbsensiGrandTotal = new RekapitulasiAbsensiGrandTotal();
                                                                        rekapitulasiAbsensiGrandTotal.setHK(rekapitulasiAbsensiGrandTotal.getHK()+rekapitulasiPresenceDanSchedule.getTotalpresencelateearlyonly());
                                                                        
                                                                        //rekapitulasiAbsensiGrandTotal.setH(rekapitulasiAbsensiGrandTotal.getH()+rekapitulasiPresenceDanSchedule.getDayOffSchedule());
                                                                        //rekapitulasiAbsensiGrandTotal.setLateLebihLimaMenit(rekapitulasiAbsensiGrandTotal.getLateLebihLimaMenit()+rekapitulasiPresenceDanSchedule.getTotalLateLebihLimaMenit());

                                                                        rekapitulasiAbsensiGrandTotalPerCompany.setHK(rekapitulasiAbsensiGrandTotalPerCompany.getHK()+rekapitulasiPresenceDanSchedule.getTotalpresencelateearlyonly());
                                                                        
                                                                        //rekapitulasiAbsensiGrandTotalPerCompany.setH(rekapitulasiAbsensiGrandTotalPerCompany.getH()+rekapitulasiPresenceDanSchedule.getDayOffSchedule());
                                                                        //rekapitulasiAbsensiGrandTotalPerCompany.setLateLebihLimaMenit(rekapitulasiAbsensiGrandTotalPerCompany.getLateLebihLimaMenit()+rekapitulasiPresenceDanSchedule.getTotalLateLebihLimaMenit());
                                                                }
                                                                rowx = new Vector();
                                                                rowx.add("" + (noEMployeeNoSection++));
                                                                rowx.add(""+employeeMinimalis.getEmployeeNum());
                                                                rowx.add(""+employeeMinimalis.getFullName());  
                                                                rowx.add(""+rekapitulasiPresenceDanSchedule.getTotalpresencelateearlyonly()); 
                                                                //rowx.add("");
                                                                //if (OnlyDw != 0 && OnlyDw == 1){
                                                                     double harianDw = 0;
                                                                     double totalharianDw = 0;
                                                                    //if (listPayDayfromSalLevel.get(employeeMinimalis.getOID()) != null){
                                                                       // harianDw = (Double) (Double.valueOf(listPayDayfromSalLevel.get(employeeMinimalis.getOID()).toString()));
                                                                        harianDw = PstPaySlipComp.getCompValueEmployee(employeeMinimalis.getOID(), rekapitulasiAbsensi.getPeriodId(), "BNF01");
                                                                        totalharianDw = PstPaySlipComp.getCompValueEmployee(employeeMinimalis.getOID(), rekapitulasiAbsensi.getPeriodId(), "BNF05");
                                                                    //}
                                                                rowx.add(""+Formater.formatNumberMataUang(harianDw, "Rp"));
                                                                rowx.add(""+Formater.formatNumberMataUang((totalharianDw), "Rp"));
                                  
                                                               // } else {
                                                               //     rowx.add(""+Formater.formatNumberMataUang(hashTblPayDay.getPayDay(employeeMinimalis.getEmpCategory(), oidEmployeeDw, employeeMinimalis.getPositionId()), "Rp") ); 
                                                                //    rowx.add(""+Formater.formatNumberMataUang((rekapitulasiPresenceDanSchedule.getPresenceOnTime()*hashTblPayDay.getPayDay(employeeMinimalis.getEmpCategory(), oidEmployeeDw, employeeMinimalis.getPositionId())), "Rp"));
                                                                
                                                               // }
                                                                for (int idx = 0; idx < itDate; idx++) {
                                                                    //rowx.add("" + idx);
                                                                    Date selectedDate = new Date(rekapitulasiAbsensi.getDtFrom().getYear(), rekapitulasiAbsensi.getDtFrom().getMonth(), (rekapitulasiAbsensi.getDtFrom().getDate() + idx));
                                                                    
                                                                    //rowx.add("" + rekapitulasiPresenceDanSchedule.getScheduleSymbol(selectedDate));
                                                                    rowx.add("" + rekapitulasiPresenceDanSchedule.getScheduleSymbol(selectedDate)+rekapitulasiPresenceDanSchedule.getDataReason(selectedDate));
                                                                }
                                                               // if(hashTblPayDay!=null){
                                                                        rekapitulasiAbsensiGrandTotal.setPayDay(rekapitulasiAbsensiGrandTotal.getPayDay()+harianDw);
                                                                        rekapitulasiAbsensiGrandTotal.setTotalPayDay(rekapitulasiAbsensiGrandTotal.getTotalPayDay()+(totalharianDw));
                                                                        rekapitulasiAbsensiGrandTotalPerCompany.setPayDay(rekapitulasiAbsensiGrandTotalPerCompany.getPayDay()+harianDw);
                                                                        rekapitulasiAbsensiGrandTotalPerCompany.setTotalPayDay(rekapitulasiAbsensiGrandTotalPerCompany.getTotalPayDay()+(totalharianDw));
                                                               // }
                                                                ctrlist.drawListRowJsVer2(outJsp, 0, rowx, idxEmp);
                                                                 //end employee list but no section
                                                            }
                                                            //untuk section gk di buat d sini

                                                        }//end loop employee
                                                        
                                                        if(hashSection==null ||  (hashSection != null && hashSection.size() > 0 && hashSection.containsKey(""+department.getOID())==false)){
                                                                rowx = new Vector();
                                                                rowx.add("" + (noEMployeeNoSection-1));
                                                                rowx.add("");
                                                                rowx.add("<b>Total Department</b>");  
                                                                rowx.add("<b>"+rekapitulasiAbsensiGrandTotal.getHK()+"</b>"); 
                                                                rowx.add("<b>"+Formater.formatNumberMataUang(rekapitulasiAbsensiGrandTotal.getPayDay(), "Rp")+"</b>");
                                                                rowx.add("<b>"+Formater.formatNumberMataUang((rekapitulasiAbsensiGrandTotal.getTotalPayDay()), "Rp") +"</b>");
                                                                for (int idx = 0; idx < itDate; idx++) {
                                                                    rowx.add("");
                                                                }
                                                                ctrlist.drawListRowJsVer2(outJsp, 0, rowx, 0); 
                                                        
                                                        }
                                                        
                                                    }
                                                }//end hasEmployee
                                                
                                                //jika ada section
                                               
                                                    if (hashSection != null && hashSection.size() > 0 && hashSection.containsKey(""+department.getOID())) {
                                                            SessSection sessSection = (SessSection) hashSection.get(""+department.getOID());
                                                            Vector cloneSection = sessSection != null && sessSection.getListSection() != null && sessSection.getListSection().size() > 0?new Vector(sessSection.getListSection()):null;
                                                            if (cloneSection!=null) {
                                                                int loopBarisSection=0;
                                                                for (int idxSec = 0; idxSec < cloneSection.size(); idxSec++) {
                                                                    Section dSection = (Section) cloneSection.get(idxDept);
                                                                    //dept
                                                                    loopBarisSection = loopBarisSection + 1;
                                                                    cloneSection.remove(idxSec);
                                                                    idxSec = idxSec -1;
                                                                    rowx = new Vector();
                                                                    rowx.add("");
                                                                    rowx.add(" &nbsp;&nbsp;<b>>>> " + dSection.getSection()+"</b>");
                                                                    rowx.add("");
                                                                    rowx.add("");
                                                                    rowx.add("");
                                                                    rowx.add("");
                                                                    for (int idx = 0; idx < itDate; idx++) {
                                                                        rowx.add("");
                                                                    }
                                                                    ctrlist.drawListRowJsVer2(outJsp, 0, rowx, loopBarisSection);
                                                                    //end dept

                                                                    //nanti cek ada kah employee di dept ini sectionnya
                                                                    int noEMployeeNoSection=1;
                                                                    if (hashEmployeeSection != null && hashEmployeeSection.size() > 0) {
                                                                        SessEmployee sessEmployee = (SessEmployee) hashEmployeeSection.get(dSection.getOID());
                                                                        Vector cloneListEmp =sessEmployee != null && sessEmployee.getListEmployee() != null && sessEmployee.getListEmployee().size() > 0?new Vector(sessEmployee.getListEmployee()):null;
                                                                        if (cloneListEmp!=null) {
                                                                            RekapitulasiAbsensiGrandTotal rekapitulasiAbsensiGrandTotalSec = new RekapitulasiAbsensiGrandTotal();
                                                                            int loopBarieEMpSec=0;
                                                                            for (int idxEmpSec = 0; idxEmpSec < cloneListEmp.size(); idxEmpSec++) { 
                                                                                EmployeeMinimalis employeeMinimalis = (EmployeeMinimalis) cloneListEmp.get(idxEmpSec);
                                                                                //employee cek ada secktion
                                                                                rekapitulasiPresenceDanSchedule = new RekapitulasiPresenceDanSchedule(); 
                                                                                
                                                                                if(employeeMinimalis.getSectionId()!=0){
                                                                                    if(listAttdAbsensi!=null && listAttdAbsensi.size()>0 && listAttdAbsensi.containsKey(""+employeeMinimalis.getOID()) && hashTblPayDay!=null){
                                                                                            rekapitulasiPresenceDanSchedule = (RekapitulasiPresenceDanSchedule)listAttdAbsensi.get(""+employeeMinimalis.getOID());
                                                                                            listAttdAbsensi.remove(""+employeeMinimalis.getOID());
                                                                                            
                                                                                            
                                                                                            rekapitulasiAbsensiGrandTotal.setHK(rekapitulasiAbsensiGrandTotal.getHK()+rekapitulasiPresenceDanSchedule.getTotalpresencelateearlyonly());
                                                                                            
                                                                                    
                                                                                            rekapitulasiAbsensiGrandTotalSec.setHK(rekapitulasiAbsensiGrandTotalSec.getHK()+rekapitulasiPresenceDanSchedule.getTotalpresencelateearlyonly());
                                                                                            
                                                                                            
                                                                                            rekapitulasiAbsensiGrandTotalPerCompany.setHK(rekapitulasiAbsensiGrandTotalPerCompany.getHK()+rekapitulasiPresenceDanSchedule.getTotalpresencelateearlyonly());
                                                                                            
                                                                                    
                                                                                    }
                                                                                    loopBarieEMpSec = loopBarieEMpSec + 1;
                                                                                    cloneListEmp.remove(idxEmpSec);
                                                                                    TotalEmployeePerDeptnSection = TotalEmployeePerDeptnSection+1;
                                                                                    TotalEmployeePerCompany = TotalEmployeePerCompany + 1;
                                                                                    idxEmpSec = idxEmpSec -1;
                                                                                    rowx = new Vector();
                                                                                    rowx.add("" + (noEMployeeNoSection++));
                                                                                    rowx.add(""+employeeMinimalis.getEmployeeNum());
                                                                                    rowx.add(""+employeeMinimalis.getFullName());  
                                                                                    
                                                                                    //priska menambahkan untuk kategori dw
                                                                                    rowx.add(""+rekapitulasiPresenceDanSchedule.getTotalpresencelateearlyonly()); 
                                                                                   // rowx.add(""+listPayDayfromSalLevel.get(employeeMinimalis.getOID()));
                                                                                   
                                                                                    //if (OnlyDw != 0 && OnlyDw == 1){
                                                                                        double harianDw = 0;
                                                                                        double totalharianDw = 0;
                                                                                        //if (listPayDayfromSalLevel.get(employeeMinimalis.getOID()) != null){
                                                                                            //harianDw = (Double) (Double.valueOf(listPayDayfromSalLevel.get(employeeMinimalis.getOID()).toString()));
                                                                                            harianDw = PstPaySlipComp.getCompValueEmployee(employeeMinimalis.getOID(), rekapitulasiAbsensi.getPeriodId(), "BNF01");
                                                                                            totalharianDw = PstPaySlipComp.getCompValueEmployee(employeeMinimalis.getOID(), rekapitulasiAbsensi.getPeriodId(), "BNF05");
                                                                                        //}
                                                                                        rowx.add(""+Formater.formatNumberMataUang(harianDw, "Rp"));
                                                                                        rowx.add(""+Formater.formatNumberMataUang((totalharianDw), "Rp"));
                                  
                                                                                    //} else {
                                                                                       // rowx.add(""+Formater.formatNumberMataUang(hashTblPayDay.getPayDay(employeeMinimalis.getEmpCategory(), oidEmployeeDw, employeeMinimalis.getPositionId()), "Rp") ); 
                                                                                       // rowx.add(""+Formater.formatNumberMataUang((rekapitulasiPresenceDanSchedule.getTotalpresencelateearlyonly()*hashTblPayDay.getPayDay(employeeMinimalis.getEmpCategory(), oidEmployeeDw, employeeMinimalis.getPositionId())), "Rp"));
                                  
                                                                                   // }
                                                                                   // rowx.add(""+Formater.formatNumberMataUang(hashTblPayDay.getPayDay(employeeMinimalis.getEmpCategory(), oidEmployeeDw, employeeMinimalis.getPositionId()), "Rp")); 
                                                                                    
                                                                                    
                                                                                    for (int idx = 0; idx < itDate; idx++) {
                                                                                        //rowx.add("" + idx);
                                                                                        Date selectedDate = new Date(rekapitulasiAbsensi.getDtFrom().getYear(), rekapitulasiAbsensi.getDtFrom().getMonth(), (rekapitulasiAbsensi.getDtFrom().getDate() + idx));
                                                                                            
                                                                                        if (viewschedule == 2){
                                                                                            
                                                                                             long OIDschedule = PstScheduleSymbol.getScheduleId(rekapitulasiPresenceDanSchedule.getScheduleSymbol(selectedDate));
                                                                                          if ((OIDschedule == dayOFF) || (OIDschedule == extraDayOFF)){
                                                                                            rowx.add("<b style=\"color:red\">" + rekapitulasiPresenceDanSchedule.getScheduleSymbol(selectedDate)+rekapitulasiPresenceDanSchedule.getDataReason(selectedDate) +"</b>");
                                                                                          } else {
                                                                                          rowx.add("" + rekapitulasiPresenceDanSchedule.getScheduleSymbol(selectedDate)+rekapitulasiPresenceDanSchedule.getDataReason(selectedDate));
                                                                                        }
                                                                                        } else if (viewschedule == 1) {
                                                                                         long OIDschedule = PstScheduleSymbol.getScheduleId(rekapitulasiPresenceDanSchedule.getScheduleSymbol(selectedDate));
                                                                                         if ((OIDschedule == dayOFF) || (OIDschedule == extraDayOFF)){
                                                                                            rowx.add("<b style=\"color:red\">" + rekapitulasiPresenceDanSchedule.getScheduleSymbol(selectedDate)+rekapitulasiPresenceDanSchedule.getDataStatus(selectedDate) +"</b>");
                                                                                         } else {
                                                                                          rowx.add("" + rekapitulasiPresenceDanSchedule.getScheduleSymbol(selectedDate)+rekapitulasiPresenceDanSchedule.getDataStatus(selectedDate));
                                                                                        }
                                                                                        } else {
                                                                                            long OIDschedule = PstScheduleSymbol.getScheduleId(rekapitulasiPresenceDanSchedule.getScheduleSymbol(selectedDate));
                                                                                          if ((OIDschedule == dayOFF) || (OIDschedule == extraDayOFF)){
                                                                                            rowx.add("<b style=\"color:red\">" + rekapitulasiPresenceDanSchedule.getScheduleSymbol(selectedDate)+rekapitulasiPresenceDanSchedule.getDataReason(selectedDate) +"</b>");
                                                                                          } else {
                                                                                          rowx.add("" + rekapitulasiPresenceDanSchedule.getScheduleSymbol(selectedDate)+rekapitulasiPresenceDanSchedule.getDataReason(selectedDate));
                                                                                        }
                                                                                        }
                                                                                       
                                                                                        
                                                                                     }
                                                                                    
                                                                                  
                                                                                   // if(hashTblPayDay!=null){
                                                                                        
                                                                                  // String nilaiemp2 =  rekapitulasiAbsensi.getEmpCategory().replaceAll(",", "" );
                                                                                  // String sdw2 = String.valueOf(Dw);
                                                                                  //  if ( nilaiemp2.equals(sdw2)){
                                                                                  //          double harianDw = 0;
                                                                                  //          if (listPayDayfromSalLevel.get(employeeMinimalis.getOID()) != null){
                                                                                  //          harianDw = (Double) (Double.valueOf(listPayDayfromSalLevel.get(employeeMinimalis.getOID()).toString()));
                                                                                  //          harianDw = PstPaySlipComp.getCompValueEmployee(employeeMinimalis.getOID(), 504404625282959819l, "BNF01");
                                                                                  //          }
                                                                                            rekapitulasiAbsensiGrandTotal.setPayDay(rekapitulasiAbsensiGrandTotal.getPayDay()+harianDw);
                                                                                            rekapitulasiAbsensiGrandTotal.setTotalPayDay(rekapitulasiAbsensiGrandTotal.getTotalPayDay()+(totalharianDw));
                                                                                            rekapitulasiAbsensiGrandTotalSec.setPayDay(rekapitulasiAbsensiGrandTotalSec.getPayDay()+harianDw);
                                                                                            rekapitulasiAbsensiGrandTotalSec.setTotalPayDay(rekapitulasiAbsensiGrandTotalSec.getTotalPayDay()+(totalharianDw));
                                                                                            rekapitulasiAbsensiGrandTotalPerCompany.setPayDay(rekapitulasiAbsensiGrandTotalPerCompany.getPayDay()+harianDw);
                                                                                            rekapitulasiAbsensiGrandTotalPerCompany.setTotalPayDay(rekapitulasiAbsensiGrandTotalPerCompany.getTotalPayDay()+(totalharianDw));
                                                                                    
                                                                                 //       } else {
                                                                                 //           rekapitulasiAbsensiGrandTotal.setPayDay(rekapitulasiAbsensiGrandTotal.getPayDay()+hashTblPayDay.getPayDay(employeeMinimalis.getEmpCategory(), oidEmployeeDw, employeeMinimalis.getPositionId()));
                                                                                 //           rekapitulasiAbsensiGrandTotal.setTotalPayDay(rekapitulasiAbsensiGrandTotal.getTotalPayDay()+(rekapitulasiPresenceDanSchedule.getTotalpresencelateearlyonly()*hashTblPayDay.getPayDay(employeeMinimalis.getEmpCategory(), oidEmployeeDw, employeeMinimalis.getPositionId())));
                                                                                 //           rekapitulasiAbsensiGrandTotalSec.setPayDay(rekapitulasiAbsensiGrandTotalSec.getPayDay()+hashTblPayDay.getPayDay(employeeMinimalis.getEmpCategory(), oidEmployeeDw, employeeMinimalis.getPositionId()));
                                                                                 //           rekapitulasiAbsensiGrandTotalSec.setTotalPayDay(rekapitulasiAbsensiGrandTotalSec.getTotalPayDay()+(rekapitulasiPresenceDanSchedule.getTotalpresencelateearlyonly()*hashTblPayDay.getPayDay(employeeMinimalis.getEmpCategory(), oidEmployeeDw, employeeMinimalis.getPositionId())));
                                                                                 //           rekapitulasiAbsensiGrandTotalPerCompany.setPayDay(rekapitulasiAbsensiGrandTotalPerCompany.getPayDay()+hashTblPayDay.getPayDay(employeeMinimalis.getEmpCategory(), oidEmployeeDw, employeeMinimalis.getPositionId()));
                                                                                 //           rekapitulasiAbsensiGrandTotalPerCompany.setTotalPayDay(rekapitulasiAbsensiGrandTotalPerCompany.getTotalPayDay()+(rekapitulasiPresenceDanSchedule.getTotalpresencelateearlyonly()*hashTblPayDay.getPayDay(employeeMinimalis.getEmpCategory(), oidEmployeeDw, employeeMinimalis.getPositionId())));
                                                                                    
                                                                                 //       }
                                                                                        
                                                                                        
                                                                                        
                                                                                           
                                                                                  //  }
                                                                                    
                                                                                    ctrlist.drawListRowJsVer2(outJsp, 0, rowx, loopBarieEMpSec);
                                                                                     //end employee list but no section
                                                                                }
                                                                                 ///ini berati employee'nya ada section
                                                                                     //hashEmployeeAdaSection.put(employeeMinimalis.getSectionId(), employeeMinimalis);
                                                                                     //nanti buatlah hashtableEmployee tanpa section dan hasth ada section
                                                                                     //untuk pencarian hari kehadiran, absensi dll pakai fungsi summary attdance nnti itu vector,loop verctor tsb, jika employeeId'nya sama maka hapus lah
                                                                            }//end employee
                                                                            
                                                                            rowx = new Vector();
                                                                            rowx.add("" + (noEMployeeNoSection-1));
                                                                            rowx.add("");
                                                                            rowx.add("<b>Total Section</b>");  
                                                                            rowx.add("<b>"+rekapitulasiAbsensiGrandTotalSec.getHK()+"</b>");
                                                                            rowx.add("<b>"+Formater.formatNumberMataUang(rekapitulasiAbsensiGrandTotalSec.getPayDay(), "Rp")+"</b>");
                                                                            rowx.add("<b>"+Formater.formatNumberMataUang((rekapitulasiAbsensiGrandTotalSec.getTotalPayDay()), "Rp") +"</b>");
                                                                            for (int idx = 0; idx < itDate; idx++) {
                                                                                rowx.add("");
                                                                            }
                                                                            
                                                                            ctrlist.drawListRowJsVer2(outJsp, 0, rowx, 0); 
                                                                            
                                                                        }//end list emp
                                                                    }//end hasEmployee
                                                                    
                                                                    
                                                                }
                                                            }
                                                            
                                                            //tota dept yg ada sectionnya
                                                                            rowx = new Vector();
                                                                            rowx.add("" + (TotalEmployeePerDeptnSection));
                                                                            rowx.add("");
                                                                            rowx.add("<b>Total Department</b>");  
                                                                            rowx.add("<b>"+rekapitulasiAbsensiGrandTotal.getHK()+"</b>"); 
                                                                            rowx.add("<b>"+Formater.formatNumberMataUang(rekapitulasiAbsensiGrandTotal.getPayDay(), "Rp") +"</b>");
                                                                            rowx.add("<b>"+Formater.formatNumberMataUang((rekapitulasiAbsensiGrandTotal.getTotalPayDay()), "Rp") +"</b>");
                                                                            for (int idx = 0; idx < itDate; idx++) {
                                                                                rowx.add("");
                                                                            }
                                                                            
                                                                            ctrlist.drawListRowJsVer2(outJsp, 0, rowx, 0); 
                                                        }
                                            }
                                        }
                                    }

                                }//end loop division
                            }
                        }//end hashDivision
                        ///ini untuk grand total masing" company
                        rowx = new Vector();
                        rowx.add("" + (TotalEmployeePerCompany));
                        rowx.add("");
                        rowx.add("<b>Grand Total ---->>>>></b>");  
                        rowx.add("<b>"+rekapitulasiAbsensiGrandTotalPerCompany.getHK()+"</b>");  
                        
                        rowx.add("<b>"+Formater.formatNumberMataUang(rekapitulasiAbsensiGrandTotalPerCompany.getPayDay(), "Rp") +"</b>");
                        rowx.add("<b>"+Formater.formatNumberMataUang((rekapitulasiAbsensiGrandTotalPerCompany.getTotalPayDay()), "Rp") +"</b>"); 
                        for (int idx = 0; idx < itDate; idx++) {
                            rowx.add("");
                        }
                         ctrlist.drawListRowJsVer2(outJsp, 0, rowx, 0); 
                    }//end company
                }

                result = "";
                ctrlist.drawListEndTableJsVer2(outJsp);
            } else {
                result = "<i>Belum ada data dalam sistem ...</i>";
            }

        } catch (Exception ex) {
            System.out.println("Exception export summary Attd" + " Emp:" + empNumTest + " " + ex);
        }
        return result;
    }

%>
<%

   
 
    String source = FRMQueryString.requestString(request, "source");
    String[] stsEmpCategory = null;
    int sizeCategory = PstEmpCategory.listAll() != null ? PstEmpCategory.listAll().size() : 0;
    stsEmpCategory = new String[sizeCategory];
    String stsEmpCategorySel = "";
    int maxEmpCat = 0;
    for (int j = 0; j < sizeCategory; j++) {
        String name = "EMP_CAT_" + j;
        String val = FRMQueryString.requestString(request, name);
        stsEmpCategory[j] = val;
        if (val != null && val.length() > 0) {
            //stsEmpCategorySel.add(""+val); 
            stsEmpCategorySel = stsEmpCategorySel + val + ",";
        }
        maxEmpCat++;
    }

    
    //    OID_DAILYWORKER
           long Dw = 0;
            try{
                String sDw = PstSystemProperty.getValueByName("OID_DAILYWORKER"); 
                Dw = Integer.parseInt(sDw);
             }catch(Exception ex){
                 System.out.println("VALUE_DAILYWORKER NOT Be SET"+ex);
             } 
    int iCommand = FRMQueryString.requestCommand(request);
    int iErrCode = FRMMessage.NONE;
    int start = FRMQueryString.requestInt(request, "start");
   
    RekapitulasiAbsensi rekapitulasiAbsensi = new RekapitulasiAbsensi();
    rekapitulasiAbsensi.setCompanyId(FRMQueryString.requestLong(request, "company_id"));
    //rekapitulasiAbsensi.setDeptId(FRMQueryString.requestLong(request, "department"));
    rekapitulasiAbsensi.addArrDivision(FRMHandler.getParamsStringValuesStatic(request ,"division_id"));
    rekapitulasiAbsensi.addArrDepartment(FRMHandler.getParamsStringValuesStatic(request ,"department"));
    rekapitulasiAbsensi.addArrSection(FRMHandler.getParamsStringValuesStatic(request ,"section"));
    
    //rekapitulasiAbsensi.setSectionId(FRMQueryString.requestLong(request, "section"));
    //rekapitulasiAbsensi.setDivisionId(FRMQueryString.requestLong(request, "division_id"));
    
    rekapitulasiAbsensi.setSourceTYpe(FRMQueryString.requestInt(request, "source_type"));
    rekapitulasiAbsensi.setPeriodId(FRMQueryString.requestLong(request, "periodId"));
    rekapitulasiAbsensi.setDtFrom(FRMQueryString.requestDate(request, "check_date_start"));
    rekapitulasiAbsensi.setDtTo(FRMQueryString.requestDate(request, "check_date_finish"));
    
    if (rekapitulasiAbsensi.getSourceTYpe() == 1 && rekapitulasiAbsensi.getPeriodId() != 0){
         PayPeriod payPeriod = new PayPeriod();
         try{
          payPeriod = PstPayPeriod.fetchExc(rekapitulasiAbsensi.getPeriodId());
         }catch(Exception e ){}
         rekapitulasiAbsensi.setDtFrom(payPeriod.getStartDate());
         rekapitulasiAbsensi.setDtTo(payPeriod.getEndDate());    
    }
    
    rekapitulasiAbsensi.setEmpCategory(stsEmpCategorySel);
    rekapitulasiAbsensi.setFullName(FRMQueryString.requestString(request, "full_name"));
    rekapitulasiAbsensi.setPayrollNumber(FRMQueryString.requestString(request, "emp_number"));
    rekapitulasiAbsensi.setResignSts(FRMQueryString.requestInt(request, "statusResign"));
    rekapitulasiAbsensi.setViewschedule(FRMQueryString.requestInt(request, "viewschedule"));
    int viewschedule = FRMQueryString.requestInt(request, "viewschedule");
    int OnlyDw = FRMQueryString.requestInt(request, "OnlyDw");
    if (OnlyDw != 0 && OnlyDw == 1){
        rekapitulasiAbsensi.setEmpCategory(Dw+",");
    }
    Vector listCompany = new Vector();
    Hashtable hashDivision = new Hashtable();
    Hashtable hashDepartment = new Hashtable();
    Hashtable hashSection = new Hashtable();
    Hashtable hashEmployee  = new Hashtable();
    Hashtable hashEmployeeSection = new Hashtable();
    Hashtable listAttdAbsensi =null;
    Hashtable listPayDayfromSalLevel = null;
    
    I_Atendance attdConfig = null;
    try {
        attdConfig = (I_Atendance) (Class.forName(PstSystemProperty.getValueByName("ATTENDANCE_CONFIG")).newInstance());
    } catch (Exception e) {
        System.out.println("Exception : " + e.getMessage());
        System.out.println("Please contact your system administration to setup system property: ATTENDANCE_CONFIG ");
    }
    int iPropInsentifLevel = 0;
        long lHolidays = 0;
        try {
            iPropInsentifLevel = Integer.parseInt(PstSystemProperty.getValueByName("PAYROLL_INSENTIF_MAX_LEVEL"));
            lHolidays = Long.parseLong(PstSystemProperty.getValueByName("OID_PUBLIC_HOLIDAY"));
        } catch (Exception ex) {
            System.out.println("Execption PAYROLL_INSENTIF_MAX_LEVEL: " + ex);
        }

        I_PayrollCalculator payrollCalculatorConfig = null;
        try {
            payrollCalculatorConfig = (I_PayrollCalculator) (Class.forName(PstSystemProperty.getValueByName("PAYROLL_CALC_CLASS_NAME")).newInstance());
        } catch (Exception e) {
            System.out.println("Exception PAYROLL_CALC_CLASS_NAME " + e.getMessage());
        }
        int propReasonNo = -1;
        try {
            propReasonNo = Integer.parseInt(PstSystemProperty.getValueByName("ATTANDACE_REASON_DUTTY_NO"));

        } catch (Exception ex) {
            System.out.println("Execption REASON_DUTTY_NO: " + ex);
        }
        int propCheckLeaveExist = 0;
        try {
            propCheckLeaveExist = Integer.parseInt(PstSystemProperty.getValueByName("ATTANDACE_WHEN_LEAVE_EXIST"));

        } catch (Exception ex) {
            System.out.println("Execption ATTANDACE_WHEN_LEAVE_EXIST: " + ex);
        }

       int showOvertime = 0;
        try {
            showOvertime = Integer.parseInt(PstSystemProperty.getValueByName("ATTANDACE_SHOW_OVERTIME_IN_REPORT_DAILY"));
        } catch (Exception ex) {

            System.out.println("<blink>ATTANDACE_SHOW_OVERTIME_IN_REPORT_DAILY NOT TO BE SET</blink>");
            showOvertime = 0;
        }

        //update by satrya 2013-04-09
        long oidScheduleOff = 0;
        try {
            oidScheduleOff = Long.parseLong(PstSystemProperty.getValueByName("OID_DAY_OFF"));
        } catch (Exception ex) {

            System.out.println("<blink>OID_DAY_OFF NOT TO BE SET</blink>");
            oidScheduleOff = 0;
        }
    I_Leave leaveConfig = null;
    try{
    leaveConfig = (I_Leave) (Class.forName("com.dimata.harisma.session.leave.LeaveConfigDinamis").newInstance());
    }catch (Exception e){
    System.out.println("Exception : " + e.getMessage());
    }
      
        
        
        Hashtable vctSchIDOff = new Hashtable();
        Hashtable hashSchOff = new Hashtable();
        HolidaysTable holidaysTable = new HolidaysTable();
        Hashtable hashPositionLevel = PstPosition.hashGetPositionLevel();
        String whereClausePeriod = "";
        if (rekapitulasiAbsensi.getDtTo() != null && rekapitulasiAbsensi.getDtFrom() != null) {
            whereClausePeriod = "\"" + Formater.formatDate(rekapitulasiAbsensi.getDtTo(), "yyyy-MM-dd HH:mm:ss") + "\" >="
                    + PstPeriod.fieldNames[PstPeriod.FLD_START_DATE] + " AND "
                    + PstPeriod.fieldNames[PstPeriod.FLD_END_DATE] + " >= \"" + Formater.formatDate(rekapitulasiAbsensi.getDtFrom(), "yyyy-MM-dd HH:mm:ss") + "\"";
        }

        Hashtable hashPeriod = new Hashtable();
        Vector vReason = null;
         //Hashtable hashSectionClone = new Hashtable(hashSection);  
         HashTblPayDay hashTblPayDay = new HashTblPayDay();
        long oidEmployeeDw = Dw;
        String where = rekapitulasiAbsensi.getWhereClauseEMployee();
    if(iCommand==Command.LIST){
            EmployeeSrcRekapitulasiAbs employeeSrcRekapitulasiAbs = PstEmployee.getEmployeeFilter(0, 0, where, PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID]);
            String sectionId = employeeSrcRekapitulasiAbs.getEmpId()!=null && employeeSrcRekapitulasiAbs.getEmpId().length()>0?PstEmployee.getSectionIdByEmpId(0, 0, (employeeSrcRekapitulasiAbs.getEmpId()!=null && employeeSrcRekapitulasiAbs.getEmpId().length()>0?PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID]+" IN("+employeeSrcRekapitulasiAbs.getEmpId()+")":""), PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID]):"";
            
            hashSchOff = PstScheduleSymbol.getHashScheduleIdOFF(PstScheduleCategory.CATEGORY_OFF);
            vctSchIDOff = PstScheduleSymbol.getHashScheduleId(PstScheduleCategory.CATEGORY_OFF); 
            hashPeriod = PstPeriod.hashlistTblPeriod(0, 0, whereClausePeriod, "");
            holidaysTable = PstPublicHolidays.getHolidaysTable(rekapitulasiAbsensi.getDtFrom(), rekapitulasiAbsensi.getDtTo()); 
            hashPositionLevel = PstPosition.hashGetPositionLevel();
            listCompany = employeeSrcRekapitulasiAbs.getEmpId()!=null && employeeSrcRekapitulasiAbs.getEmpId().length()>0?     PstCompany.list(0, 0, (employeeSrcRekapitulasiAbs.getCompanyId()!=null && employeeSrcRekapitulasiAbs.getCompanyId().length()>0 ?PstCompany.fieldNames[PstCompany.FLD_COMPANY_ID]+" IN("+employeeSrcRekapitulasiAbs.getCompanyId()+")":""), PstCompany.fieldNames[PstCompany.FLD_COMPANY])  :new Vector(); 
            hashDivision = employeeSrcRekapitulasiAbs.getEmpId()!=null && employeeSrcRekapitulasiAbs.getEmpId().length()>0? PstDivision.hashListDivision(0, 0, (employeeSrcRekapitulasiAbs.getDivisionId()!=null && employeeSrcRekapitulasiAbs.getDivisionId().length()>0?PstDivision.fieldNames[PstDivision.FLD_DIVISION_ID]+" IN("+employeeSrcRekapitulasiAbs.getDivisionId()+")":"")):new Hashtable();   
            hashDepartment = employeeSrcRekapitulasiAbs.getEmpId()!=null && employeeSrcRekapitulasiAbs.getEmpId().length()>0?PstDepartment.hashListDepartment(0, 0, (employeeSrcRekapitulasiAbs.getDepartmentId()!=null && employeeSrcRekapitulasiAbs.getDepartmentId().length()>0?PstDepartment.fieldNames[PstDepartment.FLD_DEPARTMENT_ID]+" IN("+employeeSrcRekapitulasiAbs.getDepartmentId()+")":"")):new Hashtable(); 
            hashSection = employeeSrcRekapitulasiAbs.getEmpId()!=null && employeeSrcRekapitulasiAbs.getEmpId().length()>0?PstSection.hashListSection(0, 0, (sectionId!=null && sectionId.length()>0?PstSection.fieldNames[PstSection.FLD_SECTION_ID]+" IN("+sectionId+")":"")):new Hashtable();     
            hashEmployee = employeeSrcRekapitulasiAbs.getEmpId()!=null && employeeSrcRekapitulasiAbs.getEmpId().length()>0?PstEmployee.hashListEmployee(0, 0, rekapitulasiAbsensi.whereClauseEmpId(employeeSrcRekapitulasiAbs.getEmpId())):new Hashtable(); 
            
         //   Vector nilaial = PstAlStockTaken.getAnnualLeave(rekapitulasiAbsensi.getDtFrom(), rekapitulasiAbsensi.getDtTo());
            hashEmployeeSection = employeeSrcRekapitulasiAbs.getEmpId()!=null && employeeSrcRekapitulasiAbs.getEmpId().length()>0?PstEmployee.hashListEmployeeSection(0, 0,  rekapitulasiAbsensi.whereClauseEmpId(employeeSrcRekapitulasiAbs.getEmpId())):new Hashtable();
            
            listAttdAbsensi =  employeeSrcRekapitulasiAbs.getEmpId()!=null &&  employeeSrcRekapitulasiAbs.getEmpId().length()>0?PstEmpSchedule.getListAttendaceRekap(attdConfig,leaveConfig,rekapitulasiAbsensi.getDtFrom(), rekapitulasiAbsensi.getDtTo(), employeeSrcRekapitulasiAbs.getEmpId(), vctSchIDOff, hashSchOff, iPropInsentifLevel, holidaysTable, hashPositionLevel, payrollCalculatorConfig,hashPeriod):new Hashtable(); 
            vReason = PstReason.listReason(0, 0, PstReason.fieldNames[PstReason.FLD_REASON_TIME] + "=" + PstReason.REASON_TIME_YES, PstReason.fieldNames[PstReason.FLD_NUMBER_OF_SHOW]+ " ASC "); 
            listPayDayfromSalLevel =  PstPayEmpLevel.getHashPayDayFromSalLev(employeeSrcRekapitulasiAbs.getEmpId(), rekapitulasiAbsensi.getDtTo());
            
           //hashSectionClone = new Hashtable(hashSection); 
             /*Hashtable listAttdAbsensiClone = new Hashtable(listAttdAbsensi);  
            Hashtable hashDepartmentClone = new Hashtable(hashDepartment); 
            Hashtable hashDivisionClone = new Hashtable(hashDivision); 
            Hashtable hashEmployeeClone = new Hashtable(hashEmployee); 
            Hashtable hashEmployeeSectionClone = new Hashtable(hashEmployeeSection); */
           
            
            /*rekapitulasiAbsensi.setHashDepartment(hashDepartmentClone);
            rekapitulasiAbsensi.setHashDivision(hashDivisionClone);
            rekapitulasiAbsensi.setHashEmployee(hashEmployeeClone);
            rekapitulasiAbsensi.setHashEmployeeSection(hashEmployeeSectionClone);
            rekapitulasiAbsensi.setHashSection(hashSectionClone);
            rekapitulasiAbsensi.setListAttdAbsensi(listAttdAbsensiClone);*/
            rekapitulasiAbsensi.setListCompany(listCompany);
            //rekapitulasiAbsensi.setvReason(vReason); 
            rekapitulasiAbsensi.setDtFrom(rekapitulasiAbsensi.getDtFrom());
            rekapitulasiAbsensi.setDtTo(rekapitulasiAbsensi.getDtTo());
            rekapitulasiAbsensi.setJudul(" REKAPITULASI  ABSENSI : "); 
            
            if(rekapitulasiAbsensi.getSourceTYpe()!=0){
                hashTblPayDay = PstPayDay.hashtblPayDay(0, 0, "", ""); 
            }
             session.putValue("rekapitulasi", rekapitulasiAbsensi);
             session.putValue("wherenya", where);
    }
%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html> 

    <head> 

        <title>HARISMA - Rekapitulasi Absensi</title>
        <%@ include file = "../../main/konfigurasi_jquery.jsp" %>    
        <link rel="stylesheet" href="../../styles/main.css" type="text/css">
        <link rel="stylesheet" href="../../styles/tab.css" type="text/css">
        <script type="text/javascript" src="../../javascripts/jquery.min.js"></script>
        <script type="text/javascript" src="../../javascripts/jquery-ui.min.js"></script>
        <script type="text/javascript" src="../../javascripts/gridviewScroll.min.js"></script>
        <link href="../../stylesheets/GridviewScroll.css" rel="stylesheet" />
        <script language="JavaScript">

            function fnTrapKD(){ 
                if (event.keyCode == 13) {
                    cmdView();
                }
            }

            function cmdUpdateDiv(){
                document.frpresence.command.value="<%=String.valueOf(Command.GOTO)%>";
                document.frpresence.action="rekapitulasi_absensi.jsp";
                document.frpresence.submit();
            }
            function cmdUpdateDep(){
                document.frpresence.command.value="<%=String.valueOf(Command.GOTO)%>";
                document.frpresence.action="rekapitulasi_absensi.jsp";
                document.frpresence.submit();
            }
            function cmdUpdatePos(){
                document.frpresence.command.value="<%=String.valueOf(Command.GOTO)%>";
                document.frpresence.action="rekapitulasi_absensi.jsp";
                document.frpresence.submit();
            }
            function cmdExport(){ 
                document.frpresence.action="<%=printroot%>.report.attendance.AttendanceSummaryXls"; 
                document.frpresence.target = "SummaryAttendances";
                document.frpresence.submit();
                document.frpresence.target = "";
                
            }
            function cmdSearch(nilai){
                document.frpresence.command.value="<%=String.valueOf(Command.LIST)%>";
                document.frpresence.source_type.value=nilai;
                document.frpresence.action="rekapitulasi_absensi.jsp";
                document.frpresence.submit();
                
            }
            
            function cmdExportExcel(source_type){
                 
                var linkPage = "<%=approot%>/report/presence/export_excel/export_excel_rekapitulasi_absensi.jsp?source_type="+source_type;    
                var newWin = window.open(linkPage,"attdReportDaily","height=700,width=990,status=yes,toolbar=yes,menubar=no,resizable=yes,scrollbars=yes,location=yes"); 			
                 newWin.focus();
 
                //document.frpresence.action="rekapitulasi_absensi.jsp"; 
                //document.frpresence.target = "SummaryAttendance";
                //document.frpresence.submit();
                //document.frpresence.target = "";
            }
       
        </script>

        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
        <link rel="stylesheet" href="../../styles/main.css" type="text/css">
        <link rel="stylesheet" href="../../styles/tab.css" type="text/css">
        <link href="<%=approot%>/stylesheets/superTables.css" rel="Stylesheet" type="text/css" /> 


    </head>

    <body <%=noBack%> bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('<%=approot%>/images/BtnSearchOn.jpg')">
        <%//if(isMSIE){%>
        <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%" bgcolor="#F9FCFF" >
            <%
            if (headerStyle && !verTemplate.equalsIgnoreCase("0")) {%> 
            <%@include file="../../styletemplate/template_header.jsp" %>
            <%} else {%>

            <%//}else{%>

            <%//}%>
            <tr> 
                <td ID="TOPTITLE" background="<%=approot%>/images/HRIS_HeaderBg3.jpg" width="100%" height="54">    
                    <%@ include file = "../../main/header.jsp" %>
                </td>
            </tr>
            <tr> 
                <td  bgcolor="#9BC1FF" height="15" ID="MAINMENU" valign="middle"> <!-- #BeginEditable "menumain" --> 
                    <%@ include file = "../../main/mnmain.jsp" %>
                </td>
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
            <tr> 
                <td width="88%" valign="top" align="left"> 
                    <table width="100%" border="0" cellspacing="3" cellpadding="2">
                        <tr> 
                            <td width="100%"> 
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr> 
                                        <td height="20"> <font color="#FF6600" face="Arial"><strong>  Report &gt; Rekapitulasi Absensi  </strong></font> </td>
                                    </tr>
                                    <tr> 
                                        <td> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr> 
                                                    <td  style="background-color:<%=bgColorContent%>; "> 
                                                        <table width="100%" border="0"  >
                                                            <tr> 
                                                                <td valign="top"> 
                                                                    <table style="border:1px solid <%=garisContent%>" width="100%" border="0" cellspacing="1" cellpadding="1" class="tablecolor">
                                                                        <tr> 
                                                                            <td valign="top"> 
                                                                                <form name="frpresence" method="post" action="">
                                                                                    <input type="hidden" name="hidden_empschedule_id" value="<%=iCommand%>">

                                                                                    <input type="hidden" name="command" value="">
                                                                                    <input type="hidden" name="source" value="">
                                                                                    <input type="hidden" name="source_type" value="">
                                                                                    
                                                                                    <input type="hidden" name="start" value="<%=String.valueOf(start)%>">
                                                                                    <table width="100%" border="0" cellspacing="2" cellpadding="2">

                                                                                        <tr>
                                                                                            <td width="6%" nowrap="nowrap"> <div align="left">Payrol Num </div></td>
                                                                                            <td width="30%" nowrap="nowrap">:
                                                                                                <input type="text" size="40" placeholder="Type Employee Number.." name="emp_number"  value="<%= rekapitulasiAbsensi.getPayrollNumber()%>" title="You can Input Payroll Number more than one, ex-sample : 1111,2222" class="elemenForm" onKeyDown="javascript:fnTrapKD()"> </td>

                                                                                            <td width="5%" nowrap="nowrap"> Full Name </td>
                                                                                            <td width="59%" nowrap="nowrap">:
                                                                                                <input type="text" size="50" placeholder="Type Full Name.." name="full_name"  value="<%= rekapitulasiAbsensi.getFullName()%>" title="You can Input Full Name more than one, ex-sample : saya,kamu" class="elemenForm" onKeyDown="javascript:fnTrapKD()"> </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td width="6%" nowrap="nowrap"> <div align="left">Company </div></td>
                                                                                            <td width="30%" nowrap="nowrap">:
                                                                                               <%

                                                                                                    Vector com_value = new Vector(1, 1);
                                                                                                    Vector com_key = new Vector(1, 1);
                                                                                                    com_value.add("0");
                                                                                                    com_key.add("select ...");

                                                                                                    //String sWhereClause = PstSection.fieldNames[PstSection.FLD_DEPARTMENT_ID] + " = " + sSelectedDepartment;                                                       
                                                                                                    //Vector listSec = PstSection.list(0, 0, sWhereClause, " SECTION ");
                                                                                                    Vector listCom = PstCompany.list(0, 0, "", "");
                                                                                                    for (int i = 0; i < listCom.size(); i++) {
                                                                                                        Company company = (Company) listCom.get(i);
                                                                                                        com_key.add(company.getCompany());
                                                                                                        com_value.add(String.valueOf(company.getOID()));
                                                                                                    }
                                                                                                %>
                                                                                                <%= ControlCombo.draw("company_id", "formElemen", null, "" + rekapitulasiAbsensi.getCompanyId(), com_value, com_key, "size=8 multiple onkeydown=\"javascript:fnTrapKD()\"")%>
                                                                                            </td>

                                                                                            <td width="5%" nowrap="nowrap"><%=dictionaryD.getWord(I_Dictionary.DIVISION) %></td>
                                                                                            <td width="59%" nowrap="nowrap">:
                                                                                                <%

                                                                                                    Vector div_value = new Vector(1, 1);
                                                                                                    Vector div_key = new Vector(1, 1);
                                                                                                    div_value.add("0");
                                                                                                    div_key.add("select ...");
                                                                                                    Vector listDiv  = new Vector();
                                                                                                    
                                                                                                    if (isHRDLogin){
                                                                                                        listDiv = PstDivision.list(0, 0, PstDivision.fieldNames[PstDivision.FLD_VALID_STATUS] + " = 1", PstDivision.fieldNames[PstDivision.FLD_DIVISION]);
                                                                                                    } else {
                                                                                                        listDiv = PstDivision.list(0, 0, PstDivision.fieldNames[PstDivision.FLD_COMPANY_ID] + " = " + emplx.getCompanyId() + " AND " + PstDivision.fieldNames[PstDivision.FLD_VALID_STATUS] + " = 1", PstDivision.fieldNames[PstDivision.FLD_DIVISION_ID]);
                                                                                                    }
                                                                                                    
                                                                                                    for (int i = 0; i < listDiv.size(); i++) {
                                                                                                        Division div = (Division) listDiv.get(i);
                                                                                                        div_key.add(div.getDivision());
                                                                                                        div_value.add(String.valueOf(div.getOID()));
                                                                                                    }
                                                                                                %>
                                                                                                    <%= ControlCombo.drawStringArraySelected("division_id", "formElemen", null, rekapitulasiAbsensi.getArrDivision(0), div_key, div_value, null, "size=8 multiple onkeydown=\"javascript:fnTrapKD()\"") %> 
                                                                                            </td>
                                                                                        </tr>


                                                                                        <tr> 
                                                                                            <td width="6%" align="right" nowrap> 
                                                                                                <div align="left"><%=dictionaryD.getWord(I_Dictionary.DEPARTMENT) %></div>                                                                                            </td>
                                                                                            <td width="30%" nowrap="nowrap"> : 
                                                                                                 <%

                                                                                                    Vector dep_value = new Vector(1, 1);
                                                                                                    Vector dep_key = new Vector(1, 1);
                                                                                                    dep_value.add("0");
                                                                                                    dep_key.add("select ...");

                                                                                                    Vector listDep = new Vector();
                                                                                                    
                                                                                                    if (isHRDLogin){
                                                                                                        listDep = PstDepartment.list(0, 0, PstDepartment.TBL_HR_DEPARTMENT + "." + PstDepartment.fieldNames[PstDepartment.FLD_VALID_STATUS] + " = 1", "");
                                                                                                    } else {
                                                                                                        listDep = PstDepartment.list(0, 0, PstDepartment.fieldNames[PstDepartment.FLD_DIVISION_ID] + " = " + emplx.getDivisionId() + " AND " + PstDepartment.TBL_HR_DEPARTMENT + "." + PstDepartment.fieldNames[PstDepartment.FLD_VALID_STATUS] + " = 1", PstDepartment.fieldNames[PstDepartment.FLD_DEPARTMENT] );
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

                                                                                                <%= ControlCombo.drawStringArraySelected("department", "formElemen", null, rekapitulasiAbsensi.getArrDepartment(0), dep_key, dep_value, null, "size=8 multiple onkeydown=\"javascript:fnTrapKD()\"") %> 
                                                                                            </td>
                                                                                            <td width="5%" align="left" nowrap valign="top"><%=dictionaryD.getWord(I_Dictionary.SECTION) %></td>
                                                                                            <td width="59%" nowrap="nowrap">:
                                                                                                <%

                                                                                                    Vector sec_value = new Vector(1, 1);
                                                                                                    Vector sec_key = new Vector(1, 1);
                                                                                                    sec_value.add("0");
                                                                                                    sec_key.add("select ...");
                                                                                                    
                                                                                                    
                                                                                                    Vector listSec = new Vector();
                                                                                                    
                                                                                                    if (isHRDLogin){
                                                                                                        listSec = PstSection.list(0, 0, PstSection.fieldNames[PstSection.FLD_VALID_STATUS] + " = 1", "DEPARTMENT_ID");
                                                                                                    } else {
                                                                                                        listSec = PstSection.list(0, 0, PstSection.fieldNames[PstSection.FLD_DEPARTMENT_ID] + " = " + emplx.getDepartmentId() + " AND " + PstSection.fieldNames[PstSection.FLD_VALID_STATUS] + " = 1", "DEPARTMENT_ID");
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
                                                                                                 <%= ControlCombo.drawStringArraySelected("section", "formElemen", null, rekapitulasiAbsensi.getArrSection(0), sec_key, sec_value, null, "size=8 multiple onkeydown=\"javascript:fnTrapKD()\"") %> 
                                                                                            </td>

                                                                                        </tr>

                                                                                        <tr> 
                                                                                            <td width="6%" align="right" nowrap> <div align=left>Date</div>                                                                                             </td>
                                                                                            <td width="30%" nowrap="nowrap">:

                                                                                                <%=ControlDate.drawDateWithStyle("check_date_start", rekapitulasiAbsensi.getDtFrom(), 2, -5, "formElemen", " onkeydown=\"javascript:fnTrapKD()\"")%> 
                                                                                                to <%=ControlDate.drawDateWithStyle("check_date_finish", rekapitulasiAbsensi.getDtTo(), 2, -5, "formElemen", " onkeydown=\"javascript:fnTrapKD()\"")%>   
                                                                                                Periode <%
                                                                                                        Vector periodValue = new Vector(1, 1);
                                                                                                        Vector periodKey = new Vector(1, 1);
                                                                                                        // salkey.add(" ALL DEPARTMET");
                                                                                                        //deptValue.add("0");
                                                                                                        Vector listPeriod = PstPayPeriod.list(0, 0, "", "START_DATE DESC");
                                                                                                        //   Vector listPeriod = PstPeriod.list(0, 0, "", "START_DATE DESC");
                                                                                                        for (int r = 0; r < listPeriod.size(); r++) {
                                                                                                            PayPeriod payPeriod = (PayPeriod) listPeriod.get(r);
                                                                                                            //  Period period = (Period) listPeriod.get(r);
                                                                                                            periodValue.add("" + payPeriod.getOID());
                                                                                                            periodKey.add(payPeriod.getPeriod());
                                                                                                        }
                                                                                                    %> <%=ControlCombo.draw("periodId", null, "" + rekapitulasiAbsensi.getPeriodId(), periodValue, periodKey, "")%>
                                                                                            </td>
                                                                                            <%
                                                                                             String chekr = "";
                                                                                        String chekr1 = "";
                                                                                        String chekr2 = "";
                                                                                        if (rekapitulasiAbsensi.getResignSts() == 0){
                                                                                           chekr = " checked ";
                                                                                        } else {
                                                                                           chekr = ""; 
                                                                                        }
                                                                                        
                                                                                         if (rekapitulasiAbsensi.getResignSts() == 1){
                                                                                           chekr1 = " checked ";
                                                                                        } else {
                                                                                           chekr1 = ""; 
                                                                                        }
                                                                                        
                                                                                        if (rekapitulasiAbsensi.getResignSts() == 2){
                                                                                           chekr2 = " checked ";
                                                                                        } else {
                                                                                           chekr2 = ""; 
                                                                                        }
                                                                                        %>
                                                                                            <td width="5%" align="right" nowrap><div align="left">Resigned Status </div></td>
                                                                                            <td>:
                                                                                                <input type="radio" name="statusResign" value="0" <%=chekr%>>
                                                                                                No
                                                                                                <input type="radio" name="statusResign" value="1" <%=chekr1%>>
                                                                                                Yes
                                                                                                <input type="radio" name="statusResign" value="2" <%=chekr2%>>
                                                                                                All </td> 
                                                                                        </tr>
                                                                                         <% 
                                                                                        String chek = "";
                                                                                        String chek1 = "";
                                                                                        String chek2 = "";
                                                                                        if (viewschedule == 0){
                                                                                           chek = " checked ";
                                                                                        } else {
                                                                                           chek = ""; 
                                                                                        }
                                                                                        
                                                                                         if (viewschedule == 1){
                                                                                           chek1 = " checked ";
                                                                                        } else {
                                                                                           chek1 = ""; 
                                                                                        }
                                                                                        
                                                                                        if (viewschedule == 2){
                                                                                           chek2 = " checked ";
                                                                                        } else {
                                                                                           chek2 = ""; 
                                                                                        }
                                                                                        
                                                                                        String OD = "";
                                                                                        String OD1 = "";
                                                                                        if (OnlyDw == 0){
                                                                                           OD = " checked ";
                                                                                        } else {
                                                                                           OD = ""; 
                                                                                        }
                                                                                        
                                                                                         if (OnlyDw == 1){
                                                                                           OD1 = " checked ";
                                                                                        } else {
                                                                                           OD1 = ""; 
                                                                                        }
                                                                                        
                                                                                      
                                                                                          %>
                                                                                        <tr> 
                                                                                            <td width="5%" align="right" nowrap><div align="left">View Schedule </div></td>
                                                                                            <td>:
                                                                                                <input type="radio" name="viewschedule" value="0" <%=chek%> >
                                                                                                Normal Schedule
                                                                                                <input type="radio" name="viewschedule" value="1" <%=chek1%>>
                                                                                                With Status
                                                                                                <input type="radio" name="viewschedule" value="2" <%=chek2%>>
                                                                                                With Reason </td> 
                                                                                            
                                                                                            <td width="5%" align="right" nowrap><div align="left">Only DW</div></td>
                                                                                            <td>:
                                                                                                <input type="radio" name="OnlyDw" value="0" <%=OD%> >
                                                                                                No
                                                                                                <input type="radio" name="OnlyDw" value="1" <%=OD1%>>
                                                                                                Yes
                                                                                            
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td width="5%" align="right" nowrap><div align="left">Emp. Category </div></td>
                                                                                            <td width="59%" nowrap="nowrap">
                                                                                                <table>
                                                                                                    <tr>
                                                                                                        <td width="83%" colspan="4">
                                                                                                            <table>
                                                                                                                <%

                                                                                                                    int numCol = 4;
                                                                                                                    boolean createTr = false;
                                                                                                                    int numOfColCreated = 0;
                                                                                                                    Hashtable hashGetListEmpSel = new Hashtable();
                                                                                                                    if (stsEmpCategorySel != null && stsEmpCategorySel.length() > 0) {
                                                                                                                        stsEmpCategorySel = stsEmpCategorySel.substring(0, stsEmpCategorySel.length() - 1);
                                                                                                                        String whereClause = PstEmpCategory.fieldNames[PstEmpCategory.FLD_EMP_CATEGORY_ID] + " IN (" + stsEmpCategorySel + ")";
                                                                                                                        hashGetListEmpSel = PstEmpCategory.getHashListEmpSchedule(0, 0, whereClause, "");
                                                                                                                    }
                                                                                                                    Vector vObjek = PstEmpCategory.listAll();
                                                                                                                    //String checked="unchecked"; 
                                                                                                                    long oidEmpCat = 0;
                                                                                                                    for (int tc = 0; (vObjek != null) && (tc < vObjek.size()); tc++) {
                                                                                                                        EmpCategory empCategory = (EmpCategory) vObjek.get(tc);
                                                                                                                        oidEmpCat = 0;
                                                                                                                        if (tc % numCol == 0) {
                                                                                                                            out.println("<tr><td nowrap>");
                                                                                                                            createTr = true;
                                                                                                                            numOfColCreated = 1;
                                                                                                                        } else {
                                                                                                                            out.println("<td nowrap>");
                                                                                                                            numOfColCreated = 1 + numOfColCreated;
                                                                                                                        }
                                                                                                                        if (empCategory != null) {

                                                                                                                            if (hashGetListEmpSel != null && hashGetListEmpSel.size() > 0 && hashGetListEmpSel.get(empCategory.getOID()) != null) {
                                                                                                                                EmpCategory empCategoryHas = (EmpCategory) hashGetListEmpSel.get(empCategory.getOID());
                                                                                                                                oidEmpCat = empCategoryHas.getOID();

                                                                                                                            }

                                                                                                                            if (oidEmpCat != 0) {
                                                                                                                %>
                                                                                                                <input type="checkbox" name="<%="EMP_CAT_" + tc%>"  checked="checked" value="<%=empCategory.getOID()%>"  />
                                                                                                                <%=empCategory.getEmpCategory()%> &nbsp;&nbsp;
                                                                                                                <%} else {%>
                                                                                                                <input type="checkbox" name="<%="EMP_CAT_" + tc%>"  value="<%=empCategory.getOID()%>"  />
                                                                                                                <%=empCategory.getEmpCategory()%> &nbsp;&nbsp;
                                                                                                                <%}%>
                                                                                                                <%
                                                                                                                            if (numOfColCreated == numCol || (tc + 2) > vObjek.size()) {
                                                                                                                                out.println("</td></tr>");
                                                                                                                            } else {
                                                                                                                                out.println("</td>");
                                                                                                                            }
                                                                                                                        }
                                                                                                                    }

                                                                                                                %>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </table></td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td height="13" width="0%">&nbsp;</td>
                                                                                            <td width="39%">
                                                                                                <table>
                                                                                                    <tr>
                                                                                                       <td width="39%"><a href="javascript:cmdSearch(0)" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image10','','<%=approot%>/images/BtnSearchOn.jpg',1)" id="aSearch"><img name="Image10" border="0" src="<%=approot%>/images/BtnSearch.jpg" width="24" height="24" alt="Search Employee"></a>
                                                                                                <img src="<%=approot%>/images/spacer.gif" width="6" height="1">
                                                                                                <a href="javascript:cmdSearch(0)">Search  Rekapitulasi</a></td>  
                                                                                                        <td width="39%"><a href="javascript:cmdSearch(1)" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image10','','<%=approot%>/images/BtnSearchOn.jpg',1)" id="aSearch"><img name="Image10" border="0" src="<%=approot%>/images/BtnSearch.jpg" width="24" height="24" alt="Search Employee"></a>
                                                                                                <img src="<%=approot%>/images/spacer.gif" width="6" height="1">
                                                                                                <a href="javascript:cmdSearch(1)">Search Rincian</a></td>  
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                            
                                                                                        </tr>
                                                                                        <%if (iCommand == Command.LIST) {%> 
                                                                                        <tr>
                                                                                            <td colspan="7">
                                                                                                <%
                                                                                                if(rekapitulasiAbsensi.getSourceTYpe()==0){%>
                                                                                                    <%=drawList(out, rekapitulasiAbsensi,listCompany,hashDivision,hashDepartment,hashSection,hashEmployee,hashEmployeeSection,listAttdAbsensi,vReason,viewschedule)%>
                                                                                                <%
                                                                                                
                                                                                                }else{%>
                                                                                                    <%=drawListRincian(out, rekapitulasiAbsensi,listCompany,hashDivision,hashDepartment,hashSection,hashEmployee,hashEmployeeSection,listAttdAbsensi,hashTblPayDay,oidEmployeeDw,viewschedule,listPayDayfromSalLevel,OnlyDw)%>
                                                                                                <%}
                                                                                                %>
                                                                                                </td>  
                                                                                        </tr>
                                                                                     
                                                                                        <tr> 
                                                                                            <td width="6%" nowrap> 
                                                                                                <div align="left"></div></td>
                                                                                            <%if(rekapitulasiAbsensi.getSourceTYpe()==0){%>
                                                                                                <td width="30%"> 
                                                                                                <table border="0" cellspacing="0" cellpadding="0" width="137">
                                                                                                    <tr> 
                                                                                                        <td width="16"><a href="javascript:cmdExportExcel(<%=rekapitulasiAbsensi.getSourceTYpe()%>)" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image10','','<%=approot%>/images/excel.png',1)" id="aSearch"><img name="Image10" border="0" src="<%=approot%>/images/excel.png" width="24" height="24" alt="Export Excel"></a></td>
                                                                                                        <td width="2"><img src="<%=approot%>/images/spacer.gif" width="4" height="1"></td>
                                                                                                        <td width="94" class="command" nowrap><a href="javascript:cmdExportExcel(<%=rekapitulasiAbsensi.getSourceTYpe()%>)">Export Excel Rekapitulasi</a></td>
                                                                                                    </tr>
                                                                                                </table></td>
                                                                                            <%}else{%>
                                                                                                <td width="30%"> 
                                                                                                <table border="0" cellspacing="0" cellpadding="0" width="137">
                                                                                                    <tr> 
                                                                                                        <td width="16"><a href="javascript:cmdExportExcel(<%=rekapitulasiAbsensi.getSourceTYpe()%>)" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image10','','<%=approot%>/images/excel.png',1)" id="aSearch"><img name="Image10" border="0" src="<%=approot%>/images/excel.png" width="24" height="24" alt="Export Excel"></a></td>
                                                                                                        <td width="2"><img src="<%=approot%>/images/spacer.gif" width="4" height="1"></td>
                                                                                                        <td width="94" class="command" nowrap><a href="javascript:cmdExportExcel(<%=rekapitulasiAbsensi.getSourceTYpe()%>)">Export Excel Rincian</a></td>
                                                                                                    </tr>
                                                                                                </table></td>
                                                                                            <%}%>
                                                                                        </tr>
                                                                                        <%}%>
                                                                                    </table>

                                                                                </form>
                                                                            </td>
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr> 
                                                    <td>&nbsp; </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <%if (headerStyle && !verTemplate.equalsIgnoreCase("0")) {%>
            <tr>
                <td valign="bottom">

                    <%@include file="../../footer.jsp" %>
                </td>

            </tr>
            <%} else {%>
            <tr> 
                <td colspan="2" height="20" <%=bgFooterLama%>>
                    <%@ include file = "../../main/footer.jsp" %>
                </td>
            </tr>
            <%}%>
        </table>
        <script type="text/javascript">
            $(document).ready(function () {
                gridviewScroll();
            });
            <%
                int freesize = 3;

            %>
                function gridviewScroll() {
                    gridView1 = $('#GridView1').gridviewScroll({
                        width: 1310,
                        height: 500,
                        railcolor: "##33AAFF",
                        barcolor: "#CDCDCD",
                        barhovercolor: "#606060",
                        bgcolor: "##33AAFF",
                        freezesize: <%=freesize%>,
                        arrowsize: 30,
                        varrowtopimg: "<%=approot%>/images/arrowvt.png",
                        varrowbottomimg: "<%=approot%>/images/arrowvb.png",
                        harrowleftimg: "<%=approot%>/images/arrowhl.png",
                        harrowrightimg: "<%=approot%>/images/arrowhr.png",
                        headerrowcount: 2,
                        railsize: 16,
                        barsize: 15
                    });
                }
        </script>

    </body>

</html>
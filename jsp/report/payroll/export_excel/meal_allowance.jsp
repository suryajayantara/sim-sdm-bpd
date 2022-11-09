<%-- 
    Document   : doc_master_flow_new
    Created on : 10-Feb-2017, 14:55:14
    Author     : Gunadi
--%>
<%@page import="com.dimata.harisma.session.attendance.SessEmpSchedule"%>
<%@page import="com.dimata.harisma.entity.masterdata.Reason"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstReason"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstSection"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstDepartment"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstPublicHolidays"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstScheduleCategory"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstScheduleSymbol"%>
<%@page import="com.dimata.harisma.entity.employee.PstEmployee"%>
<%@page import="com.dimata.harisma.entity.employee.EmployeeSrcRekapitulasiAbs"%>
<%@page import="com.dimata.util.Formater"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstPeriod"%>
<%@page import="com.dimata.harisma.entity.masterdata.HolidaysTable"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstEmpCategory"%>
<%@page import="java.util.Hashtable"%>
<%@page import="com.dimata.qdep.form.FRMHandler"%>
<%@page import="com.dimata.gui.jsp.ControlCombo"%>
<%@page import="com.dimata.harisma.entity.payroll.PstPaySlipComp"%>
<%@page import="com.dimata.harisma.entity.attendance.RekapitulasiPresenceDanSchedule"%>
<%@page import="com.dimata.harisma.entity.masterdata.sessemployee.EmployeeMinimalis"%>
<%@page import="com.dimata.harisma.entity.masterdata.sessdepartment.SessDepartment"%>
<%@page import="com.dimata.harisma.entity.masterdata.sessdivision.SessDivision"%>
<%@page import="com.dimata.harisma.entity.masterdata.sessemployee.SessEmployee"%>
<%@page import="com.dimata.harisma.entity.attendance.RekapitulasiAbsensiGrandTotal"%>
<%@page import="com.dimata.harisma.entity.attendance.PstEmpSchedule"%>
<%@page import="com.dimata.harisma.entity.masterdata.payday.PstPayDay"%>
<%@page import="com.dimata.harisma.entity.payroll.PstPayEmpLevel"%>
<%@page import="com.dimata.harisma.entity.masterdata.payday.HashTblPayDay"%>
<%@page import="com.dimata.harisma.entity.leave.I_Leave"%>
<%@page import="com.dimata.harisma.session.payroll.I_PayrollCalculator"%>
<%@page import="com.dimata.harisma.entity.attendance.I_Atendance"%>
<%@page import="com.dimata.harisma.session.attendance.rekapitulasiabsensi.RekapitulasiAbsensi"%>
<%@page import="com.dimata.harisma.entity.payroll.PayPeriod"%>
<%@page import="com.dimata.harisma.entity.payroll.PstPayPeriod"%>
<%@page import="com.dimata.harisma.entity.masterdata.Company"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstCompany"%>
<%@page import="com.dimata.harisma.entity.masterdata.Division"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstDivision"%>
<%@page import="com.dimata.harisma.entity.masterdata.DocMasterFlow"%>
<%@page import="com.dimata.util.Command"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstDocMasterFlow"%>
<%@page import="com.dimata.qdep.form.FRMQueryString"%>
<%@page import="com.dimata.harisma.entity.admin.AppObjInfo"%>
<%@page import="java.util.Vector"%>
<%@page import="com.dimata.harisma.form.masterdata.CtrlDocMasterFlow"%>
<%@page import="com.dimata.qdep.form.FRMMessage"%>
<%@page import="com.dimata.gui.jsp.ControlLine"%>
<%@page import="com.dimata.harisma.form.masterdata.FrmDocMasterFlow"%>
<%@ include file = "../../../main/javainit.jsp" %>
<% int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_REPORTS, AppObjInfo.G2_PAYROLL_REPORT, AppObjInfo.OBJ_CUSTOM_RPT_GENERATE); %>
<%@ include file = "../../../main/checkuser.jsp" %>
<%@page contentType="application/vnd.ms-excel" pageEncoding="UTF-8"%>

<%

   response.setHeader("Content-Disposition","attachment; filename=uang_makan.xls ");
 
    String source = FRMQueryString.requestString(request, "source");
    long periodId = FRMQueryString.requestLong(request, "periodId");
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
    
    PayPeriod period = new PayPeriod();
    try {
        period = PstPayPeriod.fetchExc(periodId);
    } catch (Exception exc){}

    
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
    rekapitulasiAbsensi.setDtFrom(period.getStartDate());
    rekapitulasiAbsensi.setDtTo(period.getEndDate());
    
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
    Vector listEmployee = new Vector();
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
        if (iCommand==Command.LIST){
            String empNum = FRMQueryString.requestString(request, "emp_number");
            String fullName = FRMQueryString.requestString(request, "full_name");
            String[] compId = FRMHandler.getParamsStringValuesStatic(request ,"company_id");
            String[] divId = FRMHandler.getParamsStringValuesStatic(request ,"division_id");
            String[] deptId = FRMHandler.getParamsStringValuesStatic(request ,"department");
            String[] secId = FRMHandler.getParamsStringValuesStatic(request ,"section");

            String whereClause = "";
            if (empNum.length()>0){
                whereClause += " AND E.EMPLOYEE_NUM = '"+empNum+"'";
            }
            if (fullName.length()>0){
                whereClause += " AND E.FULL_NAME = '"+fullName+"'";
            }
            if (compId != null){
                String inCompany = "";
                for (int i=0; i < compId.length; i++){
                    if (inCompany.length() > 0){
                        inCompany += ",";
                    }
                    inCompany += compId[i];
                }
                whereClause += " AND E.COMPANY_ID IN ("+inCompany+")";
            }
            if (divId != null){
                String inDivision = "";
                for (int i=0; i < divId.length; i++){
                    if (inDivision.length() > 0){
                        inDivision += ",";
                    }
                    inDivision += divId[i];
                }
                whereClause += " AND E.DIVISION_ID IN ("+inDivision+")";
            }
            if (deptId != null){
                String inDept = "";
                for (int i=0; i < deptId.length; i++){
                    if (inDept.length() > 0){
                        inDept += ",";
                    }
                    inDept += deptId[i];
                }
                whereClause += " AND E.DEPARTMENT_ID IN ('"+inDept+"')";
            }
            if (secId != null){
                String inSec = "";
                for (int i=0; i < secId.length; i++){
                    if (inSec.length() > 0){
                        inSec += ",";
                    }
                    inSec += secId[i];
                }
                whereClause += " AND E.SECTION_ID IN ("+inSec+")";
            }
            listEmployee = SessEmpSchedule.listRekapKehadiran(period, whereClause);

        }
    if(false){
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
            hashEmployee = employeeSrcRekapitulasiAbs.getEmpId()!=null && employeeSrcRekapitulasiAbs.getEmpId().length()>0?PstEmployee.hashListEmployeeFull(0, 0, rekapitulasiAbsensi.whereClauseEmpId(employeeSrcRekapitulasiAbs.getEmpId())):new Hashtable(); 
            
         //   Vector nilaial = PstAlStockTaken.getAnnualLeave(rekapitulasiAbsensi.getDtFrom(), rekapitulasiAbsensi.getDtTo());
            hashEmployeeSection = employeeSrcRekapitulasiAbs.getEmpId()!=null && employeeSrcRekapitulasiAbs.getEmpId().length()>0?PstEmployee.hashListEmployeeSection(0, 0,  rekapitulasiAbsensi.whereClauseEmpId(employeeSrcRekapitulasiAbs.getEmpId())):new Hashtable();
            listEmployee = PstEmployee.list(0,0, "EMPLOYEE_ID IN ("+employeeSrcRekapitulasiAbs.getEmpId()+")", "");
            listAttdAbsensi =  employeeSrcRekapitulasiAbs.getEmpId()!=null &&  employeeSrcRekapitulasiAbs.getEmpId().length()>0?PstEmpSchedule.getListAttendaceRekapFromSymbol(attdConfig,leaveConfig,rekapitulasiAbsensi.getDtFrom(), rekapitulasiAbsensi.getDtTo(), employeeSrcRekapitulasiAbs.getEmpId(), vctSchIDOff, hashSchOff, iPropInsentifLevel, holidaysTable, hashPositionLevel, payrollCalculatorConfig,hashPeriod):new Hashtable(); 
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
             session.putValue("listemployee", listEmployee);
             session.putValue("listattd", listAttdAbsensi);
             session.putValue("period", period.getPeriod());
    }
%>


<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Uang Makan</title>
    </head>
    <body>
            <% if (iCommand == Command.LIST) {
                    if (listEmployee.size() > 0 ){ %>
                <h4><strong>Laporan Uang Makan Karyawan <%=period.getPeriod()%></strong></h4>
                <table border="1">
                    <tr>
                        <td style="text-align:center; vertical-align:middle">No</td>
                        <td style="text-align:center; vertical-align:middle">NRK</td>
                        <td style="text-align:center; vertical-align:middle">Nama</td>
                        <td style="text-align:center; vertical-align:middle">Jabatan</td>
                        <td style="text-align:center; vertical-align:middle">Hari Kerja</td>
                        <td style="text-align:center; vertical-align:middle">Hadir</td>
                        <td style="text-align:center; vertical-align:middle">Tugas Belajar</td>
                        <td style="text-align:center; vertical-align:middle">Dinas Luar</td>
                        <td style="text-align:center; vertical-align:middle">Cuti Besar</td>
                        <td style="text-align:center; vertical-align:middle">Cuti Tahunan</td>
                        <td style="text-align:center; vertical-align:middle">Cuti Penting</td>
                        <td style="text-align:center; vertical-align:middle">Cuti Sakit</td>
                        <td style="text-align:center; vertical-align:middle">Sakit</td>
                        <td style="text-align:center; vertical-align:middle">Cuti Hamil</td>
                        <td style="text-align:center; vertical-align:middle">Detasir</td>
                        <td style="text-align:center; vertical-align:middle">Dispen</td>
                        <td style="text-align:center; vertical-align:middle">Ijin</td>
                        <td style="text-align:center; vertical-align:middle">Terlambat</td>
                        <td style="text-align:center; vertical-align:middle">Hanya Absen Masuk</td>
                        <td style="text-align:center; vertical-align:middle">Hanya Absen Keluar</td>
                        <td style="text-align:center; vertical-align:middle">Blm Ada Ket.</td>
                        <td style="text-align:center; vertical-align:middle">No. Rekening</td>
                        <td style="text-align:center; vertical-align:middle">Jumlah Uang Makan</td>
                        <td style="text-align:center; vertical-align:middle">Potongan</td>
                        <td style="text-align:center; vertical-align:middle">Total Uang Makan</td>
                    </tr>
                    <%
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

                    int totalSummary = 0;
                    if (listEmployee != null && listEmployee.size() > 0) { 
                        for (int idxEmp = 0; idxEmp < listEmployee.size(); idxEmp++) {
                            Vector temp = (Vector) listEmployee.get(idxEmp);
                            Employee emp = (Employee) temp.get(0);
                            Map<String, Integer> mapTime = (Map<String, Integer>) temp.get(1);
                            Map<String, Double> mapComp = (Map<String, Double>) temp.get(2);

                            Position pos = new Position();
                            String position = "";
                            try{
                                pos = PstPosition.fetchExc(emp.getPositionId());
                                position = pos.getPosition();
                            } catch (Exception exc){

                            }

                            Level lvl = new Level();
                            String Level = "";
                            try{
                                lvl = PstLevel.fetchExc(emp.getLevelId());
                                Level = lvl.getLevel();
                            } catch (Exception exc){

                            }

                            String mealAllowanceCompCode = PstSystemProperty.getValueByName("MEAL_ALLOWANCE_COMP_CODE");

                             //String mealAllowanceCompCode = PstSystemProperty.getValueByName("MEAL_ALLOWANCE_COMP_CODE");
                             double uangMakan = (mapComp.get("UANG_MAKAN") == null ? 0 : mapComp.get("UANG_MAKAN"));
                             //uangMakan = PstPaySlipComp.getCompValueEmployee(emp.getOID(), period.getOID(), mealAllowanceCompCode);
                             double potongan = (mapComp.get("POTONGAN") == null ? 0 : mapComp.get("POTONGAN"));
                             //potongan = PstPaySlipComp.getCompValueEmployee(emp.getOID(), period.getOID(), "POT_MKN");
                             totalSummary = totalSummary + (int) uangMakan - (int) potongan;



                            %>
                                 <tr>
                                     <td style="background-color: #FFF;"><%=""+ (idxEmp+1)%></td>
                                     <td style="background-color: #FFF;">="<%=""+ emp.getEmployeeNum()%>"</td>
                                     <td style="background-color: #FFF;"><%=""+ emp.getFullName()%></td>
                                     <td style="background-color: #FFF;"><%=""+ Level%></td>
                                     <td style="background-color: #FFF;"><%=""+ period.getWorkDays()%></td>
                                     <td style="background-color: #FFF;"><%=""+ (mapTime.get("H") == null ? 0 : mapTime.get("H"))%></td>
                                     <td style="background-color: #FFF;"><%=""+ (mapTime.get("TB") == null ? 0 : mapTime.get("TB"))%></td>
                                     <td style="background-color: #FFF;"><%=""+ (mapTime.get("DL") == null ? 0 : mapTime.get("DL"))%></td>
                                     <td style="background-color: #FFF;"><%=""+ (mapTime.get("CB") == null ? 0 : mapTime.get("CB"))%></td>
                                     <td style="background-color: #FFF;"><%=""+ (mapTime.get("CT") == null ? 0 : mapTime.get("CT"))%></td>
                                     <td style="background-color: #FFF;"><%=""+ (mapTime.get("CP") == null ? 0 : mapTime.get("CP"))%></td>
                                     <td style="background-color: #FFF;"><%=""+ (mapTime.get("CS") == null ? 0 : mapTime.get("CS"))%></td>
                                     <td style="background-color: #FFF;"><%=""+ (mapTime.get("S") == null ? 0 : mapTime.get("S"))%></td>
                                     <td style="background-color: #FFF;"><%=""+ (mapTime.get("CH") == null ? 0 : mapTime.get("CH"))%></td>
                                     <td style="background-color: #FFF;"><%=""+ (mapTime.get("DET") == null ? 0 : mapTime.get("DET"))%></td>
                                     <td style="background-color: #FFF;"><%=""+ (mapTime.get("DIS") == null ? 0 : mapTime.get("DIS"))%></td>
                                     <td style="background-color: #FFF;"><%=""+ (mapTime.get("IMT") == null ? 0 : mapTime.get("IMT"))%></td>
                                     <td style="background-color: #FFF;"><%=""+ (mapTime.get("LATE") == null ? 0 : mapTime.get("LATE"))%></td>
                                     <td style="background-color: #FFF;"><%=""+ (mapTime.get("OI") == null ? 0 : mapTime.get("OI"))%></td>
                                     <td style="background-color: #FFF;"><%=""+ (mapTime.get("OO") == null ? 0 : mapTime.get("OO"))%></td>
                                     <td style="background-color: #FFF;"><%=""+ (mapTime.get("ABS") == null ? 0 : mapTime.get("ABS"))%></td>
                                     <td style="background-color: #FFF;"><%=emp.getNoRekening()%></td>
                                     <td style="background-color: #FFF;"><%=uangMakan%></td>
                                     <td style="background-color: #FFF;"><%=potongan%></td>
                                     <td style="background-color: #FFF;"><%=uangMakan-potongan%></td>
                                 </tr>
                            <%
                            }

                        }   
                    %>
                    <tr>
                        <td style="background-color: #FFF; text-align: right" colspan="24">Total</td>
                        <td style="background-color: #FFF; text-align: right"><%=totalSummary%></td>
                    </tr>
                        
                </table>
                <%
                    } else {
                %>
                    <h6><strong>Tidak ada data</strong></h6>
                <%
                    }
                }
                %>
       
    </body>
</html>



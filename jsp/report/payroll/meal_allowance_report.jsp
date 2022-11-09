<%-- 
    Document   : doc_master_flow_new
    Created on : 10-Feb-2017, 14:55:14
    Author     : Gunadi
--%>
<%@page import="com.dimata.harisma.session.attendance.SessEmpSchedule"%>
<%@page import="com.dimata.harisma.entity.payroll.PstPayComponent"%>
<%@page import="com.dimata.harisma.entity.payroll.PayComponent"%>
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
<%@ include file = "../../main/javainit.jsp" %>
<% int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_REPORTS, AppObjInfo.G2_PAYROLL_REPORT, AppObjInfo.OBJ_MEAL_ALLOWANCE_RPT); %>
<%@ include file = "../../main/checkuser.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    /* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
    //boolean privPrint = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_PRINT));

    long hrdDepOid = Long.parseLong(String.valueOf(PstSystemProperty.getPropertyLongbyName(OID_HRD_DEPARTMENT)));
    boolean isHRDLogin = true ;
    
    long edpSectionOid = Long.parseLong(String.valueOf(PstSystemProperty.getPropertyLongbyName(OID_EDP_SECTION)));
    boolean isEdpLogin = edpSectionOid == sectionOfLoginUser.getOID() ? true : false;
    boolean isGeneralManager = positionType == PstPosition.LEVEL_GENERAL_MANAGER ? true : false;
    
    SessUserSession userSessionn = (SessUserSession)session.getValue(SessUserSession.HTTP_SESSION_NAME);
    AppUser appUserSess1 = userSessionn.getAppUser();
    String namaUser1 = appUserSess1.getFullName();
    
    /* Check Administrator */
    long oidCompany = 0;
    String inOidDivision = "";
    String inOidDepartment = "";
    String strDisable = "";
    String strDisableNum = "";
    if (appUserSess.getAdminStatus()==0){
        if (privViewDivGroup){
            oidCompany = emplx.getCompanyId();
            long oidDivGroup = Long.parseLong(PstSystemProperty.getValueByName("OID_DIVISION_TYPE_REGULAR"));
            String whereDiv = ""+PstDivision.fieldNames[PstDivision.FLD_DIVISION_TYPE_ID]+"="+oidDivGroup;
            Vector vListDivision = PstDivision.list(0,0,whereDiv,"");
            if (vListDivision.size()>0){
                for (int i=0; i< vListDivision.size();i++){
                    Division division = (Division) vListDivision.get(i);
                    inOidDivision += ","+division.getOID();
                }
                inOidDivision = inOidDivision.substring(1);
            }
        } else {
            oidCompany = emplx.getCompanyId();
            inOidDivision = ""+emplx.getDivisionId();
            strDisable = "disabled=\"disabled\"";
        }
    } if (namaUser1.equals("Employee")){
        strDisableNum = "disabled=\"disabled\"";
    }

//cek tipe browser, browser detection
    //String userAgent = request.getHeader("User-Agent");
    //boolean isMSIE = (userAgent!=null && userAgent.indexOf("MSIE") !=-1); 

%>
<%

   
 
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
      
        
    
    String komponenAdj = "";
    try {
        komponenAdj = PstPayComponent.getComponentName("POT_MKN");
    } catch (Exception exc){}
        
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
        <script language="JavaScript">
        function cmdSearch(){
                
                var e = document.getElementById("periodId");
                var period = e.options[e.selectedIndex].value;
                if (period == 0){
                    alert("Pilih Periode!")
                } else {
                    document.frpresence.command.value="<%=String.valueOf(Command.LIST)%>";
                    document.frpresence.action="meal_allowance_report.jsp";
                    document.frpresence.submit();
                }
        }    
        function cmdExport(){
                var e = document.getElementById("periodId");
                var period = e.options[e.selectedIndex].value;
                if (period == 0){
                    alert("Pilih Periode!")
                } else {
                    document.frpresence.command.value="<%=String.valueOf(Command.LIST)%>";
                    document.frpresence.action="export_excel/meal_allowance.jsp";
                    document.frpresence.submit();
                }
        }    
        
        function loadFilterBy(filter_by, oidDocMasterFlow) {
                var xmlhttp = new XMLHttpRequest();DEP
                xmlhttp.onreadystatechange = function() {
                    if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                        document.getElementById("div_respon").innerHTML = xmlhttp.responseText;
                    }
                };
                xmlhttp.open("GET", "doc_flow_ajax.jsp?filter_by=" + filter_by+"&oid="+oidDocMasterFlow, true);
                xmlhttp.send();
            }
            
        function loadCompany(
                pCompanyId, pDivisionId, pDepartmentId, pSectionId,
                frmCompany, frmDivision, frmDepartment, frmSection
            ) {
                var strUrl = "";
                if (pCompanyId.length == 0) { 
                    document.getElementById("div_respon").innerHTML = "";
                    return;
                } else {
                    var xmlhttp = new XMLHttpRequest();
                    xmlhttp.onreadystatechange = function() {
                        if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                            document.getElementById("div_respon").innerHTML = xmlhttp.responseText;
                        }
                    };
                    strUrl = "doc_flow_ajax.jsp";
                    strUrl += "?p_company_id="+pCompanyId;
                    strUrl += "&p_division_id="+pDivisionId;
                    strUrl += "&p_department_id="+pDepartmentId;
                    strUrl += "&p_section_id="+pSectionId;

                    strUrl += "&frm_company="+frmCompany;
                    strUrl += "&frm_division="+frmDivision;
                    strUrl += "&frm_department="+frmDepartment;
                    strUrl += "&frm_section="+frmSection;
                    xmlhttp.open("GET", strUrl, true);
                    xmlhttp.send();
                }
            }

            function loadDivision(
                companyId, frmCompany, frmDivision, frmDepartment, frmSection, filterBy
            ) {
                var strUrl = "";
                if (companyId.length == 0) { 
                    document.getElementById("div_respon").innerHTML = "";
                    return;
                } else {
                    var xmlhttp = new XMLHttpRequest();
                    xmlhttp.onreadystatechange = function() {
                        if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                            document.getElementById("div_respon").innerHTML = xmlhttp.responseText;
                        }
                    };
                    strUrl = "doc_flow_ajax.jsp";

                    strUrl += "?company_id="+companyId;

                    strUrl += "&frm_company="+frmCompany;
                    strUrl += "&frm_division="+frmDivision;
                    strUrl += "&frm_department="+frmDepartment;
                    strUrl += "&frm_section="+frmSection;
                    strUrl += "&filter_by="+filterBy;
                    xmlhttp.open("GET", strUrl, true);

                    xmlhttp.send();
                }
            }

            function loadDepartment(
                companyId, divisionId, frmCompany, 
                frmDivision, frmDepartment, frmSection, filterBy
            ) {
                var strUrl = "";
                if ((companyId.length == 0)&&(divisionId.length == 0)) { 
                    document.getElementById("div_respon").innerHTML = "";
                    return;
                } else {
                    var xmlhttp = new XMLHttpRequest();
                    xmlhttp.onreadystatechange = function() {
                        if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                            document.getElementById("div_respon").innerHTML = xmlhttp.responseText;
                        }
                    };
                    strUrl = "doc_flow_ajax.jsp";

                    strUrl += "?company_id="+companyId;
                    strUrl += "&division_id="+divisionId;

                    strUrl += "&frm_company="+frmCompany;
                    strUrl += "&frm_division="+frmDivision;
                    strUrl += "&frm_department="+frmDepartment;
                    strUrl += "&frm_section="+frmSection;
                    strUrl += "&filter_by="+filterBy;
                    xmlhttp.open("GET", strUrl, true);
                    xmlhttp.send();
                }
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
            <span id="menu_title"><strong>Laporan</strong> <strong style="color:#333;"> / </strong> <strong>Penggajian</strong> <strong style="color:#333;"> / </strong> Uang Makan </span>
        </div>
        <div class="content-main">
            <form name="frpresence" method="post" action="">
                <input type="hidden" name="command" value="<%=iCommand%>">
                <input type="hidden" name="start" value="<%=start%>">
                <div class="formstyle">
                    <table>
                        <tr>
                            <td valign="top" style="padding-right: 21px;">
                                <div id="caption">NRK</div>
                                <div id="divinput">
                                    <input type="text" name="emp_number" id="emp_number" value="<%= rekapitulasiAbsensi.getPayrollNumber()%>" />
                                </div>
                                <div id="caption">Perusahaan</div>
                                <div id="divinput">
                                    <%

                                        Vector com_value = new Vector(1, 1);
                                        Vector com_key = new Vector(1, 1);
                                        String placeHolderComp = "";
                                        String multipleComp = "";
                                        if (inOidDivision.equals("")){
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
                                    <%= ControlCombo.draw("company_id", "chosen-select", null, "" + rekapitulasiAbsensi.getCompanyId(), com_value, com_key, multipleComp+" "+placeHolderComp+" style='width:100%'")%>
                                </div>
                                <div id="caption">Unit</div>
                                <div id="divinput">
                                    <%
                                        Vector dep_value = new Vector(1, 1);
                                        Vector dep_key = new Vector(1, 1);
                                        
                                        Vector listDep = new Vector();

                                        if (inOidDivision.equals("")){
                                            listDep = PstDepartment.list(0, 0, "hr_department.VALID_STATUS=1", "");
                                        } else {
                                            listDep = PstDepartment.list(0, 0, "hr_department."+PstDepartment.fieldNames[PstDepartment.FLD_DIVISION_ID] + " IN (" + inOidDivision + ") AND hr_department.VALID_STATUS=1", "");
                                        }

                                        Hashtable hashDiv = PstDivision.listMapDivisionName(0, 0, "", "");
                                        long tempDivOid = 0 ;
                                        for (int i = 0; i < listDep.size(); i++) {
                                            Department dep = (Department) listDep.get(i);
                                            inOidDepartment += ","+dep.getOID();

                                            if (dep.getDivisionId() != tempDivOid){
                                                dep_key.add("--"+hashDiv.get(dep.getDivisionId())+"--");
                                                dep_value.add(String.valueOf(-1));
                                                tempDivOid = dep.getDivisionId();
                                            }

                                            dep_key.add(dep.getDepartment());
                                            dep_value.add(String.valueOf(dep.getOID()));
                                        }
                                        inOidDepartment = inOidDepartment.substring(1);
                                    %>

                                    <%= ControlCombo.drawStringArraySelected("department", "chosen-select", null, rekapitulasiAbsensi.getArrDepartment(0), dep_key, dep_value, null, "size=8 multiple data-placeholder='Select Unit...' style='width:100%'") %> 
                                </div>
                                <div id="caption">Periode</div>
                                <div id="divinput">
                                    <select name="periodId" id="periodId" class="chosen-select" data-placeholder="Select Periode...">
                                        <option value="0">Select Periode...</option>
                                        <%
                                        Vector listPeriod = PstPayPeriod.list(0, 0, "", "START_DATE DESC");
                                        for (int r = 0; r < listPeriod.size(); r++) {
                                            PayPeriod payPeriod = (PayPeriod) listPeriod.get(r);
                                            %><option value="<%= String.valueOf(payPeriod.getOID()) %>"><%= payPeriod.getPeriod() %></option><%
                                        }
                                        %>
                                    </select>
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
                                        if (inOidDivision.equals("")){
                                            listDiv = PstDivision.list(0, 0, "VALID_STATUS=1", "");
                                            placeHolder = "data-placeholder='Select Satuan Kerja...'";
                                            multipleDiv = "multiple";
                                        } else {
                                            listDiv = PstDivision.list(0, 0, PstDivision.fieldNames[PstDivision.FLD_DIVISION_ID] + " IN (" + inOidDivision + ") AND VALID_STATUS=1", PstDivision.fieldNames[PstDivision.FLD_DIVISION_ID]);
                                        }

                                        for (int i = 0; i < listDiv.size(); i++) {
                                            Division div = (Division) listDiv.get(i);
                                            div_key.add(div.getDivision());
                                            div_value.add(String.valueOf(div.getOID()));
                                        }
                                    %>
                                        <%= ControlCombo.drawStringArraySelected("division_id", "chosen-select", null, rekapitulasiAbsensi.getArrDivision(0), div_key, div_value, null, multipleDiv+" "+placeHolder+" style='width:100%'") %> 
                                </div>
                                <div id="caption">Sub Unit</div>
                                <div id="divinput">
                                    <%

                                        Vector sec_value = new Vector(1, 1);
                                        Vector sec_key = new Vector(1, 1);
                                        

                                        Vector listSec = new Vector();

                                        if (inOidDivision.equals("")){
                                            listSec = PstSection.list(0, 0, "VALID_STATUS=1", "DEPARTMENT_ID");
                                        } else {
                                            listSec = PstSection.list(0, 0, PstSection.fieldNames[PstSection.FLD_DEPARTMENT_ID] + " IN (" + inOidDepartment+")", "DEPARTMENT_ID");
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
                                     <%= ControlCombo.drawStringArraySelected("section", "chosen-select", null, rekapitulasiAbsensi.getArrSection(0), sec_key, sec_value, null, "multiple data-placeholder='Select Sub Unit...' style='width:100%'") %> 
                                </div>    
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div>
                                    <a href="javascript:cmdSearch()" class="btn" style="color:#FFF;">Search</a>
                                    <a href="javascript:cmdExport()" class="btn" style="color:#FFF;">Export XLS</a>
                                </div>
                            </td> 
                        </tr>
                    </table>
                </div>
            <% if (iCommand == Command.LIST) {
                    if (listEmployee.size() > 0 ){ %>
                <h4><strong>Laporan Uang Makan Karyawan <%=period.getPeriod()%></strong></h4>
                <table class="tblStyle">
                    <tr>
                        <td class="title_tbl" style="text-align:center; vertical-align:middle">No</td>
                        <td class="title_tbl" style="text-align:center; vertical-align:middle">NRK</td>
                        <td class="title_tbl" style="text-align:center; vertical-align:middle">Nama</td>
                        <td class="title_tbl" style="text-align:center; vertical-align:middle">Jabatan</td>
                        <td class="title_tbl" style="text-align:center; vertical-align:middle">Hari Kerja</td>
                        <td class="title_tbl" style="text-align:center; vertical-align:middle">Hadir</td>
                        <td class="title_tbl" style="text-align:center; vertical-align:middle">Tugas Belajar</td>
                        <td class="title_tbl" style="text-align:center; vertical-align:middle">Dinas Luar</td>
                        <td class="title_tbl" style="text-align:center; vertical-align:middle">Cuti Besar</td>
                        <td class="title_tbl" style="text-align:center; vertical-align:middle">Cuti Tahunan</td>
                        <td class="title_tbl" style="text-align:center; vertical-align:middle">Cuti Penting</td>
                        <td class="title_tbl" style="text-align:center; vertical-align:middle">Cuti Sakit</td>
                        <td class="title_tbl" style="text-align:center; vertical-align:middle">Sakit</td>
                        <td class="title_tbl" style="text-align:center; vertical-align:middle">Cuti Hamil</td>
                        <td class="title_tbl" style="text-align:center; vertical-align:middle">Detasir</td>
                        <td class="title_tbl" style="text-align:center; vertical-align:middle">Dispen</td>
                        <td class="title_tbl" style="text-align:center; vertical-align:middle">Ijin</td>
                        <td class="title_tbl" style="text-align:center; vertical-align:middle">Terlambat</td>
                        <td class="title_tbl" style="text-align:center; vertical-align:middle">Hanya Absen Masuk</td>
                        <td class="title_tbl" style="text-align:center; vertical-align:middle">Hanya Absen Keluar</td>
                        <td class="title_tbl" style="text-align:center; vertical-align:middle">Blm Ada Ket.</td>
                        <td class="title_tbl" style="text-align:center; vertical-align:middle">No. Rekening</td>
                        <td class="title_tbl" style="text-align:center; vertical-align:middle">Jumlah Uang Makan</td>
                        <td class="title_tbl" style="text-align:center; vertical-align:middle"><%=komponenAdj%></td>
                        <td class="title_tbl" style="text-align:center; vertical-align:middle">Total Uang Makan</td>
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

                    
                    if (listEmployee != null && listEmployee.size() > 0) { 
                        for (int idxEmp = 0; idxEmp < listEmployee.size(); idxEmp++) {
                            Vector temp = (Vector) listEmployee.get(idxEmp);
                            Employee emp = (Employee) temp.get(0);
                            Map<String, Integer> mapTime = (Map<String, Integer>) temp.get(1);
                            Map<String, Double> mapComp = (Map<String, Double>) temp.get(2);
                            int hk = 0 ;

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

                            //String mealAllowanceCompCode = PstSystemProperty.getValueByName("MEAL_ALLOWANCE_COMP_CODE");
                             double uangMakan = (mapComp.get("UANG_MAKAN") == null ? 0 : mapComp.get("UANG_MAKAN"));
                             //uangMakan = PstPaySlipComp.getCompValueEmployee(emp.getOID(), period.getOID(), mealAllowanceCompCode);
                             double potongan = (mapComp.get("POTONGAN") == null ? 0 : mapComp.get("POTONGAN"));
                             //potongan = PstPaySlipComp.getCompValueEmployee(emp.getOID(), period.getOID(), "POT_MKN");

                             String bgColor = "";
                             if((idxEmp%2)==0){
                                 bgColor = "#FFF";
                             } else {
                                 bgColor = "#F9F9F9";
                             }
                             
                            %>
                                 <tr>
                                     <td style="background-color: <%=bgColor%>;"><%=""+ (idxEmp+1)%></td>
                                     <td style="background-color: <%=bgColor%>;"><%=""+ emp.getEmployeeNum()%></td>
                                     <td style="background-color: <%=bgColor%>;"><%=""+ emp.getFullName()%></td>
                                     <td style="background-color: <%=bgColor%>;"><%=""+ Level%></td>
                                     <td style="background-color: <%=bgColor%>;"><%=""+ period.getWorkDays()%></td>
                                     <td style="background-color: <%=bgColor%>;"><%=""+ (mapTime.get("H") == null ? 0 : mapTime.get("H"))%></td>
                                     <td style="background-color: <%=bgColor%>;"><%=""+ (mapTime.get("TB") == null ? 0 : mapTime.get("TB"))%></td>
                                     <td style="background-color: <%=bgColor%>;"><%=""+ (mapTime.get("DL") == null ? 0 : mapTime.get("DL"))%></td>
                                     <td style="background-color: <%=bgColor%>;"><%=""+ (mapTime.get("CB") == null ? 0 : mapTime.get("CB"))%></td>
                                     <td style="background-color: <%=bgColor%>;"><%=""+ (mapTime.get("CT") == null ? 0 : mapTime.get("CT"))%></td>
                                     <td style="background-color: <%=bgColor%>;"><%=""+ (mapTime.get("CP") == null ? 0 : mapTime.get("CP"))%></td>
                                     <td style="background-color: <%=bgColor%>;"><%=""+ (mapTime.get("CS") == null ? 0 : mapTime.get("CS"))%></td>
                                     <td style="background-color: <%=bgColor%>;"><%=""+ (mapTime.get("S") == null ? 0 : mapTime.get("S"))%></td>
                                     <td style="background-color: <%=bgColor%>;"><%=""+ (mapTime.get("CH") == null ? 0 : mapTime.get("CH"))%></td>
                                     <td style="background-color: <%=bgColor%>;"><%=""+ (mapTime.get("DET") == null ? 0 : mapTime.get("DET"))%></td>
                                     <td style="background-color: <%=bgColor%>;"><%=""+ (mapTime.get("DIS") == null ? 0 : mapTime.get("DIS"))%></td>
                                     <td style="background-color: <%=bgColor%>;"><%=""+ (mapTime.get("IMT") == null ? 0 : mapTime.get("IMT"))%></td>
                                     <td style="background-color: <%=bgColor%>;"><%=""+ (mapTime.get("LATE") == null ? 0 : mapTime.get("LATE"))%></td>
                                     <td style="background-color: <%=bgColor%>;"><%=""+ (mapTime.get("OI") == null ? 0 : mapTime.get("OI"))%></td>
                                     <td style="background-color: <%=bgColor%>;"><%=""+ (mapTime.get("OO") == null ? 0 : mapTime.get("OO"))%></td>
                                     <td style="background-color: <%=bgColor%>;"><%=""+ (mapTime.get("ABS") == null ? 0 : mapTime.get("ABS"))%></td>
                                     <td style="background-color: <%=bgColor%>;"><%=emp.getNoRekening()%></td>
                                     <td style="background-color: <%=bgColor%>;"><%=uangMakan%></td>
                                     <td style="background-color: <%=bgColor%>;"><%=potongan%></td>
                                     <td style="background-color: <%=bgColor%>;"><%=uangMakan - potongan%></td>
                                 </tr>
                            <%
                            }

                        }   
                    %>
                        
                </table>
                <%
                    } else {
                %>
                    <h6><strong>Tidak ada data</strong></h6>
                <%
                    }
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



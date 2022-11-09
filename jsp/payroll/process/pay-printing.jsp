<%-- 
    Document   : pay-printing
    Created on : Aug 31, 2016, 9:09:29 AM
    Author     : Dimata 007
--%>

<%@page import="com.dimata.harisma.session.employee.SessEmployee"%>
<%@page import="com.dimata.printman.PrinterDriverLoader"%>
<%@page import="com.dimata.printman.RemotePrintMan"%>
<%@page import="com.dimata.harisma.printout.PrintPaySlip"%>
<%@page import="com.dimata.printman.DSJ_PrintObj"%>
<%@page import="com.dimata.printman.PrnConfig"%>
<%@page import="com.dimata.printman.DSJ_PrinterService"%>
<%@page import="com.dimata.printman.PrinterHost"%>
<%@page import="com.dimata.harisma.entity.payroll.PstSalaryLevelDetail"%>
<%@page import="com.dimata.harisma.entity.payroll.PaySlipGroup"%>
<%@page import="com.dimata.harisma.entity.payroll.PstPaySlipGroup"%>
<%@page import="com.dimata.harisma.entity.payroll.PaySlip"%>
<%@page import="com.dimata.harisma.entity.payroll.PstPaySlip"%>
<%@page import="com.dimata.harisma.entity.log.ChangeValue"%>
<%@page import="com.dimata.gui.jsp.ControlCombo"%>
<%@page import="com.dimata.harisma.entity.payroll.PayPeriod"%>
<%@page import="com.dimata.harisma.entity.payroll.PstPayPeriod"%>
<%@page import="com.dimata.util.Command"%>
<%@page import="com.dimata.harisma.printout.PayPrintText"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file = "../../main/javainit.jsp" %>
<% int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_PAYROLL, AppObjInfo.G2_PAYROLL_PROCESS, AppObjInfo.OBJ_PAYROLL_PROCESS_PRINT);%>
<%@ include file = "../../main/checkuser.jsp" %>
<!DOCTYPE html>
<%!
    public String getEmployeeNum(long oid) {
        String str = "-";
        try {
            Employee emp = PstEmployee.fetchExc(oid);
            str = emp.getEmployeeNum();
        } catch (Exception ex) {
            System.out.println("Employee ==> " + ex.toString());
        }
        return str;
    }
%>
<%

    int statusUser = 0;
    long oidEmp = appUserSess.getEmployeeId();
    String whereUG = PstUserGroup.fieldNames[PstUserGroup.FLD_USER_ID]+"="+appUserSess.getOID();
    Vector userGroupList = PstUserGroup.list(0, 0, whereUG, "");
    if (userGroupList != null && userGroupList.size() > 0) {
         for (int i = 0; i < userGroupList.size(); i++) {
             UserGroup userGroup = (UserGroup) userGroupList.get(i);
             String whereG = PstAppGroup.fieldNames[PstAppGroup.FLD_GROUP_ID] + "=" + userGroup.getGroupID();
             Vector groupList = PstAppGroup.list(0, 0, whereG, "");
             if (groupList != null && groupList.size() > 0) {
                 AppGroup appGroup = (AppGroup) groupList.get(0);
                 if (appGroup.getGroupName().equals("Admin Cabang")){
                     statusUser = 1;
                 }

         }      
     }
    }
    
    /* Check Administrator */
    long empCompanyId = 0;
    long empDivisionId = 0;
    session.putValue("privViewAllDivision", privViewAllDivision);
    if (appUserSess.getAdminStatus()==0 && !privViewAllDivision){
        empCompanyId = emplx.getCompanyId();
        empDivisionId = emplx.getDivisionId();
    }
    String whereClause = "";
    String strUrl = "";
    strUrl  = "'"+empCompanyId+"',";
    strUrl += "'"+empDivisionId+"',";
    strUrl += "'0',";
    strUrl += "'0',";
    strUrl += "'company',";
    strUrl += "'division',";
    strUrl += "'department',";
    strUrl += "'section'";
    
    ChangeValue changeValue = new ChangeValue();
    int prevCommand = FRMQueryString.requestInt(request, "prev_command");
    int iCommand = FRMQueryString.requestCommand(request);
    int start = FRMQueryString.requestInt(request, "start");
    int inclResign = FRMQueryString.requestInt(request, "INCLUDE_RESIGN");
    boolean bIncResign = (inclResign == 1 ? true : false);
    String msgString = "";
    long oidCompany = FRMQueryString.requestLong(request, "company");
    long oidDivision = FRMQueryString.requestLong(request, "division");
    long oidDepartment = FRMQueryString.requestLong(request, "department");
    long oidSection = FRMQueryString.requestLong(request, "section");
    
    
    long oidPaySlipComp = FRMQueryString.requestLong(request, "section");
    String searchNrFrom = FRMQueryString.requestString(request, "searchNrFrom");
    String searchNrTo = FRMQueryString.requestString(request, "searchNrTo");
    String searchName = FRMQueryString.requestString(request, "searchName");
    String employeeNum = FRMQueryString.requestString(request, "employee_num");
    String employeeName = FRMQueryString.requestString(request, "employee_name");
    int dataStatus = FRMQueryString.requestInt(request, "dataStatus");
    String codeComponenGeneral = FRMQueryString.requestString(request, "compCode");
    String compName = FRMQueryString.requestString(request, "compName");
    int aksiCommand = FRMQueryString.requestInt(request, "aksiCommand");
    //priska 20150801
    long oidPayrollGroupId = FRMQueryString.requestLong(request, "payrollGroupId");

    //update by satrya 2014-03-26
    int value_search = FRMQueryString.requestInt(request, "value_search");

    long periodeId = FRMQueryString.requestLong(request, "periodId");
    int numKolom = FRMQueryString.requestInt(request, "numKolom");
    int statusSave = FRMQueryString.requestInt(request, "statusSave");
    int keyPeriod = FRMQueryString.requestInt(request, "paySlipPeriod");
    //update by satrya 2013-01-24
    long payGroupId = FRMQueryString.requestLong(request, "payGroupId");
    String keyPeriodStr = request.getParameter("paySlipPeriod");

    boolean printZeroValue = true;
    String sprintZeroValue = PstSystemProperty.getValueByName("PAYROLL_PRINT_ZERO_VALUE");
    if (sprintZeroValue == null || sprintZeroValue.length() == 0 || sprintZeroValue.equalsIgnoreCase("YES")
            || sprintZeroValue.equalsIgnoreCase("1") || sprintZeroValue.equalsIgnoreCase("Not initialized")) {
        printZeroValue = true;
    } else {
        printZeroValue = false;
    }

    String sTemp = PstSystemProperty.getValueByName("PAYROLL_PRINT_pageLength");
    int iTemp = 0;
    try {
        iTemp = Integer.parseInt(sTemp);
    } catch (Exception exc) {
        System.out.println("No setting for PAYROLL_PRINT_pageLength ");
    }
    int pageLength = iTemp != 0 ? iTemp : 29; // maximum row per slip

    sTemp = PstSystemProperty.getValueByName("PAYROLL_PRINT_pageWidth");
    try {
        iTemp = Integer.parseInt(sTemp);
    } catch (Exception exc) {
        System.out.println("No setting for PAYROLL_PRINT_pageWidth ");
    }
    int pageWidth = iTemp != 0 ? iTemp : 80; // maximum lebar per slip

    sTemp = PstSystemProperty.getValueByName("PAYROLL_PRINT_leftMargin");
    try {
        iTemp = Integer.parseInt(sTemp);
    } catch (Exception exc) {
        System.out.println("No setting for PAYROLL_PRINT_leftMargin ");
    }
    int leftMargin = iTemp != 0 ? iTemp : 2; // margin di kiri

    sTemp = PstSystemProperty.getValueByName("PAYROLL_PRINT_maxLeftgSiteLength");
    try {
        iTemp = Integer.parseInt(sTemp);
    } catch (Exception exc) {
        System.out.println("No setting for PAYROLL_PRINT_maxLeftgSiteLength ");
    }
    int maxLeftgSiteLength = iTemp != 0 ? iTemp : 48; // maximum lebar bagian kiri slip spt untuk company dan data karyawan

    sTemp = PstSystemProperty.getValueByName("PAYROLL_PRINT_startCompany");
    try {
        iTemp = Integer.parseInt(sTemp);
    } catch (Exception exc) {
        System.out.println("No setting for PAYROLL_PRINT_startCompany ");
    }
    int startCompany = iTemp != 0 ? iTemp : 1; // row mulai print company

    sTemp = PstSystemProperty.getValueByName("PAYROLL_PRINT_startColHeaderValue");
    try {
        iTemp = Integer.parseInt(sTemp);
    } catch (Exception exc) {
        System.out.println("No setting for PAYROLL_PRINT_startColHeaderValue ");
    }
    int startColHeaderValue = iTemp != 0 ? iTemp : 14;

    sTemp = PstSystemProperty.getValueByName("PAYROLL_PRINT_startRowSlipComp");
    try {
        iTemp = Integer.parseInt(sTemp);
    } catch (Exception exc) {
        System.out.println("No setting for PAYROLL_PRINT_startRowSlipComp ");
    }
    int startRowSlipComp = iTemp != 0 ? iTemp : 1; // start row slip component

    PayPrintText.setPageLength(pageLength);
    PayPrintText.setPageWidth(pageWidth);
    PayPrintText.setLeftMargin(leftMargin);
    PayPrintText.setMaxLeftgSiteLength(maxLeftgSiteLength);
    PayPrintText.setStartCompany(startCompany);
    PayPrintText.setStartColHeaderValue(startColHeaderValue);
    PayPrintText.setStartRowSlipComp(startRowSlipComp);
    
    String outPut = "";
    Vector listEmpPaySlip = new Vector(1, 1);
    if (iCommand == Command.LIST || iCommand == Command.PRINT) {
        String whereEmployee = "";
        if (employeeNum.length()>0){
            whereClause = PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_NUM]+"='"+employeeNum+"'";
            Vector listEmp = PstEmployee.list(0, 0, whereClause, "");
            if (listEmp != null && listEmp.size()>0){
                Employee emp = (Employee)listEmp.get(0);
                whereEmployee = PstPaySlip.fieldNames[PstPaySlip.FLD_EMPLOYEE_ID]+"="+emp.getOID();
            }
        }
        if (employeeName.length()>0){
            whereClause = PstEmployee.fieldNames[PstEmployee.FLD_FULL_NAME]+" LIKE '%"+ employeeName +"%' ";
            Vector listEmp = PstEmployee.list(0, 0, whereClause, "");
            whereClause = "";
            if (listEmp != null && listEmp.size()>0){
                for (int i=0; i<listEmp.size(); i++){
                    Employee emp = (Employee)listEmp.get(i);
                    whereClause += emp.getOID()+",";
                }
                whereClause = whereClause.substring(0, whereClause.length()-1);
                whereEmployee = PstPaySlip.fieldNames[PstPaySlip.FLD_EMPLOYEE_ID]+" IN("+ whereClause +") ";
            }
        }
        
        String companyName = changeValue.getCompanyName(oidCompany);
        String divisionName = changeValue.getDivisionName(oidDivision);
        String departName = changeValue.getDepartmentName(oidDepartment);
        String sectionName = changeValue.getSectionName(oidSection);
        outPut = "Comp = "+companyName;
        outPut += "\n Division = "+divisionName;
        outPut += "\n Period = "+periodeId;
        if (periodeId != 0){
            whereClause = PstPaySlip.fieldNames[PstPaySlip.FLD_PERIOD_ID]+"="+periodeId;
            Vector whereVect = new Vector();
            whereVect.add(whereClause);
            if (whereEmployee.length()>0){
                whereVect.add(whereEmployee);
            }
            if (oidCompany != 0){
                whereClause = PstPaySlip.fieldNames[PstPaySlip.FLD_COMP_CODE]+"='"+companyName+"'";
                whereVect.add(whereClause);
            }
            if (oidDivision != 0){
                whereClause = PstPaySlip.fieldNames[PstPaySlip.FLD_DIVISION]+"='"+divisionName+"'";
                whereVect.add(whereClause);
            }
            if (oidDepartment != 0){
                whereClause = PstPaySlip.fieldNames[PstPaySlip.FLD_DEPARTMENT]+"='"+departName+"'";
                whereVect.add(whereClause);
            }
            if (oidSection != 0){
                whereClause = PstPaySlip.fieldNames[PstPaySlip.FLD_SECTION]+"='"+sectionName+"'";
                whereVect.add(whereClause);
            }
            whereClause = "";
            if (whereVect != null && whereVect.size()>0){
                for (int i=0; i<whereVect.size(); i++){
                    String where = (String)whereVect.get(i);
                    whereClause += where;
                    if (i == (whereVect.size()-1)){
                        whereClause += " ";
                    } else {
                        whereClause += " AND ";
                    }
                }
            }
            String order = PstPaySlip.fieldNames[PstPaySlip.FLD_DIVISION];
            order += ","+PstPaySlip.fieldNames[PstPaySlip.FLD_DEPARTMENT];
            listEmpPaySlip = PstPaySlip.list(0, 0, whereClause, order);
        }
        outPut += "<div>Where : "+ whereClause +"</div>";
    }
        
            Vector hostLst = null;
            Vector localPrinter = null;
            try {
                //System.out.println(" JSP 1 0");
                //hostLst = RemotePrintMan.getHostList();
                //System.out.println(" JSP 1 1");
                if (hostLst != null) {
                    for (int h = 0; h < hostLst.size(); h++) {
                        PrinterHost host = (PrinterHost) hostLst.get(h);
                        //System.out.println(" JSP 1 2"+h);
                        if (host != null) {
                        //out.println(""+h+")"+host.getHostName()+"<br>");
                        }
                    }
                } else {
                    System.out.println("START LOCAL PRINTER SERVICE INDEX 0");
                    if( DSJ_PrinterService.getPrinterDrv(0)==null){ // check if the first printer exist
                        DSJ_PrinterService prnsvc = DSJ_PrinterService.getInstance();
                        if(!prnsvc.running){prnsvc.running=true;
                        Thread thr = new Thread(prnsvc);
                        thr.setDaemon(false); thr.start();}
                    }
                 }
            } catch (Exception exc) {
                System.out.println("HostLst:  " + exc);
            }
            //out.println("hostLst :::::::::::::"+hostLst);

                %>
<%
            String s_employee_id = null;
            String s_payslip_id = null;
            String s_level_code = null;
            long oidEmployee = 0;
// Jika tekan command Save
            if (iCommand == Command.PRINT) {
                if (aksiCommand == 0) {
                    System.out.println("print all");
                    String[] employee_id = null;
                    String[] paySlip_id = null;
                    String[] level_code = null;
                    String hostIpIdx = "";
                    Vector listDfGjPrintBenefit = new Vector(1, 1);
                    Vector listDfGjPrintDeduction = new Vector(1, 1);
                    try {
                        employee_id = request.getParameterValues("employeeId");
                        paySlip_id = request.getParameterValues("paySlipId");
                        level_code = request.getParameterValues("level_code");
                        hostIpIdx = request.getParameter("printeridx");// ip server
                        System.out.println("nilai hostIpIdx  " + hostIpIdx);
                    } catch (Exception e) {
                        System.out.println("Err : " + e.toString());
                    }

                    DSJ_PrintObj obj = null;
                    Vector list = new Vector();
                    if(employee_id!=null && paySlip_id!=null && level_code!=null ){
                    for (int i = 0; i < listEmpPaySlip.size(); i++) {
                        listDfGjPrintBenefit = new Vector();
                        try {
                            //oidEmployee = FRMQueryString.requestLong(request, "print"+i+""); // row yang dicheked
                            s_employee_id = String.valueOf(employee_id[i]);
                            s_payslip_id = String.valueOf(paySlip_id[i]);
                            s_level_code = String.valueOf(level_code[i]);
                        } catch (Exception e) {
                        }
                        //print semua yang ditmapilkan
                        // cari payslip dari slip yang akan dicetak
                        //listDfGjPrintBenefit = PstSalaryLevelDetail.listPaySlip(PstSalaryLevelDetail.YES_TAKE,s_level_code,PstPayComponent.TYPE_BENEFIT,Long.parseLong(paySlip_id[i]),keyPeriod, printZeroValue);
                        //System.out.println("PaySlipId yang diprint " + Long.parseLong(paySlip_id[i]));
                        listDfGjPrintBenefit = PstSalaryLevelDetail.listPaySlipGlobal(PstSalaryLevelDetail.YES_TAKE, s_level_code, Long.parseLong(paySlip_id[i]), keyPeriod);
                        list.add(listDfGjPrintBenefit);

                    }
                   }
                    if ( (hostIpIdx != null) && (hostLst != null) && (hostLst.size() >0)) {
                        System.out.println("PrintPaySlip.rowxz  " + listDfGjPrintBenefit.size());
                        obj = PrintPaySlip.PrintForm(employee_id, periodeId, list, listEmpPaySlip, keyPeriod,payGroupId);
                        PrinterHost prnHost = RemotePrintMan.getPrinterHost(hostIpIdx, ";");
                        PrnConfig prn = RemotePrintMan.getPrinterConfig(hostIpIdx, ";");
                        obj.setPrnIndex(prn.getPrnIndex());
                        RemotePrintMan.printObj(prnHost, obj);
                    }else{
                        obj = PrintPaySlip.PrintForm(employee_id, periodeId, list, listEmpPaySlip, keyPeriod,payGroupId);
                        try{obj.setPrnIndex(Integer.parseInt(hostIpIdx));}catch(Exception exc){System.out.println(exc);};
                        if(obj!=null && (!DSJ_PrinterService.existPrnDriverLoader(obj.getPrnIndex()) || !DSJ_PrinterService.running)){
                            DSJ_PrinterService prnSvc =  DSJ_PrinterService.getInstance();
                            if(obj!=null){
                                PrinterDriverLoader prndLoader = new PrinterDriverLoader(obj);
                                prnSvc.addPrnDriverLoader(prndLoader);
                                Thread thr = new Thread(prnSvc);
                                thr.setDaemon(false);
                                thr.start();
                            }
                         }
                        if(obj!=null && DSJ_PrinterService.existPrnDriverLoader(obj.getPrnIndex())){                            
                            DSJ_PrinterService.print(obj);
                         }else {
                             if(!DSJ_PrinterService.existPrnDriverLoader(obj.getPrnIndex())){
                                 msgString = "No local printer found";
                               }
                             }
                      }
                    //update by satrya 2013-01-14
                     listEmpPaySlip = SessEmployee.listEmpPaySlip(oidDepartment, oidDivision, oidSection, searchNrFrom, searchNrTo, searchName, periodeId, -1, bIncResign, oidPayrollGroupId);
                } else {
                    System.out.println("print selected");
                    String[] employee_id = null;
                    String[] paySlip_id = null;
                    String[] level_code = null;
                    String hostIpIdx = "";
                    Vector listDfGjPrintBenefit = new Vector(1, 1);
                    try {
                        employee_id = request.getParameterValues("employeeId");
                        paySlip_id = request.getParameterValues("paySlipId");
                        level_code = request.getParameterValues("level_code");
                        hostIpIdx = request.getParameter("printeridx");// ip server
                        System.out.println("nilai hostIpIdx  " + hostIpIdx);
                    } catch (Exception e) {
                        System.out.println("Err : " + e.toString());
                    }
                    DSJ_PrintObj obj = null;
                    Vector list = new Vector();
                    Vector listEmp = new Vector();
                    Vector listEmpId= new Vector();
                    for (int i = 0; i < listEmpPaySlip.size(); i++) {
                        listDfGjPrintBenefit = new Vector();
                        try {
                            oidEmployee = FRMQueryString.requestLong(request, "print" + i + ""); // row yang dicheked
                            s_employee_id = String.valueOf(employee_id[i]);
                            s_payslip_id = String.valueOf(paySlip_id[i]);
                            s_level_code = String.valueOf(level_code[i]);
                        } catch (Exception e) {
                            System.out.println("Exception"+e);
                        }
                        //System.out.println("nilai statusSave"+statusSave);
                        if (oidEmployee != 0) {
                            //System.out.println("PaySlipId yang diprint " + Long.parseLong(paySlip_id[i]));
                            //System.out.println("keyPeriod yang diprint  " + keyPeriod);
                            listDfGjPrintBenefit = PstSalaryLevelDetail.listPaySlipGlobal(PstSalaryLevelDetail.YES_TAKE, s_level_code, Long.parseLong(paySlip_id[i]), keyPeriod);
                            list.add(listDfGjPrintBenefit);
                            listEmp.add("" + oidEmployee);
                            listEmpId.add(oidEmployee);
                        }
                        
                    }
                    if(listEmpId!=null && listEmpId.size()>0){
                            listEmpPaySlip = SessEmployee.listEmpPaySlipByEmployeeId(listEmpId, periodeId, -1, bIncResign);
                        }
                    if ( (hostIpIdx != null) && (hostLst != null) && (hostLst.size() >0)) {
                        System.out.println("PrintPaySlip.rowxz  " + listDfGjPrintBenefit.size());
                        obj = PrintPaySlip.PrintForm(employee_id, periodeId, list, listEmp, keyPeriod,payGroupId);
                        PrinterHost prnHost = RemotePrintMan.getPrinterHost(hostIpIdx, ";");
                        PrnConfig prn = RemotePrintMan.getPrinterConfig(hostIpIdx, ";");
                        obj.setPrnIndex(prn.getPrnIndex());
                        RemotePrintMan.printObj(prnHost, obj);
                    } else{                                                    
                        obj = PrintPaySlip.PrintForm(employee_id, periodeId, list, listEmp, keyPeriod,payGroupId);
                        try{obj.setPrnIndex(Integer.parseInt(hostIpIdx));}catch(Exception exc){System.out.println(exc);};
                        if(obj!=null && (!DSJ_PrinterService.existPrnDriverLoader(obj.getPrnIndex()) || !DSJ_PrinterService.running)){
                            DSJ_PrinterService prnSvc =  DSJ_PrinterService.getInstance();
                            if(obj!=null){
                                PrinterDriverLoader prndLoader = new PrinterDriverLoader(obj);
                                prnSvc.addPrnDriverLoader(prndLoader);
                                Thread thr = new Thread(prnSvc);
                                thr.setDaemon(false);
                                thr.start();
                            }
                         }
                        if(obj!=null && DSJ_PrinterService.existPrnDriverLoader(obj.getPrnIndex())){
                            DSJ_PrinterService.print(obj);
                         } else {
                             if(!DSJ_PrinterService.existPrnDriverLoader(obj.getPrnIndex())){
                                 msgString = "No local printer found";
                            }
                             }
                      }
                     
                }
                //hidde by satrya 2013-01-14
               // listEmpPaySlip = SessEmployee.listEmpPaySlip(oidDepartment, oidDivision, oidSection, searchNrFrom, searchNrTo, searchName, periodeId, -1, bIncResign);
            }
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Cetak Slip Gaji</title>
        <link rel="stylesheet" href="../../styles/main.css" type="text/css">
        <style type="text/css">
            .tblStyle {border-collapse: collapse;}
            .tblStyle td {padding: 3px 5px; border: 1px solid #CCC; font-size: 12px; }
            .title_tbl {font-weight: bold;background-color: #DDD; color: #575757;}
            .title_page {color:#0db2e1; font-weight: bold; font-size: 14px; background-color: #EEE; border-left: 1px solid #0099FF; padding: 12px 18px;}

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
                padding: 7px 0px 21px 0px;
                margin: 0px 0px 21px 0px;
                border-bottom: 1px solid #DDD;
            }
        </style>
        <SCRIPT language=JavaScript>        
            function fnTrapKD(){
                if (event.keyCode == 13) {
                    document.all.aSearch.focus();
                    cmdSearch();
                }
            }

            function openTaxCalc(paySlipOid){
                document.frm_printing.target="taxcalculator    ";
                document.frm_printing.command.value="<%=Command.PRINT%>";
                document.frm_printing.aksiCommand.value="1";
                document.frm_printing.action="taxcalculator.jsp";
                document.frm_printing.target = "";
                document.frm_printing.submit();
                document.frm_printing.target="";
            }
            function cmdUpdateDiv(){
                document.frm_printing.target="";    
                document.frm_printing.command.value="<%=String.valueOf(Command.GOTO)%>";
                document.frm_printing.action="pay-printing.jsp";        
                document.frm_printing.submit();
            }

            function cmdUpdateDept(){
                document.frm_printing.target="";    
                document.frm_printing.command.value="<%=String.valueOf(Command.GOTO)%>";
                document.frm_printing.action="pay-printing.jsp";        
                document.frm_printing.submit();
            }

            function cmdUpdateSec(){
                document.frm_printing.target="";    
                document.frm_printing.command.value="<%=String.valueOf(Command.GOTO)%>";
                document.frm_printing.action="pay-printing.jsp";        
                document.frm_printing.submit();
            }

            function cmdSearch(){
                document.frm_printing.target="";
                document.frm_printing.command.value="<%=Command.LIST%>";
                document.frm_printing.value_search.value="1";
                document.frm_printing.action="pay-printing.jsp";
                document.frm_printing.submit();
            }
        
            function cmdLoad(component_code,component_name){
                document.frm_printing.target="";
                document.frm_prepare_data.compCode.value=component_code;
                document.frm_prepare_data.compName.value=component_name;
                document.frm_prepare_data.command.value="<%=Command.LIST%>";
                document.frm_prepare_data.action="pay-pre-data.jsp";
                document.frm_prepare_data.submit();
                document.frm_prepare_data.refresh;
            }
        
            function cmdLevel(employeeId,salaryLevel,paySlipId,paySlipPeriod){
                document.frm_printing.target="";
                document.frm_prepare_data.action="pay-input-detail.jsp?employeeId=" + employeeId+ "&salaryLevel=" + salaryLevel+"&paySlipId=" + paySlipId +"&paySlipPeriod=" + paySlipPeriod ;
                document.frm_prepare_data.command.value="<%=Command.LIST%>";
                document.frm_prepare_data.submit();
            }
        
            function cmdSave(){
                document.frm_printing.target="";
                document.frm_prepare_data.command.value="<%=Command.SAVE%>";
                document.frm_prepare_data.aksiCommand.value="0";
                document.frm_prepare_data.statusSave.value="0";
                document.frm_prepare_data.action="pay-pre-data.jsp";
                document.frm_prepare_data.submit();
            }
            function cmdPrint(){
                document.frm_printing.target="";
                document.frm_printing.toEmail.value="0";
                document.frm_printing.command.value="<%=Command.PRINT%>";
                document.frm_printing.aksiCommand.value="1";
                document.frm_printing.action="pay-printing.jsp";
                document.frm_printing.target = "";
                document.frm_printing.submit();
            }
        
            function cmdPrintAll(){
                document.frm_printing.target="";
                document.frm_printing.toEmail.value="0";
                document.frm_printing.command.value="<%=Command.PRINT%>";
                document.frm_printing.aksiCommand.value="0";
                document.frm_printing.action="pay-printing.jsp";
                document.frm_printing.target = "";
                document.frm_printing.submit();
            }
            function cmdPrintHtml(){
                document.frm_printing.target="";
                document.frm_printing.toEmail.value="0";
                document.frm_printing.command.value="<%=Command.PRINT%>";
                document.frm_printing.aksiCommand.value="1";
                document.frm_printing.action="pay_print_slip.jsp";
                document.frm_printing.target = "";
                document.frm_printing.submit();
            }

            function cmdPrintAllHtml(){
                document.frm_printing.target="";
                document.frm_printing.toEmail.value="0";
                document.frm_printing.command.value="<%=Command.PRINT%>";
                document.frm_printing.aksiCommand.value="0";
                document.frm_printing.action="pay_print_slip.jsp";
                document.frm_printing.target = "";
                document.frm_printing.submit();
            }

            function cmdPrintText(){
                document.frm_printing.target="";
                document.frm_printing.toEmail.value="0";
                document.frm_printing.command.value="<%=Command.PRINT%>";
                document.frm_printing.aksiCommand.value="1";
                document.frm_printing.action="<%=approot%>/servlet/com.dimata.harisma.printout.PayPrintText";
                document.frm_printing.target = "";
                document.frm_printing.submit();
            }

            function cmdPrintAllText(){
                document.frm_printing.target="";
                document.frm_printing.toEmail.value="0";
                document.frm_printing.command.value="<%=Command.PRINT%>";
                document.frm_printing.aksiCommand.value="0";
                document.frm_printing.target="printpayroll";
                document.frm_printing.action="<%=approot%>/servlet/com.dimata.harisma.printout.PayPrintText";
                document.frm_printing.submit();
            }

            function cmdPrintCsv(){
                document.frm_printing.target="";
                document.frm_printing.toEmail.value="0";
                document.frm_printing.command.value="<%=Command.PRINT%>";
                document.frm_printing.aksiCommand.value="1";
                document.frm_printing.target="summarypayroll";
                document.frm_printing.action="<%=approot%>/servlet/com.dimata.harisma.printout.PayrollSummaryXls";
                document.frm_printing.submit();
            }

            function cmdPrintAllCsv(){
                document.frm_printing.target="";
                document.frm_printing.toEmail.value="0";
                document.frm_printing.command.value="<%=Command.PRINT%>";
                document.frm_printing.aksiCommand.value="0";
                document.frm_printing.target="summarypayroll";
                document.frm_printing.action="<%=approot%>/servlet/com.dimata.harisma.printout.PayrollSummaryXls";
                document.frm_printing.submit();
            }

            function cmdPrintAllCsvPerDepart(){
                document.frm_printing.target="";
                document.frm_printing.toEmail.value="0";
                document.frm_printing.command.value="<%=Command.PRINT%>";
                document.frm_printing.aksiCommand.value="0";
                document.frm_printing.target="summarypayroll";
                document.frm_printing.action="<%=approot%>/servlet/com.dimata.harisma.printout.PayrollSummaryXls1PerDepart";
                document.frm_printing.submit();
            }

            function cmdPrintAllCsvPerSection(){
                document.frm_printing.target="";
                document.frm_printing.toEmail.value="0";
                document.frm_printing.command.value="<%=Command.PRINT%>";
                document.frm_printing.aksiCommand.value="0";
                document.frm_printing.target="summarypayroll";
                document.frm_printing.action="<%=approot%>/servlet/com.dimata.harisma.printout.PayrollSummaryXlsPerSection";
                document.frm_printing.submit();
            }
        
            function cmdPrintAllCsvDifferent(){
                document.frm_printing.target="";
                document.frm_printing.toEmail.value="0";
                document.frm_printing.command.value="<%=Command.PRINT%>";
                document.frm_printing.aksiCommand.value="0";
                document.frm_printing.target="summarypayroll";
                document.frm_printing.action="<%=approot%>/servlet/com.dimata.harisma.printout.PayrollSummaryXlsDifferent";
                document.frm_printing.submit();
            }

            function cmdPrintSelectedBinding(){
                document.frm_printing.target="";
                document.frm_printing.toEmail.value="0";
                document.frm_printing.command.value="<%=Command.PRINT%>";
                document.frm_printing.aksiCommand.value="1";
                document.frm_printing.action="<%=approot%>/servlet/com.dimata.harisma.printout.PayPrintBinding";
                document.frm_printing.target = "";
                document.frm_printing.submit();
            }
        
            function cmdEmailSelectedBinding(){
                document.frm_printing.target="";
                document.frm_printing.command.value="<%=Command.PRINT%>";
                document.frm_printing.aksiCommand.value="1";
                document.frm_printing.toEmail.value="1";
                document.frm_printing.action="<%=approot%>/servlet/com.dimata.harisma.printout.PayPrintText";
                document.frm_printing.target = "";
                document.frm_printing.submit();
            }

            function cmdEmailSelectedPdf(){
                document.frm_printing.target="_blank";
                document.frm_printing.command.value="<%=Command.PRINT%>";
                document.frm_printing.aksiCommand.value="1";
                document.frm_printing.toEmail.value="1";
                document.frm_printing.action="<%=approot%>/servlet/PayPrintPdf";
                document.frm_printing.submit();
            }
 
            function cmdPrintSelectedPdf(){
                document.frm_printing.target="_blank";
                document.frm_printing.command.value="<%=Command.PRINT%>";
                document.frm_printing.aksiCommand.value="1";
                document.frm_printing.toEmail.value="0";
                document.frm_printing.action="<%=approot%>/servlet/PayPrintPdf";
                document.frm_printing.submit();
            }
            
            function cmdPrintAllBinding(){
                document.frm_printing.target="";
                document.frm_printing.command.value="<%=Command.PRINT%>";
                document.frm_printing.toEmail.value="1";
                document.frm_printing.aksiCommand.value="0";
                document.frm_printing.target="printpayroll";
                document.frm_printing.action="<%=approot%>/servlet/com.dimata.harisma.printout.PayPrintBinding";
                document.frm_printing.submit();
            }
        
            function cmdEmaillAlPdf(){
                document.frm_printing.target="_blank";
                document.frm_printing.command.value="<%=Command.PRINT%>";
                document.frm_printing.toEmail.value="1";
                document.frm_printing.aksiCommand.value="0";
                document.frm_printing.target="printpayroll";
                document.frm_printing.action="<%=approot%>/servlet/PayPrintPdf";
                document.frm_printing.submit();
            }
        
            function cmdPrintAllPdf(){
                document.frm_printing.target="_blank";
                document.frm_printing.command.value="<%=Command.PRINT%>";
                document.frm_printing.toEmail.value="0";
                document.frm_printing.aksiCommand.value="0";
                document.frm_printing.target="printpayroll";
                document.frm_printing.action="<%=approot%>/servlet/PayPrintPdf";
                document.frm_printing.submit();
            }
                
            function cmdEmailAllBinding(){
                document.frm_printing.target="";
                document.frm_printing.command.value="<%=Command.PRINT%>";
                document.frm_printing.toEmail.value="1";
                document.frm_printing.aksiCommand.value="0";
                document.frm_printing.target="printpayroll";
                document.frm_printing.action="<%=approot%>/servlet/com.dimata.harisma.printout.PayPrintBinding";
                document.frm_printing.submit();
            }
        
            function cmdPrintSelectedVersi1(){
                document.frm_printing.target="";
                document.frm_printing.command.value="<%=Command.PRINT%>";
                document.frm_printing.aksiCommand.value="1";
                document.frm_printing.action="<%=approot%>/servlet/com.dimata.harisma.printout.PayPrintText1";
                document.frm_printing.target = "";
                document.frm_printing.submit();
            }

            function cmdPrintAllVersi1(){
                document.frm_printing.target="";
                document.frm_printing.command.value="<%=Command.PRINT%>";
                document.frm_printing.aksiCommand.value="0";
                document.frm_printing.target="printpayroll";
                document.frm_printing.action="<%=approot%>/servlet/com.dimata.harisma.printout.PayPrintText1";
                document.frm_printing.submit();
            }
        
            function cmdPrintToPdf(){
                document.frm_printing.target="";
                document.frm_printing.command.value="<%=Command.PRINT%>";
                document.frm_printing.aksiCommand.value="0";
                document.frm_printing.target="printpayroll";
                document.frm_printing.action="<%=approot%>/servlet/com.dimata.harisma.printout.PayPrintPdf";
                document.frm_printing.submit();
            }
            
            function cmdSaveAll(){
                document.frm_printing.target="";
                document.frm_prepare_data.command.value="<%=Command.SAVE%>";
                document.frm_prepare_data.aksiCommand.value="0";
                document.frm_prepare_data.statusSave.value="1";
                document.frm_prepare_data.action="pay-pre-data.jsp";
                document.frm_prepare_data.submit();
            }
        
            function cmdBack(){
                document.frm_printing.target="";
                document.frm_prepare_data.command.value="<%=Command.LIST%>";
                document.frm_prepare_data.action="pay-pre-data.jsp";
                document.frm_prepare_data.submit();
            }
        </SCRIPT>
<script type="text/javascript">

function loadCompany(
    pCompanyId, pDivisionId, pDepartmentId, pSectionId,
    frmCompany, frmDivision, frmDepartment, frmSection
) {
    var strUrl = "";
    if (pCompanyId.length == 0) { 
        document.getElementById("div_result").innerHTML = "";
        return;
    } else {
        var xmlhttp = new XMLHttpRequest();
        xmlhttp.onreadystatechange = function() {
            if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                document.getElementById("div_result").innerHTML = xmlhttp.responseText;
            }
        };
        strUrl = "company_structure.jsp";
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
    companyId, frmCompany, frmDivision, frmDepartment, frmSection
) {
    var strUrl = "";
    if (companyId.length == 0) { 
        document.getElementById("div_result").innerHTML = "";
        return;
    } else {
        var xmlhttp = new XMLHttpRequest();
        xmlhttp.onreadystatechange = function() {
            if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                document.getElementById("div_result").innerHTML = xmlhttp.responseText;
            }
        };
        strUrl = "company_structure.jsp";

        strUrl += "?company_id="+companyId;

        strUrl += "&frm_company="+frmCompany;
        strUrl += "&frm_division="+frmDivision;
        strUrl += "&frm_department="+frmDepartment;
        strUrl += "&frm_section="+frmSection;
        xmlhttp.open("GET", strUrl, true);

        xmlhttp.send();
    }
}
    
function loadDepartment(
    companyId, divisionId, frmCompany, 
    frmDivision, frmDepartment, frmSection
) {
    var strUrl = "";
    if ((companyId.length == 0)&&(divisionId.length == 0)) { 
        document.getElementById("div_result").innerHTML = "";
        return;
    } else {
        var xmlhttp = new XMLHttpRequest();
        xmlhttp.onreadystatechange = function() {
            if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                document.getElementById("div_result").innerHTML = xmlhttp.responseText;
            }
        };
        strUrl = "company_structure.jsp";
       
        strUrl += "?company_id="+companyId;
        strUrl += "&division_id="+divisionId;
        
        strUrl += "&frm_company="+frmCompany;
        strUrl += "&frm_division="+frmDivision;
        strUrl += "&frm_department="+frmDepartment;
        strUrl += "&frm_section="+frmSection;
        xmlhttp.open("GET", strUrl, true);
        xmlhttp.send();
    }
}
    
function loadSection(
    companyId, divisionId, departmentId,
    frmCompany, frmDivision, frmDepartment, frmSection
) {
    var strUrl = "";
    if ((companyId.length == 0)&&(divisionId.length == 0)&&(departmentId.length == 0)) { 
        document.getElementById("div_result").innerHTML = "";
        return;
    } else {
        var xmlhttp = new XMLHttpRequest();
        xmlhttp.onreadystatechange = function() {
            if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                document.getElementById("div_result").innerHTML = xmlhttp.responseText;
            }
        };
        strUrl = "company_structure.jsp";
       
        strUrl += "?company_id="+companyId;
        strUrl += "&division_id="+divisionId;
        strUrl += "&department_id="+departmentId;
        
        strUrl += "&frm_company="+frmCompany;
        strUrl += "&frm_division="+frmDivision;
        strUrl += "&frm_department="+frmDepartment;
        strUrl += "&frm_section="+frmSection;
        xmlhttp.open("GET", strUrl, true);
        xmlhttp.send();
    }
}
</script>
<script>
    function pageLoad(){ 
        <% if (statusUser == 1 || appUserSess.getAdminStatus() == 1 || privViewAllDivision) { %>
        loadCompany(<%=strUrl%>);
        <% } %>
    } 
    function cmdSelectAll(){
        <% for(int i=0 ; i<listEmpPaySlip.size(); i++) { %>	              
            document.frm_printing.print<%=i%>.checked = "true";  
        <% } %>
    }
    function cmdDeselectAll(){
        <% for(int i=0 ; i<listEmpPaySlip.size(); i++) { %>	              
            document.frm_printing.print<%=i%>.checked = "";  
        <% } %>
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
            <span id="menu_title">Cetak Slip Gaji</span>
        </div>
        <div class="content-main">
            <form name="frm_printing" method="post" action="" >
                <input type="hidden" name="command" value="">
                <input type="hidden" name="aksiCommand" value="<%=aksiCommand%>">
                <input type="hidden" name="value_search" value="<%=value_search%>">
                <input type="hidden" name="toEmail" value="0">
                <table width="79%">
                    <tr>
                        <td valign="top" width="50%">
                            <div class="caption">
                                Period
                            </div>
                            <div class="divinput">
                                <%
                                    Vector periodValue = new Vector(1, 1);
                                    Vector periodKey = new Vector(1, 1);
                                    Vector listPeriod = PstPayPeriod.list(0, 0, "", "START_DATE DESC");
                                    for (int r = 0; r < listPeriod.size(); r++) {
                                        PayPeriod payPeriod = (PayPeriod) listPeriod.get(r);
                                        periodValue.add("" + payPeriod.getOID());
                                        periodKey.add(payPeriod.getPeriod());
                                    }
                                %> <%=ControlCombo.draw("periodId", null, "" + periodeId, periodValue, periodKey, "")%> 
                            </div>
                            <div id="div_result"></div>
                        </td>
                        <td valign="top" width="50%">
                            <div class="caption">
                                Employee Number (NRK)
                            </div>
                            <div class="divinput">
                                <input type="text" name="employee_num" size="12" value="<%=(statusUser == 1 || appUserSess.getAdminStatus() == 1 || privViewAllDivision ?  "" : emplx.getEmployeeNum())%>" <%=(statusUser == 1 || appUserSess.getAdminStatus() == 1 || privViewAllDivision ? "" : "readonly='readonly'" )%>>
                            </div>
                            <% if (statusUser == 1 || appUserSess.getAdminStatus() == 1 || privViewAllDivision) { %>
                            <div class="caption">
                                Nama
                            </div>
                            <div class="divinput">
                                <input type="text" name="employee_name" size="70" value="">
                            </div>
                            <% } %>
                            
                            
                            <div>&nbsp;</div>
                            <a class="btn" style="color:#FFF" href="javascript:cmdSearch()">Cari Slip</a>
                        </td>
                    </tr>
                </table>
                            <br>
                <div style="border-bottom: 1px solid #DDD"></div>
                <table>
                <%
                    if ((listEmpPaySlip != null) && (listEmpPaySlip.size() > 0)) {
                %>
                <tr> 
                    <td>
                        <strong>Pay Slip Group</strong> &nbsp;&nbsp;&nbsp;
                        <%
                            //update by satrya 2013-01-24
                            //Pay Group SLip

                            Vector grkKey = new Vector();
                            Vector grValue = new Vector();
                            Vector listPaySlipGroup = new Vector();
                            if (!privViewAllDivision || statusUser == 0 || appUserSess.getAdminStatus() == 1){
                                listPaySlipGroup = PstPaySlipGroup.list(0, 0, PstPaySlipGroup.fieldNames[PstPaySlipGroup.FLD_SHOW_ALL]+"= 1", "");
                            } else {
                                listPaySlipGroup = PstPaySlipGroup.listAll();
                            }
                            if (listPaySlipGroup != null && listPaySlipGroup.size() > 0) {
                                for (int r = 0; r < listPaySlipGroup.size(); r++) {
                                    PaySlipGroup paySlipGroup = (PaySlipGroup) listPaySlipGroup.get(r);
                                    grkKey.add(String.valueOf(paySlipGroup.getOID()));
                                    grValue.add(paySlipGroup.getGroupName());
                                }
                            }

                            out.println(ControlCombo.draw("payGroupId", null, "" + payGroupId, grkKey, grValue));
                        %>
                    </td>
                    <td>
                        <%
                        //value for period
                        Vector perKey = new Vector();
                        Vector perValue = new Vector();
                        perKey.add(PstSalaryLevelDetail.PERIODE_WEEKLY + "");
                        perKey.add(PstSalaryLevelDetail.PERIODE_MONTHLY + "");
                        perKey.add(PstSalaryLevelDetail.PERIODE_YEAR + "");
                        perValue.add(PstSalaryLevelDetail.periodKey[PstSalaryLevelDetail.PERIODE_WEEKLY]);
                        perValue.add(PstSalaryLevelDetail.periodKey[PstSalaryLevelDetail.PERIODE_MONTHLY]);
                        perValue.add(PstSalaryLevelDetail.periodKey[PstSalaryLevelDetail.PERIODE_YEAR]);

                        out.println(ControlCombo.draw("paySlipPeriod", null, 
                                "" + ((keyPeriodStr==null || keyPeriodStr.length()<1)? PstSalaryLevelDetail.PERIODE_MONTHLY : keyPeriod ) , perKey, perValue));
                        %>
                    </td>

                </tr>
                <%
                    }
                %>
                </table>
                <div>&nbsp;</div>
                <%
                    if ((listEmpPaySlip != null) && (listEmpPaySlip.size() > 0)) {
                %>               
                <a href="javascript:cmdSelectAll()" class="btn" style="color:#FFF;">Select All</a>
                <a href="javascript:cmdDeselectAll()" class="btn" style="color:#FFF;">Deselect All</a>
                <div>&nbsp;</div>
                <table class="tblStyle">
                    <tr>
                        <td class="title_tbl">No</td>
                        <td class="title_tbl">&nbsp;</td>
                        <td class="title_tbl">NRK</td>
                        <td class="title_tbl">Nama</td>
                        <td class="title_tbl">Satuan Kerja</td>
                        <td class="title_tbl">Unit</td>
                        <td class="title_tbl">Sub Unit</td>
                        <td class="title_tbl">Jabatan</td>
                    </tr>
                    <%
                    for (int i=0; i<listEmpPaySlip.size(); i++){
                        PaySlip paySlip = (PaySlip)listEmpPaySlip.get(i);
                        %>
                        <tr>
                            <td style="background-color: #FFF"><%= (i+1) %></td>
                            <td style="background-color: #FFF">
                                <input type="checkbox" name="print<%= i %>" value="<%= paySlip.getEmployeeId() %>" />
                                <input type="hidden" name="employeeId" value="<%= paySlip.getEmployeeId() %>" />
                                <input type="hidden" name="paySlipId" value="<%= paySlip.getOID() %>" />
                            </td>
                            <td style="background-color: #FFF"><%= getEmployeeNum(paySlip.getEmployeeId()) %></td>
                            <td style="background-color: #FFF"><%= changeValue.getEmployeeName(paySlip.getEmployeeId()) %></td>
                            <td style="background-color: #FFF"><%= paySlip.getDivision() %></td>
                            <td style="background-color: #FFF"><%= paySlip.getDepartment() %></td>
                            <td style="background-color: #FFF"><%= paySlip.getSection() %></td>
                            <td style="background-color: #FFF"><%= paySlip.getPosition() %></td>
                        </tr>
                        <%
                    }
                    %>
                </table>                
                <% } else { %>
                    <div style="font-size: 12px; font-weight: bold; padding: 7px; border-radius: 3px; background-color: #DDD;">No Employee available</div>
                    <div>&nbsp;</div>
                <% } %>
                <div>&nbsp;</div>
                <% if (value_search > 0) {
                    if (statusUser == 1 || appUserSess.getAdminStatus() == 1 || privViewAllDivision){
                
                %>
                <a class="btn" style="color:#FFF" href="javascript:cmdPrintHtml()">Print Selected (Format HTML)</a>
                <a class="btn" style="color:#FFF" href="javascript:cmdPrintAllHtml()">Print All  (Format HTML)</a>
                <a class="btn" style="color:#FFF" href="javascript:cmdPrintText()">Print Selected(Format Text)</a>
                <a class="btn" style="color:#FFF" href="javascript:cmdPrintAllText()">Print All(Format Text)</a>
                
                <!--<a class="btn" style="color:#FFF" href="javascript:cmdPrintAllCsvPerDepart()">Export All Depart to Excel</a>
                <a class="btn" style="color:#FFF" href="javascript:cmdPrintAllCsvPerSection()">Export All Section to Excel</a>-->
                <div>&nbsp;</div>
                <!--<a class="btn" style="color:#FFF" href="javascript:cmdPrintAllCsvDifferent()">Export Different to Excel</a>-->
                <a class="btn" style="color:#FFF" href="javascript:cmdPrintAllCsv()">Export All to Excel</a>
                <a class="btn" style="color:#FFF" href="javascript:cmdPrintCsv()">Export selected to Excel</a>
                <a class="btn" style="color:#FFF" href="javascript:cmdEmailSelectedBinding()">Email Selected(Format Text)</a>
                <a class="btn" style="color:#FFF" href="javascript:cmdEmailAllBinding()">Email All (Format Text)</a>
                <!--<a class="btn" style="color:#FFF" href="javascript:cmdPrintSelectedBinding()">Print Selected(Format Text - Binding)</a>
                <a class="btn" style="color:#FFF" href="javascript:cmdPrintAllBinding()">Print All Format Text - Binding</a>
                <a class="btn" style="color:#FFF" href="javascript:cmdPrintSelectedVersi1()">Print Selected V.1</a>-->
                <div>&nbsp;</div>
                <!--<a class="btn" style="color:#FFF" href="javascript:cmdPrintAllVersi1()">Print All V.1</a>-->
                
                <a class="btn" style="color:#FFF" href="javascript:cmdEmailSelectedPdf()">Email Selected(PDF)</a>
                <a class="btn" style="color:#FFF" href="javascript:cmdEmailAllPdf()">Email All (PDF)</a>
                <% } %>
                <a class="btn" style="color:#FFF" href="javascript:cmdPrintSelectedPdf()">Print Selected(PDF)</a>
                <a class="btn" style="color:#FFF" href="javascript:cmdPrintAllPdf()">Print All (PDF)</a>
                <div>&nbsp;</div>
                
                <% } %>
                <div>&nbsp;</div>
                <div>
                    <table>
                        <td><img src="<%=approot%>/images/attention-icon.png" width="16" height="16"></td>
                        <td><span class="fielderror" style="font-size: 12px; font-weight: bold;">Attention, please set up printer in page set up with:</span></td> 
                    </table>
                    <ul style="font-size: 11px;">
                        <li>paper size setting with size letter</li>
                        <li>orientation paper setting with portait</li>
                        <li>margin setting top: with 0.75, and etc set to zero(0)</li>
                        <li>header and footer setting with none</li>
                    </ul>
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
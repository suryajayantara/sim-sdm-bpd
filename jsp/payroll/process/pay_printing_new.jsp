<%-- 
    Document   : pay_printing_new
    Created on : Aug 5, 2016, 4:09:47 PM
    Author     : Dimata 007
--%>

<%@page import="com.dimata.harisma.entity.payroll.PaySlipGroup"%>
<%@page import="com.dimata.harisma.entity.payroll.PstPaySlipGroup"%>
<%@page import="com.dimata.gui.jsp.ControlCombo"%>
<%@page import="com.dimata.harisma.entity.payroll.PayPeriod"%>
<%@page import="com.dimata.harisma.entity.payroll.PstPayPeriod"%>
<%@page import="com.dimata.printman.PrinterDriverLoader"%>
<%@page import="com.dimata.printman.PrnConfig"%>
<%@page import="com.dimata.printman.RemotePrintMan"%>
<%@page import="com.dimata.harisma.printout.PrintPaySlip"%>
<%@page import="com.dimata.harisma.entity.payroll.PstSalaryLevelDetail"%>
<%@page import="com.dimata.printman.DSJ_PrintObj"%>
<%@page import="com.dimata.printman.DSJ_PrinterService"%>
<%@page import="com.dimata.printman.PrinterHost"%>
<%@page import="com.dimata.harisma.entity.payroll.PaySlip"%>
<%@page import="com.dimata.harisma.entity.payroll.PayEmpLevel"%>
<%@page import="com.dimata.gui.jsp.ControlList"%>
<%@page import="com.dimata.harisma.session.employee.SessEmployee"%>
<%@page import="com.dimata.harisma.entity.payroll.PaySlipComp"%>
<%@page import="com.dimata.harisma.form.payroll.FrmPaySlipComp"%>
<%@page import="com.dimata.gui.jsp.ControlLine"%>
<%@page import="com.dimata.harisma.printout.PayPrintText"%>
<%@page import="com.dimata.harisma.form.payroll.CtrlPaySlipComp"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file = "../../main/javainit.jsp" %>
<% int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_PAYROLL, AppObjInfo.G2_PAYROLL_PROCESS, AppObjInfo.OBJ_PAYROLL_PROCESS_PRINT);%>
<%@ include file = "../../main/checkuser.jsp" %>
<!DOCTYPE html>
<%
    /* Check Administrator */
    long empCompanyId = 0;
    long empDivisionId = 0;
    if (appUserSess.getAdminStatus()==0){
        empCompanyId = emplx.getCompanyId();
        empDivisionId = emplx.getDivisionId();
    }
    
    String strUrl = "";
    strUrl  = "'"+empCompanyId+"',";
    strUrl += "'"+empDivisionId+"',";
    strUrl += "'0',";
    strUrl += "'0',";
    strUrl += "'oidCompany',";
    strUrl += "'division',";
    strUrl += "'department',";
    strUrl += "'section'";
%>
<%
    CtrlPaySlipComp ctrlPaySlipComp = new CtrlPaySlipComp(request);
    int prevCommand = FRMQueryString.requestInt(request, "prev_command");
    int iCommand = FRMQueryString.requestCommand(request);
    int start = FRMQueryString.requestInt(request, "start");
    int inclResign = FRMQueryString.requestInt(request, "INCLUDE_RESIGN");
    boolean bIncResign = (inclResign == 1 ? true : false);

    long oidCompany = FRMQueryString.requestLong(request, "oidCompany");
    long oidDivision = FRMQueryString.requestLong(request, "division");
    long oidDepartment = FRMQueryString.requestLong(request, "department");
    long oidSection = FRMQueryString.requestLong(request, "section");
    long oidPaySlipComp = FRMQueryString.requestLong(request, "section");
    String searchNrFrom = FRMQueryString.requestString(request, "searchNrFrom");
    String searchNrTo = FRMQueryString.requestString(request, "searchNrTo");
    String searchName = FRMQueryString.requestString(request, "searchName");
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


%>
<%
    System.out.println("iCommand::::" + iCommand);
    int iErrCode = FRMMessage.ERR_NONE;
    String msgString = "";
    String msgStr = "";
    int recordToGet = 1000;
    int vectSize = 0;
    String orderClause = "";
    String whereClause = "";
    ControlLine ctrLine = new ControlLine();

// action on object agama defend on command entered
    iErrCode = ctrlPaySlipComp.action(iCommand, oidPaySlipComp);
    FrmPaySlipComp frmPaySlipComp = ctrlPaySlipComp.getForm();
    PaySlipComp paySlipComp = ctrlPaySlipComp.getPaySlipComp();
    msgString = ctrlPaySlipComp.getMessage();

    /*if(iCommand == Command.SAVE && prevCommand == Command.ADD)
     {
     start = PstPaySlip.findLimitStart(oidEmployee,recordToGet, whereClause,orderClause);
     vectSize = PstEmployee.getCount(whereClause);
     }
     else
     {
     vectSize = sessEmployee.countEmployee(srcEmployee);
     }
     if((iCommand==Command.FIRST)||(iCommand==Command.NEXT)||(iCommand==Command.PREV)||
     (iCommand==Command.LAST)||(iCommand==Command.LIST))
     start = ctrlPaySlip.actionList(iCommand, start, vectSize, recordToGet);*/
%>
<%


//get the kode component name by componentId
/*PayComponent payComponent = new PayComponent();
     String codeComponenGeneral ="";
     try{
     payComponent = PstPayComponent.fetchExc(componentId);
     codeComponenGeneral = payComponent.getCompCode();
     }
     catch(Exception e){
     }*/


    Vector listEmpPaySlip = new Vector(1, 1);
    if (iCommand == Command.LIST || iCommand == Command.EDIT || iCommand == Command.SAVE || iCommand == Command.ADD || iCommand == Command.PRINT) {
        listEmpPaySlip = SessEmployee.listEmpPaySlip(oidDepartment, oidDivision, oidSection, searchNrFrom, searchNrTo, searchName, periodeId, -1, bIncResign, oidPayrollGroupId);
        /*if(listEmpPaySlip.size()==0){
         //listEmpPaySlip = SessEmployee.listEmpPaySlip(oidDepartment,oidDivision,oidSection,searchNrFrom,searchNrTo,searchName,0);			
         }*/
    }

%>

<!-- JSP Block -->
<%!    public String drawList(int iCommand, FrmPaySlipComp frmObject, PaySlipComp objEntity, Vector objectClass, long idPaySlipComp, String codeComponent, String componentName) {
        String result = "";
        Vector token = new Vector(1, 1);
        ControlList ctrlist = new ControlList();
        ctrlist.setAreaWidth("100%");
        ctrlist.setListStyle("tblStyle");
        ctrlist.setTitleStyle("title_tbl");
        ctrlist.setCellStyle("listgensell");
        ctrlist.setHeaderStyle("title_tbl");
        ctrlist.setCellSpacing("0");
        ctrlist.addHeader("No");
        ctrlist.addHeader("");
        ctrlist.addHeader("NRK");
        ctrlist.addHeader("Nama");
        ctrlist.addHeader("Department");
        ctrlist.addHeader("Section");
        ctrlist.addHeader("Position");
        ctrlist.addHeader("Commencing Date");
        //ctrlist.addHeader("Salary Level");
        ctrlist.addHeader("Start Date");
        String checked = "";
        ctrlist.setLinkRow(0);
        ctrlist.setLinkSufix("");
        Vector lstData = ctrlist.getData();
        Vector lstLinkData = ctrlist.getLinkData();
        ctrlist.setLinkPrefix("javascript:cmdEdit('");
        ctrlist.setLinkSufix("')");
        ctrlist.reset();
        Vector rowx = new Vector(1, 1);
        int index = -1;
        String frmCurrency = "#,###";
            
        if (objectClass != null && objectClass.size() > 0) {
            for (int i = 0; i < objectClass.size(); i++) {
                int total = 0;
                Vector temp = (Vector) objectClass.get(i);
                Employee employee = (Employee) temp.get(0);
                PayEmpLevel payEmpLevel = (PayEmpLevel) temp.get(1);
                PaySlip paySlip = (PaySlip) temp.get(2);
                rowx = new Vector();
                rowx.add(String.valueOf(1 + i));
                rowx.add("<input type=\"checkbox\" name=\"print" + i + "\" value=\"" + employee.getOID() + "\" class=\"formElemen\" size=\"10\"><input type=\"hidden\" name=\"employeeId\" value=\"" + employee.getOID() + "\" class=\"formElemen\" size=\"10\">");
                rowx.add("<input type=\"hidden\" name=\"paySlipId\" value=\"" + paySlip.getOID() + "\" class=\"formElemen\" size=\"10\">" + employee.getEmployeeNum());
                rowx.add("<a href=\"javascript:openTaxCalc('" + paySlip.getOID() + "')\">" + employee.getFullName() + "</a>"); // update by Kartika : 2015-03-24
                    
                    
                //Department, Section, and Position
                Department depart = new Department(); // Add by Hendra Putu | 2015-05-19
                String strDepart = "";
                Section sec = new Section(); // Add by Hendra Putu | 2015-05-19
                String strSec = "";
                Position pos = new Position();
                String position = "";
                try {
                    depart = PstDepartment.fetchExc(employee.getDepartmentId());
                    sec = PstSection.fetchExc(employee.getSectionId());
                    pos = PstPosition.fetchExc(employee.getPositionId());
                    strDepart = depart.getDepartment();
                    strSec = sec.getSection();
                    position = pos.getPosition();
                } catch (Exception e) {
                    System.out.println("Exception" + e);
                }
                rowx.add("" + strDepart);
                rowx.add("" + strSec);
                rowx.add("" + position);
                rowx.add("" + Formater.formatDate(employee.getCommencingDate(), "dd-MMM-yyyy"));
                //rowx.add("<input type=\"hidden\" name=\"level_code\" value=\"" + payEmpLevel.getLevelCode() + "\" class=\"formElemen\" size=\"10\">" + payEmpLevel.getLevelCode());
                rowx.add("" + payEmpLevel.getStartDate());
                lstData.add(rowx);
            }
            result = ctrlist.drawList();
        } else {
            result = "<i>Belum ada data dalam sistem ...</i>";
        }
        return result;
    }
%>
<%
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
            if (DSJ_PrinterService.getPrinterDrv(0) == null) { // check if the first printer exist
                DSJ_PrinterService prnsvc = DSJ_PrinterService.getInstance();
                if (!prnsvc.running) {
                    prnsvc.running = true;
                    Thread thr = new Thread(prnsvc);
                    thr.setDaemon(false);
                    thr.start();
                }
            }
        }
    } catch (Exception exc) {
        System.out.println("HostLst:  " + exc);
    }
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
            if (employee_id != null && paySlip_id != null && level_code != null) {
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
            if ((hostIpIdx != null) && (hostLst != null) && (hostLst.size() > 0)) {
                System.out.println("PrintPaySlip.rowxz  " + listDfGjPrintBenefit.size());
                obj = PrintPaySlip.PrintForm(employee_id, periodeId, list, listEmpPaySlip, keyPeriod, payGroupId);
                PrinterHost prnHost = RemotePrintMan.getPrinterHost(hostIpIdx, ";");
                PrnConfig prn = RemotePrintMan.getPrinterConfig(hostIpIdx, ";");
                obj.setPrnIndex(prn.getPrnIndex());
                RemotePrintMan.printObj(prnHost, obj);
            } else {
                obj = PrintPaySlip.PrintForm(employee_id, periodeId, list, listEmpPaySlip, keyPeriod, payGroupId);
                try {
                    obj.setPrnIndex(Integer.parseInt(hostIpIdx));
                } catch (Exception exc) {
                    System.out.println(exc);
                };
                if (obj != null && (!DSJ_PrinterService.existPrnDriverLoader(obj.getPrnIndex()) || !DSJ_PrinterService.running)) {
                    DSJ_PrinterService prnSvc = DSJ_PrinterService.getInstance();
                    if (obj != null) {
                        PrinterDriverLoader prndLoader = new PrinterDriverLoader(obj);
                        prnSvc.addPrnDriverLoader(prndLoader);
                        Thread thr = new Thread(prnSvc);
                        thr.setDaemon(false);
                        thr.start();
                    }
                }
                if (obj != null && DSJ_PrinterService.existPrnDriverLoader(obj.getPrnIndex())) {
                    DSJ_PrinterService.print(obj);
                } else {
                    if (!DSJ_PrinterService.existPrnDriverLoader(obj.getPrnIndex())) {
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
            Vector listEmpId = new Vector();
            for (int i = 0; i < listEmpPaySlip.size(); i++) {
                listDfGjPrintBenefit = new Vector();
                try {
                    oidEmployee = FRMQueryString.requestLong(request, "print" + i + ""); // row yang dicheked
                    s_employee_id = String.valueOf(employee_id[i]);
                    s_payslip_id = String.valueOf(paySlip_id[i]);
                    s_level_code = String.valueOf(level_code[i]);
                } catch (Exception e) {
                    System.out.println("Exception" + e);
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
            if (listEmpId != null && listEmpId.size() > 0) {
                listEmpPaySlip = SessEmployee.listEmpPaySlipByEmployeeId(listEmpId, periodeId, -1, bIncResign);
            }
            if ((hostIpIdx != null) && (hostLst != null) && (hostLst.size() > 0)) {
                System.out.println("PrintPaySlip.rowxz  " + listDfGjPrintBenefit.size());
                obj = PrintPaySlip.PrintForm(employee_id, periodeId, list, listEmp, keyPeriod, payGroupId);
                PrinterHost prnHost = RemotePrintMan.getPrinterHost(hostIpIdx, ";");
                PrnConfig prn = RemotePrintMan.getPrinterConfig(hostIpIdx, ";");
                obj.setPrnIndex(prn.getPrnIndex());
                RemotePrintMan.printObj(prnHost, obj);
            } else {
                obj = PrintPaySlip.PrintForm(employee_id, periodeId, list, listEmp, keyPeriod, payGroupId);
                try {
                    obj.setPrnIndex(Integer.parseInt(hostIpIdx));
                } catch (Exception exc) {
                    System.out.println(exc);
                };
                if (obj != null && (!DSJ_PrinterService.existPrnDriverLoader(obj.getPrnIndex()) || !DSJ_PrinterService.running)) {
                    DSJ_PrinterService prnSvc = DSJ_PrinterService.getInstance();
                    if (obj != null) {
                        PrinterDriverLoader prndLoader = new PrinterDriverLoader(obj);
                        prnSvc.addPrnDriverLoader(prndLoader);
                        Thread thr = new Thread(prnSvc);
                        thr.setDaemon(false);
                        thr.start();
                    }
                }
                if (obj != null && DSJ_PrinterService.existPrnDriverLoader(obj.getPrnIndex())) {
                    DSJ_PrinterService.print(obj);
                } else {
                    if (!DSJ_PrinterService.existPrnDriverLoader(obj.getPrnIndex())) {
                        msgString = "No local printer found";
                    }
                }
            }
        }
    }
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Cetak Slip Gaji</title>
        <link rel="stylesheet" href="../../styles/main.css" type="text/css">
        <style type="text/css">
            .tblStyle {border-collapse: collapse; font-size: 12px; }
            .tblStyle td {padding: 5px 7px; border: 1px solid #CCC; font-size: 12px; }
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
                padding: 9px 11px;
                margin: 5px 11px 5px 0px;
                background-color: #F5F5F5;
                border:1px solid #DDD;
                border-radius: 4px;
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
            .box-info-debit {
                padding:12px;
                background-color: #C0ECFA; 
                color: #38839C;
                margin: 5px 0px;
                margin-top: 0px;
                text-align: center;
                font-size: 16px;
                border-radius: 5px;
                cursor: pointer;
            }
            .box-info-debit:hover {
                color:#FFF;
                background-color: #85C3D6;
            }
            .box-info-credit {
                padding:12px;
                background-color: #E2FAC5; 
                color: #5A8C1D;
                margin: 5px 0px;
                margin-top: 0px;
                text-align: center;
                font-size: 16px;
                border-radius: 5px;
                cursor: pointer;
            }
            .box-info-credit:hover {
                color:#FFF;
                background-color: #B0CF53;
            }
            #box-item {
                font-weight: bold;
                margin: 3px 0px;
                padding: 5px 9px;
                color: #575757;
                background-color: #EEE;
                border:1px solid #DDD;
                border-right: none;
            }
            #box-times {
                font-weight: bold;
                margin: 3px 0px;
                padding: 5px 9px;
                color: #B09595;
                background-color: #EEE;
                border:1px solid #DDD;
                cursor: pointer;
            }
            #box-times:hover {
                font-weight: bold;
                margin: 3px 0px;
                padding: 5px 9px;
                color: #B09595;
                background-color: #FFD9D9;
                border:1px solid #D9B8B8;
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
            #debit_value {
                font-size: 12px;
                color: #38839C;
                background-color: #C0ECFA;
                font-weight: bold;
                border-radius: 3px;
                padding: 9px;
            }
            #credit_value {
                font-size: 12px;
                background-color: #E2FAC5; 
                color: #5A8C1D;
                font-weight: bold;
                border-radius: 3px;
                padding: 9px;
            }
            .mydate {
                font-weight: bold;
                color: #474747;
            }
            
            #level_select {
                margin-bottom: 5px;
                padding-bottom: 5px;
                visibility: hidden;
            }
            
            #category_select {
                margin-bottom: 5px;
                padding-bottom: 5px;
                visibility: hidden;
            }
            
            #position_select {
                margin-bottom: 5px;
                padding-bottom: 5px;
                visibility: hidden;
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
            .form-style {
                font-size: 12px;
                color: #575757;
                border: 1px solid #DDD;
                border-radius: 5px;
            }
            .form-title {
                color:#474747;
                padding: 11px 21px;
                text-align: left;
                background-color: #CCC;
                border-top-left-radius: 5px;
                border-top-right-radius: 5px;
                font-weight: bold;
            }
            .form-content {
                text-align: left;
                padding: 21px;
                background-color: #EEE;
            }
            .form-footer {
                padding: 21px;
                background-color: #CCC;
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
            h2 {
                padding: 7px 0px 21px 0px;
                margin: 0px 0px 21px 0px;
                border-bottom: 1px solid #DDD;
            }
            .delete {
                background-color: #FAD7DB;
                border-radius: 3px;
                color: #BA5B66;
                font-weight: bold;
                padding: 11px;
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
                document.frm_printing.action="pay_printing_new.jsp";        
                document.frm_printing.submit();
            }

            function cmdUpdateDept(){
                document.frm_printing.target="";    
                document.frm_printing.command.value="<%=String.valueOf(Command.GOTO)%>";
                document.frm_printing.action="pay_printing_new.jsp";        
                document.frm_printing.submit();
            }

            function cmdUpdateSec(){
                document.frm_printing.target="";    
                document.frm_printing.command.value="<%=String.valueOf(Command.GOTO)%>";
                document.frm_printing.action="pay_printing_new.jsp";        
                document.frm_printing.submit();
            }

            function cmdSearch(){
                document.frm_printing.target="";
                document.frm_printing.command.value="<%=Command.LIST%>";
                document.frm_printing.value_search.value="1";
                document.frm_printing.action="pay_printing_new.jsp";
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
                document.frm_printing.action="pay_printing_new.jsp";
                document.frm_printing.target = "";
                document.frm_printing.submit();
            }
        
            function cmdPrintAll(){
                document.frm_printing.target="";
                document.frm_printing.toEmail.value="0";
                document.frm_printing.command.value="<%=Command.PRINT%>";
                document.frm_printing.aksiCommand.value="0";
                document.frm_printing.action="pay_printing_new.jsp";
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
                document.frm_printing.target="";
                document.frm_printing.command.value="<%=Command.PRINT%>";
                document.frm_printing.aksiCommand.value="1";
                document.frm_printing.toEmail.value="1";
                document.frm_printing.action="<%=approot%>/servlet/PayPrint.pdf";
                document.frm_printing.target = "";
                document.frm_printing.submit();
            }
 
            function cmdPrintSelectedPdf(){
                document.frm_printing.target="";
                document.frm_printing.command.value="<%=Command.PRINT%>";
                document.frm_printing.aksiCommand.value="1";
                document.frm_printing.toEmail.value="0";
                document.frm_printing.action="<%=approot%>/servlet/PayPrint.pdf";
                document.frm_printing.target = "";
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
                document.frm_printing.target="";
                document.frm_printing.command.value="<%=Command.PRINT%>";
                document.frm_printing.toEmail.value="1";
                document.frm_printing.aksiCommand.value="0";
                document.frm_printing.target="printpayroll";
                document.frm_printing.action="<%=approot%>/servlet/PayPrint.pdf";
                document.frm_printing.submit();
            }
        
            function cmdPrintAllPdf(){
                document.frm_printing.target="";
                document.frm_printing.command.value="<%=Command.PRINT%>";
                document.frm_printing.toEmail.value="0";
                document.frm_printing.aksiCommand.value="0";
                document.frm_printing.target="printpayroll";
                document.frm_printing.action="<%=approot%>/servlet/PayPrint.pdf";
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
        loadCompany(<%=strUrl%>);
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
                                %> <%=ControlCombo.draw("periodId", null, "" + periodeId, periodValue, periodKey, "")%> 
                            </div>
                            <div id="div_result"></div>
                        </td>
                        <td valign="top" width="50%">
                            <div class="caption">
                                Employee Number (NRK)
                            </div>
                            <div class="divinput">
                                <input type="text" name="searchNrFrom" size="12" value="<%=searchNrFrom%>"><span style="font-size: 12px"> To </span><input type="text" name="searchNrTo" size="12" value="<%=searchNrTo%>">
                            </div>
                            <div class="caption">
                                Nama
                            </div>
                            <div class="divinput">
                                <input type="text" name="searchName" size="70" value="<%=searchName%>">
                            </div>
                            <div class="caption">
                                Payroll Group
                            </div>
                            <div class="divinput">
                                <%
                                    Vector payrollGroup_value = new Vector(1, 1);
                                    Vector payrollGroup_key = new Vector(1, 1);
                                    Vector listPayrollGroup = PstPayrollGroup.list(0, 0, "", "PAYROLL_GROUP_NAME");
                                    payrollGroup_value.add("" + 0);
                                    payrollGroup_key.add("select");
                                    for (int i = 0; i < listPayrollGroup.size(); i++) {
                                        PayrollGroup payrollGroup = (PayrollGroup) listPayrollGroup.get(i);
                                        payrollGroup_key.add(payrollGroup.getPayrollGroupName());
                                        payrollGroup_value.add(String.valueOf(payrollGroup.getOID()));
                                    }

                                %>
                                <%=ControlCombo.draw("payrollGroupId", null, "" + oidPayrollGroupId, payrollGroup_value, payrollGroup_key, "")%>
                            </div>
                            <input type="checkbox" name="INCLUDE_RESIGN" value="1" /> <span style="font-size: 12px">Termasuk Karyawan Resign</span>
                            <div>&nbsp;</div>
                            <a class="btn" style="color:#FFF" href="javascript:cmdSearch()">Cari Slip</a>
                        </td>
                    </tr>
                </table>
                <div style="border-bottom: 1px solid #DDD"></div>
                <div>&nbsp;</div>
                <%
                    if ((listEmpPaySlip != null) && (listEmpPaySlip.size() > 0)) {
                %>
                <table>
                    <tr>
                        <td>
                            <div class="caption">
                                Pay Slip Monthly
                            </div>
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
                                        "" + ((keyPeriodStr == null || keyPeriodStr.length() < 1) ? PstSalaryLevelDetail.PERIODE_MONTHLY : keyPeriod), perKey, perValue));
                            %>
                        </td>
                        <td>
                            <div class="caption">
                                Pay Slip Group
                            </div>
                        </td>
                        <td>
                            <%
                                //update by satrya 2013-01-24
                                //Pay Group SLip
                                    
                                Vector grkKey = new Vector();
                                Vector grValue = new Vector();
                                Vector listPaySlipGroup = PstPaySlipGroup.listAll();
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
                            <div class="caption">
                                Select Printer
                            </div>
                        </td>
                        <td>
                            <select  name="printeridx">
                                <%
                                    Vector prnLst = null;
                                    PrinterHost host = null;
                                    if ((hostLst != null) && (hostLst.size() > 0)) {
                                        for (int h = 0; h < hostLst.size(); h++) {
                                            try {
                                                host = (PrinterHost) hostLst.get(h);
                                                if (host != null) {
                                                    prnLst = host.getListOfPrinters(false);
                                                }//getPrinterListWithStatus(host);
                                                if (prnLst != null) {
                                                    for (int i = 0; i < prnLst.size(); i++) {
                                                        try {
                                                            PrnConfig prnConf = (PrnConfig) prnLst.get(i);
                                                            out.print(" <option value='" + host.getHostIP() + ";" + prnConf.getPrnIndex() + "'> ");
                                                            out.println(host.getHostName() + " / " + prnConf.getPrnIndex() + " " + prnConf.getPrnName() + " " + prnConf.getPrnPort());
                                                            out.print(" </option>");
                                                        } catch (Exception exc) {
                                                            out.println("ERROR " + exc);
                                                        }
                                                    }
                                                }
                                            } catch (Exception exc1) {
                                                out.println("ERROR" + exc1);
                                            }
                                        }
                                    } else {
                                        out.print(" <option value='1'> ");
                                        out.println(" Local Printer ");
                                        out.print(" </option>");
                                    }
                                                                                                            
                                %>
                            </select> <%=msgString%>
                        </td>
                    </tr>
                </table>
                <%
                    }
                %>
                <div>&nbsp;</div>
                <%
                    if ((listEmpPaySlip != null) && (listEmpPaySlip.size() > 0)) {
                %>               
                    <div><%=drawList(iCommand, frmPaySlipComp, paySlipComp, listEmpPaySlip, oidPaySlipComp, codeComponenGeneral, compName)%></div>                
                <% } else { %>
                <div style="font-size: 12px; font-weight: bold; padding: 5px; background-color: #DDD;">No Employee available</div>
                    <div>&nbsp;</div>
                <% } %>
                <div>&nbsp;</div>
                <% if (value_search > 0) {%>
                <a class="btn" style="color:#FFF" href="javascript:cmdPrintHtml()">Print Selected (Format HTML)</a>
                <a class="btn" style="color:#FFF" href="javascript:cmdPrintAllHtml()">Print All  (Format HTML)</a>
                <a class="btn" style="color:#FFF" href="javascript:cmdPrintAllText()">Print All(Format Text)</a>
                <a class="btn" style="color:#FFF" href="javascript:cmdPrintAllCsv()">Export All to Excel</a>
                <a class="btn" style="color:#FFF" href="javascript:cmdPrintAllCsvPerDepart()">Export All Depart to Excel</a>
                <a class="btn" style="color:#FFF" href="javascript:cmdPrintAllCsvPerSection()">Export All Section to Excel</a>
                <div>&nbsp;</div>
                <a class="btn" style="color:#FFF" href="javascript:cmdPrintAllCsvDifferent()">Export Different to Excel</a>
                <a class="btn" style="color:#FFF" href="javascript:cmdPrintText()">Print Selected(Format Text)</a>
                <a class="btn" style="color:#FFF" href="javascript:cmdPrintCsv()">Export selected to Excel</a>
                <a class="btn" style="color:#FFF" href="javascript:cmdPrintSelectedBinding()">Print Selected(Format Text - Binding)</a>
                <a class="btn" style="color:#FFF" href="javascript:cmdPrintAllBinding()">Print All Format Text - Binding</a>
                <a class="btn" style="color:#FFF" href="javascript:cmdPrintSelectedVersi1()">Print Selected V.1</a>
                <div>&nbsp;</div>
                <a class="btn" style="color:#FFF" href="javascript:cmdPrintAllVersi1()">Print All V.1</a>
                <a class="btn" style="color:#FFF" href="javascript:cmdEmailSelectedBinding()">Email Selected(Format Text)</a>
                <a class="btn" style="color:#FFF" href="javascript:cmdEmailAllBinding()">Email All (Format Text)</a>
                <a class="btn" style="color:#FFF" href="javascript:cmdEmailSelectedPdf()">Email Selected(PDF)</a>
                <a class="btn" style="color:#FFF" href="javascript:cmdEmailAllPdf()">Email All (PDF)</a>
                <a class="btn" style="color:#FFF" href="javascript:cmdPrintSelectedPdf()">Print Selected(PDF)</a>
                <div>&nbsp;</div>
                <a class="btn" style="color:#FFF" href="javascript:cmdPrintAllPdf()">Print All (PDF)</a>
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

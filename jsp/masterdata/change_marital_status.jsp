<%-- 
    Document   : change_marital_status
    Created on : 18-Aug-2016, 08:42:26
    Author     : Acer
--%>


<%@page import="com.dimata.harisma.form.employee.CtrlEmployee"%>
<%@page import="com.dimata.harisma.session.payroll.TaxCalculator"%>
<%@page import="com.dimata.harisma.report.SrcEsptA1"%>
<%@page import="com.dimata.harisma.session.payroll.Pajak"%>
<%@page import="com.dimata.harisma.session.payroll.SessESPT"%>
<%@page import="com.dimata.harisma.report.SrcEsptMonth"%>
<%@page import="com.dimata.harisma.entity.payroll.PayComponenttemp"%>
<%@page import="com.dimata.harisma.entity.payroll.PayEmpLevel"%>
<%@page import="com.dimata.harisma.entity.payroll.PayBanks"%>
<%@page import="com.dimata.harisma.entity.payroll.PstPayComponent"%>
<%@page import="com.dimata.harisma.entity.payroll.PayPeriod"%>
<%@page import="com.dimata.harisma.entity.payroll.PstPayPeriod"%>
<%@page import="com.dimata.harisma.report.payroll.ListBenefitDeduction"%>
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
<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_EMPLOYEE, AppObjInfo.G2_DATABANK, AppObjInfo.OBJ_DATABANK);
   // int appObjCodePresenceEdit = AppObjInfo.composeObjCode(AppObjInfo.G1_EMPLOYEE, AppObjInfo.G2_ATTENDANCE, AppObjInfo.OBJ_PRESENCE);
   //boolean privUpdatePresence = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodePresenceEdit, AppObjInfo.COMMAND_UPDATE));
%>
<%@ include file = "../main/checkuser.jsp" %>
<% 
    long hrdDepOid = Long.parseLong(String.valueOf(PstSystemProperty.getPropertyLongbyName(OID_HRD_DEPARTMENT)));
    boolean isHRDLogin = hrdDepOid == departmentOid ? true : false;
    long edpSectionOid = Long.parseLong(String.valueOf(PstSystemProperty.getPropertyLongbyName(OID_EDP_SECTION)));
    boolean isEdpLogin = edpSectionOid == sectionOfLoginUser.getOID() ? true : false;
    boolean isGeneralManager = positionType == PstPosition.LEVEL_GENERAL_MANAGER ? true : false;
%>
<%!
    public String getSectionLink(String sectionId){
        String str = "";
        try{
            Section section = PstSection.fetchExc(Long.valueOf(sectionId));
            str = section.getSection();
            return str;
        } catch(Exception e){
            System.out.println(e);
        }
        return str;
    }
    
    public String drawList(Vector objectClass) {

        ControlList ctrlist = new ControlList(); //membuat new class ControlList
        // membuat tampilan dengan controllist
        
        int x = objectClass.size();
        ctrlist.setAreaWidth("100%");
        ctrlist.setListStyle("tblStyle");
        ctrlist.setTitleStyle("title_tbl");
        ctrlist.setCellStyle("listgensell");
        ctrlist.setHeaderStyle("title_tbl");
        ctrlist.setCellSpacing("0");
         ctrlist.addHeader("No.", "");
         ctrlist.addHeader("NRK", "");
         ctrlist.addHeader("Nama", "");
         ctrlist.addHeader("Satuan Kerja", "");
         ctrlist.addHeader("Status Perkawinan", "");
         ctrlist.addHeader("Status Perkawinan Untuk Pajak", "");
        ctrlist.addHeader("<a href=\"Javascript:SetAllCheckBoxesX('frmmarital','marital_', true,'"+x+"')\">Select All</a> || <a href=\"Javascript:SetAllCheckBoxesX('frmmarital','marital_', false,'"+x+"')\">Deselect All</a>", "15%", "2", "0");
        
        
        ctrlist.setLinkRow(1); // untuk menge-sett link di kolom pertama atau dikolom yg lain

        Vector lstData = ctrlist.getData();

        ctrlist.reset(); //berfungsi untuk menginisialisasi list menjadi kosong

        int no = 0;
        for (int i = 0; i < objectClass.size(); i++) {
            // membuat object WarningReprimandAyat berdasarkan objectClass ke-i
            
            Employee emp = (Employee)objectClass.get(i);
            Marital marital = new Marital();
            Marital taxMarital = new Marital();
            Division division = new Division();
            try{
                marital = PstMarital.fetchExc(emp.getMaritalId());
                taxMarital = PstMarital.fetchExc(emp.getTaxMaritalId());
                division = PstDivision.fetchExc(emp.getDivisionId());
            } catch (Exception exc){

            }

            no = no + 1;
            try {
            // rowx will be created secara berkesinambungan base on i
            Vector rowx = new Vector();
            

            
            rowx.add("" + no); //1
            rowx.add("" + emp.getEmployeeNum()); 
            rowx.add("" + emp.getFullName());
            rowx.add("" + division.getDivision());
            rowx.add("" + marital.getMaritalStatus()); //1
            rowx.add("" + taxMarital.getMaritalStatus());
            long empId = emp.getOID();
            rowx.add("<input name=\"marital_chx\" id=\"marital_"+(i)+"\" type=\"checkbox\" value="+empId+" >");
            
            lstData.add(rowx);
                       } catch (Exception e) {
                       // rowx will be created secara berkesinambungan base on i
            
                       
                       }
        }

        return ctrlist.draw(); // mengembalikan data-data control list

    }
%>
<!DOCTYPE html>
<%  

    /* Update by Hendra Putu | 20150226 */
    CtrlEmployee ctrlEmployee = new CtrlEmployee(request);
    int iErrCode = FRMMessage.NONE;
    int iCommand = FRMQueryString.requestCommand(request);
    int nrk = FRMQueryString.requestInt(request, "nrk");
    String name = FRMQueryString.requestString(request, "name");
    int sex = FRMQueryString.requestInt(request, "sex");
    long companyId = FRMQueryString.requestLong(request, "company_id");
    long divisionId = FRMQueryString.requestLong(request, "division_id");
    long departmentId = FRMQueryString.requestLong(request, "department_id");
    long sectionId = FRMQueryString.requestLong(request, "inp_section_id");
    String[] maritalChx = FRMQueryString.requestStringValues(request, "marital_chx");
    long search = 0 ;
    try{ search = FRMQueryString.requestLong(request, "search");} catch (Exception e){}
    
    long empId = 0;
    //iErrCode = ctrlEmployee.action(iCommand , empId,request ,emplx.getFullName(), appUserIdSess);
    String strChx = "";
    if (iCommand == Command.SAVE){
            
            if(maritalChx != null){
                for (int i=0; i<maritalChx.length; i++){
                    strChx += "["+ maritalChx[i] +"]";
                    Employee employee = new Employee();
                    try {
                        employee = PstEmployee.fetchExc(Long.valueOf(maritalChx[i]));
                        PstEmployee.updateTax(employee.getMaritalId(), employee.getOID());
                    } catch(Exception e){
                        System.out.println(e.toString());
                    }
                }
            }
        }
    
    Vector listEmployee = new Vector();
    String whereStatus = PstEmployee.fieldNames[PstEmployee.FLD_MARITAL_ID] + " != " + PstEmployee.fieldNames[PstEmployee.FLD_TAX_MARITAL_ID];
    
    if (divisionId != 0){
        whereStatus += " AND " + PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID] + " = " + divisionId;
    } 
    if (departmentId != 0){
        whereStatus += " AND " + PstEmployee.fieldNames[PstEmployee.FLD_DEPARTMENT_ID] + " = " + departmentId;
    }
    if (sectionId != 0){
        whereStatus += " AND " + PstEmployee.fieldNames[PstEmployee.FLD_SECTION_ID] + " = " + sectionId;
    }
    if (sex == 0){
        whereStatus += " AND " + PstEmployee.fieldNames[PstEmployee.FLD_SEX] + " = 0"; 
    }
    String order = PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_NUM];
    if (iCommand == Command.LIST){
        listEmployee = PstEmployee.list(0,0,whereStatus,order);
    }
    
    if(iCommand == Command.ASSIGN){
        
    }
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Change Tax Marital Status Form</title>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
        <link rel="stylesheet" href="../styles/main.css" type="text/css">
        <link rel="stylesheet" href="../styles/tab.css" type="text/css">
        <link href="<%=approot%>/stylesheets/superTables.css" rel="Stylesheet" type="text/css" /> 
        <style type="text/css">
            #menu_utama {color: #0066CC; font-weight: bold; padding: 5px 14px; border-left: 1px solid #0066CC; font-size: 14px; background-color: #F7F7F7;}
            #mn_utama {color: #FF6600; padding: 5px 14px; border-left: 1px solid #999; font-size: 14px; background-color: #F5F5F5;}
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
            #tdForm {
                padding: 5px;
            }
            .tblStyle {border-collapse: collapse;font-size: 11px;}
            .tblStyle td {padding: 3px 5px; border: 1px solid #CCC;}
            .title_tbl {font-weight: bold;background-color: #DDD; color: #575757;}
        </style>
        <script type="text/javascript">
            function compChange(val) 
            {
                document.frm_change_marital.command.value = "<%=Command.GOTO%>";
                document.frm_change_marital.company_id.value = val;
                document.frm_change_marital.division_id.value = "0";
                document.frm_change_marital.department_id.value = "0";
                document.frm_change_marital.action = "change_marital_status.jsp";
                document.frm_change_marital.submit();
            }
            function divisiChange(val) 
            {
                document.frm_change_marital.command.value = "<%=Command.GOTO%>";
                document.frm_change_marital.division_id.value = val;
                document.frm_change_marital.action = "change_marital_status.jsp";
                document.frm_change_marital.submit();
            }
            function deptChange(val) 
            {
                document.frm_change_marital.command.value = "<%=Command.GOTO%>";	
                document.frm_change_marital.department_id.value = val;
                document.frm_change_marital.action = "change_marital_status.jsp";
                document.frm_change_marital.submit();
            }
            
            function cmdSearch(){ 
                document.frm_change_marital.command.value="<%=Command.LIST%>";
                document.frm_change_marital.action="change_marital_status.jsp";
                document.frm_change_marital.submit();
            }
            
             function cmdSearchAll(){ 
                document.frm_change_marital.command.value="<%=Command.LIST%>";
                document.frm_change_marital.action="change_marital_status.jsp?search=1";
                document.frm_change_marital.submit();
            }
                                                                                                                       
            function cmdExportExcel(){	 
                document.frm_change_marital.action="<%=approot%>/servlet/espta1.xls"; 
                document.frm_change_marital.target = "ReportExcelA1";
                document.frm_change_marital.submit();
            }
            
            function cmdExportExcelAll(){	
                document.frm_change_marital.search.value = "<%=1%>";
                document.frm_change_marital.action="<%=approot%>/servlet/espta1.xls"; 
                document.frm_change_marital.target = "ReportExcelA1";
                document.frm_change_marital.submit();
            }
            
            function cmdProcess(){
                document.frm_change_marital.command.value="<%=Command.SAVE%>";
                document.frm_change_marital.action="change_marital_status.jsp";
                document.frm_change_marital.submit();
            }  
            
            function SetAllCheckBoxesX(FormName, FieldName, CheckValue, nilai)
            {
                for(var i = 0; i < nilai; i++)
                document.getElementById("marital_"+i).checked = CheckValue;
            }
        </script>
    </head>
    <body <%=noBack%> bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
        <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%" bgcolor="#F9FCFF" >
            <%if (headerStyle && !verTemplate.equalsIgnoreCase("0")) {%> 
            <%@include file="../styletemplate/template_header.jsp" %>
            <%} else {%>
            <tr> 
                <td ID="TOPTITLE" background="<%=approot%>/images/HRIS_HeaderBg3.jpg" width="100%" height="54"> 
                    <!-- #BeginEditable "header" --> 
                    <%@ include file = "../main/header.jsp" %>
                    <!-- #EndEditable --> </td>
            </tr>
            <tr> 
                <td  bgcolor="#9BC1FF" height="15" ID="MAINMENU" valign="middle"> <!-- #BeginEditable "menumain" --> 
                    <%@ include file = "../main/mnmain.jsp" %>
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
            <tr> 
                <td width="88%" valign="top" align="left"> 
                    <table width="100%" border="0" cellspacing="3" cellpadding="2" id="tbl0">
                        <tr> 
                            <td width="100%" colspan="3" valign="top" style="padding: 12px"> 
                                <form name="frm_change_marital" method="POST" action="">
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    
                                    <tr> 
                                        <td height="20"> <div id="menu_utama"> <!-- #BeginEditable "contenttitle" -->Tax Report for A1-Form<!-- #EndEditable --> </div> </td>
                                    </tr>
                                    <tr>
                                        <td>&nbsp;</td>
                                    </tr>
                                    <tr>
                                        <td style="background-color:#EEE;" valign="top">
                                        
                                            <table style="padding:9px; border:1px solid #00CCFF;" <%=garisContent%> width="100%" border="0" cellspacing="1" cellpadding="1" class="tablecolor">
                                                <tr>
                                                    <td valign="top">
                                                        <div id="mn_utama">Search Data for A1-Form</div>
                                                        
                                                            <input type="hidden" name="command" value="<%=iCommand%>" />
                                                            <input type="hidden" name="search" value="<%=0%>" />
                                                            <table>
                                                                
                                                                <%
                                                                    /*
                                                                     * Description : get value Company, Division, Department, and Section
                                                                     * Date : 2015-02-17
                                                                     * Author : Hendra Putu
                                                                     */
                                                                    // List Company
                                                                    Vector comp_value = new Vector(1, 1);
                                                                    Vector comp_key = new Vector(1, 1);
                                                                    comp_value.add("0");
                                                                    comp_key.add("-select-");
                                                                    String comp_selected = "";
                                                                    // List Division
                                                                    Vector div_value = new Vector(1, 1);
                                                                    Vector div_key = new Vector(1, 1);
                                                                    String whereDivision = "COMPANY_ID = " + companyId;
                                                                    div_value.add("0");
                                                                    div_key.add("-select-");
                                                                    String div_selected = "";
                                                                    // List Department
                                                                    Vector depart_value = new Vector(1, 1);
                                                                    Vector depart_key = new Vector(1, 1);
                                                                    String whereComp = "" + companyId;
                                                                    String whereDiv = "" + divisionId;
                                                                    depart_value.add("0");
                                                                    depart_key.add("-select-");
                                                                    String depart_selected = "";
                                                                    // List Section
                                                                    Vector section_value = new Vector(1, 1);
                                                                    Vector section_key = new Vector(1, 1);
                                                                    Vector section_v = new Vector();
                                                                    Vector section_k = new Vector();
                                                                    String whereSection = "DEPARTMENT_ID = " + departmentId;
                                                                    section_value.add("0");
                                                                    section_key.add("-select-");
                                                                    section_v.add("0");
                                                                    section_k.add("-select-");
                                                                    /* List variabel if not isHRDLogin || isEdpLogin || isGeneralManager */
                                                                        
                                                                    String strComp = "";
                                                                    String strCompId = "0";
                                                                    String strDivisi = "";
                                                                    String strDivisiId = "0";
                                                                    String strDepart = "";
                                                                    String strDepartId = "0";
                                                                    String strSection = "";
                                                                    String strSectionId = "0";
                                                                    if (isHRDLogin || isEdpLogin || isGeneralManager) {
                                                                        
                                                                        Vector listComp = PstCompany.list(0, 0, "", " COMPANY ");
                                                                        for (int i = 0; i < listComp.size(); i++) {
                                                                            Company comp = (Company) listComp.get(i);
                                                                            if (comp.getOID() == companyId) {
                                                                                comp_selected = String.valueOf(companyId);
                                                                            }
                                                                            comp_key.add(comp.getCompany());
                                                                            comp_value.add(String.valueOf(comp.getOID()));
                                                                        }
                                                                            
                                                                        Vector listDiv = PstDivision.list(0, 0, whereDivision, " DIVISION ");
                                                                        if (listDiv != null && listDiv.size() > 0) {
                                                                            for (int i = 0; i < listDiv.size(); i++) {
                                                                                Division division = (Division) listDiv.get(i);
                                                                                if (division.getOID() == divisionId) {
                                                                                    div_selected = String.valueOf(divisionId);
                                                                                }
                                                                                div_key.add(division.getDivision());
                                                                                div_value.add(String.valueOf(division.getOID()));
                                                                            }
                                                                        }
                                                                            
                                                                        Vector listDepart = PstDepartment.listDepartmentVer1(0, 0, whereComp, whereDiv);
                                                                        if (listDepart != null && listDepart.size() > 0) {
                                                                            for (int i = 0; i < listDepart.size(); i++) {
                                                                                Department depart = (Department) listDepart.get(i);
                                                                                if (depart.getOID() == departmentId) {
                                                                                    depart_selected = String.valueOf(departmentId);
                                                                                }
                                                                                depart_key.add(depart.getDepartment());
                                                                                depart_value.add(String.valueOf(depart.getOID()));
                                                                            }
                                                                        }
                                                                            
                                                                        Vector listSection = PstSection.list(0, 0, whereSection, "");
                                                                        if (listSection != null && listSection.size() > 0) {
                                                                            for (int i = 0; i < listSection.size(); i++) {
                                                                                Section section = (Section) listSection.get(i);
                                                                                section_key.add(section.getSection());
                                                                                section_value.add(String.valueOf(section.getOID()));
                                                                                String sectionLink = section.getSectionLinkTo();
                                                                                if ((sectionLink != null) && sectionLink.length()>0) {
                                                                                    
                                                                                    for (String retval : sectionLink.split(",")) {
                                                                                        section_value.add(retval);
                                                                                        section_key.add(getSectionLink(retval));
                                                                                    }
                                                                                }
                                                                            }
                                                                        }
                                                                            
                                                                    } else {
                                                                        // for Company and Division
                                                                        if (emplx.getDivisionId() > 0) {
                                                                            Division empDiv = PstDivision.fetchExc(emplx.getDivisionId());
                                                                            Company empComp = PstCompany.fetchExc(empDiv.getCompanyId());
                                                                            strComp = empComp.getCompany();
                                                                            strCompId = String.valueOf(empComp.getOID());
                                                                            strDivisi = empDiv.getDivision();
                                                                            strDivisiId = String.valueOf(empDiv.getOID());
                                                                        }
                                                                        // for Department
                                                                        if (emplx.getDepartmentId() > 0) {
                                                                            Department empDepart = PstDepartment.fetchExc(emplx.getDepartmentId());
                                                                            strDepart = empDepart.getDepartment();
                                                                            strDepartId = String.valueOf(empDepart.getOID());
                                                                        }
                                                                        // for Section
                                                                        if (emplx.getSectionId() > 0) {
                                                                            Section empSection = PstSection.fetchExc(emplx.getSectionId());
                                                                            strSection = empSection.getSection();
                                                                            strSectionId = String.valueOf(empSection.getOID());
                                                                                
                                                                            section_v.add(String.valueOf(empSection.getOID()));
                                                                            section_k.add(empSection.getSection());
                                                                            String sectionLink = empSection.getSectionLinkTo();
                                                                            if ((sectionLink != null) && sectionLink.length()>0) {
                                                                                
                                                                                for (String retval : sectionLink.split(",")) {
                                                                                    section_v.add(retval);
                                                                                    section_k.add(getSectionLink(retval));
                                                                                }
                                                                            }
                                                                        }
                                                                    }
                                                                %>
                                                                <tr>
                                                                    <td valign="top" id="tdForm">Company</td>
                                                                    <td valign="top" id="tdForm">
                                                                        <%
                                                                            if (isHRDLogin || isEdpLogin || isGeneralManager) {
                                                                        %>
                                                                        <input type="hidden" name="company_id" value="<%=companyId%>" />
                                                                        <%= ControlCombo.draw("inp_company_id", "formElemen", null, comp_selected, comp_value, comp_key, " onChange=\"javascript:compChange(this.value)\"")%>
                                                                        <%
                                                                        } else {
                                                                        %>
                                                                        <input type="hidden" name="inp_company_id" value="<%=strCompId%>" />
                                                                        <input type="text" name="company_nm" disabled="disabled" value="<%=strComp%>" />
                                                                        <%
                                                                            }
                                                                        %>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td valign="top" id="tdForm"><%=dictionaryD.getWord(I_Dictionary.DIVISION) %></td>
                                                                    <td valign="top" id="tdForm">
                                                                        <%
                                                                            if (isHRDLogin || isEdpLogin || isGeneralManager) {
                                                                        %>
                                                                        <input type="hidden" name="division_id" value="<%=divisionId%>" />
                                                                        <%= ControlCombo.draw("inp_division_id", "formElemen", null, div_selected, div_value, div_key, " onChange=\"javascript:divisiChange(this.value)\"")%>
                                                                        <%
                                                                        } else {
                                                                        %>
                                                                        <input type="hidden" name="inp_division_id" value="<%=strDivisiId%>" />
                                                                        <input type="text" name="division_nm" disabled="disabled" value="<%=strDivisi%>" />
                                                                        <%
                                                                            }
                                                                        %>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td valign="top" id="tdForm"><%=dictionaryD.getWord(I_Dictionary.DEPARTMENT) %></td>
                                                                    <td valign="top" id="tdForm">
                                                                        <%
                                                                            if (isHRDLogin || isEdpLogin || isGeneralManager) {
                                                                        %>
                                                                        <input type="hidden" name="department_id" value="<%=departmentId%>" />	
                                                                        <%= ControlCombo.draw("inp_department_id", "formElemen", null, depart_selected, depart_value, depart_key, " onChange=\"javascript:deptChange(this.value)\"")%>
                                                                        <%
                                                                        } else {
                                                                        %>
                                                                        <input type="hidden" name="inp_department_id" value="<%=strDepartId%>" />
                                                                        <input type="text" name="department_nm" disabled="disabled" value="<%=strDepart%>" />
                                                                        <%
                                                                            }
                                                                        %>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td valign="top" id="tdForm"><%=dictionaryD.getWord(I_Dictionary.SECTION) %></td>
                                                                    <td valign="top" id="tdForm">
                                                                        <%
                                                                            if (isHRDLogin || isEdpLogin || isGeneralManager) {
                                                                        %> 
                                                                        <%= ControlCombo.draw("inp_section_id", "formElemen", null, "", section_value, section_key, "")%>  
                                                                        <%
                                                                        } else {
                                                                        %>
                                                                        <%= ControlCombo.draw("inp_section_id", "formElemen", null, "0", section_v, section_k, "")%> 
                                                                        <%
                                                                            }
                                                                        %>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td valign="top" id="tdForm">Include Female?</td>
                                                                    <td valign="top" id="tdForm">
                                                                    <input type="radio" checked="checked" id="sex" name="sex" value="0" />No
                                                                    <input type="radio" id="sex" name="sex" value="1" />Yes
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    
                                                                    <td><strong></strong></td>
                                                                </tr>
                                                                <tr>
                                                                    <td valign="top" id="tdForm" colspan="2">
                                                                        <button id="btn" onclick="javascript:cmdSearch()">Search</button>&nbsp;
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                       
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <%
                                                    if (listEmployee != null && listEmployee.size()>0){
                                                        int size = listEmployee.size();
                                                    %>
                                                    <td>
                                                        <div id="mn_utama">List Employee</div>
                                                        <%=drawList(listEmployee)%>
                                                    </td>
                                                    
                                                </tr>
                                                <tr>
                                                    <td valign="top" id="tdForm" colspan="2">
                                                        <button id="btn" onclick="javascript:cmdProcess()">Process</button>&nbsp;
                                                    </td>
                                                </tr>
                                                <%
                                                    }
                                                    %>
                                                <tr>
                                                    <td>&nbsp;</td>
                                                </tr>
                                            </table>
                                        
                                        </td>
                                    </tr>
                                </table><!---End Tble--->
                                </form>
                            </td>
                        </tr>
                    </table>
                                                 
                </td>
            </tr>
        </table>
                                                
        <table>
            <tr>
                <td>&nbsp;</td>
            </tr>
            <%if (headerStyle && !verTemplate.equalsIgnoreCase("0")) {%>
            <tr>
                <td valign="bottom">
                    <!-- untuk footer -->
                    <%@include file="../footer.jsp" %>
                </td>
                            
            </tr>
            <%} else {%>
            <tr> 
                <td colspan="2" height="20" > <!-- #BeginEditable "footer" --> 
                    <%@ include file = "../main/footer.jsp" %>
                    <!-- #EndEditable --> </td>
            </tr>
            <%}%>
        </table>
    </body>
    <!-- #BeginEditable "script" --> <script language="JavaScript">
                var oBody = document.body;
                var oSuccess = oBody.attachEvent('onkeydown',fnTrapKD);
    </script>
                
    <!-- #EndEditable --> <!-- #EndTemplate -->
</html>


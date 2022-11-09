<%-- 
    Document   : employee_birthday
    Created on : Feb 24, 2021, 1:25:35 PM
    Author     : gndiw
--%>

<%@page import="java.math.RoundingMode"%>
<%@page import="java.math.BigDecimal"%>
<%@page import="com.dimata.harisma.entity.attendance.LLStockManagement"%>
<%@page import="com.dimata.harisma.entity.attendance.PstLLStockManagement"%>
<%@page import="com.dimata.harisma.entity.attendance.AlStockManagement"%>
<%@page import="com.dimata.harisma.entity.attendance.PstAlStockManagement"%>
<%@page import="java.util.Hashtable"%>
<%@page import="com.dimata.gui.jsp.ControlCombo"%>
<%@page import="com.dimata.harisma.entity.masterdata.*"%>
<%@page import="com.dimata.harisma.entity.masterdata.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file = "../../main/javainit.jsp" %>
<% int  appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_MENU_REPORTS, AppObjInfo.G2_MENU_LEAVE_REPORT, AppObjInfo.OBJ_MENU_REKAP_CUTI); %>
<%@ include file = "../../main/checkuser.jsp" %>
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
    long oidDivision = 0;
    String strDisable = "";
    String strDisableNum = "";
    if (appUserSess.getAdminStatus()==0 && !privViewAllDivision){
        oidCompany = emplx.getCompanyId();
        oidDivision = emplx.getDivisionId();
        strDisable = "disabled=\"disabled\"";
    } if (namaUser1.equals("Employee")){
        strDisableNum = "disabled=\"disabled\"";
    }

//cek tipe browser, browser detection
    //String userAgent = request.getHeader("User-Agent");
    //boolean isMSIE = (userAgent!=null && userAgent.indexOf("MSIE") !=-1); 

%>
<%
    int iCommand = FRMQueryString.requestCommand(request);
    int iErrCode = FRMMessage.NONE;
    int start = FRMQueryString.requestInt(request, "start");
    String empNum = FRMQueryString.requestString(request, "emp_number");
    String empName = FRMQueryString.requestString(request, "full_name");
    long compId = FRMQueryString.requestLong(request, "company_id");
    String[] div = FRMQueryString.requestStringValues(request, "division_id");
    String[] dept = FRMQueryString.requestStringValues(request, "department");
    String[] sec = FRMQueryString.requestStringValues(request, "section");
    String bulan = FRMQueryString.requestString(request, "month");
    
    Vector<String> whereCollect = new Vector<String>();
    String whereClause = "";
    whereClause = PstEmployee.fieldNames[PstEmployee.FLD_RESIGNED]+" = 0";
    whereCollect.add(whereClause);
    if (!bulan.equals("")){
        whereClause = "DATE_FORMAT("+PstEmployee.fieldNames[PstEmployee.FLD_BIRTH_DATE]+ ",'%m') = '"+ bulan+"'";
        whereCollect.add(whereClause);
    }
    if (!empNum.equals("")){
        whereClause = PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_NUM]+ " = "+ empNum;
        whereCollect.add(whereClause);
    }
    if (!empName.equals("")){
        whereClause = PstEmployee.fieldNames[PstEmployee.FLD_FULL_NAME]+ " LIKE '%"+ empName+"%'";
        whereCollect.add(whereClause);
    }
    if (compId > 0){
        whereClause = PstEmployee.fieldNames[PstEmployee.FLD_COMPANY_ID]+ " = "+ compId;
        whereCollect.add(whereClause);
    }
    if (div != null){
        if (div.length>0){
            String inDivision = "";
            for (int i=0; i < div.length; i++){
                inDivision += "'"+div[i]+"' ," ;
            }
            inDivision = inDivision.substring(0, inDivision.length()-1);
            whereClause = PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID]+ " IN ("+ inDivision+")";
            whereCollect.add(whereClause);
        }
    }
    if (dept != null){
        if (dept.length>0  ){
            String inDept = "";
            for (int i=0; i < dept.length; i++){
                inDept += "'"+dept[i]+"' ," ;
            }
            inDept = inDept.substring(0, inDept.length()-1);
            whereClause = PstEmployee.fieldNames[PstEmployee.FLD_DEPARTMENT_ID]+ " IN ("+ inDept+")";
            whereCollect.add(whereClause);
        }
    }
    if (sec != null){
        if (sec.length>0 ){
            String inSec = "";
            for (int i=0; i < sec.length; i++){
                inSec += "'"+sec[i]+"' ," ;
            }
            inSec = inSec.substring(0, inSec.length()-1);
            whereClause = PstEmployee.fieldNames[PstEmployee.FLD_SECTION_ID]+ " IN ("+ inSec+")";
            whereCollect.add(whereClause);
        }
    }
    
    if (whereCollect != null && whereCollect.size()>0){
        whereClause = "";
        for (int i=0; i<whereCollect.size(); i++){
            String where = (String)whereCollect.get(i);
            whereClause += where;
            if (i < (whereCollect.size()-1)){
                 whereClause += " AND ";
            }
        }
    }
    
    Vector listEmployee = PstEmployee.list(0, 0, whereClause, "");
    
    
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Rekap Cuti</title>
        <link rel="stylesheet" href="../../styles/main.css" type="text/css">
         <%@ include file = "../../main/konfigurasi_jquery.jsp" %>    
        <script src="../../javascripts/jquery.min-1.6.2.js" type="text/javascript"></script>
        <script src="../../javascripts/chosen.jquery.js" type="text/javascript"></script>
        <link rel="stylesheet" href="../../stylesheets/chosen.css" >
        <link rel="stylesheet" href="../../stylesheets/custom.css" >
        <script language="JavaScript">
        function cmdSearch(){
                
                    document.frpresence.command.value="<%=String.valueOf(Command.LIST)%>";
                    document.frpresence.action="employee_birthday.jsp";
                    document.frpresence.submit();
        }    
        function cmdExport(){
                document.frpresence.command.value="<%=String.valueOf(Command.LIST)%>";
                document.frpresence.action="export_excel/excel_employee_birthday.jsp";
                document.frpresence.submit();
        }    
        
        function loadFilterBy(filter_by, oidDocMasterFlow) {
                var xmlhttp = new XMLHttpRequest();DEP
                xmlhttp.onreadystatechange = function() {
                    if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                        document.getElementById("div_respon").innerHTML = xmlhttp.responseText;
                    }
                };
                xmlhttp.open("GET", "company_structure.jsp?filter_by=" + filter_by+"&oid="+oidDocMasterFlow, true);
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
                    strUrl = "company_structure.jsp";

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
                    strUrl = "company_structure.jsp";

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
            <span id="menu_title"><strong>Laporan</strong> <strong style="color:#333;"> / </strong> <strong>Karyawan</strong> <strong style="color:#333;"> / </strong> Ulang Tahun </span>
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
                                    <input type="text" name="emp_number" id="emp_number" value="" />
                                </div>
                                <div id="caption">Perusahaan</div>
                                <div id="divinput">
                                    <%

                                        Vector com_value = new Vector(1, 1);
                                        Vector com_key = new Vector(1, 1);
                                        String placeHolderComp = "";
                                        String multipleComp = "";
                                        if (oidDivision == 0){
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
                                    <%= ControlCombo.draw("company_id", "chosen-select", null, "", com_value, com_key, multipleComp+" "+placeHolderComp+" style='width:100%'")%>
                                </div>
                                <div id="caption">Unit</div>
                                <div id="divinput">
                                    <%
                                        Vector dep_value = new Vector(1, 1);
                                        Vector dep_key = new Vector(1, 1);
                                        
                                        Vector listDep = new Vector();

                                        if (oidDivision == 0){
                                            listDep = PstDepartment.list(0, 0, "hr_department.VALID_STATUS=1", "");
                                        } else {
                                            listDep = PstDepartment.list(0, 0, "hr_department."+PstDepartment.fieldNames[PstDepartment.FLD_DIVISION_ID] + " = " + oidDivision + " AND hr_department.VALID_STATUS=1", "");
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

                                    <%= ControlCombo.draw("department", "chosen-select", null, "", dep_key, dep_value, null, "size=8 multiple data-placeholder='Select Unit...' style='width:100%'") %> 
                                </div>
                                <div id="caption">Bulan</div>
                                <div id="divinput">
                                    <%
                                        Vector blnValue = new Vector(1, 1);
                                        Vector blnKey = new Vector(1, 1);
                                        
                                        blnValue.add("01");blnKey.add("Januari");
                                        blnValue.add("02");blnKey.add("Februari");
                                        blnValue.add("03");blnKey.add("Maret");
                                        blnValue.add("04");blnKey.add("April");
                                        blnValue.add("05");blnKey.add("Mei");
                                        blnValue.add("06");blnKey.add("Juni");
                                        blnValue.add("07");blnKey.add("Juli");
                                        blnValue.add("08");blnKey.add("Agustsus");
                                        blnValue.add("09");blnKey.add("September");
                                        blnValue.add("10");blnKey.add("Oktober");
                                        blnValue.add("11");blnKey.add("November");
                                        blnValue.add("12");blnKey.add("Desember");
                                    %>

                                    <%= ControlCombo.draw("month", "chosen-select", null, ""+bulan, blnKey, blnValue, null, "size=4 data-placeholder='Select Bulan...' style='width:100%'") %> 
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
                                        if (oidDivision == 0){
                                            listDiv = PstDivision.list(0, 0, "VALID_STATUS=1", "");
                                            placeHolder = "data-placeholder='Select Satuan Kerja...'";
                                            multipleDiv = "multiple";
                                        } else {
                                            listDiv = PstDivision.list(0, 0, PstDivision.fieldNames[PstDivision.FLD_DIVISION_ID] + " = " + emplx.getDivisionId()  + " AND VALID_STATUS=1", PstDivision.fieldNames[PstDivision.FLD_DIVISION_ID]);
                                        }

                                        for (int i = 0; i < listDiv.size(); i++) {
                                            Division division = (Division) listDiv.get(i);
                                            div_key.add(division.getDivision());
                                            div_value.add(String.valueOf(division.getOID()));
                                        }
                                    %>
                                        <%= ControlCombo.draw("division_id", "chosen-select", null, "", div_key, div_value, null, multipleDiv+" "+placeHolder+" style='width:100%'") %> 
                                </div>
                                <div id="caption">Sub Unit</div>
                                <div id="divinput">
                                    <%

                                        Vector sec_value = new Vector(1, 1);
                                        Vector sec_key = new Vector(1, 1);
                                        

                                        Vector listSec = new Vector();

                                        if (oidDivision == 0){
                                            listSec = PstSection.list(0, 0, "VALID_STATUS=1", "DEPARTMENT_ID");
                                        } else {
                                            listSec = PstSection.list(0, 0, PstSection.fieldNames[PstSection.FLD_DEPARTMENT_ID] + " = " + emplx.getDepartmentId(), "DEPARTMENT_ID");
                                        }

                                        Hashtable hashDepart = PstDepartment.listMapDepName(0, 0, "", "", "");
                                        long tempDepOid = 0 ;
                                        for (int i = 0; i < listSec.size(); i++) {
                                            Section section = (Section) listSec.get(i);

                                            if (section.getDepartmentId() != tempDepOid){
                                                sec_key.add("--"+hashDepart.get(""+section.getDepartmentId())+"--");
                                                sec_value.add(String.valueOf(-1));
                                                tempDepOid = section.getDepartmentId();
                                            }

                                            sec_key.add(section.getSection());
                                            sec_value.add(String.valueOf(section.getOID()));
                                        }
                                    %>
                                     <%= ControlCombo.draw("section", "chosen-select", null, "", sec_key, sec_value, null, "multiple data-placeholder='Select Sub Unit...' style='width:100%'") %> 
                                </div>    
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div>
                                    <a href="javascript:cmdSearch()" class="btn" style="color:#FFF;">Search</a>&nbsp;
                                     <a href="javascript:cmdExport()" class="btn" style="color:#FFF;">Excel</a>
                                </div>
                            </td> 
                        </tr>
                    </table>
                </div>
                <% if (iCommand == Command.LIST) {
                    if (listEmployee.size() > 0 ){ %>
                    <table class="tblStyle" style="width: 100%">
                    <tr>
                        <td class="title_tbl" style="text-align:center; vertical-align:middle; width:  5%">No</td>
                        <td class="title_tbl" style="text-align:center; vertical-align:middle; width: 5%">NRK</td>
                        <td class="title_tbl" style="text-align:center; vertical-align:middle; width: 20%">Nama</td>
                        <td class="title_tbl" style="text-align:center; vertical-align:middle; width: 20%">Jabatan</td>
                        <td class="title_tbl" style="text-align:center; vertical-align:middle; width: 15%">Satuan Kerja</td>
                        <td class="title_tbl" style="text-align:center; vertical-align:middle; width: 15%">Unit</td>
                        <td class="title_tbl" style="text-align:center; vertical-align:middle; width: 10%">Tanggal Lahir</td>
                    </tr>
                    <%
                    if (listEmployee != null && listEmployee.size() > 0) {
                        
                        for (int idxEmp = 0; idxEmp < listEmployee.size(); idxEmp++) {
                            Employee emp = (Employee) listEmployee.get(idxEmp);
                            
                    
                            Position pos = new Position();
                            String position = "";
                            try{
                                pos = PstPosition.fetchExc(emp.getPositionId());
                                position = pos.getPosition();
                            } catch (Exception exc){

                            }

                            
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
                                     <td style="background-color: <%=bgColor%>;"><%=""+ position%></td>
                                     <td style="background-color: <%=bgColor%>;"><%=""+ PstEmployee.getDivisionName(emp.getDivisionId())%></td>
                                     <td style="background-color: <%=bgColor%>;"><%=""+ PstEmployee.getDepartmentName(emp.getDepartmentId())%></td>
                                    <td style="background-color: <%=bgColor%>;"><%=""+ Formater.formatDate(emp.getBirthDate())%></td>                                     
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

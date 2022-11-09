<%-- 
    Document   : document_emp_search
    Created on : Jun 27, 2016, 10:40:06 AM
    Author     : Dimata 007
--%>

<%@page import="java.sql.ResultSet"%>
<%@page import="com.dimata.qdep.db.DBHandler"%>
<%@page import="com.dimata.harisma.entity.payroll.PstPaySlip"%>
<%@page import="com.dimata.harisma.entity.payroll.PstPaySlipComp"%>
<%@page import="com.dimata.qdep.db.DBResultSet"%>
<%@page import="com.dimata.harisma.entity.payroll.PayComponent"%>
<%@page import="com.dimata.harisma.entity.payroll.PstPayComponent"%>
<%@page import="com.dimata.harisma.entity.payroll.PayPeriod"%>
<%@page import="com.dimata.harisma.entity.payroll.PstPayPeriod"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file = "../../main/javainit.jsp" %>
<!DOCTYPE html>
<%!
    public static double getCompValue(long employeeId, long periodId, long compId) {
        double compValue = 0;
        DBResultSet dbrs = null;
        PayComponent payComp = new PayComponent();
        try {
            payComp = PstPayComponent.fetchExc(compId);
        } catch (Exception exc){}
        try {

            String sql = "SELECT PAY." + PstPaySlipComp.fieldNames[PstPaySlipComp.FLD_COMP_VALUE]
                    + " FROM " + PstPaySlipComp.TBL_PAY_SLIP_COMP + " AS PAY"
                    + " INNER JOIN " + PstPaySlip.TBL_PAY_SLIP + " AS SLIP"
                    + " ON PAY." + PstPaySlipComp.fieldNames[PstPaySlipComp.FLD_PAY_SLIP_ID]
                    + " = SLIP." + PstPaySlip.fieldNames[PstPaySlip.FLD_PAY_SLIP_ID]
                    + " WHERE SLIP." + PstPaySlip.fieldNames[PstPaySlip.FLD_PERIOD_ID] + "=" + periodId
                    + " AND SLIP." + PstPaySlip.fieldNames[PstPaySlip.FLD_EMPLOYEE_ID] + "=" + employeeId
                    + " AND PAY." + PstPaySlipComp.fieldNames[PstPaySlipComp.FLD_COMP_CODE] + "= \"" + payComp.getCompCode() + "\"";

            //System.out.println("SQL PstPaySlipComp.getOtherDeduction"+sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                compValue = rs.getDouble(1);
            }

            rs.close();
            return compValue;
        } catch (Exception e) {
            return 0;
        } finally {
            DBResultSet.close(dbrs);
        }


    }
%>
<%
    long oidEmpDoc = FRMQueryString.requestLong(request,"oid_emp_doc");
    String objectName = FRMQueryString.requestString(request,"object_name");
    boolean isDataSingle = FRMQueryString.requestBoolean(request,"is_data_single");
    boolean isEmpDocExpense = FRMQueryString.requestBoolean(request,"is_emp_doc_expense");
    String[] empCheck = FRMQueryString.requestStringValues(request, "emp_check");
    int searchType = FRMQueryString.requestInt(request, "search_type");
    long periodId = FRMQueryString.requestLong(request, "period");
    long compId = FRMQueryString.requestLong(request, "component");
    double nominal = FRMQueryString.requestDouble(request, "nominal");
    long oidInsert = 0;
    // add By Eri Yudi 2021-11-22
     EmpDoc empDoc = (EmpDoc)PstEmpDoc.fetchExc(oidEmpDoc);
     Vector listtemplate = PstDocMasterTemplate.list(0, 0, PstDocMasterTemplate.fieldNames[PstDocMasterTemplate.FLD_DOC_MASTER_ID] + " = " + empDoc.getDoc_master_id(), "");
     DocMasterTemplate empDocMasterTempleate =  (DocMasterTemplate)listtemplate.get(0);
     String whereCompMap = PstEmpDocCompMap.fieldNames[PstEmpDocCompMap.FLD_DOC_MASTER_ID] + " = "+ empDoc.getDoc_master_id();
     Vector listEmpDocCompMap = new Vector();
     if(isEmpDocExpense){
         listEmpDocCompMap = PstEmpDocCompMap.list(0, 0, whereCompMap, "");
     }
   //end  
    if (empCheck != null){
        for(int i=0; i<empCheck.length; i++){
            if (searchType == 1){
                EmpDocListExpense empDocListExpense = new EmpDocListExpense();
                empDocListExpense.setEmpDocId(oidEmpDoc);
                empDocListExpense.setPeriodeId(periodId);
                empDocListExpense.setComponentId(compId);
                empDocListExpense.setEmployeeId(Long.valueOf(empCheck[i]));
                if (objectName.equals("KELEBIHAN")){
                    empDocListExpense.setObjectName("DEBET");
                } else if (objectName.equals("KEKURANGAN")){
                    empDocListExpense.setObjectName("KREDIT");
                }
                //double compVal = getCompValue(Long.valueOf(empCheck[i]), periodId, compId);
                empDocListExpense.setCompValue(nominal);
                try {
                    oidInsert = PstEmpDocListExpense.insertExc(empDocListExpense);
                } catch(Exception e){
                    System.out.println(e.toString());
                }
            } else {
                EmpDocList empDocList = new EmpDocList();
                empDocList.setEmp_doc_id(oidEmpDoc);
                empDocList.setEmployee_id(Long.valueOf(empCheck[i]));
                empDocList.setObject_name(objectName);
                try {
                    //add by Eri Yudi 2022-04-01 for fix bug karyawan yang absen berubah padah disurat sppd employeenya sudah diganti
                    if(isDataSingle){
                        String whereClause = " "+PstEmpDocList.fieldNames[PstEmpDocList.FLD_OBJECT_NAME]+" = '"+objectName+"' AND "+PstEmpDocList.fieldNames[PstEmpDocList.FLD_EMP_DOC_ID]+" = "+oidEmpDoc;
                         Vector listEmpDoc = PstEmpDocList.list(0, 0, whereClause, "");
                         if(listEmpDoc.size()>0){
                             for(int xy = 0 ; xy < listEmpDoc.size();xy++){
                                 try{
                                      EmpDocList objDbEmpDocList = (EmpDocList) listEmpDoc.get(xy);
                                      long oidDel = PstEmpDocList.deleteExc(objDbEmpDocList.getOID());
                                 }catch(Exception exc){
                                     
                                 }
                               
                             }
                         }
                    }
                    oidInsert = PstEmpDocList.insertExc(empDocList);
                    //add by eri yudi 2021-11-22
                    if(listEmpDocCompMap.size()>0){
                        for(int xy = 0 ; xy < listEmpDocCompMap.size();xy++){
                            EmpDocCompMap empDocCompMap = (EmpDocCompMap) listEmpDocCompMap.get(xy);
                             EmpDocListExpense empDocListExpense = new EmpDocListExpense();
                                empDocListExpense.setEmpDocId(oidEmpDoc);
                                empDocListExpense.setPeriodeId(empDocCompMap.getPeriodId());
                                empDocListExpense.setComponentId(empDocCompMap.getComponentId());
                                empDocListExpense.setEmployeeId(Long.valueOf(empCheck[i]));
                                empDocListExpense.setDayLength(empDocCompMap.getDayLength());
                                empDocListExpense.setObjectName(objectName);
                                try {
                                   long oidInsertDocExpense = PstEmpDocListExpense.insertExc(empDocListExpense);
                                } catch(Exception e){
                                    System.out.println(e.toString());
                                }
                        }
                    }
                    //end add By Eri 
                } catch(Exception e){
                    System.out.println(e.toString());
                }
            }
        }
    }
               
    String strUrl = "";
    strUrl  = "'0',";
    strUrl += "'0',";
    strUrl += "'0',";
    strUrl += "'0',";
    strUrl += "'frm_company_id',";
    strUrl += "'frm_division_id',";
    strUrl += "'frm_department_id',";
    strUrl += "'frm_section_id'";
    
    String whereClause = "";
    String order = "";
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Document Employee Search</title>
        <link rel="stylesheet" href="../../styles/main.css" type="text/css">
        <style type="text/css">
            body {
                margin: 0;
                padding: 0;
                font-size: 12px;
                font-family: sans-serif;
            }
            .header {
                background-color: #EEE;
                padding: 21px;
                border-bottom: 1px solid #DDD;
            }
            .content {
                padding: 21px;
            }
            #caption, .caption {
                font-size: 12px;
                color: #474747;
                font-weight: bold;
                padding: 2px 0px 3px 0px;
            }
            #divinput, .divinput {
                margin-bottom: 5px;
                padding-bottom: 5px;
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
            
            .item {
                background-color: #EEE;
                padding: 9px;
                margin: 9px 15px;
            }
        </style>
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
                for (var selector in config) {
                    $(selector).chosen(config[selector]);
                }
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
                for (var selector in config) {
                    $(selector).chosen(config[selector]);
                }
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
                for (var selector in config) {
                    $(selector).chosen(config[selector]);
                }
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
                for (var selector in config) {
                    $(selector).chosen(config[selector]);
                }
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


function pageLoad(){ 
    loadCompany(<%=strUrl%>);
} 
function cmdSearch(){
    var strUrl = "";
    var empNum = document.getElementById("emp_num").value;
    var empName = document.getElementById("emp_name").value;
    var comp = document.getElementById("company").value;
    var divi = document.getElementById("division").value;
    var dept = document.getElementById("department").value;
    var sect = document.getElementById("section").value;
    <% if (searchType == 0 ) {%>
    var posi = document.getElementById("position").value;
    var cate = document.getElementById("category").value;
    <% } else {%>
    var posi = "0";
    var cate = "0";
    <% }%>
    var oidEmpDoc = document.getElementById("oid_emp_doc").value;
    var objName = document.getElementById("object_name").value;
    
    if (empNum.length == 0){
        empNum = "0";
    }
    if (empName.length == 0){
        empName = "0";
    }
    
    var xmlhttp = new XMLHttpRequest();
    xmlhttp.onreadystatechange = function() {
        if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
            document.getElementById("div_list").innerHTML = xmlhttp.responseText;
        }
    };
    strUrl = "list_employee.jsp";
    strUrl += "?company="+comp;
    strUrl += "&division="+divi;
    strUrl += "&department="+dept;
    strUrl += "&section="+sect;

    strUrl += "&position="+posi;
    strUrl += "&category="+cate;
    strUrl += "&emp_num="+empNum;
    strUrl += "&emp_name="+empName;
    
    strUrl += "&oid_emp_doc="+oidEmpDoc;
    strUrl += "&object_name="+objName;
    
    xmlhttp.open("GET", strUrl, true);
    xmlhttp.send();
}
function check() {
    document.getElementsByClassName("myC").checked = true;
}

function uncheck() {
    document.getElementById("myCheck").checked = false;
}
function cmdGet(){
    <% if (searchType == 1) { %>
        var perId = document.getElementById("period").value;
        var compId = document.getElementById("component").value;
        var nominal = document.getElementById("nominal").value;
        if (perId > 0 && compId >0 && nominal > 0){
            document.frm.action="document_emp_search.jsp";
            document.frm.submit();
        } else {
            alert("Pilih Periode, Komponen dan isi Nominal!");
        }
    <% } else { %>
        document.frm.action="document_emp_search.jsp";
        document.frm.submit();
    <% } %>
    
//    opener.location.reload(); // or opener.location.href = opener.location.href;
//    window.close(); // or self.close();
}

function cmdGoToSurat(oidEmpDoc, objectName){
    document.frm.action="search_app_letter.jsp?oid_emp_doc="+oidEmpDoc+"&object_name="+objectName;
    document.frm.submit();
}

</script>
<link rel="stylesheet" href="<%=approot%>/javascripts/datepicker/themes/jquery.ui.all.css">
<script src="<%=approot%>/javascripts/jquery.js"></script>
<script src="../../javascripts/chosen.jquery.js" type="text/javascript"></script>
<link rel="stylesheet" href="../../stylesheets/chosen.css" >
    </head>
    <body onload="pageLoad()">
        <div class="header">
            <h2 style="color:#999">Pencarian Karyawan</h2>
            <%
            if (oidInsert != 0){
                %>
                <div style="padding: 9px; background-color: #DDD;">Data Berhasil disimpan</div>
                <%
            }
            %>
        </div>
        <div class="content">
            <form name="frm" method="post" action="">
                <input type="hidden" id="oid_emp_doc" name="oid_emp_doc" value="<%= oidEmpDoc %>" />
                <input type="hidden" id="object_name" name="object_name" value="<%= objectName %>" />
                <input type="hidden" id="is_data_single" name="is_data_single" value="<%= isDataSingle %>" />
                <input type="hidden" id="is_emp_doc_expense" name="is_emp_doc_expense" value="<%= isEmpDocExpense %>" />
                <input type="hidden" id="search_type" name="search_type" value="<%= searchType %>" />
                <table width="100%">
                    <tr>
                        <td valign="top" width="50%">
                            <div id="caption">Emp.Num</div>
                            <div id="divinput">
                                <input type="text" id="emp_num" name="emp_num" value="" size="50" />
                            </div>

                            <div id="caption">Nama</div>
                            <div id="divinput">
                                <input type="text" id="emp_name" name="emp_name" value="" size="50" />
                            </div>

                            <div id="div_result"></div>
                            <%if (searchType == 0) {%>
                            <div id="caption">Jabatan</div>
                            <div id="divinput">
                                <select id="position" name="position" class="chosen-select">
                                    <option value="0">-select-</option>
                                    <%
                                    whereClause = PstPosition.fieldNames[PstPosition.FLD_VALID_STATUS]+"=";
                                    whereClause += PstPosition.VALID_ACTIVE;
                                    order = PstPosition.fieldNames[PstPosition.FLD_POSITION];
                                    Vector listPosition = PstPosition.list(0, 0, whereClause, order);
                                    if (listPosition != null && listPosition.size()>0){
                                        for(int i=0; i<listPosition.size(); i++){
                                            Position jabatan = (Position)listPosition.get(i);
                                            %>
                                            <option value="<%= jabatan.getOID() %>"><%= jabatan.getPosition() %></option>
                                            <%
                                        }
                                    }
                                    %>
                                </select>
                            </div>

                            <div id="caption">Kategori</div>
                            <div id="divinput">
                                <select id="category" name="category" class="chosen-select">
                                    <option value="0">-select-</option>
                                    <%
                                    Vector listCategory = PstEmpCategory.list(0, 0, "", "");
                                    if (listCategory != null && listCategory.size()>0){
                                        for(int i=0; i<listCategory.size(); i++){
                                            EmpCategory category = (EmpCategory)listCategory.get(i);
                                            %>
                                            <option value="<%= category.getOID() %>"><%= category.getEmpCategory() %></option>
                                            <%
                                        }
                                    }
                                    %>
                                </select>
                            </div>
                            <% } %>
                            <%if (searchType == 1) {%>
                            <div id="caption">Periode</div>
                            <div id="divinput">
                                <select id="period" name="period" class="chosen-select">
                                    <option value="0">-select-</option>
                                    <%
                                    Vector listPeriode = PstPayPeriod.list(0, 0, "", PstPayPeriod.fieldNames[PstPayPeriod.FLD_END_DATE]+" DESC");
                                    if (listPeriode != null && listPeriode.size()>0){
                                        for(int i=0; i<listPeriode.size(); i++){
                                            PayPeriod payPeriod = (PayPeriod)listPeriode.get(i);
                                            %>
                                            <option value="<%= payPeriod.getOID() %>"><%= payPeriod.getPeriod()%></option>
                                            <%
                                        }
                                    }
                                    %>
                                </select>
                            </div>
                                
                            <div id="caption">Komponen</div>
                            <div id="divinput">
                                <select id="component" name="component" class="chosen-select">
                                    <option value="0">-select-</option>
                                    <%
                                    Vector listPayComp = PstPayComponent.list(0, 0, "", PstPayComponent.fieldNames[PstPayComponent.FLD_COMP_TYPE]+"");
                                    if (listPayComp != null && listPayComp.size()>0){
                                        for(int i=0; i<listPayComp.size(); i++){
                                            PayComponent payComponent = (PayComponent)listPayComp.get(i);
                                            %>
                                            <option value="<%= payComponent.getOID() %>">[<%=payComponent.getCompCode()%>] <%= payComponent.getCompName()%></option>
                                            <%
                                        }
                                    }
                                    %>
                                </select>
                            </div>
                                
                                <div id="caption">Nominal</div>
                                <div id="divinput">
                                    <input type="number" name="nominal" id="nominal" value=""/>
                                </div>
                            <% } %>
                            <div>&nbsp;</div>
                            <a class="btn" style="color:#FFF" href="javascript:cmdSearch()">Search</a>
                        </td>
                        <td valign="top" width="50">
                            <div id="div_list"></div>
                        </td>
                    </tr>
                </table>
            </form>
        </div>
    </body>
</html>

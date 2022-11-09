<%-- 
    Document   : coa_mapping
    Created on : Jul 1, 2016, 4:21:51 PM
    Author     : Dimata 007
--%>

<%@page import="com.dimata.harisma.form.masterdata.FrmComponentCoaMap"%>
<%@page import="com.dimata.harisma.form.masterdata.CtrlComponentCoaMap"%>
<%@page import="com.dimata.harisma.entity.log.ChangeValue"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstComponentCoaMap"%>
<%@page import="com.dimata.harisma.entity.masterdata.ComponentCoaMap"%>
<%@page import="com.dimata.harisma.entity.payroll.PayComponent"%>
<%@page import="com.dimata.harisma.entity.payroll.PstPayComponent"%>
<%@page import="com.dimata.util.Command"%>
<%@page import="com.dimata.aiso.entity.masterdata.Perkiraan"%>
<%@page import="com.dimata.aiso.entity.masterdata.PstPerkiraan"%>
<%@page import="com.dimata.harisma.entity.masterdata.Division"%>
<%@page import="com.dimata.qdep.form.FRMQueryString"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstDivision"%>
<%@page import="com.dimata.harisma.entity.masterdata.Company"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstCompany"%>
<%@page import="java.util.Vector"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
    int iCommand = FRMQueryString.requestCommand(request);
    long oidPerkiraan = FRMQueryString.requestLong(request, FrmComponentCoaMap.fieldNames[FrmComponentCoaMap.FRM_FIELD_ID_PERKIRAAN]);
    long oidCoaMap = FRMQueryString.requestLong(request, "oid_coa_map");
    String formulaInput = FRMQueryString.requestString(request, "formula_input");
    
    long companyId = FRMQueryString.requestLong(request, "frm_company_id");
    long divisionId = FRMQueryString.requestLong(request, "frm_division_id");
    long departmentId = FRMQueryString.requestLong(request, "frm_department_id");
    long sectionId = FRMQueryString.requestLong(request, "frm_section_id");
    
    String coaName = "";
    String formulaData = "";
    ChangeValue changeValue = new ChangeValue();
    
    

    CtrlComponentCoaMap ctrlCoaMap = new CtrlComponentCoaMap(request);
    int iErrCode = ctrlCoaMap.action(iCommand, oidCoaMap);
    ComponentCoaMap coaMapping = ctrlCoaMap.getComponentCoaMap();
    
    if (coaMapping.getIdPerkiraan() != 0){
        oidPerkiraan = coaMapping.getIdPerkiraan();
    }
    
    if (iCommand == Command.EDIT){
        oidPerkiraan = coaMapping.getIdPerkiraan();
    }
    String whereClause = PstComponentCoaMap.fieldNames[PstComponentCoaMap.FLD_ID_PERKIRAAN]+"="+oidPerkiraan;
    if (oidPerkiraan != 0){
        try {
            Perkiraan perkiraan = PstPerkiraan.fetchExc(oidPerkiraan);
            coaName = perkiraan.getNama();
        } catch(Exception e){
            System.out.println(e.toString());
        }
    }
    /*
    if (iCommand == Command.SAVE){
        try {
            ComponentCoaMap coaMap = new ComponentCoaMap();
            coaMap.setGenId(companyId);
            coaMap.setDivisionId(divisionId);
            coaMap.setDepartmentId(departmentId);
            coaMap.setSectionId(sectionId);
            if (formulaInput.length()==0){
                formulaInput = "-";
            }
            coaMap.setFormula(formulaInput);
            coaMap.setIdPerkiraan(oidPerkiraan);
            PstComponentCoaMap.insertExc(coaMap);
        } catch(Exception e){
            System.out.println(e.toString());
        }
        formulaInput = "";
        formulaData = "";
        iCommand = 0;
    }
    
    if (iCommand == Command.EDIT){
        if (oidCoaMap != 0){
            try {
                coaMapping = PstComponentCoaMap.fetchExc(oidCoaMap);
            } catch (Exception e){
                System.out.println(e.toString());
            }
        }
    }*/
    
    String strUrl = "";
    strUrl  = "'"+coaMapping.getGenId()+"',";
    strUrl += "'"+coaMapping.getDivisionId()+"',";
    strUrl += "'"+coaMapping.getDepartmentId()+"',";
    strUrl += "'0',";
    strUrl += "'"+FrmComponentCoaMap.fieldNames[FrmComponentCoaMap.FRM_FIELD_GEN_ID]+"',";
    strUrl += "'"+FrmComponentCoaMap.fieldNames[FrmComponentCoaMap.FRM_FIELD_DIVISION_ID]+"',";
    strUrl += "'"+FrmComponentCoaMap.fieldNames[FrmComponentCoaMap.FRM_FIELD_DEPARTMENT_ID]+"',";
    strUrl += "'"+FrmComponentCoaMap.fieldNames[FrmComponentCoaMap.FRM_FIELD_SECTION_ID]+"'";
    
    Vector listCoaMap = PstComponentCoaMap.list(0, 0, whereClause, "");
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link rel="stylesheet" href="../../styles/main.css" type="text/css">
        <style type="text/css">
            body {
                font-family: sans-serif;
                background-color: #EEE;
                margin: 0;
                padding: 0;
            }
            .header {
                color:#575757;
                background-color: #DDD;
                padding: 21px;
            }
            .content {
                padding:21px;
            }
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
            .title {
                font-size: 18px;
            }
            .tblStyle {border-collapse: collapse; font-size: 12px; }
            .tblStyle td {padding: 5px 7px; border: 1px solid #CCC; font-size: 12px; }
            .title_tbl {font-weight: bold;background-color: #DDD; color: #575757;}
            .list {
                border-top: 1px solid #DDD;
                background-color: #FFF;
                padding: 21px;
            }
        </style>
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


function pageLoad(){ 
    loadCompany(<%=strUrl%>);
}

            function cmdAddFormula(){
                var data = document.getElementById("select_formula").value;
                var e = document.getElementById("type");
                var selectedType = e.options[e.selectedIndex].value;
                var result = "";
                if (selectedType === "0"){
                     result = document.getElementById("formula_input").value;
                } else {
                    result = document.getElementById("formula_min_input").value;
                }
                if(result!=""){
                    result = result +","+ data;
                } else {
                    result = result + data;
                }
                
                if (selectedType === "0"){
                    document.getElementById("formula_input").value = result;
                } else {
                    document.getElementById("formula_min_input").value = result;
                }
            }
            
            function cmdSave(){
                var formula = document.getElementById("formula_input").value;
                document.frm.command.value = "<%=Command.SAVE%>";
                document.frm.formula_input.value = formula;
                document.frm.action = "coa_mapping.jsp";
                document.frm.submit();
            }
            function cmdEdit(oid){
                document.frm.command.value = "<%=Command.EDIT%>";
                document.frm.oid_coa_map.value = oid;
                document.frm.action = "coa_mapping.jsp";
                document.frm.submit();
            }
            function cmdDelete(oid){
                document.frm.command.value = "<%=Command.DELETE%>";
                document.frm.oid_coa_map.value = oid; 
                document.frm.action = "coa_mapping.jsp";
                document.frm.submit();
            }
        </script>
    </head>
    <body onload="pageLoad()">
        <div class="header">
            <div class="title"><%= coaName %> Detail</div>
        </div>
        <div class="content">
            <form name="frm" method="post" action="">
                <input type="hidden" name="command" value="<%= iCommand %>" /> 
                <input type="hidden" name="oid_coa_map" value="<%= oidCoaMap %>" /> 
                <input type="hidden" name="<%= FrmComponentCoaMap.fieldNames[FrmComponentCoaMap.FRM_FIELD_ID_PERKIRAAN] %>" value="<%= oidPerkiraan %>" />
                <div id="div_result"></div>
                
                <div class="divinput">
                    <div style="font-size: 10px;">* Pilih komponen gaji, kemudian klik tombol Tambah (+)</div>
                    <select id="select_formula">
                        <option value="0">-select-</option>
                    <%
                    /* List of Salary Component */
                    Vector listComponent = PstPayComponent.list(0, 0, "", "");
                    if (listComponent != null & listComponent.size()>0){
                        for(int i=0; i<listComponent.size(); i++){
                            PayComponent payComp = (PayComponent)listComponent.get(i);
                            %>
                            <option value="<%=""+payComp.getCompCode()%>"><%=payComp.getCompCode()+" | "+payComp.getCompName()%></option>
                            <%
                        }
                    }

                    
                    formulaData = formulaInput;

                    %>
                    </select>
                    <select id="type">
                        <option value="0">Penambah</option>
                        <option value="1">Pengurang</option>
                    </select>
                    <a class="btn" style="color:#FFF;" href="javascript:cmdAddFormula()">+</a>
                    <div>&nbsp;</div>
                    <div class="caption">Formula</div>
                    <div class="divinput">
                        <input type="text" id="formula_input" name="<%= FrmComponentCoaMap.fieldNames[FrmComponentCoaMap.FRM_FIELD_FORMULA] %>" value="<%= coaMapping.getFormula() %>" size="70" value="" />
                    </div>
                    <div class="caption">Formula Pengurang</div>
                    <div class="divinput">
                        <input type="text" id="formula_min_input" name="<%= FrmComponentCoaMap.fieldNames[FrmComponentCoaMap.FRM_FIELD_FORMULA_MINUS] %>" value="<%= coaMapping.getFormulaMin()%>" size="70" value="" />
                    </div>
                    <div class="caption">No.Rekening</div>
                    <div class="divinput">
                        <input type="text" id="rekening_input" name="<%= FrmComponentCoaMap.fieldNames[FrmComponentCoaMap.FRM_FIELD_NO_REKENING] %>" value="<%= (coaMapping.getNoRekening() != null ? coaMapping.getNoRekening() : "-") %>" size="70" value="" />
                    </div>
                </div>
                <a href="javascript:cmdSave()" style="color:#FFF;" class="btn">Save</a>
                <a href="javascript:cmdCancel()" style="color:#FFF;" class="btn">Cancel</a>
                
                <div>&nbsp;</div>
                
            </form>
        </div>
                
        <div class="list">
            <table class="tblStyle">
                <tr>
                    <td class="title_tbl">No</td>
                    <td class="title_tbl">Perusahaan</td>
                    <td class="title_tbl">Satuan Kerja</td>
                    <td class="title_tbl">Unit</td>
                    <td class="title_tbl">Komponen Gaji</td>
                    <td class="title_tbl">Komponen Gaji Pengurang</td>
                    <td class="title_tbl">No. Rekening</td>
                    <td class="title_tbl">Action</td>
                </tr>
                <%
                if (listCoaMap != null && listCoaMap.size()>0){
                    for(int i=0; i<listCoaMap.size(); i++){
                        ComponentCoaMap coaMap = (ComponentCoaMap)listCoaMap.get(i);
                %>
                <tr>
                    <td><%=(i+1)%></td>
                    <td><%= changeValue.getCompanyName(coaMap.getGenId()) %></td>
                    <td><%= changeValue.getDivisionName(coaMap.getDivisionId()) %></td>
                    <td><%= changeValue.getDepartmentName(coaMap.getDepartmentId()) %></td>
                    <td><%= coaMap.getFormula() %></td>
                    <td><%= coaMap.getFormulaMin()%></td>
                    <td><%= coaMap.getNoRekening()!=null?coaMap.getNoRekening():"-" %></td>
                    <td>
                        <a href="javascript:cmdEdit('<%= coaMap.getOID() %>')">edit</a> | 
                        <a href="javascript:cmdDelete('<%= coaMap.getOID() %>')">delete</a>
                    </td>
                </tr>
                <% 
                    }
                } 
                %>
            </table>
        </div>        
    </body>
</html>

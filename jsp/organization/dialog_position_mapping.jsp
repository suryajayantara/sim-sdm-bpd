<%-- 
    Document   : dialog_position_mapping
    Created on : Jul 19, 2016, 9:33:04 AM
    Author     : Dimata 007
--%>

<%@page import="com.dimata.util.Command"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file = "../main/javainit.jsp" %>
<!DOCTYPE html>
<%
    String whereClause = "";
    int iCommand = FRMQueryString.requestCommand(request);
    long frmCompanyInp = FRMQueryString.requestLong(request, "frm_company_inp");
    long frmDivisionInp = FRMQueryString.requestLong(request, "frm_division_inp");
    long frmDepartmentInp = FRMQueryString.requestLong(request, "frm_department_inp");
    long frmSectionInp = FRMQueryString.requestLong(request, "frm_section_inp");
    
    long positionId = FRMQueryString.requestLong(request, "position_id");
    String strUrl = "";
    strUrl  = "'"+frmCompanyInp+"',";
    strUrl += "'"+frmDivisionInp+"',";
    strUrl += "'"+frmDepartmentInp+"',";
    strUrl += "'"+frmSectionInp+"',";
    strUrl += "'frm_company_inp',";
    strUrl += "'frm_division_inp',";
    strUrl += "'frm_department_inp',";
    strUrl += "'frm_section_inp'";
    
    if (frmDivisionInp != 0 && frmDepartmentInp == 0 && frmSectionInp == 0){
        if (iCommand == Command.SAVE){
            PositionDivision posisiDiv = new PositionDivision();
            posisiDiv.setDivisionId(frmDivisionInp);
            posisiDiv.setPositionId(positionId);
            try {
                PstPositionDivision.insertExc(posisiDiv);
            } catch (Exception e){
                System.out.print(""+e.toString());
            }
        }
    }
    if (frmDivisionInp !=0 && frmDepartmentInp != 0 && frmSectionInp == 0){
        if (iCommand == Command.SAVE){
            PositionDepartment posisiDept = new PositionDepartment();
            posisiDept.setDepartmentId(frmDepartmentInp);
            posisiDept.setPositionId(positionId);
            try {
                PstPositionDepartment.insertExc(posisiDept);
            } catch (Exception e){
                System.out.print(""+e.toString());
            }
        }
    }
    if (frmDivisionInp !=0 && frmDepartmentInp != 0 && frmSectionInp != 0){
        if (iCommand == Command.SAVE){
            PositionSection posisiSect = new PositionSection();
            posisiSect.setSectionId(frmSectionInp);
            posisiSect.setPositionId(positionId);
            try {
                PstPositionSection.insertExc(posisiSect);
            } catch (Exception e){
                System.out.print(""+e.toString());
            }
        }
    }
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Position Mapping</title>
        <style type="text/css">
            body {
                color: #FFF;
                font-size: 12px;
                font-family: sans-serif;
                background-color: #EEE;
                padding: 0;
                margin: 0;
            }
            .header {
                color: #377387;
                padding: 21px;
                background-color: #FFF;
                border-bottom: 1px solid #DDD;
                width: 100%;
            }
            .content {
                padding: 21px;
            }
            .btn {
                background-color: #00a1ec;
                border-radius: 3px;
                font-family: Arial;
                border-radius: 3px;
                color: #EEE;
                font-size: 12px;
                padding: 7px 11px 7px 11px;
                border: solid #00a1ec 1px;
                text-decoration: none;
            }

            .btn:hover {
                color: #FFF;
                background-color: #007fba;
                text-decoration: none;
                border: 1px solid #007fba;
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
            select {
                border: 1px solid #DDD;
                padding: 3px 5px;
                border-radius: 3px;
            }
            .btn:hover {
                color: #FFF;
                background-color: #007fba;
                text-decoration: none;
            }
            .footer {
                display: inline;
                position: fixed;
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

function cmdSave(){
    document.frm.command.value="<%= Command.SAVE %>";
    document.frm.action="dialog_position_mapping.jsp";
    document.frm.submit();
}
</script>
    </head>
    <body onload="pageLoad()">
        <div class="header">
            <h1>Add Position</h1>
        </div>
        <div class="content">
            <form name="frm" method="post" action="">
                <input type="hidden" name="command" value="<%=iCommand%>">
                <div id="div_result"></div>
                <div class="caption">
                    <%=dictionaryD.getWord(I_Dictionary.POSITION)%>
                </div>
                <div class="divinput">
                    <select name="position_id">
                        <option value="0">-Select-</option>
                        <%
                        Vector listPosition = PstPosition.list(0, 0, "", PstPosition.fieldNames[PstPosition.FLD_POSITION]);
                        if (listPosition != null && listPosition.size()>0){
                            for (int i=0; i<listPosition.size(); i++){
                                Position position = (Position)listPosition.get(i);
                                %>
                                <option value="<%= position.getOID() %>"><%= position.getPosition() %></option>
                                <%
                            }
                        }
                        %>
                    </select>
                </div>
                <div>&nbsp;</div>
                <a href="javascript:cmdSave()" style="color:#FFF;" class="btn">Save</a>
                <a href="javascript:cmdCancel()" style="color:#FFF;" class="btn">Cancel</a>
            </form>
        </div>
    </body>
</html>

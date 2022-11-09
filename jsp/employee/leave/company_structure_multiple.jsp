<%-- 
    Document   : company_structure
    Created on : May 17, 2016, 3:35:11 PM
    Author     : Dimata 007
--%>

<%@page import="com.dimata.harisma.form.employee.FrmCareerPath"%>
<%@page import="com.dimata.util.lang.I_Dictionary"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file = "../../main/javainit.jsp" %>
<%
/* value of structure */
String[] arrCompany = FRMQueryString.requestStringValues(request, "company_id");
String[] arrDivision = FRMQueryString.requestStringValues(request, "division_id");
String[] arrDepartment = FRMQueryString.requestStringValues(request, "department_id");
String[] arrSection = FRMQueryString.requestStringValues(request, "section_id");

String inCompany = "";
String inDivision = "";
String inDepartment = "";
String inSection = "";

if (arrCompany != null){
    for (int i=0; i < arrCompany.length; i++){
        inCompany = inCompany + ","+ arrCompany[i];
    }
    inCompany = inCompany.substring(1);
}
if (arrDivision != null){
    for (int i=0; i < arrDivision.length; i++){
        inDivision = inDivision + ","+ arrDivision[i];
    }
    inDivision = inDivision.substring(1);
}
if (arrDepartment != null){
    for (int i=0; i < arrDepartment.length; i++){
        inDepartment = inDepartment + ","+ arrDepartment[i];
    }
}
if (arrSection != null){
    for (int i=0; i < arrSection.length; i++){
        inSection = inSection + ","+ arrSection[i];
    }
    inSection = inSection.substring(1);
}

//long companyId = FRMQueryString.requestLong(request, "company_id");
//long divisionId = FRMQueryString.requestLong(request, "division_id");
//long departmentId = FRMQueryString.requestLong(request, "department_id");
//long sectionId = FRMQueryString.requestLong(request, "section_id");
/* Name of form input */
String frmCompany = FRMQueryString.requestString(request, "frm_company");
String frmDivision = FRMQueryString.requestString(request, "frm_division");
String frmDepartment = FRMQueryString.requestString(request, "frm_department");
String frmSection = FRMQueryString.requestString(request, "frm_section");
String strFieldNames  = "'"+frmCompany+"',";
       strFieldNames += "'"+frmDivision+"',";
       strFieldNames += "'"+frmDepartment+"',";
       strFieldNames += "'"+frmSection+"'";
/* value structure from pemanggil */
//long pCompanyId = FRMQueryString.requestLong(request, "p_company_id");
//long pDivisionId = FRMQueryString.requestLong(request, "p_division_id");
//long pDepartmentId = FRMQueryString.requestLong(request, "p_department_id");
//long pSectionId = FRMQueryString.requestLong(request, "p_section_id");

String[] pArrCompany = FRMQueryString.requestStringValues(request, "p_company_id");
String[] pArrDivision = FRMQueryString.requestStringValues(request, "p_division_id");
String[] pArrDepartment = FRMQueryString.requestStringValues(request, "p_department_id");
String[] pArrSection = FRMQueryString.requestStringValues(request, "p_section_id");

String pInCompany = "";
String pInDivision = "";
String pInDepartment = "";
String pInSection = "";

if (pArrCompany != null){
    for (int i=0; i < pArrCompany.length; i++){
        pInCompany = pInCompany + ","+ pArrCompany[i];
    }
    pInCompany = pInCompany.substring(1);
}
if (pArrDivision != null){
    for (int i=0; i < pArrDivision.length; i++){
        pInDivision = pInDivision + ","+ pArrDivision[i];
    }
    pInDivision = pInDivision.substring(1);
}
if (pArrDepartment != null){
    for (int i=0; i < pArrDepartment.length; i++){
        pInDepartment = pInDepartment + ","+ pArrDepartment[i];
    }
    pInDepartment = pInDepartment.substring(1);
}
if (pArrSection != null){
    for (int i=0; i < pArrSection.length; i++){
        pInSection = pInSection + ","+ pArrSection[i];
    }
    pInSection = pInSection.substring(1);
}

/* Kamus untuk caption field */
I_Dictionary dictionaryD = userSession.getUserDictionary();

if (!pInCompany.equals("")){
    inCompany = pInCompany;
}
if (!pInDivision.equals("")){
    inDivision = pInDivision;
}
if (!pInDepartment.equals("")){
    inDepartment = pInDepartment;
}
if (!pInSection.equals("")){
    inSection = pInSection;
}
/* Administrator Check */
    String strDisable = "";
    if (appUserSess.getAdminStatus()==0){
        strDisable = "disabled=\"disabled\"";
    }
%>
<div class="caption">
    <%=dictionaryD.getWord(I_Dictionary.COMPANY)%>
</div>
<div class="divinput">
    <select name="<%=frmCompany%>" id="company" class="chosen-select" data-placeholder='Select Perusahaan...' multiple onchange="javascript:loadDivision(this.value, <%=strFieldNames%>)" <%=strDisable%>>
        <option value="0">-select-</option>
        <%
        Vector listCompany = PstCompany.list(0, 0, "", PstCompany.fieldNames[PstCompany.FLD_COMPANY]);
        if (listCompany != null && listCompany.size()>0){
            for(int i=0; i<listCompany.size(); i++){
                Company comp = (Company)listCompany.get(i);
                if (arrCompany != null){
                    for (int x=0; x<arrCompany.length;x++){
                        if (Long.valueOf(arrCompany[x]) == comp.getOID()){
                            %>
                            <option selected="selected" value="<%=comp.getOID()%>"><%= comp.getCompany() %></option>
                            <%
                        } else {
                            %>
                            <option value="<%=comp.getOID()%>"><%= comp.getCompany() %></option>
                            <%
                        }
                    }
                } else {
                    %>
                    <option value="<%=comp.getOID()%>"><%= comp.getCompany() %></option>
                    <%
                }
             }
        }
        %>
    </select>
    <%
    if (strDisable.length()>0){
        %>
        <input type="hidden" name="<%=frmCompany%>" id="company" value="<%=inCompany%>" />
        <%
    }
    %>
</div>

<div class="caption">
    <%=dictionaryD.getWord(I_Dictionary.DIVISION)%>
</div>
<div class="divinput">
    <select name="<%=frmDivision%>" id="division" onchange="javascript:loadDepartment('<%=inCompany%>', this.value, <%=strFieldNames%>)" <%=strDisable%>>
        <option value="0">-select-</option>
        <%
        if(!inCompany.equals("")){
            String whereDiv = PstDivision.fieldNames[PstDivision.FLD_COMPANY_ID]+" IN("+inCompany+")";
            whereDiv += " AND "+PstDivision.fieldNames[PstDivision.FLD_VALID_STATUS]+"="+PstDivision.VALID_ACTIVE;
            Vector listDivision = PstDivision.list(0, 0, whereDiv, PstDivision.fieldNames[PstDivision.FLD_DIVISION]);
            if (listDivision != null && listDivision.size()>0){
                for(int i=0; i<listDivision.size(); i++){
                    Division divisi = (Division)listDivision.get(i);
                    if (arrDivision != null){
                        for (int x=0; x<arrDivision.length;x++){
                            if (Long.valueOf(arrDivision[x]) == divisi.getOID()){
                                %><option selected="selected" value="<%=divisi.getOID()%>"><%=divisi.getDivision()%></option><%
                            } else {
                                %><option value="<%=divisi.getOID()%>"><%=divisi.getDivision()%></option><%
                            }
                        }
                    } else {
                        %><option value="<%=divisi.getOID()%>"><%=divisi.getDivision()%></option><%
                    }
                }
            }
        }
        %>
    </select>
    <%
    if (strDisable.length()>0){
        %>
        <input type="hidden" name="<%=frmDivision%>" id="division" value="<%=inDivision%>" />
        <%
    }
    %>
</div>

<div class="caption">
    <%=dictionaryD.getWord(I_Dictionary.DEPARTMENT)%>
</div>
<div class="divinput">
    <select name="<%=frmDepartment%>" id="department" onchange="javascript:loadSection('<%=inCompany%>','<%=inDivision%>',this.value, <%=strFieldNames%>)">
        <option value="0">-select-</option>
        <%
        if (!inDivision.equals("")){
            Vector listDepart = PstDepartment.listDepartmentVer1In(0, 0, String.valueOf(inCompany) , String.valueOf(inDivision));
            if (listDepart != null && listDepart.size()>0){
                for(int i=0; i<listDepart.size(); i++){
                    Department depart = (Department)listDepart.get(i);
                    if (arrDepartment != null){
                        for (int x=0; x<arrDepartment.length;x++){
                            if (Long.valueOf(arrDepartment[x]) == depart.getOID()){
                                %><option selected="selected" value="<%=depart.getOID()%>"><%=depart.getDepartment()%></option><%
                            } else {
                                %><option value="<%=depart.getOID()%>"><%=depart.getDepartment()%></option><%
                            }
                        }
                    } else {
                        %><option value="<%=depart.getOID()%>"><%=depart.getDepartment()%></option><%
                    }
                }
            }
        }
        %>
    </select>
</div>

<div class="caption">
    <%=dictionaryD.getWord(I_Dictionary.SECTION)%>
</div>
<div class="divinput">
    <select name="<%=frmSection%>" id="section">
        <option value="0">-select-</option>
        <%
        if (!inDepartment.equals("")){
            String whereSection = PstSection.fieldNames[PstSection.FLD_DEPARTMENT_ID]+" IN ("+inDepartment+")";
            Vector listSection = PstSection.list(0, 0, whereSection, PstSection.fieldNames[PstSection.FLD_SECTION]);

            if (listSection != null && listSection.size()>0){
                for(int i=0; i<listSection.size(); i++){
                    Section section = (Section)listSection.get(i);
                    if (arrSection != null){
                        for (int x=0; x<arrSection.length;x++){
                            if (Long.valueOf(arrSection[x]) == section.getOID()){
                                %><option selected="selected" value="<%=section.getOID()%>"><%=section.getSection()%></option><%
                            } else {
                                %><option value="<%=section.getOID()%>"><%=section.getSection()%></option><%
                            }
                        }
                    } else {
                        %><option value="<%=section.getOID()%>"><%=section.getSection()%></option><%
                    }
                }
            }

        }        
        %>
    </select>
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
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
long companyId = FRMQueryString.requestLong(request, "company_id");
long divisionId = FRMQueryString.requestLong(request, "division_id");
long departmentId = FRMQueryString.requestLong(request, "department_id");
long sectionId = FRMQueryString.requestLong(request, "section_id");
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
long pCompanyId = FRMQueryString.requestLong(request, "p_company_id");
long pDivisionId = FRMQueryString.requestLong(request, "p_division_id");
long pDepartmentId = FRMQueryString.requestLong(request, "p_department_id");
long pSectionId = FRMQueryString.requestLong(request, "p_section_id");
/* Kamus untuk caption field */
I_Dictionary dictionaryD = userSession.getUserDictionary();

if (pCompanyId != 0){
    companyId = pCompanyId;
}
if (pDivisionId != 0){
    divisionId = pDivisionId;
}
if (pDepartmentId != 0){
    departmentId = pDepartmentId;
}
if (pSectionId != 0){
    sectionId = pSectionId;
}
/* Administrator Check */
    String strDisable = "";
    if (appUserSess.getAdminStatus()==0){
        strDisable = "disabled=\"disabled\"";
    }
   /* App Group | Update by Hendra Putu | 2016-09-26 */
   String appGroupStr = "";
   long diviAppUser = 0;
   long deptAppUser = 0;
    /* Update by Hendra Putu | 2016-09-26 | Redirect to employee view*/
   String whereUG = PstUserGroup.fieldNames[PstUserGroup.FLD_USER_ID]+"="+appUserSess.getOID();
   Vector userGroupList = PstUserGroup.list(0, 0, whereUG, "");
   if (userGroupList != null && userGroupList.size() > 0) {
        for (int i = 0; i < userGroupList.size(); i++) {
            UserGroup userGroup = (UserGroup) userGroupList.get(i);
            String whereG = PstAppGroup.fieldNames[PstAppGroup.FLD_GROUP_ID] + "=" + userGroup.getGroupID();
            Vector groupList = PstAppGroup.list(0, 0, whereG, "");
            if (groupList != null && groupList.size() > 0) {
                AppGroup appGroup = (AppGroup) groupList.get(0);
                if (appGroup.getGroupName().equals("Head")){
                    appGroupStr = appGroup.getGroupName();
                    appUserSess.getEmployeeId();
                    try {
                        Employee emp = PstEmployee.fetchExc(appUserSess.getEmployeeId());
                        diviAppUser = emp.getDivisionId();
                        deptAppUser = emp.getDepartmentId();
                    } catch(Exception e) {
                        System.out.print(""+e.toString());
                    }
                }
                if (appGroup.getGroupName().equals("Direksi")){
                    appGroupStr = appGroup.getGroupName();
                }
            }
        }      
    }
   
   if (appGroupStr.equals("Head")){
        // New location to be redirected
        String site = new String("employee_view_new.jsp");
        response.setStatus(response.SC_MOVED_TEMPORARILY);
        response.setHeader("Location", site);
   }
%>
<div class="caption">
    <%=dictionaryD.getWord(I_Dictionary.COMPANY)%>
</div>
<div class="divinput">
    <select name="<%=frmCompany%>" id="company" onchange="javascript:loadDivision(this.value, <%=strFieldNames%>)" <%=strDisable%>>
        <option value="0">-select-</option>
        <%
        Vector listCompany = PstCompany.list(0, 0, "", PstCompany.fieldNames[PstCompany.FLD_COMPANY]);
        if (listCompany != null && listCompany.size()>0){
            for(int i=0; i<listCompany.size(); i++){
                Company comp = (Company)listCompany.get(i);
                if (companyId == comp.getOID()){
                    %>
                    <option selected="selected" value="<%=comp.getOID()%>"><%= comp.getCompany() %></option>
                    <%
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
        <input type="hidden" name="<%=frmCompany%>" id="company" value="<%=companyId%>" />
        <%
    }
    %>
</div>

<div class="caption">
    <%=dictionaryD.getWord(I_Dictionary.DIVISION)%>
</div>
<div class="divinput">
    <select name="<%=frmDivision%>" id="division" onchange="javascript:loadDepartment('<%=companyId%>', this.value, <%=strFieldNames%>)" <%=strDisable%>>
        <option value="0">-select-</option>
        <%
        if(companyId != 0){
            String whereDiv = "";
            if (appGroupStr.equals("Head")){
                whereDiv = PstDivision.fieldNames[PstDivision.FLD_COMPANY_ID]+"="+companyId;
                whereDiv += " AND "+PstDivision.fieldNames[PstDivision.FLD_DIVISION_ID]+"="+diviAppUser;
            }
            if (appGroupStr.equals("Direksi")){
                whereDiv = PstDivision.fieldNames[PstDivision.FLD_COMPANY_ID]+"="+companyId;
            }
            
            whereDiv += " AND "+PstDivision.fieldNames[PstDivision.FLD_VALID_STATUS]+"="+PstDivision.VALID_ACTIVE;
            Vector listDivision = PstDivision.list(0, 0, whereDiv, PstDivision.fieldNames[PstDivision.FLD_DIVISION]);
            if (listDivision != null && listDivision.size()>0){
                for(int i=0; i<listDivision.size(); i++){
                    Division divisi = (Division)listDivision.get(i);
                    if (divisionId == divisi.getOID()){
                        %><option selected="selected" value="<%=divisi.getOID()%>"><%=divisi.getDivision()%></option><%
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
        <input type="hidden" name="<%=frmDivision%>" id="division" value="<%=divisionId%>" />
        <%
    }
    %>
</div>

<div class="caption">
    <%=dictionaryD.getWord(I_Dictionary.DEPARTMENT)%>
</div>
<div class="divinput">
    <select name="<%=frmDepartment%>" id="department" onchange="javascript:loadSection('<%=companyId%>','<%=divisionId%>',this.value, <%=strFieldNames%>)">
        <option value="0">-select-</option>
        <%
        if (divisionId != 0){
            Vector listDepart = PstDepartment.listDepartmentVer1(0, 0, String.valueOf(companyId) , String.valueOf(divisionId));
            if (listDepart != null && listDepart.size()>0){
                for(int i=0; i<listDepart.size(); i++){
                    Department depart = (Department)listDepart.get(i);
                    if (departmentId == depart.getOID()){
                        %><option selected="selected" value="<%=depart.getOID()%>"><%=depart.getDepartment()%></option><%
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
        if (departmentId != 0){
            String whereSection = PstSection.fieldNames[PstSection.FLD_DEPARTMENT_ID]+"="+departmentId;
            Vector listSection = PstSection.list(0, 0, whereSection, PstSection.fieldNames[PstSection.FLD_SECTION]);

            if (listSection != null && listSection.size()>0){
                for(int i=0; i<listSection.size(); i++){
                    Section section = (Section)listSection.get(i);
                    if (sectionId == section.getOID()){
                        %><option selected="selected" value="<%=section.getOID()%>"><%=section.getSection()%></option><%
                    } else {
                        %><option value="<%=section.getOID()%>"><%=section.getSection()%></option><%
                    }
                }
            }

        }        
        %>
    </select>
</div>
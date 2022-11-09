<%-- 
    Document   : doc_flow_ajax.jsp
    Created on : 11-Feb-2017, 10:13:48
    Author     : Gunadi
--%>
<%@page import="com.dimata.harisma.form.masterdata.FrmDocMasterFlow"%>
<%@page import="com.dimata.harisma.form.masterdata.FrmEmpDocFlow"%>
<%@ include file = "../main/javainit.jsp" %>
<% int  appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_MASTERDATA, AppObjInfo.G2_MD_PERFORMANCE_APPRAISAL, AppObjInfo.OBJ_GROUP_RANK); %>
<%@ include file = "../main/checkuser.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String filterBy = FRMQueryString.requestString(request, "filter_by");
    
    /* value of structure */
    long companyId = FRMQueryString.requestLong(request, "company_id");
    long divisionId = FRMQueryString.requestLong(request, "division_id");
    long departmentId = FRMQueryString.requestLong(request, "department_id");
    long sectionId = FRMQueryString.requestLong(request, "section_id");
    long docMasterFlowId = FRMQueryString.requestLong(request, "oid");
    /* Name of form input */
    String frmCompany = FRMQueryString.requestString(request, "frm_company");
    String frmDivision = FRMQueryString.requestString(request, "frm_division");
    String frmDepartment = FRMQueryString.requestString(request, "frm_department");
    String frmSection = FRMQueryString.requestString(request, "frm_section");
    String strFieldNames  = "'"+frmCompany+"',";
           strFieldNames += "'"+frmDivision+"',";
           strFieldNames += "'"+frmDepartment+"',";
           strFieldNames += "'"+frmSection+"'";
           
    DocMasterFlow docMasterFlow = new DocMasterFlow();       
    if (docMasterFlowId > 0){
        try {
            docMasterFlow = PstDocMasterFlow.fetchExc(docMasterFlowId);
        } catch (Exception exc){
            System.out.println(exc.toString());
        }
    }       
    
    Employee emp = new Employee();
    try {
        emp = PstEmployee.fetchExc(docMasterFlow.getEmployee_id());
    } catch (Exception exc){}
           
%>
    
<%
    if (filterBy.equals("1") || filterBy.equals("2") || filterBy.equals("3")){
%>
    <div id="caption">
        <%=dictionaryD.getWord(I_Dictionary.COMPANY)%>
    </div>
    <div id="divinput">
        <select name="<%= FrmDocMasterFlow.fieldNames[FrmDocMasterFlow.FRM_FIELD_COMPANY_ID] %>" id="company" class="chosen-select" onchange="javascript:loadDivision(this.value, <%=strFieldNames%>, <%=filterBy%>)" >
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
    </div> 
<%
    } if (filterBy.equals("2") || filterBy.equals("3")){
%>
    <div id="caption">
        <%=dictionaryD.getWord(I_Dictionary.DIVISION)%>
    </div>
    <div id="divinput">
        <select name="<%= FrmDocMasterFlow.fieldNames[FrmDocMasterFlow.FRM_FIELD_DIVISION_ID] %>" id="division" class="chosen-select" onchange="javascript:loadDepartment('<%=companyId%>', this.value, <%=strFieldNames%>, <%=filterBy%>)">
            <option value="0">-select-</option>
            <%
            if(companyId != 0){
                String whereDiv = "";
                whereDiv = PstDivision.fieldNames[PstDivision.FLD_COMPANY_ID]+"="+companyId;
                
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
    </div>
<%
  } if (filterBy.equals("3")){
%>
    <div id="caption">
        <%=dictionaryD.getWord(I_Dictionary.DEPARTMENT)%>
    </div>
    <div id="divinput">
        <select name="<%= FrmDocMasterFlow.fieldNames[FrmDocMasterFlow.FRM_FIELD_DEPARTMENT_ID] %>" id="department" class="chosen-select" onchange="javascript:loadSection('<%=companyId%>','<%=divisionId%>',this.value, <%=strFieldNames%>)">
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
<%
   } if (filterBy.equals("4")){
%>
    <div id="caption">
        <%=dictionaryD.getWord(I_Dictionary.LEVEL)%>
    </div>
    <div id="divinput">
        <select name="<%= FrmDocMasterFlow.fieldNames[FrmDocMasterFlow.FRM_FIELD_LEVEL_ID] %>" id="level" class="chosen-select" >
            <option value="0">-select-</option>
            <%
            Vector listLevel = PstLevel.list(0, 0, "" , "");
            if (listLevel != null && listLevel.size()>0){
                for(int i=0; i<listLevel.size(); i++){
                    Level level = (Level)listLevel.get(i);
                    if (docMasterFlow.getLevel_id() == level.getOID()){
                        %><option selected="selected" value="<%=level.getOID()%>"><%=level.getLevel()%></option><%
                    } else {
                        %><option value="<%=level.getOID()%>"><%=level.getLevel()%></option><%
                    }
                }
            }
            %>
        </select>
    </div>
<%
   } if (filterBy.equals("5")){
%>
    <div id="caption">
        <%=dictionaryD.getWord(I_Dictionary.POSITION)%>
    </div>
    <div id="divinput">
        <select name="<%= FrmDocMasterFlow.fieldNames[FrmDocMasterFlow.FRM_FIELD_POSITION_ID] %>" id="position" class="chosen-select" >
            <option value="0">-select-</option>
            <%
            Vector listPosition = PstPosition.list(0, 0, "" , "POSITION");
            if (listPosition != null && listPosition.size()>0){
                for(int i=0; i<listPosition.size(); i++){
                    Position position = (Position)listPosition.get(i);
                    if (docMasterFlow.getPosition_id() == position.getOID()){
                        %><option selected="selected" value="<%=position.getOID()%>"><%=position.getPosition()%></option><%
                    } else {
                        %><option value="<%=position.getOID()%>"><%=position.getPosition()%></option><%
                    }
                }
            }
            %>
        </select>
    </div>
<%     
   } if (filterBy.equals("6")){
%>
    <div id="caption">
        <%=dictionaryD.getWord(I_Dictionary.EMPLOYEE)%>
    </div>
    <div id="divinput">
        <table>
            <tr>
                <td>
                    <input type="text" name="EMP_FULLNAME" value="<%= !(emp.getFullName().equals("")) ? emp.getFullName() : ""  %>"> <input type="hidden" name="<%=FrmDocMasterFlow.fieldNames[FrmDocMasterFlow.FRM_FIELD_EMPLOYEE_ID]%>" value="<%= docMasterFlow.getEmployee_id() > 0 ? docMasterFlow.getEmployee_id() : ""  %>>" class="formElemen">                    
                </td>
                <td>
                    <a href="javascript:cmdSearchEmp()" ><img name="Image10x" border="0" src="<%=approot%>/images/icon/folder.gif" width="24" height="24" alt="Search Employee"></a>
                </td>
            </tr>
        </table>
    </div>
<%
   }
%>


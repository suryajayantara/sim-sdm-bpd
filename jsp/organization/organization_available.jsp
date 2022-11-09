<%-- 
    Document   : organization_available
    Created on : Oct 27, 2016, 10:14:03 AM
    Author     : Dimata 007
--%>
<%@ include file = "../main/javainit.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%!
    public String getStructureTemplateName(long oid){
        String name = "-";
        if (oid != 0){
            try {
                StructureTemplate tmpName = PstStructureTemplate.fetchExc(oid);
                name = tmpName.getTemplateName();
            } catch(Exception e){
                System.out.println("structure name=>"+e.toString());
            }
        }
        return name;
    }
%>
<%
    long selectStructure = FRMQueryString.requestLong(request, "select_structure");
    String structureName = getStructureTemplateName(selectStructure);
    StructureModule structureModule = new StructureModule();
    long companyId = 0;
    Vector listCompany = PstCompany.list(0, 0, "", "");
    if (listCompany != null && listCompany.size()>0){
        Company comp = (Company)listCompany.get(0);
        companyId = comp.getOID();
    }
    long divisionId = FRMQueryString.requestLong(request, "division_id");
    long departmentId = FRMQueryString.requestLong(request, "department_id");
    long sectionId = FRMQueryString.requestLong(request, "section_id");
    String whereClause = "";
    I_Dictionary dictionaryD = userSession.getUserDictionary();
    /* Get Division from OrgMapDivision */
    whereClause = PstOrgMapDivision.fieldNames[PstOrgMapDivision.FLD_TEMPLATE_ID]+"="+selectStructure;
    Vector listOrgMapDivision = PstOrgMapDivision.list(0, 0, whereClause, "");
    whereClause = PstOrgMapDepartment.fieldNames[PstOrgMapDepartment.FLD_TEMPLATE_ID]+"="+selectStructure;
    Vector listOrgMapDepartment = PstOrgMapDepartment.list(0, 0, whereClause, "");
    whereClause = PstOrgMapSection.fieldNames[PstOrgMapSection.FLD_TEMPLATE_ID]+"="+selectStructure;
    Vector listOrgMapSection = PstOrgMapSection.list(0, 0, whereClause, "");
    if (selectStructure != 0){
        %>
        <table cellpadding="5" cellspacing="5">
            <tr>
                <td colspan="3" valign="top">
                    <div class="tips">
                        <table>
                            <tr>
                                <td style="padding-right: 9px"><img width="16" src="<%=approot%>/images/tips.png" /></td>
                                <td><strong>Tips:</strong> Anda bisa klik nama divisi, department, atau section yang tampil <br />untuk menampilkan struktur organisasi</td>
                            </tr>
                        </table>
                    </div>
                </td>
            </tr>
            <tr>
                <td colspan="3" valign="top">
                    <div id="note">
                        Struktur Organisasi <%=structureName%> 
                    </div>
                </td>
            </tr>
        </table>
        <table cellpadding="5" cellspacing="5">
            <tr>
                <td valign="top">
                    <div class="box">
                        <div class="caption">
                            Daftar Struktur Organisasi tersedia
                        </div>
                        <% if (listOrgMapDivision != null && listOrgMapDivision.size()>0){ %>
                        <table cellspacing="0" cellpadding="0" width="100%">
                            <%
                            if (!listOrgMapDivision.isEmpty()) {
                                %><tr><td><div style="padding-left: 7px; padding-top: 7px"><b>DIVISION :</b></div></td></tr><%
                            }
                            for(int i=0; i<listOrgMapDivision.size(); i++){
                                OrgMapDivision orgMapDiv = (OrgMapDivision)listOrgMapDivision.get(i);
                                %>
                                <tr><td><div class="box-item" onclick="javascript:cmdViewByDiv('<%=selectStructure%>','<%= orgMapDiv.getDivisionId() %>')"><%=structureModule.getDivisionName(orgMapDiv.getDivisionId())%></div></td></tr>
                                <%
                            }
                            %>
                        </table>
                        <% } %>
                        
                        <% if (listOrgMapDepartment != null && listOrgMapDepartment.size()>0){ %>
                        <table cellspacing="0" cellpadding="0" width="100%">
                            <%
                            if (!listOrgMapDepartment.isEmpty()) {
                                %><tr><td><div style="padding-left: 7px; padding-top: 7px"><b>DEPARTMENT :</b></div></td></tr><%
                            }
                            for(int i=0; i<listOrgMapDepartment.size(); i++){
                                OrgMapDepartment orgMapDept = (OrgMapDepartment)listOrgMapDepartment.get(i);
                                %>
                                <tr><td><div class="box-item" onclick="javascript:cmdViewByDept('<%=selectStructure%>','<%= orgMapDept.getDepartmentId() %>')"><%= structureModule.getDepartmentName(orgMapDept.getDepartmentId()) %></div></td></tr>
                                <%
                            }
                            %>
                        </table>
                        <% } %>
                        
                        <% if (listOrgMapSection != null && listOrgMapSection.size()>0){ %>
                        <table cellspacing="0" cellpadding="0" width="100%">
                            <%
                            if (!listOrgMapSection.isEmpty()) {
                                %><tr><td><div style="padding-left: 7px; padding-top: 7px"><b>SECTION :</b></div></td></tr><%
                            }
                            for(int i=0; i<listOrgMapSection.size(); i++){
                                OrgMapSection orgMapSect = (OrgMapSection)listOrgMapSection.get(i);
                                %>
                                <tr><td><div class="box-item" onclick="javascript:cmdViewBySect('<%=selectStructure%>','<%= orgMapSect.getSectionId() %>')"><%= structureModule.getSectionName(orgMapSect.getSectionId()) %></div></td></tr>
                                <%
                            }
                            %>
                        </table>
                        <% } %>
                    </div>
                </td>
            </tr>
        </table>
        <%
    }        
%>
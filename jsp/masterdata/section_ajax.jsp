<%-- 
    Document   : section_ajax
    Created on : 23-Apr-2016, 09:19:01
    Author     : Acer
--%>
<%@page import="com.dimata.util.Command"%>
<%@page import="com.dimata.harisma.form.masterdata.CtrlSection"%>
<%@ include file = "../main/javainit.jsp" %>
<% int  appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_MASTERDATA, AppObjInfo.G2_MD_COMPANY, AppObjInfo.OBJ_SECTION); %>
<%@ include file = "../main/checkuser.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
  String sectionName = FRMQueryString.requestString(request, "section_name");
  long departmentId = FRMQueryString.requestLong(request, "department_id");
  String valid_status_select = FRMQueryString.requestString(request, "valid_status_select");
  
  String test = "default";
  int iCommand = FRMQueryString.requestInt(request, "command");
  int start = FRMQueryString.requestInt(request, "start");
  
  String whereClause = "";
  String order = PstSection.fieldNames[PstSection.FLD_SECTION];
  
  Vector listSection = new Vector();
  CtrlSection ctrlSection = new CtrlSection(request);
  
  int recordToGet = 10;
    int vectSize = 0;
    
   if ((valid_status_select.equals("0"))){
    valid_status_select="'0'" ;
    }else if((valid_status_select.equals("1"))) {
    valid_status_select="'1'" ;
    }else{
    valid_status_select="'1' OR '2'" ;   
    }
    
    if (!(sectionName.equals("0")) && departmentId == 0){
        test = "Searching By Section Name";
    }
    
    if (sectionName.equals("0") && departmentId != 0){
        test = "Searching By Division";
        String strIN = "0";
        whereClause = PstSection.fieldNames[PstSection.FLD_DEPARTMENT_ID]+"="+departmentId+" AND "+PstSection.fieldNames[PstSection.FLD_VALID_STATUS] +" LIKE "+valid_status_select+"";
    }
    
    if ((sectionName.equals("0") || sectionName.equals("")) &&  departmentId == 0){
        whereClause = PstSection.fieldNames[PstSection.FLD_VALID_STATUS] +" LIKE "+valid_status_select+"";
        test = "Show All Without Filter";
        
    }

    vectSize = PstSection.getCount(whereClause);
    if ((iCommand == Command.FIRST) || (iCommand == Command.NEXT) || (iCommand == Command.PREV)
            || (iCommand == Command.LAST) || (iCommand == Command.LIST)) {
        start = ctrlSection.actionList(iCommand, start, vectSize, recordToGet);
    }
    
    listSection = PstSection.list(start, recordToGet, whereClause, order);
if (listSection != null && listSection.size()>0){
        %>
        <div style="color:#575757; font-size: 13px; padding: 7px 11px; border-left: 1px solid #007592; margin: 7px 0px; background-color: #FFF;"><%=test%></div>
        <table class="tblStyle">
            <tr>
                <td class="title_tbl" style="background-color: #DDD;">No</td>
                <td class="title_tbl" style="background-color: #DDD;">Section</td>
                <td class="title_tbl" style="background-color: #DDD;">Department</td>
                <td class="title_tbl" style="background-color: #DDD;">Description</td>
                <td class="title_tbl" style="background-color: #DDD;">Section Link</td>
                <td class="title_tbl" style="background-color: #DDD;">Valid Status</td>
                <td class="title_tbl" style="background-color: #DDD;">Action</td>
           </tr>
        <%
        for(int i=0; i<listSection.size(); i++){
            Section section = (Section)listSection.get(i);
            %>
            <tr>
                <td><%= (i+1)+start %></td>
                <td><%= section.getSection()%></td>
                <td>
                    <%
                    String strDept = "-";
                    try {
                        Department dept = PstDepartment.fetchExc(section.getDepartmentId());
                        strDept = dept.getDepartment();
                    } catch(Exception e){
                        System.out.println(""+e.toString());
                    }
                    %>
                    <%= strDept %>
                </td>
                <td><%= section.getDescription() %></td>
                
                <% if(section.getSectionLinkTo() == null){ %>
                <td></td>
                <% } else { %>
                <td> <%= section.getSectionLinkTo() %> </td>
                <% } %>
                <td><%= PstSection.validStatusValue[section.getValidStatus()] %></td>
                <td>
                    <a class="btn-small-e" style="color:#FFF" href="javascript:cmdEdit('<%=section.getOID()%>')">e</a>
                    <a class="btn-small-x" style="color:#FFF" href="javascript:cmdAsk('<%=section.getOID()%>')">&times;</a>
                </td>
                
            </tr>
            <%
        }
        %>
        </table>
        
        <div>&nbsp;</div>
        <div id="record_count">
            <%
            if (vectSize >= recordToGet){
                %>
                List : <%=start+1%> &HorizontalLine; <%= (start+listSection.size()) %> | 
                <%
            }
            %>
            Total : <%= vectSize %>
        </div>
        <div class="pagging">
            <a style="color:#F5F5F5" href="javascript:cmdListFirst('<%=start%>')" class="btn-small">First</a>
            <a style="color:#F5F5F5" href="javascript:cmdListPrev('<%=start%>')" class="btn-small">Previous</a>
            <a style="color:#F5F5F5" href="javascript:cmdListNext('<%=start%>')" class="btn-small">Next</a>
            <a style="color:#F5F5F5" href="javascript:cmdListLast('<%=start%>')" class="btn-small">Last</a>
        </div>
        <%
    }
%>
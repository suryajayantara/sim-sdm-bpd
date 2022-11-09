<%-- 
    Document   : division_ajax
    Created on : Jan 7, 2016, 1:44:18 PM
    Author     : Dimata 007
--%>
<%@page import="com.dimata.harisma.entity.log.ChangeValue"%>
<%@page import="com.dimata.util.Command"%>
<%@page import="com.dimata.harisma.entity.admin.AppObjInfo"%>
<%@ include file = "../../main/javainit.jsp" %>
<% int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_MASTERDATA, AppObjInfo.G2_MD_COMPANY, AppObjInfo.OBJ_DIVISION);%>
<%@ include file = "../../main/checkuser.jsp" %>
<%@ page import ="java.util.*,
                  java.text.*,				  
                  com.dimata.qdep.form.*,				  
                  com.dimata.gui.jsp.*,
                  com.dimata.util.*,				  
                  com.dimata.harisma.entity.masterdata.*,				  				  
                  com.dimata.harisma.entity.employee.*,
                  com.dimata.harisma.entity.attendance.*,
                  com.dimata.harisma.entity.search.*,
                  com.dimata.harisma.form.masterdata.*,				  				  
                  com.dimata.harisma.form.attendance.*,
                  com.dimata.harisma.form.search.*,				  
                  com.dimata.harisma.session.attendance.*,
                  com.dimata.harisma.session.leave.SessLeaveApp,
                  com.dimata.harisma.session.leave.*,
                  com.dimata.harisma.session.attendance.SessLeaveManagement,
                  com.dimata.harisma.session.leave.RepItemLeaveAndDp"%>
<%@page contentType="application/x-msexcel" pageEncoding="UTF-8"%>
<%
    response.setHeader("Content-Disposition","attachment;filename= Sub_Unit_(Section).xls");
    String sectionName = FRMQueryString.requestString(request, "section_name");
  long departmentId = FRMQueryString.requestLong(request, "department_id");
  String valid_status_select = FRMQueryString.requestString(request, "valid_status_select");
  
  String test = "default";
  int iCommand = FRMQueryString.requestInt(request, "command");
  int start = FRMQueryString.requestInt(request, "start");
  
  String whereClause = "";
  String order = "";
  
  Vector listSection = new Vector();
  CtrlSection ctrlSection = new CtrlSection(request);
  
  int recordToGet = 0;
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
        whereClause = PstSection.fieldNames[PstSection.FLD_SECTION]+" LIKE '%"+sectionName+"%' AND "+PstSection.fieldNames[PstSection.FLD_VALID_STATUS] +" LIKE "+valid_status_select+"";
        order = PstSection.fieldNames[PstSection.FLD_SECTION];
        vectSize = PstSection.getCount(whereClause);
        listSection = PstSection.list(start, recordToGet, whereClause, order);
    }
    
    if (sectionName.equals("0") && departmentId != 0){
        test = "Searching By Division";
        String strIN = "0";
        whereClause = PstSection.fieldNames[PstSection.FLD_DEPARTMENT_ID]+"="+departmentId+" AND "+PstSection.fieldNames[PstSection.FLD_VALID_STATUS] +" LIKE "+valid_status_select+"";
        order = PstSection.fieldNames[PstSection.FLD_SECTION];
        vectSize = PstSection.getCount(whereClause);
        listSection = PstSection.list(0, 0, whereClause, order);
    }
    
    if (sectionName.equals("0") &&  departmentId == 0){
        whereClause = PstSection.fieldNames[PstSection.FLD_VALID_STATUS] +" LIKE "+valid_status_select+"";
        test = "Show All With Filter Active";
        order = PstSection.fieldNames[PstSection.FLD_SECTION];
        vectSize = PstSection.getCount("");
        listSection = PstSection.list(start, recordToGet, whereClause, order);
    }

    
if (listSection != null && listSection.size()>0){
        %>
        <div style="color:#575757; font-size: 13px; padding: 7px 11px; border-left: 1px solid #007592; margin: 7px 0px; background-color: #FFF;"><%=test%></div>
        <table class="tblStyle" border="1">
            <tr>
                <th class="title_tbl" style="background-color: #DDD;">No</th>
                <th class="title_tbl" style="background-color: #DDD;">Section</th>
                <th class="title_tbl" style="background-color: #DDD;">Department</th>
                <th class="title_tbl" style="background-color: #DDD;">Description</th>
                <th class="title_tbl" style="background-color: #DDD;">Section Link</th>
                <th class="title_tbl" style="background-color: #DDD;">Valid Status</th>
           </tr>
        <%
        for(int i=0; i<listSection.size(); i++){
            Section section = (Section)listSection.get(i);
            %>
            <tr>
                <td><%= (i+1) %></td>
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
                
                
            </tr>
            <%
        }
        %>
        </table>
        
        <%
    }
%>
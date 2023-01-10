<%@page import="com.dimata.harisma.entity.employee.appraisal.AppraisalMain"%>
<%@page import="com.dimata.harisma.entity.employee.appraisal.PstAppraisalMain"%>
<%@page import="com.dimata.harisma.entity.employee.assessment.AssessmentFormLink"%>
<%@page import="java.util.Vector"%>
<%@page import="com.dimata.harisma.entity.employee.assessment.PstAssessmentFormMain"%>
<%@page import="com.dimata.harisma.entity.employee.assessment.AssessmentFormMain"%>
<%@page import="com.dimata.harisma.entity.employee.assessment.PstAssessmentFormLink"%>
<%@page import="com.dimata.qdep.form.FRMQueryString"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    long assFormMainId = FRMQueryString.requestLong(request, "assFormMainId");
    long empId = FRMQueryString.requestLong(request, "empId");
    AssessmentFormMain entAssessmentFormMain = PstAssessmentFormMain.fetchExc(assFormMainId);
    Vector vAssFormLink = new Vector();
    AssessmentFormLink entAssFormLink = new AssessmentFormLink();
%>
<%  
    if(entAssessmentFormMain.getPeriodeAppraisalMonth() >= 12){
%>
    <tr>
        <td colspan="2">
            <hr>
        </td>
    </tr>
    <tr>
        <td>
            <strong>Assessment Child :</strong>
        </td>    
    </tr>
<%
        vAssFormLink = PstAssessmentFormLink.list(0, 0, 
            "HR_ASS_FORM_MAIN_ID_PARENT = " + entAssessmentFormMain.getOID(), 
            "");
        if(vAssFormLink.size() > 0){
            for(int j = 0; j < vAssFormLink.size(); j++){
                entAssFormLink = (AssessmentFormLink)vAssFormLink.get(j);
                Vector vAppMain = PstAppraisalMain.list(0, 0, 
                        "ASS_FORM_MAIN_ID = "+entAssFormLink.getHrAssFormMainIdChild() + " AND EMPLOYEE_ID = " + empId, 
                        "DATA_PERIOD_FROM ASC");
                if(vAppMain.size() > 0){
                    for(int i = 0; i < vAppMain.size(); i++){
                        AppraisalMain entAppraisalMain = (AppraisalMain) vAppMain.get(i);
%>
                        <tr>
                            <td colspan="2"><%= i + 1 %>. Assessment date <strong><%= entAppraisalMain.getDateOfAssessment() %></strong> period <strong><%= entAppraisalMain.getDataPeriodFrom() %> - <%= entAppraisalMain.getDataPeriodTo() %></strong></td>    
                        </tr>
                 <% } %>
             <% } else { %>
                    <tr>
                        <td>Assessment child not found.</td>
                    </tr>
             <% } %>
         <% } %>
     <% } %>
 <% } %>

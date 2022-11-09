<%-- 
    Document   : export_excel_position_history
    Created on : 27-Nov-2017, 16:18:47
    Author     : Gunadi
--%>

<%@page import="com.dimata.util.Command"%>
<%@ include file = "../../../main/javainit.jsp" %>
<%
    response.setHeader("Content-Disposition","attachment; filename=riwayat_jabatan.xls ");
    int iCommand = FRMQueryString.requestCommand(request);
    int iErrCode = FRMMessage.NONE;
    int start = FRMQueryString.requestInt(request, "start");
   
    String[] arrCompany = FRMQueryString.requestStringValues(request, "companyId");
    String[] arrDivision = FRMQueryString.requestStringValues(request, "divisionId");
    String[] arrDepartment = FRMQueryString.requestStringValues(request, "departmentId");
    String[] arrSection = FRMQueryString.requestStringValues(request, "sectionId");
    String dtFrom = FRMQueryString.requestString(request, "dateFrom");
    String dtTo = FRMQueryString.requestString(request, "dateTo");
    long positionId = FRMQueryString.requestLong(request, "positionId");
    int historyType = FRMQueryString.requestInt(request, "historyType");
    
    Vector listEmployee = new Vector();
    if (iCommand == Command.LIST){
    
        Vector<String> whereCollectCareer = new Vector<String>();
        Vector<String> whereCollectEmp = new Vector<String>();
        String whereCareerPath = "";
        String whereEmployee = "";
        String inCompany = "";
        String inDivision = "";
        String inDepartment = "";
        String inSection = "";
        String where1 = "";
        String where2 = "";

        String currWorkFrom = "IF((((SELECT MAX(`hr_work_history_now`.`WORK_TO`) FROM "
                    + "`hr_work_history_now` WHERE ((`hr_work_history_now`.`EMPLOYEE_ID` = `emp`.`EMPLOYEE_ID`) "
                    + "AND (`hr_work_history_now`.`HISTORY_GROUP` <> 1) AND (`hr_work_history_now`.`HISTORY_TYPE` = 0))) "
                    + "+ INTERVAL 1 DAY ) IS NOT NULL),((SELECT MAX(`hr_work_history_now`.`WORK_TO`) FROM `hr_work_history_now` "
                    + "WHERE ((`hr_work_history_now`.`EMPLOYEE_ID` = `emp`.`EMPLOYEE_ID`) AND (`hr_work_history_now`.`HISTORY_GROUP` <> 1) "
                    + "AND (`hr_work_history_now`.`HISTORY_TYPE` = 0))) + INTERVAL 1 DAY),`emp`.`COMMENCING_DATE`)";
        
        
        
        whereCareerPath = " (`whn`."+PstCareerPath.fieldNames[PstCareerPath.FLD_WORK_FROM]+" BETWEEN '" + dtFrom +"' AND '" + dtTo + "' "
                          + "OR `whn`."+PstCareerPath.fieldNames[PstCareerPath.FLD_WORK_FROM]+" BETWEEN '"+ dtFrom +"' AND '" + dtTo+"' "
                          + "OR '"+dtFrom+"' BETWEEN `whn`."+PstCareerPath.fieldNames[PstCareerPath.FLD_WORK_FROM]+" AND `whn`."+PstCareerPath.fieldNames[PstCareerPath.FLD_WORK_TO]+" "
                          + "OR '"+dtTo+"' BETWEEN `whn`."+PstCareerPath.fieldNames[PstCareerPath.FLD_WORK_FROM]+" AND `whn`."+PstCareerPath.fieldNames[PstCareerPath.FLD_WORK_TO]+" ) ";
        whereEmployee = "("+currWorkFrom+" BETWEEN '"+ dtFrom +"' AND '" + dtTo + "' OR CURDATE()"
                        +" BETWEEN '"+ dtFrom +"' AND '" + dtTo+"' OR "
                        + "'"+ dtFrom +"' BETWEEN "+currWorkFrom+" AND CURDATE() OR "
                        + "'"+ dtTo +"' BETWEEN "+currWorkFrom+" AND CURDATE())";

        if (arrCompany != null){
            for (int i=0; i < arrCompany.length; i++){
                inCompany = inCompany + ","+ arrCompany[i];
            }
            inCompany = inCompany.substring(1);
            where1 = "`whn`."+PstCareerPath.fieldNames[PstCareerPath.FLD_COMPANY_ID]+" IN ("+inCompany+")";
            where2 = "`emp`."+PstEmployee.fieldNames[PstEmployee.FLD_COMPANY_ID]+" IN ("+inCompany+")";
            whereCollectCareer.add(where1);
            whereCollectEmp.add(where2);
        }
        if (arrDivision != null){
            for (int i=0; i < arrDivision.length; i++){
                inDivision = inDivision + ","+ arrDivision[i];
            }
            inDivision = inDivision.substring(1);
            where1 = "`whn`."+PstCareerPath.fieldNames[PstCareerPath.FLD_DIVISION_ID]+" IN ("+inDivision+")";
            where2 = "`emp`."+PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID]+" IN ("+inDivision+")";
            whereCollectCareer.add(where1);
            whereCollectEmp.add(where2);
        }
        if (arrDepartment != null){
            for (int i=0; i < arrDepartment.length; i++){
                inDepartment = inDepartment + ","+ arrDepartment[i];
            }
            inDepartment = inDepartment.substring(1);
            where1 = "`whn`."+PstCareerPath.fieldNames[PstCareerPath.FLD_DEPARTMENT_ID]+" IN ("+inDepartment+")";
            where2 = "`emp`."+PstEmployee.fieldNames[PstEmployee.FLD_DEPARTMENT_ID]+" IN ("+inDepartment+")";
            whereCollectCareer.add(where1);
            whereCollectEmp.add(where2);        
        }
        if (arrSection != null){
            for (int i=0; i < arrSection.length; i++){
                inSection = inSection + ","+ arrSection[i];
            }
            inSection = inSection.substring(1);
            where1 = "`whn`."+PstCareerPath.fieldNames[PstCareerPath.FLD_SECTION_ID]+" IN ("+inSection+")";
            where2 = "`emp`."+PstEmployee.fieldNames[PstEmployee.FLD_SECTION_ID]+" IN ("+inSection+")";
            whereCollectCareer.add(where1);
            whereCollectEmp.add(where2);        
        }
        
        if (positionId != 0){
            where1 = "`whn`."+PstCareerPath.fieldNames[PstCareerPath.FLD_POSITION_ID]+" = "+positionId;
            where2 = "`emp`."+PstEmployee.fieldNames[PstEmployee.FLD_POSITION_ID]+" = "+positionId;
            whereCollectCareer.add(where1);
            whereCollectEmp.add(where2);   
        }
        
        if (historyType != 4){
            where1 = "`whn`."+PstCareerPath.fieldNames[PstCareerPath.FLD_HISTORY_TYPE]+" = "+historyType;
            where2 = "`emp`."+PstEmployee.fieldNames[PstEmployee.FLD_HISTORY_TYPE]+" = "+historyType;
            whereCollectCareer.add(where1);
            whereCollectEmp.add(where2);   
        }

        if (whereCollectCareer != null && whereCollectCareer.size()>0){
            whereCareerPath = whereCareerPath + " AND ";
            for (int i=0; i<whereCollectCareer.size(); i++){
                String where = (String)whereCollectCareer.get(i);
                whereCareerPath += where;
                if (i < (whereCollectCareer.size()-1)){
                     whereCareerPath += " AND ";
                }
            }
        }

        if (whereCollectEmp != null && whereCollectEmp.size()>0){
            whereEmployee = whereEmployee + " AND ";
            for (int i=0; i<whereCollectEmp.size(); i++){
                String where = (String)whereCollectEmp.get(i);
                whereEmployee += where;
                if (i < (whereCollectEmp.size()-1)){
                     whereEmployee += " AND ";
                }
            }
        }
        
        listEmployee = PstCareerPath.getPositionHistory(whereCareerPath, whereEmployee);
    }
%>
<%@page contentType="application/vnd.ms-excel" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    </head>
    <body>
        <%
        if (listEmployee.size() > 0){
            %>
            <table border="1" width="100%">
                <tr>
                    <td class="title_tbl" style="text-align:center; vertical-align:middle"><strong>No</strong></td>
                    <td class="title_tbl" style="text-align:center; vertical-align:middle"><strong>NRK</strong></td>
                    <td class="title_tbl" style="text-align:center; vertical-align:middle"><strong>Nama</strong></td>
                    <td class="title_tbl" style="text-align:center; vertical-align:middle"><strong>Satuan Kerja</strong></td>
                    <td class="title_tbl" style="text-align:center; vertical-align:middle"><strong>Jabatan</strong></td>
                    <td class="title_tbl" style="text-align:center; vertical-align:middle"><strong>Level</strong></td>
                    <td class="title_tbl" style="text-align:center; vertical-align:middle"><strong>Tingkat</strong></td>
                    <td class="title_tbl" style="text-align:center; vertical-align:middle"><strong>Tipe Riwayat</strong></td>
                    <td class="title_tbl" style="text-align:center; vertical-align:middle"><strong>Menjabat Dari</strong></td>
                    <td class="title_tbl" style="text-align:center; vertical-align:middle"><strong>Menjabat Sampai</strong></td>
                </tr>
            <%
            for (int i=0; i<listEmployee.size();i++){
                CareerPath career = (CareerPath) listEmployee.get(i);
                String bgColor = "";
                if((i%2)==0){
                    bgColor = "#FFF";
                } else {
                    bgColor = "#F9F9F9";
                }
                
                String strGrade = "-";
                            
                GradeLevel grade = new GradeLevel();
                try {
                    grade = PstGradeLevel.fetchExc(career.getGradeLevelId());
                    strGrade = grade.getCodeLevel();
                } catch (Exception exc){

                }

                %>
                    <tr>
                        <td style="background-color: <%=bgColor%>;"><%=""+ (i+1)%></td>
                        <td style="background-color: <%=bgColor%>;">="<%=PstEmployee.getEmployeeNumber(career.getEmployeeId())%>"</td>
                        <td style="background-color: <%=bgColor%>;"><%=PstEmployee.getEmployeeName(career.getEmployeeId())%></td>
                        <td style="background-color: <%=bgColor%>;"><%=PstEmployee.getDivisionName(career.getDivisionId())%></td>
                        <td style="background-color: <%=bgColor%>;"><%=PstEmployee.getPositionName(career.getPositionId())%></td>
                        <td style="background-color: <%=bgColor%>;"><%=PstEmployee.getLevelName(career.getLevelId())%></td>
                        <td style="background-color: <%=bgColor%>;"><%=strGrade%></td>
                        <td style="background-color: <%=bgColor%>;"><%=PstCareerPath.historyType[career.getHistoryType()]%></td>
                        <td style="background-color: <%=bgColor%>;"><%=career.getWorkFrom()%></td>
                        <td style="background-color: <%=bgColor%>;"><%=career.getWorkTo()%></td>
                    </tr>
                <%
            }
            %>
            </table>
            <%
        }
    %>
    </body>
</html>

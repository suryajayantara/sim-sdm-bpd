<%-- 
    Document   : candidate_detail
    Created on : Sep 30, 2016, 12:00:18 PM
    Author     : Dimata 007
--%>
<%@page import="com.dimata.util.Formater"%>
<%@page import="com.dimata.harisma.entity.log.ChangeValue"%>
<%@page import="com.dimata.harisma.session.employee.SessEmployeePicture"%>
<%@ include file = "../../main/javainit.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%!
    public String getCompetencyName(long oid){
        String str = "";
        try {
            Competency competency = PstCompetency.fetchExc(oid);
            str = competency.getCompetencyName();
        } catch(Exception e){
            System.out.println(""+e.toString());
        }
        return str;
    }
    public String getTrainingName(long oid){
        String str = "";
        try {
            Training training = PstTraining.fetchExc(oid);
            str = training.getName();
        } catch(Exception e){
            System.out.println(""+e.toString());
        }
        return str;
    }
    public String getEducationName(long oid){
        String str = "";
        try {
            Education edu = PstEducation.fetchExc(oid);
            str = edu.getEducation();
        } catch(Exception e){
            System.out.println(""+e.toString());
        }
        return str;
    }
    
    public float getCompetencyEmp(long oidEmp, long oidComp){
        float result = 0;
        Vector compEmpList = new Vector();
        String whereClause = PstEmployeeCompetency.fieldNames[PstEmployeeCompetency.FLD_COMPETENCY_ID]+"="+oidComp;
        whereClause += " AND "+PstEmployeeCompetency.fieldNames[PstEmployeeCompetency.FLD_EMPLOYEE_ID]+"="+oidEmp;
        compEmpList = PstEmployeeCompetency.list(0, 0, whereClause, "");
        if (compEmpList != null && compEmpList.size()>0){
            EmployeeCompetency empComp = (EmployeeCompetency)compEmpList.get(0);
            result = empComp.getLevelValue();
        }
        return result;
    }
    
    
    public double getTrainingEmp(long oidEmp, long oidTrain){
        double value = 0;
        Vector trainEmpList = new Vector();
        String whereClause = PstTrainingHistory.fieldNames[PstTrainingHistory.FLD_EMPLOYEE_ID]+"="+oidEmp;
        whereClause += " AND "+ PstTrainingHistory.fieldNames[PstTrainingHistory.FLD_TRAINING_ID]+"="+oidTrain;
        trainEmpList = PstTrainingHistory.list(0, 0, whereClause, "" + PstTrainingHistory.fieldNames[PstTrainingHistory.FLD_END_DATE] + " DESC " );
        if (trainEmpList != null && trainEmpList.size()>0){
            TrainingHistory tHistory = (TrainingHistory)trainEmpList.get(0);
            value = tHistory.getPoint();
        }
        return value;
    }
    
    
    

    public float getEducationEmp(long oidEmp, long oidEdu){
        float value = 0;
        Vector eduEmpList = new Vector();
        String whereClause = PstEmpEducation.fieldNames[PstEmpEducation.FLD_EDUCATION_ID]+"="+oidEdu;
        whereClause += " AND "+PstEmpEducation.fieldNames[PstEmpEducation.FLD_EMPLOYEE_ID]+"="+oidEmp;
        eduEmpList = PstEmpEducation.list(0, 0, whereClause, "");
        if (eduEmpList != null && eduEmpList.size()>0){
            EmpEducation empEdu = (EmpEducation)eduEmpList.get(0);
            value = empEdu.getPoint();
        }
        return value;
    }
    
    
    public static float getEducationScore(long oidEdu,float point){
        float score =0;
        String where = ""+ oidEdu + "="+ PstEducationScore.fieldNames[PstEducationScore.FLD_EDUCATION_ID] + " AND ("+ PstEducationScore.fieldNames[PstEducationScore.FLD_POINT_MIN] + "<=" + point + " ) AND " +
                       "("+ PstEducationScore.fieldNames[PstEducationScore.FLD_POINT_MAX] + ">=" + point + " ) " ;
        String order = PstEducationScore.fieldNames[PstEducationScore.FLD_SCORE] ;               
        Vector vScore =  PstEducationScore.list(0, 1, where ,  order);
        return (vScore==null || vScore.size()<1 ? 0: ((EducationScore)vScore.get(0)).getScore());
    }
%>
<%
    int iCommand = FRMQueryString.requestCommand(request);
    long employeeId = FRMQueryString.requestLong(request, "employee_id");
    long positionId = FRMQueryString.requestLong(request, "position_id");
    String whereClause = "";
    ChangeValue changeValue = new ChangeValue();
    Employee employee = new Employee();
    try {
        employee = PstEmployee.fetchExc(employeeId);
    } catch(Exception e){
        System.out.print(""+e.toString());
    }
    /* Data Training */
   // whereClause = PstTrainingHistory.fieldNames[PstTrainingHistory.FLD_EMPLOYEE_ID]+"="+employeeId;
    //Vector trainingEmpList = PstTrainingHistory.list(0, 0, whereClause, "");
    /* Data Education */
    //whereClause = PstEmpEducation.fieldNames[PstEmpEducation.FLD_EMPLOYEE_ID]+"="+employeeId;
    //Vector educationEmpList = PstEmpEducation.list(0, 0, whereClause, "");
    /* Data Competency */
   // whereClause = PstEmployeeCompetency.fieldNames[PstEmployeeCompetency.FLD_EMPLOYEE_ID]+"="+employeeId;
    //Vector compEmpList = PstEmployeeCompetency.list(0, 0, whereClause, "");
    
    /* All about Position Data */
    /* training required */
    whereClause = PstPositionTrainingRequired.fieldNames[PstPositionTrainingRequired.FLD_POSITION_ID]+"="+positionId;
    Vector listTrainingReq = PstPositionTrainingRequired.list(0, 0, whereClause, "");
    /* education required */
    whereClause = PstPositionEducationRequired.fieldNames[PstPositionEducationRequired.FLD_POSITION_ID]+"="+positionId;
    Vector listEducationReq = PstPositionEducationRequired.list(0, 0, whereClause, "");
    /* competency required */
    whereClause = PstPositionCompetencyRequired.fieldNames[PstPositionCompetencyRequired.FLD_POSITION_ID]+"="+positionId;
    Vector listCompetencyReq = PstPositionCompetencyRequired.list(0, 0, whereClause, ""); Vector posCompetencyList = PstCandidatePositionCompetency.list(0, 0, whereClause, "");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Detail</title>
        <style type="text/css">
            body {
                margin: 0;
                padding: 0;
                color: #575757;
                font-family: sans-serif;
                background-color: #EEE;
            }
            .header {
                background-color: #E5E5E5;
                border-bottom: 1px;
            }
            .content {
                padding: 21px;
            }
            #title {
                font-size: 12px;
                color: #007592;
                padding: 7px 12px;
                margin: 3px 12px;
                background-color: #FFF;
                border-left: 1px solid #0066CC;
            }
            .tblStyle {border-collapse: collapse; font-size: 12px; }
            .tblStyle td {padding: 5px 7px; border: 1px solid #CCC; font-size: 12px; background-color: #FFF;}
            .title_tbl {font-weight: bold;background-color: #DDD; color: #575757;}
        </style>
    </head>
    <body>
        <div class="header">
            <table>
                <tr>
                    <td style="margin: 0; padding: 0">
                        <%
                        String pictPath = "";
                        try {
                            SessEmployeePicture sessEmployeePicture = new SessEmployeePicture();
                            pictPath = sessEmployeePicture.fetchImageEmployee(employee.getOID());

                        } catch (Exception e) {
                            System.out.println("err." + e.toString());
                        }%> 
                        <%
                             if (pictPath != null && pictPath.length() > 0) {
                                out.println("<img height=\"64\" id=\"photo\" title=\"Click here to upload\"  src=\"" + approot + "/" + pictPath + "\">");
                             } else {
                        %>
                        <img width="64" id="photo" src="<%=approot%>/imgcache/no-img.jpg" />
                        <%
                            }
                        %>
                    </td>
                    <td>
                        <div><strong style="font-size: 16px; padding-left: 21px;"><%= employee.getFullName() %></strong></div>
                        <div style="font-size: 14px; padding-left: 21px;"><%= changeValue.getPositionName(employee.getPositionId()) %></div>
                    </td>
                </tr>
            </table>
        </div>
        <div class="content">
            <table class="tblStyle">
                <tr>
                    <td colspan="4" class="title_tbl" style="background-color: #DDD; color: #007592;">Jabatan <%= changeValue.getPositionName(positionId) %></td>
                </tr>
                <tr>
                    <td colspan="4" class="title_tbl" style="background-color: #DDD; color: #007592;">Data Kompetensi</td>
                </tr>
                <tr>
                    <td colspan="2" class="title_tbl" style="background-color: #DDD">Kompetensi Dibutuhkan</td>
                    <td colspan="2" class="title_tbl" style="background-color: #DDD">Kompetensi Karyawan</td>
                </tr>
                <tr>
                    <td class="title_tbl" style="background-color: #DDD">Judul</td>
                    <td class="title_tbl" style="background-color: #DDD">Skor Rekom</td>
                    <td class="title_tbl" style="background-color: #DDD">Skor (IPK)</td>
                    <td class="title_tbl" style="background-color: #DDD">Gap</td>
                </tr>
                <%  double totalSkorReq =0, totalSkorEmp= 0, totalGap=0,
                           subTotalSkorReq =0, subTotalSkorEmp= 0, subTotalGap=0;
                if (listCompetencyReq != null && listCompetencyReq.size()>0){
                    for (int i=0; i<listCompetencyReq.size(); i++){
                        PositionCompetencyRequired compReq = (PositionCompetencyRequired)listCompetencyReq.get(i);
                        double compEmpVal = getCompetencyEmp(employeeId, compReq.getCompetencyId());
                        double skorReq = compReq.getScoreReqRecommended();
                        double gap = compEmpVal - skorReq;
                        subTotalSkorReq = subTotalSkorReq + skorReq;
                        subTotalSkorEmp = subTotalSkorEmp + compEmpVal; 
                        subTotalGap = subTotalGap + gap;
                        totalSkorReq = totalSkorReq + skorReq;
                        totalSkorEmp = totalSkorEmp + compEmpVal; 
                        totalGap = totalGap + gap;
                %>
                <tr>
                    <td><%= getCompetencyName(compReq.getCompetencyId())  %></td>
                    <td style="text-align: right"><%= skorReq %></td>
                    <td style="text-align: right"><%= compEmpVal %></td>
                    <td style="text-align: right"><%= gap %></td>
                </tr>
                <% 
                    }
                    if (listCompetencyReq.size()>1){
                    %>
                    <tr >
                        <td>&nbsp;<span style="font-weight: bold">Subtotal</span></td>
                    <td style="text-align: right">&nbsp;<span style="font-weight: bold"><%= subTotalSkorReq %></span></td>
                    <td style="text-align: right">&nbsp;<span style="font-weight: bold"><%= subTotalSkorEmp %></span></td>
                    <td style="text-align: right">&nbsp;<span style="font-weight: bold"><%= subTotalGap %></span></td>
                    </tr>
                    <%
                    }
                }
                %>
                <tr>
                    <td colspan="4" class="title_tbl" style="background-color: #DDD; color: #007592;">&nbsp;</td>
                </tr>
                <tr>
                    <td colspan="4" class="title_tbl" style="background-color: #DDD; color: #007592;">Data Pelatihan</td>
                </tr>
                <tr>
                    <td colspan="2" class="title_tbl" style="background-color: #DDD">Pelatihan Dibutuhkan</td>
                    <td colspan="2" class="title_tbl" style="background-color: #DDD">Pelatihan Karyawan</td>
                </tr>
                <tr>
                    <td class="title_tbl" style="background-color: #DDD">Judul</td>
                    <td class="title_tbl" style="background-color: #DDD">Skor Rekom</td>
                    <td class="title_tbl" style="background-color: #DDD">Skor Kywn</td>
                    <td class="title_tbl" style="background-color: #DDD">Gap</td>
                </tr>
                <%  subTotalSkorReq =0; subTotalSkorEmp= 0; subTotalGap=0 ;
                if (listTrainingReq != null && listTrainingReq.size()>0){ 
                    for(int i=0; i<listTrainingReq.size(); i++){
                        PositionTrainingRequired trainReq = (PositionTrainingRequired)listTrainingReq.get(i);
                        double skorReq =trainReq.getPointRecommended();
                        double pointEmp = getTrainingEmp(employeeId, trainReq.getTrainingId());
                        double gap = pointEmp - skorReq;
                        subTotalSkorReq = subTotalSkorReq + skorReq;
                        subTotalSkorEmp = subTotalSkorEmp + pointEmp; 
                        subTotalGap = subTotalGap + gap;
                        totalSkorReq = totalSkorReq + skorReq;
                        totalSkorEmp = totalSkorEmp + pointEmp; 
                        totalGap = totalGap + gap; 
                %>
                <tr>
                    <td><%= getTrainingName(trainReq.getTrainingId()) %></td>
                    <td style="text-align: right"><%=  skorReq %></td>
                    <td style="text-align: right"><%= pointEmp %></td>
                    <td style="text-align: right"><%= gap %></td>
                </tr>
                <%
                    }
                    if (listTrainingReq.size()>1){
                    %>
                    <tr >
                        <td>&nbsp;<span style="font-weight: bold">Total</span></td>
                    <td style="text-align: right">&nbsp;<span style="font-weight: bold"><%= subTotalSkorReq %></span></td>
                    <td style="text-align: right">&nbsp;<span style="font-weight: bold"><%= subTotalSkorEmp %></span></td>
                    <td style="text-align: right">&nbsp;<span style="font-weight: bold"><%= subTotalGap %></span></td>
                    </tr>
                    <%
                    }
                }
                %>
                <tr>
                    <td colspan="4" class="title_tbl" style="background-color: #DDD; color: #007592;">Data Pendidikan</td>
                </tr>
                <tr>
                    <td colspan="2" class="title_tbl" style="background-color: #DDD">Pendidikan Dibutuhkan</td>
                    <td colspan="2" class="title_tbl" style="background-color: #DDD">Pendidikan Karyawan</td>
                </tr>
                <tr>
                    <td class="title_tbl" style="background-color: #DDD">Judul</td>
                    <td class="title_tbl" style="background-color: #DDD">Skor Rekom</td>
                    <td class="title_tbl" style="background-color: #DDD">Skor Kywn</td>
                    <td class="title_tbl" style="background-color: #DDD">Gap</td>
                </tr>
                <% subTotalSkorReq =0; subTotalSkorEmp= 0; subTotalGap=0;
                if (listEducationReq != null && listEducationReq.size()>0){
                    for (int i=0; i<listEducationReq.size(); i++){
                        PositionEducationRequired eduReq = (PositionEducationRequired)listEducationReq.get(i);
                        double eduEmpVal = getEducationEmp(employeeId, eduReq.getEducationId());
                        float eduEMpScore = getEducationScore( eduReq.getEducationId() ,(float) eduEmpVal);
                                
                        double skorReq =eduReq.getPointRecommended();
                        
                        double  gap = eduEMpScore - skorReq;
                        subTotalSkorReq = subTotalSkorReq + skorReq;
                        subTotalSkorEmp = subTotalSkorEmp + eduEMpScore; 
                        subTotalGap = subTotalGap + gap;
                        totalSkorReq = totalSkorReq + skorReq;
                        totalSkorEmp = totalSkorEmp + eduEMpScore; 
                        totalGap = totalGap + gap;
                %>
                <tr>
                    <td><%= getEducationName(eduReq.getEducationId()) %></td>
                    <td style="text-align: right"><%= Formater.formatNumber(skorReq,"###.##") %></td>
                    <td style="text-align: right"><%= Formater.formatNumber(eduEMpScore,"###.##" )%> (<%= Formater.formatNumber(eduEmpVal,"###.##" )%>)</td>
                    <td style="text-align: right"><%= Formater.formatNumber((eduReq.getPointRecommended()-eduEMpScore),"###.##") %></td>
                </tr>
                <% 
                    }  
                    if (listEducationReq.size()>1){
                    %>
                    <tr >
                    <td>&nbsp;<span style="font-weight: bold">Subtotal</span></td>
                    <td style="text-align: right">&nbsp;<span style="font-weight: bold"><%= Formater.formatNumber(subTotalSkorReq ,"###.##")%></span></td>
                    <td style="text-align: right">&nbsp;<span style="font-weight: bold"><%= Formater.formatNumber(subTotalSkorEmp ,"###.##")%></span></td>
                    <td style="text-align: right">&nbsp;<span style="font-weight: bold"><%= Formater.formatNumber(subTotalGap,"###.##") %></span></td>
                    </tr>
                    <%
                    }
                }                    
                %> 
                 <tr>
                     <td colspan="4" class="title_tbl" style="background-color: #DDD; color: #007592;">&nbsp;</td>
                </tr>
                <tr>
                    <td>&nbsp;<span style="font-weight: bold">Total</span></td>
                    <td style="text-align: right">&nbsp;<span style="font-weight: bold"><%= Formater.formatNumber(totalSkorReq ,"###.##")%></span></td>
                    <td style="text-align: right">&nbsp;<span style="font-weight: bold"><%= Formater.formatNumber(totalSkorEmp ,"###.##")%></span></td>
                    <td style="text-align: right">&nbsp;<span style="font-weight: bold"><%= Formater.formatNumber(totalGap ,"###.##")%></span></td>
                </tr>
            </table>
        </div>
    </body>
</html>

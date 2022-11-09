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
    public String getAssessmentName(long oid){
        String str = "";
        try {
            Assessment assessment = PstAssessment.fetchExc(oid);
            str = assessment.getAssessmentType();
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
        compEmpList = PstEmployeeCompetency.list(0, 0, whereClause, PstEmployeeCompetency.fieldNames[PstEmployeeCompetency.FLD_DATE_OF_ACHVMT]+" DESC");
        if (compEmpList != null && compEmpList.size()>0){
            EmployeeCompetency empComp = (EmployeeCompetency)compEmpList.get(0);
            result = empComp.getLevelValue();
        }
        return result;
    }
    
    public double getAssessmentEmp(long oidEmp, long oidAss){
        double result = 0;
        Vector assEmpList = new Vector();
        String whereClause = PstEmpAssessment.fieldNames[PstEmpAssessment.FLD_ASSESSMENT_ID]+"="+oidAss;
        whereClause += " AND "+PstEmpAssessment.fieldNames[PstEmpAssessment.FLD_EMPLOYEE_ID]+"="+oidEmp;
        assEmpList = PstEmpAssessment.list(0, 0, whereClause, PstEmpAssessment.fieldNames[PstEmpAssessment.FLD_DATE_OF_ASSESSMENT]+" DESC");
        if (assEmpList != null && assEmpList.size()>0){
            EmpAssessment empAss = (EmpAssessment)assEmpList.get(0);
            result = empAss.getScore();
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
  //  whereClause = PstPositionTrainingRequired.fieldNames[PstPositionTrainingRequired.FLD_POSITION_ID]+"="+positionId;
   // Vector listTrainingReq = PstPositionTrainingRequired.list(0, 0, whereClause, "");
    /* education required */
  //  whereClause = PstPositionEducationRequired.fieldNames[PstPositionEducationRequired.FLD_POSITION_ID]+"="+positionId;
   // Vector listEducationReq = PstPositionEducationRequired.list(0, 0, whereClause, "");
    /* competency required */
   // whereClause = PstPositionCompetencyRequired.fieldNames[PstPositionCompetencyRequired.FLD_POSITION_ID]+"="+positionId;
   // Vector listCompetencyReq = PstPositionCompetencyRequired.list(0, 0, whereClause, ""); Vector posCompetencyList = PstCandidatePositionCompetency.list(0, 0, whereClause, "");
%>
<%   long oidCandidate = FRMQueryString.requestLong(request, "candidate_main_id");
    
                if (oidCandidate != 0){
                    whereClause = PstCandidatePosition.fieldNames[PstCandidatePosition.FLD_CANDIDATE_MAIN_ID]+"="+oidCandidate; 
                }
                
                Vector candPosList = PstCandidatePosition.list(0, 0, whereClause, ""); 
                //if (candPosList != null && candPosList.size()>0){//
                    CandidatePosition candidatePos = (CandidatePosition)candPosList.get(0);
                    /* list of candidate position competency */
                    whereClause = PstCandidatePositionAssessment.fieldNames[PstCandidatePositionAssessment.FLD_CANDIDATE_MAIN_ID]+"="+candidatePos.getCandidateMainId();
                    //Vector posGradeList = PstCandidateGradeRequired.listInnerJoin(whereClause);
                    Vector posExperienceList = PstCandidatePositionExperience.list(0, 0, whereClause, "");
                    Vector posAssessmentListCdd = PstCandidatePositionAssessment.list(0, 0, whereClause, "");
                    whereClause = PstCandidatePositionTraining.fieldNames[PstCandidatePositionTraining.FLD_CANDIDATE_MAIN_ID]+"="+candidatePos.getCandidateMainId();
                    Vector posTrainingList = PstCandidatePositionTraining.list(0, 0, whereClause, "");
                    whereClause = PstCandidatePositionEducation.fieldNames[PstCandidatePositionEducation.FLD_CANDIDATE_MAIN_ID]+"="+candidatePos.getCandidateMainId();
                    Vector posEducationList = PstCandidatePositionEducation.list(0, 0, whereClause, "");
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
			<table border="0">
				<tr>
					<td style="width: 45%; vertical-align: top">
						<table class="tblStyle">
							<tr>
								<td colspan="5" class="title_tbl" style="background-color: #DDD; color: #007592;">Jabatan <%= changeValue.getPositionName(positionId) %></td>
							</tr>
							<tr>
								<td colspan="5" class="title_tbl" style="background-color: #DDD; color: #007592;">Data Assessment</td>
							</tr>
							<tr>
								<td colspan="2" class="title_tbl" style="background-color: #DDD">Assessment Dibutuhkan</td>
								<td colspan="3" class="title_tbl" style="background-color: #DDD">Assessment Karyawan</td>
							</tr>
							<tr>
								<td class="title_tbl" style="background-color: #DDD">Judul</td>
								<td class="title_tbl" style="background-color: #DDD">Skor Rekom</td>
								<td class="title_tbl" style="background-color: #DDD">Skor (IPK)</td>
								<td class="title_tbl" style="background-color: #DDD">Bobot</td>
								<td class="title_tbl" style="background-color: #DDD">Gap</td>
							</tr>
							<%  double totalSkorReq =0, totalSkorEmp= 0, totalGap=0, totalBobot=0,
									   subTotalSkorReq =0, subTotalSkorEmp= 0, subTotalGap=0,subTotalBobot=0;
							if (posAssessmentListCdd != null && posAssessmentListCdd.size()>0){ // if (listCompetencyReq != null && listCompetencyReq.size()>0){
							   for (int i=0; i<posAssessmentListCdd.size(); i++){ // for (int i=0; i<listCompetencyReq.size(); i++){
									CandidatePositionAssessment assReq = (CandidatePositionAssessment)posAssessmentListCdd.get(i); //   PositionCompetencyRequired compReq = (PositionCompetencyRequired)listCompetencyReq.get(i);
									double assEmpVal = getAssessmentEmp(employeeId, assReq.getAssessmentId());
									double skorReq = assReq.getScoreMin(); //getScoreReqRecommended();
									double gap = assEmpVal - skorReq;
									double bobot = assReq.getBobot();
									subTotalSkorReq = subTotalSkorReq + skorReq;
									subTotalSkorEmp = subTotalSkorEmp + assEmpVal; 
									subTotalGap = subTotalGap + gap;
									subTotalBobot = subTotalBobot + bobot;
									totalSkorReq = totalSkorReq + skorReq;
									totalSkorEmp = totalSkorEmp + assEmpVal; 
									totalGap = totalGap + gap;
									totalBobot = totalBobot + bobot;
							%>
							<tr>
								<td><%= getAssessmentName(assReq.getAssessmentId())  %></td>
								<td style="text-align: right"><%= skorReq %></td>
								<td style="text-align: right"><%= assEmpVal %></td>
								<td style="text-align: right"><%= bobot %></td>
								<td style="text-align: right"><%= gap %></td>
							</tr>
							<% 
								}
								if (posAssessmentListCdd.size()>1){
								%>
								<tr >
									<td>&nbsp;<span style="font-weight: bold">Subtotal</span></td>
								<td style="text-align: right">&nbsp;<span style="font-weight: bold"><%= subTotalSkorReq %></span></td>
								<td style="text-align: right">&nbsp;<span style="font-weight: bold"><%= subTotalSkorEmp %></span></td>
								<td style="text-align: right">&nbsp;<span style="font-weight: bold"><%= subTotalBobot %></span></td>
								<td style="text-align: right">&nbsp;<span style="font-weight: bold"><%= subTotalGap %></span></td>
								</tr>
								<%
								}
							}
							%>
							<tr>
								<td colspan="5" class="title_tbl" style="background-color: #DDD; color: #007592;">&nbsp;</td>
							</tr>
							<tr>
								<td colspan="5" class="title_tbl" style="background-color: #DDD; color: #007592;">Data Pelatihan</td>
							</tr>
							<tr>
								<td colspan="2" class="title_tbl" style="background-color: #DDD">Pelatihan Dibutuhkan</td>
								<td colspan="3" class="title_tbl" style="background-color: #DDD">Pelatihan Karyawan</td>
							</tr>
							<tr>
								<td class="title_tbl" style="background-color: #DDD">Judul</td>
								<td class="title_tbl" style="background-color: #DDD">Skor Rekom</td>
								<td class="title_tbl" style="background-color: #DDD">Skor Kywn</td>
								<td colspan="2" class="title_tbl" style="background-color: #DDD">Gap</td>
							</tr>
							<%  subTotalSkorReq =0; subTotalSkorEmp= 0; subTotalGap=0 ;
							if (posTrainingList != null && posTrainingList.size()>0){ //if (listTrainingReq != null && listTrainingReq.size()>0){ 
							   for(int i=0; i<posTrainingList.size(); i++){ //for(int i=0; i<listTrainingReq.size(); i++){
									CandidatePositionTraining trainReq = (CandidatePositionTraining)posTrainingList.get(i); // PositionTrainingRequired trainReq = (PositionTrainingRequired)listTrainingReq.get(i);
									double skorReq =trainReq.getScoreMin(); //trainReq.getPointRecommended();
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
								<td colspan="2" style="text-align: right"><%= gap %></td>
							</tr>
							<%
								}
								if (posTrainingList.size()>1){
								%>
								<tr >
									<td>&nbsp;<span style="font-weight: bold">Total</span></td>
								<td style="text-align: right">&nbsp;<span style="font-weight: bold"><%= subTotalSkorReq %></span></td>
								<td style="text-align: right">&nbsp;<span style="font-weight: bold"><%= subTotalSkorEmp %></span></td>
								<td colspan="2" style="text-align: right">&nbsp;<span style="font-weight: bold"><%= subTotalGap %></span></td>
								</tr>
								<%
								}
							}
							%>
							<tr>
								<td colspan="5" class="title_tbl" style="background-color: #DDD; color: #007592;">Data Pendidikan</td>
							</tr>
							<tr>
								<td colspan="2" class="title_tbl" style="background-color: #DDD">Pendidikan Dibutuhkan</td>
								<td colspan="3" class="title_tbl" style="background-color: #DDD">Pendidikan Karyawan</td>
							</tr>
							<tr>
								<td class="title_tbl" style="background-color: #DDD">Judul</td>
								<td class="title_tbl" style="background-color: #DDD">Skor Rekom</td>
								<td class="title_tbl" style="background-color: #DDD">Skor Kywn</td>
								<td colspan="2" class="title_tbl" style="background-color: #DDD">Gap</td>
							</tr>
							<% subTotalSkorReq =0; subTotalSkorEmp= 0; subTotalGap=0; 
							if (posEducationList != null && posEducationList.size()>0){ //if (listEducationReq != null && listEducationReq.size()>0){
								for (int i=0; i<posEducationList.size(); i++){ //for (int i=0; i<listEducationReq.size(); i++){
									CandidatePositionEducation eduReq = (CandidatePositionEducation)posEducationList.get(i); //(PositionEducationRequired)listEducationReq.get(i);
									double eduEmpVal = getEducationEmp(employeeId, eduReq.getEducationId());
									float eduEMpScore = getEducationScore( eduReq.getEducationId() ,(float) eduEmpVal);

									double skorReq =eduReq.getScoreMin();

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
								<td colspan="2" style="text-align: right"><%= Formater.formatNumber((eduEMpScore-eduReq.getScoreMin()),"###.##") %></td>
							</tr>
							<% 
								}  
								if (posEducationList.size()>1){
								%>
								<tr >
								<td>&nbsp;<span style="font-weight: bold">Subtotal</span></td>
								<td style="text-align: right">&nbsp;<span style="font-weight: bold"><%= Formater.formatNumber(subTotalSkorReq ,"###.##")%></span></td>
								<td style="text-align: right">&nbsp;<span style="font-weight: bold"><%= Formater.formatNumber(subTotalSkorEmp ,"###.##")%></span></td>
								<td colspan="2" style="text-align: right">&nbsp;<span style="font-weight: bold"><%= Formater.formatNumber(subTotalGap,"###.##") %></span></td>
								</tr>
								<%
								}
							}                    
							%> 
							 <tr>
								 <td colspan="5" class="title_tbl" style="background-color: #DDD; color: #007592;">&nbsp;</td>
							</tr>
							<tr>
								<td>&nbsp;<span style="font-weight: bold">Total</span></td>
								<td style="text-align: right">&nbsp;<span style="font-weight: bold"><%= Formater.formatNumber(totalSkorReq ,"###.##")%></span></td>
								<td style="text-align: right">&nbsp;<span style="font-weight: bold"><%= Formater.formatNumber(totalSkorEmp ,"###.##")%></span></td>
								<td colspan="2" style="text-align: right">&nbsp;<span style="font-weight: bold"><%= Formater.formatNumber(totalGap ,"###.##")%></span></td>
							</tr>
						</table>
					</td>
					<td style="width: 10%">
						
					</td>
					<td style="width: 45%; vertical-align: top">
						<table class="tblStyle">
							<tr>
								<td colspan="4">Filter Pencarian</td>
							</tr>
							<%
								String whereGrade = PstCandidatePositionCompetency.fieldNames[PstCandidatePositionCompetency.FLD_CANDIDATE_MAIN_ID] + "=" + oidCandidate;
								Vector<CandidateGradeRequired> listGrade = PstCandidateGradeRequired.listInnerJoin(whereGrade);
								if (listGrade.size()>0){
							%>
								<tr>
									<td colspan="4" class="title_tbl" style="background-color: #DDD; color: #007592;">Grade</td>
								</tr>
								<tr>
									<td class="title_tbl" style="background-color: #DDD">Level</td>
									<td class="title_tbl" style="background-color: #DDD">Grade Minimum</td>
									<td class="title_tbl" style="background-color: #DDD">Grade Maximum</td>
									<td class="title_tbl" style="background-color: #DDD">Grade Karyawan</td>
								</tr>
							<%		for (CandidateGradeRequired gradeRequired : listGrade) {
										Level lvl = PstLevel.getByGrade(gradeRequired.getGradeMinimum().getGradeRank(),
											gradeRequired.getGradeMaximum().getGradeRank());
										
										GradeLevel gradeLevel = new GradeLevel();
										try {
											gradeLevel = PstGradeLevel.fetchExc(employee.getGradeLevelId());
										} catch (Exception exc){}
							%>
										<tr>
											<td><%= lvl.getLevel()  %></td>
											<td><%= gradeRequired.getGradeMinimum().getCodeLevel() %></td>
											<td><%= gradeRequired.getGradeMaximum().getCodeLevel() %></td>
											<td><%= gradeLevel.getCodeLevel() %></td>
										</tr>
							<%
									}
								
								}
						
								String whereExperience = PstCandidatePositionExperience.fieldNames[PstCandidatePositionExperience.FLD_CANDIDATE_MAIN_ID] + "=" + oidCandidate+" AND "
													+PstCandidatePositionExperience.fieldNames[PstCandidatePositionExperience.FLD_TYPE]+"=0";
								Vector<CandidatePositionExperience> experienceList = PstCandidatePositionExperience.list(0, 0, whereExperience, "");
								if (experienceList.size()>0){
							%>
								<tr>
									<td colspan="4" class="title_tbl" style="background-color: #DDD; color: #007592;">Jabatan Karyawan</td>
								</tr>
								<tr>
									<td class="title_tbl" style="background-color: #DDD">Pengalaman</td>
									<td class="title_tbl" style="background-color: #DDD">Durasi Minimal</td>
									<td class="title_tbl" style="background-color: #DDD">Durasi Rekomendasi</td>
									<td class="title_tbl" style="background-color: #DDD">Durasi Karyawan</td>
								</tr>
							<%		for (CandidatePositionExperience experience : experienceList) {
										String position = "-";
										try {
											position = PstPosition.fetchExc(experience.getExperienceId()).getPosition();
										} catch (Exception e) {
											System.out.println("ERROR : " + e.getMessage());
										}
										
										double posDuration = PstCareerPath.getDuration("employee_id="+employee.getOID()+" AND position_id = "+experience.getExperienceId());
							%>
										<tr>
											<td><%= position  %></td>
											<td><%=  experience.getDurationMin() %></td>
											<td><%= experience.getDurationRecommended() %></td>
											<td><%= posDuration %></td>
										</tr>
							<%
									}
								
								}

								String whereExperienceLevel = PstCandidatePositionExperience.fieldNames[PstCandidatePositionExperience.FLD_CANDIDATE_MAIN_ID] + "=" + oidCandidate+" AND "
													+PstCandidatePositionExperience.fieldNames[PstCandidatePositionExperience.FLD_TYPE]+"=1";
								Vector<CandidatePositionExperience> experienceListLevel = PstCandidatePositionExperience.list(0, 0, whereExperienceLevel, "");
								if (experienceListLevel.size()>0){
							%>
								<tr>
									<td colspan="4" class="title_tbl" style="background-color: #DDD; color: #007592;">Level Karyawan</td>
								</tr>
								<tr>
									<td class="title_tbl" style="background-color: #DDD">Pengalaman</td>
									<td class="title_tbl" style="background-color: #DDD">Durasi Minimal</td>
									<td class="title_tbl" style="background-color: #DDD">Durasi Rekomendasi</td>
									<td class="title_tbl" style="background-color: #DDD">Durasi Karyawan</td>
								</tr>
							<%		for (CandidatePositionExperience experience : experienceListLevel) {
										String position = "-";
										try {
											position = PstLevel.fetchExc(experience.getExperienceId()).getLevel();
										} catch (Exception e) {
											System.out.println("ERROR : " + e.getMessage());
										}
										
										double posDuration = PstCareerPath.getDuration("employee_id="+employee.getOID()+" AND level_id = "+experience.getExperienceId());
							%>
										<tr>
											<td><%= position  %></td>
											<td><%=  experience.getDurationMin() %></td>
											<td><%= experience.getDurationRecommended() %></td>
											<td><%= posDuration %></td>
										</tr>
							<%
									}
								
								}
							%>
							
						</table>
					</td>
				</tr>
			</table>
        </div>
    </body>
</html>

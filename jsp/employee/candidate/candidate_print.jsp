<%-- 
    Document   : candidate_process
    Created on : Sep 28, 2016, 2:50:51 PM
    Author     : Dimata 007
--%>
<%@page import="com.dimata.harisma.session.employee.SessCandidateParam"%>
<%@page import="com.dimata.harisma.session.employee.SessEmployeePicture"%>
<%@page import="com.dimata.harisma.session.employee.EmployeeCandidate"%>
<%@page import="com.dimata.harisma.session.employee.SessCandidate"%>
<%@page import="org.apache.poi.util.SystemOutLogger"%>
<%@page import="com.dimata.harisma.entity.log.ChangeValue"%>
<%@page import="com.dimata.harisma.entity.admin.AppObjInfo"%>
<%@page import="com.dimata.util.Command"%>
<%@page import="com.dimata.util.Formater"%>

<%@ include file = "../../main/javainit.jsp" %>
<% int  appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_EMPLOYEE, AppObjInfo.G2_CANDIDATE, AppObjInfo.OBJ_CANDIDATE_SEARCH); %>
<%@ include file = "../../main/checkuser.jsp" %>
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
<%!
    public String getExpirencePosition(long oid){
        String name = "-";
        try {
            Position pos = PstPosition.fetchExc(oid);
            name = pos.getPosition();
        } catch (Exception e){
            System.out.println(e.toString());
        }
        return name;
    }
    
    public String getExpirenceLevel(long oid){
        String name = "-";
        try {
            Level lvl = PstLevel.fetchExc(oid);
            name = lvl.getLevel();
        } catch (Exception e){
            System.out.println(e.toString());
        }
        return name;
    }

    public String getTraningName(long oid){
        String name = "-";
        try {
            Training training = PstTraining.fetchExc(oid);
            name = training.getName();
        } catch (Exception e){
            System.out.println(e.toString());
        }
        return name;
    }
    
%>
<%
    int iCommand = FRMQueryString.requestCommand(request);
    long oidCandidate = FRMQueryString.requestLong(request, "candidate_main_id");
    long positionId = FRMQueryString.requestLong(request, "position_id");
    String[] checkEmp = FRMQueryString.requestStringValues(request, "check_emp");
    ChangeValue changeValue = new ChangeValue();
    boolean status_aktif = FRMQueryString.requestBoolean(request, "status_aktif"); 
    boolean status_mbt = FRMQueryString.requestBoolean(request, "status_mbt"); 
    boolean status_berhenti = FRMQueryString.requestBoolean(request, "status_berhenti"); 
    long positionTypeId = FRMQueryString.requestLong(request, "position_type");
    int resultType = FRMQueryString.requestInt(request, "result");
    
    SessCandidateParam parameters = new SessCandidateParam();  
    parameters.setEmployeeStatusActiv(status_aktif);
    parameters.setEmployeeStatusMBT(status_mbt);
    parameters.setEmployeeStatusResigned(status_berhenti);
    parameters.setEmployeePositionType(positionTypeId);
    
    Vector candidateList = SessCandidate.queryCandidate(oidCandidate, positionId, parameters); 
    
    
     long candidateLocId = FRMQueryString.requestLong(request, "candidate_loc_id");
    long gradeLevelId = FRMQueryString.requestLong(request, "grade_level_id");
    long requestedBy = FRMQueryString.requestLong(request, "requested_by");
    String candidateTitle = FRMQueryString.requestString(request, "candidate_title");
    long candidatePosId = FRMQueryString.requestLong(request, "candidate_pos_id");
    long oidPosition = FRMQueryString.requestLong(request, "position_id");
    
    int addExperience = FRMQueryString.requestInt(request, "add_experience");
    int addGradeReq = FRMQueryString.requestInt(request, "add_grade_req");
    int addCompetency = FRMQueryString.requestInt(request, "add_competency");
    int addTraining = FRMQueryString.requestInt(request, "add_training");
    int addEducation = FRMQueryString.requestInt(request, "add_education");
    
    /* data input candidate position grade level req */
    long oidCandGradeReq = FRMQueryString.requestLong(request, "oid_cand_grade_req");
    long minGradeLevelId = FRMQueryString.requestLong(request, "min_grade_level_id");
    long maxGradeLevelId = FRMQueryString.requestLong(request, "max_grade_level_id");
    
    /* data input candidate position experience */
    long oidCandPosExper = FRMQueryString.requestLong(request, "oid_cand_pos_exper");
    long experienceId = FRMQueryString.requestLong(request, "experience_id");
    int experDurMin = FRMQueryString.requestInt(request, "exper_dur_min");
    int experDurRecom = FRMQueryString.requestInt(request, "exper_dur_recom");
    /* data input candidate position competency */
    long oidCandPosComp = FRMQueryString.requestLong(request, "oid_cand_pos_comp");
    long competencyId = FRMQueryString.requestLong(request, "competency_id");
    int compScoreMin = FRMQueryString.requestInt(request, "comp_score_min");
    int compScoreMax = FRMQueryString.requestInt(request, "comp_score_max");
    /* data input candidate position training */
    long oidCandPosTrain= FRMQueryString.requestLong(request, "oid_cand_pos_train");
    long trainingId = FRMQueryString.requestLong(request, "training_id");
    int trainScoreMin = FRMQueryString.requestInt(request, "train_score_min");
    int trainScoreMax = FRMQueryString.requestInt(request, "train_score_max");
    /* data input candidate position education */
    long oidCandPosEdu = FRMQueryString.requestLong(request, "oid_cand_pos_edu");
    long educationId = FRMQueryString.requestLong(request, "education_id");
    int eduScoreMin = FRMQueryString.requestInt(request, "edu_score_min");
    int eduScoreMax = FRMQueryString.requestInt(request, "edu_score_max");
    
    CandidateMain candidateMain = new CandidateMain();
    String dimintaOleh = "Browse";
    String whereClause = "";
    Vector listLocation = new Vector();

    if (oidCandidate != 0){
        try {
            candidateMain = PstCandidateMain.fetchExc(oidCandidate);
            if (candidateMain.getRequestedBy()!= 0){
                Employee emp = PstEmployee.fetchExc(candidateMain.getRequestedBy());
                dimintaOleh = emp.getFullName();
            }
        } catch(Exception e){
            System.out.println("Output: "+e.toString());
        }
    }
    
    Vector listEmployee = PstEmpTalentPool.listJoinCandidate(oidCandidate, positionTypeId, "");
    String whereCandidate = PstCandidatePosition.fieldNames[PstCandidatePosition.FLD_CANDIDATE_MAIN_ID]+"="+oidCandidate; 
    Vector candPosList = PstCandidatePosition.list(0, 0, whereCandidate, ""); 
    if (candPosList != null && candPosList.size()>0){
            CandidatePosition candidatePos = (CandidatePosition)candPosList.get(0);
            positionId = candidatePos.getPositionId();
    }
    
    whereClause = PstCandidateResult.fieldNames[PstCandidateResult.FLD_CANDIDATE_MAIN_ID]+"="+oidCandidate
            +" AND "+PstCandidateResult.fieldNames[PstCandidateResult.FLD_POSITION_TYPE_ID]+"= "+positionTypeId;
    Vector listCandidat = PstCandidateResult.list(0, 0, whereClause, "");
    if (listCandidat.size()>0){
        String inEmp = "";
        for (int i=0; i < listCandidat.size(); i++){
            CandidateResult candidateResult = (CandidateResult) listCandidat.get(i);
            if (i > 0){
                inEmp = inEmp + ",";
            }
            inEmp = inEmp + candidateResult.getEmployeeId();
        }
        listEmployee = PstEmpTalentPool.listJoinCandidate(oidCandidate, positionTypeId, inEmp);
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Print Talent</title>
        <link rel="stylesheet" href="../../styles/main.css" type="text/css">
        <style type="text/css">
            @media all {
            .page-break { display: none; }
            }

            @media print {
            .page-break { display: block; page-break-before: always; }
            }
            body {
                font-family: sans-serif;
                font-size: 12px;
                color: #474747;
                background-color: #EEE;
                padding: 21px;
            }
            .box {
                background-color: #FFF;
                border: 1px solid #DDD;
                border-radius: 3px;
            }
            #judul {
                padding: 12px 0px;
                border-bottom: 1px solid #DDD;
            }
            #isi{
                padding: 12px 14px;
            }

            .title_tbl {
                font-weight: bold;
                background-color: #EEE;
            }
            .title {
                background-color: #FFF;
                border-left: 1px solid #007592;
                padding: 11px;
            }
            .tbl-style {border-collapse: collapse; font-size: 12px;}
            .tbl-style td {padding: 7px 9px; border: 1px solid #CCC; font-size: 12px;}
            .tblStyle {border-collapse: collapse; font-size: 12px; background-color: #FFF;}
            .tblStyle td {padding: 7px 9px; border: 1px solid #CCC; font-size: 12px; }
            .btn {
                background-color: #00a1ec;
                border-radius: 3px;
                font-family: Arial;
                color: #EEE;
                font-size: 12px;
                padding: 7px 11px 7px 11px;
                text-decoration: none;
            }

            .btn:hover {
                color: #FFF;
                background-color: #007fba;
                text-decoration: none;
            }
            .btn-small {
                font-weight: bold;
                font-family: sans-serif;
                text-decoration: none;
                padding: 5px 9px; 
                background-color: #FFF; color: #575757; 
                font-size: 11px; cursor: pointer;
                border-radius: 3px;
                border:1px solid #DDD;
                margin: 5px 0px;
            }
            .btn-small:hover { background-color: #D5D5D5; color: #474747; border:1px solid #CCC;}
            .content-main {
                padding: 21px 11px;
                margin: 0px 23px 59px 23px;
            }
            #browse {
                background-color: #DDD;
                color:#575757;
                font-weight: bold;
                padding: 5px 7px;
                border-radius: 3px;
                margin: 1px 0px;
                cursor: pointer;
            }
            #item {
                background-color: #DDD;
                color:#575757;
                font-weight: bold;
                padding: 5px 7px;
                border-radius: 3px;
                margin: 1px 0px;
            }
            #close {
                background-color: #EB9898;
                color: #B83916;
                font-weight: bold;
                padding: 5px 7px;
                border-radius: 3px;
                cursor: pointer;
                margin: 1px 5px 1px 2px;
            }
            #menu_utama {padding: 9px 14px; border-left: 1px solid #0099FF; font-size: 14px; background-color: #F3F3F3;}
            #menu_title {color:#0099FF; font-size: 14px;}
        </style>
        <script type="text/javascript">
            function cmdBack(oid){
                document.frm.command.value="<%=Command.VIEW%>";
                document.frm.candidate_main_id.value=oid;
                document.frm.action="candidate_main.jsp";
                document.frm.submit();
            }
            
            function cmdList(oid){
                document.frm.command.value="<%=Command.VIEW%>";
                document.frm.candidate_main_id.value=oid;
                document.frm.action="candidate_process.jsp";
                document.frm.submit();
            }
            
            function cmdDetail(oid, positionId){
                document.frm.employee_id.value=oid;
                document.frm.position_id.value=positionId;
                document.frm.action="candidate_detail.jsp";
                document.frm.target="_blank";
                document.frm.submit();
            }
            function cmdToTalentPool(){
                document.frm.action="candidate_process.jsp";
                document.frm.submit();
            }
            
         function cmdOpenEmployee(oid){
		document.frm.employee_oid.value=oid;
		document.frm.command.value="<%=Command.EDIT%>";
		//document.frm.prev_command.value="<%=Command.EDIT%>";
		document.frm.action="../databank/employee_edit.jsp";
                document.frm.target="_blank";
		document.frm.submit();
	}
        </script>
    </head>
    <body>
        <div class="content-main">
            <form name="frm" method ="post" action="">
                <input type="hidden" name="command" value="" />
                <input type="hidden" name="candidate_loc_id" value="<%= candidateLocId %>" />
                <input type="hidden" name="candidate_main_id" value="<%= oidCandidate %>" />
                <input type="hidden" name="code_org" value="" />
                <input type="hidden" name="grade_level_id" value="" />
                <input type="hidden" name="candidate_pos_id" value="" />
                <input type="hidden" name="add_grade_req" value="" />
                <input type="hidden" name="add_experience" value="" />
                <input type="hidden" name="add_competency" value="" />
                <input type="hidden" name="add_training" value="" />
                <input type="hidden" name="add_education" value="" />
                <input type="hidden" name="oid_cand_grade_req" value="" />
                <input type="hidden" name="oid_cand_pos_exper" value="" />
                <input type="hidden" name="oid_cand_pos_comp" value="" />
                <input type="hidden" name="oid_cand_pos_train" value="" />
                <input type="hidden" name="oid_cand_pos_edu" value="" />
                <h1 style="color:#575757">Pencarian Talent</h1>
                <div class="title">Information dasar</div>
                <table class="tblStyle">
                    <tr>
                        <td class="title_tbl">Diminta oleh</td>
                        <td>
                            <input type="hidden" name="requested_by" value="<%= dimintaOleh %>" />
                            <%= dimintaOleh %>
                        </td>
                    </tr>
                    <tr>
                        <td class="title_tbl">Judul dokumen</td>
                        <td> <%= candidateMain.getTitle() %> </td>
                    </tr>
                                    </table>
                <div>&nbsp;</div>
                <% if (oidCandidate != 0){ %>
                <div class="title">Dilokasikan (optional)</div>
               
                <%
                if (oidCandidate != 0){
                    whereClause = PstCandidateLocation.fieldNames[PstCandidateLocation.FLD_CANDIDATE_MAIN_ID]+"="+oidCandidate;
                    whereClause += " AND "+PstCandidateLocation.fieldNames[PstCandidateLocation.FLD_CODE]+"=0";
                    listLocation = PstCandidateLocation.list(0, 0, whereClause, "");
                    if (listLocation != null && listLocation.size()>0){
                        %>
                        <table cellpadding="0" cellspacing="0">
                        <%
                        for (int i=0; i<listLocation.size(); i++){
                            CandidateLocation org = (CandidateLocation)listLocation.get(i);
                            %>
                            <tr>
                                <td><div id="item"><%= changeValue.getDivisionName(org.getDivisionId()) %> / <%= changeValue.getDepartmentName(org.getDepartmentId()) %></div></td>
                                <td>&nbsp;</td>
                            </tr>
                            <%
                        }
                        %>
                        </table>
                        <%
                    }
                }
                %>
                <div>&nbsp;</div>
                <table> 
                    <tr> <td style="vertical-align: text-top;">
                <div class="title">Pilihan jabatan untuk proses talent</div>
                               
                <%
                if (oidCandidate != 0){
                    whereClause = PstCandidatePosition.fieldNames[PstCandidatePosition.FLD_CANDIDATE_MAIN_ID]+"="+oidCandidate; 
                }
                
                candPosList = PstCandidatePosition.list(0, 0, whereClause, ""); 
                if (candPosList != null && candPosList.size()>0){
                    CandidatePosition candidatePos = (CandidatePosition)candPosList.get(0);
                    /* list of candidate position competency */
                    whereClause = PstCandidatePositionCompetency.fieldNames[PstCandidatePositionCompetency.FLD_CANDIDATE_MAIN_ID]+"="+candidatePos.getCandidateMainId();
                    Vector posGradeList = PstCandidateGradeRequired.listInnerJoin(whereClause);
                    Vector posExperienceList = PstCandidatePositionExperience.list(0, 0, whereClause, PstCandidatePositionExperience.fieldNames[PstCandidatePositionExperience.FLD_TYPE]);
                    Vector posAssessmentList = PstCandidatePositionAssessment.list(0, 0, whereClause, "");
                    whereClause = PstCandidatePositionTraining.fieldNames[PstCandidatePositionTraining.FLD_CANDIDATE_MAIN_ID]+"="+candidatePos.getCandidateMainId();
                    Vector posTrainingList = PstCandidatePositionTraining.list(0, 0, whereClause, "");
                    whereClause = PstCandidatePositionEducation.fieldNames[PstCandidatePositionEducation.FLD_CANDIDATE_MAIN_ID]+"="+candidatePos.getCandidateMainId();
                    Vector posEducationList = PstCandidatePositionEducation.list(0, 0, whereClause, "");
                %>
                <input type="hidden" name="position_id" value="<%= candidatePos.getPositionId() %>" />
                
                <div class="box">
                    <div id="judul"><strong style="padding-left: 14px;"><%= changeValue.getPositionName(candidatePos.getPositionId()) %></strong></div>
                    <div id="isi">
                        <table class="tblStyle1">
                            <tr>
                                <td style="background-color: #EEE; font-weight: bold;">Grade Minimum</td>
                                <td style="background-color: #EEE; font-weight: bold;">Grade Maximum</td>
                                <td style="background-color: #EEE; font-weight: bold;">&nbsp;</td>
                            </tr>
                            <%
                            if (posGradeList != null && posGradeList.size()>0){
                                for (int i=0; i<posGradeList.size(); i++){
                                    CandidateGradeRequired dataGrade = (CandidateGradeRequired )posGradeList.get(i);
                            %>
                            <tr>
                             <% if ( (dataGrade.getOID() == oidCandGradeReq) && (iCommand == Command.EDIT)){ 
                                Vector gradeList = PstGradeLevel.list(0, 0, "", PstGradeLevel.fieldNames[PstGradeLevel.FLD_GRADE_CODE]);
                                 %>
                                 <td>
                                      <select name="min_grade_level_id">
                                          <option value="0" >-SELECT-</option>
                                        <%
                                        if (gradeList != null && gradeList.size()>0){
                                            for(int ix=0; ix< gradeList.size(); ix++){
                                                GradeLevel gradeLevel = (GradeLevel)gradeList.get(ix);
                                                %>
                                                <option value="<%= gradeLevel.getOID() %>"  <%=((dataGrade.getGradeMinimum().getOID()== gradeLevel.getOID())?"selected":"") %>  ><%= gradeLevel.getCodeLevel()%></option>
                                                <%
                                            }
                                        }
                                        %>
                                    </select>
                                </td>
                                <td>
                                      <select name="max_grade_level_id">
                                          <option value="0" >-SELECT-</option>
                                        <%
                                        
                                        if (gradeList != null && gradeList.size()>0){
                                            for(int ix=0; ix< gradeList.size(); ix++){
                                                GradeLevel gradeLevel = (GradeLevel)gradeList.get(ix);
                                                %>
                                                <option value="<%= gradeLevel.getOID() %>"  <%=((dataGrade.getGradeMaximum().getOID()== gradeLevel.getOID())?"selected":"") %>  ><%= gradeLevel.getCodeLevel()%></option>
                                                <%
                                            }
                                        }
                                        %>
                                    </select>
                                </td>
                               
                                <td>&nbsp;</td>
                            <% } else {%>
                               <td><%= dataGrade.getGradeMinimum().getCodeLevel()  %></td>
                               <td><%= dataGrade.getGradeMaximum().getCodeLevel() %></td>
                               <td>
                                   &nbsp;
                               </td>
                               <% } %>
                           </tr>
                            <% 
                                } 
                            }
                            %>
                            <% if ( (addGradeReq == 1) && (iCommand != Command.EDIT && oidCandGradeReq==0)){ 
                              Vector gradeList = PstGradeLevel.list(0, 0, "", PstGradeLevel.fieldNames[PstGradeLevel.FLD_GRADE_CODE]);
                            %>
                            <tr>
                                <td>
                                    <select name="min_grade_level_id">
                                          <option value="0" >-SELECT-</option>
                                        <%
                                        if (gradeList != null && gradeList.size()>0){
                                            for(int ix=0; ix< gradeList.size(); ix++){
                                                GradeLevel gradeLevel = (GradeLevel)gradeList.get(ix);
                                                %>
                                                <option value="<%= gradeLevel.getOID() %>"><%= gradeLevel.getCodeLevel()%></option>
                                                <%
                                            }
                                        }
                                        %>
                                    </select>
                                </td>
                                <td>
                                    <select name="max_grade_level_id">
                                          <option value="0" >-SELECT-</option>
                                        <%
                                        
                                        if (gradeList != null && gradeList.size()>0){
                                            for(int ix=0; ix< gradeList.size(); ix++){
                                                GradeLevel gradeLevel = (GradeLevel)gradeList.get(ix);
                                                %>
                                                <option value="<%= gradeLevel.getOID() %>"  ><%= gradeLevel.getCodeLevel()%></option>
                                                <%
                                            }
                                        }
                                        %>
                                    </select>
                                    
                                </td>                                
                                <td>&nbsp;</td>
                            </tr>
                            <% } %>
                        </table>
                        <div>&nbsp;</div>
                        
                        <table class="tblStyle1">
                           
                            <tr>
                                <td style="background-color: #EEE; font-weight: bold;">Pengalaman</td>
                                <td style="background-color: #EEE; font-weight: bold;">Durasi Minimal</td>
                                <td style="background-color: #EEE; font-weight: bold;">Durasi Rekomendasi</td>
                                <td style="background-color: #EEE; font-weight: bold;">&nbsp;</td>
                            </tr>
                            <%
                            if (posExperienceList != null && posExperienceList.size()>0){
                                for (int i=0; i<posExperienceList.size(); i++){
                                    CandidatePositionExperience dataPosExp = (CandidatePositionExperience )posExperienceList.get(i);
                            %>
                            <tr>
                             <% if ( (dataPosExp.getOID() == oidCandPosExper) && (iCommand == Command.EDIT)){ %>
                                  <td>
                                      <select name="experience_id">
                                          <option value="0" >-SELECT-</option>
                                        <%
                                        Vector experList = PstPosition.list(0, 0, "", PstPosition.fieldNames[PstPosition.FLD_POSITION]);
                                        if (experList != null && experList.size()>0){
                                            for(int ix=0; ix< experList.size(); ix++){
                                                Position position = (Position)experList.get(ix);
                                                %>
                                                <option value="<%= position.getOID() %>"  <%=((dataPosExp.getExperienceId()== position.getOID())?"selected":"") %>  ><%= position.getPosition() %></option>
                                                <%
                                            }
                                        }
                                        %>
                                    </select>
                                </td>
                                <td><input type="text" name="exper_dur_min" value="<%= dataPosExp.getDurationMin() %>" size="10" /></td>
                                <td><input type="text" name="exper_dur_recom" value="<%= dataPosExp.getDurationRecommended() %>" size="10" /></td>
                                <td></td>
                            <% } else {%>
                               <td><%= (dataPosExp.getType() == 1 ? getExpirenceLevel(dataPosExp.getExperienceId()) : getExpirencePosition(dataPosExp.getExperienceId()))  %></td>
                               <td><%= dataPosExp.getDurationMin() %> bulan</td>
                               <td><%= dataPosExp.getDurationRecommended() %> bulan</td>
                               <td>
                                   </td>
                               <% } %>
                           </tr>
                            <% 
                                } 
                            }
                            %>
                            <% if ( (addExperience == 1) && (iCommand != Command.EDIT && oidCandPosExper==0)){ %>
                            <tr>
                                <td>
                                    <select name="experience_id">
                                        <option value="0">-SELECT-</option>
                                        <%
                                        Vector experList = PstPosition.list(0, 0, "", PstPosition.fieldNames[PstPosition.FLD_POSITION]);
                                        if (experList != null && experList.size()>0){
                                            for (int i=0; i<experList.size(); i++){
                                                Position position = (Position)experList.get(i);
                                                %>
                                                <option value="<%= position.getOID() %>"><%= position.getPosition() %></option>
                                                <%
                                            }
                                        }
                                        %>
                                    </select>
                                </td>
                                <td><input type="text" name="exper_dur_min" value="" size="10" /></td>
                                <td><input type="text" name="exper_dur_recom" value="" size="10" /></td>
                                <td></td>
                            </tr>
                            <% } %>
                        </table>
                        <div>&nbsp;</div>
                        
                        <table class="tblStyle1">
                            <tr>
                                <td colspan="4" style="background-color: #EEE; font-weight: bold;">
                                    
                                </td>
                            </tr>
                            <tr>
                                <td style="background-color: #EEE; font-weight: bold;">Judul</td>
                                <td style="background-color: #EEE; font-weight: bold;">Skor minimal</td>
                                <td style="background-color: #EEE; font-weight: bold;">Skor dibutuhkan</td>
                                <td style="background-color: #EEE; font-weight: bold;">Bobot</td>
                                <td style="background-color: #EEE; font-weight: bold;">&nbsp;</td>
                            </tr>
                            <%
                            if (posAssessmentList != null && posAssessmentList.size()>0){
                                for (int i=0; i<posAssessmentList.size(); i++){
                                    CandidatePositionAssessment dataPosAss = (CandidatePositionAssessment)posAssessmentList.get(i);
                            %>
                                    <tr>
                                        <td><%= getAssessmentName(dataPosAss.getAssessmentId())  %></td>
                                        <td><%= dataPosAss.getScoreMin() %></td>
                                        <td><%= dataPosAss.getScoreMax() %></td>
                                        <td><%= dataPosAss.getBobot()%></td>
                                        <td>
                                            
                                        </td>
                                    </tr>
                            <% 
                                } 
                            }
                            %>
                            <% if (addCompetency == 1){ %>
                            <tr>
                                <td>
                                    <select name="competency_id">
                                        <option value="0">-SELECT-</option>
                                        <%
                                        Vector competencyList = PstCompetency.list(0, 0, "", "");
                                        if (competencyList != null && competencyList.size()>0){
                                            for (int i=0; i<competencyList.size(); i++){
                                                Competency competency = (Competency)competencyList.get(i);
                                                %>
                                                <option value="<%= competency.getOID() %>"><%= competency.getCompetencyName() %></option>
                                                <%
                                            }
                                        }
                                        %>
                                    </select>
                                </td>
                                <td><input type="text" name="comp_score_min" value="" size="10" /></td>
                                <td><input type="text" name="comp_score_max" value="" size="10" /></td>
                                <td></td>
                            </tr>
                            <% } %>
                        </table>
                        <div>&nbsp;</div>
                        <% if (resultType == 1){ %>
                        <table class="tblStyle1">
                            <tr>
                                <td colspan="4" style="background-color: #EEE; font-weight: bold;">
                                    
                                </td>
                            </tr>
                            <tr>
                                <td style="background-color: #EEE; font-weight: bold;">Judul</td>
                                <td style="background-color: #EEE; font-weight: bold;">Skor minimal</td>
                                <td style="background-color: #EEE; font-weight: bold;">Skor dibutuhkan</td>
                                <td style="background-color: #EEE; font-weight: bold;">&nbsp;</td>
                            </tr>
                            <%
                            if (posTrainingList != null && posTrainingList.size()>0){
                                for(int i=0; i<posTrainingList.size(); i++){
                                    CandidatePositionTraining train = (CandidatePositionTraining)posTrainingList.get(i);
                            %>
                            <tr>
                                <td><%= getTraningName(train.getTrainingId()) %></td>
                                <td><%= train.getScoreMin() %></td>
                                <td><%= train.getScoreMax() %></td>
                                <td>
                                    </td>
                            </tr>
                            <%
                                }
                            }
                            %>
                            <% if (addTraining == 1){ %>
                            <tr>
                                <td>
                                    <select name="training_id">
                                        <option value="0">-SELECT-</option>
                                        <%
                                        Vector trainingList = PstTraining.list(0, 0, "", PstTraining.fieldNames[PstTraining.FLD_NAME]);
                                        if (trainingList != null && trainingList.size()>0){
                                            for(int i=0; i<trainingList.size(); i++){
                                                Training train = (Training)trainingList.get(i);
                                                %>
                                                <option value="<%=train.getOID()%>"><%= train.getName() %></option>
                                                <%
                                            }
                                        }
                                        %>
                                    </select>
                                </td>
                                <td><input type="text" name="train_score_min" value="" size="10" /></td>
                                <td><input type="text" name="train_score_max" value="" size="10" /></td>
                                <td></td>
                            </tr>
                            <% } %>
                        </table>
                        <% } %>
                        <div>&nbsp;</div>
                        <table class="tblStyle1">
                            <tr>
                                <td colspan="4" style="background-color: #EEE; font-weight: bold;">
                                    
                                </td>
                            </tr>
                            <tr>
                                <td style="background-color: #EEE; font-weight: bold;">Judul</td>
                                <td style="background-color: #EEE; font-weight: bold;">Skor minimal</td>
                                <td style="background-color: #EEE; font-weight: bold;">Skor dibutuhkan</td>
                                <td style="background-color: #EEE; font-weight: bold;">&nbsp;</td>
                            </tr>
                            <%
                            if (posEducationList != null && posEducationList.size()>0){
                                for (int i=0; i<posEducationList.size(); i++){
                                    CandidatePositionEducation dataPosEdu = (CandidatePositionEducation)posEducationList.get(i);
                            %>
                            <tr>
                                <td><%= getEducationName(dataPosEdu.getEducationId()) %></td>
                                <td><%= dataPosEdu.getScoreMin() %></td>
                                <td><%= dataPosEdu.getScoreMax() %></td>
                                <td>
                                    
                                </td>
                            </tr>
                            <%
                                }
                            }
                            %>
                            <% if (addEducation == 1){ %>
                            <tr>
                                <td>
                                    <select name="education_id">
                                        <option value="0">-SELECT-</option>
                                        <%
                                        Vector educationList = PstEducation.list(0, 0, "", PstEducation.fieldNames[PstEducation.FLD_EDUCATION_LEVEL]);
                                        if (educationList != null && educationList.size()>0){
                                            for(int i=0; i<educationList.size(); i++){
                                                Education edu = (Education)educationList.get(i);
                                                %>
                                                <option value="<%=edu.getOID()%>"><%= edu.getEducation() %></option>
                                                <%
                                            }
                                        }
                                        %>
                                    </select>
                                </td>
                                <td><input type="text" name="edu_score_min" value="" size="10" /></td>
                                <td><input type="text" name="edu_score_max" value="" size="10" /></td>
                                <td></td>
                            </tr>
                            <% } %>
                        </table>
                        <!--
                        <div>&nbsp;</div>
                        <table class="tblStyle1">
                            <tr>
                                <td colspan="4" style="background-color: #EEE; font-weight: bold;">
                                    <a href="javascript:cmdTraining()">Tambah Daftar KPI</a>
                                </td>
                            </tr>
                            <tr>
                                <td style="background-color: #EEE; font-weight: bold;">Judul</td>
                                <td style="background-color: #EEE; font-weight: bold;">Skor minimal</td>
                                <td style="background-color: #EEE; font-weight: bold;">Skor dibutuhkan</td>
                                <td style="background-color: #EEE; font-weight: bold;">&nbsp;</td>
                            </tr>
                        </table>
                        -->
                        <div>&nbsp;</div>
                        
                        <div>&nbsp;</div>
                    </div>
                </div>
                        </td>
                        <td style="vertical-align: text-top;">
                             <div class="title">Sumber pencarian</div>
                
                <%
                if (oidCandidate != 0){
                    whereClause = PstCandidateLocation.fieldNames[PstCandidateLocation.FLD_CANDIDATE_MAIN_ID]+"="+oidCandidate;
                    whereClause += " AND "+PstCandidateLocation.fieldNames[PstCandidateLocation.FLD_CODE]+"=1";
                    listLocation = PstCandidateLocation.list(0, 0, whereClause, "");
                    if (listLocation != null && listLocation.size()>0){
                        %>
                        <table cellpadding="0" cellspacing="0">
                        <%
                        for (int i=0; i<listLocation.size(); i++){
                            CandidateLocation org = (CandidateLocation)listLocation.get(i);
                            %>
                            <tr>
                                <td><div id="item"><%= changeValue.getDivisionName(org.getDivisionId()) %> / <%= changeValue.getDepartmentName(org.getDepartmentId()) %></div></td>
                                <td></td>
                            </tr>
                            <%
                        }
                        %>
                        </table>
                        <%
                    }
                }
                %>
                <div> &nbsp;</div>   
                <%
                String strCandiateNote = "";
try{
    strCandiateNote = PstSystemProperty.getValueByName("CANDIDATE_FOOTNOTE");
}catch(Exception ex){
    System.out.println("[exception] "+ex.toString());
}
                %>
                 <%=( strCandiateNote == null || strCandiateNote.equalsIgnoreCase("Not initialized") ? "" : strCandiateNote  ) %>
                <div> &nbsp;</div>
                        </td>
                    </tr>
                </table>
                <% } %>
                
                
                
                                <% } %>
            </form>
        </div>
         <div class="page-break"></div>
         <div class="content-main">
             <% if (resultType == 0){ %>
            <form name="frmX" method="post" action="">
                <input type="hidden" name="candidate_main_id" value="<%= oidCandidate %>" />
                <input type="hidden" name="employee_id" value="" />
                <input type="hidden" name="employee_oid" value="" />
                <input type="hidden" name="position_id" value="" />
                
                <input type="hidden" name="command" value="<%=iCommand%>">
                
                <h1 style="color: #575757">Hasil Pencarian Talent </h1>
            
            <div>&nbsp;</div>
            <%
            if (checkEmp != null && checkEmp.length>0){
                Date now = new Date();
                for(int i=0; i<checkEmp.length; i++){
                    EmpTalentPool empTalent = new EmpTalentPool();
                    empTalent.setDateTalent(now);
                    empTalent.setEmployeeId(Long.valueOf(checkEmp[i]));
                    empTalent.setStatusInfo(PstEmpTalentPool.NEED_DEVELOP);
                    try {
                        PstEmpTalentPool.insertExc(empTalent);
                    } catch(Exception e){
                        System.out.println(e.toString());
                    }
                }
            }
            %>
            
            <table class="tblStyle">
                <tr>
                    <td class="title_tbl">No</td>
                    <td class="title_tbl">Photo</td>                    
                    <td class="title_tbl">Nama Karyawan</td>
                    <td class="title_tbl">Mulai Kerja</td>
                    <td class="title_tbl">Satuan Kerja</td>
                    <td class="title_tbl">Unit</td>
                    <td class="title_tbl">Sub Unit</td>
                    <td class="title_tbl">Jabatan</td>
                    <td class="title_tbl">Grade</td>
                    <td class="title_tbl">Grade Rank</td>
                    
                    <td class="title_tbl">Masa Kerja [bulan]</td>
                    <td class="title_tbl">Lama Jabatan Saat ini [bulan]</td>
                    <td class="title_tbl">Competency Score</td>
                    <td class="title_tbl">Pendidikan</td>
                    <td class="title_tbl">Score Pendidikan</td>
                    <td class="title_tbl">Level Pendidikan</td>
                    
                </tr>
                <%
                if (candidateList  != null && candidateList .size()>0){
                   for(int c=0; c< candidateList.size(); c++){ 
                    EmployeeCandidate candidate =  (EmployeeCandidate) candidateList.get(c);
                %>
                <tr>
                    <td><input type="checkbox" name="check_emp" value="<%= candidate.getEmployeeId() %>" /></td>
                    <td><%= (c+1) %></td>
                    <td>
                      <%
                                                String pictPath = "";
                                                try {
                                                    SessEmployeePicture sessEmployeePicture = new SessEmployeePicture();
                                                    pictPath = sessEmployeePicture.fetchImageEmployee(candidate.getEmployeeId() );

                                                } catch (Exception e) {
                                                    System.out.println("err." + e.toString());
                                                }%> 
                                                <%
                                                     if (pictPath != null && pictPath.length() > 0) {
                                                        out.println("<img height=\"135\" id=\"photo\" title=\"Click here to upload\"  src=\"" + approot + "/" + pictPath + "\">");
                                                     } else {
                                                %>
                                                <img width="135" height="135" id="photo" src="<%=approot%>/imgcache/no-img.jpg" />
                                                <%

                                                    }
                                                %> 
                    </td>
                    <td><%= candidate.getCommecingDate() %></td>
                    <td><%= candidate.getDivision() %></td>
                    <td><%= candidate.getDepartment() %></td>
                    <td><%= (candidate.getSection()!=null ? candidate.getSection():"-") %></td>
                    <td><%= candidate.getCurrPosition() %></td>
                    <td><%= candidate.getGradeCode() %></td>
                    <td><%= candidate.getGradeRank()%></td>
                    <td><%= Formater.formatNumber(candidate.getLengthOfService(), "###.##") %></td>
                    <td><%= Formater.formatNumber(candidate.getCurrentPosLength(), "###.##")  %></td>
                    <td><%= Formater.formatNumber(candidate.getSumCompetencyScore(), "###.##")  %></td>
                    <td><%= candidate.getEducationCode() %></td>
                    <td><%= Formater.formatNumber(candidate.getEducationScore(), "###.##")  %></td>
                    <td><%= candidate.getEducationLevel() %></td>
                    
                </tr>
                <% 
                   } 
                }
                %>
            </table>
            
            </form>
            <% } else if  (resultType == 1){ %>
                <table class="tblStyle">
                        <thead>
                            <tr>
                                <td class="title_tbl">Photo</td>
                                <td class="title_tbl">Nama Karyawan</td>
                                <td class="title_tbl">Mulai Kerja</td>
                                <td class="title_tbl">Satuan Kerja</td>
                                <td class="title_tbl">Unit</td>
                                <td class="title_tbl">Sub Unit</td>
                                <td class="title_tbl">Jabatan</td>
                                <td class="title_tbl">Grade</td>
                                <td class="title_tbl">Grade Rank</td>
                                <td class="title_tbl">Masa Kerja</td>
                                <td class="title_tbl">Total Score</td>
                                <td class="title_tbl">Action</td>
                            </tr>
                        </thead>
                        <%
                            if (listEmployee.size() > 0) {
                        %>
                        <tbody>
                            <% for (int i = 0; i < listEmployee.size(); i++) {
                                    EmpTalentPool empTalentPool = (EmpTalentPool) listEmployee.get(i);
                                    Employee emp = new Employee();
                                    try {
                                        emp = PstEmployee.fetchExc(empTalentPool.getEmployeeId());

                                    } catch (Exception exc) {
                                    }

                                    String img = "";
                                    try {
                                        String pictPath = "";
                                        SessEmployeePicture sessEmployeePicture = new SessEmployeePicture();
                                        pictPath = sessEmployeePicture.fetchImageEmployee(empTalentPool.getEmployeeId());

                                        if (pictPath != null && pictPath.length() > 0) {
                                            img = "<img class='img' height=\"100\" id=\"photo\" title=\"Click here to upload\" src=\"" + approot + "/" + pictPath + "\">";
                                        } else {
                                            img = "<img class='img' width=\"100\" height=\"135\" id=\"photo\" src=\"" + approot + "/imgcache/no-img.jpg\">";
                                        }
                                    } catch (Exception e) {
                                        System.out.println("err." + e.toString());
                                    }

                                    GradeLevel gradeLevel = new GradeLevel();
                                    try {
                                        gradeLevel = PstGradeLevel.fetchExc(emp.getGradeLevelId());
                                    } catch (Exception exc) {
                                    }

                            %>
                            <%
                                whereClause = PstCandidateResult.fieldNames[PstCandidateResult.FLD_CANDIDATE_MAIN_ID]+"="+oidCandidate
                                        +" AND "+PstCandidateResult.fieldNames[PstCandidateResult.FLD_POSITION_TYPE_ID]+"= "+positionTypeId
                                        +" AND "+PstCandidateResult.fieldNames[PstCandidateResult.FLD_EMPLOYEE_ID]+"= "+emp.getOID();
                                Vector listCandidatSelect = PstCandidateResult.list(0, 0, whereClause, "");
                                 String checked = "";
                                 if (listCandidatSelect.size()>0){
                                     checked = "checked";
                                 }
                            %>
                            <tr>
                                <td><div class="imgcontainer"><%=img%></div></td>
                                <td>(<%=emp.getEmployeeNum()%>) <%=emp.getFullName()%></td>
                                <td><%=emp.getCommencingDate()%></td>
                                <td><%=PstEmployee.getDivisionName(emp.getDivisionId())%></td>
                                <td><%=PstEmployee.getDepartmentName(emp.getDepartmentId())%></td>
                                <td><%=PstEmployee.getSectionName(emp.getSectionId())%></td>
                                <td><%=PstEmployee.getPositionName(emp.getPositionId())%></td>
                                <td><%=gradeLevel.getCodeLevel()%></td>
                                <td><%=gradeLevel.getGradeRank()%></td>
                                <td><%=SessCandidate.getLOS(emp.getCommencingDate())%></td>
                                <td><%= Formater.formatNumber(empTalentPool.getTotalScore(), "###.##")%></td>
                                <td><a href="javascript:cmdDetail('<%= empTalentPool.getEmployeeId()%>','<%= positionId%>')">Detail Gap</a></td>
                            </tr>
                            <%
                                }
                            %>
                        </tbody>
                        <%
                            }
                        %>
                    </table>
            <% } %>
        </div>
            <div class="page-break"></div>
            
        <% 
             int size = 0;
             if (resultType == 0){
                 size = candidateList.size();
             } else {
                 size = listEmployee.size();
             }
             
                 if (size>0){
                   for(int c=0; c< size; c++){ 
                       
                    Employee employee =  new Employee();
                    long employeeId = 0;
                    if (resultType == 0){
                        EmployeeCandidate candidate =  (EmployeeCandidate) candidateList.get(c);

                        try{
                         employee = PstEmployee.fetchExc(candidate.getEmployeeId());
                        } catch(Exception exc){
                            out.println("Employee with oid "+ candidate.getEmployeeId() + " is not found. Please report to your IT admin" );
                        }
                    
                       employeeId = candidate.getEmployeeId();
                       
                    } else {
                        EmpTalentPool empTalentPool = (EmpTalentPool) listEmployee.get(c);
                        try {
                            employee = PstEmployee.fetchExc(empTalentPool.getEmployeeId());

                        } catch (Exception exc) {
                        }
                        employeeId = empTalentPool.getEmployeeId();
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
<%    oidCandidate = FRMQueryString.requestLong(request, "candidate_main_id");
    
                if (oidCandidate != 0){
                    whereClause = PstCandidatePosition.fieldNames[PstCandidatePosition.FLD_CANDIDATE_MAIN_ID]+"="+oidCandidate; 
                }
                
                candPosList = PstCandidatePosition.list(0, 0, whereClause, ""); 
                //if (candPosList != null && candPosList.size()>0){//
                    CandidatePosition candidatePos = (CandidatePosition)candPosList.get(0);
                    /* list of candidate position competency */
                    whereClause = PstCandidatePositionCompetency.fieldNames[PstCandidatePositionCompetency.FLD_CANDIDATE_MAIN_ID]+"="+candidatePos.getCandidateMainId();
                    //Vector posGradeList = PstCandidateGradeRequired.listInnerJoin(whereClause);
                    Vector posExperienceList = PstCandidatePositionExperience.list(0, 0, whereClause, "");
                    Vector posAssessmentListCdd = PstCandidatePositionAssessment.list(0, 0, whereClause, "");
                    whereClause = PstCandidatePositionTraining.fieldNames[PstCandidatePositionTraining.FLD_CANDIDATE_MAIN_ID]+"="+candidatePos.getCandidateMainId();
                    Vector posTrainingList = PstCandidatePositionTraining.list(0, 0, whereClause, "");
                    whereClause = PstCandidatePositionEducation.fieldNames[PstCandidatePositionEducation.FLD_CANDIDATE_MAIN_ID]+"="+candidatePos.getCandidateMainId();
                    Vector posEducationList = PstCandidatePositionEducation.list(0, 0, whereClause, "");
                %>
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
                if (posAssessmentListCdd != null && posAssessmentListCdd.size()>0){ // if (listCompetencyReq != null && listCompetencyReq.size()>0){
                   for (int i=0; i<posAssessmentListCdd.size(); i++){ // for (int i=0; i<listCompetencyReq.size(); i++){
                        CandidatePositionAssessment assReq = (CandidatePositionAssessment)posAssessmentListCdd.get(i); //   PositionCompetencyRequired compReq = (PositionCompetencyRequired)listCompetencyReq.get(i);
                        double assEmpVal = getAssessmentEmp(employeeId, assReq.getAssessmentId());
                        double skorReq = assReq.getScoreMin(); //getScoreReqRecommended();
                        double gap = assEmpVal - skorReq;
                        subTotalSkorReq = subTotalSkorReq + skorReq;
                        subTotalSkorEmp = subTotalSkorEmp + assEmpVal; 
                        subTotalGap = subTotalGap + gap;
                        totalSkorReq = totalSkorReq + skorReq;
                        totalSkorEmp = totalSkorEmp + assEmpVal; 
                        totalGap = totalGap + gap;
                %>
                <tr>
                    <td><%= getAssessmentName(assReq.getAssessmentId())  %></td>
                    <td style="text-align: right"><%= skorReq %></td>
                    <td style="text-align: right"><%= assEmpVal %></td>
                    <td style="text-align: right"><%= String.format("%.2f", gap) %></td>
                </tr>
                <% 
                    }
                    if (posAssessmentListCdd.size()>1){
                    %>
                    <tr >
                        <td>&nbsp;<span style="font-weight: bold">Subtotal</span></td>
                    <td style="text-align: right">&nbsp;<span style="font-weight: bold"><%= subTotalSkorReq %></span></td>
                    <td style="text-align: right">&nbsp;<span style="font-weight: bold"><%= subTotalSkorEmp %></span></td>
                    <td style="text-align: right">&nbsp;<span style="font-weight: bold"><%= String.format("%.2f", subTotalGap) %></span></td>
                    </tr>
                    <%
                    }
                }
                %>
                <tr>
                    <td colspan="4" class="title_tbl" style="background-color: #DDD; color: #007592;">&nbsp;</td>
                </tr>
                <% if (resultType == 1){ %>
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
                if (posTrainingList != null && posTrainingList.size()>0){ //if (listTrainingReq != null && listTrainingReq.size()>0){ 
                   for(int i=0; i<posTrainingList.size(); i++){ //for(int i=0; i<listTrainingReq.size(); i++){
                        CandidatePositionTraining trainReq = (CandidatePositionTraining)posTrainingList.get(i); // PositionTrainingRequired trainReq = (PositionTrainingRequired)listTrainingReq.get(i);
                        double skorReq =trainReq.getScoreMin(); //trainReq.getPointRecommended();
                        double pointEmp = getTrainingEmp(employeeId, trainReq.getTrainingId());
                        if (pointEmp < 1){
                            pointEmp = 1;
                        }
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
                    if (posTrainingList.size()>1){
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
                    <td style="text-align: right"><%= Formater.formatNumber((eduEMpScore-eduReq.getScoreMin()),"###.##") %></td>
                </tr>
                <% 
                    }  
                    if (posEducationList.size()>1){
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
        <div class="page-break"></div>
        
        <%}
          }%>
            
            
    </body>
</html>

<%-- 
    Document   : candidate_main
    Created on : Aug 29, 2016, 3:19:01 PM
    Author     : Dimata 007
--%>

<%@page import="com.dimata.harisma.entity.log.ChangeValue"%>
<%@ include file = "../../main/javainit.jsp" %>
<% int  appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_EMPLOYEE, AppObjInfo.G2_CANDIDATE, AppObjInfo.OBJ_CANDIDATE_SEARCH); %>
<%@ include file = "../../main/checkuser.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
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

    public String getCompetencyName(long oid){
        String name = "-";
        try {
            Competency comp = PstCompetency.fetchExc(oid);
            name = comp.getCompetencyName();
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
    public String getEducationName(long oid){
        String name = "-";
        try {
            Education edu = PstEducation.fetchExc(oid);
            name = edu.getEducation();
        } catch (Exception e){
            System.out.println(e.toString());
        }
        return name;
    }
%>
<%
    int iCommand = FRMQueryString.requestCommand(request);
    long oidCandidate = FRMQueryString.requestLong(request, "candidate_main_id");
    long candidateLocId = FRMQueryString.requestLong(request, "candidate_loc_id");
    long gradeLevelId = FRMQueryString.requestLong(request, "grade_level_id");
    long requestedBy = FRMQueryString.requestLong(request, "requested_by");
    String candidateTitle = FRMQueryString.requestString(request, "candidate_title");
    long candidatePosId = FRMQueryString.requestLong(request, "candidate_pos_id");
    long oidPosition = FRMQueryString.requestLong(request, "position_id");
    
    int addExperience = FRMQueryString.requestInt(request, "add_experience");
	int addExperienceLevel = FRMQueryString.requestInt(request, "add_experience_level");
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
	/* data input candidate position experience */
    long oidCandLevelExper = FRMQueryString.requestLong(request, "oid_cand_level_exper");
    long experienceLevelId = FRMQueryString.requestLong(request, "experience_level_id");
    int experLevelDurMin = FRMQueryString.requestInt(request, "exper_dur_level_min");
    int experLevelDurRecom = FRMQueryString.requestInt(request, "exper_dur_level_recom");
    /* data input candidate position competency */
    long oidCandPosComp = FRMQueryString.requestLong(request, "oid_cand_pos_comp");
    long competencyId = FRMQueryString.requestLong(request, "competency_id");
    int compScoreMin = FRMQueryString.requestInt(request, "comp_score_min");
    int compScoreMax = FRMQueryString.requestInt(request, "comp_score_max");
	int compScoreBobot = FRMQueryString.requestInt(request, "comp_score_bobot");
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
    ChangeValue changeValue = new ChangeValue();
    
    if (iCommand == Command.SAVE){
        CandidateMain candidate = new CandidateMain();
        Date now = new Date();
        candidate.setRequestedBy(requestedBy);
        candidate.setTitle(candidateTitle);
        candidate.setApproveDate1(now);
        candidate.setApproveDate2(now);
        candidate.setApproveDate3(now);
        candidate.setApproveDate4(now);
        candidate.setCreatedDate(now);
        candidate.setDateOfRequest(now);
        candidate.setDueDate(now);
        try {
            oidCandidate = PstCandidateMain.insertExc(candidate);
        } catch(Exception e){
            System.out.println("Output: "+e.toString());
        }
        iCommand = Command.NONE;
    }
    
    if (iCommand == Command.CANCEL){
        try {
            PstCandidatePosition.deleteExc(candidatePosId);
        } catch(Exception e){
            System.out.println(e.toString());
        }
    }
    
    if (candidateLocId != 0 && iCommand == Command.DELETE){
        try {
            PstCandidateLocation.deleteExc(candidateLocId);
        } catch(Exception e){
            System.out.println("Delete candidate location=>"+e.toString());
        }
        iCommand = Command.NONE;
    }
    
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
    
     /* Save Candidate Grade Req*/
    if (addGradeReq == 2){
        CandidateGradeRequired data = new CandidateGradeRequired();
        data.setCandidateMainId(oidCandidate);
        data.setGradeMinimum(new GradeLevel(minGradeLevelId,"",0));
        data.setGradeMaximum(new GradeLevel(maxGradeLevelId,"",0));
        data.setPositionId(oidPosition);
        try {
            PstCandidateGradeRequired.insertExc(data);
        } catch(Exception e){
            System.out.println("Output: "+e.toString());
        }
        addGradeReq = 0;
    }
    // update Position Expirience
    if (addGradeReq == 3){
        CandidateGradeRequired data = new CandidateGradeRequired();
        data.setOID(oidCandGradeReq);
        data.setCandidateMainId(oidCandidate);
        data.setGradeMinimum(new GradeLevel(minGradeLevelId,"",0));
        data.setGradeMaximum(new GradeLevel(maxGradeLevelId,"",0));
        data.setPositionId(oidPosition);
        try {
            PstCandidateGradeRequired.updateExc(data);
        } catch(Exception e){
            System.out.println("Output: "+e.toString());
        }
        addGradeReq = 0; oidCandGradeReq =0;
    }
    
    
    /* Save Candidate Position Experience */
    if (addExperience == 2){
        CandidatePositionExperience data = new CandidatePositionExperience();
        data.setCandidateMainId(oidCandidate);
        data.setExperienceId(experienceId);
        data.setPositionId(oidPosition);
        data.setDurationMin(experDurMin);
        data.setDurationRecommended(experDurRecom);
		data.setType(0);
        try {
            PstCandidatePositionExperience.insertExc(data);
        } catch(Exception e){
            System.out.println("Output: "+e.toString());
        }
        addExperience = 0;
    }
    // update Position Expirience
    if (addExperience == 3){
        CandidatePositionExperience data = new CandidatePositionExperience();
        data.setOID(oidCandPosExper);
        data.setCandidateMainId(oidCandidate);
        data.setExperienceId(experienceId);
        data.setPositionId(oidPosition);
        data.setDurationMin(experDurMin);
        data.setDurationRecommended(experDurRecom);
		data.setType(0);
        try {
            PstCandidatePositionExperience.updateExc(data);
        } catch(Exception e){
            System.out.println("Output: "+e.toString());
        }
        addExperience = 0; oidCandPosExper =0;
    }
	
	/* Save Candidate Level Experience */
    if (addExperienceLevel == 2){
        CandidatePositionExperience data = new CandidatePositionExperience();
        data.setCandidateMainId(oidCandidate);
        data.setExperienceId(experienceLevelId);
        data.setPositionId(oidPosition);
        data.setDurationMin(experDurMin);
        data.setDurationRecommended(experDurRecom);
		data.setType(1);
        try {
            PstCandidatePositionExperience.insertExc(data);
        } catch(Exception e){
            System.out.println("Output: "+e.toString());
        }
        addExperienceLevel = 0;
    }
    // update Level Expirience
    if (addExperienceLevel == 3){
        CandidatePositionExperience data = new CandidatePositionExperience();
        data.setOID(oidCandLevelExper);
        data.setCandidateMainId(oidCandidate);
        data.setExperienceId(experienceLevelId);
        data.setPositionId(oidPosition);
        data.setDurationMin(experDurMin);
        data.setDurationRecommended(experDurRecom);
		data.setType(1);
        try {
            PstCandidatePositionExperience.updateExc(data);
        } catch(Exception e){
            System.out.println("Output: "+e.toString());
        }
        addExperienceLevel = 0; oidCandLevelExper =0;
    }
    
    
    /* Save Candidate Position Competency */
    if (addCompetency == 2){
        CandidatePositionCompetency data = new CandidatePositionCompetency();
        data.setCandidateMainId(oidCandidate);
        data.setCompetencyId(competencyId);
        data.setPositionId(oidPosition);
        data.setScoreMin(compScoreMin);
        data.setScoreMax(compScoreMax);
		data.setBobot(compScoreBobot);
        try {
            PstCandidatePositionCompetency.insertExc(data);
        } catch(Exception e){
            System.out.println("Output: "+e.toString());
        }
        addCompetency = 0;
    }
	/* Edit Candidate Position Competency */
    if (addCompetency == 3){
        CandidatePositionCompetency data = new CandidatePositionCompetency();
		data.setOID(oidCandPosComp);
        data.setCandidateMainId(oidCandidate);
        data.setCompetencyId(competencyId);
        data.setPositionId(oidPosition);
        data.setScoreMin(compScoreMin);
        data.setScoreMax(compScoreMax);
		data.setBobot(compScoreBobot);
        try {
            PstCandidatePositionCompetency.updateExc(data);
        } catch(Exception e){
            System.out.println("Output: "+e.toString());
        }
        addCompetency = 0; oidCandPosComp = 0;
    }
    /* Save Candidate Position Training */
    if (addTraining == 2){
        CandidatePositionTraining data = new CandidatePositionTraining();
        data.setCandidateMainId(oidCandidate);
        data.setTrainingId(trainingId);
        data.setPositionId(oidPosition);
        data.setScoreMin(trainScoreMin);
        data.setScoreMax(trainScoreMax);
        try {
            PstCandidatePositionTraining.insertExc(data);
        } catch(Exception e){
            System.out.println("Output: "+e.toString());
        }
        addTraining = 0;
    }
    /* Save Candidate Position Education */
    if (addEducation == 2){
        CandidatePositionEducation data = new CandidatePositionEducation();
        data.setCandidateMainId(oidCandidate);
        data.setEducationId(educationId);
        data.setPositionId(oidPosition);
        data.setScoreMin(eduScoreMin);
        data.setScoreMax(eduScoreMax);
        try {
            PstCandidatePositionEducation.insertExc(data);
        } catch(Exception e){
            System.out.println("Output: "+e.toString());
        }
        addEducation = 0;
    }
    /* Delete Candidate Position  */
    try {
     if (iCommand != Command.EDIT && iCommand != Command.UPDATE){
        if (oidCandGradeReq != 0){
            PstCandidateGradeRequired.deleteExc(oidCandGradeReq);
        }
         
        if (oidCandPosExper != 0){
            PstCandidatePositionExperience.deleteExc(oidCandPosExper);
        }
        
        if (oidCandPosComp != 0){
            PstCandidatePositionCompetency.deleteExc(oidCandPosComp);
        }
        if (oidCandPosTrain != 0){
            PstCandidatePositionTraining.deleteExc(oidCandPosTrain);
        }
        if (oidCandPosEdu != 0){
            PstCandidatePositionEducation.deleteExc(oidCandPosEdu);
        }
     }
    } catch(Exception e){
        System.out.println("Output: "+e.toString());
    }
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Pencarian Kandidat</title>
        <link rel="stylesheet" href="../../styles/main.css" type="text/css">
        <style type="text/css">
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
            .tblStyle {
                padding: 5px;
            }
            .title_tbl {
                font-weight: bold;
                padding-right: 11px;
            }
            .title {
                background-color: #FFF;
                border-left: 1px solid #007592;
                padding: 11px;
            }
            .tbl-style {border-collapse: collapse; font-size: 12px;}
            .tbl-style td {padding: 7px 9px; border: 1px solid #CCC; font-size: 12px;}
            .tblStyle1 {border-collapse: collapse; font-size: 12px; background-color: #FFF;}
            .tblStyle1 td {padding: 7px 9px; border: 1px solid #CCC; font-size: 12px; }
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
            function cmdSave(){
                document.frm.command.value="<%= Command.SAVE %>";
                document.frm.action="candidate_main.jsp";
                document.frm.submit();
            }
            function cmdAddLocation(oid){
                document.frm.candidate_main_id.value=oid;
                document.frm.code_org.value='0';
                document.frm.action="organization_selection.jsp";
                document.frm.submit();
            }
            function cmdDeleteCandLoc(oid){
               if(confirm("Delete Lokasi ?")){
                document.frm.candidate_loc_id.value=oid;
                document.frm.command.value="<%= Command.DELETE %>";
                document.frm.action="candidate_main.jsp";
                document.frm.submit();
               }
            }
            function cmdAddResource(oid){
                document.frm.candidate_main_id.value=oid;
                document.frm.code_org.value='1';
                document.frm.action="organization_selection.jsp";
                document.frm.submit();
            }
            function cmdAddEmp(){
                newWindow=window.open("source_employee.jsp","SourceEmployee", "height=600, width=500, status=yes, toolbar=no, menubar=no, location=center, scrollbars=yes");
                newWindow.focus();
            }
            function cmdAddGrade(oid){
                newWindow=window.open("grade_data.jsp?candidate_main_id="+oid,"GradeData", "height=600,width=500,status=yes,toolbar=no,menubar=no,location=center,scrollbars=yes");
                newWindow.focus();
            }
            function cmdAddEducation(){
                document.frm.action="education_selection.jsp";
                document.frm.submit();
            }
            function cmdAddExperience(){
                document.frm.action="experience_selection.jsp";
                document.frm.submit();
            }
            function cmdAddPosition(){
                document.frm.action="position_selection.jsp";
                document.frm.submit();
            }
            function cmdProses(){
                document.frm.command.value="<%= Command.SAVE %>";
                document.frm.action="candidate_process.jsp";
                document.frm.submit();
            }
            function cmdAddPosition(oid){
                document.frm.candidate_main_id.value=oid;
                document.frm.action="position_select.jsp";
                document.frm.submit();
            }
            function cmdBatalPilih(oid){
                document.frm.command.value="<%= Command.CANCEL %>";
                document.frm.candidate_pos_id.value=oid;
                document.frm.action="candidate_main.jsp";
                document.frm.submit();
            }
            
            
             function cmdAddGradeReq(oid){
                document.frm.add_grade_req.value=1;
                document.frm.candidate_main_id.value=oid;
                document.frm.action="candidate_main.jsp";
                document.frm.submit();
            }
                        
            function cmdSaveGradeReq(oid, oidPos){
                document.frm.add_grade_req.value=2;
                document.frm.candidate_main_id.value=oid;
                document.frm.position_id.value=oidPos;
                document.frm.action="candidate_main.jsp";
                document.frm.submit();
            }
            
            function cmdUpdateGradeReq(oid, oidPos, oidDataCan){
                document.frm.add_grade_req.value=3;
                document.frm.oid_cand_grade_req.value=oidDataCan;
                document.frm.candidate_main_id.value=oid;
                document.frm.position_id.value=oidPos;
                document.frm.action="candidate_main.jsp";
                document.frm.submit();
            }
            
            
            function cmdEditGradeReq(oid){                   
                document.frm.oid_cand_grade_req.value=oid;
                document.frm.command.value=<%= Command.EDIT %>;
                document.frm.action="candidate_main.jsp";
                document.frm.submit();
            }
            function cmdDeleteGradeReq(oid){
              if(confirm("Delete Grade ?")){
                document.frm.oid_cand_grade_req.value=oid;
                document.frm.action="candidate_main.jsp";
                document.frm.submit();
              }
            }
            
            
            function cmdAddExperience(oid){
                document.frm.add_experience.value=1;
                document.frm.candidate_main_id.value=oid;
                document.frm.action="candidate_main.jsp";
                document.frm.submit();
            }
                        
            function cmdSaveExperience(oid, oidPos){
                document.frm.add_experience.value=2;
                document.frm.candidate_main_id.value=oid;
                document.frm.position_id.value=oidPos;
                document.frm.action="candidate_main.jsp";
                document.frm.submit();
            }
            
            function cmdUpdateExperience(oid, oidPos, oidDataCan){
                document.frm.add_experience.value=3;
                document.frm.oid_cand_pos_exper.value=oidDataCan;
                document.frm.candidate_main_id.value=oid;
                document.frm.position_id.value=oidPos;
                document.frm.action="candidate_main.jsp";
                document.frm.submit();
            }
            
            function cmdAddCompetency(oid){
                document.frm.add_competency.value=1;
                document.frm.candidate_main_id.value=oid;
                document.frm.action="candidate_main.jsp";
                document.frm.submit();
            }
                        
            function cmdSaveCompetency(oid, oidPos){
                document.frm.add_competency.value=2;
                document.frm.candidate_main_id.value=oid;
                document.frm.position_id.value=oidPos;
                document.frm.action="candidate_main.jsp";
                document.frm.submit();
            }
			
			function cmdUpdateCompetency(oid, oidPos, oidDataCan){
                document.frm.add_competency.value=3;
                document.frm.oid_cand_pos_comp.value=oidDataCan;
                document.frm.candidate_main_id.value=oid;
                document.frm.position_id.value=oidPos;
                document.frm.action="candidate_main.jsp";
                document.frm.submit();
            }
			
            function cmdAddTraining(oid){
                document.frm.add_training.value=1;
                document.frm.candidate_main_id.value=oid;
                document.frm.action="candidate_main.jsp";
                document.frm.submit();
            }
			
            function cmdSaveTraining(oid, oidPos){
                document.frm.add_training.value=2;
                document.frm.candidate_main_id.value=oid;
                document.frm.position_id.value=oidPos;
                document.frm.action="candidate_main.jsp";
                document.frm.submit();
            }
            
            function cmdAddEducation(oid){
                document.frm.add_education.value=1;
                document.frm.candidate_main_id.value=oid;
                document.frm.action="candidate_main.jsp";
                document.frm.submit();
            }
            function cmdSaveEducation(oid, oidPos){
                document.frm.add_education.value=2;
                document.frm.candidate_main_id.value=oid;
                document.frm.position_id.value=oidPos;
                document.frm.action="candidate_main.jsp";
                document.frm.submit();
            }
                        
            function cmdEditExperience(oid){                
                document.frm.oid_cand_pos_exper.value=oid;
                document.frm.command.value=<%= Command.EDIT %>;
                document.frm.action="candidate_main.jsp";
                document.frm.submit();
            }
			function cmdEditCompetency(oid){                
                document.frm.oid_cand_pos_comp.value=oid;
                document.frm.command.value=<%= Command.EDIT %>;
                document.frm.action="candidate_main.jsp";
                document.frm.submit();
            }
            function cmdDeleteExperience(oid){
              if(confirm("Delete Pengalaman Kerja ?")){
                document.frm.oid_cand_pos_exper.value=oid;
                document.frm.action="candidate_main.jsp";
                document.frm.submit();
              }
            }
            
            function cmdDeleteCompetency(oid){
               if(confirm("Delete Kompetensi ?")){
                document.frm.oid_cand_pos_comp.value=oid;
                document.frm.action="candidate_main.jsp";
                document.frm.submit();
             }
            }
            function cmdDeleteTraining(oid){
                if(confirm("Delete Training ?")){
                document.frm.oid_cand_pos_train.value=oid;
                document.frm.action="candidate_main.jsp";
                document.frm.submit();
              }
            }
            function cmdDeleteEdu(oid){
               if(confirm("Delete Pendidikan ?")){
                document.frm.oid_cand_pos_edu.value=oid;
                document.frm.action="candidate_main.jsp";
                document.frm.submit();
               }
            }
        </script>
    </head>
    <body>
        <div class="header">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <%if (headerStyle && !verTemplate.equalsIgnoreCase("0")) {%> 
            <%@include file="../../styletemplate/template_header.jsp" %>
            <%} else {%>
            <tr> 
                <td ID="TOPTITLE" background="<%=approot%>/images/HRIS_HeaderBg3.jpg" width="100%" height="54"> 
                    <!-- #BeginEditable "header" --> 
                    <%@ include file = "../../main/header.jsp" %>
                    <!-- #EndEditable --> 
                </td>
            </tr>
            <tr> 
                <td  bgcolor="#9BC1FF" height="15" ID="MAINMENU" valign="middle"> <!-- #BeginEditable "menumain" --> 
                    <%@ include file = "../../main/mnmain.jsp" %>
                    <!-- #EndEditable --> </td>
            </tr>
            <tr> 
                <td  bgcolor="#9BC1FF" height="10" valign="middle"> 
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr> 
                            <td align="left"><img src="<%=approot%>/images/harismaMenuLeft1.jpg" width="8" height="8"></td>
                            <td align="center" background="<%=approot%>/images/harismaMenuLine1.jpg" width="100%"><img src="<%=approot%>/images/harismaMenuLine1.jpg" width="8" height="8"></td>
                            <td align="right"><img src="<%=approot%>/images/harismaMenuRight1.jpg" width="8" height="8"></td>
                        </tr>
                    </table>
                </td>
            </tr>
            <%}%>
            </table>
        </div>
        <div id="menu_utama">
            <span id="menu_title"><strong>Candidate</strong> <strong style="color:#333;"> / </strong>Pencarian</span>
        </div>
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
                <h1 style="color:#575757">Pencarian Kandidat</h1>
                <div class="title">Information dasar</div>
                <table class="tblStyle">
                    <tr>
                        <td class="title_tbl">Diminta oleh</td>
                        <td>
                            <input type="hidden" name="requested_by" value="" />
                            <div id="browse" onclick="javascript:cmdAddEmp()"><%= dimintaOleh %></div>
                        </td>
                    </tr>
                    <tr>
                        <td class="title_tbl">Judul dokumen</td>
                        <td> <input type="text" name="candidate_title" value="<%= candidateMain.getTitle() %>" size="50" /> </td>
                    </tr>
                    
                    <tr>
                        <td class="title_tbl">Status Karyawan</td>
                        <td>
                            <input type="checkbox" name="status_aktif" value="1" checked> AKTIF &nbsp;  
                            <input type="checkbox" name="status_mbt" value="1" > MBT  &nbsp;  
                            <input type="checkbox" name="status_berhenti" value="1" > BERHENTI  
                        </td>                        
                    </tr>
                    
                </table>
                <div>&nbsp;</div>
                <% if (oidCandidate == 0){ %>
                <a href="javascript:cmdSave()" style="color:#FFF;" class="btn">Simpan dan Lanjutkan</a>
                <% } %>
                <div>&nbsp;</div>
                <% if (oidCandidate != 0){ %>
                <div class="title">Dilokasikan (optional)</div>
                <div>&nbsp;</div>
                <a href="javascript:cmdAddLocation('<%=oidCandidate%>')" class="btn-small">Tambah Penempatan</a>
                <div>&nbsp;</div>
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
                                <td><div id="close" onclick="javascript:cmdDeleteCandLoc('<%= org.getOID() %>')">&times;</div></td>
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
                <div class="title">Pilih jabatan untuk proses kandidat?</div>
                <div>&nbsp;</div>
                <a href="javascript:cmdAddPosition('<%=oidCandidate%>')" class="btn-small">Pilih Jabatan</a>
                <div>&nbsp;</div>
                <%
                if (oidCandidate != 0){
                    whereClause = PstCandidatePosition.fieldNames[PstCandidatePosition.FLD_CANDIDATE_MAIN_ID]+"="+oidCandidate; 
                }
                
                Vector candPosList = PstCandidatePosition.list(0, 0, whereClause, ""); 
                if (candPosList != null && candPosList.size()>0){
                    CandidatePosition candidatePos = (CandidatePosition)candPosList.get(0);
                    /* list of candidate position competency */
                    whereClause = PstCandidatePositionCompetency.fieldNames[PstCandidatePositionCompetency.FLD_CANDIDATE_MAIN_ID]+"="+candidatePos.getCandidateMainId();
                    Vector posGradeList = PstCandidateGradeRequired.listInnerJoin(whereClause);
                    Vector posExperienceList = PstCandidatePositionExperience.list(0, 0, whereClause, "");
                    Vector posCompetencyList = PstCandidatePositionCompetency.list(0, 0, whereClause, "");
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
                                <td colspan="4" style="background-color: #EEE; font-weight: bold;">
                                    <a href="javascript:cmdAddGradeReq('<%= oidCandidate %>')">Tambah Daftar Grade</a>
                                </td>
                            </tr>
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
                               
                                <td><a href="javascript:cmdUpdateGradeReq('<%= oidCandidate %>','<%= candidatePos.getPositionId() %>','<%=oidCandGradeReq %>')">Save</a></td>
                            <% } else {%>
                               <td><%= dataGrade.getGradeMinimum().getCodeLevel()  %></td>
                               <td><%= dataGrade.getGradeMaximum().getCodeLevel() %></td>
                               <td>
                                   <a href="javascript:cmdEditGradeReq('<%= dataGrade.getOID() %>')">Edit</a>&nbsp;|
                                   <a href="javascript:cmdDeleteGradeReq('<%= dataGrade.getOID() %>')">Delete</a>
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
                                <td><a href="javascript:cmdSaveGradeReq('<%= oidCandidate %>','<%= candidatePos.getPositionId() %>')">Save</a></td>
                            </tr>
                            <% } %>
                        </table>
                        <div>&nbsp;</div>
                        
                        <table class="tblStyle1">
                            <tr>
                                <td colspan="4" style="background-color: #EEE; font-weight: bold;">
                                    <a href="javascript:cmdAddExperience('<%= oidCandidate %>')">Tambah Daftar Pengalaman</a>
                                </td>
                            </tr>
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
                                <td><a href="javascript:cmdUpdateExperience('<%= oidCandidate %>','<%= candidatePos.getPositionId() %>','<%=oidCandPosExper %>')">Save</a></td>
                            <% } else {%>
                               <td><%= getExpirencePosition(dataPosExp.getExperienceId())  %></td>
                               <td><%= dataPosExp.getDurationMin() %> bulan</td>
                               <td><%= dataPosExp.getDurationRecommended() %> bulan</td>
                               <td>
                                   <a href="javascript:cmdEditExperience('<%= dataPosExp.getOID() %>')">Edit</a>&nbsp;|
                                   <a href="javascript:cmdDeleteExperience('<%= dataPosExp.getOID() %>')">Delete</a>
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
                                <td><a href="javascript:cmdSaveExperience('<%= oidCandidate %>','<%= candidatePos.getPositionId() %>')">Save</a></td>
                            </tr>
                            <% } %>
                        </table>
                        <div>&nbsp;</div>
                        
                        <table class="tblStyle1">
                            <tr>
                                <td colspan="5" style="background-color: #EEE; font-weight: bold;">
                                    <a href="javascript:cmdAddCompetency('<%= oidCandidate %>')">Tambah Daftar Kompetensi</a>
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
                            if (posCompetencyList != null && posCompetencyList.size()>0){
                                for (int i=0; i<posCompetencyList.size(); i++){
                                    CandidatePositionCompetency dataPosComp = (CandidatePositionCompetency)posCompetencyList.get(i);
                            %>
                                    <tr>
										<% if ( (dataPosComp.getOID() == oidCandPosComp) && (iCommand == Command.EDIT)){ %>
											<td>
												<select name="competency_id">
													<option value="0" >-SELECT-</option>
												  <%
												  Vector competencyList = PstCompetency.list(0, 0, "", "");
													if (competencyList != null && competencyList.size()>0){
													  for (int ix=0; ix<competencyList.size(); ix++){
															Competency competency = (Competency)competencyList.get(ix);
														  %>
														  <option value="<%= competency.getOID() %>"  <%=((dataPosComp.getCompetencyId()== competency.getOID())?"selected":"") %>  ><%= competency.getCompetencyName() %></option>
														  <%
													  }
												  }
												  %>
											  </select>
										  </td>
											<td><input type="text" name="comp_score_min" value="<%= dataPosComp.getScoreMin() %>" size="10" /></td>
											<td><input type="text" name="comp_score_max" value="<%= dataPosComp.getScoreMax() %>" size="10" /></td>
											<td><input type="text" name="comp_score_bobot" value="<%= dataPosComp.getBobot() %>" size="10" /></td>
											<td><a href="javascript:cmdUpdateCompetency('<%= oidCandidate %>','<%= candidatePos.getPositionId() %>','<%=oidCandPosComp %>')">Save</a></td>
									  <% } else {%>
                                        <td><%= getCompetencyName(dataPosComp.getCompetencyId())  %></td>
                                        <td><%= dataPosComp.getScoreMin() %></td>
                                        <td><%= dataPosComp.getScoreMax() %></td>
										<td><%= dataPosComp.getBobot()%></td>
                                        <td>
                                            <a href="javascript:cmdEditCompetency('<%= dataPosComp.getOID() %>')">Edit</a>&nbsp;|
                                            <a href="javascript:cmdDeleteCompetency('<%= dataPosComp.getOID() %>')">Delete</a>
                                        </td>
										<% } %>
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
								<td><input type="text" name="comp_score_bobot" value="" size="10" /></td>
                                <td><a href="javascript:cmdSaveCompetency('<%= oidCandidate %>','<%= candidatePos.getPositionId() %>')">Save</a></td>
                            </tr>
                            <% } %>
                        </table>
                        <div>&nbsp;</div>
                        <table class="tblStyle1">
                            <tr>
                                <td colspan="4" style="background-color: #EEE; font-weight: bold;">
                                    <a href="javascript:cmdAddTraining('<%= oidCandidate %>')">Tambah Daftar Pelatihan</a>
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
                                    <a href="javascript:cmdEditTraining()">Edit</a>&nbsp;|
                                    <a href="javascript:cmdDeleteTraining('<%= train.getOID() %>')">Delete</a>
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
                                <td><a href="javascript:cmdSaveTraining('<%= oidCandidate %>','<%= candidatePos.getPositionId() %>')">Save</a></td>
                            </tr>
                            <% } %>
                        </table>
                        <div>&nbsp;</div>
                        <table class="tblStyle1">
                            <tr>
                                <td colspan="4" style="background-color: #EEE; font-weight: bold;">
                                    <a href="javascript:cmdAddEducation('<%= oidCandidate %>')">Tambah Daftar Pendidikan</a>
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
                                    <a href="javascript:cmdEditEdu()">Edit</a>&nbsp;|
                                    <a href="javascript:cmdDeleteEdu('<%= dataPosEdu.getOID() %>')">Delete</a>
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
                                <td><a href="javascript:cmdSaveEducation('<%= oidCandidate %>','<%= candidatePos.getPositionId() %>')">Save</a></td>
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
                        <a href="javascript:cmdBatalPilih('<%= candidatePos.getOID() %>')" class="btn-small">Hapus Pilihan Jabatan</a>
                        <div>&nbsp;</div>
                    </div>
                </div>
                <% } %>
                <div>&nbsp;</div>
                <div class="title">Sumber pencarian</div>
                <div>&nbsp;</div>
                <a href="javascript:cmdAddResource('<%=oidCandidate%>')" class="btn-small">Tambah Sumber Pencarian</a>
                <div>&nbsp;</div>
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
                                <td><div id="close" onclick="javascript:cmdDeleteCandLoc('<%= org.getOID() %>')">&times;</div></td>
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
                <div>&nbsp;</div>
                <div style="border-top:1px solid #CCC;">&nbsp;</div>
                <div>&nbsp;</div>
                <a href="javascript:cmdProses()" style="color:#FFF;" class="btn">Simpan dan Proses</a>
                <% } %>
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
            </form>
        </div>
            
              
        <div class="footer-page">
            <table>
                <%if (headerStyle && !verTemplate.equalsIgnoreCase("0")) {%>
                <tr>
                    <td valign="bottom"><%@include file="../../footer.jsp" %></td>
                </tr>
                <%} else {%>
                <tr> 
                    <td colspan="2" height="20" ><%@ include file = "../../main/footer.jsp" %></td>
                </tr>
                <%}%>
            </table>
        </div>
    </body>
</html>
<!--
<a href="javascript:cmdAddGrade('<%=oidCandidate%>')" class="btn-small">Tambah Filter Grade</a>
<div>&nbsp;</div>
<div>&nbsp;</div>
<a href="javascript:cmdAddPenilaian()" class="btn-small">Tambah Filter Penilaian</a>
<div>&nbsp;</div>
<div>&nbsp;</div>
<a href="javascript:cmdAddTraining()" class="btn-small">Tambah Filter Training</a>
<div>&nbsp;</div>
<div>&nbsp;</div>
<a href="javascript:cmdAddEducation()" class="btn-small">Tambah Filter Pendidikan</a>
<div>&nbsp;</div>
<div>&nbsp;</div>
<a href="javascript:cmdAddExperience()" class="btn-small">Tambah Filter Pengalaman</a>
<div>&nbsp;</div>
<div>&nbsp;</div>
<a href="javascript:cmdAddPosition()" class="btn-small">Tambah Filter Jabatan</a>
-->
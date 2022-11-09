<%-- 
    Document   : candidate_process
    Created on : Sep 28, 2016, 2:50:51 PM
    Author     : Dimata 007
--%>
<%@page import="com.dimata.qdep.db.DBHandler"%>
<%@page import="com.dimata.harisma.session.employee.SessCandidateParam"%>
<%@page import="com.dimata.harisma.session.employee.SessEmployeePicture"%>
<%@page import="com.dimata.harisma.session.employee.EmployeeCandidate"%>
<%@page import="com.dimata.harisma.session.employee.SessCandidate"%>
<%@page import="org.apache.poi.util.SystemOutLogger"%>
<%@page import="com.dimata.harisma.entity.log.ChangeValue"%>
<%@ include file = "../../main/javainit.jsp" %>
<% int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_EMPLOYEE, AppObjInfo.G2_CANDIDATE, AppObjInfo.OBJ_CANDIDATE_SEARCH);%>
<%@ include file = "../../main/checkuser.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%//
    int iCommand = FRMQueryString.requestCommand(request);
    long oidCandidate = FRMQueryString.requestLong(request, "candidate_main_id");
	
	long candidateLocId = FRMQueryString.requestLong(request, "candidate_loc_id");
    long gradeLevelId = FRMQueryString.requestLong(request, "grade_level_id");
    long requestedBy = FRMQueryString.requestLong(request, "requested_by");
    String candidateTitle = FRMQueryString.requestString(request, "candidate_title");
    long candidatePosId = FRMQueryString.requestLong(request, "candidate_pos_id");
    long oidPosition = FRMQueryString.requestLong(request, "position_id");
	
    long positionId = FRMQueryString.requestLong(request, "position_id");
    String[] checkEmp = FRMQueryString.requestStringValues(request, "check_emp");
    ChangeValue changeValue = new ChangeValue();
    boolean status_aktif = FRMQueryString.requestBoolean(request, "status_aktif");
    boolean status_mbt = FRMQueryString.requestBoolean(request, "status_mbt");
    boolean status_berhenti = FRMQueryString.requestBoolean(request, "status_berhenti");
    long posTypeId = FRMQueryString.requestLong(request, "position_type");
    SessCandidateParam parameters = new SessCandidateParam();
    parameters.setEmployeeStatusActiv(status_aktif);
    parameters.setEmployeeStatusMBT(status_mbt);
    parameters.setEmployeeStatusResigned(status_berhenti);

    CandidateMain candidateMain = new CandidateMain();
    String dimintaOleh = "Browse";
    String whereClause = "";
    Vector listLocation = new Vector();
    
    if (iCommand == Command.SUBMIT){
        String[] chkEmp = FRMQueryString.requestStringValues(request, "check_emp");
        try {
            final String sql = "DELETE FROM hr_emp_talent_pool WHERE MAIN_ID =" + oidCandidate+" AND POSITION_TYPE_ID="+posTypeId;
            DBHandler.execUpdate(sql);
        }
        catch (Exception e) {
            e.printStackTrace();
        }
        if (chkEmp != null){
            for (int i=0; i < chkEmp.length; i++){
                try {
                    double totalScore = FRMQueryString.requestDouble(request, "total_score_"+chkEmp[i]);
                    EmpTalentPool empTalentPool = new EmpTalentPool();
                    empTalentPool.setEmployeeId(Long.valueOf(chkEmp[i]));
                    empTalentPool.setDateTalent(new Date());
                    empTalentPool.setMainId(oidCandidate);
                    empTalentPool.setPosType(posTypeId);
                    empTalentPool.setTotalScore(totalScore);
                    PstEmpTalentPool.insertExc(empTalentPool);
                    
                } catch (Exception exc){}
                
            }
        }
    }
    
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
			
			String whereCandidate = PstCandidatePosition.fieldNames[PstCandidatePosition.FLD_CANDIDATE_MAIN_ID]+"="+oidCandidate; 
			Vector candPosList = PstCandidatePosition.list(0, 0, whereCandidate, ""); 
			if (candPosList != null && candPosList.size()>0){
				CandidatePosition candidatePos = (CandidatePosition)candPosList.get(0);
				positionId = candidatePos.getPositionId();
			}
        } catch(Exception e){
            System.out.println("Output: "+e.toString());
        }
    }
	
	whereClause = PstCandidateGradeRequired.fieldNames[PstCandidateGradeRequired.FLD_CANDIDATE_MAIN_ID] + "=" + oidCandidate;
	Vector listGradeRequired = PstCandidateGradeRequired.listInnerJoin(whereClause);
		
	
	Vector candidateList = new Vector();
        if (posTypeId>0){
            parameters.setEmployeePositionType(posTypeId);
        } else {
            Vector posTypeList = PstPositionType.list(0, 0, "", "");
            if (posTypeList.size() > 0){
                PositionType posType = (PositionType) posTypeList.get(0);
                parameters.setEmployeePositionType(posType.getOID());
            }
        }
	if (positionId!=0 && listGradeRequired.size()>0){
		candidateList = SessCandidate.queryCandidateV2(oidCandidate, positionId, parameters);
	}


%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Proses Talent</title>
        <link rel="stylesheet" href="../../styles/main.css" type="text/css">
        <link rel="stylesheet" type="text/css" href="../../styles/SlidePushMenu/css/component.css" />
        <style type="text/css">
            
             /* The alert message box */
            .alert {
              padding: 20px;
              background-color: #4CAF50;; /* Red */
              color: white;
              margin-bottom: 15px;
            }

            /* The close button */
            .closebtn {
              margin-left: 15px;
              color: white;
              font-weight: bold;
              float: right;
              font-size: 22px;
              line-height: 20px;
              cursor: pointer;
              transition: 0.3s;
            }

            /* When moving the mouse over the close button */
            .closebtn:hover {
              color: black;
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
			
			.tblStyle {
                padding: 5px;
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

            .floating-menu {
                font-family: sans-serif;
                background: yellowgreen;
                padding: 5px;
                position: fixed;
                right:0;
            }

            .floating-menu h3 {
                display: block;
                margin: 0 0.5em;
                color: white;
                cursor: pointer;
            }

            .cbp-spmenu-open {
                width: 35%;
            }

            .cbp-spmenu {
                background: #DDD;
            }

            .filter-group {
                padding: 10px;
                padding-top: 0px;
            }

            .title_tbl {
/*                white-space: nowrap;*/
				text-align: center;
            }
			
			.collapsible {
				background-color: #a3d73a;
				color: white;
				cursor: pointer;
				padding: 5px;
				width: 100%;
				border: none;
				text-align: left;
				outline: none;
				font-size: 15px;
			  }
			  
			  .active, .collapsible:hover {
				background-color: #8cbe27;
			  }

			  .content {
				padding: 0 18px;
				display: none;
				overflow: hidden;
				background-color: #f1f1f1;
			  }
			  
			.imgcontainer {
				width: 70px;
				height: 100px;
				overflow: hidden;
				margin: 10px;
				position: relative;
			}
			.img {
				position: absolute;
				left: -1000%;
				right: -1000%;
				top: -1000%;
				bottom: -1000%;
				margin: auto;
				min-height: 100%;
				min-width: 100%;
			}

        </style>
		<style>
			.loader {
			  border: 16px solid #f3f3f3;
			  border-radius: 50%;
			  border-top: 16px solid #3498db;
			  width: 120px;
			  height: 120px;
			  -webkit-animation: spin 2s linear infinite; /* Safari */
			  animation: spin 2s linear infinite;
			}

			/* Safari */
			@-webkit-keyframes spin {
			  0% { -webkit-transform: rotate(0deg); }
			  100% { -webkit-transform: rotate(360deg); }
			}

			@keyframes spin {
			  0% { transform: rotate(0deg); }
			  100% { transform: rotate(360deg); }
			}
		</style>
        <script type="text/javascript">
            function cmdBack(oid) {
                document.frm.command.value = "<%=Command.VIEW%>";
                document.frm.candidate_main_id.value = oid;
                document.frm.action = "candidate_main.jsp";
                document.frm.submit();
            }

            function cmdPrint(oid) {
                document.frm.command.value = "<%=Command.VIEW%>";
                document.frm.candidate_main_id.value = oid;
                document.frm.action = "candidate_print.jsp";
                document.frm.target = "_print";
                document.frm.submit();
            }
			
            function cmdExcel(oid) {
                document.frm.command.value = "<%=Command.VIEW%>";
                document.frm.candidate_main_id.value = oid;
                document.frm.action = "candidate_excel.jsp";
                document.frm.submit();
            }

            function cmdDetail(oid, positionId) {
                document.frm.employee_id.value = oid;
                document.frm.position_id.value = positionId;
                document.frm.action = "candidate_detail.jsp";
                document.frm.target = "_blank";
                document.frm.submit();
            }
            function cmdToTalentPool() {
                document.frm.action = "candidate_process.jsp";
                document.frm.submit();
            }
            
            

            function cmdOpenEmployee(oid) {
                document.frm.employee_oid.value = oid;
                document.frm.command.value = "<%=Command.EDIT%>";
                //document.frm.prev_command.value="<%=Command.EDIT%>";
                document.frm.action = "../databank/employee_edit.jsp";
                document.frm.target = "_blank";
                document.frm.submit();
            }
			
            function cmdSave(){
                document.frm.command.value="<%= Command.SAVE %>";
                document.frm.action="candidate_process_simple.jsp";
                document.frm.submit();
            }
            
            function cmdProccess(){
                document.frm.command.value="<%= Command.SUBMIT %>";
                document.frm.action="candidate_process_simple.jsp";
                document.frm.submit();
            }
            
            function cmdAddPosition(oid){
                document.frm.candidate_main_id.value=oid;
                document.frm.action="position_select.jsp";
                document.frm.submit();
            }
            
            function cmdBack(){
                document.frm.candidate_main_id.value=0;
                document.frm.action="candidate_list.jsp";
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
                document.frm.action="candidate_process_simple.jsp";
                document.frm.submit();
               }
            }
        </script>
            
        <script>
            
            
            function SetAllCheckBoxes(FormName, FieldName, CheckValue)
                {
                    if (CheckValue){
                        var clist=document.getElementsByClassName("chk");
                        for (var i = 0; i < clist.length; ++i) { clist[i].checked = "checked"; }
                    } else {
                        var clist=document.getElementsByClassName("chk");
                        for (var i = 0; i < clist.length; ++i) { clist[i].checked = ""; }
                    }
                }
            
			function status(){
				alert(this.value);
			}
			function changeGrade(){
				var sel = document.getElementById('levelGrade');
				var selected = sel.options[sel.selectedIndex];
				var min = selected.getAttribute('data-min');	
				var max = selected.getAttribute('data-max');	
				var gradeMin = document.getElementById("gradeMin");
				gradeMin.value = min;
				var gradeMax = document.getElementById("gradeMax");
				gradeMax.value = max;
			}
            function loadAjax(action, parameter) {
                var xhttp = new XMLHttpRequest();
                xhttp.onreadystatechange = function () {
                    if (this.readyState == 4 && this.status == 200) {
                        if (action === "listGrade" || action === "addGrade" || action === "editGrade" || action === "saveGrade" || action === "saveOnlyGrade" || action === "deleteGrade") {
                            document.getElementById("form-grade").innerHTML = this.responseText;
                        } else if (action === "listExperience" || action === "addExperience" || action === "editExperience" || action === "saveExperience" || action === "saveOnlyExperience" || action === "deleteExperience") {
                            document.getElementById("form-experience").innerHTML = this.responseText;
                        } else if (action === "listExperienceLevel" || action === "addExperienceLevel" || action === "editExperienceLevel" || action === "saveExperienceLevel" || action === "saveOnlyExperienceLevel" || action === "deleteExperienceLevel") {
                            document.getElementById("form-experience-level").innerHTML = this.responseText;
                        }  else if (action === "listAssessment" || action === "addAssessment" || action === "editAssessment" || action === "saveAssessment" || action === "saveOnlyAssessment" || action === "deleteAssessment") {
                            document.getElementById("form-assessment").innerHTML = this.responseText;
                        } /*else if (action === "listTraining" || action === "addTraining" || action === "editTraining" || action === "saveTraining" || action === "saveOnlyTraining" || action === "deleteTraining") {
                            document.getElementById("form-training").innerHTML = this.responseText;
                        } */ else if (action === "listEducation" || action === "addEducation" || action === "editEducation" || action === "saveEducation" || action === "saveOnlyEducation" || action === "deleteEducation") {
                            document.getElementById("form-education").innerHTML = this.responseText;
                        } else if (action === "listCandidatLocation" || action === "saveCandidatLocation" || action === "saveOnlyCandidatLocation" || action === "deleteCandidatLocation") {
                            document.getElementById("list-candidat-location").innerHTML = this.responseText;
                        } else if (action === "addCandidatLocation" || action === "editCandidatLocation") {
                            document.getElementById("form-candidat-location").innerHTML = this.responseText;
                        } else if (action === "listDivision") {
                            document.getElementById("divisionId").innerHTML = this.responseText;
                            listDepartment()();
                        } else if (action === "listDepartment") {
                            document.getElementById("departmentId").innerHTML = this.responseText;
                            listSection();
                        } else if (action === "listSection") {
                            document.getElementById("sectionId").innerHTML = this.responseText;
                        } else if (action === "listCandidat") {
                            document.getElementById("candidat-list").innerHTML = this.responseText;
                        }
                        
                        if (action === "saveGrade" || action === "saveExperience" || action === "saveExperienceLevel" || action === "saveCompetency" || action === "saveAssessment" || action === "saveTraining" || action === "saveEducation" || action === "saveCandidatLocation") {
                            listCandidat();
                        }
                        if (action === "deleteGrade" || action === "deleteExperience" || action === "deleteExperienceLevel" || action === "deleteCompetency" || action === "deleteAssessment" || action === "deleteTraining" || action === "deleteEducation" || action === "deleteCandidatLocation") {
                            listCandidat();
                        }
                        
                    }
                };
                var url = "ajaxAction.jsp?candidate_main_id=<%=oidCandidate%>&action=" + action + parameter;
                xhttp.open("GET", url, true);
                xhttp.send();
            }

            function saveGrade(type) {
                var candidatGradeId = document.getElementById("candidatGradeId").value;
                var gradeMin = document.getElementById("gradeMin").value;
                var gradeMax = document.getElementById("gradeMax").value;
                var kondisi = "0";
                
                var parameter = "&command=<%=Command.SAVE %>";
                parameter += "&position_id=<%=positionId%>";
                parameter += "&oid_cand_grade_req=" + candidatGradeId;
                parameter += "&min_grade_level_id=" + gradeMin;
                parameter += "&max_grade_level_id=" + gradeMax;
                parameter += "&kondisi_grade_level_id=" + kondisi;
                
				if (type===1){
					loadAjax("saveGrade", parameter);
				} else {
					loadAjax("saveOnlyGrade", parameter);
				}
            }

            function saveExperience(type) {
                var candidatExpId = document.getElementById("candidatExpId").value;
                var experienceId = document.getElementById("experienceId").value;
                var experDurMin = document.getElementById("minDuration").value;
                var experDurRecom = document.getElementById("recDuration").value;
                var expKondisi = document.getElementById("kondisiExp").value;
                
                var parameter = "&command=<%=Command.SAVE %>";
                parameter += "&position_id=<%=positionId%>";
                parameter += "&oid_cand_pos_exper=" + candidatExpId;
                parameter += "&experience_id=" + experienceId;
                parameter += "&exper_dur_min=" + experDurMin;
                parameter += "&exper_dur_recom=" + experDurRecom;
                parameter += "&exper_kondisi=" + expKondisi;
                
				if (type===1){
					loadAjax("saveExperience", parameter);
				} else {
					loadAjax("saveOnlyExperience", parameter);	
				}
            }
			
			function saveExperienceLevel(type) {
                var candidatExpLevelId = document.getElementById("candidatExpLevelId").value;
                var experienceLevelId = document.getElementById("experienceLevelId").value;
                var experLevelDurMin = document.getElementById("experLevelDurMin").value;
                var experLevelDurRecom = document.getElementById("experLevelDurRecom").value;
                var experLevelKondisi = document.getElementById("kondisiExpLevel").value;
                
                var parameter = "&command=<%=Command.SAVE %>";
                parameter += "&position_id=<%=positionId%>";
                parameter += "&oid_cand_level_exper=" + candidatExpLevelId;
                parameter += "&experience_level_id=" + experienceLevelId;
                parameter += "&exper_dur_level_min=" + experLevelDurMin;
                parameter += "&exper_dur_level_recom=" + experLevelDurRecom;
                parameter += "&exper_level_recom_kondisi=" + experLevelKondisi;
                
				if (type===1){
					loadAjax("saveExperienceLevel", parameter);
				} else {
					loadAjax("saveOnlyExperienceLevel", parameter);	
				}
            }

            function saveCompetency(type) {
                var candidatCompId = document.getElementById("candidatCompId").value;
                var competencyId = document.getElementById("competencyId").value;
                var compScoreMin = document.getElementById("minScore").value;
                var compScoreMax = document.getElementById("recScore").value;
                var compScoreBobot = document.getElementById("bobot").value;
                
                var parameter = "&command=<%=Command.SAVE %>";
                parameter += "&position_id=<%=positionId%>";
                parameter += "&oid_cand_pos_comp=" + candidatCompId;
                parameter += "&competency_id=" + competencyId;
                parameter += "&comp_score_min=" + compScoreMin;
                parameter += "&comp_score_max=" + compScoreMax;
                parameter += "&comp_score_bobot=" + compScoreBobot;
                
				if (type===1){
					loadAjax("saveCompetency", parameter);
				} else {
					loadAjax("saveOnlyCompetency", parameter);
				}
            }
            
            function saveAssessment(type) {
                var candidatAssId = document.getElementById("candidatAssId").value;
                var assessmentId = document.getElementById("assessmentId").value;
                var assScoreMin = document.getElementById("assMinScore").value;
                var assScoreMax = document.getElementById("assRecScore").value;
                var assScoreBobot = document.getElementById("assBobot").value;
                var tahun = document.getElementById("tahun").value;
                var assKondisi = document.getElementById("kondisiAss").value;

                var parameter = "&command=<%=Command.SAVE %>";
                parameter += "&position_id=<%=positionId%>";
                parameter += "&oid_cand_pos_ass=" + candidatAssId;
                parameter += "&assessment_id=" + assessmentId;
                parameter += "&ass_score_min=" + assScoreMin;
                parameter += "&ass_score_max=" + assScoreMax;
                parameter += "&ass_score_bobot=" + assScoreBobot;
                parameter += "&tahun=" + tahun;
                parameter += "&ass_kondisi=" + assKondisi;
                
                if (type===1){
                        loadAjax("saveAssessment", parameter);
                } else {
                        loadAjax("saveOnlyAssessment", parameter);
                }
            }

            /*function saveTraining(type) {
                var candidatTrainId = document.getElementById("candidatTrainId").value;
                var trainingId = document.getElementById("trainingId").value;
                var trainScoreMin = document.getElementById("minScoreTraining").value;
                var trainScoreMax = document.getElementById("recScoreTraining").value;
                
                var parameter = "&command=<%=Command.SAVE %>";
                parameter += "&position_id=<%=positionId%>";
                parameter += "&oid_cand_pos_train=" + candidatTrainId;
                parameter += "&training_id=" + trainingId;
                parameter += "&train_score_min=" + trainScoreMin;
                parameter += "&train_score_max=" + trainScoreMax;
                
				if (type===1){
					loadAjax("saveTraining", parameter);
				} else {
					loadAjax("saveOnlyTraining", parameter);
				}
            }*/

            function saveEducation(type) {
                var candidatEduId = document.getElementById("candidatEduId").value;
                var educationId = document.getElementById("educationId").value;
                var eduScoreMin = document.getElementById("minScoreEducation").value;
                var eduScoreMax = document.getElementById("recScoreEducation").value;
                var eduKondisi = "0";
                
                var parameter = "&command=<%=Command.SAVE %>";
                parameter += "&position_id=<%=positionId%>";
                parameter += "&oid_cand_pos_edu=" + candidatEduId;
                parameter += "&education_id=" + educationId;
                parameter += "&edu_score_min=" + eduScoreMin;
                parameter += "&edu_score_max=" + eduScoreMax;
                parameter += "&edu_kondisi=" + eduKondisi;
                
				if (type===1){
					loadAjax("saveEducation", parameter);
				} else {
					loadAjax("saveOnlyEducation", parameter);
				}
            }

            function saveCandidatLocation(type) {
                var candidateLocId = document.getElementById("candidateLocId").value;
                var companyId = document.getElementById("companyId").value;
                var divisionId = document.getElementById("divisionId").value;
                var departmentId = document.getElementById("departmentId").value;
                var sectionId = document.getElementById("sectionId").value;
                
                var parameter = "&command=<%=Command.SAVE %>";
                parameter += "&candidate_loc_id=" + candidateLocId;
                parameter += "&company_id=" + companyId;
                parameter += "&division_id=" + divisionId;
                parameter += "&department_id=" + departmentId;
                parameter += "&section_id=" + sectionId;
                parameter += "&code_org=" + 1;
                if (type===1){
					loadAjax("saveCandidatLocation", parameter);
				} else {
					loadAjax("saveOnlyCandidatLocation", parameter);
				}
            }
            
            function deleteGrade(oidGrade) {
                if (confirm("Hapus filter grade?")) {
                    loadAjax("deleteGrade", "&command=<%=Command.DELETE %>&oid_cand_grade_req=" + oidGrade);
                }
            };
            
            function deleteExperience(oidCandPosExper) {
                if (confirm("Hapus filter pengalaman?")) {
                    loadAjax("deleteExperience", "&command=<%=Command.DELETE %>&oid_cand_pos_exper=" + oidCandPosExper);
                }
            };
			
			function deleteExperienceLevel(oidCandLevelExper) {
                if (confirm("Hapus filter level?")) {
                    loadAjax("deleteExperienceLevel", "&command=<%=Command.DELETE %>&oid_cand_level_exper=" + oidCandLevelExper);
                }
            };
            
            function deleteCompetency(oidCandPosComp) {
                if (confirm("Hapus filter kompetensi?")) {
                    loadAjax("deleteCompetency", "&command=<%=Command.DELETE %>&oid_cand_pos_comp=" + oidCandPosComp);
                }
            };
            
            function deleteAssessment(oidCandPosAss) {
                if (confirm("Hapus filter assessment?")) {
                    loadAjax("deleteAssessment", "&command=<%=Command.DELETE %>&oid_cand_pos_ass=" + oidCandPosAss);
                }
            };
            
            /*function deleteTraining(oidCandPosTrain) {
                if (confirm("Hapus filter pelatihan?")) {
                    loadAjax("deleteTraining", "&command=<%=Command.DELETE %>&oid_cand_pos_train=" + oidCandPosTrain);
                }
            };*/
            
            function deleteEducation(oidCandPosEdu) {
                if (confirm("Hapus filter pendidikan?")) {
                    loadAjax("deleteEducation", "&command=<%=Command.DELETE %>&oid_cand_pos_edu=" + oidCandPosEdu);
                }
            };
            
            function deleteCandidatLocation(candidateLocId) {
                if (confirm("Hapus filter lokasi pencarian?")) {
                    loadAjax("deleteCandidatLocation", "&command=<%=Command.DELETE %>&candidate_loc_id=" + candidateLocId);
                }
            };
            
            function listDivision() {
                var companyId = document.getElementById("companyId").value;
                
                var parameter = "&command=<%=Command.LIST %>";
                parameter += "&company_id=" + companyId;
                
                loadAjax("listDivision", parameter);
            }
            
            function listDepartment() {
                var divisionId = document.getElementById("divisionId").value;
                
                var parameter = "&command=<%=Command.LIST %>";
                parameter += "&division_id=" + divisionId;
                
                loadAjax("listDepartment", parameter);
            }
            
            function listSection() {
                var departmentId = document.getElementById("departmentId").value;
                
                var parameter = "&command=<%=Command.LIST %>";
                parameter += "&department_id=" + departmentId;
                
                loadAjax("listSection", parameter);
            }
            
            function hideCandidatLocationForm() {
                document.getElementById("form-candidat-location").innerHTML = "";
                loadAjax("listCandidatLocation", "&command=<%=Command.LIST %>");
            }
            
            function listCandidat() {
                document.getElementById("candidat-list").innerHTML = "<div class='loader'></div>";
                var statusAktif = document.getElementById("status_aktif");
                var statusMbt = document.getElementById("status_mbt");
                var statusBerhenti = document.getElementById("status_berhenti");
                var e = document.getElementById("posType");
                var strUser = e.options[e.selectedIndex].value;
                
                var parameter = "&command=<%=Command.LIST %>";
                parameter += "&position_id=<%=positionId%>";
                parameter += "&status_aktif=" + statusAktif.checked;
                parameter += "&status_mbt=" + statusMbt.checked;
                parameter += "&status_berhenti=" + statusBerhenti.checked;
                parameter += "&position_type=" + strUser;
                
                loadAjax("listCandidat", parameter);
            }
            function cmdToCandidate(oid){
                document.frm.command.value="<%=Command.LIST%>";
                document.frm.candidate_main_id.value = oid;
                document.frm.action = "candidate_result.jsp";
                document.frm.submit();
            }
            
            
            
			
            function cmdAddEmp(){
                newWindow=window.open("source_employee.jsp","SourceEmployee", "height=600, width=500, status=yes, toolbar=no, menubar=no, location=center, scrollbars=yes");
                newWindow.focus();
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
            <span id="menu_title">
                <strong>Talent</strong> <strong style="color:#333;"> / </strong>Hasil Pencarian
            </span>
        </div>
        <nav class="cbp-spmenu cbp-spmenu-vertical cbp-spmenu-right" id="cbp-spmenu-s2" >
            <div>
                <span style="float:right; color:white; cursor: pointer; padding: 10px;" id="hideRight">Tutup</span>
                <h3 style="color:white;">Filter Pencarian</h3>
            </div>

            <div style="height: 90%; overflow: auto">
                <div class="filter-group">
                    <button type="button" class="btn-small" style="float: right; display: none" onclick="listCandidat()">Reload filter</button>
                </div>
                <div class="filter-group">
					<div id="form-status"></div>
                    <b>Status Karyawan :</b>
                    <input <%=(status_aktif ? "checked" : "")%> type="checkbox" id="status_aktif"> Aktif
                    <input <%=(status_mbt ? "checked" : "")%> type="checkbox" id="status_mbt"> MBT
                    <input <%=(status_berhenti ? "checked" : "")%> type="checkbox" id="status_berhenti"> Berhenti
                </div>
                <div class="filter-group">
                    <div id="form-grade"></div>
                </div>
                <div class="filter-group">
                    <div id="form-experience"></div>
                </div>
				<div class="filter-group">
                    <div id="form-experience-level"></div>
                </div>
                <div class="filter-group">
                    <div id="form-assessment"></div>
                </div>
<!--                <div class="filter-group">
                    <div id="form-training"></div>
                </div>-->
                <div class="filter-group">
                    <div id="form-education"></div>
                </div>
                <div class="filter-group">
                    <div id="list-candidat-location"></div>
                </div>
                <div class="filter-group">
                    <div id="form-candidat-location"></div>
                </div>
            </div>
        </nav>
        <div class="content-main">
            <form name="frm" method="post" action="">
                <input type="hidden" name="candidate_loc_id" value="<%= candidateLocId %>" />
                <input type="hidden" name="candidate_main_id" value="<%= oidCandidate%>" />
                <input type="hidden" name="employee_id" value="" />
                <input type="hidden" name="employee_oid" value="" />
                <input type="hidden" name="position_id" value="" />
				<input type="hidden" name="code_org" value="" />
                <input type="hidden" name="command" value="<%=iCommand%>">
				<% if (oidCandidate != 0){ %>
                <div class="floating-menu">
                    <h3 id="showRight">Filter Pencarian</h3>
                </div>
				<% } %>
				
				<table border="0" style="margin-bottom: 10px">
					<tr>
						<td valign="top">
							<table class="tblStyle">
								<tr>
									<td colspan="2">
										<div class="title">Information dasar</div>
									</td>
								</tr>
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
						</td>
						<% if (oidCandidate != 0){ %>
						<td valign="top">
							<table class="tblStyle">
								<tr>
									<td valign="top">
										<div class="title">Dilokasikan (optional)</div>
									</td>
								</tr>
								<tr>
									<td  valign="top">
										<a href="javascript:cmdAddLocation('<%=oidCandidate%>')" class="btn-small">Tambah Penempatan</a>
									</td>
								</tr>
                                                                <tr>
                                                                    <td> 
                                                                        <%
                                                                            if (oidCandidate != 0) {
                                                                                whereClause = PstCandidateLocation.fieldNames[PstCandidateLocation.FLD_CANDIDATE_MAIN_ID] + "=" + oidCandidate;
                                                                                whereClause += " AND " + PstCandidateLocation.fieldNames[PstCandidateLocation.FLD_CODE] + "=0";
                                                                                listLocation = PstCandidateLocation.list(0, 0, whereClause, "");
                                                                                if (listLocation != null && listLocation.size() > 0) {
                                                                        %>
                                                                        <table cellpadding="0" cellspacing="0">
                                                                            <%
                                                                                for (int i = 0; i < listLocation.size(); i++) {
                                                                                    CandidateLocation org = (CandidateLocation) listLocation.get(i);
                                                                            %>
                                                                            <tr>
                                                                                <td><div id="item"><%= changeValue.getDivisionName(org.getDivisionId())%> / <%= changeValue.getDepartmentName(org.getDepartmentId())%></div></td>
                                                                                <td><div id="close" onclick="javascript:cmdDeleteCandLoc('<%= org.getOID()%>')">&times;</div></td>
                                                                            </tr>
                                                                            <%
                                                                                }
                                                                            %>
                                                                        </table>
                                                                        <%
                                                                                }
                                                                            }
                                                                        %>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>
                                                                        <select id="posType" onchange="listCandidat()" name='position_type'>
                                                                            <%
                                                                            
                                                                                Position pos = new Position();
                                                                                try {
                                                                                    pos = PstPosition.fetchExc(positionId);
                                                                                } catch (Exception exc){}
                                                                            
                                                                                Vector<PositionType> posTypeList1 = PstPositionType.listJoin(0, 0, "LEVEL_ID = "+pos.getLevelId(), "");
                                                                                String option = "";
                                                                                for (PositionType posType : posTypeList1) {
                                                                                    if (posTypeId == posType.getOID()){
                                                                                        %> <option value="<%=posType.getOID()%>" selected><%=posType.getType()%></option><%;
                                                                                    } else {
                                                                                        %> <option value="<%=posType.getOID()%>"><%=posType.getType()%></option><%;
                                                                                    }
                                                                                }
                                                                            %>
                                                                        </select>
                                                                    </td>
                                                                </tr>
							</table>
						</td>
						<% if (positionId == 0){ %>
						<td valign="top">
							<table class="tblStyle">
								<tr>
									<td valign="top">
										<div class="title">Pilih jabatan untuk proses talent?</div>
									</td>
								</tr>
								<tr>
									<td  valign="top">
										<a href="javascript:cmdAddPosition('<%=oidCandidate%>')" class="btn-small">Pilih Jabatan</a>
									</td>
								</tr>
							</table>
						</td>
						<% }} %>
					</tr>
				</table>
				<table border="0" style="margin-bottom: 10px">
					<tr>
						<td>
							<button type="button" class="collapsible" onclick="showKonversi()">Konversi</button>

							<%
							String strCandiateNote = "";
							try {
								strCandiateNote = PstSystemProperty.getValueByName("CANDIDATE_FOOTNOTE");
							} catch (Exception ex) {
								System.out.println("[exception] " + ex.toString());
							}
						%>
						<%=(strCandiateNote == null || strCandiateNote.equalsIgnoreCase("Not initialized") ? "" : strCandiateNote)%>
						</td>
					</tr>
				</table>
				
				
				<% if (oidCandidate == 0){ %>
                <a href="javascript:cmdSave()" style="color:#FFF;" class="btn">Simpan dan Lanjutkan</a>
                <% } %>
				<% if (oidCandidate != 0 && positionId != 0){ %>
                <h1 style="color: #575757">Hasil Pencarian Talent : <%= changeValue.getPositionName(positionId)%></h1>

                <div>&nbsp;</div>
                <%
                    /*if (checkEmp != null && checkEmp.length > 0) {
                        Date now = new Date();
                        for (int i = 0; i < checkEmp.length; i++) {
                            EmpTalentPool empTalent = new EmpTalentPool();
                            empTalent.setDateTalent(now);
                            empTalent.setEmployeeId(Long.valueOf(checkEmp[i]));
                            empTalent.setStatusInfo(PstEmpTalentPool.NEED_DEVELOP);
                            try {
                                PstEmpTalentPool.insertExc(empTalent);
                            } catch (Exception e) {
                                System.out.println(e.toString());
                            }
                        }
                    }*/
                if (iCommand == Command.SUBMIT){
                %>
                <div class="alert">
                    <span class="closebtn" onclick="this.parentElement.style.display='none';">&times;</span> 
                    <strong>Talent Berhasil di Simpan.</strong> <a href="javascript:cmdToCandidate('<%=oidCandidate%>')">Klik untuk lanjut ke kandidat</a>
                </div>
                
                <% } %>
                <!--<a href="javascript:cmdExportToExcel()" class="btn-small">Export ke Excel</a>-->
                
                <div id="candidat-list" style="">
                    <h3><%= candidateList.size() %> data talent ditemukan</h3>
					<div style="overflow-x:auto;overflow-y: scroll; max-height: 500px" >
					<%
						
						int totalBobotAssessment = PstCandidatePositionAssessment.getTotalBobot(oidCandidate);
						
						String whereExperience = PstCandidatePositionExperience.fieldNames[PstCandidatePositionExperience.FLD_CANDIDATE_MAIN_ID] + "=" + oidCandidate+" AND "
							+PstCandidatePositionExperience.fieldNames[PstCandidatePositionExperience.FLD_TYPE]+"=1";
						Vector<CandidatePositionExperience> experienceList = PstCandidatePositionExperience.list(0, 0, whereExperience, "");
						String masaJabatan = "[";
						if (experienceList.size()>0){
							for (CandidatePositionExperience experience : experienceList) {

								try {
									masaJabatan += PstLevel.fetchExc(experience.getExperienceId()).getLevel()+ ",";
								} catch (Exception e) {
									System.out.println("ERROR : " + e.getMessage());
								}
							}
							masaJabatan = masaJabatan.substring(0, masaJabatan.length() - 1);
						}
						masaJabatan += "]";
					%>
                    <table class="tblStyle" >
                        <tr>
                            <td class="title_tbl" >
                                <a href="Javascript:SetAllCheckBoxes('FRM_CHK_TALENT','data_is_process', true)">Sel.All</a>
                                <br> <a href="Javascript:SetAllCheckBoxes('FRM_CHK_TALENT','data_is_process', false)">Del.All</a>
                            </td>
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
                            <td class="title_tbl">Lama Jabatan Saat ini <%=masaJabatan%> [bulan] <br><%=100-totalBobotAssessment%>% Bobot</td>
                            <td class="title_tbl">Competency Score<br> <%=totalBobotAssessment%>% Bobot</td>
                            <td class="title_tbl">Pendidikan</td>
                            <td class="title_tbl">Score Pendidikan</td>
                            <td class="title_tbl">Level Pendidikan</td>
							<td class="title_tbl">Total Score</td>
                            <td class="title_tbl">Action</td>
                        </tr>
                        <%
                            if (candidateList != null && candidateList.size() > 0) {
                                for (int c = 0; c < candidateList.size(); c++) {
                                    EmployeeCandidate candidate = (EmployeeCandidate) candidateList.get(c);
                        %>
                        <tr>
                            <%
                                String whereChk = PstEmpTalentPool.fieldNames[PstEmpTalentPool.FLD_EMPLOYEE_ID]+"="+candidate.getEmployeeId()
                                        +" AND "+PstEmpTalentPool.fieldNames[PstEmpTalentPool.FLD_MAIN_ID]+"="+oidCandidate;
                                 Vector vChkEmp = PstEmpTalentPool.list(0, 0, whereChk, "");
                                 String checked = "";
                                 if (vChkEmp.size()>0){
                                     checked = "checked";
                                 }
                            %>
                            <td><input type="checkbox" name="check_emp" value="<%= candidate.getEmployeeId()%>" class="chk" <%=checked%>/></td>
                            <td><%= (c + 1)%></td>
                            <td>
								<div class="imgcontainer">
                                <%
                                    String pictPath = "";
                                    try {
                                        SessEmployeePicture sessEmployeePicture = new SessEmployeePicture();
                                        pictPath = sessEmployeePicture.fetchImageEmployee(candidate.getEmployeeId());

                                    } catch (Exception e) {
                                        System.out.println("err." + e.toString());
                                    }%> 
                                <%
                                    if (pictPath != null && pictPath.length() > 0) {
                                        out.println("<img class='img' height=\"100\" id=\"photo\" title=\"Click here to upload\"  src=\"" + approot + "/" + pictPath + "\">");
                                    } else {
                                %>
                                <img class="img" width="135" height="100" id="photo" src="<%=approot%>/imgcache/no-img.jpg" />
                                <%

                                    }
                                %> 
								</div>
                            </td>
                            <td><a href="javascript:cmdOpenEmployee('<%=candidate.getEmployeeId()%>');" ><%= "(" + candidate.getPayrollNumber() + ") " + candidate.getFullName()%></a></td>
                            <td><%= candidate.getCommecingDate()%></td>
                            <td><%= candidate.getDivision()%></td>
                            <td><%= candidate.getDepartment()%></td>
                            <td><%= (candidate.getSection() != null ? candidate.getSection() : "-")%></td>
                            <td><%= candidate.getCurrPosition()%></td>
                            <td><%= candidate.getGradeCode()%></td>
                            <td><%= candidate.getGradeRank()%></td>
                            <td><%= Formater.formatNumber(candidate.getLengthOfService(), "###.##")%></td>
                            <td><%= Formater.formatNumber(candidate.getCurrentPosLength(), "###.##")%></td>
                            <td><%= Formater.formatNumber(candidate.getSumCompetencyScore(), "###.##")%></td>
                            <td><%= candidate.getEducationCode()%></td>
                            <td><%= Formater.formatNumber(candidate.getEducationScore(), "###.##")%></td>
                            <td><%= candidate.getEducationLevel()%></td>
                            <td>
                                <%= Formater.formatNumber(candidate.getTotal(), "###.##")%>
                                <input type='hidden' name='total_score_<%=candidate.getEmployeeId()%>' value='<%=candidate.getTotal()%>'/>
                            </td>
                            <td><a href="javascript:cmdDetail('<%= candidate.getEmployeeId()%>','<%= positionId%>')">Score Detail</a></td>
                        </tr>
                        <%
                                }
                            }
                        %>
                    </table>
					</div>
                </div>
                <div>&nbsp;</div>
                <a href="javascript:cmdBack()" class="btn-small">Kembali</a> 
                <a href="javascript:cmdPrint('<%= oidCandidate%>')" class="btn-small">Print List</a> 
                 <a href="javascript:cmdExcel('<%= oidCandidate%>')" class="btn-small">Export Excel</a>
                 <a href="javascript:cmdProccess()" class="btn-small">Simpan Talent</a>
            </form>
        </div>
					<% } %>

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
        <script src="../../styles/SlidePushMenu/js/classie.js"></script>
        <script>
            var menuRight = document.getElementById('cbp-spmenu-s2');
            var showRight = document.getElementById('showRight');
            var hideRight = document.getElementById('hideRight');

            showRight.onclick = function () {
                classie.toggle(this, 'active');
                classie.toggle(menuRight, 'cbp-spmenu-open');
                
                loadAjax("listGrade", "&command=<%=Command.LIST%>");
                loadAjax("listExperience", "&command=<%=Command.LIST%>");
                loadAjax("listExperienceLevel", "&command=<%=Command.LIST%>");
                loadAjax("listAssessment", "&command=<%=Command.LIST%>");
                //loadAjax("listTraining", "&command=<%=Command.LIST%>");
                loadAjax("listEducation", "&command=<%=Command.LIST%>");
                loadAjax("listCandidatLocation", "&command=<%=Command.LIST%>");
            };

            hideRight.onclick = function () {
                classie.toggle(this, 'active');
                classie.toggle(menuRight, 'cbp-spmenu-open');
            };
            
            //showRight.onclick();
            function showKonversi() {
				var x = document.getElementById("contentKonversi");
				if (x.style.display === "none") {
				  x.style.display = "block";
				} else {
				  x.style.display = "none";
				}
			  }
        </script>
    </body>
</html>

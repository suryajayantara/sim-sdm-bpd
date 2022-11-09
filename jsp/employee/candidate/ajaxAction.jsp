<%-- 
    Document   : ajaxAction
    Created on : Jun 24, 2019, 11:30:03 AM
    Author     : Dimata 007
--%>

<%@page import="com.dimata.harisma.session.employee.SessEmployeePicture"%>
<%@page import="com.dimata.harisma.session.employee.SessCandidateParam"%>
<%@page import="com.dimata.harisma.session.employee.EmployeeCandidate"%>
<%@page import="com.dimata.harisma.session.employee.SessCandidate"%>
<%@page import="com.dimata.harisma.entity.masterdata.Company"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstCompany"%>
<%@page import="com.dimata.harisma.entity.masterdata.Section"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstSection"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstDepartment"%>
<%@page import="com.dimata.harisma.entity.masterdata.Department"%>
<%@page import="com.dimata.harisma.entity.masterdata.Division"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstDivision"%>
<%@page import="com.dimata.harisma.entity.log.ChangeValue"%>
<%@page import="com.dimata.harisma.entity.employee.CandidateLocation"%>
<%@page import="com.dimata.harisma.entity.employee.PstCandidateLocation"%>
<%@page import="com.dimata.harisma.entity.masterdata.Education"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstEducation"%>
<%@page import="com.dimata.harisma.entity.employee.CandidatePositionEducation"%>
<%@page import="com.dimata.harisma.entity.employee.PstCandidatePositionEducation"%>
<%@page import="com.dimata.harisma.entity.masterdata.Training"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstTraining"%>
<%@page import="com.dimata.harisma.entity.employee.CandidatePositionTraining"%>
<%@page import="com.dimata.harisma.entity.employee.PstCandidatePositionTraining"%>
<%@page import="com.dimata.harisma.entity.masterdata.Competency"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstCompetency"%>
<%@page import="com.dimata.harisma.entity.employee.CandidatePositionCompetency"%>
<%@page import="com.dimata.util.Command"%>
<%@page import="com.dimata.harisma.entity.employee.CandidatePositionExperience"%>
<%@page import="com.dimata.harisma.entity.employee.PstCandidatePositionExperience"%>
<%@page import="com.dimata.harisma.entity.masterdata.Position"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstPosition"%>
<%@page import="com.dimata.harisma.entity.employee.PstCandidatePositionCompetency"%>
<%@page import="com.dimata.harisma.entity.employee.PstCandidateGradeRequired"%>
<%@page import="com.dimata.harisma.entity.employee.CandidateGradeRequired"%>
<%@page import="com.dimata.harisma.entity.masterdata.GradeLevel"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstGradeLevel"%>
<%@page import="java.util.Vector"%>
<%@page import="com.dimata.qdep.form.FRMQueryString"%>
<%@ include file = "../../main/javainit.jsp" %>
<% int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_EMPLOYEE, AppObjInfo.G2_CANDIDATE, AppObjInfo.OBJ_CANDIDATE_SEARCH);%>
<%@ include file = "../../main/checkuser.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%//
    int iCommand = FRMQueryString.requestCommand(request);
    String action = FRMQueryString.requestString(request, "action");
    long oidCandidate = FRMQueryString.requestLong(request, "candidate_main_id");
    long oidPosition = FRMQueryString.requestLong(request, "position_id");
    boolean status_aktif = FRMQueryString.requestBoolean(request, "status_aktif");
    boolean status_mbt = FRMQueryString.requestBoolean(request, "status_mbt");
    boolean status_berhenti = FRMQueryString.requestBoolean(request, "status_berhenti");
    long posType = FRMQueryString.requestLong(request, "position_type");

    //DATA GRADE
    long oidCandGradeReq = FRMQueryString.requestLong(request, "oid_cand_grade_req");
    long minGradeLevelId = FRMQueryString.requestLong(request, "min_grade_level_id");
    long maxGradeLevelId = FRMQueryString.requestLong(request, "max_grade_level_id");
    int kondisiGradeLevelId = FRMQueryString.requestInt(request, "kondisi_grade_level_id");

    //DATA EXPERIENCE
    long oidCandPosExper = FRMQueryString.requestLong(request, "oid_cand_pos_exper");
    long experienceId = FRMQueryString.requestLong(request, "experience_id");
    int experDurMin = FRMQueryString.requestInt(request, "exper_dur_min");
    int experDurRecom = FRMQueryString.requestInt(request, "exper_dur_recom");
    int experKondisi = FRMQueryString.requestInt(request, "exper_kondisi");
	
	//DATA LEVEL
    long oidCandLevelExper = FRMQueryString.requestLong(request, "oid_cand_level_exper");
    long experienceLevelId = FRMQueryString.requestLong(request, "experience_level_id");
    int experLevelDurMin = FRMQueryString.requestInt(request, "exper_dur_level_min");
    int experLevelDurRecom = FRMQueryString.requestInt(request, "exper_dur_level_recom");
    int experLevelKondisi = FRMQueryString.requestInt(request, "exper_level_recom_kondisi");

    //DATA COMPETENCY
    /*long oidCandPosComp = FRMQueryString.requestLong(request, "oid_cand_pos_comp");
    long competencyId = FRMQueryString.requestLong(request, "competency_id");
    int compScoreMin = FRMQueryString.requestInt(request, "comp_score_min");
    int compScoreMax = FRMQueryString.requestInt(request, "comp_score_max");
    int compScoreBobot = FRMQueryString.requestInt(request, "comp_score_bobot") ;*/
    
    //DATA ASSESSMENT
    long oidCandPosAss = FRMQueryString.requestLong(request, "oid_cand_pos_ass");
    long assessmentId = FRMQueryString.requestLong(request, "assessment_id");
    int assScoreMin = FRMQueryString.requestInt(request, "ass_score_min");
    int assScoreMax = FRMQueryString.requestInt(request, "ass_score_max");
    int assScoreBobot = FRMQueryString.requestInt(request, "ass_score_bobot") ;
    int tahun = FRMQueryString.requestInt(request, "tahun") ;
    int assKondisi = FRMQueryString.requestInt(request, "ass_kondisi") ;
    
    //DATA TRAINING
    long oidCandPosTrain = FRMQueryString.requestLong(request, "oid_cand_pos_train");
    long trainingId = FRMQueryString.requestLong(request, "training_id");
    int trainScoreMin = FRMQueryString.requestInt(request, "train_score_min");
    int trainScoreMax = FRMQueryString.requestInt(request, "train_score_max");
    int trainKondisi = FRMQueryString.requestInt(request, "train_kondisi");
    
    //DATA EDUCATION
    long oidCandPosEdu = FRMQueryString.requestLong(request, "oid_cand_pos_edu");
    long educationId = FRMQueryString.requestLong(request, "education_id");
    int eduScoreMin = FRMQueryString.requestInt(request, "edu_score_min");
    int eduScoreMax = FRMQueryString.requestInt(request, "edu_score_max");
    int eduKondisi = FRMQueryString.requestInt(request, "edu_kondisi");
    
    //DATA CANDIDATLOCATION
    long candidateLocId = FRMQueryString.requestLong(request, "candidate_loc_id");
    long companyId = FRMQueryString.requestLong(request, "company_id");
    long divisionId = FRMQueryString.requestLong(request, "division_id");
    long departmentId = FRMQueryString.requestLong(request, "department_id");
    long sectionId = FRMQueryString.requestLong(request, "section_id");
    int codeOrg = FRMQueryString.requestInt(request, "code_org");

    String htmlReturn = "";
    switch (iCommand) {
        case Command.LIST:
            if (action.equals("listCandidat")) {
                SessCandidateParam parameters = new SessCandidateParam();
                parameters.setEmployeeStatusActiv(status_aktif);
                parameters.setEmployeeStatusMBT(status_mbt);
                parameters.setEmployeeStatusResigned(status_berhenti);
                parameters.setEmployeePositionType(posType);
                htmlReturn = getListCandidat(oidCandidate, oidPosition, parameters, approot);
            } else if (action.equals("listGrade")) {
                htmlReturn = getListGrade(oidCandidate);
            } else if (action.equals("listExperience")) {
                htmlReturn = getListExperience(oidCandidate);
            } else if (action.equals("listExperienceLevel")) {
                htmlReturn = getListExperienceLevel(oidCandidate);
            } else if (action.equals("listCompetency")) {
                htmlReturn = getListCompetency(oidCandidate);
            } else if (action.equals("listAssessment")) {
                htmlReturn = getListAssessment(oidCandidate);
            } else if (action.equals("listTraining")) {
                htmlReturn = getListTraining(oidCandidate);
            } else if (action.equals("listEducation")) {
                htmlReturn = getListEducation(oidCandidate);
            } else if (action.equals("listCandidatLocation")) {
                htmlReturn = getListCandidatLocation(oidCandidate);
            } else if (action.equals("listDivision")) {
                htmlReturn = getListDivision(companyId);
            } else if (action.equals("listDepartment")) {
                htmlReturn = getListDepartment(divisionId);
            } else if (action.equals("listSection")) {
                htmlReturn = getListSection(departmentId);
            }
            break;
        case Command.ADD:
            if (action.equals("addGrade")) {
                htmlReturn = getFormGrade(0);
            } else if (action.equals("addExperience")) {
                htmlReturn = getFormExperience(0);
            } else if (action.equals("addExperienceLevel")) {
                htmlReturn = getFormExperienceLevel(0);
            } else if (action.equals("addCompetency")) {
                htmlReturn = getFormCompetency(0);
            } else if (action.equals("addAssessment")) {
                htmlReturn = getFormAssessment(0);
            } else if (action.equals("addTraining")) {
                htmlReturn = getFormTraining(0);
            } else if (action.equals("addEducation")) {
                htmlReturn = getFormEducation(0);
            } else if (action.equals("addCandidatLocation")) {
                htmlReturn = getFormCandidatLocation(0);
            }
            break;
        case Command.EDIT:
            if (action.equals("editGrade")) {
                htmlReturn = getFormGrade(oidCandGradeReq);
            } else if (action.equals("editExperience")) {
                htmlReturn = getFormExperience(oidCandPosExper);
            } else if (action.equals("editExperienceLevel")) {
                htmlReturn = getFormExperienceLevel(oidCandLevelExper);
            } else if (action.equals("editCompetency")) {
                //htmlReturn = getFormCompetency(oidCandPosComp);
            } else if (action.equals("editAssessment")) {
                htmlReturn = getFormAssessment(oidCandPosAss);
            } else if (action.equals("editTraining")) {
                htmlReturn = getFormTraining(oidCandPosTrain);
            } else if (action.equals("editEducation")) {
                htmlReturn = getFormEducation(oidCandPosEdu);
            } else if (action.equals("editCandidatLocation")) {
                htmlReturn = getFormCandidatLocation(candidateLocId);
            }
            break;
        case Command.SAVE:
            if (action.equals("saveGrade") || action.equals("saveOnlyGrade")) {
                saveGrade(oidCandidate, oidCandGradeReq, minGradeLevelId, maxGradeLevelId, oidPosition, kondisiGradeLevelId);
                htmlReturn = getListGrade(oidCandidate);
            } else if (action.equals("saveExperience") || action.equals("saveOnlyExperience")) {
                saveExperience(oidCandidate, oidCandPosExper, experienceId, oidPosition, experDurMin, experDurRecom, experKondisi);
                htmlReturn = getListExperience(oidCandidate);
            } else if (action.equals("saveExperienceLevel") || action.equals("saveOnlyExperienceLevel")) {
                saveExperienceLevel(oidCandidate, oidCandLevelExper, experienceLevelId, oidPosition, experLevelDurMin, experLevelDurRecom, experLevelKondisi);
                htmlReturn = getListExperienceLevel(oidCandidate);
            } else if (action.equals("saveCompetency") || action.equals("saveOnlyCompetency")) {
                //saveCompetency(oidCandidate, oidCandPosComp, competencyId, oidPosition, compScoreMin, compScoreMax, compScoreBobot);
                //htmlReturn = getListCompetency(oidCandidate);
            } else if (action.equals("saveAssessment") || action.equals("saveOnlyAssessment")) {
                saveAssessment(oidCandidate, oidCandPosAss, assessmentId, oidPosition, assScoreMin, assScoreMax, assScoreBobot, tahun, assKondisi);
                htmlReturn = getListAssessment(oidCandidate);
            } else if (action.equals("saveTraining") || action.equals("saveOnlyTraining")) {
                saveTraining(oidCandidate, oidCandPosTrain, trainingId, oidPosition, trainScoreMin, trainScoreMax, trainKondisi);
                htmlReturn = getListTraining(oidCandidate);
            } else if (action.equals("saveEducation") || action.equals("saveOnlyEducation")) {
                saveEducation(oidCandidate, oidCandPosEdu, educationId, oidPosition, eduScoreMin, eduScoreMax, eduKondisi);
                htmlReturn = getListEducation(oidCandidate);
            } else if (action.equals("saveCandidatLocation") || action.equals("saveOnlyCandidatLocation")) {
                saveCandidatLocation(oidCandidate, candidateLocId, companyId, divisionId, departmentId, sectionId, codeOrg);
                htmlReturn = getListCandidatLocation(oidCandidate);
            }
            break;
        case Command.DELETE:
            if (action.equals("deleteGrade")) {
                deleteGrade(oidCandGradeReq);
                htmlReturn = getListGrade(oidCandidate);
            } else if (action.equals("deleteExperience")) {
                deleteExperience(oidCandPosExper);
                htmlReturn = getListExperience(oidCandidate);
            } else if (action.equals("deleteExperienceLevel")) {
                deleteExperienceLevel(oidCandLevelExper);
                htmlReturn = getListExperienceLevel(oidCandidate);
            }  else if (action.equals("deleteCompetency")) {
                //deleteCompetency(oidCandPosComp);
                //htmlReturn = getListCompetency(oidCandidate);
            } else if (action.equals("deleteAssessment")) {
                deleteAssesment(oidCandPosAss);
                htmlReturn = getListAssessment(oidCandidate);
            } else if (action.equals("deleteTraining")) {
                deleteTraining(oidCandPosTrain);
                htmlReturn = getListTraining(oidCandidate);
            } else if (action.equals("deleteEducation")) {
                deleteEducation(oidCandPosEdu);
                htmlReturn = getListEducation(oidCandidate);
            } else if (action.equals("deleteCandidatLocation")) {
                deleteCandidatLocation(candidateLocId);
                htmlReturn = getListCandidatLocation(oidCandidate);
            }
            break;
        default:
            htmlReturn = "???";
            break;
    }

%>

<%!
    // ========== * ========== ACTION LIST ========== * ==========
    private String getListCandidat(long oidCandidate, long positionId, SessCandidateParam parameters, String approot) {
        Vector<EmployeeCandidate> candidateList = SessCandidate.queryCandidateV2(oidCandidate, positionId, parameters);
        
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

        String html = "<h3>" + candidateList.size() + " data talent ditemukan</h3>";
		html += "<div style='overflow-x:auto;overflow-y: scroll; height: 500px'>";
		html += "<table class='tblStyle'>";
        html += "<tr>";
        html += "<td class='title_tbl'><a href=\"Javascript:SetAllCheckBoxes('FRM_CHK_TALENT','data_is_process', true)\">Sel.All</a>"
                + "<br> <a href=\"Javascript:SetAllCheckBoxes('FRM_CHK_TALENT','data_is_process', false)\">Del.All</a>"
                + "</td>";
        html += "<td class='title_tbl'>No</td>";
        html += "<td class='title_tbl'>Photo</td>";
        html += "<td class='title_tbl'>Nama Karyawan</td>";
        html += "<td class='title_tbl'>Mulai Kerja</td>";
        html += "<td class='title_tbl'>Satuan Kerja</td>";
        html += "<td class='title_tbl'>Unit</td>";
        html += "<td class='title_tbl'>Sub Unit</td>";
        html += "<td class='title_tbl'>Jabatan</td>";
        html += "<td class='title_tbl'>Grade</td>";
        html += "<td class='title_tbl'>Grade Rank</td>";
        html += "<td class='title_tbl'>Masa Kerja [bulan]</td>";
        html += "<td class='title_tbl'>Lama Jabatan Saat ini "+masaJabatan+" [bulan]<br>"+(100-totalBobotAssessment)+"% Bobot</td>";
        html += "<td class='title_tbl'>Assessment Score<br> "+totalBobotAssessment+"% Bobot</td>";
        html += "<td class='title_tbl'>Pendidikan</td>";
        html += "<td class='title_tbl'>Score Pendidikan</td>";
        html += "<td class='title_tbl'>Level Pendidikan</td>";
		html += "<td class='title_tbl'>Total Score</td>";
        html += "<td class='title_tbl'>Action</td>";
        html += "</tr>";
        
        int no = 0;
        for (EmployeeCandidate candidate : candidateList) {
            no++;
            
            String img = "";
            try {
                String pictPath = "";
                SessEmployeePicture sessEmployeePicture = new SessEmployeePicture();
                pictPath = sessEmployeePicture.fetchImageEmployee(candidate.getEmployeeId());
                
                if (pictPath != null && pictPath.length() > 0) {
                    img = "<img class='img' height=\"100\" id=\"photo\" title=\"Click here to upload\" src=\"" + approot + "/" + pictPath + "\">";
                } else {
                    img = "<img class='img' width=\"100\" height=\"135\" id=\"photo\" src=\"" + approot + "/imgcache/no-img.jpg\">";
                }
            } catch (Exception e) {
                System.out.println("err." + e.toString());
            }
            String whereChk = PstEmpTalentPool.fieldNames[PstEmpTalentPool.FLD_EMPLOYEE_ID]+"="+candidate.getEmployeeId()
                    +" AND "+PstEmpTalentPool.fieldNames[PstEmpTalentPool.FLD_MAIN_ID]+"="+oidCandidate;
             Vector vChkEmp = PstEmpTalentPool.list(0, 0, whereChk, "");
             String checked = "";
             if (vChkEmp.size()>0){
                 checked = "checked";
             }
            html += "<tr>";
            html += "<td><input type=\"checkbox\" name=\"check_emp\" value=\"" + candidate.getEmployeeId() + "\" class=\"chk\" "+checked+"></td>";
            html += "<td>" + no + "</td>";
            html += "<td><div class='imgcontainer'>" + img + "</div></td>";
            html += "<td><a href=\"javascript:cmdOpenEmployee('" + candidate.getEmployeeId() + "')\">" + "(" + candidate.getPayrollNumber() + ") " + candidate.getFullName() + "</a></td>";
            html += "<td>" + candidate.getCommecingDate() + "</td>";
            html += "<td>" + candidate.getDivision() + "</td>";
            html += "<td>" + candidate.getDepartment() + "</td>";
            html += "<td>" + (candidate.getSection() != null ? candidate.getSection() : "-") + "</td>";
            html += "<td>" + candidate.getCurrPosition() + "</td>";
            html += "<td>" + candidate.getGradeCode() + "</td>";
            html += "<td>" + candidate.getGradeRank() + "</td>";
            html += "<td>" + String.format("%,.2f", candidate.getLengthOfService()) + "</td>";
            html += "<td>" + String.format("%,.2f", candidate.getCurrentPosLength()) + "</td>";
            html += "<td>" + String.format("%,.2f", candidate.getSumCompetencyScore()) + "</td>";
            html += "<td>" + candidate.getEducationCode() + "</td>";
            html += "<td>" + String.format("%,.2f", candidate.getEducationScore()) + "</td>";
            html += "<td>" + candidate.getEducationLevel() + "</td>";
            html += "<td>" 
                    + String.format("%,.2f", candidate.getTotal()) 
                    + "<input type='hidden' name='total_score_"+candidate.getEmployeeId()+"' value='"+candidate.getTotal()+"'/>"
                    + "</td>";
            html += "<td><a href=\"javascript:cmdDetail('" + candidate.getEmployeeId()+ "','" + positionId + "')\">Score Detail</a></td>";
            html += "</tr>";
        }
        
        html += "</table></div>";
        return html;
    }
    
    private static String getListGrade(long oidCandidate) {
        String btnAdd = "<button onclick='loadAjax(\"addGrade\", \"&command=" + Command.ADD + "\")' class='btn-small'>Tambah</button>";

        String html = "<table class='tblStyle'>";
        html += "<tr>";
		html += "<td class='title_tbl'>Level</td>";
        html += "<td class='title_tbl'>Grade Minimum</td>";
        html += "<td class='title_tbl'>Grade Maximum</td>";
        html += "<td class='title_tbl' style='text-align: center;'>" + btnAdd + "</td>";
        html += "</tr>";

        String whereGrade = PstCandidatePositionCompetency.fieldNames[PstCandidatePositionCompetency.FLD_CANDIDATE_MAIN_ID] + "=" + oidCandidate;
        Vector<CandidateGradeRequired> listGrade = PstCandidateGradeRequired.listInnerJoin(whereGrade);
        for (CandidateGradeRequired gradeRequired : listGrade) {
            String btnEdit = "<b style='cursor: pointer; color: blue' onclick='loadAjax(\"editGrade\", \"&command=" + Command.EDIT + "&oid_cand_grade_req=" + gradeRequired.getOID() + "\")'>Ubah</b>";
            String btnDelete = "<b style='cursor: pointer; color: red' onclick='deleteGrade(\"" + gradeRequired.getOID() + "\")'>Hapus</b>";

			Level lvl = PstLevel.getByGrade(gradeRequired.getGradeMinimum().getGradeRank(),
						gradeRequired.getGradeMaximum().getGradeRank());
            
            html += "<tr>";
			html += "<td>" + lvl.getLevel() + "</td>";
            html += "<td>" + gradeRequired.getGradeMinimum().getCodeLevel() + "</td>";
            html += "<td>" + gradeRequired.getGradeMaximum().getCodeLevel() + "</td>";
            html += "<td style='text-align: center; white-space: nowrap'>" + btnEdit + "&nbsp;&nbsp;" + btnDelete + "</td>";
            html += "</tr>";
        }
        html += "</table>";
        return html;
    }

    private String getListExperience(long oidCandidate) {
        String btnAdd = "<button onclick='loadAjax(\"addExperience\", \"&command=" + Command.ADD + "\")' class='btn-small'>Tambah</button>";

        String html = "<table class='tblStyle'>";
        html += "<tr>";
        html += "<td class='title_tbl'>Pengalaman</td>";
        html += "<td class='title_tbl'>Durasi Minimal</td>";
        html += "<td class='title_tbl'>Durasi Rekomendasi</td>";
        html += "<td class='title_tbl'>Kondisi</td>";
        html += "<td class='title_tbl' style='text-align: center;'>" + btnAdd + "</td>";
        html += "</tr>";

        String whereExperience = PstCandidatePositionExperience.fieldNames[PstCandidatePositionExperience.FLD_CANDIDATE_MAIN_ID] + "=" + oidCandidate+" AND "
							+PstCandidatePositionExperience.fieldNames[PstCandidatePositionExperience.FLD_TYPE]+"=0";
        Vector<CandidatePositionExperience> experienceList = PstCandidatePositionExperience.list(0, 0, whereExperience, "");
        for (CandidatePositionExperience experience : experienceList) {
            String position = "-";
            try {
                position = PstPosition.fetchExc(experience.getExperienceId()).getPosition();
            } catch (Exception e) {
                System.out.println("ERROR : " + e.getMessage());
            }
            String btnEdit = "<b style='cursor: pointer; color: blue' onclick='loadAjax(\"editExperience\", \"&command=" + Command.EDIT + "&oid_cand_pos_exper=" + experience.getOID() + "\")'>Ubah</b>";
            String btnDelete = "<b style='cursor: pointer; color: red' onclick='deleteExperience(\"" + experience.getOID() + "\")'>Hapus</b>";
            
            html += "<tr>";
            html += "<td>" + position + "</td>";
            html += "<td>" + experience.getDurationMin() + " bulan</td>";
            html += "<td>" + experience.getDurationRecommended() + " bulan</td>";
            html += "<td>" + PstCandidateMain.strKondisi[experience.getKondisi()] + "</td>";
            html += "<td style='text-align: center; white-space: nowrap'>" + btnEdit + "&nbsp;&nbsp;" + btnDelete + "</td>";
            html += "</tr>";
        }
        html += "</table>";
        return html;
    }

	private String getListExperienceLevel(long oidCandidate) {
        String btnAdd = "<button onclick='loadAjax(\"addExperienceLevel\", \"&command=" + Command.ADD + "\")' class='btn-small'>Tambah</button>";

        String html = "<table class='tblStyle'>";
        html += "<tr>";
        html += "<td class='title_tbl'>Level</td>";
        html += "<td class='title_tbl'>Durasi Minimal</td>";
        html += "<td class='title_tbl'>Durasi Rekomendasi</td>";
        html += "<td class='title_tbl'>Kondisi</td>";
        html += "<td class='title_tbl' style='text-align: center;'>" + btnAdd + "</td>";
        html += "</tr>";

        String whereExperience = PstCandidatePositionExperience.fieldNames[PstCandidatePositionExperience.FLD_CANDIDATE_MAIN_ID] + "=" + oidCandidate+" AND "
							+PstCandidatePositionExperience.fieldNames[PstCandidatePositionExperience.FLD_TYPE]+"=1";
        Vector<CandidatePositionExperience> experienceList = PstCandidatePositionExperience.list(0, 0, whereExperience, "");
        for (CandidatePositionExperience experience : experienceList) {
            String position = "-";
            try {
                position = PstLevel.fetchExc(experience.getExperienceId()).getLevel();
            } catch (Exception e) {
                System.out.println("ERROR : " + e.getMessage());
            }
            String btnEdit = "<b style='cursor: pointer; color: blue' onclick='loadAjax(\"editExperienceLevel\", \"&command=" + Command.EDIT + "&oid_cand_level_exper=" + experience.getOID() + "\")'>Ubah</b>";
            String btnDelete = "<b style='cursor: pointer; color: red' onclick='deleteExperienceLevel(\"" + experience.getOID() + "\")'>Hapus</b>";
            
            html += "<tr>";
            html += "<td>" + position + "</td>";
            html += "<td>" + experience.getDurationMin() + " bulan</td>";
            html += "<td>" + experience.getDurationRecommended() + " bulan</td>";
            html += "<td>" + PstCandidateMain.strKondisi[experience.getKondisi()] + "</td>";
            html += "<td style='text-align: center; white-space: nowrap'>" + btnEdit + "&nbsp;&nbsp;" + btnDelete + "</td>";
            html += "</tr>";
        }
        html += "</table>";
        return html;
    }

    private String getListCompetency(long oidCandidate) {
        String btnAdd = "<button onclick='loadAjax(\"addCompetency\", \"&command=" + Command.ADD + "\")' class='btn-small'>Tambah</button>";
        
        String html = "<table class='tblStyle'>";
        html += "<tr>";
        html += "<td class='title_tbl'>Kompetensi</td>";
        html += "<td class='title_tbl'>Skor minimal</td>";
        html += "<td class='title_tbl'>Skor dibutuhkan</td>";
        html += "<td class='title_tbl'>Bobot</td>";
        html += "<td class='title_tbl'>Kondisi</td>";
        html += "<td class='title_tbl' style='text-align: center;'>" + btnAdd + "</td>";
        html += "</tr>";
        
        String whereCompetency = PstCandidatePositionCompetency.fieldNames[PstCandidatePositionCompetency.FLD_CANDIDATE_MAIN_ID] + "=" + oidCandidate;
        Vector<CandidatePositionCompetency> posCompetencyList = PstCandidatePositionCompetency.list(0, 0, whereCompetency, "");
        for (CandidatePositionCompetency competency : posCompetencyList) {
            String competencyName = "-";
            try {
                competencyName = PstCompetency.fetchExc(competency.getCompetencyId()).getCompetencyName();
            } catch (Exception e) {
                System.out.println("ERROR : " + e.getMessage());
            }
            String btnEdit = "<b style='cursor: pointer; color: blue' onclick='loadAjax(\"editCompetency\", \"&command=" + Command.EDIT + "&oid_cand_pos_comp=" + competency.getOID() + "\")'>Ubah</b>";
            String btnDelete = "<b style='cursor: pointer; color: red' onclick='deleteCompetency(\"" + competency.getOID() + "\")'>Hapus</b>";
            
            html += "<tr>";
            html += "<td>" + competencyName + "</td>";
            html += "<td>" + competency.getScoreMin() + "</td>";
            html += "<td>" + competency.getScoreMax() + "</td>";
            html += "<td>" + competency.getBobot()+ "</td>";
            html += "<td>" + PstCandidateMain.strKondisi[competency.getKondisi()] + "</td>";
            html += "<td style='text-align: center; white-space: nowrap'>" + btnEdit + "&nbsp;&nbsp;" + btnDelete + "</td>";
            html += "</tr>";
        }
        html += "</table>";
        return html;
    }
    
    private String getListAssessment(long oidCandidate) {
        String btnAdd = "<button onclick='loadAjax(\"addAssessment\", \"&command=" + Command.ADD + "\")' class='btn-small'>Tambah</button>";
        
        String html = "<table class='tblStyle'>";
        html += "<tr>";
        html += "<td class='title_tbl'>Assessment</td>";
        html += "<td class='title_tbl'>Tahun</td>";
        html += "<td class='title_tbl'>Skor minimal</td>";
        html += "<td class='title_tbl'>Skor dibutuhkan</td>";
        html += "<td class='title_tbl'>Bobot</td>";
        html += "<td class='title_tbl'>Kondisi</td>";
        html += "<td class='title_tbl' style='text-align: center;'>" + btnAdd + "</td>";
        html += "</tr>";
        
        String whereAssessment = PstCandidatePositionAssessment.fieldNames[PstCandidatePositionAssessment.FLD_CANDIDATE_MAIN_ID] + "=" + oidCandidate;
        Vector<CandidatePositionAssessment> posAssessmentList = PstCandidatePositionAssessment.list(0, 0, whereAssessment, "");
        for (CandidatePositionAssessment assessment : posAssessmentList) {
            String assessmentName = "-";
            try {
                assessmentName = PstAssessment.fetchExc(assessment.getAssessmentId()).getAssessmentType();
            } catch (Exception e) {
                System.out.println("ERROR : " + e.getMessage());
            }
            String btnEdit = "<b style='cursor: pointer; color: blue' onclick='loadAjax(\"editAssessment\", \"&command=" + Command.EDIT + "&oid_cand_pos_ass=" + assessment.getOID() + "\")'>Ubah</b>";
            String btnDelete = "<b style='cursor: pointer; color: red' onclick='deleteAssessment(\"" + assessment.getOID() + "\")'>Hapus</b>";
            
            html += "<tr>";
            html += "<td>" + assessmentName + "</td>";
            html += "<td>" + assessment.getTahun() + "</td>";
            html += "<td>" + assessment.getScoreMin() + "</td>";
            html += "<td>" + assessment.getScoreMax() + "</td>";
            html += "<td>" + assessment.getBobot()+ "</td>";
            html += "<td>" + PstCandidateMain.strKondisi[assessment.getKondisi()] + "</td>";
            html += "<td style='text-align: center; white-space: nowrap'>" + btnEdit + "&nbsp;&nbsp;" + btnDelete + "</td>";
            html += "</tr>";
        }
        html += "</table>";
        return html;
    }

    private String getListTraining(long oidCandidate) {
        String btnAdd = "<button onclick='loadAjax(\"addTraining\", \"&command=" + Command.ADD + "\")' class='btn-small'>Tambah</button>";
        
        String html = "<table class='tblStyle'>";
        html += "<tr>";
        html += "<td class='title_tbl'>Pelatihan</td>";
        html += "<td class='title_tbl'>Skor minimal</td>";
        html += "<td class='title_tbl'>Skor dibutuhkan</td>";
        html += "<td class='title_tbl'>Kondisi</td>";
        html += "<td class='title_tbl' style='text-align: center;'>" + btnAdd + "</td>";
        html += "</tr>";
        
        String whereTraining = PstCandidatePositionTraining.fieldNames[PstCandidatePositionTraining.FLD_CANDIDATE_MAIN_ID] + "=" + oidCandidate;
        Vector<CandidatePositionTraining> posTrainingList = PstCandidatePositionTraining.list(0, 0, whereTraining, "");
        for (CandidatePositionTraining training : posTrainingList) {
            String trainingName = "-";
            try {
                trainingName = PstTraining.fetchExc(training.getTrainingId()).getName();
            } catch (Exception e) {
                System.out.println("ERROR : " + e.getMessage());
            }
            String btnEdit = "<b style='cursor: pointer; color: blue' onclick='loadAjax(\"editTraining\", \"&command=" + Command.EDIT + "&oid_cand_pos_train=" + training.getOID() + "\")'>Ubah</b>";
            String btnDelete = "<b style='cursor: pointer; color: red' onclick='deleteTraining(\"" + training.getOID() + "\")'>Hapus</b>";
            
            html += "<tr>";
            html += "<td>" + trainingName + "</td>";
            html += "<td>" + training.getScoreMin() + "</td>";
            html += "<td>" + training.getScoreMax() + "</td>";
            html += "<td>" + PstCandidateMain.strKondisi[training.getKondisi()] + "</td>";
            html += "<td style='text-align: center; white-space: nowrap'>" + btnEdit + "&nbsp;&nbsp;" + btnDelete + "</td>";
            html += "</tr>";
        }
        html += "</table>";
        return html;
    }

    private String getListEducation(long oidCandidate) {
        String btnAdd = "<button onclick='loadAjax(\"addEducation\", \"&command=" + Command.ADD + "\")' class='btn-small'>Tambah</button>";
        
        String html = "<table class='tblStyle'>";
        html += "<tr>";
        html += "<td class='title_tbl'>Pendidikan</td>";
        html += "<td class='title_tbl'>Skor minimal</td>";
        html += "<td class='title_tbl'>Skor dibutuhkan</td>";
        html += "<td class='title_tbl' style='text-align: center;'>" + btnAdd + "</td>";
        html += "</tr>";
        
        String whereEducation = PstCandidatePositionEducation.fieldNames[PstCandidatePositionEducation.FLD_CANDIDATE_MAIN_ID] + "=" + oidCandidate;
        Vector<CandidatePositionEducation> posEducationList = PstCandidatePositionEducation.list(0, 0, whereEducation, "");
        for (CandidatePositionEducation education : posEducationList) {
            String educationName = "-";
            try {
                educationName = PstEducation.fetchExc(education.getEducationId()).getEducation();
            } catch (Exception e) {
                System.out.println("ERROR : " + e.getMessage());
            }
            String btnEdit = "<b style='cursor: pointer; color: blue' onclick='loadAjax(\"editEducation\", \"&command=" + Command.EDIT + "&oid_cand_pos_edu=" + education.getOID() + "\")'>Ubah</b>";
            String btnDelete = "<b style='cursor: pointer; color: red' onclick='deleteEducation(\"" + education.getOID() + "\")'>Hapus</b>";
            
            html += "<tr>";
            html += "<td>" + educationName + "</td>";
            html += "<td>" + education.getScoreMin() + "</td>";
            html += "<td>" + education.getScoreMax() + "</td>";
            html += "<td style='text-align: center; white-space: nowrap'>" + btnEdit + "&nbsp;&nbsp;" + btnDelete + "</td>";
            html += "</tr>";
        }
        html += "</table>";
        return html;
    }

    private String getListCandidatLocation(long oidCandidate) {
        String btnAdd = "<button onclick='loadAjax(\"addCandidatLocation\", \"&command=" + Command.ADD + "\")' class='btn-small'>Tambah</button>";
        
        String html = "<table class='tblStyle'>";
        html += "<tr>";
        html += "<td class='title_tbl'>Satuan Kerja</td>";
        html += "<td class='title_tbl'>Unit</td>";
        html += "<td class='title_tbl'>Sub Unit</td>";
        html += "<td class='title_tbl' style='text-align: center;'>" + btnAdd + "</td>";
        html += "</tr>";
        
        String whereLocation = PstCandidateLocation.fieldNames[PstCandidateLocation.FLD_CANDIDATE_MAIN_ID]+"="+oidCandidate;
        whereLocation += " AND "+PstCandidateLocation.fieldNames[PstCandidateLocation.FLD_CODE]+" = 1 ";
        Vector<CandidateLocation> listLocation = PstCandidateLocation.list(0, 0, whereLocation, "");
        ChangeValue changeValue = new ChangeValue();
        for (CandidateLocation candidateLocation : listLocation) {
            String btnEdit = "<b style='cursor: pointer; color: blue' onclick='loadAjax(\"editCandidatLocation\", \"&command=" + Command.EDIT + "&candidate_loc_id=" + candidateLocation.getOID() + "\")'>Ubah</b>";
            String btnDelete = "<b style='cursor: pointer; color: red' onclick='deleteCandidatLocation(\"" + candidateLocation.getOID() + "\")'>Hapus</b>";
            
            html += "<tr>";
            html += "<td>" + changeValue.getDivisionName(candidateLocation.getDivisionId()) + "</td>";
            html += "<td>" + changeValue.getDepartmentName(candidateLocation.getDepartmentId()) + "</td>";
            html += "<td>" + changeValue.getSectionName(candidateLocation.getSectionId()) + "</td>";
            html += "<td style='text-align: center; white-space: nowrap'>" + btnEdit + "&nbsp;&nbsp;" + btnDelete + "</td>";
            html += "</tr>";
        }
        html += "</table>";
        return html;
    }
    
    private String getListDivision(long oidCompany) {
        String whereDivision = PstDivision.fieldNames[PstDivision.FLD_VALID_STATUS] + " = " + PstDivision.VALID_ACTIVE;
        whereDivision += " AND " + PstDivision.fieldNames[PstDivision.FLD_COMPANY_ID] + " = " + oidCompany;
        Vector<Division> listDivision = PstDivision.list(0, 0, whereDivision, PstDivision.fieldNames[PstDivision.FLD_DIVISION]);
        String optionDivision = "<option value='0'>-</option>";
        for (Division division : listDivision) {
            optionDivision += "<option value='" + division.getOID() + "'>" + division.getDivision()+ "</option>";
        }
        return optionDivision;
    }
    
    private String getListDepartment(long oidDivision) {
        String whereDepartment = PstDepartment.TBL_HR_DEPARTMENT + "." + PstDepartment.fieldNames[PstDepartment.FLD_VALID_STATUS] + " = " + PstDepartment.VALID_ACTIVE;
        whereDepartment += " AND " + PstDepartment.TBL_HR_DEPARTMENT + "." + PstDepartment.fieldNames[PstDepartment.FLD_DIVISION_ID] + " = " + oidDivision;
        Vector<Department> listDepartment = PstDepartment.list(0, 0, whereDepartment, PstDepartment.fieldNames[PstDepartment.FLD_DEPARTMENT]);
        String optionDepartment = "<option value='0'>-</option>";
        for (Department department : listDepartment) {
            optionDepartment += "<option value='" + department.getOID() + "'>" + department.getDepartment()+ "</option>";
        }
        return optionDepartment;
    }
    
    private String getListSection(long oidDepartment) {
        String whereSection = PstSection.fieldNames[PstSection.FLD_VALID_STATUS] + " = " + PstSection.VALID_ACTIVE;
        whereSection += " AND " + PstSection.fieldNames[PstSection.FLD_DEPARTMENT_ID] + " = " + oidDepartment;
        Vector<Section> listSection = PstSection.list(0, 0, whereSection, PstSection.fieldNames[PstSection.FLD_SECTION]);
        String optionSection = "<option value='0'>-</option>";
        for (Section section : listSection) {
            optionSection += "<option value='" + section.getOID() + "'>" + section.getSection()+ "</option>";
        }
        return optionSection;
    }

    // ========== * ========== ACTION ADD ========== * ==========
    private String getFormGrade(long oidCandGradeReq) {
        CandidateGradeRequired data = new CandidateGradeRequired();
        if (oidCandGradeReq > 0) {
            try {
                data = PstCandidateGradeRequired.fetchExc(oidCandGradeReq);
            } catch (Exception e) {
                System.out.println("ERROR : " + e.getMessage());
            }
        }
        
        Vector<GradeLevel> gradeList = PstGradeLevel.list(0, 0, "", PstGradeLevel.fieldNames[PstGradeLevel.FLD_GRADE_CODE]);
        String optionGradeMin = "";
		int min = 0;
        for (GradeLevel gradeLevel : gradeList) {
			if (oidCandGradeReq != 0){
				if (data.getGradeMinimum().getOID() == gradeLevel.getOID()){
					min = gradeLevel.getGradeRank();
				}
				optionGradeMin += "<option " + (data.getGradeMinimum().getOID() == gradeLevel.getOID() ? "selected":"") + " value='" + gradeLevel.getOID() + "'>" + gradeLevel.getCodeLevel() + "</option>";
			} else {
				optionGradeMin += "<option value='" + gradeLevel.getOID() + "'>" + gradeLevel.getCodeLevel() + "</option>";
			}
        }
        
        String optionGradeMax = "";
		int max = 0;
        for (GradeLevel gradeLevel : gradeList) {
			if (oidCandGradeReq != 0){
				if(data.getGradeMaximum().getOID() == gradeLevel.getOID()){
					max = gradeLevel.getGradeRank();
				}
				String selected = (data.getGradeMaximum().getOID() == gradeLevel.getOID()) ? "selected":"";
				optionGradeMax += "<option " + selected + " value='" + gradeLevel.getOID() + "'>" + gradeLevel.getCodeLevel() + "</option>";
			} else {
				optionGradeMax += "<option value='" + gradeLevel.getOID() + "'>" + gradeLevel.getCodeLevel() + "</option>";
			}
        }

		Level lvl = PstLevel.getByGrade(min,max);
		String optionLevel = "";
		Vector<Level> lvlList = PstLevel.list(0, 0, "", PstLevel.fieldNames[PstLevel.FLD_LEVEL_RANK]);
		for (Level level : lvlList) {

			Vector gradeMin = PstGradeLevel.list(0, 0, PstGradeLevel.fieldNames[PstGradeLevel.FLD_GRADE_RANK]+"="+level.getGradeMin(), "");
			Vector gradeMax = PstGradeLevel.list(0, 0, PstGradeLevel.fieldNames[PstGradeLevel.FLD_GRADE_RANK]+"="+level.getGradeMax(), "");
			
			long oidMin = 0;
			if (gradeMin.size()>0){
				GradeLevel lvlMin = (GradeLevel) gradeMin.get(0);
				oidMin = lvlMin.getOID();
			}

			long oidMax = 0;
			if (gradeMax.size()>0){
				GradeLevel lvlMax = (GradeLevel) gradeMax.get(0);
				oidMax = lvlMax.getOID();
			}

			if (lvl.getOID() != 0){
				String selected = (lvl.getOID() == level.getOID()) ? "selected":"";
				optionLevel += "<option data-min='"+oidMin+"' data-max='"+oidMax+"' " + selected + " value='" + level.getOID() + "'>" + level.getLevel()+ "</option>";
			} else {
				optionLevel += "<option data-min='"+oidMin+"' data-max='"+oidMax+"' value='" + level.getOID() + "'>" + level.getLevel() + "</option>";
			}
        }

		String btnSaveOnly = "<button onclick='saveGrade(0)' class='btn-small' style='color: green'>Simpan</button>";
        String btnSave = "<button onclick='saveGrade(1)' class='btn-small' style='color: green'>Simpan dan Cari</button>";
        String btnCancel = "<button onclick='loadAjax(\"listGrade\", \"&command=" + Command.LIST + "\")' class='btn-small'>Batal</button>";

        String html = "<table>";
		html += "<tr><td><b>Level</b></td><td><select id='levelGrade' onchange='changeGrade()'>" + optionLevel + "</select></td></tr>";
        html += "<tr><td><b>Grade Minimum</b></td><td><select id='gradeMin'>" + optionGradeMin + "</select></td></tr>";
        html += "<tr><td><b>Grade Maximum</b></td><td><select id='gradeMax'>" + optionGradeMax + "</select></td></tr>";
        html += "<tr><td><input type='hidden' id='candidatGradeId' value='" + oidCandGradeReq + "'></td><td>" + btnSaveOnly + " " + btnSave + " " + btnCancel + "</td></tr>";
        html += "</table>";
        return html;
    }

    private String getFormExperience(long oidCandPosExper) {
        CandidatePositionExperience data = new CandidatePositionExperience();
        if (oidCandPosExper > 0) {
            try {
                data = PstCandidatePositionExperience.fetchExc(oidCandPosExper);
            } catch (Exception e) {
                System.out.println("ERROR : " + e.getMessage());
            }
        }
        
        Vector<Position> experList = PstPosition.list(0, 0, "", PstPosition.fieldNames[PstPosition.FLD_POSITION]);
        String option = "";
        for (Position position : experList) {
            String selected = (data.getExperienceId() == position.getOID()) ? "selected":"";
            option += "<option " + selected + " value='" + position.getOID() + "'>" + position.getPosition() + "</option>";
        }

		String btnSaveOnly = "<button onclick='saveExperience(0)' class='btn-small' style='color: green'>Simpan</button>";
        String btnSave = "<button onclick='saveExperience(1)' class='btn-small' style='color: green'>Simpan dan Cari</button>";
        String btnCancel = "<button onclick='loadAjax(\"listExperience\", \"&command=" + Command.LIST + "\")' class='btn-small'>Batal</button>";

        String html = "<table>";
        html += "<tr><td><b>Pengalaman</b></td><td><select id='experienceId' style='width:90%'>" + option + "</select></td></tr>";
        html += "<tr><td><b>Durasi Minimal</b></td><td><input type='text' id='minDuration' value='" + data.getDurationMin() + "'> Bulan</td></tr>";
        html += "<tr><td><b>Durasi Rekomendasi</b></td><td><input type='text' id='recDuration' value='" + data.getDurationRecommended() + "'> Bulan</td></tr>";
        html += "<tr><td><b>Kondisi</b></td><td><select id='kondisiExp'><option value='0'>OR</option><option value='1'>AND</option></select></td></tr>";
        html += "<tr><td><input type='hidden' id='candidatExpId' value='" + oidCandPosExper + "'></td><td>" + btnSaveOnly + " " + btnSave + " " + btnCancel + "</td></tr>";
        html += "</table>";
        return html;
    }

	private String getFormExperienceLevel(long oidCandLevelExper) {
        CandidatePositionExperience data = new CandidatePositionExperience();
        if (oidCandLevelExper > 0) {
            try {
                data = PstCandidatePositionExperience.fetchExc(oidCandLevelExper);
            } catch (Exception e) {
                System.out.println("ERROR : " + e.getMessage());
            }
        }
        
        Vector<Level> experList = PstLevel.list(0, 0, "", PstLevel.fieldNames[PstLevel.FLD_LEVEL_POINT]+" DESC");
        String option = "";
        for (Level level : experList) {
            String selected = (data.getExperienceId() == level.getOID()) ? "selected":"";
            option += "<option " + selected + " value='" + level.getOID() + "'>" + level.getLevel()+ "</option>";
        }

        String btnSaveOnly = "<button onclick='saveExperienceLevel(0)' class='btn-small' style='color: green'>Simpan</button>";
		String btnSave = "<button onclick='saveExperienceLevel(1)' class='btn-small' style='color: green'>Simpan dan Cari</button>";
        String btnCancel = "<button onclick='loadAjax(\"listExperienceLevel\", \"&command=" + Command.LIST + "\")' class='btn-small'>Batal</button>";

        String html = "<table>";
        html += "<tr><td><b>Level</b></td><td><select id='experienceLevelId' style='width:90%'>" + option + "</select></td></tr>";
        html += "<tr><td><b>Durasi Minimal</b></td><td><input type='text' id='experLevelDurMin' value='" + data.getDurationMin() + "'> Bulan</td></tr>";
        html += "<tr><td><b>Durasi Rekomendasi</b></td><td><input type='text' id='experLevelDurRecom' value='" + data.getDurationRecommended() + "'> Bulan</td></tr>";
        html += "<tr><td><b>Kondisi</b></td><td><select id='kondisiExpLevel'><option value='0'>OR</option><option value='1'>AND</option></select></td></tr>";
        html += "<tr><td><input type='hidden' id='candidatExpLevelId' value='" + oidCandLevelExper + "'></td><td>" + btnSaveOnly + " " + btnSave + " " + btnCancel + "</td></tr>";
        html += "</table>";
        return html;
    }

    private String getFormCompetency(long oidCandPosComp) {
        CandidatePositionCompetency data = new CandidatePositionCompetency();
        if (oidCandPosComp > 0) {
            try {
                data = PstCandidatePositionCompetency.fetchExc(oidCandPosComp);
            } catch (Exception e) {
                System.out.println("ERROR : " + e.getMessage());
            }
        }
        
        Vector<Competency> competencyList = PstCompetency.list(0, 0, "", PstCompetency.fieldNames[PstCompetency.FLD_COMPETENCY_NAME]);
        String option = "";
        for (Competency competency : competencyList) {
            String selected = (data.getCompetencyId()== competency.getOID()) ? "selected":"";
            option += "<option " + selected + " value='" + competency.getOID() + "'>" + competency.getCompetencyName()+ "</option>";
        }

		String btnSaveOnly = "<button onclick='saveCompetency(0)' class='btn-small' style='color: green'>Simpan</button>";
        String btnSave = "<button onclick='saveCompetency(1)' class='btn-small' style='color: green'>Simpan dan Cari</button>";
        String btnCancel = "<button onclick='loadAjax(\"listCompetency\", \"&command=" + Command.LIST + "\")' class='btn-small'>Batal</button>";

        String html = "<table>";
        html += "<tr><td><b>Kompetensi</b></td><td><select id='competencyId' style='width:90%'>" + option + "</select></td></tr>";
        html += "<tr><td><b>Skor Minimal</b></td><td><input type='text' id='minScore' value='" + data.getScoreMin() + "'></td></tr>";
        html += "<tr><td><b>Skor Rekomendasi</b></td><td><input type='text' id='recScore' value='" + data.getScoreMax() + "'></td></tr>";
        html += "<tr><td><b>Bobot</b></td><td><input type='text' id='bobot' value='" + data.getBobot()+ "'></td></tr>";
        html += "<tr><td><b>Kondisi</b></td><td><select id='kondisiComp'><option value='0'>OR</option><option value='1'>AND</option></select></td></tr>";
        html += "<tr><td><input type='hidden' id='candidatCompId' value='" + oidCandPosComp + "'></td><td>" + btnSaveOnly + " " + btnSave + " " + btnCancel + "</td></tr>";
        html += "</table>";
        return html;
    }
    
    private String getFormAssessment(long oidCandPosAss) {
        CandidatePositionAssessment data = new CandidatePositionAssessment();
        if (oidCandPosAss > 0) {
            try {
                data = PstCandidatePositionAssessment.fetchExc(oidCandPosAss);
            } catch (Exception e) {
                System.out.println("ERROR : " + e.getMessage());
            }
        }
        
        Vector<Assessment> assessmentList = PstAssessment.list(0, 0, "", PstAssessment.fieldNames[PstAssessment.FLD_ASSESSMENT_TYPE]);
        String option = "";
        for (Assessment assessment : assessmentList) {
            String selected = (data.getAssessmentId()== assessment.getOID()) ? "selected":"";
            option += "<option " + selected + " value='" + assessment.getOID() + "'>" + assessment.getAssessmentType()+ "</option>";
        }

        String optionYear = "";
        Calendar cal = Calendar.getInstance();
        cal.setTime(new Date());
        int year = cal.get(Calendar.YEAR);
        for (int i = year; i >= 2010 ; i--){
            String selected = (data.getTahun()== i) ? "selected":"";
            optionYear += "<option " + selected + " value='" + i + "'>" + i+ "</option>";
        }
        
        String btnSaveOnly = "<button onclick='saveAssessment(0)' class='btn-small' style='color: green'>Simpan</button>";
        String btnSave = "<button onclick='saveAssessment(1)' class='btn-small' style='color: green'>Simpan dan Cari</button>";
        String btnCancel = "<button onclick='loadAjax(\"listAssessment\", \"&command=" + Command.LIST + "\")' class='btn-small'>Batal</button>";

        String html = "<table>";
        html += "<tr><td><b>Assessment</b></td><td><select id='assessmentId' style='width:90%'>" + option + "</select></td></tr>";
        html += "<tr><td><b>Tahun</b></td><td><select id='tahun' style='width:90%'>" + optionYear + "</select></td></tr>";
        html += "<tr><td><b>Skor Minimal</b></td><td><input type='text' id='assMinScore' value='" + data.getScoreMin() + "'></td></tr>";
        html += "<tr><td><b>Skor Rekomendasi</b></td><td><input type='text' id='assRecScore' value='" + data.getScoreMax() + "'></td></tr>";
        html += "<tr><td><b>Bobot</b></td><td><input type='text' id='assBobot' value='" + data.getBobot()+ "'></td></tr>";
        html += "<tr><td><b>Kondisi</b></td><td><select id='kondisiAss'><option value='0'>OR</option><option value='1'>AND</option></select></td></tr>";
        html += "<tr><td><input type='hidden' id='candidatAssId' value='" + oidCandPosAss + "'></td><td>" + btnSaveOnly + " " + btnSave + " " + btnCancel + "</td></tr>";
        html += "</table>";
        return html;
    }

    private String getFormTraining(long oidCandPosTrain) {
        CandidatePositionTraining data = new CandidatePositionTraining();
        if (oidCandPosTrain > 0) {
            try {
                data = PstCandidatePositionTraining.fetchExc(oidCandPosTrain);
            } catch (Exception e) {
                System.out.println("ERROR : " + e.getMessage());
            }
        }
        
        Vector<Training> trainingList = PstTraining.list(0, 0, "", PstTraining.fieldNames[PstTraining.FLD_NAME]);
        String option = "";
        for (Training training : trainingList) {
            String selected = (data.getTrainingId() == training.getOID()) ? "selected":"";
            option += "<option " + selected + " value='" + training.getOID() + "'>" + training.getName()+ "</option>";
        }

		String btnSaveOnly = "<button onclick='saveTraining(0)' class='btn-small' style='color: green'>Simpan</button>";
        String btnSave = "<button onclick='saveTraining(1)' class='btn-small' style='color: green'>Simpan dan Cari</button>";
        String btnCancel = "<button onclick='loadAjax(\"listTraining\", \"&command=" + Command.LIST + "\")' class='btn-small'>Batal</button>";

        String html = "<table>";
        html += "<tr><td><b>Pelatihan</b></td><td><select id='trainingId' style='width:90%'>" + option + "</select></td></tr>";
        html += "<tr><td><b>Skor Minimal</b></td><td><input type='text' id='minScoreTraining' value='" + data.getScoreMin() + "'></td></tr>";
        html += "<tr><td><b>Skor Rekomendasi</b></td><td><input type='text' id='recScoreTraining' value='" + data.getScoreMax() + "'></td></tr>";
        html += "<tr><td><b>Kondisi</b></td><td><select id='kondisiTrain'><option value='0'>OR</option><option value='1'>AND</option></select></td></tr>";
        html += "<tr><td><input type='hidden' id='candidatTrainId' value='" + oidCandPosTrain + "'></td><td>" + btnSaveOnly + " " + btnSave + " " + btnCancel + "</td></tr>";
        html += "</table>";
        return html;
    }

    private String getFormEducation(long oidCandPosEdu) {
        CandidatePositionEducation data = new CandidatePositionEducation();
        if (oidCandPosEdu > 0) {
            try {
                data = PstCandidatePositionEducation.fetchExc(oidCandPosEdu);
            } catch (Exception e) {
                System.out.println("ERROR : " + e.getMessage());
            }
        }
        
        Vector<Education> educationList = PstEducation.list(0, 0, "", PstEducation.fieldNames[PstEducation.FLD_EDUCATION]);
        String option = "";
        for (Education education : educationList) {
            String selected = (data.getEducationId()== education.getOID()) ? "selected":"";
            option += "<option " + selected + " value='" + education.getOID() + "'>" + education.getEducation()+ "</option>";
        }

		String btnSaveOnly = "<button onclick='saveEducation(0)' class='btn-small' style='color: green'>Simpan</button>";
        String btnSave = "<button onclick='saveEducation(1)' class='btn-small' style='color: green'>Simpan dan Cari</button>";
        String btnCancel = "<button onclick='loadAjax(\"listEducation\", \"&command=" + Command.LIST + "\")' class='btn-small'>Batal</button>";

        String html = "<table>";
        html += "<tr><td><b>Pendidikan</b></td><td><select id='educationId' style='width:90%'>" + option + "</select></td></tr>";
        html += "<tr><td><b>Skor Minimal</b></td><td><input type='text' id='minScoreEducation' value='" + data.getScoreMin() + "'></td></tr>";
        html += "<tr><td><b>Skor Rekomendasi</b></td><td><input type='text' id='recScoreEducation' value='" + data.getScoreMax() + "'></td></tr>";
        html += "<tr><td><input type='hidden' id='candidatEduId' value='" + oidCandPosEdu + "'></td><td>" + btnSaveOnly + " " + btnSave + " " + btnCancel + "</td></tr>";
        html += "</table>";
        return html;
    }

    private String getFormCandidatLocation(long candidateLocId) {
        CandidateLocation data = new CandidateLocation();
        if (candidateLocId > 0) {
            try {
                data = PstCandidateLocation.fetchExc(candidateLocId);
            } catch (Exception e) {
                System.out.println("ERROR : " + e.getMessage());
            }
        }
        
        Vector<Company> listCompany = PstCompany.list(0, 0, "", PstCompany.fieldNames[PstCompany.FLD_COMPANY]);
        String optionCompany = "<option value='0'>-</option>";
        long companyId = data.getCompanyId();
        for (Company company : listCompany) {
            if (companyId == 0) {
                //companyId = company.getOID();
            }
            String selected = (data.getCompanyId()== company.getOID()) ? "selected":"";
            optionCompany += "<option " + selected + " value='" + company.getOID() + "'>" + company.getCompany()+ "</option>";
        }
        
        String whereDivision = PstDivision.fieldNames[PstDivision.FLD_VALID_STATUS] + " = " + PstDivision.VALID_ACTIVE;
        whereDivision += " AND " + PstDivision.fieldNames[PstDivision.FLD_COMPANY_ID] + " = " + companyId;
        Vector<Division> listDivision = PstDivision.list(0, 0, whereDivision, PstDivision.fieldNames[PstDivision.FLD_DIVISION]);
        String optionDivision = "<option value='0'>-</option>";
        long divisionId = data.getDivisionId();
        for (Division division : listDivision) {
            if (divisionId == 0) {
                //divisionId = division.getOID();
            }
            String selected = (data.getDivisionId()== division.getOID()) ? "selected":"";
            optionDivision += "<option " + selected + " value='" + division.getOID() + "'>" + division.getDivision()+ "</option>";
        }
        
        String whereDepartment = PstDepartment.TBL_HR_DEPARTMENT + "." + PstDepartment.fieldNames[PstDepartment.FLD_VALID_STATUS] + " = " + PstDepartment.VALID_ACTIVE;
        whereDepartment += " AND " + PstDepartment.TBL_HR_DEPARTMENT + "." + PstDepartment.fieldNames[PstDepartment.FLD_DIVISION_ID] + " = " + divisionId;
        Vector<Department> listDepartment = PstDepartment.list(0, 0, whereDepartment, PstDepartment.fieldNames[PstDepartment.FLD_DEPARTMENT]);
        String optionDepartment = "<option value='0'>-</option>";
        long departmentId = data.getDepartmentId();
        for (Department department : listDepartment) {
            if (departmentId == 0) {
                //departmentId = department.getOID();
            }
            String selected = (data.getDepartmentId()== department.getOID()) ? "selected":"";
            optionDepartment += "<option " + selected + " value='" + department.getOID() + "'>" + department.getDepartment()+ "</option>";
        }
        
        String whereSection = PstSection.fieldNames[PstSection.FLD_VALID_STATUS] + " = " + PstSection.VALID_ACTIVE;
        whereSection += " AND " + PstSection.fieldNames[PstSection.FLD_DEPARTMENT_ID] + " = " + departmentId;
        Vector<Section> listSection = PstSection.list(0, 0, whereSection, PstSection.fieldNames[PstSection.FLD_SECTION]);
        String optionSection = "<option value='0'>-</option>";
        for (Section section : listSection) {
            String selected = (data.getSectionId()== section.getOID()) ? "selected":"";
            optionSection += "<option " + selected + " value='" + section.getOID() + "'>" + section.getSection()+ "</option>";
        }

		String btnSaveOnly = "<button onclick='saveCandidatLocation(0)' class='btn-small' style='color: green'>Simpan</button>";
        String btnSave = "<button onclick='saveCandidatLocation(1)' class='btn-small' style='color: green'>Simpan dan Cari</button>";
        String btnCancel = "<button onclick='hideCandidatLocationForm()' class='btn-small'>Selesai</button>";

        String html = "<table>";
        html += "<tr><td><b>Perusahaan</b></td><td><select id='companyId' onchange='listDivision()'>" + optionCompany + "</select></td></tr>";
        html += "<tr><td><b>Satuan Kerja</b></td><td><select id='divisionId' onchange='listDepartment()'>" + optionDivision + "</select></td></tr>";
        html += "<tr><td><b>Unit</b></td><td><select id='departmentId' onchange='listSection()'>" + optionDepartment + "</select></td></tr>";
        html += "<tr><td><b>Sub Unit</b></td><td><select id='sectionId'>" + optionSection + "</select></td></tr>";
        html += "<tr><td><input type='hidden' id='candidateLocId' value='" + candidateLocId + "'></td><td>" + btnSaveOnly + " " + btnSave + " " + btnCancel + "</td></tr>";
        html += "</table>";
        return html;
    }

    // ========== * ========== ACTION SAVE ========== * ==========
    private void saveGrade(long oidCandidate, long oidCandGradeReq, long minGradeLevelId, long maxGradeLevelId, long positionId, int kondisi) {
        try {
            CandidateGradeRequired data = new CandidateGradeRequired();
            data.setCandidateMainId(oidCandidate);
            data.setGradeMinimum(new GradeLevel(minGradeLevelId, "", 0));
            data.setGradeMaximum(new GradeLevel(maxGradeLevelId, "", 0));
            data.setPositionId(positionId);
            data.setKondisi(kondisi);
            if (oidCandGradeReq == 0) {
                PstCandidateGradeRequired.insertExc(data);
            } else {
                data.setOID(oidCandGradeReq);
                PstCandidateGradeRequired.updateExc(data);
            }
        } catch (Exception e) {
            System.out.println("ERROR : " + e.getMessage());
        }
    }

    private void saveExperience(long oidCandidate, long oidCandPosExper, long experienceId, long oidPosition, int experDurMin, int experDurRecom, int kondisi) {
        try {
            CandidatePositionExperience data = new CandidatePositionExperience();
            data.setCandidateMainId(oidCandidate);
            data.setExperienceId(experienceId);
            data.setPositionId(oidPosition);
            data.setDurationMin(experDurMin);
            data.setDurationRecommended(experDurRecom);
            data.setKondisi(kondisi);
			data.setType(0);
            if (oidCandPosExper == 0) {
                PstCandidatePositionExperience.insertExc(data);
            } else {
                data.setOID(oidCandPosExper);
                PstCandidatePositionExperience.updateExc(data);
            }
        } catch (Exception e) {
            System.out.println("ERROR : " + e.getMessage());
        }
    }

	private void saveExperienceLevel(long oidCandidate, long oidCandPosExper, long experienceLevelId, long oidPosition, int experDurMin, int experDurRecom, int kondisi) {
        try {
            CandidatePositionExperience data = new CandidatePositionExperience();
            data.setCandidateMainId(oidCandidate);
            data.setExperienceId(experienceLevelId);
            data.setPositionId(oidPosition);
            data.setDurationMin(experDurMin);
            data.setDurationRecommended(experDurRecom);
            data.setKondisi(kondisi);
			data.setType(1);
            if (oidCandPosExper == 0) {
                PstCandidatePositionExperience.insertExc(data);
            } else {
                data.setOID(oidCandPosExper);
                PstCandidatePositionExperience.updateExc(data);
            }
        } catch (Exception e) {
            System.out.println("ERROR : " + e.getMessage());
        }
    }

    private void saveCompetency(long oidCandidate, long oidCandPosComp, long competencyId, long oidPosition, int compScoreMin, int compScoreMax, int compScoreBobot, int kondisi) {
        try {
            CandidatePositionCompetency data = new CandidatePositionCompetency();
            data.setCandidateMainId(oidCandidate);
            data.setCompetencyId(competencyId);
            data.setPositionId(oidPosition);
            data.setScoreMin(compScoreMin);
            data.setScoreMax(compScoreMax);
            data.setBobot(compScoreBobot);
            data.setKondisi(kondisi);
            if (oidCandPosComp == 0) {
                PstCandidatePositionCompetency.insertExc(data);
            } else {
                data.setOID(oidCandPosComp);
                PstCandidatePositionCompetency.updateExc(data);
            }
        } catch (Exception e) {
            System.out.println("ERROR : " + e.getMessage());
        }
    }
    
    private void saveAssessment(long oidCandidate, long oidCandPosAss, long assessmentId, long oidPosition, int assScoreMin, int assScoreMax, int assScoreBobot, int tahun, int kondisi) {
        try {
            CandidatePositionAssessment data = new CandidatePositionAssessment();
            data.setCandidateMainId(oidCandidate);
            data.setAssessmentId(assessmentId);
            data.setPositionId(oidPosition);
            data.setScoreMin(assScoreMin);
            data.setScoreMax(assScoreMax);
            data.setBobot(assScoreBobot);
            data.setTahun(tahun);
            data.setKondisi(kondisi);
            if (oidCandPosAss == 0) {
                PstCandidatePositionAssessment.insertExc(data);
            } else {
                data.setOID(oidCandPosAss);
                PstCandidatePositionAssessment.updateExc(data);
            }
        } catch (Exception e) {
            System.out.println("ERROR : " + e.getMessage());
        }
    }

    private void saveTraining(long oidCandidate, long oidCandPosTrain, long trainingId, long oidPosition, int trainScoreMin, int trainScoreMax, int kondisi) {
        try {
            CandidatePositionTraining data = new CandidatePositionTraining();
            data.setCandidateMainId(oidCandidate);
            data.setTrainingId(trainingId);
            data.setPositionId(oidPosition);
            data.setScoreMin(trainScoreMin);
            data.setScoreMax(trainScoreMax);
            data.setKondisi(kondisi);
            if (oidCandPosTrain == 0) {
                PstCandidatePositionTraining.insertExc(data);
            } else {
                data.setOID(oidCandPosTrain);
                PstCandidatePositionTraining.updateExc(data);
            }
        } catch (Exception e) {
            System.out.println("ERROR : " + e.getMessage());
        }
    }
    
    private void saveEducation(long oidCandidate, long oidCandPosEdu, long educationId, long oidPosition, int eduScoreMin, int eduScoreMax, int kondisi) {
        try {
            CandidatePositionEducation data = new CandidatePositionEducation();
            data.setCandidateMainId(oidCandidate);
            data.setEducationId(educationId);
            data.setPositionId(oidPosition);
            data.setScoreMin(eduScoreMin);
            data.setScoreMax(eduScoreMax);
            data.setKondisi(kondisi);
            if (oidCandPosEdu == 0) {
                PstCandidatePositionEducation.insertExc(data);
            } else {
                data.setOID(oidCandPosEdu);
                PstCandidatePositionEducation.updateExc(data);
            }
        } catch (Exception e) {
            System.out.println("ERROR : " + e.getMessage());
        }
    }
    
    private void saveCandidatLocation(long oidCandidate, long candidateLocId, long companyId, long divisionId, long departmentId, long sectionId, int codeOrg) {
        try {
            CandidateLocation data = new CandidateLocation();
            data.setCandidateMainId(oidCandidate);
            data.setCompanyId(companyId);
            data.setDivisionId(divisionId);
            data.setDepartmentId(departmentId);
            data.setSectionId(sectionId);
            data.setCode(codeOrg);
            if (candidateLocId == 0) {
                PstCandidateLocation.insertExc(data);
            } else {
                data.setOID(candidateLocId);
                PstCandidateLocation.updateExc(data);
            }
        } catch (Exception e) {
            System.out.println("ERROR : " + e.getMessage());
        }
    }

    // ========== * ========== ACTION DELETE ========== * ==========
    private void deleteGrade(long oidCandGradeReq) {
        try {
            PstCandidateGradeRequired.deleteExc(oidCandGradeReq);
        } catch (Exception e) {
            System.out.println("ERROR : " + e.getMessage());
        }
    }

    private void deleteExperience(long oidCandPosExper) {
        try {
            PstCandidatePositionExperience.deleteExc(oidCandPosExper);
        } catch (Exception e) {
            System.out.println("ERROR : " + e.getMessage());
        }
    }

	private void deleteExperienceLevel(long oidCandLevelExper) {
        try {
            PstCandidatePositionExperience.deleteExc(oidCandLevelExper);
        } catch (Exception e) {
            System.out.println("ERROR : " + e.getMessage());
        }
    }

    private void deleteCompetency(long oidCandPosComp) {
        try {
            PstCandidatePositionCompetency.deleteExc(oidCandPosComp);
        } catch (Exception e) {
            System.out.println("ERROR : " + e.getMessage());
        }
    }
    
    private void deleteAssesment(long oidCandPosAss) {
        try {
            PstCandidatePositionAssessment.deleteExc(oidCandPosAss);
        } catch (Exception e) {
            System.out.println("ERROR : " + e.getMessage());
        }
    }

    private void deleteTraining(long oidCandPosTrain) {
        try {
            PstCandidatePositionTraining.deleteExc(oidCandPosTrain);
        } catch (Exception e) {
            System.out.println("ERROR : " + e.getMessage());
        }
    }

    private void deleteEducation(long oidCandPosEdu) {
        try {
            PstCandidatePositionEducation.deleteExc(oidCandPosEdu);
        } catch (Exception e) {
            System.out.println("ERROR : " + e.getMessage());
        }
    }

    private void deleteCandidatLocation(long candidateLocId) {
        try {
            PstCandidateLocation.deleteExc(candidateLocId);
        } catch (Exception e) {
            System.out.println("ERROR : " + e.getMessage());
        }
    }
    
%>

<%= htmlReturn%>
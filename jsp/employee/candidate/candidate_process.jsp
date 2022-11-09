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
<%@ include file = "../../main/javainit.jsp" %>
<% int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_EMPLOYEE, AppObjInfo.G2_CANDIDATE, AppObjInfo.OBJ_CANDIDATE_SEARCH);%>
<%@ include file = "../../main/checkuser.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%//
    int iCommand = FRMQueryString.requestCommand(request);
    long oidCandidate = FRMQueryString.requestLong(request, "candidate_main_id");
    long positionId = FRMQueryString.requestLong(request, "position_id");
    String[] checkEmp = FRMQueryString.requestStringValues(request, "check_emp");
    ChangeValue changeValue = new ChangeValue();
    boolean status_aktif = FRMQueryString.requestBoolean(request, "status_aktif");
    boolean status_mbt = FRMQueryString.requestBoolean(request, "status_mbt");
    boolean status_berhenti = FRMQueryString.requestBoolean(request, "status_berhenti");
    SessCandidateParam parameters = new SessCandidateParam();
    parameters.setEmployeeStatusActiv(status_aktif);
    parameters.setEmployeeStatusMBT(status_mbt);
    parameters.setEmployeeStatusResigned(status_berhenti);

    Vector candidateList = SessCandidate.queryCandidate(oidCandidate, positionId, parameters);

%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Proses Kandidat</title>
        <link rel="stylesheet" href="../../styles/main.css" type="text/css">
        <link rel="stylesheet" type="text/css" href="../../styles/SlidePushMenu/css/component.css" />
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
                white-space: nowrap;
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
        </script>
            
        <script>
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
                        }  else if (action === "listCompetency" || action === "addCompetency" || action === "editCompetency" || action === "saveCompetency" || action === "saveOnlyCompetency" || action === "deleteCompetency") {
                            document.getElementById("form-competency").innerHTML = this.responseText;
                        } else if (action === "listTraining" || action === "addTraining" || action === "editTraining" || action === "saveTraining" || action === "saveOnlyTraining" || action === "deleteTraining") {
                            document.getElementById("form-training").innerHTML = this.responseText;
                        } else if (action === "listEducation" || action === "addEducation" || action === "editEducation" || action === "saveEducation" || action === "saveOnlyEducation" || action === "deleteEducation") {
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
                        
                        if (action === "saveGrade" || action === "saveExperience" || action === "saveCompetency" || action === "saveTraining" || action === "saveEducation" || action === "saveCandidatLocation") {
							document.getElementById("candidat-list").innerHTML = "<div class='loader'></div>";
                            listCandidat();
                        }
                        if (action === "deleteGrade" || action === "deleteExperience" || action === "deleteCompetency" || action === "deleteTraining" || action === "deleteEducation" || action === "deleteCandidatLocation") {
							document.getElementById("candidat-list").innerHTML = "<div class='loader'></div>";
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
                
                var parameter = "&command=<%=Command.SAVE %>";
                parameter += "&position_id=<%=positionId%>";
                parameter += "&oid_cand_grade_req=" + candidatGradeId;
                parameter += "&min_grade_level_id=" + gradeMin;
                parameter += "&max_grade_level_id=" + gradeMax;
                
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
                
                var parameter = "&command=<%=Command.SAVE %>";
                parameter += "&position_id=<%=positionId%>";
                parameter += "&oid_cand_pos_exper=" + candidatExpId;
                parameter += "&experience_id=" + experienceId;
                parameter += "&exper_dur_min=" + experDurMin;
                parameter += "&exper_dur_recom=" + experDurRecom;
                
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
                
                var parameter = "&command=<%=Command.SAVE %>";
                parameter += "&position_id=<%=positionId%>";
                parameter += "&oid_cand_level_exper=" + candidatExpLevelId;
                parameter += "&experience_level_id=" + experienceLevelId;
                parameter += "&exper_dur_level_min=" + experLevelDurMin;
                parameter += "&exper_dur_level_recom=" + experLevelDurRecom;
                
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
                
                var parameter = "&command=<%=Command.SAVE %>";
                parameter += "&position_id=<%=positionId%>";
                parameter += "&oid_cand_pos_comp=" + candidatCompId;
                parameter += "&competency_id=" + competencyId;
                parameter += "&comp_score_min=" + compScoreMin;
                parameter += "&comp_score_max=" + compScoreMax;
                
				if (type===1){
					loadAjax("saveCompetency", parameter);
				} else {
					loadAjax("saveOnlyCompetency", parameter);
				}
            }

            function saveTraining(type) {
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
            }

            function saveEducation(type) {
                var candidatEduId = document.getElementById("candidatEduId").value;
                var educationId = document.getElementById("educationId").value;
                var eduScoreMin = document.getElementById("minScoreEducation").value;
                var eduScoreMax = document.getElementById("recScoreEducation").value;
                
                var parameter = "&command=<%=Command.SAVE %>";
                parameter += "&position_id=<%=positionId%>";
                parameter += "&oid_cand_pos_edu=" + candidatEduId;
                parameter += "&education_id=" + educationId;
                parameter += "&edu_score_min=" + eduScoreMin;
                parameter += "&edu_score_max=" + eduScoreMax;
                
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
                    loadAjax("deleteExperience", "&command=<%=Command.DELETE %>&oid_cand_level_exper=" + oidCandPosExper);
                }
            };
            
            function deleteCompetency(oidCandPosComp) {
                if (confirm("Hapus filter kompetensi?")) {
                    loadAjax("deleteCompetency", "&command=<%=Command.DELETE %>&oid_cand_pos_comp=" + oidCandPosComp);
                }
            };
            
            function deleteTraining(oidCandPosTrain) {
                if (confirm("Hapus filter pelatihan?")) {
                    loadAjax("deleteTraining", "&command=<%=Command.DELETE %>&oid_cand_pos_train=" + oidCandPosTrain);
                }
            };
            
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
                var statusAktif = document.getElementById("status_aktif");
                var statusMbt = document.getElementById("status_mbt");
                var statusBerhenti = document.getElementById("status_berhenti");
                
                var parameter = "&command=<%=Command.LIST %>";
                parameter += "&position_id=<%=positionId%>";
                parameter += "&status_aktif=" + statusAktif.checked;
                parameter += "&status_mbt=" + statusMbt.checked;
                parameter += "&status_berhenti=" + statusBerhenti.checked;
                
                loadAjax("listCandidat", parameter);
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
                <strong>Talent Pool</strong> <strong style="color:#333;"> / </strong>Hasil Pencarian
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
                    <div id="form-competency"></div>
                </div>
                <div class="filter-group">
                    <div id="form-training"></div>
                </div>
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
                <input type="hidden" name="candidate_main_id" value="<%= oidCandidate%>" />
                <input type="hidden" name="employee_id" value="" />
                <input type="hidden" name="employee_oid" value="" />
                <input type="hidden" name="position_id" value="" />

                <input type="hidden" name="command" value="<%=iCommand%>">
                <div class="floating-menu">
                    <h3 id="showRight">Filter Pencarian</h3>
                </div>

                <h1 style="color: #575757">Hasil Pencarian Talent Pool : <%= changeValue.getPositionName(positionId)%></h1><br>

                <div>&nbsp;</div>
                <%
                    if (checkEmp != null && checkEmp.length > 0) {
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
                    }
                %>
                <div>&nbsp;</div>
                <!--<a href="javascript:cmdExportToExcel()" class="btn-small">Export ke Excel</a>-->
                <a href="javascript:cmdToTalentPool()" class="btn-small">Pindahkan ke talent pool</a>
                <div>&nbsp;</div>
                <div id="candidat-list" style="">
                    <h3><%= candidateList.size() %> data kandidat ditemukan</h3>
                    <table class="tblStyle">
                        <tr>
                            <td class="title_tbl">&nbsp;</td>
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
							<td class="title_tbl">Total Score</td>
                            <td class="title_tbl">Action</td>
                        </tr>
                        <%
                            if (candidateList != null && candidateList.size() > 0) {
                                for (int c = 0; c < candidateList.size(); c++) {
                                    EmployeeCandidate candidate = (EmployeeCandidate) candidateList.get(c);
                        %>
                        <tr>
                            <td><input type="checkbox" name="check_emp" value="<%= candidate.getEmployeeId()%>" /></td>
                            <td><%= (c + 1)%></td>
                            <td>
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
                                        out.println("<img height=\"135\" id=\"photo\" title=\"Click here to upload\"  src=\"" + approot + "/" + pictPath + "\">");
                                    } else {
                                %>
                                <img width="135" height="135" id="photo" src="<%=approot%>/imgcache/no-img.jpg" />
                                <%

                                    }
                                %> 
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
							<td><%= Formater.formatNumber(candidate.getTotal(), "###.##")%></td>
                            <td><a href="javascript:cmdDetail('<%= candidate.getEmployeeId()%>','<%= positionId%>')">Score Detail</a></td>
                        </tr>
                        <%
                                }
                            }
                        %>
                    </table>
                </div>
                <div>&nbsp;</div>
                <a href="javascript:cmdBack('<%= oidCandidate%>')" class="btn-small">Kembali ke pencarian</a> | 
                <a href="javascript:cmdPrint('<%= oidCandidate%>')" class="btn-small">Print List</a>
                <%
                    String strCandiateNote = "";
                    try {
                        strCandiateNote = PstSystemProperty.getValueByName("CANDIDATE_FOOTNOTE");
                    } catch (Exception ex) {
                        System.out.println("[exception] " + ex.toString());
                    }
                %>
                <div> 
                    <div>&nbsp;</div>
                    <div>
                        <%=(strCandiateNote == null || strCandiateNote.equalsIgnoreCase("Not initialized") ? "" : strCandiateNote)%>
                    </div>
                </div> 
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
                loadAjax("listCompetency", "&command=<%=Command.LIST%>");
                loadAjax("listTraining", "&command=<%=Command.LIST%>");
                loadAjax("listEducation", "&command=<%=Command.LIST%>");
                loadAjax("listCandidatLocation", "&command=<%=Command.LIST%>");
            };

            hideRight.onclick = function () {
                classie.toggle(this, 'active');
                classie.toggle(menuRight, 'cbp-spmenu-open');
            };
            
            //showRight.onclick();
            
        </script>
    </body>
</html>

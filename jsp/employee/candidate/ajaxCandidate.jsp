<%-- 
    Document   : ajaxCandidate
    Created on : Mar 14, 2020, 11:06:23 AM
    Author     : gndiw
--%>

<%@page import="com.dimata.util.Formater"%>
<%@page import="com.dimata.harisma.session.employee.SessCandidate"%>
<%@page import="com.dimata.harisma.session.employee.SessEmployeePicture"%>
<%@page import="com.dimata.harisma.session.employee.SessCandidateParam"%>
<%@page import="com.dimata.util.Command"%>
<%@ include file = "../../main/javainit.jsp" %>
<% int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_EMPLOYEE, AppObjInfo.G2_CANDIDATE, AppObjInfo.OBJ_CANDIDATE_SEARCH);%>
<%@ include file = "../../main/checkuser.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%//
    int iCommand = FRMQueryString.requestCommand(request);
    String action = FRMQueryString.requestString(request, "action");
    long oidCandidate = FRMQueryString.requestLong(request, "candidate_main_id");
    long oidPosition = FRMQueryString.requestLong(request, "position_id");
    long posType = FRMQueryString.requestLong(request, "position_type");
    int showType = FRMQueryString.requestInt(request, "show_type");
    
    long oidCandPosTrain = FRMQueryString.requestLong(request, "oid_cand_pos_train");
    long trainingId = FRMQueryString.requestLong(request, "training_id");
    int trainScoreMin = FRMQueryString.requestInt(request, "train_score_min");
    int trainScoreMax = FRMQueryString.requestInt(request, "train_score_max");
    
    long oidCandPosPower = FRMQueryString.requestLong(request, "oid_cand_pos_power");
    long firstColorId = FRMQueryString.requestLong(request, "first_color_id");
    long secondColorId = FRMQueryString.requestLong(request, "second_color_id");
    
    String htmlReturn = "";
    switch (iCommand) {
        case Command.LIST:
            if (action.equals("listCandidat")){
                htmlReturn = getListCandidat(oidCandidate, posType, approot, showType);
            } else if (action.equals("listTraining")){
                htmlReturn = getListTraining(oidCandidate);
            } else if (action.equals("listPower")){
                htmlReturn = getListPower(oidCandidate);
            }
        break;
        case Command.ADD:
            if (action.equals("addTraining")){
                htmlReturn = getFormTraining(0);
            } else if (action.equals("addPower")){
                htmlReturn = getFormPower(0);
            }
        break;
        case Command.EDIT:
            if (action.equals("editTraining")){
                htmlReturn = getFormTraining(oidCandPosTrain);
            } else if (action.equals("editPower")){
                htmlReturn = getFormPower(oidCandPosPower);
            }
        break;
        case Command.SAVE:
            if (action.equals("saveTraining") || action.equals("saveOnlyTraining")){
                saveTraining(oidCandidate, oidCandPosTrain, trainingId, oidPosition, trainScoreMin, trainScoreMax);
                htmlReturn = getListTraining(oidCandidate);
            } else if (action.equals("savePower") || action.equals("saveOnlyPower")){
                savePower(oidCandidate, oidCandPosPower, firstColorId, secondColorId);
                htmlReturn = getListPower(oidCandidate);
            }
        break;
        case Command.DELETE:
            if (action.equals("deleteTraining")){
                deleteTraining(oidCandPosTrain);
                htmlReturn = getListTraining(oidCandidate);
            } else if (action.equals("deletePower")){
                deletePower(oidCandPosPower);
                htmlReturn = getListPower(oidCandidate);
            }
        break;
        default:
            htmlReturn = "???";
            break;
    }
%>
<%!
    // ========== * ========== ACTION LIST ========== * ==========
    private String getListCandidat(long oidCandidate, long positionId, String approot, int showType) {
        Vector listEmployee = PstEmpTalentPool.listJoinCandidate(oidCandidate, positionId, "");
        String whereClause = PstCandidateResult.fieldNames[PstCandidateResult.FLD_CANDIDATE_MAIN_ID]+"="+oidCandidate
            +" AND "+PstCandidateResult.fieldNames[PstCandidateResult.FLD_POSITION_TYPE_ID]+"= "+positionId;
        int canStatus = 0;
        Vector listCandidat = PstCandidateResult.list(0, 0, whereClause, "");
        if (listCandidat.size()>0 && showType == 0){
            
            String inEmp = "";
            for (int i=0; i < listCandidat.size(); i++){
                CandidateResult candidateResult = (CandidateResult) listCandidat.get(i);
                if (i > 0){
                    inEmp = inEmp + ",";
                }
                inEmp = inEmp + candidateResult.getEmployeeId();
            }
            listEmployee = PstEmpTalentPool.listJoinCandidate(oidCandidate, positionId, inEmp);
        }
        
        if (listCandidat.size()>0){
            canStatus = 1;
        }
        
        String html = "<input type='hidden' id='canStatus' value='"+canStatus+"'>"
                + "<table id=\"tabel\" class=\"display\" style=\"width:100%\">"
                + "<thead>"
                    + "<tr>"
                        + "<td>&nbsp;</td>"
                        + "<td>Photo</td>"
                        + "<td>Nama Karyawan</td>"
                        + "<td>Mulai Kerja</td>"
                        + "<td>Satuan Kerja</td>"
                        + "<td>Unit</td>"
                        + "<td>Sub Unit</td>"
                        + "<td>Jabatan</td>"
                        + "<td>Grade</td>"
                        + "<td>Grade Rank</td>"
                        + "<td>Masa Kerja</td>"
                        + "<td>Total Score</td>"
                        + "<td>Action</td>"
                    + "</tr>"
                + "</thead>";
                if (listEmployee.size() > 0) {
                    html += "<tbody>";
                    for (int i = 0; i < listEmployee.size(); i++) {
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
                        whereClause = PstCandidateResult.fieldNames[PstCandidateResult.FLD_CANDIDATE_MAIN_ID]+"="+oidCandidate
                                +" AND "+PstCandidateResult.fieldNames[PstCandidateResult.FLD_POSITION_TYPE_ID]+"= "+positionId
                                +" AND "+PstCandidateResult.fieldNames[PstCandidateResult.FLD_EMPLOYEE_ID]+"= "+emp.getOID();
                        Vector listCandidatSelect = PstCandidateResult.list(0, 0, whereClause, "");
                         String checked = "";
                         if (listCandidatSelect.size()>0){
                             checked = "checked";
                         }
                        
                        html += "<tr>"
                                    + "<td><input type=\"checkbox\" name=\"check_emp\" value=\""+emp.getOID()+"\" "+checked+"></td>"
                                    + "<td><div class=\"imgcontainer\">"+img+"</div></td>"
                                    + "<td>("+emp.getEmployeeNum()+")" +emp.getFullName()+"</td>"
                                    + "<td>"+emp.getCommencingDate()+"</td>"
                                    + "<td>"+PstEmployee.getDivisionName(emp.getDivisionId())+"</td>"
                                    + "<td>"+PstEmployee.getDepartmentName(emp.getDepartmentId())+"</td>"
                                    + "<td>"+PstEmployee.getSectionName(emp.getSectionId())+"</td>"
                                    + "<td>"+PstEmployee.getPositionName(emp.getPositionId())+"</td>"
                                    + "<td>"+gradeLevel.getCodeLevel()+"</td>"
                                    + "<td>"+gradeLevel.getGradeRank()+"</td>"
                                    + "<td>"+SessCandidate.getLOS(emp.getCommencingDate())+"</td>"
                                    + "<td>"+Formater.formatNumber(empTalentPool.getTotalScore(), "###.##")+"</td>"
                                    + "<td><a href=\"javascript:cmdDetail('"+empTalentPool.getEmployeeId()+"','"+ positionId+"')\">Detail Gap</a></td>"
                                + "</tr>";
                    }
                    html += "</tbody>";
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
            html += "<td style='text-align: center; white-space: nowrap'>" + btnEdit + "&nbsp;&nbsp;" + btnDelete + "</td>";
            html += "</tr>";
        }
        html += "</table>";
        return html;
    }
    
    private String getListPower(long oidCandidate) {
        String btnAdd = "<button onclick='loadAjax(\"addPower\", \"&command=" + Command.ADD + "\")' class='btn-small'>Tambah</button>";
        
        String html = "<table class='tblStyle'>";
        html += "<tr>";
        html += "<td class='title_tbl'>Character Power</td>";
        html += "<td class='title_tbl' style='text-align: center;'>" + btnAdd + "</td>";
        html += "</tr>";
        
        String wherePower = PstCandidatePositionPower.fieldNames[PstCandidatePositionPower.FLD_CANDIDATE_MAIN_ID] + "=" + oidCandidate;
        Vector<CandidatePositionPower> posPowerList = PstCandidatePositionPower.list(0, 0, wherePower, "");
        for (CandidatePositionPower power : posPowerList) {
            String color = "-";
            try {
                color = "<div style=\"background-color : "+PstPowerCharacterColor.fetchExc(power.getFirstPowerCharacterId()).getColorHex()+"; width: 50%; height:15px; display: table-cell;\">&nbsp;</div>&nbsp;";
                color += "<div style=\"background-color : "+PstPowerCharacterColor.fetchExc(power.getSecondPowerCharacterId()).getColorHex()+"; width: 50%; height:15px; display: table-cell;\">&nbsp;</div>";
            } catch (Exception e) {
                System.out.println("ERROR : " + e.getMessage());
            }
            String btnEdit = "<b style='cursor: pointer; color: blue' onclick='loadAjax(\"editPower\", \"&command=" + Command.EDIT + "&oid_cand_pos_power=" + power.getOID() + "\")'>Ubah</b>";
            String btnDelete = "<b style='cursor: pointer; color: red' onclick='deletePower(\"" + power.getOID() + "\")'>Hapus</b>";
            
            html += "<tr>";
            html += "<td><div style=\"width: 100%; display: table;\"><div style=\"display: table-row\">" + color + "</div></div></td>";
            html += "<td style='text-align: center; white-space: nowrap'>" + btnEdit + "&nbsp;&nbsp;" + btnDelete + "</td>";
            html += "</tr>";
        }
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
        html += "<tr><td><input type='hidden' id='candidatTrainId' value='" + oidCandPosTrain + "'></td><td>" + btnSaveOnly + " " + btnSave + " " + btnCancel + "</td></tr>";
        html += "</table>";
        return html;
    }
    
    private String getFormPower(long oidCandPosPower) {
        CandidatePositionPower data = new CandidatePositionPower();
        if (oidCandPosPower > 0) {
            try {
                data = PstCandidatePositionPower.fetchExc(oidCandPosPower);
            } catch (Exception e) {
                System.out.println("ERROR : " + e.getMessage());
            }
        }
        
        Vector<PowerCharacterColor> powerList = PstPowerCharacterColor.list(0, 0, "", PstPowerCharacterColor.fieldNames[PstPowerCharacterColor.FLD_COLOR_NAME]);
        String firstOption = "";
        String secondOption = "";
        for (PowerCharacterColor power : powerList) {
            String firstSelected = (data.getFirstPowerCharacterId()== power.getOID()) ? "selected":"";
            String secondSelected = (data.getSecondPowerCharacterId()== power.getOID()) ? "selected":"";
            firstOption += "<option " + firstSelected + " value='" + power.getOID() + "'>" + power.getColorName()+ "</option>";
            secondOption += "<option " + secondSelected + " value='" + power.getOID() + "'>" + power.getColorName()+ " </option>";
        }

		String btnSaveOnly = "<button onclick='savePower(0)' class='btn-small' style='color: green'>Simpan</button>";
        String btnSave = "<button onclick='savePower(1)' class='btn-small' style='color: green'>Simpan dan Cari</button>";
        String btnCancel = "<button onclick='loadAjax(\"listPower\", \"&command=" + Command.LIST + "\")' class='btn-small'>Batal</button>";

        String html = "<table>";
        html += "<tr><td><b>Warna Pertama</b></td><td><select id='firstColorId' style='width:90%'>" + firstOption + "</select></td></tr>";
        html += "<tr><td><b>Warna Kedua</b></td><td><select id='secondColorId' style='width:90%'>" + secondOption + "</select></td></tr>";
        html += "<tr><td><input type='hidden' id='candidatPowerId' value='" + oidCandPosPower + "'></td><td>" + btnSaveOnly + " " + btnSave + " " + btnCancel + "</td></tr>";
        html += "</table>";
        return html;
    }
    
    private void saveTraining(long oidCandidate, long oidCandPosTrain, long trainingId, long oidPosition, int trainScoreMin, int trainScoreMax) {
        try {
            CandidatePositionTraining data = new CandidatePositionTraining();
            data.setCandidateMainId(oidCandidate);
            data.setTrainingId(trainingId);
            data.setPositionId(oidPosition);
            data.setScoreMin(trainScoreMin);
            data.setScoreMax(trainScoreMax);
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
    
    private void savePower(long oidCandidate, long oidCandPosPower, long firstColorId, long secondColorId) {
        try {
            CandidatePositionPower data = new CandidatePositionPower();
            data.setCandidateMainId(oidCandidate);
            data.setFirstPowerCharacterId(firstColorId);
            data.setSecondPowerCharacterId(secondColorId);
            if (oidCandPosPower == 0) {
                PstCandidatePositionPower.insertExc(data);
            } else {
                data.setOID(oidCandPosPower);
                PstCandidatePositionPower.updateExc(data);
            }
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
    
    private void deletePower(long oidCandPosPower) {
        try {
            PstCandidatePositionPower.deleteExc(oidCandPosPower);
        } catch (Exception e) {
            System.out.println("ERROR : " + e.getMessage());
        }
    }

%>
<%= htmlReturn%>
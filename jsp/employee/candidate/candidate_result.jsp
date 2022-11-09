<%-- 
    Document   : candidate_result
    Created on : Sep 22, 2015, 4:23:55 PM
    Author     : Dimata 007
--%>

<%@page import="com.dimata.qdep.db.DBHandler"%>
<%@page import="com.dimata.harisma.session.employee.SessCandidate"%>
<%@page import="com.dimata.harisma.session.employee.SessEmployeePicture"%>
<%@page import="com.dimata.qdep.entity.I_DocStatus"%>
<%@ include file = "../../main/javainit.jsp" %>
<% int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_EMPLOYEE, AppObjInfo.G2_DATABANK, AppObjInfo.OBJ_DATABANK);%>
<% boolean privGenerate = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_GENERATE_SALARY_LEVEL));%>
<%@ include file = "../../main/checkuser.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%!
    public String getCompanyName(long oidCompany){
        String str = "";
        Company company = new Company();
        try {
            company = PstCompany.fetchExc(oidCompany);
            str = company.getCompany();
        } catch(Exception e){
            System.out.println("getCompanyName=>"+e.toString());
        }
        return str;
    }
    
    public String getDivisionName(long oidDivision){
        String str = "";
        Division division = new Division();
        try {
            division = PstDivision.fetchExc(oidDivision);
            str = division.getDivision();
        } catch(Exception e){
            System.out.println("getDivisionName=>"+e.toString());
        }
        return str;
    }
    
    public String getDepartmentName(long oidDepartment){
        String str = "";
        Department department = new Department();
        try {
            department = PstDepartment.fetchExc(oidDepartment);
            str = department.getDepartment();
        } catch(Exception e){
            System.out.println("getDepartmentName=>"+e.toString());
        }
        return str;
    }
    
    public String getSectionName(long oidSection){
        String str = "";
        Section section = new Section();
        try {
            section = PstSection.fetchExc(oidSection);
            str = section.getSection();
        } catch(Exception e){
            System.out.println("getSectionName=>"+e.toString());
        }
        return str;
    }
    
    public String getLocationName(long locationId){
        String str = "";
        String whereClause = PstCandidateLocation.fieldNames[PstCandidateLocation.FLD_CANDIDATE_LOC_ID]+"="+locationId;
        Vector listCanLoc = PstCandidateLocation.list(0, 0, whereClause, "");
        if (listCanLoc != null && listCanLoc.size()>0){
            for(int i=0; i<listCanLoc.size(); i++){
                CandidateLocation canLoc = (CandidateLocation)listCanLoc.get(i);
                if (canLoc.getCompanyId() > 0){
                    str += getCompanyName(canLoc.getCompanyId())+" / ";
                }
                if (canLoc.getDivisionId() > 0){
                    str += getDivisionName(canLoc.getDivisionId())+" / ";
                }
                if (canLoc.getDepartmentId() > 0){
                    str += getDepartmentName(canLoc.getDepartmentId())+" / ";
                }
                if (canLoc.getSectionId() > 0){
                    str += getSectionName(canLoc.getSectionId());
                }
            }
        }
        return str;
    }

    public String getEducationName(long eduId){
        String str = "-";
        try {
            Education edu = PstEducation.fetchExc(eduId);
            str = edu.getEducation();
        } catch(Exception e){
            System.out.println(""+e.toString());
        }
        return str;
    }
    
    public String getTrainingName(long trainId){
        String str = "-";
        try {
            Training training = PstTraining.fetchExc(trainId);
            str = training.getName();
        } catch(Exception e){
            System.out.println(""+e.toString());
        }
        return str;
    }
    
    public String getCompetencyName(long compId){
        String str = "-";
        try {
            Competency competency = PstCompetency.fetchExc(compId);
            str = competency.getCompetencyName();
        } catch(Exception e){
            System.out.println(""+e.toString());
        }
        return str;
    }
    
    public String getKPIName(long kpiId){
        String str = "-";
        try {
            KPI_List kpiList = PstKPI_List.fetchExc(kpiId);
            str = kpiList.getKpi_title();
        } catch(Exception e){
            System.out.println(""+e.toString());
        }
        return str;
    }
%>
<%
    int iCommand = FRMQueryString.requestCommand(request);
    long candidateMainId = FRMQueryString.requestLong(request, "candidate_main_id");
    int typeMenu = FRMQueryString.requestInt(request, "type_menu");
    long posTypeId = FRMQueryString.requestLong(request, "position_type");
    if (posTypeId==0){
        Vector posTypeList = PstPositionType.list(0, 0, "", "");
        if (posTypeList.size() > 0){
            PositionType posType = (PositionType) posTypeList.get(0);
            posTypeId = posType.getOID();
        }
    }
    String whereClause = PstEmpTalentPool.fieldNames[PstEmpTalentPool.FLD_MAIN_ID]+"="+candidateMainId
            +" AND "+PstEmpTalentPool.fieldNames[PstEmpTalentPool.FLD_POSITION_TYPE_ID]+"= "+posTypeId;
    //Vector listEmployee = PstEmpTalentPool.list(0, 0, whereClause, PstEmpTalentPool.fieldNames[PstEmpTalentPool.FLD_TOTAL_SCORE]+" DESC");
    Vector listEmployee = PstEmpTalentPool.listJoinCandidate(candidateMainId, posTypeId, "");
    long positionId = 0;
    String whereCandidate = PstCandidatePosition.fieldNames[PstCandidatePosition.FLD_CANDIDATE_MAIN_ID]+"="+candidateMainId; 
    Vector candPosList = PstCandidatePosition.list(0, 0, whereCandidate, ""); 
    if (candPosList != null && candPosList.size()>0){
            CandidatePosition candidatePos = (CandidatePosition)candPosList.get(0);
            positionId = candidatePos.getPositionId();
    }
    
    if (iCommand == Command.SUBMIT){
        String[] empSelect = FRMQueryString.requestStringValues(request, "check_emp");
        try {
            final String sql = "DELETE FROM hr_candidate_result WHERE CANDIDATE_MAIN_ID =" + candidateMainId+" AND POSITION_TYPE_ID="+posTypeId;
            DBHandler.execUpdate(sql);
        }
        catch (Exception e) {
            e.printStackTrace();
        }
        if (empSelect != null){
            for (int i = 0; i < empSelect.length; i++){
                try {
                    CandidateResult candidateResult = new CandidateResult();
                    candidateResult.setCandidateMainId(candidateMainId);
                    candidateResult.setEmployeeId(Long.valueOf(empSelect[i]));
                    candidateResult.setPositionTypeId(posTypeId);
                    PstCandidateResult.insertExc(candidateResult);
                } catch (Exception exc){}
            }
        }
    }
    
    whereClause = PstCandidateResult.fieldNames[PstCandidateResult.FLD_CANDIDATE_MAIN_ID]+"="+candidateMainId
            +" AND "+PstCandidateResult.fieldNames[PstCandidateResult.FLD_POSITION_TYPE_ID]+"= "+posTypeId;
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
        listEmployee = PstEmpTalentPool.listJoinCandidate(candidateMainId, posTypeId, inEmp);
    }
    

%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Candidate Result</title>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
        <link rel="stylesheet" href="../../styles/main.css" type="text/css">
        <link rel="stylesheet" type="text/css" href="../../styles/SlidePushMenu/css/component.css" />
        <link rel="stylesheet" href="../../styles/tab.css" type="text/css">
        <link href="<%=approot%>/stylesheets/superTables.css" rel="Stylesheet" type="text/css" /> 
        <link rel="stylesheet" href="../../styles/datatable/jquery.dataTables.min.css" type="text/css">
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
        <script type="text/javascript">
            function cmdProcess(){
                document.frm.command.value="<%=Command.SAVE%>";
                document.frm.action = "";
                document.frm.submit();
            }
            function cmdAnalysis(){
                document.frm.command.value="<%=Command.VIEW%>";
                document.frm.target = "_blank";
                document.frm.action = "candidate_analysis.jsp";
                document.frm.submit();
            }
            function cmdRefresh(){
                document.frm.command.value="<%=Command.LIST%>";
                document.frm.action = "candidate_result.jsp";
                document.frm.submit();
            }
            function cmdDetail(oid, positionId) {
                document.frm.employee_id.value = oid;
                document.frm.position_id.value = positionId;
                document.frm.action = "candidate_detail.jsp";
                document.frm.target = "_blank";
                document.frm.submit();
            }
            function cmdBack(){
                document.frm.candidate_main_id.value=0;
                document.frm.action="candidate_list.jsp";
                document.frm.submit();
            }
            function cmdProccess(){
                document.frm.command.value="<%= Command.SUBMIT %>";
                document.frm.action="candidate_result.jsp";
                document.frm.submit();
            }
            function cmdPrint(oid) {
                document.frm.command.value = "<%=Command.VIEW%>";
                document.frm.candidate_main_id.value = oid;
                document.frm.action = "candidate_print.jsp";
                document.frm.target = "_print";
                document.frm.submit();
            }
            
        </script>
        <script>
            function loadAjax(action, parameter) {
                var xhttp = new XMLHttpRequest();
                xhttp.onreadystatechange = function () {
                    if (this.readyState == 4 && this.status == 200) {
                        if (action === "listTraining" || action === "addTraining" || action === "editTraining" || action === "saveTraining" || action === "saveOnlyTraining" || action === "deleteTraining") {
                            document.getElementById("form-training").innerHTML = this.responseText;
                        } else if (action === "listPower" || action === "addPower" || action === "editPower" || action === "savePower" || action === "saveOnlyPower" || action === "deletePower") {
                            document.getElementById("form-power").innerHTML = this.responseText;
                        } else if (action === "listCandidat") {
                            document.getElementById("candidat-list").innerHTML = this.responseText;
                            $(document).ready(function() {
                                $('#tabel').DataTable( {
                                    "paging":   false,
                                    "info":     false,
                                    "scrollY": "300px"
                                } );
                                
                                var canStatus = $("#canStatus").val();
                                if (canStatus == "1" ){
                                    $("#showType").css({ display: "block" });
                                } else {
                                    $("#showType").css({ display: "none" });
                                }
                                
                            } );
                        }
                        
                        if (action === "saveTraining" || action === "savePower") {
                            listCandidat();
                        }
                        if (action === "deleteTraining" || action === "deletePower") {
                            listCandidat();
                        }
                        
                    }
                };
                var url = "ajaxCandidate.jsp?candidate_main_id=<%=candidateMainId%>&action=" + action + parameter;
                xhttp.open("GET", url, true);
                xhttp.send();
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
            
            function savePower(type) {
                var candidatPowerId = document.getElementById("candidatPowerId").value;
                var firstColorId = document.getElementById("firstColorId").value;
                var secondColorId = document.getElementById("secondColorId").value;
                
                var parameter = "&command=<%=Command.SAVE %>";
                parameter += "&position_id=<%=positionId%>";
                parameter += "&oid_cand_pos_power=" + candidatPowerId;
                parameter += "&first_color_id=" + firstColorId;
                parameter += "&second_color_id=" + secondColorId;
                
                if (type===1){
                        loadAjax("savePower", parameter);
                } else {
                        loadAjax("saveOnlyPower", parameter);
                }
            }
            
            function deleteTraining(oidCandPosTrain) {
                if (confirm("Hapus filter pelatihan?")) {
                    loadAjax("deleteTraining", "&command=<%=Command.DELETE %>&oid_cand_pos_train=" + oidCandPosTrain);
                }
            };
            
            function deletePower(oidCandPosPower) {
                if (confirm("Hapus filter power character?")) {
                    loadAjax("deletePower", "&command=<%=Command.DELETE %>&oid_cand_pos_power=" + oidCandPosPower);
                }
            };
            
            function listCandidat() {
                var e = document.getElementById("posType");
                var strUser = e.options[e.selectedIndex].value;
                var radioValue = $("input[name='filter']:checked").val();
                var parameter = "&command=<%=Command.LIST %>";
                parameter += "&position_id=<%=positionId%>";
                parameter += "&position_type=" + strUser;
                parameter += "&show_type=" + radioValue;
                
                loadAjax("listCandidat", parameter);
            }
        </script>
        <script src="../../styles/datatable/jquery-3.3.1.js"></script>
        <script src="../../styles/datatable/jquery.dataTables.min.js"></script>
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
                <strong>Candidate</strong> <strong style="color:#333;"> / </strong>Hasil Pencarian
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
                    <div id="form-training"></div>
                </div>
                <div class="filter-group">
                    <div id="form-power"></div>
                </div>
            </div>
        </nav>
        <div class="content-main">
            <div class="floating-menu" style="position: absolute;">
                    <h3 id="showRight">Filter Pencarian</h3>
                </div>
            <form name="frm" method="post" action="">
                <input type="hidden" name="command" value="<%=iCommand%>">
                <input type="hidden" name="candidate_main_id" value="<%=candidateMainId%>">
                <input type="hidden" name="employee_id" value="" />
                <input type="hidden" name="position_id" value="" />
                <input type="hidden" name="result" value="1" />
                
                <table width="100%" style="z-index: -1;padding:9px; border:1px solid <%=garisContent%>;"  border="0" cellspacing="1" cellpadding="1" class="tablecolor">

                    <tr>
                        <td valign="top" width="20%"> <b>Klasifikasi</b> : 
                            <select id="posType" onchange="listCandidat()" name='position_type'>
                                <%
                                    Position pos = new Position();
                                    try {
                                        pos = PstPosition.fetchExc(positionId);
                                    } catch (Exception exc){}
                                    
                                    Vector<PositionType> posTypeList1 = PstPositionType.listJoin(0, 0, "LEVEL_ID = "+pos.getLevelId(), "");
                                    String option = "";
                                    for (PositionType posType : posTypeList1) {
                                        if (posTypeId == posType.getOID()) {
                                %> <option value="<%=posType.getOID()%>" selected><%=posType.getType()%></option><%;
                                            } else {
                                %> <option value="<%=posType.getOID()%>"><%=posType.getType()%></option><%;
                                                    }
                                                }
                                %>
                            </select>
                        </td>
                        <td valign="center"> 
                            <%
                                    String display = "style='display: none;'";
                                    if (listCandidat.size()>0){
                                        display = "style='display: block;'";
                                    }
                                    
                            %>
                            <div id="showType" <%=display%>>
                                <input type="radio" id="selected" name="filter" value="0" checked>
                                <label for="selected">Tampilkan Kandidat Terpilih</label>
                                <input type="radio" id="all" name="filter" value="1">
                                <label for="all">Tampilkan Semua Talent</label><br>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td valign="top" colspan="2">
                            <div id="candidat-list" style="">
                            <div>&nbsp;</div>
                                <table id="tabel" class="display" style="width:100%">
                                    <thead>
                                        <tr>
                                            <td>&nbsp;</td>
                                            <td>Photo</td>
                                            <td>Nama Karyawan</td>
                                            <td>Mulai Kerja</td>
                                            <td>Satuan Kerja</td>
                                            <td>Unit</td>
                                            <td>Sub Unit</td>
                                            <td>Jabatan</td>
                                            <td>Grade</td>
                                            <td>Grade Rank</td>
                                            <td>Masa Kerja</td>
                                            <td>Total Score</td>
                                            <td>Action</td>
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
                                            whereClause = PstCandidateResult.fieldNames[PstCandidateResult.FLD_CANDIDATE_MAIN_ID]+"="+candidateMainId
                                                    +" AND "+PstCandidateResult.fieldNames[PstCandidateResult.FLD_POSITION_TYPE_ID]+"= "+posTypeId
                                                    +" AND "+PstCandidateResult.fieldNames[PstCandidateResult.FLD_EMPLOYEE_ID]+"= "+emp.getOID();
                                            Vector listCandidatSelect = PstCandidateResult.list(0, 0, whereClause, "");
                                             String checked = "";
                                             if (listCandidatSelect.size()>0){
                                                 checked = "checked";
                                             }
                                        %>
                                        <tr>
                                            <td><input type="checkbox" name="check_emp" value="<%=emp.getOID()%>" <%=checked%>></td>
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
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>&nbsp;</td>
                    </tr>
                    <tr>
                        <td>
                            <a href="javascript:cmdBack()" class="btn-small">Kembali</a> 
                            <a href="javascript:cmdProccess()" class="btn-small">Simpan Kandidat</a>
                            <a href="javascript:cmdPrint('<%= candidateMainId%>')" class="btn-small">Print List</a>
                        </td>
                    </tr>

                </table>
                            
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
    </body>
    <!-- #BeginEditable "script" --> 
    <script language="JavaScript">
                $(document).ready(function() {
                    $('#tabel').DataTable( {
                        "paging":   false,
                        "info":     false,
                        "scrollY": "300px"
                    } );
                    
                    $("#selected").click(function(){
                        listCandidat();
                    });

                    $("#all").click(function(){
                        listCandidat();                                
                    });
                } );
    </script>
    <script>
            var menuRight = document.getElementById('cbp-spmenu-s2');
            var showRight = document.getElementById('showRight');
            var hideRight = document.getElementById('hideRight');

            showRight.onclick = function () {
                classie.toggle(this, 'active');
                classie.toggle(menuRight, 'cbp-spmenu-open');
                
                loadAjax("listTraining", "&command=<%=Command.LIST%>");
                loadAjax("listPower", "&command=<%=Command.LIST%>");
            };

            hideRight.onclick = function () {
                classie.toggle(this, 'active');
                classie.toggle(menuRight, 'cbp-spmenu-open');
            };
        </script>
                
    <!-- #EndEditable --> <!-- #EndTemplate -->
</html>
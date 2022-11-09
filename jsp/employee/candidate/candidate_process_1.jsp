<%-- 
    Document   : candidate_process
    Created on : Sep 28, 2016, 2:50:51 PM
    Author     : Dimata 007
--%>
<%@page import="com.dimata.harisma.session.employee.SessCandidate"%>
<%@page import="org.apache.poi.util.SystemOutLogger"%>
<%@page import="com.dimata.harisma.entity.log.ChangeValue"%>
<%@ include file = "../../main/javainit.jsp" %>
<% int  appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_EMPLOYEE, AppObjInfo.G2_CANDIDATE, AppObjInfo.OBJ_CANDIDATE_SEARCH); %>
<%@ include file = "../../main/checkuser.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    int iCommand = FRMQueryString.requestCommand(request);
    long oidCandidate = FRMQueryString.requestLong(request, "candidate_main_id");
    long positionId = FRMQueryString.requestLong(request, "position_id");
    String[] checkEmp = FRMQueryString.requestStringValues(request, "check_emp");
    ChangeValue changeValue = new ChangeValue();
    String whereClause = "";
    String whereTraining = "";
    String whereEducation = "";
    String whereCompetency = "";
    String whereExperience = "";
   
    Vector candidateList = SessCandidate.queryCandidate(oidCandidate, positionId); 
    
    /* Experience List */
    whereClause = PstCandidatePositionExperience.fieldNames[PstCandidatePositionExperience.FLD_CANDIDATE_MAIN_ID]+"="+oidCandidate;
    Vector listExperiences = PstCandidatePositionExperience.list(0, 0, whereClause, "");
    if (listExperiences != null && listExperiences.size()>0){
        for (int i=0; i<listExperiences.size(); i++){
            CandidatePositionExperience experience = (CandidatePositionExperience)listExperiences.get(i);
            whereExperience = whereExperience + experience.getExperienceId() + ",";
        }
        whereExperience = whereExperience.substring(0, whereExperience.length()-1);
    }
    
    /* Competency List */
    whereClause = PstCandidatePositionCompetency.fieldNames[PstCandidatePositionCompetency.FLD_CANDIDATE_MAIN_ID]+"="+oidCandidate;
    Vector listCompetency = PstCandidatePositionCompetency.list(0, 0, whereClause, "");
    if (listCompetency != null && listCompetency.size()>0){
        for (int i=0; i<listCompetency.size(); i++){
            CandidatePositionCompetency competency = (CandidatePositionCompetency)listCompetency.get(i);
            whereCompetency = whereCompetency + competency.getCompetencyId() + ",";
        }
        whereCompetency = whereCompetency.substring(0, whereCompetency.length()-1);
    }

    /* Training List */
    whereClause = PstCandidatePositionTraining.fieldNames[PstCandidatePositionTraining.FLD_CANDIDATE_MAIN_ID]+"="+oidCandidate;
    Vector listTraining = PstCandidatePositionTraining.list(0, 0, whereClause, "");
    if (listTraining != null && listTraining.size()>0){
        for (int i=0; i<listTraining.size(); i++){
            CandidatePositionTraining train = (CandidatePositionTraining)listTraining.get(i);
            whereTraining = whereTraining + train.getTrainingId() +",";
        }
        whereTraining = whereTraining.substring(0, whereTraining.length()-1);
    }
    /* Education List */
    whereClause = PstCandidatePositionEducation.fieldNames[PstCandidatePositionEducation.FLD_CANDIDATE_MAIN_ID]+"="+oidCandidate;
    Vector listEducation = PstCandidatePositionEducation.list(0, 0, whereClause, "");
    if (listEducation != null && listEducation.size()>0){
        for (int i=0; i<listEducation.size(); i++){
            CandidatePositionEducation education = (CandidatePositionEducation)listEducation.get(i);
            whereEducation = whereEducation + education.getEducationId() +",";
        }
        whereEducation = whereEducation.substring(0, whereEducation.length()-1);
    }
    /* Key Performa Indicator */
/* Sumber Pencarian */
/*
 * code = 0 (candidate location)
 * code = 1 (sumber pencarian)
 */
    whereClause = PstCandidateLocation.fieldNames[PstCandidateLocation.FLD_CANDIDATE_MAIN_ID]+"="+oidCandidate;
    whereClause += " AND "+PstCandidateLocation.fieldNames[PstCandidateLocation.FLD_CODE]+"=1";
    Vector candidateLocList = PstCandidateLocation.list(0, 0, whereClause, "");
    String whereLocation = "";
    if (candidateLocList != null && candidateLocList.size()>0){
        for (int i=0; i<candidateLocList.size(); i++){
            CandidateLocation location = (CandidateLocation)candidateLocList.get(i);
            whereLocation = whereLocation + location.getDivisionId()+",";
        }
        whereLocation = whereLocation.substring(0, whereLocation.length()-1);
        whereClause = PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID]+" IN("+whereLocation+")";
    } else {
        whereClause = "";
    }
    Vector empTraining = new Vector();
    Vector employeeList = PstEmployee.list(0, 0, whereClause, PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_NUM]);
    String whereEmployee = "";
    /* mencari employee di databank */
    if (employeeList != null && employeeList.size() > 0) {
        for (int i = 0; i < employeeList.size(); i++) {
            Employee emp = (Employee) employeeList.get(i);
            whereEmployee = whereEmployee + emp.getOID() + ",";
        }
        whereEmployee = whereEmployee.substring(0, whereEmployee.length()-1);
        whereClause = PstTrainingHistory.fieldNames[PstTrainingHistory.FLD_EMPLOYEE_ID] +" IN ("+whereEmployee+")";
        whereClause += " AND "+PstTrainingHistory.fieldNames[PstTrainingHistory.FLD_TRAINING_ID]+" IN ("+whereTraining+")";
        empTraining = PstTrainingHistory.listDistinct(0, 0, whereClause, "");
    }
    Vector empFilterEdu = new Vector();
    whereEmployee = "";
    if (empTraining != null && empTraining.size()>0){
        for (int i=0; i<empTraining .size(); i++){
            Long empTrain = (Long)empTraining .get(i);
            whereEmployee = whereEmployee + empTrain + ",";
        }
        whereEmployee = whereEmployee.substring(0, whereEmployee.length()-1);
        whereClause = PstEmpEducation.fieldNames[PstEmpEducation.FLD_EMPLOYEE_ID]+" IN ("+whereEmployee+")";
        whereClause += " AND "+PstEmpEducation.fieldNames[PstEmpEducation.FLD_EDUCATION_ID]+" IN ("+whereEducation+")";
        empFilterEdu = PstEmpEducation.listDistinct(0, 0, whereClause, "");
    }
 /*
 * Filter competensi blm dibuat, karna blm ada data pada employee competency
 */
 /* code write here ... */  
    
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Proses Kandidat</title>
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
                document.frm.candidate_main_id.value=oid;
                document.frm.action="candidate_main.jsp";
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
        <div class="content-main">
            <form name="frm" method="post" action="">
                <input type="hidden" name="candidate_main_id" value="<%= oidCandidate %>" />
                <input type="hidden" name="employee_id" value="" />
                <input type="hidden" name="employee_oid" value="" />
                <input type="hidden" name="position_id" value="" />
                
                <input type="hidden" name="command" value="<%=iCommand%>">
                
                <h1 style="color: #575757">Hasil Pencarian Kandidat - <%= changeValue.getPositionName(positionId) %></h1>
            
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
            <div>&nbsp;</div>
            <!--<a href="javascript:cmdExportToExcel()" class="btn-small">Export ke Excel</a>-->
            <a href="javascript:cmdToTalentPool()" class="btn-small">Pindahkan ke talent pool</a>
            <div>&nbsp;</div>
            <table class="tblStyle">
                <tr>
                    <td class="title_tbl">&nbsp;</td>
                    <td class="title_tbl">No</td>
                    <td class="title_tbl">Nama Karyawan</td>
                    <td class="title_tbl">Satuan Kerja</td>
                    <td class="title_tbl">Unit</td>
                    <td class="title_tbl">Sub Unit</td>
                    <td class="title_tbl">Jabatan</td>
                    <td class="title_tbl">Grade</td>
                    <td class="title_tbl">Action</td>
                </tr>
                <%
                if (empFilterEdu  != null && empFilterEdu .size()>0){
                    whereClause = "";
                    int no = 0;
                    String strIn = "";
                    for (int i=0; i<empFilterEdu .size(); i++){
                        Long empFilter = (Long)empFilterEdu .get(i);
                        strIn = strIn + empFilter + ",";
                    }
                    strIn = strIn.substring(0, strIn.length()-1);
                    whereClause = PstEmpTalentPool.fieldNames[PstEmpTalentPool.FLD_EMPLOYEE_ID]+" IN("+strIn+")";
                    Vector empTalentList = PstEmpTalentPool.list(0, 0, whereClause, "");
                    for (int i=0; i<empFilterEdu .size(); i++){
                        Long empFilter = (Long)empFilterEdu .get(i);
                        boolean ketemu = false;
                        if (empTalentList != null && empTalentList.size()>0){
                            for (int j=0; j<empTalentList.size(); j++){
                                EmpTalentPool empBakat = (EmpTalentPool)empTalentList.get(j);
                                if (empFilter == empBakat.getEmployeeId()){
                                    ketemu = true;
                                    break;
                                }
                            }
                        }
                        if (ketemu == false){
                            no++;
                            Employee emp = new Employee();
                            try {
                                emp = PstEmployee.fetchExc(empFilter);
                            } catch (Exception e){
                                System.out.println(e.toString());
                            }
                %>
                <tr>
                    <td><input type="checkbox" name="check_emp" value="<%= empFilter %>" /></td>
                    <td><%= (no) %></td>
                    <td><a href="javascript:cmdOpenEmployee('<%=emp.getOID() %>');" ><%= "("+emp.getEmployeeNum()+") "+ emp.getFullName() %></a></td>
                    <td><%= changeValue.getDivisionName(emp.getDivisionId()) %></td>
                    <td><%= changeValue.getDepartmentName(emp.getDepartmentId()) %></td>
                    <td><%= changeValue.getSectionName(emp.getSectionId()) %></td>
                    <td><%= changeValue.getPositionName(emp.getPositionId()) %></td>
                    <td><%= changeValue.getGradeLevelName(emp.getGradeLevelId()) %></td>
                    <td><a href="javascript:cmdDetail('<%= empFilter %>','<%= positionId %>')">Score Detail</a></td>
                </tr>
                <% 
                        }
                    } 
                }
                %>
            </table>
            <div>&nbsp;</div>
            <a href="javascript:cmdBack('<%= oidCandidate %>')" class="btn-small">Kembali ke pencarian</a>
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

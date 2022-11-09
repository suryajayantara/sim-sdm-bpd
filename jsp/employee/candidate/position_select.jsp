<%-- 
    Document   : position_select
    Created on : Sep 29, 2016, 9:30:57 AM
    Author     : Dimata 007
--%>
<%@page import="com.dimata.util.Command"%>
<%@ include file = "../../main/javainit.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    int iCommand = FRMQueryString.requestCommand(request);
    long oidCandidate = FRMQueryString.requestLong(request, "candidate_main_id");
    long oidPosition = FRMQueryString.requestLong(request, "position_id");
    String positionName = FRMQueryString.requestString(request, "position_name");
    String whereClause = "";
    if (iCommand == Command.SEARCH){
        if (positionName.length()>0){
            whereClause = PstPosition.fieldNames[PstPosition.FLD_POSITION]+" LIKE '%"+positionName+"%'";
        }
    }
    /* Save Data */
    if (iCommand == Command.SAVE){
        CandidatePosition candidatePos = new CandidatePosition();
        if (oidCandidate != 0){
            Date dueDate = new Date();
            candidatePos.setCandidateLocId(0);
            candidatePos.setCandidateMainId(oidCandidate);
            candidatePos.setCandidateType(0);
            candidatePos.setDueDate(dueDate);
            candidatePos.setNumberOfCandidate(0);
            candidatePos.setObjectives("-");
            candidatePos.setPositionId(oidPosition);
            try {
                PstCandidatePosition.insertExc(candidatePos);
            } catch(Exception e){
                System.out.println(e.toString());
            }
            
            /* Save Candidate Position Grade */
            whereClause = PstPositionGradeRequired.fieldNames[PstPositionCompetencyRequired.FLD_POSITION_ID]+"="+oidPosition; 
            Vector listGradeReq = PstPositionGradeRequired.listInnerJoin(whereClause);
            if (listGradeReq != null && listGradeReq.size()>0){
                for (int i=0; i<listGradeReq.size(); i++){
                    PositionGradeRequired dataReq = (PositionGradeRequired) listGradeReq.get(i);
                    CandidateGradeRequired data = new CandidateGradeRequired();
                    data.setCandidateMainId(oidCandidate);
                    data.setPositionId(oidPosition);
                    data.setGradeMinimum(new GradeLevel(dataReq.getGradeMinimum().getOID(),"",0));
                    data.setGradeMaximum(new GradeLevel(dataReq.getGradeMaximum().getOID(),"",0));
                    try {
                        PstCandidateGradeRequired.insertExc(data);
                    } catch(Exception e){
                        System.out.println("Output: "+e.toString());
                    }
                }
            }
            
            /* Save Candidate Position Competency */
            whereClause = PstPositionCompetencyRequired.fieldNames[PstPositionCompetencyRequired.FLD_POSITION_ID]+"="+oidPosition; 
            Vector listCompetencyReq = PstPositionCompetencyRequired.list(0, 0, whereClause, "");
            if (listCompetencyReq != null && listCompetencyReq.size()>0){
                for (int i=0; i<listCompetencyReq.size(); i++){
                    PositionCompetencyRequired dataReq = (PositionCompetencyRequired)listCompetencyReq.get(i);
                    CandidatePositionCompetency data = new CandidatePositionCompetency();
                    data.setCandidateMainId(oidCandidate);
                    data.setCompetencyId(dataReq.getCompetencyId());
                    data.setPositionId(oidPosition);
                    data.setScoreMin(Math.round(dataReq.getScoreReqMin()));
                    data.setScoreMax(Math.round(dataReq.getScoreReqRecommended()));
                    try {
                        PstCandidatePositionCompetency.insertExc(data);
                    } catch(Exception e){
                        System.out.println("Output: "+e.toString());
                    }
                }
            }
            /* Save Candidate Position Training */
            whereClause = PstPositionTrainingRequired.fieldNames[PstPositionTrainingRequired.FLD_POSITION_ID]+"="+oidPosition;
            Vector listTrainingReq = PstPositionTrainingRequired.list(0, 0, whereClause, "");
            if (listTrainingReq != null && listTrainingReq.size()>0){
                for (int i=0; i<listTrainingReq.size(); i++){
                    PositionTrainingRequired trainReq = (PositionTrainingRequired)listTrainingReq.get(i);
                    CandidatePositionTraining data = new CandidatePositionTraining();
                    data.setCandidateMainId(oidCandidate);
                    data.setTrainingId(trainReq.getTrainingId());
                    data.setPositionId(oidPosition);
                    data.setScoreMin(trainReq.getPointMin());
                    data.setScoreMax(trainReq.getPointRecommended());
                    try {
                        PstCandidatePositionTraining.insertExc(data);
                    } catch(Exception e){
                        System.out.println("Output: "+e.toString());
                    }
                }
            }
            /* Save Candidate Position Education */
            whereClause = PstPositionEducationRequired.fieldNames[PstPositionEducationRequired.FLD_POSITION_ID]+"="+oidPosition;
            Vector listEduReq = PstPositionEducationRequired.list(0, 0, whereClause, "");
            if (listEduReq != null && listEduReq.size()>0){
                for (int i=0; i<listEduReq.size(); i++){
                    PositionEducationRequired dataReq = (PositionEducationRequired)listEduReq.get(i);
                    CandidatePositionEducation data = new CandidatePositionEducation();
                    data.setCandidateMainId(oidCandidate);
                    data.setEducationId(dataReq.getEducationId());
                    data.setPositionId(oidPosition);
                    data.setScoreMin(dataReq.getPointMin());
                    data.setScoreMax(dataReq.getPointRecommended());
                    try {
                        PstCandidatePositionEducation.insertExc(data);
                    } catch(Exception e){
                        System.out.println("Output: "+e.toString());
                    }
                }
            }
            
            
              /* Save Candidate Position Expirience  , add by Kartika 2019-01-13*/
            whereClause = PstPositionExperienceRequired.fieldNames[PstPositionExperienceRequired.FLD_POSITION_ID]+"="+oidPosition;
            Vector listExpirienceReq = PstPositionExperienceRequired.list(0, 0, whereClause, "");
            if (listExpirienceReq != null && listExpirienceReq.size()>0){
                for (int i=0; i<listExpirienceReq.size(); i++){
                    PositionExperienceRequired expReq = (PositionExperienceRequired)listExpirienceReq.get(i);
                    CandidatePositionExperience data = new CandidatePositionExperience();
                    data.setCandidateMainId(oidCandidate);
                    data.setExperienceId(expReq.getExperienceId());
                    data.setPositionId(oidPosition);
                    data.setDurationMin(expReq.getDurationMin());
                    data.setDurationRecommended(expReq.getDurationRecommended());
                    data.setNote(expReq.getNote());
                    try {
                        PstCandidatePositionExperience.insertExc(data);
                    } catch(Exception e){
                        System.out.println("Output: "+e.toString());
                    }
                }
            }
            
            String site = new String("candidate_process_simple.jsp?candidate_main_id="+oidCandidate);
            response.setStatus(response.SC_MOVED_TEMPORARILY);
            response.setHeader("Location", site);
        }
    }
    
    
    Vector positionList = PstPosition.list(0, 0, whereClause, PstPosition.fieldNames[PstPosition.FLD_POSITION]);
    
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Pilih Jabatan</title>
        <style type="text/css">
            body {
                margin: 0;
                padding: 0;
                font-family: sans-serif;
                background-color: #EEE;
            }
            .caption {
                font-size: 12px;
                color: #474747;
                font-weight: bold;
                padding: 2px 0px 3px 0px;
            }
            .divinput {
                margin-bottom: 5px;
                padding-bottom: 5px;
            }
            .content {
                padding: 21px;
            }
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
            select {
                border: 1px solid #DDD;
                padding: 5px 7px;
            }
            .tblStyle {border-collapse: collapse; font-size: 12px; }
            .tblStyle td {padding: 2px; font-size: 12px; }
            #item {
                font-size: 12px;
                background-color: #FFF;
                border: 1px solid #DDD;
                color:#575757;
                padding: 5px 7px;
                margin-bottom: 3px;
                border-radius: 3px;
                cursor: pointer;
            }
            #close {
                background-color: #EB9898;
                color: #B83916;
                font-weight: bold;
                padding: 5px 7px;
                border-radius: 3px;
            }
            input {
                border: 1px solid #DDD;
                padding: 6px 7px;
                border-radius: 3px;
            }
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
        </style>
        <script type="text/javascript">
            function cmdCari(){
                document.frm.command.value="<%= Command.SEARCH %>";
                document.frm.action="position_select.jsp";
                document.frm.submit();
            }
            function cmdGetData(oidPosition){
                document.frm.command.value="<%= Command.SAVE %>";
                document.frm.position_id.value=oidPosition;
                document.frm.action="position_select.jsp";
                document.frm.submit();
            }
        </script>
    </head>
    <body>
        <div class="content">
            <form name="frm" method="post" action="">
                <input type="hidden" name="command" value="" />
                <input type="hidden" name="candidate_main_id" value="<%= oidCandidate %>" />
                <input type="hidden" name="position_id" value="" />
                <h2 style="color:#797979;">Pilih Jabatan</h2>
                <input type="text" name="position_name" value="" size="50" placeholder="ketik nama jabatan..." />&nbsp;
                <a href="javascript:cmdCari()" class="btn">Cari</a>
                <div>&nbsp;</div>
                <%
                if (positionList != null  && positionList.size()>0){
                    for(int i=0; i<positionList.size(); i++){
                        Position position = (Position)positionList.get(i);
                        %>
                        <div id="item" onclick="javascript:cmdGetData('<%= position.getOID() %>')"><%= position.getPosition() %></div>
                        <%
                    }
                }
                %>

            </form>
        </div>
    </body>
</html>

<%-- 
    Document   : training_competency_edit
    Created on : Aug 12, 2021, 11:00:39 AM
    Author     : keys
--%>

<%@page import="com.dimata.util.Command"%>
<%@page import="com.dimata.harisma.entity.employee.FrmTrainingCompetencyMapping"%>
<%@page import="com.dimata.harisma.entity.employee.PstTrainingCompetencyMapping"%>
<%@page import="com.dimata.qdep.form.FRMMessage"%>
<%@page import="com.dimata.qdep.form.FRMQueryString"%>
<%@page import="com.dimata.harisma.entity.masterdata.CompetencyLevel"%>
<%@page import="com.dimata.harisma.entity.masterdata.Competency"%>


<%@page import="java.util.Vector"%>
<%@ include file = "../../main/javainit.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%  
    int iCommand = FRMQueryString.requestCommand(request);
    int start = FRMQueryString.requestInt(request, "start");
    int prevCommand = FRMQueryString.requestInt(request, "prev_command");
    long oidPosCom = FRMQueryString.requestLong(request, "hidden_training_comp_map_id");
    String comm = request.getParameter("comm");
     double dscore = 0.0;
    String score = request.getParameter(FrmTrainingCompetencyMapping.fieldNames[FrmTrainingCompetencyMapping.FRM_FIELD_SCORE]);
    if(score != null){
       dscore = Double.parseDouble(score);
    }
    long oid = FRMQueryString.requestLong(request, "oid");
    long oidTrainingActivityActual = FRMQueryString.requestLong(request, "oidTrainingActivityActual");
    long oidCompetency = FRMQueryString.requestLong(request, "competencyId");
    int msg = 0;
    
    /*variable declaration*/
    int recordToGet = 10;
    String msgString = "";
    int iErrCode = FRMMessage.NONE;
    String whereClause = "";
    String orderClause = "";

    
    CtrlTrainingCompetencyMapping ctrlTrainingCompetencyMapping = new CtrlTrainingCompetencyMapping(request);

    
    /* end switch*/
    FrmTrainingCompetencyMapping frmTraningCompetencyMap = ctrlTrainingCompetencyMapping.getForm();
    TrainingCompetencyMapping entTrainingCompetencyMapping = new TrainingCompetencyMapping();
    if(oid != 0){
     entTrainingCompetencyMapping = PstTrainingCompetencyMapping.fetchExc(oid);
    }
   
  
    
    if(iCommand == Command.SAVE && oid ==0){
     if(oidCompetency!=0 && oidTrainingActivityActual !=0){
        try{
            entTrainingCompetencyMapping.setCompetencyId(oidCompetency);
            entTrainingCompetencyMapping.setTrainingActivityActualId(oidTrainingActivityActual);
            entTrainingCompetencyMapping.setScore(dscore);
            oid = PstTrainingCompetencyMapping.insertExc(entTrainingCompetencyMapping);
            
            //delete dulu supaya ga ada yang double
            Vector listOldCompetencyMapDetail = PstTrainingCompetencyMappingDetail.listByCompetencyMappingId(oid);
            for(int xx = 0; xx < listOldCompetencyMapDetail.size();xx++){
                TrainingCompetencyMappingDetail delTrainingCompetencyMappingDetail = (TrainingCompetencyMappingDetail) listOldCompetencyMapDetail.get(xx);
                PstTrainingCompetencyMappingDetail.deleteExc(delTrainingCompetencyMappingDetail.getOID());
            }
                    
            //otomatis insert ke mapping detail kompotensin per Employee
           TrainingCompetencyMappingDetail objTrainingCompetencyMappingDetail = new TrainingCompetencyMappingDetail();
            TrainingActivityActual trainingActivityActual = PstTrainingActivityActual.fetchExc(oidTrainingActivityActual);
            Vector listEmpTrainingAttPlan =  PstTrainingAttendancePlan.getAttendanceByPlan(trainingActivityActual.getTrainingActivityPlanId());
            for(int xu = 0; xu < listEmpTrainingAttPlan.size();xu++){
                TrainingAttendancePlan objTrainingAttendancePlan = (TrainingAttendancePlan) listEmpTrainingAttPlan.get(xu);
                objTrainingCompetencyMappingDetail.setEmployeeId(objTrainingAttendancePlan.getEmployeeId());
                objTrainingCompetencyMappingDetail.setTrainingAttId(objTrainingAttendancePlan.getOID());
                objTrainingCompetencyMappingDetail.setScore(entTrainingCompetencyMapping.getScore());
                objTrainingCompetencyMappingDetail.setCompetencyId(entTrainingCompetencyMapping.getCompetencyId());
                objTrainingCompetencyMappingDetail.setTrainingActivityActualId(entTrainingCompetencyMapping.getTrainingActivityActualId());
                objTrainingCompetencyMappingDetail.setTrainingCompetencyMappingId(entTrainingCompetencyMapping.getOID());
                PstTrainingCompetencyMappingDetail.insertExc(objTrainingCompetencyMappingDetail);
                
            }
        
        TrainingCompetencyMappingDetail.generateEmployeeCompetency(oidTrainingActivityActual);
            msg=1;
        }catch(Exception exc){
            
        }
     }
    }else if(iCommand == Command.SAVE && oid!=0){
        entTrainingCompetencyMapping.setCompetencyId(oidCompetency);
        entTrainingCompetencyMapping.setTrainingActivityActualId(oidTrainingActivityActual);
        entTrainingCompetencyMapping.setScore(dscore);
        oid = PstTrainingCompetencyMapping.updateExc(entTrainingCompetencyMapping);
        msg=1;
        
        // otomatis update training compotency mapping detail 
        Vector listTrainingCompetencyMappingDetail = PstTrainingCompetencyMappingDetail.listByCompetencyMappingId(entTrainingCompetencyMapping.getOID());
        for(int xx = 0 ; xx < listTrainingCompetencyMappingDetail.size();xx++){
            TrainingCompetencyMappingDetail objTrainingCompetencyMappingDetail = (TrainingCompetencyMappingDetail) listTrainingCompetencyMappingDetail.get(xx);
            objTrainingCompetencyMappingDetail.setScore(dscore);
            PstTrainingCompetencyMappingDetail.updateExc(objTrainingCompetencyMappingDetail);
        }
        TrainingCompetencyMappingDetail.generateEmployeeCompetency(oidTrainingActivityActual);
    }else if(oid == 0){
        entTrainingCompetencyMapping.setCompetencyId(oidCompetency);
        entTrainingCompetencyMapping.setTrainingActivityActualId(oidTrainingActivityActual);
        entTrainingCompetencyMapping.setScore(dscore);
    }
    
   
    /*switch statement */
    //iErrCode = ctrlTrainingCompetencyMapping.action(iCommand, oid);
    
%>
<%
 
    
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Competency Edit</title>

        <script type="text/javascript">
            function getCmd(){
                document.<%=FrmTrainingCompetencyMapping.FRM_NAME_TRAININGCOMPETENCYMAPPING%>.action = "../../employee/training/training_competency_edit.jsp";
                document.<%=FrmTrainingCompetencyMapping.FRM_NAME_TRAININGCOMPETENCYMAPPING%>.submit();
            }
            function cmdEdit(oid) {
                document.<%=FrmTrainingCompetencyMapping.FRM_NAME_TRAININGCOMPETENCYMAPPING%>.command.value = "<%=Command.EDIT%>";
                document.<%=FrmTrainingCompetencyMapping.FRM_NAME_TRAININGCOMPETENCYMAPPING%>.hidden_comp_id.value = oid;
                getCmd();
            }

            function cmdSave() {
                document.<%=FrmTrainingCompetencyMapping.FRM_NAME_TRAININGCOMPETENCYMAPPING%>.command.value = "<%=Command.SAVE%>";
                getCmd();
            }
        </script>
        <style type="text/css">
            body {
                color:#575757;
                margin: 0;
                padding: 0;
            }
            #btn {
              background: #3498db;
              border: 1px solid #0066CC;
              border-radius: 3px;
              font-family: Arial;
              color: #ffffff;
              font-size: 12px;
              padding: 3px 9px 3px 9px;
            }

            #btn:hover {
              background: #3cb0fd;
              border: 1px solid #3498db;
            }
            td {padding-right: 14px;}
            #msg {border: 1px solid #ADCF53; background-color: #E9FFAD; color: #739613; padding: 3px 5px;}
            .header {
                background-color: #EEE;
                padding: 15px 21px;
            }
            h2 {
                color: #0096bb;
            }
            input {
                border: 1px solid #DDD;
            }
            .content {
                padding: 15px 21px;
            }
        </style>
<link rel="stylesheet" href="<%=approot%>/javascripts/datepicker/themes/jquery.ui.all.css">
<script src="<%=approot%>/javascripts/jquery.js"></script>
<script src="<%=approot%>/javascripts/datepicker/jquery.ui.core.js"></script>
<script src="<%=approot%>/javascripts/datepicker/jquery.ui.widget.js"></script>
<script src="<%=approot%>/javascripts/datepicker/jquery.ui.datepicker.js"></script>
<script>
$(function() {
    $( "#datepicker1" ).datepicker({ dateFormat: "yy-mm-dd" });
    $( "#datepicker2" ).datepicker({ dateFormat: "yy-mm-dd" });
});
</script>
    </head>
    <body>
        <div class="header">
            <h2>Competency Edit</h2>
        </div>
        <div class="content">
        <form name="<%=FrmTrainingCompetencyMapping.FRM_NAME_TRAININGCOMPETENCYMAPPING%>" action="" method="post">
            <input type="hidden" name="command" value="<%=iCommand%>">
            <input type="hidden" name="oid" value="<%=oid%>">
            <input type="hidden" name="competencyId" value="<%=entTrainingCompetencyMapping.getCompetencyId()%>">
            <input type="hidden" name="oidTrainingActivityActual" value="<%=entTrainingCompetencyMapping.getTrainingActivityActualId()%>">
            
            
        <%
     
                String CompetencyName = PstCompetency.getCompetencyName(entTrainingCompetencyMapping.getCompetencyId());
            
        %>
        
        <table>

            <tr>
                <td valign="top">Competency<input type="hidden" name="<%=frmTraningCompetencyMap.fieldNames[frmTraningCompetencyMap.FRM_FIELD_COMPETENCY_ID]%>" value="<%=entTrainingCompetencyMapping.getCompetencyId()%>" /></td>
                <td valign="top"><%=CompetencyName%></td>
            </tr>
          
            
            
            
            <tr>
                <td valign="top">Score </td>
                <td valign="top">
                   <!-- <input type="text" name="<%=frmTraningCompetencyMap.fieldNames[frmTraningCompetencyMap.FRM_FIELD_SCORE]%>" value="<%=entTrainingCompetencyMapping.getScore()%>" /> !-->
                    <select name="<%=frmTraningCompetencyMap.fieldNames[frmTraningCompetencyMap.FRM_FIELD_SCORE]%>">
                        <%
                           
                           Vector ListCompetency = PstCompetencyLevel.list(0, 0, ""+PstCompetencyLevel.fieldNames[PstCompetencyLevel.FLD_COMPETENCY_ID]+" = "+entTrainingCompetencyMapping.getCompetencyId() , ""+PstCompetencyLevel.fieldNames[PstCompetencyLevel.FLD_SCORE_VALUE]+" ASC");
                           for(int xy = 0; xy < ListCompetency.size(); xy++){
                               String selected = "";
                               CompetencyLevel objCompetencyLevel = (CompetencyLevel) ListCompetency.get(xy);
                               if(entTrainingCompetencyMapping.getScore() == objCompetencyLevel.getScoreValue()){
                                 selected = "selected" ; 
                               }
                        %>
                        <option value="<%=objCompetencyLevel.getScoreValue()%>"  <%=selected%>><%=objCompetencyLevel.getLevelName()%></option>
                        <%
                            }

                            if(ListCompetency.size() == 0){
                        %>
                         <option value="0"  >Level Kompetensi ini belum ada</option>
                        <% } %>
                    </select>
                </td>

            </tr>
            
           
            
            <tr>
                <td valign="top" colspan="2"><button id="btn" onclick="javascript:cmdSave()">Save</button></td>

            </tr>
        </table>
      
        </form>
        <%
            if (msg > 0){
        %>
                <div id="msg">Data have been save</div>
<!--                <script>
                    window.close();
                    window.opener.location.reload();
                </script>-->
        <%
            }
        %>
        </div>
    </body>
</html>

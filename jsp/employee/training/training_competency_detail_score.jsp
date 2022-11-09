<%-- 
    Document   : training_competency_edit
    Created on : Aug 12, 2021, 11:00:39 AM
    Author     : keys
--%>

<%@page import="com.dimata.util.Command"%>
<%@page import="com.dimata.harisma.entity.employee.FrmTrainingCompetencyMappingDetail"%>
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
    String score = request.getParameter(FrmTrainingCompetencyMappingDetail.fieldNames[FrmTrainingCompetencyMappingDetail.FRM_FIELD_SCORE]);
    if(score != null){
       dscore = Double.parseDouble(score);
    }
    long oid = FRMQueryString.requestLong(request, "oid");
    long oid_edit_competency_map_detail = FRMQueryString.requestLong(request, "oid_edit_competency_map_detail");
    long oidTrainingActivityActual = FRMQueryString.requestLong(request, "oidTrainingActivityActual");
    long oidTrainingActivityPlan = FRMQueryString.requestLong(request, "oidTrainingActivityPlan");
    long employeeId = FRMQueryString.requestLong(request, "employeeId");
//    long oidTrainingAttId = FRMQueryString.requestLong(request, "oidTrainingAttId");
//    long oidTrainingHistory = FRMQueryString.requestLong(request, "oidTrainingHistory");
    int msg = 0;
    
    /*variable declaration*/
    int recordToGet = 10;
    String msgString = "";
    int iErrCode = FRMMessage.NONE;
    String whereClause = "";
    String orderClause = "";

    
    
     

    /*switch statement */
    //iErrCode = ctrlTrainingCompetencyMapping.action(iCommand, oid);
    
%>
<%   
     if(iCommand == Command.SAVE){
        if(oid_edit_competency_map_detail != 0){
             TrainingCompetencyMappingDetail entTrainingCompetencyMappingDetail = PstTrainingCompetencyMappingDetail.fetchExc(oid_edit_competency_map_detail); 
             entTrainingCompetencyMappingDetail.setScore(FRMQueryString.requestDouble(request,  FrmTrainingCompetencyMappingDetail.fieldNames[FrmTrainingCompetencyMappingDetail.FRM_FIELD_SCORE]));
             long oidUpdate = PstTrainingCompetencyMappingDetail.updateExc(entTrainingCompetencyMappingDetail);
             entTrainingCompetencyMappingDetail.generateEmployeeCompetency(oidTrainingActivityActual);
             if(oidUpdate != 0){
                 msg=1;
             }
        }
    }
    
   
         
    Vector  listComMapDetail = PstTrainingCompetencyMappingDetail.listByTrainingActivityActualIdAndEmployeeId(oidTrainingActivityActual,employeeId);

  
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Competency Edit</title>

        <script type="text/javascript">
            function getCmd(){
                document.<%=FrmTrainingCompetencyMappingDetail.FRM_NAME_TRAINING_COMPETENCY_MAPPING_DETAIL%>.action = "../../employee/training/training_competency_detail_score.jsp";
                document.<%=FrmTrainingCompetencyMappingDetail.FRM_NAME_TRAINING_COMPETENCY_MAPPING_DETAIL%>.submit();
            }
            function cmdEdit(oid) {
                document.<%=FrmTrainingCompetencyMappingDetail.FRM_NAME_TRAINING_COMPETENCY_MAPPING_DETAIL%>.command.value = "<%=Command.EDIT%>";
                document.<%=FrmTrainingCompetencyMappingDetail.FRM_NAME_TRAINING_COMPETENCY_MAPPING_DETAIL%>.hidden_comp_id.value = oid;
                getCmd();
            }

            function cmdSave() {
                document.<%=FrmTrainingCompetencyMappingDetail.FRM_NAME_TRAINING_COMPETENCY_MAPPING_DETAIL%>.command.value = "<%=Command.SAVE%>";
                getCmd();
            }
            
             function cmdEditCompetency(oid){
                document.<%=FrmTrainingCompetencyMappingDetail.FRM_NAME_TRAINING_COMPETENCY_MAPPING_DETAIL%>.command.value = "<%=Command.EDIT%>";
                document.<%=FrmTrainingCompetencyMappingDetail.FRM_NAME_TRAINING_COMPETENCY_MAPPING_DETAIL%>.oid_edit_competency_map_detail.value = oid;
                getCmd();
            }
        
         function cmdRefresh(){
            document.frm_trainingplan.action="training_competency_detail_score.jsp";
            document.frm_trainingplan.submit();
        }
        
        </script>
        <style type="text/css">
    .tblStyle {border-collapse: collapse;font-size: 11px;}
    .tblStyle td {padding: 3px 5px; border: 1px solid #CCC;}
    .title_tbl {font-weight: bold;background-color: #DDD; color: #575757;}
    .title_page {color:#0db2e1; font-weight: bold; font-size: 14px; background-color: #EEE; border-left: 1px solid #0099FF; padding: 12px 18px;}
    
    .btn-small {
        font-family: sans-serif;
        text-decoration: none;
        padding: 5px 7px; 
        background-color: #676767; color: #F5F5F5; 
        font-size: 11px; cursor: pointer;
        border-radius: 3px;
    }
    .btn-small:hover { background-color: #474747; color: #FFF;}
    
    .collapsible {
            background-color: #a3d73a;
            color: white;
            cursor: pointer;
            padding: 5px;
            border: none;
            text-align: left;
            outline: none;
            font-size: 12px;
      }
</style>
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
            
             .content-title {
                padding: 21px;
                border-bottom: 1px solid #E5E5E5;
                margin-bottom: 5px;
            }
            #title-large {
                color: #575757;
                font-size: 16px;
                font-weight: bold;
            }
             #title-small {
                color:#797979;
                font-size: 11px;
            }
        </style>
        
        <%%>
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
            <h2>Nilai Kompetensi</h2>
        </div>
        <div class="content">
        <form name="<%=FrmTrainingCompetencyMappingDetail.FRM_NAME_TRAINING_COMPETENCY_MAPPING_DETAIL%>" action="" method="post">
            <input type="hidden" name="command" value="<%=iCommand%>">
            <input type="hidden" name="oid" value="<%=oid%>">
            <input type="hidden" name="oid_edit_competency_map_detail" value="<%=oid_edit_competency_map_detail%>">
            <input type="hidden" name="employeeId" value="<%=employeeId%>">
            <input type="hidden" name="oidTrainingActivityActual" value="<%=oidTrainingActivityActual%>">
            <input type="hidden" name="oidTrainingActivityPlan" value="<%=oidTrainingActivityPlan%>">
              
        <table>

            <tr>
                <td>
                    <div class="header" style="padding: 0px 15px;">
                        <h3>List Kompetensi</h3>
                    </div>
                </td>
            </tr>
            <tr>
                <td>
                            <table cellspacing="0" cellpadding="0" class="tblStyle" style="background-color: #FFF">
                                                 <tr>
                                                    <td class="title_tbl">Competency Name</td>
                                                    <td class="title_tbl">Score</td>
                                                    <td class="title_tbl">&nbsp;</td>
                                                </tr>
                               <%
                                  if(listComMapDetail.size()>0){
                                       for(int xy = 0 ; xy < listComMapDetail.size();xy++){
                                           
                                       TrainingCompetencyMappingDetail entTrainingCompetencyMappingDetail = (TrainingCompetencyMappingDetail) listComMapDetail.get(xy);
                                       String ComptencyName = PstCompetency.getCompetencyName(entTrainingCompetencyMappingDetail.getCompetencyId());
                               %>
                                                
                                                <tr>
                                                    <td><a href="javascript:cmdEditCompetency('<%=entTrainingCompetencyMappingDetail.getOID()%>')"><%=ComptencyName%></a></td>
                                                    <td><%=entTrainingCompetencyMappingDetail.getScore()%></td>
                                                    <td>&nbsp;
<!--                                                        <a class=\"btn-small-1\" href=\"javascript:cmdAskDetail('"+trainHistory.getOID()+"')\">&times;</a>-->
                                                    </td>
                                                </tr>
                                <%} }else{%>
                                                <tr>
                                                    <td colspan="3">Tidak Add Mapping Kompetensi</td>
                                                </tr>
                                <%}%>
                          </table>
                </td>
            </tr>
          
          
        </table>
                    <%if(iCommand == Command.EDIT){%> 
<!--                     <div class="content-title">
                        <div id="title-large"></div>
                    </div>-->
                     
                   
                     <%
                     TrainingCompetencyMappingDetail entTrainingCompetencyMappingDetail = PstTrainingCompetencyMappingDetail.fetchExc(oid_edit_competency_map_detail);                     
                      String CompetencyName = PstCompetency.getCompetencyName(entTrainingCompetencyMappingDetail.getCompetencyId());
                     %>
                      <table>
                          <tr>
                              <td colspan="2">
                                   <br>
                                   <div class="header" style="padding: 0px 15px;">
                                        <h3>Edit Score</h3>
                                    </div>
                              </td>
                          </tr>
                            <tr>
                                <td valign="top">Competency<input type="hidden" name="<%=FrmTrainingCompetencyMappingDetail.fieldNames[FrmTrainingCompetencyMappingDetail.FRM_FIELD_COMPETENCY_ID]%>" value="<%=entTrainingCompetencyMappingDetail.getCompetencyId()%>" /></td>
                                <td valign="top"><%=CompetencyName%></td>
                            </tr>
                            <tr>
                                <td valign="top">Score </td>
                                <td valign="top">
                                   <!-- <input type="text" name="<%=FrmTrainingCompetencyMappingDetail.fieldNames[FrmTrainingCompetencyMappingDetail.FRM_FIELD_SCORE]%>" value="<%=entTrainingCompetencyMappingDetail.getScore()%>" /> !-->
                                    <select name="<%=FrmTrainingCompetencyMappingDetail.fieldNames[FrmTrainingCompetencyMappingDetail.FRM_FIELD_SCORE]%>">
                                        <%

                                           Vector ListCompetency = PstCompetencyLevel.list(0, 0, ""+PstCompetencyLevel.fieldNames[PstCompetencyLevel.FLD_COMPETENCY_ID]+" = "+entTrainingCompetencyMappingDetail.getCompetencyId() , ""+PstCompetencyLevel.fieldNames[PstCompetencyLevel.FLD_SCORE_VALUE]+" ASC");
                                           for(int xy = 0; xy < ListCompetency.size(); xy++){
                                               String selected = "";
                                               CompetencyLevel objCompetencyLevel = (CompetencyLevel) ListCompetency.get(xy);
                                               if(entTrainingCompetencyMappingDetail.getScore() == objCompetencyLevel.getScoreValue()){
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
                 <%}%>
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

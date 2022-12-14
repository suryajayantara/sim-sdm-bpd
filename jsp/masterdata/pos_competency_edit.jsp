<%-- 
    Document   : pos_competency_edit
    Created on : Feb 5, 2015, 1:13:36 PM
    Author     : Dimata 007
--%>

<%@page import="com.dimata.util.Command"%>
<%@page import="com.dimata.harisma.form.masterdata.FrmPositionCompetencyRequired"%>
<%@page import="com.dimata.harisma.form.masterdata.CtrlPositionCompetencyRequired"%>
<%@page import="com.dimata.qdep.form.FRMMessage"%>
<%@page import="com.dimata.qdep.form.FRMQueryString"%>
<%@page import="com.dimata.harisma.entity.masterdata.CompetencyDetail"%>
<%@page import="com.dimata.harisma.entity.masterdata.CompetencyLevel"%>
<%@page import="com.dimata.harisma.entity.masterdata.Position"%>
<%@page import="com.dimata.harisma.entity.masterdata.Competency"%>
<%@page import="com.dimata.harisma.entity.masterdata.PositionCompetencyRequired"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstPositionCompetencyRequired"%>
<%@page import="java.util.Vector"%>
<%@ include file = "../main/javainit.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%  
    int iCommand = FRMQueryString.requestCommand(request);
    int start = FRMQueryString.requestInt(request, "start");
    int prevCommand = FRMQueryString.requestInt(request, "prev_command");
    long oidPosCom = FRMQueryString.requestLong(request, "hidden_pos_comp_id");
    String comm = request.getParameter("comm");
    String oid = request.getParameter("oid");
    int msg = 0;
    if (oidPosCom != 0 && oidPosCom > 0){
        oid = String.valueOf(oidPosCom);
        msg = 1;
    }
    /*variable declaration*/
    int recordToGet = 10;
    String msgString = "";
    int iErrCode = FRMMessage.NONE;
    String whereClause = "";
    String orderClause = "";

    
    CtrlPositionCompetencyRequired ctrPosCompetency = new CtrlPositionCompetencyRequired(request);
    
  FrmPositionCompetencyRequired frmPosCompetency = ctrPosCompetency.getForm();
    /*switch statement */
    iErrCode = ctrPosCompetency.action(iCommand, oidPosCom);
    /* end switch*/
  

%>
<%
    Vector listPosCom = new Vector();
    listPosCom = PstPositionCompetencyRequired.listInnerJoinVer1(oid);

%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Competency Edit</title>

        <script type="text/javascript">
            function getCmd(){
                document.<%=FrmPositionCompetencyRequired.FRM_NAME_POSITION_COMPETENCY_REQUIRED%>.action = "pos_competency_edit.jsp";
                document.<%=FrmPositionCompetencyRequired.FRM_NAME_POSITION_COMPETENCY_REQUIRED%>.submit();
            }
            function cmdEdit(oid) {
                document.<%=FrmPositionCompetencyRequired.FRM_NAME_POSITION_COMPETENCY_REQUIRED%>.command.value = "<%=Command.EDIT%>";
                document.<%=FrmPositionCompetencyRequired.FRM_NAME_POSITION_COMPETENCY_REQUIRED%>.hidden_comp_id.value = oid;
                getCmd();
            }

            function cmdSave() {
                document.<%=FrmPositionCompetencyRequired.FRM_NAME_POSITION_COMPETENCY_REQUIRED%>.command.value = "<%=Command.SAVE%>";
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
        <form name="<%=FrmPositionCompetencyRequired.FRM_NAME_POSITION_COMPETENCY_REQUIRED%>" action="" method="post">
            <input type="hidden" name="command" value="<%=iCommand%>">
            <input type="hidden" name="hidden_pos_comp_id" value="<%=oid%>">
        <%
        if (listPosCom != null && listPosCom.size() > 0){
            for(int i=0; i<listPosCom.size(); i++){
                Vector vect = (Vector)listPosCom.get(i);
                PositionCompetencyRequired posCom = (PositionCompetencyRequired)vect.get(0);
                Competency com = (Competency)vect.get(1);
                Position pos = (Position)vect.get(2);
            
        %>
        
        <table>
            <tr>
                <td valign="top">Position<input type="hidden" name="<%=frmPosCompetency.fieldNames[frmPosCompetency.FRM_FIELD_POSITION_ID]%>" value="<%=posCom.getPositionId()%>" /></td>
                <td valign="top"><%=pos.getPosition()%></td>

            </tr>
            <tr>
                <td valign="top">Competency<input type="hidden" name="<%=frmPosCompetency.fieldNames[frmPosCompetency.FRM_FIELD_COMPETENCY_ID]%>" value="<%=posCom.getCompetencyId()%>" /></td>
                <td valign="top"><%=com.getCompetencyName()%></td>
            </tr>
            <tr>
                <td valign="top">Level Satuan Kerja</td>
                <td valign="top">
                     <select name="<%=frmPosCompetency.fieldNames[frmPosCompetency.FRM_FIELD_LEVEL_DIVISION]%>">
                        <%
                        
                            for(int x=0; x < PstDivision.divisionLevel.length; x++){
                                if (x==posCom.getLevelDivision()){
                                    %>
                                    <option value="<%=x%>" selected="selected"><%=PstDivision.divisionLevelName[x]%></option>
                                    <%
                                } else {
                                    %>
                                    <option value="<%=x%>" ><%=PstDivision.divisionLevelName[x]%></option>
                                    <%
                                }

                            }
                        %>
                    </select>
                </td>
            </tr>
            <tr>
                <td valign="top">Level Unit</td>
                <td valign="top">
                     <select name="<%=frmPosCompetency.fieldNames[frmPosCompetency.FRM_FIELD_LEVEL_DEPARTMENT]%>">
                        <%
                        
                            for(int xx=0; xx < PstDepartment.departmentLevel.length; xx++){
                                if (xx==posCom.getLevelDepartment()){
                                    %>
                                    <option value="<%=xx%>" selected="selected"><%=PstDepartment.departmentLevelName[xx]%></option>
                                    <%
                                } else {
                                    %>
                                    <option value="<%=xx%>" ><%=PstDepartment.departmentLevelName[xx]%></option>
                                    <%
                                }

                            }
                        %>
                    </select>
                </td>
            </tr>
            <tr>
                <td valign="top">Level Sub Unit</td>
                <td valign="top">
                     <select name="<%=frmPosCompetency.fieldNames[frmPosCompetency.FRM_FIELD_LEVEL_SECTION]%>">
                        <%
                        
                            for(int xy=0; xy < PstSection.sectionLevel.length; xy++){
                                if (xy==posCom.getLevelSection()){
                                    %>
                                    <option value="<%=xy%>" selected="selected"><%=PstSection.sectionLevelName[xy]%></option>
                                    <%
                                } else {
                                    %>
                                    <option value="<%=xy%>" ><%=PstSection.sectionLevelName[xy]%></option>
                                    <%
                                }

                            }
                        %>
                    </select>
                </td>
            </tr>
            <tr>
                <td valign="top">Level</td>
                <td valign="top">
                     <select name="<%=frmPosCompetency.fieldNames[frmPosCompetency.FRM_FIELD_COMPETENCY_LEVEL_ID]%>">
                        <option value="0">-SELECT-</option>
                        <%
                        String orderLevel = PstLevel.fieldNames[PstLevel.FLD_LEVEL_RANK]+" DESC";
                        Vector listLevel = PstLevel.list(0, 0, "", orderLevel);
                        if (listLevel != null && listLevel.size()>0){
                            for(int l=0; l<listLevel.size(); l++){
                                Level level = (Level)listLevel.get(l);
                                if (level.getOID()==posCom.getCompetencyLevelId()){
                                    %>
                                    <option value="<%=level.getOID()%>" selected="selected"><%=level.getLevel()%></option>
                                    <%
                                } else {
                                    %>
                                    <option value="<%=level.getOID()%>"><%=level.getLevel()%></option>
                                    <%
                                }

                            }
                        }
                        %>
                    </select>
                </td>

            </tr>
            <tr>
                <td valign="top">Score Min</td>
                <td valign="top">
                   <!-- <input type="text" name="<%=frmPosCompetency.fieldNames[frmPosCompetency.FRM_FIELD_SCORE_REQ_MIN]%>" value="<%=posCom.getScoreReqMin()%>" /> !-->
                    <select name="<%=frmPosCompetency.fieldNames[frmPosCompetency.FRM_FIELD_SCORE_REQ_MIN]%>">
                        <%
                           
                           Vector ListCompetency = PstCompetencyLevel.list(0, 0, ""+PstCompetencyLevel.fieldNames[PstCompetencyLevel.FLD_COMPETENCY_ID]+" = "+posCom.getCompetencyId() , ""+PstCompetencyLevel.fieldNames[PstCompetencyLevel.FLD_SCORE_VALUE]+" ASC");
                           for(int xy = 0; xy < ListCompetency.size(); xy++){
                               String selected = "";
                               CompetencyLevel objCompetencyLevel = (CompetencyLevel) ListCompetency.get(xy);
                               if(posCom.getScoreReqMin() == objCompetencyLevel.getScoreValue()){
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
                <td valign="top">Score Recommended</td>
                <td valign="top">
                    <!-- <input type="text" name="<%=frmPosCompetency.fieldNames[frmPosCompetency.FRM_FIELD_SCORE_REQ_RECOMMENDED]%>" value="<%=posCom.getScoreReqRecommended()%>" /> !-->
                    <select name="<%=frmPosCompetency.fieldNames[frmPosCompetency.FRM_FIELD_SCORE_REQ_RECOMMENDED]%>">
                        <%
                           
                           for(int xy = 0; xy < ListCompetency.size(); xy++){
                               String selected = "";
                               CompetencyLevel objCompetencyLevel = (CompetencyLevel) ListCompetency.get(xy);
                               if(posCom.getScoreReqRecommended() == objCompetencyLevel.getScoreValue()){
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
            <!--
            <tr>
                <td valign="top">Re-Training or Re-Certificate</td>
                <td valign="top"><input type="text" name="<%=frmPosCompetency.fieldNames[frmPosCompetency.FRM_FIELD_RE_TRAIN_OR_SERTFC_REQ]%>" value="" /></td>
            </tr>
            <tr>
                <td valign="top">Valid Start</td>
                <td valign="top"><input type="text" name="<%=frmPosCompetency.fieldNames[frmPosCompetency.FRM_FIELD_VALID_START]%>" id="datepicker1" /></td>
            </tr>
            <tr>
                <td valign="top">Valid End</td>
                <td valign="top"><input type="text" name="<%=frmPosCompetency.fieldNames[frmPosCompetency.FRM_FIELD_VALID_END]%>" id="datepicker2" /></td>
            </tr>
            !-->
            <tr>
                <td valign="top">Note</td>
                <td valign="top"><textarea name="<%=frmPosCompetency.fieldNames[frmPosCompetency.FRM_FIELD_NOTE]%>"><%=posCom.getNote()%></textarea></td>
            </tr>
            <tr>
                <td valign="top"><!--Competency Level--><input type="hidden" name="<%=frmPosCompetency.fieldNames[frmPosCompetency.FRM_FIELD_COMPETENCY_LEVEL_ID]%>" value="<%=posCom.getCompetencyLevelId()%>" /></td>
                <td valign="top"><!--<button id="btn">View Detail</button>--></td>

            </tr>
            <tr>
                <td valign="top" colspan="2"><button id="btn" onclick="javascript:cmdSave()">Save</button></td>

            </tr>
        </table>
        <%
            }
        }
        %>
        </form>
        <%
            if (msg > 0){
        %>
                <div id="msg">Data have been save</div>
        <%
            }
        %>
        </div>
    </body>
</html>

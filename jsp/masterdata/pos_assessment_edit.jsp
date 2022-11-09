<%-- 
    Document   : pos_assessment_edit
    Created on : Mar 11, 2020, 4:58:42 PM
    Author     : gndiw
--%>
<%@page import="com.dimata.util.Command"%>
<%@page import="com.dimata.harisma.form.masterdata.FrmPositionAssessmentRequired"%>
<%@page import="com.dimata.harisma.form.masterdata.CtrlPositionAssessmentRequired"%>
<%@ include file = "../main/javainit.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%  
    int iCommand = FRMQueryString.requestCommand(request);
    int start = FRMQueryString.requestInt(request, "start");
    int prevCommand = FRMQueryString.requestInt(request, "prev_command");
    long oidPosAss = FRMQueryString.requestLong(request, "hidden_pos_ass_id");
    String comm = request.getParameter("comm");
    String oid = request.getParameter("oid");
    int msg = 0;
    if (oidPosAss != 0 && oidPosAss > 0){
        oid = String.valueOf(oidPosAss);
        msg = 1;
    }
    /*variable declaration*/
    int recordToGet = 10;
    String msgString = "";
    int iErrCode = FRMMessage.NONE;
    String whereClause = "";
    String orderClause = "";

    
    CtrlPositionAssessmentRequired ctrPosAssessment = new CtrlPositionAssessmentRequired(request);

    /*switch statement */
    iErrCode = ctrPosAssessment.action(iCommand, oidPosAss);
    /* end switch*/
    FrmPositionAssessmentRequired frmPosAssessment = ctrPosAssessment.getForm();

%>
<%
    Vector listPosAss = new Vector();
    listPosAss = PstPositionAssessmentRequired.listInnerJoinVer1(oid);

%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Competency Edit</title>

        <script type="text/javascript">
            function getCmd(){
                document.<%=FrmPositionAssessmentRequired.FRM_NAME_POSITION_ASSESSMENT_REQUIRED%>.action = "pos_assessment_edit.jsp";
                document.<%=FrmPositionAssessmentRequired.FRM_NAME_POSITION_ASSESSMENT_REQUIRED%>.submit();
            }
            function cmdEdit(oid) {
                document.<%=FrmPositionAssessmentRequired.FRM_NAME_POSITION_ASSESSMENT_REQUIRED%>.command.value = "<%=Command.EDIT%>";
                document.<%=FrmPositionAssessmentRequired.FRM_NAME_POSITION_ASSESSMENT_REQUIRED%>.hidden_ass_id.value = oid;
                getCmd();
            }

            function cmdSave() {
                document.<%=FrmPositionAssessmentRequired.FRM_NAME_POSITION_ASSESSMENT_REQUIRED%>.command.value = "<%=Command.SAVE%>";
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
        <form name="<%=FrmPositionAssessmentRequired.FRM_NAME_POSITION_ASSESSMENT_REQUIRED%>" action="" method="post">
            <input type="hidden" name="command" value="<%=iCommand%>">
            <input type="hidden" name="hidden_pos_ass_id" value="<%=oid%>">
        <%
        if (listPosAss != null && listPosAss.size() > 0){
            for(int i=0; i<listPosAss.size(); i++){
                Vector vect = (Vector)listPosAss.get(i);
                PositionAssessmentRequired posAss = (PositionAssessmentRequired)vect.get(0);
                Assessment ass = (Assessment)vect.get(1);
                Position pos = (Position)vect.get(2);
            
        %>
        
        <table>
            <tr>
                <td valign="top">Position<input type="hidden" name="<%=frmPosAssessment.fieldNames[frmPosAssessment.FRM_FIELD_POSITION_ID]%>" value="<%=posAss.getPositionId()%>" /></td>
                <td valign="top"><%=pos.getPosition()%></td>

            </tr>
            <tr>
                <td valign="top">Competency<input type="hidden" name="<%=frmPosAssessment.fieldNames[frmPosAssessment.FRM_FIELD_ASSESSMENT_ID]%>" value="<%=posAss.getAssessmentId()%>" /></td>
                <td valign="top"><%=ass.getAssessmentType()%></td>
            </tr>
            <tr>
                <td valign="top">Score Min</td>
                <td valign="top"><input type="text" name="<%=frmPosAssessment.fieldNames[frmPosAssessment.FRM_FIELD_SCORE_REQ_MIN]%>" value="<%=posAss.getScoreReqMin()%>" /></td>

            </tr>
            <tr>
                <td valign="top">Score Recommended</td>
                <td valign="top"><input type="text" name="<%=frmPosAssessment.fieldNames[frmPosAssessment.FRM_FIELD_SCORE_REQ_RECOMMENDED]%>" value="<%=posAss.getScoreReqRecommended()%>" /></td>

            </tr>
            <tr>
                <td valign="top">Re-Training or Re-Certificate</td>
                <td valign="top"><input type="text" name="<%=frmPosAssessment.fieldNames[frmPosAssessment.FRM_FIELD_RE_TRAIN_OR_SERTFC_REQ]%>" value="" /></td>
            </tr>
            <tr>
                <td valign="top">Valid Start</td>
                <td valign="top"><input type="text" name="<%=frmPosAssessment.fieldNames[frmPosAssessment.FRM_FIELD_VALID_START]%>" id="datepicker1" /></td>
            </tr>
            <tr>
                <td valign="top">Valid End</td>
                <td valign="top"><input type="text" name="<%=frmPosAssessment.fieldNames[frmPosAssessment.FRM_FIELD_VALID_END]%>" id="datepicker2" /></td>
            </tr>
            <tr>
                <td valign="top">Note</td>
                <td valign="top"><textarea name="<%=frmPosAssessment.fieldNames[frmPosAssessment.FRM_FIELD_NOTE]%>"><%=posAss.getNote()%></textarea></td>
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


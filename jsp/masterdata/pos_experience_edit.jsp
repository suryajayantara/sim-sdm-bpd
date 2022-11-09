<%-- 
    Document   : pos_experience_edit
    Created on : 02-Aug-2016, 20:32:49
    Author     : Acer
--%>

<%@page import="com.dimata.harisma.entity.masterdata.PstPosition"%>
<%@page import="com.dimata.util.Command"%>
<%@page import="com.dimata.harisma.entity.masterdata.Position"%>
<%@page import="com.dimata.harisma.entity.masterdata.PositionExperienceRequired"%>
<%@page import="com.dimata.harisma.entity.masterdata.PositionEducationRequired"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstPositionExperienceRequired"%>
<%@page import="java.util.Vector"%>
<%@page import="com.dimata.harisma.form.masterdata.FrmPositionExperienceRequired"%>
<%@page import="com.dimata.harisma.form.masterdata.CtrlPositionExperienceRequired"%>
<%@page import="com.dimata.qdep.form.FRMMessage"%>
<%@page import="com.dimata.qdep.form.FRMQueryString"%>
<%  
    int iCommand = FRMQueryString.requestCommand(request);
    int start = FRMQueryString.requestInt(request, "start");
    int prevCommand = FRMQueryString.requestInt(request, "prev_command");
    long oidPosExp = FRMQueryString.requestLong(request, "hidden_pos_exp_id");
    String comm = request.getParameter("comm");
    String oid = request.getParameter("oid");
    int msg = 0;
    if (oidPosExp != 0 && oidPosExp > 0){
        oid = String.valueOf(oidPosExp);
        msg = 1;
    }
    /*variable declaration*/
    int recordToGet = 10;
    String msgString = "";
    int iErrCode = FRMMessage.NONE;
    String whereClause = "";
    String orderClause = "";
    
    CtrlPositionExperienceRequired ctrPosExp = new CtrlPositionExperienceRequired(request);

    /*switch statement */
    iErrCode = ctrPosExp.action(iCommand, oidPosExp);
    /* end switch*/
    FrmPositionExperienceRequired frmPosExp = ctrPosExp.getForm();
    whereClause = PstPositionExperienceRequired.fieldNames[PstPositionExperienceRequired.FLD_POS_EXPERIENCE_REQ_ID] +"="+ oid;
%>
<%
    
    Vector listPosExp = new Vector();
    listPosExp = PstPositionExperienceRequired.list(0, recordToGet, whereClause, "");
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Experience Edit</title>
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
        <script type="text/javascript">
            function getCmd(){
                document.<%=FrmPositionExperienceRequired.FRM_NAME_POSITION_EXPERIENCE_REQUIRED%>.action = "pos_experience_edit.jsp";
                document.<%=FrmPositionExperienceRequired.FRM_NAME_POSITION_EXPERIENCE_REQUIRED%>.submit();
            }
            function cmdEdit(oid) {
                document.<%=FrmPositionExperienceRequired.FRM_NAME_POSITION_EXPERIENCE_REQUIRED%>.command.value = "<%=Command.EDIT%>";
                document.<%=FrmPositionExperienceRequired.FRM_NAME_POSITION_EXPERIENCE_REQUIRED%>.hidden_comp_id.value = oid;
                getCmd();
            }

            function cmdSave() {
                document.<%=FrmPositionExperienceRequired.FRM_NAME_POSITION_EXPERIENCE_REQUIRED%>.command.value = "<%=Command.SAVE%>";
                getCmd();
            }
        </script>
    </head>
    <body>
        <div class="header">
            <h2>Education Edit</h2>
        </div>
        <div class="content">
        <form name="<%=FrmPositionExperienceRequired.FRM_NAME_POSITION_EXPERIENCE_REQUIRED%>" action="" method="post">
            <input type="hidden" name="command" value="<%=iCommand%>">
            <input type="hidden" name="hidden_pos_exp_id" value="<%=oid%>">
        <%
        if (listPosExp != null && listPosExp.size() > 0){
            for(int i=0; i<listPosExp.size(); i++){
                PositionExperienceRequired pos = (PositionExperienceRequired)listPosExp.get(i);
                
                Position position = new Position();
                Position experience = new Position();
                try {
                    position = PstPosition.fetchExc(pos.getPositionId());
                    experience = PstPosition.fetchExc(pos.getExperienceId());
                } catch (Exception e){
                    
                }
                
        %>
        
        <table>
            <tr>
                <td valign="top">Position<input type="hidden" name="<%=frmPosExp.fieldNames[frmPosExp.FRM_FIELD_POSITION_ID]%>" value="<%=pos.getPositionId()%>" /></td>
                <td valign="top"><%=position.getPosition()%></td>
            </tr>
            <tr>
                <td valign="top">Experience Required<input type="hidden" name="<%=frmPosExp.fieldNames[frmPosExp.FRM_FIELD_EXPERIENCE_ID]%>" value="<%=pos.getExperienceId()%>" /></td>
                <td valign="top"><%=experience.getPosition()%></td>
            </tr>
            <tr>
                <td valign="top">Duration Min</td>
                <td valign="top"><input type="text"  maxlength="5" name="<%=frmPosExp.fieldNames[frmPosExp.FRM_FIELD_DURATION_MIN]%>" value="<%=pos.getDurationMin()%>" /> months</td>
            </tr>
            <tr>
                <td valign="top">Duration Recommended</td>
                <td valign="top"><input type="text" maxlength="5" name="<%=frmPosExp.fieldNames[frmPosExp.FRM_FIELD_DURATION_RECOMMENDED]%>" value="<%=pos.getDurationRecommended()%>" />months</td>
            </tr>
            <tr>
                <td valign="top">Note</td>
                <td valign="top">
                    <textarea name="<%=frmPosExp.fieldNames[frmPosExp.FRM_FIELD_NOTE]%>"><%=pos.getNote()%></textarea>
                </td>
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

<%-- 
    Document   : division_ajax
    Created on : Jan 7, 2016, 1:44:18 PM
    Author     : Dimata 007
--%>
<%@page import="com.dimata.harisma.entity.log.ChangeValue"%>
<%@page import="com.dimata.util.Command"%>
<%@page import="com.dimata.harisma.entity.admin.AppObjInfo"%>
<%@ include file = "../../main/javainit.jsp" %>
<% int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_MASTERDATA, AppObjInfo.G2_MD_COMPANY, AppObjInfo.OBJ_DIVISION);%>
<%@ include file = "../../main/checkuser.jsp" %>
<%@ page import ="java.util.*,
                  java.text.*,				  
                  com.dimata.qdep.form.*,				  
                  com.dimata.gui.jsp.*,
                  com.dimata.util.*,				  
                  com.dimata.harisma.entity.masterdata.*,				  				  
                  com.dimata.harisma.entity.employee.*,
                  com.dimata.harisma.entity.attendance.*,
                  com.dimata.harisma.entity.search.*,
                  com.dimata.harisma.form.masterdata.*,				  				  
                  com.dimata.harisma.form.attendance.*,
                  com.dimata.harisma.form.search.*,				  
                  com.dimata.harisma.session.attendance.*,
                  com.dimata.harisma.session.leave.SessLeaveApp,
                  com.dimata.harisma.session.leave.*,
                  com.dimata.harisma.session.attendance.SessLeaveManagement,
                  com.dimata.harisma.session.leave.RepItemLeaveAndDp"%>
<%@page contentType="application/x-msexcel" pageEncoding="UTF-8"%>
<%
    response.setHeader("Content-Disposition","attachment;filename= Jabatan_(Position).xls");
    String positionName = FRMQueryString.requestString(request, "position_name");
    long validStatusSelect = FRMQueryString.requestLong(request, "valid_status_select");
    long levelSelect = FRMQueryString.requestLong(request, "level_select");
    long divisionId = FRMQueryString.requestLong(request, "division_select");
    
    String test = "default";
    int iCommand = FRMQueryString.requestInt(request, "command");
    int start = FRMQueryString.requestInt(request, "start");
    String whereClause = "";
    String order = "";
    Vector listPosition = new Vector();
    CtrlPosition ctrlPosition= new CtrlPosition(request);
    
    int recordToGet = 0;
    int vectSize = 0;
    
    /*
    if (!(positionName.equals("0")) && validStatusSelect == 0 && levelSelect == 0 && divisionId == 0){
        test = "Searching By Position Name";
        whereClause = PstPosition.fieldNames[PstPosition.FLD_POSITION]+" LIKE '%"+positionName+"%'";
        order = PstPosition.fieldNames[PstPosition.FLD_POSITION];
        vectSize = PstPosition.getCount(whereClause);
        listPosition = PstPosition.list(start, recordToGet, whereClause, order);
    }
    
    if (positionName.equals("0") && validStatusSelect != 0 && levelSelect == 0 && divisionId == 0){
        test = "Searching By Valid Status";
        whereClause = PstPosition.fieldNames[PstPosition.FLD_VALID_STATUS]+"="+validStatusSelect;
        order = PstPosition.fieldNames[PstPosition.FLD_POSITION];
        vectSize = PstPosition.getCount(whereClause);
        listPosition = PstPosition.list(start, recordToGet, whereClause, order);
    }
    
    if (positionName.equals("0") && validStatusSelect == 0 && levelSelect != 0 && divisionId == 0){
        test = "Searching By Level";
        whereClause = PstPosition.fieldNames[PstPosition.FLD_LEVEL_ID]+"="+levelSelect;
        order = PstPosition.fieldNames[PstPosition.FLD_POSITION];
        vectSize = PstPosition.getCount(whereClause);
        listPosition = PstPosition.list(start, recordToGet, whereClause, order);
    }
    
    if (positionName.equals("0") && validStatusSelect == 0 && levelSelect == 0 && divisionId != 0){
        test = "Searching By Division";
        String strIN = "0";
        whereClause = PstPositionDivision.fieldNames[PstPositionDivision.FLD_DIVISION_ID]+"="+divisionId;
        Vector listPosDiv = PstPositionDivision.list(0, 0, whereClause, "");
        if (listPosDiv != null && listPosDiv.size()>0){
            for(int i=0; i<listPosDiv.size(); i++){
                PositionDivision posDiv = (PositionDivision)listPosDiv.get(i);
                strIN += posDiv.getPositionId()+", ";
            }
            strIN += "0";
        }
        whereClause = PstPosition.fieldNames[PstPosition.FLD_POSITION_ID]+" IN("+strIN+")";
        order = PstPosition.fieldNames[PstPosition.FLD_POSITION];
        vectSize = PstPosition.getCount(whereClause);
        listPosition = PstPosition.list(0, 0, whereClause, order);
    }*/
    
    if (positionName.equals("0") && validStatusSelect == 0 && levelSelect == 0 && divisionId == 0){
        whereClause = PstPosition.fieldNames[PstPosition.FLD_VALID_STATUS]+" LIKE '1'";
        test = "Show All With Filter Active";
        order = PstPosition.fieldNames[PstPosition.FLD_POSITION];
        vectSize = PstPosition.getCount("");
        listPosition = PstPosition.list(start, recordToGet, whereClause, order);
    } else {
        Vector whereVect = new Vector();
        if (!positionName.equals("0")){
            whereClause = PstPosition.fieldNames[PstPosition.FLD_POSITION]+" LIKE '%"+positionName+"%'";
            whereVect.add(whereClause);
        }
        if (validStatusSelect != 0){
            whereClause = PstPosition.fieldNames[PstPosition.FLD_VALID_STATUS]+"="+validStatusSelect;
            whereVect.add(whereClause);
        }
        if (validStatusSelect == 3){
            whereClause = PstPosition.fieldNames[PstPosition.FLD_VALID_STATUS]+"= '1' OR '2'";
            whereVect.add(whereClause);
        }
        if (levelSelect != 0){
            whereClause = PstPosition.fieldNames[PstPosition.FLD_LEVEL_ID]+"="+levelSelect;
            whereVect.add(whereClause);
        }
        if (divisionId != 0){
            whereClause = PstPositionDivision.fieldNames[PstPositionDivision.FLD_DIVISION_ID]+"="+divisionId;
            whereVect.add(whereClause);//
        }
        whereClause = "";
        if (whereVect != null && whereVect.size()>0){
            for(int i=0; i<whereVect.size(); i++){
                String whereData = (String)whereVect.get(i);
                whereClause = whereClause + whereData;
                if (i < (whereVect.size()-1)){
                    whereClause += " AND ";//
                }
            }
        }
        order = PstPosition.fieldNames[PstPosition.FLD_POSITION];
        vectSize = PstPosition.getCount(whereClause);
        listPosition = PstPosition.list(start, recordToGet, whereClause, order);
    }
    vectSize = PstPosition.getCount(whereClause);
    if ((iCommand == Command.FIRST) || (iCommand == Command.NEXT) || (iCommand == Command.PREV)
            || (iCommand == Command.LAST) || (iCommand == Command.LIST)) {
        start = ctrlPosition.actionList(iCommand, start, vectSize, recordToGet);
    }
    if (listPosition != null && listPosition.size()>0){
        String trCSS = "tr1";
        %>
        <div style="color:#575757; font-size: 13px; padding: 7px 11px; border-left: 1px solid #007592; margin: 7px 0px; background-color: #FFF;">
            Daftar data Jabatan
        </div>
        <table class="tblStyle" border="1">
            <tr style="text-align: center">
                <th class="title_tbl" style="background-color: #DDD;">No</th>
                <th class="title_tbl" style="background-color: #DDD;">Title</th>
                <th class="title_tbl" style="background-color: #DDD;">Level</th>
                <th class="title_tbl" style="background-color: #DDD;">Valid Status</th>
            </tr>
        <%
        for(int i=0; i<listPosition.size(); i++){
            Position position = (Position)listPosition.get(i);
            if (i % 2 == 0){
                trCSS = "tr1";
            } else {
                trCSS = "tr2";
            }
            %>
            <tr class="<%= trCSS %>">
                <td><%= (i+1) %></td>
                <td><%= position.getPosition() %></td>
                <td>
                    <%
                    String strLevel = "-";
                    try {
                        Level lev = PstLevel.fetchExc(position.getLevelId());
                        strLevel = lev.getLevel();
                    } catch(Exception e){
                        System.out.println(""+e.toString());
                    }
                    %>
                    <%= strLevel %>
                </td>
                <td>
                    <%= PstPosition.validStatusValue[position.getValidStatus()] %>
                </td>
                
            </tr>
            <%
        }
        %>
        </table>
        <%
    } else {
        %>
        <div>&nbsp;</div>
        <div style="padding:5px 9px; background-color: #FFF; font-size: 12px;">Tidak ada data yang tersedia</div>
        <%
    }
%>
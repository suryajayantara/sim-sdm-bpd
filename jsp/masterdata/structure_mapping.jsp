<%-- 
    Document   : structure_mapping
    Created on : Aug 24, 2015, 10:14:43 AM
    Author     : Dimata 007
--%>

<%@page import="com.dimata.harisma.form.masterdata.CtrlMappingPosition"%>
<%@page import="com.dimata.harisma.form.masterdata.FrmMappingPosition"%>
<%@page import="com.dimata.gui.jsp.ControlCombo"%>
<%@page import="com.dimata.util.Command"%>
<%@page import="com.dimata.qdep.form.FRMQueryString"%>
<%@page import="com.dimata.qdep.form.FRMMessage"%>
<%@page import="java.util.Vector"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstPosition"%>
<%@page import="com.dimata.system.entity.system.PstSystemProperty"%>
<%@page import="com.dimata.harisma.entity.admin.AppObjInfo"%>
<%@page import="com.dimata.gui.jsp.ControlLine"%>
<%@page import="com.dimata.gui.jsp.ControlList"%>
<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_REPORTS, AppObjInfo.G2_PRESENCE_REPORT, AppObjInfo.OBJ_PRESENCE_REPORT);
    int appObjCodePresenceEdit = AppObjInfo.composeObjCode(AppObjInfo.G1_EMPLOYEE, AppObjInfo.G2_ATTENDANCE, AppObjInfo.OBJ_PRESENCE);
    boolean privUpdatePresence = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodePresenceEdit, AppObjInfo.COMMAND_UPDATE));
%>
<%@ include file = "../main/checkuser.jsp" %>
<%
    long hrdDepOid = Long.parseLong(String.valueOf(PstSystemProperty.getPropertyLongbyName(OID_HRD_DEPARTMENT)));
    boolean isHRDLogin = hrdDepOid == departmentOid ? true : false;
    long edpSectionOid = Long.parseLong(String.valueOf(PstSystemProperty.getPropertyLongbyName(OID_EDP_SECTION)));
    boolean isEdpLogin = edpSectionOid == sectionOfLoginUser.getOID() ? true : false;
    boolean isGeneralManager = positionType == PstPosition.LEVEL_GENERAL_MANAGER ? true : false;
%>
<%!
    public String drawList(Vector objectClass) {
        ControlList ctrlist = new ControlList();
        ctrlist.setAreaWidth("100%");
        ctrlist.setListStyle("tblStyle");
        ctrlist.setTitleStyle("title_tbl");
        ctrlist.setCellStyle("listgensell");
        ctrlist.setHeaderStyle("title_tbl");
        ctrlist.setCellSpacing("0");
        ctrlist.addHeader("Up Position", "");
        ctrlist.addHeader("Down Position", "");
        ctrlist.addHeader("Start Date", "");
        ctrlist.addHeader("End Date", "");
        ctrlist.addHeader("Type of Link", "");
        ctrlist.addHeader("","");
        ctrlist.setLinkRow(0);
        ctrlist.setLinkSufix("");
        Vector lstData = ctrlist.getData();
        Vector lstLinkData = ctrlist.getLinkData();
        ctrlist.setLinkPrefix("javascript:cmdEdit('");
        ctrlist.setLinkSufix("')");
        ctrlist.reset();

        if (objectClass != null && objectClass.size()>0){
            for(int i=0; i<objectClass.size(); i++){
                MappingPosition mapping = (MappingPosition)objectClass.get(i);
                Vector rowx = new Vector();

                rowx.add(getPositionName(mapping.getUpPositionId()));
                rowx.add(getPositionName(mapping.getDownPositionId()));
                rowx.add(""+mapping.getStartDate());
                rowx.add(""+mapping.getEndDate());
                rowx.add(PstMappingPosition.typeOfLink[mapping.getTypeOfLink()]);
                rowx.add("<button class=\"btn\" onclick=\"cmdAsk('"+mapping.getOID()+"')\">&times;</button>");
                lstData.add(rowx);
                lstLinkData.add(String.valueOf(mapping.getOID()));
            }
        }
        return ctrlist.draw();
    }
    
    public String getDrawDownPosition(long oidPosition, long oidTemplate, String approot){
        String str = "";
        String whereClause = PstMappingPosition.fieldNames[PstMappingPosition.FLD_UP_POSITION_ID]+"="+oidPosition;
        whereClause += " AND "+PstMappingPosition.fieldNames[PstMappingPosition.FLD_TEMPLATE_ID]+"="+oidTemplate;
        Vector listDown = PstMappingPosition.list(0, 0, whereClause, "");
        String topkiri = "border-top:1px solid #999;";
        String topkanan = "border-top:1px solid #999;";
        if (listDown != null && listDown.size()>0){
            str = "<table class=\"tblStyle1\"><tr>";
            for(int i=0; i<listDown.size(); i++){
                MappingPosition pos = (MappingPosition)listDown.get(i);
                
                if (listDown.size() == 1){
                    topkiri = "";
                    topkanan = "";
                } else {
                    if (i == 0 || i == (listDown.size()-1)){
                        if (i == 0){
                            topkiri = "";
                            topkanan = "border-top:1px solid #999;";
                        } else {
                            topkiri = "border-top:1px solid #999;";
                            topkanan = "";
                        }
                    } else {
                        topkiri = "border-top:1px solid #999;";
                        topkanan = "border-top:1px solid #999;";
                    }
                }
                
                str += "<td valign=\"top\">";
                
                str += "<table width=\"100%\" align=\"center\" cellpadding=\"0\" cellspacing=\"0\">";
                str += "<tr>";
                str += "<td width=\"50%\" style=\"border-right:1px solid #999; "+topkiri+"\">&nbsp;</td><td width=\"50%\" style=\""+topkanan+"\">&nbsp;</td>";
                str += "</tr>";
                if (pos.getVerticalLine() > 0){
                    for(int v=0; v<pos.getVerticalLine(); v++){
                        str += "<tr>";
                        str += "<td width=\"50%\" style=\"border-right:1px solid #999;>&nbsp;</td><td width=\"50%\">&nbsp;</td>";
                        str += "</tr>";
                    }
                }
                str += "</table>";
                
                str += "<img height=\"64\" id=\"photo\" src=\""+approot+"/imgcache/no-img.jpg\" />"; 
                
                str += "<div style=\"color: #373737\"><strong>Nama Karyawan</strong></div>";
                str += "<div id=\"position\">" + getPositionName(pos.getDownPositionId()) + "</div>" + getDrawDownPosition(pos.getDownPositionId(), oidTemplate, approot);
                
                //str += "<td>"+getPositionName(pos.getDownPositionId())+"<br />"+getDrawDownPosition(pos.getDownPositionId(),oidTemplate)+"</td>";
            }
            str += "</tr></table>";
        }
        
        return str;
    }

    public String getPositionName(long posId){
        String position = "";
        Position pos = new Position();
        try {
            pos = PstPosition.fetchExc(posId);
        } catch(Exception ex){
            System.out.println("getPositionName ==> "+ex.toString());
        }
        position = pos.getPosition();
        return position;
    }
   
%>
<!DOCTYPE html>
<%  
    int iCommand = FRMQueryString.requestCommand(request);
    long oidMapping = FRMQueryString.requestLong(request, "oid_mapping");
    long oidTemplate = FRMQueryString.requestLong(request, "oid_template");
    long selectClone = FRMQueryString.requestLong(request, "select_clone");
    int start = FRMQueryString.requestInt(request, "start");
    int prevCommand = FRMQueryString.requestInt(request, "prev_command");
    long oidUpPosition = FRMQueryString.requestLong(request, "up_position");
    long oidDownPosition = FRMQueryString.requestLong(request, "down_position");

    /*variable declaration*/
    int recordToGet = 15;
    String msgString = "";
    int iErrCode = FRMMessage.NONE;
    String whereClause = PstMappingPosition.fieldNames[PstMappingPosition.FLD_TEMPLATE_ID]+"="+oidTemplate;
    String orderClause = "";

    CtrlMappingPosition ctrlMapping = new CtrlMappingPosition(request);
    ControlLine ctrLine = new ControlLine();
    Vector listMapping = new Vector(1, 1);

    /*switch statement */
    iErrCode = ctrlMapping.action(iCommand, oidMapping);
    /* end switch*/
    FrmMappingPosition frmMapping = ctrlMapping.getForm();

    /*count list All Position*/
    int vectSize = PstMappingPosition.getCount(whereClause);

    MappingPosition mapping = ctrlMapping.getMappingPosition();

    /*switch list Division*/
    if ((iCommand == Command.SAVE) && (iErrCode == FRMMessage.NONE)) {
        start = PstMappingPosition.findLimitStart(mapping.getOID(), recordToGet, whereClause, orderClause);
        oidMapping = mapping.getOID();
        mapping = new MappingPosition();
    }

    if ((iCommand == Command.FIRST || iCommand == Command.PREV)
            || (iCommand == Command.NEXT || iCommand == Command.LAST)) {
        start = ctrlMapping.actionList(iCommand, start, vectSize, recordToGet);
    }
    /* end switch list*/

    /* get record to display */
    listMapping = PstMappingPosition.list(start, recordToGet, whereClause, orderClause);

    /*handle condition if size of record to display = 0 and start > 0 	after delete*/
    if (listMapping.size() < 1 && start > 0) {
        if (vectSize - recordToGet > recordToGet) {
            start = start - recordToGet;   //go to Command.PREV
        } else {
            start = 0;
            iCommand = Command.FIRST;
            prevCommand = Command.FIRST; //go to Command.FIRST//
        }
        listMapping = PstMappingPosition.list(start, recordToGet, whereClause, orderClause);
    }
    
    if (iCommand == Command.YES){
        MappingPosition mapPos = new MappingPosition();
        whereClause = PstMappingPosition.fieldNames[PstMappingPosition.FLD_TEMPLATE_ID]+"="+selectClone;
        Vector listMapClone = PstMappingPosition.list(0, 0, whereClause, "");
        if (listMapClone != null && listMapClone.size()>0){
            for(int i=0; i<listMapClone.size(); i++){
                MappingPosition mappingPos = (MappingPosition)listMapClone.get(i);
                mapPos.setOID(0);
                mapPos.setUpPositionId(mappingPos.getUpPositionId());
                mapPos.setDownPositionId(mappingPos.getDownPositionId());
                mapPos.setStartDate(mappingPos.getStartDate());
                mapPos.setEndDate(mappingPos.getEndDate());
                mapPos.setTypeOfLink(mappingPos.getTypeOfLink());
                mapPos.setTemplateId(oidTemplate);
                try {
                    PstMappingPosition.insertExc(mapPos);
                } catch (Exception e){
                    System.out.println("Insert mapping clone=>"+e.toString());
                }
            }
        }
        iCommand = Command.VIEW;
        listMapping = PstMappingPosition.list(0, recordToGet, whereClause, orderClause);
    }
%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Structure Mapping</title>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
        <link rel="stylesheet" href="../styles/main.css" type="text/css">
        <link rel="stylesheet" href="../styles/tab.css" type="text/css">
        <link href="<%=approot%>/stylesheets/superTables.css" rel="Stylesheet" type="text/css" /> 
        <style type="text/css">

            #mn_utama {color: #FF6600; padding: 5px 14px; border-left: 1px solid #999; font-size: 12px; font-weight: bold; background-color: #F5F5F5;}
            
            #menu_utama {padding: 9px 14px; border-left: 1px solid #0099FF; font-size: 14px; background-color: #F3F3F3; color:#0099FF; font-size: 14px; font-weight: bold;}
            
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
            #btn1 {
              background: #f27979;
              border: 1px solid #d74e4e;
              border-radius: 3px;
              font-family: Arial;
              color: #ffffff;
              font-size: 12px;
              padding: 3px 9px 3px 9px;
            }

            #btn1:hover {
              background: #d22a2a;
              border: 1px solid #c31b1b;
            }
            #tdForm {
                padding: 5px;
            }
            .detail {
                background-color: #b01818;
                color:#FFF;
                padding: 2px;
                font-size: 9px;
                cursor: pointer;
            }
            .detail1 {
                background-color: #ffe400;
                color:#d76f09;
                padding: 2px;
                font-size: 9px;
                cursor: pointer;
            }
            .detail_pos {
                cursor: pointer;
            }
            .tblStyle {border-collapse: collapse;font-size: 11px;}
            .tblStyle td {padding: 4px 6px; border: 1px solid #CCC; background-color: #FFF;}
            
            .tblStyle1 {border-collapse: collapse; background-color: #FFF;}
            .tblStyle1 td {color:#575757; text-align: center; font-size: 11px; padding: 3px 0px; }
            
            .title_tbl {font-weight: bold;background-color: #DDD; color: #575757;}
            #confirm {background-color: #fad9d9;border: 1px solid #da8383; color: #bf3c3c; padding: 14px 21px;border-radius: 5px;}
            .title_part {background-color: #FFF; border-left: 1px solid #3cb0fd; padding:5px 15px;  color: #575757; margin: 3px 0px;}
            #position {
                background-color: #DDD;
                color: #474747;
                padding: 2px 3px;
                margin: 3px;
            }
            .div_title_clone {
                color: #474747;
                font-weight: bold;
                padding-left: 19px;
                background-color: #DDD;
                border:1px solid #CCC;
                border-bottom: none;
                border-right: none;
                border-top-left-radius: 5px;
            }
            .div_close {
                padding: 9px;
                background-color: #DDD;
                border:1px solid #CCC;
                border-left: none;
                border-bottom: none;
                border-top-right-radius: 5px;
            }
            .div_clone {
                padding: 19px;
                background-color: #F5F5F5;
                border:1px solid #CCC;
                border-bottom-left-radius: 5px;
                border-bottom-right-radius: 5px;
            }
            
            .btn-small {
                font-family: sans-serif;
                text-decoration: none;
                padding: 5px 7px; 
                background-color: #676767; color: #F5F5F5; 
                font-size: 11px; cursor: pointer;
                border-radius: 3px;
            }
            .btn-small:hover { background-color: #474747; color: #FFF;}
            
            .btn-small-e {
                font-family: sans-serif;
                text-decoration: none;
                padding: 3px 5px; 
                background-color: #92C8E8; color: #F5F5F5; 
                font-size: 11px; cursor: pointer;
                border-radius: 3px;
            }
            .btn-small-e:hover { background-color: #659FC2; color: #FFF;}
            
            .btn-small-x {
                font-family: sans-serif;
                text-decoration: none;
                padding: 3px 5px; 
                background-color: #EB9898; color: #F5F5F5; 
                font-size: 11px; cursor: pointer;
                border-radius: 3px;
            }
            .btn-small-x:hover { background-color: #D14D4D; color: #FFF;}
        </style>
        <script type="text/javascript">
            function getCmd(){
                document.<%=FrmMappingPosition.FRM_NAME_MAPPING_POSITION%>.action = "structure_mapping.jsp";
                document.<%=FrmMappingPosition.FRM_NAME_MAPPING_POSITION%>.submit();
            }
            function cmdSave(){
                document.<%=FrmMappingPosition.FRM_NAME_MAPPING_POSITION%>.command.value = "<%=Command.SAVE%>";
                getCmd();
            }
            
            function cmdAdd(){
                document.<%=FrmMappingPosition.FRM_NAME_MAPPING_POSITION%>.oid_mapping.value = "0";
                document.<%=FrmMappingPosition.FRM_NAME_MAPPING_POSITION%>.command.value="<%=Command.ADD%>";
                document.<%=FrmMappingPosition.FRM_NAME_MAPPING_POSITION%>.prev_command.value="<%=prevCommand%>";
                getCmd();
            }
            
            function cmdClone(){
                document.<%=FrmMappingPosition.FRM_NAME_MAPPING_POSITION%>.command.value="<%=Command.DETAIL%>";
                getCmd();
            }
            
            function cmdSubmitClone(val){
                document.<%=FrmMappingPosition.FRM_NAME_MAPPING_POSITION%>.select_clone=val;
                document.<%=FrmMappingPosition.FRM_NAME_MAPPING_POSITION%>.command.value="<%=Command.YES%>";
                getCmd();
            }
            
            function cmdEdit(oid) {
                document.<%=FrmMappingPosition.FRM_NAME_MAPPING_POSITION%>.command.value = "<%=Command.EDIT%>";
                document.<%=FrmMappingPosition.FRM_NAME_MAPPING_POSITION%>.oid_mapping.value = oid;
                getCmd();
            }
            
            function cmdListFirst(){
                document.<%=FrmMappingPosition.FRM_NAME_MAPPING_POSITION%>.command.value="<%=Command.FIRST%>";
                document.<%=FrmMappingPosition.FRM_NAME_MAPPING_POSITION%>.prev_command.value="<%=Command.FIRST%>";
                getCmd();
            }

            function cmdListPrev(){
                document.<%=FrmMappingPosition.FRM_NAME_MAPPING_POSITION%>.command.value="<%=Command.PREV%>";
                document.<%=FrmMappingPosition.FRM_NAME_MAPPING_POSITION%>.prev_command.value="<%=Command.PREV%>";
                getCmd();
            }

            function cmdListNext(){
                document.<%=FrmMappingPosition.FRM_NAME_MAPPING_POSITION%>.command.value="<%=Command.NEXT%>";
                document.<%=FrmMappingPosition.FRM_NAME_MAPPING_POSITION%>.prev_command.value="<%=Command.NEXT%>";
                getCmd();
            }

            function cmdListLast(){
                document.<%=FrmMappingPosition.FRM_NAME_MAPPING_POSITION%>.command.value="<%=Command.LAST%>";
                document.<%=FrmMappingPosition.FRM_NAME_MAPPING_POSITION%>.prev_command.value="<%=Command.LAST%>";
                getCmd();
            }
            function cmdBack() {
                document.<%=FrmMappingPosition.FRM_NAME_MAPPING_POSITION%>.command.value="<%=Command.BACK%>";               
                getCmd();
            }
            function cmdAsk(oid){
                document.<%=FrmMappingPosition.FRM_NAME_MAPPING_POSITION%>.command.value="<%=Command.ASK%>";
                document.<%=FrmMappingPosition.FRM_NAME_MAPPING_POSITION%>.oid_mapping.value = oid;
                getCmd();
            }
            function cmdDelete(oid){
                document.<%=FrmMappingPosition.FRM_NAME_MAPPING_POSITION%>.command.value = "<%=Command.DELETE%>";
                document.<%=FrmMappingPosition.FRM_NAME_MAPPING_POSITION%>.oid_mapping.value = oid;
                getCmd();
            }
            function cmdGoBack() {
                document.<%=FrmMappingPosition.FRM_NAME_MAPPING_POSITION%>.command.value="<%=Command.BACK%>";               
                document.<%=FrmMappingPosition.FRM_NAME_MAPPING_POSITION%>.action="structure_template.jsp";
                document.<%=FrmMappingPosition.FRM_NAME_MAPPING_POSITION%>.submit();
            }
            function cmdUpPosition(){
                newWindow=window.open("structure_upposition_form.jsp","StructureUpposition", "height=600,width=500,status=yes,toolbar=no,menubar=no,location=center,scrollbars=yes");
                newWindow.focus();
            }
            function cmdDownPosition(){
                newWindow=window.open("structure_downposition_form.jsp","StructureDownposition", "height=600,width=500,status=yes,toolbar=no,menubar=no,location=center,scrollbars=yes");
                newWindow.focus();
            }
        </script>
        <script type="text/javascript">
            var valueCheck = 0;
            
            function putValue(v){
                valueCheck = v;
            }
           function loadList(oid_map) {
               var template = document.getElementById("oid_template").value;
                if (oid_map.length == 0) { 
                    oid_map = "0";
                } 
                var xmlhttp = new XMLHttpRequest();
                xmlhttp.onreadystatechange = function() {
                    if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                        document.getElementById("map_respon").innerHTML = xmlhttp.responseText;
                    }
                };
                xmlhttp.open("GET", "mapping_ajax.jsp?oid_mapping=" + oid_map +"&rb_position="+valueCheck+"&oid_template=" + template, true);
                xmlhttp.send();
                
            }
            
            function prepare(){
                loadList("0");
            }
            
            function cmdListFirst(start){
                var template = document.getElementById("oid_template").value;
                var xmlhttp = new XMLHttpRequest();
                xmlhttp.onreadystatechange = function() {
                    if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                        document.getElementById("map_respon").innerHTML = xmlhttp.responseText;
                    }
                };
                xmlhttp.open("GET", "mapping_ajax.jsp?oid_mapping=0&rb_position="+valueCheck+ "&command=" + <%=Command.FIRST%> + "&start="+start+"&oid_template=" + template , true);
                xmlhttp.send();
            }

            function cmdListPrev(start){
                var template = document.getElementById("oid_template").value;
                var xmlhttp = new XMLHttpRequest();
                xmlhttp.onreadystatechange = function() {
                    if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                        document.getElementById("map_respon").innerHTML = xmlhttp.responseText;
                    }
                };
                xmlhttp.open("GET", "mapping_ajax.jsp?oid_mapping=0&rb_position="+valueCheck+ "&command=" + <%=Command.PREV%> + "&start="+start+"&oid_template=" + template, true);
                xmlhttp.send();
            }

            function cmdListNext(start){
                var template = document.getElementById("oid_template").value;
                var xmlhttp = new XMLHttpRequest();
                xmlhttp.onreadystatechange = function() {
                    if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                        document.getElementById("map_respon").innerHTML = xmlhttp.responseText;
                    }
                };
                xmlhttp.open("GET", "mapping_ajax.jsp?oid_mapping=0&rb_position="+valueCheck+ "&command=" + <%=Command.NEXT%> + "&start="+start+"&oid_template=" + template, true);
                xmlhttp.send();
            }

            function cmdListLast(start){
                var template = document.getElementById("oid_template").value;
                var xmlhttp = new XMLHttpRequest();
                xmlhttp.onreadystatechange = function() {
                    if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                        document.getElementById("map_respon").innerHTML = xmlhttp.responseText;
                    }
                };
                xmlhttp.open("GET", "mapping_ajax.jsp?oid_mapping=0&rb_position="+valueCheck+ "&command=" + <%=Command.LAST%> + "&start="+start+"&oid_template=" + template, true);
                xmlhttp.send();
            }
        </script>  
        <style type="text/css">
            body {background-color: #EEE;}
            .header {
                
            }
            .content-main {
                background-color: #FFF;
                margin: 25px 23px 59px 23px;
                border: 1px solid #DDD;
                border-radius: 5px;
            }
            .content-info {
                padding: 21px;
                border-bottom: 1px solid #E5E5E5;
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
            
            .btn-data {
                background-color: #DDD;
                border-radius: 3px;
                font-family: Arial;
                color: #474747;
                font-size: 12px;
                padding: 7px 11px 7px 11px;
                text-decoration: none;
            }
            .btn-data:hover {
                color: #FFF;
                background-color: #999;
                text-decoration: none;
            }
            
            .btn-small {
                font-family: sans-serif;
                text-decoration: none;
                padding: 5px 7px; 
                background-color: #676767; color: #F5F5F5; 
                font-size: 11px; cursor: pointer;
                border-radius: 3px;
            }
            .btn-small:hover { background-color: #474747; color: #FFF;}
            #record_count{
                font-size: 11px;
                padding-bottom: 3px;
            }
            .tbl-main {border-collapse: collapse; font-size: 11px; background-color: #FFF; margin: 0px;}
            .tbl-main td {padding: 4px 7px; border: 1px solid #DDD; }
            #tbl-title {font-weight: bold; background-color: #F5F5F5; color: #575757;}
            
            .tbl-small {border-collapse: collapse; font-size: 11px; background-color: #FFF;}
            .tbl-small td {padding: 2px 3px; border: 1px solid #DDD; }
            
            #caption {padding: 7px 0px 2px 0px; font-size: 12px; font-weight: bold; color: #575757;}
            #div_input {}
            
            .form-style {
                font-size: 12px;
                color: #575757;
                border: 1px solid #DDD;
                border-radius: 5px;
            }
            .form-title {
                padding: 11px 21px;
                margin-bottom: 2px;
                border-bottom: 1px solid #DDD;
                background-color: #EEE;
                border-top-left-radius: 5px;
                border-top-right-radius: 5px;
                font-weight: bold;
            }
            .form-content {
                padding: 21px;
            }
            .form-footer {
                border-top: 1px solid #DDD;
                padding: 11px 21px;
                margin-top: 2px;
                background-color: #EEE;
                border-bottom-left-radius: 5px;
                border-bottom-right-radius: 5px;
            }
            #confirm {
                padding: 18px 21px;
                background-color: #FF6666;
                color: #FFF;
                border: 1px solid #CF5353;
            }
            #btn-confirm {
                padding: 3px; border: 1px solid #CF5353; 
                background-color: #CF5353; color: #FFF; 
                font-size: 11px; cursor: pointer;
            }
            .footer-page {
                
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
    <body onload="prepare()">
        <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%" bgcolor="#F9FCFF" >
            <%if (headerStyle && !verTemplate.equalsIgnoreCase("0")) {%> 
            <%@include file="../styletemplate/template_header.jsp" %>
            <%} else {%>
            <tr> 
                <td ID="TOPTITLE" background="<%=approot%>/images/HRIS_HeaderBg3.jpg" height="54"> 
                    <!-- #BeginEditable "header" --> 
                    <%@ include file = "../main/header.jsp" %>
                    <!-- #EndEditable --> 
                </td>
            </tr>
            <tr> 
                <td  bgcolor="#9BC1FF" height="15" ID="MAINMENU" valign="middle"> <!-- #BeginEditable "menumain" --> 
                    <%@ include file = "../main/mnmain.jsp" %>
                    <!-- #EndEditable --> </td>
            </tr>
            <tr> 
                <td  bgcolor="#9BC1FF" height="10" valign="middle"> 
                    <table border="0" cellspacing="0" cellpadding="0">
                        <tr> 
                            <td align="left"><img src="<%=approot%>/images/harismaMenuLeft1.jpg" width="8" height="8"></td>
                            <td align="center" background="<%=approot%>/images/harismaMenuLine1.jpg" width="100%"><img src="<%=approot%>/images/harismaMenuLine1.jpg" width="8" height="8"></td>
                            <td align="right"><img src="<%=approot%>/images/harismaMenuRight1.jpg" width="8" height="8"></td>
                        </tr>
                    </table>
                </td>
            </tr>
            <%}%>
            <tr> 
                <td valign="top" align="left" width="100%"> 
                    <table border="0" cellspacing="3" cellpadding="2" id="tbl0" width="100%">
                        <tr> 
                            <td  colspan="3" valign="top" style="padding: 12px"> 
                                <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                    <tr> 
                                        <td height="20"> 
                                            <div id="menu_utama"> 
                                                <a class="btn" style="color:#FFF;" href="javascript:cmdGoBack()">Back to search</a> &nbsp; Mapping Position
                                            </div> 
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>&nbsp;</td>
                                    </tr>
                                    <tr>
                                        <td style="background-color:#EEE;" valign="top" width="100%">
                                        
                                            <table width="100%" style="padding:9px; border:1px solid <%=garisContent%>;"  border="0" cellspacing="1" cellpadding="1" class="tablecolor">
                                                <tr>
                                                    <td valign="top">
                                                        <!--- fitur filter --->
                                                        <form name="<%=FrmMappingPosition.FRM_NAME_MAPPING_POSITION%>" method="post" action="">
                                                            <input type="hidden" name="command" value="<%=iCommand%>" />
                                                            <input type="hidden" name="oid_mapping" value="<%=oidMapping%>" />
                                                            <input type="hidden" id="oid_template" name="oid_template" value="<%=oidTemplate%>" />
                                                            <input type="hidden" name="<%=frmMapping.fieldNames[FrmMappingPosition.FRM_FIELD_TEMPLATE_ID]%>" value="<%=oidTemplate%>" />
                                                            <input type="hidden" name="start" value="<%=start%>" />
                                                            <input type="hidden" name="prev_command" value="<%=prevCommand%>" />
                                                            <%
                                                            if (iCommand == Command.ASK){
                                                            %>
                                                            <div id="confirm">
                                                                <strong>Are you sure to delete item ?</strong> &nbsp;
                                                                <button id="btn1" onclick="javascript:cmdDelete('<%=oidMapping%>')">Yes</button>
                                                                &nbsp;<button id="btn1" onclick="javascript:cmdBack()">No</button>
                                                            </div>
                                                            <%
                                                            }

                                                            if (iCommand == Command.DETAIL){
                                                            %>
                                                            
                                                            <table cellspacing="0" cellpadding="0">
                                                                <tr>
                                                                    <td class="div_title_clone">Clone Data Mapping</td>
                                                                    <td align="right" class="div_close">
                                                                        <button class="btn" onclick="cmdBack()">&times;</button>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td colspan="2" class="div_clone">
                                                                        <select name="select_clone">
                                                                            <option value="0">-SELECT-</option>
                                                                            <%
                                                                            Vector listTemplate = PstStructureTemplate.list(0, 0, "", "");
                                                                            if (listTemplate != null && listTemplate.size()>0){
                                                                                for(int i=0; i<listTemplate.size(); i++){
                                                                                    StructureTemplate template = (StructureTemplate)listTemplate.get(i);
                                                                                    %>
                                                                                    <option value="<%=template.getOID()%>"><%=template.getTemplateName()%></option>
                                                                                    <%
                                                                                }
                                                                            }
                                                                            %>
                                                                        </select>
                                                                        &nbsp;<button class="btn" onclick="cmdSubmitClone()">Clone</button>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                            <% } %>
                                                            
                                                            <table>
                                                                <tr>
                                                                    <td>
                                                                        <div>&nbsp;</div>
                                                                        <a style="color:#FFF;" class="btn" href="javascript:cmdAdd()">Add Data</a>&nbsp;
                                                                        <a style="color:#FFF;" class="btn" href="javascript:cmdClone()">Clone Data</a>&nbsp;
                                                                        <a style="color:#FFF;" class="btn" href="javascript:cmdBack()">Back</a>
                                                                        <div>&nbsp;</div>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                            <%
                                                            if(iCommand == Command.ADD || iCommand == Command.EDIT){
                                                            %>
                                                            <table>
                                                                <tr>
                                                                    <td colspan="2">
                                                                        <div id="mn_utama">Form of Mapping Position</div>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td valign="middle"><strong>Up Position</strong></td>
                                                                    <td valign="middle">
                                                                        <div>&nbsp;</div>
                                                                        <input type="hidden" name="up_position" value="<%=mapping.getUpPositionId() %>" />
                                                                        <input type="hidden" name="<%=frmMapping.fieldNames[FrmMappingPosition.FRM_FIELD_UP_POSITION_ID]%>" value="<%=mapping.getUpPositionId()%>" />
                                                                        <a class="btn" style="color:#FFF;" href="javascript:cmdUpPosition()">Browse</a>&nbsp;
                                                                        <%
                                                                        if (oidUpPosition != 0){
                                                                            %>
                                                                            <span id="upposname" name="upposname" class="btn-data"><%=getPositionName(oidUpPosition)%></span>
                                                                            <%
                                                                        } else {
                                                                            //if (mapping.getUpPositionId() != 0){
                                                                                %>
                                                                                <span  id="upposname" name="upposname" class="btn-data"><%=getPositionName(mapping.getUpPositionId())%></span>
                                                                                <%
                                                                            //}
                                                                        }
                                                                        %>
                                                                        <div>&nbsp;</div>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td valign="middle"><strong>Down Position</strong></td>
                                                                    <td valign="middle">
                                                                        <div>&nbsp;</div>
                                                                        <input type="hidden" name="down_position" value="<%=mapping.getDownPositionId()%>" />
                                                                        <input type="hidden" name="<%=frmMapping.fieldNames[FrmMappingPosition.FRM_FIELD_DOWN_POSITION_ID]%>" value="<%=mapping.getDownPositionId()%>" />
                                                                        <a class="btn" style="color:#FFF;" href="javascript:cmdDownPosition()">Browse</a>&nbsp;
                                                                        <%
                                                                        if (oidDownPosition != 0){
                                                                            %>
                                                                            <span id="downposname" name="downposname" class="btn-data"><%=getPositionName(oidDownPosition)%></span>
                                                                            <%
                                                                        } else {
                                                                            //if (mapping.getDownPositionId()!=0){
                                                                                %>
                                                                                <span  id="downposname" name="downposname"  class="btn-data"><%=getPositionName(mapping.getDownPositionId())%></span>
                                                                                <%
                                                                           // }
                                                                        }
                                                                        %>
                                                                        <div>&nbsp;</div>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td valign="middle"><strong>Start Date</strong></td>
                                                                    <td valign="middle"><input type="text" id="datepicker1" name="<%=frmMapping.fieldNames[FrmMappingPosition.FRM_FIELD_START_DATE]%>" size="50" value="<%=mapping.getStartDate()%>" /></td>
                                                                </tr>
                                                                <tr>
                                                                    <td valign="middle"><strong>End Date</strong></td>
                                                                    <td valign="middle"><input type="text" id="datepicker2" name="<%=frmMapping.fieldNames[FrmMappingPosition.FRM_FIELD_END_DATE]%>" size="50" value="<%=mapping.getEndDate()%>" /></td>
                                                                </tr>
                                                                <tr>
                                                                    <td valign="middle"><strong>Type of Link</strong></td>
                                                                    <td valign="middle">
                                                                        <select name="<%=frmMapping.fieldNames[FrmMappingPosition.FRM_FIELD_TYPE_OF_LINK]%>">
                                                                            <%
                                                                            String[] arrType = {"-select-","Supervisory", "Coordination", "Leave Approval", "Schedule Change Form Approval", 
                                                                                            "EO Form Approval", "Overtime Approval Non Operasional", "Appraisal Approval", "Replacement", 
                                                                                            "Overtime Approval Operasional", "Overtime Request Operasional", "Overtime Request Non Operasional", 
                                                                                            "KPI", "KPI Achievment", "Data Change"};
                                                                            for (int t=0; t<arrType.length; t++){
                                                                                if(t == mapping.getTypeOfLink()){
                                                                                    %>
                                                                                    <option value="<%=t%>" selected="selected"><%=arrType[t]%></option>
                                                                                    <%
                                                                                } else {
                                                                                    %>
                                                                                    <option value="<%=t%>"><%=arrType[t]%></option>
                                                                                    <%
                                                                                }
                                                                            }
                                                                            %>
                                                                        </select>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td valign="middle"><strong>Only For Division</strong></td>
                                                                    <td valign="middle">
                                                                            <%
                                                                            Vector div_value = new Vector(1, 1);
                                                                            Vector div_key = new Vector(1, 1);

                                                                            div_value.add("0");
                                                                            div_key.add("All Division");
                                                                            Vector listDivision = PstDivision.list(0, 0, "VALID_STATUS=1", "");
                                                                            for (int i = 0; i < listDivision.size(); i++) {
                                                                                Division div = (Division) listDivision.get(i);
                                                                                div_key.add(div.getDivision());
                                                                                div_value.add(String.valueOf(div.getOID()));
                                                                            }
                                                                            %>
                                                                            <%= ControlCombo.draw(frmMapping.fieldNames[FrmMappingPosition.FRM_FIELD_DIVISION_ID], "chosen-select", null, "" + mapping.getDivisionId(), div_value, div_key, "")%>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td valign="middle"><strong>Vertical Line</strong></td>
                                                                    <td valign="middle">
                                                                        <input type="text" name="<%=frmMapping.fieldNames[FrmMappingPosition.FRM_FIELD_VERTICAL_LINE]%>" value="<%= mapping.getVerticalLine() %>" />
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td colspan="2">
                                                                        <div>&nbsp;</div>
                                                                        <a style="color:#FFF;" class="btn" href="javascript:cmdSave()">Save</a>&nbsp;
                                                                        <a style="color:#FFF;" class="btn" href="javascript:cmdBack()">Back</a>
                                                                        <div>&nbsp;</div>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                            <%
                                                            }
                                                            %>
                                                            <div class="search">
                                                                <div style="font-size: 12px; padding-bottom: 5px; font-family: sans-serif;">
                                                                    <input type="radio" checked="checked" onclick="putValue('0')" id="rb_position" name="rb_position" value="0" />Up Position
                                                                    <input type="radio" id="rb_position" onclick="putValue('1')" name="rb_position" value="1" />Down Position
                                                                </div>
                                                                <input style="padding: 5px 9px" type="text" name="oid_map" placeholder="Mapping Search..." size="87" onkeyup="loadList(this.value)" />
                                                            </div>  
                                                            <div>&nbsp;</div>
                                                            <div id="map_respon"></div>
                                                            <div>&nbsp;</div>
                                                            <%--<table>
                                                                <tr>
                                                                    <td valign="top">
                                                                        <div id="mn_utama">List of Position Mapping</div>
                                                                    </td>
                                                                </tr>
                                                                <%
                                                                
                                                                if ((listMapping != null && listMapping.size()>0)|| iCommand == Command.VIEW){
                                                                %>
                                                                <tr>
                                                                    <td valign="top">
                                                                        <%=drawList(listMapping)%>
                                                                    </td>
                                                                </tr>
                                                                <%
                                                                } else {
                                                                %>
                                                                <tr>
                                                                    <td valign="top">
                                                                        No record found
                                                                    </td>
                                                                </tr>
                                                                <%
                                                                }
                                                                
                                                                %>
                                                                
                                                                <tr>
                                                                    <td valign="top">
                                                                        <span class="command"> 
                                                                            <%
                                                                                int cmd = 0;
                                                                                if ((iCommand == Command.FIRST || iCommand == Command.PREV)
                                                                                        || (iCommand == Command.NEXT || iCommand == Command.LAST)) {
                                                                                    cmd = iCommand;
                                                                                } else {
                                                                                    if (iCommand == Command.NONE || prevCommand == Command.NONE) {
                                                                                        cmd = Command.FIRST;
                                                                                    } else {
                                                                                        if ((iCommand == Command.SAVE) && (iErrCode == FRMMessage.NONE) && (oidMapping== 0)) {
                                                                                            cmd = PstMappingPosition.findLimitCommand(start, recordToGet, vectSize);
                                                                                        } else {
                                                                                            cmd = prevCommand;
                                                                                        }
                                                                                    }
                                                                                }
                                                                            %>
                                                                            <%
                                                                                ctrLine.setLocationImg(approot + "/images");
                                                                                ctrLine.initDefault();
                                                                            %>
                                                                            <%=ctrLine.drawImageListLimit(cmd, vectSize, start, recordToGet)%> 
                                                                        </span>
                                                                    </td>
                                                                </tr>
                                                            </table>--%>
                                                                <%
                                                                
                                                                StructureTemplate template = new StructureTemplate();
                                                                try{
                                                                    template = PstStructureTemplate.fetchExc(oidTemplate);
                                                                } catch (Exception exc){}
                                                                
                                                                if (((listMapping != null && listMapping.size()>0)|| iCommand == Command.VIEW) && (!template.getTemplateDesc().equals("") && !template.getTemplateDesc().equals("-"))){
                                                                %>
                                                                <div id="mn_utama">View of Structure</div>
                                                                <table>
                                                                    <tr>
                                                                        <td valign="top">
                                                                            <%
                                                                            String whereMap = PstMappingPosition.fieldNames[PstMappingPosition.FLD_TEMPLATE_ID]+"="+oidTemplate;
                                                                            Vector listMap = PstMappingPosition.list(0, 0, whereMap, "");
                                                                            int checkUp = 0;
                                                                            long topMain = 0;
                                                                            if (listMap != null && listMap.size()>0){
                                                                                long[] arrUp = new long[listMap.size()];
                                                                                long[] arrDown = new long[listMap.size()];
                                                                                for(int i=0; i<listMap.size(); i++){
                                                                                    MappingPosition map = (MappingPosition)listMap.get(i);
                                                                                    arrUp[i] = map.getUpPositionId();
                                                                                    arrDown[i] = map.getDownPositionId();
                                                                                }
                                                                                for(int j=0; j<arrUp.length; j++){
                                                                                    for(int k=0; k<arrDown.length; k++){
                                                                                        if (arrUp[j] == arrDown[k]){
                                                                                            checkUp++;
                                                                                        }
                                                                                    }
                                                                                    if (checkUp == 0){
                                                                                        topMain = arrUp[j];
                                                                                    }
                                                                                    checkUp = 0;
                                                                                }

                                                                                if (topMain > 0){
                                                                                    %>
                                                                                    <table class="tblStyle1">
                                                                                        <tr>
                                                                                            <td>
                                                                                                <img height="64" id="photo" src="<%=approot%>/imgcache/no-img.jpg" />
                                                                                                <div style="color: #373737;">
                                                                                                    Nama Karyawan
                                                                                                </div>
                                                                                                <%=getPositionName(topMain)%>
                                                                                                <%=getDrawDownPosition(topMain,oidTemplate,approot)%>
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                    <%
                                                                                }
                                                                            }
                                                                            %>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                                <% } %>
                                                        </form>

                                                        
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>&nbsp;</td>
                                                </tr>
                                                <tr>
                                                    <td>&nbsp;</td>
                                                </tr>
                                            </table>
                                        
                                        </td>
                                    </tr>
                                </table><!---End Tble--->
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
        <table>
            <tr>
                <td>&nbsp;</td>
            </tr>
            <%if (headerStyle && !verTemplate.equalsIgnoreCase("0")) {%>
            <tr>
                <td valign="bottom">
                    <!-- untuk footer -->
                    <%@include file="../footer.jsp" %>
                </td>
                            
            </tr>
            <%} else {%>
            <tr> 
                <td colspan="2" height="20" > <!-- #BeginEditable "footer" --> 
                    <%@ include file = "../main/footer.jsp" %>
                    <!-- #EndEditable --> </td>
            </tr>
            <%}%>
        </table>
    </body>
</html>
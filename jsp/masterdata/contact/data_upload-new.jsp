<%-- 
    Document   : data_upload
    Created on : Feb 27, 2016, 10:49:52 AM
    Author     : khirayinnura
--%>

<%@page import="com.dimata.harisma.entity.admin.AppObjInfo"%>
<%@page import="com.dimata.gui.jsp.ControlCombo"%>
<%@page import="com.dimata.system.entity.dataupload.*"%>
<%@page import="com.dimata.system.form.dataupload.*"%>
<%@page import="com.dimata.gui.jsp.ControlList"%>
<%@page import="com.dimata.util.Command"%>
<%@page import="com.dimata.system.entity.dataupload.*"%>
<%@page import="com.dimata.system.form.dataupload.*"%>
<%@page import="java.util.Vector"%>
<%@page import="com.dimata.gui.jsp.ControlLine"%>
<%@page import="com.dimata.qdep.form.FRMMessage"%>
<%@page import="com.dimata.qdep.form.FRMQueryString"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file = "../../main/javainit.jsp" %>
<% int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_TRAINING, AppObjInfo.G2_TRAINING_PROGRAM, AppObjInfo.OBJ_MENU_TRAINING_PROGRAM);%>
<%@ include file = "../../main/checkuser.jsp" %>

<%
    int iCommand = FRMQueryString.requestCommand(request);
    int start = FRMQueryString.requestInt(request, "start");
    int prevCommand = FRMQueryString.requestInt(request, "prev_command");
    long oidDataMain = FRMQueryString.requestLong(request, "data_main_oid");
    long oidDataDetail = FRMQueryString.requestLong(request, "data_detail_oid");
    long oidObject = FRMQueryString.requestLong(request, "object_id"); //oid dari object misal: modul family member, maka oid family member yang diambil
    String className = FRMQueryString.requestString(request, "classname");
    long oidTraining = FRMQueryString.requestLong(request, "training_id");
    String trainTitle = FRMQueryString.requestString(request, "training_title");


    /*variable declaration*/
    int recordToGet = 10;
    String msgString = "";
    //int iErrCode = FRMMessage.NONE;
    int iErrCode = FRMMessage.NONE;
    String whereClause = "DATA_MAIN_ID="+oidDataMain;
    String orderClause = PstDataUploadDetail.fieldNames[PstDataUploadDetail.FLD_DATA_DETAIL_TITLE];
    
    //CtrlDataUploadMain ctrlDataUploadMain = new CtrlDataUploadMain(request);
    CtrlDataUploadDetail ctrlDataUploadDetail = new CtrlDataUploadDetail(request);
    ControlLine ctrLine = new ControlLine();
   // Vector listDataUploadMain = new Vector(1, 1);
    Vector listDataUploadDetail = new Vector(1, 1);

    /*switch statement */
    //iErrCode = ctrlDataUploadMain.action(iCommand, oidDataMain);
    iErrCode = ctrlDataUploadDetail.action(iCommand, oidDataDetail);
    /* end switch*/
    FrmDataUploadDetail frmDataUploadDetail = ctrlDataUploadDetail.getForm();

    DataUploadDetail dataUploadDetail = ctrlDataUploadDetail.getDataUploadDetail();
    msgString = ctrlDataUploadDetail.getMessage();


    /*switch list CareerPath*/
    if ((iCommand == Command.SAVE) && (iErrCode == FRMMessage.NONE) && (oidDataDetail == 0)) {
        start = PstDataUploadDetail.findLimitStart(dataUploadDetail.getOID(), recordToGet, whereClause, orderClause);
    }

    /*count list All CareerPath*/
    int vectSize = PstDataUploadDetail.getCount(whereClause);

    if ((iCommand == Command.FIRST || iCommand == Command.PREV)
            || (iCommand == Command.NEXT || iCommand == Command.LAST)) {
        start = ctrlDataUploadDetail.actionList(iCommand, start, vectSize, recordToGet);
    }
    /* end switch list*/

    /* get record to display */
    listDataUploadDetail = PstDataUploadDetail.list(start, recordToGet, whereClause, orderClause);

    /*handle condition if size of record to display = 0 and start > 0 	after delete*/
    if (listDataUploadDetail.size() < 1 && start > 0) {
        if (vectSize - recordToGet > recordToGet) {
            start = start - recordToGet;   //go to Command.PREV
        } else {
            start = 0;
            iCommand = Command.FIRST;
            prevCommand = Command.FIRST; //go to Command.FIRST
        }
        listDataUploadDetail = PstDataUploadMain.list(start, recordToGet, whereClause, orderClause);
    }

%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

        <link rel="stylesheet" href="../../styles/colorbox.css" />
        <script src="../../javascripts/jquery.min.js"></script>
        <script src="../../javascripts/jquery.colorbox.js"></script>

        <!-- #BeginEditable "styles" -->
        <link rel="stylesheet" href="../../styles/main.css" type="text/css">
        <!-- #EndEditable -->
        <!-- #BeginEditable "stylestab" -->
        <link rel="stylesheet" href="../../styles/tab.css" type="text/css">
        <!-- #EndEditable -->
                
        <script type="text/javascript">
            function cmdAdd(){
                //document.frm_data_upload.object_id.value=idClass;
                document.frm_data_upload.command.value="<%=Command.ADD%>";
                document.frm_data_upload.action="data_upload-new.jsp";
                document.frm_data_upload.submit();
            }
            
            function cmdSave(){
                document.frm_data_upload.command.value="<%=Command.SAVE%>";
                document.frm_data_upload.action="data_upload-new.jsp?training_id="+document.getElementById("training_id").value
                    +"&data_main_oid="+document.getElementById("data_main_oid").value
                    +"&training_title="+document.getElementById("training_title").value;
                document.frm_data_upload.submit();
            }

            function cmdEdit(oidDataDetail){
                document.frm_data_upload.data_detail_oid.value=oidDataDetail;
                document.frm_data_upload.command.value="<%=Command.EDIT%>";
                document.frm_data_upload.action="data_upload-new.jsp";
                document.frm_data_upload.submit();
            }

            function cmdCancel(oidDataDetail){
                document.frm_data_upload.data_detail_oid.value=oidDataDetail;
                document.frm_data_upload.command.value="<%=Command.NONE%>";
                document.frm_data_upload.cmd.value="<%=Command.NONE%>";
                document.frm_data_upload.prev_command.value="<%=prevCommand%>";
                document.frm_data_upload.action="data_upload-new.jsp";
                document.frm_data_upload.submit();
            }
            
            function cmdAsk(oid){
                document.getElementById("data_detail_oid").value=oid;
                document.getElementById("confirm").style.visibility="visible";
            }

            function cmdNoDel(){
                document.getElementById("data_detail_oid").value="0";
                document.getElementById("confirm").style.visibility="hidden";
            }
            
            function cmdDelete(){
                var oid = document.getElementById("data_detail_oid").value;
                document.frm_data_upload.data_detail_oid.value=oid;
                document.frm_data_upload.command.value="<%=Command.DELETE%>";
                document.frm_data_upload.action="data_upload-new.jsp";
                document.frm_data_upload.submit();
            }
            function cmdBack(mainId){
                document.frm_data_upload.command.value="<%=Command.NONE%>";
                document.frm_data_upload.action="data_upload-new.jsp?training_id="+document.getElementById("training_id").value
                    +"&data_main_oid="+document.getElementById("data_main_oid").value
                    +"&training_title="+document.getElementById("training_title").value;
                document.frm_data_upload.submit();
            }
            function upload(i){
                //alert("asd");
                document.frm_data_upload.action="upload_pict_detail.jsp?command=3&training_id="+document.getElementById("training_id").value
                    +"&data_main_oid="+document.getElementById("data_main_oid").value
                    +"&training_title="+document.getElementById("training_title").value
                    +"&data_detail_oid="+document.getElementById("idDetail_"+i).value;
                //alert("asd"+document.getElementById("idDetail_"+i).value);
                document.frm_data_upload.submit();
            }
        </script>
        <style type="text/css">
            .tblStyle {border-collapse: collapse;font-size: 11px;}
            .tblStyle .td {padding: 3px 5px; border: 1px solid #CCC; }
            .title_tbl {font-weight: bold;background-color: #DDD; color: #575757;}

            .title_tbl_part {
                font-weight: bold;
                background-color: #EEE; 
                /*color: #08aad2;*/
            }
            .title_tbl_part_sub {
                font-weight: bold;
                background-color: #EEE; 
                color: #729a13;
            }
            body {color:#373737;}
            #menu_utama {padding: 9px 14px; border-left: 1px solid #0099FF; font-size: 14px; background-color: #F3F3F3;}
            #menu_title {color:#0099FF; font-size: 14px; font-weight: bold;}
            #menu_teks {color:#CCC;}
            #box_title {padding:9px; background-color: #D5D5D5; font-weight: bold; color:#575757; margin-bottom: 7px; }
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

            .breadcrumb {
                background-color: #EEE;
                color:#0099FF;
                padding: 7px 9px;
            }
            .navbar {
                font-family: sans-serif;
                font-size: 12px;
                background-color: #0084ff;
                padding: 7px 9px;
                color : #FFF;
                border-top:1px solid #0084ff;
                border-bottom: 1px solid #0084ff;
            }
            .navbar ul {
                list-style-type: none;
                margin: 0;
                padding: 0;
            }

            .navbar li {
                padding: 7px 9px;
                display: inline;
                cursor: pointer;
            }

            .navbar li:hover {
                background-color: #0b71d0;
                border-bottom: 1px solid #033a6d;
            }

            .active {
                background-color: #0b71d0;
                border-bottom: 1px solid #033a6d;
            }
            .title_part {color:#FF7E00; background-color: #F7F7F7; border-left: 1px solid #0099FF; padding: 9px 11px;}
           
            #confirm {
                font-size: 12px;
                padding: 7px 0px 8px 15px;
                background-color: #FF6666;
                color: #FFF;
                visibility: hidden;
            }
            #btn-confirm-y {
                padding: 7px 15px 8px 15px;
                background-color: #F25757; color: #FFF; 
                font-size: 12px; cursor: pointer;
            }
            #btn-confirm-n {
                padding: 7px 15px 8px 15px;
                background-color: #E34949; color: #FFF; 
                font-size: 12px; cursor: pointer;
            }
        </style>
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
                background-color: #EEE;
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
            .btn-small {
                padding: 3px; border: 1px solid #CCC; 
                background-color: #EEE; color: #777777; 
                font-size: 11px; cursor: pointer;
            }
            .btn-small:hover {border: 1px solid #999; background-color: #CCC; color: #FFF;}

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
            .footer-page {

            }

            .bg-status {
                padding: 5px;
                background-color: #DFF0D8;
            }

            /*dropdown*/
            .dropdown {
                color:#08aad2;
                background-color: white;
                padding: 5px 7px;
                border-radius: 3px;
                border:1px solid #CCC;
                position: relative;
                display: inline-block;
            }

            .dropdown-content {
                display: none;
                position: absolute;
                background-color: #FFF;
                min-width: 160px;
                box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2);
                padding: 5px 0px;
                z-index: 1;
                border-radius: 3px;
                border:1px solid #999;
            }

            .dropdown:hover .dropdown-content {
                display: block;
            }
            #div_drop {
                padding: 5px 9px;
            }
            #div_drop:hover {
                color: #237C99;
                background-color: #E5E5E5;
            }
            #div_drop a{
                color: #2A87B5;
            }
            .info {
                background-color: #EEE;
                padding: 21px;
            }
        </style>
    </head>
<body>
    <div>
        <form name="frm_data_upload" method ="post">
            <input type="hidden" name="command" value="<%=iCommand%>"> 
            <input type="hidden" name="vectSize" value="<%=vectSize%>">
            <input type="hidden" name="start" value="<%=start%>">
            <input type="hidden" name="prev_command" value="<%=prevCommand%>">
            <input type="hidden" id="data_main_oid" name="data_main_oid" value="<%=oidDataMain%>">
            <input type="hidden" id="data_detail_oid" name="data_detail_oid" value="<%=oidDataDetail%>">
            <input type="hidden" id="training_id" name="training_id" value="<%=oidTraining%>">
            <input type="hidden" id="training_title" name="training_title" value="<%=trainTitle%>">
            
            <div class="content-main">
                <div class="content">
                    <div>
                        <h3>Data Upload</h3>
                    </div>
                    
                    <div class="info">
                        <% if(oidTraining != 0){
                            String typeName = "-";
                            Training objTraining = new Training();

                            try{
                                 objTraining = PstTraining.fetchExc(oidTraining);
                                 TrainType trainType = PstTrainType.fetchExc(objTraining.getType());
                                 typeName = trainType.getTypeName();
                            }catch(Exception exc){
                                 objTraining = new Training();
                            }
                        %>

                            <table>
                              <tr> 
                                <td><strong>Training Name </strong></td>
                                <td>:</td>
                                <td><strong><%=objTraining.getName()%></strong></td>
                              </tr>
                              <tr> 
                                <td><strong>Training Type</strong></td>
                                <td>:</td>
                                <td><strong><%= typeName %></strong></td>
                              </tr>
                              <tr> 
                                <td><strong>Description</strong></td>
                                <td>:</td>
                                <td><strong><%=objTraining.getDescription()%></strong></td>
                              </tr>
                              <tr>
                                  <td><strong>Training Title</strong></td>
                                  <td>:</td>
                                  <td><strong><%=trainTitle%></strong></td>
                              </tr>
                            </table>
                        <%}%>
                    </div>

                    <div>
                        </br>
                        <span id="confirm">Are you sure to delete data ? <a id="btn-confirm-y" href="javascript:cmdDelete()">Yes</a><a id="btn-confirm-n" href="javascript:cmdNoDel()">No</a></span>
                        </br>
                        <%
                        if(privUpdate){
                        %>
                        <table width="100%" cellspacing="1" cellpadding="1" class="tblStyle td">
                            <tr>
                                <td valign="top" class="title_tbl td">No.</td>
                                <td valign="top" class="title_tbl td">Title</td>
                                <td valign="top" class="title_tbl td">Description</td>
                                <td valign="top" class="title_tbl td">Filename</td>
                            </tr>
                            <%
                                for (int i = 0; i < listDataUploadDetail.size(); i++) {
                                    DataUploadDetail dataUploadDetail2 = (DataUploadDetail) listDataUploadDetail.get(i);

                                    // listDataUploadDetail = PstDataUploadDetail.list(0, 0, "DATA_MAIN_ID="+dataUploadMain.getOID(), "");

                                    String btn = "<div class=\"dropdown\">";
                                    btn += "<span><strong>" + dataUploadDetail2.getDataDetailTitle() + "</strong></span>";
                                    btn += "<div class=\"dropdown-content\">";
                                    btn += "<div id=\"div_drop\"><a href=\"javascript:cmdEdit('" + dataUploadDetail2.getOID() + "')\">Edit</a></div>";
                                    btn += "<div id=\"div_drop\"><a href=\"javascript:cmdAsk('"+dataUploadDetail2.getOID()+"')\">Delete</a></div>";
                                    //  btn +=   "<div id=\"div_drop\" ><a class=\"modul\" href=\"data_upload_Detail.jsp\">Upload</a></div>";
                                    btn += "</div>";
                                    btn += "</div>";
                            %>
                            <%if (iCommand == Command.EDIT && oidDataDetail == dataUploadDetail2.getOID()) {%>
                            <tr>
                                <td class="title_tbl_part td"><%=i+1%></td>
                                <td class="title_tbl_part td">
                                    <input type="hidden" name="<%=FrmDataUploadDetail.fieldNames[FrmDataUploadDetail.FRM_FIELD_DATA_MAIN_ID]%>"  value="<%=oidDataMain%>" class="formElemen">
                                    <input type="text" name="<%=FrmDataUploadDetail.fieldNames[FrmDataUploadDetail.FRM_FIELD_DATA_DETAIL_TITLE]%>"  value="<%=dataUploadDetail2.getDataDetailTitle()%>" class="formElemen">
                                </td>
                                <td class="title_tbl_part td"><textarea name="<%=FrmDataUploadDetail.fieldNames[FrmDataUploadDetail.FRM_FIELD_DATA_DETAIL_DESC]%>" class="elemenForm" cols="30" rows="3"><%=dataUploadDetail2.getDataDetailDesc()%></textarea></td>
                                <td class="title_tbl_part td"></td>
                            </tr>
                            <%} else {%>
                            <tr>
                                <td class="title_tbl_part td"><%=i+1%>
                                <input type="hidden" id="idDetail_<%=i+1%>" name="idDetail"  value="<%=dataUploadDetail2.getOID()%>" class="formElemen">
                                </td>
                                <%if (iCommand == Command.EDIT) {%>
                                <td class="title_tbl_part td"><%=dataUploadDetail2.getDataDetailTitle()%></td>
                                <%}else{%>
                                <td class="title_tbl_part td"><%=btn%></td>
                                <%}%>
                                <td class="title_tbl_part td"><%=dataUploadDetail2.getDataDetailDesc()%></td>
                                <td class="title_tbl_part td"><a href="javascript:upload(<%=i+1%>)">Upload</a></br><a href="<%=approot%>/imgdoc/<%=dataUploadDetail2.getFilename()%>"><%=dataUploadDetail2.getFilename()%></a></td>
                            </tr>

                            <%}%>

                            <%
                                }
                            %>
                            <% if (iCommand == Command.ADD) {%>
                            <tr>
                                <td class="title_tbl_part td"></td>
                                <td class="title_tbl_part td">
                                    <input type="hidden" name="<%=FrmDataUploadDetail.fieldNames[FrmDataUploadDetail.FRM_FIELD_DATA_MAIN_ID]%>"  value="<%=oidDataMain%>" class="formElemen">
                                    <input type="text" name="<%=FrmDataUploadDetail.fieldNames[FrmDataUploadDetail.FRM_FIELD_DATA_DETAIL_TITLE]%>"  value="" class="formElemen">
                                </td>
                                <td class="title_tbl_part td"><textarea name="<%=FrmDataUploadDetail.fieldNames[FrmDataUploadDetail.FRM_FIELD_DATA_DETAIL_DESC]%>" class="elemenForm" cols="30" rows="3"></textarea></td>
                                <td class="title_tbl_part td"></td>
                            </tr>
                            <%}%>
                        </table>
                        <% } else { %>
                        
                        <table width="100%" cellspacing="1" cellpadding="1" class="tblStyle td">
                            <tr>
                                <td valign="top" class="title_tbl td">No.</td>
                                <td valign="top" class="title_tbl td">Title</td>
                                <td valign="top" class="title_tbl td">Description</td>
                                <td valign="top" class="title_tbl td">Filename</td>
                            </tr>
                            <%
                                for (int i = 0; i < listDataUploadDetail.size(); i++) {
                                    DataUploadDetail dataUploadDetail2 = (DataUploadDetail) listDataUploadDetail.get(i);

                                    // listDataUploadDetail = PstDataUploadDetail.list(0, 0, "DATA_MAIN_ID="+dataUploadMain.getOID(), "");

                                    String btn = "<div class=\"dropdown\">";
                                    btn += "<span><strong>" + dataUploadDetail2.getDataDetailTitle() + "</strong></span>";
                                    btn += "<div class=\"dropdown-content\">";
                                    btn += "<div id=\"div_drop\"><a href=\"javascript:cmdEdit('" + dataUploadDetail2.getOID() + "')\">Edit</a></div>";
                                    btn += "<div id=\"div_drop\"><a href=\"javascript:cmdAsk('"+dataUploadDetail2.getOID()+"')\">Delete</a></div>";
                                    //  btn +=   "<div id=\"div_drop\" ><a class=\"modul\" href=\"data_upload_Detail.jsp\">Upload</a></div>";
                                    btn += "</div>";
                                    btn += "</div>";
                            %>
                            <%if (iCommand == Command.EDIT && oidDataDetail == dataUploadDetail2.getOID()) {%>
                            <tr>
                                <td class="title_tbl_part td"><%=i+1%></td>
                                <td class="title_tbl_part td">
                                    <input type="hidden" name="<%=FrmDataUploadDetail.fieldNames[FrmDataUploadDetail.FRM_FIELD_DATA_MAIN_ID]%>"  value="<%=oidDataMain%>" class="formElemen">
                                    <input type="text" name="<%=FrmDataUploadDetail.fieldNames[FrmDataUploadDetail.FRM_FIELD_DATA_DETAIL_TITLE]%>"  value="<%=dataUploadDetail2.getDataDetailTitle()%>" class="formElemen">
                                </td>
                                <td class="title_tbl_part td"><textarea name="<%=FrmDataUploadDetail.fieldNames[FrmDataUploadDetail.FRM_FIELD_DATA_DETAIL_DESC]%>" class="elemenForm" cols="30" rows="3"><%=dataUploadDetail2.getDataDetailDesc()%></textarea></td>
                                <td class="title_tbl_part td"></td>
                            </tr>
                            <%} else {%>
                            <tr>
                                <td class="title_tbl_part td"><%=i+1%></td>
                                <td class="title_tbl_part td"><%=dataUploadDetail2.getDataDetailTitle()%></td>
                                <td class="title_tbl_part td"><%=dataUploadDetail2.getDataDetailDesc()%></td>
                                <td class="title_tbl_part td"><a href="<%=approot%>/imgdoc/<%=dataUploadDetail2.getFilename()%>"><%=dataUploadDetail2.getFilename()%></a></td>
                            </tr>

                            <%}%>

                            <%
                                }
                            %>
                            
                        </table>
                        <% } %>
                    </div>
                    <!--%=drawList(iCommand, listDataUploadMain, oidDataMain, oidObject, className)%-->
                    </br>
                    <% if(privUpdate) { %>
                    <div>
                        <%if (listDataUploadDetail.size() < 1) {%>
                        <p id="title-small" class="bg-status">
                            Not Any Data 
                        <p>
                            <%}%>
                            <%if (iCommand == Command.ADD || iCommand == Command.EDIT) {%>
                            <a style="color:#FFF" class="btn" href="javascript:cmdSave()">Save</a>&nbsp;<a style="color:#FFF" class="btn" href="javascript:cmdBack(<%=oidDataMain%>)">Batal</a>
                            <%} else {%>
                        <p style="margin-top: 2px"><a style="color:#FFF" class="btn" href="javascript:cmdAdd()">Tambah Data</a></p>
                        <%}%>
                        </br>
                        
                    </div>
                    <% } %>
                </div>
            </div>
            </form>
        </div>
    </body>
</html>

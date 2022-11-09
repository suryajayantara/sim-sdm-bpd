<%-- 
    Document   : setup_jv
    Created on : Dec 13, 2016, 9:27:53 AM
    Author     : Dimata 007
--%>

<%@page import="com.dimata.qdep.db.DBHandler"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_DOKUMEN_SURAT, AppObjInfo.G2_MASTER_DOCUMENT, AppObjInfo.OBJ_DOCUMENT_MASTER);%>
<%@ include file = "../main/checkuser.jsp" %>
<!DOCTYPE html>
<%
    int iCommand = FRMQueryString.requestCommand(request);
    int commandCustom = FRMQueryString.requestInt(request, "command_custom");
    String codeDiv = FRMQueryString.requestString(request, "code_div");
    String codeComp = FRMQueryString.requestString(request, "code_comp");
    long oidDivCode = FRMQueryString.requestLong(request, "oid_div_code");
    long oidCompCode = FRMQueryString.requestLong(request, "oid_comp_code");
    String groupCodeDiv = FRMQueryString.requestString(request, "group_code_div");
    String whereClause = "";
/*
 * command custom = 1 | add code div
 * command custom = 2 | save code div
 */
    if (commandCustom == 2){
        DivisionCodeJv divCode = new DivisionCodeJv();
        divCode.setDivisionCode(codeDiv);
        try {
            PstDivisionCodeJv.insertExc(divCode);
        } catch (Exception e){
            System.out.println(e.toString());
        }
    }
    
    if (commandCustom == 4){
        ComponentCodeJv compCodeJv = new ComponentCodeJv();
        compCodeJv.setCompCode(codeComp);
        try {
            PstComponentCodeJv.insertExc(compCodeJv);
        } catch (Exception e){
            System.out.println(e.toString());
        }
    }
    
    if (commandCustom == 5){
        if (oidDivCode != 0){
            try {
                PstDivisionCodeJv.deleteExc(oidDivCode);
                String sql = "DELETE FROM hr_division_map_jv WHERE DIVISION_CODE_ID="+oidDivCode;
                DBHandler.execUpdate(sql);
            } catch (Exception e){
                System.out.println(e.toString());
            }
        }
    }
    if (commandCustom == 6){
        if (oidCompCode != 0){
            try {
                PstComponentCodeJv.deleteExc(oidCompCode);
                String sql = "DELETE FROM hr_component_map_jv WHERE COMP_CODE_ID="+oidCompCode;
                DBHandler.execUpdate(sql);
            } catch (Exception e){
                System.out.println(e.toString());
            }
        }
    }
    if (commandCustom == 8){
        DivisionGroupJV divGroupCode = new DivisionGroupJV();
        divGroupCode.setDivisionGroup(groupCodeDiv);
        try {
            PstDivisionGroupJV.insertExc(divGroupCode);
        } catch (Exception e){
            System.out.println(e.toString());
        }
    }
    /* List of Division Code and Component Code */
    Vector divCodeList = PstDivisionCodeJv.list(0, 0, "", "");
    Vector compCodeList = PstComponentCodeJv.list(0, 0, "", "");
    Vector groupDivList = PstDivisionGroupJV.list(0, 0, "", "");
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Setup Jurnal Voucher</title>
        <link rel="stylesheet" href="../styles/main.css" type="text/css">
        <style type="text/css">
            .tblStyle {border-collapse: collapse; font-size: 12px;}
            .tblStyle td {padding: 7px 9px; border: 1px solid #DDD; font-size: 12px;}
            .title_tbl {font-weight: bold;background-color: #DDD; color: #575757;}
            .title_page {color:#0db2e1; font-weight: bold; font-size: 14px; background-color: #EEE; border-left: 1px solid #0099FF; padding: 12px 18px;}

            body {color:#373737;}
            #menu_utama {padding: 9px 14px; border-left: 1px solid #0099FF; font-size: 14px; background-color: #F3F3F3;}
            #menu_title {color:#0099FF; font-size: 14px;}
            #menu_teks {color:#CCC;}
            
            #btn {
              background: #CCC;
              border-radius: 3px;
              font-family: Arial;
              color: #575757;
              font-size: 12px;
              padding: 4px 9px 4px 9px;
            }

            #btn:hover {
              color: #474747;
              background: #FFF;
            }
            .title_part {color:#FF7E00; background-color: #F7F7F7; border-left: 1px solid #0099FF; padding: 9px 11px;}
            
            body {background-color: #EEE;}
            .header {
                
            }
            .content-main {
                padding: 21px 32px;
                margin: 0px 23px 59px 23px;
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
            .box {
                margin: 7px;
                padding: 9px 12px;
                background-color: #FFF;
                color:#575757;
            }
            #box_title {
                padding:21px; 
                font-size: 14px; 
                color: #007fba;
                border-top: 1px solid #28A7D1;
                border-bottom: 1px solid #EEE;
            }
            #box_content {
                padding:21px; 
                font-size: 12px;
                color: #575757;
            }
            .box-info {
                padding:21px 43px; 
                background-color: #F7F7F7;
                border-bottom: 1px solid #CCC;
                -webkit-box-shadow: 0 1px 4px rgba(0, 0, 0, 0.065);
                 -moz-box-shadow: 0 1px 4px rgba(0, 0, 0, 0.065);
                      box-shadow: 0 1px 4px rgba(0, 0, 0, 0.065);
            }
            #title-info-name {
                padding: 11px 15px;
                font-size: 35px;
                color: #535353;
            }
            #title-info-desc {
                padding: 7px 15px;
                font-size: 21px;
                color: #676767;
            }
            
            #photo {
                padding: 7px; 
                background-color: #FFF; 
                border: 1px solid #DDD;
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
                font-family: sans-serif;
                text-decoration: none;
                padding: 5px 7px; 
                background-color: #EEE; color: #575757; 
                font-size: 11px; cursor: pointer;
                border-radius: 3px;
                border: 1px solid #DDD;
            }
            .btn-small:hover { background-color: #DDD; color: #474747;}
            
            .btn-small-1 {
                font-family: sans-serif;
                text-decoration: none;
                padding: 5px 7px; 
                background-color: #EEE; color: #575757; 
                font-size: 11px; cursor: pointer;
                border-radius: 3px;
            }
            .btn-small-1:hover { background-color: #DDD; color: #474747;}
            
            .tbl-main {border-collapse: collapse; font-size: 11px; background-color: #FFF; margin: 0px;}
            .tbl-main td {padding: 4px 7px; border: 1px solid #DDD; }
            #tbl-title {font-weight: bold; background-color: #F5F5F5; color: #575757;}
            
            .tbl-small {border-collapse: collapse; font-size: 11px; background-color: #FFF;}
            .tbl-small td {padding: 2px 3px; border: 1px solid #DDD; }
            
            #caption {
                font-size: 12px;
                color: #474747;
                font-weight: bold;
                padding: 2px 0px 3px 0px;
            }
            #divinput {
                margin-bottom: 5px;
                padding-bottom: 5px;
            }
            
            #div_item_sch {
                background-color: #EEE;
                color: #575757;
                padding: 5px 7px;
            }
            
            #record_count{
                font-size: 12px;
                font-weight: bold;
                padding-bottom: 9px;
            }
            #box-form {
                background-color: #EEE; 
                border-radius: 5px;
            }
            .formstyle {
                background-color: #FFF;
                padding: 21px;
                border-radius: 3px;
                margin: 3px 0px;
            }
            .form-style {
                font-size: 12px;
                color: #575757;
                border: 1px solid #DDD;
                border-radius: 5px;
            }
            .form-title {
                padding: 11px 21px;
                text-align: left;
                border-bottom: 1px solid #DDD;
                background-color: #FFF;
                border-top-left-radius: 5px;
                border-top-right-radius: 5px;
                font-weight: bold;
            }
            .form-content {
                text-align: left;
                padding: 21px;
                background-color: #DDD;
            }
            .form-footer {
                border-top: 1px solid #DDD;
                padding: 11px 21px;
                background-color: #FFF;
                border-bottom-left-radius: 5px;
                border-bottom-right-radius: 5px;
            }
            #confirm {
                padding: 5px 7px;
                background-color: #FF6666;
                color: #FFF;
                border-radius: 3px;
                font-size: 12px;
                font-weight: bold;
                margin-bottom: 5px;
            }
            #btn-confirm {
                padding: 3px 5px; border-radius: 2px;
                background-color: #CF5353; color: #FFF; 
                font-size: 11px; cursor: pointer;
            }
            .footer-page {
                font-size: 12px;
            }
            .btn-small-e {
                font-family: sans-serif;
                text-decoration: none;
                padding: 3px 5px; 
                margin: 2px;
                background-color: #92C8E8; color: #F5F5F5; 
                font-size: 11px; cursor: pointer;
                border-radius: 3px;
                border: 1px solid #92C8E8;
            }
            .btn-small-e:hover { background-color: #659FC2; border: 1px solid #659FC2; color: #FFF;}
            
            .btn-small-x {
                font-family: sans-serif;
                text-decoration: none;
                padding: 3px 5px; 
                margin: 2px;
                background-color: #EB9898; color: #F5F5F5; 
                font-size: 11px; cursor: pointer;
                border-radius: 3px;
                border: 1px solid #EB9898;
            }
            .btn-small-x:hover { background-color: #D14D4D; border: 1px solid #D14D4D; color: #FFF;}
            .box-input {
                background-color: #DDD;
                padding: 7px;
                margin: 5px 0px;
            }
        </style>
        <script type="text/javascript">
            function cmdAddCodeDiv(){
                document.frm.command_custom.value="1";
                document.frm.action="";
                document.frm.submit();
            }

            function cmdSaveCodeDiv(){
                document.frm.command_custom.value="2";
                document.frm.action="";
                document.frm.submit();
            }

            function cmdCancelCodeDiv(){
                document.frm.command_custom.value="0";
                document.frm.action="";
                document.frm.submit();
            }

            function cmdAddCodeComp(){
                document.frm.command_custom.value="3";
                document.frm.action="";
                document.frm.submit();
            }

            function cmdSaveCodeComp(){
                document.frm.command_custom.value="4";
                document.frm.action="";
                document.frm.submit();
            }

            function cmdCancelCodeComp(){
                document.frm.command_custom.value="0";
                document.frm.action="";
                document.frm.submit();
            }
            
            function cmdAddGroupDiv(){
                document.frm.command_custom.value="7";
                document.frm.action="";
                document.frm.submit();
            }
            
            function cmdSaveGroupDiv(){
                document.frm.command_custom.value="8";
                document.frm.action="";
                document.frm.submit();
            }
            
            function cmdAddDivision(oid){
                window.open("<%=approot%>/masterdata/setup_jv_division.jsp?oid_div_code="+oid, null, "height=270,width=570, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");
            }
            
            function cmdAddComp(oid){
                window.open("<%=approot%>/masterdata/setup_jv_comp.jsp?oid_comp_code="+oid, null, "height=300,width=550, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");
            }
            
            function cmdDelAllDiv(oid){
                document.frm.command_custom.value="5";
                document.frm.oid_div_code.value=oid;
                document.frm.action="";
                document.frm.submit();
            }
            
            function cmdDelAllComp(oid){
                document.frm.command_custom.value="6";
                document.frm.oid_comp_code.value=oid;
                document.frm.action="";
                document.frm.submit();
            }
        </script>
    </head>
    <body>
        <div class="header">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <%if (headerStyle && !verTemplate.equalsIgnoreCase("0")) {%> 
            <%@include file="../styletemplate/template_header.jsp" %>
            <%} else {%>
            <tr> 
                <td ID="TOPTITLE" background="<%=approot%>/images/HRIS_HeaderBg3.jpg" width="100%" height="54"> 
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
            <span id="menu_title"><strong>Masterdata</strong> <strong style="color:#333;"> / </strong>Setup Jurnal Voucher</span>
        </div>
        <div class="content-main">
            <form name="frm" method ="post" action="">
                <input type="hidden" name="command" value="<%=iCommand%>">
                <input type="hidden" name="command_custom" value="">
                <input type="hidden" name="oid_div_code" value="">
                <input type="hidden" name="oid_comp_code" value="" />
                <table width="100%">
                    <tr>
                        <td colspan="2">
                            <div class="box">
                                <h2 style="color:#575757">Group Satuan Kerja</h2>
                                <a href="javascript:cmdAddGroupDiv()" class="btn" style="color:#FFF;">Tambah Data</a>
                                <div>&nbsp;</div>
                                <% if (commandCustom == 7) { %>
                                <div class="box-input">
                                    <input type="text" name="group_code_div" value="" placeholder="contoh: DIV01" />
                                    <a href="javascript:cmdSaveGroupDiv()" id="btn" style="color:#575757;">Simpan</a>
                                    <a href="javascript:cmdCancelGroupDiv()" id="btn" style="color:#575757;">Batal</a>
                                </div>
                                <% } %>
                                <table class="tblStyle" width="100%">
                                    <tr>
                                        <td class="title_tbl">CODE</td>
                                        <td class="title_tbl">Kumpulan CODE Satuan Kerja</td>
                                        <td class="title_tbl">Action</td>
                                    </tr>
                                    <%
                                    if (groupDivList != null && groupDivList.size() > 0){
                                        for (int i=0; i < groupDivList.size();i++){
                                            DivisionGroupJV divGroup = (DivisionGroupJV) groupDivList.get(i);
                                            %>
                                            <tr>
                                                <td><%=divGroup.getDivisionGroupCode()%></td>
                                                <td>
                                                    <button class="btn-small-e" onclick="javascript:cmdAddDivisionCode('<%= divGroup.getOID() %>')">Tambah Mapping Satuan Kerja</button>
                                                    <%
                                                    whereClause = PstDivisionGroupMapJv.fieldNames[PstDivisionGroupMapJv.FLD_DIVISION_GROUP_ID]+"="+divGroup.getOID();
                                                    Vector divGroupMapList = PstDivisionGroupMapJv.list(0, 0, whereClause, "");
                                                    if (divGroupMapList != null && divGroupMapList.size()>0){
                                                    %>
                                                    <table>
                                                        <% 
                                                        for(int j=0; j<divGroupMapList.size(); j++){ 
                                                            DivisionGroupMapJv divGroupMap = (DivisionGroupMapJv)divGroupMapList.get(j);
                                                            DivisionCodeJv divCode = new DivisionCodeJv();
                                                            try {
                                                                divCode = PstDivisionCodeJv.fetchExc(divGroupMap.getDivisionCodeId());
                                                            } catch (Exception exc){}
                                                        %>
                                                        <tr>
                                                            <td class="title_tbl"><%= divCode.getDivisionCode()%></td>
                                                            <td class="title_tbl"><%= divGroupMap.getAccountName()%></td>
                                                            <td class="title_tbl"><%= divGroupMap.getAccountNumber()%></td>
                                                        </tr>
                                                        <% } %>
                                                    </table>
                                                    <% } %>
                                                </td>
                                                <td><button class="btn-small-x" onclick="javascript:cmdDelAllGroup('<%= divGroup.getOID() %>')">delete</button></td>
                                            </tr>
                                            
                                            <%
                                        }
                                    }
                                    %>
                                </table>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td valign="top">
                            <div class="box">
                                <h2 style="color:#575757">Satuan Kerja yang ditampilkan</h2>
                                <a href="javascript:cmdAddCodeDiv()" class="btn" style="color:#FFF;">Tambah Data</a>
                                <div>&nbsp;</div>
                                <% if (commandCustom == 1) { %>
                                <div class="box-input">
                                    <input type="text" name="code_div" value="" placeholder="contoh: DIV01" />
                                    <a href="javascript:cmdSaveCodeDiv()" id="btn" style="color:#575757;">Simpan</a>
                                    <a href="javascript:cmdCancelCodeDiv()" id="btn" style="color:#575757;">Batal</a>
                                </div>
                                <% } %>
                                <table class="tblStyle" width="100%">
                                    <tr>
                                        <td class="title_tbl">CODE</td>
                                        <td class="title_tbl">Kumpulan Satuan Kerja</td>
                                        <td class="title_tbl">Action</td>
                                    </tr>
                                    <%
                                    if (divCodeList != null && divCodeList.size()>0){
                                        for (int i=0; i<divCodeList.size(); i++){
                                            DivisionCodeJv divCode = (DivisionCodeJv)divCodeList.get(i);
                                    %>
                                    <tr>
                                        <td><%= divCode.getDivisionCode() %></td>
                                        <td>
                                            <button class="btn-small-e" onclick="javascript:cmdAddDivision('<%= divCode.getOID() %>')">Tambah data Satuan Kerja</button>
                                            <%
                                            whereClause = PstDivisionMapJv.fieldNames[PstDivisionMapJv.FLD_DIVISION_CODE_ID]+"="+divCode.getOID();
                                            Vector divMapList = PstDivisionMapJv.list(0, 0, whereClause, "");
                                            if (divMapList != null && divMapList.size()>0){
                                            %>
                                            <table>
                                                <% 
                                                for(int j=0; j<divMapList.size(); j++){ 
                                                    DivisionMapJv divMap = (DivisionMapJv)divMapList.get(j);
                                                %>
                                                <tr>
                                                    <td class="title_tbl"><%= divMap.getDivisionName() %></td>
                                                </tr>
                                                <% } %>
                                            </table>
                                            <% } %>
                                        </td>
                                        <td><button class="btn-small-x" onclick="javascript:cmdDelAllDiv('<%= divCode.getOID() %>')">delete</button></td>
                                    </tr>
                                    <% 
                                        }
                                    } 
                                    %>
                                </table>
                            </div>
                        </td>
                        <td valign="top">
                            <div class="box">
                                <h2 style="color:#575757">Komponen yang ditampilkan</h2>
                                <a href="javascript:cmdAddCodeComp()" class="btn" style="color:#FFF;">Tambah Data</a>
                                <div>&nbsp;</div>
                                <% if (commandCustom == 3){ %>
                                <div class="box-input">
                                    <input type="text" name="code_comp" value="" placeholder="contoh: COMP01" />
                                    <a href="javascript:cmdSaveCodeComp()" id="btn" style="color:#575757;">Simpan</a>
                                    <a href="javascript:cmdCancelCodeComp()" id="btn" style="color:#575757;">Batal</a>
                                </div>
                                <% } %>
                                <table class="tblStyle" width="100%">
                                    <tr>
                                        <td class="title_tbl">CODE</td>
                                        <td class="title_tbl">Kumpulan Komponen Gaji</td>
                                        <td class="title_tbl">Action</td>
                                    </tr>
                                    <%
                                    if (compCodeList != null && compCodeList.size()>0){
                                        for (int i=0; i<compCodeList.size(); i++){
                                            ComponentCodeJv compCode = (ComponentCodeJv)compCodeList.get(i);
                                    %>
                                    <tr>
                                        <td><%= compCode.getCompCode() %></td>
                                        <td>
                                            <button class="btn-small-e" onclick="javascript:cmdAddComp('<%= compCode.getOID() %>')">Tambah data komponen</button>
                                            <%
                                            whereClause = PstComponentMapJv.fieldNames[PstComponentMapJv.FLD_COMP_CODE_ID]+"="+compCode.getOID();
                                            Vector compMapList = PstComponentMapJv.list(0, 0, whereClause, "");
                                            if (compMapList != null && compMapList.size()>0){
                                            %>
                                            <table>
                                                <%
                                                for(int j=0; j<compMapList.size(); j++){
                                                    ComponentMapJv compMap = (ComponentMapJv)compMapList.get(j);
                                                %>
                                                <tr>
                                                    <td class="title_tbl"><%= compMap.getComponentName() %></td>
                                                </tr>
                                                <% } %>
                                            </table>
                                            <% } %>
                                        </td>
                                        <td><button class="btn-small-x" onclick="javascript:cmdDelAllComp('<%= compCode.getOID() %>')">delete</button></td>
                                    </tr>
                                    <%
                                        }
                                    }
                                    %>
                                </table>
                            </div>
                        </td>
                    </tr>
                </table>
            </form>
        </div>
        <div class="footer-page">
            <table>
                <%if (headerStyle && !verTemplate.equalsIgnoreCase("0")) {%>
                <tr>
                    <td valign="bottom"><%@include file="../footer.jsp" %></td>
                </tr>
                <%} else {%>
                <tr> 
                    <td colspan="2" height="20" ><%@ include file = "../main/footer.jsp" %></td>
                </tr>
                <%}%>
            </table>
        </div>
    </body>
</html>

<%-- 
    Document   : position_management
    Created on : Apr 10, 2016, 3:35:29 PM
    Author     : Dimata 007
--%>

<%@ include file = "../main/javainit.jsp" %>
<% int  appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_MENU_ORGANISASI, AppObjInfo.G2_MENU_STRUKTUR_ORGANISASI, AppObjInfo.OBJ_MENU_STRUKTUR_ORGANISASI); %>
<%@ include file = "../main/checkuser.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    
    
    /*
    String division_id = FRMQueryString.requestString(request, "div_id");

    Vector listPosition = structureModule.listPosition(division_id);
    Vector vPositionByDept = new Vector();
    Vector vPositionBySection = new Vector();
    */
    int iCommand = FRMQueryString.requestCommand(request);
    long divisionDel = FRMQueryString.requestLong(request, "division_del");
    long departmentDel = FRMQueryString.requestLong(request, "department_del");
    long sectionDel = FRMQueryString.requestLong(request, "section_del");
    long positionDel = FRMQueryString.requestLong(request, "position_del");
    String whereClause = "";
    if (divisionDel != 0 && departmentDel == 0 && sectionDel == 0){
        if (iCommand == Command.DELETE){
            whereClause = PstPositionDivision.fieldNames[PstPositionDivision.FLD_DIVISION_ID]+"="+divisionDel;
            whereClause += " AND "+PstPositionDivision.fieldNames[PstPositionDivision.FLD_POSITION_ID]+"="+positionDel;
            Vector listData = PstPositionDivision.list(0, 0, whereClause, "");
            if (listData != null && listData.size()>0){
                PositionDivision pos = (PositionDivision)listData.get(0);
                PstPositionDivision.deleteExc(pos.getOID());
            }
        }
    }
    if (divisionDel !=0 && departmentDel != 0 && sectionDel == 0){
        if (iCommand == Command.DELETE){
            whereClause = PstPositionDepartment.fieldNames[PstPositionDepartment.FLD_DEPARTMENT_ID]+"="+departmentDel;
            whereClause += " AND "+PstPositionDepartment.fieldNames[PstPositionDepartment.FLD_POSITION_ID]+"="+positionDel;
            Vector listData = PstPositionDepartment.list(0, 0, whereClause, "");
            if (listData != null && listData.size()>0){
                PositionDepartment pos = (PositionDepartment)listData.get(0);
                PstPositionDepartment.deleteExc(pos.getOID());
            }
        }
    }
    if (divisionDel !=0 && departmentDel != 0 && sectionDel != 0){
        if (iCommand == Command.DELETE){
            whereClause = PstPositionSection.fieldNames[PstPositionSection.FLD_SECTION_ID]+"="+sectionDel;
            whereClause += " AND "+PstPositionSection.fieldNames[PstPositionSection.FLD_POSITION_ID]+"="+positionDel;
            Vector listData = PstPositionSection.list(0, 0, whereClause, "");
            if (listData != null && listData.size()>0){
                PositionSection pos = (PositionSection)listData.get(0);
                PstPositionSection.deleteExc(pos.getOID());
            }
        }
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Position Management</title>
        <link rel="stylesheet" href="../styles/main.css" type="text/css">
        <style type="text/css">
            .tblStyle {border-collapse: collapse; font-size: 12px; background-color: #FFF; }
            .tblStyle td {padding: 6px 9px; border: 1px solid #CCC; font-size: 12px; }
            .title_tbl {font-weight: bold;background-color: #DDD; color: #575757;}
            .tr1 {background-color: #FFF;}
            .tr2 {background-color: #EEE;}
            .title_page {color:#0db2e1; font-weight: bold; font-size: 14px; background-color: #EEE; border-left: 1px solid #0099FF; padding: 12px 18px;}
            #font-info {
                padding: 2px 5px;
                font-size: 12px; 
                font-weight: bold;
            }
            #font-val {
                color : #007fba;
                padding: 2px 5px;
                font-size: 12px; 
                font-weight: bold;
            }
            #tbl_form td {
                font-size: 12px;
            }
            body {color:#373737;}
            #menu_utama {padding: 9px 14px; border-left: 1px solid #0099FF; font-size: 14px; background-color: #F3F3F3; border-bottom: 1px solid #DDD;}
            #menu_sub {padding: 9px 14px; border-left: 1px solid #0099FF; font-size: 14px; background-color: #FFF; margin-bottom: 5px; } 
            #note {
                font-size: 13px;
                padding: 11px;
                background-color: #d3f0f9;
                color: #59aac1;
            }
            #menu_title {color:#0099FF; font-size: 14px;}
            #menu_teks {color:#CCC;}
            
            .active {
                background-color: #0b71d0;
                border-bottom: 1px solid #033a6d;
            }
            .title_part {color:#FF7E00; background-color: #F7F7F7; border-left: 1px solid #0099FF; padding: 9px 11px;}
            
            body {
                background-color: #EEE;
                /*
                background-image: url("<=approot>/stylesheets/images/noisy_grid.png");
                background-repeat: repeat;*/
            }
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
                margin: 3px 5px;
                background-color: #FFF;
                border-radius: 3px;
                border: 1px solid #DDD;
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
                background-color: #676767; color: #F5F5F5; 
                font-size: 11px; cursor: pointer;
                border-radius: 3px;
            }
            .btn-small:hover { background-color: #474747; color: #FFF;}
            
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
            
            .caption {
                font-size: 13px;
                color: #575757;
                font-weight: bold;
                padding: 9px 13px 9px 13px;
                border-bottom: 1px solid #DDD;
            }
            #divinput {
                margin: 5px;
                padding-bottom: 5px;
                background-color: #DDD;
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
                padding: 13px 17px;
                background-color: #FF6666;
                color: #FFF;
                border-radius: 3px;
                font-size: 12px;
                font-weight: bold;
                visibility: hidden;
            }
            #btn-confirm {
                padding: 4px 9px; border-radius: 3px;
                background-color: #CF5353; color: #FFF; 
                font-size: 11px; cursor: pointer;
            }
            .footer-page {
                font-size: 12px; 
            }
            
            #floatleft {
                font-size: 12px;
                color: #474747;
                padding: 7px 11px;
                background-color: #FFF;
                border-radius: 3px;
                margin: 5px 0px;
                cursor: pointer;
            }
            #floatleft:hover {
                color: #FFF;
                background-color: #474747;
            }
            .box-item {
                color: #474747;
                padding: 7px 13px;
                font-size: 11px;
                background-color: #FFF;
                margin: 1px 0px;
                cursor: pointer;
            }
            .box-item:hover {
                color: #373737;
                background-color: #EEE;
            }
            .box-item-active {
                color: #F5F5F5;
                padding: 9px 13px;
                font-size: 11px;
                background-color: #007fba;
                margin: 1px 0px;
                cursor: pointer;
            }
        </style>
        <script type="text/javascript">
            function loadCompany(oid) {
                if (oid.length == 0) { 
                    document.getElementById("txtHint").innerHTML = "";
                    return;
                } else {
                    var xmlhttp = new XMLHttpRequest();
                    xmlhttp.onreadystatechange = function() {
                        if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                            document.getElementById("txtHint").innerHTML = xmlhttp.responseText;
                        }
                    };
                    xmlhttp.open("GET", "struct_manage.jsp", true);
                    xmlhttp.send();
                }
            }
            function loadDivision() {
                var xmlhttp = new XMLHttpRequest();
                xmlhttp.onreadystatechange = function() {
                    if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                        document.getElementById("txtHint").innerHTML = xmlhttp.responseText;
                    }
                };
                xmlhttp.open("GET", "struct_manage.jsp", true);
                xmlhttp.send();
            }

            function loadDepartment(comp_id, divisi_id) {
                if ((comp_id.length == 0)&&(divisi_id.length == 0)) { 
                    document.getElementById("txtHint").innerHTML = "";
                    return;
                } else {
                    var xmlhttp = new XMLHttpRequest();
                    xmlhttp.onreadystatechange = function() {
                        if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                            document.getElementById("txtHint").innerHTML = xmlhttp.responseText;
                        }
                    };
                    xmlhttp.open("GET", "struct_manage.jsp?company_id="+comp_id+"&division_id=" + divisi_id, true);
                    xmlhttp.send();
                }
            }

            function loadSection(comp_id, divisi_id, depart_id) {
                if ((comp_id.length == 0)&&(divisi_id.length == 0)&&(depart_id.length == 0)) { 
                    document.getElementById("txtHint").innerHTML = "";
                    return;
                } else {
                    var xmlhttp = new XMLHttpRequest();
                    xmlhttp.onreadystatechange = function() {
                        if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                            document.getElementById("txtHint").innerHTML = xmlhttp.responseText;
                        }
                    };
                    xmlhttp.open("GET", "struct_manage.jsp?company_id="+comp_id+"&division_id=" + divisi_id +"&department_id="+depart_id, true);
                    xmlhttp.send();
                }
            }
            
            function clickSection(comp_id, divisi_id, depart_id, sect_id){
                if ((comp_id.length == 0)&&(divisi_id.length == 0)&&(depart_id.length == 0)&&(sect_id.length == 0)) { 
                    document.getElementById("txtHint").innerHTML = "";
                    return;
                } else {
                    var xmlhttp = new XMLHttpRequest();
                    xmlhttp.onreadystatechange = function() {
                        if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                            document.getElementById("txtHint").innerHTML = xmlhttp.responseText;
                        }
                    };
                    xmlhttp.open("GET", "struct_manage.jsp?company_id="+comp_id+"&division_id=" + divisi_id +"&department_id="+depart_id+"&section_id="+sect_id, true);
                    xmlhttp.send();
                }
            }
            function cmdViewDesc(oid){
                newWindow=window.open("job_desc.jsp?oid_position="+oid,"JobDesc", "height=600,width=500,status=yes,toolbar=no,menubar=no,location=center,scrollbars=yes");
                newWindow.focus();
            }
            
            function pageLoad(){ loadCompany('0'); }
            
            function cmdAdd(comp, div, dept, sec){
                var url = "dialog_position_mapping.jsp?frm_company_inp="+comp;
                url += "&frm_division_inp="+div+"&frm_department_inp="+dept+"&frm_section_inp="+sec;
                newWindow=window.open(url,"DialogPosition", "height=500,width=600,status=yes,toolbar=no,menubar=no,scrollbars=no");
                newWindow.focus();
            }
            
            function cmdDelete(div, dept, sec, pos){
                document.frm.command.value="<%= Command.DELETE %>";
                document.frm.division_del.value=div;
                document.frm.department_del.value=dept;
                document.frm.section_del.value=sec;
                document.frm.position_del.value=pos;
                document.frm.action="position_management.jsp";
                document.frm.submit();
            }
        </script>

    </head>
    <body onload="pageLoad()">
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
            <span id="menu_title">Position Management</span>
        </div>
        <div class="content-main">
            <form name="frm" method="post" action="" >
                <input type="hidden" name="command" value="<%=iCommand%>">
                <input type="hidden" name="division_del" value="<%=divisionDel%>">
                <input type="hidden" name="department_del" value="<%=departmentDel%>">
                <input type="hidden" name="section_del" value="<%=sectionDel%>">
                <input type="hidden" name="position_del" value="<%=positionDel%>">
                <div id="txtHint"></div>
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

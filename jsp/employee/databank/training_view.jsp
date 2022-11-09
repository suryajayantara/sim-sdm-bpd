<%-- 
    Document   : training_view
    Created on : Dec 28, 2015, 11:47:56 AM
    Author     : Dimata 007
--%>
<%@ include file = "../../main/javainit.jsp" %>
<% int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_MENU_EMPLOYEE, AppObjInfo.G2_MENU_DATABANK, AppObjInfo.OBJ_MENU_MY_PROFILE);%>
<%@ include file = "../../main/checkuser.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
/* OBJ_DATABANK_PERSONAL_DATA = 1; */
int appObjCodePer = AppObjInfo.composeObjCode(AppObjInfo.G1_EMPLOYEE, AppObjInfo.G2_DATABANK, AppObjInfo.OBJ_DATABANK_PERSONAL_DATA);
boolean privViewPer = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodePer, AppObjInfo.COMMAND_VIEW));
boolean privUpdatePer = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodePer, AppObjInfo.COMMAND_UPDATE));
/* OBJ_DATABANK_FAMILY_MEMBER = 2; */
int appObjCodeFam = AppObjInfo.composeObjCode(AppObjInfo.G1_EMPLOYEE, AppObjInfo.G2_DATABANK, AppObjInfo.OBJ_DATABANK_FAMILY_MEMBER);
boolean privViewFam = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeFam, AppObjInfo.COMMAND_VIEW));
boolean privUpdateFam = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeFam, AppObjInfo.COMMAND_UPDATE));
/* OBJ_DATABANK_LANG_N_COMPETENCE = 3; */
int appObjCodeLang = AppObjInfo.composeObjCode(AppObjInfo.G1_EMPLOYEE, AppObjInfo.G2_DATABANK, AppObjInfo.OBJ_DATABANK_LANG_N_COMPETENCE);
boolean privViewLang = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeLang, AppObjInfo.COMMAND_VIEW));
boolean privUpdateLang = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeLang, AppObjInfo.COMMAND_UPDATE));
/* OBJ_DATABANK_EDUCATION = 4; */
int appObjCodeEdu = AppObjInfo.composeObjCode(AppObjInfo.G1_EMPLOYEE, AppObjInfo.G2_DATABANK, AppObjInfo.OBJ_DATABANK_EDUCATION);
boolean privViewEdu = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeEdu, AppObjInfo.COMMAND_VIEW));
boolean privUpdateEdu = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeEdu, AppObjInfo.COMMAND_UPDATE));
/* OBJ_DATABANK_EXPERIENCE = 5; */
int appObjCodeExp = AppObjInfo.composeObjCode(AppObjInfo.G1_EMPLOYEE, AppObjInfo.G2_DATABANK, AppObjInfo.OBJ_DATABANK_EXPERIENCE);
boolean privViewExp = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeExp, AppObjInfo.COMMAND_VIEW));
boolean privUpdateExp = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeExp, AppObjInfo.COMMAND_UPDATE));
/* OBJ_DATABANK_CAREERPATH = 6; */
int appObjCodeCar = AppObjInfo.composeObjCode(AppObjInfo.G1_EMPLOYEE, AppObjInfo.G2_DATABANK, AppObjInfo.OBJ_DATABANK_CAREERPATH);
boolean privViewCar = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeCar, AppObjInfo.COMMAND_VIEW));
boolean privUpdateCar = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeCar, AppObjInfo.COMMAND_UPDATE));
/* On The Top */
/* OBJ_DATABANK_TRAINING = 7; */
/* OBJ_DATABANK_WARNING = 8; */
int appObjCodeWar = AppObjInfo.composeObjCode(AppObjInfo.G1_EMPLOYEE, AppObjInfo.G2_DATABANK, AppObjInfo.OBJ_DATABANK_WARNING);
boolean privViewWar = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeWar, AppObjInfo.COMMAND_VIEW));
boolean privUpdateWar = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeWar, AppObjInfo.COMMAND_UPDATE));
/* OBJ_DATABANK_REPRIMAND = 9; */
int appObjCodeRep = AppObjInfo.composeObjCode(AppObjInfo.G1_EMPLOYEE, AppObjInfo.G2_DATABANK, AppObjInfo.OBJ_DATABANK_REPRIMAND);
boolean privViewRep = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeRep, AppObjInfo.COMMAND_VIEW));
boolean privUpdateRep = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeRep, AppObjInfo.COMMAND_UPDATE));
/* OBJ_DATABANK_AWARD = 10; */
int appObjCodeAwr = AppObjInfo.composeObjCode(AppObjInfo.G1_EMPLOYEE, AppObjInfo.G2_DATABANK, AppObjInfo.OBJ_DATABANK_AWARD);
boolean privViewAwr = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeAwr, AppObjInfo.COMMAND_VIEW));
boolean privUpdateAwr = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeAwr, AppObjInfo.COMMAND_UPDATE));
/* OBJ_DATABANK_PICTURE = 11; */
int appObjCodePic = AppObjInfo.composeObjCode(AppObjInfo.G1_EMPLOYEE, AppObjInfo.G2_DATABANK, AppObjInfo.OBJ_DATABANK_PICTURE);
boolean privViewPic = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodePic, AppObjInfo.COMMAND_VIEW));
boolean privUpdatePic = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodePic, AppObjInfo.COMMAND_UPDATE));
/* OBJ_DATABANK_RELEVANT_DOC = 12; */
int appObjCodeRel = AppObjInfo.composeObjCode(AppObjInfo.G1_EMPLOYEE, AppObjInfo.G2_DATABANK, AppObjInfo.OBJ_DATABANK_RELEVANT_DOC);
boolean privViewRel = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeRel, AppObjInfo.COMMAND_VIEW));
boolean privUpdateRel = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeRel, AppObjInfo.COMMAND_UPDATE));
/////
%>
<%
    long oidEmployee = FRMQueryString.requestLong(request, "employee_oid");
    
    if (oidEmployee == 0) {
        oidEmployee = emplx.getOID();
    }
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Databank - <%=dictionaryD.getWord(I_Dictionary.TRAINING_ON_DATABANK)%></title>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

        <link rel="stylesheet" href="../../styles/main.css" type="text/css">
        <style type="text/css">
            .tblStyle {border-collapse: collapse;}
            .tblStyle td {padding: 5px 7px; border: 1px solid #CCC; font-size: 12px;}
            .title_tbl {font-weight: bold;background-color: #DDD; color: #575757;}
            .title_page {color:#0db2e1; font-weight: bold; font-size: 14px; background-color: #EEE; border-left: 1px solid #0099FF; padding: 12px 18px;}

            body {color:#373737;}
            #menu_utama {padding: 9px 14px; border-left: 1px solid #0099FF; font-size: 14px; background-color: #F3F3F3;}
            #menu_title {color:#0099FF; font-size: 14px;}
            #menu_teks {color:#CCC;}
            
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
            
            .navbar li a {
                color : #F5F5F5;
                text-decoration: none;
            }
            
            .navbar li a:hover {
                color:#FFF;
            }
            
            .navbar li a:active {
                color:#FFF;
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
            
            body {background-color: #EEE;}
            .header {
                
            }
            .content-main {
                padding: 5px 25px 25px 25px;
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
                margin: 17px 7px;
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
                border-radius: 5px;
                color: #EEE;
                font-size: 12px;
                padding: 5px 11px 5px 11px;
                border: solid #007fba 1px;
                text-decoration: none;
            }

            .btn:hover {
                color: #FFF;
                background-color: #007fba;
                text-decoration: none;
                border: 1px solid #007fba;
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
                font-size: 12px;
            }
            
        </style>
        <script type="text/javascript">
            var valueCheck = 0;
            
            function putValue(v){
                valueCheck = v;
            }
            
            function loadList(training_cari) {
                var oidEmp = document.getElementById("oid_emp").value;
                if (training_cari.length == 0) { 
                    training_cari = "0";
                } 
                var xmlhttp = new XMLHttpRequest();
                xmlhttp.onreadystatechange = function() {
                    if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                        document.getElementById("div_respon").innerHTML = xmlhttp.responseText;
                    }
                };
                xmlhttp.open("GET", "training-ajax-view.jsp?training_cari=" + training_cari +"&rb_cari="+valueCheck+"&employee_oid="+oidEmp, true);
                xmlhttp.send(); 
            }
            
            function prepare(){
                loadList("0");
            }
            
            function cmdListFirst(start){       
                var oidEmp = document.getElementById("oid_emp").value;
                var xmlhttp = new XMLHttpRequest();
                xmlhttp.onreadystatechange = function() {
                    if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                        document.getElementById("div_respon").innerHTML = xmlhttp.responseText;
                    }
                };
                xmlhttp.open("GET", "training-ajax-view.jsp?training_cari=0&rb_cari="+valueCheck+"&command=" + <%=Command.FIRST%> + "&start="+start+"&employee_oid="+oidEmp, true);
                xmlhttp.send();
            }

            function cmdListPrev(start){
                var oidEmp = document.getElementById("oid_emp").value;
                var xmlhttp = new XMLHttpRequest();
                xmlhttp.onreadystatechange = function() {
                    if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                        document.getElementById("div_respon").innerHTML = xmlhttp.responseText;
                    }
                };
                xmlhttp.open("GET", "training-ajax-view.jsp?training_cari=0&rb_cari="+valueCheck+"&command=" + <%=Command.PREV%> + "&start="+start+"&employee_oid="+oidEmp, true);
                xmlhttp.send();
            }

            function cmdListNext(start){
                var oidEmp = document.getElementById("oid_emp").value;
                var xmlhttp = new XMLHttpRequest();
                xmlhttp.onreadystatechange = function() {
                    if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                        document.getElementById("div_respon").innerHTML = xmlhttp.responseText;
                    }
                };
                xmlhttp.open("GET", "training-ajax-view.jsp?training_cari=0&rb_cari="+valueCheck+"&command=" + <%=Command.NEXT%> + "&start="+start+"&employee_oid="+oidEmp, true);
                xmlhttp.send();
            }

            function cmdListLast(start){
                var oidEmp = document.getElementById("oid_emp").value;
                var xmlhttp = new XMLHttpRequest();
                xmlhttp.onreadystatechange = function() {
                    if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                        document.getElementById("div_respon").innerHTML = xmlhttp.responseText;
                    }
                };
                xmlhttp.open("GET", "training-ajax-view.jsp?training_cari=0&rb_cari="+valueCheck+"&command=" + <%=Command.LAST%> + "&start="+start+"&employee_oid="+oidEmp, true);
                xmlhttp.send();
            }

        </script>
    </head>
    <body onload="prepare()">
        <div class="header">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <%if (headerStyle && !verTemplate.equalsIgnoreCase("0")) {%> 
            <%@include file="../../styletemplate/template_header.jsp" %>
            <%} else {%>
            <tr> 
                <td ID="TOPTITLE" background="<%=approot%>/images/HRIS_HeaderBg3.jpg" width="100%" height="54"> 
                    <!-- #BeginEditable "header" --> 
                    <%@ include file = "../../main/header.jsp" %>
                    <!-- #EndEditable --> 
                </td>
            </tr>
            <tr> 
                <td  bgcolor="#9BC1FF" height="15" ID="MAINMENU" valign="middle"> <!-- #BeginEditable "menumain" --> 
                    <%@ include file = "../../main/mnmain.jsp" %>
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
            <span id="menu_title">Databank <strong style="color:#333;"> / </strong><%=dictionaryD.getWord(I_Dictionary.TRAINING_ON_DATABANK)%></span>
        </div>
        <% if (oidEmployee != 0) {%>
            <div class="navbar">
                <ul style="margin-left: 97px">
                    <% if (privViewPer == true){ 
                            if (privUpdatePer){
                    %>
                                <li class=""> <a href="employee_edit.jsp?employee_oid=<%=oidEmployee%>&prev_command=<%=Command.EDIT%>" class="tablink"><%=dictionaryD.getWord(I_Dictionary.PERSONAL_DATA)%></a> </li>
                    <%      } else { %>
                                <li class=""> <a href="employee_view_new.jsp?employee_oid=<%=oidEmployee%>" class="tablink"><%=dictionaryD.getWord(I_Dictionary.PERSONAL_DATA)%></a> </li>
                    <%      } 
                       }
                    %>
                    <% if (privViewFam == true){ 
                            if (privUpdateFam){
                    %>
                                <li class=""> <a href="familymember.jsp?employee_oid=<%=oidEmployee%>" class="tablink"><%=dictionaryD.getWord(I_Dictionary.FAMILY_MEMBER) %></a> </li>
                    <%      } else { %>
                                <li class=""> <a href="familymember_view.jsp?employee_oid=<%=oidEmployee%>" class="tablink"><%=dictionaryD.getWord(I_Dictionary.FAMILY_MEMBER) %></a> </li>                    
                    <%      } 
                        }
                    %>
                    <% if (privViewLang == true){ 
                            if (privUpdateLang){
                    %>
                                <li class=""> <a href="emplanguage.jsp?employee_oid=<%=oidEmployee%>" class="tablink"><%=dictionaryD.getWord(I_Dictionary.COMPETENCIES) %></a> </li>
                    <%      } else { %>
                                <li class=""> <a href="emplanguage_view.jsp?employee_oid=<%=oidEmployee%>" class="tablink"><%=dictionaryD.getWord(I_Dictionary.COMPETENCIES) %></a> </li>                    
                    <%      } 
                        }
                    %>
                    <% if (privViewEdu == true){ 
                            if (privUpdateEdu){
                    %>
                                <li class=""> <a href="empeducation.jsp?employee_oid=<%=oidEmployee%>" class="tablink"><%=dictionaryD.getWord(I_Dictionary.EDUCATION) %></a> </li>
                    <%      } else { %>
                                <li class=""> <a href="empeducation_view.jsp?employee_oid=<%=oidEmployee%>" class="tablink"><%=dictionaryD.getWord(I_Dictionary.EDUCATION) %></a> </li>
                    <%      } 
                        }        
                    %>
                    <% if (privViewExp == true){ 
                            if (privUpdateExp){
                    %>
                                <li class=""> <a href="experience.jsp?employee_oid=<%=oidEmployee%>" class="tablink"><%=dictionaryD.getWord(I_Dictionary.EXPERIENCE) %></a> </li>
                    <%      } else { %>
                                <li class=""> <a href="experience_view.jsp?employee_oid=<%=oidEmployee%>" class="tablink"><%=dictionaryD.getWord(I_Dictionary.EXPERIENCE) %></a> </li>
                    <%      } 
                        }
                    %>
                    <% if (privViewCar == true){ 
                            if (privUpdateCar){
                    %>
                                <li class=""> <a href="careerpath.jsp?employee_oid=<%=oidEmployee%>" class="tablink"><%=dictionaryD.getWord(I_Dictionary.CAREER_PATH) %></a> </li>
                    <%      } else { %>
                                <li class=""> <a href="careerpath_view.jsp?employee_oid=<%=oidEmployee%>" class="tablink"><%=dictionaryD.getWord(I_Dictionary.CAREER_PATH) %></a> </li>
                    <%      } 
                        }
                    %>
                    <li class="active"> <%=dictionaryD.getWord(I_Dictionary.TRAINING_ON_DATABANK)%> </li>
                    <% if (privViewWar == true){ 
                            if (privUpdateWar){
                    %>
                                <li class=""> <a href="warning.jsp?employee_oid=<%=oidEmployee%>" class="tablink"><%=dictionaryD.getWord(I_Dictionary.WARNING) %></a> </li>
                    <%      } else { %>            
                                <li class=""> <a href="warning_view.jsp?employee_oid=<%=oidEmployee%>" class="tablink"><%=dictionaryD.getWord(I_Dictionary.WARNING) %></a> </li>
                    <%      }
                        } 
                    %>
                    <% if (privViewRep == true){ 
                            if (privUpdateRep){
                    %>
                                <li class=""> <a href="reprimand.jsp?employee_oid=<%=oidEmployee%>" class="tablink"><%=dictionaryD.getWord(I_Dictionary.REPRIMAND) %></a> </li>
                    <%      } else { %>
                                <li class=""> <a href="reprimand_view.jsp?employee_oid=<%=oidEmployee%>" class="tablink"><%=dictionaryD.getWord(I_Dictionary.REPRIMAND) %></a> </li>
                    <%      } 
                        }        
                    %>
                    <% if (privViewAwr == true){ 
                            if (privUpdateAwr){
                    %>
                                <li class=""> <a href="award.jsp?employee_oid=<%=oidEmployee%>" class="tablink"><%=dictionaryD.getWord(I_Dictionary.AWARD) %></a> </li>
                    <%      } else { %>
                                <li class=""> <a href="award_view.jsp?employee_oid=<%=oidEmployee%>" class="tablink"><%=dictionaryD.getWord(I_Dictionary.AWARD) %></a> </li>
                    <%      } 
                        }
                    %>
                    <% if (privViewPic == true){ %>
                                <li class=""> <a href="picture.jsp?employee_oid=<%=oidEmployee%>" class="tablink"><%=dictionaryD.getWord(I_Dictionary.PICTURE) %></a> </li>
                    <% } %>
                    <% if (privViewRel == true){ 
                            if (privUpdateRel){
                    %>
                                <li class=""> <a href="doc_relevant.jsp?employee_oid=<%=oidEmployee%>" class="tablink"><%=dictionaryD.getWord(I_Dictionary.RELEVANT_DOCS) %></a> </li>
                    <%      } else { %>
                                <li class=""> <a href="doc_relevant_view.jsp?employee_oid=<%=oidEmployee%>" class="tablink"><%=dictionaryD.getWord(I_Dictionary.RELEVANT_DOCS) %></a> </li>
                    <%      } 
                        }
                    %>
                    <%
                        if (oidEmployee == emplx.getOID()){
                    %>
                        <li class=""> <a href="update_pin.jsp?employee_oid=<%=oidEmployee%>" class="tablink">Ubah PIN</a> </li>
                    <%
                        }
                    %>
                </ul>
            </div>
        <%}%>
        <div class="content-main">
            <div class="box">
                <div id="box_title">Daftar <%=dictionaryD.getWord(I_Dictionary.TRAINING_ON_DATABANK)%></div>
                <div id="box_content">
                    <input type="hidden" id="oid_emp" name="employee_oid" value="<%=oidEmployee%>">
                    <div class="search">
                        <div style="font-size: 12px; padding-bottom: 5px; font-family: sans-serif;">
                            <input type="radio" checked="checked" onclick="putValue('0')" id="rb_cari" name="rb_cari" value="0" />Training Program 
                            <input type="radio" id="rb_cari" onclick="putValue('1')" name="rb_cari" value="1" />Training Title
                        </div>
                        <input style="padding: 5px 9px" type="text" name="training_cari" placeholder="Training Search..." size="87" onkeyup="loadList(this.value)" />
                    </div>  
                    <div>&nbsp;</div>
                    <div id="div_respon"></div>
                    <div>&nbsp;</div>
                </div>
            </div>
        </div>
        <div class="footer-page">
            <table>
                <%if (headerStyle && !verTemplate.equalsIgnoreCase("0")) {%>
                <tr>
                    <td valign="bottom"><%@include file="../../footer.jsp" %></td>
                </tr>
                <%} else {%>
                <tr> 
                    <td colspan="2" height="20" ><%@ include file = "../../main/footer.jsp" %></td>
                </tr>
                <%}%>
            </table>
        </div>
    </body>
</html>
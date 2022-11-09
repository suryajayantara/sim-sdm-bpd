<%-- 
    Document   : emplanguage_view
    Created on : Dec 28, 2015, 11:08:55 AM
    Author     : Dimata 007
--%>
<%@page import="com.dimata.gui.jsp.ControlList"%>
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
int appObjCodeTra = AppObjInfo.composeObjCode(AppObjInfo.G1_EMPLOYEE, AppObjInfo.G2_DATABANK, AppObjInfo.OBJ_DATABANK_TRAINING);
boolean privViewTra = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeTra, AppObjInfo.COMMAND_VIEW));
boolean privUpdateTra = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodeTra, AppObjInfo.COMMAND_UPDATE));
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
<%!
    public String getCompetencyName(long competencyId){
        String str = "";
        try {
            Competency competency = PstCompetency.fetchExc(competencyId);
            str = competency.getCompetencyName();
        } catch(Exception ex){
            System.out.println("getCompetency=>"+ex.toString());
        }
        return str;
    }

        public String drawList(Vector objectClass)

        {
                ControlList ctrlist = new ControlList();
                ctrlist.setAreaWidth("0");
                ctrlist.setListStyle("tblStyle");
                ctrlist.setTitleStyle("title_tbl");
                ctrlist.setCellStyle("listgensell");
                ctrlist.setHeaderStyle("title_tbl");
                ctrlist.setCellSpacing("0");
                ctrlist.addHeader("Language","");
                ctrlist.addHeader("Oral","");
                ctrlist.addHeader("Written","");
                ctrlist.addHeader("Description","");
                Vector lstData = ctrlist.getData();
                ctrlist.reset();
                int index = -1;
                int no=0; 
                for (int i = 0; i < objectClass.size(); i++) {
                        no++;
                        EmpLanguage empLanguage = (EmpLanguage) objectClass.get(i);
                        Vector rowx = new Vector();
                        Language language = new Language();
                        if (empLanguage.getLanguageId() != 0) {
                            try {
                                language = PstLanguage.fetchExc(empLanguage.getLanguageId());
                            } catch (Exception exc) {
                                language = new Language();
                            }
                        }
                            
                        rowx.add(language.getLanguage());
                        rowx.add(PstEmpLanguage.gradeKey[empLanguage.getOral()]);
                        rowx.add(PstEmpLanguage.gradeKey[empLanguage.getWritten()]);
                        rowx.add(empLanguage.getDescription());
                        lstData.add(rowx);
                    }

                return ctrlist.draw(index);
        }

        
        public String drawListEmpCompetencies(Vector objectClass)
        {
                ControlList ctrlist = new ControlList();
                ctrlist.setAreaWidth("0");
                ctrlist.setListStyle("tblStyle");
                ctrlist.setTitleStyle("title_tbl");
                ctrlist.setCellStyle("listgensell");
                ctrlist.setHeaderStyle("title_tbl");
                ctrlist.setCellSpacing("0");
                ctrlist.addHeader("Competencies","");
                ctrlist.addHeader("Level value","");
                ctrlist.addHeader("Date of Achieve","");
                ctrlist.addHeader("Special Achievement","");

                ctrlist.setLinkRow(0);
                ctrlist.setLinkSufix("");
                Vector lstData = ctrlist.getData();
                ctrlist.reset();
                int index = -1;
                int no=0; 
                for (int i = 0; i < objectClass.size(); i++) {
                    EmployeeCompetency empCompetency = (EmployeeCompetency)objectClass.get(i);
                    Vector rowx = new Vector();
                    rowx.add(getCompetencyName(empCompetency.getCompetencyId()));
                    rowx.add(""+empCompetency.getLevelValue());
                    rowx.add(""+empCompetency.getDateOfAchvmt());
                    rowx.add(empCompetency.getSpecialAchievement());
                    lstData.add(rowx);
                }

                return ctrlist.draw(index);
        }

%>
<%
    long oidEmployee = FRMQueryString.requestLong(request, "employee_oid");
    
    if (oidEmployee == 0) {
        oidEmployee = emplx.getOID();
    }
    String whereClause = "";
    Vector listEmpLanguage = new Vector();
    Vector listEmpCompetency = new Vector();
    
    whereClause = PstEmpLanguage.fieldNames[PstEmpLanguage.FLD_EMPLOYEE_ID]+ " = "+oidEmployee;
    listEmpLanguage = PstEmpLanguage.list(0,0, whereClause, "");
    
    whereClause = PstEmployeeCompetency.fieldNames[PstEmployeeCompetency.FLD_EMPLOYEE_ID]+"="+oidEmployee;
    listEmpCompetency = PstEmployeeCompetency.list(0, 0, whereClause, "");
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Databank - <%=dictionaryD.getWord(I_Dictionary.COMPETENCIES) %></title>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

        <link rel="stylesheet" href="../../styles/main.css" type="text/css">
        <style type="text/css">
            .tblStyle {border-collapse: collapse; }
            .tblStyle td {padding: 5px 7px; border: 1px solid #CCC; font-size: 12px; }
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
                text-decoration: none;
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
    </head>
    <body>
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
            <span id="menu_title">Databank <strong style="color:#333;"> / </strong><%=dictionaryD.getWord(I_Dictionary.LANGUAGE) %> & <%=dictionaryD.getWord(I_Dictionary.COMPETENCIES) %></span>
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
                    <li class="active"><%=dictionaryD.getWord(I_Dictionary.COMPETENCIES) %></li>
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
                    <% if (privViewTra == true){ 
                            if (privUpdateTra){
                    %>
                                <li class=""> <a href="training.jsp?employee_oid=<%=oidEmployee%>" class="tablink"><%=dictionaryD.getWord(I_Dictionary.TRAINING_ON_DATABANK)%></a></li>
                    <%      } else { %>
                                <li class=""> <a href="training_view.jsp?employee_oid=<%=oidEmployee%>" class="tablink"><%=dictionaryD.getWord(I_Dictionary.TRAINING_ON_DATABANK)%></a></li>
                    <%      } 
                        }
                    %>
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
                <div id="box_title">Daftar Kompetensi</div>
                <div id="box_content">
                    <% 
                        
                        if (listEmpCompetency != null && listEmpCompetency.size()>0){
                            %>
                            <%=drawListEmpCompetencies(listEmpCompetency)%>
                            <%
                        } else {
                            %>
                            <p>No record available</p>
                            <%
                        }
                    %>
                </div>
            </div>
            <div class="box">
                <div id="box_title">Daftar Bahasa</div>
                <div id="box_content">
                    <% 
                        
                        if (listEmpLanguage != null && listEmpLanguage.size()>0){
                            %>
                            <%= drawList(listEmpLanguage)%>
                            <%
                        } else {
                            %>
                            <p>No record available</p>
                            <%
                        }
                    %>
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

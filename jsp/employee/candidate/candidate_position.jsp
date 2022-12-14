<%-- 
    Document   : candidate_position
    Created on : Sep 8, 2015, 10:53:21 AM
    Author     : Dimata 007
--%>

<%@page import="com.dimata.harisma.entity.log.ChangeValue"%>
<%@page import="com.dimata.harisma.form.employee.FrmCandidateLocation"%>
<%@page import="com.dimata.harisma.form.employee.CtrlCandidateLocation"%>
<%@page import="com.dimata.gui.jsp.ControlCombo"%>
<%@ include file = "../../main/javainit.jsp" %>
<% int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_EMPLOYEE, AppObjInfo.G2_DATABANK, AppObjInfo.OBJ_DATABANK);%>
<% boolean privGenerate = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_GENERATE_SALARY_LEVEL));%>
<%@ include file = "../../main/checkuser.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%!
    public String getCompanyName(long oidCompany){
        String str = "";
        Company company = new Company();
        try {
            company = PstCompany.fetchExc(oidCompany);
            str = company.getCompany();
        } catch(Exception e){
            System.out.println("getCompanyName=>"+e.toString());
        }
        return str;
    }
    
    public String getDivisionName(long oidDivision){
        String str = "";
        Division division = new Division();
        try {
            division = PstDivision.fetchExc(oidDivision);
            str = division.getDivision();
        } catch(Exception e){
            System.out.println("getDivisionName=>"+e.toString());
        }
        return str;
    }
    
    public String getDepartmentName(long oidDepartment){
        String str = "";
        Department department = new Department();
        try {
            department = PstDepartment.fetchExc(oidDepartment);
            str = department.getDepartment();
        } catch(Exception e){
            System.out.println("getDepartmentName=>"+e.toString());
        }
        return str;
    }
    
    public String getSectionName(long oidSection){
        String str = "";
        Section section = new Section();
        try {
            section = PstSection.fetchExc(oidSection);
            str = section.getSection();
        } catch(Exception e){
            System.out.println("getSectionName=>"+e.toString());
        }
        return str;
    }
    
%>
<!DOCTYPE html>
<%
int iCommand = FRMQueryString.requestCommand(request);
long candidateMainId = FRMQueryString.requestLong(request, "candidate_main_id");
long candidateLocId = FRMQueryString.requestLong(request, "candidate_location_id");
String[] chxPosition = FRMQueryString.requestStringValues(request, "chx_position");
long positionId = FRMQueryString.requestLong(request, "position_select");
int typeMenu = FRMQueryString.requestInt(request, "type_menu");
ChangeValue changeValue = new ChangeValue();
String titleMenu = "";
if (typeMenu == 0){
    titleMenu = "Candidate";
} else {
    titleMenu = "Talent";
}
Date now = new Date();
String whereClause = "";
String orderBy = "";

CandidatePosition candidatePosition = new CandidatePosition();
if (iCommand == Command.SAVE && candidateMainId > 0){
    if (positionId > 0){
        candidatePosition = new CandidatePosition();
        candidatePosition.setOID(0);
        candidatePosition.setCandidateLocId(candidateLocId);
        candidatePosition.setCandidateMainId(candidateMainId);
        candidatePosition.setPositionId(positionId);
        candidatePosition.setCandidateType(0);
        candidatePosition.setNumberOfCandidate(0);
        candidatePosition.setObjectives("-");
        candidatePosition.setDueDate(now);
        try {
            PstCandidatePosition.insertExc(candidatePosition);
        } catch(Exception e) {
            System.out.println("Insert data Candidate Position=>"+e.toString());
        }

    }
    iCommand = Command.NONE;
}

%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Candidate Position</title>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
        <link rel="stylesheet" href="../../styles/main.css" type="text/css">
        <link rel="stylesheet" href="../../styles/tab.css" type="text/css">
        <link href="<%=approot%>/stylesheets/superTables.css" rel="Stylesheet" type="text/css" /> 
        <style type="text/css">

            #mn_utama {color: #FF6600; padding: 5px 14px; border-left: 1px solid #999; font-size: 12px; font-weight: bold; background-color: #F5F5F5;}
            
            #menu_utama {padding: 9px 14px; border-left: 1px solid #0099FF; font-size: 14px; background-color: #F3F3F3; color:#0099FF; font-size: 14px; font-weight: bold;}
            
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
            
            #btn1 {
              background-color: #DDD;
              border: 1px solid #CCC;
              border-radius: 3px;
              color: #575757;
              font-size: 11px;
              padding: 6px 9px;
              cursor: pointer;
            }
            #btn1:hover {
              color: #373737;
              background-color: #c5c5c5;
              border: 1px solid #999;
            }
            
            #btn2 {
              background-color: #00ccff;
              border: 1px solid #00aeda;
              border-radius: 3px;
              color: #FFF;
              font-size: 14px;
              padding: 9px 17px;
              cursor: pointer;
            }
            #btn2:hover {
              color: #FFF;
              background-color: #0096bb;
              border: 1px solid #007592;
            }
            
            #btn_disable {
              background-color: #EEE;
              border: 1px solid #D5D5D5;
              border-radius: 3px;
              color: #CCC;
              font-size: 14px;
              padding: 9px 17px;
            }
            .tblStyle {border-collapse: collapse; font-size: 9px;}
            .tblStyle td {font-weight: bold; padding: 3px 7px;}
            .title_tbl {font-weight: bold;background-color: #DDD; color: #575757; }
            .title_part {background-color: #FFF; border-left: 1px solid #3cb0fd; padding:5px 15px;  color: #575757; margin: 1px 0px;}
            
            .divLocation {
                margin:3px 0px; 
                padding:5px 7px; 
                background-color: #FFF;
                color: #575757;
                font-weight: bold;
            }
            
            .position {
                color: #474747;
                background-color: #DDD;
                padding: 3px 5px;
                margin: 3px;
                border-radius: 3px;
            }
            
            #nav-next {
              background-color: #00ccff;
              color: #FFF;
              font-size: 14px;
              padding: 11px 17px 10px 17px;
              cursor: pointer;
            }
            #nav-next-disable {
              background-color: #d9d9d9;
              color: #FFF;
              font-size: 14px;
              padding: 11px 17px 10px 17px;
              cursor: pointer;
            }
            .pesan {
                font-weight: bold;
                padding: 12px;
                background-color: #f0fad2;
                color: #689d3d;
                border-radius: 3px;
            }
            select {
                padding: 5px 7px;
                border: 1px solid #DDD;
                border-radius: 3px;
                color: #474747;
            }
        </style>
        <script type="text/javascript">
            function cmdSave(){
                document.frm.command.value="<%=Command.SAVE%>";
                document.frm.action = "candidate_position.jsp";
                document.frm.submit();
            }
            function cmdGoTo(val, oid){
                var link = "";
                switch(val){
                    case "1":
                        link = "candidate_main.jsp";
                        break;
                    case "2":
                        link = "candidate_location.jsp";
                        break;
                    case "3":
                        link = "candidate_position.jsp";
                        break;
                    case "4":
                        link = "candidate_matrix.jsp";
                        break;
                    case "5":
                        link = "candidate_selection.jsp";
                        break;
                    case "6":
                        link = "candidate_complete.jsp";
                        break;
                }
                document.frm.command.value="0";
                document.frm.candidate_main_id.value=oid;
                document.frm.action = link;
                document.frm.submit();
            }
        </script>

    </head>
    <body <%=noBack%> bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
        <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%" bgcolor="#F9FCFF" >
            <%if (headerStyle && !verTemplate.equalsIgnoreCase("0")) {%> 
            <%@include file="../../styletemplate/template_header.jsp" %>
            <%} else {%>
            <tr> 
                <td ID="TOPTITLE" background="<%=approot%>/images/HRIS_HeaderBg3.jpg" height="54"> 
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
                                        <td height="20"> <div id="menu_utama">Candidate Position</div> </td>
                                    </tr>
                                    <tr>
                                        <td>&nbsp;</td>
                                    </tr>
                                    <tr>
                                        <td style="background-color:#EEE;" valign="top" width="100%">
                                       
                                            
                                            <table width="100%" style="padding:9px; border:1px solid <%=garisContent%>;"  border="0" cellspacing="1" cellpadding="1" class="tablecolor">
                                                <tr>
                                                    <td valign="top">
                                                        <form name="frm" method="post" action="">
                                                            <input type="hidden" name="command" value="<%=iCommand%>">
                                                            <input type="hidden" name="candidate_main_id" value="<%=candidateMainId%>" />
                                                            <table>
                                                                <tr>
                                                                    <td colspan="2" style="border-bottom:1px solid #CCC; padding:15px 9px;">
                                                                        <table cellspacing="0" cellpadding="0" border="0">
                                                                            <tr>
                                                                                <td valign="top"><div id="nav-next" onclick="cmdGoTo('1','<%=candidateMainId%>')">1) <%=titleMenu%> Main</div></td>
                                                                                <td valign="middle"><img src="<%=approot%>/images/nav-next-enable.png" /></td>
                                                                                <td valign="top"><div id="nav-next" onclick="cmdGoTo('2','<%=candidateMainId%>')">2) <%=titleMenu%> Location</div></td>
                                                                                <td valign="middle"><img src="<%=approot%>/images/nav-next-enable.png" /></td>
                                                                                <td valign="top"><div id="nav-next" onclick="cmdGoTo('3','<%=candidateMainId%>')">3) <%=titleMenu%> Position</div></td>
                                                                                <td valign="middle"><img src="<%=approot%>/images/nav-next.png" /></td>
                                                                                <td valign="top"><div id="nav-next-disable" onclick="cmdGoTo('4','<%=candidateMainId%>')">4) <%=titleMenu%> Detail</div></td>
                                                                                <td valign="middle"><img src="<%=approot%>/images/nav-next-disable.png" /></td>
                                                                                <td valign="top"><div id="nav-next-disable" onclick="cmdGoTo('5','<%=candidateMainId%>')">5) <%=titleMenu%> Selection</div></td>
                                                                                <td valign="middle"><img src="<%=approot%>/images/nav-next-disable.png" /></td>
                                                                                <td valign="top"><div id="nav-next-disable" onclick="cmdGoTo('6','<%=candidateMainId%>')">6) <%=titleMenu%> Summary</div></td>                                                                                
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td valign="top">
                                                                        <table>
                                                                            <tr>
                                                                                <td>
                                                                                    <select name="position_select" class="chosen-select">
                                                                                        <option value="0">-SELECT-</option>
                                                                                        <%
                                                                                        orderBy = PstPosition.fieldNames[PstPosition.FLD_POSITION]+" ASC";
                                                                                        Vector listPosition = PstPosition.list(0, 0, "", orderBy);
                                                                                        if (listPosition != null && listPosition.size()>0){
                                                                                            for(int i=0; i<listPosition.size(); i++){
                                                                                                Position position = (Position)listPosition.get(i);
                                                                                                %>
                                                                                                <option value="<%=position.getOID()%>"><%=position.getPosition()%></option>
                                                                                                <%
                                                                                            }
                                                                                        }
                                                                                        %>
                                                                                    </select>
                                                                                    <a href="javascript:cmdSave()" id="btn1">Tambah</a>
                                                                                </td>
                                                                            </tr>
                                                                        </table>                                                                        
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                            <div>&nbsp;</div>
                                                            <%
                                                            //candidateMainId
                                                            whereClause = PstCandidatePosition.fieldNames[PstCandidatePosition.FLD_CANDIDATE_MAIN_ID]+"="+candidateMainId;
                                                            Vector candidatePosList = PstCandidatePosition.list(0, 0, whereClause, "");      
                                                            if (candidatePosList != null && candidatePosList.size()>0){
                                                                for (int i=0; i<candidatePosList.size(); i++){
                                                                    CandidatePosition candidatePos = (CandidatePosition)candidatePosList.get(i);
                                                                    %>
                                                                    <div><%= changeValue.getPositionName(candidatePos.getPositionId()) %></div>
                                                                    <%
                                                                }
                                                            }
                                                            %>
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
                    <%@include file="../../footer.jsp" %>
                </td>
                            
            </tr>
            <%} else {%>
            <tr> 
                <td colspan="2" height="20" > <!-- #BeginEditable "footer" --> 
                    <%@ include file = "../../main/footer.jsp" %>
                    <!-- #EndEditable --> </td>
            </tr>
            <%}%>
        </table>
    </body>
    <!-- #BeginEditable "script" --> <script language="JavaScript">
                var oBody = document.body;
                var oSuccess = oBody.attachEvent('onkeydown',fnTrapKD);
    </script>
                
    <!-- #EndEditable --> <!-- #EndTemplate -->
</html>
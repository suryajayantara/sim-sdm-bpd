<%-- 
    Document   : gap_competency_detail
    Created on : Jul 4, 2021, 5:11:15 PM
    Author     : gndiw
--%>

<%@page import="com.dimata.harisma.session.employee.SessEmployeePicture"%>
<%@page import="org.json.JSONObject"%>
<%@page import="com.dimata.harisma.session.employee.SessRptCompetency"%>
<%@page import="com.dimata.harisma.session.employee.SessEmployee"%>
<%@page import="com.dimata.harisma.entity.attendance.PstLLStockManagement"%>
<%@page import="com.dimata.harisma.entity.attendance.AlStockManagement"%>
<%@page import="com.dimata.harisma.entity.attendance.PstAlStockManagement"%>
<%@page import="com.dimata.harisma.entity.log.ChangeValue"%>
<%@page import="com.dimata.harisma.entity.leave.PstLeaveApplication"%>
<%@page import="com.dimata.harisma.entity.leave.LeaveApplication"%>
<%@page import="com.dimata.gui.jsp.ControlCombo"%>
<%@page import="com.dimata.harisma.form.search.FrmSrcTraining"%>
<%@page import="com.dimata.qdep.db.DBHandler"%>
<%@page import="com.dimata.qdep.db.DBResultSet"%>
<%@page import="java.sql.ResultSet"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file = "../../main/javainit.jsp" %>
<% int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_MASTERDATA, AppObjInfo.G2_MD_COMPANY, AppObjInfo.OBJ_DIVISION);%>
<%@ include file = "../../main/checkuser.jsp" %>
<!DOCTYPE html>
<%!
   
     public static String getWorkFrom(long employeeId){
        String workFrom = "";
        
        DBResultSet dbrs = null;
        double count = 0;
        double pct = 0;
        try {
            String sql = "SELECT * "
                    + "FROM hr_view_work_history_now "
                    + "WHERE employee_id = '"+employeeId+"' AND work_history_now_id = 0";
            //System.out.println("sql jumlah ::::::::::::::::::::::"+sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                workFrom = rs.getString("WORK_FROM");
            }
            rs.close();

        } catch (Exception ex) {
            return "";
        } finally {
            DBResultSet.close(dbrs);
        }
        
        return workFrom;
    }
%>
<%
    int iCommand = FRMQueryString.requestCommand(request);
    long employeeId = FRMQueryString.requestLong(request, "employee_id");
    Employee emp = new Employee();
    String position = "";
    String division = "";
    String department = "";
    String section = "";
    String workFrom = "";
    try {
        emp = PstEmployee.fetchExc(employeeId);
        position = PstEmployee.getPositionName(emp.getPositionId());
        division = PstEmployee.getDivisionName(emp.getDivisionId());
        department = PstEmployee.getDepartmentName(emp.getDepartmentId());
        section = PstEmployee.getSectionName(emp.getSectionId());
        workFrom = getWorkFrom(emp.getOID());
    } catch (Exception exc){}
    
    Division dv = new Division();
    Department dep = new Department();
    Section sec = new Section();
    try {
        dv = PstDivision.fetchExc(emp.getDivisionId());
    } catch (Exception exc){}
    
    try {
        dep = PstDepartment.fetchExc(emp.getDepartmentId());
    } catch (Exception exc){}
    
    try {
        sec = PstSection.fetchExc(emp.getSectionId());
    } catch (Exception exc){}
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Laporan Gap Kompetensi</title>
        <link rel="stylesheet" href="../../styles/main.css" type="text/css">
        <%@ include file = "../../main/konfigurasi_jquery.jsp" %>    
        <script src="../../javascripts/jquery.min-1.6.2.js" type="text/javascript"></script>
        <script src="../../javascripts/chosen.jquery.js" type="text/javascript"></script>
        <link rel="stylesheet" href="../../stylesheets/chosen.css" >
        <style type="text/css">
            .tblStyle {border-collapse: collapse; font-size: 12px; }
            .tblStyle td {padding: 5px 7px; border: 1px solid #CCC; font-size: 12px; }
            .title_tbl {font-weight: bold; background-color: #DDD; color: #575757;}
            .title_tbl_header {font-weight: bold; background-color: yellowgreen; color: #575757;}
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
            .title_part {color:#FF7E00; background-color: #F7F7F7; border-left: 1px solid #0099FF; padding: 9px 11px;}
            
            body {background-color: #EEE;}
            .header {
                
            }
            .content-main {
                padding: 21px 11px;
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
            #title-box {
                color: #007fba;
                border-bottom: 1px solid #DDD; 
                font-weight: bold; 
                font-size: 14px;
                padding-bottom: 9px;
            }
            .content {
                padding: 21px;
            }
            .box {
                padding: 15px 17px;
                margin: 5px;
                background-color: #F5F5F5;
                border:1px solid #DDD;
                border-radius: 4px;
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
            #box-item {
                font-weight: bold;
                margin: 3px 0px;
                padding: 5px 9px;
                color: #575757;
                background-color: #EEE;
                border:1px solid #DDD;
                border-right: none;
            }
            #box-times {
                font-weight: bold;
                margin: 3px 0px;
                padding: 5px 9px;
                color: #B09595;
                background-color: #EEE;
                border:1px solid #DDD;
                cursor: pointer;
            }
            #box-times:hover {
                font-weight: bold;
                margin: 3px 0px;
                padding: 5px 9px;
                color: #B09595;
                background-color: #FFD9D9;
                border:1px solid #D9B8B8;
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
                font-size: 12px;
                color: #474747;
                font-weight: bold;
                padding: 2px 0px 3px 0px;
            }
            .divinput {
                margin-bottom: 5px;
                padding-bottom: 5px;
            }
            
            .mydate {
                font-weight: bold;
                color: #474747;
            }
            
            #level_select {
                margin-bottom: 5px;
                padding-bottom: 5px;
                visibility: hidden;
            }
            
            #category_select {
                margin-bottom: 5px;
                padding-bottom: 5px;
                visibility: hidden;
            }
            
            #position_select {
                margin-bottom: 5px;
                padding-bottom: 5px;
                visibility: hidden;
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
            h2 {
                padding: 7px 0px 21px 0px;
                margin: 0px 0px 21px 0px;
                border-bottom: 1px solid #DDD;
            }
        </style>
        <script language="JavaScript">
        function cmdSearch(){
                    document.frm.command.value="<%=String.valueOf(Command.LIST)%>";
                    document.frm.action="gap_competency.jsp";
                    document.frm.submit();
        }    
        function cmdExport(){
                document.frpresence.command.value="<%=String.valueOf(Command.LIST)%>";
                document.frpresence.action="export_excel/overtime_report.jsp";
                document.frpresence.submit();
        }    
        
        </script>
       
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
            <span id="menu_title">Laporan Kompetensi <strong style="color:#333;"> / </strong> Gap Kompetensi <strong style="color:#333;"> / </strong>Detail</span>
        </div>
        <div class="content-main">
            <form name="frm" method="post" action="">
                <input type="hidden" name="command" value="<%=iCommand%>">
                <input type="hidden" name="start" value="">
                <div class="box">
                    <div id="title-box">Gap Detail</div>
                    <div>&nbsp;</div>
                    <table style="width: 100%; border: none">
                        <tr>
                            <td rowspan="7">
                                <% 
                                    String pictPath = "";
                                    try {
                                        SessEmployeePicture sessEmployeePicture = new SessEmployeePicture();
                                        pictPath = sessEmployeePicture.fetchImageEmployee(emp.getOID());

                                    } catch (Exception e) {
                                        System.out.println("err." + e.toString());
                                    }%> 
                                    <%
                                         if (pictPath != null && pictPath.length() > 0) {
                                            out.println("<img height=\"135\" id=\"photo\" title=\"Click here to upload\"  src=\"" + approot + "/" + pictPath + "\">");
                                         } else {
                                    %>
                                    <img width="135" height="135" id="photo" src="<%=approot%>/imgcache/no-img.jpg" />
                                    <%

                                        }
                                    %>
                            </td>
                            <td style="width:15%">NRK</td>
                            <td style="width:75%">:&nbsp;<%=emp.getEmployeeNum()%></td>
                        </tr>
                        <tr>
                            <td>NAMA</td>
                            <td>:&nbsp;<%=emp.getFullName()%></td>
                        </tr>
                        <tr>
                            <td>POSISI</td>
                            <td>:&nbsp;<%=position%></td>
                        </tr>
                        <tr>
                            <td>TANGGAL MULAI MENJABAT</td>
                            <td>:&nbsp;<%=workFrom%></td>
                        </tr>
                        <tr>
                            <td>SATUAN KERJA</td>
                            <td>:&nbsp;<%=division%></td>
                        </tr>
                        <tr>
                            <td>UNIT KERJA</td>
                            <td>:&nbsp;<%=department%></td>
                        </tr>
                        <tr>
                            <td>SUB UNIT</td>
                            <td>:&nbsp;<%=section%></td>
                        </tr>
                        <tr>
                            <td>&nbsp;</td>
                            <td colspan="2">
                                <table class="tblStyle" style="width: 100%;">
                                    <tr>
                                        <td class="title_tbl" colspan="4" style="text-align: center; width: 60%">DAFTAR KOMPETENSI</td>
                                        <td class="title_tbl" style="text-align: center; width: 10%">TINGKAT KECAKAPAN KOMPETENSI YANG DIBUTUHKAN SESUAI POSISI</td>
                                        <td class="title_tbl" style="text-align: center; width: 10%">TINGKAT KECAKAPAN KOMPETENSI YANG DIMILIKI</td>
                                        <td class="title_tbl" colspan="2" style="text-align: center; width: 10%">GAP KOMPETENSI (Telah Dinilai)</td>
                                        <td class="title_tbl" colspan="2" style="text-align: center; width: 10%">PENCAPAIAN KOMPETENSI (Telah Dinilai)</td>
                                        <td class="title_tbl" style="text-align: center; width: 10%">KOMPETENSI DIMILIKI (Belum Dinilai)</td>
                                        <td class="title_tbl" style="text-align: center; width: 10%">GAP KOMPETENSI (Belum Dinilai)</td>
                                        <td class="title_tbl" style="text-align: center; width: 10%">PENCAPAIAN KOMPETENSI (Belum Dinilai)</td>
                                    </tr>
                                    <tr>
                                        <td colspan="8">&nbsp;</td>
                                    </tr>
                                    <%
                                    JSONObject empScore = SessRptCompetency.getEmpCompetency(emp.getOID());
                                    JSONObject posScore = SessRptCompetency.getPosCompetency(emp.getPositionId(), emp.getLevelId(), dv.getLevelDivision(), dep.getLevelDepartment(), sec.getLevelSection());
                                    Vector listType = PstCompetencyType.list(0, 0, PstCompetencyType.fieldNames[PstCompetencyType.FLD_ACCUMULATE_IN_ACHIEVMENT]+"=1", "");
                                    for (int i = 0; i < listType.size(); i++){
                                        CompetencyType cType = (CompetencyType) listType.get(i);
                                        double pctType = SessRptCompetency.getPencapaianKompetensiType(emp.getOID(), emp.getPositionId(), cType.getOID(), emp.getLevelId(), dv.getLevelDivision(), dep.getLevelDepartment(), sec.getLevelSection(),0);
                                        double pctTypeNormal = SessRptCompetency.getPencapaianKompetensiType(emp.getOID(), emp.getPositionId(), cType.getOID(), emp.getLevelId(), dv.getLevelDivision(), dep.getLevelDepartment(), sec.getLevelSection(),1);
                                        int gapType = SessRptCompetency.getGapKompetensiType(emp.getOID(), emp.getPositionId(), cType.getOID(), emp.getLevelId(), dv.getLevelDivision(), dep.getLevelDepartment(), sec.getLevelSection(), 0);
                                        int gapTypeBelum = SessRptCompetency.getGapKompetensiType(emp.getOID(), emp.getPositionId(), cType.getOID(), emp.getLevelId(), dv.getLevelDivision(), dep.getLevelDepartment(), sec.getLevelSection(), 1);
                                        double pctTypeBelum = SessRptCompetency.getPencapaianKompetensiTypeBelum(emp.getOID(), emp.getPositionId(), cType.getOID(), emp.getLevelId(), dv.getLevelDivision(), dep.getLevelDepartment(), sec.getLevelSection());
                                        %>
                                        <tr>
                                            <td colspan="4" class="title_tbl_header"><%=cType.getTypeName()%></td>
                                            <td class="title_tbl_header">&nbsp;</td>
                                            <td class="title_tbl_header">&nbsp;</td>
                                            <td class="title_tbl_header" style="text-align: center"><%=(int) gapType%></td>
                                            <td class="title_tbl_header">&nbsp;</td>
                                            <td  class="title_tbl_header" style="text-align: center"><%=(int) pctTypeNormal%>%</td>
                                            <td  class="title_tbl_header" style="text-align: center"><%=(int) pctType%>%</td>
                                            <td class="title_tbl_header">&nbsp;</td>
                                            <td class="title_tbl_header" style="text-align: center"><%=(int) gapTypeBelum%></td>
                                            <td class="title_tbl_header" style="text-align: center"><%=(int) pctTypeBelum%>%</td>
                                        </tr>     
                                        <%
                                        Vector listGroup = PstCompetencyGroup.list(0, 0, PstCompetencyGroup.fieldNames[PstCompetencyGroup.FLD_COMPETENCY_TYPE_ID]+"="+cType.getOID(), "");
                                        for (int x=0; x < listGroup.size(); x++){
                                            CompetencyGroup grp = (CompetencyGroup) listGroup.get(x);
                                            double pctGroup = Math.round(SessRptCompetency.getPencapaianKompetensiGroup(emp.getOID(), emp.getPositionId(), grp.getGroupName(), emp.getLevelId(), dv.getLevelDivision(), dep.getLevelDepartment(), sec.getLevelSection(),0));
                                            double pctGroupNormal = Math.round(SessRptCompetency.getPencapaianKompetensiGroup(emp.getOID(), emp.getPositionId(), grp.getGroupName(), emp.getLevelId(), dv.getLevelDivision(), dep.getLevelDepartment(), sec.getLevelSection(),1));
                                            int gapGroup = SessRptCompetency.getTotalGapGroup(emp.getOID(), emp.getPositionId(), grp.getGroupName(), emp.getLevelId(), dv.getLevelDivision(), dep.getLevelDepartment(), sec.getLevelSection(), 0);
                                            int gapGroupBelum = SessRptCompetency.getTotalGapGroup(emp.getOID(), emp.getPositionId(), grp.getGroupName(), emp.getLevelId(), dv.getLevelDivision(), dep.getLevelDepartment(), sec.getLevelSection(), 1);
                                            double pctGroupBelum = Math.round(SessRptCompetency.getPencapaianKompetensiGroupBelumDinilai(emp.getOID(), emp.getPositionId(), grp.getGroupName(), emp.getLevelId(), dv.getLevelDivision(), dep.getLevelDepartment(), sec.getLevelSection()));
                                            %>
                                            <tr>
                                                <td style="width: 1%; border-right: none !important;" class="title_tbl">&nbsp;</td>
                                                <td style="width: 1%; border-left: none !important; border-right: none !important;" class="title_tbl"><%=x+1%></td>
                                                <td colspan="2" style="border-left: none !important;" class="title_tbl"><%=grp.getGroupName()%></td>
                                                <td class="title_tbl">&nbsp;</td>
                                                <td class="title_tbl">&nbsp;</td>
                                                <td class="title_tbl"style="text-align: center"><%=gapGroup%></td>
                                                <td class="title_tbl">&nbsp;</td>
                                                <td class="title_tbl" style="text-align: center"><%=(int) pctGroupNormal%>%</td>
                                                <td class="title_tbl" style="text-align: center"><%=(int) pctGroup%>%</td>
                                                <td class="title_tbl">&nbsp;</td>
                                                <td class="title_tbl"style="text-align: center"><%=gapGroupBelum%></td>
                                                <td class="title_tbl"style="text-align: center"><%=(int) pctGroupBelum%>%</td>
                                            </tr>     
                                            <%
                                            Vector listCompetency = PstCompetency.list(0, 0, PstCompetency.fieldNames[PstCompetency.FLD_COMPETENCY_GROUP_ID]+"="+grp.getOID(), "");
                                            for (int n=0; n < listCompetency.size(); n++){
                                                Competency comp = (Competency) listCompetency.get(n);
                                                double req = posScore.optDouble(""+comp.getOID(), 0.0);
                                                double score = empScore.optDouble(""+comp.getOID(), 0.0);
                                                String strReq = req > 0 ? ""+((int) req) : "";
                                                String strScore = score > 0 || req > 0 ? ""+(int) score : "";
                                                String strGap = "";
                                                String strGapBelum = "";
                                                String strDiff = "";
                                                double pct = 0;
                                                double pctNormal = 0;
                                                String strPctBelum = "";
                                               
                                                
                                     
                                                if (req > 0){
                                                    if ((req - score) > 0){
                                                        strGap = ""+(int) (score-req);
                                                    } else if ((req-score) == 0) {
                                                        strGap = ""+(int) (score-req);
                                                    } else {
                                                        strGap = "+"+(int) (score-req);
                                                    }
                                                    
                                                    if (score < req) {
                                                        strDiff = strGap;
                                                    } else {
                                                        strDiff = "0";
                                                    }
                                                    pct = Math.round((score/req)*100.0);
                                                    if (pct > 100.0){
                                                        pctNormal = 100.0;
                                                    } else {
                                                        pctNormal = pct;
                                                    }
                                                    
                                                }
                                                
                                                String yesNoD = empScore.optString(""+comp.getOID(),null);
                                                String yesNo = "";
                                                if (req > 0 ){
                                                    if(yesNoD == null){
                                                        yesNo = "belum ada";
                                                        strGapBelum = "-1";
                                                        strPctBelum = "0%";
                                                    }else if (yesNoD != null){
                                                        yesNo = "ada";
                                                        strGapBelum = "0";
                                                         strPctBelum = "100%";
                                                    }
                                                }
                                                
                                                String strPct = pct > 0 || req >0 ? ""+(int) pct+"%" : "";
                                                String strPctNormal = pctNormal > 0 || req >0 ? ""+(int) pctNormal+"%" : "";
                                                %>
                                                <tr>
                                                    <td colspan="2" style="width: 1%; border-right: none !important;">&nbsp;</td>
                                                    <td style="width: 1%; border-left: none !important; border-right: none !important;"><%=n+1%></td>
                                                    <td style="border-left: none !important;"><%=comp.getCompetencyName()%></td>
                                                    <td style="text-align: center"><%=strReq%></td>
                                                    <td style="text-align: center"><%=strScore%></td>
                                                    <td style="text-align: center"><%=strDiff%></td>
                                                    <td style="text-align: center"><%=strGap%></td>
                                                    <td style="text-align: center"><%=strPctNormal%></td>
                                                    <td style="text-align: center"><%=strPct%></td>
                                                    <td style="text-align: center"><%=yesNo%></td>
                                                    <td style="text-align: center"><%=strGapBelum%></td>
                                                    <td style="text-align: center"><%=strPctBelum%></td>
                                                </tr>     
                                                <%
                                            }
                                        }
                                    }
                                    %>
                                </table>
                            </td>
                        </tr>
                    </table>
                </div>
            </form>
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
		<script type="text/javascript">
                var config = {
                    '.chosen-select'           : {},
                    '.chosen-select-deselect'  : {allow_single_deselect:true},
                    '.chosen-select-no-single' : {disable_search_threshold:10},
                    '.chosen-select-no-results': {no_results_text:'Oops, nothing found!'},
                    '.chosen-select-width'     : {width:"100%"}
                }
                for (var selector in config) {
                    $(selector).chosen(config[selector]);
                }

                
                
        </script>  
    </body>
</html>

<%-- 
    Document   : report_daftar_kompetensi
    Created on : Jul 11, 2021, 5:04:17 PM
    Author     : gndiw
--%>

<%@page import="com.dimata.harisma.form.masterdata.CtrlPositionCompetencyRequired"%>
<%@page import="com.dimata.harisma.form.masterdata.FrmPositionCompetencyRequired"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="com.dimata.qdep.db.DBHandler"%>
<%@page import="com.dimata.qdep.db.DBResultSet"%>
<%@page import="java.util.Map.Entry"%>
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
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file = "../../main/javainit.jsp" %>
<% int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_MENU_COMPETENCY, AppObjInfo.G2_MENU_LAPORAN_KOMPETENSI, AppObjInfo.OBJ_MENU_RPT_DAFTAR_COMPETENCY);%>
<%@ include file = "../../main/checkuser.jsp" %>
<!DOCTYPE html>
<%!
   
     public static Vector getList(long positionId, long levelId, int satuanKerja, int levelUnit, int levelSubUnit){
        Vector listData = new Vector();
        
        DBResultSet dbrs = null;
        double count = 0;
        double pct = 0;
        try {
            String sql = "SELECT * "
                    + "FROM hr_view_position_competency_list "
                    + "WHERE position_id = '"+positionId+"' \n"
                    + "AND competency_level_id = '"+levelId+"' \n"
                    + "AND `LEVEL_DIVISION` = '"+satuanKerja+"' \n"
                    + "AND `LEVEL_DEPARTMENT` = '"+levelUnit+"' \n"
                    + "AND `LEVEL_SECTION` = '"+levelSubUnit+"' \n"
                    + "GROUP BY COMPETENCY_ID\n"
                    + "ORDER BY COMPETENCY_TYPE_ID, COMPETENCY_GROUP_ID, COMPETENCY_ID";
            //System.out.println("sql jumlah ::::::::::::::::::::::"+sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                SessRptCompetency rptComp = new SessRptCompetency();
                rptComp.setTypeName(rs.getString("TYPE_NAME"));
                rptComp.setGroupName(rs.getString("GROUP_NAME"));
                rptComp.setCompetencyName(rs.getString("COMPETENCY_NAME"));
                rptComp.setMinReq(rs.getInt("SCORE_REQ_MIN"));
                rptComp.setMaxReq(rs.getInt("SCORE_REQ_RECOMMENDED"));
                listData.add(rptComp);
            }
            rs.close();

        } catch (Exception ex) {
            return listData;
        } finally {
            DBResultSet.close(dbrs);
        }
        
        return listData;
    }
%>
<%
    String strUrl = "";
    strUrl  = "'0',";
    strUrl += "'0',";
    strUrl += "'0',";
    strUrl += "'0',";
    strUrl += "'frm_company_id',";
    strUrl += "'frm_division_id',";
    strUrl += "'frm_department_id',";
    strUrl += "'frm_section_id'";
    
    SessUserSession userSessionn = (SessUserSession)session.getValue(SessUserSession.HTTP_SESSION_NAME);
    AppUser appUserSess1 = userSessionn.getAppUser();
    String namaUser1 = appUserSess1.getFullName();
    
    /* Check Administrator */
    long oidCompetency = 0;
    long oidDivision = 0;
    String strDisable = "";
    String strDisableNum = "";
    if (appUserSess.getAdminStatus()==0 && !privViewAllDivision){
        oidDivision = emplx.getDivisionId();
        strDisable = "disabled=\"disabled\"";
    } if (namaUser1.equals("Employee")){
        strDisableNum = "disabled=\"disabled\"";
    }
    

%>
<%
    int iCommand = FRMQueryString.requestCommand(request);
    long positionId = FRMQueryString.requestLong(request, "positionId");
    long levelId = FRMQueryString.requestLong(request, "levelId");
    int satuanKerja = FRMQueryString.requestInt(request, "satuanKerja");
    int levelUnit = FRMQueryString.requestInt(request, "levelUnit");
    int levelSubUnit = FRMQueryString.requestInt(request, "levelSubUnit");
    
    CtrlPositionCompetencyRequired ctrPosCompetency = new CtrlPositionCompetencyRequired(request);
    FrmPositionCompetencyRequired frmPosCompetency = ctrPosCompetency.getForm();
    Vector listCompetency = getList(positionId, levelId, satuanKerja, levelUnit, levelSubUnit);
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
                    document.frm.target="";
                    document.frm.action="report_daftar_kompetensi.jsp";
                    document.frm.submit();
        }    
        function cmdExport(){
                document.frpresence.command.value="<%=String.valueOf(Command.LIST)%>";
                document.frpresence.action="export_excel/overtime_report.jsp";
                document.frpresence.submit();
        }    
        function cmdDetail(oid){
		document.frm.employee_id.value=oid;
		document.frm.action="gap_competency_detail.jsp";
                document.frm.target="_blank";
		document.frm.submit();
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
            <span id="menu_title">Laporan Kompetensi <strong style="color:#333;"> / </strong> Kompetensi <strong style="color:#333;"> / </strong>Pencarian</span>
        </div>
        <div class="content-main">
            <form name="frm" method="post" action="">
                <input type="hidden" name="command" value="<%=iCommand%>">
                <input type="hidden" name="start" value="">
                <input type="hidden" name="employee_id" value="">
                <div class="box">
                    <div id="title-box">Pencarian Kompetensi</div>
                    <table width="100%">
                        <tr>
                            <td valign="top" width="20%">
                                <div class="caption">
                                    <%=dictionaryD.getWord(I_Dictionary.POSITION)%>
                                </div>
                                <div id="divinput">
                                    <%

                                        Vector pos_value = new Vector(1, 1);
                                        Vector pos_key = new Vector(1, 1);
                                        
                                        Vector listPosition = PstPosition.list(0, 0, "", PstPosition.fieldNames[PstPosition.FLD_POSITION]);

                                        for (int i = 0; i < listPosition.size(); i++) {
                                            Position pos = (Position) listPosition.get(i);
                                            pos_key.add(pos.getPosition());
                                            pos_value.add(String.valueOf(pos.getOID()));
                                        }
                                    %>
                                     <%= ControlCombo.draw("positionId", "chosen-select", null, ""+positionId, pos_key, pos_value, null, "data-placeholder='Select Position...' style='width:50%' id='position'") %> 
                                </div>
                            </td>
                            <td valign="top" width="20%">
                                <div class="caption">
                                    <%=dictionaryD.getWord(I_Dictionary.LEVEL)%>
                                </div>
                                <div id="divinput">
                                    <%

                                        Vector lvl_value = new Vector(1, 1);
                                        Vector lvl_key = new Vector(1, 1);
                                        
                                        Vector listLevel = PstLevel.list(0, 0, "", PstLevel.fieldNames[PstLevel.FLD_LEVEL]);

                                        for (int i = 0; i < listLevel.size(); i++) {
                                            Level lvl = (Level) listLevel.get(i);
                                            lvl_key.add(lvl.getLevel());
                                            lvl_value.add(String.valueOf(lvl.getOID()));
                                        }
                                    %>
                                     <%= ControlCombo.draw("levelId", "chosen-select", null, ""+levelId, lvl_key, lvl_value, null, "data-placeholder='Select Level...' style='width:50%' id='level'") %> 
                                </div>
                            </td>
                            <td valign="top" width="33%">
                                <div class="caption">
                                    Satuan Kerja
                                </div>
                                <div id="divinput">
                                    <%

                                        Vector kelas_value = new Vector(1, 1);
                                        Vector kelas_key = new Vector(1, 1);

                                        for (int i = 0; i < PstDivision.divisionLevel.length; i++) {
                                            kelas_key.add(""+i);
                                            kelas_value.add(""+PstDivision.divisionLevelName[i]);
                                        }
                                    %>
                                    <%= ControlCombo.draw("satuanKerja", "chosen-select", null, ""+satuanKerja, kelas_value, kelas_key, null, "data-placeholder='Select Level...' style='width:50%' id='satuanKerja'") %> 
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td valign="top" width="33%">
                                <div class="caption">
                                    Level Unit
                                </div>
                                <div id="divinput">
                                    <%

                                        Vector levelUnit_value = new Vector(1, 1);
                                        Vector levelUnit_key = new Vector(1, 1);

                                        for (int i = 0; i < PstDepartment.departmentLevel.length; i++) {
                                            levelUnit_key.add(""+i);
                                            levelUnit_value.add(""+PstDepartment.departmentLevelName[i]);
                                        }
                                    %>
                                    <%= ControlCombo.draw("levelUnit", "chosen-select", null, ""+levelUnit, levelUnit_value, levelUnit_key, null, "data-placeholder='Select Level...' style='width:50%' id='levelUnit'") %> 
                                </div>
                            </td>
                            <td valign="top" width="33%">
                                <div class="caption">
                                    Level Sub Unit
                                </div>
                                <div id="divinput">
                                    <%

                                        Vector levelSubUnit_value = new Vector(1, 1);
                                        Vector levelSubUnit_key = new Vector(1, 1);

                                        for (int i = 0; i < PstSection.sectionLevel.length; i++) {
                                            levelSubUnit_key.add(""+i);
                                            levelSubUnit_value.add(""+PstSection.sectionLevelName[i]);
                                        }
                                    %>
                                    <%= ControlCombo.draw("levelSubUnit", "chosen-select", null, ""+levelSubUnit, levelSubUnit_value, levelSubUnit_key, null, "data-placeholder='Select Level...' style='width:50%' id='levelSubUnit'") %> 
                                </div>
                            </td>
                        </tr>
                    </table>
                    <div style="border-top: 1px solid #DDD;">&nbsp;</div>
                    <a href="javascript:cmdSearch()" style="color:#FFF;" class="btn">Search</a>
                    <div>&nbsp;</div>
                </div>
                <div class="box">
                    <div id="title-box">Hasil Pencarian</div>
                    <div>&nbsp;</div>
                    <%
                        if (listCompetency != null && listCompetency.size()>0 && iCommand == Command.LIST){
                            %>
                            <table class="tblStyle" style="width: 100%">
                                <tr>
                                    <td colspan="4" class="title_tbl">DAFTAR_KOMPETENSI</td>
                                    <td class="title_tbl">TINGKAT KECAKAPAN KOMPETENSI YANG DIBUTUHKAN</td>
                                </tr>
                            <%
                            String lastType = "";
                            String lastGroup = "";
                            int cntGroup = 0;
                            int cntComp = 0;
                            for (int i=0; i < listCompetency.size(); i++){
                                SessRptCompetency rpt = (SessRptCompetency) listCompetency.get(i);
                                if (!lastType.equals(rpt.getTypeName())){
                                    lastType = rpt.getTypeName();
                                    cntGroup = 0;
                                    
                                    %>
                                    <tr>
                                        <td colspan="4" class="title_tbl_header"><%=rpt.getTypeName()%></td>
                                        <td  class="title_tbl_header" style="text-align: center"></td>
                                    </tr>     
                                    <%
                                }
                                
                                if (!lastGroup.equals(rpt.getGroupName())){
                                        lastGroup = rpt.getGroupName();
                                    cntComp = 0;
                                    cntGroup++;
                                    
                                    %>
                                    <tr>
                                        <td style="width: 1%; border-right: none !important;" class="title_tbl">&nbsp;</td>
                                        <td style="width: 1%; border-left: none !important; border-right: none !important;" class="title_tbl"><%=cntGroup%></td>
                                        <td colspan="2" style="border-left: none !important;" class="title_tbl"><%=rpt.getGroupName()%></td>
                                        <td class="title_tbl" style="text-align: center"></td>
                                    </tr>     
                                    <%
                                }
                                cntComp++;
                                %>
                                <tr>
                                    <td colspan="2" style="width: 1%; border-right: none !important;">&nbsp;</td>
                                    <td style="width: 1%; border-left: none !important; border-right: none !important;"><%=cntComp%></td>
                                    <td style="border-left: none !important;"><%=rpt.getCompetencyName()%></td>
                                    <td style="text-align: center"><%= rpt.getMinReq() != rpt.getMaxReq() ? rpt.getMinReq()+"-"+rpt.getMaxReq():rpt.getMinReq() %></td>
                                </tr>     
                                <%
                            }
                                %>
                            </table>
                            <%
                        } else {
                    %>
                    <h>Tidak ada data</h>
                    <%  } %>
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

<%-- 
    Document   : training_mapping_compotency
    Created on : Dec 3, 2021, 3:36:12 PM
    Author     : keys
--%>

<%@page import="com.dimata.util.Command"%>
<%@page import="com.dimata.qdep.form.FRMQueryString"%>
<%@page import="java.util.Vector"%>
<%@page import="com.dimata.harisma.session.employee.SessRptCompetency"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="com.dimata.qdep.db.DBHandler"%>
<%@page import="com.dimata.harisma.entity.payroll.PstPaySlip"%>
<%@page import="com.dimata.harisma.entity.payroll.PstPaySlipComp"%>
<%@page import="com.dimata.qdep.db.DBResultSet"%>
<%@page import="com.dimata.harisma.entity.payroll.PayComponent"%>
<%@page import="com.dimata.harisma.entity.payroll.PstPayComponent"%>
<%@page import="com.dimata.harisma.entity.payroll.PayPeriod"%>
<%@page import="com.dimata.harisma.entity.payroll.PstPayPeriod"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file = "../main/javainit.jsp" %>
<!DOCTYPE html>
<%!
   public static Vector getList(long positionId, long levelId, int satuanKerja, int levelUnit, int levelSubUnit){
        Vector listData = new Vector();
        
        DBResultSet dbrs = null;
        double count = 0;
        double pct = 0;
        try {
            String sql = "SELECT comptency.*, `ctype`.`TYPE_NAME`,`cgroup`.`GROUP_NAME` FROM hr_competency comptency"+
                            " INNER JOIN `hr_competency_type` ctype"+
                            " ON comptency.`COMPETENCY_TYPE_ID` = `ctype`.`COMPETENCY_TYPE_ID`"+
                            " INNER JOIN `hr_competency_group` cgroup"+
                            " ON `comptency`.`COMPETENCY_GROUP_ID` = `cgroup`.`COMPETENCY_GROUP_ID`"+
                            " WHERE `ctype`.`ACCUMULATE_IN_ACHIEVMENT` = 1"+
                            " ORDER BY COMPETENCY_TYPE_ID, COMPETENCY_GROUP_ID, COMPETENCY_ID";
                            
            //System.out.println("sql jumlah ::::::::::::::::::::::"+sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                SessRptCompetency rptComp = new SessRptCompetency();
                rptComp.setTypeName(rs.getString("TYPE_NAME"));
                rptComp.setGroupName(rs.getString("GROUP_NAME"));
                rptComp.setCompetencyName(rs.getString("COMPETENCY_NAME"));
                rptComp.setCompetencyId(rs.getLong("COMPETENCY_ID"));
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
    int iCommand = FRMQueryString.requestCommand(request);
    long oidTrainingActivityActual = FRMQueryString.requestLong(request,"oidTrainingActivityActual");
    long oidInsert = FRMQueryString.requestLong(request,"oidInsert");
    String objectName = FRMQueryString.requestString(request,"object_name");
    int searchType = FRMQueryString.requestInt(request, "search_type");
    String serachText  = FRMQueryString.requestString(request, "search");  
    String[] competencyCheck =  null;
     Vector listCompetency = getList(0, 0, 0, 0, 0);
     boolean saveSuccess = true;
     if(iCommand == Command.SAVE){
         competencyCheck = FRMQueryString.requestStringValues(request, "competency");
             boolean deleteMapDetailSuccess = PstTrainingCompetencyMappingDetail.deleteCompetencyDetailMapByTrainingActualI(oidTrainingActivityActual);
             boolean deleteSuccess = PstTrainingCompetencyMapping.deleteCompetencyMapByTrainingActualId(oidTrainingActivityActual);
             if(competencyCheck != null){
                 for(int x = 0 ; x < competencyCheck.length; x++){
                    double score = FRMQueryString.requestDouble(request, competencyCheck[x]);
                    TrainingCompetencyMapping objTraininingComMap = new TrainingCompetencyMapping();
                    objTraininingComMap.setTrainingActivityActualId(oidTrainingActivityActual);
                    objTraininingComMap.setCompetencyId(Long.parseLong(competencyCheck[x]));
                    objTraininingComMap.setScore(score);
                    try{
                    PstTrainingCompetencyMapping.insertExc(objTraininingComMap);
                    }catch(Exception exc){
                        saveSuccess = false;
                        System.out.println("Error insert map :"+exc);
                    }
               }
             }
             
         
        if(oidTrainingActivityActual != 0){
          TrainingCompetencyMappingDetail.autoInsertComptencyMapDetail(oidTrainingActivityActual);
          TrainingCompetencyMappingDetail.generateEmployeeCompetency(oidTrainingActivityActual);
        }
         
     }

%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Document Employee Search</title>
        <link rel="stylesheet" href="../../styles/main.css" type="text/css">
        <style type="text/css">
            .tblStyle {border-collapse: collapse; font-size: 12px; }
            .tblStyle td {padding: 5px 7px; border: 1px solid #CCC; font-size: 12px; }
            .title_tbl {font-weight: bold; background-color: #DDD; color: #575757;}
            .title_tbl_header {font-weight: bold; background-color: yellowgreen; color: #575757;}
            .title_page {color:#0db2e1; font-weight: bold; font-size: 14px; background-color: #EEE; border-left: 1px solid #0099FF; padding: 12px 18px;}
            
            body {
                margin: 0;
                padding: 0;
                font-size: 12px;
                font-family: sans-serif;
            }
            .header {
                background-color: #EEE;
                padding: 21px;
                border-bottom: 1px solid #DDD;
            }
            .content {
                padding: 21px;
            }
            #caption, .caption {
                font-size: 12px;
                color: #474747;
                font-weight: bold;
                padding: 2px 0px 3px 0px;
            }
            #divinput, .divinput {
                margin-bottom: 5px;
                padding-bottom: 5px;
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
                padding: 3px 5px; 
                background-color: #EEE; color: #575757; 
                font-size: 11px; cursor: pointer;
                border-radius: 3px;
                border: 1px solid #DDD;
            }
            .btn-small-1:hover { background-color: #DDD; color: #474747;}
        </style>
<script type="text/javascript">

  function search(){
    document.frm.action="training_mapping_compotency.jsp";
    document.frm.command.value=<%=Command.SEARCH%>;
    document.frm.submit();
   }

function simpan(oidTrainingActual){
    document.frm.action="training_mapping_compotency.jsp";
    document.frm.command.value=<%=Command.SAVE%>;
    document.frm.submit();
}

</script>
<link rel="stylesheet" href="<%=approot%>/javascripts/datepicker/themes/jquery.ui.all.css">
<script src="<%=approot%>/javascripts/jquery.js"></script>
<script src="../../javascripts/chosen.jquery.js" type="text/javascript"></script>
<link rel="stylesheet" href="../../stylesheets/chosen.css" >
    </head>
    <body onload="pageLoad()">
        <div class="header">
            <h2 style="color:#999">Mapping Kompetensi</h2>
            <%
            if (oidInsert != 0){
                %>
                <div style="padding: 9px; background-color: #DDD;">Data Berhasil disimpan</div>
                <%
            }
            %>
        </div>
        <div class="content">
            <form name="frm" method="post" action="">
                <input type="hidden" id="command" name="command" value="<%= iCommand %>" />
                <input type="hidden" id="oidTrainingActivityActual" name="oidTrainingActivityActual" value="<%= oidTrainingActivityActual %>" />
                <input type="hidden" id="oid_emp_doc" name="oidInsert" value="<%= oidInsert %>" />
                <input type="hidden" id="object_name" name="object_name" value="<%= objectName %>" />
                <%if(saveSuccess && iCommand == Command.SAVE){%>
                <table width="100%">
                    <tr>
                        <td>
                            <div>&nbsp;</div>
                            <div style="background-color:#CAEEFA; color:#3D7587; padding: 8px 12px;">
                                Data berhasil tersimpan
                            </div>
                        </td>
                    </tr>
                </table>
                <%}%>
                 <%
                        if (listCompetency != null && listCompetency.size()>0 ){
                            %>
                              
                            <table class="tblStyle" style="width: 100%">
                            <%
                            String lastType = "";
                            String lastGroup = "";
                            int cntGroup = 0;
                            int cntComp = 0;
                            
                            %>
                            <tr>
                                <td style="width: 1%; border-right: none !important;" class="title_tbl" colspan="6"> 
                                    <input type="text" name="search" placeholder="search"  value="<%=serachText%>" id="search"  onchange="search()">
                                    <a href="javascript:search()" class="btn"> Search </a>
                                </td>
                                
                              
                            </tr>
                            
                                <tr>
                                    <th style="width: 1%; border-right: none !important; height:30px;" class="title_tbl" colspan="4">Kompetensi</th>
                                    <th class="title_tbl" style="text-align: center">Level</th>
                                    <th class="title_tbl" style="text-align: center">Pilih</th>
                                </tr>   
                            <%
                            for (int i=0; i < listCompetency.size(); i++){
                                SessRptCompetency rpt = (SessRptCompetency) listCompetency.get(i);
                                if (!lastType.equals(rpt.getTypeName())){
                                    lastType = rpt.getTypeName();
                                    cntGroup = 0;
                                    
                                    %>
                                    <tr>
                                        <td colspan="5" class="title_tbl_header"><%=rpt.getTypeName()%></td>
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
                                        <td style="width: 1%; border-left: none !important; border-right: none !important;" class="title_tbl">&nbsp;</td>
                                        <td colspan="2" style="border-left: none !important;" class="title_tbl"><%=rpt.getGroupName()%></td>
                                        <td class="title_tbl" style="text-align: center"></td>
                                        <td class="title_tbl" style="text-align: center"></td>
                                    </tr>     
                                    <%
                                }
                                cntComp++;



                                boolean showInView = true;
                                
                                Hashtable listMapping =   PstTrainingCompetencyMapping.listHashByTrainingActualId(oidTrainingActivityActual);
                                if(iCommand == Command.SEARCH){
                                    
                                    if(rpt.getCompetencyName().toUpperCase().contains(serachText.toUpperCase())){
                                        showInView = true;
                                    }else{
                                        showInView =false;
                                    }
                                }
                            
                               
                                boolean competencyChecked = false;
                                if(listMapping.size() > 0){
                                      competencyChecked = listMapping.containsKey(rpt.getCompetencyId());
                                }
                                
                                
                                if(showInView || competencyChecked){
                                %>
                                
                                
                                <tr>
                                    <td colspan="2" style="width: 1%; border-right: none !important;">&nbsp;</td>
                                    <td style="width: 1%; border-left: none !important; border-right: none !important;">&nbsp;</td>
                                    <td style="border-left: none !important;"><%=rpt.getCompetencyName()%></td>
                                    <td style="text-align: center">
                                        <select  name="<%=rpt.getCompetencyId()%>">
                                             <%
                                               
                                                Vector ListCompetency = PstCompetencyLevel.list(0, 0, ""+PstCompetencyLevel.fieldNames[PstCompetencyLevel.FLD_COMPETENCY_ID]+" = "+rpt.getCompetencyId(), ""+PstCompetencyLevel.fieldNames[PstCompetencyLevel.FLD_SCORE_VALUE]+" ASC");
                                                String selected = "";
                                                String scoreSelected = String.valueOf(listMapping.get(rpt.getCompetencyId()));
                                                for(int xy = 0; xy < ListCompetency.size(); xy++){
                                                    CompetencyLevel objCompetencyLevel = (CompetencyLevel) ListCompetency.get(xy);
                                                    selected = "";
                                                     if(scoreSelected != null){
                                                        if(scoreSelected.equals(""+objCompetencyLevel.getScoreValue())){
                                                            selected = "selected";
                                                        } 
                                                     }
                                                    
                                                  
                                             %>
                                             <option value="<%=objCompetencyLevel.getScoreValue()%>"  title="<%=objCompetencyLevel.getDescription()%>" <%=selected%>><%=objCompetencyLevel.getLevelName()%></option>
                                             <%
                                                 }
                                             %>
                                        </select>
                                    </td>
                                   
                                    <td style="text-align: center"><input type="checkbox" <%=competencyChecked ? "checked":""%> name="competency" value="<%=rpt.getCompetencyId()%>"></td>
                                </tr>    
                                
                                <%
                                    }
                            }
                                %>
                                
                              
                                        
                                  
                            </table>
                                <br>
                                <br>
                            <div>
                                <a href="javascript:simpan()" class="btn"> Simpan </a>
                            </div>
                            <%
                        } else {
                    %>
                    <h>Tidak ada data</h>
                    <%  } %>
            </form>
        </div>
    </body>

</html>

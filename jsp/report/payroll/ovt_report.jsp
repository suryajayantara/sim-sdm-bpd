<%-- 
    Document   : Search ESPT Form A1 , for closing in middle of year also Annual
    Created on : Dec 28, 2015, 17:55 
    Author     : Kartika
--%>

<%@page import="com.dimata.harisma.form.search.FrmSrcOvertimeReport"%>
<%@page import="com.dimata.harisma.entity.search.SrcOvertimeReport"%>
<%@page import="com.dimata.harisma.entity.payroll.PstPayPeriod"%>
<%@page import="com.dimata.harisma.entity.payroll.PayPeriod"%>
<%@page import="com.dimata.harisma.entity.payroll.Ovt_Type"%>
<%@page import="com.dimata.qdep.entity.I_DocStatus"%>
<%@page import="com.dimata.harisma.entity.payroll.Ovt_Idx"%>
<%@page import="com.dimata.harisma.entity.payroll.PstOvt_Idx"%>
<%@page import="com.dimata.harisma.entity.overtime.PstOvertimeDetail"%>
<%@page import="com.dimata.harisma.entity.overtime.OvertimeDetail"%>
<%@page import="com.dimata.harisma.entity.payroll.PstOvt_Type"%>
<%@ page language="java" %>

<%@ page import ="java.util.*"%>
<%@ page import = "java.util.Date" %>
<%@ page import = "java.text.*" %>

<%@ page import ="com.dimata.gui.jsp.*"%>
<%@ page import ="com.dimata.util.*"%>
<%@ page import ="com.dimata.qdep.form.*"%>

<%@ include file = "../../main/javainit.jsp" %>
<% int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_REPORTS, AppObjInfo.G2_PAYROLL_REPORT, AppObjInfo.OBJ_LIST_SALARY_SUMMARY_REPORT);
   // int appObjCodePresenceEdit = AppObjInfo.composeObjCode(AppObjInfo.G1_EMPLOYEE, AppObjInfo.G2_ATTENDANCE, AppObjInfo.OBJ_PRESENCE);
   //boolean privUpdatePresence = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodePresenceEdit, AppObjInfo.COMMAND_UPDATE));
%>
<%@ include file = "../../main/checkuser.jsp" %>
<% 
    long hrdDepOid = Long.parseLong(String.valueOf(PstSystemProperty.getPropertyLongbyName(OID_HRD_DEPARTMENT)));
    boolean isHRDLogin = hrdDepOid == departmentOid ? true : false;
    long edpSectionOid = Long.parseLong(String.valueOf(PstSystemProperty.getPropertyLongbyName(OID_EDP_SECTION)));
    boolean isEdpLogin = edpSectionOid == sectionOfLoginUser.getOID() ? true : false;
    boolean isGeneralManager = positionType == PstPosition.LEVEL_GENERAL_MANAGER ? true : false;
%>
<%!
    public String getSectionLink(String sectionId){
        String str = "";
        try{
            Section section = PstSection.fetchExc(Long.valueOf(sectionId));
            str = section.getSection();
            return str;
        } catch(Exception e){
            System.out.println(e);
        }
        return str;
    }
    
    public String drawList(Vector objectClass, String whereClause) {

        String result = "";
	
        ControlList ctrlist = new ControlList();
        ctrlist.setAreaWidth("100%");
        ctrlist.setListStyle("tblStyle");
        ctrlist.setTitleStyle("title_tbl");
        ctrlist.setCellStyle("listgensell");
        ctrlist.setHeaderStyle("title_tbl");
        ctrlist.setCellSpacing("0");

        ctrlist.addHeader("<center>No.</center>","", "2", "0");
        ctrlist.addHeader("<center>NRK</center>","", "2", "0");
        ctrlist.addHeader("<center>Nama</center>","", "2", "0");
        ctrlist.addHeader("<center>Jabatan</center>","", "2", "0");
        ctrlist.addHeader("<center>Divisi</center>","", "2", "0");
        
        ctrlist.addHeader(""+PstOvt_Type.nameOvtIndonesia[PstOvt_Type.WORKING_DAY],"", "1", "2");
        
        /* wd */
        ctrlist.addHeader("Satu Jam Pertama","","0","0");
        ctrlist.addHeader("Diatas 1 Jam","","0","0");  
        
        ctrlist.addHeader(""+PstOvt_Type.nameOvtIndonesia[PstOvt_Type.SCHEDULE_OFF],"", "1", "3");

           

        /* so */
        ctrlist.addHeader("8 Jam Pertama","","0","0");
        ctrlist.addHeader("Jam ke-9","","0","0");        
        ctrlist.addHeader("Jam ke-10 & 11","","0","0");
        
        ctrlist.addHeader("<center>"+PstOvt_Type.nameOvtIndonesia[PstOvt_Type.HOLIDAY]+"</center>","", "2", "0");
        ctrlist.addHeader("<center>Lembur</center>","", "1", "2");
        /* ov */
        ctrlist.addHeader("Rek. Simpeda","","0","0");
        ctrlist.addHeader("Uang Lembur (Rp)","","0","0");

        ctrlist.setLinkRow(-1);
        ctrlist.setLinkSufix("");
        Vector lstData = ctrlist.getData();
        Vector lstLinkData = ctrlist.getLinkData();
        ctrlist.setLinkPrefix("javascript:cmdEdit('");
        ctrlist.setLinkSufix("')");
        ctrlist.reset();
        Vector rowx = new Vector(1,1);
	int index = -1;
        
        Vector listOvt = new Vector();
        Employee emp = new Employee();
        Position pos = new Position();
        Division div = new Division();
                
        if(objectClass!=null && objectClass.size()>0){
            for(int i=0; i<objectClass.size(); i++){
                
                double durasi = 0.0;
                double totIdxWD = 0.0;
                double totIdxH = 0.0;
                double totIdxSO = 0.0;

                double durasiWD = 0.0;
                double JamWDP = 0.0;
                double JamWDK = 0.0;

                double durasiH = 0.0;

                double durasiSO = 0.0;
                double jamVIIISO = 0.0;
                double jamIXSO = 0.0;
                double jamXSO = 0.0;

                int overType = 0;
                String noRek = "";

                long religionId = 0;
                
                OvertimeDetail empTime = (OvertimeDetail) objectClass.get(i);
                rowx = new Vector();
                
                rowx.add(String.valueOf(i+1));
                
                try{
                    if(empTime.getEmployeeId() != 0){
                        emp = PstEmployee.fetchExc(empTime.getEmployeeId());
                        
                        religionId = emp.getReligionId();
                        
                        rowx.add(String.valueOf(emp.getEmployeeNum()));
                        rowx.add(String.valueOf(emp.getFullName()));
                        if(emp.getPositionId() != 0){
                            pos = PstPosition.fetchExc(emp.getPositionId());
                            
                            rowx.add(String.valueOf(pos.getPosition()));
                        } else {
                            rowx.add("");
                        }
                        if(emp.getDivisionId() != 0){
                            div = PstDivision.fetchExc(emp.getDivisionId());
                            
                            rowx.add(String.valueOf(div.getDivision()));
                        } else {
                            rowx.add("");
                        }
                        if(!emp.getNoRekening().equals("") && !emp.getNoRekening().equals(null)){
                            noRek = emp.getNoRekening();
                        }
                    } else {
                        rowx.add("");
                        rowx.add("");
                        rowx.add("");
                        rowx.add("");
                    }
                } catch(Exception e){
                    
                }
                
                //whereClause = whereClause + " AND odt." + PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID]+"='"+empTime.getEmployeeId()+"'";
                listOvt = PstOvertimeDetail.list3(0, 0, whereClause + " AND odt." + PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID]+"='"+empTime.getEmployeeId()+"'", "");
                for(int j=0; j<listOvt.size(); j++){
                    OvertimeDetail empTime2 = (OvertimeDetail) listOvt.get(j);
                    
                    durasi = Formater.formatDurationTime2(empTime2.getDateFrom(), empTime2.getDateTo(), true);
                    
                    overType = getOvertimeType(empTime2.getDateFrom(), religionId);
                    
                    if(overType == PstOvt_Type.WORKING_DAY){
                        //durasiWD = durasiWD + durasi;
                        totIdxWD = totIdxWD + getOvIdx(emp.getOID(), durasi, overType);
                        if(durasi > 1){
                            JamWDK = JamWDK + (durasi-1);
                            JamWDP = JamWDP + 1;
                        } 
                        if(durasi == 1){
                            JamWDP = JamWDP + 1;
                        }
                        //durasiWD = 0;
                    } else if(overType == PstOvt_Type.SCHEDULE_OFF){
                        //durasiSO = durasiSO + durasi;
                        totIdxSO = totIdxSO + getOvIdx(emp.getOID(), durasi, overType);
                        if(durasi > 9 &&  durasi < 12){
                            jamVIIISO = jamVIIISO + 8;
                            jamIXSO = jamIXSO + 1;
                            jamXSO = jamXSO + (durasi-9);
                        } 
                        if(durasi == 9){
                            jamVIIISO = jamVIIISO + 8;
                            jamIXSO = jamIXSO + 1;
                        } 
                        if(durasi == 8){
                            jamVIIISO = jamVIIISO + 8;
                        }
                        //durasiSO = 0;
                    } else if(overType == PstOvt_Type.HOLIDAY){
                        durasiH = durasiH + durasi;
                        totIdxH = totIdxH + getOvIdx(emp.getOID(), durasiH, overType);
                       // durasiH = 0;
                    } else {
                        
                    }
                    
                   // totIdx = getOvIdx(emp.getOID(), durasi, overType);
                }    
                
                rowx.add(String.valueOf(Formater.formatNumber(Math.round(JamWDP),"#,###.##")));
                rowx.add(String.valueOf(Formater.formatNumber(Math.round(JamWDK),"#,###.##")));
                rowx.add(String.valueOf(Formater.formatNumber(Math.round(jamVIIISO),"#,###.##")));
                rowx.add(String.valueOf(Formater.formatNumber(Math.round(jamIXSO),"#,###.##")));
                rowx.add(String.valueOf(Formater.formatNumber(Math.round(jamXSO),"#,###.##")));
                rowx.add(String.valueOf(Formater.formatNumber(Math.round(durasiH),"#,###.##")));
                rowx.add(String.valueOf(noRek));
                rowx.add(String.valueOf(Formater.formatNumber((totIdxWD+totIdxSO+totIdxH),"#,###.##")));
                                                
                lstData.add(rowx);
            }
            result = ctrlist.drawList();
        }
        
        return result;

    }
    
    public int getOvertimeType(Date dtParam, long religionId) {
        int result = 0;
        Vector listPH = new Vector();
        
        listPH = PstPublicHolidays.list(0, 0, "'"+Formater.formatDate(dtParam, "yyyy-MM-dd")+"' BETWEEN  holiday_date AND holiday_date_to", "holiday_status");
        
        if(listPH.size() > 0){
            for(int i = 0; i < listPH.size(); i++){
                PublicHolidays pH = (PublicHolidays)listPH.get(i);
                if(pH.getiHolidaySts() == 1 || religionId == pH.getiHolidaySts()){
                    result = PstOvt_Type.HOLIDAY;
                    i = listPH.size();
                }
            }
        } else {
            String[] stDays = {
		"Sunday","Monday","Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"
            };
            
            Calendar objCal = Calendar.getInstance();
            objCal.setTime(dtParam);
            
            String day = stDays[objCal.get(Calendar.DAY_OF_WEEK)-1];
            if(day == stDays[0] || day == stDays[6]){
                result = PstOvt_Type.SCHEDULE_OFF;
            } else {
                result = PstOvt_Type.WORKING_DAY;
            }
        }
        
        return result;
    }
    public int getEmpLvlRank(String where) {
        int result = 0;
        Vector empLevelRank = PstLevel.list(0, 0, where, "");
        if(empLevelRank.size() > 0){
            for(int i = 0; i < empLevelRank.size(); i++){
                Level lvl = (Level)empLevelRank.get(i);
                result = lvl.getLevelRank();
            }
        }
        
        return result;
    }
    public Double getOvIdx(long oid, double realDur, int typeOfDay) {
        double result = 0.0;
        int empLvlMin = 0;
        int empLvlMax = 0;
        
        String whereEmpLvlRank = "level_id=(SELECT level_id FROM  hr_employee WHERE employee_id='"+oid+"')";
        String whereMin = "";
        String whereMax = "";
        String ovTypeCode = "";
        
        int empLvlRank = getEmpLvlRank(whereEmpLvlRank);
        
        Vector ovtTyp = PstOvt_Type.list(0, 0, PstOvt_Type.fieldNames[PstOvt_Type.FLD_TYPE_OF_DAY]+"='"+typeOfDay+"'", "");
        if(ovtTyp.size() > 0){
            for(int i = 0; i < ovtTyp.size(); i++){
                Ovt_Type opt = (Ovt_Type)ovtTyp.get(i);
                
                Vector levelRankMin = PstLevel.list(0, 0, "", "");
                whereMin = "level_id='"+opt.getMasterLevelMin()+"'";
                whereMax = "level_id='"+opt.getMasterLevelMax()+"'";
                empLvlMin = getEmpLvlRank(whereMin);
                empLvlMax = getEmpLvlRank(whereMax);
                
                if(empLvlRank >= empLvlMin && empLvlRank <= empLvlMax){
                    ovTypeCode = opt.getOvt_Type_Code();                    
                }
            }
        }
        
        Vector ovtIdx = PstOvt_Idx.list(0, 0, PstOvt_Idx.fieldNames[PstOvt_Idx.FLD_OVT_TYPE_CODE]+"='"+ovTypeCode+"'", "HOUR_FROM");
        if(ovtIdx.size() > 0){
            for(int i = 0; i < ovtIdx.size(); i++){
                Ovt_Idx ovt_Idx = (Ovt_Idx)ovtIdx.get(i);
                //1 , 5, 3
                if(typeOfDay == PstOvt_Type.HOLIDAY){
                    if(realDur < ovt_Idx.getHour_from() && realDur == 0){
                        result = getOvIdx(oid, realDur, PstOvt_Type.SCHEDULE_OFF);
                        i = ovtIdx.size();
                    } else {
                        result = result + ovt_Idx.getOvt_idx();
                    }
                } else {
                    for(int j = 1; j <= realDur; j++){
                        if(j >= ovt_Idx.getHour_from() && j <= ovt_Idx.getHour_to()){
                            result = result + ovt_Idx.getOvt_idx();
                        }
                    }
                }
            }
        }
        
        return result;
    }
    
%>
<!DOCTYPE html>
<%  

    /* Update by Hendra Putu | 20150226 */
    int iCommand = FRMQueryString.requestCommand(request);
    long periodId = FRMQueryString.requestLong(request, "inp_period_id");
    long companyId = FRMQueryString.requestLong(request, "company_id");
    long divisionId = FRMQueryString.requestLong(request, "division_id");
    long departmentId = FRMQueryString.requestLong(request, "department_id");
    long sectionId = FRMQueryString.requestLong(request, "inp_section_id");
    long search = 0 ;
    try{ search = FRMQueryString.requestLong(request, "search");} catch (Exception e){}
    SrcOvertimeReport srcOvertimeReport = new SrcOvertimeReport();
    FrmSrcOvertimeReport frmSrcOvertimeReport = new FrmSrcOvertimeReport(request, srcOvertimeReport);

    Vector listTime = new Vector();
    String whereClause="odt."+PstOvertimeDetail.fieldNames[PstOvertimeDetail.FLD_STATUS]+"='"+I_DocStatus.DOCUMENT_STATUS_PROCEED+"'";

    if (iCommand == Command.LIST){
        frmSrcOvertimeReport.requestEntityObject(srcOvertimeReport);
        
        
        /*if(!srcOvertimeReport.getPayroll().equals("") && !srcOvertimeReport.getPayroll().equals(null)){
            whereClause = whereClause + " AND " + PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_NUM]+"='"+srcOvertimeReport.getPayroll()+"'";
        }
        if(!srcOvertimeReport.getFullname().equals("") && !srcOvertimeReport.getFullname().equals(null)){
            whereClause = whereClause + " AND " + PstEmployee.fieldNames[PstEmployee.FLD_FULL_NAME]+"='"+srcOvertimeReport.getFullname()+"'";
        }*/
        if(search == 0){
            PayPeriod payPeriod = null;
            try {
                payPeriod = PstPayPeriod.fetchExc(periodId);
                if (payPeriod == null || payPeriod.getOID() == 0) {
                    throw new Exception("Payroll Period can't not be get with id=" + periodId, new Throwable());
                }
            } catch (Exception exc) {
                throw new Exception("Payroll Period can't not be get with id=" + periodId, exc);
            }
             if (payPeriod.getEndDate() != null && payPeriod.getStartDate() != null) {
                whereClause += " AND odt.DATE_FROM >= '"+payPeriod.getStartDate()+"%' AND odt.DATE_TO <= '"+payPeriod.getEndDate()+"%'";
            } else {
                
            }
            if (divisionId != 0) {
                whereClause += " AND emp.DIVISION_ID=" + divisionId + " ";
            }
            if (departmentId != 0) {
                whereClause += " AND emp.DEPARTMENT_ID=" + departmentId + " ";
            }
            if (sectionId != 0) {
                whereClause += " AND emp.SECTION_ID=" + sectionId + " ";
            }
        }
        
        listTime = PstOvertimeDetail.list4(0, 0, whereClause, "");
        
    }
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Search Overtime Report</title>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
        <link rel="stylesheet" href="../../styles/main.css" type="text/css">
        <link rel="stylesheet" href="../../styles/tab.css" type="text/css">
        <link href="<%=approot%>/stylesheets/superTables.css" rel="Stylesheet" type="text/css" /> 
        <style type="text/css">
            .tblStyle {border-collapse: collapse; font-size: 12px;}
            .tblStyle td {padding: 7px 9px; border: 1px solid #CCC; font-size: 12px;}
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
            function compChange(val) 
            {
                document.<%=frmSrcOvertimeReport.FRM_SRC_OVERTIME_REPORT%>.command.value = "<%=Command.GOTO%>";
                document.<%=frmSrcOvertimeReport.FRM_SRC_OVERTIME_REPORT%>.company_id.value = val;
                document.<%=frmSrcOvertimeReport.FRM_SRC_OVERTIME_REPORT%>.division_id.value = "0";
                document.<%=frmSrcOvertimeReport.FRM_SRC_OVERTIME_REPORT%>.department_id.value = "0";
                document.<%=frmSrcOvertimeReport.FRM_SRC_OVERTIME_REPORT%>.action = "ovt_report.jsp";
                document.<%=frmSrcOvertimeReport.FRM_SRC_OVERTIME_REPORT%>.submit();
            }
            function divisiChange(val) 
            {
                document.<%=frmSrcOvertimeReport.FRM_SRC_OVERTIME_REPORT%>.command.value = "<%=Command.GOTO%>";
                document.<%=frmSrcOvertimeReport.FRM_SRC_OVERTIME_REPORT%>.division_id.value = val;
                document.<%=frmSrcOvertimeReport.FRM_SRC_OVERTIME_REPORT%>.action = "ovt_report.jsp";
                document.<%=frmSrcOvertimeReport.FRM_SRC_OVERTIME_REPORT%>.submit();
            }
            function deptChange(val) 
            {
                document.<%=frmSrcOvertimeReport.FRM_SRC_OVERTIME_REPORT%>.command.value = "<%=Command.GOTO%>";	
                document.<%=frmSrcOvertimeReport.FRM_SRC_OVERTIME_REPORT%>.department_id.value = val;
                document.<%=frmSrcOvertimeReport.FRM_SRC_OVERTIME_REPORT%>.action = "ovt_report.jsp";
                document.<%=frmSrcOvertimeReport.FRM_SRC_OVERTIME_REPORT%>.submit();
            }
            
            function cmdSearch(){ 
                var n = document.getElementById('inp_period_id').value;
                if(n == 0){
                   alert("Periode Belum Dipilih.");
                } else {
                    document.<%=frmSrcOvertimeReport.FRM_SRC_OVERTIME_REPORT%>.command.value="<%=Command.LIST%>";
                    document.<%=frmSrcOvertimeReport.FRM_SRC_OVERTIME_REPORT%>.action="ovt_report.jsp";
                    document.<%=frmSrcOvertimeReport.FRM_SRC_OVERTIME_REPORT%>.submit();
                }
            }
            
            function cmdSearchAll(){ 
                document.<%=frmSrcOvertimeReport.FRM_SRC_OVERTIME_REPORT%>.command.value="<%=Command.LIST%>";
                document.<%=frmSrcOvertimeReport.FRM_SRC_OVERTIME_REPORT%>.action="ovt_report.jsp?search=1";
                document.<%=frmSrcOvertimeReport.FRM_SRC_OVERTIME_REPORT%>.submit();
            }
                                                                                                                       
            function cmdExportExcel(){	 
                document.<%=frmSrcOvertimeReport.FRM_SRC_OVERTIME_REPORT%>.action="<%=approot%>/servlet/espta1.xls"; 
                document.<%=frmSrcOvertimeReport.FRM_SRC_OVERTIME_REPORT%>.target = "ReportExcelA1";
                document.<%=frmSrcOvertimeReport.FRM_SRC_OVERTIME_REPORT%>.submit();
            }
            
            function cmdExportExcelAll(){	
                document.<%=frmSrcOvertimeReport.FRM_SRC_OVERTIME_REPORT%>.search.value = "<%=1%>";
                document.<%=frmSrcOvertimeReport.FRM_SRC_OVERTIME_REPORT%>.action="<%=approot%>/servlet/espta1.xls"; 
                document.<%=frmSrcOvertimeReport.FRM_SRC_OVERTIME_REPORT%>.target = "ReportExcelA1";
                document.<%=frmSrcOvertimeReport.FRM_SRC_OVERTIME_REPORT%>.submit();
            }
        </script>
    </head>
    <body <%=noBack%> bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
        <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%" bgcolor="#F9FCFF" >
            <%if (headerStyle && !verTemplate.equalsIgnoreCase("0")) {%> 
            <%@include file="../../styletemplate/template_header.jsp" %>
            <%} else {%>
            <tr> 
                <td ID="TOPTITLE" background="<%=approot%>/images/HRIS_HeaderBg3.jpg" width="100%" height="54"> 
                    <!-- #BeginEditable "header" --> 
                    <%@ include file = "../../main/header.jsp" %>
                    <!-- #EndEditable --> </td>
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
            <tr> 
                <td width="88%" valign="top" align="left"> 
                    <table width="100%" border="0" cellspacing="3" cellpadding="2" id="tbl0">
                        <tr> 
                            <td width="100%" colspan="3" valign="top" style="padding: 12px"> 
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr> 
                                        <td height="20"> <div id="menu_utama"> <!-- #BeginEditable "contenttitle" -->Overtime Report<!-- #EndEditable --> </div> </td>
                                    </tr>
                                    <tr>
                                        <td>&nbsp;</td>
                                    </tr>
                                    <tr>
                                        <td style="background-color:#EEE;" valign="top">
                                        
                                            <table style="padding:9px; border:1px solid #00CCFF;" <%=garisContent%> width="100%" border="0" cellspacing="1" cellpadding="1" class="tablecolor">
                                                <tr>
                                                    <td valign="top">
                                                        <div id="mn_utama">Search Data for Overtime</div>
                                                        <form name="<%=frmSrcOvertimeReport.FRM_SRC_OVERTIME_REPORT%>" method="POST" action="">
                                                            <input type="hidden" name="command" value="<%=iCommand%>" />
                                                            <input type="hidden" name="search" value="<%=0%>" />
                                                            <table>
                                                                <tr>
                                                                    <td valign="top" id="tdForm">Period</td>
                                                                    <td valign="top" id="tdForm">
                                                                        <select id="inp_period_id" name="inp_period_id">
                                                                            <option value="0">-select-</option>
                                                                        <%
                                                                        String selectedPeriod = "";
                                                                        Vector listPeriod = PstPayPeriod.list(0, 0, "", "START_DATE DESC"); 
                                                                        if (listPeriod != null && listPeriod.size() > 0){
                                                                            for(int i=0; i<listPeriod.size(); i++){
                                                                                PayPeriod periods = (PayPeriod)listPeriod.get(i);
                                                                                
                                                                                if (periodId == periods.getOID()){
                                                                                    selectedPeriod = " selected=\"selected\"";
                                                                                } else {
                                                                                    selectedPeriod = " ";
                                                                                }
                                                                                %>
                                                                                <option value="<%=periods.getOID()%>" <%=selectedPeriod%>><%=periods.getPeriod()%></option>
                                                                                <%
                                                                            }
                                                                        }
                                                                        %>
                                                                        </select>
                                                                    </td>
                                                                </tr>
                                                                <%
                                                                    /*
                                                                     * Description : get value Company, Division, Department, and Section
                                                                     * Date : 2015-02-17
                                                                     * Author : Hendra Putu
                                                                     */
                                                                    // List Company
                                                                    Vector comp_value = new Vector(1, 1);
                                                                    Vector comp_key = new Vector(1, 1);
                                                                    comp_value.add("0");
                                                                    comp_key.add("-select-");
                                                                    String comp_selected = "";
                                                                    // List Division
                                                                    Vector div_value = new Vector(1, 1);
                                                                    Vector div_key = new Vector(1, 1);
                                                                    String whereDivision = "COMPANY_ID = " + companyId;
                                                                    div_value.add("0");
                                                                    div_key.add("-select-");
                                                                    String div_selected = "";
                                                                    // List Department
                                                                    Vector depart_value = new Vector(1, 1);
                                                                    Vector depart_key = new Vector(1, 1);
                                                                    String whereComp = "" + companyId;
                                                                    String whereDiv = "" + divisionId;
                                                                    depart_value.add("0");
                                                                    depart_key.add("-select-");
                                                                    String depart_selected = "";
                                                                    // List Section
                                                                    Vector section_value = new Vector(1, 1);
                                                                    Vector section_key = new Vector(1, 1);
                                                                    Vector section_v = new Vector();
                                                                    Vector section_k = new Vector();
                                                                    String whereSection = "DEPARTMENT_ID = " + departmentId;
                                                                    section_value.add("0");
                                                                    section_key.add("-select-");
                                                                    section_v.add("0");
                                                                    section_k.add("-select-");
                                                                    /* List variabel if not isHRDLogin || isEdpLogin || isGeneralManager */
                                                                        
                                                                    String strComp = "";
                                                                    String strCompId = "0";
                                                                    String strDivisi = "";
                                                                    String strDivisiId = "0";
                                                                    String strDepart = "";
                                                                    String strDepartId = "0";
                                                                    String strSection = "";
                                                                    String strSectionId = "0";
                                                                    if (isHRDLogin || isEdpLogin || isGeneralManager) {
                                                                        
                                                                        Vector listComp = PstCompany.list(0, 0, "", " COMPANY ");
                                                                        for (int i = 0; i < listComp.size(); i++) {
                                                                            Company comp = (Company) listComp.get(i);
                                                                            if (comp.getOID() == companyId) {
                                                                                comp_selected = String.valueOf(companyId);
                                                                            }
                                                                            comp_key.add(comp.getCompany());
                                                                            comp_value.add(String.valueOf(comp.getOID()));
                                                                        }
                                                                            
                                                                        Vector listDiv = PstDivision.list(0, 0, whereDivision, " DIVISION ");
                                                                        if (listDiv != null && listDiv.size() > 0) {
                                                                            for (int i = 0; i < listDiv.size(); i++) {
                                                                                Division division = (Division) listDiv.get(i);
                                                                                if (division.getOID() == divisionId) {
                                                                                    div_selected = String.valueOf(divisionId);
                                                                                }
                                                                                div_key.add(division.getDivision());
                                                                                div_value.add(String.valueOf(division.getOID()));
                                                                            }
                                                                        }
                                                                            
                                                                        Vector listDepart = PstDepartment.listDepartmentVer1(0, 0, whereComp, whereDiv);
                                                                        if (listDepart != null && listDepart.size() > 0) {
                                                                            for (int i = 0; i < listDepart.size(); i++) {
                                                                                Department depart = (Department) listDepart.get(i);
                                                                                if (depart.getOID() == departmentId) {
                                                                                    depart_selected = String.valueOf(departmentId);
                                                                                }
                                                                                depart_key.add(depart.getDepartment());
                                                                                depart_value.add(String.valueOf(depart.getOID()));
                                                                            }
                                                                        }
                                                                            
                                                                        Vector listSection = PstSection.list(0, 0, whereSection, "");
                                                                        if (listSection != null && listSection.size() > 0) {
                                                                            for (int i = 0; i < listSection.size(); i++) {
                                                                                Section section = (Section) listSection.get(i);
                                                                                section_key.add(section.getSection());
                                                                                section_value.add(String.valueOf(section.getOID()));
                                                                                String sectionLink = section.getSectionLinkTo();
                                                                                if ((sectionLink != null) && sectionLink.length()>0) {
                                                                                    
                                                                                    for (String retval : sectionLink.split(",")) {
                                                                                        section_value.add(retval);
                                                                                        section_key.add(getSectionLink(retval));
                                                                                    }
                                                                                }
                                                                            }
                                                                        }
                                                                            
                                                                    } else {
                                                                        // for Company and Division
                                                                        if (emplx.getDivisionId() > 0) {
                                                                            Division empDiv = PstDivision.fetchExc(emplx.getDivisionId());
                                                                            Company empComp = PstCompany.fetchExc(empDiv.getCompanyId());
                                                                            strComp = empComp.getCompany();
                                                                            strCompId = String.valueOf(empComp.getOID());
                                                                            strDivisi = empDiv.getDivision();
                                                                            strDivisiId = String.valueOf(empDiv.getOID());
                                                                        }
                                                                        // for Department
                                                                        if (emplx.getDepartmentId() > 0) {
                                                                            Department empDepart = PstDepartment.fetchExc(emplx.getDepartmentId());
                                                                            strDepart = empDepart.getDepartment();
                                                                            strDepartId = String.valueOf(empDepart.getOID());
                                                                        }
                                                                        // for Section
                                                                        if (emplx.getSectionId() > 0) {
                                                                            Section empSection = PstSection.fetchExc(emplx.getSectionId());
                                                                            strSection = empSection.getSection();
                                                                            strSectionId = String.valueOf(empSection.getOID());
                                                                                
                                                                            section_v.add(String.valueOf(empSection.getOID()));
                                                                            section_k.add(empSection.getSection());
                                                                            String sectionLink = empSection.getSectionLinkTo();
                                                                            if ((sectionLink != null) && sectionLink.length()>0) {
                                                                                
                                                                                for (String retval : sectionLink.split(",")) {
                                                                                    section_v.add(retval);
                                                                                    section_k.add(getSectionLink(retval));
                                                                                }
                                                                            }
                                                                        }
                                                                    }
                                                                %>
                                                                <tr>
                                                                    <td valign="top" id="tdForm">Company</td>
                                                                    <td valign="top" id="tdForm">
                                                                        <%
                                                                            if (isHRDLogin || isEdpLogin || isGeneralManager) {
                                                                        %>
                                                                        <input type="hidden" name="company_id" value="<%=companyId%>" />
                                                                        <%= ControlCombo.draw("inp_company_id", "formElemen", null, comp_selected, comp_value, comp_key, " onChange=\"javascript:compChange(this.value)\"")%>
                                                                        <%
                                                                        } else {
                                                                        %>
                                                                        <input type="hidden" name="inp_company_id" value="<%=strCompId%>" />
                                                                        <input type="text" name="company_nm" disabled="disabled" value="<%=strComp%>" />
                                                                        <%
                                                                            }
                                                                        %>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td valign="top" id="tdForm">Satuan Kerja</td>
                                                                    <td valign="top" id="tdForm">
                                                                        <%
                                                                            if (isHRDLogin || isEdpLogin || isGeneralManager) {
                                                                        %>
                                                                        <input type="hidden" name="division_id" value="<%=divisionId%>" />
                                                                        <%= ControlCombo.draw("inp_division_id", "formElemen", null, div_selected, div_value, div_key, " onChange=\"javascript:divisiChange(this.value)\"")%>
                                                                        <%
                                                                        } else {
                                                                        %>
                                                                        <input type="hidden" name="inp_division_id" value="<%=strDivisiId%>" />
                                                                        <input type="text" name="division_nm" disabled="disabled" value="<%=strDivisi%>" />
                                                                        <%
                                                                            }
                                                                        %>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td valign="top" id="tdForm">Unit</td>
                                                                    <td valign="top" id="tdForm">
                                                                        <%
                                                                            if (isHRDLogin || isEdpLogin || isGeneralManager) {
                                                                        %>
                                                                        <input type="hidden" name="department_id" value="<%=departmentId%>" />	
                                                                        <%= ControlCombo.draw("inp_department_id", "formElemen", null, depart_selected, depart_value, depart_key, " onChange=\"javascript:deptChange(this.value)\"")%>
                                                                        <%
                                                                        } else {
                                                                        %>
                                                                        <input type="hidden" name="inp_department_id" value="<%=strDepartId%>" />
                                                                        <input type="text" name="department_nm" disabled="disabled" value="<%=strDepart%>" />
                                                                        <%
                                                                            }
                                                                        %>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td valign="top" id="tdForm">Sub Unit</td>
                                                                    <td valign="top" id="tdForm">
                                                                        <%
                                                                            if (isHRDLogin || isEdpLogin || isGeneralManager) {
                                                                        %> 
                                                                        <%= ControlCombo.draw("inp_section_id", "formElemen", null, "", section_value, section_key, "")%>  
                                                                        <%
                                                                        } else {
                                                                        %>
                                                                        <%= ControlCombo.draw("inp_section_id", "formElemen", null, "0", section_v, section_k, "")%> 
                                                                        <%
                                                                            }
                                                                        %>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td valign="top" id="tdForm" colspan="2">
                                                                        <button id="btn" onclick="javascript:cmdSearch()">Search</button>&nbsp;
                                                                       <!-- <button id="btn" onclick="javascript:cmdExportExcel()">Export to Excel</button>-->
                                                                        <button id="btn" onclick="javascript:cmdSearchAll()">Search All</button>&nbsp;
                                                                        <!--<button id="btn" onclick="javascript:cmdExportExcelAll()">Export to Excel All</button>-->
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </form>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <%
                                                    if (listTime != null && listTime.size()>0){
                                                    %>
                                                    <td>
                                                        <div id="mn_utama">List Overtime</div>
                                                        <%=drawList(listTime, whereClause)%>
                                                    </td>
                                                    <%
                                                    }
                                                    %>
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

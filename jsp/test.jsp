<%@page import="com.dimata.harisma.entity.leave.PstSpecialUnpaidLeaveTaken"%>
<%@page import="com.dimata.harisma.entity.attendance.PstAlStockTaken"%>
<%@page import="com.dimata.harisma.entity.attendance.PstLlStockTaken"%>
<%@page import="com.dimata.harisma.entity.attendance.PstEmpSchedule"%>
<%@page import="com.dimata.harisma.entity.overtime.OvertimeDetail"%>
<%@page import="com.dimata.harisma.entity.leave.I_Leave"%>
<%@page import="com.dimata.harisma.entity.overtime.Overtime"%>
<%@page import="com.dimata.harisma.entity.overtime.PstOvertimeDetail"%>
<%@page import="com.dimata.harisma.entity.overtime.PstOvertime"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="com.dimata.qdep.db.DBHandler"%>
<%@page import="com.dimata.qdep.db.DBResultSet"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.dimata.harisma.session.attendance.SessEmpSchedule"%>
<%@ page language="java" %>

<%@ page import="java.util.*, com.dimata.util.Command" %>
<%@ page import="com.dimata.harisma.session.admin.*" %>
<%@ page import="com.dimata.harisma.utility.service.parser.*" %>
<%@ page import="com.dimata.qdep.form.*" %>
<%@ page import="com.dimata.util.blob.*" %>
<%@ page import="com.dimata.util.*" %>

<%@ page import="java.lang.System"%>
<%@ page import="java.io.BufferedReader"%>
<%@ page import="java.io.ByteArrayInputStream"%>
<%@ page import="java.io.*"%>
<%@ page import="java.io.File"%>
<%@ page import="com.dimata.harisma.utility.odbc.*"%>

<%@ include file="main/javainit.jsp"%>
<%!

    public String getApprovalEmployeeTopLinkByLevel(long employeeId, int typeOfLink,int levelPoint, String status) {
       String byLevelId = "";
       try{
       Vector vLevel = PstLevel.getAllLevelByPoint(levelPoint);
       
       for (int xx = 0; xx < vLevel.size(); xx++ ){
           Level levelX = (Level) vLevel.get(xx);
           byLevelId = byLevelId +levelX.getOID()+",";
       }
           byLevelId = byLevelId.substring(0,byLevelId.length()-1);
           //byLevelId = byLevelId +"10003";
       }catch(Exception e){} 
       
       
        Vector listEmployee = new Vector();
        String whereClause  = "HE." + PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID] + " = "+employeeId+" AND HMP."+ PstMappingPosition.fieldNames[PstMappingPosition.FLD_TYPE_OF_LINK] + " = "+typeOfLink+" AND HP." + PstPosition.fieldNames[PstPosition.FLD_LEVEL_ID] + " IN ("+byLevelId+")" ;
        String listTopLink = PstMappingPosition.listEmployeeTopPositionId(0, 0, whereClause, "");
        if (listTopLink.length() > 0 ){
           listTopLink = listTopLink.substring(0, (listTopLink.length() - 1 ));
        }
        Employee employee = new Employee();
        try {
            employee = PstEmployee.fetchExc(employeeId);
        
        } catch (Exception e) {
            
        }
        long oidDireksi = 0;
        long oidDirut = 0;
           
        try {
            oidDireksi = Long.parseLong(com.dimata.system.entity.PstSystemProperty.getValueByName("OID_DIREKSI"));
           
        } catch (Exception exc){
            oidDireksi = 0;
        }
        
        try {
            oidDirut = Long.parseLong(PstSystemProperty.getValueByName("OID_DIRUT_POSITION"));
        } catch (Exception exc){
            oidDirut = 0;
        }
        
//        String kadivLevelRank = "";
//        try {
//            kadivLevelRank = PstSystemProperty.getValueByName("KADIV_LEVEL_RANK");
//        } catch (Exception exc){
//            
//        }
        
        
        
        
        Vector listEmployeeDivisionTopLink      = new Vector();
         
        //cek kadiv kosong listTopLink divisi
        Vector employeeX = new Vector();
        Vector listUpPosition = new Vector();
        String upPosition = "";
        if(!listTopLink.equals("")) {
            String whereEmployee = "" + PstEmployee.fieldNames[PstEmployee.FLD_POSITION_ID] + " IN (" + listTopLink + ")";
            employeeX = PstEmployee.list(0,0, whereEmployee, "");
            if (employeeX.size() == 0){
                status = "2";
                String wherePosition = "" +PstMappingPosition.fieldNames[PstMappingPosition.FLD_DOWN_POSITION_ID] + " IN ("+ listTopLink + ")"
                        + " AND " +PstMappingPosition.fieldNames[PstMappingPosition.FLD_TYPE_OF_LINK] + " = 3 "; 
                listUpPosition = PstMappingPosition.list(0, 0, wherePosition, "");
                if(listUpPosition.size() > 0){
                    for (int i=0; i < listUpPosition.size(); i++){
                        MappingPosition map = (MappingPosition) listUpPosition.get(i);
                        upPosition = upPosition + "," + map.getUpPositionId();
                    }
                }
                if(!(upPosition.equals(""))){
                    upPosition = upPosition.substring(1);
                }
                
            }
        }
        
        if (status.equals("direksi approval")){
            if (listTopLink.length()>0){
               listEmployeeDivisionTopLink      = PstEmployee.listEmployeeApprovalTopLink(0, 0, " ( POSITION_ID IN ("+listTopLink+")  AND `DIVISION_ID` = "+employee.getDivisionId() + " ) OR ( POSITION_ID IN ("+listTopLink+")  AND `DIVISION_ID` = "+oidDireksi+" )" , "", 0,0, 0);
            }
        } else if (status.equals("2")){
               listEmployeeDivisionTopLink      = PstEmployee.listEmployeeApprovalTopLink(0, 0, " POSITION_ID IN ("+upPosition+")  AND `DIVISION_ID` = "+oidDireksi , "", 0,0, 0);
        } 
        else  {
            if (listTopLink.length()>0){
               listEmployeeDivisionTopLink      = PstEmployee.listEmployeeApprovalTopLink(0, 0, " POSITION_ID IN ("+listTopLink+")  AND `DEPARTMENT_ID` = "+employee.getDepartmentId() , "", 0,0, 0);
            }
        }
        
//        if (listEmployeeDivisionTopLink.size() == 0 && byLevelId.equals("504404608059716705,504404608059827576")){
//               listEmployeeDivisionTopLink      = PstEmployee.listEmployeeApprovalTopLink(0, 0, " POSITION_ID IN ("+oidDirut+")  AND `DIVISION_ID` = "+oidDireksi , "", 0,0, 0);
//        }
        
        if (listEmployeeDivisionTopLink == null || listEmployeeDivisionTopLink.size() == 0){
            if (listTopLink.length()>0){
                listEmployeeDivisionTopLink      = PstEmployee.listEmployeeApprovalTopLink(0, 0, " POSITION_ID IN ("+listTopLink+")  AND `DIVISION_ID` = '"+employee.getDivisionId()+"'" , "", 0,0, 0);                
            }
         }
        
        if (listEmployeeDivisionTopLink.size() != 0 || listEmployeeDivisionTopLink.size() > 0){ 
            listEmployee = listEmployeeDivisionTopLink;
        }
        
        //Cek apakah yang bersangkutan sedang cuti atau tidak
        String inEmployee = "";
        if(listEmployee.size() > 0){
            
            
            boolean isNeedReplacement = true;
            for (int i=0; i < listEmployee.size(); i++){
                Employee emp = (Employee) listEmployee.get(i);
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                Date dtNow = new Date();
                String dateNow = sdf.format(dtNow);

                String whereAL = "'"+ dateNow +"' BETWEEN DATE_FORMAT(" + PstAlStockTaken.fieldNames[PstAlStockTaken.FLD_TAKEN_DATE] + ", '%Y-%m-%d')"
                                + " AND DATE_FORMAT(" + PstAlStockTaken.fieldNames[PstAlStockTaken.FLD_TAKEN_FINNISH_DATE] + ", '%Y-%m-%d') AND "
                                + ""+ PstAlStockTaken.fieldNames[PstAlStockTaken.FLD_EMPLOYEE_ID] + " IN ("+emp.getOID()+")";
                String whereLL = "'"+ dateNow +"' BETWEEN DATE_FORMAT(" + PstLlStockTaken.fieldNames[PstLlStockTaken.FLD_TAKEN_DATE] + ", '%Y-%m-%d')"
                                + " AND DATE_FORMAT(" + PstLlStockTaken.fieldNames[PstLlStockTaken.FLD_TAKEN_FINNISH_DATE] + ", '%Y-%m-%d') AND "
                                + ""+ PstLlStockTaken.fieldNames[PstLlStockTaken.FLD_EMPLOYEE_ID] + " IN ("+emp.getOID()+")";
                String whereSL = "'"+ dateNow +"' BETWEEN DATE_FORMAT(" + PstSpecialUnpaidLeaveTaken.fieldNames[PstSpecialUnpaidLeaveTaken.FLD_TAKEN_DATE] + ", '%Y-%m-%d')"
                                + " AND DATE_FORMAT(" + PstSpecialUnpaidLeaveTaken.fieldNames[PstSpecialUnpaidLeaveTaken.FLD_TAKEN_FINNISH_DATE] + ", '%Y-%m-%d') AND "
                                + ""+ PstSpecialUnpaidLeaveTaken.fieldNames[PstSpecialUnpaidLeaveTaken.FLD_EMPLOYEE_ID] + " IN ("+emp.getOID()+")";

                Vector listEmpLeaveAL = PstAlStockTaken.list(0, 0, whereAL, "");
                Vector listEmpLeaveLL = PstLlStockTaken.list(0, 0, whereLL, "");
                Vector listEmpLeaveSL = PstSpecialUnpaidLeaveTaken.list(0, 0, whereSL, "");
                
                if (listEmpLeaveAL.size() > 0 || listEmpLeaveLL.size() > 0 || listEmpLeaveSL.size() > 0){
                    
                } else {
                    isNeedReplacement = false;
                }
                
                if (!isNeedReplacement){
                    int day = dtNow.getDate();
                                String inRpt = "'"+PstScheduleSymbol.REPORT_DL+"','"+PstScheduleSymbol.REPORT_S+"','"+PstScheduleSymbol.REPORT_DET+"'";
                    String inDLSymbol = PstScheduleSymbol.listScheduleSymbolbyReportTypeIn(inRpt);

                    whereClause = PstEmpSchedule.fieldNames[PstEmpSchedule.FLD_EMPLOYEE_ID]+"="+emp.getOID();
                    Period period;
                    try {
                        period = PstPeriod.getPeriodBySelectedDate(dtNow);
                        whereClause += " AND "+PstEmpSchedule.fieldNames[PstEmpSchedule.FLD_PERIOD_ID]+"="+period.getOID();
                    } catch (Exception exc){
                        period = new Period();
                    }

                    switch(day){
                        case 1:
                            whereClause += " AND "+PstEmpSchedule.fieldNames[PstEmpSchedule.FLD_D1]+" IN ("+inDLSymbol+")";
                            break;
                        case 2:
                            whereClause += " AND "+PstEmpSchedule.fieldNames[PstEmpSchedule.FLD_D2]+" IN ("+inDLSymbol+")";
                            break;
                        case 3:
                            whereClause += " AND "+PstEmpSchedule.fieldNames[PstEmpSchedule.FLD_D3]+" IN ("+inDLSymbol+")";
                            break;
                        case 4:
                            whereClause += " AND "+PstEmpSchedule.fieldNames[PstEmpSchedule.FLD_D4]+" IN ("+inDLSymbol+")";
                            break;
                        case 5:
                            whereClause += " AND "+PstEmpSchedule.fieldNames[PstEmpSchedule.FLD_D5]+" IN ("+inDLSymbol+")";
                            break;
                        case 6:
                            whereClause += " AND "+PstEmpSchedule.fieldNames[PstEmpSchedule.FLD_D6]+" IN ("+inDLSymbol+")";
                            break;
                        case 7:
                            whereClause += " AND "+PstEmpSchedule.fieldNames[PstEmpSchedule.FLD_D7]+" IN ("+inDLSymbol+")";
                            break;
                        case 8:
                            whereClause += " AND "+PstEmpSchedule.fieldNames[PstEmpSchedule.FLD_D8]+" IN ("+inDLSymbol+")";
                            break;
                        case 9:
                            whereClause += " AND "+PstEmpSchedule.fieldNames[PstEmpSchedule.FLD_D9]+" IN ("+inDLSymbol+")";
                            break;   
                        case 10:
                            whereClause += " AND "+PstEmpSchedule.fieldNames[PstEmpSchedule.FLD_D10]+" IN ("+inDLSymbol+")";
                            break;
                        case 11:
                            whereClause += " AND "+PstEmpSchedule.fieldNames[PstEmpSchedule.FLD_D11]+" IN ("+inDLSymbol+")";
                            break;
                        case 12:
                            whereClause += " AND "+PstEmpSchedule.fieldNames[PstEmpSchedule.FLD_D12]+" IN ("+inDLSymbol+")";
                            break;
                        case 13:
                            whereClause += " AND "+PstEmpSchedule.fieldNames[PstEmpSchedule.FLD_D13]+" IN ("+inDLSymbol+")";
                            break;
                        case 14:
                            whereClause += " AND "+PstEmpSchedule.fieldNames[PstEmpSchedule.FLD_D14]+" IN ("+inDLSymbol+")";
                            break;
                        case 15:
                            whereClause += " AND "+PstEmpSchedule.fieldNames[PstEmpSchedule.FLD_D15]+" IN ("+inDLSymbol+")";
                            break;
                        case 16:
                            whereClause += " AND "+PstEmpSchedule.fieldNames[PstEmpSchedule.FLD_D16]+" IN ("+inDLSymbol+")";
                            break;
                        case 17:
                            whereClause += " AND "+PstEmpSchedule.fieldNames[PstEmpSchedule.FLD_D17]+" IN ("+inDLSymbol+")";
                            break;
                        case 18:
                            whereClause += " AND "+PstEmpSchedule.fieldNames[PstEmpSchedule.FLD_D18]+" IN ("+inDLSymbol+")";
                            break;
                        case 19:
                            whereClause += " AND "+PstEmpSchedule.fieldNames[PstEmpSchedule.FLD_D19]+" IN ("+inDLSymbol+")";
                            break;
                        case 20:
                            whereClause += " AND "+PstEmpSchedule.fieldNames[PstEmpSchedule.FLD_D20]+" IN ("+inDLSymbol+")";
                            break;
                        case 21:
                            whereClause += " AND "+PstEmpSchedule.fieldNames[PstEmpSchedule.FLD_D21]+" IN ("+inDLSymbol+")";
                            break;
                        case 22:
                            whereClause += " AND "+PstEmpSchedule.fieldNames[PstEmpSchedule.FLD_D22]+" IN ("+inDLSymbol+")";
                            break;
                        case 23:
                            whereClause += " AND "+PstEmpSchedule.fieldNames[PstEmpSchedule.FLD_D23]+" IN ("+inDLSymbol+")";
                            break;
                        case 24:
                            whereClause += " AND "+PstEmpSchedule.fieldNames[PstEmpSchedule.FLD_D24]+" IN ("+inDLSymbol+")";
                            break;
                        case 25:
                            whereClause += " AND "+PstEmpSchedule.fieldNames[PstEmpSchedule.FLD_D25]+" IN ("+inDLSymbol+")";
                            break;
                        case 26:
                            whereClause += " AND "+PstEmpSchedule.fieldNames[PstEmpSchedule.FLD_D26]+" IN ("+inDLSymbol+")";
                            break;   
                        case 27:
                            whereClause += " AND "+PstEmpSchedule.fieldNames[PstEmpSchedule.FLD_D27]+" IN ("+inDLSymbol+")";
                            break;
                        case 28:
                            whereClause += " AND "+PstEmpSchedule.fieldNames[PstEmpSchedule.FLD_D28]+" IN ("+inDLSymbol+")";
                            break;
                        case 29:
                            whereClause += " AND "+PstEmpSchedule.fieldNames[PstEmpSchedule.FLD_D29]+" IN ("+inDLSymbol+")";
                            break;
                        case 30:
                            whereClause += " AND "+PstEmpSchedule.fieldNames[PstEmpSchedule.FLD_D30]+" IN ("+inDLSymbol+")";
                            break;
                        case 31:
                            whereClause += " AND "+PstEmpSchedule.fieldNames[PstEmpSchedule.FLD_D31]+" IN ("+inDLSymbol+")";
                            break;
                    }

                    Vector listDL = PstEmpSchedule.list(0, 0, whereClause, "");
                    if (listDL.size()>0){
                        isNeedReplacement = true;
                    }
                }
                
            }
            if (!(inEmployee.equals(""))){
                inEmployee = inEmployee.substring(1);
            }
            

            String inReplacement = "";
            String whereReplacement = "";
            if (isNeedReplacement){
                whereReplacement = "" +PstMappingPosition.fieldNames[PstMappingPosition.FLD_DOWN_POSITION_ID] + " IN ("+ listTopLink + ")"
                            + " AND " +PstMappingPosition.fieldNames[PstMappingPosition.FLD_TYPE_OF_LINK] + " = 8 "; 
                Vector listReplacement = PstMappingPosition.list(0, 0, whereReplacement, "");
                if(listReplacement.size() > 0){
                    for (int i=0; i < listReplacement.size(); i++){
                        MappingPosition map = (MappingPosition) listReplacement.get(i);
                        inReplacement = inReplacement + "," + map.getUpPositionId();
                    }
                } else {
                    String whereUpReplacement = "" +PstMappingPosition.fieldNames[PstMappingPosition.FLD_DOWN_POSITION_ID] + " IN ("+ listTopLink + ")"
                            + " AND " +PstMappingPosition.fieldNames[PstMappingPosition.FLD_TYPE_OF_LINK] + " = 3 "; 
                    Vector listUpReplacement = PstMappingPosition.list(0, 0, whereUpReplacement, "");
                    if(listUpReplacement.size() > 0){
                    for (int i=0; i < listUpReplacement.size(); i++){
                        MappingPosition map = (MappingPosition) listUpReplacement.get(i);
                        inReplacement = inReplacement + "," + map.getUpPositionId();
                    }
                }
                }
                if(!(inReplacement.equals(""))){
                    inReplacement = inReplacement.substring(1);
                }
            }

            Vector listEmployeeReplacement = new Vector();
            if ((!inReplacement.equals(""))){
                listEmployeeReplacement      = PstEmployee.listEmployeeApprovalTopLink(0, 0, " POSITION_ID IN ("+inReplacement+")  AND `DIVISION_ID` = "+employee.getDivisionId() , "", 0,0, 0);
                if (listEmployeeReplacement.size() == 0){
                    listEmployeeReplacement = PstEmployee.listEmployeeApprovalTopLink(0, 0, " POSITION_ID IN ("+inReplacement+")", "", 0,0, 0);
                }
            }

            if (listEmployeeReplacement.size() != 0 || listEmployeeReplacement.size() > 0){ 
                listEmployee = listEmployeeReplacement;
            }
        }
        
        
        return byLevelId;
    }

    public static int getOvertimeApprovalDayDiff(long employeeId, Date ovtDate){
        int diff = 0;
        
        Employee emp = new Employee();
        try {
            emp = PstEmployee.fetchExc(employeeId);
        } catch (Exception exc){}
        
        String whereClause = PstPublicHolidays.fieldNames[PstPublicHolidays.FLD_HOLIDAY_DATE]+" BETWEEN '"+Formater.formatDate(ovtDate, "yyyy-MM-dd")+"' "
                + " AND '"+Formater.formatDate(new Date(), "yyyy-MM-dd")+"'";
        
        
        String whereAdd = "";
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd") ;
        int pengurang = 0;
        Vector listPH = PstPublicHolidays.list(0, 0, whereClause, "holiday_status");
        if (listPH.size()>0){
            for(int x = 0; x < listPH.size(); x++){
                PublicHolidays pH = (PublicHolidays)listPH.get(x);
                if(pH.getiHolidaySts() == 1 || emp.getReligionId() == pH.getiHolidaySts()){
                    pengurang += pH.getDays();
                }
            }
        }
        
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT ((DATEDIFF('"+Formater.formatDate(new Date(), "yyyy-MM-dd")+" 00:00:00', '"+Formater.formatDate(ovtDate, "yyyy-MM-dd")+" 00:00:00')) - "
                    + "((WEEK('"+Formater.formatDate(new Date(), "yyyy-MM-dd")+" 00:00:00') - WEEK('"+Formater.formatDate(ovtDate, "yyyy-MM-dd")+" 00:00:00')) * 2) - "
                    + "(CASE WHEN WEEKDAY('"+Formater.formatDate(ovtDate, "yyyy-MM-dd")+" 00:00:00') = 6 THEN 1 ELSE 0 END) - "
                    + "(CASE WHEN WEEKDAY('"+Formater.formatDate(new Date(), "yyyy-MM-dd")+" 00:00:00') = 5 THEN 1 ELSE 0 END) "
                    + whereAdd + ") AS DifD";

            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                diff = rs.getInt(1)-pengurang;
            }
            rs.close();
          

        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        
        return diff;
    }
    
    public static Date getMaxOvtDate(long overtimeId){
        Date dt = null;
        
        DBResultSet dbrs = null;
        try{
            String sql = "SELECT MAX("+PstOvertimeDetail.fieldNames[PstOvertimeDetail.FLD_DATE_TO]+") AS "+PstOvertimeDetail.fieldNames[PstOvertimeDetail.FLD_DATE_TO]+
                         " FROM " +PstOvertimeDetail.TBL_OVERTIME_DETAIL +
                         " WHERE " +PstOvertimeDetail.fieldNames[PstOvertimeDetail.FLD_OVERTIME_ID]+" = "+ overtimeId;

            //System.out.println("sqlgetOvtDuration   "+sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
           // System.out.println("sql   "+sql);
            while(rs.next()) { 
                dt = DBHandler.convertDate(rs.getDate(PstOvertimeDetail.fieldNames[PstOvertimeDetail.FLD_DATE_TO]), rs.getTime(PstOvertimeDetail.fieldNames[PstOvertimeDetail.FLD_DATE_TO]));
            }
            rs.close();
	        
        }catch(Exception e){
            System.out.println("Error");
        }
        
        return dt;
    }
    
%>
<%

/*TextLoader tl = new TextLoader();
String str = tl.getFileString("D:/user/edarmasusila/project/harisma/NIKKO/kde/CARDRAW.SDF");

out.println(str);

StringReader sr = new StringReader(str);
LineNumberReader ln = new LineNumberReader(sr);
Vector strBuffer = new Vector(1,1);
boolean stop = false;
int i=0;
while(!stop){
	String s = ln.readLine();
	
	out.println("<br>"+s);
	
	i = i+1;
	ln.setLineNumber(i);
	if(s==null){
		stop = true;
	}
	else{
		CardneticText ct = new CardneticText(s);
		out.println("<br>"+ct.getSwappingDate());
		out.println("<br>"+ct.getSwappingId());
		out.println("<br>"+ct.getSwappingType()+"<br>");
	}
	
}

out.println("<br>200604201526");
out.println("<br>"+Formater.formatDate("200604201526", "yyyyMMddhhmm"));
String stx = "20060420152600103441266290011";
out.println("<br>"+stx);
out.println("<br>"+stx.substring(0,12));
out.println("<br>"+stx.substring(12,24));
out.println("<br>"+stx.substring(24,25));


File filex = new File("D:/temp/test.txt");
try{
	String execBatFileName = "rename.bat";
	String cmd = "d:\n";
	cmd = cmd + "cd"+System.getProperty("file.separator")+"\n";
	cmd = cmd + "cd temp\n";
	cmd = cmd + "rename test.txt test-1.txt\n";
	
	FileOutputStream fff = new FileOutputStream("d:"+System.getProperty("file.separator")+"temp"+System.getProperty("file.separator")+execBatFileName);
	fff.write(cmd.getBytes());
	fff.flush();
	fff.close();

	ExecCommand exccomm = new ExecCommand();
	exccomm.runCommmand("d:"+System.getProperty("file.separator")+"temp"+System.getProperty("file.separator")+execBatFileName);
}
catch(Exception e){
	out.println(e.toString());
}

com.dimata.util.blob.File ff = new com.dimata.util.blob.File();
ff.renameFile("C", "Program Files/Cardnetic/Smart 2k/DATA", "CARDRAW-1.SDF", "CARDRAW.SDF");

//File filex = new File("D:\temp\test.txt");
//if(filex.isFile()){
	
//}

*/
String whereOvNotif = PstOvertime.fieldNames[PstOvertime.FLD_STATUS_DOC]+" IN ('0','1') "
                                        + " AND "+PstOvertime.fieldNames[PstOvertime.FLD_REQ_DATE]+" > DATE_ADD(CURDATE(),INTERVAL -7 DAY)";
        Vector listOvertime = PstOvertime.list(0, 0, whereOvNotif, "");

int limitDayApproval = 0;
    String strlimitDayApproval = PstSystemProperty.getValueByName("OVERTIME_APPROVAL_LIMIT_DAY");
try {
    limitDayApproval = Integer.valueOf(strlimitDayApproval);
} catch (Exception exc){}
long employeeId = 504404562438396010L;
I_Leave leaveConfig = null;
        try{
            leaveConfig = (I_Leave) (Class.forName(PstSystemProperty.getValueByName("LEAVE_CONFIG")).newInstance());
        }catch (Exception e){
            System.out.println("Exception : " + e.getMessage());
        }
%>
<html>
<head>
<title>text loader</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body bgcolor="#FFFFFF" text="#000000">
    
    <%
        for (int i=0; i < listOvertime.size(); i++){
            Overtime overtime = (Overtime) listOvertime.get(i);
            if (overtime.getOID() == 504404771299984477L){
                Date dtMax = getMaxOvtDate(overtime.getOID());

                boolean approval = true;
                if (dtMax != null && limitDayApproval > 0 && (overtime.getStatusDoc() == 0 || overtime.getStatusDoc() == 1)){
                    int diff = PstOvertime.getOvertimeApprovalDayDiff(504404562438396010L, dtMax);
                    long maxTime = dtMax.getTime();
                    long nowTime = new Date().getTime();
                    long diffTime = nowTime - maxTime;
                    long diffDays = diffTime / (1000 * 60 * 60 * 24);
                    if (diff > (limitDayApproval)){
                        approval = false;
                    }
                }
                if (approval){
                   boolean checkApproval = false;
                    int incIndexApp = 0;
                    boolean indexComplete = false;
                    if (overtime.getRequestId() == 0){
                        indexComplete = PstOvertime.cekApproval(overtime, 11);
                        if(!indexComplete){
                            Vector listMaxEmp = PstOvertimeDetail.maxLevelEmployees(overtime.getOID());
                            if(listMaxEmp.size() > 0){
                                OvertimeDetail overtimeDetail = (OvertimeDetail) listMaxEmp.get(0);

                                if(overtimeDetail.getEmployeeId() != 0){
                                    Employee employeeObj = new Employee();
                                    try {
                                        employeeObj = PstEmployee.fetchExc(overtimeDetail.getEmployeeId());

                                    } catch (Exception e) {
                                    }

                                    Level level = new Level();
                                    try {
                                        level = PstLevel.fetchExc(employeeObj.getLevelId());
                                    } catch (Exception e) {
                                    }

                                    Level maxLevelObj = new Level();
                                    try {
                                        maxLevelObj = PstLevel.fetchExc(level.getMaxLevelApproval());
                                    } catch (Exception e) {
                                    }

                                    int minLevel = level.getLevelPoint();
                                    int maxLevel = maxLevelObj.getLevelPoint();
                                    incIndexApp = 1;
                                    int typeApproval = 11;
                                    if (overtime.getOvertimeType() == 1){
                                        typeApproval = 10;
                                    }
                                    long oidEmpDinamis = overtimeDetail.getEmployeeId();
                                    String byLevelId = "";
                                     %><%=maxLevel%><%
                                    for (int xx = minLevel; xx <= maxLevel; xx++) {
                                        Vector listEmpApproval = leaveConfig.getApprovalEmployeeTopLinkByLevel(oidEmpDinamis, typeApproval, xx,"");
                                        
                                        %><%=xx%><%
                                        if (listEmpApproval.size() > 0) {
                                            if (listEmpApproval != null && listEmpApproval.size() > 0) {

                                                for (int x = 0; x < listEmpApproval.size(); x++) {
                                                    Employee objEmp = (Employee) listEmpApproval.get(x);
                                                    
                                                    %><%=objEmp.getFullName()%><%
                                                }
                                            }
                                        }
                                    }
                                }

                            }
                        }
                    } else if (overtime.getApproval1Id() == 0){
                        indexComplete = PstOvertime.cekApproval(overtime, 1);
                        if(!indexComplete){
                            checkApproval = PstOvertime.checkApprover(overtime.getOID(), leaveConfig, employeeId, overtime.getRequestId(), overtime.getRequestId() );
                        }
                    } else if (overtime.getApproval2Id() == 0){
                        indexComplete = PstOvertime.cekApproval(overtime, 2);
                        if(!indexComplete){
                            checkApproval = PstOvertime.checkApprover(overtime.getOID(), leaveConfig, employeeId, overtime.getRequestId(), overtime.getApproval1Id() );
                        }
                    } else if (overtime.getApproval3Id() == 0){
                        indexComplete = PstOvertime.cekApproval(overtime, 3);
                        if(!indexComplete){
                            checkApproval = PstOvertime.checkApprover(overtime.getOID(), leaveConfig, employeeId, overtime.getRequestId(), overtime.getApproval2Id() );
                        }
                    } else if (overtime.getApproval4Id() == 0){
                        indexComplete = PstOvertime.cekApproval(overtime, 4);
                        if(!indexComplete){
                            checkApproval = PstOvertime.checkApprover(overtime.getOID(), leaveConfig, employeeId, overtime.getRequestId(), overtime.getApproval3Id() );
                        }
                    } else if (overtime.getApproval5Id() == 0){
                        indexComplete = PstOvertime.cekApproval(overtime, 5);
                        if(!indexComplete){
                            checkApproval = PstOvertime.checkApprover(overtime.getOID(), leaveConfig, employeeId, overtime.getRequestId(), overtime.getApproval4Id() );
                        }
                    } else if (overtime.getApproval6Id() == 0){
                        indexComplete = PstOvertime.cekApproval(overtime, 6);
                        if(!indexComplete){
                            checkApproval = PstOvertime.checkApprover(overtime.getOID(), leaveConfig, employeeId, overtime.getRequestId(), overtime.getApproval5Id() );
                        }
                    }

                }
            }
        }
    %>
</body>
</html>

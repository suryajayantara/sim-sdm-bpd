<%-- 
    Document   : more_detail
    Created on : May 19, 2016, 4:55:23 PM
    Author     : Dimata 007
--%>

<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.dimata.util.Command"%>
<%@page import="java.math.RoundingMode"%>
<%@page import="java.math.BigDecimal"%>
<%@page import="com.dimata.util.Formater"%>
<%@page import="com.dimata.harisma.entity.leave.LeaveApplication"%>
<%@page import="com.dimata.harisma.entity.leave.PstLeaveApplication"%>
<%@page import="com.dimata.harisma.entity.leave.I_Leave"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="com.dimata.qdep.db.DBResultSet"%>
<%@page import="org.json.*"%>
<%@page import="com.dimata.qdep.db.DBHandler"%>
<%@page import="com.dimata.harisma.entity.log.ChangeValue"%>
<%@page import="com.dimata.harisma.entity.log.DictionaryField"%>
<%@page import="com.dimata.qdep.entity.I_DocStatus"%>
<%@page import="com.dimata.harisma.entity.log.PstLogSysHistory"%>
<%@page import="com.dimata.harisma.entity.log.LogSysHistory"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file = "../../main/javainit.jsp" %>
<%!
    public long divisionId = 0;
    public int convertInteger(double val){
        BigDecimal bDecimal = new BigDecimal(val);
        bDecimal = bDecimal.setScale(0, RoundingMode.HALF_UP);
        return bDecimal.intValue();
    }
    
    public String getEmployeeName(long employeeId){
        String str = "";
        try {
            Employee emp = PstEmployee.fetchExc(employeeId);
            str = "<strong>["+emp.getEmployeeNum()+"] "+emp.getFullName()+"</strong>";
        } catch(Exception e){
            System.out.println(e.toString());
        }
        return str;
    }
    /*
SELECT hr_employee.POSITION_ID FROM hr_employee
WHERE hr_employee.EMPLOYEE_ID=101306; //get position id //

SELECT * FROM hr_mapping_position
WHERE hr_mapping_position.TYPE_OF_LINK=3 AND hr_mapping_position.DOWN_POSITION_ID=504404619213373526; // get up position id //

SELECT hr_position.POSITION_ID, hr_position.POSITION, hr_employee.EMPLOYEE_ID, hr_employee.FULL_NAME
FROM hr_position 
INNER JOIN hr_employee ON hr_employee.POSITION_ID=hr_position.POSITION_ID
WHERE hr_position.POSITION_ID=1784659104; // get employee id //
    */
    public String getPositionIdByEmpId(long employeeId) {
        String positionId = "";
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT hr_employee.POSITION_ID, hr_employee.DIVISION_ID FROM hr_employee ";
            sql += " WHERE hr_employee.EMPLOYEE_ID="+employeeId;
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                positionId = rs.getString(PstEmployee.fieldNames[PstEmployee.FLD_POSITION_ID]);
                divisionId = rs.getLong(PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID]);
            }
            rs.close();
            return positionId;
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return positionId;
    }

    public String getUpPositionId(String positionId, long divisionId) {
        String upPositionId = "";
        DBResultSet dbrs = null;
        Date dtNow = new Date();
        try {
            String sql = "SELECT * FROM hr_mapping_position ";
            sql += " WHERE hr_mapping_position.TYPE_OF_LINK=14 AND ";
            sql += " hr_mapping_position.DOWN_POSITION_ID IN ("+positionId+") AND '"+Formater.formatDate(dtNow, "yyyy-MM-dd")+"'"
 +                 " BETWEEN START_DATE AND END_DATE "
                   + " AND (DIVISION_ID =0 OR DIVISION_ID="+divisionId+")";
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                upPositionId = upPositionId + "," + rs.getLong(PstMappingPosition.fieldNames[PstMappingPosition.FLD_UP_POSITION_ID]);
            }
            rs.close();
            if (!(upPositionId.equals(""))){
                upPositionId = upPositionId.substring(1);
            }
            return upPositionId;
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return upPositionId;
    }
    
    public String getUpPositionByDivisionId(String positionId, long divisionId) {
        String upPositionId = "";
        DBResultSet dbrs = null;
        Date dtNow = new Date();
        try {
            String sql = "SELECT * FROM hr_mapping_position ";
            sql += " WHERE hr_mapping_position.TYPE_OF_LINK=14 AND ";
            sql += " hr_mapping_position.DOWN_POSITION_ID IN ("+positionId+") AND '"+Formater.formatDate(dtNow, "yyyy-MM-dd")+"'"
                    + " BETWEEN START_DATE AND END_DATE "
                    + " AND DIVISION_ID="+divisionId+"";
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                upPositionId = upPositionId + "," + rs.getLong(PstMappingPosition.fieldNames[PstMappingPosition.FLD_UP_POSITION_ID]);
            }
            rs.close();
            if (!(upPositionId.equals(""))){
                upPositionId = upPositionId.substring(1);
            }
            return upPositionId;
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return upPositionId;
    }
    
    public String getUpPositionIdReplacement(String positionId, long divisionId) {
        String upPositionId = "";
        DBResultSet dbrs = null;
        Date dtNow = new Date();
        try {
            String sql = "SELECT * FROM hr_mapping_position ";
            sql += " WHERE hr_mapping_position.TYPE_OF_LINK=8 AND ";
            sql += " hr_mapping_position.DOWN_POSITION_ID IN ("+positionId+") AND '"+Formater.formatDate(dtNow, "yyyy-MM-dd")+"'"
 +                 " BETWEEN START_DATE AND END_DATE "
                   + " AND (DIVISION_ID =0 OR DIVISION_ID="+divisionId+")";
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                upPositionId = upPositionId + "," + rs.getLong(PstMappingPosition.fieldNames[PstMappingPosition.FLD_UP_POSITION_ID]);
            }
            rs.close();
            if (!(upPositionId.equals(""))){
                upPositionId = upPositionId.substring(1);
            }
            return upPositionId;
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return upPositionId;
    }    

    public long getEmpIdByPositionId(String positionId, long divisionId) {
        Vector listEmp = new Vector();
        DBResultSet dbrs = null;
        long empId = 0;
        long empTemp = 0;
        try {
            String sql = "SELECT hr_position.POSITION_ID, hr_position.POSITION, ";
            sql += " hr_employee.EMPLOYEE_ID, hr_employee.FULL_NAME, hr_employee.DIVISION_ID ";
            sql += " FROM hr_position ";
            sql += " INNER JOIN hr_employee ON hr_employee.POSITION_ID=hr_position.POSITION_ID ";
            sql += " WHERE hr_position.POSITION_ID IN ("+positionId+")";
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                if (rs.getLong(PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID])==divisionId){
                    empId = rs.getLong(PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID]);
                } else {
                    empTemp = rs.getLong(PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID]);
                }
            }
            if (empId == 0 && empTemp != 0){
                empId = empTemp;
            }
            rs.close();
            
            return empId;
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return empId;
    }
    
    public int getLevelPoint(long positionId){
     int levelPoint = 0;
     
     Position pos = new Position();
     try{
         pos = PstPosition.fetchExc(positionId);
     } catch (Exception exc){
         
     }
     
     Level level = new Level();
     try {
        level = PstLevel.fetchExc(pos.getLevelId());
        levelPoint = level.getLevelPoint();
     } catch (Exception e) {
     }

    return levelPoint;
    }

/*
public String getApproval(long empId, int inc){
    String str = "a";
    if (empId != 0 && inc < 6){
        long posId = getPositionIdByEmpId(empId);
        long upPosId = getUpPositionId(posId);
        long employeId = getEmpIdByPositionId(upPosId);
        if (employeId != 0){
            int loop = inc;
            loop++;
            str = "("+employeId+") "+ getApproval(employeId, loop);
        }
    }

    return str;
}
*/
    public String getHrApproval(long employeeId){
        String str = "";
        
        I_Leave leaveConfig = null;

        try {
            leaveConfig = (I_Leave) (Class.forName(PstSystemProperty.getValueByName("LEAVE_CONFIG")).newInstance());
        } catch (Exception e) {
            System.out.println("Exception : " + e.getMessage());
        }
        
        
        Vector listHRMan = leaveConfig.listSDMApproval(employeeId);
        //Vector listHRMan = leaveConfig.getApprovalEmployeeTopLink(objLeaveApplication.getDepHeadApproval(), 3);

        if (listHRMan != null && listHRMan.size() > 0) {

            for (int i = 0; i < listHRMan.size(); i++) {
                Employee objEmp = (Employee) listHRMan.get(i);
                str = str + " / " + getEmployeeName(objEmp.getOID());
            }
            str = str.substring(2);
        }

        return str;
    }
    
    
    public String getApprovalView(long empId, int maxApproval, long divisionId){
        String str = "";
        Vector listEmployeeDivisionTopLink = new Vector();
        long oidDireksi = 0;
        long oidKomisaris = 0;
        long hr_department = Long.parseLong(PstSystemProperty.getValueByName("OID_HRD_DEPARTMENT"));   
        try {
            oidDireksi = Long.parseLong(com.dimata.system.entity.PstSystemProperty.getValueByName("OID_DIREKSI"));
           
        } catch (Exception exc){
            oidDireksi = 0;
        }
        try {
            oidKomisaris = Long.parseLong(com.dimata.system.entity.PstSystemProperty.getValueByName("OID_KOMISARIS"));
           
        } catch (Exception exc){
            oidKomisaris = 0;
        }
        
        I_Leave leaveConfig = null;

        try {
            leaveConfig = (I_Leave) (Class.forName(PstSystemProperty.getValueByName("LEAVE_CONFIG")).newInstance());
        } catch (Exception e) {
            System.out.println("Exception : " + e.getMessage());
        }
        if (empId != 0){
            
            Employee employee =  new Employee();
            try {
                employee = PstEmployee.fetchExc(empId);
            } catch (Exception exc){}
            
            int lvlEmp = getLevelPoint(employee.getPositionId());
            
            if(lvlEmp < maxApproval){
                
                String posId = getPositionIdByEmpId(empId);
                String upPosId = getUpPositionId(posId, divisionId);
                String upPosByDivisionId = getUpPositionByDivisionId(posId, divisionId);
                long employeeId = getEmpIdByPositionId(upPosId, employee.getDivisionId());
                if (!upPosByDivisionId.equals("")){
                    listEmployeeDivisionTopLink      = PstEmployee.listEmployeeApprovalTopLink(0, 0, " (POSITION_ID IN ("+upPosId+")  AND `DEPARTMENT_ID` = "+employee.getDepartmentId()+") OR POSITION_ID IN ("+upPosByDivisionId+")" , "", 0,0, 0);
                    if (listEmployeeDivisionTopLink == null || listEmployeeDivisionTopLink.size() == 0){
                       listEmployeeDivisionTopLink      = PstEmployee.listEmployeeApprovalTopLink(0, 0, " (POSITION_ID IN ("+upPosId+")  AND `DIVISION_ID` IN ('"+employee.getDivisionId()+"','"+oidDireksi+"','"+oidKomisaris+"')) OR POSITION_ID IN ("+upPosByDivisionId+")" , "", 0,0, 0);                
                    }
                } else {
                    listEmployeeDivisionTopLink      = PstEmployee.listEmployeeApprovalTopLink(0, 0, " POSITION_ID IN ("+upPosId+")  AND `DEPARTMENT_ID` = "+employee.getDepartmentId() , "", 0,0, 0);
                    if (listEmployeeDivisionTopLink == null || listEmployeeDivisionTopLink.size() == 0){
                       listEmployeeDivisionTopLink      = PstEmployee.listEmployeeApprovalTopLink(0, 0, " POSITION_ID IN ("+upPosId+")  AND `DIVISION_ID` IN ('"+employee.getDivisionId()+"','"+oidDireksi+"','"+oidKomisaris+"')" , "", 0,0, 0);                
                    }
                }
                if (listEmployeeDivisionTopLink.size() > 0){
                    for (int i=0;i< listEmployeeDivisionTopLink.size(); i++){
                        Employee emp = (Employee) listEmployeeDivisionTopLink.get(i);
                        int empApprovalStatus = leaveConfig.getApprovalEmployeeLeaveStatus(emp.getOID());
                        if (empApprovalStatus == 1){
                            int lvlEmpUp = getLevelPoint(emp.getPositionId());
                            Vector listEmpReplacement = leaveConfig.getApprovalEmployeeReplacement(empId, emp.getOID(), lvlEmpUp, 3,divisionId);
                            if (listEmpReplacement.size() > 0){
                                for (int x=0; x < listEmpReplacement.size(); x ++){
                                    Employee objEmpReplacement = (Employee) listEmpReplacement.get(x);
                                    str = str + " / " + getEmployeeName(objEmpReplacement.getOID());
                                }
                            } else if (listEmployeeDivisionTopLink.size() == 1){
                                str = str + " / " + getApprovalView(emp.getOID(),maxApproval, divisionId);
                            }
                        } else {
                            str = str + " / " + getEmployeeName(emp.getOID());
                        }
                    }
                    str = str.substring(2);
                } else {
                    String upPosIdReplacement = getUpPositionIdReplacement(upPosId, divisionId);
                    employeeId = getEmpIdByPositionId(upPosId, employee.getDivisionId());
                    if (upPosIdReplacement.equals("")){
                        upPosId = getUpPositionId(upPosId, divisionId);
                        upPosByDivisionId = getUpPositionByDivisionId(upPosId, divisionId);
                        if (!upPosByDivisionId.equals("")){
                            listEmployeeDivisionTopLink      = PstEmployee.listEmployeeApprovalTopLink(0, 0, " (POSITION_ID IN ("+upPosId+")  AND `DIVISION_ID` IN ('"+employee.getDivisionId()+"','"+oidDireksi+"','"+oidKomisaris+"')) OR POSITION_ID IN ("+upPosByDivisionId+")" , "", 0,0, 0); 
                        } else {
                            listEmployeeDivisionTopLink      = PstEmployee.listEmployeeApprovalTopLink(0, 0, " POSITION_ID IN ("+upPosId+")  AND `DIVISION_ID` IN ('"+employee.getDivisionId()+"','"+oidDireksi+"','"+oidKomisaris+"')" , "", 0,0, 0); 
                        }
                    } else {
                        listEmployeeDivisionTopLink      = PstEmployee.listEmployeeApprovalTopLink(0, 0, " POSITION_ID IN ("+upPosIdReplacement+")" , "", 0,0, 0);     
                    }
                    if (listEmployeeDivisionTopLink.size() > 0){
                        for (int i=0;i< listEmployeeDivisionTopLink.size(); i++){
                            Employee emp = (Employee) listEmployeeDivisionTopLink.get(i);
                            int empApprovalStatus = leaveConfig.getApprovalEmployeeLeaveStatus(emp.getOID());
                            if (empApprovalStatus == 1){
                                int lvlEmpUp = getLevelPoint(emp.getPositionId());
                                Vector listEmpReplacement = leaveConfig.getApprovalEmployeeReplacement(empId, emp.getOID(), lvlEmpUp, 3,divisionId);
                                if (listEmpReplacement.size() > 0){
                                    for (int x=0; x < listEmpReplacement.size(); x ++){
                                        Employee objEmpReplacement = (Employee) listEmpReplacement.get(x);
                                        str = str + " / " + getEmployeeName(objEmpReplacement.getOID());
                                    }
                                } else if (listEmployeeDivisionTopLink.size() == 1){
                                    str = str + " / " + getApprovalView(emp.getOID(),maxApproval, divisionId);
                                }
                            } else {
                                str = str + " / " + getEmployeeName(emp.getOID());
                            }
                        }
                        str = str.substring(2);
                    } else if (hr_department != employee.getDepartmentId()){
                
                        Vector listHRMan = leaveConfig.listSDMApproval(empId);
                        if (listHRMan != null && listHRMan.size() > 0) {
                            for (int i = 0; i < listHRMan.size(); i++) {
                                Employee objEmp = (Employee) listHRMan.get(i);
                                str = str + " / " + getEmployeeName(objEmp.getOID());
                            }
                            str = str.substring(2);
                        }
                    }
                }
            } else if (hr_department != employee.getDepartmentId()){
                
                Vector listHRMan = leaveConfig.listSDMApproval(empId);
                if (listHRMan != null && listHRMan.size() > 0) {
                    for (int i = 0; i < listHRMan.size(); i++) {
                        Employee objEmp = (Employee) listHRMan.get(i);
                        str = str + " / " + getEmployeeName(objEmp.getOID());
                    }
                    str = str.substring(2);
                }
            }
        }

        return str;
    }

    public String getApproval(long empId, int inc, long logHistoryId, long userLoggin, int maxApproval, long divisionId){
        String str = "";
        String str2 = "";
        LogSysHistory logSysHistory = new LogSysHistory();
        Vector listEmployeeDivisionTopLink = new Vector();
        long hr_department = Long.parseLong(PstSystemProperty.getValueByName("OID_HRD_DEPARTMENT"));
        long oidDireksi = 0;
        long oidKomisaris = 0;
           
        try {
            oidDireksi = Long.parseLong(com.dimata.system.entity.PstSystemProperty.getValueByName("OID_DIREKSI"));
           
        } catch (Exception exc){
            oidDireksi = 0;
        }
        try {
            oidKomisaris = Long.parseLong(com.dimata.system.entity.PstSystemProperty.getValueByName("OID_KOMISARIS"));

        } catch (Exception exc){
                oidKomisaris = 0;
        }
        int fieldApp = 0;
        try {
            logSysHistory = PstLogSysHistory.fetchExc(logHistoryId);
            fieldApp = getFieldApproval(logSysHistory.getApprover1(), 
            logSysHistory.getApprover2(), logSysHistory.getApprover3(), 
            logSysHistory.getApprover4(), logSysHistory.getApprover5(), 
            logSysHistory.getApprover6());
        } catch(Exception e){
            System.out.println(e.toString());
        }
        
        I_Leave leaveConfig = null;

        try {
            leaveConfig = (I_Leave) (Class.forName(PstSystemProperty.getValueByName("LEAVE_CONFIG")).newInstance());
        } catch (Exception e) {
            System.out.println("Exception : " + e.getMessage());
        }
        
        if (empId != 0 && inc < 6){
            Employee employee =  new Employee();
            try {
                employee = PstEmployee.fetchExc(empId);
            } catch (Exception exc){}
            
            int lvlEmp = getLevelPoint(employee.getPositionId());
            
            if(lvlEmp < maxApproval){
            
                String posId = getPositionIdByEmpId(empId);
                String upPosId = getUpPositionId(posId, divisionId);
                String upPosByDivisionId = getUpPositionByDivisionId(posId, divisionId);
                long employeeId = getEmpIdByPositionId(upPosId, employee.getDivisionId());
                if (!upPosByDivisionId.equals("")){
                    listEmployeeDivisionTopLink      = PstEmployee.listEmployeeApprovalTopLink(0, 0, " (POSITION_ID IN ("+upPosId+")  AND `DEPARTMENT_ID` = "+employee.getDepartmentId()+") OR POSITION_ID IN ("+upPosByDivisionId+")" , "", 0,0, 0);
                    if (listEmployeeDivisionTopLink == null || listEmployeeDivisionTopLink.size() == 0){
                       listEmployeeDivisionTopLink      = PstEmployee.listEmployeeApprovalTopLink(0, 0, " (POSITION_ID IN ("+upPosId+")  AND `DIVISION_ID` IN ('"+employee.getDivisionId()+"','"+oidDireksi+"','"+oidKomisaris+"')) OR POSITION_ID IN ("+upPosByDivisionId+")" , "", 0,0, 0);                
                    }
                } else {
                    listEmployeeDivisionTopLink      = PstEmployee.listEmployeeApprovalTopLink(0, 0, " POSITION_ID IN ("+upPosId+")  AND `DEPARTMENT_ID` = "+employee.getDepartmentId() , "", 0,0, 0);
                    if (listEmployeeDivisionTopLink == null || listEmployeeDivisionTopLink.size() == 0){
                       listEmployeeDivisionTopLink      = PstEmployee.listEmployeeApprovalTopLink(0, 0, " POSITION_ID IN ("+upPosId+")  AND `DIVISION_ID` IN ('"+employee.getDivisionId()+"','"+oidDireksi+"','"+oidKomisaris+"')" , "", 0,0, 0);               
                    }
                }
                if (listEmployeeDivisionTopLink.size() > 0){
                    for (int i=0;i< listEmployeeDivisionTopLink.size(); i++){
                        Employee emp = (Employee) listEmployeeDivisionTopLink.get(i);
                        int empApprovalStatus = leaveConfig.getApprovalEmployeeLeaveStatus(emp.getOID());
                        long oidEmpReal = 0;
                        if (empApprovalStatus == 1){
                            oidEmpReal = emp.getOID();
                            int lvlEmpUp = getLevelPoint(emp.getPositionId());
                            Vector listEmpReplacement = leaveConfig.getApprovalEmployeeReplacement(empId, emp.getOID(), lvlEmpUp, 3, divisionId);
                            if (listEmpReplacement.size() > 0){
                                for (int x=0; x < listEmpReplacement.size(); x ++){
                                    emp = (Employee) listEmpReplacement.get(x);
                                    if (emp.getOID() == userLoggin){
                                        break;
                                    }
                                    
                                }
                            } else if (listEmployeeDivisionTopLink.size() == 1){
                                str = getApproval(emp.getOID(),inc, logHistoryId, userLoggin, maxApproval, divisionId);
                                break;
                            }
                        } 
                        int loop = inc;
                        loop++;
                        if (emp.getOID() != userLoggin){
                            //getApproval(employeeId, loop, leaveAppId, userLoggin);
                            //str = "<a class=\"btn-grey\" style=\"color:#FFF\" href=\"javascript:cmdViewApproval('"+leaveAppId+"')\">View</a>";
                        } else {
                            /* Jika employeeId == useLoggin */
                            if (logSysHistory.getOID() != 0){
                                if (logSysHistory.getApprover1()== userLoggin 
                                || logSysHistory.getApprover2() == userLoggin 
                                || logSysHistory.getApprover3() == userLoggin
                                || logSysHistory.getApprover4() == userLoggin
                                || logSysHistory.getApprover5() == userLoggin
                                || logSysHistory.getApprover6() == userLoggin){
                                    //str = "<a class=\"btn-grey\" style=\"color:#FFF\" href=\"javascript:cmdViewApproval('"+leaveAppId+"')\">View</a>";
                                } else if(oidEmpReal != 0 && oidEmpReal != emp.getOID()) {
                                        if (logSysHistory.getLogStatus() != 6){
                                            int check = checkNextApproval(oidEmpReal, maxApproval, divisionId, logHistoryId);
                                            str = "<a class=\"btn\" style=\"color:#38a109\" href=\"javascript:cmdApprove('"+oidEmpReal+"','"+logHistoryId+"','"+fieldApp+"','"+check+"','"+userLoggin+"')\">Approve</a>";
                                            str2 = "<a class=\"btn\" style=\"color:#e04f5f\" href=\"javascript:cmdDecline('"+oidEmpReal+"','"+logHistoryId+"','"+fieldApp+"','-1','"+userLoggin+"')\">Tolak</a>";
                                        }
                                        break;    
                                } else {
                                        if (logSysHistory.getLogStatus() != 6){
                                            int check = checkNextApproval(userLoggin, maxApproval, divisionId, logHistoryId);
                                            str = "<a class=\"btn\" style=\"color:#38a109\" href=\"javascript:cmdApprove('"+userLoggin+"','"+logHistoryId+"','"+fieldApp+"','"+check+"','0')\">Approve</a>";
                                            str2 = "<a class=\"btn\" style=\"color:#e04f5f\" href=\"javascript:cmdDecline('"+userLoggin+"','"+logHistoryId+"','"+fieldApp+"','-1','0')\">Tolak</a>";
                                        }
                                        break;
                                    }
                                }
                            }
                        }
                    }
                else {
                    /* jika up position ada (top link) dan employee == 0*/
                    String upPosIdReplacement = getUpPositionIdReplacement(upPosId, divisionId);
                    employeeId = getEmpIdByPositionId(upPosId, employee.getDivisionId());
                    if (upPosIdReplacement.equals("")){
                        upPosId = getUpPositionId(upPosId, divisionId);
                        upPosByDivisionId = getUpPositionByDivisionId(upPosId, divisionId);
                        if (!upPosByDivisionId.equals("")){
                            listEmployeeDivisionTopLink      = PstEmployee.listEmployeeApprovalTopLink(0, 0, " (POSITION_ID IN ("+upPosId+")  AND `DIVISION_ID` IN ('"+employee.getDivisionId()+"','"+oidDireksi+"','"+oidKomisaris+"')) OR POSITION_ID IN ("+upPosByDivisionId+")" , "", 0,0, 0); 
                        } else {
                            listEmployeeDivisionTopLink      = PstEmployee.listEmployeeApprovalTopLink(0, 0, " POSITION_ID IN ("+upPosId+")  AND `DIVISION_ID` IN ('"+employee.getDivisionId()+"','"+oidDireksi+"','"+oidKomisaris+"')" , "", 0,0, 0); 
                        }
                    } else {
                        listEmployeeDivisionTopLink      = PstEmployee.listEmployeeApprovalTopLink(0, 0, " POSITION_ID IN ("+upPosIdReplacement+")" , "", 0,0, 0);     
                    } 
                    if (listEmployeeDivisionTopLink.size() > 0){
                        for (int i=0;i< listEmployeeDivisionTopLink.size(); i++){
                            Employee emp = (Employee) listEmployeeDivisionTopLink.get(i);
                            int empApprovalStatus = leaveConfig.getApprovalEmployeeLeaveStatus(emp.getOID());
                            long oidEmpReal = 0;
                            if (empApprovalStatus == 1){
                                oidEmpReal = emp.getOID();
                                int lvlEmpUp = getLevelPoint(emp.getPositionId());
                                Vector listEmpReplacement = leaveConfig.getApprovalEmployeeReplacement(empId, emp.getOID(), lvlEmpUp, 3, divisionId);
                                if (listEmpReplacement.size() > 0){
                                    for (int x=0; x < listEmpReplacement.size(); x ++){
                                        emp = (Employee) listEmpReplacement.get(x);
                                        if (emp.getOID() == userLoggin){
                                            break;
                                        }

                                    }
                                } else if (listEmployeeDivisionTopLink.size() == 1){
                                    str = getApproval(emp.getOID(),inc, logHistoryId, userLoggin, maxApproval, divisionId);
                                    break;
                                }
                            } 
                            if (emp.getOID() == userLoggin){
                                if (logSysHistory.getLogStatus() != 6){
                                    str = "<a class=\"btn\" style=\"color:#38a109\" href=\"javascript:cmdApprove('"+userLoggin+"','"+logHistoryId+"','"+fieldApp+"','2','0')\">Approve</a>";
                                    str2 = "<a class=\"btn\" style=\"color:#e04f5f\" href=\"javascript:cmdDecline('"+userLoggin+"','"+logHistoryId+"','"+fieldApp+"','-1','0')\">Tolak</a>";
                                }
                                    break;
                            } else {
                                //str = "<a class=\"btn-grey\" style=\"color:#FFF\" href=\"javascript:cmdViewApproval('"+logHistoryId+"')\">View</a>";
                            }
                        }
                    } else if (hr_department != employee.getDepartmentId()){
                        Vector listHRMan = leaveConfig.listSDMApproval(empId);
                        if (listHRMan != null && listHRMan.size() > 0) {
                            for (int i = 0; i < listHRMan.size(); i++) {
                                Employee objEmp = (Employee) listHRMan.get(i);
                                if (objEmp.getOID() == userLoggin){
                                    if (logSysHistory.getLogStatus() != 6){
                                        str = "<a class=\"btn\" style=\"color:#38a109\" href=\"javascript:cmdApprove('"+userLoggin+"','"+logHistoryId+"','7','2','0')\">Approve</a>";
                                        str2 = "<a class=\"btn\" style=\"color:#e04f5f\" href=\"javascript:cmdDecline('"+userLoggin+"','"+logHistoryId+"','7','-1','0')\">Tolak</a>";
                                    }
                                }
                            }
                        }
                    }
                } 
            } else if (hr_department != employee.getDepartmentId()){
                Vector listHRMan = leaveConfig.listSDMApproval(empId);
                if (listHRMan != null && listHRMan.size() > 0) {
                    for (int i = 0; i < listHRMan.size(); i++) {
                        Employee objEmp = (Employee) listHRMan.get(i);
                        if (objEmp.getOID() == userLoggin){
                            if (logSysHistory.getLogStatus() != 6){
                                str = "<a class=\"btn\" style=\"color:#38a109\" href=\"javascript:cmdApprove('"+userLoggin+"','"+logHistoryId+"','7','2','0')\">Approve</a>";
                                str2 = "<a class=\"btn\" style=\"color:#e04f5f\" href=\"javascript:cmdDecline('"+userLoggin+"','"+logHistoryId+"','7','-1','0')\">Tolak</a>";
                            }
                        }
                    }
                }
            }
        }
        
        return str+"&nbsp;"+str2;
    }

    public int getFieldApproval(long approval1, long approval2, long approval3, long approval4, long approval5, long approval6){
        int fieldApp = 0;
        if (approval1 == 0 
        & approval2 == 0 
        & approval3 == 0
        & approval4 == 0
        & approval5 == 0
        & approval6 == 0){
            fieldApp = 1;
        }
        if (approval1 != 0 
        & approval2 == 0 
        & approval3 == 0
        & approval4 == 0
        & approval5 == 0
        & approval6 == 0){
            fieldApp = 2;
        }
        if (approval1 != 0 
        & approval2 != 0 
        & approval3 == 0
        & approval4 == 0
        & approval5 == 0
        & approval6 == 0){
            fieldApp = 3;
        }
        if (approval1 != 0 
        & approval2 != 0 
        & approval3 != 0
        & approval4 == 0
        & approval5 == 0
        & approval6 == 0){
            fieldApp = 4;
        }
        if (approval1 != 0 
        & approval2 != 0 
        & approval3 != 0
        & approval4 != 0
        & approval5 == 0
        & approval6 == 0){
            fieldApp = 5;
        }
        if (approval1 != 0 
        & approval2 != 0 
        & approval3 != 0
        & approval4 != 0
        & approval5 != 0
        & approval6 == 0){
            fieldApp = 6;
        }
        return fieldApp;
    }

    public long checkTopLink(String positionId) {
        DBResultSet dbrs = null;
        long empId = 0;
        try {
            String sql = "SELECT hr_position.POSITION_ID, hr_position.POSITION, ";
            sql += " hr_employee.EMPLOYEE_ID, hr_employee.FULL_NAME, hr_employee.DIVISION_ID ";
            sql += " FROM hr_position ";
            sql += " INNER JOIN hr_employee ON hr_employee.POSITION_ID=hr_position.POSITION_ID ";
            sql += " WHERE hr_position.POSITION_ID IN ("+positionId+")";
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                if (rs.getLong(PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID])==divisionId){
                    empId = rs.getLong(PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID]);
                } 
            }
            rs.close();
            return empId;
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return empId;
    }

    public int checkNextApproval(long empId, int maxApproval,long divisionId, long logHistoryId){
        int status = 0;
        boolean check = false;
        Vector listEmployeeDivisionTopLink = new Vector();
        long hr_department = Long.parseLong(PstSystemProperty.getValueByName("OID_HRD_DEPARTMENT"));
        long oidDireksi = 0;
        long oidKomisaris = 0;
        
        I_Leave leaveConfig = null;

        try {
            leaveConfig = (I_Leave) (Class.forName(PstSystemProperty.getValueByName("LEAVE_CONFIG")).newInstance());
        } catch (Exception e) {
            System.out.println("Exception : " + e.getMessage());
        }
           
        try {
            oidDireksi = Long.parseLong(com.dimata.system.entity.PstSystemProperty.getValueByName("OID_DIREKSI"));
           
        } catch (Exception exc){
            oidDireksi = 0;
        }
        try {
            oidKomisaris = Long.parseLong(com.dimata.system.entity.PstSystemProperty.getValueByName("OID_KOMISARIS"));

        } catch (Exception exc){
                oidKomisaris = 0;
        }
        if (empId != 0){
            Employee employee =  new Employee();
            try {
                employee = PstEmployee.fetchExc(empId);
            } catch (Exception exc){}
            
            int lvlEmp = getLevelPoint(employee.getPositionId());
            
            if(lvlEmp < maxApproval){
                String posId = getPositionIdByEmpId(empId);
                String upPosId = getUpPositionId(posId, divisionId);
                String upPosByDivisionId = getUpPositionByDivisionId(upPosId, divisionId);
                //check = checkPositionDivision(upPosId);
                long employeeId = checkTopLink(upPosId);
                if (!upPosByDivisionId.equals("")){
                    listEmployeeDivisionTopLink      = PstEmployee.listEmployeeApprovalTopLink(0, 0, " (POSITION_ID IN ("+upPosId+")  AND `DEPARTMENT_ID` = "+employee.getDepartmentId()+") OR POSITION_ID IN ("+upPosByDivisionId+")" , "", 0,0, 0);
                    if (listEmployeeDivisionTopLink == null || listEmployeeDivisionTopLink.size() == 0){
                       listEmployeeDivisionTopLink      = PstEmployee.listEmployeeApprovalTopLink(0, 0, " (POSITION_ID IN ("+upPosId+")  AND `DIVISION_ID` IN ('"+employee.getDivisionId()+"','"+oidDireksi+"','"+oidKomisaris+"')) OR POSITION_ID IN ("+upPosByDivisionId+")" , "", 0,0, 0);                
                    }
                } else {
                    listEmployeeDivisionTopLink      = PstEmployee.listEmployeeApprovalTopLink(0, 0, " POSITION_ID IN ("+upPosId+")  AND `DEPARTMENT_ID` = "+employee.getDepartmentId() , "", 0,0, 0);
                    if (listEmployeeDivisionTopLink == null || listEmployeeDivisionTopLink.size() == 0){
                       listEmployeeDivisionTopLink      = PstEmployee.listEmployeeApprovalTopLink(0, 0, " POSITION_ID IN ("+upPosId+")  AND `DIVISION_ID` IN ('"+employee.getDivisionId()+"','"+oidDireksi+"','"+oidKomisaris+"')" , "", 0,0, 0);                
                    }
                }
                if (listEmployeeDivisionTopLink.size() > 0){
                    for (int i=0; i < listEmployeeDivisionTopLink.size(); i++){
                        Employee emp = (Employee) listEmployeeDivisionTopLink.get(i);
                        int lvlApp = getLevelPoint(emp.getPositionId());
                        if (lvlApp <= maxApproval){
                            int empApprovalStatus = leaveConfig.getApprovalEmployeeLeaveStatus(emp.getOID());
                            if (empApprovalStatus == 1){
                                int lvlEmpUp = getLevelPoint(emp.getPositionId());
                                Vector listEmpReplacement = leaveConfig.getApprovalEmployeeReplacement(empId, emp.getOID(), lvlEmpUp, 3, divisionId);
                                if (listEmpReplacement.size() > 0){
                                    status = 1;
                                    for (int x=0; x < listEmpReplacement.size(); x ++){
                                        Employee objEmpReplacement = (Employee) listEmpReplacement.get(x);
                                        if (objEmpReplacement.getOID() == empId){
                                            status = 2;
                                        }
                                    }
                                } else {
                                    status = 2;
                                }
                            }  else {
                                status = 1;
                            }
                            
                        } else {
                            status = 2;
                        }
                    }
                } else {
                    String upPosIdReplacement = getUpPositionIdReplacement(upPosId, divisionId);
                    employeeId = getEmpIdByPositionId(upPosId, employee.getDivisionId());
                    if (upPosIdReplacement.equals("")){
                        upPosId = getUpPositionId(upPosId, divisionId);
                        upPosByDivisionId = getUpPositionByDivisionId(upPosId, divisionId);
                        if (!upPosByDivisionId.equals("")){
                            listEmployeeDivisionTopLink      = PstEmployee.listEmployeeApprovalTopLink(0, 0, " (POSITION_ID IN ("+upPosId+")  AND `DIVISION_ID` IN ('"+employee.getDivisionId()+"','"+oidDireksi+"','"+oidKomisaris+"')) OR POSITION_ID IN ("+upPosByDivisionId+")" , "", 0,0, 0); 
                        } else {
                            listEmployeeDivisionTopLink      = PstEmployee.listEmployeeApprovalTopLink(0, 0, " POSITION_ID IN ("+upPosId+")  AND `DIVISION_ID` IN ('"+employee.getDivisionId()+"','"+oidDireksi+"','"+oidKomisaris+"')" , "", 0,0, 0); 
                        }
                    } else {
                        listEmployeeDivisionTopLink      = PstEmployee.listEmployeeApprovalTopLink(0, 0, " POSITION_ID IN ("+upPosIdReplacement+")" , "", 0,0, 0);     
                    }
                    if (listEmployeeDivisionTopLink.size() > 0){
                        for (int i=0;i< listEmployeeDivisionTopLink.size(); i++){
                            Employee emp = (Employee) listEmployeeDivisionTopLink.get(i);
                            int lvlApp = getLevelPoint(emp.getPositionId());
                            if (lvlApp <= maxApproval){
                                int empApprovalStatus = leaveConfig.getApprovalEmployeeLeaveStatus(emp.getOID());
                                if (empApprovalStatus == 1){
                                    int lvlEmpUp = getLevelPoint(emp.getPositionId());
                                    Vector listEmpReplacement = leaveConfig.getApprovalEmployeeReplacement(empId, emp.getOID(), lvlEmpUp, 3,divisionId);
                                    if (listEmpReplacement.size() > 0){
                                        status = 1;
                                        for (int x=0; x < listEmpReplacement.size(); x ++){
                                            Employee objEmpReplacement = (Employee) listEmpReplacement.get(x);
                                            if (objEmpReplacement.getOID() == empId){
                                                status = 2;
                                            }
                                        }
                                    } else {
                                        status = 2;
                                    }
                                } else {
                                    status = 1;
                                }
                            } else {
                                status = 2;
                            }
                        }
                    } else if (employee.getDepartmentId() != hr_department){
                        status = 1;
                    }else {
                        status = 2;
                    }
                }
            } else if (employee.getDepartmentId() != hr_department){
                status = 1;
            }else {
                status = 2;
            }
        } 

        return status;
    }

    public boolean checkPositionDivision(String positionId){
        boolean status = false;
        DBResultSet dbrs = null;
        long posDivId = 0;
        try {
            String sql = "SELECT * FROM hr_position_division WHERE position_id IN ("+positionId+")";
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                posDivId = rs.getLong(PstPositionDivision.fieldNames[PstPositionDivision.FLD_DIVISION_ID]);
            }
            rs.close();
            if (posDivId == divisionId){
                status = true;
            }
            return status;
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return status;
    }
%>
<style type="text/css">
    body {
        color: #575757;
        margin: 0;
        padding: 0;
        font-size: 12px;
        font-family: sans-serif;
    }
    .tblStyle {border-collapse: collapse; }
    .tblStyle td {padding: 5px 7px; border: 1px solid #CCC; font-size: 12px; }
    .title_tbl {font-weight: bold;background-color: #DDD; color: #575757;}
    .tbl_date_red{
        font-weight: bold;
        color: #B83916;
        font-size: 11px;
        background-color: #FFD5C9;
        padding: 3px 5px;
        border-radius: 3px;
    }
    .content-main {
        padding: 21px;
        padding-top: 150px;
    }
    .btn {
        background-color: #DDD;
        border-radius: 3px;
        font-family: Arial;
        border-radius: 3px;
        color: #575757;
        font-size: 12px;
        padding: 7px 11px 7px 11px;
        text-decoration: none;
    }

    .btn:hover {
        color: #474747;
        background-color: #CCC;
        text-decoration: none;
    }
    #style_add {
        font-weight: bold;
        color: #677A1F;
        font-size: 11px;
        background-color: #E8F5BA;
        padding: 3px 5px;
        border-radius: 3px;
    }
    #style_edit {
        font-weight: bold;
        color: #257865;
        font-size: 11px;
        background-color: #BAF5E7;
        padding: 3px 5px;
        border-radius: 3px;
    }
    #style_delete {
        font-weight: bold;
        color: #8F2F3A;
        font-size: 11px;
        background-color: #F5CBD0;
        padding: 3px 5px;
        border-radius: 3px;
    }
    #style_login {
        font-weight: bold;
        color: #B83916;
        font-size: 11px;
        background-color: #FFD5C9;
        padding: 3px 5px;
        border-radius: 3px;
    }
    .header {
        position: fixed;
        width: 100%;
        padding-left: 21px;
        min-height: 130px;
        color:#FFF;
        border-top: 1px solid #CCC;
        border-bottom: 1px solid #CCC;
        background-color: #EEE;
    }
    #inp {
        color: #474747;
        border: 1px solid #CCC;
        border-radius: 3px;
        padding: 5px 7px;
    }
</style>
<script type="text/javascript">
    function cmdPerintah(){
        document.frm.perintah.value="1";
        document.frm.action="more_detail.jsp";
        document.frm.submit();
    }
    function cmdApprove(empApproved, oidLog, fieldApproval, checkApp, replacementId){
        document.frm.command.value="<%= Command.APPROVE %>";
        document.frm.employee_id.value=empApproved;
        document.frm.employee_rep.value=replacementId;
        document.frm.oid.value=oidLog;
        document.frm.field_approval.value=fieldApproval;
        document.frm.check_approval.value=checkApp;
        document.frm.action="more_detail_approval.jsp";
        document.frm.submit();
    }
    function cmdDecline(empApproved, oidLog, fieldApproval, checkApp, replacementId){
        document.frm.command.value="<%= Command.APPROVE %>";
        document.frm.employee_id.value=empApproved;
        document.frm.employee_rep.value=replacementId;
        document.frm.oid.value=oidLog;
        document.frm.field_approval.value=fieldApproval;
        document.frm.check_approval.value=checkApp;
        document.frm.action="more_detail_approval.jsp";
        document.frm.submit();
    }
</script>
<%!
    public String parsingData(String data){
        String str = "";
        str = data.replaceAll(";", "<br>");
        return str;
    }
    
    public Vector<String> parsingDataVersi2(String data){
        Vector<String> vdata = new Vector();
        for (String retval : data.split(";")) {
            vdata.add(retval);
        }
        return vdata;
    }
    
    public String getTableDetail(String logDetail){
		String table = "";
		try {
			JSONObject jObject = new JSONObject(logDetail.trim());
                        
			
			table = "<table class=\"tblStyle\">";
                        table += "<tr>";
                        table += "<td class=\"title_tbl\">Field</td>";
                        table += "<td class=\"title_tbl\">Data</td>";
                        table += "</tr>";
                        if (jObject.optJSONArray("items") != null){
                            for (int x = 0; x < jObject.optJSONArray("items").length(); x++){
                                JSONObject obj = jObject.optJSONArray("items").getJSONObject(x);
                                table += "<tr>";
                                Iterator<?> keys = obj.keys();
                                while( keys.hasNext() ) {
                                        table += "<tr>";
                                        String key = (String)keys.next();
                                        table += "<td class=\"title_tbl\">"+key+"</td>";
                                        if (obj.get(key) instanceof JSONArray)
                                                {
                                                        table += "<td><table class=\"tblStyle\">";
                                                        // it's an array
                                                        JSONArray urlArray = (JSONArray) obj.get(key);
                                                        for (int i = 0; i < 1; i++) {
                                                                JSONObject object = urlArray.getJSONObject(i);
                                                                Iterator<?> keysA = object.keys();
                                                                table += "<tr>";
                                                                table += "<td class=\"title_tbl\">no</td>";
                                                                while( keysA.hasNext() ) {
                                                                        String keySA = (String)keysA.next();
                                                                        if ( object.get(keySA) instanceof JSONObject ) {
                                                                                table += "<td class=\"title_tbl\">"+keySA+"</td>";
                                                                        } else {
                                                                                table += "<td class=\"title_tbl\">"+keySA+"</td>";
                                                                        }
                                                                }
                                                                table += "</tr>";
                                                        }
                                                        for (int i = 0; i < urlArray.length(); i++) {
                                                                JSONObject object = urlArray.getJSONObject(i);
                                                                Iterator<?> keysA = object.keys();
                                                                table += "<tr>";
                                                                table += "<td>"+(i+1)+"</td>";
                                                                while( keysA.hasNext() ) {
                                                                        String keySA = (String)keysA.next();
                                                                        if ( object.get(keySA) instanceof JSONObject ) {
                                                                                table += "<td>"+object.get(keySA)+"</td>";
                                                                        } else {
                                                                                table += "<td>"+object.get(keySA)+"</td>";
                                                                        }
                                                                }
                                                                table += "</tr>";

                                                        }
                                                table += "</td></table>";
                                                }
                                        else if ( obj.get(key) instanceof JSONObject ) {
                                                 table += "<td>"+obj.get(key)+"</td>";
                                        } else {
                                                table += "<td>"+obj.get(key)+"</td>";
                                        }
                                }
                            }
                        }
			
		}catch (Exception exc){
			System.out.println(exc.toString());
		}
		
        return table;
    }

    public String getTableDetailUpadate(String logPrev, String logCurr){
		String table = "";
                String[] field = null ;
                String[] prev   = null;
                String[] curr  = null ;
                try {
                    boolean showPrev = false;
                    boolean showCurr = false;
                    JSONObject jObjectPrev = new JSONObject(logPrev.trim());
                    JSONObject jObjectCurrent = new JSONObject(logCurr.trim());
                    

                    table += "<table class=\"tblStyle\">";
                    table += "<tr>";
                    table += "<td class=\"title_tbl\"></td>";
                    table += "<td class=\"title_tbl\">Previous</td>";
                    table += "<td class=\"title_tbl\">Current</td>";
                    table += "</tr>";
                    if (jObjectCurrent.optJSONArray("items") != null){
                            for (int x = 0; x < jObjectCurrent.optJSONArray("items").length(); x++){
                                JSONObject objCurrent = jObjectCurrent.optJSONArray("items").getJSONObject(x);
                                JSONObject objPrev = jObjectPrev.optJSONArray("items").getJSONObject(x);
                                table += "<tr>";
                                Iterator<?> keys = objCurrent.keys();
                                while( keys.hasNext() ) {
                                        table += "<tr>";
                                        String key = (String)keys.next();
                                        table += "<td class=\"title_tbl\">"+key+"</td>";
                                        if (objCurrent.get(key) instanceof JSONArray)
                                                {
                                                        table += "<td><table class=\"tblStyle\">";
                                                        // it's an array
                                                        JSONArray urlArray = (JSONArray) objCurrent.get(key);
                                                        JSONArray urlArrayPrev = (JSONArray) objPrev.get(key);
                                                        for (int i = 0; i < 1; i++) {
                                                                JSONObject object = urlArray.getJSONObject(i);
                                                                Iterator<?> keysA = object.keys();
                                                                table += "<tr>";
                                                                table += "<td class=\"title_tbl\">no</td>";
                                                                while( keysA.hasNext() ) {
                                                                        String keySA = (String)keysA.next();
                                                                        if ( object.get(keySA) instanceof JSONObject ) {
                                                                                table += "<td class=\"title_tbl\">"+keySA+"</td>";
                                                                        } else {
                                                                                table += "<td class=\"title_tbl\">"+keySA+"</td>";
                                                                        }
                                                                }
                                                                table += "</tr>";
                                                        }
                                                        for (int i = 0; i < urlArray.length(); i++) {
                                                                JSONObject object = urlArray.getJSONObject(i);
                                                                JSONObject objectPrev = urlArrayPrev.getJSONObject(i);
                                                                Iterator<?> keysA = object.keys();
                                                                table += "<tr>";
                                                                table += "<td>"+(i+1)+"</td>";
                                                                while( keysA.hasNext() ) {
                                                                        String keySA = (String)keysA.next();
                                                                        if ( object.get(keySA) instanceof JSONObject ) {
                                                                                table += "<td>"+objectPrev.get(keySA)+"</td>";
                                                                                table += "<td>"+object.get(keySA)+"</td>";
                                                                        } else {
                                                                                table += "<td>"+objectPrev.get(keySA)+"</td>";
                                                                                table += "<td>"+object.get(keySA)+"</td>";
                                                                        }
                                                                }
                                                                table += "</tr>";

                                                        }
                                                table += "</td></table>";
                                                }
                                        else if ( objCurrent.get(key) instanceof JSONObject ) {
                                                 table += "<td>"+objPrev.get(key)+"</td>";
                                                 table += "<td>"+objCurrent.get(key)+"</td>";
                                        } else {
                                                table += "<td>"+objPrev.get(key)+"</td>";
                                                table += "<td>"+objCurrent.get(key)+"</td>";
                                        }
                                }
                            }
                        }
                    table += "</table>";

		}catch (Exception exc){
			System.out.println(exc.toString());
		}
		
        return table;
    }
%>
<%
int iCommand = FRMQueryString.requestCommand(request);
long logSysHistoryOid = FRMQueryString.requestLong(request, "oid");
int fieldApp = FRMQueryString.requestInt(request, "field_approval");
    int checkApproval = FRMQueryString.requestInt(request, "check_approval");
long oidLog = FRMQueryString.requestLong(request, "oid_log");
int actionParam = FRMQueryString.requestInt(request, "action_param");
String approveNote = FRMQueryString.requestString(request, "approve_note");
int statusUpdate = 0;
String queryUp = "";
Date now = new Date();
if (oidLog != 0 && actionParam != 0){
    if (actionParam == 1){
        statusUpdate = PstLogSysHistory.approveLog(appUserIdSess, ""+now, approveNote, oidLog);
    }
    if (actionParam == 2){
        statusUpdate = PstLogSysHistory.notApproveLog(appUserIdSess, ""+now, approveNote, oidLog);
    }
}
LogSysHistory logSysHistory = new LogSysHistory();
if (logSysHistoryOid != 0){
    logSysHistory = PstLogSysHistory.fetchExc(logSysHistoryOid);
}
SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
if (iCommand == Command.APPROVE){
    try {
        String oidFieldApp = "";
        String dateFieldApp = "";
        String oidFieldRepApp = "";
        String dateNow = sdf.format(now);
        switch(fieldApp){
            case 1: 
                oidFieldApp = PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_APPROVER_1];
                dateFieldApp = PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_APPROVER_1_DATE];
                break;
            case 2: 
                oidFieldApp = PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_APPROVER_2];
                dateFieldApp = PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_APPROVER_2_DATE];
                break;
            case 3: 
                oidFieldApp = PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_APPROVER_3];
                dateFieldApp = PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_APPROVER_3_DATE];
                break;
            case 4: 
                oidFieldApp = PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_APPROVER_4];
                dateFieldApp = PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_APPROVER_4_DATE];
                break;
            case 5: 
                oidFieldApp = PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_APPROVER_5];
                dateFieldApp = PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_APPROVER_5_DATE];
                break;
            case 6: 
                oidFieldApp = PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_APPROVER_6];
                dateFieldApp = PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_APPROVER_6_DATE];
                break;
            case 7:
                oidFieldApp = PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_APPROVER_ID];
                dateFieldApp = PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_APPROVE_DATE];
                break;                
        }
        String sql = "UPDATE doc_log_history SET "+oidFieldApp+"="+appUserSess.getEmployeeId()+", "+dateFieldApp+"='"+dateNow+"'";
        if (checkApproval == -1){
            sql += ", log_status=6 ";
        } else if (checkApproval != 1){
            sql += ", log_status=1 ";
        }
        sql += " WHERE log_id="+logSysHistoryOid;
        DBHandler.execUpdate(sql);
        if (checkApproval == 2){
            DBHandler.execUpdate(logSysHistory.getQuery());
        }
    } catch(Exception e){
        System.out.println(e.toString());
    }
}

%>
<% if (logSysHistoryOid != 0){ 

    long approval1 = 0;
    long approval2 = 0;
    long approval3 = 0;
    long approval4 = 0;
    long approval5 = 0;
    long approval6 = 0;
    long hrApproval = 0;
    Employee emp = new Employee();
    AppUser appUser = new AppUser();
    try {
        logSysHistory = PstLogSysHistory.fetchExc(logSysHistoryOid);
        appUser = PstAppUser.fetch(logSysHistory.getLogUserId());
        emp = PstEmployee.fetchExc(appUser.getEmployeeId());
        approval1 = logSysHistory.getApprover1();
        approval2 = logSysHistory.getApprover2();
        approval3 = logSysHistory.getApprover3();
        approval4 = logSysHistory.getApprover4();
        approval5 = logSysHistory.getApprover5();
        approval6 = logSysHistory.getApprover1();
        hrApproval = logSysHistory.getApproverId();
    } catch(Exception e){
        System.out.println(e.toString());
    }
    
    Position pos = new Position();
    Level level = new Level();
    Level maxLevelObj = new Level();
    int maxLevel = 0;
    if (emp.getOID() != 0){
        
        try {
            pos = PstPosition.fetchExc(emp.getPositionId());            
        } catch (Exception exc){

        }
        
        
        try {
            level = PstLevel.fetchExc(pos.getLevelId());
        } catch (Exception e) {
        }
        
        
        try {
            maxLevelObj = PstLevel.fetchExc(level.getMaxLevelApproval());
        } catch (Exception e) {
        }
        
        maxLevel = maxLevelObj.getLevelPoint();
    }
    
    int lastApproval = 0;
    long employeeId = emp.getOID();
    if (approval6 != 0){
        lastApproval = 6;
        employeeId = approval6;
    } else if (approval5 != 0){
        lastApproval = 5;
        employeeId = approval5;
    } else if (approval4 != 0){
        lastApproval = 4;
        employeeId = approval4;
    } else if (approval3 != 0){
        lastApproval = 3;
        employeeId = approval3;
    } else if (approval2 != 0){
        lastApproval = 2;
        employeeId = approval2;
    } else if (approval1 != 0){
        lastApproval = 1;
        employeeId = approval1;
    }
    long hr_department = Long.parseLong(PstSystemProperty.getValueByName("OID_HRD_DEPARTMENT"));
    
    
%>
<form name="frm" action="">
    <input type="hidden" name="command" value="">
    <input type="hidden" name="employee_id" value="">
    <input type="hidden" name="employee_rep" value="">
    <input type="hidden" name="oid" value="">
    <input type="hidden" name="field_approval" value="">
    <input type="hidden" name="check_approval" value="">
    <input type="hidden" name="oid_log" value="" />
    <input type="hidden" name="action_param" value="" />

    <div class="header">
        <%
                       
                if (approval1 != 0){
                        if (logSysHistory.getLogStatus() == 6 && approval2 == 0 && hrApproval == 0){
                        %>
                            <h3 style="padding-top: 7px; color: #007592;"><%= getEmployeeName(approval1)+" : Declined<br>" %></h3>
                        <%    
                        } else {
                        %>
                            <h3 style="padding-top: 7px; color: #007592;"><%= getEmployeeName(approval1)+" : Approved<br>" %></h3>
                        <%
                        }
                    if (approval2 != 0){
                        if (logSysHistory.getLogStatus() == 6 && approval3 == 0 && hrApproval == 0){
                            %>
                            <h3 style="padding-top: 7px; color: #007592;"><%= getEmployeeName(approval2)+" : Declined<br>" %></h3>
                            <%
                        } else {
                            %>
                            <h3 style="padding-top: 7px; color: #007592;"><%= getEmployeeName(approval2)+" : Approved<br>" %></h3>
                            <%
                        }
                        if (approval3 != 0){
                            if (logSysHistory.getLogStatus() == 6 && approval4 == 0 && hrApproval == 0){
                                %>
                                <h3 style="padding-top: 7px; color: #007592;"><%= getEmployeeName(approval3)+" : Declined<br>" %></h3>
                                <%
                            } else {
                                %>
                                <h3 style="padding-top: 7px; color: #007592;"><%= getEmployeeName(approval3)+" : Approved<br>" %></h3>
                                <%
                            }
                            if (approval4 != 0){
                                if (logSysHistory.getLogStatus() == 6 && approval5 == 0 && hrApproval == 0){
                                    %>
                                    <h3 style="padding-top: 7px; color: #007592;"><%= getEmployeeName(approval4)+" : Declined<br>" %></h3>
                                    <%
                                } else {
                                    %>
                                    <h3 style="padding-top: 7px; color: #007592;"><%= getEmployeeName(approval4)+" : Approved<br>" %></h3>
                                    <%
                                }
                                if (approval5 != 0){
                                    if (logSysHistory.getLogStatus() == 6 && approval6 == 0 && hrApproval == 0){
                                        %>
                                        <h3 style="padding-top: 7px; color: #007592;"><%= getEmployeeName(approval5)+" : Declined<br>" %></h3>
                                        <%
                                    } else {
                                        %>
                                        <h3 style="padding-top: 7px; color: #007592;"><%= getEmployeeName(approval5)+" : Approved<br>" %></h3>
                                        <%
                                    }
                                    if (approval6 != 0){
                                        if (logSysHistory.getLogStatus() == 6){
                                            %>
                                            <h3 style="padding-top: 7px; color: #007592;"><%= getEmployeeName(approval6)+" : Declined<br>" %></h3>
                                            <%
                                        } else {
                                            %>
                                            <h3 style="padding-top: 7px; color: #007592;"><%= getEmployeeName(approval6)+" : Approved<br>" %></h3>
                                            <%
                                        }
                                    } else if (logSysHistory.getLogStatus()== 0) {
                                        %>
                                        <h3 style="padding-top: 7px; color: #007592;"><%= getApprovalView(approval5,maxLevel, emp.getDivisionId())+" : Next<br>" %></h3>
                                        <%
                                    }  else if (hrApproval != 0){
                                        if (logSysHistory.getLogStatus() == 6) {
                                            %>
                                            <h3 style="padding-top: 7px; color: #007592;"><%= getEmployeeName(hrApproval)+" : Declined<br>" %></h3>
                                            <%
                                        } else {
                                            %>
                                            <h3 style="padding-top: 7px; color: #007592;"><%= getEmployeeName(hrApproval)+" : Approved<br>" %></h3>
                                            <%
                                        }
                                    }
                                } else if (logSysHistory.getLogStatus() == 0) {
                                    %>
                                    <h3 style="padding-top: 7px; color: #007592;"><%= getApprovalView(approval4,maxLevel, emp.getDivisionId())+" : Next<br>" %></h3>
                                    <%
                                } else if (hrApproval != 0){
                                    if (logSysHistory.getLogStatus() == 6) {
                                        %>
                                        <h3 style="padding-top: 7px; color: #007592;"><%= getEmployeeName(hrApproval)+" : Declined<br>" %></h3>
                                        <%
                                    } else {
                                        %>
                                        <h3 style="padding-top: 7px; color: #007592;"><%= getEmployeeName(hrApproval)+" : Approved<br>" %></h3>
                                        <%
                                    }
                                } 
                            } else if (logSysHistory.getLogStatus() == 0) {
                                %>
                                <h3 style="padding-top: 7px; color: #007592;"><%= getApprovalView(approval3,maxLevel,emp.getDivisionId())+" : Next<br>" %></h3>
                                <%
                            } else if (hrApproval != 0){
                                if (logSysHistory.getLogStatus() == 6) {
                                    %>
                                    <h3 style="padding-top: 7px; color: #007592;"><%= getEmployeeName(hrApproval)+" : Declined<br>" %></h3>
                                    <%
                                } else {
                                    %>
                                    <h3 style="padding-top: 7px; color: #007592;"><%= getEmployeeName(hrApproval)+" : Approved<br>" %></h3>
                                    <%
                                }
                            }
                        }  else if (logSysHistory.getLogStatus() == 0) {
                            %>
                            <h3 style="padding-top: 7px; color: #007592;"><%= getApprovalView(approval2,maxLevel,emp.getDivisionId())+" : Next<br>" %></h3>
                            <%
                        } else if (hrApproval != 0){
                            if (logSysHistory.getLogStatus() == 6) {
                                %>
                                <h3 style="padding-top: 7px; color: #007592;"><%= getEmployeeName(hrApproval)+" : Declined<br>" %></h3>
                                <%
                            } else {
                                %>
                                <h3 style="padding-top: 7px; color: #007592;"><%= getEmployeeName(hrApproval)+" : Approved<br>" %></h3>
                                <%
                            }
                        }
                    } else if (logSysHistory.getLogStatus() == 0) {
                        %>
                        <h3 style="padding-top: 7px; color: #007592;"><%= getApprovalView(approval1,maxLevel,emp.getDivisionId())+" : Next<br>" %></h3>
                        <%
                    }  else if (hrApproval != 0){
                        if (logSysHistory.getLogStatus() == 6) {
                            %>
                            <h3 style="padding-top: 7px; color: #007592;"><%= getEmployeeName(hrApproval)+" : Declined<br>" %></h3>
                            <%
                        } else {
                            %>
                            <h3 style="padding-top: 7px; color: #007592;"><%= getEmployeeName(hrApproval)+" : Approved<br>" %></h3>
                            <%
                        }
                    }
                } else if (logSysHistory.getLogStatus() == 0) {
                    %>
                    <h3 style="padding-top: 7px; color: #007592;"><%= getApprovalView(emp.getOID(),maxLevel,emp.getDivisionId())+" : Next<br>" %></h3>
                    <%
                } else if (hrApproval != 0){
                    if (logSysHistory.getLogStatus() == 6) {
                        %>
                        <h3 style="padding-top: 7px; color: #007592;"><%= getEmployeeName(hrApproval)+" : Declined<br>" %></h3>
                        <%
                    } else {
                        %>
                        <h3 style="padding-top: 7px; color: #007592;"><%= getEmployeeName(hrApproval)+" : Approved<br>" %></h3>
                        <%
                    }
                } 
                if (logSysHistory.getLogStatus() != PstLogSysHistory.DOCUMENT_STATUS_APPROVED){
                        %>
                        <%= getApproval(employeeId, 0, logSysHistory.getOID(), emplx.getOID(), maxLevel, emp.getDivisionId()) %>
                        <%
                    }
                %>
    </div>
    
<div class="content-main">
    
    <%
     if (logSysHistory != null){           
                String styleAction = "";
                if (logSysHistory.getLogUserAction().equals("ADD")){
                    styleAction = "style_add";
                }
                if (logSysHistory.getLogUserAction().equals("EDIT")){
                    styleAction = "style_edit";
                }
                if (logSysHistory.getLogUserAction().equals("DELETE")){
                    styleAction = "style_delete";
                }
                if (logSysHistory.getLogUserAction().equals("LOGIN")){
                    styleAction = "style_login";
                }           
    %>
        
        
                <table style="padding: 0px; margin: 0px; font-size: 12px;">
                    <tr>
                        <td><strong>Module</strong></td>
                        <td> : <%= logSysHistory.getLogModule() %></td>
                    </tr>
                    <tr>
                        <td><strong>Action</strong></td>
                        <td> : <strong id="<%= styleAction %>"><%=logSysHistory.getLogUserAction()%></strong></td>
                    </tr>
                    <%
                        if (logSysHistory.getLogEditedUserId() > 0){
                            try {
                                Employee employee = PstEmployee.fetchExc(logSysHistory.getLogEditedUserId());
                                
                                %>
                                <tr>
                                    <td><strong>Karyawan</strong></td>
                                    <td> : <strong>[<%=employee.getEmployeeNum()%>] <%=employee.getFullName()%></strong></td>
                                </tr>
                                <%
                            } catch (Exception exc){}
                        }
                    
                    %>
<!--                    <tr>
                        <td><strong>Status</strong></td>
                        <td> : <%= PstLogSysHistory.fieldDocumentStatus[logSysHistory.getLogStatus()] %></td>
                    </tr>-->
                </table>
                <div>&nbsp;</div>
                <%if(logSysHistory.getLogUserAction().equals("EDIT") || logSysHistory.getLogUserAction().equals("APPROVE") || logSysHistory.getLogUserAction().equals("REMOVE APPROVAL")|| logSysHistory.getLogUserAction().equals("UPDATE APPROVAL")){%>
                    <%= getTableDetailUpadate(logSysHistory.getLogPrev(),logSysHistory.getLogCurr()) %>
                <%}else{%>
                    <%= getTableDetail(logSysHistory.getLogDetail()) %>
                <%
                 }
            }
        %>
    
</div>
</form>
<% } %>
<%
if (statusUpdate != 0){
    %>
    <div id="style_add">Data telah diperbarui ! Silahkan klik tombol Search untuk me-refresh hasil pencarian.</div>
    <strong><%= queryUp %></strong>
    <%
}
%>
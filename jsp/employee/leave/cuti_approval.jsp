<%-- 
    Document   : cuti_approval
    Created on : Feb 21, 2017, 2:14:35 PM
    Author     : mchen
--%>
<%@page import="com.dimata.harisma.entity.leave.I_Leave"%>
<%@page import="com.dimata.harisma.entity.leave.PstMessageEmp"%>
<%@page import="com.dimata.harisma.entity.leave.MessageEmp"%>
<%@page import="com.dimata.harisma.entity.leave.SpecialUnpaidLeaveTaken"%>
<%@page import="com.dimata.harisma.entity.leave.PstSpecialUnpaidLeaveTaken"%>
<%@page import="com.dimata.harisma.entity.attendance.LlStockTaken"%>
<%@page import="com.dimata.harisma.entity.attendance.PstLlStockTaken"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.math.RoundingMode"%>
<%@page import="java.math.BigDecimal"%>
<%@page import="com.dimata.harisma.entity.attendance.AlStockTaken"%>
<%@page import="com.dimata.harisma.entity.attendance.PstAlStockTaken"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="com.dimata.qdep.db.DBHandler"%>
<%@page import="com.dimata.qdep.db.DBResultSet"%>
<%@page import="com.dimata.gui.jsp.ControlCombo"%>
<%@page import="com.dimata.harisma.session.leave.LeaveConfigBpd"%>
<%@page import="com.dimata.harisma.entity.leave.LeaveApplication"%>
<%@page import="com.dimata.harisma.entity.leave.PstLeaveApplication"%>
<%@ include file = "../../main/javainit.jsp" %>
<%  //int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_EMPLOYEE, AppObjInfo.G2_LEAVE_APPLICATION, AppObjInfo.OBJ_LEAVE_APPLICATION);%>
<%//@ include file = "../../main/checkuser.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%!
    public long divisionId = 0;
    public String[] leaveType = {
        "Cuti Khusus", "Cuti Hamil", "Cuti Penting", "Cuti Tahunan", "Cuti Besar"
    };
    public int convertInteger(double val){
        BigDecimal bDecimal = new BigDecimal(val);
        bDecimal = bDecimal.setScale(0, RoundingMode.HALF_UP);
        return bDecimal.intValue();
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
            sql += " WHERE hr_mapping_position.TYPE_OF_LINK=3 AND ";
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
            sql += " WHERE hr_mapping_position.TYPE_OF_LINK=3 AND ";
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

    public String getApproval(long empId, int inc, long leaveAppId, long userLoggin, int maxApproval, boolean needHrApproval, long divisionId){
        String str = "";
        LeaveApplication leaveApplication = new LeaveApplication();
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
            leaveApplication = PstLeaveApplication.fetchExc(leaveAppId);
            fieldApp = getFieldApproval(leaveApplication.getApproval_1(), 
            leaveApplication.getApproval_2(), leaveApplication.getApproval_3(), 
            leaveApplication.getApproval_4(), leaveApplication.getApproval_5(), 
            leaveApplication.getApproval_6());
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
                                str = getApproval(emp.getOID(),inc, leaveAppId, userLoggin, maxApproval, needHrApproval, divisionId);
                                break;
                            }
                        } 
                        int loop = inc;
                        loop++;
                        if (emp.getOID() != userLoggin){
                            //getApproval(employeeId, loop, leaveAppId, userLoggin);
                            str = "<a class=\"btn-grey\" style=\"color:#FFF\" href=\"javascript:cmdViewApproval('"+leaveAppId+"')\">View</a>";
                        } else {
                            /* Jika employeeId == useLoggin */
                            if (leaveApplication.getOID() != 0){
                                if (leaveApplication.getApproval_1() == userLoggin 
                                || leaveApplication.getApproval_2() == userLoggin 
                                || leaveApplication.getApproval_3() == userLoggin
                                || leaveApplication.getApproval_4() == userLoggin
                                || leaveApplication.getApproval_5() == userLoggin
                                || leaveApplication.getApproval_6() == userLoggin){
                                    str = "<a class=\"btn-grey\" style=\"color:#FFF\" href=\"javascript:cmdViewApproval('"+leaveAppId+"')\">View</a>";
                                } else if(oidEmpReal != 0 && oidEmpReal != emp.getOID()) {
                                        int check = checkNextApproval(oidEmpReal, needHrApproval, maxApproval, divisionId, leaveAppId);
                                        str = "<a class=\"btn-green\" style=\"color:#38a109\" href=\"javascript:cmdApprove('"+oidEmpReal+"','"+leaveAppId+"','"+fieldApp+"','"+check+"','"+userLoggin+"')\">Approve</a>";
                                        break;    
                                } else {
                                        int check = checkNextApproval(userLoggin, needHrApproval, maxApproval, divisionId, leaveAppId);
                                        str = "<a class=\"btn-green\" style=\"color:#38a109\" href=\"javascript:cmdApprove('"+userLoggin+"','"+leaveAppId+"','"+fieldApp+"','"+check+"','0')\">Approve</a>";
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
                                    str = getApproval(emp.getOID(),inc, leaveAppId, userLoggin, maxApproval, needHrApproval, divisionId);
                                    break;
                                }
                            } 
                            if (emp.getOID() == userLoggin){
                                    str = "<a class=\"btn-green\" style=\"color:#38a109\" href=\"javascript:cmdApprove('"+userLoggin+"','"+leaveAppId+"','"+fieldApp+"','2','0')\">Approve</a>";
                                    break;
                            } else {
                                str = "<a class=\"btn-grey\" style=\"color:#FFF\" href=\"javascript:cmdViewApproval('"+leaveAppId+"')\">View</a>";
                            }
                        }
                    } 
                }
            } else if (needHrApproval && hr_department != employee.getDepartmentId()){
                Vector listHRMan = leaveConfig.listSDMApproval(empId);
                if (listHRMan != null && listHRMan.size() > 0) {
                    for (int i = 0; i < listHRMan.size(); i++) {
                        Employee objEmp = (Employee) listHRMan.get(i);
                        if (objEmp.getOID() == userLoggin){
                            str = "<a class=\"btn-green\" style=\"color:#38a109\" href=\"javascript:cmdApprove('"+userLoggin+"','"+leaveAppId+"','7','2','0')\">Approve</a>";
                        }
                    }
                }
            }
        }
        
        return str;
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

    public int checkNextApproval(long empId, boolean needHrApproval, int maxApproval,long divisionId, long leaveAppId){
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
                    } else {
                        status = 2;
                    }
                }
            } else if (needHrApproval && employee.getDepartmentId() != hr_department){
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
<%
    Vector leaveAppList = new Vector();
    SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
    int iCommand = FRMQueryString.requestCommand(request);
    long employeeId = FRMQueryString.requestLong(request, "employee_id");
    long leaveId = FRMQueryString.requestLong(request, "leave_id");
    long repId = FRMQueryString.requestLong(request, "employee_rep");
    int fieldApp = FRMQueryString.requestInt(request, "field_approval");
    int checkApproval = FRMQueryString.requestInt(request, "check_approval");
    int lvCategory = FRMQueryString.requestInt(request, "leaveCategory");
    long oidSchedule = FRMQueryString.requestLong(request, "schSymbol");
    String message = FRMQueryString.requestString(request, "message");

    if (iCommand == Command.APPROVE){
        try {
            String oidFieldApp = "";
            String dateFieldApp = "";
            String oidFieldRepApp = "";
            Date now = new Date();
            String dateNow = Formater.formatDate(now, "yyyy-MM-dd");
            switch(fieldApp){
                case 1: 
                    oidFieldApp = "approval_1";
                    dateFieldApp = "approval_1_date";
                    oidFieldRepApp = "rep_approval_1";
                    break;
                case 2: 
                    oidFieldApp = "approval_2";
                    dateFieldApp = "approval_2_date";
                    oidFieldRepApp = "rep_approval_2";
                    break;
                case 3: 
                    oidFieldApp = "approval_3";
                    dateFieldApp = "approval_3_date";
                    oidFieldRepApp = "rep_approval_3";
                    break;
                case 4: 
                    oidFieldApp = "approval_4";
                    dateFieldApp = "approval_4_date";
                    oidFieldRepApp = "rep_approval_4";
                    break;
                case 5: 
                    oidFieldApp = "approval_5";
                    dateFieldApp = "approval_5_date";
                    oidFieldRepApp = "rep_approval_5";
                    break;
                case 6: 
                    oidFieldApp = "approval_6";
                    dateFieldApp = "approval_6_date";
                    oidFieldRepApp = "rep_approval_6";
                    break;
                case 7:
                    oidFieldApp = "hr_man_approval";
                    dateFieldApp = "hr_man_approve_date";
                    oidFieldRepApp = "rep_approval_1";
                    break;                
            }
            String sql = "UPDATE hr_leave_application SET "+oidFieldApp+"="+employeeId+", "+dateFieldApp+"='"+dateNow+"', "+oidFieldRepApp+"="+repId;
            if (checkApproval != 1){
                sql += ", doc_status=2 ";
            }
            sql += " WHERE leave_application_id="+leaveId;
            DBHandler.execUpdate(sql);
        } catch(Exception e){
            System.out.println(e.toString());
        }
    }
    if (iCommand == Command.CONFIRM){
        try {
            String sql = " UPDATE hr_leave_application SET";
            sql += " doc_status="+PstLeaveApplication.FLD_STATUS_APPLICATION_DECLINED;
            sql += " WHERE leave_application_id="+leaveId;
            DBHandler.execUpdate(sql);
            MessageEmp messageEmp = new MessageEmp();
            messageEmp.setEmployeeId(employeeId);
            messageEmp.setMessage(message);
            messageEmp.setLeaveId(leaveId);
            Date dateNow = new Date();
            messageEmp.setMessageDate(dateNow);
            PstMessageEmp.insertExc(messageEmp);
        } catch(Exception e){
            System.out.println(e.toString());
        }
    }
    /* get data leave application status to be approve */
    String whereClause = PstLeaveApplication.getLeaveFilter(emplx.getOID(), emplx.getDivisionId());
    if (whereClause.length()>0){
        whereClause = "hr_leave_application.LEAVE_APPLICATION_ID IN(" + whereClause.substring(0, whereClause.length()-1) + ")";
        if (lvCategory == PstLeaveApplication.FLD_TYPE_LEAVE_CATEGORY_SPECIAL){
            if (oidSchedule != 0){
                whereClause += " AND " +PstSpecialUnpaidLeaveTaken.TBL_SPECIAL_UNPAID_LEAVE_TAKEN+"."+PstSpecialUnpaidLeaveTaken.fieldNames[PstSpecialUnpaidLeaveTaken.FLD_SCHEDULED_ID]+"="+oidSchedule;
            }
        } else {
            whereClause += " AND " +PstLeaveApplication.TBL_LEAVE_APPLICATION+"."+PstLeaveApplication.fieldNames[PstLeaveApplication.FLD_TYPE_LEAVE_CATEGORY]+"="+lvCategory;
        }
        leaveAppList = PstLeaveApplication.listLeaveAppEmp(whereClause);
    }
    
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Leave Approve</title>
        <link rel="stylesheet" href="../../styles/main.css" type="text/css">
        <style type="text/css">
            .tblStyle {border-collapse: collapse; font-size: 12px; }
            .tblStyle td {padding: 5px 7px; border: 1px solid #CCC; font-size: 12px;}
            .title_tbl {font-weight: bold;background-color: #EEE; color: #575757;}
            .title_page {color:#0db2e1; font-weight: bold; font-size: 14px; background-color: #EEE; border-left: 1px solid #0099FF; padding: 12px 18px;}

            .tblStyleNoBorder {font-size: 12px; }
            .tblStyleNoBorder td {padding: 5px 7px; font-size: 12px; }
            
            body {color:#373737;}
            #menu_utama {padding: 9px 14px; border-left: 1px solid #0099FF; font-size: 14px; background-color: #F3F3F3;}
            #menu_title {color:#0099FF; font-size: 14px;}
            #menu_teks {color:#CCC;}

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

            .content {
                padding: 21px;
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
            
            .btn-green {
                background-color: #b0f991;
                border-radius: 3px;
                font-family: Arial;
                color: #EEE;
                font-size: 11px;
                padding: 3px 5px;
                text-decoration: none;
            }

            .btn-green:hover {
                color: #FFF;
                background-color: #83ef53;
                text-decoration: none;
            }
            
            .btn-red {
                background-color: #ff9999;
                border-radius: 3px;
                font-family: Arial;
                color: #EEE;
                font-size: 11px;
                padding: 3px 5px;
                text-decoration: none;
            }

            .btn-red:hover {
                color: #FFF;
                background-color: #ff6666;
                text-decoration: none;
            }
            
            .btn-grey {
                background-color: #C5C5C5;
                border-radius: 3px;
                font-family: Arial;
                color: #EEE;
                font-size: 11px;
                padding: 3px 5px;
                text-decoration: none;
            }

            .btn-grey:hover {
                color: #FFF;
                background-color: #B7B7B7;
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
            h2 {
                padding: 0px 0px 21px 0px;
                margin: 0px 0px 21px 0px;
                border-bottom: 1px solid #DDD;
            }
            .box {
                border: 1px solid #DDD;
                background-color: #f5f5f5;
                margin: 5px 0px;
            }
            #box-title {
                font-size: 14px;
                font-weight: bold;
                color: #007fba;
                padding-bottom: 15px;
            }
            #box-content {
                color: #575757;
                padding: 14px 19px;
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
            .item {
                background-color: #FFF;
                padding: 9px;
                margin: 9px 15px;
            }
            .box-message {
                background-color: #FFF;
                border: 1px solid #DDD;
                border-radius: 5px;
                padding: 21px;
                margin-bottom: 12px;
            }
        </style>
        <script type="text/javascript">
            function cmdApprove(empApproved, oidLeaveApp, fieldApproval, checkApp, replacementId){
                document.frm.command.value="<%= Command.APPROVE %>";
                document.frm.employee_id.value=empApproved;
                document.frm.employee_rep.value=replacementId;
                document.frm.leave_id.value=oidLeaveApp;
                document.frm.field_approval.value=fieldApproval;
                document.frm.check_approval.value=checkApp;
                document.frm.action="cuti_approval.jsp";
                document.frm.submit();
            }
            function cmdViewApproval(leaveId){
                newWindow=window.open("view_approval.jsp?leave_id="+leaveId,"ViewApproval", "height=400, width=500, status=yes, toolbar=no, menubar=no, location=center, scrollbars=yes");
                newWindow.focus();
            }
            function cmdDecline(empId, oidLeaveApp){
                document.frm.command.value="<%= Command.CANCEL %>";
                document.frm.employee_id.value=empId;
                document.frm.leave_id.value=oidLeaveApp;
                document.frm.action="cuti_approval.jsp";
                document.frm.submit();
            }
            function cmdSend(empId, oidLeaveApp){
                document.frm.command.value="<%= Command.CONFIRM %>";
                document.frm.employee_id.value=empId;
                document.frm.leave_id.value=oidLeaveApp;
                document.frm.action="cuti_approval.jsp";
                document.frm.submit();
            }
            function cmdBatal(){
                document.frm.command.value="<%= Command.NONE %>";
                document.frm.action="cuti_approval.jsp";
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
            <span id="menu_title">Approve Cuti</span>
        </div>
        <div class="content-main">
            <form name="frm" method="post" action="">
                <!-- input pendukung -->
                <input type="hidden" name="command" value="">
                <input type="hidden" name="employee_id" value="">
                <input type="hidden" name="employee_rep" value="">
                <input type="hidden" name="leave_id" value="">
                <input type="hidden" name="field_approval" value="">
                <input type="hidden" name="check_approval" value="">
                <input type="hidden" name="leaveCategory" value="<%=lvCategory%>">
                <input type="hidden" name="schSymbol" value="<%=oidSchedule%>">
                <% if (iCommand == Command.CANCEL){ %>
                <div class="box-message">
                    <div style="border-bottom: 1px solid #CCC; padding: 0px 0px 21px 0px; margin-bottom: 21px;">Form kirim pesan</div>
                    <textarea name="message" cols="50" rows="7" placeholder="kirim pesan pembatalan..."></textarea>
                    <div>&nbsp;</div>
                    <a href="javascript:cmdSend('<%= employeeId %>','<%= leaveId %>')" class="btn" style="color:#FFF">Send</a>
                    <a href="javascript:cmdBatal()" class="btn" style="color:#FFF">Cancel</a>
                    <div>&nbsp;</div>
                </div>
                <% }
                    if (leaveAppList != null && leaveAppList.size()>0){
                %>
                <table class="tblStyle">
                    
                    <tr>
                        <!--<td class="title_tbl">&nbsp;</td>-->
                        <td class="title_tbl">No</td>
                        <td class="title_tbl">NRK</td>
                        <td class="title_tbl">Nama</td>
                        <td class="title_tbl">Tgl Pengajuan</td>
                        <td class="title_tbl">Tgl Cuti</td>
                        <td class="title_tbl">Tgl Berakhir</td>
                        <td class="title_tbl">Qty</td>
                        <td class="title_tbl">Jenis Cuti</td>
                        <td class="title_tbl">Alasan</td>
                        <td class="title_tbl">Action</td>
                    </tr>
                    <%
                            long scheduleSymbol = 0;
                            Employee emp = new Employee();
                            int maxApproval = 0;
                            boolean needHrApproval = false;
                            String [] oidLevelDontNeedHrApproval = PstSystemProperty.getValueByNameWithStringNull("OID_LEVEL_DIDNT_NEED_SDM").split(",");
                            for (int i=0; i<leaveAppList.size(); i++){
                                String[] data = (String[])leaveAppList.get(i);
                                String startCuti = "";
                                String endCuti = "";
                                int qtyCuti = 0;
                                String where = PstAlStockTaken.fieldNames[PstAlStockTaken.FLD_LEAVE_APPLICATION_ID]+"="+data[0];
                                Vector listALStockTaken = PstAlStockTaken.list(0, 0, where, "");
                                if (listALStockTaken != null && listALStockTaken.size()>0){
                                    AlStockTaken alStockTaken = (AlStockTaken)listALStockTaken.get(0);
                                    startCuti = sdf.format(alStockTaken.getTakenDate());
                                    endCuti = sdf.format(alStockTaken.getTakenFinnishDate());
                                    qtyCuti = convertInteger(alStockTaken.getTakenQty());
                                } else {
                                    where = PstLlStockTaken.fieldNames[PstLlStockTaken.FLD_LEAVE_APPLICATION_ID]+"="+data[0];
                                    Vector listLlStockTaken = PstLlStockTaken.list(0, 0, where, "");
                                    if (listLlStockTaken != null && listLlStockTaken.size()>0){
                                        LlStockTaken llStockTaken = (LlStockTaken)listLlStockTaken.get(0);
                                        startCuti = sdf.format(llStockTaken.getTakenDate());
                                        endCuti = sdf.format(llStockTaken.getTakenFinnishDate());
                                        qtyCuti = convertInteger(llStockTaken.getTakenQty());
                                    } else {
                                        where = PstSpecialUnpaidLeaveTaken.fieldNames[PstSpecialUnpaidLeaveTaken.FLD_LEAVE_APLICATION_ID]+"="+data[0];
                                        Vector listSlStockTaken = PstSpecialUnpaidLeaveTaken.list(0, 0, where, "");
                                        if (listSlStockTaken != null && listSlStockTaken.size()>0){
                                            SpecialUnpaidLeaveTaken slStockTaken = (SpecialUnpaidLeaveTaken)listSlStockTaken.get(0);
                                            scheduleSymbol = slStockTaken.getScheduledId();
                                            startCuti = sdf.format(slStockTaken.getTakenDate());
                                            endCuti = sdf.format(slStockTaken.getTakenFinnishDate());
                                            qtyCuti = convertInteger(slStockTaken.getTakenQty());
                                        }
                                    }
                                }
                                
                                try{
                                    emp = PstEmployee.fetchExc(Long.valueOf(data[6]));
                                } catch (Exception exc){

                                }

                                needHrApproval = PstLeaveApplication.checkNeedHrApproval(emp.getDivisionId());

                                Position pos = new Position();
                                Level level = new Level();
                                Level maxLevelObj = new Level();
                                //Level level = new Level();
                                try {
                                     pos = PstPosition.fetchExc(emp.getPositionId());
                                 } catch (Exception e) {
                                 }
                                
                                 try {
                                     level = PstLevel.fetchExc(pos.getLevelId());
                                 } catch (Exception e) {
                                 }


                                 try {
                                     maxLevelObj = PstLevel.fetchExc(level.getMaxLevelApproval());
                                 } catch (Exception e) {
                                 }

                                 maxApproval = maxLevelObj.getLevelPoint();
                                
                                 for (int x=0; x < oidLevelDontNeedHrApproval.length; x++){
                                    if(oidLevelDontNeedHrApproval[x].equals(""+level.getOID())){
                                        needHrApproval = false;
                                    }
                                }
                                
                                long oidEmp = 0;
                                if (data[7].equals("0")
                                & data[8].equals("0")
                                & data[9].equals("0")
                                & data[10].equals("0")
                                & data[11].equals("0")
                                & data[12].equals("0")){
                                    oidEmp = Long.valueOf(data[6]);
                                }
                                if (!data[7].equals("0")
                                & data[8].equals("0")
                                & data[9].equals("0")
                                & data[10].equals("0")
                                & data[11].equals("0")
                                & data[12].equals("0")){
                                    oidEmp = Long.valueOf(data[7]);
                                }
                                if (!data[7].equals("0")
                                & !data[8].equals("0")
                                & data[9].equals("0")
                                & data[10].equals("0")
                                & data[11].equals("0")
                                & data[12].equals("0")){
                                    oidEmp = Long.valueOf(data[8]);
                                }
                                if (!data[7].equals("0")
                                & !data[8].equals("0")
                                & !data[9].equals("0")
                                & data[10].equals("0")
                                & data[11].equals("0")
                                & data[12].equals("0")){
                                    oidEmp = Long.valueOf(data[9]);
                                }
                                if (!data[7].equals("0")
                                & !data[8].equals("0")
                                & !data[9].equals("0")
                                & !data[10].equals("0")
                                & data[11].equals("0")
                                & data[12].equals("0")){
                                    oidEmp = Long.valueOf(data[10]);
                                }
                                if (!data[7].equals("0")
                                & !data[8].equals("0")
                                & !data[9].equals("0")
                                & !data[10].equals("0")
                                & !data[11].equals("0")
                                & data[12].equals("0")){
                                    oidEmp = Long.valueOf(data[11]);
                                }
                                %>
                                <tr>
                                    <!--<td style="background-color: #FFF;"><input type="checkbox" name="chx" value="" /></td>-->
                                    <td style="background-color: #FFF;"><%= (i+1) %></td>
                                    <td style="background-color: #FFF;"><%= data[3] %></td>
                                    <td style="background-color: #FFF;"><%= data[4] %></td>
                                    <td style="background-color: #FFF;"><%= data[5] %></td>
                                    <td style="background-color: #FFF;"><%= startCuti %></td>
                                    <td style="background-color: #FFF;"><%= endCuti %></td>
                                    <td style="background-color: #FFF;"><%= qtyCuti %></td>
                                    <%
                                    if (Integer.valueOf(data[1]) != 0){
                                    %>
                                    <td style="background-color: #FFF;"><%= leaveType[Integer.valueOf(data[1])]  %></td>
                                    <%
                                        } else {
                                            ScheduleSymbol symbol = new ScheduleSymbol();
                                            try {
                                                symbol = PstScheduleSymbol.fetchExc(scheduleSymbol);
                                            } catch (Exception exc){

                                            }
                                    %>
                                    <td style="background-color: #FFF;"><%= symbol.getSchedule() %></td>
                                    <%
                                        }
                                    %>
                                    <td style="background-color: #FFF;"><%= data[2] %></td>
                                    <td style="background-color: #FFF;">
                                        <%= getApproval(oidEmp, 0, Long.valueOf(data[0]), emplx.getOID(), maxApproval, needHrApproval, emp.getDivisionId()) %>
                                        <a class="btn-red" style="color:#FFF" href="javascript:cmdDecline('<%= oidEmp %>','<%= Long.valueOf(data[0]) %>')">Decline</a>
                                    </td>
                                </tr>
                                <%
                            }
                        
                    %>
                </table>
                    <%
                        } else {
                    %>
                    <h5><strong>No Data Available</strong></h5>
                    <%
                        }
                    %>
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
    </body>
</html>
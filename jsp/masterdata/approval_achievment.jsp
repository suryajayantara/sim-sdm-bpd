<%-- 
    Document   : cuti_approval
    Created on : Feb 21, 2017, 2:14:35 PM
    Author     : mchen
--%>
<%@page import="com.dimata.harisma.entity.masterdata.PstPositionDivision"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstKpiTarget"%>
<%@page import="com.dimata.util.Command"%>
<%@page import="com.dimata.qdep.form.FRMQueryString"%>
<%@page import="com.dimata.harisma.entity.employee.Employee"%>
<%@page import="com.dimata.system.entity.system.PstSystemProperty"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstLevel"%>
<%@page import="com.dimata.harisma.entity.masterdata.Level"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstPosition"%>
<%@page import="com.dimata.harisma.entity.masterdata.Position"%>
<%@page import="java.util.Vector"%>
<%@page import="com.dimata.util.Formater"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstMappingPosition"%>
<%@page import="java.util.Date"%>
<%@page import="com.dimata.harisma.entity.employee.PstEmployee"%>
<%@page import="com.dimata.qdep.entity.I_DocStatus"%>
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
<%@ include file = "../main/javainit.jsp" %>
<%  //int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_EMPLOYEE, AppObjInfo.G2_LEAVE_APPLICATION, AppObjInfo.OBJ_LEAVE_APPLICATION);%>
<%//@ include file = "../../main/checkuser.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%!
    public long divisionId = 0;
    
    public int convertInteger(double val){
        BigDecimal bDecimal = new BigDecimal(val);
        bDecimal = bDecimal.setScale(0, RoundingMode.HALF_UP);
        return bDecimal.intValue();
    }

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
            sql += " WHERE hr_mapping_position.TYPE_OF_LINK=13 AND ";
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
            sql += " WHERE hr_mapping_position.TYPE_OF_LINK=13 AND ";
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

    public String getApproval(long empId, int inc, long kpiAchievId, long userLoggin, int maxApproval, long divisionId){
        String str = "";
        KPI_Employee_Achiev kpiea = new KPI_Employee_Achiev();
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
            kpiea = PstKPI_Employee_Achiev.fetchExc(kpiAchievId);
            fieldApp = getFieldApproval(kpiea.getApproval1(), 
            kpiea.getApproval2(), kpiea.getApproval3(), 
            kpiea.getApproval4(), kpiea.getApproval5(), 
            kpiea.getApproval6());
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
                                str = getApproval(emp.getOID(),inc, kpiAchievId, userLoggin, maxApproval, divisionId);
                                break;
                            }
                        } 
                        int loop = inc;
                        loop++;
                        if (emp.getOID() != userLoggin){
                            //getApproval(employeeId, loop, leaveAppId, userLoggin);
                            str = "<a class=\"btn-grey\" style=\"color:#FFF\" href=\"javascript:cmdViewApproval('"+kpiAchievId+"')\">View</a>";
                        } else {
                            /* Jika employeeId == useLoggin */
                            if (kpiea.getOID() != 0){
                                if (kpiea.getApproval1() == userLoggin 
                                || kpiea.getApproval2() == userLoggin 
                                || kpiea.getApproval3() == userLoggin
                                || kpiea.getApproval4() == userLoggin
                                || kpiea.getApproval5() == userLoggin
                                || kpiea.getApproval6() == userLoggin){
                                    str = "<a class=\"btn-grey\" style=\"color:#FFF\" href=\"javascript:cmdViewApproval('"+kpiAchievId+"')\">View</a>";
                                } else if(oidEmpReal != 0 && oidEmpReal != emp.getOID()) {
                                        int check = checkNextApproval(oidEmpReal, maxApproval, divisionId, kpiAchievId);
                                        str = "<a class=\"btn-green\" style=\"color:#38a109\" href=\"javascript:cmdApprove('"+oidEmpReal+"','"+kpiAchievId+"','"+fieldApp+"','"+check+"','"+userLoggin+"')\">Approve</a>";
                                        break;    
                                } else {
                                        int check = checkNextApproval(userLoggin, maxApproval, divisionId, kpiAchievId);
                                        str = "<a class=\"btn-green\" style=\"color:#38a109\" href=\"javascript:cmdApprove('"+userLoggin+"','"+kpiAchievId+"','"+fieldApp+"','"+check+"','0')\">Approve</a>";
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
                                    str = getApproval(emp.getOID(),inc, kpiAchievId, userLoggin, maxApproval, divisionId);
                                    break;
                                }
                            } 
                            if (emp.getOID() == userLoggin){
                                    str = "<a class=\"btn-green\" style=\"color:#38a109\" href=\"javascript:cmdApprove('"+userLoggin+"','"+kpiAchievId+"','"+fieldApp+"','2','0')\">Approve</a>";
                                    break;
                            } else {
                                str = "<a class=\"btn-grey\" style=\"color:#FFF\" href=\"javascript:cmdViewApproval('"+kpiAchievId+"')\">View</a>";
                            }
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

    public int checkNextApproval(long empId, int maxApproval,long divisionId, long leaveAppId){
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
            } else {
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
    Vector kpiAchievList = new Vector();
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    int iCommand = FRMQueryString.requestCommand(request);
    long employeeId = FRMQueryString.requestLong(request, "employee_id");
    long achievId = FRMQueryString.requestLong(request, "achiev_id");
    long repId = FRMQueryString.requestLong(request, "employee_rep");
    int fieldApp = FRMQueryString.requestInt(request, "field_approval");
    int checkApproval = FRMQueryString.requestInt(request, "check_approval");
    String message = FRMQueryString.requestString(request, "message");

    if (iCommand == Command.APPROVE){
        try {
            String oidFieldApp = "";
            String dateFieldApp = "";
            String oidFieldRepApp = "";
            Date now = new Date();
            String dateNow = sdf.format(now);
            switch(fieldApp){
                case 1: 
                    oidFieldApp = "approval_1";
                    dateFieldApp = "approval_date_1";
                    oidFieldRepApp = "rep_approval_1";
                    break;
                case 2: 
                    oidFieldApp = "approval_2";
                    dateFieldApp = "approval_date_2";
                    oidFieldRepApp = "rep_approval_2";
                    break;
                case 3: 
                    oidFieldApp = "approval_3";
                    dateFieldApp = "approval_date_3";
                    oidFieldRepApp = "rep_approval_3";
                    break;
                case 4: 
                    oidFieldApp = "approval_4";
                    dateFieldApp = "approval_date_4";
                    oidFieldRepApp = "rep_approval_4";
                    break;
                case 5: 
                    oidFieldApp = "approval_5";
                    dateFieldApp = "approval_date_5";
                    oidFieldRepApp = "rep_approval_5";
                    break;
                case 6: 
                    oidFieldApp = "approval_6";
                    dateFieldApp = "approval_date_6";
                    oidFieldRepApp = "rep_approval_6";
                    break;               
            }
            String sql = "UPDATE hr_kpi_employee_achiev SET "+oidFieldApp+"="+employeeId+", "+dateFieldApp+"='"+dateNow+"'";
            if (checkApproval != 1){
                sql += ", status=2 ";
            }
            sql += " WHERE KPI_EMPLOYEE_ACHIEV_ID="+achievId;
            DBHandler.execUpdate(sql);
        } catch(Exception e){
            System.out.println(e.toString());
        }
    }
    /* get data leave application status to be approve */
    String whereClause = PstKPI_Employee_Achiev.getKPIFilter(emplx.getOID(), emplx.getDivisionId());
    if (whereClause.length()>0){
        whereClause = "hr_kpi_employee_achiev.KPI_EMPLOYEE_ACHIEV_ID IN(" + whereClause.substring(0, whereClause.length()-1) + ")";
        kpiAchievList = PstKPI_Employee_Achiev.listKpi(whereClause);
    }
    
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>KPI Achievment Approve</title>
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
                document.frm.achiev_id.value=oidLeaveApp;
                document.frm.field_approval.value=fieldApproval;
                document.frm.check_approval.value=checkApp;
                document.frm.action="approval_achievment.jsp";
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
            <%@include file="../styletemplate/template_header.jsp" %>
            <%} else {%>
            <tr> 
                <td ID="TOPTITLE" background="<%=approot%>/images/HRIS_HeaderBg3.jpg" width="100%" height="54"> 
                    <!-- #BeginEditable "header" --> 
                    <%@ include file = "../main/header.jsp" %>
                    <!-- #EndEditable --> 
                </td>
            </tr>
            <tr> 
                <td  bgcolor="#9BC1FF" height="15" ID="MAINMENU" valign="middle"> <!-- #BeginEditable "menumain" --> 
                    <%@ include file = "../main/mnmain.jsp" %>
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
            <span id="menu_title">Approve Achievment</span>
        </div>
        <div class="content-main">
            <form name="frm" method="post" action="">
                <!-- input pendukung -->
                <input type="hidden" name="command" value="">
                <input type="hidden" name="employee_id" value="">
                <input type="hidden" name="employee_rep" value="">
                <input type="hidden" name="achiev_id" value="">
                <input type="hidden" name="field_approval" value="">
                <input type="hidden" name="check_approval" value="">
                
                <% 
                    if (kpiAchievList != null && kpiAchievList.size()>0){
                %>
                <table class="tblStyle">
                    
                    <tr>
                        <!--<td class="title_tbl">&nbsp;</td>-->
                        <td class="title_tbl">No</td>
                        <td class="title_tbl">NRK</td>
                        <td class="title_tbl">Nama</td>
                        <td class="title_tbl">Tgl Buat</td>
                        <td class="title_tbl">KPI</td>
						<td class="title_tbl">Achievment</td>
                        <td class="title_tbl">Action</td>
                    </tr>
                    <%
                            long scheduleSymbol = 0;
                            Employee emp = new Employee();
                            int maxApproval = 0;
                            for (int i=0; i<kpiAchievList.size(); i++){
                                String[] data = (String[])kpiAchievList.get(i);
                                String where = PstKPI_Employee_Achiev.fieldNames[PstKPI_Employee_Achiev.FLD_KPI_EMPLOYEE_ACHIEV_ID]+"="+data[0];
                                
                                try{
                                    emp = PstEmployee.fetchExc(Long.valueOf(data[3]));
                                } catch (Exception exc){

                                }

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
								 
								KPI_List kPI_List = new KPI_List();
								try {
									kPI_List = PstKPI_List.fetchExc(Long.valueOf(data[14]));
								} catch (Exception exc){}

                                 maxApproval = maxLevelObj.getLevelPoint();
                                
                                
                                long oidEmp = 0;
								if (data[4].equals("0")
								& data[5].equals("0")
								& data[6].equals("0")
								& data[7].equals("0")
								& data[8].equals("0")
								& data[9].equals("0")){
									oidEmp = Long.valueOf(data[3]);
								}
								if (!data[4].equals("0")
								& data[5].equals("0")
								& data[6].equals("0")
								& data[7].equals("0")
								& data[8].equals("0")
								& data[9].equals("0")){
									oidEmp = Long.valueOf(data[4]);
								}
								if (!data[4].equals("0")
								& !data[5].equals("0")
								& data[6].equals("0")
								& data[7].equals("0")
								& data[8].equals("0")
								& data[9].equals("0")){
									oidEmp = Long.valueOf(data[5]);
								}
								if (!data[4].equals("0")
								& !data[5].equals("0")
								& !data[6].equals("0")
								& data[7].equals("0")
								& data[8].equals("0")
								& data[9].equals("0")){
									oidEmp = Long.valueOf(data[6]);
								}
								if (!data[4].equals("0")
								& !data[5].equals("0")
								& !data[6].equals("0")
								& !data[7].equals("0")
								& data[8].equals("0")
								& data[9].equals("0")){
									oidEmp = Long.valueOf(data[7]);
								}
								if (!data[4].equals("0")
								& !data[5].equals("0")
								& !data[6].equals("0")
								& !data[7].equals("0")
								& !data[8].equals("0")
								& data[9].equals("0")){
									oidEmp = Long.valueOf(data[8]);
								}
                                %>
                                <tr>
                                    <!--<td style="background-color: #FFF;"><input type="checkbox" name="chx" value="" /></td>-->
                                    <td style="background-color: #FFF;"><%= (i+1) %></td>
                                    <td style="background-color: #FFF;"><%= data[10] %></td>
                                    <td style="background-color: #FFF;"><%= data[1] %></td>
                                    <td style="background-color: #FFF;"><%= data[2] %></td>
									<td style="background-color: #FFF;"><%= kPI_List.getKpi_title() %></td>
									<td style="background-color: #FFF;"><%= (kPI_List.getInputType() == PstKPI_List.TYPE_WAKTU ? data[12] : data[11]) %></td>
                                    <td style="background-color: #FFF;">
                                        <%= getApproval(oidEmp, 0, Long.valueOf(data[0]), emplx.getOID(), maxApproval, emp.getDivisionId()) %>
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
                    <td valign="bottom"><%@include file="../footer.jsp" %></td>
                </tr>
                <%} else {%>
                <tr> 
                    <td colspan="2" height="20" ><%@ include file = "../main/footer.jsp" %></td>
                </tr>
                <%}%>
            </table>
        </div>
    </body>
</html>
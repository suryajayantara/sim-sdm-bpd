<%-- 
    Document   : view_approval
    Created on : Feb 16, 2017, 11:54:47 PM
    Author     : mchen
--%>

<%@page import="com.dimata.util.Formater"%>
<%@page import="com.dimata.harisma.entity.leave.I_Leave"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="com.dimata.qdep.db.DBHandler"%>
<%@page import="com.dimata.qdep.db.DBResultSet"%>
<%@page import="com.dimata.harisma.entity.leave.PstLeaveApplication"%>
<%@page import="com.dimata.harisma.entity.leave.LeaveApplication"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file = "../main/javainit.jsp" %>
<%  int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_EMPLOYEE, AppObjInfo.G2_LEAVE_APPLICATION, AppObjInfo.OBJ_LEAVE_APPLICATION);%>
<%@ include file = "../main/checkuser.jsp" %>
<!DOCTYPE html>
<%!
    public long divisionId = 0;
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
                    + " BETWEEN START_DATE AND END_DATE "
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


    public String getApproval(long empId, int maxApproval, long divisionId){
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
                                str = str + " / " + getApproval(emp.getOID(),maxApproval, divisionId);
                            }
                        } else {
                            str = str + " / " + getEmployeeName(emp.getOID());
                        }
                    }
                    str = str.substring(2);
                }
            }
        }

        return str;
    }

    public String getHrApproval(long leaveId){
        String str = "";
        
        I_Leave leaveConfig = null;

        try {
            leaveConfig = (I_Leave) (Class.forName(PstSystemProperty.getValueByName("LEAVE_CONFIG")).newInstance());
        } catch (Exception e) {
            System.out.println("Exception : " + e.getMessage());
        }
        
        LeaveApplication leaveApp = new LeaveApplication();
        try{
            leaveApp = PstLeaveApplication.fetchExc(leaveId);
        } catch (Exception exc){
            
        }
        
        Vector listHRMan = leaveConfig.listSDMApproval(leaveApp.getEmployeeId());
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
%>
<%
    long kpiAchievId = FRMQueryString.requestLong(request, "achiev_id");
    KPI_Employee_Achiev kpiAchiev = new KPI_Employee_Achiev();
    
    
    long empId = 0;
    long approval1 = 0;
    long approval2 = 0;
    long approval3 = 0;
    long approval4 = 0;
    long approval5 = 0;
    long approval6 = 0;
    long hrApproval = 0;
    long repApproval1 = 0;
    long repApproval2 = 0;
    long repApproval3 = 0;
    long repApproval4 = 0;
    long repApproval5 = 0;
    long repApproval6 = 0;
    Employee emp = new Employee();
    try {
        kpiAchiev = PstKPI_Employee_Achiev.fetchExc(kpiAchievId);
        empId = kpiAchiev.getEmployeeId();
        approval1 = kpiAchiev.getApproval1();
        approval2 = kpiAchiev.getApproval2();
        approval3 = kpiAchiev.getApproval3();
        approval4 = kpiAchiev.getApproval4();
        approval5 = kpiAchiev.getApproval5();
        approval6 = kpiAchiev.getApproval6();
        emp = PstEmployee.fetchExc(empId);
    } catch(Exception e){
        System.out.println(e.toString());
    }
    
    Position pos = new Position();
    Level level = new Level();
    Level maxLevelObj = new Level();
    int maxLevel = 0;
    if (empId != 0){
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
    
    //check last approval
    int lastApproval = 0;
    if (approval6 != 0){
        lastApproval = 6;
    } else if (approval5 != 0){
        lastApproval = 5;
    } else if (approval4 != 0){
        lastApproval = 4;
    } else if (approval3 != 0){
        lastApproval = 3;
    } else if (approval2 != 0){
        lastApproval = 2;
    } else if (approval1 != 0){
        lastApproval = 1;
    }
    
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>View Next Approval</title>
        <style type="text/css">
            body {
                font-family: sans-serif;
                color: #575757;
            }
        </style>
    </head>
    <body>
        <h1>View Next Approval!</h1>
<%
    if (approval1 != 0){
        if (lastApproval == 1 && kpiAchiev.getStatus()== 5){
            %>
            <%= getEmployeeName(approval1)+" : Waiting Cancel Approve<br>" %>
            <%
        } else {
            if (repApproval1 != 0){
                %>
                <%= getEmployeeName(repApproval1)+" : Approved<br>" %>
                <%    
            } else {
                %>
                <%= getEmployeeName(approval1)+" : Approved<br>" %>
                <%
            }
        }
        if (approval2 != 0){
            if (lastApproval == 2 && kpiAchiev.getStatus() == 5){
                %>
                <%= getEmployeeName(approval2)+" : Waiting Cancel Approve<br>" %>
                <%
            } else {
                if (repApproval2 != 0){
                    %>
                    <%= getEmployeeName(repApproval2)+" : Approved<br>" %>
                    <%    
                } else {
                    %>
                    <%= getEmployeeName(approval2)+" : Approved<br>" %>
                    <%
                }
            }
            if (approval3 != 0){
                if (lastApproval == 3 && kpiAchiev.getStatus() == 5){
                    %>
                    <%= getEmployeeName(approval3)+" : Waiting Cancel Approve<br>" %>
                    <%
                } else {
                    if (repApproval3 != 0){
                        %>
                        <%= getEmployeeName(repApproval3)+" : Approved<br>" %>
                        <%    
                    } else {
                        %>
                        <%= getEmployeeName(approval3)+" : Approved<br>" %>
                        <%
                    }
                }
                if (approval4 != 0){
                    if (lastApproval == 4 && kpiAchiev.getStatus() == 5){
                        %>
                        <%= getEmployeeName(approval4)+" : Waiting Cancel Approve<br>" %>
                        <%
                    } else {
                        if (repApproval4 != 0){
                            %>
                            <%= getEmployeeName(repApproval4)+" : Approved<br>" %>
                            <%    
                        } else {
                            %>
                            <%= getEmployeeName(approval4)+" : Approved<br>" %>
                            <%
                        }
                    }
                    if (approval5 != 0){
                        if (lastApproval == 5 && kpiAchiev.getStatus() == 5){
                            %>
                            <%= getEmployeeName(approval5)+" : Waiting Cancel Approve<br>" %>
                            <%
                        } else {
                            if (repApproval5 != 0){
                                %>
                                <%= getEmployeeName(repApproval5)+" : Approved<br>" %>
                                <%    
                            } else {
                                %>
                                <%= getEmployeeName(approval5)+" : Approved<br>" %>
                                <%
                            }
                        }
                        if (approval6 != 0){
                            if (lastApproval == 6 && kpiAchiev.getStatus() == 5){
                                %>
                                <%= getEmployeeName(approval6)+" : Waiting Cancel Approve<br>" %>
                                <%
                            } else {
                                if (repApproval6 != 0){
                                    %>
                                    <%= getEmployeeName(repApproval6)+" : Approved<br>" %>
                                    <%    
                                } else {
                                    %>
                                    <%= getEmployeeName(approval6)+" : Approved<br>" %>
                                    <%
                                }
                            }
                        } else if (kpiAchiev.getStatus() == 0 || kpiAchiev.getStatus() == 1) {
                            %>
                            <%= getApproval(approval5,maxLevel, emp.getDivisionId())+" : Next<br>" %>
                            <%
                        }
                    } else if (kpiAchiev.getStatus() == 0 || kpiAchiev.getStatus() == 1) {
                        %>
                        <%= getApproval(approval4,maxLevel, emp.getDivisionId())+" : Next<br>" %>
                        <%
                    }
                } else if (kpiAchiev.getStatus() == 0 || kpiAchiev.getStatus() == 1) {
                    %>
                    <%= getApproval(approval3,maxLevel,emp.getDivisionId())+" : Next<br>" %>
                    <%
                }
            } else if (kpiAchiev.getStatus() == 0 || kpiAchiev.getStatus() == 1) {
                %>
                <%= getApproval(approval2,maxLevel, emp.getDivisionId())+" : Next<br>" %>
                <%
            }
        } else if (kpiAchiev.getStatus() == 0 || kpiAchiev.getStatus() == 1) {
            %>
            <%= getApproval(approval1,maxLevel,emp.getDivisionId())+" : Next<br>" %>
            <%
        }
    } else if (kpiAchiev.getStatus() == 0 || kpiAchiev.getStatus() == 1) {
        %>
        <%= getApproval(empId,maxLevel,emp.getDivisionId())+" : Next<br>" %>
        <%
    }
%>
    </body>
</html>

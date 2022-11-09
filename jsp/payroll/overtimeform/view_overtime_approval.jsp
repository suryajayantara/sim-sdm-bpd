<%-- 
    Document   : view_overtime_approval
    Created on : Jul 27, 2019, 9:43:01 AM
    Author     : Dimata 007
--%>

<%@page import="com.dimata.qdep.entity.I_DocStatus"%>
<%@page import="com.dimata.harisma.entity.leave.I_Leave"%>
<%@page import="com.dimata.harisma.entity.overtime.OvertimeDetail"%>
<%@page import="com.dimata.harisma.entity.overtime.PstOvertimeDetail"%>
<%@page import="com.dimata.harisma.entity.overtime.PstOvertime"%>
<%@page import="com.dimata.harisma.entity.overtime.Overtime"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file = "../../main/javainit.jsp" %>
<%  int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_EMPLOYEE, AppObjInfo.G2_LEAVE_APPLICATION, AppObjInfo.OBJ_LEAVE_APPLICATION);%>
<%@ include file = "../../main/checkuser.jsp" %>

<%!//
    long hr_department = 0;
    int finalApprovalMinLevel = PstPosition.LEVEL_DIRECTOR;
    int finalApprovalMaxLevel = PstPosition.LEVEL_GENERAL_MANAGER;

    public void init() {
        try {
            hr_department = Long.parseLong(PstSystemProperty.getValueByName("OID_HRD_DEPARTMENT"));
        } catch (Exception e) {
            System.out.println("Exception : " + e.getMessage());
        }
    }

    I_Leave leaveConfig = null;

    public void jspInit() {
        try {
            leaveConfig = (I_Leave) (Class.forName(PstSystemProperty.getValueByName("LEAVE_CONFIG")).newInstance());
        } catch (Exception e) {
            System.out.println("Exception : " + e.getMessage());
        }
    }
    String valHideInfo = PstSystemProperty.getValueByName("HIDE_INFORMATION_OVERTIME_FORM");

%>

<%//
    long overtimeId = FRMQueryString.requestLong(request, "overtime_id");

    Overtime overtime = new Overtime();
    if (overtimeId != 0) {
        try {
            overtime = PstOvertime.fetchExc(overtimeId);
        } catch (Exception e) {
            System.out.println("Exception : " + e.getMessage());
        }
    }
    int maxApproval = PstOvertime.getMaxApp(overtime.getRequestId(), leaveConfig, overtime);
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <style type="text/css">
            body {
                font-family: sans-serif;
                color: #575757;
            }
            p {margin: 15px 0px 5px}
            div {margin-bottom: 5px;}
        </style>
    </head>
    <body>
        <h2>View Next Approval!</h2>
        <p>Overtime number : <%= overtime.getOvertimeNum() %></p>
        <%//
            if (overtime.getRequestId() == 0) {
                out.println("<p><b>Waiting for request by :</b></p>");
            } else {
                out.println("<p><b>Requested by :</b></p>");
            }
            Vector<OvertimeDetail> listMaxEmp = PstOvertimeDetail.maxLevelEmployees(overtime.getOID());
            if (listMaxEmp.size() > 0) {
                try {
                    OvertimeDetail overtimeDetail = (OvertimeDetail) listMaxEmp.get(0);

                    Employee employee = new Employee();
                    if (overtimeDetail.getEmployeeId() != 0) {
                        employee = PstEmployee.fetchExc(overtimeDetail.getEmployeeId());
                    }

                    Level level = new Level();
                    if (employee.getLevelId() != 0) {
                        level = PstLevel.fetchExc(employee.getLevelId());
                    }

                    Level maxLevelObj = new Level();
                    if (level.getMaxLevelApproval() != 0) {
                        maxLevelObj = PstLevel.fetchExc(level.getMaxLevelApproval());
                    }

                    int minLevel = level.getLevelPoint();
                    int maxLevel = maxLevelObj.getLevelPoint();

                    long oidEmpDinamis = overtimeDetail.getEmployeeId();
                    int typeApproval = 11;
                    if (overtime.getOvertimeType() == 1) {
                        typeApproval = 10;
                    }

                    int no = 1;
                    if (overtime.getRequestId() != 0) {
                        Employee e = PstEmployee.fetchExc(overtime.getRequestId());
                        out.println("<div>[" + e.getEmployeeNum() + "] " + e.getFullName() + "</div>");
                    } else {
                        for (int xx = minLevel; xx <= maxLevel; xx++) {
                            Vector listEmpApproval = leaveConfig.getApprovalEmployeeTopLinkByLevel(oidEmpDinamis, typeApproval, xx, "");
                            if (listEmpApproval.size() > 0) {
                                if (listEmpApproval != null && listEmpApproval.size() > 0) {
                                    for (int i = 0; i < listEmpApproval.size(); i++) {
                                        Employee objEmp = (Employee) listEmpApproval.get(i);
                                        out.println("<div>" + no + ". [" + objEmp.getEmployeeNum() + "] " + objEmp.getFullName() + "</div>");
                                        no++;
                                    }
                                }
                            }
                        }
                    }
                } catch (Exception e) {
                    out.println(e.getMessage());
                }
            }

            out.println("<p><b>Approved by :</b></p>");
            if ((overtime.getOID() != 0) && (overtime.getRequestId() != 0) && (maxApproval == I_Leave.LEAVE_APPROVE_1 || maxApproval == I_Leave.LEAVE_APPROVE_2 || maxApproval == I_Leave.LEAVE_APPROVE_3 || maxApproval == I_Leave.LEAVE_APPROVE_4 || maxApproval == I_Leave.LEAVE_APPROVE_5 || maxApproval == I_Leave.LEAVE_APPROVE_6)) {
                Employee employeeObj = new Employee();
                if (overtime.getRequestId() != 0) {
                    employeeObj = PstEmployee.fetchExc(overtime.getRequestId());
                }

                Level level = new Level();
                if (employeeObj.getLevelId() != 0) {
                    level = PstLevel.fetchExc(employeeObj.getLevelId());
                }

                Level maxLevelObj = new Level();
                if (level.getMaxLevelApproval() != 0) {
                    maxLevelObj = PstLevel.fetchExc(level.getMaxLevelApproval());
                }

                int minLevel = level.getLevelPoint();
                int maxLevel = maxLevelObj.getLevelPoint();
                int incIndexApp = 1;
                int typeApproval = 6;
                if (overtime.getOvertimeType() == 1) {
                    typeApproval = 9;
                }
                long oidEmpDinamis = overtime.getRequestId();
                int no = 1;
                for (int xx = minLevel; xx <= maxLevel; xx++) {
                    Vector listEmpApproval = leaveConfig.getApprovalEmployeeTopLinkByLevel(oidEmpDinamis, typeApproval, xx, "");
                    if (listEmpApproval.size() > 0) {
                        if (overtime.getOID() != 0) {
                            if ((overtime.getStatusDoc() == I_DocStatus.DOCUMENT_STATUS_TO_BE_APPROVED || overtime.getStatusDoc() == I_DocStatus.DOCUMENT_STATUS_DRAFT)) {
                                if (listEmpApproval != null && listEmpApproval.size() > 0) {
                                    for (int i = 0; i < listEmpApproval.size(); i++) {
                                        Employee objEmp = (Employee) listEmpApproval.get(i);
                                        long selectedApproval = PstOvertime.getApproveOidByApprovalIndex(overtime, incIndexApp);
                                        String approved = (selectedApproval == objEmp.getOID()) ? "Approved" : "To Be Approved";
                                        out.println("<div>" + no + ". [" + objEmp.getEmployeeNum() + "] " + objEmp.getFullName() + " <b>(" + approved + ")</b></div>");
                                        no++;
                                    }
                                }
                                
                                if (PstOvertime.getApproveOidByApprovalIndex(overtime, incIndexApp) != 0) {
                                    oidEmpDinamis = PstOvertime.getApproveOidByApprovalIndex(overtime, incIndexApp);
                                }
                                
                            } else {
                                Employee employee = new Employee();
                                try {
                                    String approved = "To Be Approved";
                                    if (incIndexApp == 1 && overtime.getApproval1Id() != 0) {
                                        employee = PstEmployee.fetchExc(overtime.getApproval1Id());
                                        approved = "Approved";
                                    }
                                    if (incIndexApp == 2 && overtime.getApproval2Id() != 0) {
                                        employee = PstEmployee.fetchExc(overtime.getApproval2Id());
                                        approved = "Approved";
                                    }
                                    if (incIndexApp == 3 && overtime.getApproval3Id() != 0) {
                                        employee = PstEmployee.fetchExc(overtime.getApproval3Id());
                                        approved = "Approved";
                                    }
                                    if (incIndexApp == 4 && overtime.getApproval4Id() != 0) {
                                        employee = PstEmployee.fetchExc(overtime.getApproval4Id());
                                        approved = "Approved";
                                    }
                                    if (incIndexApp == 5 && overtime.getApproval5Id() != 0) {
                                        employee = PstEmployee.fetchExc(overtime.getApproval5Id());
                                        approved = "Approved";
                                    }
                                    if (incIndexApp == 6 && overtime.getApproval6Id() != 0) {
                                        employee = PstEmployee.fetchExc(overtime.getApproval6Id());
                                        approved = "Approved";
                                    }
                                    
                                    out.println("<div>" + no + ". [" + employee.getEmployeeNum() + "] " + employee.getFullName() + " <b>(" + approved + ")</b></div>");
                                    if (PstOvertime.getApproveOidByApprovalIndex(overtime, incIndexApp) != 0) {
                                        oidEmpDinamis = PstOvertime.getApproveOidByApprovalIndex(overtime, incIndexApp);
                                    }
                                    no++;
                                } catch (Exception e) {
                                    out.println(e.getMessage());
                                }
                            }
                        }
                        incIndexApp++;
                    }
                }
            }
        %>
    </body>
</html>

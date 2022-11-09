/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.log;

import com.dimata.harisma.entity.admin.AppUser;
import com.dimata.harisma.entity.admin.PstAppUser;
import com.dimata.harisma.entity.employee.Employee;
import com.dimata.harisma.entity.employee.PstEmployee;
import com.dimata.system.entity.system.PstSystemProperty;

/**
 *
 * @author Dimata 007
 */
public class LogFeature {
    private int sysLog = 0;
    private Employee employee = new Employee();

    public int getSysLog() {
        return sysLog;
    }

    public void setSysLog() {
        this.sysLog = Integer.parseInt(String.valueOf(PstSystemProperty.getPropertyLongbyName("SET_USER_ACTIVITY_LOG")));
    }
    
    public Employee getEmployee(){
        return employee;
    }
    
    public void setEmployee(long userId){
        try {
            AppUser appUser = PstAppUser.fetch(userId);
            this.employee = PstEmployee.fetchExc(appUser.getEmployeeId());
        } catch(Exception e){
            System.out.println("Get AppUser: userId: "+e.toString());
        }
    }
    
    public long insertLogSystem(long userId, String tblName, String actionName, 
            String logField, String logCurr, String logPrev, String logModule, String url, long objId){
        long oid = 0;
        try {
            Employee emp = getEmployee();
            LogSysHistory logSysHistory = new LogSysHistory();
            logSysHistory.setLogDocumentId(0);
            logSysHistory.setLogUserId(userId);
            logSysHistory.setApproverId(userId);
            logSysHistory.setApproveDate(null);
            logSysHistory.setLogLoginName("user log");
            logSysHistory.setLogDocumentNumber("");
            logSysHistory.setLogDocumentType(tblName); //entity
            logSysHistory.setLogUserAction(actionName); // command
            logSysHistory.setLogOpenUrl(url); // locate jsp
            logSysHistory.setLogUpdateDate(null);
            logSysHistory.setLogApplication(I_LogHistory.SYSTEM_NAME[I_LogHistory.SYSTEM_HAIRISMA]);
            logSysHistory.setLogDetail(logField); // apa yang dirubah
            logSysHistory.setLogStatus(0); /* 0 == draft */
            /* data logCurr yg telah diinisalisasi kemudian dipakai untuk set ke logPrev, dan logCurr */
            logSysHistory.setLogPrev(logCurr);
            logSysHistory.setLogCurr(logCurr);
            logSysHistory.setLogModule(logModule); /* nama sub module*/
            /* data struktur perusahaan didapat dari pengguna yang login melalui AppUser */
            logSysHistory.setCompanyId(emp.getCompanyId());
            logSysHistory.setDivisionId(emp.getDivisionId());
            logSysHistory.setDepartmentId(emp.getDepartmentId());
            logSysHistory.setSectionId(emp.getSectionId());
            /* mencatat item yang diedit */
            logSysHistory.setLogEditedUserId(objId);
            /* setelah di set maka lakukan proses insert ke table logSysHistory */
            PstLogSysHistory.insertExc(logSysHistory);
        } catch(Exception e){
            System.out.println(""+e.toString());
        }
        return oid;
    }
}

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.session.employee;

/**
 *
 * @author Kartika
 */
public class SessCandidateParam {
    private boolean employeeStatusActiv = true;
    private boolean employeeStatusMBT = false;
    private boolean employeeStatusResigned = false;
    private long employeePositionType = 0;

    /**
     * @return the employeeStatusActiv
     */
    public boolean isEmployeeStatusActiv() {
        return employeeStatusActiv;
    }

    /**
     * @param employeeStatusActiv the employeeStatusActiv to set
     */
    public void setEmployeeStatusActiv(boolean employeeStatusActiv) {
        this.employeeStatusActiv = employeeStatusActiv;
    }

    /**
     * @return the employeeStatusMBT
     */
    public boolean isEmployeeStatusMBT() {
        return employeeStatusMBT;
    }

    /**
     * @param employeeStatusMBT the employeeStatusMBT to set
     */
    public void setEmployeeStatusMBT(boolean employeeStatusMBT) {
        this.employeeStatusMBT = employeeStatusMBT;
    }

    /**
     * @return the employeeStatusResigned
     */
    public boolean isEmployeeStatusResigned() {
        return employeeStatusResigned;
    }

    /**
     * @param employeeStatusResigned the employeeStatusResigned to set
     */
    public void setEmployeeStatusResigned(boolean employeeStatusResigned) {
        this.employeeStatusResigned = employeeStatusResigned;
    }

    /**
     * @return the employeePositionType
     */
    public long getEmployeePositionType() {
        return employeePositionType;
    }

    /**
     * @param employeePositionType the employeePositionType to set
     */
    public void setEmployeePositionType(long employeePositionType) {
        this.employeePositionType = employeePositionType;
    }
    
}

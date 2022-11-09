/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.masterdata;

/**
 *
 * @author Gunadi
 */
import com.dimata.qdep.entity.Entity;

public class EmpDocListExpense extends Entity {

    private long empDocListExpenseId = 0;
    private long empDocId = 0;
    private long employeeId = 0;
    private long componentId = 0;
    private int dayLength = 0;
    private double compValue = 0;
    private String objectName = "";
    private long periodeId = 0;

    public long getEmpDocListExpenseId() {
        return empDocListExpenseId;
    }

    public void setEmpDocListExpenseId(long empDocListExpenseId) {
        this.empDocListExpenseId = empDocListExpenseId;
    }

    public long getEmpDocId() {
        return empDocId;
    }

    public void setEmpDocId(long empDocId) {
        this.empDocId = empDocId;
    }

    public long getEmployeeId() {
        return employeeId;
    }

    public void setEmployeeId(long employeeId) {
        this.employeeId = employeeId;
    }

    public long getComponentId() {
        return componentId;
    }

    public void setComponentId(long componentId) {
        this.componentId = componentId;
    }

    public int getDayLength() {
        return dayLength;
    }

    public void setDayLength(int dayLength) {
        this.dayLength = dayLength;
    }

    /**
     * @return the compValue
     */
    public double getCompValue() {
        return compValue;
    }

    /**
     * @param compValue the compValue to set
     */
    public void setCompValue(double compValue) {
        this.compValue = compValue;
    }

	/**
	 * @return the objectName
	 */
	public String getObjectName() {
		return objectName;
	}

	/**
	 * @param objectName the objectName to set
	 */
	public void setObjectName(String objectName) {
		this.objectName = objectName;
	}

    /**
     * @return the periodeId
     */
    public long getPeriodeId() {
        return periodeId;
    }

    /**
     * @param periodeId the periodeId to set
     */
    public void setPeriodeId(long periodeId) {
        this.periodeId = periodeId;
    }
}

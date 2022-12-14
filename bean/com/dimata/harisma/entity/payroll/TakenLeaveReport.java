/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.payroll;

/**
 *
 * @author Dimata 007
 */
public class TakenLeaveReport {
    private String department = "";
    private String section = "";
    private double baseAmount = 0;
    private int headCount = 0;
    private int leaveTaken = 0;
    private double applyAmount = 0;
    private double totalApplyAmount = 0;

    /**
     * @return the department
     */
    public String getDepartment() {
        return department;
    }

    /**
     * @param department the department to set
     */
    public void setDepartment(String department) {
        this.department = department;
    }

    /**
     * @return the section
     */
    public String getSection() {
        return section;
    }

    /**
     * @param section the section to set
     */
    public void setSection(String section) {
        this.section = section;
    }

    /**
     * @return the baseAmount
     */
    public double getBaseAmount() {
        return baseAmount;
    }

    /**
     * @param baseAmount the baseAmount to set
     */
    public void setBaseAmount(double baseAmount) {
        this.baseAmount = baseAmount;
    }

    /**
     * @return the headCount
     */
    public int getHeadCount() {
        return headCount;
    }

    /**
     * @param headCount the headCount to set
     */
    public void setHeadCount(int headCount) {
        this.headCount = headCount;
    }

    /**
     * @return the leaveTaken
     */
    public int getLeaveTaken() {
        return leaveTaken;
    }

    /**
     * @param leaveTaken the leaveTaken to set
     */
    public void setLeaveTaken(int leaveTaken) {
        this.leaveTaken = leaveTaken;
    }

    /**
     * @return the applyAmount
     */
    public double getApplyAmount() {
        return applyAmount;
    }

    /**
     * @param applyAmount the applyAmount to set
     */
    public void setApplyAmount(double applyAmount) {
        this.applyAmount = applyAmount;
    }

    /**
     * @return the totalApplyAmount
     */
    public double getTotalApplyAmount() {
        return totalApplyAmount;
    }

    /**
     * @param totalApplyAmount the totalApplyAmount to set
     */
    public void setTotalApplyAmount(double totalApplyAmount) {
        this.totalApplyAmount = totalApplyAmount;
    }
}

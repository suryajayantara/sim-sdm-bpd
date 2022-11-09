/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.employee;

/**
 *
 * @author Dimata 007
 */
import com.dimata.qdep.entity.Entity;
import java.util.Date;

public class EmpTalentPool extends Entity {

    private long employeeId = 0;
    private Date dateTalent = null;
    private int statusInfo = 0;
    private long mainId = 0;
    private long posType = 0;
    private double totalScore = 0;

    public long getEmployeeId() {
        return employeeId;
    }

    public void setEmployeeId(long employeeId) {
        this.employeeId = employeeId;
    }

    public Date getDateTalent() {
        return dateTalent;
    }

    public void setDateTalent(Date dateTalent) {
        this.dateTalent = dateTalent;
    }

    public int getStatusInfo() {
        return statusInfo;
    }

    public void setStatusInfo(int statusInfo) {
        this.statusInfo = statusInfo;
    }

    /**
     * @return the mainId
     */
    public long getMainId() {
        return mainId;
    }

    /**
     * @param mainId the mainId to set
     */
    public void setMainId(long mainId) {
        this.mainId = mainId;
    }

    /**
     * @return the posType
     */
    public long getPosType() {
        return posType;
    }

    /**
     * @param posType the posType to set
     */
    public void setPosType(long posType) {
        this.posType = posType;
    }

    /**
     * @return the totalScore
     */
    public double getTotalScore() {
        return totalScore;
    }

    /**
     * @param totalScore the totalScore to set
     */
    public void setTotalScore(double totalScore) {
        this.totalScore = totalScore;
    }
}

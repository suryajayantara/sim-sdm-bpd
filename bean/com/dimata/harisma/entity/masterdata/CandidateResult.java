/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.masterdata;

import com.dimata.qdep.entity.Entity;

/**
 *
 * @author gndiw
 */
public class CandidateResult extends Entity {

    private long candidateMainId = 0;
    private long employeeId = 0;
    private long positionTypeId = 0;

    public long getCandidateMainId() {
        return candidateMainId;
    }

    public void setCandidateMainId(long candidateMainId) {
        this.candidateMainId = candidateMainId;
    }

    public long getEmployeeId() {
        return employeeId;
    }

    public void setEmployeeId(long employeeId) {
        this.employeeId = employeeId;
    }

    /**
     * @return the positionTypeId
     */
    public long getPositionTypeId() {
        return positionTypeId;
    }

    /**
     * @param positionTypeId the positionTypeId to set
     */
    public void setPositionTypeId(long positionTypeId) {
        this.positionTypeId = positionTypeId;
    }

}

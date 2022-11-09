/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.employee.assessment;

import com.dimata.qdep.entity.Entity;

/**
 *
 * @author keys
 */
public class AssessmentFormMainPosition  extends Entity {
    
    private long AssFormMainPositionId = 0;
    private long AssFormMainId = 0;
    private long positionId = 0;
    
    /**
     * @return the AssFormMainPositionId
     */
    public long getAssFormMainPositionId() {
        return AssFormMainPositionId;
    }

    /**
     * @param AssFormMainPositionId the AssFormMainPositionId to set
     */
    public void setAssFormMainPositionId(long AssFormMainPositionId) {
        this.AssFormMainPositionId = AssFormMainPositionId;
    }

    /**
     * @return the AssFormMainId
     */
    public long getAssFormMainId() {
        return AssFormMainId;
    }

    /**
     * @param AssFormMainId the AssFormMainId to set
     */
    public void setAssFormMainId(long AssFormMainId) {
        this.AssFormMainId = AssFormMainId;
    }

    /**
     * @return the positionId
     */
    public long getPositionId() {
        return positionId;
    }

    /**
     * @param positionId the positionId to set
     */
    public void setPositionId(long positionId) {
        this.positionId = positionId;
    }

    
   
   
 
}

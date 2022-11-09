/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.masterdata;

import com.dimata.qdep.entity.Entity;

/**
 *
 * @author keys
 */
public class KpiGroupPosition extends Entity {
    private long kpiGroupPositionId= 0;
    private long kpiGroupId = 0;
    private long positionId = 0; 
    /**
     * @return the kpiGroupPositionId
     */
    public long getKpiGroupPositionId() {
        return kpiGroupPositionId;
    }

    /**
     * @param kpiGroupPositionId the kpiGroupPositionId to set
     */
    public void setKpiGroupPositionId(long kpiGroupPositionId) {
        this.kpiGroupPositionId = kpiGroupPositionId;
    }

    /**
     * @return the kpiGroupId
     */
    public long getKpiGroupId() {
        return kpiGroupId;
    }

    /**
     * @param kpiGroupId the kpiGroupId to set
     */
    public void setKpiGroupId(long kpiGroupId) {
        this.kpiGroupId = kpiGroupId;
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

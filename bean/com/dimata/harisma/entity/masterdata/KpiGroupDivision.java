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


public class KpiGroupDivision extends Entity {
    private long kpiGroupDivisonId = 0;
    private long kpiGroupId = 0;
    private long divisionId = 0; 

    /**
     * @return the kpiGroupDivisonId
     */
    public long getKpiGroupDivisonId() {
        return kpiGroupDivisonId;
    }

    /**
     * @param kpiGroupDivisonId the kpiGroupDivisonId to set
     */
    public void setKpiGroupDivisonId(long kpiGroupDivisonId) {
        this.kpiGroupDivisonId = kpiGroupDivisonId;
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
     * @return the divisionId
     */
    public long getDivisionId() {
        return divisionId;
    }

    /**
     * @param divisionId the divisionId to set
     */
    public void setDivisionId(long divisionId) {
        this.divisionId = divisionId;
    }
 


    
}

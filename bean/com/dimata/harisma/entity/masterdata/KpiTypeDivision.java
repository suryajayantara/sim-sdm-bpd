/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.masterdata;


import com.dimata.qdep.entity.Entity;


/**
 *
 * @author User
 */

public class KpiTypeDivision extends Entity{

    
    private long kpiTypeDivisionId = 0;
    private long kpiTypeId = 0;
    private long divisionId = 0;

/**
     * @return the kpiTypeDivisionId
     */
    public long getKpiTypeDivisionId() {
        return kpiTypeDivisionId;
    }

    /**
     * @param kpiTypeDivisionId the kpiTypeDivisionId to set
     */
    public void setKpiTypeDivisionId(long kpiTypeDivisionId) {
        this.kpiTypeDivisionId = kpiTypeDivisionId;
    }

    /**
     * @return the kpiTypeId
     */
    public long getKpiTypeId() {
        return kpiTypeId;
    }

    /**
     * @param kpiTypeId the kpiTypeId to set
     */
    public void setKpiTypeId(long kpiTypeId) {
        this.kpiTypeId = kpiTypeId;
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

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.masterdata;

/**
 *
 * @author User
 */
import com.dimata.qdep.entity.Entity;

/**
 *
 * @author User
 */
public class KpiSettingList extends Entity{

    private long kpiSettingListId = 0;
    private long kpiSettingId = 0;
    private long kpiListId = 0;
    private long kpiDistributionId = 0;

        /**
     * @return the kpiSettinListId
     */
    public long getKpiSettingListId() {
        return kpiSettingListId;
    }

    /**
     * @param kpiSettinListId the kpiSettinListId to set
     */
    public void setKpiSettingListId(long kpiSettingListId) {
        this.kpiSettingListId = kpiSettingListId;
    }
    /**
     * @return the kpiSettingId
     */
    public long getKpiSettingId() {
        return kpiSettingId;
    }

    /**
     * @param kpiSettingId the kpiSettingId to set
     */
    public void setKpiSettingId(long kpiSettingId) {
        this.kpiSettingId = kpiSettingId;
    }

    /**
     * @return the kpiListId
     */
    public long getKpiListId() {
        return kpiListId;
    }

    /**
     * @param kpiListId the kpiListId to set
     */
    public void setKpiListId(long kpiListId) {
        this.kpiListId = kpiListId;
    }

    /**
     * @return the kpiDistributionId
     */
    public long getKpiDistributionId() {
        return kpiDistributionId;
    }

    /**
     * @param kpiDistributionId the kpiDistributionId to set
     */
    public void setKpiDistributionId(long kpiDistributionId) {
        this.kpiDistributionId = kpiDistributionId;
    }
    
}


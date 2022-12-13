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

public class KpiSettingType extends Entity {

    private long kpiSettingTypeId = 0;
    private long kpiSettingId = 0;
    private long kpiTypeId = 0;

    public long getKpiSettingTypeId() {
        return kpiSettingTypeId;
    }

    public void setKpiSettingTypeId(long kpiSettingTypeId) {
        this.kpiSettingTypeId = kpiSettingTypeId;
    }

    public long getKpiSettingId() {
        return kpiSettingId;
    }

    public void setKpiSettingId(long kpiSettingId) {
        this.kpiSettingId = kpiSettingId;
    }

    public long getKpiTypeId() {
        return kpiTypeId;
    }

    public void setKpiTypeId(long kpiTypeId) {
        this.kpiTypeId = kpiTypeId;
    }
    

}

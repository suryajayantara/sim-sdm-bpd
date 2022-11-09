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
public class KPITypeCompany extends Entity {

    private long kpiTypeCompanyId = 0;

    public long getKpiTypeCompanyId() {
        return kpiTypeCompanyId;
    }

    public void setKpiTypeCompanyId(long kpiTypeCompanyId) {
        this.kpiTypeCompanyId = kpiTypeCompanyId;
    }

    public long getKpiTypeId() {
        return kpiTypeId;
    }

    public void setKpiTypeId(long kpiTypeId) {
        this.kpiTypeId = kpiTypeId;
    }

    public long getCompanyId() {
        return companyId;
    }

    public void setCompanyId(long companyId) {
        this.companyId = companyId;
    }
    private long kpiTypeId = 0;
    private long companyId = 0;
    
}

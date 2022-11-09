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
import java.util.Date;


public class KpiSetting extends Entity {


private long kpiSettingId = 0;
private Date validDate = null;
private int status = 0;
private Date startDate = null;
private long companyId = 0;
private int tahun = 0;



public long getKpiSettingId(){
return kpiSettingId;
}

public void setKpiSettingId(long kpiSettingId){
this.kpiSettingId = kpiSettingId;
}

public Date getValidDate(){
return validDate;
}

public void setValidDate(Date validDate){
this.validDate = validDate;
}

public int getStatus(){
return status;
}

public void setStatus(int status){
this.status = status;
}

public Date getStartDate(){
return startDate;
}

public void setStartDate(Date startDate){
this.startDate = startDate;
}

   /**
     * @return the companyId
     */
    public long getCompanyId() {
        return companyId;
    }

    /**
     * @param companyId the companyId to set
     */
    public void setCompanyId(long companyId) {
        this.companyId = companyId;
    }

    public int getTahun() {
        return tahun;
    }

    /**
     * @param tahun the tahun to set
     */
    public void setTahun(int tahun) {
        this.tahun = tahun;
    }
    


}

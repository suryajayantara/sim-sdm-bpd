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

public class KpiSettingGroup extends Entity {

private long kpiSettingGroupId = 0;
private long kpiSettingId = 0;
private long kpiGroupId = 0;

public long getKpiSettingGroupId(){
return kpiSettingGroupId;
}

public void setKpiSettingGroupId(long kpiSettingGroupId){
this.kpiSettingGroupId = kpiSettingGroupId;
}

public long getKpiSettingId(){
return kpiSettingId;
}

public void setKpiSettingId(long kpiSettingId){
this.kpiSettingId = kpiSettingId;
}

public long getKpiGroupId(){
return kpiGroupId;
}

public void setKpiGroupId(long kpiGroupId){
this.kpiGroupId = kpiGroupId;
}

}

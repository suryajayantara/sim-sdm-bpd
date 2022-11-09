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

public class KpiSettingPosition extends Entity {

private long kpiSettingPositionId = 0;
private long kpiSettingId = 0;
private long positionId = 0;

public long getKpiSettingPositionId(){
return kpiSettingPositionId;
}

public void setKpiSettingPositionId(long kpiSettingPositionId){
this.kpiSettingPositionId = kpiSettingPositionId;
}

public long getKpiSettingId(){
return kpiSettingId;
}

public void setKpiSettingId(long kpiSettingId){
this.kpiSettingId = kpiSettingId;
}

public long getPositionId(){
return positionId;
}

public void setPositionId(long positionId){
this.positionId = positionId;
}

}

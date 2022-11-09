/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.masterdata;

/**
 *
 * @author keys
 */
import com.dimata.qdep.entity.Entity;

public class EmpDocCompMap extends Entity {

private long docCompMapId = 0;
private long docMasterId = 0;
private long componentId = 0;
private  int dayLength = 0;
private long periodId = 0;

public long getDocCompMapId(){
return docCompMapId;
}

public void setDocCompMapId(long docCompMapId){
this.docCompMapId = docCompMapId;
}

public long getDocMasterId(){
return docMasterId;
}

public void setDocMasterId(long docMasterId){
this.docMasterId = docMasterId;
}

public long getComponentId(){
return componentId;
}

public void setComponentId(long componentId){
this.componentId = componentId;
}

public int getDayLength(){
return dayLength;
}

public void setDayLength(int dayLength){
this.dayLength = dayLength;
}

public long getPeriodId(){
return periodId;
}

public void setPeriodId(long periodId){
this.periodId = periodId;
}

}
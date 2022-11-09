package com.dimata.harisma.entity.masterdata;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
import com.dimata.qdep.entity.Entity;

public class PositionExperienceRequired extends Entity {

private long positionId = 0;
private long experienceId = 0;
private int durationMin = 0;
private int durationRecommended = 0;
private String note = "";

public long getPositionId(){
return positionId;
}

public void setPositionId(long positionId){
this.positionId = positionId;
}

public long getExperienceId(){
return experienceId;
}

public void setExperienceId(long experienceId){
this.experienceId = experienceId;
}

public int getDurationMin(){
return durationMin;
}

public void setDurationMin(int durationMin){
this.durationMin = durationMin;
}

public int getDurationRecommended(){
return durationRecommended;
}

public void setDurationRecommended(int durationRecommended){
this.durationRecommended = durationRecommended;
}

public String getNote(){
return note;
}

public void setNote(String note){
this.note = note;
}

}
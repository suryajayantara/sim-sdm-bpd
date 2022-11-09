package com.dimata.harisma.entity.employee;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
import com.dimata.qdep.entity.Entity;

public class CandidatePositionExperience extends Entity {
private long candidateMainId = 0;
private long positionId = 0;
private long experienceId = 0;
private int durationMin = 0;
private int durationRecommended = 0;
private String note = "";
private int type = 0;
private int kondisi = 0;


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

    /**
     * @return the candidateMainId
     */
    public long getCandidateMainId() {
        return candidateMainId;
    }

    /**
     * @param candidateMainId the candidateMainId to set
     */
    public void setCandidateMainId(long candidateMainId) {
        this.candidateMainId = candidateMainId;
    }

	/**
	 * @return the type
	 */
	public int getType() {
		return type;
	}

	/**
	 * @param type the type to set
	 */
	public void setType(int type) {
		this.type = type;
	}

    /**
     * @return the kondisi
     */
    public int getKondisi() {
        return kondisi;
    }

    /**
     * @param kondisi the kondisi to set
     */
    public void setKondisi(int kondisi) {
        this.kondisi = kondisi;
    }

}
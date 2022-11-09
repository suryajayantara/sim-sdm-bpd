/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.employee;

/**
 *
 * @author Dimata 007
 */
import com.dimata.qdep.entity.Entity;

public class CandidatePositionCompetency extends Entity {

    private long candidateMainId = 0;
    private long positionId = 0;
    private long competencyId = 0;
    private int scoreMin = 0;
    private int scoreMax = 0;
    private int bobot = 0;
    private int kondisi = 0;

    public long getCandidateMainId() {
        return candidateMainId;
    }

    public void setCandidateMainId(long candidateMainId) {
        this.candidateMainId = candidateMainId;
    }

    public long getPositionId() {
        return positionId;
    }

    public void setPositionId(long positionId) {
        this.positionId = positionId;
    }

    public long getCompetencyId() {
        return competencyId;
    }

    public void setCompetencyId(long competencyId) {
        this.competencyId = competencyId;
    }

    public int getScoreMin() {
        return scoreMin;
    }

    public void setScoreMin(int scoreMin) {
        this.scoreMin = scoreMin;
    }

    public int getScoreMax() {
        return scoreMax;
    }

    public void setScoreMax(int scoreMax) {
        this.scoreMax = scoreMax;
    }

	/**
	 * @return the bobot
	 */
	public int getBobot() {
		return bobot;
	}

	/**
	 * @param bobot the bobot to set
	 */
	public void setBobot(int bobot) {
		this.bobot = bobot;
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

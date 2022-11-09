/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.employee;

import com.dimata.qdep.entity.Entity;

/**
 *
 * @author gndiw
 */
public class CandidatePositionAssessment extends Entity {

    private long candidateMainId = 0;
    private long positionId = 0;
    private long assessmentId = 0;
    private int scoreMin = 0;
    private int scoreMax = 0;
    private int bobot = 0;
    private int tahun = 0;
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

    public long getAssessmentId() {
        return assessmentId;
    }

    public void setAssessmentId(long assessmentId) {
        this.assessmentId = assessmentId;
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

    public int getBobot() {
        return bobot;
    }

    public void setBobot(int bobot) {
        this.bobot = bobot;
    }

    /**
     * @return the tahun
     */
    public int getTahun() {
        return tahun;
    }

    /**
     * @param tahun the tahun to set
     */
    public void setTahun(int tahun) {
        this.tahun = tahun;
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

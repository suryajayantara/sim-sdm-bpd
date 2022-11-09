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

public class CandidatePositionKpi extends Entity {

    private long candidateMainId = 0;
    private long positionId = 0;
    private long kpiId = 0;
    private int scoreMin = 0;
    private int scoreMax = 0;

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

    public long getKpiId() {
        return kpiId;
    }

    public void setKpiId(long kpiId) {
        this.kpiId = kpiId;
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
}
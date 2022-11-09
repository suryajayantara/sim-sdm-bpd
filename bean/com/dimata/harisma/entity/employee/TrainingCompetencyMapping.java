/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.employee;
import com.dimata.qdep.entity.Entity;

/**
 *
 * @author keys
 */
public class TrainingCompetencyMapping extends Entity{
    private long trainingCompetencyMappingId = 0;
    private long trainingActivityActualId = 0;
    private long competencyId = 0;
    private double score = 0;

    public long getTrainingCompetencyMappingId() {
        return trainingCompetencyMappingId;
    }

    public void setTrainingCompetencyMappingId(long trainingCompetencyMappingId) {
        this.trainingCompetencyMappingId = trainingCompetencyMappingId;
    }

    public long getTrainingActivityActualId() {
        return trainingActivityActualId;
    }

    public void setTrainingActivityActualId(long trainingActivityActualId) {
        this.trainingActivityActualId = trainingActivityActualId;
    }

    public long getCompetencyId() {
        return competencyId;
    }

    public void setCompetencyId(long competencyId) {
        this.competencyId = competencyId;
    }

    public double getScore() {
        return score;
    }

    public void setScore(double score) {
        this.score = score;
    }
}

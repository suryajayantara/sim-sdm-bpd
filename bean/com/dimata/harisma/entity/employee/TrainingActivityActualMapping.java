/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.employee;

/**
 *
 * @author Gunadi
 */
import com.dimata.qdep.entity.Entity;

public class TrainingActivityActualMapping extends Entity {

    private long trainingActivityActualId = 0;
    private long trainingId = 0;

    public long getTrainingActivityActualId() {
        return trainingActivityActualId;
    }

    public void setTrainingActivityActualId(long trainingActivityActualId) {
        this.trainingActivityActualId = trainingActivityActualId;
    }

    public long getTrainingId() {
        return trainingId;
    }

    public void setTrainingId(long trainingId) {
        this.trainingId = trainingId;
    }
}
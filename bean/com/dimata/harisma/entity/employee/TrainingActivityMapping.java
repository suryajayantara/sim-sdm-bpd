/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.employee;

import com.dimata.qdep.entity.Entity;

/**
 *
 * @author Gunadi
 */
public class TrainingActivityMapping extends Entity {

    private long trainingActivityPlanId = 0;
    private long trainingId = 0;

    public long getTrainingActivityPlanId() {
        return trainingActivityPlanId;
    }

    public void setTrainingActivityPlanId(long trainingActivityPlanId) {
        this.trainingActivityPlanId = trainingActivityPlanId;
    }

    public long getTrainingId() {
        return trainingId;
    }

    public void setTrainingId(long trainingId) {
        this.trainingId = trainingId;
    }
}
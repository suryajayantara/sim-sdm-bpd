/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.masterdata;

import com.dimata.qdep.entity.Entity;

/**
 *
 * @author khirayinnura
 */
public class TrainingBudget extends Entity {
    private long trainingBudgetId = 0;
    private String trainingBudgetYear = "";
    private long trainingId = 0;
    private double trainingBudgetDuration = 0;
    private double trainingBudgetFrequency = 0;
    private double trainingBudgetBatch = 0;
    private double trainingBudgetAmount = 0;
    private double trainingBudgetCostBatch = 0;
    private double trainingBudgetTotal = 0;
    private long trainingLocationTypeId = 0;
    private long trainingAreaId = 0;
    private String trainingBudgetDesc = "";

    /**
     * @return the trainingBudgetId
     */
    public long getTrainingBudgetId() {
        return trainingBudgetId;
    }

    /**
     * @param trainingBudgetId the trainingBudgetId to set
     */
    public void setTrainingBudgetId(long trainingBudgetId) {
        this.trainingBudgetId = trainingBudgetId;
    }

    /**
     * @return the trainingBudgetYear
     */
    public String getTrainingBudgetYear() {
        return trainingBudgetYear;
    }

    /**
     * @param trainingBudgetYear the trainingBudgetYear to set
     */
    public void setTrainingBudgetYear(String trainingBudgetYear) {
        this.trainingBudgetYear = trainingBudgetYear;
    }

    /**
     * @return the trainingId
     */
    public long getTrainingId() {
        return trainingId;
    }

    /**
     * @param trainingId the trainingId to set
     */
    public void setTrainingId(long trainingId) {
        this.trainingId = trainingId;
    }

    /**
     * @param trainingBudgetAmount the trainingBudgetAmount to set
     */
    public void setTrainingBudgetAmount(int trainingBudgetAmount) {
        this.setTrainingBudgetAmount(trainingBudgetAmount);
    }

    /**
     * @return the trainingBudgetCostBatch
     */
    public double getTrainingBudgetCostBatch() {
        return trainingBudgetCostBatch;
    }

    /**
     * @param trainingBudgetCostBatch the trainingBudgetCostBatch to set
     */
    public void setTrainingBudgetCostBatch(double trainingBudgetCostBatch) {
        this.trainingBudgetCostBatch = trainingBudgetCostBatch;
    }

    /**
     * @return the trainingBudgetTotal
     */
    public double getTrainingBudgetTotal() {
        return trainingBudgetTotal;
    }

    /**
     * @param trainingBudgetTotal the trainingBudgetTotal to set
     */
    public void setTrainingBudgetTotal(double trainingBudgetTotal) {
        this.trainingBudgetTotal = trainingBudgetTotal;
    }

    /**
     * @return the trainingLocationTypeId
     */
    public long getTrainingLocationTypeId() {
        return trainingLocationTypeId;
    }

    /**
     * @param trainingLocationTypeId the trainingLocationTypeId to set
     */
    public void setTrainingLocationTypeId(long trainingLocationTypeId) {
        this.trainingLocationTypeId = trainingLocationTypeId;
    }

    /**
     * @return the trainingAreaId
     */
    public long getTrainingAreaId() {
        return trainingAreaId;
    }

    /**
     * @param trainingAreaId the trainingAreaId to set
     */
    public void setTrainingAreaId(long trainingAreaId) {
        this.trainingAreaId = trainingAreaId;
    }

    /**
     * @return the trainingBudgetDesc
     */
    public String getTrainingBudgetDesc() {
        return trainingBudgetDesc;
    }

    /**
     * @param trainingBudgetDesc the trainingBudgetDesc to set
     */
    public void setTrainingBudgetDesc(String trainingBudgetDesc) {
        this.trainingBudgetDesc = trainingBudgetDesc;
    }

    /**
     * @return the trainingBudgetDuration
     */
    public double getTrainingBudgetDuration() {
        return trainingBudgetDuration;
    }

    /**
     * @param trainingBudgetDuration the trainingBudgetDuration to set
     */
    public void setTrainingBudgetDuration(double trainingBudgetDuration) {
        this.trainingBudgetDuration = trainingBudgetDuration;
    }

    /**
     * @return the trainingBudgetFrequency
     */
    public double getTrainingBudgetFrequency() {
        return trainingBudgetFrequency;
    }

    /**
     * @param trainingBudgetFrequency the trainingBudgetFrequency to set
     */
    public void setTrainingBudgetFrequency(double trainingBudgetFrequency) {
        this.trainingBudgetFrequency = trainingBudgetFrequency;
    }

    /**
     * @return the trainingBudgetBatch
     */
    public double getTrainingBudgetBatch() {
        return trainingBudgetBatch;
    }

    /**
     * @param trainingBudgetBatch the trainingBudgetBatch to set
     */
    public void setTrainingBudgetBatch(double trainingBudgetBatch) {
        this.trainingBudgetBatch = trainingBudgetBatch;
    }

    /**
     * @return the trainingBudgetAmount
     */
    public double getTrainingBudgetAmount() {
        return trainingBudgetAmount;
    }

    /**
     * @param trainingBudgetAmount the trainingBudgetAmount to set
     */
    public void setTrainingBudgetAmount(double trainingBudgetAmount) {
        this.trainingBudgetAmount = trainingBudgetAmount;
    }
}

/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.form.masterdata;

import com.dimata.harisma.entity.masterdata.TrainingBudget;
import com.dimata.qdep.form.FRMHandler;
import com.dimata.qdep.form.I_FRMInterface;
import com.dimata.qdep.form.I_FRMType;
import javax.servlet.http.HttpServletRequest;

/**
 *
 * @author khirayinnura
 */
public class FrmTrainingBudget extends FRMHandler implements I_FRMInterface, I_FRMType {

    private TrainingBudget entTrainingBudget;
    public static final String FRM_NAME_TRAINING_BUDGET = "FRM_NAME_TRAINING_BUDGET";
    public static final int FRM_FIELD_TRAINING_BUDGET_ID = 0;
    public static final int FRM_FIELD_TRAINING_BUDGET_YEAR = 1;
    public static final int FRM_FIELD_TRAINING_ID = 2;
    public static final int FRM_FIELD_TRAINING_BUDGET_DURATION = 3;
    public static final int FRM_FIELD_TRAINING_BUDGET_FREQUENCY = 4;
    public static final int FRM_FIELD_TRAINING_BUDGET_BATCH = 5;
    public static final int FRM_FIELD_TRAINING_BUDGET_AMOUNT = 6;
    public static final int FRM_FIELD_TRAINING_BUDGET_COST_BATCH = 7;
    public static final int FRM_FIELD_TRAINING_BUDGET_TOTAL = 8;
    public static final int FRM_FIELD_TRAINING_LOCATION_TYPE_ID = 9;
    public static final int FRM_FIELD_TRAINING_AREA_ID = 10;
    public static final int FRM_FIELD_TRAINING_BUDGET_DESC = 11;
    public static String[] fieldNames = {
        "FRM_FIELD_TRAINING_BUDGET_ID",
        "FRM_FIELD_TRAINING_BUDGET_YEAR",
        "FRM_FIELD_TRAINING_ID",
        "FRM_FIELD_TRAINING_BUDGET_DURATION",
        "FRM_FIELD_TRAINING_BUDGET_FREQUENCY",
        "FRM_FIELD_TRAINING_BUDGET_BATCH",
        "FRM_FIELD_TRAINING_BUDGET_AMOUNT",
        "FRM_FIELD_TRAINING_BUDGET_COST_BATCH",
        "FRM_FIELD_TRAINING_BUDGET_TOTAL",
        "FRM_FIELD_TRAINING_LOCATION_TYPE_ID",
        "FRM_FIELD_TRAINING_AREA_ID",
        "FRM_FIELD_TRAINING_BUDGET_DESC"
    };
    public static int[] fieldTypes = {
        TYPE_LONG,
        TYPE_STRING,
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_STRING
    };

    public FrmTrainingBudget() {
    }

    public FrmTrainingBudget(TrainingBudget entTrainingBudget) {
        this.entTrainingBudget = entTrainingBudget;
    }

    public FrmTrainingBudget(HttpServletRequest request, TrainingBudget entTrainingBudget) {
        super(new FrmTrainingBudget(entTrainingBudget), request);
        this.entTrainingBudget = entTrainingBudget;
    }

    public String getFormName() {
        return FRM_NAME_TRAINING_BUDGET;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int getFieldSize() {
        return fieldNames.length;
    }

    public TrainingBudget getEntityObject() {
        return entTrainingBudget;
    }

    public void requestEntityObject(TrainingBudget entTrainingBudget) {
        try {
            this.requestParam();
            entTrainingBudget.setTrainingBudgetYear(getString(FRM_FIELD_TRAINING_BUDGET_YEAR));
            entTrainingBudget.setTrainingId(getLong(FRM_FIELD_TRAINING_ID));
            entTrainingBudget.setTrainingBudgetDuration(getDouble(FRM_FIELD_TRAINING_BUDGET_DURATION));
            entTrainingBudget.setTrainingBudgetFrequency(getDouble(FRM_FIELD_TRAINING_BUDGET_FREQUENCY));
            entTrainingBudget.setTrainingBudgetBatch(getDouble(FRM_FIELD_TRAINING_BUDGET_BATCH));
            entTrainingBudget.setTrainingBudgetAmount(getDouble(FRM_FIELD_TRAINING_BUDGET_AMOUNT));
            entTrainingBudget.setTrainingBudgetCostBatch(getDouble(FRM_FIELD_TRAINING_BUDGET_COST_BATCH));
            entTrainingBudget.setTrainingBudgetTotal(getDouble(FRM_FIELD_TRAINING_BUDGET_TOTAL));
            entTrainingBudget.setTrainingLocationTypeId(getLong(FRM_FIELD_TRAINING_LOCATION_TYPE_ID));
            entTrainingBudget.setTrainingAreaId(getLong(FRM_FIELD_TRAINING_AREA_ID));
            entTrainingBudget.setTrainingBudgetDesc(getString(FRM_FIELD_TRAINING_BUDGET_DESC));
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}

/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.form.employee;

/**
 *
 * @author Gunadi
 */
import com.dimata.harisma.entity.employee.TrainingActivityMapping;
import com.dimata.qdep.form.FRMHandler;
import com.dimata.qdep.form.I_FRMInterface;
import com.dimata.qdep.form.I_FRMType;
import javax.servlet.http.HttpServletRequest;

public class FrmTrainingActivityMapping extends FRMHandler implements I_FRMInterface, I_FRMType {

    private TrainingActivityMapping entTrainingActivityPlanMapping;
    public static final String FRM_NAME_TRAINING_ACTIVITY_MAPPING = "FRM_NAME_TRAINING_ACTIVITY_MAPPING";
    public static final int FRM_FIELD_TRAINING_ACTIVITY_MAPPING_ID = 0;
    public static final int FRM_FIELD_TRAINING_ACTIVITY_PLAN_ID = 1;
    public static final int FRM_FIELD_TRAINING_ID = 2;
    public static String[] fieldNames = {
        "FRM_FIELD_TRAINING_ACTIVITY_MAPPING_ID",
        "FRM_FIELD_TRAINING_ACTIVITY_PLAN_ID",
        "FRM_FIELD_TRAINING_ID"
    };
    public static int[] fieldTypes = {
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG
    };

    public FrmTrainingActivityMapping() {
    }

    public FrmTrainingActivityMapping(TrainingActivityMapping entTrainingActivityPlanMapping) {
        this.entTrainingActivityPlanMapping = entTrainingActivityPlanMapping;
    }

    public FrmTrainingActivityMapping(HttpServletRequest request, TrainingActivityMapping entTrainingActivityPlanMapping) {
        super(new FrmTrainingActivityMapping(entTrainingActivityPlanMapping), request);
        this.entTrainingActivityPlanMapping = entTrainingActivityPlanMapping;
    }

    public String getFormName() {
        return FRM_NAME_TRAINING_ACTIVITY_MAPPING;
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

    public TrainingActivityMapping getEntityObject() {
        return entTrainingActivityPlanMapping;
    }

    public void requestEntityObject(TrainingActivityMapping entTrainingActivityPlanMapping) {
        try {
            this.requestParam();
            entTrainingActivityPlanMapping.setTrainingActivityPlanId(getLong(FRM_FIELD_TRAINING_ACTIVITY_PLAN_ID));
            entTrainingActivityPlanMapping.setTrainingId(getLong(FRM_FIELD_TRAINING_ID));
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}
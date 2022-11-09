/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.form.employee;

/**
 *
 * @author Gunadi
 */
import com.dimata.harisma.entity.employee.TrainingActivityActualMapping;
import com.dimata.qdep.form.FRMHandler;
import com.dimata.qdep.form.I_FRMInterface;
import com.dimata.qdep.form.I_FRMType;
import javax.servlet.http.HttpServletRequest;

public class FrmTrainingActivityActualMapping extends FRMHandler implements I_FRMInterface, I_FRMType {

    private TrainingActivityActualMapping entTrainingActivityActualMapping;
    public static final String FRM_NAME_TRAINING_ACTIVITY_ACTUAL_MAPPING = "FRM_NAME_TRAINING_ACTIVITY_ACTUAL_MAPPING";
    public static final int FRM_FIELD_TRAINING_ACTIVITY_ACTUAL_MAPPING_ID = 0;
    public static final int FRM_FIELD_TRAINING_ACTIVITY_ACTUAL_ID = 1;
    public static final int FRM_FIELD_TRAININGID = 2;
    public static String[] fieldNames = {
        "FRM_FIELD_TRAINING_ACTIVITY_ACTUAL_MAPPING_ID",
        "FRM_FIELD_TRAINING_ACTIVITY_ACTUAL_ID",
        "FRM_FIELD_TRAININGID"
    };
    public static int[] fieldTypes = {
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG
    };

    public FrmTrainingActivityActualMapping() {
    }

    public FrmTrainingActivityActualMapping(TrainingActivityActualMapping entTrainingActivityActualMapping) {
        this.entTrainingActivityActualMapping = entTrainingActivityActualMapping;
    }

    public FrmTrainingActivityActualMapping(HttpServletRequest request, TrainingActivityActualMapping entTrainingActivityActualMapping) {
        super(new FrmTrainingActivityActualMapping(entTrainingActivityActualMapping), request);
        this.entTrainingActivityActualMapping = entTrainingActivityActualMapping;
    }

    public String getFormName() {
        return FRM_NAME_TRAINING_ACTIVITY_ACTUAL_MAPPING;
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

    public TrainingActivityActualMapping getEntityObject() {
        return entTrainingActivityActualMapping;
    }

    public void requestEntityObject(TrainingActivityActualMapping entTrainingActivityActualMapping) {
        try {
            this.requestParam();
            entTrainingActivityActualMapping.setTrainingActivityActualId(getLong(FRM_FIELD_TRAINING_ACTIVITY_ACTUAL_ID));
            entTrainingActivityActualMapping.setTrainingId(getLong(FRM_FIELD_TRAININGID));
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}
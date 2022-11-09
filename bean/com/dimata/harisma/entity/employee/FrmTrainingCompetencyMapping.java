/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.employee;

/**
 *
 * @author keys
 */

import com.dimata.qdep.form.FRMHandler;
import com.dimata.qdep.form.I_FRMInterface;
import com.dimata.qdep.form.I_FRMType;
import javax.servlet.http.HttpServletRequest;


public class FrmTrainingCompetencyMapping extends FRMHandler implements I_FRMInterface, I_FRMType{
    private TrainingCompetencyMapping entTrainingCompetencyMapping;
    public static final String FRM_NAME_TRAININGCOMPETENCYMAPPING = "FRM_NAME_TRAININGCOMPETENCYMAPPING";
    public static final int FRM_FIELD_TRAINING_COMPETENCY_MAPPING_ID = 0;
    public static final int FRM_FIELD_TRAINING_ACTIVITY_ACTUAL_ID = 1;
    public static final int FRM_FIELD_COMPETENCY_ID = 2;
    public static final int FRM_FIELD_SCORE = 3;

    public static String[] fieldNames = {
        "FRM_FIELD_TRAINING_COMPETENCY_MAPPING_ID",
        "FRM_FIELD_TRAINING_ACTIVITY_ACTUAL_ID",
        "FRM_FIELD_COMPETENCY_ID",
        "FRM_FIELD_SCORE"
    };

    public static int[] fieldTypes = {
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_INT
    };

    public FrmTrainingCompetencyMapping() {
    }

    public FrmTrainingCompetencyMapping(TrainingCompetencyMapping entTrainingCompetencyMapping) {
        this.entTrainingCompetencyMapping = entTrainingCompetencyMapping;
    }

    public FrmTrainingCompetencyMapping(HttpServletRequest request, TrainingCompetencyMapping entTrainingCompetencyMapping) {
        super(new FrmTrainingCompetencyMapping(entTrainingCompetencyMapping), request);
        this.entTrainingCompetencyMapping = entTrainingCompetencyMapping;
    }

    public String getFormName() {
        return FRM_NAME_TRAININGCOMPETENCYMAPPING;
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

    public TrainingCompetencyMapping getEntityObject() {
        return entTrainingCompetencyMapping;
    }

    public void requestEntityObject(TrainingCompetencyMapping entTrainingCompetencyMapping) {
        try {
            this.requestParam();
            entTrainingCompetencyMapping.setTrainingCompetencyMappingId(getLong(FRM_FIELD_TRAINING_COMPETENCY_MAPPING_ID));
            entTrainingCompetencyMapping.setOID(getLong(FRM_FIELD_TRAINING_ACTIVITY_ACTUAL_ID));
            entTrainingCompetencyMapping.setCompetencyId(getLong(FRM_FIELD_COMPETENCY_ID));
            entTrainingCompetencyMapping.setScore(getInt(FRM_FIELD_SCORE));
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}

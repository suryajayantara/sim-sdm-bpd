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


public class FrmTrainingCompetencyMappingDetail extends FRMHandler implements I_FRMInterface, I_FRMType{
    private TrainingCompetencyMappingDetail entTrainingCompetencyMappingDetail;
    public static final String FRM_NAME_TRAINING_COMPETENCY_MAPPING_DETAIL = "FRM_NAME_TRAINING_COMPETENCY_MAPPING_DETAIL";
    public static final int FRM_FIELD_TRAINING_COMPETENCY_MAPPING_DETAIL_ID = 0;
    public static final int FRM_FIELD_TRAINING_ACTIVITY_ACTUAL_ID = 1;
    public static final int FRM_FIELD_COMPETENCY_ID = 2;
    public static final int FRM_FIELD_SCORE = 3;

    public static String[] fieldNames = {
        "FRM_NAME_TRAINING_COMPETENCY_MAPPING_DETAIL",
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

    public FrmTrainingCompetencyMappingDetail() {
    }

    public FrmTrainingCompetencyMappingDetail(TrainingCompetencyMappingDetail entTrainingCompetencyMappingDetail) {
        this.entTrainingCompetencyMappingDetail = entTrainingCompetencyMappingDetail;
    }

    public FrmTrainingCompetencyMappingDetail(HttpServletRequest request, TrainingCompetencyMappingDetail entTrainingCompetencyMappingDetail) {
        super(new FrmTrainingCompetencyMappingDetail(entTrainingCompetencyMappingDetail), request);
        this.entTrainingCompetencyMappingDetail = entTrainingCompetencyMappingDetail;
    }

    public String getFormName() {
        return FRM_NAME_TRAINING_COMPETENCY_MAPPING_DETAIL;
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

    public TrainingCompetencyMappingDetail getEntityObject() {
        return entTrainingCompetencyMappingDetail;
    }

    public void requestEntityObject(TrainingCompetencyMappingDetail entTrainingCompetencyMappingDetail) {
        try {
            this.requestParam();
            entTrainingCompetencyMappingDetail.setTrainingCompetencyMappingDetailId(getLong(FRM_FIELD_TRAINING_COMPETENCY_MAPPING_DETAIL_ID));
            entTrainingCompetencyMappingDetail.setOID(getLong(FRM_FIELD_TRAINING_ACTIVITY_ACTUAL_ID));
            entTrainingCompetencyMappingDetail.setCompetencyId(getLong(FRM_FIELD_COMPETENCY_ID));
            entTrainingCompetencyMappingDetail.setScore(getInt(FRM_FIELD_SCORE));
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}

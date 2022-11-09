/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.form.employee;

import com.dimata.harisma.entity.employee.CandidatePositionAssessment;
import com.dimata.qdep.form.FRMHandler;
import com.dimata.qdep.form.I_FRMInterface;
import com.dimata.qdep.form.I_FRMType;
import javax.servlet.http.HttpServletRequest;

/**
 *
 * @author gndiw
 */
public class FrmCandidatePositionAssessment extends FRMHandler implements I_FRMInterface, I_FRMType {

    private CandidatePositionAssessment entCandidatePositionAssessment;
    public static final String FRM_NAME_CANDIDATE_POSITION_ASSESSMENT = "FRM_NAME_CANDIDATE_POSITION_ASSESSMENT";
    public static final int FRM_FIELD_CAND_POS_ASS_ID = 0;
    public static final int FRM_FIELD_CANDIDATE_MAIN_ID = 1;
    public static final int FRM_FIELD_POSITION_ID = 2;
    public static final int FRM_FIELD_ASSESSMENT_ID = 3;
    public static final int FRM_FIELD_SCORE_MIN = 4;
    public static final int FRM_FIELD_SCORE_MAX = 5;
    public static final int FRM_FIELD_BOBOT = 6;

    public static String[] fieldNames = {
        "FRM_FIELD_CAND_POS_ASS_ID",
        "FRM_FIELD_CANDIDATE_MAIN_ID",
        "FRM_FIELD_POSITION_ID",
        "FRM_FIELD_ASSESSMENT_ID",
        "FRM_FIELD_SCORE_MIN",
        "FRM_FIELD_SCORE_MAX",
        "FRM_FIELD_BOBOT"
    };

    public static int[] fieldTypes = {
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_INT,
        TYPE_INT,
        TYPE_INT
    };

    public FrmCandidatePositionAssessment() {
    }

    public FrmCandidatePositionAssessment(CandidatePositionAssessment entCandidatePositionAssessment) {
        this.entCandidatePositionAssessment = entCandidatePositionAssessment;
    }

    public FrmCandidatePositionAssessment(HttpServletRequest request, CandidatePositionAssessment entCandidatePositionAssessment) {
        super(new FrmCandidatePositionAssessment(entCandidatePositionAssessment), request);
        this.entCandidatePositionAssessment = entCandidatePositionAssessment;
    }

    public String getFormName() {
        return FRM_NAME_CANDIDATE_POSITION_ASSESSMENT;
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

    public CandidatePositionAssessment getEntityObject() {
        return entCandidatePositionAssessment;
    }

    public void requestEntityObject(CandidatePositionAssessment entCandidatePositionAssessment) {
        try {
            this.requestParam();
            entCandidatePositionAssessment.setCandidateMainId(getLong(FRM_FIELD_CANDIDATE_MAIN_ID));
            entCandidatePositionAssessment.setPositionId(getLong(FRM_FIELD_POSITION_ID));
            entCandidatePositionAssessment.setAssessmentId(getLong(FRM_FIELD_ASSESSMENT_ID));
            entCandidatePositionAssessment.setScoreMin(getInt(FRM_FIELD_SCORE_MIN));
            entCandidatePositionAssessment.setScoreMax(getInt(FRM_FIELD_SCORE_MAX));
            entCandidatePositionAssessment.setBobot(getInt(FRM_FIELD_BOBOT));
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }

}
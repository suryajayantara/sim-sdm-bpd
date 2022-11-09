/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.form.masterdata;

import com.dimata.harisma.entity.masterdata.PositionAssessmentRequired;
import com.dimata.qdep.form.FRMHandler;
import com.dimata.qdep.form.I_FRMInterface;
import com.dimata.qdep.form.I_FRMType;
import java.sql.Date;
import javax.servlet.http.HttpServletRequest;

/**
 *
 * @author gndiw
 */
public class FrmPositionAssessmentRequired extends FRMHandler implements I_FRMInterface, I_FRMType {

    private PositionAssessmentRequired entPositionAssessmentRequired;
    public static final String FRM_NAME_POSITION_ASSESSMENT_REQUIRED = "FRM_NAME_POSITION_ASSESSMENT_REQUIRED";
    public static final int FRM_FIELD_POS_COMP_REQ_ID = 0;
    public static final int FRM_FIELD_POSITION_ID = 1;
    public static final int FRM_FIELD_ASSESSMENT_ID = 2;
    public static final int FRM_FIELD_SCORE_REQ_MIN = 3;
    public static final int FRM_FIELD_SCORE_REQ_RECOMMENDED = 4;
    public static final int FRM_FIELD_NOTE = 5;
    public static final int FRM_FIELD_RE_TRAIN_OR_SERTFC_REQ = 6;
    public static final int FRM_FIELD_VALID_START = 7;
    public static final int FRM_FIELD_VALID_END = 8;
    public static String[] fieldNames = {
        "FRM_FIELD_POS_COMP_REQ_ID",
        "FRM_FIELD_POSITION_ID",
        "FRM_FIELD_ASSESSMENT_ID",
        "FRM_FIELD_SCORE_REQ_MIN",
        "FRM_FIELD_SCORE_REQ_RECOMMENDED",
        "FRM_FIELD_NOTE",
        "FRM_FIELD_RE_TRAIN_OR_SERTFC_REQ",
        "FRM_FIELD_VALID_START",
        "FRM_FIELD_VALID_END"
    };
    public static int[] fieldTypes = {
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_STRING,
        TYPE_INT,
        TYPE_STRING,
        TYPE_STRING
    };

    public FrmPositionAssessmentRequired() {
    }

    public FrmPositionAssessmentRequired(PositionAssessmentRequired entPositionAssessmentRequired) {
        this.entPositionAssessmentRequired = entPositionAssessmentRequired;
    }

    public FrmPositionAssessmentRequired(HttpServletRequest request, PositionAssessmentRequired entPositionAssessmentRequired) {
        super(new FrmPositionAssessmentRequired(entPositionAssessmentRequired), request);
        this.entPositionAssessmentRequired = entPositionAssessmentRequired;
    }

    public String getFormName() {
        return FRM_NAME_POSITION_ASSESSMENT_REQUIRED;
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

    public PositionAssessmentRequired getEntityObject() {
        return entPositionAssessmentRequired;
    }

    public void requestEntityObject(PositionAssessmentRequired entPositionAssessmentRequired) {
        try {
            this.requestParam();
            entPositionAssessmentRequired.setPositionId(getLong(FRM_FIELD_POSITION_ID));
            entPositionAssessmentRequired.setAssessmentId(getLong(FRM_FIELD_ASSESSMENT_ID));
            entPositionAssessmentRequired.setScoreReqMin(getFloat(FRM_FIELD_SCORE_REQ_MIN));
            entPositionAssessmentRequired.setScoreReqRecommended(getFloat(FRM_FIELD_SCORE_REQ_RECOMMENDED));
            entPositionAssessmentRequired.setNote(getString(FRM_FIELD_NOTE));
            entPositionAssessmentRequired.setReTrainOrSertfcReq(getInt(FRM_FIELD_RE_TRAIN_OR_SERTFC_REQ));
            entPositionAssessmentRequired.setValidStart(Date.valueOf(getString(FRM_FIELD_VALID_START)));
            entPositionAssessmentRequired.setValidEnd(Date.valueOf(getString(FRM_FIELD_VALID_END)));
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}

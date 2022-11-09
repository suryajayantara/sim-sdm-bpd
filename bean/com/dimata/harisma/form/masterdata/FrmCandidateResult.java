/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.form.masterdata;

import com.dimata.harisma.entity.masterdata.CandidateResult;
import com.dimata.qdep.form.FRMHandler;
import com.dimata.qdep.form.I_FRMInterface;
import com.dimata.qdep.form.I_FRMType;
import javax.servlet.http.HttpServletRequest;


/**
 *
 * @author gndiw
 */
public class FrmCandidateResult extends FRMHandler implements I_FRMInterface, I_FRMType {

    private CandidateResult entCandidateResult;
    public static final String FRM_NAME_CANDIDATE_RESULT = "FRM_NAME_CANDIDATE_RESULT";
    public static final int FRM_FIELD_CANDIDATE_RESULT_ID = 0;
    public static final int FRM_FIELD_CANDIDATE_MAIN_ID = 1;
    public static final int FRM_FIELD_EMPLOYEE_ID = 2;
    public static final int FRM_FIELD_POSITION_TYPE_ID = 3;

    public static String[] fieldNames = {
        "FRM_FIELD_CANDIDATE_RESULT_ID",
        "FRM_FIELD_CANDIDATE_MAIN_ID",
        "FRM_FIELD_EMPLOYEE_ID",
        "FRM_FIELD_POSITION_TYPE_ID"
    };

    public static int[] fieldTypes = {
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG
    };

    public FrmCandidateResult() {
    }

    public FrmCandidateResult(CandidateResult entCandidateResult) {
        this.entCandidateResult = entCandidateResult;
    }

    public FrmCandidateResult(HttpServletRequest request, CandidateResult entCandidateResult) {
        super(new FrmCandidateResult(entCandidateResult), request);
        this.entCandidateResult = entCandidateResult;
    }

    public String getFormName() {
        return FRM_NAME_CANDIDATE_RESULT;
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

    public CandidateResult getEntityObject() {
        return entCandidateResult;
    }

    public void requestEntityObject(CandidateResult entCandidateResult) {
        try {
            this.requestParam();
            entCandidateResult.setCandidateMainId(getLong(FRM_FIELD_CANDIDATE_MAIN_ID));
            entCandidateResult.setEmployeeId(getLong(FRM_FIELD_EMPLOYEE_ID));
            entCandidateResult.setPositionTypeId(getLong(FRM_FIELD_POSITION_TYPE_ID));
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }

}
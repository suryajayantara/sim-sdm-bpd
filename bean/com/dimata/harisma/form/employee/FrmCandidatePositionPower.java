/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.form.employee;

import com.dimata.harisma.entity.employee.CandidatePositionPower;
import com.dimata.qdep.form.FRMHandler;
import com.dimata.qdep.form.I_FRMInterface;
import com.dimata.qdep.form.I_FRMType;
import javax.servlet.http.HttpServletRequest;

/**
 *
 * @author gndiw
 */
public class FrmCandidatePositionPower extends FRMHandler implements I_FRMInterface, I_FRMType {

    private CandidatePositionPower entCandidatePositionPower;
    public static final String FRM_NAME_CANDIDATE_POSITION_POWER = "FRM_NAME_CANDIDATE_POSITION_POWER";
    public static final int FRM_FIELD_CANDIDATE_POSITION_POWER_ID = 0;
    public static final int FRM_FIELD_CANDIDATE_MAIN_ID = 1;
    public static final int FRM_FIELD_POSITION_ID = 2;
    public static final int FRM_FIELD_FIRST_POWER_CHARACTER_ID = 3;
    public static final int FRM_FIELD_SECOND_POWER_CHARACTER_ID = 4;

    public static String[] fieldNames = {
        "FRM_FIELD_CANDIDATE_POSITION_POWER_ID",
        "FRM_FIELD_CANDIDATE_MAIN_ID",
        "FRM_FIELD_POSITION_ID",
        "FRM_FIELD_FIRST_POWER_CHARACTER_ID",
        "FRM_FIELD_SECOND_POWER_CHARACTER_ID"
    };

    public static int[] fieldTypes = {
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG
    };

    public FrmCandidatePositionPower() {
    }

    public FrmCandidatePositionPower(CandidatePositionPower entCandidatePositionPower) {
        this.entCandidatePositionPower = entCandidatePositionPower;
    }

    public FrmCandidatePositionPower(HttpServletRequest request, CandidatePositionPower entCandidatePositionPower) {
        super(new FrmCandidatePositionPower(entCandidatePositionPower), request);
        this.entCandidatePositionPower = entCandidatePositionPower;
    }

    public String getFormName() {
        return FRM_NAME_CANDIDATE_POSITION_POWER;
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

    public CandidatePositionPower getEntityObject() {
        return entCandidatePositionPower;
    }

    public void requestEntityObject(CandidatePositionPower entCandidatePositionPower) {
        try {
            this.requestParam();
            entCandidatePositionPower.setCandidateMainId(getLong(FRM_FIELD_CANDIDATE_MAIN_ID));
            entCandidatePositionPower.setPositionId(getLong(FRM_FIELD_POSITION_ID));
            entCandidatePositionPower.setFirstPowerCharacterId(getLong(FRM_FIELD_FIRST_POWER_CHARACTER_ID));
            entCandidatePositionPower.setSecondPowerCharacterId(getLong(FRM_FIELD_SECOND_POWER_CHARACTER_ID));
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }

}

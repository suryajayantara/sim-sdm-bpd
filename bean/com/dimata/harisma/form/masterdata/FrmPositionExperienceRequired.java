/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.form.masterdata;

import com.dimata.harisma.entity.masterdata.PositionExperienceRequired;
import com.dimata.qdep.form.FRMHandler;
import com.dimata.qdep.form.I_FRMInterface;
import com.dimata.qdep.form.I_FRMType;
import javax.servlet.http.HttpServletRequest;
/**
 *
 * @author Acer
 */
public class FrmPositionExperienceRequired extends FRMHandler implements I_FRMInterface, I_FRMType {

    private PositionExperienceRequired entPositionExperienceRequired;
    public static final String FRM_NAME_POSITION_EXPERIENCE_REQUIRED = "FRM_NAME_POSITION_EXPERIENCE_REQUIRED";
    public static final int FRM_FIELD_POS_EXPERIENCE_REQ_ID = 0;
    public static final int FRM_FIELD_POSITION_ID = 1;
    public static final int FRM_FIELD_EXPERIENCE_ID = 2;
    public static final int FRM_FIELD_DURATION_MIN = 3;
    public static final int FRM_FIELD_DURATION_RECOMMENDED = 4;
    public static final int FRM_FIELD_NOTE = 5;
    public static String[] fieldNames = {
        "FRM_FIELD_POS_EDUCATION_REQ_ID",
        "FRM_FIELD_POSITION_ID",
        "FRM_FIELD_EDUCATION_ID",
        "FRM_FIELD_DURATION_MIN",
        "FRM_FIELD_DURATION_RECOMMENDED",
        "FRM_FIELD_NOTE"
    };
    public static int[] fieldTypes = {
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_INT,
        TYPE_INT,
        TYPE_STRING
    };

    public FrmPositionExperienceRequired() {
    }

    public FrmPositionExperienceRequired(PositionExperienceRequired entPositionExperienceRequired) {
        this.entPositionExperienceRequired = entPositionExperienceRequired;
    }

    public FrmPositionExperienceRequired(HttpServletRequest request, PositionExperienceRequired entPositionExperienceRequired) {
        super(new FrmPositionExperienceRequired(entPositionExperienceRequired), request);
        this.entPositionExperienceRequired = entPositionExperienceRequired;
    }

    public String getFormName() {
        return FRM_NAME_POSITION_EXPERIENCE_REQUIRED;
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

    public PositionExperienceRequired getEntityObject() {
        return entPositionExperienceRequired;
    }

    public void requestEntityObject(PositionExperienceRequired entPositionExperienceRequired) {
        try {
            this.requestParam();
            entPositionExperienceRequired.setPositionId(getLong(FRM_FIELD_POSITION_ID));
            entPositionExperienceRequired.setExperienceId(getLong(FRM_FIELD_EXPERIENCE_ID));
            entPositionExperienceRequired.setDurationMin(getInt(FRM_FIELD_DURATION_MIN));
            entPositionExperienceRequired.setDurationRecommended(getInt(FRM_FIELD_DURATION_RECOMMENDED));
            entPositionExperienceRequired.setNote(getString(FRM_FIELD_NOTE));
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}
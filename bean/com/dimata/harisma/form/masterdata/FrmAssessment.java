/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.form.masterdata;

import com.dimata.harisma.entity.masterdata.Assessment;
import com.dimata.qdep.form.FRMHandler;
import com.dimata.qdep.form.I_FRMInterface;
import com.dimata.qdep.form.I_FRMType;
import javax.servlet.http.HttpServletRequest;

/**
 *
 * @author gndiw
 */
public class FrmAssessment extends FRMHandler implements I_FRMInterface, I_FRMType {

    private Assessment entAssessment;
    public static final String FRM_NAME_ASSESSMENT = "FRM_NAME_ASSESSMENT";
    public static final int FRM_FIELD_ASSESSMENT_ID = 0;
    public static final int FRM_FIELD_ASSESSMENT_TYPE = 1;
    public static final int FRM_FIELD_DESCRIPTION = 2;

    public static String[] fieldNames = {
        "FRM_FIELD_ASSESSMENT_ID",
        "FRM_FIELD_ASSESSMENT_TYPE",
        "FRM_FIELD_DESCRIPTION"
    };

    public static int[] fieldTypes = {
        TYPE_LONG,
        TYPE_STRING,
        TYPE_STRING
    };

    public FrmAssessment() {
    }

    public FrmAssessment(Assessment entAssessment) {
        this.entAssessment = entAssessment;
    }

    public FrmAssessment(HttpServletRequest request, Assessment entAssessment) {
        super(new FrmAssessment(entAssessment), request);
        this.entAssessment = entAssessment;
    }

    public String getFormName() {
        return FRM_NAME_ASSESSMENT;
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

    public Assessment getEntityObject() {
        return entAssessment;
    }

    public void requestEntityObject(Assessment entAssessment) {
        try {
            this.requestParam();
            entAssessment.setAssessmentType(getString(FRM_FIELD_ASSESSMENT_TYPE));
            entAssessment.setDescription(getString(FRM_FIELD_DESCRIPTION));
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }

}
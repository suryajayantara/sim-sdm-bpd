/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.form.employee;

import com.dimata.harisma.entity.employee.EmpAssessment;
import com.dimata.qdep.form.FRMHandler;
import com.dimata.qdep.form.I_FRMInterface;
import com.dimata.qdep.form.I_FRMType;
import java.sql.Date;
import javax.servlet.http.HttpServletRequest;

/**
 *
 * @author gndiw
 */
public class FrmEmpAssessment extends FRMHandler implements I_FRMInterface, I_FRMType {

    private EmpAssessment entEmpAssessment;
    public static final String FRM_NAME_EMP_ASSESSMENT = "FRM_NAME_EMP_ASSESSMENT";
    public static final int FRM_FIELD_EMP_ASSESSMENT_ID = 0;
    public static final int FRM_FIELD_EMPLOYEE_ID = 1;
    public static final int FRM_FIELD_ASSESSMENT_ID = 2;
    public static final int FRM_FIELD_SCORE = 3;
    public static final int FRM_FIELD_DATE_OF_ASSESSMENT = 4;
    public static final int FRM_FIELD_REMARK = 5;

    public static String[] fieldNames = {
        "FRM_FIELD_EMP_ASSESSMENT_ID",
        "FRM_FIELD_EMPLOYEE_ID",
        "FRM_FIELD_ASSESSMENT_ID",
        "FRM_FIELD_SCORE",
        "FRM_FIELD_DATE_OF_ASSESSMENT",
        "FRM_FIELD_REMARK"
    };

    public static int[] fieldTypes = {
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_STRING,
        TYPE_STRING
    };

    public FrmEmpAssessment() {
    }

    public FrmEmpAssessment(EmpAssessment entEmpAssessment) {
        this.entEmpAssessment = entEmpAssessment;
    }

    public FrmEmpAssessment(HttpServletRequest request, EmpAssessment entEmpAssessment) {
        super(new FrmEmpAssessment(entEmpAssessment), request);
        this.entEmpAssessment = entEmpAssessment;
    }

    public String getFormName() {
        return FRM_NAME_EMP_ASSESSMENT;
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

    public EmpAssessment getEntityObject() {
        return entEmpAssessment;
    }

    public void requestEntityObject(EmpAssessment entEmpAssessment) {
        try {
            this.requestParam();
            entEmpAssessment.setEmployeeId(getLong(FRM_FIELD_EMPLOYEE_ID));
            entEmpAssessment.setAssessmentId(getLong(FRM_FIELD_ASSESSMENT_ID));
            entEmpAssessment.setScore(getDouble(FRM_FIELD_SCORE));
            entEmpAssessment.setDateOfAssessment(Date.valueOf(getString(FRM_FIELD_DATE_OF_ASSESSMENT)));
            entEmpAssessment.setRemark(getString(FRM_FIELD_REMARK));
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }

}
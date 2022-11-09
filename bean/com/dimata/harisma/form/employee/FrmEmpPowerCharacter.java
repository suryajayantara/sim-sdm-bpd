/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.form.employee;

import com.dimata.harisma.entity.employee.EmpPowerCharacter;
import com.dimata.qdep.form.FRMHandler;
import com.dimata.qdep.form.I_FRMInterface;
import com.dimata.qdep.form.I_FRMType;
import javax.servlet.http.HttpServletRequest;

/**
 *
 * @author gndiw
 */
public class FrmEmpPowerCharacter extends FRMHandler implements I_FRMInterface, I_FRMType {

    private EmpPowerCharacter entEmpPowerCharacter;
    public static final String FRM_NAME_EMP_POWER_CHARACTER = "FRM_NAME_EMP_POWER_CHARACTER";
    public static final int FRM_FIELD_EMP_POWER_CHARACTER_ID = 0;
    public static final int FRM_FIELD_POWER_CHARACTER_ID = 1;
    public static final int FRM_FIELD_EMPLOYEE_ID = 2;
    public static final int FRM_FIELD_INDEX = 3;
    public static final int FRM_FIELD_SECOND_POWER_CHARACTER_ID = 4;

    public static String[] fieldNames = {
        "FRM_FIELD_EMP_POWER_CHARACTER_ID",
        "FRM_FIELD_POWER_CHARACTER_ID",
        "FRM_FIELD_EMPLOYEE_ID",
        "FRM_FIELD_INDEX",
        "FRM_FIELD_SECOND_POWER_CHARACTER_ID"
    };

    public static int[] fieldTypes = {
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_INT,
        TYPE_LONG
    };

    public FrmEmpPowerCharacter() {
    }

    public FrmEmpPowerCharacter(EmpPowerCharacter entEmpPowerCharacter) {
        this.entEmpPowerCharacter = entEmpPowerCharacter;
    }

    public FrmEmpPowerCharacter(HttpServletRequest request, EmpPowerCharacter entEmpPowerCharacter) {
        super(new FrmEmpPowerCharacter(entEmpPowerCharacter), request);
        this.entEmpPowerCharacter = entEmpPowerCharacter;
    }

    public String getFormName() {
        return FRM_NAME_EMP_POWER_CHARACTER;
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

    public EmpPowerCharacter getEntityObject() {
        return entEmpPowerCharacter;
    }

    public void requestEntityObject(EmpPowerCharacter entEmpPowerCharacter) {
        try {
            this.requestParam();
            entEmpPowerCharacter.setPowerCharacterId(getLong(FRM_FIELD_POWER_CHARACTER_ID));
            entEmpPowerCharacter.setEmployeeId(getLong(FRM_FIELD_EMPLOYEE_ID));
            entEmpPowerCharacter.setIndex(getInt(FRM_FIELD_INDEX));
            entEmpPowerCharacter.setSecondCharacterId(getLong(FRM_FIELD_SECOND_POWER_CHARACTER_ID));
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }

}
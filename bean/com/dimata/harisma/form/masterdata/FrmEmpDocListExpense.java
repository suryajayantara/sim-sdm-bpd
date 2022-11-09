/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.form.masterdata;

import com.dimata.harisma.entity.masterdata.EmpDocListExpense;
import com.dimata.qdep.form.FRMHandler;
import com.dimata.qdep.form.I_FRMInterface;
import com.dimata.qdep.form.I_FRMType;
import javax.servlet.http.HttpServletRequest;

/**
 *
 * @author Gunadi
 */
public class FrmEmpDocListExpense extends FRMHandler implements I_FRMInterface, I_FRMType {

    private EmpDocListExpense entEmpDocListExpense;
    public static final String FRM_NAME_EMP_DOC_LIST_EXPENSE = "FRM_NAME_EMP_DOC_LIST_EXPENSE";
    public static final int FRM_FIELD_EMP_DOC_LIST_EXPENSE_ID = 0;
    public static final int FRM_FIELD_EMP_DOC_ID = 1;
    public static final int FRM_FIELD_EMPLOYEE_ID = 2;
    public static final int FRM_FIELD_COMPONENT_ID = 3;
    public static final int FRM_FIELD_DAY_LENGTH = 4;
    public static final int FRM_FIELD_COMP_VALUE = 5;
    public static String[] fieldNames = {
        "FRM_FIELD_EMP_DOC_LIST_EXPENSE_ID",
        "FRM_FIELD_EMP_DOC_ID",
        "FRM_FIELD_EMPLOYEE_ID",
        "FRM_FIELD_COMPONENT_ID",
        "FRM_FIELD_DAY_LENGTH",
        "FRM_FIELD_COMP_VALUE"
    };
    public static int[] fieldTypes = {
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_INT,
        TYPE_FLOAT
    };

    public FrmEmpDocListExpense() {
    }

    public FrmEmpDocListExpense(EmpDocListExpense entEmpDocListExpense) {
        this.entEmpDocListExpense = entEmpDocListExpense;
    }

    public FrmEmpDocListExpense(HttpServletRequest request, EmpDocListExpense entEmpDocListExpense) {
        super(new FrmEmpDocListExpense(entEmpDocListExpense), request);
        this.entEmpDocListExpense = entEmpDocListExpense;
    }

    public String getFormName() {
        return FRM_NAME_EMP_DOC_LIST_EXPENSE;
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

    public EmpDocListExpense getEntityObject() {
        return entEmpDocListExpense;
    }

    public void requestEntityObject(EmpDocListExpense entEmpDocListExpense) {
        try {
            this.requestParam();
            entEmpDocListExpense.setEmpDocId(getLong(FRM_FIELD_EMP_DOC_ID));
            entEmpDocListExpense.setEmployeeId(getLong(FRM_FIELD_EMPLOYEE_ID));
            entEmpDocListExpense.setComponentId(getLong(FRM_FIELD_COMPONENT_ID));
            entEmpDocListExpense.setDayLength(getInt(FRM_FIELD_DAY_LENGTH));
            entEmpDocListExpense.setCompValue(getDouble(FRM_FIELD_COMP_VALUE));
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}
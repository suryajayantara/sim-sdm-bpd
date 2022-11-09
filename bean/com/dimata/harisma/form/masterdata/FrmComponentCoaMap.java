/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.form.masterdata;

/**
 *
 * @author Dimata 007
 */
import com.dimata.harisma.entity.masterdata.ComponentCoaMap;
import com.dimata.qdep.form.FRMHandler;
import com.dimata.qdep.form.I_FRMInterface;
import com.dimata.qdep.form.I_FRMType;
import javax.servlet.http.HttpServletRequest;

public class FrmComponentCoaMap extends FRMHandler implements I_FRMInterface, I_FRMType {

    private ComponentCoaMap entComponentCoaMap;
    public static final String FRM_NAME_COMPONENT_COA_MAP = "FRM_NAME_COMPONENT_COA_MAP";
    public static final int FRM_FIELD_COMPONENT_COA_MAP_ID = 0;
    public static final int FRM_FIELD_FORMULA = 1;
    public static final int FRM_FIELD_GEN_ID = 2;
    public static final int FRM_FIELD_DIVISION_ID = 3;
    public static final int FRM_FIELD_DEPARTMENT_ID = 4;
    public static final int FRM_FIELD_SECTION_ID = 5;
    public static final int FRM_FIELD_ID_PERKIRAAN = 6;
    public static final int FRM_FIELD_FORMULA_MINUS = 7;
    public static final int FRM_FIELD_NO_REKENING = 8;
    public static String[] fieldNames = {
        "FRM_FIELD_COMPONENT_COA_MAP_ID",
        "FRM_FIELD_FORMULA",
        "FRM_FIELD_GEN_ID",
        "FRM_FIELD_DIVISION_ID",
        "FRM_FIELD_DEPARTMENT_ID",
        "FRM_FIELD_SECTION_ID",
        "FRM_FIELD_ID_PERKIRAAN",
        "FRM_FIELD_FORMULA_MINUS",
        "FRM_FIELD_NO_REKENING"
    };
    public static int[] fieldTypes = {
        TYPE_LONG,
        TYPE_STRING,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_STRING
    };

    public FrmComponentCoaMap() {
    }

    public FrmComponentCoaMap(ComponentCoaMap entComponentCoaMap) {
        this.entComponentCoaMap = entComponentCoaMap;
    }

    public FrmComponentCoaMap(HttpServletRequest request, ComponentCoaMap entComponentCoaMap) {
        super(new FrmComponentCoaMap(entComponentCoaMap), request);
        this.entComponentCoaMap = entComponentCoaMap;
    }

    public String getFormName() {
        return FRM_NAME_COMPONENT_COA_MAP;
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

    public ComponentCoaMap getEntityObject() {
        return entComponentCoaMap;
    }

    public void requestEntityObject(ComponentCoaMap entComponentCoaMap) {
        try {
            this.requestParam();
            entComponentCoaMap.setFormula(getString(FRM_FIELD_FORMULA));
            entComponentCoaMap.setGenId(getLong(FRM_FIELD_GEN_ID));
            entComponentCoaMap.setDivisionId(getLong(FRM_FIELD_DIVISION_ID));
            entComponentCoaMap.setDepartmentId(getLong(FRM_FIELD_DEPARTMENT_ID));
            entComponentCoaMap.setSectionId(getLong(FRM_FIELD_SECTION_ID));
            entComponentCoaMap.setIdPerkiraan(getLong(FRM_FIELD_ID_PERKIRAAN));
            entComponentCoaMap.setFormulaMin(getString(FRM_FIELD_FORMULA_MINUS));
            entComponentCoaMap.setNoRekening(getString(FRM_FIELD_NO_REKENING));
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}
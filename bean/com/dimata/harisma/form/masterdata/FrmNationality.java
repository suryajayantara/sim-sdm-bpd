/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.form.masterdata;

import com.dimata.harisma.entity.masterdata.Nationality;
import com.dimata.qdep.form.FRMHandler;
import com.dimata.qdep.form.I_FRMInterface;
import com.dimata.qdep.form.I_FRMType;
import javax.servlet.http.HttpServletRequest;

/**
 *
 * @author ARYS
 */
public class FrmNationality extends FRMHandler implements I_FRMInterface, I_FRMType {
   
    private Nationality entNationality;
    public static final String FRM_NAME_NATIONALITY = "FRM_NAME_NATIONALITY";
    public static final int FRM_FIELD_NATIONALITY_ID = 0;
    public static final int FRM_FIELD_NATIONALITY_CODE = 1;
    public static final int FRM_FIELD_NATIONALITY_NAME = 2;
    public static final int FRM_FIELD_NATIONALITY_TYPE = 3;
    public static String[] fieldNames = {
        "FRM_FIELD_NATIONALITY_ID",
        "FRM_FIELD_NATIONALITY_CODE",
        "FRM_FIELD_NATIONALITY_NAME",
        "FRM_FIELD_NATIONALITY_TYPE"
    };
    public static int[] fieldTypes = {
        TYPE_LONG,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_INT
    };

    public FrmNationality() {
    }

    public FrmNationality(Nationality entNationality) {
        this.entNationality = entNationality;
    }

    public FrmNationality(HttpServletRequest request, Nationality entNationality) {
        super(new FrmNationality(entNationality), request);
        this.entNationality = entNationality;
    }

    public String getFormName() {
        return FRM_NAME_NATIONALITY;
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

    public Nationality getEntityObject() {
        return entNationality;
    }

    public void requestEntityObject(Nationality entNationality) {
        try {
            this.requestParam();
            entNationality.setNationalityCode(getString(FRM_FIELD_NATIONALITY_CODE));
            entNationality.setNationalityName(getString(FRM_FIELD_NATIONALITY_NAME));
            entNationality.setNationalityType(getInt(FRM_FIELD_NATIONALITY_TYPE));
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }

}

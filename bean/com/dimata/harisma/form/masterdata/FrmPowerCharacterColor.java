/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.form.masterdata;

import com.dimata.harisma.entity.masterdata.PowerCharacterColor;
import com.dimata.qdep.form.FRMHandler;
import com.dimata.qdep.form.I_FRMInterface;
import com.dimata.qdep.form.I_FRMType;
import javax.servlet.http.HttpServletRequest;

/**
 *
 * @author gndiw
 */
public class FrmPowerCharacterColor extends FRMHandler implements I_FRMInterface, I_FRMType {

    private PowerCharacterColor entPowerCharacterColor;
    public static final String FRM_NAME_POWERCHARACTERCOLOR = "FRM_NAME_POWERCHARACTERCOLOR";
    public static final int FRM_FIELD_POWER_CHARACTER_COLOR_ID = 0;
    public static final int FRM_FIELD_COLOR_NAME = 1;
    public static final int FRM_FIELD_COLOR_HEX = 2;

    public static String[] fieldNames = {
        "FRM_FIELD_POWER_CHARACTER_COLOR_ID",
        "FRM_FIELD_COLOR_NAME",
        "FRM_FIELD_COLOR_HEX"
    };

    public static int[] fieldTypes = {
        TYPE_LONG,
        TYPE_STRING,
        TYPE_STRING
    };

    public FrmPowerCharacterColor() {
    }

    public FrmPowerCharacterColor(PowerCharacterColor entPowerCharacterColor) {
        this.entPowerCharacterColor = entPowerCharacterColor;
    }

    public FrmPowerCharacterColor(HttpServletRequest request, PowerCharacterColor entPowerCharacterColor) {
        super(new FrmPowerCharacterColor(entPowerCharacterColor), request);
        this.entPowerCharacterColor = entPowerCharacterColor;
    }

    public String getFormName() {
        return FRM_NAME_POWERCHARACTERCOLOR;
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

    public PowerCharacterColor getEntityObject() {
        return entPowerCharacterColor;
    }

    public void requestEntityObject(PowerCharacterColor entPowerCharacterColor) {
        try {
            this.requestParam();
            entPowerCharacterColor.setColorName(getString(FRM_FIELD_COLOR_NAME));
            entPowerCharacterColor.setColorHex(getString(FRM_FIELD_COLOR_HEX));
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }

}

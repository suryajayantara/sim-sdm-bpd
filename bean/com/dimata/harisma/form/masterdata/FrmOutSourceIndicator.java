/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.form.masterdata;

/**
 *
 * @author Acer
 */
import com.dimata.harisma.entity.masterdata.OutSourceIndicator;
import com.dimata.qdep.form.FRMHandler;
import com.dimata.qdep.form.I_FRMInterface;
import com.dimata.qdep.form.I_FRMType;
import javax.servlet.http.HttpServletRequest;

public class FrmOutSourceIndicator extends FRMHandler implements I_FRMInterface, I_FRMType {

    private OutSourceIndicator entOutSourceIndicator;
    public static final String FRM_NAME_OUTSOURCEINDICATOR = "FRM_NAME_OUTSOURCEINDICATOR";
    public static final int FRM_FIELD_OUT_INDICATOR_ID = 0;
    public static final int FRM_FIELD_INDICATOR_NAME = 1;

    public static String[] fieldNames = {
        "FRM_FIELD_OUT_INDICATOR_ID",
        "FRM_FIELD_INDICATOR_NAME"
    };

    public static int[] fieldTypes = {
        TYPE_LONG,
        TYPE_STRING
    };

    public FrmOutSourceIndicator() {
    }

    public FrmOutSourceIndicator(OutSourceIndicator entOutSourceIndicator) {
        this.entOutSourceIndicator = entOutSourceIndicator;
    }

    public FrmOutSourceIndicator(HttpServletRequest request, OutSourceIndicator entOutSourceIndicator) {
        super(new FrmOutSourceIndicator(entOutSourceIndicator), request);
        this.entOutSourceIndicator = entOutSourceIndicator;
    }

    public String getFormName() {
        return FRM_NAME_OUTSOURCEINDICATOR;
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

    public OutSourceIndicator getEntityObject() {
        return entOutSourceIndicator;
    }

    public void requestEntityObject(OutSourceIndicator entOutSourceIndicator) {
        try {
            this.requestParam();
            entOutSourceIndicator.setIndicatorName(getString(FRM_FIELD_INDICATOR_NAME));
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }

}

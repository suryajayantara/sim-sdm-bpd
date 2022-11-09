/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.form.masterdata;

import com.dimata.harisma.entity.masterdata.PositionTypeMapping;
import com.dimata.qdep.form.FRMHandler;
import com.dimata.qdep.form.I_FRMInterface;
import com.dimata.qdep.form.I_FRMType;
import javax.servlet.http.HttpServletRequest;

/**
 *
 * @author gndiw
 */
public class FrmPositionTypeMapping extends FRMHandler implements I_FRMInterface, I_FRMType {

    private PositionTypeMapping entPositionTypeMapping;
    public static final String FRM_NAME_POSITION_TYPE_MAPPING = "FRM_NAME_POSITION_TYPE_MAPPING";
    public static final int FRM_FIELD_POSITION_TYPE_MAPPING_ID = 0;
    public static final int FRM_FIELD_LEVEL_ID = 1;
    public static final int FRM_FIELD_POSITION_TYPE_ID = 2;

    public static String[] fieldNames = {
        "FRM_FIELD_POSITION_TYPE_MAPPING_ID",
        "FRM_FIELD_LEVEL_ID",
        "FRM_FIELD_POSITION_TYPE_ID"
    };

    public static int[] fieldTypes = {
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG
    };

    public FrmPositionTypeMapping() {
    }

    public FrmPositionTypeMapping(PositionTypeMapping entPositionTypeMapping) {
        this.entPositionTypeMapping = entPositionTypeMapping;
    }

    public FrmPositionTypeMapping(HttpServletRequest request, PositionTypeMapping entPositionTypeMapping) {
        super(new FrmPositionTypeMapping(entPositionTypeMapping), request);
        this.entPositionTypeMapping = entPositionTypeMapping;
    }

    public String getFormName() {
        return FRM_NAME_POSITION_TYPE_MAPPING;
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

    public PositionTypeMapping getEntityObject() {
        return entPositionTypeMapping;
    }

    public void requestEntityObject(PositionTypeMapping entPositionTypeMapping) {
        try {
            this.requestParam();
            entPositionTypeMapping.setLevelId(getLong(FRM_FIELD_LEVEL_ID));
            entPositionTypeMapping.setPositionTypeId(getLong(FRM_FIELD_POSITION_TYPE_ID));
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }

}
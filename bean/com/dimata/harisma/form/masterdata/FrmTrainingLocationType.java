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
import com.dimata.harisma.entity.masterdata.TrainingLocationType;
import com.dimata.qdep.form.FRMHandler;
import com.dimata.qdep.form.I_FRMInterface;
import com.dimata.qdep.form.I_FRMType;
import javax.servlet.http.HttpServletRequest;

public class FrmTrainingLocationType extends FRMHandler implements I_FRMInterface, I_FRMType {

    private TrainingLocationType entTrainingLocationType;
    public static final String FRM_NAME_TRAININGLOCATIONTYPE = "FRM_NAME_TRAININGLOCATIONTYPE";
    public static final int FRM_FIELD_TRAINING_LOCATION_TYPE_ID = 0;
    public static final int FRM_FIELD_LOCATIONNAME = 1;
    public static final int FRM_FIELD_DESCRIPTION = 2;

    public static String[] fieldNames = {
        "FRM_FIELD_TRAINING_LOCATION_TYPE_ID",
        "FRM_FIELD_LOCATIONNAME",
        "FRM_FIELD_DESCRIPTION"
    };

    public static int[] fieldTypes = {
        TYPE_LONG,
        TYPE_STRING,
        TYPE_STRING
    };

    public FrmTrainingLocationType() {
    }

    public FrmTrainingLocationType(TrainingLocationType entTrainingLocationType) {
        this.entTrainingLocationType = entTrainingLocationType;
    }

    public FrmTrainingLocationType(HttpServletRequest request, TrainingLocationType entTrainingLocationType) {
        super(new FrmTrainingLocationType(entTrainingLocationType), request);
        this.entTrainingLocationType = entTrainingLocationType;
    }

    public String getFormName() {
        return FRM_NAME_TRAININGLOCATIONTYPE;
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

    public TrainingLocationType getEntityObject() {
        return entTrainingLocationType;
    }

    public void requestEntityObject(TrainingLocationType entTrainingLocationType) {
        try {
            this.requestParam();
            entTrainingLocationType.setLocationName(getString(FRM_FIELD_LOCATIONNAME));
            entTrainingLocationType.setDescription(getString(FRM_FIELD_DESCRIPTION));
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }

}

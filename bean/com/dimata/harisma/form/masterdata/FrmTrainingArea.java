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
import com.dimata.harisma.entity.masterdata.TrainingArea;
import com.dimata.qdep.form.FRMHandler;
import com.dimata.qdep.form.I_FRMInterface;
import com.dimata.qdep.form.I_FRMType;
import javax.servlet.http.HttpServletRequest;

public class FrmTrainingArea extends FRMHandler implements I_FRMInterface, I_FRMType {

    private TrainingArea entTrainingArea;
    public static final String FRM_NAME_TRAININGAREA = "FRM_NAME_TRAININGAREA";
    public static final int FRM_FIELD_TRAINING_AREA_ID = 0;
    public static final int FRM_FIELD_AREA_NAME = 1;
    public static final int FRM_FIELD_DESCRIPTION = 2;

    public static String[] fieldNames = {
        "FRM_FIELD_TRAINING_AREA_ID",
        "FRM_FIELD_AREA_NAME",
        "FRM_FIELD_DESCRIPTION"
    };

    public static int[] fieldTypes = {
        TYPE_LONG,
        TYPE_STRING,
        TYPE_STRING
    };

    public FrmTrainingArea() {
    }

    public FrmTrainingArea(TrainingArea entTrainingArea) {
        this.entTrainingArea = entTrainingArea;
    }

    public FrmTrainingArea(HttpServletRequest request, TrainingArea entTrainingArea) {
        super(new FrmTrainingArea(entTrainingArea), request);
        this.entTrainingArea = entTrainingArea;
    }

    public String getFormName() {
        return FRM_NAME_TRAININGAREA;
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

    public TrainingArea getEntityObject() {
        return entTrainingArea;
    }

    public void requestEntityObject(TrainingArea entTrainingArea) {
        try {
            this.requestParam();
            entTrainingArea.setAreaName(getString(FRM_FIELD_AREA_NAME));
            entTrainingArea.setDescription(getString(FRM_FIELD_DESCRIPTION));
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }

}

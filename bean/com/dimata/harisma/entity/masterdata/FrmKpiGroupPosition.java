/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.masterdata;

import com.dimata.qdep.form.FRMHandler;
import com.dimata.qdep.form.I_FRMInterface;
import com.dimata.qdep.form.I_FRMType;
import javax.servlet.http.HttpServletRequest;

/**
 *
 * @author keys
 */
public class FrmKpiGroupPosition extends FRMHandler implements I_FRMInterface, I_FRMType {
     private KpiGroupPosition entKpiGroupPosition;
    
  public static final String FRM_KPI_GROUP_POSITION = "FRM_KPI_GROUP_POSITION";
  public static final int FRM_FIELD_KPI_GROUP_DIVISON_ID = 0;
  public static final int FRM_FIELD_KPI_GROUP_ID = 1;
  public static final int FRM_FIELD_POSITION_ID= 2;


public static String[] fieldNames = {
    "FRM_FIELD_KPI_GROUP_DIVISON_ID",
    "FRM_FIELD_KPI_GROUP_ID",
    "FRM_FIELD_POSITION_ID"
};

public static int[] fieldTypes = {
    TYPE_LONG,
    TYPE_LONG,
    TYPE_LONG
};

public FrmKpiGroupPosition() {
}

public FrmKpiGroupPosition(KpiGroupPosition entKpiGroupPosition) {
   this.entKpiGroupPosition = entKpiGroupPosition;
}

public FrmKpiGroupPosition(HttpServletRequest request, KpiGroupPosition entKpiGroupPosition) {
   super(new FrmKpiGroupPosition(entKpiGroupPosition), request);
   this.entKpiGroupPosition = entKpiGroupPosition;
}

public String getFormName() {
   return FRM_KPI_GROUP_POSITION;
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

public KpiGroupPosition getEntityObject() {
   return entKpiGroupPosition;
}

public void requestEntityObject(KpiGroupPosition entKpiGroupPosition) {
   try {
        this.requestParam();
        entKpiGroupPosition.setKpiGroupPositionId(getLong(FRM_FIELD_KPI_GROUP_DIVISON_ID));
        entKpiGroupPosition.setKpiGroupId(getLong(FRM_FIELD_KPI_GROUP_ID));
        entKpiGroupPosition.setPositionId(getLong(FRM_FIELD_POSITION_ID));
   } catch (Exception e) {
        System.out.println("Error on requestEntityObject : " + e.toString());
   }
} 
}

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.form.masterdata;

/**
 *
 * @author keys
 */
import com.dimata.harisma.entity.masterdata.EmpDocCompMap;
import com.dimata.qdep.form.FRMHandler;
import com.dimata.qdep.form.I_FRMInterface;
import com.dimata.qdep.form.I_FRMType;
import javax.servlet.http.HttpServletRequest;

public class FrmEmpDocCompMap extends FRMHandler implements I_FRMInterface, I_FRMType {
  private EmpDocCompMap entEmpDocCompMap;
  public static final String FRM_NAME_EMPDOCCOMPMAP = "FRM_NAME_EMPDOCCOMPMAP";
  public static final int FRM_FIELD_DOC_COMP_MAP_ID = 0;
  public static final int FRM_FIELD_DOC_MASTER_ID = 1;
  public static final int FRM_FIELD_COMPONENT_ID = 2;
  public static final int FRM_FIELD_DAY_LENGTH = 3;
  public static final int FRM_FIELD_PERIOD_ID = 4;


public static String[] fieldNames = {
    "FRM_FIELD_DOC_COMP_MAP_ID",
    "FRM_FIELD_DOC_MASTER_ID",
    "FRM_FIELD_COMPONENT_ID",
    "FRM_FIELD_DAY_LENGTH",
    "FRM_FIELD_PERIOD_ID"
};

public static int[] fieldTypes = {
    TYPE_LONG,
    TYPE_LONG,
    TYPE_LONG,
    TYPE_INT,
    TYPE_LONG
};

public FrmEmpDocCompMap() {
}

public FrmEmpDocCompMap(EmpDocCompMap entEmpDocCompMap) {
   this.entEmpDocCompMap = entEmpDocCompMap;
}

public FrmEmpDocCompMap(HttpServletRequest request, EmpDocCompMap entEmpDocCompMap) {
   super(new FrmEmpDocCompMap(entEmpDocCompMap), request);
   this.entEmpDocCompMap = entEmpDocCompMap;
}

public String getFormName() {
   return FRM_NAME_EMPDOCCOMPMAP;
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

public EmpDocCompMap getEntityObject() {
   return entEmpDocCompMap;
}

public void requestEntityObject(EmpDocCompMap entEmpDocCompMap) {
   try {
        this.requestParam();
        entEmpDocCompMap.setOID(getLong(FRM_FIELD_DOC_COMP_MAP_ID));
        entEmpDocCompMap.setDocMasterId(getLong(FRM_FIELD_DOC_MASTER_ID));
        entEmpDocCompMap.setComponentId(getLong(FRM_FIELD_COMPONENT_ID));
        entEmpDocCompMap.setDayLength(getInt(FRM_FIELD_DAY_LENGTH));
        entEmpDocCompMap.setPeriodId(getLong(FRM_FIELD_PERIOD_ID));
   } catch (Exception e) {
        System.out.println("Error on requestEntityObject : " + e.toString());
   }
}

}
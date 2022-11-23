/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.form.masterdata;

import com.dimata.harisma.entity.masterdata.KpiSettingType;
import com.dimata.qdep.form.FRMHandler;
import com.dimata.qdep.form.I_FRMInterface;
import com.dimata.qdep.form.I_FRMType;
import java.util.Vector;
import javax.servlet.http.HttpServletRequest;

public class FrmKpiSettingType extends FRMHandler implements I_FRMInterface, I_FRMType {
        /**
     * @return the vOidKpiType
     */
    public Vector <Long> getvOidKpiType() {
        return vOidKpiType;
    }
  private KpiSettingType entKpiSettingType;
  private Vector <Long> vOidKpiType = null;
  public static final String FRM_NAME_KPISETTINGTYPE = "FRM_NAME_KPISETTINGTYPE";
  public static final int FRM_FIELD_KPI_SETTING_TYPE_ID = 0;
  public static final int FRM_FIELD_KPI_SETTING_ID = 1;
  public static final int FRM_FIELD_KPI_TYPE_ID = 2;
  public static final int FRM_FIELD_KPI_GROUP_ID = 3;


public static String[] fieldNames = {
    "FRM_FIELD_KPI_SETTING_TYPE_ID",
    "FRM_FIELD_KPI_SETTING_ID",
    "FRM_FIELD_KPI_TYPE_ID",
    "FRM_FIELD_KPI_GROUP_ID"
};

public static int[] fieldTypes = {
    TYPE_LONG,
    TYPE_LONG,
    TYPE_VECTOR_LONG,
    TYPE_LONG,
};

public FrmKpiSettingType() {
}

public FrmKpiSettingType(KpiSettingType entKpiSettingType) {
   this.entKpiSettingType = entKpiSettingType;
}

public FrmKpiSettingType(HttpServletRequest request, KpiSettingType entKpiSettingType) {
   super(new FrmKpiSettingType(entKpiSettingType), request);
   this.entKpiSettingType = entKpiSettingType;
}

public String getFormName() {
   return FRM_NAME_KPISETTINGTYPE;
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

public KpiSettingType getEntityObject() {
   return entKpiSettingType;
}

public void requestEntityObject(KpiSettingType entKpiSettingType) {
   try {
        this.requestParam();
        entKpiSettingType.setKpiSettingTypeId(getLong(FRM_FIELD_KPI_SETTING_TYPE_ID));
        entKpiSettingType.setKpiSettingId(getLong(FRM_FIELD_KPI_SETTING_ID));
        vOidKpiType = getVectorLong(fieldNames[FRM_FIELD_KPI_TYPE_ID]);
   } catch (Exception e) {
        System.out.println("Error on requestEntityObject : " + e.toString());
   }
}

}
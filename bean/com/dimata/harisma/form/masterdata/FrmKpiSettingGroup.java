/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.form.masterdata;

/**
 *
 * @author User
 */
import com.dimata.harisma.entity.masterdata.KpiSettingGroup;
import com.dimata.qdep.form.FRMHandler;
import com.dimata.qdep.form.I_FRMInterface;
import com.dimata.qdep.form.I_FRMType;
import java.util.Vector;
import javax.servlet.http.HttpServletRequest;

public class FrmKpiSettingGroup extends FRMHandler implements I_FRMInterface, I_FRMType {
  public Vector <Long> getvOidKpiGroup() {
        return vOidKpiGroup;
    }
  private KpiSettingGroup entKpiSettingGroup;
  private Vector <Long> vOidKpiGroup = null;
  public static final String FRM_NAME_KPISETTINGGROUP = "FRM_NAME_KPISETTINGGROUP";
  public static final int FRM_FIELD_KPI_SETTING_GROUP_ID = 0;
  public static final int FRM_FIELD_KPI_SETTING_ID = 1;
  public static final int FRM_FIELD_KPI_GROUP_ID = 2;


public static String[] fieldNames = {
    "FRM_FIELD_KPI_SETTING_GROUP_ID",
    "FRM_FIELD_KPI_SETTING_ID",
    "FRM_FIELD_KPI_GROUP_ID"
};

public static int[] fieldTypes = {
    TYPE_LONG,
    TYPE_LONG,
    TYPE_VECTOR_LONG
};

public FrmKpiSettingGroup() {
}

public FrmKpiSettingGroup(KpiSettingGroup entKpiSettingGroup) {
   this.entKpiSettingGroup = entKpiSettingGroup;
}

public FrmKpiSettingGroup(HttpServletRequest request, KpiSettingGroup entKpiSettingGroup) {
   super(new FrmKpiSettingGroup(entKpiSettingGroup), request);
   this.entKpiSettingGroup = entKpiSettingGroup;
}

public String getFormName() {
   return FRM_NAME_KPISETTINGGROUP;
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

public KpiSettingGroup getEntityObject() {
   return entKpiSettingGroup;
}

public void requestEntityObject(KpiSettingGroup entKpiSettingGroup) {
   try {
        this.requestParam();
        entKpiSettingGroup.setKpiSettingGroupId(getLong(FRM_FIELD_KPI_SETTING_GROUP_ID));
        entKpiSettingGroup.setKpiSettingId(getLong(FRM_FIELD_KPI_SETTING_ID));
        vOidKpiGroup = getVectorLong(fieldNames[FRM_FIELD_KPI_GROUP_ID]);
   } catch (Exception e) {
        System.out.println("Error on requestEntityObject : " + e.toString());
   }
}

}
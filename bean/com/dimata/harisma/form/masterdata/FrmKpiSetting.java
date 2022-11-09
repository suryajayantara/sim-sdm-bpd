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
import com.dimata.harisma.entity.masterdata.KpiSetting;
import com.dimata.harisma.entity.masterdata.KpiSettingPosition;
import com.dimata.qdep.form.FRMHandler;
import com.dimata.qdep.form.I_FRMInterface;
import com.dimata.qdep.form.I_FRMType;
import com.dimata.util.Formater;
import java.util.Vector;
import javax.servlet.http.HttpServletRequest;

public class FrmKpiSetting extends FRMHandler implements I_FRMInterface, I_FRMType {



    /**
     * @return the vOidPosition
     */
    public Vector <Long> getvOidPosition() {
        return vOidPosition;
    }
  private KpiSetting entKpiSetting;
  private Vector <Long> vOidPosition = null;
  public static final String FRM_NAME_KPISETTING = "FRM_NAME_KPISETTING";
  public static final int FRM_FIELD_KPI_SETTING_ID = 0;
  public static final int FRM_FIELD_VALID_DATE = 1;
  public static final int FRM_FIELD_STATUS = 2;
  public static final int FRM_FIELD_START_DATE = 3;
  public static final int FRM_FIELD_COMPANY_ID = 4;
  public static final int FRM_FIELD_POSITION_ID = 5;
  public static final int FRM_FIELD_TAHUN = 6;
  


public static String[] fieldNames = {
    "FRM_FIELD_KPI_SETTING_ID",
    "FRM_FIELD_VALID_DATE",
    "FRM_FIELD_STATUS",
    "FRM_FIELD_START_DATE",
    "FRM_FIELD_COMPANY_ID",
    "FRM_FIELD_POSITION_ID",
    "FRM_FIELD_TAHUN"

};

public static int[] fieldTypes = {
    TYPE_LONG,
    TYPE_STRING,
    TYPE_INT,
    TYPE_STRING,
    TYPE_LONG,
    TYPE_VECTOR_LONG,
    TYPE_INT
    
};

public FrmKpiSetting() {
}

public FrmKpiSetting(KpiSetting entKpiSetting) {
   this.entKpiSetting = entKpiSetting;
}

public FrmKpiSetting(HttpServletRequest request, KpiSetting entKpiSetting) {
   super(new FrmKpiSetting(entKpiSetting), request);
   this.entKpiSetting = entKpiSetting;
}

public String getFormName() {
   return FRM_NAME_KPISETTING;
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

public KpiSetting getEntityObject() {
   return entKpiSetting;
}

public void requestEntityObject(KpiSetting entKpiSetting) {
   try {
        this.requestParam();
        entKpiSetting.setKpiSettingId(getLong(FRM_FIELD_KPI_SETTING_ID));
        
        String startDate = getString(FRM_FIELD_VALID_DATE);
        entKpiSetting.setValidDate(Formater.formatDate(startDate, "yyyy-MM-dd"));  
        
        entKpiSetting.setStatus(getInt(FRM_FIELD_STATUS));
        
        String validDate = getString(FRM_FIELD_START_DATE);
        entKpiSetting.setStartDate(Formater.formatDate(validDate, "yyyy-MM-dd"));
        vOidPosition = getVectorLong(fieldNames[FRM_FIELD_POSITION_ID]);
        
        entKpiSetting.setCompanyId(getLong(FRM_FIELD_COMPANY_ID));
        entKpiSetting.setTahun(getInt(FRM_FIELD_TAHUN));
   } catch (Exception e) {
        System.out.println("Error on requestEntityObject : " + e.toString());
   }
}

}

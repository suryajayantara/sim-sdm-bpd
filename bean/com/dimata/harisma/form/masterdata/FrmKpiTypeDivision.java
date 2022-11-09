/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.form.masterdata;

import com.dimata.harisma.entity.masterdata.KpiTypeDivision;
import com.dimata.qdep.form.FRMHandler;
import com.dimata.qdep.form.I_FRMInterface;
import com.dimata.qdep.form.I_FRMType;
import static com.dimata.qdep.form.I_FRMType.TYPE_LONG;
import javax.servlet.http.HttpServletRequest;

/**
 *
 * @author User
 */
public class FrmKpiTypeDivision extends FRMHandler implements I_FRMInterface, I_FRMType {
    private KpiTypeDivision entKpiTypeDivision;
  public static final String FRM_NAME_KPITYPEDIVISION = "FRM_NAME_KPITYPEDIVISION";
  public static final int FRM_FIELD_KPI_TYPE_DIVISION_ID = 0;
  public static final int FRM_FIELD_KPI_TYPE_ID = 1;
  public static final int FRM_FIELD_DIVISION_ID = 2;


public static String[] fieldNames = {
    "FRM_FIELD_KPI_TYPE_DIVISION_ID",
    "FRM_FIELD_KPI_TYPE_ID",
    "FRM_FIELD_DIVISION_ID"
};

public static int[] fieldTypes = {
    TYPE_LONG,
    TYPE_LONG,
    TYPE_LONG
};

public FrmKpiTypeDivision() {
}

public FrmKpiTypeDivision(KpiTypeDivision entKpiTypeDivision) {
   this.entKpiTypeDivision = entKpiTypeDivision;
}

public FrmKpiTypeDivision(HttpServletRequest request, KpiTypeDivision entKpiTypeDivision) {
   super(new FrmKpiTypeDivision(entKpiTypeDivision), request);
   this.entKpiTypeDivision = entKpiTypeDivision;
}

public String getFormName() {
   return FRM_NAME_KPITYPEDIVISION;
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

public KpiTypeDivision getEntityObject() {
   return entKpiTypeDivision;
}

public void requestEntityObject(KpiTypeDivision entKpiTypeDivision) {
   try {
        this.requestParam();
        entKpiTypeDivision.setKpiTypeDivisionId(getLong(FRM_FIELD_KPI_TYPE_DIVISION_ID));
        entKpiTypeDivision.setOID(getLong(FRM_FIELD_KPI_TYPE_ID));
        entKpiTypeDivision.setDivisionId(getLong(FRM_FIELD_DIVISION_ID));
   } catch (Exception e) {
        System.out.println("Error on requestEntityObject : " + e.toString());
   }
}

}


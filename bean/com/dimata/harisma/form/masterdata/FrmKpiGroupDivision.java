/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.form.masterdata;

import com.dimata.harisma.entity.masterdata.KpiGroupDivision;
import com.dimata.qdep.form.FRMHandler;
import com.dimata.qdep.form.I_FRMInterface;
import com.dimata.qdep.form.I_FRMType;
import static com.dimata.qdep.form.I_FRMType.TYPE_LONG;
import javax.servlet.http.HttpServletRequest;

/**
 *
 * @author keys
 */
public class FrmKpiGroupDivision extends FRMHandler implements I_FRMInterface, I_FRMType  {
    private KpiGroupDivision entKpiGroupDivision;
    
  public static final String FRM_KPI_GROUP_DIVISION = "FRM_KPI_GROUP_DIVISION";
  public static final int FRM_FIELD_KPI_GROUP_DIVISON_ID = 0;
  public static final int FRM_FIELD_KPI_GROUP_ID = 1;
  public static final int FRM_FIELD_DIVISION_ID= 2;


public static String[] fieldNames = {
    "FRM_FIELD_KPI_GROUP_DIVISON_ID",
    "FRM_FIELD_KPI_GROUP_ID",
    "FRM_FIELD_DIVISION_ID"
};

public static int[] fieldTypes = {
    TYPE_LONG,
    TYPE_LONG,
    TYPE_LONG
};

public FrmKpiGroupDivision() {
}

public FrmKpiGroupDivision(KpiGroupDivision entKpiGroupDivision) {
   this.entKpiGroupDivision = entKpiGroupDivision;
}

public FrmKpiGroupDivision(HttpServletRequest request, KpiGroupDivision entKpiGroupDivision) {
   super(new FrmKpiGroupDivision(entKpiGroupDivision), request);
   this.entKpiGroupDivision = entKpiGroupDivision;
}

public String getFormName() {
   return FRM_KPI_GROUP_DIVISION;
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

public KpiGroupDivision getEntityObject() {
   return entKpiGroupDivision;
}

public void requestEntityObject(KpiGroupDivision entKpiGroupDivision) {
   try {
        this.requestParam();
        entKpiGroupDivision.setKpiGroupDivisonId(getLong(FRM_FIELD_KPI_GROUP_DIVISON_ID));
        entKpiGroupDivision.setKpiGroupId(getLong(FRM_FIELD_KPI_GROUP_ID));
        entKpiGroupDivision.setDivisionId(getLong(FRM_FIELD_DIVISION_ID));
   } catch (Exception e) {
        System.out.println("Error on requestEntityObject : " + e.toString());
   }
}

}

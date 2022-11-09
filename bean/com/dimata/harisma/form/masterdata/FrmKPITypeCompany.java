/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.form.masterdata;

import com.dimata.harisma.entity.masterdata.*;
import com.dimata.qdep.form.FRMHandler;
import com.dimata.qdep.form.I_FRMInterface;
import com.dimata.qdep.form.I_FRMType;
import javax.servlet.http.HttpServletRequest;
/**
 *
 * @author keys
 */
public class FrmKPITypeCompany extends FRMHandler implements I_FRMInterface, I_FRMType {
  private KPITypeCompany entKPITypeCompany;
  public static final String FRM_NAME_KPITYPECOMPANY = "FRM_NAME_KPITYPECOMPANY";
  public static final int FRM_FIELD_KPI_TYPE_COMPANY_ID = 0;
  public static final int FRM_FIELD_KPI_TYPE_ID = 1;
  public static final int FRM_FIELD_COMPANY_ID = 2;
  public static final int FRM_FIELD_DIVISION_ID = 2;

public static String[] fieldNames = {
    "FRM_FIELD_KPI_TYPE_COMPANY_ID",
    "FRM_FIELD_KPI_TYPE_ID",
    "FRM_FIELD_COMPANY_ID",
    "FRM_FIELD_DIVISION_ID"
};

public static int[] fieldTypes = {
    TYPE_LONG,
    TYPE_LONG,
    TYPE_LONG,
    TYPE_LONG
};

public FrmKPITypeCompany() {
}

public FrmKPITypeCompany(KPITypeCompany entKPITypeCompany) {
   this.entKPITypeCompany = entKPITypeCompany;
}

public FrmKPITypeCompany(HttpServletRequest request, KPITypeCompany entKPITypeCompany) {
   super(new FrmKPITypeCompany(entKPITypeCompany), request);
   this.entKPITypeCompany = entKPITypeCompany;
}

public String getFormName() {
   return FRM_NAME_KPITYPECOMPANY;
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

public KPITypeCompany getEntityObject() {
   return entKPITypeCompany;
}

public void requestEntityObject(KPITypeCompany entKPITypeCompany) {
   try {
        this.requestParam();
        entKPITypeCompany.setKpiTypeCompanyId(getLong(FRM_FIELD_KPI_TYPE_COMPANY_ID));
        entKPITypeCompany.setOID(getLong(FRM_FIELD_KPI_TYPE_ID));
        entKPITypeCompany.setCompanyId(getLong(FRM_FIELD_COMPANY_ID));
        
   } catch (Exception e) {
        System.out.println("Error on requestEntityObject : " + e.toString());
   }
}

}
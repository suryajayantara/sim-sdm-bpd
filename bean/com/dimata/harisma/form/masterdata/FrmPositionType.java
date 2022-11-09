/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.form.masterdata;

import com.dimata.harisma.entity.masterdata.PositionType;
import com.dimata.qdep.form.FRMHandler;
import com.dimata.qdep.form.I_FRMInterface;
import com.dimata.qdep.form.I_FRMType;
import javax.servlet.http.HttpServletRequest;

/**
 *
 * @author gndiw
 */
public class FrmPositionType extends FRMHandler implements I_FRMInterface, I_FRMType {
  private PositionType entPositionType;
  public static final String FRM_NAME_POSITION_TYPE = "FRM_NAME_POSITION_TYPE";
  public static final int FRM_FIELD_POSITION_TYPE_ID = 0;
  public static final int FRM_FIELD_TYPE = 1;
  public static final int FRM_FIELD_DESC = 2;


public static String[] fieldNames = {
    "FRM_FIELD_POSITION_TYPE_ID",
    "FRM_FIELD_TYPE",
    "FRM_FIELD_DESC"
};

public static int[] fieldTypes = {
    TYPE_LONG,
    TYPE_STRING,
    TYPE_STRING
};

public FrmPositionType() {
}

public FrmPositionType(PositionType entPositionType) {
   this.entPositionType = entPositionType;
}

public FrmPositionType(HttpServletRequest request, PositionType entPositionType) {
   super(new FrmPositionType(entPositionType), request);
   this.entPositionType = entPositionType;
}

public String getFormName() {
   return FRM_NAME_POSITION_TYPE;
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

public PositionType getEntityObject() {
   return entPositionType;
}

public void requestEntityObject(PositionType entPositionType) {
   try {
        this.requestParam();
        entPositionType.setType(getString(FRM_FIELD_TYPE));
        entPositionType.setDesc(getString(FRM_FIELD_DESC));
   } catch (Exception e) {
        System.out.println("Error on requestEntityObject : " + e.toString());
   }
}

}

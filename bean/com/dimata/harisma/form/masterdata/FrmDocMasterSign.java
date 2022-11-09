/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.form.masterdata;

import com.dimata.harisma.entity.masterdata.DocMasterSign;

import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
/* qdep package */
import com.dimata.qdep.form.*;
/* project package */
import com.dimata.harisma.entity.masterdata.*;

public class FrmDocMasterSign extends FRMHandler implements I_FRMInterface, I_FRMType{
     private DocMasterSign docMasterSign;

    public static final String FRM_NAME_DOC_MASTER_SIGN = "FRM_NAME_DOC_MASTER_SIGN";

  public static final int FRM_FIELD_DOC_MASTER_SIGN_ID = 0;
  public static final int FRM_FIELD_DOC_MASTER_ID = 1;
  public static final int FRM_FIELD_SIGN_INDEX = 2;
  public static final int FRM_FIELD_POSITION_ID = 3;
  public static final int FRM_FIELD_EMPLOYEE_ID = 4;
  public static final int FRM_FIELD_SIGN_FOR_DIVISION_ID = 5;
    
    public static String[] fieldNames = {
       
    "FRM_FIELD_DOC_MASTER_SIGN_ID",
    "FRM_FIELD_DOC_MASTER_ID",
    "FRM_FIELD_SIGN_INDEX",
    "FRM_FIELD_POSITION_ID",
    "FRM_FIELD_EMPLOYEE_ID",
    "FRM_FIELD_SIGN_FOR_DIVISION_ID"
    };

    public static int[] fieldTypes = {
    TYPE_LONG,
    TYPE_LONG,
    TYPE_INT,
    TYPE_LONG,
    TYPE_LONG,
    TYPE_LONG
    };

     //update by priska
    public static final int[] indexValue = {0,1,2,3,4,5,6,7,8};    
    public static final String[] indexKey = {"0","1","2","3","4","5","6","7","8"};
    
    public static Vector getindexValue(){
        Vector indexv = new Vector();
        for (int i= 0; i< indexValue.length; i++){
            indexv.add(String.valueOf(indexValue[i]));
        }
        return indexv;
    }
    
     public static Vector getindexKey(){
        Vector indexk = new Vector();
        for (int i = 0; i < indexKey.length; i++ ){
            indexk.add(indexKey[i]);
        }
        return indexk;
    }   
    
    public FrmDocMasterSign() {
    }

    public FrmDocMasterSign(DocMasterSign docMasterSign) {
        this.docMasterSign = docMasterSign;
    }

    public FrmDocMasterSign(HttpServletRequest request, DocMasterSign docMasterSign) {
        super(new FrmDocMasterSign(docMasterSign), request);
        this.docMasterSign = docMasterSign;
    }

    public String getFormName() {
        return FRM_NAME_DOC_MASTER_SIGN;
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

    public DocMasterSign getEntityObject() {
        return docMasterSign;
    }

    public void requestEntityObject(DocMasterSign docMasterSign) {
        try {
            this.requestParam();
    docMasterSign.setDocMasterId(getLong(FRM_FIELD_DOC_MASTER_ID));
    docMasterSign.setSignIndex(getInt(FRM_FIELD_SIGN_INDEX));
    docMasterSign.setPositionId(getLong(FRM_FIELD_POSITION_ID));
    docMasterSign.setEmployeeId(getLong(FRM_FIELD_EMPLOYEE_ID));
    docMasterSign.setSignForDivisionId(getLong(FRM_FIELD_SIGN_FOR_DIVISION_ID));
            
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}

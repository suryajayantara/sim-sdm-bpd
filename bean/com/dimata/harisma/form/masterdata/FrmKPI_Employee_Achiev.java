/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.form.masterdata;

import com.dimata.harisma.entity.masterdata.KPI_Employee_Achiev;
import com.dimata.harisma.entity.masterdata.KPI_Employee_Achiev;
import com.dimata.qdep.form.FRMHandler;
import com.dimata.qdep.form.I_FRMInterface;
import com.dimata.qdep.form.I_FRMType;
import javax.servlet.http.HttpServletRequest;

/**
 *
 * @author GUSWIK
 */
public class FrmKPI_Employee_Achiev extends FRMHandler implements I_FRMInterface, I_FRMType{
     private KPI_Employee_Achiev kPI_Employee_Achiev;

    public static final String FRM_NAME_KPI_EMPLOYEE_ACHIEV = "FRM_NAME_KPI_EMPLOYEE_ACHIEV";

    public static final int FRM_FIELD_KPI_EMPLOYEE_ACHIEV_ID = 0;
    public static final int FRM_FIELD_KPI_LIST_ID = 1;
    public static final int FRM_FIELD_STARTDATE = 2;
    public static final int FRM_FIELD_ENDDATE = 3;
    public static final int FRM_FIELD_EMPLOYEE_ID = 4;
    public static final int FRM_FIELD_ENTRYDATE = 5;
    public static final int FRM_FIELD_ACHIEVMENT = 6;
	public static final int FRM_FIELD_ACHIEV_DATE = 7;
	public static final int FRM_FIELD_ACHIEV_PROOF = 8;
	public static final int FRM_FIELD_ACHIEV_TYPE = 9;
	public static final int FRM_FIELD_APPROVAL_1 = 10;
	public static final int FRM_FIELD_APPROVAL_DATE_1 = 11;
	public static final int FRM_FIELD_APPROVAL_2 = 12;
	public static final int FRM_FIELD_APPROVAL_DATE_2 = 13;
	public static final int FRM_FIELD_APPROVAL_3 = 14;
	public static final int FRM_FIELD_APPROVAL_DATE_3 = 15;
	public static final int FRM_FIELD_APPROVAL_4 = 16;
	public static final int FRM_FIELD_APPROVAL_DATE_4 = 17;
	public static final int FRM_FIELD_APPROVAL_5 = 18;
	public static final int FRM_FIELD_APPROVAL_DATE_5 = 19;
	public static final int FRM_FIELD_APPROVAL_6 = 20;
	public static final int FRM_FIELD_APPROVAL_DATE_6 = 21;
	public static final int FRM_FIELD_STATUS = 22;
	public static final int FRM_FIELD_TARGET_ID = 23;
	public static final int FRM_FIELD_ACHIEV_NOTE = 24;
    
    public static String[] fieldNames = {
       
        "FRM_FIELD_KPI_EMPLOYEE_ACHIEV_ID",
        "FRM_FIELD_KPI_LIST_ID",
        "FRM_FIELD_STARTDATE",
        "FRM_FIELD_ENDDATE",
        "FRM_FIELD_EMPLOYEE_ID",
        "FRM_FIELD_ENTRYDATE",
        "FRM_FIELD_ACHIEVMENT",
		"FRM_FIELD_ACHIEV_DATE",
		"FRM_FIELD_ACHIEV_PROOF",
		"FRM_FIELD_ACHIEV_TYPE",
		"FRM_FIELD_APPROVAL_1",
		"FRM_FIELD_APPROVAL_DATE_1",
		"FRM_FIELD_APPROVAL_2",
		"FRM_FIELD_APPROVAL_DATE_2",
		"FRM_FIELD_APPROVAL_3",
		"FRM_FIELD_APPROVAL_DATE_3",
		"FRM_FIELD_APPROVAL_4",
		"FRM_FIELD_APPROVAL_DATE_4",
		"FRM_FIELD_APPROVAL_5",
		"FRM_FIELD_APPROVAL_DATE_5",
		"FRM_FIELD_APPROVAL_6",
		"FRM_FIELD_APPROVAL_DATE_6",
		"FRM_FIELD_STATUS",
		"FRM_FIELD_TARGET_ID",
		"FRM_FIELD_ACHIEV_NOTE"
    };

    public static int[] fieldTypes = {
        TYPE_LONG, 
        TYPE_LONG, 
        TYPE_DATE, 
        TYPE_DATE, 
        TYPE_LONG, 
        TYPE_DATE,
        TYPE_FLOAT,
		TYPE_DATE,
		TYPE_STRING,
		TYPE_INT,
		TYPE_LONG,
		TYPE_DATE,
		TYPE_LONG,
		TYPE_DATE,
		TYPE_LONG,
		TYPE_DATE,
		TYPE_LONG,
		TYPE_DATE,
		TYPE_LONG,
		TYPE_DATE,
		TYPE_LONG,
		TYPE_DATE,
		TYPE_INT,
		TYPE_LONG,
		TYPE_STRING
    };

    public FrmKPI_Employee_Achiev() {
    }

    public FrmKPI_Employee_Achiev(KPI_Employee_Achiev kPI_Employee_Achiev) {
        this.kPI_Employee_Achiev = kPI_Employee_Achiev;
    }

    public FrmKPI_Employee_Achiev(HttpServletRequest request, KPI_Employee_Achiev kPI_Employee_Achiev) {
        super(new FrmKPI_Employee_Achiev(kPI_Employee_Achiev), request);
        this.kPI_Employee_Achiev = kPI_Employee_Achiev;
    }

    public String getFormName() {
        return FRM_NAME_KPI_EMPLOYEE_ACHIEV;
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

    public KPI_Employee_Achiev getEntityObject() {
        return kPI_Employee_Achiev;
    }

    public void requestEntityObject(KPI_Employee_Achiev kPI_Employee_Achiev) {
        try {
            this.requestParam();
            kPI_Employee_Achiev.setKpiListId(getLong(FRM_FIELD_KPI_LIST_ID));
            kPI_Employee_Achiev.setStartDate(getDate(FRM_FIELD_STARTDATE));
            kPI_Employee_Achiev.setEndDate(getDate(FRM_FIELD_ENDDATE));
            kPI_Employee_Achiev.setEmployeeId(getLong(FRM_FIELD_EMPLOYEE_ID));
            kPI_Employee_Achiev.setEntryDate(getDate(FRM_FIELD_ENTRYDATE));
            kPI_Employee_Achiev.setAchievement(getDouble(FRM_FIELD_ACHIEVMENT));
			kPI_Employee_Achiev.setAchievDate(getDate(FRM_FIELD_ACHIEV_DATE));
			kPI_Employee_Achiev.setAchievProof(getString(FRM_FIELD_ACHIEV_PROOF));
			kPI_Employee_Achiev.setAchievType(getInt(FRM_FIELD_ACHIEV_TYPE));
            kPI_Employee_Achiev.setApproval1(getLong(FRM_FIELD_APPROVAL_1));
			kPI_Employee_Achiev.setApprovalDate1(getDate(FRM_FIELD_APPROVAL_DATE_1));
			kPI_Employee_Achiev.setApproval2(getLong(FRM_FIELD_APPROVAL_2));
			kPI_Employee_Achiev.setApprovalDate2(getDate(FRM_FIELD_APPROVAL_DATE_2));
			kPI_Employee_Achiev.setApproval3(getLong(FRM_FIELD_APPROVAL_3));
			kPI_Employee_Achiev.setApprovalDate3(getDate(FRM_FIELD_APPROVAL_DATE_3));
			kPI_Employee_Achiev.setApproval4(getLong(FRM_FIELD_APPROVAL_4));
			kPI_Employee_Achiev.setApprovalDate4(getDate(FRM_FIELD_APPROVAL_DATE_4));
			kPI_Employee_Achiev.setApproval5(getLong(FRM_FIELD_APPROVAL_5));
			kPI_Employee_Achiev.setApprovalDate5(getDate(FRM_FIELD_APPROVAL_DATE_5));
			kPI_Employee_Achiev.setApproval6(getLong(FRM_FIELD_APPROVAL_6));
			kPI_Employee_Achiev.setApprovalDate6(getDate(FRM_FIELD_APPROVAL_DATE_6));
			kPI_Employee_Achiev.setStatus(getInt(FRM_FIELD_STATUS));
			kPI_Employee_Achiev.setTargetId(getLong(FRM_FIELD_TARGET_ID));
			kPI_Employee_Achiev.setAchievNote(getString(FRM_FIELD_ACHIEV_NOTE));
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }

}

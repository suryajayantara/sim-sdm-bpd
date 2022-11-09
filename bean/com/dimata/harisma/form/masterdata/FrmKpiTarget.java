/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.form.masterdata;

import com.dimata.harisma.entity.masterdata.KpiTarget;
import com.dimata.qdep.form.FRMHandler;
import com.dimata.qdep.form.I_FRMInterface;
import com.dimata.qdep.form.I_FRMType;
import com.dimata.util.Formater;
import javax.servlet.http.HttpServletRequest;

/**
 *
 * @author IanRizky
 */
public class FrmKpiTarget extends FRMHandler implements I_FRMInterface, I_FRMType {

	private KpiTarget entKpiTarget;
	public static final String FRM_NAME_KPITARGET = "FRM_NAME_KPITARGET";
	public static final int FRM_FIELD_KPI_TARGET_ID = 0;
	public static final int FRM_FIELD_CREATE_DATE = 1;
	public static final int FRM_FIELD_TITLE = 2;
	public static final int FRM_FIELD_STATUS_DOC = 3;
	public static final int FRM_FIELD_COMPANY_ID = 4;
	public static final int FRM_FIELD_DIVISION_ID = 5;
	public static final int FRM_FIELD_DEPARTMENT_ID = 6;
	public static final int FRM_FIELD_SECTION_ID = 7;
	public static final int FRM_FIELD_COUNT_IDX = 8;
	public static final int FRM_FIELD_APPROVAL_1 = 9;
	public static final int FRM_FIELD_APPROVAL_DATE_1 = 10;
	public static final int FRM_FIELD_APPROVAL_2 = 11;
	public static final int FRM_FIELD_APPROVAL_DATE_2 = 12;
	public static final int FRM_FIELD_APPROVAL_3 = 13;
	public static final int FRM_FIELD_APPROVAL_DATE_3 = 14;
	public static final int FRM_FIELD_APPROVAL_4 = 15;
	public static final int FRM_FIELD_APPROVAL_DATE_4 = 16;
	public static final int FRM_FIELD_APPROVAL_5 = 17;
	public static final int FRM_FIELD_APPROVAL_DATE_5 = 18;
	public static final int FRM_FIELD_APPROVAL_6 = 19;
	public static final int FRM_FIELD_APPROVAL_DATE_6 = 20;
	public static final int FRM_FIELD_AUTHOR_ID = 21;
	public static final int FRM_FIELD_TAHUN = 22;

	public static String[] fieldNames = {
		"FRM_FIELD_KPI_TARGET_ID",
		"FRM_FIELD_CREATE_DATE",
		"FRM_FIELD_TITLE",
		"FRM_FIELD_STATUS_DOC",
		"FRM_FIELD_COMPANY_ID",
		"FRM_FIELD_DIVISION_ID",
		"FRM_FIELD_DEPARTMENT_ID",
		"FRM_FIELD_SECTION_ID",
		"FRM_FIELD_COUNT_IDX",
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
		"FRM_FIELD_AUTHOR_ID",
		"FRM_FIELD_TAHUN"
	};

	public static int[] fieldTypes = {
		TYPE_LONG,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_INT,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_LONG,
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
		TYPE_LONG,
		TYPE_INT
	};

	public FrmKpiTarget() {
	}

	public FrmKpiTarget(KpiTarget entKpiTarget) {
		this.entKpiTarget = entKpiTarget;
	}

	public FrmKpiTarget(HttpServletRequest request, KpiTarget entKpiTarget) {
		super(new FrmKpiTarget(entKpiTarget), request);
		this.entKpiTarget = entKpiTarget;
	}

	public String getFormName() {
		return FRM_NAME_KPITARGET;
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

	public KpiTarget getEntityObject() {
		return entKpiTarget;
	}

	public void requestEntityObject(KpiTarget entKpiTarget) {
		try {
			this.requestParam();
			entKpiTarget.setCreateDate(Formater.formatDate(getString(FRM_FIELD_CREATE_DATE), "yyyy-MM-dd"));
			entKpiTarget.setTitle(getString(FRM_FIELD_TITLE));
			entKpiTarget.setStatusDoc(getInt(FRM_FIELD_STATUS_DOC));
			entKpiTarget.setCompanyId(getLong(FRM_FIELD_COMPANY_ID));
			entKpiTarget.setDivisionId(getLong(FRM_FIELD_DIVISION_ID));
			entKpiTarget.setDepartmentId(getLong(FRM_FIELD_DEPARTMENT_ID));
			entKpiTarget.setSectionId(getLong(FRM_FIELD_SECTION_ID));
			entKpiTarget.setCountIdx(getInt(FRM_FIELD_COUNT_IDX));
			entKpiTarget.setApproval1(getLong(FRM_FIELD_APPROVAL_1));
			entKpiTarget.setApprovalDate1(getDate(FRM_FIELD_APPROVAL_DATE_1));
			entKpiTarget.setApproval2(getLong(FRM_FIELD_APPROVAL_2));
			entKpiTarget.setApprovalDate2(getDate(FRM_FIELD_APPROVAL_DATE_2));
			entKpiTarget.setApproval3(getLong(FRM_FIELD_APPROVAL_3));
			entKpiTarget.setApprovalDate3(getDate(FRM_FIELD_APPROVAL_DATE_3));
			entKpiTarget.setApproval4(getLong(FRM_FIELD_APPROVAL_4));
			entKpiTarget.setApprovalDate4(getDate(FRM_FIELD_APPROVAL_DATE_4));
			entKpiTarget.setApproval5(getLong(FRM_FIELD_APPROVAL_5));
			entKpiTarget.setApprovalDate5(getDate(FRM_FIELD_APPROVAL_DATE_5));
			entKpiTarget.setApproval6(getLong(FRM_FIELD_APPROVAL_6));
			entKpiTarget.setApprovalDate6(getDate(FRM_FIELD_APPROVAL_DATE_6));
			entKpiTarget.setAuthorId(getLong(FRM_FIELD_AUTHOR_ID));
			entKpiTarget.setTahun(getInt(FRM_FIELD_TAHUN));
		} catch (Exception e) {
			System.out.println("Error on requestEntityObject : " + e.toString());
		}
	}

}
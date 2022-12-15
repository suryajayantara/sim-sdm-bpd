/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.form.masterdata;

import com.dimata.harisma.entity.masterdata.KpiTargetDetail;
import com.dimata.qdep.form.FRMHandler;
import com.dimata.qdep.form.I_FRMInterface;
import com.dimata.qdep.form.I_FRMType;
import com.dimata.util.Formater;
import javax.servlet.http.HttpServletRequest;

/**
 *
 * @author IanRizky
 */
public class FrmKpiTargetDetail extends FRMHandler implements I_FRMInterface, I_FRMType {

	private KpiTargetDetail entKpiTargetDetail;
	public static final String FRM_NAME_KPI_TARGET_DETAIL = "FRM_NAME_KPI_TARGET_DETAIL";
	public static final int FRM_FIELD_KPI_TARGET_DETAIL_ID = 0;
	public static final int FRM_FIELD_KPI_TARGET_ID = 1;
	public static final int FRM_FIELD_KPI_ID = 2;
	public static final int FRM_FIELD_PERIOD = 3;
	public static final int FRM_FIELD_DATE_FROM = 4;
	public static final int FRM_FIELD_DATE_TO = 5;
	public static final int FRM_FIELD_AMOUNT = 6;
	public static final int FRM_FIELD_KPI_GROUP_ID = 7;
	public static final int FRM_FIELD_WEIGHT_VALUE = 8;
	public static final int FRM_FIELD_KPI_SETTING_LIST_ID = 9;
	public static final int FRM_FIELD_INDEX_PERIOD = 10;

	public static String[] fieldNames = {
		"FRM_FIELD_KPI_TARGET_DETAIL_ID",
		"FRM_FIELD_KPI_TARGET_ID",
		"FRM_FIELD_KPI_ID",
		"FRM_FIELD_PERIOD",
		"FRM_FIELD_DATE_FROM",
		"FRM_FIELD_DATE_TO",
		"FRM_FIELD_AMOUNT",
		"FRM_FIELD_KPI_GROUP_ID",
		"FRM_FIELD_WEIGHT_VALUE",
		"KPI_SETTING_LIST_ID",
		"FRM_FIELD_INDEX_PERIOD"
	};

	public static int[] fieldTypes = {
		TYPE_LONG,
		TYPE_LONG + ENTRY_REQUIRED,
		TYPE_LONG,
		TYPE_INT,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_FLOAT,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_INT
	};

	public FrmKpiTargetDetail() {
	}

	public FrmKpiTargetDetail(KpiTargetDetail entKpiTargetDetail) {
		this.entKpiTargetDetail = entKpiTargetDetail;
	}

	public FrmKpiTargetDetail(HttpServletRequest request, KpiTargetDetail entKpiTargetDetail) {
		super(new FrmKpiTargetDetail(entKpiTargetDetail), request);
		this.entKpiTargetDetail = entKpiTargetDetail;
	}

	public String getFormName() {
		return FRM_NAME_KPI_TARGET_DETAIL;
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

	public KpiTargetDetail getEntityObject() {
		return entKpiTargetDetail;
	}

	public void requestEntityObject(KpiTargetDetail entKpiTargetDetail) {
		try {
			this.requestParam();
			entKpiTargetDetail.setKpiTargetId(getLong(FRM_FIELD_KPI_TARGET_ID));
			entKpiTargetDetail.setKpiId(getLong(FRM_FIELD_KPI_ID));
			entKpiTargetDetail.setPeriod(getInt(FRM_FIELD_PERIOD));
			entKpiTargetDetail.setDateFrom(Formater.formatDate(getString(FRM_FIELD_DATE_FROM), "yyyy-MM-dd"));
			entKpiTargetDetail.setDateTo(Formater.formatDate(getString(FRM_FIELD_DATE_TO), "yyyy-MM-dd"));
			entKpiTargetDetail.setAmount(getFloat(FRM_FIELD_AMOUNT));
			entKpiTargetDetail.setKpiGroupId(getLong(FRM_FIELD_KPI_GROUP_ID));
			entKpiTargetDetail.setWeightValue(getFloat(FRM_FIELD_WEIGHT_VALUE));
			entKpiTargetDetail.setKpiSettingListId(getLong(FRM_FIELD_KPI_SETTING_LIST_ID));
			entKpiTargetDetail.setIndexPeriod(getInt(FRM_FIELD_WEIGHT_VALUE));
		} catch (Exception e) {
			System.out.println("Error on requestEntityObject : " + e.toString());
		}
	}

}
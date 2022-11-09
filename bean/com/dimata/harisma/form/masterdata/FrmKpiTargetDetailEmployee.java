/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.form.masterdata;

import com.dimata.harisma.entity.masterdata.KpiTargetDetailEmployee;
import com.dimata.qdep.form.FRMHandler;
import com.dimata.qdep.form.I_FRMInterface;
import com.dimata.qdep.form.I_FRMType;
import javax.servlet.http.HttpServletRequest;

/**
 *
 * @author IanRizky
 */
public class FrmKpiTargetDetailEmployee extends FRMHandler implements I_FRMInterface, I_FRMType {

	private KpiTargetDetailEmployee entKpiTargetDetailEmployee;
	public static final String FRM_NAME_KPI_TARGET_DETAIL_EMPLOYEE = "FRM_NAME_KPI_TARGET_DETAIL_EMPLOYEE";
	public static final int FRM_FIELD_KPI_TARGET_DETAIL_EMPLOYEE_ID = 0;
	public static final int FRM_FIELD_KPI_TARGET_DETAIL_ID = 1;
	public static final int FRM_FIELD_EMPLOYEE_ID = 2;
        public static final int FRM_FIELD_BOBOT = 3;

	public static String[] fieldNames = {
		"FRM_FIELD_KPI_TARGET_DETAIL_EMPLOYEE_ID",
		"FRM_FIELD_KPI_TARGET_DETAIL_ID",
		"FRM_FIELD_EMPLOYEE_ID",
                "FRM_FIELD_BOBOT"
	};

	public static int[] fieldTypes = {
		TYPE_LONG,
		TYPE_LONG,
		TYPE_LONG,
                TYPE_FLOAT
	};

	public FrmKpiTargetDetailEmployee() {
	}

	public FrmKpiTargetDetailEmployee(KpiTargetDetailEmployee entKpiTargetDetailEmployee) {
		this.entKpiTargetDetailEmployee = entKpiTargetDetailEmployee;
	}

	public FrmKpiTargetDetailEmployee(HttpServletRequest request, KpiTargetDetailEmployee entKpiTargetDetailEmployee) {
		super(new FrmKpiTargetDetailEmployee(entKpiTargetDetailEmployee), request);
		this.entKpiTargetDetailEmployee = entKpiTargetDetailEmployee;
	}

	public String getFormName() {
		return FRM_NAME_KPI_TARGET_DETAIL_EMPLOYEE;
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

	public KpiTargetDetailEmployee getEntityObject() {
		return entKpiTargetDetailEmployee;
	}

	public void requestEntityObject(KpiTargetDetailEmployee entKpiTargetDetailEmployee) {
		try {
			this.requestParam();
			entKpiTargetDetailEmployee.setKpiTargetDetailId(getLong(FRM_FIELD_KPI_TARGET_DETAIL_ID));
			entKpiTargetDetailEmployee.setEmployeeId(getLong(FRM_FIELD_EMPLOYEE_ID));
                        entKpiTargetDetailEmployee.setBobot(getDouble(FRM_FIELD_BOBOT));
		} catch (Exception e) {
			System.out.println("Error on requestEntityObject : " + e.toString());
		}
	}
}

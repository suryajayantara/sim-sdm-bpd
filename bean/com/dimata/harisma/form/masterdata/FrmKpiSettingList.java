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
import com.dimata.harisma.entity.masterdata.KpiSettingList;
import com.dimata.qdep.form.FRMHandler;
import com.dimata.qdep.form.I_FRMInterface;
import com.dimata.qdep.form.I_FRMType;
import java.util.Vector;
import javax.servlet.http.HttpServletRequest;

public class FrmKpiSettingList extends FRMHandler implements I_FRMInterface, I_FRMType {

    public Vector <Long> getvOidKpiList() {
        return vOidKpiList;
    }
    private KpiSettingList entKpiSettingList;
    public Vector <Long> vOidKpiList = null;
    public static final String FRM_NAME_KPISETTINGLIST = "FRM_NAME_KPISETTINGLIST";
    public static final int FRM_FIELD_KPI_SETTING_LIST_ID = 0;
    public static final int FRM_FIELD_KPI_SETTING_ID = 1;
    public static final int FRM_FIELD_KPI_LIST_ID = 2;
    public static final int FRM_FIELD_KPI_DISTRIBUTION_ID = 3;

    public static String[] fieldNames = {
        "FRM_FIELD_KPI_SETTING_LIST_ID",
        "FRM_FIELD_KPI_SETTING_ID",
        "FRM_FIELD_KPI_LIST_ID",
        "FRM_FIELD_KPI_DISTRIBUTION_ID"
    };

    public static int[] fieldTypes = {
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG
    };

    public FrmKpiSettingList() {
    }

    public FrmKpiSettingList(KpiSettingList entKpiSettingList) {
        this.entKpiSettingList = entKpiSettingList;
    }

    public FrmKpiSettingList(HttpServletRequest request, KpiSettingList entKpiSettingList) {
        super(new FrmKpiSettingList(entKpiSettingList), request);
        this.entKpiSettingList = entKpiSettingList;
    }

    public String getFormName() {
        return FRM_NAME_KPISETTINGLIST;
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

    public KpiSettingList getEntityObject() {
        return entKpiSettingList;
    }

    public void requestEntityObject(KpiSettingList entKpiSettingList) {
        try {
            this.requestParam();
            entKpiSettingList.setKpiSettingListId(getLong(FRM_FIELD_KPI_SETTING_LIST_ID));
            entKpiSettingList.setKpiSettingId(getLong(FRM_FIELD_KPI_SETTING_ID));
            vOidKpiList = getVectorLong(fieldNames[FRM_FIELD_KPI_LIST_ID]);
            entKpiSettingList.setKpiDistributionId(getLong(FRM_FIELD_KPI_DISTRIBUTION_ID));
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }

}

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
import com.dimata.harisma.entity.masterdata.KpiDistribution;
import com.dimata.qdep.form.FRMHandler;
import com.dimata.qdep.form.I_FRMInterface;
import com.dimata.qdep.form.I_FRMType;
import javax.servlet.http.HttpServletRequest;

public class FrmKpiDistribution extends FRMHandler implements I_FRMInterface, I_FRMType {

    private KpiDistribution entKpiDistribution;
    public static final String FRM_NAME_KPIDISTRIBUTION = "FRM_NAME_KPIDISTRIBUTION";
    public static final int FRM_FIELD_KPI_DISTRIBUTION_ID = 0;
    public static final int FRM_FIELD_DISTRIBUTION = 1;

    public static String[] fieldNames = {
        "FRM_FIELD_KPI_DISTRIBUTION_ID",
        "FRM_FIELD_DISTRIBUTION"
    };

    public static int[] fieldTypes = {
        TYPE_LONG,
        TYPE_STRING
    };

    public FrmKpiDistribution() {
    }

    public FrmKpiDistribution(KpiDistribution entKpiDistribution) {
        this.entKpiDistribution = entKpiDistribution;
    }

    public FrmKpiDistribution(HttpServletRequest request, KpiDistribution entKpiDistribution) {
        super(new FrmKpiDistribution(entKpiDistribution), request);
        this.entKpiDistribution = entKpiDistribution;
    }

    public String getFormName() {
        return FRM_NAME_KPIDISTRIBUTION;
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

    public KpiDistribution getEntityObject() {
        return entKpiDistribution;
    }

    public void requestEntityObject(KpiDistribution entKpiDistribution) {
        try {
            this.requestParam();
            entKpiDistribution.setKpiDistributionId(getLong(FRM_FIELD_KPI_DISTRIBUTION_ID));
            entKpiDistribution.setDistribution(getString(FRM_FIELD_DISTRIBUTION));
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }

}

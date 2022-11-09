/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.form.report.lkpbu;

import com.dimata.harisma.entity.report.lkpbu.Lkpbu;
import com.dimata.qdep.form.FRMHandler;
import com.dimata.qdep.form.I_FRMInterface;
import com.dimata.qdep.form.I_FRMType;
import javax.servlet.http.HttpServletRequest;

/**
 *
 * @author khirayinnura
 */
public class FrmLkpbu extends FRMHandler implements I_FRMInterface, I_FRMType {

    private Lkpbu entLkpbu;
    public static final String FRM_NAME_LKPBU_801 = "FRM_NAME_LKPBU_801";
    public static final int FRM_FIELD_LKPBU_801_ID = 0;
    public static final int FRM_FIELD_EMPLOYEE_ID = 1;
    public static final int FRM_FIELD_NO_SURAT_PELAPORAN = 2;
    public static final int FRM_FIELD_TANGGAL_SURAT_PELAPORAN = 3;
    public static final int FRM_FIELD_NO_SK = 4;
    public static final int FRM_FIELD_TANGGAL_SK = 5;
    public static final int FRM_FIELD_NO_SK_PEMBERHENTIAN = 6;
    public static final int FRM_FIELD_TANGGAL_SK_PEMBERHENTIAN = 7;
    public static final int FRM_FIELD_KETERANGAN = 8;
    public static final int FRM_FIELD_PERIOD_ID = 9;
    public static final int FRM_FIELD_POSITION = 10;
    public static String[] fieldNames = {
        "FRM_FIELD_LKPBU_801_ID",
        "FRM_FIELD_EMPLOYEE_ID",
        "FRM_FIELD_NO_SURAT_PELAPORAN",
        "FRM_FIELD_TANGGAL_SURAT_PELAPORAN",
        "FRM_FIELD_NO_SK",
        "FRM_FIELD_TANGGAL_SK",
        "FRM_FIELD_NO_SK_PEMBERHENTIAN",
        "FRM_FIELD_TANGGAL_SK_PEMBERHENTIAN",
        "FRM_FIELD_KETERANGAN",
        "FRM_FIELD_PERIOD_ID",
        "FRM_FIELD_POSITION"
    };
    public static int[] fieldTypes = {
        TYPE_LONG,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_LONG,
        TYPE_STRING
    };

    public FrmLkpbu() {
    }

    public FrmLkpbu(Lkpbu entLkpbu) {
        this.entLkpbu = entLkpbu;
    }

    public FrmLkpbu(HttpServletRequest request, Lkpbu entLkpbu) {
        super(new FrmLkpbu(entLkpbu), request);
        this.entLkpbu = entLkpbu;
    }

    public String getFormName() {
        return FRM_NAME_LKPBU_801;
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

    public Lkpbu getEntityObject() {
        return entLkpbu;
    }

    public void requestEntityObject(Lkpbu entLkpbu) {
        try {
            this.requestParam();
            entLkpbu.setEmployeeId(getLong(FRM_FIELD_EMPLOYEE_ID));
            entLkpbu.setNoSuratPelaporan(getString(FRM_FIELD_NO_SURAT_PELAPORAN));
            entLkpbu.setTanggalSuratPelaporan(getString(FRM_FIELD_TANGGAL_SURAT_PELAPORAN));
            entLkpbu.setNoSK(getString(FRM_FIELD_NO_SK));
            entLkpbu.setTanggalSK(getString(FRM_FIELD_TANGGAL_SK));
            entLkpbu.setNoSKPemberhentian(getString(FRM_FIELD_NO_SK_PEMBERHENTIAN));
            entLkpbu.setTanggalSKPemberhentian(getString(FRM_FIELD_TANGGAL_SK_PEMBERHENTIAN));
            entLkpbu.setKeterangan(getString(FRM_FIELD_KETERANGAN));
            entLkpbu.setPeriodId(getLong(FRM_FIELD_PERIOD_ID));
            entLkpbu.setPositionName(getString(FRM_FIELD_POSITION));
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}

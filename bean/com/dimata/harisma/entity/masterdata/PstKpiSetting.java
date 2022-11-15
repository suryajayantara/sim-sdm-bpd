/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.masterdata;

/**
 *
 * @author User
 */
import java.sql.*;
import com.dimata.util.lang.I_Language;
import com.dimata.qdep.db.*;
import com.dimata.qdep.entity.*;
import com.dimata.util.Command;
import com.dimata.util.Formater;
import java.util.Vector;
import org.json.JSONObject;

public class PstKpiSetting extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {

    public static final String TBL_KPI_SETTING = "hr_kpi_setting";
    public static final int FLD_KPI_SETTING_ID = 0;
    public static final int FLD_VALID_DATE = 1;
    public static final int FLD_STATUS = 2;
    public static final int FLD_START_DATE = 3;
    public static final int FLD_COMPANY_ID = 4;
    public static final int FLD_TAHUN = 5;

    public static String[] fieldNames = {
        "KPI_SETTING_ID",
        "VALID_DATE",
        "STATUS",
        "START_DATE",
        "COMPANY_ID",
        "TAHUN"
    };

    public static int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_DATE,
        TYPE_INT,
        TYPE_DATE,
        TYPE_LONG,
        TYPE_INT

    };

    public PstKpiSetting() {
    }

    public PstKpiSetting(int i) throws DBException {
        super(new PstKpiSetting());
    }

    public PstKpiSetting(String sOid) throws DBException {
        super(new PstKpiSetting(0));
        if (!locate(sOid)) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public PstKpiSetting(long lOid) throws DBException {
        super(new PstKpiSetting(0));
        String sOid = "0";
        try {
            sOid = String.valueOf(lOid);
        } catch (Exception e) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        if (!locate(sOid)) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public int getFieldSize() {
        return fieldNames.length;
    }

    public String getTableName() {
        return TBL_KPI_SETTING;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new PstKpiSetting().getClass().getName();
    }

    public static KpiSetting fetchExc(long oid) throws DBException {
        try {
            KpiSetting entKpisetting = new KpiSetting();
            PstKpiSetting pstKpiSetting = new PstKpiSetting(oid);
            entKpisetting.setOID(oid);
            entKpisetting.setValidDate(pstKpiSetting.getDate(FLD_VALID_DATE));
            entKpisetting.setStatus(pstKpiSetting.getInt(FLD_STATUS));
            entKpisetting.setStartDate(pstKpiSetting.getDate(FLD_START_DATE));
            entKpisetting.setCompanyId(pstKpiSetting.getLong(FLD_COMPANY_ID));
            entKpisetting.setTahun(pstKpiSetting.getInt(FLD_TAHUN));
            return entKpisetting;
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstKpiSetting(0), DBException.UNKNOWN);
        }
    }

    public long fetchExc(Entity entity) throws Exception {
        KpiSetting entKpiSetting = fetchExc(entity.getOID());
        entity = (Entity) entKpiSetting;
        return entKpiSetting.getOID();
    }

    public static synchronized long updateExc(KpiSetting entKpiSetting) throws DBException {
        try {
            if (entKpiSetting.getOID() != 0) {
                PstKpiSetting pstKpiSetting = new PstKpiSetting(entKpiSetting.getOID());
                pstKpiSetting.setDate(FLD_VALID_DATE, entKpiSetting.getValidDate());
                pstKpiSetting.setInt(FLD_STATUS, entKpiSetting.getStatus());
                pstKpiSetting.setDate(FLD_START_DATE, entKpiSetting.getStartDate());
                pstKpiSetting.setLong(FLD_COMPANY_ID, entKpiSetting.getCompanyId());
                pstKpiSetting.setInt(FLD_TAHUN, entKpiSetting.getTahun());
                pstKpiSetting.update();
                return entKpiSetting.getOID();
            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstKpiSetting(0), DBException.UNKNOWN);
        }
        return 0;
    }

    public long updateExc(Entity entity) throws Exception {
        return updateExc((KpiSetting) entity);
    }

    public static synchronized long deleteExc(long oid) throws DBException {
        try {
            PstKpiSetting pstKpiSetting = new PstKpiSetting(oid);
            pstKpiSetting.delete();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstKpiSetting(0), DBException.UNKNOWN);
        }
        return oid;
    }

    public long deleteExc(Entity entity) throws Exception {
        if (entity == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(entity.getOID());
    }

    public static synchronized long insertExc(KpiSetting entKpiSetting) throws DBException {
        try {
            PstKpiSetting pstKpiSetting = new PstKpiSetting(0);
            pstKpiSetting.setDate(FLD_VALID_DATE, entKpiSetting.getValidDate());
            pstKpiSetting.setInt(FLD_STATUS, entKpiSetting.getStatus());
            pstKpiSetting.setDate(FLD_START_DATE, entKpiSetting.getStartDate());
            pstKpiSetting.setLong(FLD_COMPANY_ID, entKpiSetting.getCompanyId());
            pstKpiSetting.setInt(FLD_TAHUN, entKpiSetting.getTahun());
            pstKpiSetting.insert();
            entKpiSetting.setOID(pstKpiSetting.getlong(FLD_KPI_SETTING_ID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstKpiSetting(0), DBException.UNKNOWN);
        }
        return entKpiSetting.getOID();
    }

    public long insertExc(Entity entity) throws Exception {
        return insertExc((KpiSetting) entity);
    }

    public static void resultToObject(ResultSet rs, KpiSetting entKpiSetting) {
        try {
            entKpiSetting.setOID(rs.getLong(PstKpiSetting.fieldNames[PstKpiSetting.FLD_KPI_SETTING_ID]));
            entKpiSetting.setValidDate(rs.getDate(PstKpiSetting.fieldNames[PstKpiSetting.FLD_VALID_DATE]));
            entKpiSetting.setStatus(rs.getInt(PstKpiSetting.fieldNames[PstKpiSetting.FLD_STATUS]));
            entKpiSetting.setStartDate(rs.getDate(PstKpiSetting.fieldNames[PstKpiSetting.FLD_START_DATE]));
            entKpiSetting.setCompanyId(rs.getLong(PstKpiSetting.fieldNames[PstKpiSetting.FLD_COMPANY_ID]));
            entKpiSetting.setTahun(rs.getInt(PstKpiSetting.fieldNames[PstKpiSetting.FLD_TAHUN]));
        } catch (Exception e) {
        }
    }

    public static Vector listAll() {
        return list(0, 500, "", "");
    }

    public static Vector list(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT * FROM " + TBL_KPI_SETTING;
            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " WHERE " + whereClause;
            }
            if (order != null && order.length() > 0) {
                sql = sql + " ORDER BY " + order;
            }
            if (limitStart == 0 && recordToGet == 0) {
                sql = sql + "";
            } else {
                sql = sql + " LIMIT " + limitStart + "," + recordToGet;
            }
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                KpiSetting entKpiSetting = new KpiSetting();
                resultToObject(rs, entKpiSetting);
                lists.add(entKpiSetting);
            }
            rs.close();
            return lists;
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return new Vector();
    }
    
    public static Vector listWithJoinPositionAndCompany(String whereClause) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT\n" +
                            "  `tb_kpiposisi`.`POSITION_ID` AS POSITION_ID,\n" +
                            "  `kpi_setting`.`COMPANY_ID` AS COMPANY_ID,\n" +
                            "  kpi_setting.`KPI_SETTING_ID`,\n" +
                            "  kpi_setting.`START_DATE`,\n" +
                            "  kpi_setting.`STATUS`,\n" +
                            "  kpi_setting.`TAHUN`,\n" +
                            "  kpi_setting.`VALID_DATE`\n" +
                            "FROM\n" +
                            "  hr_kpi_setting AS kpi_setting\n" +
                            "  LEFT JOIN `hr_kpi_setting_position` tb_kpiposisi\n" +
                            "    ON kpi_setting.`KPI_SETTING_ID` = `tb_kpiposisi`.`KPI_SETTING_ID`\n" +
                            "  LEFT JOIN `hr_position` tb_posisi\n" +
                            "    ON tb_kpiposisi.`POSITION_ID` = `tb_posisi`.`POSITION_ID`\n" +
                            "  LEFT JOIN `pay_general` tb_perusahan\n" +
                            "    ON kpi_setting.`COMPANY_ID` = `tb_perusahan`.`GEN_ID`\n"+
                         "WHERE "+ whereClause + 
                         "GROUP BY kpi_setting.`KPI_SETTING_ID`";
                         
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                KpiSetting entKpiSetting = new KpiSetting();
                resultToObject(rs, entKpiSetting);
                lists.add(entKpiSetting);
            }
            rs.close();
            return lists;
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return new Vector();
    }

    public static int getCount(String whereClause) {
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT COUNT(" + PstKpiSetting.fieldNames[PstKpiSetting.FLD_VALID_DATE] + ") FROM " + TBL_KPI_SETTING;
            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " WHERE " + whereClause;
            }
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            int count = 0;
            while (rs.next()) {
                count = rs.getInt(1);
            }
            rs.close();
            return count;
        } catch (Exception e) {
            return 0;
        } finally {
            DBResultSet.close(dbrs);
        }
    }

    public static int findLimitStart(long oid, int recordToGet, String whereClause, String orderClause) {
        int size = getCount(whereClause);
        int start = 0;
        boolean found = false;
        for (int i = 0; (i < size) && !found; i = i + recordToGet) {
            Vector list = list(i, recordToGet, whereClause, orderClause);
            start = i;
            if (list.size() > 0) {
                for (int ls = 0; ls < list.size(); ls++) {
                    KpiSetting entKpiSetting = (KpiSetting) list.get(ls);
                    if (oid == entKpiSetting.getOID()) {
                        found = true;
                    }
                }
            }
        }
        if ((start >= size) && (size > 0)) {
            start = start - recordToGet;
        }
        return start;
    }

    public static int findLimitCommand(int start, int recordToGet, int vectSize) {
        int cmd = Command.LIST;
        int mdl = vectSize % recordToGet;
        vectSize = vectSize + (recordToGet - mdl);
        if (start == 0) {
            cmd = Command.FIRST;
        } else {
            if (start == (vectSize - recordToGet)) {
                cmd = Command.LAST;
            } else {
                start = start + recordToGet;
                if (start <= (vectSize - recordToGet)) {
                    cmd = Command.NEXT;
                    System.out.println("next.......................");
                } else {
                    start = start - recordToGet;
                    if (start > 0) {
                        cmd = Command.PREV;
                        System.out.println("prev.......................");
                    }
                }
            }
        }
        return cmd;
    }
//Add by Eri Yudi 2020-07-01
//Method for API

    public static JSONObject fetchJSON(KpiSetting entKpiSetting) {
        JSONObject object = new JSONObject();
        try {
            object.put(PstKpiSetting.fieldNames[PstKpiSetting.FLD_KPI_SETTING_ID], "" + entKpiSetting.getOID());
            object.put(PstKpiSetting.fieldNames[PstKpiSetting.FLD_VALID_DATE], (entKpiSetting.getValidDate() != null) ? Formater.formatDate(entKpiSetting.getValidDate(), "yyyy-MM-dd HH:mm:ss") : "0000-00-00 00:00:00");
            object.put(PstKpiSetting.fieldNames[PstKpiSetting.FLD_STATUS], "" + entKpiSetting.getStatus());
            object.put(PstKpiSetting.fieldNames[PstKpiSetting.FLD_START_DATE], (entKpiSetting.getStartDate() != null) ? Formater.formatDate(entKpiSetting.getStartDate(), "yyyy-MM-dd HH:mm:ss") : "0000-00-00 00:00:00");
            object.put(PstKpiSetting.fieldNames[PstKpiSetting.FLD_COMPANY_ID], "" + entKpiSetting.getCompanyId());
            object.put(PstKpiSetting.fieldNames[PstKpiSetting.FLD_TAHUN], "" + entKpiSetting.getTahun());
        } catch (Exception exc) {
            System.out.println("Err :" + exc);
        }
        return object;
    }

    public static long syncExc(JSONObject jSONObject) throws DBException {
        long oid = 0;
        try {
            oid = Long.valueOf((String) jSONObject.get(PstKpiSetting.fieldNames[PstKpiSetting.FLD_KPI_SETTING_ID]));
            KpiSetting entKpiSetting = PstKpiSetting.parseJsonObject(jSONObject);
            oid = entKpiSetting.getOID();
            boolean chekOid = PstKpiSetting.checkOID(oid);
            if (chekOid) {
                // Doing update
                oid = PstKpiSetting.updateExc(entKpiSetting);
            } else {
                // Doing insert
                oid = PstKpiSetting.insertExc(entKpiSetting);
            }
        } catch (Exception exc) {
            System.out.println("Err :" + exc);
        }
        return oid;
    }

    private static KpiSetting parseJsonObject(JSONObject jsonObject) {
        KpiSetting entKpiSetting = new KpiSetting();
        try {
            entKpiSetting.setOID(Long.valueOf((String) jsonObject.get(PstKpiSetting.fieldNames[PstKpiSetting.FLD_KPI_SETTING_ID])));
            entKpiSetting.setValidDate(Formater.formatDate((String) jsonObject.get(PstKpiSetting.fieldNames[PstKpiSetting.FLD_VALID_DATE]), "yyyy-MM-dd HH:mm:ss"));
            entKpiSetting.setStatus(Integer.valueOf((String) jsonObject.get(PstKpiSetting.fieldNames[PstKpiSetting.FLD_STATUS])));
            entKpiSetting.setStartDate(Formater.formatDate((String) jsonObject.get(PstKpiSetting.fieldNames[PstKpiSetting.FLD_START_DATE]), "yyyy-MM-dd HH:mm:ss"));
            entKpiSetting.setCompanyId(Long.valueOf((String) jsonObject.get(PstKpiSetting.fieldNames[PstKpiSetting.FLD_COMPANY_ID])));
            entKpiSetting.setTahun(Integer.valueOf((String) jsonObject.get(PstKpiSetting.fieldNames[PstKpiSetting.FLD_TAHUN])));
        } catch (Exception exc) {
            System.out.println("Err :" + exc);
        }
        return entKpiSetting;
    }

    public static boolean checkOID(long kpiSettingId) {
        DBResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + TBL_KPI_SETTING
                    + " WHERE " + PstKpiSetting.fieldNames[PstKpiSetting.FLD_KPI_SETTING_ID]
                    + " = " + kpiSettingId;
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                result = true;
            }
            rs.close();
        } catch (Exception exc) {
            System.out.println("Err :" + exc);
        } finally {
            DBResultSet.close(dbrs);
        }
        return result;
    }

}

/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.masterdata;

import com.dimata.qdep.db.DBException;
import com.dimata.qdep.db.DBHandler;
import com.dimata.qdep.db.DBResultSet;
import com.dimata.qdep.db.I_DBInterface;
import com.dimata.qdep.db.I_DBType;
import com.dimata.qdep.entity.Entity;
import com.dimata.qdep.entity.I_PersintentExc;
import com.dimata.util.lang.I_Language;
import java.sql.ResultSet;
import java.util.Vector;

/**
 *
 * @author GUSWIK
 */
public class PstKPI_List extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {

    public static final String TBL_HR_KPI_LIST = "hr_kpi_list";
    public static final int FLD_KPI_LIST_ID = 0;
    public static final int FLD_COMPANY_ID = 1;
    public static final int FLD_KPI_TITLE = 2;
    public static final int FLD_DESCRIPTION = 3;
    public static final int FLD_VALID_FROM = 4;
    public static final int FLD_VALID_TO = 5;
    public static final int FLD_VALUE_TYPE = 6;
    public static final int FLD_INPUT_TYPE = 7;
    public static final int FLD_PARENT_ID = 8;
    public static final int FLD_KORELASI = 9;
    public static final int FLD_RANGE_START = 10;
    public static final int FLD_RANGE_END = 11;

    public static final String[] fieldNames = {
        "KPI_LIST_ID",
        "COMPANY_ID",
        "KPI_TITLE",
        "DESCRIPTION",
        "VALID_FROM",
        "VALID_TO",
        "VALUE_TYPE",
        "INPUT_TYPE",
        "PARENT_ID",
        "KORELASI",
        "RANGE_START",
        "RANGE_END"
    };
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_DATE,
        TYPE_DATE,
        TYPE_STRING,
        TYPE_INT,
        TYPE_LONG,
        TYPE_INT,
        TYPE_FLOAT,
        TYPE_FLOAT
    };

    public static final int KORELASI_POSITIF = 0;
    public static final int KORELASI_NEGATIF = 1;

    public static final String[] strKorelasi = {
        "Positif",
        "Negatif"
    };

    public static final int TYPE_PERSENTASE = 0;
    public static final int TYPE_WAKTU = 1;
    public static final int TYPE_JUMLAH = 2;

    public static final String[] strType = {
        "Persentase",
        "Waktu",
        "Jumlah"
    };

    public PstKPI_List() {
    }

    public PstKPI_List(int i) throws DBException {
        super(new PstKPI_List());
    }

    public PstKPI_List(String sOid) throws DBException {
        super(new PstKPI_List(0));
        if (!locate(sOid)) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public PstKPI_List(long lOid) throws DBException {
        super(new PstKPI_List(0));
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
        return TBL_HR_KPI_LIST;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new PstKPI_List().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        KPI_List kPI_List = fetchExc(ent.getOID());
        ent = (Entity) kPI_List;
        return kPI_List.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((KPI_List) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((KPI_List) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static KPI_List fetchExc(long oid) throws DBException {
        try {
            KPI_List kPI_List = new KPI_List();
            PstKPI_List pstKPI_List = new PstKPI_List(oid);
            kPI_List.setOID(oid);

            kPI_List.setCompany_id(pstKPI_List.getlong(FLD_COMPANY_ID));
            kPI_List.setKpi_title(pstKPI_List.getString(FLD_KPI_TITLE));
            kPI_List.setDescription(pstKPI_List.getString(FLD_DESCRIPTION));
            kPI_List.setValid_from(pstKPI_List.getDate(FLD_VALID_FROM));
            kPI_List.setValid_to(pstKPI_List.getDate(FLD_VALID_TO));
            kPI_List.setValue_type(pstKPI_List.getString(FLD_VALUE_TYPE));
            kPI_List.setInputType(pstKPI_List.getInt(FLD_INPUT_TYPE));
            kPI_List.setParentId(pstKPI_List.getlong(FLD_PARENT_ID));
            kPI_List.setKorelasi(pstKPI_List.getInt(FLD_KORELASI));
            kPI_List.setRangeStart(pstKPI_List.getfloat(FLD_RANGE_START));
            kPI_List.setRangeEnd(pstKPI_List.getfloat(FLD_RANGE_END));
            return kPI_List;

        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstKPI_List(0), DBException.UNKNOWN);
        }
    }

    public static long insertExc(KPI_List kPI_List) throws DBException {
        try {
            PstKPI_List pstKPI_List = new PstKPI_List(0);

            pstKPI_List.setLong(FLD_COMPANY_ID, kPI_List.getCompany_id());
            pstKPI_List.setString(FLD_KPI_TITLE, kPI_List.getKpi_title());
            pstKPI_List.setString(FLD_DESCRIPTION, kPI_List.getDescription());
            pstKPI_List.setDate(FLD_VALID_FROM, kPI_List.getValid_from());
            pstKPI_List.setDate(FLD_VALID_TO, kPI_List.getValid_to());
            pstKPI_List.setString(FLD_VALUE_TYPE, kPI_List.getValue_type());
            pstKPI_List.setInt(FLD_INPUT_TYPE, kPI_List.getInputType());
            pstKPI_List.setLong(FLD_PARENT_ID, kPI_List.getParentId());
            pstKPI_List.setInt(FLD_KORELASI, kPI_List.getKorelasi());
            pstKPI_List.setFloat(FLD_RANGE_START, kPI_List.getRangeStart());
            pstKPI_List.setFloat(FLD_RANGE_END, kPI_List.getRangeEnd());

            pstKPI_List.insert();
            kPI_List.setOID(pstKPI_List.getlong(FLD_KPI_LIST_ID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstKPI_List(0), DBException.UNKNOWN);
        }
        return kPI_List.getOID();
    }

    public static long updateExc(KPI_List kPI_List) throws DBException {
        try {
            if (kPI_List.getOID() != 0) {
                PstKPI_List pstKPI_List = new PstKPI_List(kPI_List.getOID());

                pstKPI_List.setLong(FLD_COMPANY_ID, kPI_List.getCompany_id());
                pstKPI_List.setString(FLD_KPI_TITLE, kPI_List.getKpi_title());
                pstKPI_List.setString(FLD_DESCRIPTION, kPI_List.getDescription());
                pstKPI_List.setDate(FLD_VALID_FROM, kPI_List.getValid_from());
                pstKPI_List.setDate(FLD_VALID_TO, kPI_List.getValid_to());
                pstKPI_List.setString(FLD_VALUE_TYPE, kPI_List.getValue_type());
                pstKPI_List.setInt(FLD_INPUT_TYPE, kPI_List.getInputType());
                pstKPI_List.setLong(FLD_PARENT_ID, kPI_List.getParentId());
                pstKPI_List.setInt(FLD_KORELASI, kPI_List.getKorelasi());
                pstKPI_List.setFloat(FLD_RANGE_START, kPI_List.getRangeStart());
                pstKPI_List.setFloat(FLD_RANGE_END, kPI_List.getRangeEnd());
                pstKPI_List.update();

                pstKPI_List.update();
                return kPI_List.getOID();

            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstKPI_List(0), DBException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws DBException {
        try {
            PstKPI_List pstKPI_List = new PstKPI_List(oid);
            pstKPI_List.delete();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstKPI_List(0), DBException.UNKNOWN);
        }
        return oid;
    }

    public static Vector listAll() {
        return list(0, 500, "", "");
    }

    public static Vector list(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT * FROM " + TBL_HR_KPI_LIST;
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
                KPI_List kPI_List = new KPI_List();
                resultToObject(rs, kPI_List);
                lists.add(kPI_List);
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

    public static Vector listWithJoinSettingAndGroup(String whereClause) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT hr_kpi_list.`KPI_LIST_ID`, hr_kpi_list.`KPI_TITLE`, hr_kpi_list.`DESCRIPTION` FROM hr_kpi_setting \n"
                    + "INNER JOIN hr_kpi_setting_group ON hr_kpi_setting.`KPI_SETTING_ID` = hr_kpi_setting_group.`KPI_SETTING_ID` \n"
                    + "INNER JOIN hr_kpi_setting_list ON hr_kpi_setting.`KPI_SETTING_ID` = hr_kpi_setting_list.`KPI_SETTING_ID` \n"
                    + "INNER JOIN hr_kpi_list ON hr_kpi_setting_list.`KPI_LIST_ID` = hr_kpi_list.`KPI_LIST_ID` \n"
                    + "WHERE " + whereClause;
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                KPI_List entKpiList = new KPI_List();
                resultToObjectGetTitle(rs, entKpiList);
                lists.add(entKpiList);
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
    
    public static Vector listWithJoinGroup(String whereClause) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT hr_kpi_list.`KPI_LIST_ID`, hr_kpi_list.`KPI_TITLE` FROM hr_kpi_list \n"+
                            "JOIN hr_kpi_list_group ON hr_kpi_list.`KPI_LIST_ID` = hr_kpi_list_group.`KPI_LIST_ID` \n" +
                            "JOIN hr_kpi_group ON hr_kpi_list_group.`KPI_GROUP_ID` = hr_kpi_group.`KPI_GROUP_ID` \n" +
                            "WHERE " + whereClause;
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                KPI_List entKpiList = new KPI_List();
                resultToObjectGetTitle(rs, entKpiList);
                lists.add(entKpiList);
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

    public static Vector listInnerJoinKPIEmpTarget(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT * FROM " + TBL_HR_KPI_LIST + " hkl ";
            sql = sql + "INNER JOIN " + PstKPI_Employee_Target.TBL_HR_KPI_EMPLOYEE_TARGET + " hket ON hket." + PstKPI_Employee_Target.fieldNames[PstKPI_Employee_Target.FLD_KPI_LIST_ID] + " = hkl." + PstKPI_List.fieldNames[PstKPI_List.FLD_KPI_LIST_ID] + " ";
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
                KPI_List kPI_List = new KPI_List();
                resultToObject(rs, kPI_List);
                lists.add(kPI_List);
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

    public static void resultToObject(ResultSet rs, KPI_List kPI_List) {
        try {
            kPI_List.setOID(rs.getLong(PstKPI_List.fieldNames[PstKPI_List.FLD_KPI_LIST_ID]));
            kPI_List.setCompany_id(rs.getLong(PstKPI_List.fieldNames[PstKPI_List.FLD_COMPANY_ID]));
            kPI_List.setKpi_title(rs.getString(PstKPI_List.fieldNames[PstKPI_List.FLD_KPI_TITLE]));
            kPI_List.setDescription(rs.getString(PstKPI_List.fieldNames[PstKPI_List.FLD_DESCRIPTION]));
            kPI_List.setValid_from(rs.getDate(PstKPI_List.fieldNames[PstKPI_List.FLD_VALID_FROM]));
            kPI_List.setValid_to(rs.getDate(PstKPI_List.fieldNames[PstKPI_List.FLD_VALID_TO]));
            kPI_List.setValue_type(rs.getString(PstKPI_List.fieldNames[PstKPI_List.FLD_VALUE_TYPE]));
            kPI_List.setInputType(rs.getInt(PstKPI_List.fieldNames[PstKPI_List.FLD_INPUT_TYPE]));
            kPI_List.setParentId(rs.getLong(PstKPI_List.fieldNames[PstKPI_List.FLD_PARENT_ID]));
            kPI_List.setKorelasi(rs.getInt(PstKPI_List.fieldNames[PstKPI_List.FLD_KORELASI]));
            kPI_List.setRangeStart(rs.getFloat(PstKPI_List.fieldNames[PstKPI_List.FLD_RANGE_START]));
            kPI_List.setRangeEnd(rs.getFloat(PstKPI_List.fieldNames[PstKPI_List.FLD_RANGE_END]));

        } catch (Exception e) {
        }
    }
    
    /*eidt by suryawan*/
    public static void resultToObjectGetTitle(ResultSet rs, KPI_List kPI_List) {
        try {
            kPI_List.setOID(rs.getLong(PstKPI_List.fieldNames[PstKPI_List.FLD_KPI_LIST_ID]));
            kPI_List.setKpi_title(rs.getString(PstKPI_List.fieldNames[PstKPI_List.FLD_KPI_TITLE]));
            kPI_List.setDescription(rs.getString(PstKPI_List.fieldNames[PstKPI_List.FLD_DESCRIPTION]));
        } catch (Exception e) {
            System.out.println(e);
        } 
    }

    public static boolean checkOID(long kPI_ListId) {
        DBResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + TBL_HR_KPI_LIST + " WHERE "
                    + PstKPI_List.fieldNames[PstKPI_List.FLD_KPI_LIST_ID] + " = " + kPI_ListId;

            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                result = true;
            }
            rs.close();
        } catch (Exception e) {
            System.out.println("err : " + e.toString());
        } finally {
            DBResultSet.close(dbrs);
            return result;
        }
    }

    public static int getCount(String whereClause) {
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT COUNT(" + PstKPI_List.fieldNames[PstKPI_List.FLD_KPI_LIST_ID] + ") FROM " + TBL_HR_KPI_LIST;
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


    /* This method used to find current data */
    public static int findLimitStart(long oid, int recordToGet, String whereClause) {
        String order = "";
        int size = getCount(whereClause);
        int start = 0;
        boolean found = false;
        for (int i = 0; (i < size) && !found; i = i + recordToGet) {
            Vector list = list(i, recordToGet, whereClause, order);
            start = i;
            if (list.size() > 0) {
                for (int ls = 0; ls < list.size(); ls++) {
                    KPI_List kPI_List = (KPI_List) list.get(ls);
                    if (oid == kPI_List.getOID()) {
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

}

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.masterdata;

import com.dimata.qdep.db.*;
import java.sql.*;
import com.dimata.util.lang.I_Language;
import com.dimata.qdep.db.DBResultSet;
import static com.dimata.qdep.db.I_DBType.TYPE_ID;
import static com.dimata.qdep.db.I_DBType.TYPE_LONG;
import static com.dimata.qdep.db.I_DBType.TYPE_PK;
import com.dimata.qdep.entity.Entity;
import com.dimata.qdep.entity.I_PersintentExc;
import com.dimata.util.Command;
import java.util.Hashtable;
import java.util.Vector;
import org.json.JSONObject;

/**
 *
 * @author keys
 */
public class PstKPITypeCompany extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {

    public static final String TBL_KPITYPECOMPANY = "hr_kpi_type_company";
    public static final int FLD_KPI_TYPE_COMPANY_ID = 0;
    public static final int FLD_KPI_TYPE_ID = 1;
    public static final int FLD_COMPANY_ID = 2;

    public static String[] fieldNames = {
        "KPI_TYPE_COMPANY_ID",
        "KPI_TYPE_ID",
        "COMPANY_ID",};

    public static int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_LONG,};

    public PstKPITypeCompany() {
    }

    public PstKPITypeCompany(int i) throws DBException {
        super(new PstKPITypeCompany());
    }

    public PstKPITypeCompany(String sOid) throws DBException {
        super(new PstKPITypeCompany(0));
        if (!locate(sOid)) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public PstKPITypeCompany(long lOid) throws DBException {
        super(new PstKPITypeCompany(0));
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
        return TBL_KPITYPECOMPANY;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new PstKPITypeCompany().getClass().getName();
    }

    public static KPITypeCompany fetchExc(long oid) throws DBException {
        try {
            KPITypeCompany entKpitypecompany = new KPITypeCompany();
            PstKPITypeCompany pstKpitypecompany = new PstKPITypeCompany(oid);
            entKpitypecompany.setOID(oid);
            entKpitypecompany.setKpiTypeId(pstKpitypecompany.getlong(FLD_KPI_TYPE_ID));
            entKpitypecompany.setCompanyId(pstKpitypecompany.getlong(FLD_COMPANY_ID));
            return entKpitypecompany;
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstKPITypeCompany(0), DBException.UNKNOWN);
        }
    }

    public long fetchExc(Entity entity) throws Exception {
        KPITypeCompany entKPITypeCompany = fetchExc(entity.getOID());
        entity = (Entity) entKPITypeCompany;
        return entKPITypeCompany.getOID();
    }

    public static synchronized long updateExc(KPITypeCompany entKPITypeCompany) throws DBException {
        try {
            if (entKPITypeCompany.getOID() != 0) {
                PstKPITypeCompany pstKPITypeCompany = new PstKPITypeCompany(entKPITypeCompany.getOID());
                pstKPITypeCompany.setLong(FLD_KPI_TYPE_ID, entKPITypeCompany.getKpiTypeId());
                pstKPITypeCompany.setLong(FLD_COMPANY_ID, entKPITypeCompany.getCompanyId());
                pstKPITypeCompany.update();
                return entKPITypeCompany.getOID();
            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstKPITypeCompany(0), DBException.UNKNOWN);
        }
        return 0;
    }

    public long updateExc(Entity entity) throws Exception {
        return updateExc((KPITypeCompany) entity);
    }

    public static synchronized long deleteExc(long oid) throws DBException {
        try {
            PstKPITypeCompany pstKPITypeCompany = new PstKPITypeCompany(oid);
            pstKPITypeCompany.delete();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstKPITypeCompany(0), DBException.UNKNOWN);
        }
        return oid;
    }

    public long deleteExc(Entity entity) throws Exception {
        if (entity == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(entity.getOID());
    }

    public static synchronized long insertExc(KPITypeCompany entKPITypeCompany) throws DBException {
        try {
            PstKPITypeCompany pstKPITypeCompany = new PstKPITypeCompany(0);
            pstKPITypeCompany.setLong(FLD_KPI_TYPE_ID, entKPITypeCompany.getKpiTypeId());
            pstKPITypeCompany.setLong(FLD_COMPANY_ID, entKPITypeCompany.getCompanyId());
            pstKPITypeCompany.insert();
            entKPITypeCompany.setOID(pstKPITypeCompany.getlong(FLD_KPI_TYPE_ID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstKPITypeCompany(0), DBException.UNKNOWN);
        }
        return entKPITypeCompany.getOID();
    }

    public long insertExc(Entity entity) throws Exception {
        return insertExc((KPITypeCompany) entity);
    }

    public static void resultToObject(ResultSet rs, KPITypeCompany entKPITypeCompany) {
        try {
            entKPITypeCompany.setOID(rs.getLong(PstKPITypeCompany.fieldNames[PstKPITypeCompany.FLD_KPI_TYPE_COMPANY_ID]));
            entKPITypeCompany.setKpiTypeId(rs.getLong(PstKPITypeCompany.fieldNames[PstKPITypeCompany.FLD_KPI_TYPE_ID]));
            entKPITypeCompany.setCompanyId(rs.getLong(PstKPITypeCompany.fieldNames[PstKPITypeCompany.FLD_COMPANY_ID]));
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
            String sql = "SELECT * FROM " + TBL_KPITYPECOMPANY;
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
                KPITypeCompany entKPITypeCompany = new KPITypeCompany();
                resultToObject(rs, entKPITypeCompany);
                lists.add(entKPITypeCompany);
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

    public static Vector listKPITypeCompany(long oid_kpi_type) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT\n"
                    + "  DISTINCT(comp.`GEN_ID`) AS GEN_ID\n"
                    + "FROM\n"
                    + "  pay_general comp\n"
                    + "  INNER JOIN `hr_kpi_type_company` AS map\n"
                    + "  ON comp.`GEN_ID` = map.`COMPANY_ID`\n"
                    + "WHERE map.kpi_type_id = " + oid_kpi_type;
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                Company company = new Company();
                company = PstCompany.fetchExc(rs.getLong(PstCompany.fieldNames[PstCompany.FLD_COMPANY_ID]));
                lists.add(company);
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

    public static Hashtable listHashTable(int limitStart, int recordToGet, String whereClause, String order) {
        Hashtable lists = new Hashtable();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT * FROM " + TBL_KPITYPECOMPANY;
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
                lists.put(rs.getLong(PstKPITypeCompany.fieldNames[PstKPITypeCompany.FLD_COMPANY_ID]), rs.getLong(PstKPITypeCompany.fieldNames[PstKPITypeCompany.FLD_KPI_TYPE_ID]));

            }
            rs.close();
            return lists;
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return new Hashtable();
    }

    public static int getCount(String whereClause) {
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT COUNT(" + PstKPITypeCompany.fieldNames[PstKPITypeCompany.FLD_KPI_TYPE_ID] + ") FROM " + TBL_KPITYPECOMPANY;
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
                    KPITypeCompany entKPITypeCompany = (KPITypeCompany) list.get(ls);
                    if (oid == entKPITypeCompany.getOID()) {
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

    public static JSONObject fetchJSON(KPITypeCompany entKPITypeCompany) {
        JSONObject object = new JSONObject();
        try {
            object.put(PstKPITypeCompany.fieldNames[PstKPITypeCompany.FLD_KPI_TYPE_COMPANY_ID], "" + entKPITypeCompany.getOID());
            object.put(PstKPITypeCompany.fieldNames[PstKPITypeCompany.FLD_KPI_TYPE_ID], "" + entKPITypeCompany.getKpiTypeId());
            object.put(PstKPITypeCompany.fieldNames[PstKPITypeCompany.FLD_COMPANY_ID], "" + entKPITypeCompany.getCompanyId());
        } catch (Exception exc) {
            System.out.println("Err :" + exc);
        }
        return object;
    }

    public static long syncExc(JSONObject jSONObject) throws DBException {
        long oid = 0;
        try {
            oid = Long.valueOf((String) jSONObject.get(PstKPITypeCompany.fieldNames[PstKPITypeCompany.FLD_KPI_TYPE_COMPANY_ID]));
            KPITypeCompany entKPITypeCompany = PstKPITypeCompany.parseJsonObject(jSONObject);
            oid = entKPITypeCompany.getOID();
            boolean chekOid = PstKPITypeCompany.checkOID(oid);
            if (chekOid) {
                // Doing update
                oid = PstKPITypeCompany.updateExc(entKPITypeCompany);
            } else {
                // Doing insert
                oid = PstKPITypeCompany.insertExc(entKPITypeCompany);
            }
        } catch (Exception exc) {
            System.out.println("Err :" + exc);
        }
        return oid;
    }

    private static KPITypeCompany parseJsonObject(JSONObject jsonObject) {
        KPITypeCompany entKPITypeCompany = new KPITypeCompany();
        try {
            entKPITypeCompany.setOID(Long.valueOf((String) jsonObject.get(PstKPITypeCompany.fieldNames[PstKPITypeCompany.FLD_KPI_TYPE_COMPANY_ID])));
            entKPITypeCompany.setKpiTypeId(Long.valueOf((String) jsonObject.get(PstKPITypeCompany.fieldNames[PstKPITypeCompany.FLD_KPI_TYPE_ID])));
            entKPITypeCompany.setCompanyId(Long.valueOf((String) jsonObject.get(PstKPITypeCompany.fieldNames[PstKPITypeCompany.FLD_COMPANY_ID])));

        } catch (Exception exc) {
            System.out.println("Err :" + exc);
        }
        return entKPITypeCompany;
    }

    public static boolean checkOID(long kpiTypeCompanyId) {
        DBResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + TBL_KPITYPECOMPANY
                    + " WHERE " + PstKPITypeCompany.fieldNames[PstKPITypeCompany.FLD_KPI_TYPE_COMPANY_ID]
                    + " = " + kpiTypeCompanyId;
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

    public static long deleteByKPITypeId(long kpi_typ_oid) {
        DBResultSet dbrs = null;
        try {
            String sql = "DELETE FROM " + PstKPITypeCompany.TBL_KPITYPECOMPANY
                    + " WHERE " + PstKPITypeCompany.fieldNames[PstKPITypeCompany.FLD_KPI_TYPE_ID]
                    + " = '" + kpi_typ_oid + "'";

            int status = DBHandler.execUpdate(sql);
            return kpi_typ_oid;
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }

        return 0;
    }

    /**
     *
     * @param limitStart
     * @param recordToGet
     * @param whereClause
     * @param order
     * @return
     */
    public static Hashtable listJoinDevision(int limitStart, int recordToGet, String whereClause, String order) {
        Hashtable lists = new Hashtable();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT\n"
                    + " hd.`DIVISION`\n"
                    + "FROM `" + PstCompany.TBL_HR_COMPANY + "` pg\n"
                    + "INNER JOIN `" + TBL_KPITYPECOMPANY + "` hktc\n"
                    + "ON `hktc`.`" + fieldNames[FLD_COMPANY_ID] + "` = pg.`GEN_ID`\n"
                    + "INNER JOIN `hr_division` hd\n"
                    + "ON hd.`COMPANY_ID` = `hktc`.`COMPANY_ID`";
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
                lists.put(rs.getLong(PstKPITypeCompany.fieldNames[PstKPITypeCompany.FLD_COMPANY_ID]), rs.getLong(PstKPITypeCompany.fieldNames[PstKPITypeCompany.FLD_KPI_TYPE_ID]));
            }
            rs.close();
            return lists;
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return new Hashtable();
    }
}

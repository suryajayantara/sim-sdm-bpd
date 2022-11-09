/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.masterdata;

/**
 *
 * @author Dimata 007
 */
import com.dimata.qdep.db.DBException;
import com.dimata.qdep.db.DBHandler;
import com.dimata.qdep.db.DBResultSet;
import com.dimata.qdep.db.I_DBInterface;
import com.dimata.qdep.db.I_DBType;
import com.dimata.qdep.entity.Entity;
import com.dimata.qdep.entity.I_PersintentExc;
import com.dimata.util.Command;
import com.dimata.util.lang.I_Language;
import java.sql.ResultSet;
import java.util.Vector;

public class PstEmpDocSeries extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {

    public static final String TBL_EMP_DOC_SERIES = "hr_emp_doc_series";
    public static final int FLD_EMP_DOC_SERIES_ID = 0;
    public static final int FLD_COMPANY_ID = 1;
    public static final int FLD_DIVISION_ID = 2;
    public static final int FLD_DEPARTMENT_ID = 3;
    public static final int FLD_SECTION_ID = 4;
    public static final int FLD_NOMOR_DOC_SERIES = 5;
    public static String[] fieldNames = {
        "EMP_DOC_SERIES_ID",
        "COMPANY_ID",
        "DIVISION_ID",
        "DEPARTMENT_ID",
        "SECTION_ID",
        "NOMOR_DOC_SERIES"
    };
    public static int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_STRING
    };

    public PstEmpDocSeries() {
    }

    public PstEmpDocSeries(int i) throws DBException {
        super(new PstEmpDocSeries());
    }

    public PstEmpDocSeries(String sOid) throws DBException {
        super(new PstEmpDocSeries(0));
        if (!locate(sOid)) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public PstEmpDocSeries(long lOid) throws DBException {
        super(new PstEmpDocSeries(0));
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
        return TBL_EMP_DOC_SERIES;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new PstEmpDocSeries().getClass().getName();
    }

    public static EmpDocSeries fetchExc(long oid) throws DBException {
        try {
            EmpDocSeries entEmpDocSeries = new EmpDocSeries();
            PstEmpDocSeries pstEmpDocSeries = new PstEmpDocSeries(oid);
            entEmpDocSeries.setOID(oid);
            entEmpDocSeries.setCompanyId(pstEmpDocSeries.getLong(FLD_COMPANY_ID));
            entEmpDocSeries.setDivisionId(pstEmpDocSeries.getLong(FLD_DIVISION_ID));
            entEmpDocSeries.setDepartmentId(pstEmpDocSeries.getLong(FLD_DEPARTMENT_ID));
            entEmpDocSeries.setSectionId(pstEmpDocSeries.getLong(FLD_SECTION_ID));
            entEmpDocSeries.setNomorDocSeries(pstEmpDocSeries.getString(FLD_NOMOR_DOC_SERIES));
            return entEmpDocSeries;
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstEmpDocSeries(0), DBException.UNKNOWN);
        }
    }

    public long fetchExc(Entity entity) throws Exception {
        EmpDocSeries entEmpDocSeries = fetchExc(entity.getOID());
        entity = (Entity) entEmpDocSeries;
        return entEmpDocSeries.getOID();
    }

    public static synchronized long updateExc(EmpDocSeries entEmpDocSeries) throws DBException {
        try {
            if (entEmpDocSeries.getOID() != 0) {
                PstEmpDocSeries pstEmpDocSeries = new PstEmpDocSeries(entEmpDocSeries.getOID());
                pstEmpDocSeries.setLong(FLD_COMPANY_ID, entEmpDocSeries.getCompanyId());
                pstEmpDocSeries.setLong(FLD_DIVISION_ID, entEmpDocSeries.getDivisionId());
                pstEmpDocSeries.setLong(FLD_DEPARTMENT_ID, entEmpDocSeries.getDepartmentId());
                pstEmpDocSeries.setLong(FLD_SECTION_ID, entEmpDocSeries.getSectionId());
                pstEmpDocSeries.setString(FLD_NOMOR_DOC_SERIES, entEmpDocSeries.getNomorDocSeries());
                pstEmpDocSeries.update();
                return entEmpDocSeries.getOID();
            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstEmpDocSeries(0), DBException.UNKNOWN);
        }
        return 0;
    }

    public long updateExc(Entity entity) throws Exception {
        return updateExc((EmpDocSeries) entity);
    }

    public static synchronized long deleteExc(long oid) throws DBException {
        try {
            PstEmpDocSeries pstEmpDocSeries = new PstEmpDocSeries(oid);
            pstEmpDocSeries.delete();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstEmpDocSeries(0), DBException.UNKNOWN);
        }
        return oid;
    }

    public long deleteExc(Entity entity) throws Exception {
        if (entity == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(entity.getOID());
    }

    public static synchronized long insertExc(EmpDocSeries entEmpDocSeries) throws DBException {
        try {
            PstEmpDocSeries pstEmpDocSeries = new PstEmpDocSeries(0);
            pstEmpDocSeries.setLong(FLD_COMPANY_ID, entEmpDocSeries.getCompanyId());
            pstEmpDocSeries.setLong(FLD_DIVISION_ID, entEmpDocSeries.getDivisionId());
            pstEmpDocSeries.setLong(FLD_DEPARTMENT_ID, entEmpDocSeries.getDepartmentId());
            pstEmpDocSeries.setLong(FLD_SECTION_ID, entEmpDocSeries.getSectionId());
            pstEmpDocSeries.setString(FLD_NOMOR_DOC_SERIES, entEmpDocSeries.getNomorDocSeries());
            pstEmpDocSeries.insert();
            entEmpDocSeries.setOID(pstEmpDocSeries.getLong(FLD_EMP_DOC_SERIES_ID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstEmpDocSeries(0), DBException.UNKNOWN);
        }
        return entEmpDocSeries.getOID();
    }

    public long insertExc(Entity entity) throws Exception {
        return insertExc((EmpDocSeries) entity);
    }

    public static void resultToObject(ResultSet rs, EmpDocSeries entEmpDocSeries) {
        try {
            entEmpDocSeries.setOID(rs.getLong(PstEmpDocSeries.fieldNames[PstEmpDocSeries.FLD_EMP_DOC_SERIES_ID]));
            entEmpDocSeries.setCompanyId(rs.getLong(PstEmpDocSeries.fieldNames[PstEmpDocSeries.FLD_COMPANY_ID]));
            entEmpDocSeries.setDivisionId(rs.getLong(PstEmpDocSeries.fieldNames[PstEmpDocSeries.FLD_DIVISION_ID]));
            entEmpDocSeries.setDepartmentId(rs.getLong(PstEmpDocSeries.fieldNames[PstEmpDocSeries.FLD_DEPARTMENT_ID]));
            entEmpDocSeries.setSectionId(rs.getLong(PstEmpDocSeries.fieldNames[PstEmpDocSeries.FLD_SECTION_ID]));
            entEmpDocSeries.setNomorDocSeries(rs.getString(PstEmpDocSeries.fieldNames[PstEmpDocSeries.FLD_NOMOR_DOC_SERIES]));
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
            String sql = "SELECT * FROM " + TBL_EMP_DOC_SERIES;
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
                EmpDocSeries entEmpDocSeries = new EmpDocSeries();
                resultToObject(rs, entEmpDocSeries);
                lists.add(entEmpDocSeries);
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

    public static boolean checkOID(long entEmpDocSeriesId) {
        DBResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + TBL_EMP_DOC_SERIES + " WHERE "
                    + PstEmpDocSeries.fieldNames[PstEmpDocSeries.FLD_EMP_DOC_SERIES_ID] + " = " + entEmpDocSeriesId;
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
            String sql = "SELECT COUNT(" + PstEmpDocSeries.fieldNames[PstEmpDocSeries.FLD_EMP_DOC_SERIES_ID] + ") FROM " + TBL_EMP_DOC_SERIES;
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
                    EmpDocSeries entEmpDocSeries = (EmpDocSeries) list.get(ls);
                    if (oid == entEmpDocSeries.getOID()) {
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
}

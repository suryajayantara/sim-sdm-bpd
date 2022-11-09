/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.employee;

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
import com.dimata.util.lang.I_Language;
import java.sql.ResultSet;
import java.util.Vector;

public class PstCandidatePositionKpi extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {

    public static final String TBL_CANDIDATE_POSITION_KPI = "hr_candidate_position_kpi";
    public static final int FLD_CAND_POS_KPI_ID = 0;
    public static final int FLD_CANDIDATE_MAIN_ID = 1;
    public static final int FLD_POSITION_ID = 2;
    public static final int FLD_KPI_ID = 3;
    public static final int FLD_SCORE_MIN = 4;
    public static final int FLD_SCORE_MAX = 5;
    public static String[] fieldNames = {
        "CAND_POS_KPI_ID",
        "CANDIDATE_MAIN_ID",
        "POSITION_ID",
        "KPI_ID",
        "SCORE_MIN",
        "SCORE_MAX"
    };
    public static int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_INT,
        TYPE_INT
    };

    public PstCandidatePositionKpi() {
    }

    public PstCandidatePositionKpi(int i) throws DBException {
        super(new PstCandidatePositionKpi());
    }

    public PstCandidatePositionKpi(String sOid) throws DBException {
        super(new PstCandidatePositionKpi(0));
        if (!locate(sOid)) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public PstCandidatePositionKpi(long lOid) throws DBException {
        super(new PstCandidatePositionKpi(0));
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
        return TBL_CANDIDATE_POSITION_KPI;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new PstCandidatePositionKpi().getClass().getName();
    }

    public static CandidatePositionKpi fetchExc(long oid) throws DBException {
        try {
            CandidatePositionKpi entCandidatePositionKpi = new CandidatePositionKpi();
            PstCandidatePositionKpi pstCandidatePositionKpi = new PstCandidatePositionKpi(oid);
            entCandidatePositionKpi.setOID(oid);
            entCandidatePositionKpi.setCandidateMainId(pstCandidatePositionKpi.getLong(FLD_CANDIDATE_MAIN_ID));
            entCandidatePositionKpi.setPositionId(pstCandidatePositionKpi.getLong(FLD_POSITION_ID));
            entCandidatePositionKpi.setKpiId(pstCandidatePositionKpi.getLong(FLD_KPI_ID));
            entCandidatePositionKpi.setScoreMin(pstCandidatePositionKpi.getInt(FLD_SCORE_MIN));
            entCandidatePositionKpi.setScoreMax(pstCandidatePositionKpi.getInt(FLD_SCORE_MAX));
            return entCandidatePositionKpi;
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstCandidatePositionKpi(0), DBException.UNKNOWN);
        }
    }

    public long fetchExc(Entity entity) throws Exception {
        CandidatePositionKpi entCandidatePositionKpi = fetchExc(entity.getOID());
        entity = (Entity) entCandidatePositionKpi;
        return entCandidatePositionKpi.getOID();
    }

    public static synchronized long updateExc(CandidatePositionKpi entCandidatePositionKpi) throws DBException {
        try {
            if (entCandidatePositionKpi.getOID() != 0) {
                PstCandidatePositionKpi pstCandidatePositionKpi = new PstCandidatePositionKpi(entCandidatePositionKpi.getOID());
                pstCandidatePositionKpi.setLong(FLD_CANDIDATE_MAIN_ID, entCandidatePositionKpi.getCandidateMainId());
                pstCandidatePositionKpi.setLong(FLD_POSITION_ID, entCandidatePositionKpi.getPositionId());
                pstCandidatePositionKpi.setLong(FLD_KPI_ID, entCandidatePositionKpi.getKpiId());
                pstCandidatePositionKpi.setInt(FLD_SCORE_MIN, entCandidatePositionKpi.getScoreMin());
                pstCandidatePositionKpi.setInt(FLD_SCORE_MAX, entCandidatePositionKpi.getScoreMax());
                pstCandidatePositionKpi.update();
                return entCandidatePositionKpi.getOID();
            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstCandidatePositionKpi(0), DBException.UNKNOWN);
        }
        return 0;
    }

    public long updateExc(Entity entity) throws Exception {
        return updateExc((CandidatePositionKpi) entity);
    }

    public static synchronized long deleteExc(long oid) throws DBException {
        try {
            PstCandidatePositionKpi pstCandidatePositionKpi = new PstCandidatePositionKpi(oid);
            pstCandidatePositionKpi.delete();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstCandidatePositionKpi(0), DBException.UNKNOWN);
        }
        return oid;
    }

    public long deleteExc(Entity entity) throws Exception {
        if (entity == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(entity.getOID());
    }

    public static synchronized long insertExc(CandidatePositionKpi entCandidatePositionKpi) throws DBException {
        try {
            PstCandidatePositionKpi pstCandidatePositionKpi = new PstCandidatePositionKpi(0);
            pstCandidatePositionKpi.setLong(FLD_CANDIDATE_MAIN_ID, entCandidatePositionKpi.getCandidateMainId());
            pstCandidatePositionKpi.setLong(FLD_POSITION_ID, entCandidatePositionKpi.getPositionId());
            pstCandidatePositionKpi.setLong(FLD_KPI_ID, entCandidatePositionKpi.getKpiId());
            pstCandidatePositionKpi.setInt(FLD_SCORE_MIN, entCandidatePositionKpi.getScoreMin());
            pstCandidatePositionKpi.setInt(FLD_SCORE_MAX, entCandidatePositionKpi.getScoreMax());
            pstCandidatePositionKpi.insert();
            entCandidatePositionKpi.setOID(pstCandidatePositionKpi.getLong(FLD_CAND_POS_KPI_ID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstCandidatePositionKpi(0), DBException.UNKNOWN);
        }
        return entCandidatePositionKpi.getOID();
    }

    public long insertExc(Entity entity) throws Exception {
        return insertExc((CandidatePositionKpi) entity);
    }

    public static void resultToObject(ResultSet rs, CandidatePositionKpi entCandidatePositionKpi) {
        try {
            entCandidatePositionKpi.setOID(rs.getLong(PstCandidatePositionKpi.fieldNames[PstCandidatePositionKpi.FLD_CAND_POS_KPI_ID]));
            entCandidatePositionKpi.setCandidateMainId(rs.getLong(PstCandidatePositionKpi.fieldNames[PstCandidatePositionKpi.FLD_CANDIDATE_MAIN_ID]));
            entCandidatePositionKpi.setPositionId(rs.getLong(PstCandidatePositionKpi.fieldNames[PstCandidatePositionKpi.FLD_POSITION_ID]));
            entCandidatePositionKpi.setKpiId(rs.getLong(PstCandidatePositionKpi.fieldNames[PstCandidatePositionKpi.FLD_KPI_ID]));
            entCandidatePositionKpi.setScoreMin(rs.getInt(PstCandidatePositionKpi.fieldNames[PstCandidatePositionKpi.FLD_SCORE_MIN]));
            entCandidatePositionKpi.setScoreMax(rs.getInt(PstCandidatePositionKpi.fieldNames[PstCandidatePositionKpi.FLD_SCORE_MAX]));
        } catch (Exception e) {
        }
    }

    public static Vector list(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT * FROM " + TBL_CANDIDATE_POSITION_KPI;
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
                CandidatePositionKpi entCandidatePositionKpi = new CandidatePositionKpi();
                resultToObject(rs, entCandidatePositionKpi);
                lists.add(entCandidatePositionKpi);
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

}

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

public class PstCandidatePositionEducation extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {

    public static final String TBL_CANDIDATE_POSITION_EDUCATION = "hr_candidate_position_education";
    public static final int FLD_CAND_POS_EDU_ID = 0;
    public static final int FLD_CANDIDATE_MAIN_ID = 1;
    public static final int FLD_POSITION_ID = 2;
    public static final int FLD_EDUCATION_ID = 3;
    public static final int FLD_SCORE_MIN = 4;
    public static final int FLD_SCORE_MAX = 5;
    public static final int FLD_KONDISI = 6;
    public static String[] fieldNames = {
        "CAND_POS_EDU_ID",
        "CANDIDATE_MAIN_ID",
        "POSITION_ID",
        "EDUCATION_ID",
        "SCORE_MIN",
        "SCORE_MAX",
        "KONDISI"
    };
    public static int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_INT,
        TYPE_INT,
        TYPE_INT
    };

    public PstCandidatePositionEducation() {
    }

    public PstCandidatePositionEducation(int i) throws DBException {
        super(new PstCandidatePositionEducation());
    }

    public PstCandidatePositionEducation(String sOid) throws DBException {
        super(new PstCandidatePositionEducation(0));
        if (!locate(sOid)) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public PstCandidatePositionEducation(long lOid) throws DBException {
        super(new PstCandidatePositionEducation(0));
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
        return TBL_CANDIDATE_POSITION_EDUCATION;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new PstCandidatePositionEducation().getClass().getName();
    }

    public static CandidatePositionEducation fetchExc(long oid) throws DBException {
        try {
            CandidatePositionEducation entCandidatePositionEducation = new CandidatePositionEducation();
            PstCandidatePositionEducation pstCandidatePositionEducation = new PstCandidatePositionEducation(oid);
            entCandidatePositionEducation.setOID(oid);
            entCandidatePositionEducation.setCandidateMainId(pstCandidatePositionEducation.getLong(FLD_CANDIDATE_MAIN_ID));
            entCandidatePositionEducation.setPositionId(pstCandidatePositionEducation.getLong(FLD_POSITION_ID));
            entCandidatePositionEducation.setEducationId(pstCandidatePositionEducation.getLong(FLD_EDUCATION_ID));
            entCandidatePositionEducation.setScoreMin(pstCandidatePositionEducation.getInt(FLD_SCORE_MIN));
            entCandidatePositionEducation.setScoreMax(pstCandidatePositionEducation.getInt(FLD_SCORE_MAX));
            entCandidatePositionEducation.setKondisi(pstCandidatePositionEducation.getInt(FLD_KONDISI));
            return entCandidatePositionEducation;
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstCandidatePositionEducation(0), DBException.UNKNOWN);
        }
    }

    public long fetchExc(Entity entity) throws Exception {
        CandidatePositionEducation entCandidatePositionEducation = fetchExc(entity.getOID());
        entity = (Entity) entCandidatePositionEducation;
        return entCandidatePositionEducation.getOID();
    }

    public static synchronized long updateExc(CandidatePositionEducation entCandidatePositionEducation) throws DBException {
        try {
            if (entCandidatePositionEducation.getOID() != 0) {
                PstCandidatePositionEducation pstCandidatePositionEducation = new PstCandidatePositionEducation(entCandidatePositionEducation.getOID());
                pstCandidatePositionEducation.setLong(FLD_CANDIDATE_MAIN_ID, entCandidatePositionEducation.getCandidateMainId());
                pstCandidatePositionEducation.setLong(FLD_POSITION_ID, entCandidatePositionEducation.getPositionId());
                pstCandidatePositionEducation.setLong(FLD_EDUCATION_ID, entCandidatePositionEducation.getEducationId());
                pstCandidatePositionEducation.setInt(FLD_SCORE_MIN, entCandidatePositionEducation.getScoreMin());
                pstCandidatePositionEducation.setInt(FLD_SCORE_MAX, entCandidatePositionEducation.getScoreMax());
                pstCandidatePositionEducation.setInt(FLD_KONDISI, entCandidatePositionEducation.getKondisi());
                pstCandidatePositionEducation.update();
                return entCandidatePositionEducation.getOID();
            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstCandidatePositionEducation(0), DBException.UNKNOWN);
        }
        return 0;
    }

    public long updateExc(Entity entity) throws Exception {
        return updateExc((CandidatePositionEducation) entity);
    }

    public static synchronized long deleteExc(long oid) throws DBException {
        try {
            PstCandidatePositionEducation pstCandidatePositionEducation = new PstCandidatePositionEducation(oid);
            pstCandidatePositionEducation.delete();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstCandidatePositionEducation(0), DBException.UNKNOWN);
        }
        return oid;
    }

    public long deleteExc(Entity entity) throws Exception {
        if (entity == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(entity.getOID());
    }

    public static synchronized long insertExc(CandidatePositionEducation entCandidatePositionEducation) throws DBException {
        try {
            PstCandidatePositionEducation pstCandidatePositionEducation = new PstCandidatePositionEducation(0);
            pstCandidatePositionEducation.setLong(FLD_CANDIDATE_MAIN_ID, entCandidatePositionEducation.getCandidateMainId());
            pstCandidatePositionEducation.setLong(FLD_POSITION_ID, entCandidatePositionEducation.getPositionId());
            pstCandidatePositionEducation.setLong(FLD_EDUCATION_ID, entCandidatePositionEducation.getEducationId());
            pstCandidatePositionEducation.setInt(FLD_SCORE_MIN, entCandidatePositionEducation.getScoreMin());
            pstCandidatePositionEducation.setInt(FLD_SCORE_MAX, entCandidatePositionEducation.getScoreMax());
            pstCandidatePositionEducation.setInt(FLD_KONDISI, entCandidatePositionEducation.getKondisi());
            pstCandidatePositionEducation.insert();
            entCandidatePositionEducation.setOID(pstCandidatePositionEducation.getLong(FLD_CAND_POS_EDU_ID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstCandidatePositionEducation(0), DBException.UNKNOWN);
        }
        return entCandidatePositionEducation.getOID();
    }

    public long insertExc(Entity entity) throws Exception {
        return insertExc((CandidatePositionEducation) entity);
    }

    public static void resultToObject(ResultSet rs, CandidatePositionEducation entCandidatePositionEducation) {
        try {
            entCandidatePositionEducation.setOID(rs.getLong(PstCandidatePositionEducation.fieldNames[PstCandidatePositionEducation.FLD_CAND_POS_EDU_ID]));
            entCandidatePositionEducation.setCandidateMainId(rs.getLong(PstCandidatePositionEducation.fieldNames[PstCandidatePositionEducation.FLD_CANDIDATE_MAIN_ID]));
            entCandidatePositionEducation.setPositionId(rs.getLong(PstCandidatePositionEducation.fieldNames[PstCandidatePositionEducation.FLD_POSITION_ID]));
            entCandidatePositionEducation.setEducationId(rs.getLong(PstCandidatePositionEducation.fieldNames[PstCandidatePositionEducation.FLD_EDUCATION_ID]));
            entCandidatePositionEducation.setScoreMin(rs.getInt(PstCandidatePositionEducation.fieldNames[PstCandidatePositionEducation.FLD_SCORE_MIN]));
            entCandidatePositionEducation.setScoreMax(rs.getInt(PstCandidatePositionEducation.fieldNames[PstCandidatePositionEducation.FLD_SCORE_MAX]));
            entCandidatePositionEducation.setKondisi(rs.getInt(PstCandidatePositionEducation.fieldNames[PstCandidatePositionEducation.FLD_KONDISI]));
        } catch (Exception e) {
        }
    }

    public static Vector list(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT * FROM " + TBL_CANDIDATE_POSITION_EDUCATION;
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
                CandidatePositionEducation entCandidatePositionEducation = new CandidatePositionEducation();
                resultToObject(rs, entCandidatePositionEducation);
                lists.add(entCandidatePositionEducation);
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
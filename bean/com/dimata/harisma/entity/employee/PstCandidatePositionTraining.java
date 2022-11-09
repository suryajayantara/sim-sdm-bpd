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

public class PstCandidatePositionTraining extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {

    public static final String TBL_CANDIDATE_POSITION_TRAINING = "hr_candidate_position_training";
    public static final int FLD_CAND_POS_TRAINING_ID = 0;
    public static final int FLD_CANDIDATE_MAIN_ID = 1;
    public static final int FLD_POSITION_ID = 2;
    public static final int FLD_TRAINING_ID = 3;
    public static final int FLD_SCORE_MIN = 4;
    public static final int FLD_SCORE_MAX = 5;
    public static final int FLD_KONDISI = 6;
    public static String[] fieldNames = {
        "CAND_POS_TRAINING_ID",
        "CANDIDATE_MAIN_ID",
        "POSITION_ID",
        "TRAINING_ID",
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

    public PstCandidatePositionTraining() {
    }

    public PstCandidatePositionTraining(int i) throws DBException {
        super(new PstCandidatePositionTraining());
    }

    public PstCandidatePositionTraining(String sOid) throws DBException {
        super(new PstCandidatePositionTraining(0));
        if (!locate(sOid)) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public PstCandidatePositionTraining(long lOid) throws DBException {
        super(new PstCandidatePositionTraining(0));
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
        return TBL_CANDIDATE_POSITION_TRAINING;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new PstCandidatePositionTraining().getClass().getName();
    }

    public static CandidatePositionTraining fetchExc(long oid) throws DBException {
        try {
            CandidatePositionTraining entCandidatePositionTraining = new CandidatePositionTraining();
            PstCandidatePositionTraining pstCandidatePositionTraining = new PstCandidatePositionTraining(oid);
            entCandidatePositionTraining.setOID(oid);
            entCandidatePositionTraining.setCandidateMainId(pstCandidatePositionTraining.getLong(FLD_CANDIDATE_MAIN_ID));
            entCandidatePositionTraining.setPositionId(pstCandidatePositionTraining.getLong(FLD_POSITION_ID));
            entCandidatePositionTraining.setTrainingId(pstCandidatePositionTraining.getLong(FLD_TRAINING_ID));
            entCandidatePositionTraining.setScoreMin(pstCandidatePositionTraining.getInt(FLD_SCORE_MIN));
            entCandidatePositionTraining.setScoreMax(pstCandidatePositionTraining.getInt(FLD_SCORE_MAX));
            entCandidatePositionTraining.setKondisi(pstCandidatePositionTraining.getInt(FLD_KONDISI));
            return entCandidatePositionTraining;
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstCandidatePositionTraining(0), DBException.UNKNOWN);
        }
    }

    public long fetchExc(Entity entity) throws Exception {
        CandidatePositionTraining entCandidatePositionTraining = fetchExc(entity.getOID());
        entity = (Entity) entCandidatePositionTraining;
        return entCandidatePositionTraining.getOID();
    }

    public static synchronized long updateExc(CandidatePositionTraining entCandidatePositionTraining) throws DBException {
        try {
            if (entCandidatePositionTraining.getOID() != 0) {
                PstCandidatePositionTraining pstCandidatePositionTraining = new PstCandidatePositionTraining(entCandidatePositionTraining.getOID());
                pstCandidatePositionTraining.setLong(FLD_CANDIDATE_MAIN_ID, entCandidatePositionTraining.getCandidateMainId());
                pstCandidatePositionTraining.setLong(FLD_POSITION_ID, entCandidatePositionTraining.getPositionId());
                pstCandidatePositionTraining.setLong(FLD_TRAINING_ID, entCandidatePositionTraining.getTrainingId());
                pstCandidatePositionTraining.setInt(FLD_SCORE_MIN, entCandidatePositionTraining.getScoreMin());
                pstCandidatePositionTraining.setInt(FLD_SCORE_MAX, entCandidatePositionTraining.getScoreMax());
                pstCandidatePositionTraining.setInt(FLD_KONDISI, entCandidatePositionTraining.getKondisi());
                pstCandidatePositionTraining.update();
                return entCandidatePositionTraining.getOID();
            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstCandidatePositionTraining(0), DBException.UNKNOWN);
        }
        return 0;
    }

    public long updateExc(Entity entity) throws Exception {
        return updateExc((CandidatePositionTraining) entity);
    }

    public static synchronized long deleteExc(long oid) throws DBException {
        try {
            PstCandidatePositionTraining pstCandidatePositionTraining = new PstCandidatePositionTraining(oid);
            pstCandidatePositionTraining.delete();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstCandidatePositionTraining(0), DBException.UNKNOWN);
        }
        return oid;
    }

    public long deleteExc(Entity entity) throws Exception {
        if (entity == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(entity.getOID());
    }

    public static synchronized long insertExc(CandidatePositionTraining entCandidatePositionTraining) throws DBException {
        try {
            PstCandidatePositionTraining pstCandidatePositionTraining = new PstCandidatePositionTraining(0);
            pstCandidatePositionTraining.setLong(FLD_CANDIDATE_MAIN_ID, entCandidatePositionTraining.getCandidateMainId());
            pstCandidatePositionTraining.setLong(FLD_POSITION_ID, entCandidatePositionTraining.getPositionId());
            pstCandidatePositionTraining.setLong(FLD_TRAINING_ID, entCandidatePositionTraining.getTrainingId());
            pstCandidatePositionTraining.setInt(FLD_SCORE_MIN, entCandidatePositionTraining.getScoreMin());
            pstCandidatePositionTraining.setInt(FLD_SCORE_MAX, entCandidatePositionTraining.getScoreMax());
            pstCandidatePositionTraining.setInt(FLD_KONDISI, entCandidatePositionTraining.getKondisi());
            pstCandidatePositionTraining.insert();
            entCandidatePositionTraining.setOID(pstCandidatePositionTraining.getLong(FLD_CAND_POS_TRAINING_ID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstCandidatePositionTraining(0), DBException.UNKNOWN);
        }
        return entCandidatePositionTraining.getOID();
    }

    public long insertExc(Entity entity) throws Exception {
        return insertExc((CandidatePositionTraining) entity);
    }

    public static void resultToObject(ResultSet rs, CandidatePositionTraining entCandidatePositionTraining) {
        try {
            entCandidatePositionTraining.setOID(rs.getLong(PstCandidatePositionTraining.fieldNames[PstCandidatePositionTraining.FLD_CAND_POS_TRAINING_ID]));
            entCandidatePositionTraining.setCandidateMainId(rs.getLong(PstCandidatePositionTraining.fieldNames[PstCandidatePositionTraining.FLD_CANDIDATE_MAIN_ID]));
            entCandidatePositionTraining.setPositionId(rs.getLong(PstCandidatePositionTraining.fieldNames[PstCandidatePositionTraining.FLD_POSITION_ID]));
            entCandidatePositionTraining.setTrainingId(rs.getLong(PstCandidatePositionTraining.fieldNames[PstCandidatePositionTraining.FLD_TRAINING_ID]));
            entCandidatePositionTraining.setScoreMin(rs.getInt(PstCandidatePositionTraining.fieldNames[PstCandidatePositionTraining.FLD_SCORE_MIN]));
            entCandidatePositionTraining.setScoreMax(rs.getInt(PstCandidatePositionTraining.fieldNames[PstCandidatePositionTraining.FLD_SCORE_MAX]));
            entCandidatePositionTraining.setKondisi(rs.getInt(PstCandidatePositionTraining.fieldNames[PstCandidatePositionTraining.FLD_KONDISI]));
        } catch (Exception e) {
        }
    }

    public static Vector list(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT * FROM " + TBL_CANDIDATE_POSITION_TRAINING;
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
                CandidatePositionTraining entCandidatePositionTraining = new CandidatePositionTraining();
                resultToObject(rs, entCandidatePositionTraining);
                lists.add(entCandidatePositionTraining);
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
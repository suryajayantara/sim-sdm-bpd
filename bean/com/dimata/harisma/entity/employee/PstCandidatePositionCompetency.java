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

public class PstCandidatePositionCompetency extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {

    public static final String TBL_CANDIDATE_POSITION_COMPETENCY = "hr_candidate_position_competency";
    public static final int FLD_CAND_POS_COMP_ID = 0;
    public static final int FLD_CANDIDATE_MAIN_ID = 1;
    public static final int FLD_POSITION_ID = 2;
    public static final int FLD_COMPETENCY_ID = 3;
    public static final int FLD_SCORE_MIN = 4;
    public static final int FLD_SCORE_MAX = 5;
	public static final int FLD_BOBOT = 6;
        public static final int FLD_KONDISI = 7;
	
	
    public static String[] fieldNames = {
        "CAND_POS_COMP_ID",
        "CANDIDATE_MAIN_ID",
        "POSITION_ID",
        "COMPETENCY_ID",
        "SCORE_MIN",
        "SCORE_MAX",
        "BOBOT",
        "KONDISI"
    };
    public static int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_INT,
        TYPE_INT,
        TYPE_INT,
        TYPE_INT
    };

    public PstCandidatePositionCompetency() {
    }

    public PstCandidatePositionCompetency(int i) throws DBException {
        super(new PstCandidatePositionCompetency());
    }

    public PstCandidatePositionCompetency(String sOid) throws DBException {
        super(new PstCandidatePositionCompetency(0));
        if (!locate(sOid)) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public PstCandidatePositionCompetency(long lOid) throws DBException {
        super(new PstCandidatePositionCompetency(0));
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
        return TBL_CANDIDATE_POSITION_COMPETENCY;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new PstCandidatePositionCompetency().getClass().getName();
    }

    public static CandidatePositionCompetency fetchExc(long oid) throws DBException {
        try {
            CandidatePositionCompetency entCandidatePositionCompetency = new CandidatePositionCompetency();
            PstCandidatePositionCompetency pstCandidatePositionCompetency = new PstCandidatePositionCompetency(oid);
            entCandidatePositionCompetency.setOID(oid);
            entCandidatePositionCompetency.setCandidateMainId(pstCandidatePositionCompetency.getLong(FLD_CANDIDATE_MAIN_ID));
            entCandidatePositionCompetency.setPositionId(pstCandidatePositionCompetency.getLong(FLD_POSITION_ID));
            entCandidatePositionCompetency.setCompetencyId(pstCandidatePositionCompetency.getLong(FLD_COMPETENCY_ID));
            entCandidatePositionCompetency.setScoreMin(pstCandidatePositionCompetency.getInt(FLD_SCORE_MIN));
            entCandidatePositionCompetency.setScoreMax(pstCandidatePositionCompetency.getInt(FLD_SCORE_MAX));
            entCandidatePositionCompetency.setBobot(pstCandidatePositionCompetency.getInt(FLD_BOBOT));
            entCandidatePositionCompetency.setKondisi(pstCandidatePositionCompetency.getInt(FLD_KONDISI));
            return entCandidatePositionCompetency;
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstCandidatePositionCompetency(0), DBException.UNKNOWN);
        }
    }

    public long fetchExc(Entity entity) throws Exception {
        CandidatePositionCompetency entCandidatePositionCompetency = fetchExc(entity.getOID());
        entity = (Entity) entCandidatePositionCompetency;
        return entCandidatePositionCompetency.getOID();
    }

    public static synchronized long updateExc(CandidatePositionCompetency entCandidatePositionCompetency) throws DBException {
        try {
            if (entCandidatePositionCompetency.getOID() != 0) {
                PstCandidatePositionCompetency pstCandidatePositionCompetency = new PstCandidatePositionCompetency(entCandidatePositionCompetency.getOID());
                pstCandidatePositionCompetency.setLong(FLD_CANDIDATE_MAIN_ID, entCandidatePositionCompetency.getCandidateMainId());
                pstCandidatePositionCompetency.setLong(FLD_POSITION_ID, entCandidatePositionCompetency.getPositionId());
                pstCandidatePositionCompetency.setLong(FLD_COMPETENCY_ID, entCandidatePositionCompetency.getCompetencyId());
                pstCandidatePositionCompetency.setInt(FLD_SCORE_MIN, entCandidatePositionCompetency.getScoreMin());
                pstCandidatePositionCompetency.setInt(FLD_SCORE_MAX, entCandidatePositionCompetency.getScoreMax());
                pstCandidatePositionCompetency.setInt(FLD_BOBOT, entCandidatePositionCompetency.getBobot());
                pstCandidatePositionCompetency.setInt(FLD_KONDISI, entCandidatePositionCompetency.getKondisi());
                pstCandidatePositionCompetency.update();
                return entCandidatePositionCompetency.getOID();
            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstCandidatePositionCompetency(0), DBException.UNKNOWN);
        }
        return 0;
    }

    public long updateExc(Entity entity) throws Exception {
        return updateExc((CandidatePositionCompetency) entity);
    }

    public static synchronized long deleteExc(long oid) throws DBException {
        try {
            PstCandidatePositionCompetency pstCandidatePositionCompetency = new PstCandidatePositionCompetency(oid);
            pstCandidatePositionCompetency.delete();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstCandidatePositionCompetency(0), DBException.UNKNOWN);
        }
        return oid;
    }

    public long deleteExc(Entity entity) throws Exception {
        if (entity == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(entity.getOID());
    }

    public static synchronized long insertExc(CandidatePositionCompetency entCandidatePositionCompetency) throws DBException {
        try {
            PstCandidatePositionCompetency pstCandidatePositionCompetency = new PstCandidatePositionCompetency(0);
            pstCandidatePositionCompetency.setLong(FLD_CANDIDATE_MAIN_ID, entCandidatePositionCompetency.getCandidateMainId());
            pstCandidatePositionCompetency.setLong(FLD_POSITION_ID, entCandidatePositionCompetency.getPositionId());
            pstCandidatePositionCompetency.setLong(FLD_COMPETENCY_ID, entCandidatePositionCompetency.getCompetencyId());
            pstCandidatePositionCompetency.setInt(FLD_SCORE_MIN, entCandidatePositionCompetency.getScoreMin());
            pstCandidatePositionCompetency.setInt(FLD_SCORE_MAX, entCandidatePositionCompetency.getScoreMax());
            pstCandidatePositionCompetency.setInt(FLD_BOBOT, entCandidatePositionCompetency.getBobot());
            pstCandidatePositionCompetency.setInt(FLD_KONDISI, entCandidatePositionCompetency.getKondisi());
            pstCandidatePositionCompetency.insert();
            entCandidatePositionCompetency.setOID(pstCandidatePositionCompetency.getLong(FLD_CAND_POS_COMP_ID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstCandidatePositionCompetency(0), DBException.UNKNOWN);
        }
        return entCandidatePositionCompetency.getOID();
    }

    public long insertExc(Entity entity) throws Exception {
        return insertExc((CandidatePositionCompetency) entity);
    }

    public static void resultToObject(ResultSet rs, CandidatePositionCompetency entCandidatePositionCompetency) {
        try {
            entCandidatePositionCompetency.setOID(rs.getLong(PstCandidatePositionCompetency.fieldNames[PstCandidatePositionCompetency.FLD_CAND_POS_COMP_ID]));
            entCandidatePositionCompetency.setCandidateMainId(rs.getLong(PstCandidatePositionCompetency.fieldNames[PstCandidatePositionCompetency.FLD_CANDIDATE_MAIN_ID]));
            entCandidatePositionCompetency.setPositionId(rs.getLong(PstCandidatePositionCompetency.fieldNames[PstCandidatePositionCompetency.FLD_POSITION_ID]));
            entCandidatePositionCompetency.setCompetencyId(rs.getLong(PstCandidatePositionCompetency.fieldNames[PstCandidatePositionCompetency.FLD_COMPETENCY_ID]));
            entCandidatePositionCompetency.setScoreMin(rs.getInt(PstCandidatePositionCompetency.fieldNames[PstCandidatePositionCompetency.FLD_SCORE_MIN]));
            entCandidatePositionCompetency.setScoreMax(rs.getInt(PstCandidatePositionCompetency.fieldNames[PstCandidatePositionCompetency.FLD_SCORE_MAX]));
            entCandidatePositionCompetency.setBobot(rs.getInt(PstCandidatePositionCompetency.fieldNames[PstCandidatePositionCompetency.FLD_BOBOT]));
            entCandidatePositionCompetency.setKondisi(rs.getInt(PstCandidatePositionCompetency.fieldNames[PstCandidatePositionCompetency.FLD_KONDISI]));
        } catch (Exception e) {
        }
    }

    public static Vector list(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT * FROM " + TBL_CANDIDATE_POSITION_COMPETENCY;
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
                CandidatePositionCompetency entCandidatePositionCompetency = new CandidatePositionCompetency();
                resultToObject(rs, entCandidatePositionCompetency);
                lists.add(entCandidatePositionCompetency);
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
	
	public static int getTotalBobot(long candidateId){
		int total = 0;
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT SUM("+fieldNames[FLD_BOBOT]+") FROM " + TBL_CANDIDATE_POSITION_COMPETENCY
					+" WHERE "+fieldNames[FLD_CANDIDATE_MAIN_ID]+"="+candidateId;
            
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                total = rs.getInt(1);
            }
            rs.close();
            return total;
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
		return total;
	}

}
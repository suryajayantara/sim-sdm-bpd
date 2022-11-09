/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.employee;

import java.sql.*;
import com.dimata.util.lang.I_Language;
import com.dimata.qdep.db.*;
import com.dimata.qdep.entity.*;
import com.dimata.util.Command;
import java.util.Vector;

/**
 *
 * @author gndiw
 */
public class PstCandidatePositionAssessment extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {

    public static final String TBL_CANDIDATE_POSITION_ASSESSMENT = "hr_candidate_position_assessment";
    public static final int FLD_CAND_POS_ASS_ID = 0;
    public static final int FLD_CANDIDATE_MAIN_ID = 1;
    public static final int FLD_POSITION_ID = 2;
    public static final int FLD_ASSESSMENT_ID = 3;
    public static final int FLD_SCORE_MIN = 4;
    public static final int FLD_SCORE_MAX = 5;
    public static final int FLD_BOBOT = 6;
    public static final int FLD_TAHUN = 7;
    public static final int FLD_KONDISI = 8;

    public static String[] fieldNames = {
        "CAND_POS_ASS_ID",
        "CANDIDATE_MAIN_ID",
        "POSITION_ID",
        "ASSESSMENT_ID",
        "SCORE_MIN",
        "SCORE_MAX",
        "BOBOT",
        "TAHUN",
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
        TYPE_INT,
        TYPE_INT
    };

    public PstCandidatePositionAssessment() {
    }

    public PstCandidatePositionAssessment(int i) throws DBException {
        super(new PstCandidatePositionAssessment());
    }

    public PstCandidatePositionAssessment(String sOid) throws DBException {
        super(new PstCandidatePositionAssessment(0));
        if (!locate(sOid)) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public PstCandidatePositionAssessment(long lOid) throws DBException {
        super(new PstCandidatePositionAssessment(0));
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
        return TBL_CANDIDATE_POSITION_ASSESSMENT;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new PstCandidatePositionAssessment().getClass().getName();
    }

    public static CandidatePositionAssessment fetchExc(long oid) throws DBException {
        try {
            CandidatePositionAssessment entCandidatePositionAssessment = new CandidatePositionAssessment();
            PstCandidatePositionAssessment pstCandidatePositionAssessment = new PstCandidatePositionAssessment(oid);
            entCandidatePositionAssessment.setOID(oid);
            entCandidatePositionAssessment.setCandidateMainId(pstCandidatePositionAssessment.getlong(FLD_CANDIDATE_MAIN_ID));
            entCandidatePositionAssessment.setPositionId(pstCandidatePositionAssessment.getlong(FLD_POSITION_ID));
            entCandidatePositionAssessment.setAssessmentId(pstCandidatePositionAssessment.getlong(FLD_ASSESSMENT_ID));
            entCandidatePositionAssessment.setScoreMin(pstCandidatePositionAssessment.getInt(FLD_SCORE_MIN));
            entCandidatePositionAssessment.setScoreMax(pstCandidatePositionAssessment.getInt(FLD_SCORE_MAX));
            entCandidatePositionAssessment.setBobot(pstCandidatePositionAssessment.getInt(FLD_BOBOT));
            entCandidatePositionAssessment.setTahun(pstCandidatePositionAssessment.getInt(FLD_TAHUN));
            entCandidatePositionAssessment.setKondisi(pstCandidatePositionAssessment.getInt(FLD_KONDISI));
            return entCandidatePositionAssessment;
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstCandidatePositionAssessment(0), DBException.UNKNOWN);
        }
    }

    public long fetchExc(Entity entity) throws Exception {
        CandidatePositionAssessment entCandidatePositionAssessment = fetchExc(entity.getOID());
        entity = (Entity) entCandidatePositionAssessment;
        return entCandidatePositionAssessment.getOID();
    }

    public static synchronized long updateExc(CandidatePositionAssessment entCandidatePositionAssessment) throws DBException {
        try {
            if (entCandidatePositionAssessment.getOID() != 0) {
                PstCandidatePositionAssessment pstCandidatePositionAssessment = new PstCandidatePositionAssessment(entCandidatePositionAssessment.getOID());
                pstCandidatePositionAssessment.setLong(FLD_CANDIDATE_MAIN_ID, entCandidatePositionAssessment.getCandidateMainId());
                pstCandidatePositionAssessment.setLong(FLD_POSITION_ID, entCandidatePositionAssessment.getPositionId());
                pstCandidatePositionAssessment.setLong(FLD_ASSESSMENT_ID, entCandidatePositionAssessment.getAssessmentId());
                pstCandidatePositionAssessment.setInt(FLD_SCORE_MIN, entCandidatePositionAssessment.getScoreMin());
                pstCandidatePositionAssessment.setInt(FLD_SCORE_MAX, entCandidatePositionAssessment.getScoreMax());
                pstCandidatePositionAssessment.setInt(FLD_BOBOT, entCandidatePositionAssessment.getBobot());
                pstCandidatePositionAssessment.setInt(FLD_TAHUN, entCandidatePositionAssessment.getTahun());
                pstCandidatePositionAssessment.setInt(FLD_KONDISI, entCandidatePositionAssessment.getKondisi());
                pstCandidatePositionAssessment.update();
                return entCandidatePositionAssessment.getOID();
            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstCandidatePositionAssessment(0), DBException.UNKNOWN);
        }
        return 0;
    }

    public long updateExc(Entity entity) throws Exception {
        return updateExc((CandidatePositionAssessment) entity);
    }

    public static synchronized long deleteExc(long oid) throws DBException {
        try {
            PstCandidatePositionAssessment pstCandidatePositionAssessment = new PstCandidatePositionAssessment(oid);
            pstCandidatePositionAssessment.delete();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstCandidatePositionAssessment(0), DBException.UNKNOWN);
        }
        return oid;
    }

    public long deleteExc(Entity entity) throws Exception {
        if (entity == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(entity.getOID());
    }

    public static synchronized long insertExc(CandidatePositionAssessment entCandidatePositionAssessment) throws DBException {
        try {
            PstCandidatePositionAssessment pstCandidatePositionAssessment = new PstCandidatePositionAssessment(0);
            pstCandidatePositionAssessment.setLong(FLD_CANDIDATE_MAIN_ID, entCandidatePositionAssessment.getCandidateMainId());
            pstCandidatePositionAssessment.setLong(FLD_POSITION_ID, entCandidatePositionAssessment.getPositionId());
            pstCandidatePositionAssessment.setLong(FLD_ASSESSMENT_ID, entCandidatePositionAssessment.getAssessmentId());
            pstCandidatePositionAssessment.setInt(FLD_SCORE_MIN, entCandidatePositionAssessment.getScoreMin());
            pstCandidatePositionAssessment.setInt(FLD_SCORE_MAX, entCandidatePositionAssessment.getScoreMax());
            pstCandidatePositionAssessment.setInt(FLD_BOBOT, entCandidatePositionAssessment.getBobot());
            pstCandidatePositionAssessment.setInt(FLD_TAHUN, entCandidatePositionAssessment.getTahun());
            pstCandidatePositionAssessment.setInt(FLD_KONDISI, entCandidatePositionAssessment.getKondisi());
            pstCandidatePositionAssessment.insert();
            entCandidatePositionAssessment.setOID(pstCandidatePositionAssessment.getlong(FLD_CANDIDATE_MAIN_ID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstCandidatePositionAssessment(0), DBException.UNKNOWN);
        }
        return entCandidatePositionAssessment.getOID();
    }

    public long insertExc(Entity entity) throws Exception {
        return insertExc((CandidatePositionAssessment) entity);
    }

    public static void resultToObject(ResultSet rs, CandidatePositionAssessment entCandidatePositionAssessment) {
        try {
            entCandidatePositionAssessment.setOID(rs.getLong(PstCandidatePositionAssessment.fieldNames[PstCandidatePositionAssessment.FLD_CAND_POS_ASS_ID]));
            entCandidatePositionAssessment.setCandidateMainId(rs.getLong(PstCandidatePositionAssessment.fieldNames[PstCandidatePositionAssessment.FLD_CANDIDATE_MAIN_ID]));
            entCandidatePositionAssessment.setPositionId(rs.getLong(PstCandidatePositionAssessment.fieldNames[PstCandidatePositionAssessment.FLD_POSITION_ID]));
            entCandidatePositionAssessment.setAssessmentId(rs.getLong(PstCandidatePositionAssessment.fieldNames[PstCandidatePositionAssessment.FLD_ASSESSMENT_ID]));
            entCandidatePositionAssessment.setScoreMin(rs.getInt(PstCandidatePositionAssessment.fieldNames[PstCandidatePositionAssessment.FLD_SCORE_MIN]));
            entCandidatePositionAssessment.setScoreMax(rs.getInt(PstCandidatePositionAssessment.fieldNames[PstCandidatePositionAssessment.FLD_SCORE_MAX]));
            entCandidatePositionAssessment.setBobot(rs.getInt(PstCandidatePositionAssessment.fieldNames[PstCandidatePositionAssessment.FLD_BOBOT]));
            entCandidatePositionAssessment.setTahun(rs.getInt(PstCandidatePositionAssessment.fieldNames[PstCandidatePositionAssessment.FLD_TAHUN]));
            entCandidatePositionAssessment.setKondisi(rs.getInt(PstCandidatePositionAssessment.fieldNames[PstCandidatePositionAssessment.FLD_KONDISI]));
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
            String sql = "SELECT * FROM " + TBL_CANDIDATE_POSITION_ASSESSMENT;
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
                CandidatePositionAssessment entCandidatePositionAssessment = new CandidatePositionAssessment();
                resultToObject(rs, entCandidatePositionAssessment);
                lists.add(entCandidatePositionAssessment);
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

    public static boolean checkOID(long entCandidatePositionAssessmentId) {
        DBResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + TBL_CANDIDATE_POSITION_ASSESSMENT + " WHERE "
                    + PstCandidatePositionAssessment.fieldNames[PstCandidatePositionAssessment.FLD_CANDIDATE_MAIN_ID] + " = " + entCandidatePositionAssessmentId;
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
            String sql = "SELECT COUNT(" + PstCandidatePositionAssessment.fieldNames[PstCandidatePositionAssessment.FLD_CANDIDATE_MAIN_ID] + ") FROM " + TBL_CANDIDATE_POSITION_ASSESSMENT;
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
                    CandidatePositionAssessment entCandidatePositionAssessment = (CandidatePositionAssessment) list.get(ls);
                    if (oid == entCandidatePositionAssessment.getOID()) {
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
    
    public static int getTotalBobot(long assessmentId){
		int total = 0;
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT SUM("+fieldNames[FLD_BOBOT]+") FROM " + TBL_CANDIDATE_POSITION_ASSESSMENT
					+" WHERE "+fieldNames[FLD_CANDIDATE_MAIN_ID]+"="+assessmentId;
            
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

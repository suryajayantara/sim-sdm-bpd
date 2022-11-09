/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
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
import com.dimata.util.Command;
import com.dimata.util.lang.I_Language;
import java.sql.ResultSet;
import java.util.Vector;

/**
 *
 * @author gndiw
 */
public class PstPositionAssessmentRequired extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {

    public static final String TBL_POSITION_ASSESSMENT_REQUIRED = "hr_pos_assessment_req";
    public static final int FLD_POS_ASS_REQ_ID = 0;
    public static final int FLD_POSITION_ID = 1;
    public static final int FLD_ASSESSMENT_ID = 2;
    public static final int FLD_SCORE_REQ_MIN = 3;
    public static final int FLD_SCORE_REQ_RECOMMENDED = 4;
    public static final int FLD_NOTE = 5;
    public static final int FLD_RE_TRAIN_OR_SERTFC_REQ = 6;
    public static final int FLD_VALID_START = 7;
    public static final int FLD_VALID_END = 8;
    public static String[] fieldNames = {
        "POS_ASS_REQ_ID",
        "POSITION_ID",
        "ASSESSMENT_ID",
        "SCORE_REQ_MIN",
        "SCORE_REQ_RECOMMENDED",
        "NOTE",
        "RE_TRAIN_OR_SERTFC_REQ",
        "VALID_START",
        "VALID_END"
    };
    public static int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_STRING,
        TYPE_INT,
        TYPE_DATE,
        TYPE_DATE
    };

    public PstPositionAssessmentRequired() {
    }

    public PstPositionAssessmentRequired(int i) throws DBException {
        super(new PstPositionAssessmentRequired());
    }

    public PstPositionAssessmentRequired(String sOid) throws DBException {
        super(new PstPositionAssessmentRequired(0));
        if (!locate(sOid)) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public PstPositionAssessmentRequired(long lOid) throws DBException {
        super(new PstPositionAssessmentRequired(0));
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
        return TBL_POSITION_ASSESSMENT_REQUIRED;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new PstPositionAssessmentRequired().getClass().getName();
    }

    public static PositionAssessmentRequired fetchExc(long oid) throws DBException {
        try {
            PositionAssessmentRequired entPositionAssessmentRequired = new PositionAssessmentRequired();
            PstPositionAssessmentRequired pstPositionAssessmentRequired = new PstPositionAssessmentRequired(oid);
            entPositionAssessmentRequired.setOID(oid);
            entPositionAssessmentRequired.setPositionId(pstPositionAssessmentRequired.getlong(FLD_POSITION_ID));
            entPositionAssessmentRequired.setAssessmentId(pstPositionAssessmentRequired.getlong(FLD_ASSESSMENT_ID));
            entPositionAssessmentRequired.setScoreReqMin(pstPositionAssessmentRequired.getfloat(FLD_SCORE_REQ_MIN));
            entPositionAssessmentRequired.setScoreReqRecommended(pstPositionAssessmentRequired.getfloat(FLD_SCORE_REQ_RECOMMENDED));
            entPositionAssessmentRequired.setNote(pstPositionAssessmentRequired.getString(FLD_NOTE));
            entPositionAssessmentRequired.setReTrainOrSertfcReq(pstPositionAssessmentRequired.getInt(FLD_RE_TRAIN_OR_SERTFC_REQ));
            entPositionAssessmentRequired.setValidStart(pstPositionAssessmentRequired.getDate(FLD_VALID_START));
            entPositionAssessmentRequired.setValidEnd(pstPositionAssessmentRequired.getDate(FLD_VALID_END));
            return entPositionAssessmentRequired;
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstPositionAssessmentRequired(0), DBException.UNKNOWN);
        }
    }

    public long fetchExc(Entity entity) throws Exception {
        PositionAssessmentRequired entPositionAssessmentRequired = fetchExc(entity.getOID());
        entity = (Entity) entPositionAssessmentRequired;
        return entPositionAssessmentRequired.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((PositionAssessmentRequired) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((PositionAssessmentRequired) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static long insertExc(PositionAssessmentRequired entPositionAssessmentRequired) throws DBException {
        try {
            PstPositionAssessmentRequired pstPositionAssessmentRequired = new PstPositionAssessmentRequired(0);
            pstPositionAssessmentRequired.setLong(FLD_POSITION_ID, entPositionAssessmentRequired.getPositionId());
            pstPositionAssessmentRequired.setLong(FLD_ASSESSMENT_ID, entPositionAssessmentRequired.getAssessmentId());
            pstPositionAssessmentRequired.setFloat(FLD_SCORE_REQ_MIN, entPositionAssessmentRequired.getScoreReqMin());
            pstPositionAssessmentRequired.setFloat(FLD_SCORE_REQ_RECOMMENDED, entPositionAssessmentRequired.getScoreReqRecommended());
            pstPositionAssessmentRequired.setString(FLD_NOTE, entPositionAssessmentRequired.getNote());
            pstPositionAssessmentRequired.setInt(FLD_RE_TRAIN_OR_SERTFC_REQ, entPositionAssessmentRequired.getReTrainOrSertfcReq());
            pstPositionAssessmentRequired.setDate(FLD_VALID_START, entPositionAssessmentRequired.getValidStart());
            pstPositionAssessmentRequired.setDate(FLD_VALID_END, entPositionAssessmentRequired.getValidEnd());
            pstPositionAssessmentRequired.insert();
            entPositionAssessmentRequired.setOID(pstPositionAssessmentRequired.getLong(FLD_POS_ASS_REQ_ID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstPositionAssessmentRequired(0), DBException.UNKNOWN);
        }
        return entPositionAssessmentRequired.getOID();
    }

    public static long updateExc(PositionAssessmentRequired entPositionAssessmentRequired) throws DBException {
        try {
            if (entPositionAssessmentRequired.getOID() != 0) {
                PstPositionAssessmentRequired pstPositionAssessmentRequired = new PstPositionAssessmentRequired(entPositionAssessmentRequired.getOID());
                pstPositionAssessmentRequired.setLong(FLD_POSITION_ID, entPositionAssessmentRequired.getPositionId());
                pstPositionAssessmentRequired.setLong(FLD_ASSESSMENT_ID, entPositionAssessmentRequired.getAssessmentId());
                pstPositionAssessmentRequired.setFloat(FLD_SCORE_REQ_MIN, entPositionAssessmentRequired.getScoreReqMin());
                pstPositionAssessmentRequired.setFloat(FLD_SCORE_REQ_RECOMMENDED, entPositionAssessmentRequired.getScoreReqRecommended());
                pstPositionAssessmentRequired.setString(FLD_NOTE, entPositionAssessmentRequired.getNote());
                pstPositionAssessmentRequired.setInt(FLD_RE_TRAIN_OR_SERTFC_REQ, entPositionAssessmentRequired.getReTrainOrSertfcReq());
                pstPositionAssessmentRequired.setDate(FLD_VALID_START, entPositionAssessmentRequired.getValidStart());
                pstPositionAssessmentRequired.setDate(FLD_VALID_END, entPositionAssessmentRequired.getValidEnd());
                pstPositionAssessmentRequired.update();
                return entPositionAssessmentRequired.getOID();

            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstPositionAssessmentRequired(0), DBException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws DBException {
        try {
            PstPositionAssessmentRequired pstPositionAssessmentRequired = new PstPositionAssessmentRequired(oid);
            pstPositionAssessmentRequired.delete();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstPositionAssessmentRequired(0), DBException.UNKNOWN);
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
            String sql = "SELECT * FROM " + TBL_POSITION_ASSESSMENT_REQUIRED;
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
                PositionAssessmentRequired entPositionAssessmentRequired = new PositionAssessmentRequired();
                resultToObject(rs, entPositionAssessmentRequired);
                lists.add(entPositionAssessmentRequired);
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
    
    public static Vector listInnerJoin(String where){
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql  = "SELECT * FROM " + TBL_POSITION_ASSESSMENT_REQUIRED;
                   sql += " INNER JOIN hr_assessment_type ON hr_pos_assessment_req.ASSESSMENT_ID=hr_assessment_type.ASSESSMENT_ID ";
                   sql += " WHERE hr_pos_assessment_req.POSITION_ID = "+where+"";
            
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                Vector vect = new Vector(1,1);
                PositionAssessmentRequired entPositionAssessmentRequired = new PositionAssessmentRequired();
                Assessment ass = new Assessment();
                resultToObject(rs, entPositionAssessmentRequired);
                vect.add(entPositionAssessmentRequired);
                ass.setAssessmentType(rs.getString(PstAssessment.fieldNames[PstAssessment.FLD_ASSESSMENT_TYPE]));
                vect.add(ass);
                lists.add(vect);
            }
            rs.close();
            return lists;

        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return lists;
    }
    
    public static Vector listInnerJoinVer1(String where){
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql  = "SELECT * FROM " + TBL_POSITION_ASSESSMENT_REQUIRED;
                   sql += " INNER JOIN hr_assessment_type ON hr_pos_assessment_req.ASSESSMENT_ID=hr_assessment_type.ASSESSMENT_ID ";
                   sql += " INNER JOIN hr_position ON hr_pos_assessment_req.POSITION_ID=hr_position.POSITION_ID ";
                   sql += " WHERE "+TBL_POSITION_ASSESSMENT_REQUIRED+"."+PstPositionAssessmentRequired.fieldNames[PstPositionAssessmentRequired.FLD_POS_ASS_REQ_ID]+" = "+where+"";
            
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                Vector vect = new Vector(1,1);
                // Position Competency Required
                PositionAssessmentRequired entPositionAssessmentRequired = new PositionAssessmentRequired();
                resultToObject(rs, entPositionAssessmentRequired);
                vect.add(entPositionAssessmentRequired);
                // Competency
                Assessment assessment = new Assessment();
                assessment.setAssessmentType(rs.getString(PstAssessment.fieldNames[PstAssessment.FLD_ASSESSMENT_TYPE]));
                vect.add(assessment);
                // Position
                Position pos = new Position();
                pos.setPosition(rs.getString(PstPosition.fieldNames[PstPosition.FLD_POSITION]));
                vect.add(pos);
                lists.add(vect);
            }
            rs.close();
            return lists;

        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return lists;
    }
    // resultToObject PositionAssessmentRequired
    private static void resultToObject(ResultSet rs, PositionAssessmentRequired entPositionAssessmentRequired) {
        try {
            entPositionAssessmentRequired.setOID(rs.getLong(PstPositionAssessmentRequired.fieldNames[PstPositionAssessmentRequired.FLD_POS_ASS_REQ_ID]));
            entPositionAssessmentRequired.setPositionId(rs.getLong(PstPositionAssessmentRequired.fieldNames[PstPositionAssessmentRequired.FLD_POSITION_ID]));
            entPositionAssessmentRequired.setAssessmentId(rs.getLong(PstPositionAssessmentRequired.fieldNames[PstPositionAssessmentRequired.FLD_ASSESSMENT_ID]));
            entPositionAssessmentRequired.setScoreReqMin(rs.getFloat(PstPositionAssessmentRequired.fieldNames[PstPositionAssessmentRequired.FLD_SCORE_REQ_MIN]));
            entPositionAssessmentRequired.setScoreReqRecommended(rs.getFloat(PstPositionAssessmentRequired.fieldNames[PstPositionAssessmentRequired.FLD_SCORE_REQ_RECOMMENDED]));
            entPositionAssessmentRequired.setNote(rs.getString(PstPositionAssessmentRequired.fieldNames[PstPositionAssessmentRequired.FLD_NOTE]));
            entPositionAssessmentRequired.setReTrainOrSertfcReq(rs.getInt(PstPositionAssessmentRequired.fieldNames[PstPositionAssessmentRequired.FLD_RE_TRAIN_OR_SERTFC_REQ]));
            entPositionAssessmentRequired.setValidStart(rs.getDate(PstPositionAssessmentRequired.fieldNames[PstPositionAssessmentRequired.FLD_VALID_START]));
            entPositionAssessmentRequired.setValidEnd(rs.getDate(PstPositionAssessmentRequired.fieldNames[PstPositionAssessmentRequired.FLD_VALID_END]));
        } catch (Exception e) {
        }
    }
    
    public static boolean checkOID(long entPositionAssessmentRequiredId) {
        DBResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + TBL_POSITION_ASSESSMENT_REQUIRED + " WHERE "
                    + PstPositionAssessmentRequired.fieldNames[PstPositionAssessmentRequired.FLD_POS_ASS_REQ_ID] + " = " + entPositionAssessmentRequiredId;

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
            String sql = "SELECT COUNT(" + PstPositionAssessmentRequired.fieldNames[PstPositionAssessmentRequired.FLD_POS_ASS_REQ_ID] + ") FROM " + TBL_POSITION_ASSESSMENT_REQUIRED;
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
    public static int findLimitStart(long oid, int recordToGet, String whereClause, String orderClause) {
        int size = getCount(whereClause);
        int start = 0;
        boolean found = false;
        for (int i = 0; (i < size) && !found; i = i + recordToGet) {
            Vector list = list(i, recordToGet, whereClause, orderClause);
            start = i;
            if (list.size() > 0) {
                for (int ls = 0; ls < list.size(); ls++) {
                    PositionAssessmentRequired entPositionAssessmentRequired = (PositionAssessmentRequired) list.get(ls);
                    if (oid == entPositionAssessmentRequired.getOID()) {
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
    /* This method used to find command where current data */

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

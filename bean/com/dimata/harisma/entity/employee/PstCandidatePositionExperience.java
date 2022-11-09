/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.employee;

import com.dimata.harisma.entity.masterdata.Position;
import com.dimata.harisma.entity.masterdata.PstPosition;
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
 * @author Acer
 */
public class PstCandidatePositionExperience extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {

    public static final String TBL_CANDIDATE_POS_EXPERIENCE = "hr_candidate_pos_expirience";
    public static final int FLD_CAND_POS_EXPIRIENCE_ID = 0;
    public static final int FLD_POSITION_ID = 1;
    public static final int FLD_EXPERIENCE_ID = 2;
    public static final int FLD_DURATION_MIN = 3;
    public static final int FLD_DURATION_RECOMMENDED = 4;
    public static final int FLD_NOTE = 5;
    public static final int FLD_CANDIDATE_MAIN_ID = 6;
	public static final int FLD_TYPE = 7;
        public static final int FLD_KONDISI = 8;
    public static String[] fieldNames = {
        "CAND_POS_EXPIRIENCE_ID",
        "POSITION_ID",
        "EXPERIENCE_ID",
        "DURATION_MIN",
        "DURATION_RECOMMENDED",
        "NOTE",
        "CANDIDATE_MAIN_ID",
        "TYPE",
        "KONDISI"
    };
    public static int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_INT,
        TYPE_INT,
        TYPE_STRING,
        TYPE_LONG,
        TYPE_INT,
        TYPE_INT
    };

    public PstCandidatePositionExperience() {
    }

    public PstCandidatePositionExperience(int i) throws DBException {
        super(new PstCandidatePositionExperience());
    }

    public PstCandidatePositionExperience(String sOid) throws DBException {
        super(new PstCandidatePositionExperience(0));
        if (!locate(sOid)) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public PstCandidatePositionExperience(long lOid) throws DBException {
        super(new PstCandidatePositionExperience(0));
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
        return TBL_CANDIDATE_POS_EXPERIENCE;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new PstCandidatePositionExperience().getClass().getName();
    }

    public static CandidatePositionExperience fetchExc(long oid) throws DBException {
        try {
            CandidatePositionExperience entCandidatePositionExperience = new CandidatePositionExperience();
            PstCandidatePositionExperience pstPstCandidatePositionExperience = new PstCandidatePositionExperience(oid);
            entCandidatePositionExperience.setOID(oid);
            entCandidatePositionExperience.setPositionId(pstPstCandidatePositionExperience.getlong(FLD_POSITION_ID));
            entCandidatePositionExperience.setCandidateMainId(pstPstCandidatePositionExperience.getlong(FLD_CANDIDATE_MAIN_ID));
            entCandidatePositionExperience.setExperienceId(pstPstCandidatePositionExperience.getlong(FLD_EXPERIENCE_ID));
            entCandidatePositionExperience.setDurationMin(pstPstCandidatePositionExperience.getInt(FLD_DURATION_MIN));
            entCandidatePositionExperience.setDurationRecommended(pstPstCandidatePositionExperience.getInt(FLD_DURATION_RECOMMENDED));
            entCandidatePositionExperience.setNote(pstPstCandidatePositionExperience.getString(FLD_NOTE));
            entCandidatePositionExperience.setType(pstPstCandidatePositionExperience.getInt(FLD_TYPE));
            entCandidatePositionExperience.setKondisi(pstPstCandidatePositionExperience.getInt(FLD_KONDISI));
            return entCandidatePositionExperience;
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstCandidatePositionExperience(0), DBException.UNKNOWN);
        }
    }

    public long fetchExc(Entity entity) throws Exception {
        CandidatePositionExperience entCandidatePositionExperience = fetchExc(entity.getOID());
        entity = (Entity) entCandidatePositionExperience;
        return entCandidatePositionExperience.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((CandidatePositionExperience) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((CandidatePositionExperience) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static long insertExc(CandidatePositionExperience entCandidatePositionExperience) throws DBException {
        try {
            PstCandidatePositionExperience pstCandidatePositionExperience = new PstCandidatePositionExperience(0);
            pstCandidatePositionExperience.setLong(FLD_POSITION_ID, entCandidatePositionExperience.getPositionId());
            pstCandidatePositionExperience.setLong(FLD_CANDIDATE_MAIN_ID, entCandidatePositionExperience.getCandidateMainId());
            pstCandidatePositionExperience.setLong(FLD_EXPERIENCE_ID, entCandidatePositionExperience.getExperienceId());
            pstCandidatePositionExperience.setInt(FLD_DURATION_MIN, entCandidatePositionExperience.getDurationMin());
            pstCandidatePositionExperience.setInt(FLD_DURATION_RECOMMENDED, entCandidatePositionExperience.getDurationRecommended());
            pstCandidatePositionExperience.setString(FLD_NOTE, entCandidatePositionExperience.getNote());
            pstCandidatePositionExperience.setInt(FLD_TYPE, entCandidatePositionExperience.getType());
            pstCandidatePositionExperience.setInt(FLD_KONDISI, entCandidatePositionExperience.getKondisi());
            pstCandidatePositionExperience.insert();
            entCandidatePositionExperience.setOID(pstCandidatePositionExperience.getLong(FLD_CAND_POS_EXPIRIENCE_ID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstCandidatePositionExperience(0), DBException.UNKNOWN);
        }
        return entCandidatePositionExperience.getOID();
    }

    public static long updateExc(CandidatePositionExperience entCandidatePositionExperience) throws DBException {
        try {
            if (entCandidatePositionExperience.getOID() != 0) {
                PstCandidatePositionExperience pstCandidatePositionExperience = new PstCandidatePositionExperience(entCandidatePositionExperience.getOID());
                pstCandidatePositionExperience.setLong(FLD_POSITION_ID, entCandidatePositionExperience.getPositionId());
                pstCandidatePositionExperience.setLong(FLD_CANDIDATE_MAIN_ID, entCandidatePositionExperience.getCandidateMainId());
                pstCandidatePositionExperience.setLong(FLD_EXPERIENCE_ID, entCandidatePositionExperience.getExperienceId());
                pstCandidatePositionExperience.setInt(FLD_DURATION_MIN, entCandidatePositionExperience.getDurationMin());
                pstCandidatePositionExperience.setInt(FLD_DURATION_RECOMMENDED, entCandidatePositionExperience.getDurationRecommended());
                pstCandidatePositionExperience.setString(FLD_NOTE, entCandidatePositionExperience.getNote());
                pstCandidatePositionExperience.setInt(FLD_TYPE, entCandidatePositionExperience.getType());
                pstCandidatePositionExperience.setInt(FLD_KONDISI, entCandidatePositionExperience.getKondisi());
                pstCandidatePositionExperience.update();
                return entCandidatePositionExperience.getOID();

            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstCandidatePositionExperience(0), DBException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws DBException {
        try {
            PstCandidatePositionExperience pstCandidatePositionExperience = new PstCandidatePositionExperience(oid);
            pstCandidatePositionExperience.delete();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstCandidatePositionExperience(0), DBException.UNKNOWN);
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
            String sql = "SELECT * FROM " + TBL_CANDIDATE_POS_EXPERIENCE;
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
                CandidatePositionExperience entCandidatePositionExperience = new CandidatePositionExperience();
                resultToObject(rs, entCandidatePositionExperience);
                lists.add(entCandidatePositionExperience);
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
            String sql  = "SELECT * FROM " + TBL_CANDIDATE_POS_EXPERIENCE;
                   sql += " INNER JOIN "+PstPosition.TBL_HR_POSITION+" ON "+TBL_CANDIDATE_POS_EXPERIENCE+
                   "."+PstCandidatePositionExperience.fieldNames[PstCandidatePositionExperience.FLD_EXPERIENCE_ID]+"="+PstPosition.TBL_HR_POSITION+"."+PstPosition.fieldNames[PstPosition.FLD_POSITION_ID];
                   sql += " WHERE "+TBL_CANDIDATE_POS_EXPERIENCE+"."+PstCandidatePositionExperience.fieldNames[PstCandidatePositionExperience.FLD_POSITION_ID]+" = "+where+"";
            
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                Vector vect = new Vector(1,1);
                CandidatePositionExperience entCandidatePositionExperience = new CandidatePositionExperience();
                Position pos = new Position();
                resultToObject(rs, entCandidatePositionExperience);
                vect.add(entCandidatePositionExperience);
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
    
    public static Vector listInnerJoinVer1(String where){
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql  = "SELECT * FROM " + TBL_CANDIDATE_POS_EXPERIENCE;
                   sql += " INNER JOIN hr_position POS ON "+TBL_CANDIDATE_POS_EXPERIENCE+".POSITION_ID=POS.POSITION_ID ";
                   sql += " INNER JOIN "+PstPosition.TBL_HR_POSITION+" ON "+TBL_CANDIDATE_POS_EXPERIENCE+
                   "."+PstCandidatePositionExperience.fieldNames[PstCandidatePositionExperience.FLD_POSITION_ID]+"="+PstPosition.TBL_HR_POSITION+"."+PstPosition.fieldNames[PstPosition.FLD_POSITION_ID];
                   sql += " WHERE "+TBL_CANDIDATE_POS_EXPERIENCE+"."+PstCandidatePositionExperience.fieldNames[PstCandidatePositionExperience.FLD_CAND_POS_EXPIRIENCE_ID]+" = "+where+"";
            
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                Vector vect = new Vector(1,1);
                CandidatePositionExperience entCandidatePositionExperience = new CandidatePositionExperience();
                resultToObject(rs, entCandidatePositionExperience);
                vect.add(entCandidatePositionExperience);
                // Position
                Position pos = new Position();
                pos.setPosition(rs.getString(PstPosition.fieldNames[PstPosition.FLD_POSITION]));
                vect.add(pos);
                // Education
                Position posReq = new Position();
                posReq.setPosition(rs.getString(PstPosition.fieldNames[PstPosition.FLD_POSITION]));
                vect.add(posReq);
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
    
    private static void resultToObject(ResultSet rs, CandidatePositionExperience entCandidatePositionExperience) {
        try {
            entCandidatePositionExperience.setOID(rs.getLong(PstCandidatePositionExperience.fieldNames[PstCandidatePositionExperience.FLD_CAND_POS_EXPIRIENCE_ID]));
            entCandidatePositionExperience.setPositionId(rs.getLong(PstCandidatePositionExperience.fieldNames[PstCandidatePositionExperience.FLD_POSITION_ID]));
            entCandidatePositionExperience.setCandidateMainId(rs.getLong(PstCandidatePositionExperience.fieldNames[PstCandidatePositionExperience.FLD_CANDIDATE_MAIN_ID]));
            entCandidatePositionExperience.setExperienceId(rs.getLong(PstCandidatePositionExperience.fieldNames[PstCandidatePositionExperience.FLD_EXPERIENCE_ID]));
            entCandidatePositionExperience.setDurationMin(rs.getInt(PstCandidatePositionExperience.fieldNames[PstCandidatePositionExperience.FLD_DURATION_MIN]));
            entCandidatePositionExperience.setDurationRecommended(rs.getInt(PstCandidatePositionExperience.fieldNames[PstCandidatePositionExperience.FLD_DURATION_RECOMMENDED]));
            entCandidatePositionExperience.setNote(rs.getString(PstCandidatePositionExperience.fieldNames[PstCandidatePositionExperience.FLD_NOTE]));
            entCandidatePositionExperience.setType(rs.getInt(PstCandidatePositionExperience.fieldNames[PstCandidatePositionExperience.FLD_TYPE]));
            entCandidatePositionExperience.setKondisi(rs.getInt(PstCandidatePositionExperience.fieldNames[PstCandidatePositionExperience.FLD_KONDISI]));

        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long entCandidatePositionExperience) {
        DBResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + TBL_CANDIDATE_POS_EXPERIENCE + " WHERE "
                    + PstCandidatePositionExperience.fieldNames[PstCandidatePositionExperience.FLD_CAND_POS_EXPIRIENCE_ID] + " = " + entCandidatePositionExperience;

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
            String sql = "SELECT COUNT(" + PstCandidatePositionExperience.fieldNames[PstCandidatePositionExperience.FLD_CAND_POS_EXPIRIENCE_ID] + ") FROM " + TBL_CANDIDATE_POS_EXPERIENCE;
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
                    CandidatePositionExperience entCandidatePositionExperience = (CandidatePositionExperience) list.get(ls);
                    if (oid == entCandidatePositionExperience.getOID()) {
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

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
public class PstCandidatePositionPower extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {

    public static final String TBL_CANDIDATE_POSITION_POWER = "hr_candidate_position_power";
    public static final int FLD_CANDIDATE_POSITION_POWER_ID = 0;
    public static final int FLD_CANDIDATE_MAIN_ID = 1;
    public static final int FLD_POSITION_ID = 2;
    public static final int FLD_FIRST_POWER_CHARACTER_ID = 3;
    public static final int FLD_SECOND_POWER_CHARACTER_ID = 4;

    public static String[] fieldNames = {
        "CANDIDATE_POSITION_POWER_ID",
        "CANDIDATE_MAIN_ID",
        "POSITION_ID",
        "FIRST_POWER_CHARACTER_ID",
        "SECOND_POWER_CHARACTER_ID"
    };

    public static int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG
    };

    public PstCandidatePositionPower() {
    }

    public PstCandidatePositionPower(int i) throws DBException {
        super(new PstCandidatePositionPower());
    }

    public PstCandidatePositionPower(String sOid) throws DBException {
        super(new PstCandidatePositionPower(0));
        if (!locate(sOid)) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public PstCandidatePositionPower(long lOid) throws DBException {
        super(new PstCandidatePositionPower(0));
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
        return TBL_CANDIDATE_POSITION_POWER;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new PstCandidatePositionPower().getClass().getName();
    }

    public static CandidatePositionPower fetchExc(long oid) throws DBException {
        try {
            CandidatePositionPower entCandidatePositionPower = new CandidatePositionPower();
            PstCandidatePositionPower pstCandidatePositionPower = new PstCandidatePositionPower(oid);
            entCandidatePositionPower.setOID(oid);
            entCandidatePositionPower.setCandidateMainId(pstCandidatePositionPower.getlong(FLD_CANDIDATE_MAIN_ID));
            entCandidatePositionPower.setPositionId(pstCandidatePositionPower.getlong(FLD_POSITION_ID));
            entCandidatePositionPower.setFirstPowerCharacterId(pstCandidatePositionPower.getlong(FLD_FIRST_POWER_CHARACTER_ID));
            entCandidatePositionPower.setSecondPowerCharacterId(pstCandidatePositionPower.getlong(FLD_SECOND_POWER_CHARACTER_ID));
            return entCandidatePositionPower;
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstCandidatePositionPower(0), DBException.UNKNOWN);
        }
    }

    public long fetchExc(Entity entity) throws Exception {
        CandidatePositionPower entCandidatePositionPower = fetchExc(entity.getOID());
        entity = (Entity) entCandidatePositionPower;
        return entCandidatePositionPower.getOID();
    }

    public static synchronized long updateExc(CandidatePositionPower entCandidatePositionPower) throws DBException {
        try {
            if (entCandidatePositionPower.getOID() != 0) {
                PstCandidatePositionPower pstCandidatePositionPower = new PstCandidatePositionPower(entCandidatePositionPower.getOID());
                pstCandidatePositionPower.setLong(FLD_CANDIDATE_MAIN_ID, entCandidatePositionPower.getCandidateMainId());
                pstCandidatePositionPower.setLong(FLD_POSITION_ID, entCandidatePositionPower.getPositionId());
                pstCandidatePositionPower.setLong(FLD_FIRST_POWER_CHARACTER_ID, entCandidatePositionPower.getFirstPowerCharacterId());
                pstCandidatePositionPower.setLong(FLD_SECOND_POWER_CHARACTER_ID, entCandidatePositionPower.getSecondPowerCharacterId());
                pstCandidatePositionPower.update();
                return entCandidatePositionPower.getOID();
            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstCandidatePositionPower(0), DBException.UNKNOWN);
        }
        return 0;
    }

    public long updateExc(Entity entity) throws Exception {
        return updateExc((CandidatePositionPower) entity);
    }

    public static synchronized long deleteExc(long oid) throws DBException {
        try {
            PstCandidatePositionPower pstCandidatePositionPower = new PstCandidatePositionPower(oid);
            pstCandidatePositionPower.delete();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstCandidatePositionPower(0), DBException.UNKNOWN);
        }
        return oid;
    }

    public long deleteExc(Entity entity) throws Exception {
        if (entity == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(entity.getOID());
    }

    public static synchronized long insertExc(CandidatePositionPower entCandidatePositionPower) throws DBException {
        try {
            PstCandidatePositionPower pstCandidatePositionPower = new PstCandidatePositionPower(0);
            pstCandidatePositionPower.setLong(FLD_CANDIDATE_MAIN_ID, entCandidatePositionPower.getCandidateMainId());
            pstCandidatePositionPower.setLong(FLD_POSITION_ID, entCandidatePositionPower.getPositionId());
            pstCandidatePositionPower.setLong(FLD_FIRST_POWER_CHARACTER_ID, entCandidatePositionPower.getFirstPowerCharacterId());
            pstCandidatePositionPower.setLong(FLD_SECOND_POWER_CHARACTER_ID, entCandidatePositionPower.getSecondPowerCharacterId());
            pstCandidatePositionPower.insert();
            entCandidatePositionPower.setOID(pstCandidatePositionPower.getlong(FLD_CANDIDATE_MAIN_ID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstCandidatePositionPower(0), DBException.UNKNOWN);
        }
        return entCandidatePositionPower.getOID();
    }

    public long insertExc(Entity entity) throws Exception {
        return insertExc((CandidatePositionPower) entity);
    }

    public static void resultToObject(ResultSet rs, CandidatePositionPower entCandidatePositionPower) {
        try {
            entCandidatePositionPower.setOID(rs.getLong(PstCandidatePositionPower.fieldNames[PstCandidatePositionPower.FLD_CANDIDATE_POSITION_POWER_ID]));
            entCandidatePositionPower.setCandidateMainId(rs.getLong(PstCandidatePositionPower.fieldNames[PstCandidatePositionPower.FLD_CANDIDATE_MAIN_ID]));
            entCandidatePositionPower.setPositionId(rs.getLong(PstCandidatePositionPower.fieldNames[PstCandidatePositionPower.FLD_POSITION_ID]));
            entCandidatePositionPower.setFirstPowerCharacterId(rs.getLong(PstCandidatePositionPower.fieldNames[PstCandidatePositionPower.FLD_FIRST_POWER_CHARACTER_ID]));
            entCandidatePositionPower.setSecondPowerCharacterId(rs.getLong(PstCandidatePositionPower.fieldNames[PstCandidatePositionPower.FLD_SECOND_POWER_CHARACTER_ID]));
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
            String sql = "SELECT * FROM " + TBL_CANDIDATE_POSITION_POWER;
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
                CandidatePositionPower entCandidatePositionPower = new CandidatePositionPower();
                resultToObject(rs, entCandidatePositionPower);
                lists.add(entCandidatePositionPower);
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

    public static boolean checkOID(long entCandidatePositionPowerId) {
        DBResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + TBL_CANDIDATE_POSITION_POWER + " WHERE "
                    + PstCandidatePositionPower.fieldNames[PstCandidatePositionPower.FLD_CANDIDATE_MAIN_ID] + " = " + entCandidatePositionPowerId;
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
            String sql = "SELECT COUNT(" + PstCandidatePositionPower.fieldNames[PstCandidatePositionPower.FLD_CANDIDATE_MAIN_ID] + ") FROM " + TBL_CANDIDATE_POSITION_POWER;
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
                    CandidatePositionPower entCandidatePositionPower = (CandidatePositionPower) list.get(ls);
                    if (oid == entCandidatePositionPower.getOID()) {
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

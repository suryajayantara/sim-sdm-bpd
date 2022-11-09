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
public class PstEmpPowerCharacter extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {

    public static final String TBL_EMP_POWER_CHARACTER = "hr_emp_character_power";
    public static final int FLD_EMP_POWER_CHARACTER_ID = 0;
    public static final int FLD_POWER_CHARACTER_ID = 1;
    public static final int FLD_EMPLOYEE_ID = 2;
    public static final int FLD_INDEX = 3;
    public static final int FLD_SECOND_POWER_CHARACTER_ID = 4;

    public static String[] fieldNames = {
        "EMP_POWER_CHARACTER_ID",
        "FIRST_POWER_CHARACTER_ID",
        "EMPLOYEE_ID",
        "IDX",
        "SECOND_POWER_CHARACTER_ID"
    };

    public static int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_INT,
        TYPE_LONG
    };

    private static String query = "";
    
    public String getQuery(){
        return query;
    }
    
    public PstEmpPowerCharacter() {
    }

    public PstEmpPowerCharacter(int i) throws DBException {
        super(new PstEmpPowerCharacter());
    }

    public PstEmpPowerCharacter(String sOid) throws DBException {
        super(new PstEmpPowerCharacter(0));
        if (!locate(sOid)) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public PstEmpPowerCharacter(long lOid) throws DBException {
        super(new PstEmpPowerCharacter(0));
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
        return TBL_EMP_POWER_CHARACTER;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new PstEmpPowerCharacter().getClass().getName();
    }

    public static EmpPowerCharacter fetchExc(long oid) throws DBException {
        try {
            EmpPowerCharacter entEmpPowerCharacter = new EmpPowerCharacter();
            PstEmpPowerCharacter pstEmpPowerCharacter = new PstEmpPowerCharacter(oid);
            entEmpPowerCharacter.setOID(oid);
            entEmpPowerCharacter.setPowerCharacterId(pstEmpPowerCharacter.getlong(FLD_POWER_CHARACTER_ID));
            entEmpPowerCharacter.setEmployeeId(pstEmpPowerCharacter.getlong(FLD_EMPLOYEE_ID));
            entEmpPowerCharacter.setIndex(pstEmpPowerCharacter.getInt(FLD_INDEX));
            entEmpPowerCharacter.setSecondCharacterId(pstEmpPowerCharacter.getlong(FLD_SECOND_POWER_CHARACTER_ID));
            return entEmpPowerCharacter;
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstEmpPowerCharacter(0), DBException.UNKNOWN);
        }
    }

    public long fetchExc(Entity entity) throws Exception {
        EmpPowerCharacter entEmpPowerCharacter = fetchExc(entity.getOID());
        entity = (Entity) entEmpPowerCharacter;
        return entEmpPowerCharacter.getOID();
    }

    public static synchronized long updateExc(EmpPowerCharacter entEmpPowerCharacter) throws DBException {
        try {
            if (entEmpPowerCharacter.getOID() != 0) {
                PstEmpPowerCharacter pstEmpPowerCharacter = new PstEmpPowerCharacter(entEmpPowerCharacter.getOID());
                pstEmpPowerCharacter.setLong(FLD_POWER_CHARACTER_ID, entEmpPowerCharacter.getPowerCharacterId());
                pstEmpPowerCharacter.setLong(FLD_EMPLOYEE_ID, entEmpPowerCharacter.getEmployeeId());
                pstEmpPowerCharacter.setInt(FLD_INDEX, entEmpPowerCharacter.getIndex());
                pstEmpPowerCharacter.setLong(FLD_SECOND_POWER_CHARACTER_ID, entEmpPowerCharacter.getSecondCharacterId());
                pstEmpPowerCharacter.update();
                return entEmpPowerCharacter.getOID();
            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstEmpPowerCharacter(0), DBException.UNKNOWN);
        }
        return 0;
    }
    
    public static synchronized long updateExcPending(EmpPowerCharacter entEmpPowerCharacter) throws DBException {
        try {
            if (entEmpPowerCharacter.getOID() != 0) {
                PstEmpPowerCharacter pstEmpPowerCharacter = new PstEmpPowerCharacter(entEmpPowerCharacter.getOID());
                pstEmpPowerCharacter.setLong(FLD_POWER_CHARACTER_ID, entEmpPowerCharacter.getPowerCharacterId());
                pstEmpPowerCharacter.setLong(FLD_EMPLOYEE_ID, entEmpPowerCharacter.getEmployeeId());
                pstEmpPowerCharacter.setInt(FLD_INDEX, entEmpPowerCharacter.getIndex());
                pstEmpPowerCharacter.setLong(FLD_SECOND_POWER_CHARACTER_ID, entEmpPowerCharacter.getSecondCharacterId());
                query = pstEmpPowerCharacter.getUpdateSQL();
                return entEmpPowerCharacter.getOID();
            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstEmpPowerCharacter(0), DBException.UNKNOWN);
        }
        return 0;
    }

    public long updateExc(Entity entity) throws Exception {
        return updateExc((EmpPowerCharacter) entity);
    }

    public static synchronized long deleteExc(long oid) throws DBException {
        try {
            PstEmpPowerCharacter pstEmpPowerCharacter = new PstEmpPowerCharacter(oid);
            pstEmpPowerCharacter.delete();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstEmpPowerCharacter(0), DBException.UNKNOWN);
        }
        return oid;
    }

    public static synchronized long deleteExcPending(long oid) throws DBException {
        try {
            PstEmpPowerCharacter pstEmpPowerCharacter = new PstEmpPowerCharacter(oid);
            query = pstEmpPowerCharacter.getDeleteSQL();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstEmpPowerCharacter(0), DBException.UNKNOWN);
        }
        return oid;
    }
    
    public long deleteExc(Entity entity) throws Exception {
        if (entity == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(entity.getOID());
    }

    public static synchronized long insertExc(EmpPowerCharacter entEmpPowerCharacter) throws DBException {
        try {
            PstEmpPowerCharacter pstEmpPowerCharacter = new PstEmpPowerCharacter(0);
            pstEmpPowerCharacter.setLong(FLD_POWER_CHARACTER_ID, entEmpPowerCharacter.getPowerCharacterId());
            pstEmpPowerCharacter.setLong(FLD_EMPLOYEE_ID, entEmpPowerCharacter.getEmployeeId());
            pstEmpPowerCharacter.setInt(FLD_INDEX, entEmpPowerCharacter.getIndex());
            pstEmpPowerCharacter.setLong(FLD_SECOND_POWER_CHARACTER_ID, entEmpPowerCharacter.getSecondCharacterId());
            pstEmpPowerCharacter.insert();
            entEmpPowerCharacter.setOID(pstEmpPowerCharacter.getlong(FLD_POWER_CHARACTER_ID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstEmpPowerCharacter(0), DBException.UNKNOWN);
        }
        return entEmpPowerCharacter.getOID();
    }

    public static synchronized long insertExcPending(EmpPowerCharacter entEmpPowerCharacter) throws DBException {
        try {
            PstEmpPowerCharacter pstEmpPowerCharacter = new PstEmpPowerCharacter(0);
            pstEmpPowerCharacter.setLong(FLD_POWER_CHARACTER_ID, entEmpPowerCharacter.getPowerCharacterId());
            pstEmpPowerCharacter.setLong(FLD_EMPLOYEE_ID, entEmpPowerCharacter.getEmployeeId());
            pstEmpPowerCharacter.setInt(FLD_INDEX, entEmpPowerCharacter.getIndex());
            pstEmpPowerCharacter.setLong(FLD_SECOND_POWER_CHARACTER_ID, entEmpPowerCharacter.getSecondCharacterId());
            query = pstEmpPowerCharacter.getInsertQuery();
            entEmpPowerCharacter.setOID(pstEmpPowerCharacter.getlong(FLD_POWER_CHARACTER_ID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstEmpPowerCharacter(0), DBException.UNKNOWN);
        }
        return entEmpPowerCharacter.getOID();
    }
    
    public long insertExc(Entity entity) throws Exception {
        return insertExc((EmpPowerCharacter) entity);
    }

    public static void resultToObject(ResultSet rs, EmpPowerCharacter entEmpPowerCharacter) {
        try {
            entEmpPowerCharacter.setOID(rs.getLong(PstEmpPowerCharacter.fieldNames[PstEmpPowerCharacter.FLD_EMP_POWER_CHARACTER_ID]));
            entEmpPowerCharacter.setPowerCharacterId(rs.getLong(PstEmpPowerCharacter.fieldNames[PstEmpPowerCharacter.FLD_POWER_CHARACTER_ID]));
            entEmpPowerCharacter.setEmployeeId(rs.getLong(PstEmpPowerCharacter.fieldNames[PstEmpPowerCharacter.FLD_EMPLOYEE_ID]));
            entEmpPowerCharacter.setIndex(rs.getInt(PstEmpPowerCharacter.fieldNames[PstEmpPowerCharacter.FLD_INDEX]));
            entEmpPowerCharacter.setSecondCharacterId(rs.getLong(PstEmpPowerCharacter.fieldNames[PstEmpPowerCharacter.FLD_SECOND_POWER_CHARACTER_ID]));
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
            String sql = "SELECT * FROM " + TBL_EMP_POWER_CHARACTER;
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
                EmpPowerCharacter entEmpPowerCharacter = new EmpPowerCharacter();
                resultToObject(rs, entEmpPowerCharacter);
                lists.add(entEmpPowerCharacter);
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

    public static boolean checkOID(long entEmpPowerCharacterId) {
        DBResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + TBL_EMP_POWER_CHARACTER + " WHERE "
                    + PstEmpPowerCharacter.fieldNames[PstEmpPowerCharacter.FLD_POWER_CHARACTER_ID] + " = " + entEmpPowerCharacterId;
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
            String sql = "SELECT COUNT(" + PstEmpPowerCharacter.fieldNames[PstEmpPowerCharacter.FLD_POWER_CHARACTER_ID] + ") FROM " + TBL_EMP_POWER_CHARACTER;
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
                    EmpPowerCharacter entEmpPowerCharacter = (EmpPowerCharacter) list.get(ls);
                    if (oid == entEmpPowerCharacter.getOID()) {
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

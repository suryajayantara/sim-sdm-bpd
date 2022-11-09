/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.masterdata;

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
public class PstPowerCharacterColor extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {

    public static final String POWER_CHARACTER_COLOR = "hr_power_character_color";
    public static final int FLD_POWER_CHARACTER_COLOR_ID = 0;
    public static final int FLD_COLOR_NAME = 1;
    public static final int FLD_COLOR_HEX = 2;

    public static String[] fieldNames = {
        "POWER_CHARACTER_COLOR_ID",
        "COLOR_NAME",
        "COLOR_HEX"
    };

    public static int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_STRING,
        TYPE_STRING
    };

    public PstPowerCharacterColor() {
    }

    public PstPowerCharacterColor(int i) throws DBException {
        super(new PstPowerCharacterColor());
    }

    public PstPowerCharacterColor(String sOid) throws DBException {
        super(new PstPowerCharacterColor(0));
        if (!locate(sOid)) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public PstPowerCharacterColor(long lOid) throws DBException {
        super(new PstPowerCharacterColor(0));
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
        return POWER_CHARACTER_COLOR;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new PstPowerCharacterColor().getClass().getName();
    }

    public static PowerCharacterColor fetchExc(long oid) throws DBException {
        try {
            PowerCharacterColor entPowerCharacterColor = new PowerCharacterColor();
            PstPowerCharacterColor pstPowerCharacterColor = new PstPowerCharacterColor(oid);
            entPowerCharacterColor.setOID(oid);
            entPowerCharacterColor.setColorName(pstPowerCharacterColor.getString(FLD_COLOR_NAME));
            entPowerCharacterColor.setColorHex(pstPowerCharacterColor.getString(FLD_COLOR_HEX));
            return entPowerCharacterColor;
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstPowerCharacterColor(0), DBException.UNKNOWN);
        }
    }

    public long fetchExc(Entity entity) throws Exception {
        PowerCharacterColor entPowerCharacterColor = fetchExc(entity.getOID());
        entity = (Entity) entPowerCharacterColor;
        return entPowerCharacterColor.getOID();
    }

    public static synchronized long updateExc(PowerCharacterColor entPowerCharacterColor) throws DBException {
        try {
            if (entPowerCharacterColor.getOID() != 0) {
                PstPowerCharacterColor pstPowerCharacterColor = new PstPowerCharacterColor(entPowerCharacterColor.getOID());
                pstPowerCharacterColor.setString(FLD_COLOR_NAME, entPowerCharacterColor.getColorName());
                pstPowerCharacterColor.setString(FLD_COLOR_HEX, entPowerCharacterColor.getColorHex());
                pstPowerCharacterColor.update();
                return entPowerCharacterColor.getOID();
            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstPowerCharacterColor(0), DBException.UNKNOWN);
        }
        return 0;
    }

    public long updateExc(Entity entity) throws Exception {
        return updateExc((PowerCharacterColor) entity);
    }

    public static synchronized long deleteExc(long oid) throws DBException {
        try {
            PstPowerCharacterColor pstPowerCharacterColor = new PstPowerCharacterColor(oid);
            pstPowerCharacterColor.delete();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstPowerCharacterColor(0), DBException.UNKNOWN);
        }
        return oid;
    }

    public long deleteExc(Entity entity) throws Exception {
        if (entity == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(entity.getOID());
    }

    public static synchronized long insertExc(PowerCharacterColor entPowerCharacterColor) throws DBException {
        try {
            PstPowerCharacterColor pstPowerCharacterColor = new PstPowerCharacterColor(0);
            pstPowerCharacterColor.setString(FLD_COLOR_NAME, entPowerCharacterColor.getColorName());
            pstPowerCharacterColor.setString(FLD_COLOR_HEX, entPowerCharacterColor.getColorHex());
            pstPowerCharacterColor.insert();
            entPowerCharacterColor.setOID(pstPowerCharacterColor.getlong(FLD_COLOR_NAME));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstPowerCharacterColor(0), DBException.UNKNOWN);
        }
        return entPowerCharacterColor.getOID();
    }

    public long insertExc(Entity entity) throws Exception {
        return insertExc((PowerCharacterColor) entity);
    }

    public static void resultToObject(ResultSet rs, PowerCharacterColor entPowerCharacterColor) {
        try {
            entPowerCharacterColor.setOID(rs.getLong(PstPowerCharacterColor.fieldNames[PstPowerCharacterColor.FLD_POWER_CHARACTER_COLOR_ID]));
            entPowerCharacterColor.setColorName(rs.getString(PstPowerCharacterColor.fieldNames[PstPowerCharacterColor.FLD_COLOR_NAME]));
            entPowerCharacterColor.setColorHex(rs.getString(PstPowerCharacterColor.fieldNames[PstPowerCharacterColor.FLD_COLOR_HEX]));
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
            String sql = "SELECT * FROM " + POWER_CHARACTER_COLOR;
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
                PowerCharacterColor entPowerCharacterColor = new PowerCharacterColor();
                resultToObject(rs, entPowerCharacterColor);
                lists.add(entPowerCharacterColor);
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

    public static boolean checkOID(long entPowerCharacterColorId) {
        DBResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + POWER_CHARACTER_COLOR + " WHERE "
                    + PstPowerCharacterColor.fieldNames[PstPowerCharacterColor.FLD_COLOR_NAME] + " = " + entPowerCharacterColorId;
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
            String sql = "SELECT COUNT(" + PstPowerCharacterColor.fieldNames[PstPowerCharacterColor.FLD_COLOR_NAME] + ") FROM " + POWER_CHARACTER_COLOR;
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
                    PowerCharacterColor entPowerCharacterColor = (PowerCharacterColor) list.get(ls);
                    if (oid == entPowerCharacterColor.getOID()) {
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


/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package com.dimata.harisma.entity.masterdata;

/**
 *
 * @author dimata005
 */

import com.dimata.qdep.db.*;
import com.dimata.qdep.entity.*;
import com.dimata.util.*;
import com.dimata.util.lang.I_Language;
import java.sql.ResultSet;
import java.util.Vector;

public class PstStructurePositionAccess extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {

    public static final String TBL_STRUCTURE_POSITION_ACCESS = "hr_structure_position_access";
    public static final int FLD_STRUCTURE_POSITION_ACCESS_ID = 0;
    public static final int FLD_STRUCTURE_TEMPLATE_ID = 1;
    public static final int FLD_POSITION_ID = 2;
    public static String[] fieldNames = {
        "STRUCTURE_POSITION_ACCESS_ID",
        "STRUCTURE_TEMPLATE_ID",
        "POSITION_ID"
    };
    public static int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_LONG
    };

    public PstStructurePositionAccess() {
    }

    public PstStructurePositionAccess(int i) throws DBException {
        super(new PstStructurePositionAccess());
    }

    public PstStructurePositionAccess(String sOid) throws DBException {
        super(new PstStructurePositionAccess(0));
        if (!locate(sOid)) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public PstStructurePositionAccess(long lOid) throws DBException {
        super(new PstStructurePositionAccess(0));
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
        return TBL_STRUCTURE_POSITION_ACCESS;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new PstStructurePositionAccess().getClass().getName();
    }

    public static StructurePositionAccess fetchExc(long oid) throws DBException {
        try {
            StructurePositionAccess entStructurePositionAccess = new StructurePositionAccess();
            PstStructurePositionAccess pstPositionCompany = new PstStructurePositionAccess(oid);
            entStructurePositionAccess.setOID(oid);
            entStructurePositionAccess.setTemplateId(pstPositionCompany.getLong(FLD_STRUCTURE_TEMPLATE_ID));
            entStructurePositionAccess.setPositionId(pstPositionCompany.getLong(FLD_POSITION_ID));
            return entStructurePositionAccess;
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstStructurePositionAccess(0), DBException.UNKNOWN);
        }
    }

    public long fetchExc(Entity entity) throws Exception {
        StructurePositionAccess entStructurePositionAccess = fetchExc(entity.getOID());
        entity = (Entity) entStructurePositionAccess;
        return entStructurePositionAccess.getOID();
    }

    public static synchronized long updateExc(StructurePositionAccess entStructurePositionAccess) throws DBException {
        try {
            if (entStructurePositionAccess.getOID() != 0) {
                PstStructurePositionAccess pstPositionCompany = new PstStructurePositionAccess(entStructurePositionAccess.getOID());
                pstPositionCompany.setLong(FLD_STRUCTURE_TEMPLATE_ID, entStructurePositionAccess.getTemplateId());
                pstPositionCompany.setLong(FLD_POSITION_ID, entStructurePositionAccess.getPositionId());
                pstPositionCompany.update();
                return entStructurePositionAccess.getOID();
            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstStructurePositionAccess(0), DBException.UNKNOWN);
        }
        return 0;
    }

    public long updateExc(Entity entity) throws Exception {
        return updateExc((StructurePositionAccess) entity);
    }

    public static synchronized long deleteExc(long oid) throws DBException {
        try {
            PstStructurePositionAccess pstPositionCompany = new PstStructurePositionAccess(oid);
            pstPositionCompany.delete();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstStructurePositionAccess(0), DBException.UNKNOWN);
        }
        return oid;
    }

    public long deleteExc(Entity entity) throws Exception {
        if (entity == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(entity.getOID());
    }

    public static synchronized long insertExc(StructurePositionAccess entStructurePositionAccess) throws DBException {
        try {
            PstStructurePositionAccess pstPositionCompany = new PstStructurePositionAccess(0);
            pstPositionCompany.setLong(FLD_STRUCTURE_TEMPLATE_ID, entStructurePositionAccess.getTemplateId());
            pstPositionCompany.setLong(FLD_POSITION_ID, entStructurePositionAccess.getPositionId());
            pstPositionCompany.insert();
            entStructurePositionAccess.setOID(pstPositionCompany.getLong(FLD_STRUCTURE_POSITION_ACCESS_ID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstStructurePositionAccess(0), DBException.UNKNOWN);
        }
        return entStructurePositionAccess.getOID();
    }

    public long insertExc(Entity entity) throws Exception {
        return insertExc((StructurePositionAccess) entity);
    }

    public static void resultToObject(ResultSet rs, StructurePositionAccess entStructurePositionAccess) {
        try {
            entStructurePositionAccess.setOID(rs.getLong(PstStructurePositionAccess.fieldNames[PstStructurePositionAccess.FLD_STRUCTURE_POSITION_ACCESS_ID]));
            entStructurePositionAccess.setTemplateId(rs.getLong(PstStructurePositionAccess.fieldNames[PstStructurePositionAccess.FLD_STRUCTURE_TEMPLATE_ID]));
            entStructurePositionAccess.setPositionId(rs.getLong(PstStructurePositionAccess.fieldNames[PstStructurePositionAccess.FLD_POSITION_ID]));
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
            String sql = "SELECT * FROM " + TBL_STRUCTURE_POSITION_ACCESS;
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
                StructurePositionAccess entStructurePositionAccess = new StructurePositionAccess();
                resultToObject(rs, entStructurePositionAccess);
                lists.add(entStructurePositionAccess);
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

    public static boolean checkOID(long entPositionCompanyId) {
        DBResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + TBL_STRUCTURE_POSITION_ACCESS + " WHERE "
                    + PstStructurePositionAccess.fieldNames[PstStructurePositionAccess.FLD_POSITION_ID] + " = " + entPositionCompanyId;
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
            String sql = "SELECT COUNT(" + PstStructurePositionAccess.fieldNames[PstStructurePositionAccess.FLD_POSITION_ID] + ") FROM " + TBL_STRUCTURE_POSITION_ACCESS;
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
                    StructurePositionAccess entStructurePositionAccess = (StructurePositionAccess) list.get(ls);
                    if (oid == entStructurePositionAccess.getOID()) {
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

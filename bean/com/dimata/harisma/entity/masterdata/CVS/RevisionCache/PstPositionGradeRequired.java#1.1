/*
 * To change this template, choose Tools | Templates
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
 * @author Hendra McHen | 2015-02-02
 */
public class PstPositionGradeRequired extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {

    public static final String TBL_POSITION_GRADE_REQUIRED = "hr_pos_grade_req";
    public static final int FLD_POS_GRADE_REQ_ID = 0;
    public static final int FLD_POSITION_ID = 1;
    public static final int FLD_MIN_GRADE_LEVEL_ID = 2;
    public static final int FLD_MAX_GRADE_LEVEL_ID = 3;
    public static final int FLD_NOTE = 4;
    public static String[] fieldNames = {
        "POS_GRADE_REQ_ID",
        "POSITION_ID",
        "MIN_GRADE_LEVEL_ID",
        "MAX_GRADE_LEVEL_ID",
        "NOTE"
    };
    public static int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_STRING
    };

    public PstPositionGradeRequired() {
    }

    public PstPositionGradeRequired(int i) throws DBException {
        super(new PstPositionGradeRequired());
    }

    public PstPositionGradeRequired(String sOid) throws DBException {
        super(new PstPositionGradeRequired(0));
        if (!locate(sOid)) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public PstPositionGradeRequired(long lOid) throws DBException {
        super(new PstPositionGradeRequired(0));
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
        return TBL_POSITION_GRADE_REQUIRED;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new PstPositionGradeRequired().getClass().getName();
    }

    public static PositionGradeRequired fetchExc(long oid) throws DBException {
        try {
            PositionGradeRequired entPositionGradeRequired = new PositionGradeRequired();
            PstPositionGradeRequired pstPositionGradeRequired = new PstPositionGradeRequired(oid);
            entPositionGradeRequired.setOID(oid);
            entPositionGradeRequired.setPositionId(pstPositionGradeRequired.getlong(FLD_POSITION_ID));
            entPositionGradeRequired.setGradeMinimum(new GradeLevel(pstPositionGradeRequired.getlong(FLD_MIN_GRADE_LEVEL_ID),"",0));
            entPositionGradeRequired.setGradeMaximum(new GradeLevel(pstPositionGradeRequired.getlong(FLD_MAX_GRADE_LEVEL_ID),"",0));
            entPositionGradeRequired.setNote(pstPositionGradeRequired.getString(FLD_NOTE));
            return entPositionGradeRequired;
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstPositionGradeRequired(0), DBException.UNKNOWN);
        }
    }

    public long fetchExc(Entity entity) throws Exception {
        PositionGradeRequired entPositionGradeRequired = fetchExc(entity.getOID());
        entity = (Entity) entPositionGradeRequired;
        return entPositionGradeRequired.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((PositionGradeRequired) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((PositionGradeRequired) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static long insertExc(PositionGradeRequired entPositionGradeRequired) throws DBException {
        try {
            PstPositionGradeRequired pstPositionGradeRequired = new PstPositionGradeRequired(0);
            pstPositionGradeRequired.setLong(FLD_POSITION_ID, entPositionGradeRequired.getPositionId());
            pstPositionGradeRequired.setLong(FLD_MIN_GRADE_LEVEL_ID, entPositionGradeRequired.getGradeMinimum().getOID());
            pstPositionGradeRequired.setLong(FLD_MAX_GRADE_LEVEL_ID, entPositionGradeRequired.getGradeMaximum().getOID());
            pstPositionGradeRequired.setString(FLD_NOTE, entPositionGradeRequired.getNote());
            pstPositionGradeRequired.insert();
            entPositionGradeRequired.setOID(pstPositionGradeRequired.getLong(FLD_POS_GRADE_REQ_ID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstPositionGradeRequired(0), DBException.UNKNOWN);
        }
        return entPositionGradeRequired.getOID();
    }

    public static long updateExc(PositionGradeRequired entPositionGradeRequired) throws DBException {
        try {
            if (entPositionGradeRequired.getOID() != 0) {
                PstPositionGradeRequired pstPositionGradeRequired = new PstPositionGradeRequired(entPositionGradeRequired.getOID());
                pstPositionGradeRequired.setLong(FLD_POSITION_ID, entPositionGradeRequired.getPositionId());
            pstPositionGradeRequired.setLong(FLD_MIN_GRADE_LEVEL_ID, entPositionGradeRequired.getGradeMinimum().getOID());
            pstPositionGradeRequired.setLong(FLD_MAX_GRADE_LEVEL_ID, entPositionGradeRequired.getGradeMaximum().getOID());
                pstPositionGradeRequired.setString(FLD_NOTE, entPositionGradeRequired.getNote());

                pstPositionGradeRequired.update();
                return entPositionGradeRequired.getOID();

            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstPositionGradeRequired(0), DBException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws DBException {
        try {
            PstPositionGradeRequired pstPositionGradeRequired = new PstPositionGradeRequired(oid);
            pstPositionGradeRequired.delete();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstPositionGradeRequired(0), DBException.UNKNOWN);
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
            String sql = "SELECT * FROM " + TBL_POSITION_GRADE_REQUIRED;
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
                PositionGradeRequired entPositionGradeRequired = new PositionGradeRequired();
                resultToObject(rs, entPositionGradeRequired);
                lists.add(entPositionGradeRequired);
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

    public static Vector<PositionGradeRequired> listInnerJoin(String where){
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql  = "SELECT "+
                    "GR."+PstPositionGradeRequired.fieldNames[PstPositionGradeRequired.FLD_POS_GRADE_REQ_ID] +
                    ",GR."+PstPositionGradeRequired.fieldNames[PstPositionGradeRequired.FLD_POSITION_ID] +
                    ",GR."+PstPositionGradeRequired.fieldNames[PstPositionGradeRequired.FLD_MIN_GRADE_LEVEL_ID] +
                    ",GR."+PstPositionGradeRequired.fieldNames[PstPositionGradeRequired.FLD_MAX_GRADE_LEVEL_ID] +
                    ",GR."+PstPositionGradeRequired.fieldNames[PstPositionGradeRequired.FLD_NOTE] +
                    ",G1."+PstGradeLevel.fieldNames[PstGradeLevel.FLD_GRADE_LEVEL_ID] + " AS G1_ID " +
                    ",G1."+PstGradeLevel.fieldNames[PstGradeLevel.FLD_GRADE_CODE] +" AS G1_CODE " +
                    ",G1."+PstGradeLevel.fieldNames[PstGradeLevel.FLD_GRADE_RANK] +" AS G1_RANK " +
                    ",G2."+PstGradeLevel.fieldNames[PstGradeLevel.FLD_GRADE_LEVEL_ID] + " AS G2_ID " +
                    ",G2."+PstGradeLevel.fieldNames[PstGradeLevel.FLD_GRADE_CODE] +" AS G2_CODE " +
                    ",G2."+PstGradeLevel.fieldNames[PstGradeLevel.FLD_GRADE_RANK] +" AS G2_RANK " +
                    " FROM " + TBL_POSITION_GRADE_REQUIRED +  " GR ";
                   sql += " INNER JOIN "+PstGradeLevel.TBL_HR_GRADE_LEVEL+" AS G1 "
                           +" ON GR."+PstPositionGradeRequired.fieldNames[PstPositionGradeRequired.FLD_MIN_GRADE_LEVEL_ID]+"="+
                              "G1."+PstGradeLevel.fieldNames[PstGradeLevel.FLD_GRADE_LEVEL_ID];
                   sql += " INNER JOIN "+PstGradeLevel.TBL_HR_GRADE_LEVEL+" AS G2 "
                           +" ON GR."+PstPositionGradeRequired.fieldNames[PstPositionGradeRequired.FLD_MAX_GRADE_LEVEL_ID]+"="+
                              "G2."+PstGradeLevel.fieldNames[PstGradeLevel.FLD_GRADE_LEVEL_ID];
                   sql += " WHERE "+where+"";
            
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                Vector vect = new Vector(1,1);
                PositionGradeRequired entPositionGradeRequired = new PositionGradeRequired();
                 entPositionGradeRequired.setOID(rs.getLong(PstPositionGradeRequired.fieldNames[PstPositionGradeRequired.FLD_POS_GRADE_REQ_ID]));
            entPositionGradeRequired.setPositionId(rs.getLong(PstPositionGradeRequired.fieldNames[PstPositionGradeRequired.FLD_POSITION_ID]));
            entPositionGradeRequired.setGradeMinimum(new GradeLevel(rs.getLong("G1_ID"), rs.getString("G1_CODE"), rs.getInt("G1_RANK")));
            entPositionGradeRequired.setGradeMaximum(new GradeLevel(rs.getLong("G2_ID"), rs.getString("G2_CODE"), rs.getInt("G2_RANK")));
            entPositionGradeRequired.setNote(rs.getString(PstPositionGradeRequired.fieldNames[PstPositionGradeRequired.FLD_NOTE]));

                lists.add(entPositionGradeRequired);
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
    
   
    
    private static void resultToObject(ResultSet rs, PositionGradeRequired entPositionGradeRequired) {
        try {
            entPositionGradeRequired.setOID(rs.getLong(PstPositionGradeRequired.fieldNames[PstPositionGradeRequired.FLD_POS_GRADE_REQ_ID]));
            entPositionGradeRequired.setPositionId(rs.getLong(PstPositionGradeRequired.fieldNames[PstPositionGradeRequired.FLD_POSITION_ID]));
            entPositionGradeRequired.setGradeMinimum(new GradeLevel(rs.getLong(PstPositionGradeRequired.fieldNames[PstPositionGradeRequired.FLD_MIN_GRADE_LEVEL_ID]),"",0));
            entPositionGradeRequired.setGradeMaximum(new GradeLevel(rs.getLong(PstPositionGradeRequired.fieldNames[PstPositionGradeRequired.FLD_MAX_GRADE_LEVEL_ID]),"",0));
            entPositionGradeRequired.setNote(rs.getString(PstPositionGradeRequired.fieldNames[PstPositionGradeRequired.FLD_NOTE]));
        } catch (Exception e) {
        }
    }
    


    public static boolean checkOID(long entPositionGradeRequiredId) {
        DBResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + TBL_POSITION_GRADE_REQUIRED + " WHERE "
                    + PstPositionGradeRequired.fieldNames[PstPositionGradeRequired.FLD_POS_GRADE_REQ_ID] + " = " + entPositionGradeRequiredId;

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
            String sql = "SELECT COUNT(" + PstPositionGradeRequired.fieldNames[PstPositionGradeRequired.FLD_POS_GRADE_REQ_ID] + ") FROM " + TBL_POSITION_GRADE_REQUIRED;
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
                    PositionGradeRequired entPositionGradeRequired = (PositionGradeRequired) list.get(ls);
                    if (oid == entPositionGradeRequired.getOID()) {
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

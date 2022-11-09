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
import java.util.Hashtable;
import java.util.Vector;
/**
 *
 * @author keys
 */
public class PstTrainingCompetencyMapping extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language{
    public static final String TBL_TRAININGCOMPETENCYMAPPING = "hr_training_competency_mapping";
    public static final int FLD_TRAINING_COMPETENCY_MAPPING_ID = 0;
    public static final int FLD_TRAINING_ACTIVITY_ACTUAL_ID = 1;
    public static final int FLD_COMPETENCY_ID = 2;
    public static final int FLD_SCORE = 3;

    public static String[] fieldNames = {
        "TRAINING_COMPETENCY_MAPPING_ID",
        "TRAINING_ACTIVITY_ACTUAL_ID",
        "COMPETENCY_ID",
        "SCORE"
    };

    public static int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_INT
    };

    public PstTrainingCompetencyMapping() {
    }

    public PstTrainingCompetencyMapping(int i) throws DBException {
        super(new PstTrainingCompetencyMapping());
    }

    public PstTrainingCompetencyMapping(String sOid) throws DBException {
        super(new PstTrainingCompetencyMapping(0));
        if (!locate(sOid)) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public PstTrainingCompetencyMapping(long lOid) throws DBException {
        super(new PstTrainingCompetencyMapping(0));
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
        return TBL_TRAININGCOMPETENCYMAPPING;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new PstTrainingCompetencyMapping().getClass().getName();
    }

    public static TrainingCompetencyMapping fetchExc(long oid) throws DBException {
        try {
            TrainingCompetencyMapping entTrainingCompetencyMapping = new TrainingCompetencyMapping();
            PstTrainingCompetencyMapping pstTrainingCompetencyMapping = new PstTrainingCompetencyMapping(oid);
            entTrainingCompetencyMapping.setOID(oid);
            entTrainingCompetencyMapping.setTrainingActivityActualId(pstTrainingCompetencyMapping.getlong(FLD_TRAINING_ACTIVITY_ACTUAL_ID));
            entTrainingCompetencyMapping.setCompetencyId(pstTrainingCompetencyMapping.getlong(FLD_COMPETENCY_ID));
            entTrainingCompetencyMapping.setScore(pstTrainingCompetencyMapping.getInt(FLD_SCORE));
            return entTrainingCompetencyMapping;
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstTrainingCompetencyMapping(0), DBException.UNKNOWN);
        }
    }

    public long fetchExc(Entity entity) throws Exception {
        TrainingCompetencyMapping entTrainingCompetencyMapping = fetchExc(entity.getOID());
        entity = (Entity) entTrainingCompetencyMapping;
        return entTrainingCompetencyMapping.getOID();
    }

    public static synchronized long updateExc(TrainingCompetencyMapping entTrainingCompetencyMapping) throws DBException {
        try {
            if (entTrainingCompetencyMapping.getOID() != 0) {
                PstTrainingCompetencyMapping pstTrainingCompetencyMapping = new PstTrainingCompetencyMapping(entTrainingCompetencyMapping.getOID());
                pstTrainingCompetencyMapping.setLong(FLD_TRAINING_ACTIVITY_ACTUAL_ID, entTrainingCompetencyMapping.getTrainingActivityActualId());
                pstTrainingCompetencyMapping.setLong(FLD_COMPETENCY_ID, entTrainingCompetencyMapping.getCompetencyId());
                pstTrainingCompetencyMapping.setDouble(FLD_SCORE, entTrainingCompetencyMapping.getScore());
                pstTrainingCompetencyMapping.update();
                return entTrainingCompetencyMapping.getOID();
            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstTrainingCompetencyMapping(0), DBException.UNKNOWN);
        }
        return 0;
    }

    public long updateExc(Entity entity) throws Exception {
        return updateExc((TrainingCompetencyMapping) entity);
    }

    public static synchronized long deleteExc(long oid) throws DBException {
        try {
            PstTrainingCompetencyMapping pstTrainingCompetencyMapping = new PstTrainingCompetencyMapping(oid);
            pstTrainingCompetencyMapping.delete();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstTrainingCompetencyMapping(0), DBException.UNKNOWN);
        }
        return oid;
    }

    public long deleteExc(Entity entity) throws Exception {
        if (entity == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(entity.getOID());
    }

    public static synchronized long insertExc(TrainingCompetencyMapping entTrainingCompetencyMapping) throws DBException {
        try {
            PstTrainingCompetencyMapping pstTrainingCompetencyMapping = new PstTrainingCompetencyMapping(0);
            pstTrainingCompetencyMapping.setLong(FLD_TRAINING_ACTIVITY_ACTUAL_ID, entTrainingCompetencyMapping.getTrainingActivityActualId());
            pstTrainingCompetencyMapping.setLong(FLD_COMPETENCY_ID, entTrainingCompetencyMapping.getCompetencyId());
            pstTrainingCompetencyMapping.setDouble(FLD_SCORE, entTrainingCompetencyMapping.getScore());
            pstTrainingCompetencyMapping.insert();
            entTrainingCompetencyMapping.setOID(pstTrainingCompetencyMapping.getlong(FLD_TRAINING_COMPETENCY_MAPPING_ID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstTrainingCompetencyMapping(0), DBException.UNKNOWN);
        }
        return entTrainingCompetencyMapping.getOID();
    }

    public long insertExc(Entity entity) throws Exception {
        return insertExc((TrainingCompetencyMapping) entity);
    }

    public static void resultToObject(ResultSet rs, TrainingCompetencyMapping entTrainingCompetencyMapping) {
        try {
            entTrainingCompetencyMapping.setOID(rs.getLong(PstTrainingCompetencyMapping.fieldNames[PstTrainingCompetencyMapping.FLD_TRAINING_COMPETENCY_MAPPING_ID]));
            entTrainingCompetencyMapping.setTrainingActivityActualId(rs.getLong(PstTrainingCompetencyMapping.fieldNames[PstTrainingCompetencyMapping.FLD_TRAINING_ACTIVITY_ACTUAL_ID]));
            entTrainingCompetencyMapping.setCompetencyId(rs.getLong(PstTrainingCompetencyMapping.fieldNames[PstTrainingCompetencyMapping.FLD_COMPETENCY_ID]));
            entTrainingCompetencyMapping.setScore(rs.getInt(PstTrainingCompetencyMapping.fieldNames[PstTrainingCompetencyMapping.FLD_SCORE]));
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
            String sql = "SELECT * FROM " + TBL_TRAININGCOMPETENCYMAPPING;
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
                TrainingCompetencyMapping entTrainingCompetencyMapping = new TrainingCompetencyMapping();
                resultToObject(rs, entTrainingCompetencyMapping);
                lists.add(entTrainingCompetencyMapping);
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

    public static Vector listTrainingCompetencyMapByOidActual(long oidTrainingActualId) {
        DBResultSet dbrs = null;
         Vector lists = new Vector();
        try {
            String sql = "SELECT * FROM " + TBL_TRAININGCOMPETENCYMAPPING + " WHERE "
                    + PstTrainingCompetencyMapping.fieldNames[PstTrainingCompetencyMapping.FLD_TRAINING_ACTIVITY_ACTUAL_ID] + " = " + oidTrainingActualId;
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                TrainingCompetencyMapping entTrainingCompetencyMapping = new TrainingCompetencyMapping();
                resultToObject(rs, entTrainingCompetencyMapping);
                lists.add(entTrainingCompetencyMapping);
            }
            rs.close();
            return lists;
        } catch (Exception e) {
            System.out.println("err : " + e.toString());
        } finally {
            DBResultSet.close(dbrs);
        }
        return new Vector();
    }
    
    public static boolean deleteCompetencyMapByTrainingActualId(long oidTrainingActual) {
        DBResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "DELETE FROM " + TBL_TRAININGCOMPETENCYMAPPING + " WHERE "
                    + PstTrainingCompetencyMapping.fieldNames[PstTrainingCompetencyMapping.FLD_TRAINING_ACTIVITY_ACTUAL_ID] + " = " + oidTrainingActual;
            DBHandler.execUpdate(sql);
            result = true;
        } catch (Exception e) {
            result = false;
            System.out.println("err : " + e.toString());
        } finally {
            DBResultSet.close(dbrs);
            return result;
        }
    }
        
    public static boolean checkOID(long entTrainingCompetencyMappingId) {
        DBResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + TBL_TRAININGCOMPETENCYMAPPING + " WHERE "
                    + PstTrainingCompetencyMapping.fieldNames[PstTrainingCompetencyMapping.FLD_TRAINING_COMPETENCY_MAPPING_ID] + " = " + entTrainingCompetencyMappingId;
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
            String sql = "SELECT COUNT(" + PstTrainingCompetencyMapping.fieldNames[PstTrainingCompetencyMapping.FLD_TRAINING_ACTIVITY_ACTUAL_ID] + ") FROM " + TBL_TRAININGCOMPETENCYMAPPING;
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
                    TrainingCompetencyMapping entTrainingCompetencyMapping = (TrainingCompetencyMapping) list.get(ls);
                    if (oid == entTrainingCompetencyMapping.getOID()) {
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
    
    
      public static Hashtable listHashByTrainingActualId(long oidTrainingActual) {
        Hashtable result = new Hashtable();
        DBResultSet dbrs = null;
        String whereClause = " "+PstTrainingCompetencyMapping.fieldNames[PstTrainingCompetencyMapping.FLD_TRAINING_ACTIVITY_ACTUAL_ID]+ " = "+ oidTrainingActual;
        try {
            if (whereClause != null && whereClause.length() > 0) {
            String sql = "SELECT * FROM " + TBL_TRAININGCOMPETENCYMAPPING;
            
                sql = sql + " WHERE " + whereClause;
           
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                result.put(rs.getLong(PstTrainingCompetencyMapping.fieldNames[PstTrainingCompetencyMapping.FLD_COMPETENCY_ID]), rs.getDouble(PstTrainingCompetencyMapping.fieldNames[PstTrainingCompetencyMapping.FLD_SCORE]));
            }
            rs.close();
            }
            return result;
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return  new Hashtable();
    }

 
}

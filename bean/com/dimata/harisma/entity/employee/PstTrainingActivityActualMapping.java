/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.employee;

/**
 *
 * @author Gunadi
 */
import java.sql.*;
import com.dimata.util.lang.I_Language;
import com.dimata.qdep.db.*;
import com.dimata.qdep.entity.*;
import com.dimata.util.Command;
import java.util.Vector;

public class PstTrainingActivityActualMapping extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {

    public static final String TBL_TRAINING_ACTIVITY_ACTUAL_MAPPING = "hr_training_activity_actual_mapping";
    public static final int FLD_TRAINING_ACTIVITY_ACTUAL_MAPPING_ID = 0;
    public static final int FLD_TRAINING_ACTIVITY_ACTUAL_ID = 1;
    public static final int FLD_TRAINING_ID = 2;
    public static String[] fieldNames = {
        "TRAINING_ACTIVITY_ACTUAL_MAPPING_ID",
        "TRAINING_ACTIVITY_ACTUAL_ID",
        "TRAINING_ID"
    };
    public static int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_LONG
    };

    public PstTrainingActivityActualMapping() {
    }

    public PstTrainingActivityActualMapping(int i) throws DBException {
        super(new PstTrainingActivityActualMapping());
    }

    public PstTrainingActivityActualMapping(String sOid) throws DBException {
        super(new PstTrainingActivityActualMapping(0));
        if (!locate(sOid)) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public PstTrainingActivityActualMapping(long lOid) throws DBException {
        super(new PstTrainingActivityActualMapping(0));
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
        return TBL_TRAINING_ACTIVITY_ACTUAL_MAPPING;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new PstTrainingActivityActualMapping().getClass().getName();
    }

    public static TrainingActivityActualMapping fetchExc(long oid) throws DBException {
        try {
            TrainingActivityActualMapping entTrainingActivityActualMapping = new TrainingActivityActualMapping();
            PstTrainingActivityActualMapping pstTrainingActivityActualMapping = new PstTrainingActivityActualMapping(oid);
            entTrainingActivityActualMapping.setOID(oid);
            entTrainingActivityActualMapping.setTrainingActivityActualId(pstTrainingActivityActualMapping.getLong(FLD_TRAINING_ACTIVITY_ACTUAL_ID));
            entTrainingActivityActualMapping.setTrainingId(pstTrainingActivityActualMapping.getLong(FLD_TRAINING_ID));
            return entTrainingActivityActualMapping;
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstTrainingActivityActualMapping(0), DBException.UNKNOWN);
        }
    }

    public long fetchExc(Entity entity) throws Exception {
        TrainingActivityActualMapping entTrainingActivityActualMapping = fetchExc(entity.getOID());
        entity = (Entity) entTrainingActivityActualMapping;
        return entTrainingActivityActualMapping.getOID();
    }

    public static synchronized long updateExc(TrainingActivityActualMapping entTrainingActivityActualMapping) throws DBException {
        try {
            if (entTrainingActivityActualMapping.getOID() != 0) {
                PstTrainingActivityActualMapping pstTrainingActivityActualMapping = new PstTrainingActivityActualMapping(entTrainingActivityActualMapping.getOID());
                pstTrainingActivityActualMapping.setLong(FLD_TRAINING_ACTIVITY_ACTUAL_ID, entTrainingActivityActualMapping.getTrainingActivityActualId());
                pstTrainingActivityActualMapping.setLong(FLD_TRAINING_ID, entTrainingActivityActualMapping.getTrainingId());
                pstTrainingActivityActualMapping.update();
                return entTrainingActivityActualMapping.getOID();
            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstTrainingActivityActualMapping(0), DBException.UNKNOWN);
        }
        return 0;
    }

    public long updateExc(Entity entity) throws Exception {
        return updateExc((TrainingActivityActualMapping) entity);
    }

    public static synchronized long deleteExc(long oid) throws DBException {
        try {
            PstTrainingActivityActualMapping pstTrainingActivityActualMapping = new PstTrainingActivityActualMapping(oid);
            pstTrainingActivityActualMapping.delete();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstTrainingActivityActualMapping(0), DBException.UNKNOWN);
        }
        return oid;
    }

    public long deleteExc(Entity entity) throws Exception {
        if (entity == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(entity.getOID());
    }

    public static synchronized long insertExc(TrainingActivityActualMapping entTrainingActivityActualMapping) throws DBException {
        try {
            PstTrainingActivityActualMapping pstTrainingActivityActualMapping = new PstTrainingActivityActualMapping(0);
            pstTrainingActivityActualMapping.setLong(FLD_TRAINING_ACTIVITY_ACTUAL_ID, entTrainingActivityActualMapping.getTrainingActivityActualId());
            pstTrainingActivityActualMapping.setLong(FLD_TRAINING_ID, entTrainingActivityActualMapping.getTrainingId());
            pstTrainingActivityActualMapping.insert();
            entTrainingActivityActualMapping.setOID(pstTrainingActivityActualMapping.getLong(FLD_TRAINING_ACTIVITY_ACTUAL_MAPPING_ID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstTrainingActivityActualMapping(0), DBException.UNKNOWN);
        }
        return entTrainingActivityActualMapping.getOID();
    }

    public long insertExc(Entity entity) throws Exception {
        return insertExc((TrainingActivityActualMapping) entity);
    }

    public static void resultToObject(ResultSet rs, TrainingActivityActualMapping entTrainingActivityActualMapping) {
        try {
            entTrainingActivityActualMapping.setOID(rs.getLong(PstTrainingActivityActualMapping.fieldNames[PstTrainingActivityActualMapping.FLD_TRAINING_ACTIVITY_ACTUAL_MAPPING_ID]));
            entTrainingActivityActualMapping.setTrainingActivityActualId(rs.getLong(PstTrainingActivityActualMapping.fieldNames[PstTrainingActivityActualMapping.FLD_TRAINING_ACTIVITY_ACTUAL_ID]));
            entTrainingActivityActualMapping.setTrainingId(rs.getLong(PstTrainingActivityActualMapping.fieldNames[PstTrainingActivityActualMapping.FLD_TRAINING_ID]));
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
            String sql = "SELECT * FROM " + TBL_TRAINING_ACTIVITY_ACTUAL_MAPPING;
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
                TrainingActivityActualMapping entTrainingActivityActualMapping = new TrainingActivityActualMapping();
                resultToObject(rs, entTrainingActivityActualMapping);
                lists.add(entTrainingActivityActualMapping);
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
    
    public static boolean checkOID(long entTrainingActivityActualMappingId) {
        DBResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + TBL_TRAINING_ACTIVITY_ACTUAL_MAPPING + " WHERE "
                    + PstTrainingActivityActualMapping.fieldNames[PstTrainingActivityActualMapping.FLD_TRAINING_ACTIVITY_ACTUAL_MAPPING_ID] + " = " + entTrainingActivityActualMappingId;
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
            String sql = "SELECT COUNT(" + PstTrainingActivityActualMapping.fieldNames[PstTrainingActivityActualMapping.FLD_TRAINING_ACTIVITY_ACTUAL_MAPPING_ID] + ") FROM " + TBL_TRAINING_ACTIVITY_ACTUAL_MAPPING;
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
                    TrainingActivityActualMapping entTrainingActivityActualMapping = (TrainingActivityActualMapping) list.get(ls);
                    if (oid == entTrainingActivityActualMapping.getOID()) {
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
    
    public static String[] getArrayTrainingProgram(long oidTraining){
        
        String where = PstTrainingActivityActualMapping.fieldNames[PstTrainingActivityActualMapping.FLD_TRAINING_ACTIVITY_ACTUAL_ID]
                        + " = " + oidTraining;
        Vector listTraining = PstTrainingActivityActualMapping.list(0, 0, where, "");
        
        String[] list = new String[listTraining.size()];
        if (listTraining.size() > 0){
            for (int i=0; i < listTraining.size();i++){
                TrainingActivityActualMapping tr = (TrainingActivityActualMapping) listTraining.get(i);
                list[i] = String.valueOf(tr.getTrainingId());
            }
        }
        
        return list;
    }
    
}

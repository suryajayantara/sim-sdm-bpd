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

public class PstTrainingActivityMapping extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {

    public static final String TBL_TRAINING_ACTIVITY_MAPPING = "hr_training_activity_mapping";
    public static final int FLD_TRAINING_ACTIVITY_MAPPING_ID = 0;
    public static final int FLD_TRAINING_ACTIVITY_PLAN_ID = 1;
    public static final int FLD_TRAINING_ID = 2;
    public static String[] fieldNames = {
        "TRAINING_ACTIVITY_MAPPING_ID",
        "TRAINING_ACTIVITY_PLAN_ID",
        "TRAINING_ID"
    };
    public static int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_LONG
    };

    public PstTrainingActivityMapping() {
    }

    public PstTrainingActivityMapping(int i) throws DBException {
        super(new PstTrainingActivityMapping());
    }

    public PstTrainingActivityMapping(String sOid) throws DBException {
        super(new PstTrainingActivityMapping(0));
        if (!locate(sOid)) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public PstTrainingActivityMapping(long lOid) throws DBException {
        super(new PstTrainingActivityMapping(0));
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
        return TBL_TRAINING_ACTIVITY_MAPPING;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new PstTrainingActivityMapping().getClass().getName();
    }

    public static TrainingActivityMapping fetchExc(long oid) throws DBException {
        try {
            TrainingActivityMapping entTrainingActivityPlanMapping = new TrainingActivityMapping();
            PstTrainingActivityMapping pstTrainingActivityPlanMapping = new PstTrainingActivityMapping(oid);
            entTrainingActivityPlanMapping.setOID(oid);
            entTrainingActivityPlanMapping.setTrainingActivityPlanId(pstTrainingActivityPlanMapping.getLong(FLD_TRAINING_ACTIVITY_PLAN_ID));
            entTrainingActivityPlanMapping.setTrainingId(pstTrainingActivityPlanMapping.getLong(FLD_TRAINING_ID));
            return entTrainingActivityPlanMapping;
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstTrainingActivityMapping(0), DBException.UNKNOWN);
        }
    }

    public long fetchExc(Entity entity) throws Exception {
        TrainingActivityMapping entTrainingActivityPlanMapping = fetchExc(entity.getOID());
        entity = (Entity) entTrainingActivityPlanMapping;
        return entTrainingActivityPlanMapping.getOID();
    }

    public static synchronized long updateExc(TrainingActivityMapping entTrainingActivityPlanMapping) throws DBException {
        try {
            if (entTrainingActivityPlanMapping.getOID() != 0) {
                PstTrainingActivityMapping pstTrainingActivityPlanMapping = new PstTrainingActivityMapping(entTrainingActivityPlanMapping.getOID());
                pstTrainingActivityPlanMapping.setLong(FLD_TRAINING_ACTIVITY_PLAN_ID, entTrainingActivityPlanMapping.getTrainingActivityPlanId());
                pstTrainingActivityPlanMapping.setLong(FLD_TRAINING_ID, entTrainingActivityPlanMapping.getTrainingId());
                pstTrainingActivityPlanMapping.update();
                return entTrainingActivityPlanMapping.getOID();
            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstTrainingActivityMapping(0), DBException.UNKNOWN);
        }
        return 0;
    }

    public long updateExc(Entity entity) throws Exception {
        return updateExc((TrainingActivityMapping) entity);
    }

    public static synchronized long deleteExc(long oid) throws DBException {
        try {
            PstTrainingActivityMapping pstTrainingActivityPlanMapping = new PstTrainingActivityMapping(oid);
            pstTrainingActivityPlanMapping.delete();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstTrainingActivityMapping(0), DBException.UNKNOWN);
        }
        return oid;
    }

    public long deleteExc(Entity entity) throws Exception {
        if (entity == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(entity.getOID());
    }

    public static synchronized long insertExc(TrainingActivityMapping entTrainingActivityPlanMapping) throws DBException {
        try {
            PstTrainingActivityMapping pstTrainingActivityPlanMapping = new PstTrainingActivityMapping(0);
            pstTrainingActivityPlanMapping.setLong(FLD_TRAINING_ACTIVITY_PLAN_ID, entTrainingActivityPlanMapping.getTrainingActivityPlanId());
            pstTrainingActivityPlanMapping.setLong(FLD_TRAINING_ID, entTrainingActivityPlanMapping.getTrainingId());
            pstTrainingActivityPlanMapping.insert();
            entTrainingActivityPlanMapping.setOID(pstTrainingActivityPlanMapping.getLong(FLD_TRAINING_ACTIVITY_MAPPING_ID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstTrainingActivityMapping(0), DBException.UNKNOWN);
        }
        return entTrainingActivityPlanMapping.getOID();
    }

    public long insertExc(Entity entity) throws Exception {
        return insertExc((TrainingActivityMapping) entity);
    }

    public static void resultToObject(ResultSet rs, TrainingActivityMapping entTrainingActivityPlanMapping) {
        try {
            entTrainingActivityPlanMapping.setOID(rs.getLong(PstTrainingActivityMapping.fieldNames[PstTrainingActivityMapping.FLD_TRAINING_ACTIVITY_MAPPING_ID]));
            entTrainingActivityPlanMapping.setTrainingActivityPlanId(rs.getLong(PstTrainingActivityMapping.fieldNames[PstTrainingActivityMapping.FLD_TRAINING_ACTIVITY_PLAN_ID]));
            entTrainingActivityPlanMapping.setTrainingId(rs.getLong(PstTrainingActivityMapping.fieldNames[PstTrainingActivityMapping.FLD_TRAINING_ID]));
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
            String sql = "SELECT * FROM " + TBL_TRAINING_ACTIVITY_MAPPING;
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
                TrainingActivityMapping entTrainingActivityPlanMapping = new TrainingActivityMapping();
                resultToObject(rs, entTrainingActivityPlanMapping);
                lists.add(entTrainingActivityPlanMapping);
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

    public static boolean checkOID(long entTrainingActivityPlanMappingId) {
        DBResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + TBL_TRAINING_ACTIVITY_MAPPING + " WHERE "
                    + PstTrainingActivityMapping.fieldNames[PstTrainingActivityMapping.FLD_TRAINING_ACTIVITY_MAPPING_ID] + " = " + entTrainingActivityPlanMappingId;
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
            String sql = "SELECT COUNT(" + PstTrainingActivityMapping.fieldNames[PstTrainingActivityMapping.FLD_TRAINING_ACTIVITY_MAPPING_ID] + ") FROM " + TBL_TRAINING_ACTIVITY_MAPPING;
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
                    TrainingActivityMapping entTrainingActivityPlanMapping = (TrainingActivityMapping) list.get(ls);
                    if (oid == entTrainingActivityPlanMapping.getOID()) {
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
        
        String where = PstTrainingActivityMapping.fieldNames[PstTrainingActivityMapping.FLD_TRAINING_ACTIVITY_PLAN_ID]
                        + " = " + oidTraining;
        Vector listTraining = PstTrainingActivityMapping.list(0, 0, where, "");
        
        String[] list = new String[listTraining.size()];
        if (listTraining.size() > 0){
            for (int i=0; i < listTraining.size();i++){
                TrainingActivityMapping tr = (TrainingActivityMapping) listTraining.get(i);
                list[i] = String.valueOf(tr.getTrainingId());
            }
        }
        
        return list;
    }
    
    public static boolean isContain(String[] array, String targetValue){
        for (String s:array){
            if (s.equals(targetValue)){
                return true;
            }
        }
        return false;
    }
    
}

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
import com.dimata.util.lang.I_Language;
import java.sql.ResultSet;
import java.util.Vector;

/**
 *
 * @author khirayinnura
 */
public class PstTrainingBudget extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {

    public static final String TBL_TRAINING_BUDGET = "hr_training_budget";
    public static final int FLD_TRAINING_BUDGET_ID = 0;
    public static final int FLD_TRAINING_BUDGET_YEAR = 1;
    public static final int FLD_TRAINING_ID = 2;
    public static final int FLD_TRAINING_BUDGET_DURATION = 3;
    public static final int FLD_TRAINING_BUDGET_FREQUENCY = 4;
    public static final int FLD_TRAINING_BUDGET_BATCH = 5;
    public static final int FLD_TRAINING_BUDGET_AMOUNT = 6;
    public static final int FLD_TRAINING_BUDGET_COST_BATCH = 7;
    public static final int FLD_TRAINING_BUDGET_TOTAL = 8;
    public static final int FLD_TRAINING_LOCATION_TYPE_ID = 9;
    public static final int FLD_TRAINING_AREA_ID = 10;
    public static final int FLD_TRAINING_BUDGET_DESC = 11;
    public static String[] fieldNames = {
        "TRAINING_BUDGET_ID",
        "TRAINING_BUDGET_YEAR",
        "TRAINING_ID",
        "TRAINING_BUDGET_DURATION",
        "TRAINING_BUDGET_FREQUENCY",
        "TRAINING_BUDGET_BATCH",
        "TRAINING_BUDGET_AMOUNT",
        "TRAINING_BUDGET_COST_BATCH",
        "TRAINING_BUDGET_TOTAL",
        "TRAINING_LOCATION_TYPE_ID",
        "TRAINING_AREA_ID",
        "TRAINING_BUDGET_DESC"
    };
    public static int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_STRING,
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_STRING
    };

    public PstTrainingBudget() {
    }

    public PstTrainingBudget(int i) throws DBException {
        super(new PstTrainingBudget());
    }

    public PstTrainingBudget(String sOid) throws DBException {
        super(new PstTrainingBudget(0));
        if (!locate(sOid)) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public PstTrainingBudget(long lOid) throws DBException {
        super(new PstTrainingBudget(0));
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
        return TBL_TRAINING_BUDGET;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new PstTrainingBudget().getClass().getName();
    }

    public static TrainingBudget fetchExc(long oid) throws DBException {
        try {
            TrainingBudget entTrainingBudget = new TrainingBudget();
            PstTrainingBudget pstTrainingBudget = new PstTrainingBudget(oid);
            entTrainingBudget.setOID(oid);
            entTrainingBudget.setTrainingBudgetYear(pstTrainingBudget.getString(FLD_TRAINING_BUDGET_YEAR));
            entTrainingBudget.setTrainingId(pstTrainingBudget.getLong(FLD_TRAINING_ID));
            entTrainingBudget.setTrainingBudgetDuration(pstTrainingBudget.getdouble(FLD_TRAINING_BUDGET_DURATION));
            entTrainingBudget.setTrainingBudgetFrequency(pstTrainingBudget.getdouble(FLD_TRAINING_BUDGET_FREQUENCY));
            entTrainingBudget.setTrainingBudgetBatch(pstTrainingBudget.getdouble(FLD_TRAINING_BUDGET_BATCH));
            entTrainingBudget.setTrainingBudgetAmount(pstTrainingBudget.getdouble(FLD_TRAINING_BUDGET_AMOUNT));
            entTrainingBudget.setTrainingBudgetCostBatch(pstTrainingBudget.getdouble(FLD_TRAINING_BUDGET_COST_BATCH));
            entTrainingBudget.setTrainingBudgetTotal(pstTrainingBudget.getdouble(FLD_TRAINING_BUDGET_TOTAL));
            entTrainingBudget.setTrainingLocationTypeId(pstTrainingBudget.getLong(FLD_TRAINING_LOCATION_TYPE_ID));
            entTrainingBudget.setTrainingAreaId(pstTrainingBudget.getLong(FLD_TRAINING_AREA_ID));
            entTrainingBudget.setTrainingBudgetDesc(pstTrainingBudget.getString(FLD_TRAINING_BUDGET_DESC));
            return entTrainingBudget;
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstTrainingBudget(0), DBException.UNKNOWN);
        }
    }

    public long fetchExc(Entity entity) throws Exception {
        TrainingBudget entTrainingBudget = fetchExc(entity.getOID());
        entity = (Entity) entTrainingBudget;
        return entTrainingBudget.getOID();
    }

    public static synchronized long updateExc(TrainingBudget entTrainingBudget) throws DBException {
        try {
            if (entTrainingBudget.getOID() != 0) {
                PstTrainingBudget pstTrainingBudget = new PstTrainingBudget(entTrainingBudget.getOID());
                pstTrainingBudget.setString(FLD_TRAINING_BUDGET_YEAR, entTrainingBudget.getTrainingBudgetYear());
                pstTrainingBudget.setLong(FLD_TRAINING_ID, entTrainingBudget.getTrainingId());
                pstTrainingBudget.setDouble(FLD_TRAINING_BUDGET_DURATION, entTrainingBudget.getTrainingBudgetDuration());
                pstTrainingBudget.setDouble(FLD_TRAINING_BUDGET_FREQUENCY, entTrainingBudget.getTrainingBudgetFrequency());
                pstTrainingBudget.setDouble(FLD_TRAINING_BUDGET_BATCH, entTrainingBudget.getTrainingBudgetBatch());
                pstTrainingBudget.setDouble(FLD_TRAINING_BUDGET_AMOUNT, entTrainingBudget.getTrainingBudgetAmount());
                pstTrainingBudget.setDouble(FLD_TRAINING_BUDGET_COST_BATCH, entTrainingBudget.getTrainingBudgetCostBatch());
                pstTrainingBudget.setDouble(FLD_TRAINING_BUDGET_TOTAL, entTrainingBudget.getTrainingBudgetTotal());
                pstTrainingBudget.setLong(FLD_TRAINING_LOCATION_TYPE_ID, entTrainingBudget.getTrainingLocationTypeId());
                pstTrainingBudget.setLong(FLD_TRAINING_AREA_ID, entTrainingBudget.getTrainingAreaId());
                pstTrainingBudget.setString(FLD_TRAINING_BUDGET_DESC, entTrainingBudget.getTrainingBudgetDesc());
                pstTrainingBudget.update();
                return entTrainingBudget.getOID();
            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstTrainingBudget(0), DBException.UNKNOWN);
        }
        return 0;
    }

    public long updateExc(Entity entity) throws Exception {
        return updateExc((TrainingBudget) entity);
    }

    public static synchronized long deleteExc(long oid) throws DBException {
        try {
            PstTrainingBudget pstTrainingBudget = new PstTrainingBudget(oid);
            pstTrainingBudget.delete();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstTrainingBudget(0), DBException.UNKNOWN);
        }
        return oid;
    }

    public long deleteExc(Entity entity) throws Exception {
        if (entity == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(entity.getOID());
    }

    public static synchronized long insertExc(TrainingBudget entTrainingBudget) throws DBException {
        try {
            PstTrainingBudget pstTrainingBudget = new PstTrainingBudget(0);
            pstTrainingBudget.setString(FLD_TRAINING_BUDGET_YEAR, entTrainingBudget.getTrainingBudgetYear());
            pstTrainingBudget.setLong(FLD_TRAINING_ID, entTrainingBudget.getTrainingId());
            pstTrainingBudget.setDouble(FLD_TRAINING_BUDGET_DURATION, entTrainingBudget.getTrainingBudgetDuration());
            pstTrainingBudget.setDouble(FLD_TRAINING_BUDGET_FREQUENCY, entTrainingBudget.getTrainingBudgetFrequency());
            pstTrainingBudget.setDouble(FLD_TRAINING_BUDGET_BATCH, entTrainingBudget.getTrainingBudgetBatch());
            pstTrainingBudget.setDouble(FLD_TRAINING_BUDGET_AMOUNT, entTrainingBudget.getTrainingBudgetAmount());
            pstTrainingBudget.setDouble(FLD_TRAINING_BUDGET_COST_BATCH, entTrainingBudget.getTrainingBudgetCostBatch());
            pstTrainingBudget.setDouble(FLD_TRAINING_BUDGET_TOTAL, entTrainingBudget.getTrainingBudgetTotal());
            pstTrainingBudget.setLong(FLD_TRAINING_LOCATION_TYPE_ID, entTrainingBudget.getTrainingLocationTypeId());
            pstTrainingBudget.setLong(FLD_TRAINING_AREA_ID, entTrainingBudget.getTrainingAreaId());
            pstTrainingBudget.setString(FLD_TRAINING_BUDGET_DESC, entTrainingBudget.getTrainingBudgetDesc());
            pstTrainingBudget.insert();
            entTrainingBudget.setOID(pstTrainingBudget.getLong(FLD_TRAINING_BUDGET_ID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstTrainingBudget(0), DBException.UNKNOWN);
        }
        return entTrainingBudget.getOID();
    }

    public long insertExc(Entity entity) throws Exception {
        return insertExc((TrainingBudget) entity);
    }

    public static Vector list(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT * FROM " + TBL_TRAINING_BUDGET;
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
                TrainingBudget trainingBudget = new TrainingBudget();
                resultToObject(rs, trainingBudget);
                lists.add(trainingBudget);
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
    
    public static Vector listJoin(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT tb.* FROM "+TBL_TRAINING_BUDGET+" tb"
                            +" INNER JOIN "+PstTraining.TBL_HR_TRAINING+" tr"
                            +" ON"
                            +" tr.TRAINING_ID = tb.TRAINING_ID"
                            +" INNER JOIN "+PstTrainType.TBL_TRAIN_TYPE+" tt"
                            +" ON"
                            +" tr.TYPE = tt.TYPE_ID";
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
                TrainingBudget trainingBudget = new TrainingBudget();
                resultToObject(rs, trainingBudget);
                lists.add(trainingBudget);
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
    
    public static void resultToObject(ResultSet rs, TrainingBudget entTrainingBudget) {
        try {
            entTrainingBudget.setOID(rs.getLong(PstTrainingBudget.fieldNames[PstTrainingBudget.FLD_TRAINING_BUDGET_ID]));
            entTrainingBudget.setTrainingBudgetYear(rs.getString(PstTrainingBudget.fieldNames[PstTrainingBudget.FLD_TRAINING_BUDGET_YEAR]));
            entTrainingBudget.setTrainingId(rs.getLong(PstTrainingBudget.fieldNames[PstTrainingBudget.FLD_TRAINING_ID]));
            entTrainingBudget.setTrainingBudgetDuration(rs.getDouble(PstTrainingBudget.fieldNames[PstTrainingBudget.FLD_TRAINING_BUDGET_DURATION]));
            entTrainingBudget.setTrainingBudgetFrequency(rs.getDouble(PstTrainingBudget.fieldNames[PstTrainingBudget.FLD_TRAINING_BUDGET_FREQUENCY]));
            entTrainingBudget.setTrainingBudgetBatch(rs.getDouble(PstTrainingBudget.fieldNames[PstTrainingBudget.FLD_TRAINING_BUDGET_BATCH]));
            entTrainingBudget.setTrainingBudgetAmount(rs.getDouble(PstTrainingBudget.fieldNames[PstTrainingBudget.FLD_TRAINING_BUDGET_AMOUNT]));
            entTrainingBudget.setTrainingBudgetCostBatch(rs.getDouble(PstTrainingBudget.fieldNames[PstTrainingBudget.FLD_TRAINING_BUDGET_COST_BATCH]));
            entTrainingBudget.setTrainingBudgetTotal(rs.getDouble(PstTrainingBudget.fieldNames[PstTrainingBudget.FLD_TRAINING_BUDGET_TOTAL]));
            entTrainingBudget.setTrainingLocationTypeId(rs.getLong(PstTrainingBudget.fieldNames[PstTrainingBudget.FLD_TRAINING_LOCATION_TYPE_ID]));
            entTrainingBudget.setTrainingAreaId(rs.getLong(PstTrainingBudget.fieldNames[PstTrainingBudget.FLD_TRAINING_AREA_ID]));
            entTrainingBudget.setTrainingBudgetDesc(rs.getString(PstTrainingBudget.fieldNames[PstTrainingBudget.FLD_TRAINING_BUDGET_DESC]));
        } catch (Exception e) {
        }
    }
    public static int getCount(String whereClause) {
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT COUNT(" + PstTrainingBudget.fieldNames[PstTrainingBudget.FLD_TRAINING_BUDGET_ID] + ") FROM " + TBL_TRAINING_BUDGET;
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
    public static int findLimitStart(long oid, int recordToGet, String whereClause) {
        String order = "";
        int size = getCount(whereClause);
        int start = 0;
        boolean found = false;
        for (int i = 0; (i < size) && !found; i = i + recordToGet) {
            Vector list = list(i, recordToGet, whereClause, order);
            start = i;
            if (list.size() > 0) {
                for (int ls = 0; ls < list.size(); ls++) {
                    TrainingBudget trainingBudget = (TrainingBudget) list.get(ls);
                    if (oid == trainingBudget.getOID()) {
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
}

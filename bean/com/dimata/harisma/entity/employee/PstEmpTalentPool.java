/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.employee;

/**
 *
 * @author Dimata 007
 */
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

public class PstEmpTalentPool extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {

    public static final String TBL_EMP_TALENT_POOL = "hr_emp_talent_pool";
    public static final int FLD_EMP_TALENT_POOL_ID = 0;
    public static final int FLD_EMPLOYEE_ID = 1;
    public static final int FLD_DATE_TALENT = 2;
    public static final int FLD_STATUS_INFO = 3;
    public static final int FLD_MAIN_ID = 4;
    public static final int FLD_POSITION_TYPE_ID = 5;
    public static final int FLD_TOTAL_SCORE = 6;
    public static String[] fieldNames = {
        "EMP_TALENT_POOL_ID",
        "EMPLOYEE_ID",
        "DATE_TALENT",
        "STATUS_INFO",
        "MAIN_ID",
        "POSITION_TYPE_ID",
        "TOTAL_SCORE"
    };
    public static int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_DATE,
        TYPE_INT,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_FLOAT
    };
    public static String[] statusInfoValue = {
      "Need Develop", "Be Accepted"  
    };
    public static int NEED_DEVELOP = 0;
    public static int BE_ACCEPTED = 1;

    public PstEmpTalentPool() {
    }

    public PstEmpTalentPool(int i) throws DBException {
        super(new PstEmpTalentPool());
    }

    public PstEmpTalentPool(String sOid) throws DBException {
        super(new PstEmpTalentPool(0));
        if (!locate(sOid)) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public PstEmpTalentPool(long lOid) throws DBException {
        super(new PstEmpTalentPool(0));
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
        return TBL_EMP_TALENT_POOL;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new PstEmpTalentPool().getClass().getName();
    }

    public static EmpTalentPool fetchExc(long oid) throws DBException {
        try {
            EmpTalentPool entEmpTalentPool = new EmpTalentPool();
            PstEmpTalentPool pstEmpTalentPool = new PstEmpTalentPool(oid);
            entEmpTalentPool.setOID(oid);
            entEmpTalentPool.setEmployeeId(pstEmpTalentPool.getLong(FLD_EMPLOYEE_ID));
            entEmpTalentPool.setDateTalent(pstEmpTalentPool.getDate(FLD_DATE_TALENT));
            entEmpTalentPool.setStatusInfo(pstEmpTalentPool.getInt(FLD_STATUS_INFO));
            entEmpTalentPool.setMainId(pstEmpTalentPool.getlong(FLD_MAIN_ID));
            entEmpTalentPool.setPosType(pstEmpTalentPool.getlong(FLD_POSITION_TYPE_ID));
            entEmpTalentPool.setTotalScore(pstEmpTalentPool.getdouble(FLD_TOTAL_SCORE));
            return entEmpTalentPool;
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstEmpTalentPool(0), DBException.UNKNOWN);
        }
    }

    public long fetchExc(Entity entity) throws Exception {
        EmpTalentPool entEmpTalentPool = fetchExc(entity.getOID());
        entity = (Entity) entEmpTalentPool;
        return entEmpTalentPool.getOID();
    }

    public static synchronized long updateExc(EmpTalentPool entEmpTalentPool) throws DBException {
        try {
            if (entEmpTalentPool.getOID() != 0) {
                PstEmpTalentPool pstEmpTalentPool = new PstEmpTalentPool(entEmpTalentPool.getOID());
                pstEmpTalentPool.setLong(FLD_EMPLOYEE_ID, entEmpTalentPool.getEmployeeId());
                pstEmpTalentPool.setDate(FLD_DATE_TALENT, entEmpTalentPool.getDateTalent());
                pstEmpTalentPool.setInt(FLD_STATUS_INFO, entEmpTalentPool.getStatusInfo());
                pstEmpTalentPool.setLong(FLD_MAIN_ID, entEmpTalentPool.getMainId());
                pstEmpTalentPool.setLong(FLD_POSITION_TYPE_ID, entEmpTalentPool.getPosType());
                pstEmpTalentPool.setDouble(FLD_TOTAL_SCORE, entEmpTalentPool.getTotalScore());
                pstEmpTalentPool.update();
                return entEmpTalentPool.getOID();
            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstEmpTalentPool(0), DBException.UNKNOWN);
        }
        return 0;
    }

    public long updateExc(Entity entity) throws Exception {
        return updateExc((EmpTalentPool) entity);
    }

    public static synchronized long deleteExc(long oid) throws DBException {
        try {
            PstEmpTalentPool pstEmpTalentPool = new PstEmpTalentPool(oid);
            pstEmpTalentPool.delete();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstEmpTalentPool(0), DBException.UNKNOWN);
        }
        return oid;
    }

    public long deleteExc(Entity entity) throws Exception {
        if (entity == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(entity.getOID());
    }

    public static synchronized long insertExc(EmpTalentPool entEmpTalentPool) throws DBException {
        try {
            PstEmpTalentPool pstEmpTalentPool = new PstEmpTalentPool(0);
            pstEmpTalentPool.setLong(FLD_EMPLOYEE_ID, entEmpTalentPool.getEmployeeId());
            pstEmpTalentPool.setDate(FLD_DATE_TALENT, entEmpTalentPool.getDateTalent());
            pstEmpTalentPool.setInt(FLD_STATUS_INFO, entEmpTalentPool.getStatusInfo());
            pstEmpTalentPool.setLong(FLD_MAIN_ID, entEmpTalentPool.getMainId());
            pstEmpTalentPool.setLong(FLD_POSITION_TYPE_ID, entEmpTalentPool.getPosType());
            pstEmpTalentPool.setDouble(FLD_TOTAL_SCORE, entEmpTalentPool.getTotalScore());
            pstEmpTalentPool.insert();
            entEmpTalentPool.setOID(pstEmpTalentPool.getLong(FLD_EMP_TALENT_POOL_ID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstEmpTalentPool(0), DBException.UNKNOWN);
        }
        return entEmpTalentPool.getOID();
    }

    public long insertExc(Entity entity) throws Exception {
        return insertExc((EmpTalentPool) entity);
    }

    public static void resultToObject(ResultSet rs, EmpTalentPool entEmpTalentPool) {
        try {
            entEmpTalentPool.setOID(rs.getLong(PstEmpTalentPool.fieldNames[PstEmpTalentPool.FLD_EMP_TALENT_POOL_ID]));
            entEmpTalentPool.setEmployeeId(rs.getLong(PstEmpTalentPool.fieldNames[PstEmpTalentPool.FLD_EMPLOYEE_ID]));
            entEmpTalentPool.setDateTalent(rs.getDate(PstEmpTalentPool.fieldNames[PstEmpTalentPool.FLD_DATE_TALENT]));
            entEmpTalentPool.setStatusInfo(rs.getInt(PstEmpTalentPool.fieldNames[PstEmpTalentPool.FLD_STATUS_INFO]));
            entEmpTalentPool.setMainId(rs.getLong(PstEmpTalentPool.fieldNames[PstEmpTalentPool.FLD_MAIN_ID]));
            entEmpTalentPool.setPosType(rs.getLong(PstEmpTalentPool.fieldNames[PstEmpTalentPool.FLD_POSITION_TYPE_ID]));
            entEmpTalentPool.setTotalScore(rs.getLong(PstEmpTalentPool.fieldNames[PstEmpTalentPool.FLD_TOTAL_SCORE]));
        } catch (Exception e) {
        }
    }

    public static Vector list(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT * FROM " + TBL_EMP_TALENT_POOL;
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
                EmpTalentPool entEmpTalentPool = new EmpTalentPool();
                resultToObject(rs, entEmpTalentPool);
                lists.add(entEmpTalentPool);
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
            String sql = "SELECT * FROM " + TBL_EMP_TALENT_POOL + " AS talent ";
            sql += " INNER JOIN "+PstEmployee.TBL_HR_EMPLOYEE+" AS emp ON ";
            sql += "talent."+fieldNames[FLD_EMPLOYEE_ID]+"=emp."+PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID];
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
                Employee employee = new Employee();
                PstEmployee.resultToObject(rs, employee);
                lists.add(employee);
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
    
    public static Vector listJoinCandidate(long oidCandidateMain, long posTypeId, String whereEmployee) {
        
        String whereClause = "";
        String whereTraining = "";
        String wherePower = "";
        String whereEmp = "";
        
        
        /* Grade Level List */
        whereClause = PstCandidatePositionTraining.fieldNames[PstCandidatePositionTraining.FLD_CANDIDATE_MAIN_ID] + "=" + oidCandidateMain;
        Vector listTraining = PstCandidatePositionTraining.list(0, 0, whereClause, "");
        if (listTraining != null && listTraining.size() > 0) {
            for (int i = 0; i < listTraining.size(); i++) {
                CandidatePositionTraining train = (CandidatePositionTraining) listTraining.get(i);
                whereTraining = whereTraining + train.getTrainingId() + ",";
            }
            whereTraining = whereTraining.substring(0, whereTraining.length() - 1);
        }
        /* Power List */
        whereClause = PstCandidatePositionPower.fieldNames[PstCandidatePositionPower.FLD_CANDIDATE_MAIN_ID] + "=" + oidCandidateMain;
        Vector listPower = PstCandidatePositionPower.list(0, 0, whereClause, "");
        if (listPower != null && listPower.size() > 0) {
            for (int i = 0; i < listPower.size(); i++) {
                CandidatePositionPower power = (CandidatePositionPower) listPower.get(i);
                wherePower = wherePower + "("+PstEmpPowerCharacter.fieldNames[PstEmpPowerCharacter.FLD_POWER_CHARACTER_ID]+ " = "+power.getFirstPowerCharacterId()
                        + " AND "+PstEmpPowerCharacter.fieldNames[PstEmpPowerCharacter.FLD_SECOND_POWER_CHARACTER_ID]+ " = "+power.getSecondPowerCharacterId()+")";
                if (i < (listPower.size()-1)){
                    wherePower = wherePower + " OR ";
                }
            }
        }
        
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT talent.* FROM " + TBL_EMP_TALENT_POOL+" AS talent "
                    + "INNER JOIN hr_employee AS he ON he.EMPLOYEE_ID = talent.EMPLOYEE_ID "
                    + (whereTraining != null && whereTraining.length() > 0 ? " INNER JOIN hr_training_history AS th on th.EMPLOYEE_ID =  he.EMPLOYEE_ID " : "")
                    + (wherePower != null && wherePower.length() > 0 ? "INNER JOIN hr_emp_character_power AS pw on pw.EMPLOYEE_ID =  he.EMPLOYEE_ID " : "")
                    + " WHERE "
                    + (whereTraining != null && whereTraining.length() > 0 ? " th.TRAINING_ID IN (/* training */ " + whereTraining + ") " : " (1=1) ")
		    + (wherePower != null && wherePower.length() > 0 ? (" AND (" + wherePower + ") ") : " AND (1=1) ")
                    + (whereEmployee != null && whereEmployee.length() > 0 ? (" AND  talent.EMPLOYEE_ID  IN (" + whereEmployee + ") ") : " AND (1=1) ")
                    + " AND talent."+PstEmpTalentPool.fieldNames[PstEmpTalentPool.FLD_MAIN_ID]+"="+oidCandidateMain
                    + " AND talent."+PstEmpTalentPool.fieldNames[PstEmpTalentPool.FLD_POSITION_TYPE_ID]+"= "+posTypeId
                    + " GROUP BY he.`EMPLOYEE_ID` "
                    + " ORDER BY talent.`TOTAL_SCORE` DESC";
            
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                EmpTalentPool entEmpTalentPool = new EmpTalentPool();
                resultToObject(rs, entEmpTalentPool);
                lists.add(entEmpTalentPool);
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

}
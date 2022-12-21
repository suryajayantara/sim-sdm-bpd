/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.masterdata;

import com.dimata.harisma.entity.employee.Employee;
import com.dimata.harisma.entity.employee.PstEmployee;
import com.dimata.qdep.db.DBException;
import com.dimata.qdep.db.DBHandler;
import com.dimata.qdep.db.DBResultSet;
import com.dimata.qdep.db.I_DBInterface;
import com.dimata.qdep.db.I_DBType;
import com.dimata.qdep.entity.Entity;
import com.dimata.qdep.entity.I_DocStatus;
import com.dimata.qdep.entity.I_PersintentExc;
import com.dimata.system.entity.PstSystemProperty;
import com.dimata.util.DateCalc;
import com.dimata.util.Formater;
import com.dimata.util.lang.I_Language;
import java.sql.ResultSet;
import java.util.Date;
import java.util.Hashtable;
import java.util.Vector;

/**
 *
 * @author GUSWIK
 */
public class PstKPI_Employee_Achiev extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {

   public static final String TBL_HR_KPI_EMPLOYEE_ACHIEV = "hr_kpi_employee_achiev";
	public static final int FLD_KPI_EMPLOYEE_ACHIEV_ID = 0;
	public static final int FLD_KPI_LIST_ID = 1;
	public static final int FLD_STARTDATE = 2;
	public static final int FLD_ENDDATE = 3;
	public static final int FLD_EMPLOYEE_ID = 4;
	public static final int FLD_ENTRYDATE = 5;
	public static final int FLD_ACHIEVEMENT = 6;
	public static final int FLD_ACHIEV_DATE = 7;
	public static final int FLD_ACHIEV_PROOF = 8;
	public static final int FLD_ACHIEV_TYPE = 9;
	public static final int FLD_APPROVAL_1 = 10;
	public static final int FLD_APPROVAL_DATE_1 = 11;
	public static final int FLD_APPROVAL_2 = 12;
	public static final int FLD_APPROVAL_DATE_2 = 13;
	public static final int FLD_APPROVAL_3 = 14;
	public static final int FLD_APPROVAL_DATE_3 = 15;
	public static final int FLD_APPROVAL_4 = 16;
	public static final int FLD_APPROVAL_DATE_4 = 17;
	public static final int FLD_APPROVAL_5 = 18;
	public static final int FLD_APPROVAL_DATE_5 = 19;
	public static final int FLD_APPROVAL_6 = 20;
	public static final int FLD_APPROVAL_DATE_6 = 21;
	public static final int FLD_STATUS = 22;
	public static final int FLD_TARGET_ID = 23;
	public static final int FLD_ACHIEV_NOTE = 24;
   
    public static final String[] fieldNames = {
		"KPI_EMPLOYEE_ACHIEV_ID",
		"KPI_LIST_ID",
		"STARTDATE",
		"ENDDATE",
		"EMPLOYEE_ID",
		"ENTRYDATE",
		"ACHIEVEMENT",
		"ACHIEV_DATE",
		"ACHIEV_PROOF",
		"ACHIEV_TYPE",
		"APPROVAL_1",
		"APPROVAL_DATE_1",
		"APPROVAL_2",
		"APPROVAL_DATE_2",
		"APPROVAL_3",
		"APPROVAL_DATE_3",
		"APPROVAL_4",
		"APPROVAL_DATE_4",
		"APPROVAL_5",
		"APPROVAL_DATE_5",
		"APPROVAL_6",
		"APPROVAL_DATE_6",
		"STATUS",
		"TARGET_ID",
		"ACHIEV_NOTE"
	};
    public static final int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_LONG,
		TYPE_DATE,
		TYPE_DATE,
		TYPE_LONG,
		TYPE_DATE,
		TYPE_FLOAT,
		TYPE_DATE,
		TYPE_STRING,
		TYPE_INT,
		TYPE_LONG,
		TYPE_DATE,
		TYPE_LONG,
		TYPE_DATE,
		TYPE_LONG,
		TYPE_DATE,
		TYPE_LONG,
		TYPE_DATE,
		TYPE_LONG,
		TYPE_DATE,
		TYPE_LONG,
		TYPE_DATE,
		TYPE_INT,
		TYPE_LONG,
		TYPE_STRING
	};
	
	public static final int TYPE_DRAFT = 0;
        public static final int TYPE_IN_PROGRESS = 1;
	public static final int TYPE_FINISH = 2;
	
	public static final String[] typeAchiev = {
                "Draft",
		"In Progress",
		"Finish",
                "To Be Approve",
                "To Be Corrected"
	};

   public PstKPI_Employee_Achiev() {
   }

    public PstKPI_Employee_Achiev(int i) throws DBException {
        super(new PstKPI_Employee_Achiev());
    }

    public PstKPI_Employee_Achiev(String sOid) throws DBException {
        super(new PstKPI_Employee_Achiev(0));
        if (!locate(sOid)) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public PstKPI_Employee_Achiev(long lOid) throws DBException {
        super(new PstKPI_Employee_Achiev(0));
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
        return TBL_HR_KPI_EMPLOYEE_ACHIEV;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new PstKPI_Employee_Achiev().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        KPI_Employee_Achiev kPI_Employee_Achiev = fetchExc(ent.getOID());
        ent = (Entity) kPI_Employee_Achiev;
        return kPI_Employee_Achiev.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((KPI_Employee_Achiev) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((KPI_Employee_Achiev) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static KPI_Employee_Achiev fetchExc(long oid) throws DBException {
        try {
            KPI_Employee_Achiev kPI_Employee_Achiev = new KPI_Employee_Achiev();
            PstKPI_Employee_Achiev pstKPI_Employee_Achiev = new PstKPI_Employee_Achiev(oid);
            kPI_Employee_Achiev.setOID(oid);

			kPI_Employee_Achiev.setKpiListId(pstKPI_Employee_Achiev.getlong(FLD_KPI_LIST_ID));
			kPI_Employee_Achiev.setStartDate(pstKPI_Employee_Achiev.getDate(FLD_STARTDATE));
			kPI_Employee_Achiev.setEndDate(pstKPI_Employee_Achiev.getDate(FLD_ENDDATE));
			kPI_Employee_Achiev.setEmployeeId(pstKPI_Employee_Achiev.getlong(FLD_EMPLOYEE_ID));
			kPI_Employee_Achiev.setEntryDate(pstKPI_Employee_Achiev.getDate(FLD_ENTRYDATE));
			kPI_Employee_Achiev.setAchievement(pstKPI_Employee_Achiev.getdouble(FLD_ACHIEVEMENT));
			kPI_Employee_Achiev.setAchievDate(pstKPI_Employee_Achiev.getDate(FLD_ACHIEV_DATE));
			kPI_Employee_Achiev.setAchievProof(pstKPI_Employee_Achiev.getString(FLD_ACHIEV_PROOF));
			kPI_Employee_Achiev.setAchievType(pstKPI_Employee_Achiev.getInt(FLD_ACHIEV_TYPE));
			kPI_Employee_Achiev.setApproval1(pstKPI_Employee_Achiev.getLong(FLD_APPROVAL_1));
			kPI_Employee_Achiev.setApprovalDate1(pstKPI_Employee_Achiev.getDate(FLD_APPROVAL_DATE_1));
			kPI_Employee_Achiev.setApproval2(pstKPI_Employee_Achiev.getLong(FLD_APPROVAL_2));
			kPI_Employee_Achiev.setApprovalDate2(pstKPI_Employee_Achiev.getDate(FLD_APPROVAL_DATE_2));
			kPI_Employee_Achiev.setApproval3(pstKPI_Employee_Achiev.getLong(FLD_APPROVAL_3));
			kPI_Employee_Achiev.setApprovalDate3(pstKPI_Employee_Achiev.getDate(FLD_APPROVAL_DATE_3));
			kPI_Employee_Achiev.setApproval4(pstKPI_Employee_Achiev.getLong(FLD_APPROVAL_4));
			kPI_Employee_Achiev.setApprovalDate4(pstKPI_Employee_Achiev.getDate(FLD_APPROVAL_DATE_4));
			kPI_Employee_Achiev.setApproval5(pstKPI_Employee_Achiev.getLong(FLD_APPROVAL_5));
			kPI_Employee_Achiev.setApprovalDate5(pstKPI_Employee_Achiev.getDate(FLD_APPROVAL_DATE_5));
			kPI_Employee_Achiev.setApproval6(pstKPI_Employee_Achiev.getLong(FLD_APPROVAL_6));
			kPI_Employee_Achiev.setApprovalDate6(pstKPI_Employee_Achiev.getDate(FLD_APPROVAL_DATE_6));
			kPI_Employee_Achiev.setStatus(pstKPI_Employee_Achiev.getInt(FLD_STATUS));
			kPI_Employee_Achiev.setTargetId(pstKPI_Employee_Achiev.getlong(FLD_TARGET_ID));
			kPI_Employee_Achiev.setAchievNote(pstKPI_Employee_Achiev.getString(FLD_ACHIEV_NOTE));
			
         return kPI_Employee_Achiev;

        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstKPI_Employee_Achiev(0), DBException.UNKNOWN);
        }
    }

    public static long insertExc(KPI_Employee_Achiev kPI_Employee_Achiev) throws DBException {
        try {
            PstKPI_Employee_Achiev pstKPI_Employee_Achiev = new PstKPI_Employee_Achiev(0);

           // pstKPI_Employee_Achiev.setLong(FLD_KPI_EMPLOYEE_ACHIEV_ID, kPI_Employee_Achiev.getKpiListId());
            pstKPI_Employee_Achiev.setLong(FLD_KPI_LIST_ID, kPI_Employee_Achiev.getKpiListId());
			pstKPI_Employee_Achiev.setDate(FLD_STARTDATE, kPI_Employee_Achiev.getStartDate());
			pstKPI_Employee_Achiev.setDate(FLD_ENDDATE, kPI_Employee_Achiev.getEndDate());
			pstKPI_Employee_Achiev.setLong(FLD_EMPLOYEE_ID, kPI_Employee_Achiev.getEmployeeId());
			pstKPI_Employee_Achiev.setDate(FLD_ENTRYDATE, kPI_Employee_Achiev.getEntryDate());
			pstKPI_Employee_Achiev.setDouble(FLD_ACHIEVEMENT, kPI_Employee_Achiev.getAchievement());
			pstKPI_Employee_Achiev.setDate(FLD_ACHIEV_DATE, kPI_Employee_Achiev.getAchievDate());
			pstKPI_Employee_Achiev.setString(FLD_ACHIEV_PROOF, kPI_Employee_Achiev.getAchievProof());
			pstKPI_Employee_Achiev.setInt(FLD_ACHIEV_TYPE, kPI_Employee_Achiev.getAchievType());
			pstKPI_Employee_Achiev.setLong(FLD_APPROVAL_1, kPI_Employee_Achiev.getApproval1());
			pstKPI_Employee_Achiev.setDate(FLD_APPROVAL_DATE_1, kPI_Employee_Achiev.getApprovalDate1());
			pstKPI_Employee_Achiev.setLong(FLD_APPROVAL_2, kPI_Employee_Achiev.getApproval2());
			pstKPI_Employee_Achiev.setDate(FLD_APPROVAL_DATE_2, kPI_Employee_Achiev.getApprovalDate2());
			pstKPI_Employee_Achiev.setLong(FLD_APPROVAL_3, kPI_Employee_Achiev.getApproval3());
			pstKPI_Employee_Achiev.setDate(FLD_APPROVAL_DATE_3, kPI_Employee_Achiev.getApprovalDate3());
			pstKPI_Employee_Achiev.setLong(FLD_APPROVAL_4, kPI_Employee_Achiev.getApproval4());
			pstKPI_Employee_Achiev.setDate(FLD_APPROVAL_DATE_4, kPI_Employee_Achiev.getApprovalDate4());
			pstKPI_Employee_Achiev.setLong(FLD_APPROVAL_5, kPI_Employee_Achiev.getApproval5());
			pstKPI_Employee_Achiev.setDate(FLD_APPROVAL_DATE_5, kPI_Employee_Achiev.getApprovalDate5());
			pstKPI_Employee_Achiev.setLong(FLD_APPROVAL_6, kPI_Employee_Achiev.getApproval6());
			pstKPI_Employee_Achiev.setDate(FLD_APPROVAL_DATE_6, kPI_Employee_Achiev.getApprovalDate6());
			pstKPI_Employee_Achiev.setInt(FLD_STATUS, kPI_Employee_Achiev.getStatus());
			pstKPI_Employee_Achiev.setLong(FLD_TARGET_ID, kPI_Employee_Achiev.getTargetId());
			pstKPI_Employee_Achiev.setString(FLD_ACHIEV_NOTE, kPI_Employee_Achiev.getAchievNote());
			
          
            pstKPI_Employee_Achiev.insert();
            kPI_Employee_Achiev.setOID(pstKPI_Employee_Achiev.getlong(FLD_KPI_EMPLOYEE_ACHIEV_ID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstKPI_Employee_Achiev(0), DBException.UNKNOWN);
        }
        return kPI_Employee_Achiev.getOID();
    }

    public static long updateExc(KPI_Employee_Achiev kPI_Employee_Achiev) throws DBException {
        try {
            if (kPI_Employee_Achiev.getOID() != 0) {
                PstKPI_Employee_Achiev pstKPI_Employee_Achiev = new PstKPI_Employee_Achiev(kPI_Employee_Achiev.getOID());

            pstKPI_Employee_Achiev.setLong(FLD_KPI_LIST_ID, kPI_Employee_Achiev.getKpiListId());
            pstKPI_Employee_Achiev.setDate(FLD_STARTDATE, kPI_Employee_Achiev.getStartDate());
            pstKPI_Employee_Achiev.setDate(FLD_ENDDATE, kPI_Employee_Achiev.getEndDate());
            pstKPI_Employee_Achiev.setLong(FLD_EMPLOYEE_ID, kPI_Employee_Achiev.getEmployeeId());
            pstKPI_Employee_Achiev.setDate(FLD_ENTRYDATE, kPI_Employee_Achiev.getEntryDate());
            pstKPI_Employee_Achiev.setDouble(FLD_ACHIEVEMENT, kPI_Employee_Achiev.getAchievement());
			pstKPI_Employee_Achiev.setDate(FLD_ACHIEV_DATE, kPI_Employee_Achiev.getAchievDate());
			pstKPI_Employee_Achiev.setString(FLD_ACHIEV_PROOF, kPI_Employee_Achiev.getAchievProof());
			pstKPI_Employee_Achiev.setInt(FLD_ACHIEV_TYPE, kPI_Employee_Achiev.getAchievType());
			pstKPI_Employee_Achiev.setLong(FLD_APPROVAL_1, kPI_Employee_Achiev.getApproval1());
			pstKPI_Employee_Achiev.setDate(FLD_APPROVAL_DATE_1, kPI_Employee_Achiev.getApprovalDate1());
			pstKPI_Employee_Achiev.setLong(FLD_APPROVAL_2, kPI_Employee_Achiev.getApproval2());
			pstKPI_Employee_Achiev.setDate(FLD_APPROVAL_DATE_2, kPI_Employee_Achiev.getApprovalDate2());
			pstKPI_Employee_Achiev.setLong(FLD_APPROVAL_3, kPI_Employee_Achiev.getApproval3());
			pstKPI_Employee_Achiev.setDate(FLD_APPROVAL_DATE_3, kPI_Employee_Achiev.getApprovalDate3());
			pstKPI_Employee_Achiev.setLong(FLD_APPROVAL_4, kPI_Employee_Achiev.getApproval4());
			pstKPI_Employee_Achiev.setDate(FLD_APPROVAL_DATE_4, kPI_Employee_Achiev.getApprovalDate4());
			pstKPI_Employee_Achiev.setLong(FLD_APPROVAL_5, kPI_Employee_Achiev.getApproval5());
			pstKPI_Employee_Achiev.setDate(FLD_APPROVAL_DATE_5, kPI_Employee_Achiev.getApprovalDate5());
			pstKPI_Employee_Achiev.setLong(FLD_APPROVAL_6, kPI_Employee_Achiev.getApproval6());
			pstKPI_Employee_Achiev.setDate(FLD_APPROVAL_DATE_6, kPI_Employee_Achiev.getApprovalDate6());
			pstKPI_Employee_Achiev.setInt(FLD_STATUS, kPI_Employee_Achiev.getStatus());
			pstKPI_Employee_Achiev.setLong(FLD_TARGET_ID, kPI_Employee_Achiev.getTargetId());
			pstKPI_Employee_Achiev.setString(FLD_ACHIEV_NOTE, kPI_Employee_Achiev.getAchievNote());
            pstKPI_Employee_Achiev.update();

                return kPI_Employee_Achiev.getOID();

            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstKPI_Employee_Achiev(0), DBException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws DBException {
        try {
            PstKPI_Employee_Achiev pstKPI_Employee_Achiev = new PstKPI_Employee_Achiev(oid);
            pstKPI_Employee_Achiev.delete();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstKPI_Employee_Achiev(0), DBException.UNKNOWN);
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
            String sql = "SELECT * FROM " + TBL_HR_KPI_EMPLOYEE_ACHIEV;
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
                KPI_Employee_Achiev kPI_Employee_Achiev = new KPI_Employee_Achiev();
                resultToObject(rs, kPI_Employee_Achiev);
                lists.add(kPI_Employee_Achiev);
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
    
     public static double listAlldataAchCount(int tahun, long kpiListId, long CompanyId, long divisionId, long departmentId, long sectionId) {
           return listAlldataAchCount(tahun, kpiListId, CompanyId,  divisionId,  departmentId,  sectionId, 0);
       }
    
     public static double listAlldataAchCount(int tahun, long kpiListId, long CompanyId, long divisionId, long departmentId, long sectionId, long empId) {
        double value = 0; 
        DBResultSet dbrs = null;
 

        try {
            String sql = " SELECT SUM(KEA."+PstKPI_Employee_Achiev.fieldNames[PstKPI_Employee_Achiev.FLD_ACHIEVEMENT]+") FROM " + TBL_HR_KPI_EMPLOYEE_ACHIEV + 
                    " KEA INNER JOIN hr_employee HE ON KEA."+PstKPI_Employee_Achiev.fieldNames[PstKPI_Employee_Achiev.FLD_EMPLOYEE_ID]+" = HE."+PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID]+" "+
                    " WHERE KPI_LIST_ID = "+kpiListId+" AND KEA."
            
                    + PstKPI_Employee_Achiev.fieldNames[PstKPI_Employee_Achiev.FLD_STARTDATE] + " LIKE \"%" + tahun + "%\" AND KEA."
                    + PstKPI_Employee_Achiev.fieldNames[PstKPI_Employee_Achiev.FLD_ENDDATE] + " LIKE \"%" + tahun + "%\" AND HE."
                    + PstEmployee.fieldNames[PstEmployee.FLD_COMPANY_ID] + " = " + CompanyId + " ";
            if (divisionId > 0){
                sql = sql +" AND HE."+  PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID] + " = " + divisionId + " ";
            }
            if (departmentId > 0){
                sql = sql +" AND HE."+  PstEmployee.fieldNames[PstEmployee.FLD_DEPARTMENT_ID] + " = " + departmentId + " ";
            }
            if (sectionId > 0){
                sql = sql +" AND HE."+  PstEmployee.fieldNames[PstEmployee.FLD_SECTION_ID] + " = " + sectionId + " ";
            }
            if (empId > 0){
                sql = sql +" AND HE."+  PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID] + " = " + empId + " ";
            }
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
             
                value = rs.getInt(1);
              
            }
            rs.close();
            return value;

        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return 0;
    }
    
    
      public static void resultToObject(ResultSet rs, KPI_Employee_Achiev kPI_Employee_Achiev) {
        try {
            kPI_Employee_Achiev.setOID(rs.getLong(PstKPI_Employee_Achiev.fieldNames[PstKPI_Employee_Achiev.FLD_KPI_EMPLOYEE_ACHIEV_ID]));
            kPI_Employee_Achiev.setKpiListId(rs.getLong(PstKPI_Employee_Achiev.fieldNames[PstKPI_Employee_Achiev.FLD_KPI_LIST_ID]));
            kPI_Employee_Achiev.setStartDate(rs.getDate(PstKPI_Employee_Achiev.fieldNames[PstKPI_Employee_Achiev.FLD_STARTDATE]));
            kPI_Employee_Achiev.setEndDate(rs.getDate(PstKPI_Employee_Achiev.fieldNames[PstKPI_Employee_Achiev.FLD_ENDDATE]));
            kPI_Employee_Achiev.setEmployeeId(rs.getLong(PstKPI_Employee_Achiev.fieldNames[PstKPI_Employee_Achiev.FLD_EMPLOYEE_ID]));
            kPI_Employee_Achiev.setEntryDate(rs.getDate(PstKPI_Employee_Achiev.fieldNames[PstKPI_Employee_Achiev.FLD_ENTRYDATE]));
            kPI_Employee_Achiev.setAchievement(rs.getDouble(PstKPI_Employee_Achiev.fieldNames[PstKPI_Employee_Achiev.FLD_ACHIEVEMENT]));
			kPI_Employee_Achiev.setAchievDate(rs.getDate(PstKPI_Employee_Achiev.fieldNames[PstKPI_Employee_Achiev.FLD_ACHIEV_DATE]));
			kPI_Employee_Achiev.setAchievProof(rs.getString(PstKPI_Employee_Achiev.fieldNames[PstKPI_Employee_Achiev.FLD_ACHIEV_PROOF]));
			kPI_Employee_Achiev.setAchievType(rs.getInt(PstKPI_Employee_Achiev.fieldNames[PstKPI_Employee_Achiev.FLD_ACHIEV_TYPE]));
            kPI_Employee_Achiev.setApproval1(rs.getLong(PstKPI_Employee_Achiev.fieldNames[PstKPI_Employee_Achiev.FLD_APPROVAL_1]));
			kPI_Employee_Achiev.setApprovalDate1(rs.getDate(PstKPI_Employee_Achiev.fieldNames[PstKPI_Employee_Achiev.FLD_APPROVAL_DATE_1]));
			kPI_Employee_Achiev.setApproval2(rs.getLong(PstKPI_Employee_Achiev.fieldNames[PstKPI_Employee_Achiev.FLD_APPROVAL_2]));
			kPI_Employee_Achiev.setApprovalDate2(rs.getDate(PstKPI_Employee_Achiev.fieldNames[PstKPI_Employee_Achiev.FLD_APPROVAL_DATE_2]));
			kPI_Employee_Achiev.setApproval3(rs.getLong(PstKPI_Employee_Achiev.fieldNames[PstKPI_Employee_Achiev.FLD_APPROVAL_3]));
			kPI_Employee_Achiev.setApprovalDate3(rs.getDate(PstKPI_Employee_Achiev.fieldNames[PstKPI_Employee_Achiev.FLD_APPROVAL_DATE_3]));
			kPI_Employee_Achiev.setApproval4(rs.getLong(PstKPI_Employee_Achiev.fieldNames[PstKPI_Employee_Achiev.FLD_APPROVAL_4]));
			kPI_Employee_Achiev.setApprovalDate4(rs.getDate(PstKPI_Employee_Achiev.fieldNames[PstKPI_Employee_Achiev.FLD_APPROVAL_DATE_4]));
			kPI_Employee_Achiev.setApproval5(rs.getLong(PstKPI_Employee_Achiev.fieldNames[PstKPI_Employee_Achiev.FLD_APPROVAL_5]));
			kPI_Employee_Achiev.setApprovalDate5(rs.getDate(PstKPI_Employee_Achiev.fieldNames[PstKPI_Employee_Achiev.FLD_APPROVAL_DATE_5]));
			kPI_Employee_Achiev.setApproval6(rs.getLong(PstKPI_Employee_Achiev.fieldNames[PstKPI_Employee_Achiev.FLD_APPROVAL_6]));
			kPI_Employee_Achiev.setApprovalDate6(rs.getDate(PstKPI_Employee_Achiev.fieldNames[PstKPI_Employee_Achiev.FLD_APPROVAL_DATE_6]));
			kPI_Employee_Achiev.setStatus(rs.getInt(PstKPI_Employee_Achiev.fieldNames[PstKPI_Employee_Achiev.FLD_STATUS]));
			kPI_Employee_Achiev.setTargetId(rs.getLong(PstKPI_Employee_Achiev.fieldNames[PstKPI_Employee_Achiev.FLD_TARGET_ID]));
			kPI_Employee_Achiev.setAchievNote(rs.getString(PstKPI_Employee_Achiev.fieldNames[PstKPI_Employee_Achiev.FLD_ACHIEV_NOTE]));
        } catch (Exception e) {
        }
    }
    
    public static boolean checkOID(long kPI_Employee_AchievId) {
        DBResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + TBL_HR_KPI_EMPLOYEE_ACHIEV + " WHERE "
                    + PstKPI_Employee_Achiev.fieldNames[PstKPI_Employee_Achiev.FLD_KPI_EMPLOYEE_ACHIEV_ID] + " = " + kPI_Employee_AchievId;

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

    public static long deleteKpiEmployeAchiev(int year, long kpiListId, long companyId) {
        DBResultSet dbrs = null;
        long resulthasil =0;
        try {
            String sql = "DELETE  FROM " + TBL_HR_KPI_EMPLOYEE_ACHIEV + " WHERE "
                    + PstKPI_Employee_Target.fieldNames[PstKPI_Employee_Target.FLD_STARTDATE] + " LIKE \"%" + year + "%\" AND "
                    + PstKPI_Employee_Target.fieldNames[PstKPI_Employee_Target.FLD_ENDDATE] + " LIKE \"%" + year + "%\" AND "
                    + PstKPI_Employee_Target.fieldNames[PstKPI_Employee_Target.FLD_KPI_LIST_ID] + " = " + kpiListId + "";
             
            DBHandler.execSqlInsert(sql);
        } catch (Exception e) {
            System.out.println("err : " + e.toString());
            
        } finally {
            DBResultSet.close(dbrs);
            return resulthasil;
        }
    }
    
    public static int getCount(String whereClause) {
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT COUNT(" + PstKPI_Employee_Achiev.fieldNames[PstKPI_Employee_Achiev.FLD_KPI_EMPLOYEE_ACHIEV_ID] + ") FROM " + TBL_HR_KPI_EMPLOYEE_ACHIEV;
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
    
        public static double getTotalAchievEmployee(long employeeId, long kpiListId) {
        double nilai = 0;
        DBResultSet dbrs = null;
        try {
            String sql = " SELECT SUM(ket." + PstKPI_Employee_Achiev.fieldNames[PstKPI_Employee_Achiev.FLD_ACHIEVEMENT] + ") FROM  " + PstKPI_Employee_Achiev.TBL_HR_KPI_EMPLOYEE_ACHIEV +" ket ";
            sql =  sql + " WHERE ket." + PstKPI_Employee_Achiev.fieldNames[PstKPI_Employee_Achiev.FLD_EMPLOYEE_ID] + " = " + employeeId ; 
            sql =  sql + " AND ket." + PstKPI_Employee_Achiev.fieldNames[PstKPI_Employee_Achiev.FLD_KPI_LIST_ID] + " = " + kpiListId ; 
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
               nilai  = rs.getInt(1);
            }
            rs.close();
            return nilai;

        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return nilai;
    }

    public static Hashtable Hlist(int limitStart, int recordToGet, String whereClause, String order) {
        Hashtable hashListSec = new Hashtable();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT * FROM " + TBL_HR_KPI_EMPLOYEE_ACHIEV;
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
                KPI_Employee_Achiev kPI_Employee_Achiev = new KPI_Employee_Achiev();
                resultToObject(rs, kPI_Employee_Achiev);
                hashListSec.put(kPI_Employee_Achiev.getEmployeeId(), kPI_Employee_Achiev);  
            }
            rs.close();
            return hashListSec;

        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return new Hashtable();
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
                    KPI_Employee_Achiev kPI_Employee_Achiev = (KPI_Employee_Achiev) list.get(ls);
                    if (oid == kPI_Employee_Achiev.getOID()) {
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
	
	public static void updateFileName(String fileName,long idPages) {
        try {
            String sql = "UPDATE " + PstKPI_Employee_Achiev.TBL_HR_KPI_EMPLOYEE_ACHIEV+
            " SET " + PstKPI_Employee_Achiev.fieldNames[FLD_ACHIEV_PROOF] + " = '" + fileName +"'"+
            " WHERE " + PstKPI_Employee_Achiev.fieldNames[PstKPI_Employee_Achiev.FLD_KPI_EMPLOYEE_ACHIEV_ID] +
            " = " + idPages ;           
            int result = DBHandler.execUpdate(sql);
        } catch (Exception e) {
            System.out.println("\tExc updateFileName : " + e.toString());
        } finally {
            //System.out.println("\tFinal updatePresenceStatus");
        }
    }
	
	public static String getKPIFilter(long userLoggin, long divisionId){
        String str = "";
        Vector leaveAppList = listKpi("");
        Employee emp = new Employee();
        int maxApproval = 0;
        boolean needHrApproval = false;
        if (leaveAppList != null && leaveAppList.size()>0){
            for (int i=0; i<leaveAppList.size(); i++){
                String[] data = (String[])leaveAppList.get(i);
                
                try{
                    emp = PstEmployee.fetchExc(Long.valueOf(data[3]));
                } catch (Exception exc){
                    
                }
                
                Position pos = new Position();
                Level level = new Level();
                Level maxLevelObj = new Level();
                //Level level = new Level();
                
                try {
                    pos = PstPosition.fetchExc(emp.getPositionId());            
                } catch (Exception exc){

                }
                
                 try {
                     level = PstLevel.fetchExc(pos.getLevelId());
                 } catch (Exception e) {
                 }


                 try {
                     maxLevelObj = PstLevel.fetchExc(level.getMaxLevelApproval());
                 } catch (Exception e) {
                 }

                 maxApproval = maxLevelObj.getLevelPoint();
                 
                long oidEmp = 0;
                if (data[4].equals("0")
                & data[5].equals("0")
                & data[6].equals("0")
                & data[7].equals("0")
                & data[8].equals("0")
                & data[9].equals("0")){
                    oidEmp = Long.valueOf(data[3]);
                }
                if (!data[4].equals("0")
                & data[5].equals("0")
                & data[6].equals("0")
                & data[7].equals("0")
                & data[8].equals("0")
                & data[9].equals("0")){
                    oidEmp = Long.valueOf(data[4]);
                }
                if (!data[4].equals("0")
                & !data[5].equals("0")
                & data[6].equals("0")
                & data[7].equals("0")
                & data[8].equals("0")
                & data[9].equals("0")){
                    oidEmp = Long.valueOf(data[5]);
                }
                if (!data[4].equals("0")
                & !data[5].equals("0")
                & !data[6].equals("0")
                & data[7].equals("0")
                & data[8].equals("0")
                & data[9].equals("0")){
                    oidEmp = Long.valueOf(data[6]);
                }
                if (!data[4].equals("0")
                & !data[5].equals("0")
                & !data[6].equals("0")
                & !data[7].equals("0")
                & data[8].equals("0")
                & data[9].equals("0")){
                    oidEmp = Long.valueOf(data[7]);
                }
                if (!data[4].equals("0")
                & !data[5].equals("0")
                & !data[6].equals("0")
                & !data[7].equals("0")
                & !data[8].equals("0")
                & data[9].equals("0")){
                    oidEmp = Long.valueOf(data[8]);
                }
                String nilai = getKPIAchievIdByApproval(oidEmp, userLoggin, divisionId, data[0], maxApproval, needHrApproval, emp.getDivisionId());
                if (!nilai.equals("0") && !nilai.equals("")){ 
                    str = str + nilai + ",";
                }
            }
        }
        
        return str;
    }
	
	public static int getNotification(long userLoggin, long divisionId, String whereAdd){
        int count = 0;
        Vector leaveAppList = listKpi(whereAdd);
        Employee emp = new Employee();
        int maxApproval = 0;
        boolean needHrApproval = false;
        if (leaveAppList != null && leaveAppList.size()>0){
            for (int i=0; i<leaveAppList.size(); i++){
                String[] data = (String[])leaveAppList.get(i);
                
                try{
                    emp = PstEmployee.fetchExc(Long.valueOf(data[3]));
                } catch (Exception exc){
                    
                }
                
                //needHrApproval = PstLeaveApplication.checkNeedHrApproval(emp.getDivisionId());
                Position pos = new Position();
                Level level = new Level();
                Level maxLevelObj = new Level();
                //Level level = new Level();
                
                try {
                    pos = PstPosition.fetchExc(emp.getPositionId());            
                } catch (Exception exc){

                }
                
                 try {
                     level = PstLevel.fetchExc(pos.getLevelId());
                 } catch (Exception e) {
                 }


                 try {
                     maxLevelObj = PstLevel.fetchExc(level.getMaxLevelApproval());
                 } catch (Exception e) {
                 }

                 maxApproval = maxLevelObj.getLevelPoint();
                 

                long oidEmp = 0;
                if (data[4].equals("0")
                & data[5].equals("0")
                & data[6].equals("0")
                & data[7].equals("0")
                & data[8].equals("0")
                & data[9].equals("0")){
                    oidEmp = Long.valueOf(data[3]);
                }
                if (!data[4].equals("0")
                & data[5].equals("0")
                & data[6].equals("0")
                & data[7].equals("0")
                & data[8].equals("0")
                & data[9].equals("0")){
                    oidEmp = Long.valueOf(data[4]);
                }
                if (!data[4].equals("0")
                & !data[5].equals("0")
                & data[6].equals("0")
                & data[7].equals("0")
                & data[8].equals("0")
                & data[9].equals("0")){
                    oidEmp = Long.valueOf(data[5]);
                }
                if (!data[4].equals("0")
                & !data[5].equals("0")
                & !data[6].equals("0")
                & data[7].equals("0")
                & data[8].equals("0")
                & data[9].equals("0")){
                    oidEmp = Long.valueOf(data[6]);
                }
                if (!data[4].equals("0")
                & !data[5].equals("0")
                & !data[6].equals("0")
                & !data[7].equals("0")
                & data[8].equals("0")
                & data[9].equals("0")){
                    oidEmp = Long.valueOf(data[7]);
                }
                if (!data[4].equals("0")
                & !data[5].equals("0")
                & !data[6].equals("0")
                & !data[7].equals("0")
                & !data[8].equals("0")
                & data[9].equals("0")){
                    oidEmp = Long.valueOf(data[8]);
                }
                count = count + getApproval(oidEmp, userLoggin, divisionId, maxApproval, needHrApproval, emp.getDivisionId());
            }
        }
        
        return count;
    }
	
	public static int getApproval(long empId, long userLoggin, long divisionId, int maxApproval, boolean needHrApproval, long empDivisionId){
        int nilai = 0;
        Vector listEmployeeDivisionTopLink = new Vector();
        long oidDireksi = 0;
        long oidKomisaris = 0;
        long hr_department = Long.parseLong(PstSystemProperty.getValueByName("OID_HRD_DEPARTMENT"));      
        try {
            oidDireksi = Long.parseLong(com.dimata.system.entity.PstSystemProperty.getValueByName("OID_DIREKSI"));
           
        } catch (Exception exc){
            oidDireksi = 0;
        }
        try {
            oidKomisaris = Long.parseLong(com.dimata.system.entity.PstSystemProperty.getValueByName("OID_KOMISARIS"));

        } catch (Exception exc){
                oidKomisaris = 0;
        }
        
        if (empId != 0){
            Employee employee =  new Employee();
            try {
                employee = PstEmployee.fetchExc(empId);
            } catch (Exception exc){}
            
            int lvlEmp = getLevelPoint(employee.getPositionId());
            
            if(lvlEmp < maxApproval){
            
                String posId = getPositionIdByEmpId(empId);
                String upPosId = getUpPositionId(posId,empDivisionId);
                String upPosByDivisionId = getUpPositionByDivisionId(posId, empDivisionId);
                long employeeId = getEmpIdByPositionId(upPosId, employee.getDivisionId());
                if (!upPosByDivisionId.equals("")){
                    listEmployeeDivisionTopLink      = PstEmployee.listEmployeeApprovalTopLink(0, 0, " (POSITION_ID IN ("+upPosId+")  AND `DEPARTMENT_ID` = "+employee.getDepartmentId()+") OR POSITION_ID IN ("+upPosByDivisionId+")" , "", 0,0, 0);
                    if (listEmployeeDivisionTopLink == null || listEmployeeDivisionTopLink.size() == 0){
                        listEmployeeDivisionTopLink      = PstEmployee.listEmployeeApprovalTopLink(0, 0, " (POSITION_ID IN ("+upPosId+")  AND `DIVISION_ID` IN ('"+employee.getDivisionId()+"','"+oidDireksi+"','"+oidKomisaris+"')) OR POSITION_ID IN ("+upPosByDivisionId+")" , "", 0,0, 0);                
                     }
                }
                else if (!(upPosId.equals(""))){
                    listEmployeeDivisionTopLink      = PstEmployee.listEmployeeApprovalTopLink(0, 0, " POSITION_ID IN ("+upPosId+")  AND `DEPARTMENT_ID` = "+employee.getDepartmentId() , "", 0,0, 0);
                    if (listEmployeeDivisionTopLink == null || listEmployeeDivisionTopLink.size() == 0){
                        listEmployeeDivisionTopLink      = PstEmployee.listEmployeeApprovalTopLink(0, 0, " POSITION_ID IN ("+upPosId+")  AND `DIVISION_ID` IN ('"+employee.getDivisionId()+"','"+oidDireksi+"','"+oidKomisaris+"')" , "", 0,0, 0);                
                     }
                }
                if (listEmployeeDivisionTopLink.size() > 0){
                    for (int i=0; i < listEmployeeDivisionTopLink.size(); i++){
                        Employee emp = (Employee) listEmployeeDivisionTopLink.get(i);
                        
                        if (emp.getOID() != userLoggin){
                            //getApproval(employeeId, loop, leaveAppId, userLoggin);
                            nilai = 0;
                        } else{
                            /* Jika employeeId == useLoggin */
                            nilai = 1;
                            break;
                        }
                    }

                }
            }
        }
        
        return nilai;
    }
	
	public static String getKPIAchievIdByApproval(long empId, long userLoggin, long divisionId, String leaveId, int maxApproval, boolean needHrApproval, long empDivisionId){
        String nilai = "";
        Vector listEmployeeDivisionTopLink = new Vector();
        long oidDireksi = 0;
        long oidKomisaris = 0;
        long hr_department = Long.parseLong(PstSystemProperty.getValueByName("OID_HRD_DEPARTMENT"));   
        try {
            oidDireksi = Long.parseLong(com.dimata.system.entity.PstSystemProperty.getValueByName("OID_DIREKSI"));
           
        } catch (Exception exc){
            oidDireksi = 0;
        }
        try {
            oidKomisaris = Long.parseLong(com.dimata.system.entity.PstSystemProperty.getValueByName("OID_KOMISARIS"));
   
        } catch (Exception exc){
                oidKomisaris = 0;
        }
        
        if (empId != 0){
            Employee employee =  new Employee();
            try {
                employee = PstEmployee.fetchExc(empId);
            } catch (Exception exc){}
            
            int lvlEmp = getLevelPoint(employee.getPositionId());
            
            if(lvlEmp < maxApproval){
                String posId = getPositionIdByEmpId(empId);
                String upPosId = getUpPositionId(posId,empDivisionId);
                String upPosByDivisionId = getUpPositionByDivisionId(posId, empDivisionId);
                long employeeId = getEmpIdByPositionId(upPosId, employee.getDivisionId());
                if (!upPosByDivisionId.equals("")){
                    listEmployeeDivisionTopLink      = PstEmployee.listEmployeeApprovalTopLink(0, 0, " (POSITION_ID IN ("+upPosId+")  AND `DEPARTMENT_ID` = "+employee.getDepartmentId()+") OR POSITION_ID IN ("+upPosByDivisionId+")" , "", 0,0, 0);
                    if (listEmployeeDivisionTopLink == null || listEmployeeDivisionTopLink.size() == 0){
                        listEmployeeDivisionTopLink      = PstEmployee.listEmployeeApprovalTopLink(0, 0, " (POSITION_ID IN ("+upPosId+")  AND `DIVISION_ID` IN ('"+employee.getDivisionId()+"','"+oidDireksi+"','"+oidKomisaris+"')) OR POSITION_ID IN ("+upPosByDivisionId+")" , "", 0,0, 0);                
                     }
                }
                else if (!(upPosId.equals(""))){
                    listEmployeeDivisionTopLink      = PstEmployee.listEmployeeApprovalTopLink(0, 0, " POSITION_ID IN ("+upPosId+")  AND `DEPARTMENT_ID` = "+employee.getDepartmentId() , "", 0,0, 0);
                    if (listEmployeeDivisionTopLink == null || listEmployeeDivisionTopLink.size() == 0){
                        listEmployeeDivisionTopLink      = PstEmployee.listEmployeeApprovalTopLink(0, 0, " POSITION_ID IN ("+upPosId+")  AND `DIVISION_ID` IN ('"+employee.getDivisionId()+"','"+oidDireksi+"','"+oidKomisaris+"')" , "", 0,0, 0);                
                     }
                }
                if (listEmployeeDivisionTopLink.size() > 0){
                    for (int i =0; i < listEmployeeDivisionTopLink.size(); i++){
                        Employee emp = (Employee) listEmployeeDivisionTopLink.get(i);
                        if (emp.getOID() != userLoggin){
                            //getApproval(employeeId, loop, leaveAppId, userLoggin);
                            nilai = "0";
                        } else {
                            /* Jika employeeId == useLoggin */
                            nilai = leaveId;
                            break;
                        }
                    }
                }
            }
        }
        
        return nilai;
    }
	
	public static Vector listKpi(String whereAdd) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT hr_kpi_employee_achiev.KPI_EMPLOYEE_ACHIEV_ID, " +
            "hr_employee.EMPLOYEE_NUM, " +
            "hr_employee.FULL_NAME, " +
            "hr_kpi_employee_achiev.ACHIEVEMENT, "+
			"hr_kpi_employee_achiev.ACHIEV_DATE, "+
			"hr_kpi_employee_achiev.ENTRYDATE, "+
			"hr_kpi_employee_achiev.ACHIEV_PROOF, "+
			"hr_kpi_employee_achiev.KPI_LIST_ID, "+
            "hr_employee.EMPLOYEE_ID, " +
            "hr_kpi_employee_achiev.APPROVAL_1, "+
            "hr_kpi_employee_achiev.APPROVAL_2, "+
            "hr_kpi_employee_achiev.APPROVAL_3, "+
            "hr_kpi_employee_achiev.APPROVAL_4, "+
            "hr_kpi_employee_achiev.APPROVAL_5, "+
            "hr_kpi_employee_achiev.APPROVAL_6 "+
            "FROM " + TBL_HR_KPI_EMPLOYEE_ACHIEV + " "+
            "INNER JOIN hr_employee ON hr_employee.EMPLOYEE_ID=hr_kpi_employee_achiev.EMPLOYEE_ID "+
            "WHERE hr_kpi_employee_achiev.STATUS IN ("+I_DocStatus.DOCUMENT_STATUS_DRAFT+", "+I_DocStatus.DOCUMENT_STATUS_TO_BE_APPROVED+")";
            if (whereAdd.length()>0){
                sql += " AND "+whereAdd+" ";
            }
            sql += "ORDER BY hr_kpi_employee_achiev.ENTRYDATE DESC";

            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                String [] data = new String[15];
                data[0] = ""+rs.getLong(PstKPI_Employee_Achiev.fieldNames[PstKPI_Employee_Achiev.FLD_KPI_EMPLOYEE_ACHIEV_ID]);
                data[1] = ""+rs.getString("FULL_NAME");
                data[2] = ""+rs.getString("ENTRYDATE");
                data[3] = ""+rs.getString("EMPLOYEE_ID");
				data[10] = ""+rs.getString("EMPLOYEE_NUM");
				data[11] = ""+rs.getString("ACHIEVEMENT");
				data[12] = ""+rs.getString("ACHIEV_DATE");
				data[13] = ""+rs.getString("ACHIEV_PROOF");
				data[14] = ""+rs.getString("KPI_LIST_ID");

                data[4] = ""+rs.getString("APPROVAL_1");
                data[5] = ""+rs.getString("APPROVAL_2");
                data[6] = ""+rs.getString("APPROVAL_3");
                data[7] = ""+rs.getString("APPROVAL_4");
                data[8] = ""+rs.getString("APPROVAL_5");
                data[9] = ""+rs.getString("APPROVAL_6");
                
                lists.add(data);
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
	
	public static String getPositionIdByEmpId(long employeeId) {
        String positionId = "";
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT hr_employee.POSITION_ID, hr_employee.DIVISION_ID FROM hr_employee ";
            sql += " WHERE hr_employee.EMPLOYEE_ID="+employeeId;
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                positionId = rs.getString(PstEmployee.fieldNames[PstEmployee.FLD_POSITION_ID]);
                //divisionId = rs.getLong(PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID]);
            }
            rs.close();
            return positionId;
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return positionId;
    }

    public static String getUpPositionId(String positionId, long divisionId) {
        String upPositionId = "";
        DBResultSet dbrs = null;
        java.util.Date dtNow = new java.util.Date();
        try {
            String sql = "SELECT * FROM hr_mapping_position ";
            sql += " WHERE hr_mapping_position.TYPE_OF_LINK=13 AND ";
            sql += " hr_mapping_position.DOWN_POSITION_ID IN ("+positionId+") AND '"+Formater.formatDate(dtNow, "yyyy-MM-dd")+"'"
 +                 " BETWEEN START_DATE AND END_DATE "
                    + " AND (DIVISION_ID =0 OR DIVISION_ID="+divisionId+")";
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                upPositionId = upPositionId + "," + rs.getLong(PstMappingPosition.fieldNames[PstMappingPosition.FLD_UP_POSITION_ID]);
            }
            rs.close();
            if (!(upPositionId.equals(""))){
                upPositionId = upPositionId.substring(1);
            }
            return upPositionId;
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return upPositionId;
    }
    
    public static String getUpPositionByDivisionId(String positionId, long divisionId) {
        String upPositionId = "";
        DBResultSet dbrs = null;
        java.util.Date dtNow = new java.util.Date();
        try {
            String sql = "SELECT * FROM hr_mapping_position ";
            sql += " WHERE hr_mapping_position.TYPE_OF_LINK=13 AND ";
            sql += " hr_mapping_position.DOWN_POSITION_ID IN ("+positionId+") AND '"+Formater.formatDate(dtNow, "yyyy-MM-dd")+"'"
                    + " BETWEEN START_DATE AND END_DATE "
                    + " AND DIVISION_ID="+divisionId+"";
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                upPositionId = upPositionId + "," + rs.getLong(PstMappingPosition.fieldNames[PstMappingPosition.FLD_UP_POSITION_ID]);
            }
            rs.close();
            if (!(upPositionId.equals(""))){
                upPositionId = upPositionId.substring(1);
            }
            return upPositionId;
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return upPositionId;
    }
	
	public static long getEmpIdByPositionId(String positionId, long divisionId) {
        DBResultSet dbrs = null;
        long empId = 0;
        long empTemp = 0;
        try {
            String sql = "SELECT hr_position.POSITION_ID, hr_position.POSITION, ";
            sql += " hr_employee.EMPLOYEE_ID, hr_employee.FULL_NAME, hr_employee.DIVISION_ID ";
            sql += " FROM hr_position ";
            sql += " INNER JOIN hr_employee ON hr_employee.POSITION_ID=hr_position.POSITION_ID ";
            sql += " WHERE hr_position.POSITION_ID IN ("+positionId+")";
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                if (rs.getLong(PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID])==divisionId){
                    empId = rs.getLong(PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID]);
                } else {
                    empTemp = rs.getLong(PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID]);
                }
            }
            if (empId == 0 && empTemp != 0){
                empId = empTemp;
            }
            rs.close();
            
            return empId;
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return empId;
    }
    
	public static int getLevelPoint(long positionId){
    int levelPoint = 0;

        Position pos = new Position();
        try{
            pos = PstPosition.fetchExc(positionId);
        } catch (Exception exc){

        }

        Level level = new Level();
        try {
           level = PstLevel.fetchExc(pos.getLevelId());
           levelPoint = level.getLevelPoint();
        } catch (Exception e) {
        }

       return levelPoint;
    }
	
	public static Vector listJoinKpi(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT ACV.* FROM " + TBL_HR_KPI_EMPLOYEE_ACHIEV+" AS ACV "
					+ " INNER JOIN hr_kpi_list AS KPI "
					+ " ON ACV.KPI_LIST_ID = KPI.KPI_LIST_ID ";
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
                KPI_Employee_Achiev kPI_Employee_Achiev = new KPI_Employee_Achiev();
                resultToObject(rs, kPI_Employee_Achiev);
                lists.add(kPI_Employee_Achiev);
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
	
	public static double getTotalParentScore(long kpiId, Date dtFrom, Date dtTo){
		
		double score = 0.0;
		
		String whereAcv = "KPI."+PstKPI_List.fieldNames[PstKPI_List.FLD_PARENT_ID]+"="+kpiId
					+" AND ACV."+PstKPI_Employee_Achiev.fieldNames[PstKPI_Employee_Target.FLD_ACHIEV_DATE]
					+" BETWEEN '"+dtFrom+"' AND '"+dtTo+"'"
					+ " AND ACV."+PstKPI_Employee_Achiev.fieldNames[PstKPI_Employee_Achiev.FLD_ACHIEV_TYPE]+"="+PstKPI_Employee_Achiev.TYPE_FINISH
					+ " AND ACV."+PstKPI_Employee_Achiev.fieldNames[PstKPI_Employee_Achiev.FLD_STATUS]+"=2";
		Vector listAcv = PstKPI_Employee_Achiev.listJoinKpi(0, 0, whereAcv, "");
		if (listAcv.size()>0){
			for (int i=0; i < listAcv.size(); i++){
				KPI_Employee_Achiev achiev = (KPI_Employee_Achiev) listAcv.get(i);
				score = score + getScore(achiev.getOID());
			}
			score = score / (double) listAcv.size();
		}
		
		
		return score;
		
	}
	
	public static double getTotalScore(long kpiId, Date dtFrom, Date dtTo){
		
		double score = 0.0;
		
		String whereAcv = "KPI."+PstKPI_List.fieldNames[PstKPI_List.FLD_KPI_LIST_ID]+"="+kpiId
					+" AND ACV."+PstKPI_Employee_Achiev.fieldNames[PstKPI_Employee_Target.FLD_ACHIEV_DATE]
					+" BETWEEN '"+dtFrom+"' AND '"+dtTo+"'"
					+ " AND ACV."+PstKPI_Employee_Achiev.fieldNames[PstKPI_Employee_Achiev.FLD_ACHIEV_TYPE]+"="+PstKPI_Employee_Achiev.TYPE_FINISH
					+ " AND ACV."+PstKPI_Employee_Achiev.fieldNames[PstKPI_Employee_Achiev.FLD_STATUS]+"=2";
		Vector listAcv = PstKPI_Employee_Achiev.listJoinKpi(0, 0, whereAcv, "");
		if (listAcv.size()>0){
			for (int i=0; i < listAcv.size(); i++){
				KPI_Employee_Achiev achiev = (KPI_Employee_Achiev) listAcv.get(i);
				score = score + getScore(achiev.getOID());
			}
			score = score / (double) listAcv.size();
		}
		
		
		return score;
		
	}

	public static double getScore(long kpiAchievId){
		
		double score = 0.0;
		
		KPI_Employee_Achiev kpiAchiev = new KPI_Employee_Achiev();
		try {
			kpiAchiev = PstKPI_Employee_Achiev.fetchExc(kpiAchievId);
			KPI_List kpi = PstKPI_List.fetchExc(kpiAchiev.getKpiListId());
			KPI_Employee_Target kpitarget = PstKPI_Employee_Target.fetchExc(kpiAchiev.getTargetId());
			
			double achiev = 0.0;
			double target = 0.0;
			
			switch(kpi.getInputType()){
				case PstKPI_List.TYPE_WAKTU:
					achiev = (double) DateCalc.dayDifference(kpitarget.getStartDate(), kpiAchiev.getAchievDate());
					target = (double) DateCalc.dayDifference(kpitarget.getStartDate(), kpitarget.getEndDate());
				break;
				case PstKPI_List.TYPE_JUMLAH:
					achiev = kpiAchiev.getAchievement();
					target = kpitarget.getTarget();
				break;
				case PstKPI_List.TYPE_PERSENTASE:
					achiev = kpiAchiev.getAchievement();
					target = kpitarget.getTarget();
				break;
			}
			
			if (kpi.getKorelasi() == PstKPI_List.KORELASI_NEGATIF){
				score = (1 - ((achiev - target) / target)) * 100;
			} else {
				score = (1 + ((achiev - target) / target)) * 100;
			}
			
			
		} catch (Exception exc){}
		
		return Math.round((score));
	}
  
}

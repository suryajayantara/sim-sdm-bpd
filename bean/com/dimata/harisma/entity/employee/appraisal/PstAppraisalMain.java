
/* Created on 	:  [date] [time] AM/PM 
 * 
 * @author	 :
 * @version	 :
 */

/*******************************************************************
 * Class Description 	: [project description ... ] 
 * Imput Parameters 	: [input parameter ...] 
 * Output 		: [output ...] 
 *******************************************************************/

package com.dimata.harisma.entity.employee.appraisal; 

/* package java */ 
import com.dimata.harisma.entity.employee.*;
import com.dimata.harisma.entity.leave.I_Leave;
import com.dimata.harisma.entity.leave.LeaveApplication;
import com.dimata.harisma.entity.masterdata.Level;
import com.dimata.harisma.entity.masterdata.PstLevel;
import com.dimata.harisma.form.employee.appraisal.FrmAppraisalMain;
import com.dimata.qdep.db.DBException;
import com.dimata.qdep.db.DBHandler;
import com.dimata.qdep.db.DBResultSet;
import com.dimata.qdep.db.I_DBInterface;
import com.dimata.qdep.db.I_DBType;
import com.dimata.qdep.entity.Entity;
import com.dimata.qdep.entity.I_PersintentExc;
import com.dimata.util.Command;
import java.sql.ResultSet;
import java.util.Vector;

;import java.util.Date;

/* package qdep */
import com.dimata.util.lang.I_Language;


public class PstAppraisalMain extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language { 

	public static final  String TBL_HR_APPRAISAL_MAIN = "hr_app_main";//

	public static final  int FLD_APP_MAIN_ID        = 0;
	public static final  int FLD_EMPLOYEE_ID        = 1;
	public static final  int FLD_EMP_POSITION_ID    = 2;
	public static final  int FLD_EMP_DEPARTMENT_ID  = 3;
	public static final  int FLD_EMP_LEVEL_ID       = 4;
	public static final  int FLD_ASSESSOR_ID        = 5;
	public static final  int FLD_ASS_POSITION_ID    = 6;
	public static final  int FLD_DATE_ASS_POSITION  = 7;
	public static final  int FLD_DATE_OF_ASS        = 8;
	public static final  int FLD_DATE_OF_LAST_ASS   = 9;
	public static final  int FLD_DATE_OF_NEXT_ASS   = 10;
	public static final  int FLD_DATE_JOINED_HOTEL  = 11;
	public static final  int FLD_TOTAL_ASSESSMENT   = 12;
	public static final  int FLD_TOTAL_SCORE        = 13;
	public static final  int FLD_SCORE_AVERAGE      = 14;
	public static final  int FLD_DIVISION_HEAD_ID   = 15;
	public static final  int FLD_EMP_SIGN_DATE      = 16;
	public static final  int FLD_ASS_SIGN_DATE      = 17;
	public static final  int FLD_DIV_HEAD_SIGN_DATE = 18;
        
        public static final int FLD_APPROVAL_1_ID       = 19;
        public static final int FLD_TIME_APPROVAL_1     = 20;
        public static final int FLD_APPROVAL_2_ID       = 21;
        public static final int FLD_TIME_APPROVAL_2     = 22;
        public static final int FLD_APPROVAL_3_ID       = 23;
        public static final int FLD_TIME_APPROVAL_3     = 24;
        public static final int FLD_APPROVAL_4_ID       = 25;
        public static final int FLD_TIME_APPROVAL_4     = 26;
        public static final int FLD_APPROVAL_5_ID       = 27;
        public static final int FLD_TIME_APPROVAL_5     = 28;
        public static final int FLD_APPROVAL_6_ID       = 29;
        public static final int FLD_TIME_APPROVAL_6     = 30;
        
        public static final int FLD_DATA_PERIOD_FROM    = 31;
        public static final int FLD_DATA_PERIOD_TO      = 32;
        
        public static final int FLD_ASS_FORM_MAIN_ID      = 33;
        
	public static final  String[] fieldNames = {
		"HR_APP_MAIN_ID",
		"EMPLOYEE_ID",
		"EMP_POSITION_ID",
		"EMP_DEPARTMENT_ID",
		"LEVEL_ID",
		"ASSESSOR_ID",
		"ASS_POSITION_ID",
		"DATE_ASSUMED_POSITION",
		"DATE_OF_ASSESSMENT",
		"DATE_OF_LAST_ASSESSMENT",
		"DATE_OF_NEXT_ASSESSMENT",
		"DATE_JOINED_HOTEL",
		"TOTAL_ASS",
		"TOTAL_SCORE",
		"SCORE_AVERAGE",
		"DIVISION_HEAD",
		"EMP_SIGN_DATE",
		"ASS_SIGN_DATE",
		"DIV_SIGN_DATE",
                "APPROVAL_1_ID",
                "TIME_APPROVAL_1",
                "APPROVAL_2_ID",
                "TIME_APPROVAL_2",
                "APPROVAL_3_ID",
                "TIME_APPROVAL_3",
                "APPROVAL_4_ID",
                "TIME_APPROVAL_4",
                "APPROVAL_5_ID",
                "TIME_APPROVAL_5",
                "APPROVAL_6_ID",
                "TIME_APPROVAL_6",
                "DATA_PERIOD_FROM",
                "DATA_PERIOD_TO",
                "ASS_FORM_MAIN_ID"
	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_DATE,
		TYPE_DATE,
		TYPE_DATE,
		TYPE_DATE,
		TYPE_DATE,
		TYPE_INT,
		TYPE_FLOAT,
		TYPE_FLOAT,
		TYPE_LONG,
		TYPE_DATE,
		TYPE_DATE,
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
                TYPE_LONG,
                TYPE_DATE,
                TYPE_DATE,
                TYPE_DATE,
                TYPE_LONG
	 }; 

	public PstAppraisalMain(){
	}

	public PstAppraisalMain(int i) throws DBException { 
		super(new PstAppraisalMain()); 
	}

	public PstAppraisalMain(String sOid) throws DBException { 
		super(new PstAppraisalMain(0)); 
		if(!locate(sOid)) 
			throw new DBException(this,DBException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public PstAppraisalMain(long lOid) throws DBException { 
		super(new PstAppraisalMain(0)); 
		String sOid = "0"; 
		try { 
			sOid = String.valueOf(lOid); 
		}catch(Exception e) { 
			throw new DBException(this,DBException.RECORD_NOT_FOUND); 
		} 
		if(!locate(sOid)) 
			throw new DBException(this,DBException.RECORD_NOT_FOUND); 
		else 
			return; 
	} 

	public int getFieldSize(){ 
		return fieldNames.length; 
	}

	public String getTableName(){ 
		return TBL_HR_APPRAISAL_MAIN;
	}

	public String[] getFieldNames(){ 
		return fieldNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new PstAppraisalMain().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		AppraisalMain appraisalMain = fetchExc(ent.getOID()); 
		ent = (Entity)appraisalMain; 
		return appraisalMain.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((AppraisalMain) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((AppraisalMain) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new DBException(this,DBException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static AppraisalMain fetchExc(long oid) throws DBException{ 
		try{ 
			AppraisalMain appraisalMain = new AppraisalMain();
			PstAppraisalMain pstAppraisalMain = new PstAppraisalMain(oid); 
			appraisalMain.setOID(oid);

			appraisalMain.setEmployeeId(pstAppraisalMain.getlong(FLD_EMPLOYEE_ID));
			appraisalMain.setEmpDepartmentId(pstAppraisalMain.getlong(FLD_EMP_DEPARTMENT_ID));
			appraisalMain.setEmpPositionId(pstAppraisalMain.getlong(FLD_EMP_POSITION_ID));
			appraisalMain.setEmpLevelId(pstAppraisalMain.getlong(FLD_EMP_LEVEL_ID));
                        
			appraisalMain.setAssesorId(pstAppraisalMain.getlong(FLD_ASSESSOR_ID));
			appraisalMain.setAssesorPositionId(pstAppraisalMain.getlong(FLD_ASS_POSITION_ID));
                        
			appraisalMain.setDateAssumedPosition(pstAppraisalMain.getDate(FLD_DATE_ASS_POSITION));
			appraisalMain.setDateOfAssessment(pstAppraisalMain.getDate(FLD_DATE_OF_ASS));
			appraisalMain.setDateOfLastAssessment(pstAppraisalMain.getDate(FLD_DATE_OF_LAST_ASS));
			appraisalMain.setDateOfNextAssessment(pstAppraisalMain.getDate(FLD_DATE_OF_NEXT_ASS));
			appraisalMain.setDateJoinedHotel(pstAppraisalMain.getDate(FLD_DATE_JOINED_HOTEL));
			appraisalMain.setTotalAssessment(pstAppraisalMain.getInt(FLD_TOTAL_ASSESSMENT));
			appraisalMain.setTotalScore(pstAppraisalMain.getdouble(FLD_TOTAL_SCORE));
			appraisalMain.setScoreAverage(pstAppraisalMain.getdouble(FLD_SCORE_AVERAGE));
			appraisalMain.setDivisionHeadId(pstAppraisalMain.getlong(FLD_DIVISION_HEAD_ID));
			appraisalMain.setEmployeeSignDate(pstAppraisalMain.getDate(FLD_EMP_SIGN_DATE));
			appraisalMain.setAssessorSignDate(pstAppraisalMain.getDate(FLD_ASS_SIGN_DATE));
			appraisalMain.setDivisionHeadSignDate(pstAppraisalMain.getDate(FLD_DIV_HEAD_SIGN_DATE));
                        appraisalMain.setApproval1Id(pstAppraisalMain.getLong(FLD_APPROVAL_1_ID));
                        appraisalMain.setTimeApproval1(pstAppraisalMain.getDate(FLD_TIME_APPROVAL_1));
                        appraisalMain.setApproval2Id(pstAppraisalMain.getLong(FLD_APPROVAL_2_ID));
                        appraisalMain.setTimeApproval2(pstAppraisalMain.getDate(FLD_TIME_APPROVAL_2));
                        appraisalMain.setApproval3Id(pstAppraisalMain.getLong(FLD_APPROVAL_3_ID));
                        appraisalMain.setTimeApproval3(pstAppraisalMain.getDate(FLD_TIME_APPROVAL_3));
                        appraisalMain.setApproval4Id(pstAppraisalMain.getLong(FLD_APPROVAL_4_ID));
                        appraisalMain.setTimeApproval4(pstAppraisalMain.getDate(FLD_TIME_APPROVAL_4));
                        appraisalMain.setApproval5Id(pstAppraisalMain.getLong(FLD_APPROVAL_5_ID));
                        appraisalMain.setTimeApproval5(pstAppraisalMain.getDate(FLD_TIME_APPROVAL_5));
                        appraisalMain.setApproval6Id(pstAppraisalMain.getLong(FLD_APPROVAL_6_ID));
                        appraisalMain.setTimeApproval6(pstAppraisalMain.getDate(FLD_TIME_APPROVAL_6));
                        appraisalMain.setDataPeriodFrom(pstAppraisalMain.getDate(FLD_DATA_PERIOD_FROM));
                        appraisalMain.setDataPeriodTo(pstAppraisalMain.getDate(FLD_DATA_PERIOD_TO));                        
                        appraisalMain.setAssFormMainId(pstAppraisalMain.getLong(FLD_ASS_FORM_MAIN_ID));                        
			return appraisalMain; 
		}catch(DBException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new DBException(new PstAppraisalMain(0),DBException.UNKNOWN); 
		} 
	}

	public static long insertExc(AppraisalMain appraisalMain) throws DBException{ 
		try{ 
			PstAppraisalMain pstAppraisalMain = new PstAppraisalMain(0);

			pstAppraisalMain.setLong(FLD_EMPLOYEE_ID, appraisalMain.getEmployeeId());
			pstAppraisalMain.setLong(FLD_EMP_DEPARTMENT_ID, appraisalMain.getEmpDepartmentId());
			pstAppraisalMain.setLong(FLD_EMP_POSITION_ID, appraisalMain.getEmpPositionId());
			pstAppraisalMain.setLong(FLD_EMP_LEVEL_ID, appraisalMain.getEmpLevelId());
			pstAppraisalMain.setLong(FLD_ASSESSOR_ID, appraisalMain.getAssesorId());
			pstAppraisalMain.setLong(FLD_ASS_POSITION_ID, appraisalMain.getAssesorPositionId());
			pstAppraisalMain.setDate(FLD_DATE_ASS_POSITION, appraisalMain.getDateAssumedPosition());
			pstAppraisalMain.setDate(FLD_DATE_OF_ASS, appraisalMain.getDateOfAssessment());
			pstAppraisalMain.setDate(FLD_DATE_OF_LAST_ASS, appraisalMain.getDateOfLastAssessment());
			pstAppraisalMain.setDate(FLD_DATE_OF_NEXT_ASS, appraisalMain.getDateOfNextAssessment());
			pstAppraisalMain.setDate(FLD_DATE_JOINED_HOTEL, appraisalMain.getDateJoinedHotel());
			pstAppraisalMain.setInt(FLD_TOTAL_ASSESSMENT, appraisalMain.getTotalAssessment());
			pstAppraisalMain.setDouble(FLD_TOTAL_SCORE, appraisalMain.getTotalScore());
			pstAppraisalMain.setDouble(FLD_SCORE_AVERAGE, appraisalMain.getScoreAverage());
			pstAppraisalMain.setLong(FLD_DIVISION_HEAD_ID, appraisalMain.getDivisionHeadId());
			pstAppraisalMain.setDate(FLD_EMP_SIGN_DATE, appraisalMain.getEmployeeSignDate());
			pstAppraisalMain.setDate(FLD_ASS_SIGN_DATE, appraisalMain.getAssessorSignDate());
			pstAppraisalMain.setDate(FLD_DIV_HEAD_SIGN_DATE, appraisalMain.getDivisionHeadSignDate());
                        
                        pstAppraisalMain.setLong(FLD_APPROVAL_1_ID, appraisalMain.getApproval1Id());
                        pstAppraisalMain.setDate(FLD_TIME_APPROVAL_1, appraisalMain.getTimeApproval1());
                        pstAppraisalMain.setLong(FLD_APPROVAL_2_ID, appraisalMain.getApproval2Id());
                        pstAppraisalMain.setDate(FLD_TIME_APPROVAL_2, appraisalMain.getTimeApproval2());
                        pstAppraisalMain.setLong(FLD_APPROVAL_3_ID, appraisalMain.getApproval3Id());
                        pstAppraisalMain.setDate(FLD_TIME_APPROVAL_3, appraisalMain.getTimeApproval3());
                        pstAppraisalMain.setLong(FLD_APPROVAL_4_ID, appraisalMain.getApproval4Id());
                        pstAppraisalMain.setDate(FLD_TIME_APPROVAL_4, appraisalMain.getTimeApproval4());
                        pstAppraisalMain.setLong(FLD_APPROVAL_5_ID, appraisalMain.getApproval5Id());
                        pstAppraisalMain.setDate(FLD_TIME_APPROVAL_5, appraisalMain.getTimeApproval5());
                        pstAppraisalMain.setLong(FLD_APPROVAL_6_ID, appraisalMain.getApproval6Id());
                        pstAppraisalMain.setDate(FLD_TIME_APPROVAL_6, appraisalMain.getTimeApproval6());
                        pstAppraisalMain.setDate(FLD_DATA_PERIOD_FROM, appraisalMain.getDataPeriodFrom());
                        pstAppraisalMain.setDate(FLD_DATA_PERIOD_TO, appraisalMain.getDataPeriodTo());
                        pstAppraisalMain.setLong(FLD_ASS_FORM_MAIN_ID, appraisalMain.getAssFormMainId());
			pstAppraisalMain.insert(); 
			appraisalMain.setOID(pstAppraisalMain.getlong(FLD_APP_MAIN_ID));
		}catch(DBException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new DBException(new PstAppraisalMain(0),DBException.UNKNOWN); 
		}
		return appraisalMain.getOID();
	}

	public static long updateExc(AppraisalMain appraisalMain) throws DBException{ 
		try{ 
                    if(appraisalMain.getOID() != 0){ 
                        PstAppraisalMain pstAppraisalMain = new PstAppraisalMain(appraisalMain.getOID());

                        pstAppraisalMain.setLong(FLD_EMPLOYEE_ID, appraisalMain.getEmployeeId());
			pstAppraisalMain.setLong(FLD_EMP_DEPARTMENT_ID, appraisalMain.getEmpDepartmentId());
			pstAppraisalMain.setLong(FLD_EMP_POSITION_ID, appraisalMain.getEmpPositionId());
			pstAppraisalMain.setLong(FLD_EMP_LEVEL_ID, appraisalMain.getEmpLevelId());
			pstAppraisalMain.setLong(FLD_ASSESSOR_ID, appraisalMain.getAssesorId());
			pstAppraisalMain.setLong(FLD_ASS_POSITION_ID, appraisalMain.getAssesorPositionId());
			pstAppraisalMain.setDate(FLD_DATE_ASS_POSITION, appraisalMain.getDateAssumedPosition());
			pstAppraisalMain.setDate(FLD_DATE_OF_ASS, appraisalMain.getDateOfAssessment());
			pstAppraisalMain.setDate(FLD_DATE_OF_LAST_ASS, appraisalMain.getDateOfLastAssessment());
			pstAppraisalMain.setDate(FLD_DATE_OF_NEXT_ASS, appraisalMain.getDateOfNextAssessment());
			pstAppraisalMain.setDate(FLD_DATE_JOINED_HOTEL, appraisalMain.getDateJoinedHotel());
			pstAppraisalMain.setInt(FLD_TOTAL_ASSESSMENT, appraisalMain.getTotalAssessment());
			pstAppraisalMain.setDouble(FLD_TOTAL_SCORE, appraisalMain.getTotalScore());
			pstAppraisalMain.setDouble(FLD_SCORE_AVERAGE, appraisalMain.getScoreAverage());
                        pstAppraisalMain.setLong(FLD_DIVISION_HEAD_ID, appraisalMain.getDivisionHeadId());
			pstAppraisalMain.setDate(FLD_EMP_SIGN_DATE, appraisalMain.getEmployeeSignDate());
			pstAppraisalMain.setDate(FLD_ASS_SIGN_DATE, appraisalMain.getAssessorSignDate());
			pstAppraisalMain.setDate(FLD_DIV_HEAD_SIGN_DATE, appraisalMain.getDivisionHeadSignDate());
                        
                        pstAppraisalMain.setLong(FLD_APPROVAL_1_ID, appraisalMain.getApproval1Id());
                        pstAppraisalMain.setDate(FLD_TIME_APPROVAL_1, appraisalMain.getTimeApproval1());
                        pstAppraisalMain.setLong(FLD_APPROVAL_2_ID, appraisalMain.getApproval2Id());
                        pstAppraisalMain.setDate(FLD_TIME_APPROVAL_2, appraisalMain.getTimeApproval2());
                        pstAppraisalMain.setLong(FLD_APPROVAL_3_ID, appraisalMain.getApproval3Id());
                        pstAppraisalMain.setDate(FLD_TIME_APPROVAL_3, appraisalMain.getTimeApproval3());
                        pstAppraisalMain.setLong(FLD_APPROVAL_4_ID, appraisalMain.getApproval4Id());
                        pstAppraisalMain.setDate(FLD_TIME_APPROVAL_4, appraisalMain.getTimeApproval4());
                        pstAppraisalMain.setLong(FLD_APPROVAL_5_ID, appraisalMain.getApproval5Id());
                        pstAppraisalMain.setDate(FLD_TIME_APPROVAL_5, appraisalMain.getTimeApproval5());
                        pstAppraisalMain.setLong(FLD_APPROVAL_6_ID, appraisalMain.getApproval6Id());
                        pstAppraisalMain.setDate(FLD_TIME_APPROVAL_6, appraisalMain.getTimeApproval6());
                        pstAppraisalMain.setDate(FLD_DATA_PERIOD_FROM, appraisalMain.getDataPeriodFrom());
                        pstAppraisalMain.setDate(FLD_DATA_PERIOD_TO, appraisalMain.getDataPeriodTo());
                        pstAppraisalMain.setLong(FLD_ASS_FORM_MAIN_ID, appraisalMain.getAssFormMainId());
                        
                        pstAppraisalMain.update(); 
                        return appraisalMain.getOID();
                    }
		}catch(DBException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new DBException(new PstAppraisalMain(0),DBException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws DBException{ 
		try{ 
			PstAppraisalMain pstAppraisalMain = new PstAppraisalMain(oid);
			pstAppraisalMain.delete();
		}catch(DBException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new DBException(new PstAppraisalMain(0),DBException.UNKNOWN); 
		}
		return oid;
	}

	public static Vector listAll(){ 
		return list(0, 500, "",""); 
	}

	public static Vector list(int limitStart,int recordToGet, String whereClause, String order){
		Vector lists = new Vector(); 
		DBResultSet dbrs = null;
		try {
			String sql = "SELECT * FROM " + TBL_HR_APPRAISAL_MAIN; 
			if(whereClause != null && whereClause.length() > 0)
				sql = sql + " WHERE " + whereClause;
			if(order != null && order.length() > 0)
				sql = sql + " ORDER BY " + order;
			if(limitStart == 0 && recordToGet == 0)
				sql = sql + "";
			else
				sql = sql + " LIMIT " + limitStart + ","+ recordToGet ;
			dbrs = DBHandler.execQueryResult(sql);
			ResultSet rs = dbrs.getResultSet();
			while(rs.next()) {
				AppraisalMain appraisalMain = new AppraisalMain();
				resultToObject(rs, appraisalMain);
				lists.add(appraisalMain);
			}
			rs.close();
			return lists;

		}catch(Exception e) {
			System.out.println(e);
		}finally {
			DBResultSet.close(dbrs);
		}
			return new Vector();
	}

	public static void resultToObject(ResultSet rs, AppraisalMain appraisalMain){
		try{
                    appraisalMain.setOID(rs.getLong(PstAppraisalMain.fieldNames[PstAppraisalMain.FLD_APP_MAIN_ID]));
                    appraisalMain.setEmployeeId(rs.getLong(PstAppraisalMain.fieldNames[PstAppraisalMain.FLD_EMPLOYEE_ID]));
                    appraisalMain.setEmpDepartmentId(rs.getLong(PstAppraisalMain.fieldNames[PstAppraisalMain.FLD_EMP_DEPARTMENT_ID]));
                    appraisalMain.setEmpPositionId(rs.getLong(PstAppraisalMain.fieldNames[PstAppraisalMain.FLD_EMP_POSITION_ID]));
                    appraisalMain.setEmpLevelId(rs.getLong(PstAppraisalMain.fieldNames[PstAppraisalMain.FLD_EMP_LEVEL_ID]));
                    appraisalMain.setAssesorId(rs.getLong(PstAppraisalMain.fieldNames[PstAppraisalMain.FLD_ASSESSOR_ID]));
                    appraisalMain.setAssesorPositionId(rs.getLong(PstAppraisalMain.fieldNames[PstAppraisalMain.FLD_ASS_POSITION_ID]));
                    appraisalMain.setDateAssumedPosition(rs.getDate(PstAppraisalMain.fieldNames[PstAppraisalMain.FLD_DATE_ASS_POSITION]));
                    appraisalMain.setDateOfAssessment(rs.getDate(PstAppraisalMain.fieldNames[PstAppraisalMain.FLD_DATE_OF_ASS]));
                    appraisalMain.setDateOfLastAssessment(rs.getDate(PstAppraisalMain.fieldNames[PstAppraisalMain.FLD_DATE_OF_LAST_ASS]));
                    appraisalMain.setDateOfNextAssessment(rs.getDate(PstAppraisalMain.fieldNames[PstAppraisalMain.FLD_DATE_OF_NEXT_ASS]));
                    appraisalMain.setDateJoinedHotel(rs.getDate(PstAppraisalMain.fieldNames[PstAppraisalMain.FLD_DATE_JOINED_HOTEL]));
                    appraisalMain.setTotalAssessment(rs.getInt(PstAppraisalMain.fieldNames[PstAppraisalMain.FLD_TOTAL_ASSESSMENT]));
                    appraisalMain.setTotalScore(rs.getDouble(PstAppraisalMain.fieldNames[PstAppraisalMain.FLD_TOTAL_SCORE]));
                    appraisalMain.setScoreAverage(rs.getDouble(PstAppraisalMain.fieldNames[PstAppraisalMain.FLD_SCORE_AVERAGE]));
                    appraisalMain.setDivisionHeadId(rs.getLong(PstAppraisalMain.fieldNames[PstAppraisalMain.FLD_DIVISION_HEAD_ID]));
                    appraisalMain.setEmployeeSignDate(rs.getDate(PstAppraisalMain.fieldNames[PstAppraisalMain.FLD_EMP_SIGN_DATE]));
                    appraisalMain.setAssessorSignDate(rs.getDate(PstAppraisalMain.fieldNames[PstAppraisalMain.FLD_ASS_SIGN_DATE]));
                    appraisalMain.setDivisionHeadSignDate(rs.getDate(PstAppraisalMain.fieldNames[PstAppraisalMain.FLD_DIV_HEAD_SIGN_DATE]));
                    
                    appraisalMain.setApproval1Id(rs.getLong(PstAppraisalMain.fieldNames[PstAppraisalMain.FLD_APPROVAL_1_ID]));
                    appraisalMain.setTimeApproval1(rs.getDate(PstAppraisalMain.fieldNames[PstAppraisalMain.FLD_TIME_APPROVAL_1]));
                    appraisalMain.setApproval2Id(rs.getLong(PstAppraisalMain.fieldNames[PstAppraisalMain.FLD_APPROVAL_2_ID]));
                    appraisalMain.setTimeApproval2(rs.getDate(PstAppraisalMain.fieldNames[PstAppraisalMain.FLD_TIME_APPROVAL_2]));
                    appraisalMain.setApproval3Id(rs.getLong(PstAppraisalMain.fieldNames[PstAppraisalMain.FLD_APPROVAL_3_ID]));
                    appraisalMain.setTimeApproval3(rs.getDate(PstAppraisalMain.fieldNames[PstAppraisalMain.FLD_TIME_APPROVAL_3]));
                    appraisalMain.setApproval4Id(rs.getLong(PstAppraisalMain.fieldNames[PstAppraisalMain.FLD_APPROVAL_4_ID]));
                    appraisalMain.setTimeApproval4(rs.getDate(PstAppraisalMain.fieldNames[PstAppraisalMain.FLD_TIME_APPROVAL_4]));
                    appraisalMain.setApproval5Id(rs.getLong(PstAppraisalMain.fieldNames[PstAppraisalMain.FLD_APPROVAL_5_ID]));
                    appraisalMain.setTimeApproval5(rs.getDate(PstAppraisalMain.fieldNames[PstAppraisalMain.FLD_TIME_APPROVAL_5]));
                    appraisalMain.setApproval6Id(rs.getLong(PstAppraisalMain.fieldNames[PstAppraisalMain.FLD_APPROVAL_6_ID]));
                    appraisalMain.setTimeApproval6(rs.getDate(PstAppraisalMain.fieldNames[PstAppraisalMain.FLD_TIME_APPROVAL_6]));
                    appraisalMain.setDataPeriodFrom(rs.getDate(PstAppraisalMain.fieldNames[PstAppraisalMain.FLD_DATA_PERIOD_FROM]));                    
                    appraisalMain.setDataPeriodTo(rs.getDate(PstAppraisalMain.fieldNames[PstAppraisalMain.FLD_DATA_PERIOD_TO]));                                        
                    appraisalMain.setAssFormMainId(rs.getLong(PstAppraisalMain.fieldNames[PstAppraisalMain.FLD_ASS_FORM_MAIN_ID]));                                        
		}catch(Exception e){ }
	}

	public static boolean checkOID(long appraisalMainId){
		DBResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + TBL_HR_APPRAISAL_MAIN + " WHERE " + 
                                PstAppraisalMain.fieldNames[PstAppraisalMain.FLD_APP_MAIN_ID] 
                                + " = " + appraisalMainId;

			dbrs = DBHandler.execQueryResult(sql);
			ResultSet rs = dbrs.getResultSet();

			while(rs.next()) { result = true; }
			rs.close();
		}catch(Exception e){
			System.out.println("err : "+e.toString());
		}finally{
			DBResultSet.close(dbrs);
			return result;
		}
	}

	public static int getCount(String whereClause){
		DBResultSet dbrs = null;
		try {
			String sql = "SELECT COUNT("+ PstAppraisalMain.fieldNames[PstAppraisalMain.FLD_APP_MAIN_ID] 
                                + ") FROM " + TBL_HR_APPRAISAL_MAIN;
			if(whereClause != null && whereClause.length() > 0)
				sql = sql + " WHERE " + whereClause;

			dbrs = DBHandler.execQueryResult(sql);
			ResultSet rs = dbrs.getResultSet();

			int count = 0;
			while(rs.next()) { count = rs.getInt(1); }

			rs.close();
			return count;
		}catch(Exception e) {
			return 0;
		}finally {
			DBResultSet.close(dbrs);
		}
	}


	/* This method used to find current data */
	public static int findLimitStart( long oid, int recordToGet, String whereClause, String orderClause){
		int size = getCount(whereClause);
		int start = 0;
		boolean found =false;
		for(int i=0; (i < size) && !found ; i=i+recordToGet){
			 Vector list =  list(i,recordToGet, whereClause, orderClause); 
			 start = i;
			 if(list.size()>0){
			  for(int ls=0;ls<list.size();ls++){ 
			  	   AppraisalMain appraisalMain = (AppraisalMain)list.get(ls);
				   if(oid == appraisalMain.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
	/* This method used to find command where current data */
	public static int findLimitCommand(int start, int recordToGet, int vectSize){
		 int cmd = Command.LIST;
		 int mdl = vectSize % recordToGet;
		 vectSize = vectSize + (recordToGet - mdl);
		 if(start == 0)
			 cmd =  Command.FIRST;
		 else{
			 if(start == (vectSize-recordToGet))
				 cmd = Command.LAST;
			 else{
				 start = start + recordToGet;
				 if(start <= (vectSize - recordToGet)){
					 cmd = Command.NEXT;
				 }else{
					 start = start - recordToGet;
					 if(start > 0){
						 cmd = Command.PREV; 
					 } 
				 }
			 } 
		 }

		 return cmd;
	}
        
        public static String getApproveFrmByApprovalIndex(AppraisalMain appraisalMain, int index) {
        
            String result = "";
            try{
                if (index == 1){
                        try{
                            result = FrmAppraisalMain.fieldNames[FrmAppraisalMain.FRM_FIELD_APPROVAL_1_ID];
                        } catch (Exception e){}
                        return result;
                    
                }
                if (index == 2){
                        try{
                            result = FrmAppraisalMain.fieldNames[FrmAppraisalMain.FRM_FIELD_APPROVAL_2_ID];
                        } catch (Exception e){}
                        return result;
                }
                if (index == 3){
                        try{
                            result = FrmAppraisalMain.fieldNames[FrmAppraisalMain.FRM_FIELD_APPROVAL_3_ID];
                        } catch (Exception e){}
                        return result;
                }
                if (index == 4){
                        try{
                            result = FrmAppraisalMain.fieldNames[FrmAppraisalMain.FRM_FIELD_APPROVAL_4_ID];
                        } catch (Exception e){}
                        return result;
                }
                if (index == 5){
                        try{
                            result = FrmAppraisalMain.fieldNames[FrmAppraisalMain.FRM_FIELD_APPROVAL_5_ID];
                        } catch (Exception e){}
                        return result;
                }
                if (index == 6){
                        try{
                            result = FrmAppraisalMain.fieldNames[FrmAppraisalMain.FRM_FIELD_APPROVAL_6_ID];
                        } catch (Exception e){}
                        return result;
                }
                
            }catch(Exception e){} 
            
            return result;
    }
 
 public static String getApproveFrmByApprovalIndexDate(AppraisalMain appraisalMain, int index) {
        
            String result = "";
            try{
                if (index == 1){
                        try{
                            result = FrmAppraisalMain.fieldNames[FrmAppraisalMain.FRM_FIELD_TIME_APPROVAL_1];
                        } catch (Exception e){}
                        return result;
                    
                }
                if (index == 2){
                        try{
                            result = FrmAppraisalMain.fieldNames[FrmAppraisalMain.FRM_FIELD_TIME_APPROVAL_2];
                        } catch (Exception e){}
                        return result;
                }
                if (index == 3){
                        try{
                            result = FrmAppraisalMain.fieldNames[FrmAppraisalMain.FRM_FIELD_TIME_APPROVAL_3];
                        } catch (Exception e){}
                        return result;
                }
                if (index == 4){
                        try{
                            result = FrmAppraisalMain.fieldNames[FrmAppraisalMain.FRM_FIELD_TIME_APPROVAL_4];
                        } catch (Exception e){}
                        return result;
                }
                if (index == 5){
                        try{
                            result = FrmAppraisalMain.fieldNames[FrmAppraisalMain.FRM_FIELD_TIME_APPROVAL_5];
                        } catch (Exception e){}
                        return result;
                }
                if (index == 6){
                        try{
                            result = FrmAppraisalMain.fieldNames[FrmAppraisalMain.FRM_FIELD_TIME_APPROVAL_6];
                        } catch (Exception e){}
                        return result;
                }
                
            }catch(Exception e){} 
            
            return result;
    }
    
    public static long getApproveOidByApprovalIndex(AppraisalMain appraisalMain, int index) {
        
            long result = 0;
            try{
                if (index == 1){
                    if (appraisalMain.getApproval1Id() != 0){
                        try{
                            result = appraisalMain.getApproval1Id();
                        } catch (Exception e){}
                        return result;
                    }
                }
                if (index == 2){
                    if (appraisalMain.getApproval2Id() != 0){
                        try{
                            result = appraisalMain.getApproval2Id();
                        } catch (Exception e){}
                        return result;
                    }
                }
                if (index == 3){
                    if (appraisalMain.getApproval3Id() != 0){
                        try{
                            result = appraisalMain.getApproval3Id();    
                        } catch (Exception e){}
                        return result;
                    }
                }
                if (index == 4){
                    if (appraisalMain.getApproval4Id() != 0){
                        try{
                            result = appraisalMain.getApproval4Id();
                        } catch (Exception e){}
                        return result;
                    }
                }
                if (index == 5){
                    if (appraisalMain.getApproval5Id() != 0){
                        try{
                            result = appraisalMain.getApproval5Id() ;
                        } catch (Exception e){}
                        return result;
                    }
                }
                if (index == 6){
                    if (appraisalMain.getApproval6Id() != 0){
                        try{
                            result = appraisalMain.getApproval6Id();
                        } catch (Exception e){}
                        return result;
                    }
                }
                
            }catch(Exception e){} 
            
            return result;
    }
    
    public static Date getApproveDateByApprovalIndex(AppraisalMain appraisalMain, int index) {
        
            Date result = null;
            try{
                if (index == 1){
                    if (appraisalMain.getApproval1Id() != 0){
                        try{
                            result = appraisalMain.getTimeApproval1();
                        } catch (Exception e){}
                        return result;
                    }
                }
                if (index == 2){
                    if (appraisalMain.getApproval2Id() != 0){
                        try{
                            result = appraisalMain.getTimeApproval2();
                        } catch (Exception e){}
                        return result;
                    }
                }
                if (index == 3){
                    if (appraisalMain.getApproval3Id() != 0){
                        try{
                            result = appraisalMain.getTimeApproval3();    
                        } catch (Exception e){}
                        return result;
                    }
                }
                if (index == 4){
                    if (appraisalMain.getApproval4Id() != 0){
                        try{
                            result = appraisalMain.getTimeApproval4();
                        } catch (Exception e){}
                        return result;
                    }
                }
                if (index == 5){
                    if (appraisalMain.getApproval5Id() != 0){
                        try{
                            result = appraisalMain.getTimeApproval5();
                        } catch (Exception e){}
                        return result;
                    }
                }
                if (index == 6){
                    if (appraisalMain.getApproval6Id() != 0){
                        try{
                            result = appraisalMain.getTimeApproval6();
                        } catch (Exception e){}
                        return result;
                    }
                }
                
            }catch(Exception e){} 
            
            return result;
    }
    
    public static String getApproveFrmDateByApprovalIndex(AppraisalMain appraisalMain, int index) {
        
            String result = "";
            try{
                if (index == 1){
                        try{
                            result = FrmAppraisalMain.fieldNames[FrmAppraisalMain.FRM_FIELD_TIME_APPROVAL_1];
                        } catch (Exception e){}
                        return result;
                }
                if (index == 2){
                        try{
                            result = FrmAppraisalMain.fieldNames[FrmAppraisalMain.FRM_FIELD_TIME_APPROVAL_2];
                        } catch (Exception e){}
                        return result;
                }
                if (index == 3){
                        try{
                            result = FrmAppraisalMain.fieldNames[FrmAppraisalMain.FRM_FIELD_TIME_APPROVAL_3];
                        } catch (Exception e){}
                        return result;
                }
                if (index == 4){
                        try{
                            result = FrmAppraisalMain.fieldNames[FrmAppraisalMain.FRM_FIELD_TIME_APPROVAL_4];
                        } catch (Exception e){}
                        return result;
                }
                if (index == 5){
                        try{
                            result = FrmAppraisalMain.fieldNames[FrmAppraisalMain.FRM_FIELD_TIME_APPROVAL_5];
                        } catch (Exception e){}
                        return result;
                }
                if (index == 6){
                        try{
                            result = FrmAppraisalMain.fieldNames[FrmAppraisalMain.FRM_FIELD_TIME_APPROVAL_6];
                        } catch (Exception e){}
                        return result;
                }
                
            }catch(Exception e){} 
            
            return result;
    }
    
    public static boolean cekApproval(AppraisalMain appraisalMain,int index) {
        
            boolean cekAdaTrue = false;
            
            try{
                if (index == 1){
                    if (appraisalMain.getApproval1Id() != 0){
                        return true;
                    }
                }
                if (index == 2){
                    if (appraisalMain.getApproval2Id() != 0){
                        return true;
                    }
                }
                if (index == 3){
                    if (appraisalMain.getApproval3Id() != 0){
                        return true;
                    }
                }
                if (index == 4){
                    if (appraisalMain.getApproval4Id() != 0){
                        return true;
                    }
                }
                if (index == 5){
                    if (appraisalMain.getApproval5Id() != 0){
                        return true;
                    }
                }
                if (index == 6){
                    if (appraisalMain.getApproval6Id() != 0){
                        return true;
                    }
                }
                
            }catch(Exception e){} 
            
            return cekAdaTrue;
    }
    
    public static String getObjEmployeeByApprovalIndex(AppraisalMain appraisalMain, int index) {
        
            Employee employee = new Employee();
            String result = "";
            try{
                if (index == 1){
                    if (appraisalMain.getApproval1Id() != 0){
                        try{
                            employee = PstEmployee.fetchExc(appraisalMain.getApproval1Id());
                            result = "<B>" + employee.getFullName() + "</B><input type=\"hidden\" name=\"" + FrmAppraisalMain.fieldNames[FrmAppraisalMain.FRM_FIELD_APPROVAL_1_ID] + "\" value=\"" + appraisalMain.getApproval1Id() + "\">";
                        } catch (Exception e){}
                        return result;
                    }
                }
                if (index == 2){
                    if (appraisalMain.getApproval2Id() != 0){
                        try{
                            employee = PstEmployee.fetchExc(appraisalMain.getApproval2Id());
                            result = "<B>" + employee.getFullName() + "</B><input type=\"hidden\" name=\"" + FrmAppraisalMain.fieldNames[FrmAppraisalMain.FRM_FIELD_APPROVAL_2_ID] + "\" value=\"" + appraisalMain.getApproval2Id() + "\">";
                        } catch (Exception e){}
                        return result;
                    }
                }
                if (index == 3){
                    if (appraisalMain.getApproval3Id() != 0){
                        try{
                            employee = PstEmployee.fetchExc(appraisalMain.getApproval3Id());
                            result = "<B>" + employee.getFullName() + "</B><input type=\"hidden\" name=\"" + FrmAppraisalMain.fieldNames[FrmAppraisalMain.FRM_FIELD_APPROVAL_3_ID] + "\" value=\"" + appraisalMain.getApproval3Id() + "\">";
                        } catch (Exception e){}
                        return result;
                    }
                }
                if (index == 4){
                    if (appraisalMain.getApproval4Id() != 0){
                        try{
                            employee = PstEmployee.fetchExc(appraisalMain.getApproval4Id());
                            result = "<B>" + employee.getFullName() + "</B><input type=\"hidden\" name=\"" + FrmAppraisalMain.fieldNames[FrmAppraisalMain.FRM_FIELD_APPROVAL_4_ID] + "\" value=\"" + appraisalMain.getApproval4Id() + "\">";
                        } catch (Exception e){}
                        return result;
                    }
                }
                if (index == 5){
                    if (appraisalMain.getApproval5Id() != 0){
                        try{
                            employee = PstEmployee.fetchExc(appraisalMain.getApproval5Id());
                            result = "<B>" + employee.getFullName() + "</B><input type=\"hidden\" name=\"" + FrmAppraisalMain.fieldNames[FrmAppraisalMain.FRM_FIELD_APPROVAL_5_ID] + "\" value=\"" + appraisalMain.getApproval5Id() + "\">";
                        } catch (Exception e){}
                        return result;
                    }
                }
                if (index == 6){
                    if (appraisalMain.getApproval6Id() != 0){
                        try{
                            employee = PstEmployee.fetchExc(appraisalMain.getApproval6Id());
                            result = "<B>" + employee.getFullName() + "</B><input type=\"hidden\" name=\"" + FrmAppraisalMain.fieldNames[FrmAppraisalMain.FRM_FIELD_APPROVAL_6_ID] + "\" value=\"" + appraisalMain.getApproval6Id() + "\">";
                        } catch (Exception e){}
                        return result;
                    }
                }
                
            }catch(Exception e){} 
            
            return result;
    }
    
    public static Date getApproveOidByApprovalIndexDate(AppraisalMain appraisalMain, int index) {
        
            Date result = new  Date();
            try{
                if (index == 1){
                    if (appraisalMain.getTimeApproval1() != null){
                        try{
                            result = appraisalMain.getTimeApproval1();
                        } catch (Exception e){}
                        return result;
                    }
                }
                if (index == 2){
                    if (appraisalMain.getTimeApproval1() != null){
                        try{
                            result = appraisalMain.getTimeApproval1();
                        } catch (Exception e){}
                        return result;
                    }
                }
                if (index == 3){
                    if (appraisalMain.getTimeApproval1() != null){
                        try{
                            result = appraisalMain.getTimeApproval1();
                        } catch (Exception e){}
                        return result;
                    }
                }
                if (index == 4){
                    if (appraisalMain.getTimeApproval1() != null){
                        try{
                            result = appraisalMain.getTimeApproval1();
                        } catch (Exception e){}
                        return result;
                    }
                }
                if (index == 5){
                    if (appraisalMain.getTimeApproval1() != null){
                        try{
                            result = appraisalMain.getTimeApproval1();
                        } catch (Exception e){}
                        return result;
                    }
                }
                if (index == 6){
                    if (appraisalMain.getTimeApproval1() != null){
                        try{
                            result = appraisalMain.getTimeApproval1();
                        } catch (Exception e){}
                        return result;
                    }
                }
                
            }catch(Exception e){} 
            
            return result;
    }
        
        public static int getMaxApp(long employeeId, I_Leave leaveConfig, AppraisalMain appraisalMain ){
        int max = 0;
          Employee employeeObj = new Employee();
            try {
                employeeObj = PstEmployee.fetchExc(employeeId);
            }catch (Exception e){}

            Level level = new Level();
            try{
                level = PstLevel.fetchExc(employeeObj.getLevelId());
            }catch(Exception e){}

            Level maxLevelObj = new Level();
            try{
                maxLevelObj = PstLevel.fetchExc(level.getMaxLevelApproval());
            }catch(Exception e){}

            int minLevel = level.getLevelPoint();
            int maxLevel = maxLevelObj.getLevelPoint();
            int incIndexApp = 1;            
            long oidEmpDinamis = employeeId;
            for (int xx = minLevel; xx<=maxLevel; xx++ ){
            Vector listEmpApproval = leaveConfig.getApprovalEmployeeTopLinkByLevel(oidEmpDinamis, 6, xx, "");
                if (listEmpApproval.size()>0){
                    if (PstAppraisalMain.getApproveOidByApprovalIndex(appraisalMain, incIndexApp) != 0){
                        oidEmpDinamis = PstAppraisalMain.getApproveOidByApprovalIndex(appraisalMain, incIndexApp);
                    }
                    max++;
                    incIndexApp++;
                }
            }
        return max;
    }
}

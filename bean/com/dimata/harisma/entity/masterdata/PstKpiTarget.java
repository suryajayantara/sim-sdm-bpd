/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.masterdata;

import com.dimata.harisma.entity.employee.Employee;
import com.dimata.harisma.entity.employee.PstEmployee;
import java.sql.*;
import com.dimata.util.lang.I_Language;
import com.dimata.qdep.db.*;
import com.dimata.qdep.entity.*;
import com.dimata.system.entity.PstSystemProperty;
import com.dimata.util.Command;
import com.dimata.util.Formater;
import java.util.Vector;

/**
 *
 * @author IanRizky
 */
public class PstKpiTarget extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {

	public static final String TBL_KPI_TARGET = "hr_kpi_target";
	public static final int FLD_KPI_TARGET_ID = 0;
	public static final int FLD_CREATE_DATE = 1;
	public static final int FLD_TITLE = 2;
	public static final int FLD_STATUS_DOC = 3;
	public static final int FLD_COMPANY_ID = 4;
	public static final int FLD_DIVISION_ID = 5;
	public static final int FLD_DEPARTMENT_ID = 6;
	public static final int FLD_SECTION_ID = 7;
	public static final int FLD_COUNT_IDX = 8;
	public static final int FLD_APPROVAL_1 = 9;
	public static final int FLD_APPROVAL_DATE_1 = 10;
	public static final int FLD_APPROVAL_2 = 11;
	public static final int FLD_APPROVAL_DATE_2 = 12;
	public static final int FLD_APPROVAL_3 = 13;
	public static final int FLD_APPROVAL_DATE_3 = 14;
	public static final int FLD_APPROVAL_4 = 15;
	public static final int FLD_APPROVAL_DATE_4 = 16;
	public static final int FLD_APPROVAL_5 = 17;
	public static final int FLD_APPROVAL_DATE_5 = 18;
	public static final int FLD_APPROVAL_6 = 19;
	public static final int FLD_APPROVAL_DATE_6 = 20;
	public static final int FLD_AUTHOR_ID = 21;
	public static final int FLD_TAHUN = 22;
        public static final int FLD_POSITION_ID = 23;

	public static String[] fieldNames = {
		"KPI_TARGET_ID",
		"CREATE_DATE",
		"TITLE",
		"STATUS_DOC",
		"COMPANY_ID",
		"DIVISION_ID",
		"DEPARTMENT_ID",
		"SECTION_ID",
		"COUNT_IDX",
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
		"AUTHOR_ID",
		"TAHUN",
                "POSITION_ID"
	};

	public static int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_DATE,
		TYPE_STRING,
		TYPE_INT,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_LONG,
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
		TYPE_LONG,
		TYPE_INT,
                TYPE_LONG
	};

	public PstKpiTarget() {
	}

	public PstKpiTarget(int i) throws DBException {
		super(new PstKpiTarget());
	}

	public PstKpiTarget(String sOid) throws DBException {
		super(new PstKpiTarget(0));
		if (!locate(sOid)) {
			throw new DBException(this, DBException.RECORD_NOT_FOUND);
		} else {
			return;
		}
	}

	public PstKpiTarget(long lOid) throws DBException {
		super(new PstKpiTarget(0));
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
		return TBL_KPI_TARGET;
	}

	public String[] getFieldNames() {
		return fieldNames;
	}

	public int[] getFieldTypes() {
		return fieldTypes;
	}

	public String getPersistentName() {
		return new PstKpiTarget().getClass().getName();
	}

	public static KpiTarget fetchExc(long oid) throws DBException {
		try {
			KpiTarget entKpiTarget = new KpiTarget();
			PstKpiTarget pstKpiTarget = new PstKpiTarget(oid);
			entKpiTarget.setOID(oid);
			entKpiTarget.setCreateDate(pstKpiTarget.getDate(FLD_CREATE_DATE));
			entKpiTarget.setTitle(pstKpiTarget.getString(FLD_TITLE));
			entKpiTarget.setStatusDoc(pstKpiTarget.getInt(FLD_STATUS_DOC));
			entKpiTarget.setCompanyId(pstKpiTarget.getLong(FLD_COMPANY_ID));
			entKpiTarget.setDivisionId(pstKpiTarget.getLong(FLD_DIVISION_ID));
			entKpiTarget.setDepartmentId(pstKpiTarget.getLong(FLD_DEPARTMENT_ID));
			entKpiTarget.setSectionId(pstKpiTarget.getLong(FLD_SECTION_ID));
			entKpiTarget.setCountIdx(pstKpiTarget.getInt(FLD_COUNT_IDX));
			entKpiTarget.setApproval1(pstKpiTarget.getLong(FLD_APPROVAL_1));
			entKpiTarget.setApprovalDate1(pstKpiTarget.getDate(FLD_APPROVAL_DATE_1));
			entKpiTarget.setApproval2(pstKpiTarget.getLong(FLD_APPROVAL_2));
			entKpiTarget.setApprovalDate2(pstKpiTarget.getDate(FLD_APPROVAL_DATE_2));
			entKpiTarget.setApproval3(pstKpiTarget.getLong(FLD_APPROVAL_3));
			entKpiTarget.setApprovalDate3(pstKpiTarget.getDate(FLD_APPROVAL_DATE_3));
			entKpiTarget.setApproval4(pstKpiTarget.getLong(FLD_APPROVAL_4));
			entKpiTarget.setApprovalDate4(pstKpiTarget.getDate(FLD_APPROVAL_DATE_4));
			entKpiTarget.setApproval5(pstKpiTarget.getLong(FLD_APPROVAL_5));
			entKpiTarget.setApprovalDate5(pstKpiTarget.getDate(FLD_APPROVAL_DATE_5));
			entKpiTarget.setApproval6(pstKpiTarget.getLong(FLD_APPROVAL_6));
			entKpiTarget.setApprovalDate6(pstKpiTarget.getDate(FLD_APPROVAL_DATE_6));
			entKpiTarget.setAuthorId(pstKpiTarget.getlong(FLD_AUTHOR_ID));
			entKpiTarget.setTahun(pstKpiTarget.getInt(FLD_TAHUN));
                        entKpiTarget.setPositionId(pstKpiTarget.getInt(FLD_POSITION_ID));
			return entKpiTarget;
		} catch (DBException dbe) {
			throw dbe;
		} catch (Exception e) {
			throw new DBException(new PstKpiTarget(0), DBException.UNKNOWN);
		}
	}

	public long fetchExc(Entity entity) throws Exception {
		KpiTarget entKpiTarget = fetchExc(entity.getOID());
		entity = (Entity) entKpiTarget;
		return entKpiTarget.getOID();
	}

	public static synchronized long updateExc(KpiTarget entKpiTarget) throws DBException {
		try {
			if (entKpiTarget.getOID() != 0) {
				PstKpiTarget pstKpiTarget = new PstKpiTarget(entKpiTarget.getOID());
				pstKpiTarget.setDate(FLD_CREATE_DATE, entKpiTarget.getCreateDate());
				pstKpiTarget.setString(FLD_TITLE, entKpiTarget.getTitle());
				pstKpiTarget.setInt(FLD_STATUS_DOC, entKpiTarget.getStatusDoc());
				pstKpiTarget.setLong(FLD_COMPANY_ID, entKpiTarget.getCompanyId());
				pstKpiTarget.setLong(FLD_DIVISION_ID, entKpiTarget.getDivisionId());
				pstKpiTarget.setLong(FLD_DEPARTMENT_ID, entKpiTarget.getDepartmentId());
				pstKpiTarget.setLong(FLD_SECTION_ID, entKpiTarget.getSectionId());
				pstKpiTarget.setInt(FLD_COUNT_IDX, entKpiTarget.getCountIdx());
				pstKpiTarget.setLong(FLD_APPROVAL_1, entKpiTarget.getApproval1());
				pstKpiTarget.setDate(FLD_APPROVAL_DATE_1, entKpiTarget.getApprovalDate1());
				pstKpiTarget.setLong(FLD_APPROVAL_2, entKpiTarget.getApproval2());
				pstKpiTarget.setDate(FLD_APPROVAL_DATE_2, entKpiTarget.getApprovalDate2());
				pstKpiTarget.setLong(FLD_APPROVAL_3, entKpiTarget.getApproval3());
				pstKpiTarget.setDate(FLD_APPROVAL_DATE_3, entKpiTarget.getApprovalDate3());
				pstKpiTarget.setLong(FLD_APPROVAL_4, entKpiTarget.getApproval4());
				pstKpiTarget.setDate(FLD_APPROVAL_DATE_4, entKpiTarget.getApprovalDate4());
				pstKpiTarget.setLong(FLD_APPROVAL_5, entKpiTarget.getApproval5());
				pstKpiTarget.setDate(FLD_APPROVAL_DATE_5, entKpiTarget.getApprovalDate5());
				pstKpiTarget.setLong(FLD_APPROVAL_6, entKpiTarget.getApproval6());
				pstKpiTarget.setDate(FLD_APPROVAL_DATE_6, entKpiTarget.getApprovalDate6());
				pstKpiTarget.setLong(FLD_AUTHOR_ID, entKpiTarget.getAuthorId());
				pstKpiTarget.setInt(FLD_TAHUN, entKpiTarget.getTahun());
                                pstKpiTarget.setLong(FLD_POSITION_ID, entKpiTarget.getPositionId());
                                
				pstKpiTarget.update();
				return entKpiTarget.getOID();
			}
		} catch (DBException dbe) {
			throw dbe;
		} catch (Exception e) {
			throw new DBException(new PstKpiTarget(0), DBException.UNKNOWN);
		}
		return 0;
	}

	public long updateExc(Entity entity) throws Exception {
		return updateExc((KpiTarget) entity);
	}

	public static synchronized long deleteExc(long oid) throws DBException {
		try {
			PstKpiTarget pstKpiTarget = new PstKpiTarget(oid);
			pstKpiTarget.delete();
		} catch (DBException dbe) {
			throw dbe;
		} catch (Exception e) {
			throw new DBException(new PstKpiTarget(0), DBException.UNKNOWN);
		}
		return oid;
	}

	public long deleteExc(Entity entity) throws Exception {
		if (entity == null) {
			throw new DBException(this, DBException.RECORD_NOT_FOUND);
		}
		return deleteExc(entity.getOID());
	}

	public static synchronized long insertExc(KpiTarget entKpiTarget) throws DBException {
		try {
			PstKpiTarget pstKpiTarget = new PstKpiTarget(0);
			pstKpiTarget.setDate(FLD_CREATE_DATE, entKpiTarget.getCreateDate());
			pstKpiTarget.setString(FLD_TITLE, entKpiTarget.getTitle());
			pstKpiTarget.setInt(FLD_STATUS_DOC, entKpiTarget.getStatusDoc());
			pstKpiTarget.setLong(FLD_COMPANY_ID, entKpiTarget.getCompanyId());
			pstKpiTarget.setLong(FLD_DIVISION_ID, entKpiTarget.getDivisionId());
			pstKpiTarget.setLong(FLD_DEPARTMENT_ID, entKpiTarget.getDepartmentId());
			pstKpiTarget.setLong(FLD_SECTION_ID, entKpiTarget.getSectionId());
			pstKpiTarget.setInt(FLD_COUNT_IDX, entKpiTarget.getCountIdx());
			pstKpiTarget.setLong(FLD_APPROVAL_1, entKpiTarget.getApproval1());
			pstKpiTarget.setDate(FLD_APPROVAL_DATE_1, entKpiTarget.getApprovalDate1());
			pstKpiTarget.setLong(FLD_APPROVAL_2, entKpiTarget.getApproval2());
			pstKpiTarget.setDate(FLD_APPROVAL_DATE_2, entKpiTarget.getApprovalDate2());
			pstKpiTarget.setLong(FLD_APPROVAL_3, entKpiTarget.getApproval3());
			pstKpiTarget.setDate(FLD_APPROVAL_DATE_3, entKpiTarget.getApprovalDate3());
			pstKpiTarget.setLong(FLD_APPROVAL_4, entKpiTarget.getApproval4());
			pstKpiTarget.setDate(FLD_APPROVAL_DATE_4, entKpiTarget.getApprovalDate4());
			pstKpiTarget.setLong(FLD_APPROVAL_5, entKpiTarget.getApproval5());
			pstKpiTarget.setDate(FLD_APPROVAL_DATE_5, entKpiTarget.getApprovalDate5());
			pstKpiTarget.setLong(FLD_APPROVAL_6, entKpiTarget.getApproval6());
			pstKpiTarget.setDate(FLD_APPROVAL_DATE_6, entKpiTarget.getApprovalDate6());
			pstKpiTarget.setLong(FLD_AUTHOR_ID, entKpiTarget.getAuthorId());
			pstKpiTarget.setInt(FLD_TAHUN, entKpiTarget.getTahun());
                        pstKpiTarget.setLong(FLD_POSITION_ID, entKpiTarget.getPositionId());
			pstKpiTarget.insert();
			entKpiTarget.setOID(pstKpiTarget.getLong(FLD_KPI_TARGET_ID));
		} catch (DBException dbe) {
			throw dbe;
		} catch (Exception e) {
			throw new DBException(new PstKpiTarget(0), DBException.UNKNOWN);
		}
		return entKpiTarget.getOID();
	}

	public long insertExc(Entity entity) throws Exception {
		return insertExc((KpiTarget) entity);
	}

	public static void resultToObject(ResultSet rs, KpiTarget entKpiTarget) {
		try {
			entKpiTarget.setOID(rs.getLong(PstKpiTarget.fieldNames[PstKpiTarget.FLD_KPI_TARGET_ID]));
			entKpiTarget.setCreateDate(rs.getDate(PstKpiTarget.fieldNames[PstKpiTarget.FLD_CREATE_DATE]));
			entKpiTarget.setTitle(rs.getString(PstKpiTarget.fieldNames[PstKpiTarget.FLD_TITLE]));
			entKpiTarget.setStatusDoc(rs.getInt(PstKpiTarget.fieldNames[PstKpiTarget.FLD_STATUS_DOC]));
			entKpiTarget.setCompanyId(rs.getLong(PstKpiTarget.fieldNames[PstKpiTarget.FLD_COMPANY_ID]));
			entKpiTarget.setDivisionId(rs.getLong(PstKpiTarget.fieldNames[PstKpiTarget.FLD_DIVISION_ID]));
			entKpiTarget.setDepartmentId(rs.getLong(PstKpiTarget.fieldNames[PstKpiTarget.FLD_DEPARTMENT_ID]));
			entKpiTarget.setSectionId(rs.getLong(PstKpiTarget.fieldNames[PstKpiTarget.FLD_SECTION_ID]));
			entKpiTarget.setCountIdx(rs.getInt(PstKpiTarget.fieldNames[PstKpiTarget.FLD_COUNT_IDX]));
			entKpiTarget.setApproval1(rs.getLong(PstKpiTarget.fieldNames[PstKpiTarget.FLD_APPROVAL_1]));
			entKpiTarget.setApprovalDate1(rs.getDate(PstKpiTarget.fieldNames[PstKpiTarget.FLD_APPROVAL_DATE_1]));
			entKpiTarget.setApproval2(rs.getLong(PstKpiTarget.fieldNames[PstKpiTarget.FLD_APPROVAL_2]));
			entKpiTarget.setApprovalDate2(rs.getDate(PstKpiTarget.fieldNames[PstKpiTarget.FLD_APPROVAL_DATE_2]));
			entKpiTarget.setApproval3(rs.getLong(PstKpiTarget.fieldNames[PstKpiTarget.FLD_APPROVAL_3]));
			entKpiTarget.setApprovalDate3(rs.getDate(PstKpiTarget.fieldNames[PstKpiTarget.FLD_APPROVAL_DATE_3]));
			entKpiTarget.setApproval4(rs.getLong(PstKpiTarget.fieldNames[PstKpiTarget.FLD_APPROVAL_4]));
			entKpiTarget.setApprovalDate4(rs.getDate(PstKpiTarget.fieldNames[PstKpiTarget.FLD_APPROVAL_DATE_4]));
			entKpiTarget.setApproval5(rs.getLong(PstKpiTarget.fieldNames[PstKpiTarget.FLD_APPROVAL_5]));
			entKpiTarget.setApprovalDate5(rs.getDate(PstKpiTarget.fieldNames[PstKpiTarget.FLD_APPROVAL_DATE_5]));
			entKpiTarget.setApproval6(rs.getLong(PstKpiTarget.fieldNames[PstKpiTarget.FLD_APPROVAL_6]));
			entKpiTarget.setApprovalDate6(rs.getDate(PstKpiTarget.fieldNames[PstKpiTarget.FLD_APPROVAL_DATE_6]));
			entKpiTarget.setAuthorId(rs.getLong(PstKpiTarget.fieldNames[PstKpiTarget.FLD_AUTHOR_ID]));
			entKpiTarget.setTahun(rs.getInt(PstKpiTarget.fieldNames[PstKpiTarget.FLD_TAHUN]));
                        entKpiTarget.setPositionId(rs.getLong(PstKpiTarget.fieldNames[PstKpiTarget.FLD_POSITION_ID]));
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
			String sql = "SELECT * FROM " + TBL_KPI_TARGET;
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
				KpiTarget entKpiTarget = new KpiTarget();
				resultToObject(rs, entKpiTarget);
				lists.add(entKpiTarget);
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

	public static boolean checkOID(long entKpiTargetId) {
		DBResultSet dbrs = null;
		boolean result = false;
		try {
			String sql = "SELECT * FROM " + TBL_KPI_TARGET + " WHERE "
					+ PstKpiTarget.fieldNames[PstKpiTarget.FLD_KPI_TARGET_ID] + " = " + entKpiTargetId;
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
			String sql = "SELECT COUNT(" + PstKpiTarget.fieldNames[PstKpiTarget.FLD_KPI_TARGET_ID] + ") FROM " + TBL_KPI_TARGET;
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
					KpiTarget entKpiTarget = (KpiTarget) list.get(ls);
					if (oid == entKpiTarget.getOID()) {
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
		} else if (start == (vectSize - recordToGet)) {
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
		return cmd;
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
                String nilai = getKPITargetIdByApproval(oidEmp, userLoggin, divisionId, data[0], maxApproval, needHrApproval, emp.getDivisionId());
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
	
	public static String getKPITargetIdByApproval(long empId, long userLoggin, long divisionId, String leaveId, int maxApproval, boolean needHrApproval, long empDivisionId){
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
            String sql = "SELECT hr_kpi_target.KPI_TARGET_ID, " +
            "hr_employee.EMPLOYEE_NUM, " +
            "hr_employee.FULL_NAME, " +
            "hr_kpi_target.CREATE_DATE, "+
			"hr_kpi_target.TITLE, "+
            "hr_employee.EMPLOYEE_ID, " +
            "hr_kpi_target.APPROVAL_1, "+
            "hr_kpi_target.APPROVAL_2, "+
            "hr_kpi_target.APPROVAL_3, "+
            "hr_kpi_target.APPROVAL_4, "+
            "hr_kpi_target.APPROVAL_5, "+
            "hr_kpi_target.APPROVAL_6 "+
            "FROM " + TBL_KPI_TARGET+ " "+
            "INNER JOIN hr_employee ON hr_employee.EMPLOYEE_ID=hr_kpi_target.AUTHOR_ID "+
            "WHERE hr_kpi_target.STATUS_DOC="+I_DocStatus.DOCUMENT_STATUS_TO_BE_APPROVED+" ";
            if (whereAdd.length()>0){
                sql += " AND "+whereAdd+" ";
            }
            sql += "ORDER BY hr_kpi_target.CREATE_DATE DESC";

            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                String [] data = new String[12];
                data[0] = ""+rs.getLong(PstKpiTarget.fieldNames[PstKpiTarget.FLD_KPI_TARGET_ID]);
                data[1] = ""+rs.getString("FULL_NAME");
                data[2] = ""+rs.getString("CREATE_DATE");
                data[3] = ""+rs.getString("EMPLOYEE_ID");
				data[10] = ""+rs.getString("EMPLOYEE_NUM");
				data[11] = ""+rs.getString("TITLE");

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
            sql += " WHERE hr_mapping_position.TYPE_OF_LINK=12 AND ";
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
            sql += " WHERE hr_mapping_position.TYPE_OF_LINK=12 AND ";
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
}

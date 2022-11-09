/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.masterdata;

import java.sql.*;
import com.dimata.util.lang.I_Language;
import com.dimata.qdep.db.*;
import com.dimata.qdep.entity.*;
import com.dimata.util.Command;
import java.util.Vector;

/**
 *
 * @author IanRizky
 */
public class PstKpiTargetDetailEmployee extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {

	public static final String TBL_KPI_TARGET_DETAIL_EMPLOYEE = "hr_kpi_target_detail_employee";
	public static final int FLD_KPI_TARGET_DETAIL_EMPLOYEE_ID = 0;
	public static final int FLD_KPI_TARGET_DETAIL_ID = 1;
	public static final int FLD_EMPLOYEE_ID = 2;
        public static final int FLD_BOBOT = 3;

	public static String[] fieldNames = {
		"KPI_TARGET_DETAIL_EMPLOYEE_ID",
		"KPI_TARGET_DETAIL_ID",
		"EMPLOYEE_ID",
                "BOBOT"
	};

	public static int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_LONG,
		TYPE_LONG,
                TYPE_FLOAT
	};

	public PstKpiTargetDetailEmployee() {
	}

	public PstKpiTargetDetailEmployee(int i) throws DBException {
		super(new PstKpiTargetDetailEmployee());
	}

	public PstKpiTargetDetailEmployee(String sOid) throws DBException {
		super(new PstKpiTargetDetailEmployee(0));
		if (!locate(sOid)) {
			throw new DBException(this, DBException.RECORD_NOT_FOUND);
		} else {
			return;
		}
	}

	public PstKpiTargetDetailEmployee(long lOid) throws DBException {
		super(new PstKpiTargetDetailEmployee(0));
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
		return TBL_KPI_TARGET_DETAIL_EMPLOYEE;
	}

	public String[] getFieldNames() {
		return fieldNames;
	}

	public int[] getFieldTypes() {
		return fieldTypes;
	}

	public String getPersistentName() {
		return new PstKpiTargetDetailEmployee().getClass().getName();
	}

	public static KpiTargetDetailEmployee fetchExc(long oid) throws DBException {
		try {
			KpiTargetDetailEmployee entKpiTargetDetailEmployee = new KpiTargetDetailEmployee();
			PstKpiTargetDetailEmployee pstKpiTargetDetailEmployee = new PstKpiTargetDetailEmployee(oid);
			entKpiTargetDetailEmployee.setOID(oid);
			entKpiTargetDetailEmployee.setKpiTargetDetailId(pstKpiTargetDetailEmployee.getLong(FLD_KPI_TARGET_DETAIL_ID));
			entKpiTargetDetailEmployee.setEmployeeId(pstKpiTargetDetailEmployee.getLong(FLD_EMPLOYEE_ID));
                        entKpiTargetDetailEmployee.setBobot(pstKpiTargetDetailEmployee.getdouble(FLD_BOBOT));
			return entKpiTargetDetailEmployee;
		} catch (DBException dbe) {
			throw dbe;
		} catch (Exception e) {
			throw new DBException(new PstKpiTargetDetailEmployee(0), DBException.UNKNOWN);
		}
	}

	public long fetchExc(Entity entity) throws Exception {
		KpiTargetDetailEmployee entKpiTargetDetailEmployee = fetchExc(entity.getOID());
		entity = (Entity) entKpiTargetDetailEmployee;
		return entKpiTargetDetailEmployee.getOID();
	}

	public static synchronized long updateExc(KpiTargetDetailEmployee entKpiTargetDetailEmployee) throws DBException {
		try {
			if (entKpiTargetDetailEmployee.getOID() != 0) {
				PstKpiTargetDetailEmployee pstKpiTargetDetailEmployee = new PstKpiTargetDetailEmployee(entKpiTargetDetailEmployee.getOID());
				pstKpiTargetDetailEmployee.setLong(FLD_KPI_TARGET_DETAIL_ID, entKpiTargetDetailEmployee.getKpiTargetDetailId());
				pstKpiTargetDetailEmployee.setLong(FLD_EMPLOYEE_ID, entKpiTargetDetailEmployee.getEmployeeId());
                                pstKpiTargetDetailEmployee.setDouble(FLD_BOBOT, entKpiTargetDetailEmployee.getBobot());
				pstKpiTargetDetailEmployee.update();
				return entKpiTargetDetailEmployee.getOID();
			}
		} catch (DBException dbe) {
			throw dbe;
		} catch (Exception e) {
			throw new DBException(new PstKpiTargetDetailEmployee(0), DBException.UNKNOWN);
		}
		return 0;
	}

	public long updateExc(Entity entity) throws Exception {
		return updateExc((KpiTargetDetailEmployee) entity);
	}

	public static synchronized long deleteExc(long oid) throws DBException {
		try {
			PstKpiTargetDetailEmployee pstKpiTargetDetailEmployee = new PstKpiTargetDetailEmployee(oid);
			pstKpiTargetDetailEmployee.delete();
		} catch (DBException dbe) {
			throw dbe;
		} catch (Exception e) {
			throw new DBException(new PstKpiTargetDetailEmployee(0), DBException.UNKNOWN);
		}
		return oid;
	}

	public long deleteExc(Entity entity) throws Exception {
		if (entity == null) {
			throw new DBException(this, DBException.RECORD_NOT_FOUND);
		}
		return deleteExc(entity.getOID());
	}

	public static synchronized long insertExc(KpiTargetDetailEmployee entKpiTargetDetailEmployee) throws DBException {
		try {
			PstKpiTargetDetailEmployee pstKpiTargetDetailEmployee = new PstKpiTargetDetailEmployee(0);
			pstKpiTargetDetailEmployee.setLong(FLD_KPI_TARGET_DETAIL_ID, entKpiTargetDetailEmployee.getKpiTargetDetailId());
			pstKpiTargetDetailEmployee.setLong(FLD_EMPLOYEE_ID, entKpiTargetDetailEmployee.getEmployeeId());
                        pstKpiTargetDetailEmployee.setDouble(FLD_BOBOT, entKpiTargetDetailEmployee.getBobot());
			pstKpiTargetDetailEmployee.insert();
			entKpiTargetDetailEmployee.setOID(pstKpiTargetDetailEmployee.getLong(FLD_KPI_TARGET_DETAIL_EMPLOYEE_ID));
		} catch (DBException dbe) {
			throw dbe;
		} catch (Exception e) {
			throw new DBException(new PstKpiTargetDetailEmployee(0), DBException.UNKNOWN);
		}
		return entKpiTargetDetailEmployee.getOID();
	}

	public long insertExc(Entity entity) throws Exception {
		return insertExc((KpiTargetDetailEmployee) entity);
	}

	public static void resultToObject(ResultSet rs, KpiTargetDetailEmployee entKpiTargetDetailEmployee) {
		try {
			entKpiTargetDetailEmployee.setOID(rs.getLong(PstKpiTargetDetailEmployee.fieldNames[PstKpiTargetDetailEmployee.FLD_KPI_TARGET_DETAIL_EMPLOYEE_ID]));
			entKpiTargetDetailEmployee.setKpiTargetDetailId(rs.getLong(PstKpiTargetDetailEmployee.fieldNames[PstKpiTargetDetailEmployee.FLD_KPI_TARGET_DETAIL_ID]));
			entKpiTargetDetailEmployee.setEmployeeId(rs.getLong(PstKpiTargetDetailEmployee.fieldNames[PstKpiTargetDetailEmployee.FLD_EMPLOYEE_ID]));
                        entKpiTargetDetailEmployee.setBobot(rs.getDouble(PstKpiTargetDetailEmployee.fieldNames[PstKpiTargetDetailEmployee.FLD_BOBOT]));
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
			String sql = "SELECT * FROM " + TBL_KPI_TARGET_DETAIL_EMPLOYEE;
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
				KpiTargetDetailEmployee entKpiTargetDetailEmployee = new KpiTargetDetailEmployee();
				resultToObject(rs, entKpiTargetDetailEmployee);
				lists.add(entKpiTargetDetailEmployee);
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
			String sql = "SELECT EMP.* FROM " + TBL_KPI_TARGET_DETAIL_EMPLOYEE+" AS EMP"
					+ " INNER JOIN "+PstKpiTargetDetail.TBL_KPI_TARGET_DETAIL+" AS DET"
					+ " ON EMP."+fieldNames[FLD_KPI_TARGET_DETAIL_ID]+"= DET."+PstKpiTargetDetail.fieldNames[PstKpiTargetDetail.FLD_KPI_TARGET_DETAIL_ID]
					+ " INNER JOIN "+PstKpiTarget.TBL_KPI_TARGET+" TARGET "
					+ " ON DET."+PstKpiTargetDetail.fieldNames[PstKpiTargetDetail.FLD_KPI_TARGET_ID]
					+ " = TARGET."+PstKpiTarget.fieldNames[PstKpiTarget.FLD_KPI_TARGET_ID];
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
				KpiTargetDetailEmployee entKpiTargetDetailEmployee = new KpiTargetDetailEmployee();
				resultToObject(rs, entKpiTargetDetailEmployee);
				lists.add(entKpiTargetDetailEmployee);
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

	public static boolean checkOID(long entKpiTargetDetailEmployeeId) {
		DBResultSet dbrs = null;
		boolean result = false;
		try {
			String sql = "SELECT * FROM " + TBL_KPI_TARGET_DETAIL_EMPLOYEE + " WHERE "
					+ PstKpiTargetDetailEmployee.fieldNames[PstKpiTargetDetailEmployee.FLD_KPI_TARGET_DETAIL_EMPLOYEE_ID] + " = " + entKpiTargetDetailEmployeeId;
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
			String sql = "SELECT COUNT(" + PstKpiTargetDetailEmployee.fieldNames[PstKpiTargetDetailEmployee.FLD_KPI_TARGET_DETAIL_EMPLOYEE_ID] + ") FROM " + TBL_KPI_TARGET_DETAIL_EMPLOYEE;
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
					KpiTargetDetailEmployee entKpiTargetDetailEmployee = (KpiTargetDetailEmployee) list.get(ls);
					if (oid == entKpiTargetDetailEmployee.getOID()) {
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
}
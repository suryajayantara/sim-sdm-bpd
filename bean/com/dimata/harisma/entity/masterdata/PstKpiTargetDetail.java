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
public class PstKpiTargetDetail extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {

	public static final String TBL_KPI_TARGET_DETAIL = "hr_kpi_target_detail";
	public static final int FLD_KPI_TARGET_DETAIL_ID = 0;
	public static final int FLD_KPI_TARGET_ID = 1;
	public static final int FLD_KPI_ID = 2;
	public static final int FLD_PERIOD = 3;
	public static final int FLD_DATE_FROM = 4;
	public static final int FLD_DATE_TO = 5;
	public static final int FLD_AMOUNT = 6;
	public static final int FLD_KPI_GROUP_ID = 7;
	public static final int FLD_WEIGHT_VALUE = 8;
	public static final int FLD_KPI_SETTING_LIST_ID = 9;
	public static final int FLD_INDEX_PERIOD = 10;

	public static String[] fieldNames = {
		"KPI_TARGET_DETAIL_ID",
		"KPI_TARGET_ID",
		"KPI_ID",
		"PERIOD",
		"DATE_FROM",
		"DATE_TO",
		"AMOUNT",
		"KPI_GROUP_ID",
		"WEIGHT_VALUE",
                "KPI_SETTING_LIST_ID",
                "INDEX_PERIOD"
	};

	public static int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_INT,
		TYPE_DATE,
		TYPE_DATE,
		TYPE_FLOAT,
		TYPE_LONG,
		TYPE_FLOAT,
		TYPE_LONG,
		TYPE_INT
	};
	
	public static final int PERIOD_BULAN = 0;
	public static final int PERIOD_TRIWULAN = 1;
	public static final int PERIOD_CATURWULAN = 2;
	public static final int PERIOD_SEMESTER = 3;
	public static final int PERIOD_TAHUN = 4;
	
	public static final String[] period = {
		"Bulanan",
		"Triwulan",
		"Caturwulan",
		"Semester",
		"Tahunan"
	};

	public PstKpiTargetDetail() {
	}

	public PstKpiTargetDetail(int i) throws DBException {
		super(new PstKpiTargetDetail());
	}

	public PstKpiTargetDetail(String sOid) throws DBException {
		super(new PstKpiTargetDetail(0));
		if (!locate(sOid)) {
			throw new DBException(this, DBException.RECORD_NOT_FOUND);
		} else {
			return;
		}
	}

	public PstKpiTargetDetail(long lOid) throws DBException {
		super(new PstKpiTargetDetail(0));
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
		return TBL_KPI_TARGET_DETAIL;
	}

	public String[] getFieldNames() {
		return fieldNames;
	}

	public int[] getFieldTypes() {
		return fieldTypes;
	}

	public String getPersistentName() {
		return new PstKpiTargetDetail().getClass().getName();
	}

	public static KpiTargetDetail fetchExc(long oid) throws DBException {
		try {
			KpiTargetDetail entKpiTargetDetail = new KpiTargetDetail();
			PstKpiTargetDetail pstKpiTargetDetail = new PstKpiTargetDetail(oid);
			entKpiTargetDetail.setOID(oid);
			entKpiTargetDetail.setKpiTargetId(pstKpiTargetDetail.getLong(FLD_KPI_TARGET_ID));
			entKpiTargetDetail.setKpiId(pstKpiTargetDetail.getLong(FLD_KPI_ID));
			entKpiTargetDetail.setPeriod(pstKpiTargetDetail.getInt(FLD_PERIOD));
			entKpiTargetDetail.setDateFrom(pstKpiTargetDetail.getDate(FLD_DATE_FROM));
			entKpiTargetDetail.setDateTo(pstKpiTargetDetail.getDate(FLD_DATE_TO));
			entKpiTargetDetail.setAmount(pstKpiTargetDetail.getdouble(FLD_AMOUNT));
			entKpiTargetDetail.setKpiGroupId(pstKpiTargetDetail.getLong(FLD_KPI_GROUP_ID));
			entKpiTargetDetail.setWeightValue(pstKpiTargetDetail.getdouble(FLD_WEIGHT_VALUE));
			entKpiTargetDetail.setIndexPeriod(pstKpiTargetDetail.getInt(FLD_INDEX_PERIOD));
			return entKpiTargetDetail;
		} catch (DBException dbe) {
			throw dbe;
		} catch (Exception e) {
			throw new DBException(new PstKpiTargetDetail(0), DBException.UNKNOWN);
		}
	}

	public long fetchExc(Entity entity) throws Exception {
		KpiTargetDetail entKpiTargetDetail = fetchExc(entity.getOID());
		entity = (Entity) entKpiTargetDetail;
		return entKpiTargetDetail.getOID();
	}

	public static synchronized long updateExc(KpiTargetDetail entKpiTargetDetail) throws DBException {
		try {
			if (entKpiTargetDetail.getOID() != 0) {
				PstKpiTargetDetail pstKpiTargetDetail = new PstKpiTargetDetail(entKpiTargetDetail.getOID());
				pstKpiTargetDetail.setLong(FLD_KPI_TARGET_ID, entKpiTargetDetail.getKpiTargetId());
				pstKpiTargetDetail.setLong(FLD_KPI_ID, entKpiTargetDetail.getKpiId());
				pstKpiTargetDetail.setInt(FLD_PERIOD, entKpiTargetDetail.getPeriod());
				pstKpiTargetDetail.setDate(FLD_DATE_FROM, entKpiTargetDetail.getDateFrom());
				pstKpiTargetDetail.setDate(FLD_DATE_TO, entKpiTargetDetail.getDateTo());
				pstKpiTargetDetail.setDouble(FLD_AMOUNT, entKpiTargetDetail.getAmount());
				pstKpiTargetDetail.setLong(FLD_KPI_GROUP_ID, entKpiTargetDetail.getKpiGroupId());
				pstKpiTargetDetail.setDouble(FLD_WEIGHT_VALUE, entKpiTargetDetail.getWeightValue());
				pstKpiTargetDetail.setInt(FLD_INDEX_PERIOD, entKpiTargetDetail.getIndexPeriod());
				pstKpiTargetDetail.update();
				return entKpiTargetDetail.getOID();
			}
		} catch (DBException dbe) {
			throw dbe;
		} catch (Exception e) {
			throw new DBException(new PstKpiTargetDetail(0), DBException.UNKNOWN);
		}
		return 0;
	}

	public long updateExc(Entity entity) throws Exception {
		return updateExc((KpiTargetDetail) entity);
	}

	public static synchronized long deleteExc(long oid) throws DBException {
		try {
			PstKpiTargetDetail pstKpiTargetDetail = new PstKpiTargetDetail(oid);
			pstKpiTargetDetail.delete();
		} catch (DBException dbe) {
			throw dbe;
		} catch (Exception e) {
			throw new DBException(new PstKpiTargetDetail(0), DBException.UNKNOWN);
		}
		return oid;
	}

	public long deleteExc(Entity entity) throws Exception {
		if (entity == null) {
			throw new DBException(this, DBException.RECORD_NOT_FOUND);
		}
		return deleteExc(entity.getOID());
	}

	public static synchronized long insertExc(KpiTargetDetail entKpiTargetDetail) throws DBException {
		try {
			PstKpiTargetDetail pstKpiTargetDetail = new PstKpiTargetDetail(0);
			pstKpiTargetDetail.setLong(FLD_KPI_TARGET_ID, entKpiTargetDetail.getKpiTargetId());
			pstKpiTargetDetail.setLong(FLD_KPI_ID, entKpiTargetDetail.getKpiId());
			pstKpiTargetDetail.setInt(FLD_PERIOD, entKpiTargetDetail.getPeriod());
			pstKpiTargetDetail.setDate(FLD_DATE_FROM, entKpiTargetDetail.getDateFrom());
			pstKpiTargetDetail.setDate(FLD_DATE_TO, entKpiTargetDetail.getDateTo());
			pstKpiTargetDetail.setDouble(FLD_AMOUNT, entKpiTargetDetail.getAmount());
                        if (entKpiTargetDetail.getKpiGroupId() > 0 ){
                            pstKpiTargetDetail.setLong(FLD_KPI_GROUP_ID, entKpiTargetDetail.getKpiGroupId());
                        }
			pstKpiTargetDetail.setDouble(FLD_WEIGHT_VALUE, entKpiTargetDetail.getWeightValue());
			pstKpiTargetDetail.setInt(FLD_INDEX_PERIOD, entKpiTargetDetail.getIndexPeriod());
                        if(entKpiTargetDetail.getKpiSettingListId() > 0){
                            pstKpiTargetDetail.setLong(FLD_KPI_SETTING_LIST_ID, entKpiTargetDetail.getKpiSettingListId());
                        }
                        pstKpiTargetDetail.insert();
			entKpiTargetDetail.setOID(pstKpiTargetDetail.getLong(FLD_KPI_TARGET_DETAIL_ID));
		} catch (DBException dbe) {
			throw dbe;
		} catch (Exception e) {
			throw new DBException(new PstKpiTargetDetail(0), DBException.UNKNOWN);
		}
		return entKpiTargetDetail.getOID();
	}

	public long insertExc(Entity entity) throws Exception {
		return insertExc((KpiTargetDetail) entity);
	}

	public static void resultToObject(ResultSet rs, KpiTargetDetail entKpiTargetDetail) {
		try {
			entKpiTargetDetail.setOID(rs.getLong(PstKpiTargetDetail.fieldNames[PstKpiTargetDetail.FLD_KPI_TARGET_DETAIL_ID]));
			entKpiTargetDetail.setKpiTargetId(rs.getLong(PstKpiTargetDetail.fieldNames[PstKpiTargetDetail.FLD_KPI_TARGET_ID]));
			entKpiTargetDetail.setKpiId(rs.getLong(PstKpiTargetDetail.fieldNames[PstKpiTargetDetail.FLD_KPI_ID]));
			entKpiTargetDetail.setPeriod(rs.getInt(PstKpiTargetDetail.fieldNames[PstKpiTargetDetail.FLD_PERIOD]));
			entKpiTargetDetail.setDateFrom(rs.getDate(PstKpiTargetDetail.fieldNames[PstKpiTargetDetail.FLD_DATE_FROM]));
			entKpiTargetDetail.setDateTo(rs.getDate(PstKpiTargetDetail.fieldNames[PstKpiTargetDetail.FLD_DATE_TO]));
			entKpiTargetDetail.setAmount(rs.getDouble(PstKpiTargetDetail.fieldNames[PstKpiTargetDetail.FLD_AMOUNT]));
			entKpiTargetDetail.setKpiGroupId(rs.getLong(PstKpiTargetDetail.fieldNames[PstKpiTargetDetail.FLD_KPI_GROUP_ID]));
			entKpiTargetDetail.setWeightValue(rs.getDouble(PstKpiTargetDetail.fieldNames[PstKpiTargetDetail.FLD_WEIGHT_VALUE]));
			entKpiTargetDetail.setKpiSettingListId(rs.getLong(PstKpiTargetDetail.fieldNames[PstKpiTargetDetail.FLD_KPI_SETTING_LIST_ID]));
			entKpiTargetDetail.setIndexPeriod(rs.getInt(PstKpiTargetDetail.fieldNames[PstKpiTargetDetail.FLD_INDEX_PERIOD]));
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
			String sql = "SELECT * FROM " + TBL_KPI_TARGET_DETAIL;
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
				KpiTargetDetail entKpiTargetDetail = new KpiTargetDetail();
				resultToObject(rs, entKpiTargetDetail);
				lists.add(entKpiTargetDetail);
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
	
	public static Vector listJoinKpi(int limitStart, int recordToGet, String whereClause, String order) {
		Vector lists = new Vector();
		DBResultSet dbrs = null;
		try {
			String sql = "SELECT * FROM " + TBL_KPI_TARGET_DETAIL+" AS DET"
					+ " INNER JOIN "+PstKPI_List.TBL_HR_KPI_LIST+" AS LST"
					+ " ON DET."+fieldNames[FLD_KPI_ID]+"="+PstKPI_List.fieldNames[PstKPI_List.FLD_KPI_LIST_ID];
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
				KpiTargetDetail entKpiTargetDetail = new KpiTargetDetail();
				resultToObject(rs, entKpiTargetDetail);
				lists.add(entKpiTargetDetail);
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

	public static boolean checkOID(long entKpiTargetDetailId) {
		DBResultSet dbrs = null;
		boolean result = false;
		try {
			String sql = "SELECT * FROM " + TBL_KPI_TARGET_DETAIL + " WHERE "
					+ PstKpiTargetDetail.fieldNames[PstKpiTargetDetail.FLD_KPI_TARGET_DETAIL_ID] + " = " + entKpiTargetDetailId;
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
			String sql = "SELECT COUNT(" + PstKpiTargetDetail.fieldNames[PstKpiTargetDetail.FLD_KPI_TARGET_DETAIL_ID] + ") FROM " + TBL_KPI_TARGET_DETAIL;
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
					KpiTargetDetail entKpiTargetDetail = (KpiTargetDetail) list.get(ls);
					if (oid == entKpiTargetDetail.getOID()) {
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

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.masterdata;

/**
 *
 * @author User
 */
import com.dimata.harisma.entity.masterdata.KpiSettingType;
import com.dimata.qdep.db.DBException;
import com.dimata.qdep.db.DBHandler;
import com.dimata.qdep.db.DBResultSet;
import com.dimata.qdep.db.I_DBInterface;
import com.dimata.qdep.db.I_DBType;
import com.dimata.qdep.entity.Entity;
import com.dimata.qdep.entity.I_PersintentExc;
import com.dimata.util.Command;
import com.dimata.util.lang.I_Language;
import java.sql.ResultSet;
import java.util.Vector;

/**
 *
 * @author Ade
 */

public class PstKpiSettingType extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {

	public static final String TBL_KPI_SETTING_TYPE = "hr_kpi_setting_type";
        public static final int FLD_KPI_SETTING_TYPE_ID = 0;
        public static final int FLD_KPI_SETTING_ID = 1;
	public static final int FLD_KPI_TYPE_ID = 2;
	public static final int FLD_KPI_GROUP_ID = 3;

	public static String[] fieldNames = {
		"KPI_SETTING_TYPE_ID",
		"KPI_SETTING_ID",
		"KPI_TYPE_ID",
		"KPI_GROUP_ID"
	};

	public static int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_LONG
	};

	public PstKpiSettingType() {
	}

	public PstKpiSettingType(int i) throws DBException {
		super(new PstKpiSettingType());
	}

	public PstKpiSettingType(String sOid) throws DBException {
		super(new PstKpiSettingType(0));
		if (!locate(sOid)) {
			throw new DBException(this, DBException.RECORD_NOT_FOUND);
		} else {
			return;
		}
	}

	public PstKpiSettingType(long lOid) throws DBException {
		super(new PstKpiSettingType(0));
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
		return TBL_KPI_SETTING_TYPE;
	}

	public String[] getFieldNames() {
		return fieldNames;
	}

	public int[] getFieldTypes() {
		return fieldTypes;
	}

	public String getPersistentName() {
		return new PstKpiSettingType().getClass().getName();
	}

	public static KpiSettingType fetchExc(long oid) throws DBException {
		try {
			KpiSettingType entKpiSettingType = new KpiSettingType();
			PstKpiSettingType pstKpiSettingType = new PstKpiSettingType(oid);
			entKpiSettingType.setOID(oid);
                        entKpiSettingType.setKpiSettingId(pstKpiSettingType.getLong(FLD_KPI_SETTING_ID));
			entKpiSettingType.setKpiTypeId(pstKpiSettingType.getLong(FLD_KPI_TYPE_ID));
			entKpiSettingType.setKpiGroupId(pstKpiSettingType.getLong(FLD_KPI_GROUP_ID));
			return entKpiSettingType;
		} catch (DBException dbe) {
			throw dbe;
		} catch (Exception e) {
			throw new DBException(new PstKpiSettingType(0), DBException.UNKNOWN);
		}
	}
        
        public static KpiSettingType fetchBySettingId(long oid) throws DBException {
		try {
			KpiSettingType entKpiSettingType = new KpiSettingType();
			PstKpiSettingType pstKpiSettingType = new PstKpiSettingType(oid);
			entKpiSettingType.setOID(oid);
                        entKpiSettingType.setKpiSettingId(pstKpiSettingType.getLong(FLD_KPI_SETTING_ID));
			entKpiSettingType.setKpiTypeId(pstKpiSettingType.getLong(FLD_KPI_TYPE_ID));
			entKpiSettingType.setKpiGroupId(pstKpiSettingType.getLong(FLD_KPI_GROUP_ID));
			return entKpiSettingType;
		} catch (DBException dbe) {
			throw dbe;
		} catch (Exception e) {
			throw new DBException(new PstKpiSettingType(0), DBException.UNKNOWN);
		}
	}

	public long fetchExc(Entity entity) throws Exception {
		KpiSettingType entKpiSettingType = fetchExc(entity.getOID());
		entity = (Entity) entKpiSettingType;
		return entKpiSettingType.getOID();
	}

	public static synchronized long updateExc(KpiSettingType entKpiSettingType) throws DBException {
		try {
			if (entKpiSettingType.getKpiSettingTypeId() != 0) {
				PstKpiSettingType pstKpiSettingType = new PstKpiSettingType(entKpiSettingType.getKpiSettingTypeId());
				pstKpiSettingType.setLong(FLD_KPI_SETTING_ID, entKpiSettingType.getKpiSettingId());
				pstKpiSettingType.setLong(FLD_KPI_TYPE_ID, entKpiSettingType.getKpiTypeId());
				pstKpiSettingType.setLong(FLD_KPI_GROUP_ID, entKpiSettingType.getKpiGroupId());
				pstKpiSettingType.update();
				return entKpiSettingType.getKpiSettingTypeId();
			}
		} catch (DBException dbe) {
			throw dbe;
		} catch (Exception e) {
			throw new DBException(new PstKpiSettingType(0), DBException.UNKNOWN);
		}
		return 0;
	}

	public long updateExc(Entity entity) throws Exception {
		return updateExc((KpiSettingType) entity);
	}

	public static synchronized long deleteExc(long oid) throws DBException {
		try {
			PstKpiSettingType pstKpiSettingType = new PstKpiSettingType(oid);
			pstKpiSettingType.delete();
		} catch (DBException dbe) {
			throw dbe;
		} catch (Exception e) {
			throw new DBException(new PstKpiSettingType(0), DBException.UNKNOWN);
		}
		return oid;
	}

	public long deleteExc(Entity entity) throws Exception {
		if (entity == null) {
			throw new DBException(this, DBException.RECORD_NOT_FOUND);
		}
		return deleteExc(entity.getOID());
	}
 
	public static synchronized long insertExc(KpiSettingType entKpiSettingType) throws DBException {
		try {
			PstKpiSettingType pstKpiSettingType = new PstKpiSettingType(0);
			pstKpiSettingType.setLong(FLD_KPI_SETTING_ID, entKpiSettingType.getKpiSettingId());
			pstKpiSettingType.setLong(FLD_KPI_TYPE_ID, entKpiSettingType.getKpiTypeId());
                        if(entKpiSettingType.getKpiGroupId() > 0){
                            pstKpiSettingType.setLong(FLD_KPI_GROUP_ID, entKpiSettingType.getKpiGroupId());
                        }
			pstKpiSettingType.insert();
			entKpiSettingType.setOID(pstKpiSettingType.getLong(FLD_KPI_SETTING_TYPE_ID));
		} catch (DBException dbe) {
			throw dbe;
		} catch (Exception e) {
			throw new DBException(new PstKpiSettingType(0), DBException.UNKNOWN);
		}
		return entKpiSettingType.getOID();
	}

	public long insertExc(Entity entity) throws Exception {
		return insertExc((KpiSettingType) entity);
	}

	public static void resultToObject(ResultSet rs, KpiSettingType entKpiSettingType) {
		try {
			entKpiSettingType.setKpiSettingTypeId(rs.getLong(PstKpiSettingType.fieldNames[PstKpiSettingType.FLD_KPI_SETTING_TYPE_ID]));
			entKpiSettingType.setKpiSettingId(rs.getLong(PstKpiSettingType.fieldNames[PstKpiSettingType.FLD_KPI_SETTING_ID]));
			entKpiSettingType.setKpiTypeId(rs.getLong(PstKpiSettingType.fieldNames[PstKpiSettingType.FLD_KPI_TYPE_ID]));
                        entKpiSettingType.setKpiGroupId(rs.getLong(PstKpiSettingType.fieldNames[PstKpiSettingType.FLD_KPI_GROUP_ID]));
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
			String sql = "SELECT * FROM " + TBL_KPI_SETTING_TYPE;
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
				KpiSettingType entKpiSettingType = new KpiSettingType();
				resultToObject(rs, entKpiSettingType);
				lists.add(entKpiSettingType);
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
        
        public static String[] arrayListKpiSettingType(long oid_kpi_setting) {
        Vector<String> listsToArray = new Vector();
        String[] res = null;
        DBResultSet dbrs = null;
        try {
            
            String sql = "SELECT DISTINCT\n" +
                        "  (KpiType.`KPI_TYPE_ID`) AS KPI_TYPE_ID \n" +
                        "FROM\n" +
                        "  `hr_kpi_type` KpiType\n" +
                        "  INNER JOIN `hr_kpi_setting_type` AS map\n" +
                        "    ON KpiType.`KPI_TYPE_ID` = map.`KPI_TYPE_ID`\n" +
                        " WHERE map.kpi_setting_id = "+ oid_kpi_setting;
                           
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                String oidKpiType = rs.getString(PstKPI_Type.fieldNames[PstKPI_Type.FLD_KPI_TYPE_ID]);
                listsToArray.add(oidKpiType);
            }
            rs.close();
            return listsToArray.toArray(new String[listsToArray.size()]);
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return new String[0];
    }

	public static boolean checkOID(long entKpiSettingTypeId) {
		DBResultSet dbrs = null;
		boolean result = false;
		try {
			String sql = "SELECT * FROM " + TBL_KPI_SETTING_TYPE + " WHERE "
					+ PstKpiSettingType.fieldNames[PstKpiSettingType.FLD_KPI_SETTING_TYPE_ID] + " = " + entKpiSettingTypeId;
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
			String sql = "SELECT COUNT(" + PstKpiSettingType.fieldNames[PstKpiSettingType.FLD_KPI_SETTING_TYPE_ID] + ") FROM " + TBL_KPI_SETTING_TYPE;
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
					KpiSettingType entKpiSettingType = (KpiSettingType) list.get(ls);
					if (oid == entKpiSettingType.getOID()) {
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
        /*ini berfungsi untuk delete berdasarkan where nya, kalau ini berarti berdasarkan oid kpi setting`*/
        public static long deleteByKpiSetting(long kpi_setting_id) {
        DBResultSet dbrs = null;
        try {
            String sql = "DELETE FROM " + PstKpiSettingType.TBL_KPI_SETTING_TYPE
                    + " WHERE " + PstKpiSettingType.fieldNames[PstKpiSettingType.FLD_KPI_SETTING_ID]
                    + " = '" + kpi_setting_id + "'";

            int status = DBHandler.execUpdate(sql);
            return kpi_setting_id;
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }

        return 0;
        
    }
        public static long deleteByKpiGroup(long kpi_group_id) {
        DBResultSet dbrs = null;
        try {
            String sql = "DELETE FROM " + PstKpiSettingType.TBL_KPI_SETTING_TYPE
                    + " WHERE " + PstKpiSettingType.fieldNames[PstKpiSettingType.FLD_KPI_GROUP_ID]
                    + " = '" + kpi_group_id + "'";

            int status = DBHandler.execUpdate(sql);
            return kpi_group_id;
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }

        return 0;
        
    }
 
}

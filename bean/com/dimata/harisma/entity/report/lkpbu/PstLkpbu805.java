/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.report.lkpbu;

import com.dimata.harisma.entity.employee.PstEmployee;
import com.dimata.harisma.entity.masterdata.PstEducation;
import com.dimata.harisma.entity.masterdata.PstEmpCategory;
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
public class PstLkpbu805 extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {

    public static final String TBL_LKPBU_805 = "hr_report_lkpbu_805";
    public static final int FLD_LKPBU_805_ID = 0;
    public static final int FLD_JENIS_PEKERJAAN = 1;
    public static final int FLD_JENIS_PENDIDIKAN = 2;
    public static final int FLD_STATUS_PEGAWAI = 3;
    public static final int FLD_LKPBU_805_YEAR_REALISASI = 4;
    public static final int FLD_LKPBU_805_YEAR_PREDIKSI_1 = 5;
    public static final int FLD_LKPBU_805_YEAR_PREDIKSI_2 = 6;
    public static final int FLD_LKPBU_805_YEAR_PREDIKSI_3 = 7;
    public static final int FLD_LKPBU_805_YEAR_PREDIKSI_4 = 8;
    public static final int FLD_LKPBU_805_START_DATE = 9;
    public static final int FLD_YEAR = 10;
    public static final int FLD_CODE = 11;
    public static String[] fieldNames = {
        "LKPBU_805_ID",
        "JENIS_PEKERJAAN",
        "JENIS_PENDIDIKAN",
        "STATUS_PEGAWAI",
        "LKPBU_805_YEAR_REALISASI",
        "LKPBU_805_YEAR_PREDIKSI_1",
        "LKPBU_805_YEAR_PREDIKSI_2",
        "LKPBU_805_YEAR_PREDIKSI_3",
        "LKPBU_805_YEAR_PREDIKSI_4",
        "LKPBU_805_START_DATE",
        "YEAR",
        "CODE"
    };
    public static int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_INT,
        TYPE_INT,
        TYPE_INT,
        TYPE_INT,
        TYPE_INT,
        TYPE_DATE,
        TYPE_INT,
        TYPE_STRING
    };

    public PstLkpbu805() {
    }

    public PstLkpbu805(int i) throws DBException {
        super(new PstLkpbu805());
    }

    public PstLkpbu805(String sOid) throws DBException {
        super(new PstLkpbu805(0));
        if (!locate(sOid)) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public PstLkpbu805(long lOid) throws DBException {
        super(new PstLkpbu805(0));
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
        return TBL_LKPBU_805;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new PstLkpbu805().getClass().getName();
    }

    public static Lkpbu805 fetchExc(long oid) throws DBException {
        try {
            Lkpbu805 entLkpbu805 = new Lkpbu805();
            PstLkpbu805 pstLkpbu805 = new PstLkpbu805(oid);
            entLkpbu805.setOID(oid);
            entLkpbu805.setJenisPekerjaan(pstLkpbu805.getString(FLD_JENIS_PEKERJAAN));
            entLkpbu805.setJenisPendidikan(pstLkpbu805.getString(FLD_JENIS_PENDIDIKAN));
            entLkpbu805.setStatusPegawai(pstLkpbu805.getString(FLD_STATUS_PEGAWAI));
            entLkpbu805.setLkpbu805YearRealisasi(pstLkpbu805.getInt(FLD_LKPBU_805_YEAR_REALISASI));
            entLkpbu805.setLkpbu805YearPrediksi1(pstLkpbu805.getInt(FLD_LKPBU_805_YEAR_PREDIKSI_1));
            entLkpbu805.setLkpbu805YearPrediksi2(pstLkpbu805.getInt(FLD_LKPBU_805_YEAR_PREDIKSI_2));
            entLkpbu805.setLkpbu805YearPrediksi3(pstLkpbu805.getInt(FLD_LKPBU_805_YEAR_PREDIKSI_3));
            entLkpbu805.setLkpbu805YearPrediksi4(pstLkpbu805.getInt(FLD_LKPBU_805_YEAR_PREDIKSI_4));
            entLkpbu805.setLkpbu805StartDate(pstLkpbu805.getDate(FLD_LKPBU_805_START_DATE));
            entLkpbu805.setYear(pstLkpbu805.getInt(FLD_YEAR));
            entLkpbu805.setCode(pstLkpbu805.getString(FLD_CODE));
            return entLkpbu805;
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstLkpbu805(0), DBException.UNKNOWN);
        }
    }

    public long fetchExc(Entity entity) throws Exception {
        Lkpbu805 entLkpbu805 = fetchExc(entity.getOID());
        entity = (Entity) entLkpbu805;
        return entLkpbu805.getOID();
    }

    public static synchronized long updateExc(Lkpbu805 entLkpbu805) throws DBException {
        try {
            if (entLkpbu805.getOID() != 0) {
                PstLkpbu805 pstLkpbu805 = new PstLkpbu805(entLkpbu805.getOID());
                pstLkpbu805.setString(FLD_JENIS_PEKERJAAN, entLkpbu805.getJenisPekerjaan());
                pstLkpbu805.setString(FLD_JENIS_PENDIDIKAN, entLkpbu805.getJenisPendidikan());
                pstLkpbu805.setString(FLD_STATUS_PEGAWAI, entLkpbu805.getStatusPegawai());
                pstLkpbu805.setInt(FLD_LKPBU_805_YEAR_REALISASI, entLkpbu805.getLkpbu805YearRealisasi());
                pstLkpbu805.setInt(FLD_LKPBU_805_YEAR_PREDIKSI_1, entLkpbu805.getLkpbu805YearPrediksi1());
                pstLkpbu805.setInt(FLD_LKPBU_805_YEAR_PREDIKSI_2, entLkpbu805.getLkpbu805YearPrediksi2());
                pstLkpbu805.setInt(FLD_LKPBU_805_YEAR_PREDIKSI_3, entLkpbu805.getLkpbu805YearPrediksi3());
                pstLkpbu805.setInt(FLD_LKPBU_805_YEAR_PREDIKSI_4, entLkpbu805.getLkpbu805YearPrediksi4());
                pstLkpbu805.setDate(FLD_LKPBU_805_START_DATE, entLkpbu805.getLkpbu805StartDate());
                pstLkpbu805.setInt(FLD_YEAR, entLkpbu805.getYear());
                pstLkpbu805.setString(FLD_CODE, entLkpbu805.getCode());
                pstLkpbu805.update();
                return entLkpbu805.getOID();
            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstLkpbu805(0), DBException.UNKNOWN);
        }
        return 0;
    }

    public long updateExc(Entity entity) throws Exception {
        return updateExc((Lkpbu805) entity);
    }

    public static synchronized long deleteExc(long oid) throws DBException {
        try {
            PstLkpbu805 pstLkpbu805 = new PstLkpbu805(oid);
            pstLkpbu805.delete();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstLkpbu805(0), DBException.UNKNOWN);
        }
        return oid;
    }

    public long deleteExc(Entity entity) throws Exception {
        if (entity == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(entity.getOID());
    }

    public static synchronized long insertExc(Lkpbu805 entLkpbu805) throws DBException {
        try {
            PstLkpbu805 pstLkpbu805 = new PstLkpbu805(0);
            pstLkpbu805.setString(FLD_JENIS_PEKERJAAN, entLkpbu805.getJenisPekerjaan());
            pstLkpbu805.setString(FLD_JENIS_PENDIDIKAN, entLkpbu805.getJenisPendidikan());
            pstLkpbu805.setString(FLD_STATUS_PEGAWAI, entLkpbu805.getStatusPegawai());
            pstLkpbu805.setInt(FLD_LKPBU_805_YEAR_REALISASI, entLkpbu805.getLkpbu805YearRealisasi());
            pstLkpbu805.setInt(FLD_LKPBU_805_YEAR_PREDIKSI_1, entLkpbu805.getLkpbu805YearPrediksi1());
            pstLkpbu805.setInt(FLD_LKPBU_805_YEAR_PREDIKSI_2, entLkpbu805.getLkpbu805YearPrediksi2());
            pstLkpbu805.setInt(FLD_LKPBU_805_YEAR_PREDIKSI_3, entLkpbu805.getLkpbu805YearPrediksi3());
            pstLkpbu805.setInt(FLD_LKPBU_805_YEAR_PREDIKSI_4, entLkpbu805.getLkpbu805YearPrediksi4());
            pstLkpbu805.setDate(FLD_LKPBU_805_START_DATE, entLkpbu805.getLkpbu805StartDate());
            pstLkpbu805.setInt(FLD_YEAR, entLkpbu805.getYear());
            pstLkpbu805.setString(FLD_CODE, entLkpbu805.getCode());
            pstLkpbu805.insert();
            entLkpbu805.setOID(pstLkpbu805.getlong(FLD_LKPBU_805_ID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstLkpbu805(0), DBException.UNKNOWN);
        }
        return entLkpbu805.getOID();
    }

    public long insertExc(Entity entity) throws Exception {
        return insertExc((Lkpbu805) entity);
    }
    
    public static Vector listAll() {
        return list(0, 500, "", "");
    }
    
    public static Vector list(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        
        try {
            String sql = "SELECT * FROM " + TBL_LKPBU_805;
            if(whereClause != null && whereClause.length() > 0)
                sql = sql + " WHERE " + whereClause;
            if(order != null && order.length() > 0)
                sql = sql + " ORDER BY " + order;
            if(limitStart == 0 && recordToGet == 0)
                sql = sql + "";
            else
                sql = sql + " LIMIT " + limitStart + "," + recordToGet;
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while(rs.next()) {
                Lkpbu805 lkpbu805 = new Lkpbu805();
                resultToObject(rs, lkpbu805);
                lists.add(lkpbu805);
            }
            rs.close();
            return lists;
        } catch(Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return new Vector();
    }
    
    public static void resultToObject(ResultSet rs, Lkpbu805 entLkpbu805) {
        try {
            entLkpbu805.setOID(rs.getLong(PstLkpbu805.fieldNames[PstLkpbu805.FLD_LKPBU_805_ID]));
            entLkpbu805.setJenisPekerjaan(rs.getString(PstLkpbu805.fieldNames[PstLkpbu805.FLD_JENIS_PEKERJAAN]));
            entLkpbu805.setJenisPendidikan(rs.getString(PstLkpbu805.fieldNames[PstLkpbu805.FLD_JENIS_PENDIDIKAN]));
            entLkpbu805.setStatusPegawai(rs.getString(PstLkpbu805.fieldNames[PstLkpbu805.FLD_STATUS_PEGAWAI]));
            entLkpbu805.setLkpbu805YearRealisasi(rs.getInt(PstLkpbu805.fieldNames[PstLkpbu805.FLD_LKPBU_805_YEAR_REALISASI]));
            entLkpbu805.setLkpbu805YearPrediksi1(rs.getInt(PstLkpbu805.fieldNames[PstLkpbu805.FLD_LKPBU_805_YEAR_PREDIKSI_1]));
            entLkpbu805.setLkpbu805YearPrediksi2(rs.getInt(PstLkpbu805.fieldNames[PstLkpbu805.FLD_LKPBU_805_YEAR_PREDIKSI_2]));
            entLkpbu805.setLkpbu805YearPrediksi3(rs.getInt(PstLkpbu805.fieldNames[PstLkpbu805.FLD_LKPBU_805_YEAR_PREDIKSI_3]));
            entLkpbu805.setLkpbu805YearPrediksi4(rs.getInt(PstLkpbu805.fieldNames[PstLkpbu805.FLD_LKPBU_805_YEAR_PREDIKSI_4]));
            entLkpbu805.setYear(rs.getInt(PstLkpbu805.fieldNames[PstLkpbu805.FLD_YEAR]));
            entLkpbu805.setCode(rs.getString(PstLkpbu805.fieldNames[PstLkpbu805.FLD_CODE]));
        } catch (Exception e) {
        }
    }
    
    public static boolean checkOID(long lkpbuId) {
        DBResultSet dbrs = null;
        boolean result = false;
        
        try {
            String sql = "SELECT * FROM " + TBL_LKPBU_805 + " WHERE " +
                            PstLkpbu805.fieldNames[PstLkpbu805.FLD_LKPBU_805_ID] +
                            " = " + lkpbuId;
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            
            while(rs.next()) {
                result = true;
            }
            rs.close();
        } catch(Exception e) {
            System.out.println("err : " + e.toString());
        } finally {
            DBResultSet.close(dbrs);
            return result;
        }
    }
    
    public static int getCount(String whereClause){
		com.dimata.qdep.db.DBResultSet dbrs = null;
		try {
			String sql = "SELECT COUNT("+ PstLkpbu805.fieldNames[PstLkpbu805.FLD_LKPBU_805_ID] + ") FROM " + TBL_LKPBU_805;
			if(whereClause != null && whereClause.length() > 0)
				sql = sql + " WHERE " + whereClause;

			dbrs = com.dimata.qdep.db.DBHandler.execQueryResult(sql);
			ResultSet rs = dbrs.getResultSet();

			int count = 0;
			while(rs.next()) { count = rs.getInt(1); }

			rs.close();
			return count;
		}catch(Exception e) {
			return 0;
		}finally {
			com.dimata.qdep.db.DBResultSet.close(dbrs);
		}
	}
    
    public static long getLkpbu805Id(String code, int year){
        long oid = 0;
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT * FROM "+ TBL_LKPBU_805
                        + " WHERE "+PstLkpbu805.fieldNames[PstLkpbu805.FLD_CODE]+"='"+code+"'"
                        + " AND "+PstLkpbu805.fieldNames[PstLkpbu805.FLD_YEAR]+"="+year;
            System.out.println("SQL Lkpbu805:"+sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                oid = rs.getLong(PstLkpbu805.fieldNames[PstLkpbu805.FLD_LKPBU_805_ID]);
            }
            rs.close();
            return oid;
        } catch (Exception exc){
            System.out.println(exc);
        } finally {
            DBResultSet.close(dbrs);
        }
        return oid;
    }
}

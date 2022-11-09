/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.report.lkpbu;

import com.dimata.harisma.entity.employee.CareerPath;
import com.dimata.harisma.entity.employee.EmpEducation;
import com.dimata.harisma.entity.employee.Employee;
import com.dimata.harisma.entity.employee.PstCareerPath;
import com.dimata.harisma.entity.employee.PstEmpEducation;
import com.dimata.harisma.entity.employee.PstEmployee;
import com.dimata.harisma.entity.employee.PstTrainingActivityActual;
import com.dimata.harisma.entity.masterdata.Division;
import com.dimata.harisma.entity.masterdata.Education;
import com.dimata.harisma.entity.masterdata.EmpCategory;
import com.dimata.harisma.entity.masterdata.Position;
import com.dimata.harisma.entity.masterdata.PstCompany;
import com.dimata.harisma.entity.masterdata.PstDivision;
import com.dimata.harisma.entity.masterdata.PstEducation;
import com.dimata.harisma.entity.masterdata.PstEmpCategory;
import com.dimata.harisma.entity.masterdata.PstLevel;
import com.dimata.harisma.entity.masterdata.PstPosition;
import com.dimata.harisma.entity.masterdata.PstResignedReason;
import com.dimata.harisma.entity.masterdata.PstTrainType;
import com.dimata.harisma.entity.masterdata.ResignedReason;
import com.dimata.qdep.db.DBException;
import com.dimata.qdep.db.DBHandler;
import com.dimata.qdep.db.DBResultSet;
import com.dimata.qdep.db.I_DBInterface;
import com.dimata.qdep.db.I_DBType;
import com.dimata.qdep.entity.Entity;
import com.dimata.qdep.entity.I_PersintentExc;
import com.dimata.system.entity.PstSystemProperty;
import com.dimata.util.Formater;
import com.dimata.util.lang.I_Language;
import java.sql.ResultSet;
import java.sql.Struct;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.List;
import java.util.Vector;

/**
 *
 * @author khirayinnura
 */
public class PstLkpbu extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {
    
    public static final String TBL_LKPBU_801 = "hr_report_lkpbu_801";
    public static final int FLD_LKPBU_801_ID = 0;
    public static final int FLD_EMPLOYEE_ID = 1;
    public static final int FLD_NO_SURAT_PELAPORAN = 2;
    public static final int FLD_TANGGAL_SURAT_PELAPORAN = 3;
    public static final int FLD_NO_SK = 4;
    public static final int FLD_TANGGAL_SK = 5;
    public static final int FLD_NO_SK_PEMBERHENTIAN = 6;
    public static final int FLD_TANGGAL_SK_PEMBERHENTIAN = 7;
    public static final int FLD_KETERANGAN = 8;
    public static final int FLD_PERIOD_ID = 9;
    public static final int FLD_POSITION = 10;
    public static String[] fieldNames = {
        "LKPBU_801_ID",
        "EMPLOYEE_ID",
        "NO_SURAT_PELAPORAN",
        "TANGGAL_SURAT_PELAPORAN",
        "NO_SK",
        "TANGGAL_SK",
        "NO_SK_PEMBERHENTIAN",
        "TANGGAL_SK_PEMBERHENTIAN",
        "KETERANGAN",
        "PERIOD_ID",
        "POSITION"
    };
    public static int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_LONG,
        TYPE_STRING
    };
    
    public PstLkpbu() {
    }
    
    public PstLkpbu(int i) throws DBException {
        super(new PstLkpbu());
    }
    
    public PstLkpbu(String sOid) throws DBException {
        super(new PstLkpbu(0));
        if (!locate(sOid)) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public PstLkpbu(long lOid) throws DBException {
        super(new PstLkpbu(0));
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
        return TBL_LKPBU_801;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new PstLkpbu().getClass().getName();
    }

    public static Lkpbu fetchExc(long oid) throws DBException {
        try {
            Lkpbu entLkpbu = new Lkpbu();
            PstLkpbu pstLkpbu = new PstLkpbu(oid);
            entLkpbu.setOID(oid);
            entLkpbu.setEmployeeId(pstLkpbu.getLong(FLD_EMPLOYEE_ID));
            entLkpbu.setNoSuratPelaporan(pstLkpbu.getString(FLD_NO_SURAT_PELAPORAN));
            entLkpbu.setTanggalSuratPelaporan(pstLkpbu.getString(FLD_TANGGAL_SURAT_PELAPORAN));
            entLkpbu.setNoSK(pstLkpbu.getString(FLD_NO_SK));
            entLkpbu.setTanggalSK(pstLkpbu.getString(FLD_TANGGAL_SK));
            entLkpbu.setNoSKPemberhentian(pstLkpbu.getString(FLD_NO_SK_PEMBERHENTIAN));
            entLkpbu.setTanggalSKPemberhentian(pstLkpbu.getString(FLD_TANGGAL_SK_PEMBERHENTIAN));
            entLkpbu.setKeterangan(pstLkpbu.getString(FLD_KETERANGAN));
            entLkpbu.setPeriodId(pstLkpbu.getLong(FLD_PERIOD_ID));
            entLkpbu.setPositionName(pstLkpbu.getString(FLD_POSITION));
            return entLkpbu;
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstLkpbu(0), DBException.UNKNOWN);
        }
    }

    public long fetchExc(Entity entity) throws Exception {
        Lkpbu entLkpbu = fetchExc(entity.getOID());
        entity = (Entity) entLkpbu;
        return entLkpbu.getOID();
    }

    public static synchronized long updateExc(Lkpbu entLkpbu) throws DBException {
        try {
            if (entLkpbu.getOID() != 0) {
                PstLkpbu pstLkpbu = new PstLkpbu(entLkpbu.getOID());
                pstLkpbu.setLong(FLD_EMPLOYEE_ID, entLkpbu.getEmployeeId());
                pstLkpbu.setString(FLD_NO_SURAT_PELAPORAN, entLkpbu.getNoSuratPelaporan());
                pstLkpbu.setString(FLD_TANGGAL_SURAT_PELAPORAN, entLkpbu.getTanggalSuratPelaporan());
                pstLkpbu.setString(FLD_NO_SK, entLkpbu.getNoSK());
                pstLkpbu.setString(FLD_TANGGAL_SK, entLkpbu.getTanggalSK());
                pstLkpbu.setString(FLD_NO_SK_PEMBERHENTIAN, entLkpbu.getNoSKPemberhentian());
                pstLkpbu.setString(FLD_TANGGAL_SK_PEMBERHENTIAN, entLkpbu.getTanggalSKPemberhentian());
                pstLkpbu.setString(FLD_KETERANGAN, entLkpbu.getKeterangan());                
                pstLkpbu.setLong(FLD_PERIOD_ID, entLkpbu.getPeriodId());
                pstLkpbu.setString(FLD_POSITION, entLkpbu.getPositionName());
                pstLkpbu.update();
                return entLkpbu.getOID();
            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstLkpbu(0), DBException.UNKNOWN);
        }
        return 0;
    }

    public long updateExc(Entity entity) throws Exception {
        return updateExc((Lkpbu) entity);
    }

    public static synchronized long deleteExc(long oid) throws DBException {
        try {
            PstLkpbu pstLkpbu = new PstLkpbu(oid);
            pstLkpbu.delete();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstLkpbu(0), DBException.UNKNOWN);
        }
        return oid;
    }

    public long deleteExc(Entity entity) throws Exception {
        if (entity == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(entity.getOID());
    }

    public static synchronized long insertExc(Lkpbu entLkpbu) throws DBException {
        try {
            PstLkpbu pstLkpbu = new PstLkpbu(0);
            pstLkpbu.setLong(FLD_EMPLOYEE_ID, entLkpbu.getEmployeeId());
            pstLkpbu.setString(FLD_NO_SURAT_PELAPORAN, entLkpbu.getNoSuratPelaporan());
            pstLkpbu.setString(FLD_TANGGAL_SURAT_PELAPORAN, entLkpbu.getTanggalSuratPelaporan());
            pstLkpbu.setString(FLD_NO_SK, entLkpbu.getNoSK());
            pstLkpbu.setString(FLD_TANGGAL_SK, entLkpbu.getTanggalSK());
            pstLkpbu.setString(FLD_NO_SK_PEMBERHENTIAN, entLkpbu.getNoSKPemberhentian());
            pstLkpbu.setString(FLD_TANGGAL_SK_PEMBERHENTIAN, entLkpbu.getTanggalSKPemberhentian());
            pstLkpbu.setString(FLD_KETERANGAN, entLkpbu.getKeterangan());            
            pstLkpbu.setLong(FLD_PERIOD_ID, entLkpbu.getPeriodId());
            pstLkpbu.setString(FLD_POSITION, entLkpbu.getPositionName());
            pstLkpbu.insert();
            entLkpbu.setOID(pstLkpbu.getLong(FLD_LKPBU_801_ID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstLkpbu(0), DBException.UNKNOWN);
        }
        return entLkpbu.getOID();
    }

    public long insertExc(Entity entity) throws Exception {
        return insertExc((Lkpbu) entity);
    }

    public static Vector listAll() {
        return list(0, 500, "", "");
    }

    public static Vector list(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT * FROM " + TBL_LKPBU_801;
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
                Lkpbu lkpbu = new Lkpbu();
                resultToObject(rs, lkpbu);
                lists.add(lkpbu);
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
    
    public static void resultToObject(ResultSet rs, Lkpbu entLkpbu) {
        try {
            entLkpbu.setOID(rs.getLong(PstLkpbu.fieldNames[PstLkpbu.FLD_LKPBU_801_ID]));
            entLkpbu.setEmployeeId(rs.getLong(PstLkpbu.fieldNames[PstLkpbu.FLD_EMPLOYEE_ID]));
            entLkpbu.setNoSuratPelaporan(rs.getString(PstLkpbu.fieldNames[PstLkpbu.FLD_NO_SURAT_PELAPORAN]));
            entLkpbu.setTanggalSuratPelaporan(rs.getString(PstLkpbu.fieldNames[PstLkpbu.FLD_TANGGAL_SURAT_PELAPORAN]));
            entLkpbu.setNoSK(rs.getString(PstLkpbu.fieldNames[PstLkpbu.FLD_NO_SK]));
            entLkpbu.setTanggalSK(rs.getString(PstLkpbu.fieldNames[PstLkpbu.FLD_TANGGAL_SK]));
            entLkpbu.setNoSKPemberhentian(rs.getString(PstLkpbu.fieldNames[PstLkpbu.FLD_NO_SK_PEMBERHENTIAN]));
            entLkpbu.setTanggalSKPemberhentian(rs.getString(PstLkpbu.fieldNames[PstLkpbu.FLD_TANGGAL_SK_PEMBERHENTIAN]));
            entLkpbu.setKeterangan(rs.getString(PstLkpbu.fieldNames[PstLkpbu.FLD_KETERANGAN]));
            entLkpbu.setPeriodId(rs.getLong(PstLkpbu.fieldNames[PstLkpbu.FLD_PERIOD_ID]));
            entLkpbu.setPositionName(rs.getString(PstLkpbu.fieldNames[PstLkpbu.FLD_POSITION]));
        } catch (Exception e) {
        }
    }

    public static Vector getDataFiltering(Vector listLkpbu) {
        
        Vector lists = new Vector();
        String codeStatus = "";
        String codeJabatan = "";
        String codeEdu = "";
        int umurPre1 = 0;
        int umurPre2 = 0;
        int umurPre3 = 0;
        int umurPre4 = 0;
        int pensiun = 0;
        int totalRealisasi = 0;

        for(int i = 0; i < listLkpbu.size(); i++) {
            Lkpbu lkpbu = (Lkpbu)listLkpbu.get(i);
            Vector rowx = new Vector(1,1);
            if(i == 0){
                codeJabatan = lkpbu.getEmpLevelCode();
                codeEdu = lkpbu.getEmpEduCode();
                codeStatus = lkpbu.getEmpCategoryNameCode();
            }
            
            if( lkpbu.getEmpCategoryNameCode().equals(codeStatus) && lkpbu.getEmpLevelCode().equals(codeJabatan) && 
                    lkpbu.getEmpEduCode().equals(codeEdu)){
                
                totalRealisasi++;
                
                if(lkpbu.getEmpUmur() == 54){
                    umurPre1++;
                } else if(lkpbu.getEmpUmur() == 53){
                    umurPre2++;
                } else if(lkpbu.getEmpUmur() == 52){
                    umurPre3++;
                } else if(lkpbu.getEmpUmur() == 51){
                    umurPre4++;
                } else if(lkpbu.getEmpUmur() >= 55){
                    pensiun++;
                } else {
                    
                }
                
                 if(i == ( listLkpbu.size()-1) ){
                        rowx.add(lkpbu.getEmpLevelCode());
                        codeEdu = lkpbu.getEmpEduCode();
                        int jml = codeEdu.length();
                        if(jml == 1){
                            rowx.add("0"+codeEdu);
                        } else {
                            rowx.add(""+codeEdu);
                        }
                        rowx.add(lkpbu.getEmpCategoryNameCode());
                        rowx.add(totalRealisasi);
                        int Prediksi1 = totalRealisasi - umurPre1;
                        rowx.add(Prediksi1);
                        int Prediksi2 = totalRealisasi - umurPre2;
                        rowx.add(Prediksi2);
                        int Prediksi3 = totalRealisasi - umurPre3;
                        rowx.add(Prediksi3);
                        int Prediksi4 = totalRealisasi - umurPre4;
                        rowx.add(Prediksi4);
                        
                        lists.add(rowx);
                    }
                                                 
            } else {
                rowx.add(codeJabatan);
                
                int jml = codeEdu.length();
                if(jml == 1){
                    rowx.add("0"+codeEdu);
                } else {
                    rowx.add(""+codeEdu);
                }                
                
                rowx.add(codeStatus);
                rowx.add(totalRealisasi);
                int Prediksi1 = (totalRealisasi - pensiun) - umurPre1;
                rowx.add(Prediksi1);
                int Prediksi2 = (totalRealisasi - pensiun) - umurPre2;
                rowx.add(Prediksi2);
                int Prediksi3 = (totalRealisasi - pensiun) - umurPre3;
                rowx.add(Prediksi3);
                int Prediksi4 = (totalRealisasi - pensiun) - umurPre4;
                rowx.add(Prediksi4);
                        
                codeJabatan = lkpbu.getEmpLevelCode();
                codeEdu = lkpbu.getEmpEduCode();
                codeStatus = lkpbu.getEmpCategoryNameCode();
                
                totalRealisasi=0;
                umurPre1 = 0;
                umurPre2 = 0;
                umurPre3 = 0;
                umurPre4 = 0;
                pensiun = 0;
                
                i--;
                                
                lists.add(rowx);
            } 
    }
        
        return lists;
    
    }
    
    /*
     * SELECT hr_emp_category.CODE AS category_code, BIRTH_DATE, hr_level.CODE AS level_code,  MAX(hr_education.EDUCATION_LEVEL) AS EDU_LEVEL, SEX FROM hr_employee
        INNER JOIN hr_emp_category ON hr_employee.EMP_CATEGORY_ID = hr_emp_category.EMP_CATEGORY_ID
        INNER JOIN hr_level ON hr_employee.LEVEL_ID = hr_level.LEVEL_ID
        INNER JOIN hr_emp_education ON hr_employee.EMPLOYEE_ID=hr_emp_education.EMPLOYEE_ID
        INNER JOIN hr_education ON hr_emp_education.EDUCATION_ID=hr_education.EDUCATION_ID
        WHERE hr_employee.COMMENCING_DATE LIKE '%2014%' 
        GROUP BY hr_employee.employee_id
        ORDER BY category_code, level_code, EDU_LEVEL;
     *
     */
    public static Vector listEmployeeJabatan(/*dedy_20150904 int whereYear*/) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT hr_emp_category."+PstEmpCategory.fieldNames[PstEmpCategory.FLD_CODE]+" AS category_code, BIRTH_DATE, hr_level."+PstLevel.fieldNames[PstLevel.FLD_CODE]+
                    " AS level_code,  MAX(hr_education."+PstEducation.fieldNames[PstEducation.FLD_EDUCATION_LEVEL]+") AS EDU_LEVEL, SEX"+
                    " FROM hr_employee"+
                    " INNER JOIN hr_emp_category ON hr_employee.EMP_CATEGORY_ID = hr_emp_category.EMP_CATEGORY_ID"+
                    " INNER JOIN hr_level ON hr_employee.LEVEL_ID = hr_level.LEVEL_ID"+
                    " INNER JOIN hr_emp_education ON hr_employee.EMPLOYEE_ID=hr_emp_education.EMPLOYEE_ID"+
                    " INNER JOIN hr_education ON hr_emp_education.EDUCATION_ID=hr_education.EDUCATION_ID"+
                    /* dedy_20150904 " WHERE hr_employee.COMMENCING_DATE LIKE '%"+whereYear+"%'"+ */ 
                    " GROUP BY hr_employee.employee_id"+
                    " ORDER BY category_code, level_code, EDU_LEVEL";
           
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                Lkpbu lkpbu = new Lkpbu();
                resultToObjectJabatan(rs, lkpbu);
                lists.add(lkpbu);
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
    
    /*
     * SELECT resign.RESIGNED_CODE, lvl.CODE AS level_code, SEX FROM hr_employee AS emp
        INNER JOIN hr_resigned_reason AS resign ON emp.RESIGNED_REASON_ID = resign.RESIGNED_REASON_ID
        INNER JOIN hr_level AS lvl ON emp.LEVEL_ID = lvl.LEVEL_ID
WHERE emp.RESIGNED_DATE LIKE '%2015%' 
        GROUP BY emp.employee_id
        ORDER BY resign.RESIGNED_CODE, level_code;
     */
    
    public static Vector listEmployeePensiun(int whereYear) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql ="SELECT " +
                        "emp.`EMPLOYEE_ID`," +
                        "res.`RESIGNED_CODE`," +
                        "pos.`JENIS_JABATAN`," +
                        "emp.`SEX`" +
                        "FROM " +
                        "hr_employee emp " +
                        "INNER JOIN `hr_work_history_now` cp " +
                        "ON emp.`EMPLOYEE_ID` = cp.`EMPLOYEE_ID` " +
                        "INNER JOIN hr_position pos " +
                        "ON cp.`POSITION_ID` = pos.`POSITION_ID` " +
                        "INNER JOIN hr_resigned_reason res " +
                        "ON emp.`RESIGNED_REASON_ID` = res.`RESIGNED_REASON_ID` " +
                        "WHERE emp.`RESIGNED_DATE` LIKE '%"+whereYear+"%' " +
                        "AND '"+whereYear+"-01-01' BETWEEN cp.work_from AND cp.work_to " +
                        "AND cp.history_group != 1 " +
                        "GROUP BY emp.employee_id " +
                        "ORDER BY emp.employee_id";
           
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                Lkpbu lkpbu = new Lkpbu();
                resultToObjectPensiun(rs, lkpbu);
                lists.add(lkpbu);
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
    
    /*
     * lkpbu 806
      SELECT
        tt.CODE,
        YEAR(taa.DATE),
        taa.ATENDEES
      FROM hr_training_activity_actual AS taa
        INNER JOIN hr_training AS t
          ON taa.TRAINING_ID = t.TRAINING_ID
        INNER JOIN hr_training_type AS tt
          ON t.TYPE = tt.TYPE_ID
      WHERE YEAR(TAA.DATE) = 2015
      ORDER BY tt.CODE;
     */
    public static Vector listTrainingAtt(int whereYear) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT t.CODE, SUM(taa.ATENDEES) AS ATENDEES FROM hr_training_activity_actual AS taa " +
                        "INNER JOIN hr_training AS t ON taa.TRAINING_ID = t.TRAINING_ID " +
                        "INNER JOIN hr_training_type AS tt ON t.TYPE = tt.TYPE_ID " +
                        "WHERE YEAR(taa.DATE) = '"+whereYear+"' " +
                        "GROUP BY t.`CODE` " +
                        "ORDER BY t.CODE";
           
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                Lkpbu lkpbu = new Lkpbu();
                resultToObjectTrainAtt(rs, lkpbu);
                lists.add(lkpbu);
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
    
    
    public static void resultToObjectJabatan(ResultSet rs, Lkpbu lkpbu) {
        try {
            lkpbu.setEmpCategoryNameCode(rs.getString("category_code"));
            lkpbu.setEmpBirthDate(rs.getDate(PstEmployee.fieldNames[PstEmployee.FLD_BIRTH_DATE]));
            lkpbu.setEmpLevelCode(rs.getString("level_code"));
            lkpbu.setEmpEduCode(rs.getString("EDU_LEVEL"));
            lkpbu.setEmpSex(rs.getInt(PstEmployee.fieldNames[PstEmployee.FLD_SEX]));
            
        } catch (Exception e) {
        }
    }
    
    public static void resultToObjectTrainAtt(ResultSet rs, Lkpbu lkpbu) {
        try {
            lkpbu.setCode(rs.getString(PstTrainType.fieldNames[PstTrainType.FLD_TRAIN_TYPE_CODE]));
            lkpbu.setTrainAteendes(rs.getInt(PstTrainingActivityActual.fieldNames[PstTrainingActivityActual.FLD_ATENDEES]));
            
        } catch (Exception e) {
        }
    }
    
    public static void resultToObjectPensiun(ResultSet rs, Lkpbu lkpbu) {
        try {
            lkpbu.setResignCategory(rs.getString(PstResignedReason.fieldNames[PstResignedReason.FLD_RESIGNED_CODE]));
            lkpbu.setJenisJabatan(rs.getString("JENIS_JABATAN"));
            lkpbu.setEmpSex(rs.getInt(PstEmployee.fieldNames[PstEmployee.FLD_SEX]));
            
        } catch (Exception e) {
        }
    }
    /*
     * SELECT emp.EMPLOYEE_NUM, emp.FULL_NAME, gen.COMPANY, d.DIVISION FROM hr_employee AS emp
        INNER JOIN pay_general AS gen
        ON
        gen.GEN_ID=emp.COMPANY_ID
        INNER JOIN hr_division AS d
        ON
        d.DIVISION_ID=emp.DIVISION_ID
        WHERE POSITION_ID='';
     */

    public static Vector listPosition(String whereClause) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT emp.EMPLOYEE_NUM, emp.FULL_NAME, gen.COMPANY, d.DIVISION"+
                    " FROM hr_employee AS emp"+
                    " INNER JOIN pay_general AS gen ON gen.GEN_ID=emp.COMPANY_ID"+
                    " INNER JOIN hr_division AS d ON d.DIVISION_ID=emp.DIVISION_ID";
            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " WHERE " + whereClause;
            }
            
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            //System.out.println("list employee list of employee  " + sql);
            while (rs.next()) {
                Lkpbu lkpbu = new Lkpbu();
                resultToObjectKadivSdm(rs, lkpbu);
                lists.add(lkpbu);
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

    public static void resultToObjectKadivSdm(ResultSet rs, Lkpbu lkpbu) {
        try {
            lkpbu.setEmpNumTtd(rs.getString(PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_NUM]));
            lkpbu.setNameTtd(rs.getString(PstEmployee.fieldNames[PstEmployee.FLD_FULL_NAME]));
            lkpbu.setCompanyTtd(rs.getString(PstCompany.fieldNames[PstCompany.FLD_COMPANY]));
            lkpbu.setDivisiTtd(rs.getString(PstDivision.fieldNames[PstDivision.FLD_DIVISION]));
            
        } catch (Exception e) {
        }
    }
    
    public static Vector listPE() {
        Vector lists = new Vector();
        DBResultSet dbrs = null;

        String lkpbuLvlId = "";
        try {
            lkpbuLvlId = String.valueOf(PstSystemProperty.getValueByName("LKPBU_LEVEL_ID"));//menambahkan system properties
        } catch (Exception e) {
            System.out.println("Exeception ATTANDACE_ON_NO_SCHEDULE:" + e);
        }
        String lkpbuLvlPEId = "";
        try {
            lkpbuLvlPEId = String.valueOf(PstSystemProperty.getValueByName("LKPBU_LEVEL_PE_ID"));//menambahkan system properties
        } catch (Exception e) {
            System.out.println("Exeception ATTANDACE_ON_NO_SCHEDULE:" + e);
        }

        try {
            String sql = "SELECT"
                    + " emp.`EMPLOYEE_ID`"
                    + " FROM hr_employee emp"
                    + " INNER JOIN hr_position pos ON emp.`POSITION_ID` = pos.`POSITION_ID`"
                    + " INNER JOIN hr_division divi ON emp.`DIVISION_ID` = divi.`DIVISION_ID`"
                    + " INNER JOIN hr_level lvl ON emp.`LEVEL_ID` = lvl.`LEVEL_ID`"
                    + " WHERE"
                    + " pos.`HEAD_TITLE` = 3"
                    + " AND lvl.level_id IN (" + lkpbuLvlPEId + ")"
                    + " AND emp.history_group != 1"
                    + " AND pos.`LEVEL_ID` IN (" + lkpbuLvlId + ")";

            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            //System.out.println("list employee list of employee  " + sql);
            while (rs.next()) {
                Employee emp = new Employee();
                emp.setOID(rs.getLong("EMPLOYEE_ID"));
                lists.add(emp);
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

    public static String checkCarier(Employee employee, Vector listCareer) {
        String output = "";
        String tempDate = "";
        String nextDate = "";
        Date dateWorkFrom = new Date();
        /* Jika ada data career path maka cari perhitungan workFrom */
        if (listCareer.size() > 0) {
            long dateTempLong = 0;
            long dateFromLong = 0;
            for (int j = 0; j < listCareer.size(); j++) {
                CareerPath careerPath = (CareerPath) listCareer.get(j);
                if (careerPath.getHistoryType() == PstCareerPath.CAREER_TYPE || careerPath.getHistoryType() == PstCareerPath.PEJABAT_SEMENTARA_TYPE) {
                    if (careerPath.getHistoryGroup() != PstCareerPath.RIWAYAT_GRADE) {
                        /* Initialisasi Data */
                        tempDate = Formater.formatDate(careerPath.getWorkTo(), "yyyyMMdd");
                        dateFromLong = Long.valueOf(tempDate);
                        dateWorkFrom = careerPath.getWorkTo();
                        /* check jika dateTempLong == 0 maka isi nilai inisialisasi */
                        /* hanya dilakukan sekali */
                        if (dateTempLong == 0) {
                            dateTempLong = Long.valueOf(tempDate);
                            dateWorkFrom = careerPath.getWorkTo();
                        }
                        /* bandingkan data */
                        if (dateTempLong < dateFromLong) {
                            dateTempLong = dateFromLong;
                            dateWorkFrom = careerPath.getWorkTo();
                        }
                    }
                }
            }

            /* Get the next Date */

            if (dateTempLong == 0 || dateFromLong == 0) {
                nextDate += employee.getCommencingDate();
            } else {
                try {
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd"); /*new SimpleDateFormat("dd MMMM yyyy");*/
                    Calendar c = Calendar.getInstance();
                    c.setTime(dateWorkFrom);
                    c.add(Calendar.DATE, 1);  // number of days to add
                    nextDate = sdf.format(c.getTime());  // dt is now the new date
                } catch (Exception e) {
                    System.out.println("Date=>" + e.toString());
                }
            }
        }
        return nextDate;
    }
    
    public static Vector getLkpbu804(Vector listEmployee) {
        
        int sex = 0;
        int index = 0;
        String code = "";
        String codeResign = "";
        String codeJabatan = "";
        boolean condition = true;
        String kode = "";
        String data = "";
        long empId = 0;

        int totalLaki = 0;
        int totalPerempuan = 0;
        int totalL = 0;
        int totalP = 0;
        int totalData = 0;
        
        Vector listLkpbu = new Vector();
        if (listEmployee != null && listEmployee.size() > 0) {
            for (int i = 0; i < listEmployee.size(); i++) {
                Lkpbu lkpbu804 = (Lkpbu) listEmployee.get(i);
                data = "";
                totalL = 0;
                totalP = 0;
                totalLaki = 0;
                totalPerempuan = 0;
                try {
                
                codeResign = lkpbu804.getResignCategory();
                codeJabatan = lkpbu804.getJenisJabatan();
                sex = lkpbu804.getEmpSex();
                code = codeResign + "," + codeJabatan;
                } catch (Exception exc){
                
                }    
                
                if (listLkpbu.size() > 0) {
                    for (int j = 0; j < listLkpbu.size(); j++) {
                        Lkpbu lkpbu = (Lkpbu) listLkpbu.get(j);
                        condition = true;
                        
                        index = j;
                        kode = lkpbu.getCode();
                        
                        if(!(kode.equals(code))){
                            condition = false;
                            
                        } else {
                            condition = true;
                            if(lkpbu.getEmpSex() == 0){
                                totalL = lkpbu.getJumlahLaki() + 1;
                                totalP = lkpbu.getJumlahPerempuan();
                            } else{
                                totalP = lkpbu.getJumlahPerempuan() + 1;
                                totalL = lkpbu.getJumlahLaki();
                            }
                            break;
                            
                        }
                        
                    } 
                        
                            if (condition == false){
                            if (sex == 0) {
                                totalLaki = 1;
                                } else {
                                totalPerempuan = 1;
                                }
                                lkpbu804.setResignCategory(codeResign);
                                lkpbu804.setJenisJabatan(codeJabatan);
                                lkpbu804.setCode(code);
                                lkpbu804.setJumlahLaki(totalLaki);
                                lkpbu804.setJumlahPerempuan(totalPerempuan);
                                listLkpbu.add(lkpbu804);
                            } else {
                                
                                lkpbu804.setResignCategory(codeResign);
                                lkpbu804.setJenisJabatan(codeJabatan);
                                lkpbu804.setCode(code);
                                lkpbu804.setJumlahLaki(totalL);
                                lkpbu804.setJumlahPerempuan(totalP);
                                listLkpbu.set(index, lkpbu804);
                                }
                         
                } else {
                    
                        if (lkpbu804.getEmpSex() == 0) {
                            totalLaki = totalLaki + 1;
                        } else {
                            totalPerempuan = totalPerempuan + 1;
                        }
                        lkpbu804.setResignCategory(codeResign);
                        lkpbu804.setJenisJabatan(codeJabatan);
                        lkpbu804.setEmpSex(sex);
                        lkpbu804.setCode(code);
                        lkpbu804.setJumlahLaki(totalLaki);
                        lkpbu804.setJumlahPerempuan(totalPerempuan);
                        listLkpbu.add(lkpbu804);
                    
                }

            }
        }
        return listLkpbu;
    }
    
        public static HashMap<String, Lkpbu> getLkpbu804V2(Vector listEmployee) {
        
        int sex = 0;
        int index = 0;
        String code = "";
        String codeResign = "";
        String codeJabatan = "";
        boolean condition = true;
        String kode = "";
        String data = "";
        long empId = 0;

        int totalLaki = 0;
        int totalPerempuan = 0;
        int totalL = 0;
        int totalP = 0;
        int totalData = 0;
        
        HashMap mapLkpbu804 = new HashMap<String, Lkpbu>();
        Vector listLkpbu = new Vector();
        
        String inPensiunPosition = PstSystemProperty.getValueByName("IN_OID_POSITION_PENSIUN");
        if (listEmployee != null && listEmployee.size() > 0) {
            for (int i = 0; i < listEmployee.size(); i++) {
                Employee employee = (Employee) listEmployee.get(i);
                
                String whereCareer = "("+PstCareerPath.fieldNames[PstCareerPath.FLD_HISTORY_GROUP]
                        +" ="+ PstCareerPath.RIWAYAT_JABATAN+
                        " OR "+ PstCareerPath.fieldNames[PstCareerPath.FLD_HISTORY_GROUP] + 
                        " = "+PstCareerPath.RIWAYAT_CAREER_N_GRADE+") "
                        + " AND "+PstCareerPath.fieldNames[PstCareerPath.FLD_EMPLOYEE_ID]
                        +" = "+employee.getOID();
                
                if (inPensiunPosition.length()>0 && !inPensiunPosition.equals("Not Initialized")){
                    whereCareer += " AND "+PstCareerPath.fieldNames[PstCareerPath.FLD_POSITION_ID]
                            +" NOT IN ("+inPensiunPosition+")";
                }
                
                whereCareer += " ORDER BY "+PstCareerPath.fieldNames[PstCareerPath.FLD_WORK_TO]
                        + " DESC LIMIT 1";
                Vector lastCareer = PstCareerPath.list(0, 0, whereCareer, "");
                long positionId = 0;
                if (lastCareer.size()>0){
                    CareerPath career = (CareerPath) lastCareer.get(0);
                    positionId = career.getPositionId();
                }
                
                ResignedReason reason = new ResignedReason();
                try {
                    reason = PstResignedReason.fetchExc(employee.getResignedReasonId());
                } catch (Exception exc){}
                
                Position pos = new Position();
                try {
                    pos = PstPosition.fetchExc(positionId);
                } catch (Exception exc){}
                
                
                codeResign = reason.getResignedCode();
                if (PstPosition.strJenisJabatanInt[pos.getJenisJabatan()] > 9){
                    codeJabatan = ""+PstPosition.strJenisJabatanInt[pos.getJenisJabatan()];
                } else {
                    codeJabatan = "0"+PstPosition.strJenisJabatanInt[pos.getJenisJabatan()];
                }
                sex = employee.getSex();
                code = codeResign + codeJabatan;
                
                Lkpbu lkpbu804 = (Lkpbu)mapLkpbu804.get(code);
                if (lkpbu804 != null){
                    ArrayList<Long> listL = lkpbu804.getIdLaki();
                    ArrayList<Long> listP = lkpbu804.getIdPerempuan();
                    if (sex == PstEmployee.MALE){
                        listL.add(employee.getOID());
                        lkpbu804.setIdLaki(listL);
                        lkpbu804.setIdPerempuan(lkpbu804.getIdPerempuan());
                        lkpbu804.setJumlahLaki(lkpbu804.getJumlahLaki()+1);
                        lkpbu804.setJumlahPerempuan(lkpbu804.getJumlahPerempuan());
                        mapLkpbu804.put(code, lkpbu804);
                    } else {
                        lkpbu804.setJumlahLaki(lkpbu804.getJumlahLaki());
                        lkpbu804.setJumlahPerempuan(lkpbu804.getJumlahPerempuan()+1);
                        listP.add(employee.getOID());
                        lkpbu804.setIdLaki(lkpbu804.getIdLaki());
                        lkpbu804.setIdPerempuan(listP);
                        mapLkpbu804.put(code, lkpbu804);
                    }
                } else {
                    lkpbu804 = new Lkpbu();
                    lkpbu804.setResignCategory(""+codeResign);
                    lkpbu804.setJenisJabatan(""+codeJabatan);
                    ArrayList<Long> listL = lkpbu804.getIdLaki();
                    ArrayList<Long> listP = lkpbu804.getIdPerempuan();
                    if (sex == PstEmployee.MALE){
                        lkpbu804.setJumlahLaki(1);
                        lkpbu804.setJumlahPerempuan(0);
                        listL.add(employee.getOID());
                        lkpbu804.setIdLaki(listL);
                        lkpbu804.setIdPerempuan(lkpbu804.getIdPerempuan());
                        mapLkpbu804.put(code, lkpbu804);
                    } else {
                        lkpbu804.setJumlahLaki(0);
                        lkpbu804.setJumlahPerempuan(1);
                        listP.add(employee.getOID());
                        lkpbu804.setIdLaki(lkpbu804.getIdLaki());
                        lkpbu804.setIdPerempuan(listP);
                        mapLkpbu804.put(code, lkpbu804);
                    }
                }

            }
        }
        return mapLkpbu804;
    }
    
    /**
     *
     * @param listEmployee
     * @return
     */
    public static Vector getLkpbu803(Vector listEmployee) {
        
        String jenisPegawai = "";
        String jenisUsia = "";
        String jenisJabatan = "";
        String jenisPendidikan = "";
        int sex = 0;
        int index = 0;
        String code = "";
        String codePegawai = "";
        String codeUsia = "";
        String codeJabatan = "";
        String codePendidikan = "";
        String codeTenagaKerja = "";
        boolean condition = true;
        String kode = "";
        String data = "";
        long empId = 0;

        int totalLaki = 0;
        int totalPerempuan = 0;
        int totalL = 0;
        int totalP = 0;
        int totalData = 0;
        
        Vector listLkpbu = new Vector();
        if (listEmployee != null && listEmployee.size() > 0) {
            for (int i = 0; i < listEmployee.size(); i++) {
                Lkpbu lkpbu803 = (Lkpbu) listEmployee.get(i);
                data = "";
                totalL = 0;
                totalP = 0;
                totalLaki = 0;
                totalPerempuan = 0;
                try {
                empId = lkpbu803.getEmployeeId();
                if (lkpbu803.getEmpCategory().equals("Tetap")) {
                    codePegawai = "01";
                } else {
                    codePegawai = "02";
                }

                codeUsia = lkpbu803.getCodeUsia();
                if (codeUsia == null) {
                    codeUsia = "";
                }

                codeJabatan = lkpbu803.getJenisJabatan();
                if (codeJabatan == null || codeJabatan.equals("")) {

                    data = "invalid";
                }

                codePendidikan = lkpbu803.getJenisPendidikan();
                if (codePendidikan == null || codePendidikan.equals("")) {

                    data = "invalid";
                }

                codeTenagaKerja = lkpbu803.getJenisPekerjaan();
                if (codeTenagaKerja == null || codeTenagaKerja.equals("") || codeTenagaKerja.equals("0")) {

                    data = "invalid";
                }

                sex = lkpbu803.getEmpSex();
                code = codePegawai + "," + codeUsia + "," + codeJabatan + "," + codePendidikan + "," + codeTenagaKerja;
                } catch (Exception exc){
                
                }    
                
                if (listLkpbu.size() > 0) {
                    for (int j = 0; j < listLkpbu.size(); j++) {
                        Lkpbu lkpbu = (Lkpbu) listLkpbu.get(j);
                        condition = true;
                        
                        index = j;
                        
                        kode = lkpbu.getCode();
                        
                        if(!(kode.equals(code))){
                            condition = false;
                            
                        } else {
                            condition = true;
                            if(lkpbu.getEmpSex() == 0){
                                totalL = lkpbu.getJumlahLaki() + 1;
                                totalP = lkpbu.getJumlahPerempuan();
                            } else{
                                totalP = lkpbu.getJumlahPerempuan() + 1;
                                totalL = lkpbu.getJumlahLaki();
                            }
                            break;
                            
                        }
                        
                    } 
                        
                            if (condition == false){
                            if (sex == 0) {
                                totalLaki = 1;
                                } else {
                                totalPerempuan = 1;
                                }
                                lkpbu803.setEmpCategory(codePegawai);
                                lkpbu803.setCodeUsia(codeUsia);
                                lkpbu803.setJenisJabatan(codeJabatan);
                                lkpbu803.setJenisPekerjaan(codeTenagaKerja);
                                lkpbu803.setJenisPendidikan(codePendidikan);
                                lkpbu803.setEmpSex(sex);
                                lkpbu803.setEmployeeId(empId);
                                lkpbu803.setCode(code);
                                lkpbu803.setJumlahLaki(totalLaki);
                                lkpbu803.setJumlahPerempuan(totalPerempuan);
                                listLkpbu.add(lkpbu803);
                            } else {
                                
                                lkpbu803.setEmpCategory(codePegawai);
                                lkpbu803.setCodeUsia(codeUsia);
                                lkpbu803.setJenisJabatan(codeJabatan);
                                lkpbu803.setJenisPekerjaan(codeTenagaKerja);
                                lkpbu803.setJenisPendidikan(codePendidikan);
                                lkpbu803.setEmpSex(sex);
                                lkpbu803.setEmployeeId(empId);
                                lkpbu803.setCode(code);
                                lkpbu803.setJumlahLaki(totalL);
                                lkpbu803.setJumlahPerempuan(totalP);
                                listLkpbu.set(index, lkpbu803);
                                }
                         
                } else {
                    
                        if (lkpbu803.getEmpSex() == 0) {
                            totalLaki = totalLaki + 1;
                        } else {
                            totalPerempuan = totalPerempuan + 1;
                        }
                        lkpbu803.setEmpCategory(codePegawai);
                        lkpbu803.setCodeUsia(codeUsia);
                        lkpbu803.setJenisJabatan(codeJabatan);
                        lkpbu803.setJenisPekerjaan(codeTenagaKerja);
                        lkpbu803.setJenisPendidikan(codePendidikan);
                        lkpbu803.setEmpSex(sex);
                        lkpbu803.setEmployeeId(empId);
                        lkpbu803.setCode(code);
                        lkpbu803.setJumlahLaki(totalLaki);
                        lkpbu803.setJumlahPerempuan(totalPerempuan);
                        listLkpbu.add(lkpbu803);
                    
                }

            }
        }
        return listLkpbu;
    }
    
    public static HashMap<String, Lkpbu> getLkpbu803V2(Vector objectList, int year) {
        
        int sex = 0;
        int index = 0;
        String code = "";
        String statusTenagaKerja = "";
        String jenisUsia = "";
        String jenisJabatan = "";
        String jenisPendidikan = "";
        String jenisPekerjaan = "";
        long empId = 0;

        int totalLaki = 0;
        int totalPerempuan = 0;
        int totalL = 0;
        int totalP = 0;
        int totalData = 0;
        
        HashMap mapLkpbu803 = new HashMap<String, Lkpbu>();
        Vector listLkpbu = new Vector();
        if (objectList != null && objectList.size() > 0) {
            for (int i = 0; i < objectList.size(); i++) {
                Vector temp = (Vector) objectList.get(i);
                Employee employee = (Employee) temp.get(0);
                Position pos = (Position) temp.get(1);
                EmpCategory empCat = (EmpCategory) temp.get(2);
                EmpEducation empEducation = (EmpEducation) temp.get(3);
                Division div = (Division) temp.get(4);
                
                Education education = new Education();
                try {
                    education = PstEducation.fetchExc(empEducation.getEducationId());
                } catch (Exception exc){}
                
                statusTenagaKerja = empCat.getCode();
                //jenisUsia = Lkpbu.getCodeUsia(employee.getBirthDate(), 2016);
                jenisUsia = (String) temp.get(5);
                if (PstPosition.strJenisJabatanInt[pos.getJenisJabatan()] > 9){
                    jenisJabatan = ""+PstPosition.strJenisJabatanInt[pos.getJenisJabatan()];
                } else {
                    jenisJabatan = "0"+PstPosition.strJenisJabatanInt[pos.getJenisJabatan()];
                }
                jenisPendidikan = education.getKode();
                if (PstPosition.strTenagaKerjaint[pos.getTenagaKerja()] > 9){
                    jenisPekerjaan = ""+PstPosition.strTenagaKerjaint[pos.getTenagaKerja()];
                } else {
                    jenisPekerjaan = "0"+PstPosition.strTenagaKerjaint[pos.getTenagaKerja()];
                }
                
                sex = employee.getSex();
                code=statusTenagaKerja+jenisUsia+jenisJabatan+jenisPendidikan+jenisPekerjaan;
                
                Lkpbu lkpbu803 = (Lkpbu)mapLkpbu803.get(code);
                if (lkpbu803 != null){
                    ArrayList<Long> listL = lkpbu803.getIdLaki();
                    ArrayList<Long> listP = lkpbu803.getIdPerempuan();
                    if (sex == PstEmployee.MALE){
                        listL.add(employee.getOID());
                        lkpbu803.setIdLaki(listL);
                        lkpbu803.setIdPerempuan(lkpbu803.getIdPerempuan());
                        lkpbu803.setJumlahLaki(lkpbu803.getJumlahLaki()+1);
                        lkpbu803.setJumlahPerempuan(lkpbu803.getJumlahPerempuan());
                        mapLkpbu803.put(code, lkpbu803);
                    } else {
                        lkpbu803.setJumlahLaki(lkpbu803.getJumlahLaki());
                        lkpbu803.setJumlahPerempuan(lkpbu803.getJumlahPerempuan()+1);
                        listP.add(employee.getOID());
                        lkpbu803.setIdLaki(lkpbu803.getIdLaki());
                        lkpbu803.setIdPerempuan(listP);
                        mapLkpbu803.put(code, lkpbu803);
                    }
                } else {
                    lkpbu803 = new Lkpbu();
                    lkpbu803.setStatusPegawai(""+statusTenagaKerja);
                    lkpbu803.setJenisUsia(""+jenisUsia);
                    lkpbu803.setJenisJabatan(""+jenisJabatan);
                    lkpbu803.setJenisPendidikan(""+jenisPendidikan);
                    lkpbu803.setJenisPekerjaan(""+jenisPekerjaan);
                    ArrayList<Long> listL = lkpbu803.getIdLaki();
                    ArrayList<Long> listP = lkpbu803.getIdPerempuan();
                    if (sex == PstEmployee.MALE){
                        lkpbu803.setJumlahLaki(1);
                        lkpbu803.setJumlahPerempuan(0);
                        listL.add(employee.getOID());
                        lkpbu803.setIdLaki(listL);
                        lkpbu803.setIdPerempuan(lkpbu803.getIdPerempuan());
                        mapLkpbu803.put(code, lkpbu803);
                    } else {
                        lkpbu803.setJumlahLaki(0);
                        lkpbu803.setJumlahPerempuan(1);
                        listP.add(employee.getOID());
                        lkpbu803.setIdLaki(lkpbu803.getIdLaki());
                        lkpbu803.setIdPerempuan(listP);
                        mapLkpbu803.put(code, lkpbu803);
                    }
                }

            }
        }
        return mapLkpbu803;
    }
    
    /**
     *
     * @param listEmployee
     * @return
     */
    public static Vector getLkpbu805(Vector listEmployee) {
    
        String jenisPegawai = "";
        String jenisPendidikan = "";
        int sex = 0;
        int index = 0;
        String code = "";
        String codePegawai = "";
        String codePendidikan = "";
        String codeTenagaKerja = "";
        boolean condition = true;
        String kode = "";
        String data = "";
        long empId = 0;

        int totalLaki = 0;
        int totalPerempuan = 0;
        int totalL = 0;
        int totalP = 0;
        int totalData = 0;
        
        Vector listLkpbu = new Vector();
        if (listEmployee != null && listEmployee.size() > 0) {
            for (int i = 0; i < listEmployee.size(); i++) {
                Lkpbu lkpbu805 = (Lkpbu) listEmployee.get(i);
                data = "";
                totalL = 0;
                totalP = 0;
                totalLaki = 0;
                totalPerempuan = 0;
                try {
                empId = lkpbu805.getEmployeeId();
                if (lkpbu805.getEmpCategory().equals("Tetap")) {
                    codePegawai = "01";
                } else {
                    codePegawai = "02";
                }
                
                codePendidikan = lkpbu805.getJenisPendidikan();
                if (codePendidikan == null || codePendidikan.equals("")) {

                    data = "invalid";
                }

               // codeTenagaKerja = lkpbu805.getJenisPekerjaan();
                if(lkpbu805.getJenisPekerjaan().length() == 1){
                    codeTenagaKerja = "0"+lkpbu805.getJenisPekerjaan();
                } else {
                    codeTenagaKerja = lkpbu805.getJenisPekerjaan();
                } 
                if (codeTenagaKerja == null || codeTenagaKerja.equals("") || codeTenagaKerja.equals("0")) {

                    data = "invalid";
                }
                
                sex = lkpbu805.getEmpSex();
                code = codeTenagaKerja + "," + codePendidikan + "," + codePegawai;
                } catch (Exception exc){
                
                }    
                
                if (listLkpbu.size() > 0) {
                    for (int j = 0; j < listLkpbu.size(); j++) {
                        Lkpbu lkpbu = (Lkpbu) listLkpbu.get(j);
                        condition = true;
                        
                        index = j;
                        
                        kode = lkpbu.getCode();
                        
                        if(!(kode.equals(code))){
                            condition = false;
                            
                        } else {
                            condition = true;
                            if(lkpbu.getEmpSex() == 0){
                                totalL = lkpbu.getJumlahLaki() + 1;
                                totalP = lkpbu.getJumlahPerempuan();
                            } else{
                                totalP = lkpbu.getJumlahPerempuan() + 1;
                                totalL = lkpbu.getJumlahLaki();
                            }
                            break;
                            
                        }
                        
                    } 
                        
                            if (condition == false){
                            if (sex == 0) {
                                totalLaki = 1;
                                } else {
                                totalPerempuan = 1;
                                }
                                lkpbu805.setEmpCategory(codePegawai);
                                lkpbu805.setJenisPekerjaan(codeTenagaKerja);
                                lkpbu805.setJenisPendidikan(codePendidikan);
                                lkpbu805.setEmpSex(sex);
                                lkpbu805.setEmployeeId(empId);
                                lkpbu805.setCode(code);
                                lkpbu805.setJumlahLaki(totalLaki);
                                lkpbu805.setJumlahPerempuan(totalPerempuan);
                                listLkpbu.add(lkpbu805);
                            } else {
                                
                                lkpbu805.setEmpCategory(codePegawai);
                                lkpbu805.setJenisPekerjaan(codeTenagaKerja);
                                lkpbu805.setJenisPendidikan(codePendidikan);
                                lkpbu805.setEmpSex(sex);
                                lkpbu805.setEmployeeId(empId);
                                lkpbu805.setCode(code);
                                lkpbu805.setJumlahLaki(totalL);
                                lkpbu805.setJumlahPerempuan(totalP);
                                listLkpbu.set(index, lkpbu805);
                                }
                         
                } else {
                    
                        if (lkpbu805.getEmpSex() == 0) {
                            totalLaki = totalLaki + 1;
                        } else {
                            totalPerempuan = totalPerempuan + 1;
                        }
                        lkpbu805.setEmpCategory(codePegawai);
                        lkpbu805.setJenisPekerjaan(codeTenagaKerja);
                        lkpbu805.setJenisPendidikan(codePendidikan);
                        lkpbu805.setEmpSex(sex);
                        lkpbu805.setEmployeeId(empId);
                        lkpbu805.setCode(code);
                        lkpbu805.setJumlahLaki(totalLaki);
                        lkpbu805.setJumlahPerempuan(totalPerempuan);
                        listLkpbu.add(lkpbu805);
                    
                }

            }
        }
        return listLkpbu;
    }
    
    public static HashMap<String, Lkpbu> getLkpbu805V2(Vector objectList, int year) {
        
        int sex = 0;
        int index = 0;
        String code = "";
        String statusTenagaKerja = "";
        String jenisUsia = "";
        String jenisJabatan = "";
        String jenisPendidikan = "";
        String jenisPekerjaan = "";
        long empId = 0;

        
        HashMap mapLkpbu805 = new HashMap<String, Lkpbu>();
        Vector listLkpbu = new Vector();
        if (objectList != null && objectList.size() > 0) {
            for (int i = 0; i < objectList.size(); i++) {
                Vector temp = (Vector) objectList.get(i);
                Employee employee = (Employee) temp.get(0);
                Position pos = (Position) temp.get(1);
                EmpCategory empCat = (EmpCategory) temp.get(2);
                EmpEducation empEducation = (EmpEducation) temp.get(3);
                Division div = (Division) temp.get(4);
                
                Education education = new Education();
                try {
                    education = PstEducation.fetchExc(empEducation.getEducationId());
                } catch (Exception exc){}
                
                
                if (PstPosition.strTenagaKerjaint[pos.getTenagaKerja()] > 9){
                    jenisPekerjaan = ""+PstPosition.strTenagaKerjaint[pos.getTenagaKerja()];
                } else {
                    jenisPekerjaan = "0"+PstPosition.strTenagaKerjaint[pos.getTenagaKerja()];
                }
                jenisPendidikan = education.getKode();
                statusTenagaKerja = empCat.getCode();
                
                
                sex = employee.getSex();
                code=jenisPekerjaan+jenisPendidikan+statusTenagaKerja;
                
                Lkpbu lkpbu805 = (Lkpbu)mapLkpbu805.get(code);
                if (lkpbu805 != null){
                    ArrayList<Long> listEmployee = lkpbu805.getIdKaryawan();
                    listEmployee.add(employee.getOID());
                    lkpbu805.setIdKaryawan(listEmployee);
                    lkpbu805.setJumlahKaryawan(lkpbu805.getJumlahKaryawan()+1);
                    lkpbu805.setCode(code);
                    mapLkpbu805.put(code, lkpbu805);
                } else {
                    ArrayList<Long> listEmployee = new ArrayList<Long>();
                    lkpbu805 = new Lkpbu();
                    lkpbu805.setStatusPegawai(""+statusTenagaKerja);
                    lkpbu805.setJenisUsia(""+jenisUsia);
                    lkpbu805.setJenisJabatan(""+jenisJabatan);
                    lkpbu805.setJenisPendidikan(""+jenisPendidikan);
                    lkpbu805.setJenisPekerjaan(""+jenisPekerjaan);
                    listEmployee.add(employee.getOID());
                    lkpbu805.setIdKaryawan(listEmployee);
                    lkpbu805.setJumlahKaryawan(1);
                    lkpbu805.setCode(code);
                    mapLkpbu805.put(code, lkpbu805);
                }

            }
        }
        return mapLkpbu805;
    }
    
    
    
    
    
    public static Vector listEmployeee803(int year){
        Vector result = new Vector(1, 1);
        DBResultSet dbrs = null;
        String notInPosition = PstSystemProperty.getValueByName("LKPBU_803_RPT_OID_NOT_IN_POSITION");
        try {
            String sql = "SELECT vw.* FROM hr_view_work_history_now AS vw "
                    + "INNER JOIN hr_employee AS emp "
                    + "ON vw.EMPLOYEE_ID = emp.EMPLOYEE_ID "
                    + "WHERE emp.COMMENCING_DATE <= '"+year+"-12-31' "
                    + "AND (emp.RESIGNED = 0 OR emp.RESIGNED_DATE >= '"+(year+1)+"-01-01') "
                    + "AND '"+year+"-12-31' BETWEEN vw.WORK_FROM AND vw.WORK_TO ";
            
            if (notInPosition.length() > 0 && !notInPosition.equals("Not Initialized")){
                sql += "AND vw.POSITION_ID NOT IN ("+notInPosition+") ";
            } 
            sql += "ORDER BY vw.DIVISION_ID, emp.BIRTH_DATE";
            
            //AND vw.POSITION_ID NOT IN (37023,37022) 
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            
            while (rs.next()) {
                try{
                Vector vectTemp = new Vector(1, 1);
                long empId = rs.getLong("EMPLOYEE_ID");
                long positionId = rs.getLong("POSITION_ID");
                long empCatId = rs.getLong("EMP_CATEGORY_ID");
                long divisionId = rs.getLong("DIVISION_ID");
                
                Employee employee = new Employee();
                try {
                    employee = PstEmployee.fetchExc(empId);
                } catch (Exception exc){}
                vectTemp.add(employee);
                
                Position pos = new Position();
                try {
                    pos = PstPosition.fetchExc(positionId);
                } catch (Exception exc){}
                vectTemp.add(pos);
                
                EmpCategory empCategory = new EmpCategory();
                try {
                    empCategory = PstEmpCategory.fetchExc(empCatId);
                } catch (Exception exc){}
                vectTemp.add(empCategory);
                
                EmpEducation empEducation = new EmpEducation();
                try{
                    empEducation = PstEmpEducation.getLastEmpEducation(empId, year);
                } catch (Exception exc){}
                vectTemp.add(empEducation);
                
                Division div = new Division();
                try {
                    div = PstDivision.fetchExc(divisionId);
                } catch (Exception exc){}
                vectTemp.add(div);
                
                String date = year+"-12-31";
                SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
                Date dtNow = format.parse(date);
                String age = Lkpbu.getCodeUsiaV2(employee.getBirthDate(), dtNow);
                vectTemp.add(age);
                
                result.add(vectTemp);
               
            }
            catch (Exception exc){
                    
                }
            }
            rs.close();
            return result;
        } catch (Exception exc){
           System.out.println(exc);
        } finally {
            DBResultSet.close(dbrs);
        }
        
        return result;
    }
    
        public static Vector listCurrentEmployeee803(int year){
        Vector result = new Vector(1, 1);
        DBResultSet dbrs = null;
        String notInPosition = PstSystemProperty.getValueByName("LKPBU_803_RPT_OID_NOT_IN_POSITION");
        try {
            String sql = "SELECT emp.* FROM hr_employee AS emp  "
                    + "WHERE emp.COMMENCING_DATE <= '"+year+"-12-31' "
                    + "AND (emp.RESIGNED = 0 OR emp.RESIGNED_DATE >= '"+(year+1)+"-01-01') ";
            if (notInPosition.length() > 0 && !notInPosition.equals("Not Initialized")){
                sql += "AND emp.POSITION_ID NOT IN ("+notInPosition+") ";
            } 
            sql += "ORDER BY emp.DIVISION_ID, emp.BIRTH_DATE";
            //AND vw.POSITION_ID NOT IN (37023,37022) 
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            
            while (rs.next()) {
                try{
                Vector vectTemp = new Vector(1, 1);
                long empId = rs.getLong("EMPLOYEE_ID");
                long positionId = rs.getLong("POSITION_ID");
                long empCatId = rs.getLong("EMP_CATEGORY_ID");
                long divisionId = rs.getLong("DIVISION_ID");
                
                Employee employee = new Employee();
                try {
                    employee = PstEmployee.fetchExc(empId);
                } catch (Exception exc){}
                vectTemp.add(employee);
                
                Position pos = new Position();
                try {
                    pos = PstPosition.fetchExc(positionId);
                } catch (Exception exc){}
                vectTemp.add(pos);
                
                EmpCategory empCategory = new EmpCategory();
                try {
                    empCategory = PstEmpCategory.fetchExc(empCatId);
                } catch (Exception exc){}
                vectTemp.add(empCategory);
                
                EmpEducation empEducation = new EmpEducation();
                try{
                    empEducation = PstEmpEducation.getLastEmpEducation(empId, year);
                } catch (Exception exc){}
                vectTemp.add(empEducation);
                
                Division div = new Division();
                try {
                    div = PstDivision.fetchExc(divisionId);
                } catch (Exception exc){}
                vectTemp.add(div);
                
                String date = year+"-12-31";
                SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
                Date dtNow = format.parse(date);
                String age = Lkpbu.getCodeUsiaV2(employee.getBirthDate(), dtNow);
                vectTemp.add(age);
                
                result.add(vectTemp);
               
            }
            catch (Exception exc){
                    
                }
            }
            rs.close();
            return result;
        } catch (Exception exc){
           System.out.println(exc);
        } finally {
            DBResultSet.close(dbrs);
        }
        
        return result;
    }
    
    
    public static Vector lkpbu(int year){
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        String date = year+"-12-31";
        Hashtable<String, CareerPath> careerMap = PstCareerPath.listCareerPath(date);
        Hashtable<String, Position> mapPosition = PstPosition.listMap(0, 0, "", "");
        Hashtable<String, EmpEducation> mapEmpEducation = PstEmpEducation.listEmpEducation(year);
        try{
            String sql = "SELECT emp.*,cat.EMP_CATEGORY FROM hr_employee emp INNER JOIN `hr_emp_category` cat ON emp.`EMP_CATEGORY_ID` = cat.`EMP_CATEGORY_ID`  WHERE `RESIGNED` = 0 ";
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            
            while (rs.next()) {
                try{
                String empId = rs.getString("EMPLOYEE_ID");
                long positionId = rs.getLong("POSITION_ID");
                Vector listCareerPath = new Vector();
                
                CareerPath cp = careerMap.get(empId);
                
                try{
                    if(positionId != cp.getPositionId() && positionId > 0){
                        positionId = cp.getPositionId();
                    }
                } catch (Exception exc){
                    positionId = rs.getLong("POSITION_ID");
                }
                EmpEducation empEdu = mapEmpEducation.get(empId);
                Education edu = PstEducation.fetchExc(empEdu.getEducationId());
                
                
                Position pos = mapPosition.get(""+positionId);
                Date birthDate = rs.getDate("BIRTH_DATE");
                String codeUsia = Lkpbu.getCodeUsia(birthDate, year);
                int sex = rs.getInt("SEX");
                String category = rs.getString("EMP_CATEGORY");
                
                if(pos.getTenagaKerja() > 0){
                Lkpbu lkpbu803 = new Lkpbu();
                lkpbu803.setEmpCategory(category);
                lkpbu803.setCodeUsia(codeUsia);
                lkpbu803.setJenisJabatan(""+pos.getJenisJabatan());
                lkpbu803.setJenisPekerjaan(""+pos.getTenagaKerja());
                lkpbu803.setJenisPendidikan(edu.getKode());
                lkpbu803.setEmpSex(sex);
                lkpbu803.setEmployeeId(Long.parseLong(empId));
                lists.add(lkpbu803);
                }
               
            }
            catch (Exception exc){
                    
                }
            }
            rs.close();
            return lists;
         } catch (Exception exc){
           System.out.println(exc);
        } finally {
            DBResultSet.close(dbrs);
        }
        return new Vector();  
    } 
    
    public static Vector lkpbu803(int year){
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql =  "SELECT" +
                        " emp.`EMPLOYEE_ID`," +
                        " emp.`BIRTH_DATE`," +
                        " emp.`SEX`," +
                        " pos.`POSITION_ID`," +
                        " pos.`JENIS_JABATAN`," +
                        " pos.`TENAGA_KERJA`," +
                        " edu.`KODE`," +
                        " edu.`EDUCATION`," +
                        " cat.`EMP_CATEGORY`" +
                        " FROM" +
                        " hr_employee emp" +
                        " INNER JOIN hr_position pos" +
                        " ON emp.`POSITION_ID` = pos.`POSITION_ID`" +
                        " INNER JOIN `hr_emp_education` empedu" +
                        " ON emp.`EMPLOYEE_ID` = empedu.`EMPLOYEE_ID`" +
                        " INNER JOIN `hr_education` edu" +
                        " ON empedu.`EDUCATION_ID` = edu.`EDUCATION_ID`" +
                        " INNER JOIN `hr_emp_category` cat" +
                        " ON emp.`EMP_CATEGORY_ID` = cat.`EMP_CATEGORY_ID`" +
                        " WHERE `empedu`.`EMP_EDUCATION_ID` IN (SELECT emp_education_id FROM" +
                        "(SELECT employee_id, MAX(end_date) AS end_date FROM hr_emp_education GROUP BY employee_id)" +
                        " AS X JOIN hr_emp_education USING (employee_id, end_date))" +
                        " AND pos.`TENAGA_KERJA` != 0" +
                        " ORDER BY cat.`EMP_CATEGORY` DESC , pos.`JENIS_JABATAN`,edu.`KODE`, pos.`TENAGA_KERJA`, emp.`BIRTH_DATE`   ";
            
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            //System.out.println("list employee list of employee  " + sql);
            while (rs.next()) {
                try {
                    String category = rs.getString("EMP_CATEGORY");
                    Date birthDate = rs.getDate("BIRTH_DATE");
                    String codeUsia = Lkpbu.getCodeUsia(birthDate, year);
                    String jenisJabatan = ""+rs.getInt("JENIS_JABATAN");
                    String jenisTenaga = ""+rs.getInt("TENAGA_KERJA");
                    String codeEducation = rs.getString("KODE");
                    int sex = rs.getInt("SEX");
                    long employeeId = rs.getLong("EMPLOYEE_ID");
                    
                    Lkpbu lkpbu = new Lkpbu();
                    lkpbu.setEmpCategory(category);
                    lkpbu.setCodeUsia(codeUsia);
                    lkpbu.setJenisJabatan(jenisJabatan);
                    lkpbu.setJenisPekerjaan(jenisTenaga);
                    lkpbu.setJenisPendidikan(codeEducation);
                    lkpbu.setEmpSex(sex);
                    lkpbu.setEmployeeId(employeeId);
                    lists.add(lkpbu);
                } catch (Exception exc){
                    
                }
            }
            rs.close();
            return lists;
            
        } catch (Exception exc){
           System.out.println(exc);
        } finally {
            DBResultSet.close(dbrs);
        }
        return new Vector();  
    }
    
    public static long lkpbu801byEmployee(long employeeId, long periodId){
        long oid = 0;
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT * FROM "+PstLkpbu.TBL_LKPBU_801
                        + " WHERE "+PstLkpbu.fieldNames[PstLkpbu.FLD_EMPLOYEE_ID]+"="+employeeId
                        + " AND "+PstLkpbu.fieldNames[PstLkpbu.FLD_PERIOD_ID]+"="+periodId;
            System.out.println("SQL Lkpbu801:"+sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                oid = rs.getLong(PstLkpbu.fieldNames[PstLkpbu.FLD_LKPBU_801_ID]);
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

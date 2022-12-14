/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.masterdata;

import com.dimata.harisma.entity.attendance.PstEmpSchedule;
import com.dimata.harisma.entity.employee.PstEmployee;
import com.dimata.harisma.entity.payroll.PayComponent;
import com.dimata.harisma.entity.payroll.PayPeriod;
import com.dimata.harisma.entity.payroll.PstPayComponent;
import com.dimata.harisma.session.attendance.SessEmpSchedule;
import com.dimata.harisma.session.attendance.rekapitulasiabsensi.RekapitulasiAbsensi;
import com.dimata.qdep.db.DBException;
import com.dimata.qdep.db.DBHandler;
import com.dimata.qdep.db.DBResultSet;
import com.dimata.qdep.db.I_DBInterface;
import com.dimata.qdep.db.I_DBType;
import com.dimata.qdep.entity.Entity;
import com.dimata.qdep.entity.I_PersintentExc;
import com.dimata.system.entity.PstSystemProperty;
import com.dimata.util.Command;
import com.dimata.util.DateCalc;
import com.dimata.util.Formater;
import com.dimata.util.lang.I_Language;
import java.sql.ResultSet;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Hashtable;
import java.util.Vector;

/**
 *
 * @author GUSWIK
 */
public class PstEmpDoc extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {

    public static final String TBL_HR_EMP_DOC = "hr_emp_doc";
    public static final int FLD_EMP_DOC_ID = 0;
    public static final int FLD_DOC_MASTER_ID = 1;
    public static final int FLD_DOC_TITLE = 2;
    public static final int FLD_REQUEST_DATE = 3;
    public static final int FLD_DOC_NUMBER = 4;
    public static final int FLD_DATE_OF_ISSUE = 5;
    public static final int FLD_PLAN_DATE_FROM = 6;
    public static final int FLD_PLAN_DATE_TO = 7;
    public static final int FLD_REAL_DATE_FROM = 8;
    public static final int FLD_REAL_DATE_TO = 9;
    public static final int FLD_OBJECTIVES = 10;
    public static final int FLD_DETAILS = 11;
    public static final int FLD_COUNTRY_ID = 12;
    public static final int FLD_PROVINCE_ID = 13;
    public static final int FLD_REGION_ID = 14;
    public static final int FLD_SUBREGION_ID = 15;
    public static final int FLD_GEO_ADDRESS = 16;
    public static final int FLD_FILE_NAME = 17;
    public static final int FLD_DOCH_ATTACH_FILE = 18;
    /* Update by Hendra Putu | 2016-07-15 */
    //public static final int FLD_EMP_DOC_SERIES_ID = 19;
    public static final int FLD_COMPANY_ID = 19;
    public static final int FLD_DIVISION_ID = 20;
    public static final int FLD_DEPARTMENT_ID = 21;
    public static final int FLD_SECTION_ID = 22;
    public static final int FLD_DOC_STATUS = 23;
	public static final int FLD_LEAVE_APPLICATION_ID = 24;
    
    public static final String[] fieldNames = {
        "EMP_DOC_ID",
        "DOC_MASTER_ID",
        "DOC_TITLE",
        "REQUEST_DATE",
        "DOC_NUMBER",
        "DATE_OF_ISSUE",
        "PLAN_DATE_FROM",
        "PLAN_DATE_TO",
        "REAL_DATE_FROM",
        "REAL_DATE_TO",
        "OBJECTIVES",
        "DETAILS",
        "COUNTRY_ID",
        "PROVINCE_ID",
        "REGION_ID",
        "SUBREGION_ID",
        "GEO_ADDRESS",
        "FILE_NAME",
        "DOCH_ATTACH_FILE",
        "COMPANY_ID",
        "DIVISION_ID",
        "DEPARTMENT_ID",
        "SECTION_ID",
        "DOC_STATUS",
		"LEAVE_APPLICATION_ID"
    };
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_DATE,
        TYPE_STRING,
        TYPE_DATE,
        TYPE_DATE,
        TYPE_DATE,
        TYPE_DATE,
        TYPE_DATE,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_INT,
		TYPE_LONG
    };

    public PstEmpDoc() {
    }

    public PstEmpDoc(int i) throws DBException {
        super(new PstEmpDoc());
    }

    public PstEmpDoc(String sOid) throws DBException {
        super(new PstEmpDoc(0));
        if (!locate(sOid)) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public PstEmpDoc(long lOid) throws DBException {
        super(new PstEmpDoc(0));
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
        return TBL_HR_EMP_DOC;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new PstEmpDoc().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        EmpDoc empDoc = fetchExc(ent.getOID());
        ent = (Entity) empDoc;
        return empDoc.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((EmpDoc) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((EmpDoc) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static EmpDoc fetchExc(long oid) throws DBException {
        try {
            EmpDoc empDoc = new EmpDoc();
            PstEmpDoc pstEmpDoc = new PstEmpDoc(oid);
            empDoc.setOID(oid);

            empDoc.setDoc_master_id(pstEmpDoc.getLong(FLD_DOC_MASTER_ID));
            empDoc.setDoc_title(pstEmpDoc.getString(FLD_DOC_TITLE));
            empDoc.setRequest_date(pstEmpDoc.getDate(FLD_REQUEST_DATE));
            empDoc.setDoc_number(pstEmpDoc.getString(FLD_DOC_NUMBER));
            empDoc.setDate_of_issue(pstEmpDoc.getDate(FLD_DATE_OF_ISSUE));
            empDoc.setPlan_date_from(pstEmpDoc.getDate(FLD_PLAN_DATE_FROM));
            empDoc.setPlan_date_to(pstEmpDoc.getDate(FLD_PLAN_DATE_TO));
            empDoc.setReal_date_from(pstEmpDoc.getDate(FLD_REAL_DATE_FROM));
            empDoc.setReal_date_to(pstEmpDoc.getDate(FLD_REAL_DATE_TO));
            empDoc.setObjectives(pstEmpDoc.getString(FLD_OBJECTIVES));
            empDoc.setDetails(pstEmpDoc.getString(FLD_DETAILS));
            empDoc.setCountry_id(pstEmpDoc.getLong(FLD_COUNTRY_ID));
            empDoc.setProvince_id(pstEmpDoc.getLong(FLD_PROVINCE_ID));
            empDoc.setRegion_id(pstEmpDoc.getLong(FLD_REGION_ID));
            empDoc.setSubregion_id(pstEmpDoc.getLong(FLD_SUBREGION_ID));
            empDoc.setGeo_address(pstEmpDoc.getString(FLD_GEO_ADDRESS));
            empDoc.setFileName(pstEmpDoc.getString(FLD_FILE_NAME));
            empDoc.setDocAttachFile(pstEmpDoc.getString(FLD_DOCH_ATTACH_FILE));
            empDoc.setCompanyId(pstEmpDoc.getLong(FLD_COMPANY_ID));
            empDoc.setDivisionId(pstEmpDoc.getLong(FLD_DIVISION_ID));
            empDoc.setDepartmentId(pstEmpDoc.getLong(FLD_DEPARTMENT_ID));
            empDoc.setSectionId(pstEmpDoc.getLong(FLD_SECTION_ID));
            empDoc.setDocStatus(pstEmpDoc.getInt(FLD_DOC_STATUS));
            empDoc.setLeaveId(pstEmpDoc.getLong(FLD_LEAVE_APPLICATION_ID));
            fetchGeoAddress(empDoc);

            return empDoc;
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstEmpDoc(0), DBException.UNKNOWN);
        }
    }

    public static Hashtable fetchExcHashtable(long oid) throws DBException {
        try {
            Hashtable empDocH = new Hashtable();
            EmpDoc empDoc = new EmpDoc();
            PstEmpDoc pstEmpDoc = new PstEmpDoc(oid);
            empDoc.setOID(oid);

            empDoc.setDoc_master_id(pstEmpDoc.getLong(FLD_DOC_MASTER_ID));
            empDocH.put(PstEmpDoc.fieldNames[PstEmpDoc.FLD_DOC_MASTER_ID], empDoc.getOID());
            empDoc.setDoc_title(pstEmpDoc.getString(FLD_DOC_TITLE));
            empDocH.put(PstEmpDoc.fieldNames[PstEmpDoc.FLD_DOC_TITLE], (empDoc.getDoc_title() != null ? empDoc.getDoc_title() : ""));
            empDoc.setRequest_date(pstEmpDoc.getDate(FLD_REQUEST_DATE));
            
            SimpleDateFormat formatterDateSql = new SimpleDateFormat("yyyy-MM-dd");
            String dateInString = (String) empDoc.getRequest_date().toString();
            String strYear = "";
            String strMonth = "";
            String strDay = "";
            String dateShow = "";
            SimpleDateFormat formatterDate = new SimpleDateFormat("dd MMMM yyyy");
            try {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                Date dateX = formatterDateSql.parse(dateInString);
                String strDate = sdf.format(dateX);
                strYear = strDate.substring(0, 4);
                strMonth = strDate.substring(5, 7);
                if (strMonth.length() > 0){
                    switch(Integer.valueOf(strMonth)){
                        case 1: strMonth = "Januari"; break;
                        case 2: strMonth = "Februari"; break;
                        case 3: strMonth = "Maret"; break;
                        case 4: strMonth = "April"; break;
                        case 5: strMonth = "Mei"; break;
                        case 6: strMonth = "Juni"; break;
                        case 7: strMonth = "Juli"; break;
                        case 8: strMonth = "Agustus"; break;
                        case 9: strMonth = "September"; break;
                        case 10: strMonth = "Oktober"; break;
                        case 11: strMonth = "November"; break;
                        case 12: strMonth = "Desember"; break;
                    }
                }
                strDay = strDate.substring(8, 10);
                dateShow = strDay + " "+ strMonth + " " + strYear;  ////formatterDate.format(dateX);

            } catch (Exception e) {
                e.printStackTrace();
            }
            
            empDocH.put(PstEmpDoc.fieldNames[PstEmpDoc.FLD_REQUEST_DATE], (empDoc.getRequest_date() != null ? dateShow : ""));

            empDoc.setDoc_number(pstEmpDoc.getString(FLD_DOC_NUMBER));
            empDocH.put(PstEmpDoc.fieldNames[PstEmpDoc.FLD_DOC_NUMBER], (empDoc.getDoc_number() != null ? empDoc.getDoc_number() : ""));

            empDoc.setDate_of_issue(pstEmpDoc.getDate(FLD_DATE_OF_ISSUE));
            String dateIssueString = (String) empDoc.getDate_of_issue().toString();
            String strYearIssue = "";
            String strMonthIssue = "";
            String strDayIssue = "";
            String dateShowIssue = "";
            try {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                Date dateX = formatterDateSql.parse(dateIssueString);
                String strDate = sdf.format(dateX);
                strYearIssue = strDate.substring(0, 4);
                strMonthIssue = strDate.substring(5, 7);
                if (strMonthIssue.length() > 0){
                    switch(Integer.valueOf(strMonthIssue)){
                        case 1: strMonthIssue = "Januari"; break;
                        case 2: strMonthIssue = "Februari"; break;
                        case 3: strMonthIssue = "Maret"; break;
                        case 4: strMonthIssue = "April"; break;
                        case 5: strMonthIssue = "Mei"; break;
                        case 6: strMonthIssue = "Juni"; break;
                        case 7: strMonthIssue = "Juli"; break;
                        case 8: strMonthIssue = "Agustus"; break;
                        case 9: strMonthIssue = "September"; break;
                        case 10: strMonthIssue = "Oktober"; break;
                        case 11: strMonthIssue = "November"; break;
                        case 12: strMonthIssue = "Desember"; break;
                    }
                }
                strDayIssue = strDate.substring(8, 10);
                dateShowIssue = strDayIssue + " "+ strMonthIssue + " " + strYearIssue;  ////formatterDate.format(dateX);

            } catch (Exception e) {
                e.printStackTrace();
            }
            empDocH.put(PstEmpDoc.fieldNames[PstEmpDoc.FLD_DATE_OF_ISSUE], (empDoc.getDate_of_issue() != null ? dateShowIssue : ""));

            empDoc.setPlan_date_from(pstEmpDoc.getDate(FLD_PLAN_DATE_FROM));
            empDocH.put(PstEmpDoc.fieldNames[PstEmpDoc.FLD_PLAN_DATE_FROM], (empDoc.getPlan_date_from() != null ? empDoc.getPlan_date_from() : ""));

            empDoc.setPlan_date_to(pstEmpDoc.getDate(FLD_PLAN_DATE_TO));
            empDocH.put(PstEmpDoc.fieldNames[PstEmpDoc.FLD_PLAN_DATE_TO], (empDoc.getPlan_date_to() != null ? empDoc.getPlan_date_to() : ""));
            empDoc.setReal_date_from(pstEmpDoc.getDate(FLD_REAL_DATE_FROM));
            empDocH.put(PstEmpDoc.fieldNames[PstEmpDoc.FLD_REAL_DATE_FROM], (empDoc.getReal_date_from() != null ? empDoc.getReal_date_from() : ""));
            empDoc.setReal_date_to(pstEmpDoc.getDate(FLD_REAL_DATE_TO));
            empDocH.put(PstEmpDoc.fieldNames[PstEmpDoc.FLD_REAL_DATE_TO], (empDoc.getReal_date_to() != null ? empDoc.getReal_date_to() : ""));
            empDoc.setObjectives(pstEmpDoc.getString(FLD_OBJECTIVES));
            empDocH.put(PstEmpDoc.fieldNames[PstEmpDoc.FLD_OBJECTIVES], (empDoc.getObjectives() != null ? empDoc.getObjectives() : ""));
            empDoc.setDetails(pstEmpDoc.getString(FLD_DETAILS));
            empDoc.setCountry_id(pstEmpDoc.getLong(FLD_COUNTRY_ID));
            empDoc.setProvince_id(pstEmpDoc.getLong(FLD_PROVINCE_ID));
            empDoc.setRegion_id(pstEmpDoc.getLong(FLD_REGION_ID));
            empDoc.setSubregion_id(pstEmpDoc.getLong(FLD_SUBREGION_ID));
            empDoc.setGeo_address(pstEmpDoc.getString(FLD_GEO_ADDRESS));
            empDoc.setDocAttachFile(pstEmpDoc.getString(FLD_DOCH_ATTACH_FILE));
            empDoc.setFileName(pstEmpDoc.getString(FLD_FILE_NAME));
            empDoc.setCompanyId(pstEmpDoc.getLong(FLD_COMPANY_ID));
            empDoc.setDivisionId(pstEmpDoc.getLong(FLD_DIVISION_ID));
            empDoc.setDepartmentId(pstEmpDoc.getLong(FLD_DEPARTMENT_ID));
            empDoc.setSectionId(pstEmpDoc.getLong(FLD_SECTION_ID));
            empDoc.setDocStatus(pstEmpDoc.getInt(FLD_DOC_STATUS));
			empDoc.setLeaveId(pstEmpDoc.getLong(FLD_LEAVE_APPLICATION_ID));
            
            fetchGeoAddress(empDoc);

            return empDocH;
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstEmpDoc(0), DBException.UNKNOWN);
        }
    }

    public static long insertExc(EmpDoc empDoc) throws DBException {
        try {
            PstEmpDoc pstEmpDoc = new PstEmpDoc(0);

            pstEmpDoc.setLong(FLD_DOC_MASTER_ID, empDoc.getDoc_master_id());
            pstEmpDoc.setString(FLD_DOC_TITLE, empDoc.getDoc_title());
            pstEmpDoc.setDate(FLD_REQUEST_DATE, empDoc.getRequest_date());
            pstEmpDoc.setString(FLD_DOC_NUMBER, empDoc.getDoc_number());
            pstEmpDoc.setDate(FLD_DATE_OF_ISSUE, empDoc.getDate_of_issue());
            pstEmpDoc.setDate(FLD_PLAN_DATE_FROM, empDoc.getPlan_date_from());
            pstEmpDoc.setDate(FLD_PLAN_DATE_TO, empDoc.getPlan_date_to());
            pstEmpDoc.setDate(FLD_REAL_DATE_FROM, empDoc.getReal_date_from());
            pstEmpDoc.setDate(FLD_REAL_DATE_TO, empDoc.getReal_date_to());
            pstEmpDoc.setString(FLD_OBJECTIVES, empDoc.getObjectives());
            pstEmpDoc.setString(FLD_DETAILS, empDoc.getDetails());
            pstEmpDoc.setLong(FLD_COUNTRY_ID, empDoc.getCountry_id());
            pstEmpDoc.setLong(FLD_PROVINCE_ID, empDoc.getProvince_id());
            pstEmpDoc.setLong(FLD_REGION_ID, empDoc.getRegion_id());
            pstEmpDoc.setLong(FLD_SUBREGION_ID, empDoc.getSubregion_id());
            pstEmpDoc.setString(FLD_GEO_ADDRESS, empDoc.getGeo_address());
            pstEmpDoc.setString(FLD_DOCH_ATTACH_FILE, empDoc.getDocAttachFile());
            pstEmpDoc.setString(FLD_FILE_NAME, empDoc.getFileName());
            pstEmpDoc.setLong(FLD_COMPANY_ID, empDoc.getCompanyId());
            pstEmpDoc.setLong(FLD_DIVISION_ID, empDoc.getDivisionId());
            pstEmpDoc.setLong(FLD_DEPARTMENT_ID, empDoc.getDepartmentId());
            pstEmpDoc.setLong(FLD_SECTION_ID, empDoc.getSectionId());
            pstEmpDoc.setInt(FLD_DOC_STATUS, empDoc.getDocStatus());
			pstEmpDoc.setLong(FLD_LEAVE_APPLICATION_ID, empDoc.getLeaveId());

            pstEmpDoc.insert();
            empDoc.setOID(pstEmpDoc.getlong(FLD_EMP_DOC_ID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstEmpDoc(0), DBException.UNKNOWN);
        }
        return empDoc.getOID();
    }

    public static long updateExc(EmpDoc empDoc) throws DBException {
        try {
            if (empDoc.getOID() != 0) {
                PstEmpDoc pstEmpDoc = new PstEmpDoc(empDoc.getOID());

                pstEmpDoc.setLong(FLD_DOC_MASTER_ID, empDoc.getDoc_master_id());
                pstEmpDoc.setString(FLD_DOC_TITLE, empDoc.getDoc_title());
                pstEmpDoc.setDate(FLD_REQUEST_DATE, empDoc.getRequest_date());
                pstEmpDoc.setString(FLD_DOC_NUMBER, empDoc.getDoc_number());
                pstEmpDoc.setDate(FLD_DATE_OF_ISSUE, empDoc.getDate_of_issue());
                pstEmpDoc.setDate(FLD_PLAN_DATE_FROM, empDoc.getPlan_date_from());
                pstEmpDoc.setDate(FLD_PLAN_DATE_TO, empDoc.getPlan_date_to());
                pstEmpDoc.setDate(FLD_REAL_DATE_FROM, empDoc.getReal_date_from());
                pstEmpDoc.setDate(FLD_REAL_DATE_TO, empDoc.getReal_date_to());
                pstEmpDoc.setString(FLD_OBJECTIVES, empDoc.getObjectives());
                pstEmpDoc.setString(FLD_DETAILS, empDoc.getDetails());
                pstEmpDoc.setLong(FLD_COUNTRY_ID, empDoc.getCountry_id());
                pstEmpDoc.setLong(FLD_PROVINCE_ID, empDoc.getProvince_id());
                pstEmpDoc.setLong(FLD_REGION_ID, empDoc.getRegion_id());
                pstEmpDoc.setLong(FLD_SUBREGION_ID, empDoc.getSubregion_id());
                pstEmpDoc.setString(FLD_GEO_ADDRESS, empDoc.getGeo_address());
                pstEmpDoc.setString(FLD_DOCH_ATTACH_FILE, empDoc.getDocAttachFile());
                pstEmpDoc.setLong(FLD_COMPANY_ID, empDoc.getCompanyId());
                pstEmpDoc.setLong(FLD_DIVISION_ID, empDoc.getDivisionId());
                pstEmpDoc.setLong(FLD_DEPARTMENT_ID, empDoc.getDepartmentId());
                pstEmpDoc.setLong(FLD_SECTION_ID, empDoc.getSectionId());
                pstEmpDoc.setInt(FLD_DOC_STATUS, empDoc.getDocStatus());
				pstEmpDoc.setLong(FLD_LEAVE_APPLICATION_ID, empDoc.getLeaveId());

                pstEmpDoc.update();
                return empDoc.getOID();

            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstEmpDoc(0), DBException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws DBException {
        try {
            PstEmpDoc pstEmpDoc = new PstEmpDoc(oid);
            pstEmpDoc.delete();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstEmpDoc(0), DBException.UNKNOWN);
        }
        return oid;
    }

    public static Vector listAll() {
        return list(0, 500, "", "");
    }
    public static Vector listSpj(RekapitulasiAbsensi rekapitulasiAbsensi) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = " SELECT distinct (hr_emp_doc.`EMP_DOC_ID`),hr_emp_doc.`EMP_DOC_ID`,  hr_emp_doc.`DOC_NUMBER`,  hr_emp_doc.`REQUEST_DATE`,  hr_employee.`FULL_NAME`, hr_employee.`EMPLOYEE_ID`, hr_employee.`POSITION_ID`, hr_employee.`GRADE_LEVEL_ID`,`hr_doc_master`.`DOC_MASTER_ID` "
                    + "FROM `hr_emp_doc` "
                    + "INNER JOIN `hr_doc_master` ON (  `hr_doc_master`.`DOC_MASTER_ID` = `hr_emp_doc`.`DOC_MASTER_ID`   AND `hr_doc_master`.`DOC_TYPE_ID` = 504404581429279957 ) "
                    + "INNER JOIN `hr_emp_doc_list`  ON ( `hr_emp_doc_list`.`EMP_DOC_ID` = `hr_emp_doc`.`EMP_DOC_ID`  AND `hr_emp_doc_list`.`OBJECT_NAME` = 'TRAINNER2' )  "
                    + "INNER JOIN `hr_employee`  ON ( `hr_employee`.`EMPLOYEE_ID` = hr_emp_doc_list.`EMPLOYEE_ID` ) ";
            sql += " WHERE 1=1 ";
            if ( rekapitulasiAbsensi.getFullName() != null && !rekapitulasiAbsensi.getFullName().equals("") ){
                sql += " AND `hr_employee`.`FULL_NAME` LIKE '% " + rekapitulasiAbsensi.getFullName()+" %' ";
            }
            if ( rekapitulasiAbsensi.getPayrollNumber() != null && !rekapitulasiAbsensi.getPayrollNumber().equals("") ){
                sql += " AND `hr_employee`.`EMPLOYEE_NUM` LIKE '% " + rekapitulasiAbsensi.getPayrollNumber()+" %' ";
            }
            if ( rekapitulasiAbsensi.getCompanyId() != 0 ){
                sql += " AND `hr_employee`.`COMPANY_ID` = " + rekapitulasiAbsensi.getCompanyId();
            }
            if (rekapitulasiAbsensi.getArrDivision(0)!=null) {
                String[] divisionId = rekapitulasiAbsensi.getArrDivision(0);
                    if (! (divisionId!=null && (divisionId[0].equals("0")))) {
                    sql += " AND (";
                    for (int i=0; i<divisionId.length; i++) {
                        sql = sql + " `hr_employee`."+PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID]+
                                    " = "+ divisionId[i] + " OR ";
                        if (i==(divisionId.length-1)) {
                            sql = sql.substring(0, sql.length()-4);
                        }
                    }
                    sql += " )";
                }
               
            }
            
            if (rekapitulasiAbsensi.getArrDepartment(0)!=null) {
                String[] departmentId = rekapitulasiAbsensi.getArrDepartment(0);
                    if (! (departmentId!=null && (departmentId[0].equals("0")))) {
                    sql += " AND (";
                    for (int i=0; i<departmentId.length; i++) {
                        sql = sql + " `hr_employee`."+PstEmployee.fieldNames[PstEmployee.FLD_DEPARTMENT_ID]+
                                    " = "+ departmentId[i] + " OR ";
                        if (i==(departmentId.length-1)) {
                            sql = sql.substring(0, sql.length()-4);
                        }
                    }
                    sql += " )";
                }
               
            }
            
            if (rekapitulasiAbsensi.getArrSection(0)!=null) {
                String[] sectionId = rekapitulasiAbsensi.getArrSection(0);
                    if (! (sectionId!=null && (sectionId[0].equals("0")))) {
                    sql += " AND (";
                    for (int i=0; i<sectionId.length; i++) {
                        sql = sql + " `hr_employee`."+PstEmployee.fieldNames[PstEmployee.FLD_SECTION_ID]+
                                    " = "+ sectionId[i] + " OR ";
                        if (i==(sectionId.length-1)) {
                            sql = sql.substring(0, sql.length()-4);
                        }
                    }
                    sql += " )";
                }
               
            }
            
             if (rekapitulasiAbsensi.getArrPosition(0)!=null) {
                String[] positionId = rekapitulasiAbsensi.getArrPosition(0);
                    if (! (positionId!=null && (positionId[0].equals("0")))) {
                    sql += " AND (";
                    for (int i=0; i<positionId.length; i++) {
                        sql = sql + " `hr_employee`."+PstEmployee.fieldNames[PstEmployee.FLD_POSITION_ID]+
                                    " = "+ positionId[i] + " OR ";
                        if (i==(positionId.length-1)) {
                            sql = sql.substring(0, sql.length()-4);
                        }
                    }
                    sql += " )";
                }
               
            }
            
            
            if ( rekapitulasiAbsensi.getDtFrom() != null && rekapitulasiAbsensi.getDtTo() != null){
                sql += " AND (`hr_emp_doc`.`DATE_OF_ISSUE` BETWEEN \"" +  Formater.formatDate(rekapitulasiAbsensi.getDtFrom(), "yyyy-MM-dd 00:00:00") + "\" AND \""+  Formater.formatDate(rekapitulasiAbsensi.getDtTo(), "yyyy-MM-dd 23:59:59 \")" ) ;
            }
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                EmpDocSpj empDocSpj = new EmpDocSpj();
                empDocSpj.setEmpDocId(rs.getLong("hr_emp_doc.EMP_DOC_ID"));
                empDocSpj.setDocNumber(rs.getString("hr_emp_doc.DOC_NUMBER"));
                empDocSpj.setRequestDate(rs.getDate("hr_emp_doc.REQUEST_DATE"));
                empDocSpj.setFullName(rs.getString("hr_employee.FULL_NAME"));
                empDocSpj.setLevelId(rs.getLong("hr_employee.GRADE_LEVEL_ID"));
                empDocSpj.setEmployeeId(rs.getLong("hr_employee.EMPLOYEE_ID"));
                empDocSpj.setPositionId(rs.getLong("hr_employee.POSITION_ID"));
                empDocSpj.setDocMasterId(rs.getLong("hr_doc_master.DOC_MASTER_ID"));
                
                lists.add(empDocSpj);
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

    public static Vector list(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT * FROM " + TBL_HR_EMP_DOC;
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
                EmpDoc empDoc = new EmpDoc();
                resultToObject(rs, empDoc);
                lists.add(empDoc);
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

    public static Vector listSpecial(int limitStart, int recordToGet, String whereClause, String order, searchEmpDoc seaDoc) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT * FROM " + TBL_HR_EMP_DOC;
            sql = sql + " WHERE 1=1 ";
            if (seaDoc.getDoc_master_id() > 0) {
                sql = sql + " AND " + PstEmpDoc.fieldNames[PstEmpDoc.FLD_DOC_MASTER_ID] + " = " + seaDoc.getDoc_master_id();
            }
            if (seaDoc.getDocTitle().length() > 0) {
                sql = sql + " AND " + PstEmpDoc.fieldNames[PstEmpDoc.FLD_DOC_TITLE] + " LIKE \"%" + seaDoc.getDocTitle() + "%\"";
            }
            if (seaDoc.getDocNumber().length() > 0) {
                sql = sql + " AND " + PstEmpDoc.fieldNames[PstEmpDoc.FLD_DOC_NUMBER] + " LIKE \"%" + seaDoc.getDocNumber() + "%\"";
            }
            if (seaDoc.getDocStatus() > -1) {
                sql = sql + " AND DOC_STATUS = " + seaDoc.getDocStatus();
            }
            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " AND " + whereClause;
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
                EmpDoc empDoc = new EmpDoc();
                resultToObject(rs, empDoc);
                lists.add(empDoc);
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

    public static int listSpecialCount(int limitStart, int recordToGet, String whereClause, String order, searchEmpDoc seaDoc) {
        int count = 0;
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT COUNT(" + PstEmpDoc.fieldNames[PstEmpDoc.FLD_EMP_DOC_ID] + ") FROM " + TBL_HR_EMP_DOC;
            sql = sql + " WHERE 1=1 ";
            if (seaDoc.getDoc_master_id() > 0) {
                sql = sql + " AND " + PstEmpDoc.fieldNames[PstEmpDoc.FLD_DOC_MASTER_ID] + " = " + seaDoc.getDoc_master_id();
            }
            if (seaDoc.getDocTitle().length() > 0) {
                sql = sql + " AND " + PstEmpDoc.fieldNames[PstEmpDoc.FLD_DOC_TITLE] + " LIKE \"%" + seaDoc.getDocTitle() + "%\"";
            }
            if (seaDoc.getDocNumber().length() > 0) {
                sql = sql + " AND " + PstEmpDoc.fieldNames[PstEmpDoc.FLD_DOC_NUMBER] + " LIKE \"%" + seaDoc.getDocNumber() + "%\"";
            }
            if (seaDoc.getDocStatus() > -1) {
                sql = sql + " AND DOC_STATUS = " + seaDoc.getDocStatus();
            }
            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " AND " + whereClause;
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
                count = rs.getInt(1);
            }
            rs.close();
            return count;

        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return count;
    }

    public static void fetchGeoAddress(EmpDoc empDoc) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        if ((empDoc == null) || (empDoc.getOID() == 0)) {
            return;
        }
        try {
            String sql =
                    "SELECT e." + fieldNames[FLD_EMP_DOC_ID]
                    + ", n." + PstNegara.fieldNames[PstNegara.FLD_NM_NEGARA] + " AS NEG "
                    + ", p." + PstProvinsi.fieldNames[PstProvinsi.FLD_NM_PROVINSI] + " AS PROV "
                    + ", k." + PstKabupaten.fieldNames[PstKabupaten.FLD_NM_KABUPATEN] + " AS KAB "
                    + ", c." + PstKecamatan.fieldNames[PstKecamatan.FLD_NM_KECAMATAN] + " AS KEC "
                    + " FROM " + TBL_HR_EMP_DOC + " e "
                    + " LEFT JOIN " + PstNegara.TBL_BKD_NEGARA + " n ON e." + fieldNames[FLD_COUNTRY_ID] + "=n." + PstNegara.fieldNames[PstNegara.FLD_ID_NEGARA]
                    + " LEFT JOIN " + PstProvinsi.TBL_HR_PROPINSI + " p ON e." + fieldNames[FLD_PROVINCE_ID] + "= p." + PstProvinsi.fieldNames[PstProvinsi.FLD_ID_PROVINSI]
                    + " LEFT JOIN " + PstKabupaten.TBL_HR_KABUPATEN + " k ON e." + fieldNames[FLD_REGION_ID] + " = k." + PstKabupaten.fieldNames[PstKabupaten.FLD_ID_KABUPATEN]
                    + " LEFT JOIN " + PstKecamatan.TBL_HR_KECAMATAN + " c ON e." + fieldNames[FLD_SUBREGION_ID] + "= c." + PstKecamatan.fieldNames[PstKecamatan.FLD_ID_KECAMATAN]
                    + " WHERE " + fieldNames[FLD_EMP_DOC_ID] + "=\"" + empDoc.getOID() + "\"";

            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                empDoc.setGeo_address(
                        "" + rs.getString("NEG") + ", "
                        + rs.getString("PROV") + ", "
                        + rs.getString("KAB") + ", "
                        + rs.getString("KEC"));
            }
            empDoc.setGeo_address(empDoc.getGeo_address().replaceAll("null", "-"));
            rs.close();
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return;
    }

    public static String GetGeoAddress(EmpDoc empDoc) {
        Vector lists = new Vector();
        String geo = "";
        DBResultSet dbrs = null;
        if ((empDoc == null) || (empDoc.getOID() == 0)) {
            return null;
        }
        try {
            String sql =
                    "SELECT e." + fieldNames[FLD_EMP_DOC_ID]
                    + ", n." + PstNegara.fieldNames[PstNegara.FLD_NM_NEGARA] + " AS NEG "
                    + ", p." + PstProvinsi.fieldNames[PstProvinsi.FLD_NM_PROVINSI] + " AS PROV "
                    + ", k." + PstKabupaten.fieldNames[PstKabupaten.FLD_NM_KABUPATEN] + " AS KAB "
                    + ", c." + PstKecamatan.fieldNames[PstKecamatan.FLD_NM_KECAMATAN] + " AS KEC "
                    + " FROM " + TBL_HR_EMP_DOC + " e "
                    + " LEFT JOIN " + PstNegara.TBL_BKD_NEGARA + " n ON e." + fieldNames[FLD_COUNTRY_ID] + "=n." + PstNegara.fieldNames[PstNegara.FLD_ID_NEGARA]
                    + " LEFT JOIN " + PstProvinsi.TBL_HR_PROPINSI + " p ON e." + fieldNames[FLD_PROVINCE_ID] + "= p." + PstProvinsi.fieldNames[PstProvinsi.FLD_ID_PROVINSI]
                    + " LEFT JOIN " + PstKabupaten.TBL_HR_KABUPATEN + " k ON e." + fieldNames[FLD_REGION_ID] + " = k." + PstKabupaten.fieldNames[PstKabupaten.FLD_ID_KABUPATEN]
                    + " LEFT JOIN " + PstKecamatan.TBL_HR_KECAMATAN + " c ON e." + fieldNames[FLD_SUBREGION_ID] + "= c." + PstKecamatan.fieldNames[PstKecamatan.FLD_ID_KECAMATAN]
                    + " WHERE " + fieldNames[FLD_EMP_DOC_ID] + "=\"" + empDoc.getOID() + "\"";

            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                geo = ("" + rs.getString("NEG") + ", " + rs.getString("PROV") + ", " + rs.getString("KAB") + ", " + rs.getString("KEC"));
            }
            geo = geo.replaceAll("null", "-");
            rs.close();
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return geo;
    }

    public static void resultToObject(ResultSet rs, EmpDoc empDoc) {
        try {



            empDoc.setOID(rs.getLong(PstEmpDoc.fieldNames[PstEmpDoc.FLD_EMP_DOC_ID]));
            empDoc.setDoc_master_id(rs.getLong(PstEmpDoc.fieldNames[PstEmpDoc.FLD_DOC_MASTER_ID]));
            empDoc.setDoc_title(rs.getString(PstEmpDoc.fieldNames[PstEmpDoc.FLD_DOC_TITLE]));
            empDoc.setRequest_date(rs.getDate(PstEmpDoc.fieldNames[PstEmpDoc.FLD_REQUEST_DATE]));
            empDoc.setDoc_number(rs.getString(PstEmpDoc.fieldNames[PstEmpDoc.FLD_DOC_NUMBER]));
            empDoc.setDate_of_issue(rs.getDate(PstEmpDoc.fieldNames[PstEmpDoc.FLD_DATE_OF_ISSUE]));
            empDoc.setPlan_date_from(rs.getDate(PstEmpDoc.fieldNames[PstEmpDoc.FLD_PLAN_DATE_FROM]));
            empDoc.setPlan_date_to(rs.getDate(PstEmpDoc.fieldNames[PstEmpDoc.FLD_PLAN_DATE_TO]));
            empDoc.setReal_date_from(rs.getDate(PstEmpDoc.fieldNames[PstEmpDoc.FLD_REAL_DATE_FROM]));
            empDoc.setReal_date_to(rs.getDate(PstEmpDoc.fieldNames[PstEmpDoc.FLD_REAL_DATE_TO]));
            empDoc.setObjectives(rs.getString(PstEmpDoc.fieldNames[PstEmpDoc.FLD_OBJECTIVES]));
            empDoc.setDetails(rs.getString(PstEmpDoc.fieldNames[PstEmpDoc.FLD_DETAILS]));
            empDoc.setCountry_id(rs.getLong(PstEmpDoc.fieldNames[PstEmpDoc.FLD_COUNTRY_ID]));
            empDoc.setProvince_id(rs.getLong(PstEmpDoc.fieldNames[PstEmpDoc.FLD_PROVINCE_ID]));
            empDoc.setRegion_id(rs.getLong(PstEmpDoc.fieldNames[PstEmpDoc.FLD_REGION_ID]));
            empDoc.setSubregion_id(rs.getLong(PstEmpDoc.fieldNames[PstEmpDoc.FLD_SUBREGION_ID]));
            empDoc.setGeo_address(rs.getString(PstEmpDoc.fieldNames[PstEmpDoc.FLD_GEO_ADDRESS]));
            empDoc.setDocAttachFile(rs.getString(PstEmpDoc.fieldNames[PstEmpDoc.FLD_DOCH_ATTACH_FILE]));
            empDoc.setFileName(rs.getString(PstEmpDoc.fieldNames[PstEmpDoc.FLD_FILE_NAME]));
            empDoc.setCompanyId(rs.getLong(PstEmpDoc.fieldNames[PstEmpDoc.FLD_COMPANY_ID]));
            empDoc.setDivisionId(rs.getLong(PstEmpDoc.fieldNames[PstEmpDoc.FLD_DIVISION_ID]));
            empDoc.setDepartmentId(rs.getLong(PstEmpDoc.fieldNames[PstEmpDoc.FLD_DEPARTMENT_ID]));
            empDoc.setSectionId(rs.getLong(PstEmpDoc.fieldNames[PstEmpDoc.FLD_SECTION_ID]));
            empDoc.setDocStatus(rs.getInt(PstEmpDoc.fieldNames[PstEmpDoc.FLD_DOC_STATUS]));
			empDoc.setLeaveId(rs.getLong(PstEmpDoc.fieldNames[PstEmpDoc.FLD_LEAVE_APPLICATION_ID]));

        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long empDocId) {
        DBResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + TBL_HR_EMP_DOC + " WHERE "
                    + PstEmpDoc.fieldNames[PstEmpDoc.FLD_EMP_DOC_ID] + " = " + empDocId;

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

    public static Long getEmpDocFinalId(String noSk) {
        DBResultSet dbrs = null;
        long value = 0;
        try {
            String sql = "SELECT " + PstEmpDoc.fieldNames[PstEmpDoc.FLD_EMP_DOC_ID] + " FROM " + TBL_HR_EMP_DOC + " WHERE "
                    + PstEmpDoc.fieldNames[PstEmpDoc.FLD_DOC_NUMBER] + " = \"" + noSk + "\"";
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();


            while (rs.next()) {
                value = rs.getLong(1);
            }

            rs.close();
            return value;
        } catch (Exception e) {
            return value;
        } finally {
            DBResultSet.close(dbrs);
        }
    }
	
	public static boolean checkNoSk(String noSk) {
        DBResultSet dbrs = null;
        boolean isTrue = false;
        try {
            String sql = "SELECT " + PstEmpDoc.fieldNames[PstEmpDoc.FLD_EMP_DOC_ID] + " FROM " + TBL_HR_EMP_DOC + " WHERE "
                    + PstEmpDoc.fieldNames[PstEmpDoc.FLD_DOC_NUMBER] + " = \"" + noSk + "\"";
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();


            while (rs.next()) {
                isTrue = true;
            }

            rs.close();
            return isTrue;
        } catch (Exception e) {
            return isTrue;
        } finally {
            DBResultSet.close(dbrs);
        }
    }

    public static int getCount(String whereClause) {
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT COUNT(" + PstEmpDoc.fieldNames[PstEmpDoc.FLD_EMP_DOC_ID] + ") FROM " + TBL_HR_EMP_DOC;
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

    public static int findLimitCommand(int start, int recordToGet, int vectSize) {
        int cmd = Command.LIST;
        int mdl = vectSize % recordToGet;
        vectSize = vectSize + (recordToGet - mdl);
        if (start == 0) {
            cmd = Command.FIRST;
        } else {
            if (start == (vectSize - recordToGet)) {
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
        }

        return cmd;
    }

    /**
     * get field index that will update
     *
     * @param employeeId
     * @return
     * @created by Priska
     */
    public static int updateEmpDoc(long empDocId, int status) {
        int result = 0;
        DBResultSet dbrs = null;
        try {
            String sql = "UPDATE " + PstEmpDoc.TBL_HR_EMP_DOC
                    + " SET DOC_STATUS = " + status
                    + " WHERE " + PstEmpDoc.fieldNames[PstEmpDoc.FLD_EMP_DOC_ID]
                    + " = " + empDocId;
            result = DBHandler.execUpdate(sql);
        } catch (Exception e) {
            System.out.println("Exc update emp document status : " + e.toString());
        } finally {
            DBResultSet.close(dbrs);
            return result;
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
                    EmpDoc empDoc = (EmpDoc) list.get(ls);
                    if (oid == empDoc.getOID()) {
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

    public static void updateFileName(String fileName, long idEmpDoc) {
        try {
            String sql = "UPDATE " + PstEmpDoc.TBL_HR_EMP_DOC
                    + " SET " + PstEmpDoc.fieldNames[FLD_FILE_NAME] + " = '" + fileName + "'"
                    + " WHERE " + PstEmpDoc.fieldNames[PstEmpDoc.FLD_EMP_DOC_ID]
                    + " = " + idEmpDoc;
            System.out.println("sql PstEmpDoc.updateFileName : " + sql);
            int result = DBHandler.execUpdate(sql);
        } catch (Exception e) {
            System.out.println("\tExc updateFileName : " + e.toString());
        } finally {
            //System.out.println("\tFinal updatePresenceStatus");
        }
    }
    
    public static int updateSchedule(long docId){
        int result = 0;
        
        String listOidDocSPJKR40 = String.valueOf(PstSystemProperty.getValueByName("OID_SPJKR40_DOC"));
        String listOidDocSPJLB40 = String.valueOf(PstSystemProperty.getValueByName("OID_SPJLB40_DOC"));
        String listOidDocSPJLK = String.valueOf(PstSystemProperty.getValueByName("OID_SPJLK_DOC"));
        String listOidDocSPJDKLT = String.valueOf(PstSystemProperty.getValueByName("OID_SPJDKLT_DOC"));
        String oidSPJKR40Sym = String.valueOf(PstSystemProperty.getValueByName("OID_SPJKR40"));
        String oidSPJLB40Sym = String.valueOf(PstSystemProperty.getValueByName("OID_SPJLB40"));
        String oidSPJLK = String.valueOf(PstSystemProperty.getValueByName("OID_SPJLK"));
        String oidSPJDKLT = String.valueOf(PstSystemProperty.getValueByName("OID_SPJDKLT"));
        String fieldStartDate = PstSystemProperty.getValueByName("START_DATE_FIELD_NAME_SPJ");
        String fieldEndDate = PstSystemProperty.getValueByName("END_DATE_FIELD_NAME_SPJ");
        
        String[] oidDocSPJKR40 = listOidDocSPJKR40.split(",");
        String[] oidDocSPJLB40 = listOidDocSPJLB40.split(",");
        String[] oidDocSPJLK = listOidDocSPJLK.split(",");
        String[] oidDocSPJDKLT = listOidDocSPJDKLT.split(",");
        
        
        EmpDoc empDoc = new EmpDoc();
        
        try{
            empDoc = PstEmpDoc.fetchExc(docId);
        } catch (Exception exc){
            System.out.println(exc.toString());
        }
        
        String whereEmpDocField = " (" + PstEmpDocField.fieldNames[PstEmpDocField.FLD_OBJECT_NAME] + " = '" + fieldStartDate + "'"
                                + " OR " + PstEmpDocField.fieldNames[PstEmpDocField.FLD_OBJECT_NAME] + " = '" + fieldEndDate + "' ) "
                                + " AND " + PstEmpDocField.fieldNames[PstEmpDocField.FLD_EMP_DOC_ID] + " = " + docId;
        Vector listEmpDocField = PstEmpDocField.list(0, 0, whereEmpDocField, "");
        
        String whereEmpDocList = " (" + PstEmpDocList.fieldNames[PstEmpDocList.FLD_OBJECT_NAME] + " = 'TRAINNER2' OR "
                                + PstEmpDocList.fieldNames[PstEmpDocList.FLD_OBJECT_NAME] + " = 'TRAINNERLISTLINE' ) AND "
                                + PstEmpDocField.fieldNames[PstEmpDocField.FLD_EMP_DOC_ID] + " = " + docId;
        Vector listEmpDocList = PstEmpDocList.list(0, 0, whereEmpDocList, "");
        
        DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
        Date startDate = new Date();
        Date endDate = new Date();
        boolean startDateSetted = false;
        boolean endDateSetted = false;
        if (listEmpDocField.size() > 0){
            for (int i = 0; i < listEmpDocField.size() ; i++){
                EmpDocField empDocField = (EmpDocField) listEmpDocField.get(i);
                if (empDocField.getObject_name().equals(fieldStartDate)){
                    try {
                        startDate = df.parse(empDocField.getValue());
                        startDateSetted = true;
                    } catch (Exception exc){
                        System.out.println(exc.toString());
                    }
                } else if (empDocField.getObject_name().equals(fieldEndDate)){
                    try {
                        endDate = df.parse(empDocField.getValue());
                        endDateSetted = true;
                    } catch (Exception exc){
                        System.out.println(exc.toString());
                    }
                } 
            }
            //add by Eri Yudi 2022-01-06 untuk check update schedule dari spj jika tgl start atau end tidak di isi
            if(startDateSetted==false || endDateSetted==false){
                if(startDateSetted==false){
                    startDate = endDate;
                }else{
                    endDate = startDate;
                }
                     
            }
        }
        
        int dayDiff = (int) DateCalc.dayDifference( startDate,endDate);
        Date newDate = new Date();
        
        if (listEmpDocList.size() > 0) {
            for (int idxEmp = 0; idxEmp < listEmpDocList.size(); idxEmp++) {
                newDate = startDate;
                EmpDocList empDocList = (EmpDocList) listEmpDocList.get(idxEmp);
                for (int idx = 0; idx < (dayDiff + 1); idx++) {
                    long schId = SessEmpSchedule.getSchId(empDocList.getEmployee_id(), newDate);

                    if (schId != 0) {
                        for (int i=0; i < oidDocSPJKR40.length;i++){
                            if (empDoc.getDoc_master_id() == Long.valueOf(oidDocSPJKR40[i])) {
                                //add by Eri Yudi 2020-09-28 for set D2N schedule
                                  long oldSchOid  = SessEmpSchedule.getSchOid(newDate, schId);
                                 int scheduleD2 = SessEmpSchedule.updateSchedule2(newDate, schId,oldSchOid);
                                 //end
                                int schedule = SessEmpSchedule.updateSchedule(newDate, schId, oidSPJKR40Sym);
                            }
                        }
                        for (int x=0; x < oidDocSPJLB40.length; x++){
                            if (empDoc.getDoc_master_id() == Long.valueOf(oidDocSPJLB40[x])) {
                                //add by Eri Yudi 2020-09-28 for set D2N schedule
                                 long oldSchOid  = SessEmpSchedule.getSchOid(newDate, schId) ;
                                 int scheduleD2 = SessEmpSchedule.updateSchedule2(newDate,schId,oldSchOid);
                                 //end
                                int schedule = SessEmpSchedule.updateSchedule(newDate, schId, oidSPJLB40Sym);
                            }
                        }
                        for (int n=0; n < oidDocSPJLK.length; n++){
                             if (empDoc.getDoc_master_id() == Long.valueOf(oidDocSPJLK[n])) {
                                 //add by Eri Yudi 2020-09-28 for set D2N schedule
                                 long oldSchOid  = SessEmpSchedule.getSchOid(newDate, schId) ;
                                 int scheduleD2 = SessEmpSchedule.updateSchedule2(newDate,schId,oldSchOid);
                                 //end
                                int schedule = SessEmpSchedule.updateSchedule(newDate, schId, oidSPJLK);
                            }
                        }
                        for (int m=0; m < oidDocSPJDKLT.length; m++){
                             if (empDoc.getDoc_master_id() == Long.valueOf(oidDocSPJDKLT[m])) {
                                 //add by Eri Yudi 2020-09-28 for set D2N schedule
                                 long oldSchOid = SessEmpSchedule.getSchOid(newDate, schId) ;
                                 int scheduleD2 = SessEmpSchedule.updateSchedule2(newDate,schId,oldSchOid);
                                 //end
                                int schedule = SessEmpSchedule.updateSchedule(newDate, schId, oidSPJDKLT);
                            }
                        }
                         
                    }
                    long tmpDate = newDate.getTime() + (24 * 60 * 60 * 1000);
                    newDate = new Date(tmpDate);
                    //startDate = newDate;
                }
            }
        }
    
        
        return result;
    }
    
    public static int cancelUpdateSchedule(long docId){
        int result = 0;
        
        String listOidDocSPJKR40 = String.valueOf(PstSystemProperty.getValueByName("OID_SPJKR40_DOC"));
        String listOidDocSPJLB40 = String.valueOf(PstSystemProperty.getValueByName("OID_SPJLB40_DOC"));
        String listOidDocSPJLK = String.valueOf(PstSystemProperty.getValueByName("OID_SPJLK_DOC"));
        String listOidDocSPJDKLT = String.valueOf(PstSystemProperty.getValueByName("OID_SPJDKLT_DOC"));
        String fieldStartDate = PstSystemProperty.getValueByName("START_DATE_FIELD_NAME_SPJ");
        String fieldEndDate = PstSystemProperty.getValueByName("END_DATE_FIELD_NAME_SPJ");
        
        String[] oidDocSPJKR40 = listOidDocSPJKR40.split(",");
        String[] oidDocSPJLB40 = listOidDocSPJLB40.split(",");
        String[] oidDocSPJLK = listOidDocSPJLK.split(",");
        String[] oidDocSPJDKLT = listOidDocSPJDKLT.split(",");
        
        
        EmpDoc empDoc = new EmpDoc();
        
        try{
            empDoc = PstEmpDoc.fetchExc(docId);
        } catch (Exception exc){
            System.out.println(exc.toString());
        }
        
        String whereEmpDocField = " (" + PstEmpDocField.fieldNames[PstEmpDocField.FLD_OBJECT_NAME] + " = '" + fieldStartDate + "'"
                                + " OR " + PstEmpDocField.fieldNames[PstEmpDocField.FLD_OBJECT_NAME] + " = '" + fieldEndDate + "' ) "
                                + " AND " + PstEmpDocField.fieldNames[PstEmpDocField.FLD_EMP_DOC_ID] + " = " + docId;
        Vector listEmpDocField = PstEmpDocField.list(0, 0, whereEmpDocField, "");
        
        String whereEmpDocList = " (" + PstEmpDocList.fieldNames[PstEmpDocList.FLD_OBJECT_NAME] + " = 'TRAINNER2' OR "
                                + PstEmpDocList.fieldNames[PstEmpDocList.FLD_OBJECT_NAME] + " = 'TRAINNERLISTLINE' ) AND "
                                + PstEmpDocField.fieldNames[PstEmpDocField.FLD_EMP_DOC_ID] + " = " + docId;
        Vector listEmpDocList = PstEmpDocList.list(0, 0, whereEmpDocList, "");
        
        DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
        Date startDate = new Date();
        Date endDate = new Date();
        
        if (listEmpDocField.size() > 0){
            for (int i = 0; i < listEmpDocField.size() ; i++){
                EmpDocField empDocField = (EmpDocField) listEmpDocField.get(i);
                if (empDocField.getObject_name().equals(fieldStartDate)){
                    try {
                        startDate = df.parse(empDocField.getValue());
                    } catch (Exception exc){
                        System.out.println(exc.toString());
                    }
                } else if (empDocField.getObject_name().equals(fieldEndDate)){
                    try {
                        endDate = df.parse(empDocField.getValue());
                    } catch (Exception exc){
                        System.out.println(exc.toString());
                    }
                } 
            }
        }
        
        int dayDiff = (int) DateCalc.dayDifference( startDate,endDate);
        Date newDate = new Date();
        
        if (listEmpDocList.size() > 0) {
            for (int idxEmp = 0; idxEmp < listEmpDocList.size(); idxEmp++) {
                newDate = startDate;
                EmpDocList empDocList = (EmpDocList) listEmpDocList.get(idxEmp);
                for (int idx = 0; idx < (dayDiff + 1); idx++) {
                    long schId = SessEmpSchedule.getSchId(empDocList.getEmployee_id(), newDate);

                    if (schId != 0) {
                        for (int i=0; i < oidDocSPJKR40.length;i++){
                            if (empDoc.getDoc_master_id() == Long.valueOf(oidDocSPJKR40[i])) {
                                //add by Eri Yudi 2020-09-28 for set D2N schedule
                                  long oldSchOid  = SessEmpSchedule.getSchD2NOid(newDate, schId);
                                 int scheduleD2 = SessEmpSchedule.updateSchedule2(newDate, schId,0);
                                 //end
                                int schedule = SessEmpSchedule.cancelUpdateSchedule(newDate, schId, oldSchOid);
                            }
                        }
                        for (int x=0; x < oidDocSPJLB40.length; x++){
                            if (empDoc.getDoc_master_id() == Long.valueOf(oidDocSPJLB40[x])) {
                                //add by Eri Yudi 2020-09-28 for set D2N schedule
                                 long oldSchOid  = SessEmpSchedule.getSchD2NOid(newDate, schId) ;
                                 int scheduleD2 = SessEmpSchedule.updateSchedule2(newDate,schId,0);
                                 //end
                                int schedule = SessEmpSchedule.cancelUpdateSchedule(newDate, schId, oldSchOid);
                            }
                        }
                        for (int n=0; n < oidDocSPJLK.length; n++){
                             if (empDoc.getDoc_master_id() == Long.valueOf(oidDocSPJLK[n])) {
                                 //add by Eri Yudi 2020-09-28 for set D2N schedule
                                 long oldSchOid  = SessEmpSchedule.getSchD2NOid(newDate, schId) ;
                                 int scheduleD2 = SessEmpSchedule.updateSchedule2(newDate,schId,0);
                                 //end
                                int schedule = SessEmpSchedule.cancelUpdateSchedule(newDate, schId, oldSchOid);
                            }
                        }
                        for (int m=0; m < oidDocSPJDKLT.length; m++){
                             if (empDoc.getDoc_master_id() == Long.valueOf(oidDocSPJDKLT[m])) {
                                 //add by Eri Yudi 2020-09-28 for set D2N schedule
                                 long oldSchOid = SessEmpSchedule.getSchD2NOid(newDate, schId) ;
                                 int scheduleD2 = SessEmpSchedule.updateSchedule2(newDate,schId,0);
                                 //end
                                int schedule = SessEmpSchedule.cancelUpdateSchedule(newDate, schId, oldSchOid);
                            }
                        }
                         
                    }
                    long tmpDate = newDate.getTime() + (24 * 60 * 60 * 1000);
                    newDate = new Date(tmpDate);
                    //startDate = newDate;
                }
            }
        }
    
        
        return result;
    }
        public static Hashtable fetchExcHashtableComponent(long oid) {
        Hashtable hashtableComp = new Hashtable();
        try {
            
            PayComponent payComp = new PayComponent();
            EmpDocListExpense docExpense = new EmpDocListExpense();
            double totalValue = 0;
            
            try {
                docExpense = PstEmpDocListExpense.fetchExc(oid);
            } catch (Exception exc) {
                System.out.println(exc.toString());
            }
            
            try {
                payComp = PstPayComponent.fetchExc(docExpense.getComponentId());
            } catch (Exception exc) {
                System.out.println(exc.toString());
            }
            
            payComp.setOID(docExpense.getComponentId());

            hashtableComp.put(PstPayComponent.fieldNames[PstPayComponent.FLD_COMP_NAME], payComp.getCompName());
            hashtableComp.put(PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_DAY_LENGTH], ""+docExpense.getDayLength());
            hashtableComp.put(PstEmpDocListExpense.fieldNames[PstEmpDocListExpense.FLD_COMP_VALUE], ""+docExpense.getCompValue());
            totalValue = docExpense.getDayLength() * docExpense.getCompValue();
            if (totalValue > 0){
                hashtableComp.put("COMP_TOTAL_VALUE",""+totalValue);
            } else {
                hashtableComp.put("COMP_TOTAL_VALUE","-");
            }
        } catch (Exception e) {
            
        }
        return hashtableComp;
    }
        
    public static boolean isScheduleSPJ(String scheduleId){
        boolean isSPJ = false;
        
        String oidSPJKR40Sym = String.valueOf(PstSystemProperty.getValueByName("OID_SPJKR40"));
        String oidSPJLB40Sym = String.valueOf(PstSystemProperty.getValueByName("OID_SPJLB40"));
        String oidSPJLK = String.valueOf(PstSystemProperty.getValueByName("OID_SPJLK"));
        String oidSPJDKLT = String.valueOf(PstSystemProperty.getValueByName("OID_SPJDKLT"));
        
        try {
            if (scheduleId.equals(oidSPJKR40Sym) || scheduleId.equals(oidSPJLB40Sym) || scheduleId.equals(oidSPJLK) || scheduleId.equals(oidSPJDKLT)){
                isSPJ = true;
            }
        } catch (Exception exc){}
        
        
        return isSPJ;
        
    }
    
    public static long getDocOidByDate(Date date, long employeeId){
        long oid = 0;
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT "
                        + "EMP_DOC_ID,"
                        + "START_DATE,"
                        + "END_DATE "
                    + "FROM ("
                            + "SELECT "
                            + "EMP_DOC_ID,"
                            + "(SELECT VALUE FROM `hr_emp_doc_field` WHERE emp_doc_id = lst.emp_doc_id AND `OBJECT_NAME` = 'TGL_BERANGKAT' LIMIT 1) AS START_DATE,"
                            + "(SELECT VALUE FROM `hr_emp_doc_field` WHERE emp_doc_id = lst.emp_doc_id AND `OBJECT_NAME` = 'TGL_KEMBALI' LIMIT 1) AS END_DATE "
                        + "FROM "
                            + "`hr_emp_doc_list` lst "
                        + "WHERE employee_id = "+employeeId+" AND OBJECT_NAME != 1) AS DATA "
                    + "WHERE '"+Formater.formatDate(date,"yyyy-MM-dd")+"' BETWEEN START_DATE AND END_DATE";
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                oid = rs.getLong("EMP_DOC_ID");
            }
        } catch (Exception exc){}
        
        return oid;
    }
    
    public static long getDocOidBetweenDate(String startDate, String endDate, long employeeId){
        long oid = 0;
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT "
                        + "EMP_DOC_ID,"
                        + "START_DATE,"
                        + "END_DATE "
                    + "FROM ("
                            + "SELECT "
                            + "EMP_DOC_ID,"
                            + "(SELECT VALUE FROM `hr_emp_doc_field` WHERE emp_doc_id = lst.emp_doc_id AND `OBJECT_NAME` = 'TGL_BERANGKAT' LIMIT 1) AS START_DATE,"
                            + "(SELECT VALUE FROM `hr_emp_doc_field` WHERE emp_doc_id = lst.emp_doc_id AND `OBJECT_NAME` = 'TGL_KEMBALI' LIMIT 1) AS END_DATE "
                        + "FROM "
                            + "`hr_emp_doc_list` lst "
                        + "WHERE employee_id = "+employeeId+") AS DATA "
                    + "WHERE (('"+startDate+"' BETWEEN START_DATE AND END_DATE) "
                    + "OR ('"+endDate+"' BETWEEN START_DATE AND END_DATE) "
                    + "OR (START_DATE BETWEEN '"+startDate+"' AND '"+endDate+"') "
                    + "OR (END_DATE BETWEEN '"+startDate+"' AND '"+endDate+"')) AND DOC_STATUS NOT IN (4,6) ";
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                oid = rs.getLong("EMP_DOC_ID");
            }
        } catch (Exception exc){}
        
        return oid;
    }
    
}


/* Created on 	:  [date] [time] AM/PM 
 * 
 * @author	 :
 * @version	 :
 */
/**
 * *****************************************************************
 * Class Description : [project description ... ] Imput Parameters : [input
 * parameter ...] Output : [output ...]
 * *****************************************************************
 */
package com.dimata.harisma.entity.employee.appraisal;

/* package java */
import com.dimata.harisma.entity.attendance.EmpSchedule;
import com.dimata.harisma.entity.attendance.PstEmpSchedule;
import com.dimata.harisma.entity.employee.*;
import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;

/* package qdep */
import com.dimata.util.lang.I_Language;
import com.dimata.util.*;
import com.dimata.qdep.db.*;
import com.dimata.qdep.entity.*;

/* package harisma */
//import com.dimata.harisma.db.DBHandler;
//import com.dimata.harisma.db.DBException;
//import com.dimata.harisma.db.DBLogger;
import com.dimata.harisma.entity.employee.*;
import com.dimata.harisma.entity.employee.assessment.AssessmentFormItem;
import com.dimata.harisma.entity.employee.assessment.PstAssessmentFormItem;
import com.dimata.harisma.entity.masterdata.Period;
import com.dimata.harisma.entity.masterdata.PstPeriod;
import static com.dimata.harisma.entity.payroll.PstPaySlip.checkString;

public class PstAppraisal extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {

    public static final String TBL_HR_APPRAISAL = "hr_appraisal";//

    /*
     HR_APPRAISAL_ID` bigint(20) NOT NULL default '0',
     `EMP_COMMENT` text collate latin1_general_ci,
     `ASS_COMMENT` text collate latin1_general_ci,
     `RATING` float default NULL,
     `HR_APP_MAIN_ID` bigint(20) NOT NULL default '0',
     `ASS_FORM_ITEM_ID` bigint(20) default NULL,
     */
    public static final int FLD_APPRAISAL_ID = 0;
    public static final int FLD_ASS_FORM_ITEM_ID = 1;
    public static final int FLD_APP_MAIN_ID = 2;
    public static final int FLD_EMP_COMMENT = 3;
    public static final int FLD_ASS_COMMENT = 4;
    public static final int FLD_RATING = 5;
    public static final int FLD_ANSWER_1 = 6;
    public static final int FLD_ANSWER_2 = 7;
    public static final int FLD_ANSWER_3 = 8;
    public static final int FLD_ANSWER_4 = 9;
    public static final int FLD_ANSWER_5 = 10;
    public static final int FLD_ANSWER_6 = 11;
    public static final int FLD_REALIZATION = 12;
    public static final int FLD_EVIDENCE = 13;
    public static final int FLD_POINT = 14;
	public static final int FLD_WEIGHT = 15;
	public static final int FLD_KPI_ID = 16;
    public static final String[] fieldNames = {
        "HR_APPRAISAL_ID",
        "ASS_FORM_ITEM_ID",
        "HR_APP_MAIN_ID",
        "EMP_COMMENT",
        "ASS_COMMENT",
        "RATING",
        "ANSWER_1",
        "ANSWER_2",
        "ANSWER_3",
        "ANSWER_4",
        "ANSWER_5",
        "ANSWER_6",
        "REALIZATION",
        "EVIDENCE",
        "POINT",
		"WEIGHT",
		"KPI_ID"
    };
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_FLOAT,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_FLOAT,
        TYPE_STRING,
        TYPE_FLOAT,
		TYPE_FLOAT,
		TYPE_LONG
    };

    public PstAppraisal() {
    }

    public PstAppraisal(int i) throws DBException {
        super(new PstAppraisal());
    }

    public PstAppraisal(String sOid) throws DBException {
        super(new PstAppraisal(0));
        if (!locate(sOid)) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public PstAppraisal(long lOid) throws DBException {
        super(new PstAppraisal(0));
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
        return TBL_HR_APPRAISAL;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new PstAppraisal().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        Appraisal appraisal = fetchExc(ent.getOID());
        ent = (Entity) appraisal;
        return appraisal.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((Appraisal) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((Appraisal) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static Appraisal fetchExc(long oid) throws DBException {
        try {
            Appraisal appraisal = new Appraisal();
            PstAppraisal pstAppraisal = new PstAppraisal(oid);
            appraisal.setOID(oid);

            appraisal.setAppMainId(pstAppraisal.getlong(FLD_APP_MAIN_ID));
            appraisal.setAssFormItemId(pstAppraisal.getlong(FLD_ASS_FORM_ITEM_ID));
            appraisal.setAssComment(pstAppraisal.getString(FLD_ASS_COMMENT));
            appraisal.setEmpComment(pstAppraisal.getString(FLD_EMP_COMMENT));
            appraisal.setRating(pstAppraisal.getdouble(FLD_RATING));
            appraisal.setAnswer_1(pstAppraisal.getString(FLD_ANSWER_1));
            appraisal.setAnswer_2(pstAppraisal.getString(FLD_ANSWER_2));
            appraisal.setAnswer_3(pstAppraisal.getString(FLD_ANSWER_3));
            appraisal.setAnswer_4(pstAppraisal.getString(FLD_ANSWER_4));
            appraisal.setAnswer_5(pstAppraisal.getString(FLD_ANSWER_5));
            appraisal.setAnswer_6(pstAppraisal.getString(FLD_ANSWER_6));
            appraisal.setRealization(pstAppraisal.getfloat(FLD_REALIZATION));
            appraisal.setEvidence(pstAppraisal.getString(FLD_EVIDENCE));
            appraisal.setPoint(pstAppraisal.getfloat(FLD_POINT));
			appraisal.setWeight(pstAppraisal.getdouble(FLD_WEIGHT));
			appraisal.setKpiId(pstAppraisal.getlong(FLD_KPI_ID));

            return appraisal;
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstAppraisal(0), DBException.UNKNOWN);
        }
    }

    public static long insertExc(Appraisal appraisal) throws DBException {
        try {
            PstAppraisal pstAppraisal = new PstAppraisal(0);

            pstAppraisal.setLong(FLD_APP_MAIN_ID, appraisal.getAppMainId());
            pstAppraisal.setLong(FLD_ASS_FORM_ITEM_ID, appraisal.getAssFormItemId());
            pstAppraisal.setString(FLD_ASS_COMMENT, appraisal.getAssComment());
            pstAppraisal.setString(FLD_EMP_COMMENT, appraisal.getEmpComment());
            pstAppraisal.setDouble(FLD_RATING, appraisal.getRating());
            pstAppraisal.setString(FLD_ANSWER_1, appraisal.getAnswer_1());
            pstAppraisal.setString(FLD_ANSWER_2, appraisal.getAnswer_2());
            pstAppraisal.setString(FLD_ANSWER_3, appraisal.getAnswer_3());
            pstAppraisal.setString(FLD_ANSWER_4, appraisal.getAnswer_4());
            pstAppraisal.setString(FLD_ANSWER_5, appraisal.getAnswer_5());
            pstAppraisal.setString(FLD_ANSWER_6, appraisal.getAnswer_6());
            pstAppraisal.setFloat(FLD_REALIZATION, appraisal.getRealization());
            pstAppraisal.setString(FLD_EVIDENCE, appraisal.getEvidence());
            pstAppraisal.setFloat(FLD_POINT, appraisal.getPoint());
			pstAppraisal.setDouble(FLD_WEIGHT, appraisal.getWeight());
			pstAppraisal.setLong(FLD_KPI_ID, appraisal.getKpiId());
            pstAppraisal.insert();
            appraisal.setOID(pstAppraisal.getlong(FLD_APPRAISAL_ID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstAppraisal(0), DBException.UNKNOWN);
        }
        return appraisal.getOID();
    }

    public static long updateExc(Appraisal appraisal) throws DBException {
        try {
            if (appraisal.getOID() != 0) {
                PstAppraisal pstAppraisal = new PstAppraisal(appraisal.getOID());

                pstAppraisal.setLong(FLD_APP_MAIN_ID, appraisal.getAppMainId());
                pstAppraisal.setLong(FLD_ASS_FORM_ITEM_ID, appraisal.getAssFormItemId());
                pstAppraisal.setString(FLD_ASS_COMMENT, appraisal.getAssComment());
                pstAppraisal.setString(FLD_EMP_COMMENT, appraisal.getEmpComment());
                pstAppraisal.setDouble(FLD_RATING, appraisal.getRating());
                pstAppraisal.setString(FLD_ANSWER_1, appraisal.getAnswer_1());
                pstAppraisal.setString(FLD_ANSWER_2, appraisal.getAnswer_2());
                pstAppraisal.setString(FLD_ANSWER_3, appraisal.getAnswer_3());
                pstAppraisal.setString(FLD_ANSWER_4, appraisal.getAnswer_4());
                pstAppraisal.setString(FLD_ANSWER_5, appraisal.getAnswer_5());
                pstAppraisal.setString(FLD_ANSWER_6, appraisal.getAnswer_6());
                pstAppraisal.setFloat(FLD_REALIZATION, appraisal.getRealization());
                pstAppraisal.setString(FLD_EVIDENCE, appraisal.getEvidence());
                pstAppraisal.setFloat(FLD_POINT, appraisal.getPoint());
				pstAppraisal.setDouble(FLD_WEIGHT, appraisal.getWeight());
				pstAppraisal.setLong(FLD_KPI_ID, appraisal.getKpiId());
                pstAppraisal.update();
                return appraisal.getOID();
            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstAppraisal(0), DBException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws DBException {
        try {
            PstAppraisal pstAppraisal = new PstAppraisal(oid);
            pstAppraisal.delete();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstAppraisal(0), DBException.UNKNOWN);
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
            String sql = "SELECT * FROM " + TBL_HR_APPRAISAL;
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
                Appraisal appraisal = new Appraisal();
                resultToObject(rs, appraisal);
                lists.add(appraisal);
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

    public static void resultToObject(ResultSet rs, Appraisal appraisal) {
        try {
            appraisal.setOID(rs.getLong(PstAppraisal.fieldNames[PstAppraisal.FLD_APPRAISAL_ID]));
            appraisal.setAppMainId(rs.getLong(PstAppraisal.fieldNames[PstAppraisal.FLD_APP_MAIN_ID]));
            appraisal.setAssFormItemId(rs.getLong(PstAppraisal.fieldNames[PstAppraisal.FLD_ASS_FORM_ITEM_ID]));
            appraisal.setAssComment(rs.getString(PstAppraisal.fieldNames[PstAppraisal.FLD_ASS_COMMENT]));
            appraisal.setEmpComment(rs.getString(PstAppraisal.fieldNames[PstAppraisal.FLD_EMP_COMMENT]));
            appraisal.setRating(rs.getDouble(PstAppraisal.fieldNames[PstAppraisal.FLD_RATING]));
            appraisal.setAnswer_1(rs.getString(PstAppraisal.fieldNames[PstAppraisal.FLD_ANSWER_1]));
            appraisal.setAnswer_2(rs.getString(PstAppraisal.fieldNames[PstAppraisal.FLD_ANSWER_2]));
            appraisal.setAnswer_3(rs.getString(PstAppraisal.fieldNames[PstAppraisal.FLD_ANSWER_3]));
            appraisal.setAnswer_4(rs.getString(PstAppraisal.fieldNames[PstAppraisal.FLD_ANSWER_4]));
            appraisal.setAnswer_5(rs.getString(PstAppraisal.fieldNames[PstAppraisal.FLD_ANSWER_5]));
            appraisal.setAnswer_6(rs.getString(PstAppraisal.fieldNames[PstAppraisal.FLD_ANSWER_6]));
            appraisal.setRealization(rs.getFloat(PstAppraisal.fieldNames[PstAppraisal.FLD_REALIZATION]));
            appraisal.setEvidence(rs.getString(PstAppraisal.fieldNames[PstAppraisal.FLD_EVIDENCE]));
            appraisal.setPoint(rs.getFloat(PstAppraisal.fieldNames[PstAppraisal.FLD_POINT]));
			appraisal.setWeight(rs.getDouble(PstAppraisal.fieldNames[PstAppraisal.FLD_WEIGHT]));
			appraisal.setKpiId(rs.getLong(PstAppraisal.fieldNames[PstAppraisal.FLD_KPI_ID]));
        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long appraisalId) {
        DBResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + TBL_HR_APPRAISAL + " WHERE "
                    + PstAppraisal.fieldNames[PstAppraisal.FLD_APPRAISAL_ID]
                    + " = " + appraisalId;

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
            String sql = "SELECT COUNT(" + PstAppraisal.fieldNames[PstAppraisal.FLD_APPRAISAL_ID]
                    + ") FROM " + TBL_HR_APPRAISAL;
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
    
    /**
     * sql = "SELECT SUM(" + PstAppraisal.fieldNames[PstAppraisal.FLD_RATING]
                    + ") FROM " + TBL_HR_APPRAISAL + 
                    " INNER JOIN "+PstAssessmentFormItem.TBL_HR_ASS_FORM_ITEM+" i ON "+PstAssessmentFormItem.TBL_HR_ASS_FORM_ITEM+"."+
                    PstAssessmentFormItem.fieldNames[PstAssessmentFormItem.FLD_ASS_FORM_ITEM_ID] +" = "+TBL_HR_APPRAISAL+"."+fieldNames[FLD_ASS_FORM_ITEM_ID]; 
            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " WHERE " + whereClause;
            }
     * @param whereClause
     * @return 
     */
    public static float getSummaryRating(String whereClause) {
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT SUM(" + PstAppraisal.fieldNames[PstAppraisal.FLD_RATING]
                    + ") FROM " + TBL_HR_APPRAISAL + 
                    " INNER JOIN "+PstAssessmentFormItem.TBL_HR_ASS_FORM_ITEM+" ON "+PstAssessmentFormItem.TBL_HR_ASS_FORM_ITEM+"."+
                    PstAssessmentFormItem.fieldNames[PstAssessmentFormItem.FLD_ASS_FORM_ITEM_ID] +" = "+TBL_HR_APPRAISAL+"."+fieldNames[FLD_ASS_FORM_ITEM_ID]; 
            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " WHERE " + whereClause;
            }

            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            float sum = 0;
            while (rs.next()) {
                sum = rs.getFloat(1);
            }

            rs.close();
            return sum;
        } catch (Exception e) {
            return 0;
        } finally {
            DBResultSet.close(dbrs);
        }
    }    

    /* This method used to find current data */
    public static int findLimitStart(long oid, int recordToGet, String whereClause, String orderClause) {
        int size = getCount(whereClause);
        int start = 0;
        boolean found = false;
        for (int i = 0; (i < size) && !found; i = i + recordToGet) {
            Vector list = list(i, recordToGet, whereClause, orderClause);
            start = i;
            if (list.size() > 0) {
                for (int ls = 0; ls < list.size(); ls++) {
                    Appraisal appraisal = (Appraisal) list.get(ls);
                    if (oid == appraisal.getOID()) {
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
    /* This method used to find command where current data */

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
                } else {
                    start = start - recordToGet;
                    if (start > 0) {
                        cmd = Command.PREV;
                    }
                }
            }
        }

        return cmd;
    }

    //Mencari item yang memiliki type 12
    public static Vector getAppraisalAssessorComments(long appraisalOid) {
        Vector vAppraisal = new Vector(1, 1);
        String query = "SELECT APP.* FROM " + TBL_HR_APPRAISAL + " AS APP "
                + " INNER JOIN " + PstAssessmentFormItem.TBL_HR_ASS_FORM_ITEM + " AS ITEM "
                + " ON APP." + fieldNames[FLD_ASS_FORM_ITEM_ID]
                + " = ITEM." + PstAssessmentFormItem.fieldNames[PstAssessmentFormItem.FLD_ASS_FORM_ITEM_ID]
                + " WHERE APP." + fieldNames[FLD_APP_MAIN_ID] + " = " + appraisalOid
                + " AND ITEM." + PstAssessmentFormItem.fieldNames[PstAssessmentFormItem.FLD_TYPE]
                + " = " + PstAssessmentFormItem.ITEM_TYPE_2_COL_ASS_COMM;
        DBResultSet dbrs = null;
        try {
            dbrs = DBHandler.execQueryResult(query);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                Appraisal appraisal = new Appraisal();
                resultToObject(rs, appraisal);
                vAppraisal.add(appraisal);
            }
            rs.close();

        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return vAppraisal;
    }

    public static void deleteAppraisalByMain(long appMainOid) {
        int result = 0;
        try {
            String sql = "DELETE FROM " + TBL_HR_APPRAISAL
                    + " WHERE " + fieldNames[FLD_APP_MAIN_ID]
                    + " = " + appMainOid;

            result = DBHandler.execUpdate(sql);
        } catch (Exception e) {
            System.out.println("\tPstAppraisal.deleteAppraisalByMain" + e);
        }
    }
    
    public static Appraisal getDataFromFormula(Long appraisalId, Long assessmentFormItemId){
        Appraisal appraisal = new Appraisal();
        int result = 0;
        AssessmentFormItem assFormItem = new AssessmentFormItem();
        AppraisalMain appraisalMain = new AppraisalMain();
        try {
            assFormItem = PstAssessmentFormItem.fetchExc(assessmentFormItemId);
            appraisalMain = PstAppraisalMain.fetchExc(appraisalId);
        } catch (Exception exc){ }
        
        String formula = assFormItem.getFormula();
        
        if ((checkString(formula, "GET_PRESENCE_LATE") > -1)){
            int late = getPresence(appraisalMain.getDataPeriodFrom(), appraisalMain.getDataPeriodTo(), appraisalMain.getEmployeeId());
            result = getAssPresenceIdx(late);
            float total = assFormItem.getWeightPoint() * result ;
            String evidence = "";
            if (late > 12){
                evidence = "(satu) semester terlambat dan/atau sakit selama lebih dari " + late + " hari";
            } else if (late != 0 && late <=12){
                evidence = "(satu) semester terlambat dan/atau sakit selama " + late + " hari";
            } 
            else {
                evidence = "(satu) semester tidak pernah terlambat dan tidak pernah sakit.";
            }
            appraisal.setRealization(result);
            appraisal.setEvidence(evidence);
            appraisal.setPoint(result);
            appraisal.setRating(total);
            
        }
        
        return appraisal;
    }
    
    public static int getPresence(Date periodFrom, Date periodTo, Long employeeId){
        Vector list = new Vector(1, 1);
        Vector listPeriod = new Vector();
        Vector listPresence = new Vector();
        String wherePeriod = ""+PstPeriod.fieldNames[PstPeriod.FLD_START_DATE] + " BETWEEN '"+periodFrom+"' AND '" + periodTo +"'";
        listPeriod = PstPeriod.list(0, 0, wherePeriod, "");
        int totalLate = 0;
        String SSD = "504404617410740900";
        String SD = "504404624827245735";
        long oidDCSchedule = Long.parseLong(SSD);
        long oidWODCSchedule = Long.parseLong(SD);
        if (listPeriod.size()>0){
            for (int i = 0; i < listPeriod.size(); i++){
                Period period = (Period) listPeriod.get(i);
                String whereStatus = PstEmpSchedule.fieldNames[PstEmpSchedule.FLD_PERIOD_ID]+" = "+period.getOID()+" AND "+PstEmpSchedule.fieldNames[PstEmpSchedule.FLD_EMPLOYEE_ID]+" = "+employeeId;
                listPresence = PstEmpSchedule.list(0, 0, whereStatus, "");
                if(listPresence.size()>0){
                    for (int x = 0;x < listPresence.size();x ++){
                        EmpSchedule empSchedule = (EmpSchedule) listPresence.get(x);
                        
                        if(empSchedule.getStatus1() == 1 || empSchedule.getReason1() == oidDCSchedule || empSchedule.getReason1() == oidWODCSchedule ) {
                            totalLate = totalLate + 1;
                        }
                        if(empSchedule.getStatus2() == 1 || empSchedule.getReason2() == oidDCSchedule || empSchedule.getReason2() == oidWODCSchedule ) {
                            totalLate = totalLate + 1;
                        }
                        if(empSchedule.getStatus3() == 1 || empSchedule.getReason3() == oidDCSchedule || empSchedule.getReason3() == oidWODCSchedule ) {
                            totalLate = totalLate + 1;
                        }
                        if(empSchedule.getStatus4() == 1 || empSchedule.getReason4() == oidDCSchedule || empSchedule.getReason4() == oidWODCSchedule ) {
                            totalLate = totalLate + 1;
                        }
                        if(empSchedule.getStatus5() == 1 || empSchedule.getReason5() == oidDCSchedule || empSchedule.getReason5() == oidWODCSchedule ) {
                            totalLate = totalLate + 1;
                        }
                        if(empSchedule.getStatus6() == 1 || empSchedule.getReason6() == oidDCSchedule || empSchedule.getReason6() == oidWODCSchedule ) {
                            totalLate = totalLate + 1;
                        }
                        if(empSchedule.getStatus7() == 1 || empSchedule.getReason7() == oidDCSchedule || empSchedule.getReason7() == oidWODCSchedule ) {
                            totalLate = totalLate + 1;
                        }
                        if(empSchedule.getStatus8() == 1 || empSchedule.getReason8() == oidDCSchedule || empSchedule.getReason8() == oidWODCSchedule ) {
                            totalLate = totalLate + 1;
                        }
                        if(empSchedule.getStatus9() == 1 || empSchedule.getReason9() == oidDCSchedule || empSchedule.getReason9() == oidWODCSchedule ) {
                            totalLate = totalLate + 1;
                        }
                        if(empSchedule.getStatus10() == 1 || empSchedule.getReason10() == oidDCSchedule || empSchedule.getReason10() == oidWODCSchedule ) {
                            totalLate = totalLate + 1;
                        }
                        if(empSchedule.getStatus11() == 1 || empSchedule.getReason11() == oidDCSchedule || empSchedule.getReason11() == oidWODCSchedule ) {
                            totalLate = totalLate + 1;
                        }
                        if(empSchedule.getStatus12() == 1 || empSchedule.getReason12() == oidDCSchedule || empSchedule.getReason12() == oidWODCSchedule ) {
                            totalLate = totalLate + 1;
                        }
                        if(empSchedule.getStatus13() == 1 || empSchedule.getReason13() == oidDCSchedule || empSchedule.getReason13() == oidWODCSchedule ) {
                            totalLate = totalLate + 1;
                        }
                        if(empSchedule.getStatus14() == 1 || empSchedule.getReason14() == oidDCSchedule || empSchedule.getReason14() == oidWODCSchedule ) {
                            totalLate = totalLate + 1;
                        }
                        if(empSchedule.getStatus15() == 1 || empSchedule.getReason15() == oidDCSchedule || empSchedule.getReason15() == oidWODCSchedule ) {
                            totalLate = totalLate + 1;
                        }
                        if(empSchedule.getStatus16() == 1 || empSchedule.getReason16() == oidDCSchedule || empSchedule.getReason16() == oidWODCSchedule ) {
                            totalLate = totalLate + 1;
                        }
                        if(empSchedule.getStatus17() == 1 || empSchedule.getReason17() == oidDCSchedule || empSchedule.getReason17() == oidWODCSchedule ) {
                            totalLate = totalLate + 1;
                        }
                        if(empSchedule.getStatus18() == 1 || empSchedule.getReason18() == oidDCSchedule || empSchedule.getReason18() == oidWODCSchedule ) {
                            totalLate = totalLate + 1;
                        }
                        if(empSchedule.getStatus19() == 1 || empSchedule.getReason19() == oidDCSchedule || empSchedule.getReason19() == oidWODCSchedule ) {
                            totalLate = totalLate + 1;
                        }
                        if(empSchedule.getStatus20() == 1 || empSchedule.getReason20() == oidDCSchedule || empSchedule.getReason20() == oidWODCSchedule ) {
                            totalLate = totalLate + 1;
                        }
                        if(empSchedule.getStatus21() == 1 || empSchedule.getReason21() == oidDCSchedule || empSchedule.getReason21() == oidWODCSchedule ) {
                            totalLate = totalLate + 1;
                        }
                        if(empSchedule.getStatus22() == 1 || empSchedule.getReason22() == oidDCSchedule || empSchedule.getReason22() == oidWODCSchedule ) {
                            totalLate = totalLate + 1;
                        }
                        if(empSchedule.getStatus23() == 1 || empSchedule.getReason23() == oidDCSchedule || empSchedule.getReason23() == oidWODCSchedule ) {
                            totalLate = totalLate + 1;
                        }
                        if(empSchedule.getStatus24() == 1 || empSchedule.getReason24() == oidDCSchedule || empSchedule.getReason24() == oidWODCSchedule ) {
                            totalLate = totalLate + 1;
                        }
                        if(empSchedule.getStatus25() == 1 || empSchedule.getReason25() == oidDCSchedule || empSchedule.getReason25() == oidWODCSchedule ) {
                            totalLate = totalLate + 1;
                        }
                        if(empSchedule.getStatus26() == 1 || empSchedule.getReason26() == oidDCSchedule || empSchedule.getReason26() == oidWODCSchedule ) {
                            totalLate = totalLate + 1;
                        }
                        if(empSchedule.getStatus27() == 1 || empSchedule.getReason27() == oidDCSchedule || empSchedule.getReason27() == oidWODCSchedule ) {
                            totalLate = totalLate + 1;
                        }
                        if(empSchedule.getStatus28() == 1 || empSchedule.getReason28() == oidDCSchedule || empSchedule.getReason28() == oidWODCSchedule ) {
                            totalLate = totalLate + 1;
                        }
                        if(empSchedule.getStatus29() == 1 || empSchedule.getReason29() == oidDCSchedule || empSchedule.getReason29() == oidWODCSchedule ) {
                            totalLate = totalLate + 1;
                        }
                        if(empSchedule.getStatus30() == 1 || empSchedule.getReason30() == oidDCSchedule || empSchedule.getReason30() == oidWODCSchedule ) {
                            totalLate = totalLate + 1;
                        }
                        if(empSchedule.getStatus31() == 1 || empSchedule.getReason31() == oidDCSchedule || empSchedule.getReason31() == oidWODCSchedule ) {
                            totalLate = totalLate + 1;
                        }
                        
                    }
                    
                }
            }
            
        }
         
        return totalLate;
    }
    
    public static int getAssPresenceIdx(int late){
        int result = 0;
        
        if (late > 12){
            result = 1;
        } else if (late > 9 && late <= 12){
            result = 2;
        } else if (late > 6 && late <= 9){
            result = 3;
        } else if (late > 0 && late <= 6 ){
            result = 4; 
        } else if (late == 0){
            result = 5;
        }
        
        return result;
    }
    
}

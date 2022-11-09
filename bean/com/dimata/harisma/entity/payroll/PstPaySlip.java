/*
 * PstPaySlip.java
 *
 * Created on April 24, 2007, 4:56 PM
 */
package com.dimata.harisma.entity.payroll;

/* package java */
import com.dimata.harisma.entity.arap.ArApItem;
import com.dimata.harisma.entity.arap.ArApMain;
import com.dimata.harisma.entity.arap.PstArApItem;
import com.dimata.harisma.entity.arap.PstArApMain;
import com.dimata.harisma.entity.attendance.AlStockManagement;
import com.dimata.harisma.entity.attendance.AlStockTaken;
import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;

/* package qdep */
import com.dimata.util.lang.I_Language;
import com.dimata.util.*;
import com.dimata.qdep.db.*;
import com.dimata.qdep.entity.*;
import com.dimata.harisma.entity.masterdata.Period;
import com.dimata.harisma.entity.attendance.EmpSchedule;
import com.dimata.harisma.entity.attendance.LLStockManagement;
import com.dimata.harisma.entity.attendance.LlStockTaken;
import com.dimata.harisma.entity.attendance.PstAlStockManagement;
import com.dimata.harisma.entity.attendance.PstAlStockTaken;
import com.dimata.harisma.entity.attendance.PstEmpSchedule;
import com.dimata.harisma.entity.attendance.PstLLStockManagement;
import com.dimata.harisma.entity.attendance.PstLlStockTaken;
import com.dimata.harisma.entity.attendance.PstPresence;
import com.dimata.harisma.entity.configrewardnpunisment.PstRewardAndPunishmentDetail;
import com.dimata.harisma.entity.masterdata.Reason;

/* package harisma */
//import com.dimata. harisma.db.DBHandler;
//import com.dimata.harisma.db.DBException;
//import com.dimata.harisma.db.DBLogger;
import com.dimata.harisma.entity.payroll.*;
import com.dimata.harisma.entity.employee.*;
import com.dimata.harisma.entity.leave.I_Leave;
import com.dimata.harisma.entity.leave.LeaveApplication;
import com.dimata.harisma.entity.leave.PstLeaveApplication;
import com.dimata.harisma.entity.leave.PstSpecialUnpaidLeaveTaken;
import com.dimata.harisma.entity.leave.SpecialUnpaidLeaveTaken;
import com.dimata.harisma.entity.masterdata.PstEmpDoc;
import com.dimata.harisma.entity.masterdata.PstEmpDocListMutation;
import com.dimata.harisma.entity.masterdata.Company;
import com.dimata.harisma.entity.masterdata.Department;
import com.dimata.harisma.entity.masterdata.Division;
import com.dimata.harisma.entity.masterdata.EmpDoc;
import com.dimata.harisma.entity.masterdata.EmpDocListExpense;
import com.dimata.harisma.entity.masterdata.GradeLevel;
import com.dimata.harisma.entity.masterdata.Position;
import com.dimata.harisma.entity.masterdata.PstCompany;
import com.dimata.harisma.entity.masterdata.PstComponentCoaMap;
import com.dimata.harisma.entity.masterdata.PstDepartment;
import com.dimata.harisma.entity.masterdata.PstDivision;
import com.dimata.harisma.entity.masterdata.PstEmpDocListExpense;
import com.dimata.harisma.entity.masterdata.PstGradeLevel;
import com.dimata.harisma.entity.masterdata.PstPeriod;
import com.dimata.harisma.entity.masterdata.PstPosition;
import com.dimata.harisma.entity.masterdata.PstPublicHolidays;
import com.dimata.harisma.entity.masterdata.PstScheduleCategory;
import com.dimata.harisma.entity.masterdata.PstScheduleSymbol;
import com.dimata.harisma.entity.masterdata.PstSection;
import com.dimata.harisma.entity.masterdata.ScheduleSymbol;
import com.dimata.harisma.entity.masterdata.Section;
import com.dimata.harisma.entity.overtime.Overtime;
import com.dimata.harisma.entity.overtime.PstOvertime;
import com.dimata.harisma.entity.overtime.OvertimeDetail;
import com.dimata.harisma.entity.overtime.PstOvertimeDetail;
import static com.dimata.harisma.entity.payroll.PayComponentDecimalFormat.convertInteger;
import static com.dimata.harisma.entity.payroll.PayComponentDecimalFormat.customFormat;
import com.dimata.harisma.entity.payroll.PstValue_Mapping;
import com.dimata.harisma.form.payroll.FrmPayInput;
import com.dimata.harisma.session.attendance.PresenceReportDaily;
import com.dimata.harisma.session.attendance.SessEmpSchedule;
import com.dimata.harisma.session.leave.SessLeaveApplication;
import com.dimata.harisma.session.payroll.I_PayrollCalculator;
import com.dimata.harisma.session.payroll.Pajak;
import com.dimata.harisma.session.payroll.TaxCalculator;
import com.dimata.system.entity.system.PstSystemProperty;
import java.text.SimpleDateFormat;
import java.util.concurrent.TimeUnit;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspWriter;
import org.apache.catalina.startup.SetContextPropertiesRule;
//import com.dimata.harisma.entity.locker.*;

/**
 *
 * @author yunny
 */
public class PstPaySlip extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {

    public static final String TBL_PAY_SLIP = "pay_slip";
    public static final int FLD_PAY_SLIP_ID = 0;
    public static final int FLD_PERIOD_ID = 1;
    public static final int FLD_EMPLOYEE_ID = 2;
    public static final int FLD_STATUS = 3;
    public static final int FLD_PAID_STATUS = 4;
    public static final int FLD_PAY_SLIP_DATE = 5;
    public static final int FLD_DAY_PRESENT = 6;
    public static final int FLD_DAY_PAID_LV = 7;
    public static final int FLD_DAY_ABSENT = 8;
    public static final int FLD_DAY_UNPAID_LV = 9;
    public static final int FLD_DIVISION = 10;
    public static final int FLD_DEPARTMENT = 11;
    public static final int FLD_POSITION = 12;
    public static final int FLD_SECTION = 13;
    public static final int FLD_NOTE = 14;
    public static final int FLD_COMMENC_DATE = 15;
    public static final int FLD_PAYMENT_TYPE = 16;
    public static final int FLD_BANK_ID = 17;
    public static final int FLD_PAY_SLIP_TYPE = 18;
    public static final int FLD_COMP_CODE = 19;
    public static final int FLD_DAY_LATE = 20;
    public static final int FLD_PROCENTASE_PRESENCE = 21;
    //update by satrya 2013-02-20
    public static final int FLD_DAY_OFF_SCHEDULE = 22;
    public static final int FLD_TOTAL_DAY_OFF_OVERTIME = 23;
    public static final int FLD_INSENTIF = 24;
    public static final int FLD_DATE_OK_WITH_LEAVE = 25;
    //update by satrya 2013-05-06
    public static final int FLD_OV_IDX_ADJUSTMENT = 26;
    public static final int FLD_PRIVATE_NOTE = 27;
    //update by satrya 2014-02-06
    public static final int FLD_MEAL_ALLOWANCE_MONEY = 28;
    public static final int FLD_MEAL_ALLOWANCE_MONEY_ADJUSMENT = 29;
    public static final int FLD_OVERTIME_IDX = 30;
    public static final int FLD_NOTE_ADMIN = 31;
    //update by satrya 2014-05-01
    public static final int FLD_OV_IDX_PAID_SALARY_ADJUSMENT_DATE = 32;
    public static final int FLD_OV_MEAL_ALLOWANCE_MONEY_ADJ_DATE = 33;
    // update by Hendra Putu | 2015-01-24
    public static final int FLD_NIGHT_ALLOWANCE = 34;
    public static final int FLD_TRANSPORT_ALLOWANCE = 35;
    /* Update by Hendra Putu | 2016-08-18 */
    public static final int FLD_GRADE_CODE = 36;

    public static final String[] fieldNames = {
        "PAY_SLIP_ID",
        "PERIOD_ID",
        "EMPLOYEE_ID",
        "STATUS",
        "PAID_STATUS",
        "PAY_SLIP_DATE",
        "DAY_PRESENT",
        "DAY_PAID_LV",
        "DAY_ABSENT",
        "DAY_UNPAID_LV",
        "DIVISION",
        "DEPARTMENT",
        "POSITION",
        "SECTION",
        "NOTE",
        "COMMENC_DATE",
        "PAYMENT_TYPE",
        "BANK_ID",
        "PAY_SLIP_TYPE",
        "COMP_CODE",
        "DAY_LATE",
        "PROCENTASE_PRESENCE",
        "DAY_OFF_SCHEDULE",
        "TOTAL_DAY_OFF_OVERTIME",
        "INSENTIF",
        "DATE_OK_WITH_LEAVE",
        //UPDATE BY SATRYA 2013-05-06
        "OV_IDX_ADJUSTMENT",
        "PRIVATE_NOTE",
        "MEAL_ALLOWANCE_MONEY",
        "MEAL_ALLOWANCE_MONEY_ADJUSMENT",
        "OVERTIME_IDX",
        "NOTE_ADMIN",
        "OV_IDX_PAID_SALARY_ADJUSMENT_DATE",
        "OV_MEAL_ALLOWANCE_MONEY_ADJ_DATE",
        // update by Hendra Putu | 2015-01-24
        "NIGHT_ALLOWANCE",
        "TRANSPORT_ALLOWANCE",
        "GRADE_CODE"
    };
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_INT,
        TYPE_INT,
        TYPE_DATE,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_DATE,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_INT,
        TYPE_STRING,
        TYPE_FLOAT,
        TYPE_FLOAT,
        //update by satrya 2013-02-20
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_STRING,
        //update by satrya 2014-02-06
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_STRING,
        TYPE_DATE,
        TYPE_DATE,
        // update by Hendra Putu | 2015-01-24
        TYPE_INT,
        TYPE_INT,
        TYPE_STRING
    };
    //value for Status
    public static final int NO_APPROVE = 0;
    public static final int YES_APPROVE = 1;
    public static final String[] approveKey = {"Tidak", "Ya"};
    public static final int[] approveValue = {0, 1};
    //value for Paid
    public static final int NO_PAID = 0;
    public static final int YES_PAID = 1;
    public static final String[] paidKey = {"Tidak", "Ya"};
    public static final int[] paidValue = {0, 1};
    public static final String PAY_COMP_OVERTIME_IDX = "OVERTIME_IDX";
    public static final String PAY_COMP_SALARY_TAX = "SALARY_TAX";
    public static final String PAY_COMP_SALARY_TAX_SECOND_SLIP = "SALARY_TAX_SECOND_SLIP";
    public static final String PAY_COMP_GR_UP_SALARY_TAX = "SALARY_GR_UP_TAX";
    public static final String PAY_COMP_SECOND_SLIP_GR_UP_SALARY_TAX = "SECOND_SLIP_SALARY_GR_UP_TAX";

    /**
     * // update by kartika 2014-11-10 menghitung pajak pendapatan non continue
     * diperiode ini dengan menggunakan asumsi gaji lainnya dari 1 bulan
     * sebelumnya
     */
    public static final String PAY_COMP_SALARY_TAX_NON_CONT_MONTHLY = "SALARY_TAX_NON_CONT";

    /**
     * // update by kartika 2015-06-29 menghitung pajak pendapatan non continue
     * diperiode ini dengan menggunakan asumsi gaji lainnya dari 2 bulan
     * sebelumnya
     */
    public static final String PAY_COMP_SALARY_PREV2_TAX_NON_CONT_MONTHLY = "SALARY_PREV2_TAX_NON_CONT"; // update by kartika 2015-06-29

    /**
     * update by kartika 20150625 hitung pph 21 tanpa componen : contoh :
     * SALARY_TAX_WO_COMP#THR#BONUS ,
     *
     */
    public static String COMP_SPLIT_BY = "#"; // component split by #
    public static final String PAY_COMP_WO_COMP_SALARY_EMP_TAX = "WO_COMP_SALARY_EMP_TAX";

    /**
     * update by kartika 20150629 hitung pph 21 "terhutang' dari Periode to End
     * Year tanpa componen : contoh : SALARY_TAX_WO_COMP#THR#BONUS ,
     *
     */
    public static final String PAY_COMP_SALARY_EMP_ENDYEAR_TAX = "SALARY_EMP_ENDYEAR_TAX";
    public static final String PAY_COMP_SALARY_EMP_PREV_ENDYEAR_TAX = "SALARY_EMP_ENDYEAR_PREV_TAX";  // Pajak sampai akhir tahun dengan asumsi gaji rutin dari periode sebelumnya

    /**
     * update by kartika 20150629 hitung pph 21 "terhutang' dari Periode to End
     * Year tanpa componen : contoh : SALARY_TAX_WO_COMP#THR#BONUS ,
     *
     */
    public static final String PAY_COMP_WO_COMP_SALARY_EMP_ENDYEAR_TAX = "SALARY_EMP_WO_COMP_ENDYEAR_TAX";
    public static final String PAY_COMP_WO_COMP_SALARY_EMP_PREV_ENDYEAR_TAX = "WO_COMP_SALARY_EMP_PREV_ENDYEAR_TAX";  // Pajak sampai akhir tahun dengan asumsi gaji rutin dari periode sebelumnya dengan tanpa komponen2 gaji di list     
    // by Kartika 30 Juni 2015
    public static final String PAY_PERIOD_NAME = "PAY_PERIOD_NAME"; // contoh : dalam rumus  = IF ( PAY_PERIOD_NAME = "July 2015" , 3123000 , 0 )
    public static Vector<String> PAY_COMP_SALARY_TAX_CODE_PREPAY = null;  // update by Kartika 23 July 2015
    public static String PAY_COMP_SALARY_TAX_CODE = "PPH21";
    public static String PAY_COMP_CALC_MEALS_ALLOWANCE = "calc_meal_allowance"; // jumlah(count) dari lembur yang diberikan uang makan
    public static String PAY_COMP_DATE_OK = "DATE_OK"; // jumlah hari yang status OK 
    public static String PAY_COMP_DATE_OK_WITH_LEAVE = "DATE_OK_WITH_LEAVE"; // jumlah hari yang status OK dan tanpa cuti
    //by priska
    public static String PAY_COMP_REWARD_PUNISHMENT = "REWARD_PUNISHMENT"; // nilai reward punishment 
    public static String PAY_COMP_DESCRIPTION_REWARD_PUNISHMENT = "total calculated reward and punishment "; // Description nilai reward punishment
    //by priska 2015-02-17
    public static String PAY_COMP_DATE_ONLY_IN = "DATE_ONLY_IN"; // only in
    public static String PAY_COMP_DESCRIPTION_DATE_ONLY_IN = "total calculated only in "; // Description only in
    //by priska 2015-02-17
    public static String PAY_COMP_DATE_ONLY_OUT = "DATE_ONLY_OUT"; // only out
    public static String PAY_COMP_DESCRIPTION_DATE_ONLY_OUT = "total calculated only out "; // Description only out
    //by priska 2015-04-18
    public static String NPWP = "NPWP";
    public static String NPWP_DESCRIPTION = "total NPWP"; 
        //by priska 2015-04-18
    public static String RESIGN_STATUS = "RESIGN_STATUS";
    public static String RESIGN_STATUS_DESCRIPTION = "deskripsi RESIGN_STATUS"; 
    //by priska 2015-12-26
    public static String GET_LOS = "GET_LOS";
    public static String GET_LOS_DESCRIPTION = "GET LENGTH OF SERVICE BY MONTH";
    //by priska 2015-12-15
    public static String GET_AGE= "GET_AGE";
    public static String GET_AGE_DESCRIPTION = "total GET_AGE_DESCRIPTION"; 
    //by priska 2015-12-15
    public static String GET_INSENTIF_CASHIER= "GET_INSENTIF_CASHIER";
    public static String GET_INSENTIF_CASHIER_DESCRIPTION = "GET_INSENTIF_CASHIER_DESCRIPTION";  
    //by priska 2016-01-11
    public static String WORKDAYBO= "WORKDAYBO";
    public static String WORKDAYBO_DESCRIPTION = "total WORKDAYBO_DESCRIPTION";
    //by priska 2016-01-11
    public static String WORKDAYOP= "WORKDAYOP";
    public static String WORKDAYOP_DESCRIPTION = "total WORKDAYOP_DESCRIPTION";
    //by priska 2015-11-04
    public static String MEMBER_OF_BPJS_KESEHATAN = "MEMBER_OF_BPJS_KESEHATAN";
    public static String MEMBER_OF_BPJS_KESEHATAN_DESCRIPTION = "total MEMBER_OF_BPJS_KESEHATAN";
    
    public static String MEMBER_OF_BPJS_KETENAGAKERJAAN = "MEMBER_OF_BPJS_KETENAGAKERJAAN";
    public static String MEMBER_OF_BPJS_KETENAGAKERJAAN_DESCRIPTION = "total MEMBER_OF_BPJS_KETENAGAKERJAAN";
    

    //by priska 2015-02-21
    public static String PAY_COMP_EARLY_HOME = "EARLY_HOME";
    public static String PAY_COMP_DESCRIPTION_EARLY_HOME = "total calculated early home ";

    //by priska 2015-02-21
    public static String PAY_COMP_LATE_EARLY = "LATE_EARLY";
    public static String PAY_COMP_DESCRIPTION_LATE_EARLY = "total calculated DATE_LATE_EARLY ";

    public static String GET_VALUE_MAPPING = "GET_VALUE_MAPPING"; // nilai reward punishment 
    public static String DESCRIPTION_GET_VALUE_MAPPING = "total calculated nilai mapping"; // Description nilai reward punishment

    
    public static String GET_DOCUMENT_COMPONENT = "GET_DOCUMENT_COMPONENT"; // nilai reward punishment 
    public static String DESCRIPTION_GET_DOCUMENT_COMPONENT = "total calculated nilai Document Component"; // Description nilai reward punishment
    public static String GET_DOCUMENT_COMPONENT_VAL_MAPPING = "GET_DOCUMENT_COMPONENT_VAL_MAPPING"; // nilai reward punishment 
    public static String DESCRIPTION_GET_DOCUMENT_COMPONENT_VAL_MAPPING = "total calculated nilai Document Component"; // Description nilai reward punishment
    public static String GET_DOC_VAL = "GET_DOC_VAL";
	public static String GET_DOC_VAL_LEAVE_ALLOWANCE = "GET_DOC_VAL_LEAVE_ALLOWANCE";
    
    public static String GET_DAY_PAY_PERIOD = "GET_DAY_PAY_PERIOD"; // nilai reward punishment 
    public static String DESCRIPTION_GET_DAY_PAY_PERIOD = "total DAY_PAY_PERIOD"; // Description nilai reward punishment

    public static String GET_PERIODE_BEFORE_COMPONENT_VALUE = "GET_PERIODE_BEFORE_COMPONENT_VALUE"; // nilai al allowance 
    public static String GET_ELIGIBLE_LEAVE = "GET_ELIGIBLE_LEAVE"; // nilai al allowance 
    //priska 20150807
    public static String GET_AL_ALLOWANCE = "GET_AL_ALLOWANCE"; // nilai al allowance 
    public static String DESCRIPTION_GET_AL_ALLOWANCE = "True or false AL_ALLOWANCE"; // Description al allowance
    public static String GET_LL_ALLOWANCE = "GET_LL_ALLOWANCE"; // nilai al allowance 
    public static String DESCRIPTION_GET_LL_ALLOWANCE = "True or false LL_ALLOWANCE"; // Description al allowance

    /* HENDRA PUTU | 2015-03-09 */
    public static final String PAY_COMP_BENEFIT_PART_ONE = "BENEFIT_PART_ONE";
    public static String PAY_COMP_BENEFIT_PART_ONE_CODE = "ALW06";
    public static final String PAY_COMP_DESCRIPTION_BENEFIT_PART_ONE = "Flat Service Charge";
    public static final String PAY_COMP_BENEFIT_PART_TWO = "BENEFIT_PART_TWO";
    public static String PAY_COMP_BENEFIT_PART_TWO_CODE = "ALW07";
    public static String UNPAID_LEAVE = "UNPAID_LEAVE";
    public static String UNPAID_LEAVE_DESCRIPTION = "UNPAID_LEAVE_DESCRIPTION";
    public static final String PAY_COMP_DESCRIPTION_BENEFIT_PART_TWO = "Service Charge by Point";

    public static final String PAY_COMP_DESCRIPTION_OVERTIME_IDX = "Total overtime index calculated based on overtime form, actual duration and overtime index setting";
    public static final String PAY_COMP_DESCRIPTION_SALARY_TAX = "Calcuated employee salary tax, based on standard calculation of Harisma";
    public static final String PAY_COMP_DESCRIPTION_SALARY_TAX_CODE = "Code of salary component representing tax paid to goverment";
    //update by satrya 2014-05-14
    public static final String PAY_COMP_REASON_IDX = "REASON_IDX_NO-REASON";
    public static final String PAY_COMP_DESCRIPTION_REASON_IDX = "Total Reason idx calculate base on system  absensi + adjusment from pay input";
    public static final String PAY_COMP_REASON_TIME = "REASON_TIME_NO-REASON";
    public static final String PAY_COMP_DESCRIPTION_REASON_TIME = "Total Reason Time calculate base on system absensi + adjusment from pay input";
    public static final String PAY_COMP_POSITION = "POSITION_NAMA-POSITION";
    public static final String PAY_COMP_DESCRIPTION_POSITION = "Total Position  calculate base on system   + adjusment from pay input";

    public static final String PAY_COMP_NIGHT_ALLOWANCE_IDX = "NIGHT_ALLOWANCE";
    public static final String PAY_COMP_DESCRIPTION_NIGHT_ALLOWANCE_IDX = "If people have worked in night shift, so they will get allowance";
    
    // dedy 20160305
    public static final String GET_HUTANG = "EMPLOYEE_PAYABLE";
    public static final String WITHOUT_LEAVE = "WITHOUT_LEAVE";
    public static final String SALARY_TAX_NON_RUTIN = "SALARY_TAX_NON_RUTIN";
    public static final String SECOND_SLIP_SALARY_TAX_NON_RUTIN = "SECOND_SLIP_SALARY_TAX_NON_RUTIN";
    public static final String GET_SCHEDULE_SYMBOL = "GET_SCHEDULE_SYMBOL_";
    public static final String GET_COMPONENT_VALUE = "GET_COMPONENT_VALUE_";
    public static final String GET_PREV_PERIOD_COMP_VALUE = "GET_PREV_PERIOD_COMP_VALUE_";
    public static final String GET_WITHOUT_LEAVE_SCHEDULE_SYMBOL = "GET_WITHOUT_LEAVE_SCHEDULE_SYMBOL_";
    public static final String GET_WITH_DAY_OFF_WITHOUT_LEAVE_SCHEDULE_SYMBOL = "GET_WITH_DAY_OFF_WITHOUT_LEAVE_SCHEDULE_SYMBOL_";
    public static final String GET_SCH_MEAL_ALLOWANCE_WITH_DURATION = "GET_MEAL_ALLOWANCE_WITH_DURATION";
    public static final String GET_POTONGAN_KREDIT = "GET_POTONGAN_KREDIT";
    public static final String GET_MATERNITY_LEAVE_DURATION = "GET_MATERNITY_LEAVE_DURATION";
    public static final String GET_UNPAID_LEAVE_DURATION = "GET_UNPAID_LEAVE_DURATION";
    public static final String GET_LL_STOCK = "GET_LL_STOCK";
    public static final String GET_AL_STOCK = "GET_AL_STOCK";

    public static final String[][] payComCaculated = {
        {PAY_COMP_OVERTIME_IDX, PAY_COMP_DESCRIPTION_OVERTIME_IDX},
        {PAY_COMP_SALARY_TAX, PAY_COMP_DESCRIPTION_SALARY_TAX},
        {PAY_COMP_SALARY_TAX_CODE, PAY_COMP_DESCRIPTION_SALARY_TAX_CODE},
        {PAY_COMP_CALC_MEALS_ALLOWANCE, "Calcuated meal allowance from overtime form"},
        {PAY_COMP_DATE_OK, "Date ok(attendance ontime and no early ) without leave"},
        {PAY_COMP_DATE_OK_WITH_LEAVE, "Date ok(attendance ontime and no early ) with leave included"}
    };
    

    /**
     * Creates a new instance of PstPaySlip
     */
    public PstPaySlip() {
    }

    private static Vector logicParser(String text) {
        Vector vector = LogicParser.textSentence(text);
        for (int i = 0; i < vector.size(); i++) {
            String code = (String) vector.get(i);
            if (((vector.get(vector.size() - 1)).equals(LogicParser.SIGN))
                    && ((vector.get(vector.size() - 1)).equals(LogicParser.ENGLISH))) {
                vector.remove(vector.size() - 1);
            }
        }

        return vector;
    }

    public PstPaySlip(int i) throws DBException {
        super(new PstPaySlip());
    }

    public PstPaySlip(String sOid) throws DBException {
        super(new PstPaySlip(0));
        if (!locate(sOid)) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public PstPaySlip(long lOid) throws DBException {
        super(new PstPaySlip(0));
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

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public long fetchExc(Entity ent) throws Exception {
        PaySlip paySlip = fetchExc(ent.getOID());
        ent = (Entity) paySlip;
        return paySlip.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((PaySlip) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((PaySlip) ent);
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int getFieldSize() {
        return fieldNames.length;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new PstPaySlip().getClass().getName();
    }

    public String getTableName() {
        return TBL_PAY_SLIP;
    }

    public static PaySlip fetchExc(long oid) throws DBException {
        try {
            PaySlip paySlip = new PaySlip();
            PstPaySlip pstPaySlip = new PstPaySlip(oid);
            paySlip.setOID(oid);
            paySlip.setPeriodId(pstPaySlip.getlong(FLD_PERIOD_ID));
            paySlip.setEmployeeId(pstPaySlip.getlong(FLD_EMPLOYEE_ID));
            paySlip.setStatus(pstPaySlip.getInt(FLD_STATUS));
            paySlip.setPaidStatus(pstPaySlip.getInt(FLD_PAID_STATUS));
            paySlip.setPaySlipDate(pstPaySlip.getDate(FLD_PAY_SLIP_DATE));
            paySlip.setDayPresent(pstPaySlip.getdouble(FLD_DAY_PRESENT));
            paySlip.setDayPaidLv(pstPaySlip.getdouble(FLD_DAY_PAID_LV));
            paySlip.setDayAbsent(pstPaySlip.getdouble(FLD_DAY_ABSENT));
            paySlip.setDayUnpaidLv(pstPaySlip.getdouble(FLD_DAY_UNPAID_LV));
            //update by satrya 2013-02-21
            paySlip.setDaysOkWithLeave(pstPaySlip.getdouble(FLD_DATE_OK_WITH_LEAVE));
            paySlip.setInsentif(pstPaySlip.getdouble(FLD_INSENTIF));
            paySlip.setTotDayOffOt(pstPaySlip.getdouble(FLD_TOTAL_DAY_OFF_OVERTIME));
            paySlip.setDayOffSch(pstPaySlip.getdouble(FLD_DAY_OFF_SCHEDULE));

            paySlip.setDivision(pstPaySlip.getString(FLD_DIVISION));
            paySlip.setDepartment(pstPaySlip.getString(FLD_DEPARTMENT));
            paySlip.setPosition(pstPaySlip.getString(FLD_POSITION));
            paySlip.setSection(pstPaySlip.getString(FLD_SECTION));
            paySlip.setNote(pstPaySlip.getString(FLD_NOTE));
            paySlip.setCommencDate(pstPaySlip.getDate(FLD_COMMENC_DATE));
            paySlip.setPaymentType(pstPaySlip.getlong(FLD_PAYMENT_TYPE));
            paySlip.setBankId(pstPaySlip.getlong(FLD_BANK_ID));
            paySlip.setPaySlipType(pstPaySlip.getInt(FLD_PAY_SLIP_TYPE));
            paySlip.setCompCode(pstPaySlip.getString(FLD_COMP_CODE));
            paySlip.setDayLate(pstPaySlip.getdouble(FLD_DAY_LATE));
            paySlip.setProcentasePresence(pstPaySlip.getdouble(FLD_PROCENTASE_PRESENCE));
            //update by satrya 2013-05-06
            paySlip.setOvIdxAdj(pstPaySlip.getdouble(FLD_OV_IDX_ADJUSTMENT));
            paySlip.setPrivateNote(pstPaySlip.getString(FLD_PRIVATE_NOTE));

            //update by satrya 2014-02-06
            paySlip.setMealAllowanceMoneyByForm(pstPaySlip.getdouble(FLD_MEAL_ALLOWANCE_MONEY));
            paySlip.setMealAllowanceMoneyAdj(pstPaySlip.getdouble(FLD_MEAL_ALLOWANCE_MONEY_ADJUSMENT));
            paySlip.setOvertimeIdxByForm(pstPaySlip.getdouble(FLD_OVERTIME_IDX));
            paySlip.setNoteAdmin(pstPaySlip.getString(FLD_NOTE_ADMIN));

            paySlip.setOvIdxPaidBySalaryAdjDt(pstPaySlip.getDate(FLD_OV_IDX_PAID_SALARY_ADJUSMENT_DATE));
            paySlip.setOvAllowanceMoneyAdjDt(pstPaySlip.getDate(FLD_OV_MEAL_ALLOWANCE_MONEY_ADJ_DATE));
            
            paySlip.setGradeCode(pstPaySlip.getString(FLD_GRADE_CODE));
            return paySlip;
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstPaySlip(0), DBException.UNKNOWN);
        }
    }

    public static long insertExcWithDetail(PaySlip paySlip) throws DBException {
        /*
         Description : this code is modified by Hendra McHen
         Date : 2015-04-20
         Author : Hendra McHen
         Analysis : 
         oid = getPaySlipId(PERIOD_ID, EMPLOYEE_ID)
         check jika oid != 0
         begin
         check payslip components
         jika tidak sama dengan null maka lakukan proses
         ambil list data dari excel kemudian bandingkan dengan list data dari table db
         jika nama component sama maka bandingkan value, jika beda maka update, 
         jika tidak maka lakukan insert
         end
         jika tidak
         begin
         buat payslip id
         lakukan insert data ke payslip dan payslipcomponent
         end
         */
        /* Update 2016-07-27 */
        long output = 0;
        try {
            long oid = getPaySlipId(paySlip.getPeriodId(), paySlip.getEmployeeId());
            if (oid != 0) {
                if (paySlip.getPaySlipComps() != null) {
                    Vector slipCompFromXLS = paySlip.getPaySlipComps();
                    for (int i = 0; i < slipCompFromXLS.size(); i++) {
                        PaySlipComp slipComponent = new PaySlipComp();
                        PaySlipComp compFromXLS = (PaySlipComp) slipCompFromXLS.get(i);
                        String whereClause = "" + PstPaySlipComp.fieldNames[PstPaySlipComp.FLD_PAY_SLIP_ID] + "=" + oid + " AND COMP_CODE='" + compFromXLS.getCompCode() + "'";
                        Vector slipCompFromDB = PstPaySlipComp.list(0, 0, whereClause, "");
                        if (slipCompFromDB != null && slipCompFromDB.size() > 0) {
                            PaySlipComp compFromDB = (PaySlipComp) slipCompFromDB.get(0);
                            if (compFromDB.getCompCode().equals(compFromXLS.getCompCode())) {
                                if (compFromDB.getCompValue() != compFromXLS.getCompValue()) {
                                    String dataOut = compFromDB.getCompCode()+" == "+compFromXLS.getCompCode();
                                    dataOut += "\n "+compFromDB.getCompValue()+" != "+compFromXLS.getCompValue();
                                    dataOut += "\n "+compFromDB.getOID();
                                    dataOut += "\n payslipId:"+oid;
                                    try {
                                        slipComponent.setCompCode(compFromXLS.getCompCode());
                                        slipComponent.setCompValue(compFromXLS.getCompValue());
                                        slipComponent.setPaySlipId(oid);
                                        // output = PstPaySlipComp.updateExc(slipComponent);
                                        
                                        PstPaySlipComp.deleteExc(compFromDB.getOID());
                                        output = PstPaySlipComp.insertExc(slipComponent);
                                    } catch (Exception exc) {
                                        System.out.println("PstPaySlipComp.updateExc(slipComponent)=>"+" dataout: "+dataOut+" e: "+exc.toString());
                                    }
                                }
                            }
                        } else {
                            if (paySlip.getPaySlipComps() != null) {
                                Vector details = paySlip.getPaySlipComps();
                                for (int s = 0; s < details.size(); s++) {
                                    PaySlipComp comp = (PaySlipComp) details.get(s);
                                    PaySlipComp slipComp = new PaySlipComp();
                                    slipComp.setPaySlipId(oid);
                                    slipComp.setCompCode(comp.getCompCode());
                                    slipComp.setCompValue(comp.getCompValue());
                                    try {
                                        output = PstPaySlipComp.insertExc(slipComp);
                                    } catch (Exception exc) {
                                        System.out.println("PstPaySlipComp.insertExc(slipComp)=>"+exc.toString());
                                    }
                                }
                            }
                        }
                    }
                }
            } else {
                oid = insertExc(paySlip);
                if (paySlip.getPaySlipComps() != null) {
                    //PstPaySlipComp.deleteByPaySlipId(oid);
                    Vector details = paySlip.getPaySlipComps();
                    for (int i = 0; i < details.size(); i++) {
                        PaySlipComp comp = (PaySlipComp) details.get(i);
                        comp.setPaySlipId(oid);
                        try {
                            output = PstPaySlipComp.insertExc(comp);
                        } catch (Exception exc) {
                            System.out.println("PstPaySlipComp.insertExc(comp)=>"+exc.toString());
                        }

                    }
                }
            }

        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstPaySlip(0), DBException.UNKNOWN);
        }
        return output;
    }

    public static long insertExc(PaySlip paySlip) throws DBException {
        try {
            PstPaySlip pstPaySlip = new PstPaySlip(0);
            pstPaySlip.setLong(FLD_PERIOD_ID, paySlip.getPeriodId());
            pstPaySlip.setLong(FLD_EMPLOYEE_ID, paySlip.getEmployeeId());
            pstPaySlip.setInt(FLD_STATUS, paySlip.getStatus());
            pstPaySlip.setInt(FLD_PAID_STATUS, paySlip.getPaidStatus());
            pstPaySlip.setDate(FLD_PAY_SLIP_DATE, paySlip.getPaySlipDate());
            pstPaySlip.setDouble(FLD_DAY_PRESENT, paySlip.getDayPresent());
            pstPaySlip.setDouble(FLD_DAY_PAID_LV, paySlip.getDayPaidLv());
            pstPaySlip.setDouble(FLD_DAY_ABSENT, paySlip.getDayAbsent());
            pstPaySlip.setDouble(FLD_DAY_UNPAID_LV, paySlip.getDayUnpaidLv());
            pstPaySlip.setString(FLD_DIVISION, paySlip.getDivision());
            pstPaySlip.setString(FLD_DEPARTMENT, paySlip.getDepartment());
            pstPaySlip.setString(FLD_POSITION, paySlip.getPosition());
            pstPaySlip.setString(FLD_SECTION, paySlip.getSection());
            pstPaySlip.setString(FLD_NOTE, paySlip.getNote());
            pstPaySlip.setDate(FLD_COMMENC_DATE, paySlip.getCommencDate());
            pstPaySlip.setLong(FLD_PAYMENT_TYPE, paySlip.getPaymentType());
            pstPaySlip.setLong(FLD_BANK_ID, paySlip.getBankId());
            pstPaySlip.setInt(FLD_PAY_SLIP_TYPE, paySlip.getPaySlipType());
            pstPaySlip.setString(FLD_COMP_CODE, paySlip.getCompCode());
            pstPaySlip.setDouble(FLD_DAY_LATE, paySlip.getDayLate());
            pstPaySlip.setDouble(FLD_PROCENTASE_PRESENCE, paySlip.getProcentasePresence());
            //update by satrya 2013-05-06
            pstPaySlip.setDouble(FLD_OV_IDX_ADJUSTMENT, paySlip.getOvIdxAdj());
            pstPaySlip.setString(FLD_PRIVATE_NOTE, paySlip.getPrivateNote());
            //update by satrya 2014-02-06
            pstPaySlip.setDouble(FLD_MEAL_ALLOWANCE_MONEY, paySlip.getMealAllowanceMoneyByForm());
            pstPaySlip.setDouble(FLD_MEAL_ALLOWANCE_MONEY_ADJUSMENT, paySlip.getMealAllowanceMoneyAdj());
            pstPaySlip.setDouble(FLD_OVERTIME_IDX, paySlip.getOvertimeIdxByForm());
            pstPaySlip.setString(FLD_NOTE_ADMIN, paySlip.getNoteAdmin());

            pstPaySlip.setDate(FLD_OV_IDX_PAID_SALARY_ADJUSMENT_DATE, paySlip.getOvIdxPaidBySalaryAdjDt());
            pstPaySlip.setDate(FLD_OV_MEAL_ALLOWANCE_MONEY_ADJ_DATE, paySlip.getOvAllowanceMoneyAdjDt());
            
            pstPaySlip.setString(FLD_GRADE_CODE, paySlip.getGradeCode());
            pstPaySlip.insert();
            paySlip.setOID(pstPaySlip.getlong(FLD_PAY_SLIP_ID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstPaySlip(0), DBException.UNKNOWN);
        }
        return paySlip.getOID();
    }

    public static long updateExc(PaySlip paySlip) throws DBException {
        try {
            if (paySlip.getOID() != 0) {
                PstPaySlip pstPaySlip = new PstPaySlip(paySlip.getOID());
                pstPaySlip.setLong(FLD_PERIOD_ID, paySlip.getPeriodId());
                pstPaySlip.setLong(FLD_EMPLOYEE_ID, paySlip.getEmployeeId());
                pstPaySlip.setInt(FLD_STATUS, paySlip.getStatus());
                pstPaySlip.setInt(FLD_PAID_STATUS, paySlip.getPaidStatus());
                pstPaySlip.setDate(FLD_PAY_SLIP_DATE, paySlip.getPaySlipDate());
                pstPaySlip.setDouble(FLD_DAY_PRESENT, paySlip.getDayPresent());
                pstPaySlip.setDouble(FLD_DAY_PAID_LV, paySlip.getDayPaidLv());
                pstPaySlip.setDouble(FLD_DAY_ABSENT, paySlip.getDayAbsent());
                pstPaySlip.setDouble(FLD_DAY_UNPAID_LV, paySlip.getDayUnpaidLv());
                pstPaySlip.setString(FLD_DIVISION, paySlip.getDivision());
                pstPaySlip.setString(FLD_DEPARTMENT, paySlip.getDepartment());
                pstPaySlip.setString(FLD_POSITION, paySlip.getPosition());
                pstPaySlip.setString(FLD_SECTION, paySlip.getSection());
                pstPaySlip.setString(FLD_NOTE, paySlip.getNote());
                pstPaySlip.setDate(FLD_COMMENC_DATE, paySlip.getCommencDate());
                pstPaySlip.setLong(FLD_PAYMENT_TYPE, paySlip.getPaymentType());
                pstPaySlip.setLong(FLD_BANK_ID, paySlip.getBankId());
                pstPaySlip.setInt(FLD_PAY_SLIP_TYPE, paySlip.getPaySlipType());
                pstPaySlip.setString(FLD_COMP_CODE, paySlip.getCompCode());
                pstPaySlip.setDouble(FLD_DAY_LATE, paySlip.getDayLate());
                pstPaySlip.setDouble(FLD_PROCENTASE_PRESENCE, paySlip.getProcentasePresence());

                //update by satrya 2013-05-06
                pstPaySlip.setDouble(FLD_OV_IDX_ADJUSTMENT, paySlip.getOvIdxAdj());
                pstPaySlip.setString(FLD_PRIVATE_NOTE, paySlip.getPrivateNote());

                //update by satrya 2014-02-06
                pstPaySlip.setDouble(FLD_MEAL_ALLOWANCE_MONEY, paySlip.getMealAllowanceMoneyByForm());
                pstPaySlip.setDouble(FLD_MEAL_ALLOWANCE_MONEY_ADJUSMENT, paySlip.getMealAllowanceMoneyAdj());
                pstPaySlip.setDouble(FLD_OVERTIME_IDX, paySlip.getOvertimeIdxByForm());
                pstPaySlip.setString(FLD_NOTE_ADMIN, paySlip.getNoteAdmin());

                pstPaySlip.setDate(FLD_OV_IDX_PAID_SALARY_ADJUSMENT_DATE, paySlip.getOvIdxPaidBySalaryAdjDt());
                pstPaySlip.setDate(FLD_OV_MEAL_ALLOWANCE_MONEY_ADJ_DATE, paySlip.getOvAllowanceMoneyAdjDt());
                pstPaySlip.setString(FLD_GRADE_CODE, paySlip.getGradeCode());
                pstPaySlip.update();
                return paySlip.getOID();

            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstPaySlip(0), DBException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws DBException {
        try {
            PstPaySlip pstPaySlip = new PstPaySlip(oid);
            pstPaySlip.delete();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstPaySlip(0), DBException.UNKNOWN);
        }
        return oid;
    }

    public static Vector listAll() {
        return list(0, 1000, "", "");
    }

    public static Vector list(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT * FROM " + TBL_PAY_SLIP;
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
            //System.out.println("SQL LIST Pay Slip"+sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                PaySlip paySlip = new PaySlip();
                resultToObject(rs, paySlip);
                lists.add(paySlip);
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

    public static void resultToObject(ResultSet rs, PaySlip paySlip) {
        try {
            paySlip.setOID(rs.getLong(PstPaySlip.fieldNames[PstPaySlip.FLD_PAY_SLIP_ID]));
            paySlip.setPeriodId(rs.getLong(PstPaySlip.fieldNames[PstPaySlip.FLD_PERIOD_ID]));
            paySlip.setEmployeeId(rs.getLong(PstPaySlip.fieldNames[PstPaySlip.FLD_EMPLOYEE_ID]));
            paySlip.setStatus(rs.getInt(PstPaySlip.fieldNames[PstPaySlip.FLD_STATUS]));
            paySlip.setPaidStatus(rs.getInt(PstPaySlip.fieldNames[PstPaySlip.FLD_PAID_STATUS]));
            paySlip.setPaySlipDate(rs.getDate(PstPaySlip.fieldNames[PstPaySlip.FLD_PAY_SLIP_DATE]));
            paySlip.setDayPresent(rs.getDouble(PstPaySlip.fieldNames[PstPaySlip.FLD_DAY_PRESENT]));
            paySlip.setDayPresent(rs.getDouble(PstPaySlip.fieldNames[PstPaySlip.FLD_DAY_PRESENT]));
            paySlip.setDayPaidLv(rs.getDouble(PstPaySlip.fieldNames[PstPaySlip.FLD_DAY_PAID_LV]));
            paySlip.setDayAbsent(rs.getDouble(PstPaySlip.fieldNames[PstPaySlip.FLD_DAY_ABSENT]));
            paySlip.setDayUnpaidLv(rs.getDouble(PstPaySlip.fieldNames[PstPaySlip.FLD_DAY_UNPAID_LV]));
            paySlip.setDivision(rs.getString(PstPaySlip.fieldNames[PstPaySlip.FLD_DIVISION]));
            paySlip.setDepartment(rs.getString(PstPaySlip.fieldNames[PstPaySlip.FLD_DEPARTMENT]));
            paySlip.setPosition(rs.getString(PstPaySlip.fieldNames[PstPaySlip.FLD_POSITION]));
            paySlip.setSection(rs.getString(PstPaySlip.fieldNames[PstPaySlip.FLD_SECTION]));
            paySlip.setNote(rs.getString(PstPaySlip.fieldNames[PstPaySlip.FLD_NOTE]));
            paySlip.setCommencDate(rs.getDate(PstPaySlip.fieldNames[PstPaySlip.FLD_COMMENC_DATE]));
            paySlip.setPaymentType(rs.getLong(PstPaySlip.fieldNames[PstPaySlip.FLD_PAYMENT_TYPE]));
            paySlip.setBankId(rs.getLong(PstPaySlip.fieldNames[PstPaySlip.FLD_BANK_ID]));
            paySlip.setPaySlipType(rs.getInt(PstPaySlip.fieldNames[PstPaySlip.FLD_PAY_SLIP_TYPE]));
            paySlip.setCompCode(rs.getString(PstPaySlip.fieldNames[PstPaySlip.FLD_COMP_CODE]));
            paySlip.setDayLate(rs.getDouble(PstPaySlip.fieldNames[PstPaySlip.FLD_DAY_LATE]));
            paySlip.setProcentasePresence(rs.getDouble(PstPaySlip.fieldNames[PstPaySlip.FLD_PROCENTASE_PRESENCE]));

            //update by satrya 2013-05-06
            paySlip.setOvIdxAdj(rs.getDouble(PstPaySlip.fieldNames[PstPaySlip.FLD_OV_IDX_ADJUSTMENT]));
            paySlip.setPrivateNote(rs.getString(PstPaySlip.fieldNames[PstPaySlip.FLD_PRIVATE_NOTE]));

            //update by satrya 2014-02-06
            paySlip.setMealAllowanceMoneyByForm(rs.getDouble(PstPaySlip.fieldNames[PstPaySlip.FLD_MEAL_ALLOWANCE_MONEY]));
            paySlip.setMealAllowanceMoneyAdj(rs.getDouble(PstPaySlip.fieldNames[PstPaySlip.FLD_MEAL_ALLOWANCE_MONEY_ADJUSMENT]));
            paySlip.setOvertimeIdxByForm(rs.getDouble(PstPaySlip.fieldNames[PstPaySlip.FLD_OVERTIME_IDX]));
            paySlip.setNoteAdmin(rs.getString(PstPaySlip.fieldNames[PstPaySlip.FLD_NOTE_ADMIN]));

            paySlip.setOvIdxPaidBySalaryAdjDt(rs.getDate(FLD_OV_IDX_PAID_SALARY_ADJUSMENT_DATE));
            paySlip.setOvAllowanceMoneyAdjDt(rs.getDate(FLD_OV_MEAL_ALLOWANCE_MONEY_ADJ_DATE));
            paySlip.setGradeCode(rs.getString(FLD_GRADE_CODE));
        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long slipId) {
        DBResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + TBL_PAY_SLIP + " WHERE "
                    + PstPaySlip.fieldNames[PstPaySlip.FLD_PAY_SLIP_ID] + " = '" + slipId + "'";

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

    
    public static int getSeniorOrSupervisor(long employeeId, long sectionId, long departmentId) {
        DBResultSet dbrs = null;
        int dapat = 0;
        long oid = 0;
        try {
            String sql   = "SELECT  he.`EMPLOYEE_ID` ";
                    sql += "FROM `hr_employee` he  INNER JOIN `hr_position` hp ON hp.`POSITION_ID` = he.`POSITION_ID`"; 
                    sql += "WHERE he.`DEPARTMENT_ID` = "+departmentId+"  AND he.`SECTION_ID` = "+sectionId+"  AND he.`POSITION_ID` IN (20150382, 20150377) ORDER BY hp.`POSITION_LEVEL`";


            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                oid = rs.getLong(1);
            }

            rs.close();
            
            if ((oid == employeeId) && (employeeId!=0)){
                dapat = 1;
            }
            
            return dapat;
        } catch (Exception e) {
            return dapat;
        } finally {
            DBResultSet.close(dbrs);
        }
    }
    
    public static boolean checkOIDEmp(long oidEmployee) {
        DBResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + TBL_PAY_SLIP + " WHERE "
                    + PstPaySlip.fieldNames[PstPaySlip.FLD_EMPLOYEE_ID] + " = '" + oidEmployee + "'";

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
            String sql = "SELECT COUNT(" + PstPaySlip.fieldNames[PstPaySlip.FLD_PAY_SLIP_ID] + ") FROM " + TBL_PAY_SLIP;
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
        String order = "";
        int size = getCount(whereClause);
        int start = 0;
        boolean found = false;
        for (int i = 0; (i < size) && !found; i = i + recordToGet) {
            Vector list = list(i, recordToGet, whereClause, orderClause);
            start = i;
            if (list.size() > 0) {
                for (int ls = 0; ls < list.size(); ls++) {
                    PaySlip paySlip = (PaySlip) list.get(ls);
                    if (oid == paySlip.getOID()) {
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
        vectSize = vectSize + mdl;
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

    public static long getPaySlipId(long periodId, long employeeId, String compCode) {
        DBResultSet dbrs = null;
        long paySlipOid = 0;
        try {
            String sql = "SELECT " + fieldNames[FLD_PAY_SLIP_ID]
                    + " FROM " + TBL_PAY_SLIP
                    + " WHERE " + PstPaySlip.fieldNames[PstPaySlip.FLD_PERIOD_ID] + " = " + periodId + " AND "
                    + PstPaySlip.fieldNames[PstPaySlip.FLD_EMPLOYEE_ID] + " = " + employeeId + " AND "
                    + PstPaySlip.fieldNames[PstPaySlip.FLD_COMP_CODE] + " = '" + compCode + "'";

            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            System.out.println("sql get PaySlipId: " + sql);
            while (rs.next()) {
                paySlipOid = rs.getLong(fieldNames[FLD_PAY_SLIP_ID]);
            }

            rs.close();
            return paySlipOid;
        } catch (Exception e) {
            System.out.println("err : " + e.toString());
        } finally {
            DBResultSet.close(dbrs);
            return paySlipOid;
        }
    }
    
    public static int getCountPaySlip(long periodId, long employeeId) {
        DBResultSet dbrs = null;
        int result = 0;
        try {
            String sql = "SELECT COUNT(" + fieldNames[FLD_PAY_SLIP_ID]
                    + ") AS COUNT FROM " + TBL_PAY_SLIP
                    + " WHERE " + PstPaySlip.fieldNames[PstPaySlip.FLD_PERIOD_ID] + " = " + periodId + " AND "
                    + PstPaySlip.fieldNames[PstPaySlip.FLD_EMPLOYEE_ID] + " = " + employeeId;

            //System.out.println("sql get PaySlipId: " + sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            //System.out.println("sql get PaySlipId: " + sql);
            while (rs.next()) {
                result = rs.getInt("COUNT");
            }

            rs.close();
            
        } catch (Exception e) {
            System.out.println("err : " + e.toString());
        } finally {
            DBResultSet.close(dbrs);
            return result;
        }
    }

    public static long getPaySlipId(long periodId, long employeeId) {
        DBResultSet dbrs = null;
        long paySlipOid = 0;
        try {
            String sql = "SELECT " + fieldNames[FLD_PAY_SLIP_ID]
                    + " FROM " + TBL_PAY_SLIP
                    + " WHERE " + PstPaySlip.fieldNames[PstPaySlip.FLD_PERIOD_ID] + " = " + periodId + " AND "
                    + PstPaySlip.fieldNames[PstPaySlip.FLD_EMPLOYEE_ID] + " = " + employeeId;

            //System.out.println("sql get PaySlipId: " + sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            //System.out.println("sql get PaySlipId: " + sql);
            int size= getCountPaySlip(periodId, employeeId);
            
            while (rs.next()) {
                if (size > 1){
                    long oidSecond = getSecondPaySlipId(periodId, employeeId);
                    if (oidSecond != rs.getLong(fieldNames[FLD_PAY_SLIP_ID])){
                        paySlipOid = rs.getLong(fieldNames[FLD_PAY_SLIP_ID]);
                        return paySlipOid;
                    }
                } else {
                    paySlipOid = rs.getLong(fieldNames[FLD_PAY_SLIP_ID]);
                    return paySlipOid;
                }
                
            }

            rs.close();
            
        } catch (Exception e) {
            System.out.println("err : " + e.toString());
        } finally {
            DBResultSet.close(dbrs);
            return paySlipOid;
        }
    }
    
    public static long getSecondPaySlipId(long periodId, long employeeId) {
        
        long oidSecondSlipDivision = 0;
        try{
            oidSecondSlipDivision = Long.valueOf(PstSystemProperty.getValueByName("SECOND_SLIP_DIVISION_ID"));
        } catch (Exception exc){}
        
        String mbtName = "";
        if (oidSecondSlipDivision > 0){
            Division div = new Division();
            try {
                div = PstDivision.fetchExc(oidSecondSlipDivision);
                mbtName = div.getDivision();
            } catch (Exception exc){}
        }
        
        DBResultSet dbrs = null;
        long paySlipOid = 0;
        try {
            String sql = "SELECT " + fieldNames[FLD_PAY_SLIP_ID]
                    + " FROM " + TBL_PAY_SLIP
                    + " WHERE " + PstPaySlip.fieldNames[PstPaySlip.FLD_PERIOD_ID] + " = " + periodId + " AND "
                    + PstPaySlip.fieldNames[PstPaySlip.FLD_EMPLOYEE_ID] + " = " + employeeId+ " AND "
                    + PstPaySlip.fieldNames[PstPaySlip.FLD_DIVISION] + " = '"+mbtName+"'";

            //System.out.println("sql get PaySlipId: " + sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            //System.out.println("sql get PaySlipId: " + sql);
            while (rs.next()) {
                paySlipOid = rs.getLong(fieldNames[FLD_PAY_SLIP_ID]);
                return paySlipOid;
            }

            rs.close();
            
        } catch (Exception e) {
            System.out.println("err : " + e.toString());
        } finally {
            DBResultSet.close(dbrs);
            return paySlipOid;
        }
    }    
    
    
    public static long getPaySlipIdByDivisionOrDepartment(long periodId, long employeeId, String division, String department) {
        DBResultSet dbrs = null;
        long paySlipOid = 0;
        try {
            String sql = "SELECT " + fieldNames[FLD_PAY_SLIP_ID]
                    + " FROM " + TBL_PAY_SLIP
                    + " WHERE " + PstPaySlip.fieldNames[PstPaySlip.FLD_PERIOD_ID] + " = " + periodId + " AND "
                    + PstPaySlip.fieldNames[PstPaySlip.FLD_EMPLOYEE_ID] + " = " + employeeId +" AND ("
                    + PstPaySlip.fieldNames[PstPaySlip.FLD_DIVISION] + " = '"+division+"' OR "
                    + PstPaySlip.fieldNames[PstPaySlip.FLD_DEPARTMENT] + " = '"+department+"')";

            //System.out.println("sql get PaySlipId: " + sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            //System.out.println("sql get PaySlipId: " + sql);
            while (rs.next()) {
                paySlipOid = rs.getLong(fieldNames[FLD_PAY_SLIP_ID]);
                return paySlipOid;
            }

            rs.close();
            
        } catch (Exception e) {
            System.out.println("err : " + e.toString());
        } finally {
            DBResultSet.close(dbrs);
            return paySlipOid;
        }
    }
    
//    public static long getPaySlipIdMBT(long periodId, long employeeId) {
//        DBResultSet dbrs = null;
//        long paySlipOid = 0;
//        try {
//            String sql = "SELECT " + fieldNames[FLD_PAY_SLIP_ID]
//                    + " FROM " + TBL_PAY_SLIP
//                    + " WHERE " + PstPaySlip.fieldNames[PstPaySlip.FLD_PERIOD_ID] + " = " + periodId + " AND "
//                    + PstPaySlip.fieldNames[PstPaySlip.FLD_EMPLOYEE_ID] + " = " + employeeId + " AND "
//                    + PstPaySlip.fieldNames[PstPaySlip.FLD_DIVISION] + " = 'Masa Bebas Tugas'";
//
//            //System.out.println("sql get PaySlipId: " + sql);
//            dbrs = DBHandler.execQueryResult(sql);
//            ResultSet rs = dbrs.getResultSet();
//            //System.out.println("sql get PaySlipId: " + sql);
//            while (rs.next()) {
//                paySlipOid = rs.getLong(fieldNames[FLD_PAY_SLIP_ID]);
//                return paySlipOid;
//            }
//
//            rs.close();
//            
//        } catch (Exception e) {
//            System.out.println("err : " + e.toString());
//        } finally {
//            DBResultSet.close(dbrs);
//            return paySlipOid;
//        }
//    }

    /*
     *  This method used to update status of data 
     *  Created By Yunny
     */
    public static void updateStatus(long paySlipId, int appStatus, int paidStatus) {
        DBResultSet dbrs = null;
        //boolean result = false;
        //String barcode = (barcodeNumber.equals(null)) ? "null" : barcodeNumber;

        try {
            String sql = "";

            sql = " UPDATE " + TBL_PAY_SLIP + " SET "
                    + PstPaySlip.fieldNames[PstPaySlip.FLD_STATUS] + " =  " + appStatus + ","
                    + PstPaySlip.fieldNames[PstPaySlip.FLD_PAID_STATUS] + " =  " + paidStatus
                    + " WHERE " + PstPaySlip.fieldNames[PstPaySlip.FLD_PAY_SLIP_ID] + " = " + paySlipId;

            //dbrs = DBHandler.execQueryResult(sql);
            int status = DBHandler.execUpdate(sql);
            //ResultSet rs = dbrs.getResultSet();
            // System.out.println("\tupdateStatus : " + sql);
            //while(rs.next()) { result = true; }
            //rs.close();
        } catch (Exception e) {
            System.err.println("\tupdateStatus error : " + e.toString());
        } finally {
            DBResultSet.close(dbrs);
            //return result;
        }
    }

    /* This method used to get datas for employee who have payroll slip
     * Created By Yunny 
     */
    public static Vector getEmpSlip(long periodId, long paySlipId) {
        Vector result = new Vector(1, 1);
        DBResultSet dbrs = null;

        try {
            String sql = "SELECT EMP." + PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID]
                    + ", EMP." + PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_NUM]
                    + ", EMP." + PstEmployee.fieldNames[PstEmployee.FLD_FULL_NAME]
                    + ", PAY." + PstPaySlip.fieldNames[PstPaySlip.FLD_STATUS]
                    + ", PAY." + PstPaySlip.fieldNames[PstPaySlip.FLD_PAID_STATUS]
                    + ", PAY." + PstPaySlip.fieldNames[PstPaySlip.FLD_DIVISION]
                    + ", PAY." + PstPaySlip.fieldNames[PstPaySlip.FLD_DEPARTMENT]
                    + ", PAY." + PstPaySlip.fieldNames[PstPaySlip.FLD_POSITION]
                    + ", PAY." + PstPaySlip.fieldNames[PstPaySlip.FLD_SECTION]
                    + ", PAY." + PstPaySlip.fieldNames[PstPaySlip.FLD_COMMENC_DATE]
                    + ", PAY." + PstPaySlip.fieldNames[PstPaySlip.FLD_DAY_PRESENT]
                    + ", PAY." + PstPaySlip.fieldNames[PstPaySlip.FLD_DAY_PAID_LV]
                    + ", PAY." + PstPaySlip.fieldNames[PstPaySlip.FLD_DAY_ABSENT]
                    + ", PAY." + PstPaySlip.fieldNames[PstPaySlip.FLD_DAY_UNPAID_LV]
                    + ", PAY." + PstPaySlip.fieldNames[PstPaySlip.FLD_DAY_LATE]
                    + ", PAY." + PstPaySlip.fieldNames[PstPaySlip.FLD_NOTE]
                    + ", EMP." + PstEmployee.fieldNames[PstEmployee.FLD_COMPANY_ID] + ", EMP." + PstEmployee.fieldNames[PstEmployee.FLD_EMAIL_ADDRESS]
                    + ", EMP." + PstEmployee.fieldNames[PstEmployee.FLD_BIRTH_DATE] + ""
                    + ", PAY." + PstPaySlip.fieldNames[PstPaySlip.FLD_GRADE_CODE]
                    + " FROM " + PstEmployee.TBL_HR_EMPLOYEE + " AS EMP "
                    + " INNER JOIN " + PstPaySlip.TBL_PAY_SLIP + " AS PAY "
                    + " ON EMP." + PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID]
                    + " = PAY." + PstPaySlip.fieldNames[PstPaySlip.FLD_EMPLOYEE_ID]
                    + " WHERE PAY." + PstPaySlip.fieldNames[PstPaySlip.FLD_PAY_SLIP_ID]
                    + " = " + paySlipId
                    + " AND PAY." + PstPaySlip.fieldNames[PstPaySlip.FLD_PERIOD_ID]
                    + " = " + periodId;

            //System.out.println("sql getEmpSlip: " + sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                Employee employee = new Employee();
                employee.setOID(rs.getLong(1));
                employee.setEmployeeNum(rs.getString(2));
                employee.setFullName(rs.getString(3));
                employee.setCompanyId(rs.getLong(PstEmployee.fieldNames[PstEmployee.FLD_COMPANY_ID]));
                employee.setEmailAddress(rs.getString(PstEmployee.fieldNames[PstEmployee.FLD_EMAIL_ADDRESS]));
                employee.setBirthDate(rs.getDate(PstEmployee.fieldNames[PstEmployee.FLD_BIRTH_DATE]));
                result.add(employee);
                PaySlip paySlip = new PaySlip();
                paySlip.setStatus(rs.getInt(4));
                paySlip.setPaidStatus(rs.getInt(5));
                paySlip.setDivision(rs.getString(6));
                paySlip.setDepartment(rs.getString(7));
                paySlip.setPosition(rs.getString(8));
                paySlip.setSection(rs.getString(9));
                paySlip.setCommencDate(rs.getDate(10));
                paySlip.setDayPresent(rs.getDouble(11));
                paySlip.setDayPaidLv(rs.getDouble(12));
                paySlip.setDayAbsent(rs.getDouble(13));
                paySlip.setDayUnpaidLv(rs.getDouble(14));
                paySlip.setDayLate(rs.getDouble(15));
                paySlip.setNote(rs.getString(16));
                paySlip.setGradeCode(rs.getString(20));
                result.add(paySlip);
            }
            rs.close();
        } catch (Exception e) {
            System.out.println("err : " + e.toString());
        } finally {
            DBResultSet.close(dbrs);
            return result;
        }
    }

    /*
     *  This method used to update working day in pay slip 
     *  Created By Yunny
     */
    public static void updateWorkingDay(PayInput payInput, int statusApprove) {
        //double dateOkWithLeave,double insentif,double dayOffOT,double dayOffSchedule,double ovIdxAdjsment,String privateNote) {
        //System.out.println("nilai day present" + dayPresent);
        DBResultSet dbrs = null;
        if (payInput != null) {
            try {
                double dayPaidLv = payInput.getAlTime() + payInput.getLlTime() + payInput.getDpTime();
                String sql = "";
                sql = " UPDATE " + TBL_PAY_SLIP + " SET "
                        + PstPaySlip.fieldNames[PstPaySlip.FLD_DAY_PRESENT] + " =  " + payInput.getPresenceOntimeTime() + ","
                        + PstPaySlip.fieldNames[PstPaySlip.FLD_DAY_PAID_LV] + " =  " + dayPaidLv + ","
                        + PstPaySlip.fieldNames[PstPaySlip.FLD_DAY_ABSENT] + " =  " + payInput.getAbsenceIdx() + ","
                        + PstPaySlip.fieldNames[PstPaySlip.FLD_DAY_UNPAID_LV] + " =  " + payInput.getUnPaidLeave() + ","
                        + PstPaySlip.fieldNames[PstPaySlip.FLD_DAY_LATE] + " =  " + payInput.getLateIdx() + ","
                        + PstPaySlip.fieldNames[PstPaySlip.FLD_STATUS] + " =  " + statusApprove + ","
                        + PstPaySlip.fieldNames[PstPaySlip.FLD_PROCENTASE_PRESENCE] + " =  " + payInput.getProsentaseOK() + ","
                        //update by satrya 2013-02-20
                        + PstPaySlip.fieldNames[PstPaySlip.FLD_DATE_OK_WITH_LEAVE] + " =  " + /*dateOkWithLeave*/ 0 + ","
                        + PstPaySlip.fieldNames[PstPaySlip.FLD_INSENTIF] + " =  " + payInput.getInsentif() + ","
                        + PstPaySlip.fieldNames[PstPaySlip.FLD_TOTAL_DAY_OFF_OVERTIME] + " =  " + 0/*dayOffOT*/ + ","
                        + PstPaySlip.fieldNames[PstPaySlip.FLD_DAY_OFF_SCHEDULE] + " =  " + payInput.getDayOffSchedule() + ","
                        //update by satrya 2013-05-06
                        + PstPaySlip.fieldNames[PstPaySlip.FLD_OV_IDX_ADJUSTMENT] + " =  " + payInput.getOtIdxPaidSalaryAdjust() + ","
                        //update by satrya 2014-02-06
                        + PstPaySlip.fieldNames[PstPaySlip.FLD_OVERTIME_IDX] + " =  " + payInput.getOtIdxPaidSalary() + ","
                        + PstPaySlip.fieldNames[PstPaySlip.FLD_MEAL_ALLOWANCE_MONEY] + " =  " + payInput.getOtAllowanceMoney() + ","
                        + PstPaySlip.fieldNames[PstPaySlip.FLD_MEAL_ALLOWANCE_MONEY_ADJUSMENT] + " =  " + payInput.getOtAllowanceMoneyAdjust() + ","
                        + PstPaySlip.fieldNames[PstPaySlip.FLD_PRIVATE_NOTE] + " =  \"" + payInput.getPrivateNote() + "\""
                        + " WHERE " + PstPaySlip.fieldNames[PstPaySlip.FLD_EMPLOYEE_ID] + " = " + payInput.getEmployeeId()
                        + " AND " + PstPaySlip.fieldNames[PstPaySlip.FLD_PERIOD_ID] + " = " + payInput.getPeriodId();

                int status = DBHandler.execUpdate(sql);
                //System.out.println("\tupdateWorking Day : " + sql);
            } catch (Exception e) {
                System.err.println("\tupdateWorking error : " + e.toString());
            } finally {
                DBResultSet.close(dbrs);
                //return result;
            }
        }

    }

    /*
     *  This method used to update working day in pay slip 
     *  Created By Satrya Ramayu
     */
    public static void updateWorkingDay(String employeeId, long periodId, int statusApprove) {
        //double dateOkWithLeave,double insentif,double dayOffOT,double dayOffSchedule,double ovIdxAdjsment,String privateNote) {
        //System.out.println("nilai day present" + dayPresent);
        DBResultSet dbrs = null;
        if (employeeId != null && employeeId.length() > 0 && periodId != 0) {
            try {

                String sql = "";
                sql = " UPDATE " + TBL_PAY_SLIP + " SET "
                        + PstPaySlip.fieldNames[PstPaySlip.FLD_STATUS] + " =  " + statusApprove
                        + " WHERE " + PstPaySlip.fieldNames[PstPaySlip.FLD_EMPLOYEE_ID] + " IN(" + employeeId + ")"
                        + " AND " + PstPaySlip.fieldNames[PstPaySlip.FLD_PERIOD_ID] + " = " + periodId;

                int status = DBHandler.execUpdate(sql);
                //System.out.println("\tupdateWorking Day : " + sql);
            } catch (Exception e) {
                System.err.println("\tupdateWorking error : " + e.toString());
            } finally {
                DBResultSet.close(dbrs);
                //return result;
            }
        }

    }

    /**
     * khusus ot karena di beberapa bagian sdh ada di tb pay input
     *
     * @param payInput
     */
    public static void updateWorkingDayPaiSalarydAjusment(PayInput payInput) {
        //double dateOkWithLeave,double insentif,double dayOffOT,double dayOffSchedule,double ovIdxAdjsment,String privateNote) {
        //System.out.println("nilai day present" + dayPresent);
        DBResultSet dbrs = null;
        if (payInput != null && payInput.getOtIdxPaidSalaryAdjustDt() != null) {
            try {
                String sql = "";
                sql = " UPDATE " + TBL_PAY_SLIP + " SET "
                        + PstPaySlip.fieldNames[PstPaySlip.FLD_OV_IDX_ADJUSTMENT] + " =  " + payInput.getOtIdxPaidSalaryAdjust()
                        + "," + PstPaySlip.fieldNames[PstPaySlip.FLD_OV_IDX_PAID_SALARY_ADJUSMENT_DATE] + " =\"" + Formater.formatDate(payInput.getOtIdxPaidSalaryAdjustDt(), "yyyy-MM-dd HH:mm") + "\""
                        + " WHERE " + PstPaySlip.fieldNames[PstPaySlip.FLD_EMPLOYEE_ID] + " = " + payInput.getEmployeeId()
                        + " AND " + PstPaySlip.fieldNames[PstPaySlip.FLD_PERIOD_ID] + " = " + payInput.getPeriodId();

                int status = DBHandler.execUpdate(sql);
                //System.out.println("\tupdateWorking Day : " + sql);
            } catch (Exception e) {
                System.err.println("\tupdateWorking error : " + e.toString());
            } finally {
                DBResultSet.close(dbrs);
                //return result;
            }
        }

    }

    public static void updateWorkingDayAllowanceAjusment(PayInput payInput) {
        //double dateOkWithLeave,double insentif,double dayOffOT,double dayOffSchedule,double ovIdxAdjsment,String privateNote) {
        //System.out.println("nilai day present" + dayPresent);
        DBResultSet dbrs = null;
        if (payInput != null && payInput.getOtAllowanceMoneyAdjust() > 0 && payInput.getOtAllowanceMoneyAdjustDt() != null) {
            try {
                String sql = "";
                sql = " UPDATE " + TBL_PAY_SLIP + " SET "
                        + PstPaySlip.fieldNames[PstPaySlip.FLD_MEAL_ALLOWANCE_MONEY_ADJUSMENT] + " =  " + payInput.getOtAllowanceMoneyAdjust()
                        + "," + PstPaySlip.fieldNames[PstPaySlip.FLD_OV_MEAL_ALLOWANCE_MONEY_ADJ_DATE] + " =\"" + Formater.formatDate(payInput.getOtAllowanceMoneyAdjustDt(), "yyyy-MM-dd HH:mm") + "\""
                        + " WHERE " + PstPaySlip.fieldNames[PstPaySlip.FLD_EMPLOYEE_ID] + " = " + payInput.getEmployeeId()
                        + " AND " + PstPaySlip.fieldNames[PstPaySlip.FLD_PERIOD_ID] + " = " + payInput.getPeriodId();

                int status = DBHandler.execUpdate(sql);
                //System.out.println("\tupdateWorking Day : " + sql);
            } catch (Exception e) {
                System.err.println("\tupdateWorking error : " + e.toString());
            } finally {
                DBResultSet.close(dbrs);
                //return result;
            }
        }

    }
    /*
     *  This method used to update working day in pay slip 
     *  Created By Yunny
     */

    public static void updateNote(long employeeId, long periodId, String note) {

        DBResultSet dbrs = null;
        try {
            String sql = "";
            sql = " UPDATE " + TBL_PAY_SLIP + " SET "
                    + PstPaySlip.fieldNames[PstPaySlip.FLD_NOTE] + " =  '" + note + "'"
                    + " WHERE " + PstPaySlip.fieldNames[PstPaySlip.FLD_EMPLOYEE_ID] + " = " + employeeId
                    + " AND " + PstPaySlip.fieldNames[PstPaySlip.FLD_PERIOD_ID] + " = " + periodId;

            int status = DBHandler.execUpdate(sql);
            System.out.println("\tupdateNote : " + sql);
        } catch (Exception e) {
            System.err.println("\tupdateNote : " + e.toString());
        } finally {
            DBResultSet.close(dbrs);
            //return result;
        }
    }

    /**
     * This method used to update note for all note of payroll slip in period
     * Created By Kartika 16 Okt 2012
     *
     * @param periodId
     * @param noteToAll
     * @param allLeftSeparator : seperator between personal note and all note :
     * e.g. Personal Note // All Note, system will replace the right sign of the
     * note
     */
    public static void updateNote(long periodId, String noteToAll, String allLeftSeparator, String allLeftSeparatorNew, String employeeId) {

        DBResultSet dbrs = null;
        try {
            if (employeeId != null && employeeId.length() > 0) {

                String sql = "";
                sql = " UPDATE " + TBL_PAY_SLIP + " SET "
                        + PstPaySlip.fieldNames[PstPaySlip.FLD_NOTE]
                        + " = CONCAT(SUBSTRING_INDEX(" + PstPaySlip.fieldNames[PstPaySlip.FLD_NOTE] + ", \"" + allLeftSeparator + "\",1) , \""
                        + (allLeftSeparatorNew + " " + noteToAll) + "\") "
                        + " WHERE "
                        + PstPaySlip.fieldNames[PstPaySlip.FLD_PERIOD_ID] + " = " + periodId
                        + " AND " + PstPaySlip.fieldNames[PstPaySlip.FLD_EMPLOYEE_ID] + " IN(" + employeeId + ")";

                //System.out.println("\tupdateNote : " + sql);
                int status = DBHandler.execUpdate(sql);
            }
        } catch (Exception e) {
            System.err.println("\tupdateNote : " + e.toString());
        } finally {
            DBResultSet.close(dbrs);
            //return result;
        }
    }

    /* This method used to gen sum of employee's salary
     * @ param : employee_id
     * @ param : period_id
     * Created by Yunny
     */
    public static double getSumSalary(long oidPeriod, long employee_id) {
        DBResultSet dbrs = null;
        double sumSalary = 0;
        try {
            String sql = "SELECT SUM(COMP." + PstPaySlipComp.fieldNames[PstPaySlipComp.FLD_COMP_VALUE] + ") FROM "
                    + PstPaySlip.TBL_PAY_SLIP + " AS SLIP"
                    + " INNER JOIN " + PstPaySlipComp.TBL_PAY_SLIP_COMP + " AS COMP "
                    + " ON SLIP." + PstPaySlip.fieldNames[PstPaySlip.FLD_PAY_SLIP_ID]
                    + " = COMP." + PstPaySlipComp.fieldNames[PstPaySlipComp.FLD_PAY_SLIP_ID]
                    + " INNER JOIN " + PstPayComponent.TBL_PAY_COMPONENT + " AS PAY"
                    + " ON COMP." + PstPaySlipComp.fieldNames[PstPaySlipComp.FLD_COMP_CODE]
                    + " = PAY." + PstPayComponent.fieldNames[PstPayComponent.FLD_COMP_CODE]
                    + " WHERE SLIP." + PstPaySlip.fieldNames[PstPaySlip.FLD_PERIOD_ID]
                    + " = " + oidPeriod
                    + " AND SLIP." + PstPaySlip.fieldNames[PstPaySlip.FLD_EMPLOYEE_ID]
                    + " = " + employee_id
                    + " AND PAY." + PstPayComponent.fieldNames[PstPayComponent.FLD_COMP_TYPE]
                    + " = " + PstPayComponent.TYPE_BENEFIT
                    + " AND " + PstPayComponent.fieldNames[PstPayComponent.FLD_TAX_ITEM]
                    + " IN (" + PstPayComponent.GAJI + "," + PstPayComponent.TUNJANGAN + "," + PstPayComponent.BONUS_THR + ")";
            //System.out.println("SQL getSumSalary" + sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                sumSalary = rs.getDouble(1);
            }
            rs.close();
            return sumSalary;
        } catch (Exception e) {
            return 0;
        } finally {
            DBResultSet.close(dbrs);
        }
    }

    /* This method used to gen NPWP of employee's 
     * @ param : employee_id
     * @ param : period_id
     * Created by priska 20150418
     */
    public static double getNPWP(long employeeId) {
        double NPWP = 0;
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT " + PstEmployee.fieldNames[PstEmployee.FLD_NPWP]
                    + " FROM " + PstEmployee.TBL_HR_EMPLOYEE
                    + " WHERE " + PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID] + " = " + employeeId;

            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                NPWP = rs.getDouble(1);
            }

            rs.close();

        } catch (Exception e) {
            return 0;
        } finally {
            DBResultSet.close(dbrs);
            return NPWP;
        }
    }

       /* This method used to gen NPWP of employee's 
     * @ param : employee_id
     * @ param : period_id
     * Created by priska 20150418
     */
    public static int get_LOS(Date CommencingDate) {
        int get_LOS = 0;
        DBResultSet dbrs = null;
        Date today = new Date();
        try {
            Calendar comDate = Calendar.getInstance();
            Calendar nowDate = Calendar.getInstance();
            comDate.setTime(CommencingDate);
            nowDate.setTime(today);
            get_LOS = nowDate.get(Calendar.MONTH) - comDate.get(Calendar.MONTH);
        } catch (Exception e) {
            return 0;
        } finally {
            DBResultSet.close(dbrs);
            return get_LOS;
        }
    }
    
    public static double getSumSalaryBenefit(long oidPeriod, long employee_id) {
        DBResultSet dbrs = null;
        double sumSalary = 0;
        try {
            String sql = "SELECT SUM(COMP." + PstPaySlipComp.fieldNames[PstPaySlipComp.FLD_COMP_VALUE] + ") FROM "
                    + PstPaySlip.TBL_PAY_SLIP + " AS SLIP"
                    + " INNER JOIN " + PstPaySlipComp.TBL_PAY_SLIP_COMP + " AS COMP "
                    + " ON SLIP." + PstPaySlip.fieldNames[PstPaySlip.FLD_PAY_SLIP_ID]
                    + " = COMP." + PstPaySlipComp.fieldNames[PstPaySlipComp.FLD_PAY_SLIP_ID]
                    + " INNER JOIN " + PstPayComponent.TBL_PAY_COMPONENT + " AS PAY"
                    + " ON COMP." + PstPaySlipComp.fieldNames[PstPaySlipComp.FLD_COMP_CODE]
                    + " = PAY." + PstPayComponent.fieldNames[PstPayComponent.FLD_COMP_CODE]
                    + " WHERE SLIP." + PstPaySlip.fieldNames[PstPaySlip.FLD_PERIOD_ID]
                    + " = " + oidPeriod
                    + " AND SLIP." + PstPaySlip.fieldNames[PstPaySlip.FLD_EMPLOYEE_ID]
                    + " = " + employee_id
                    + " AND PAY." + PstPayComponent.fieldNames[PstPayComponent.FLD_COMP_TYPE]
                    + " = " + PstPayComponent.TYPE_BENEFIT
                    + " AND " + PstPayComponent.fieldNames[PstPayComponent.FLD_TAX_ITEM]
                    + " IN (" + PstPayComponent.GAJI + "," + PstPayComponent.TUNJANGAN + "," + PstPayComponent.BONUS_THR + ")";
            //System.out.println("SQL getSumSalary" + sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                sumSalary = rs.getDouble(1);
            }
            rs.close();
            return sumSalary;
        } catch (Exception e) {
            return 0;
        } finally {
            DBResultSet.close(dbrs);
        }
    }

    public static double getBeforePeriodeComponentValue(PayPeriod payPeriod, long employeeId,String compCode) {

        double nilai = 0;

        DBResultSet dbrs = null;

        PayPeriod payPeriodPrevious =  PstPayPeriod.getPreviousPayPeriod(payPeriod.getOID()); 
        
        try {

            String sql = " SELECT psc.`COMP_VALUE` FROM `pay_slip_comp` psc INNER JOIN `pay_slip` ps ON ps.`PAY_SLIP_ID` = psc.`PAY_SLIP_ID` ";
                   sql += " WHERE ps.`PERIOD_ID` = "+payPeriodPrevious.getOID()+" AND ps.`EMPLOYEE_ID` = "+employeeId+" AND psc.`COMP_CODE` =\""+compCode+"\"";            
  
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
              nilai = rs.getDouble(1);
            }
            return nilai;
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
            return 0;
     }
    
    public static double getSumSalaryBenefit(long oidPeriod, long employee_id, String where) {
        DBResultSet dbrs = null;
        double sumSalary = 0;
        try {
            String sql = "SELECT SUM(COMP." + PstPaySlipComp.fieldNames[PstPaySlipComp.FLD_COMP_VALUE] + ") FROM "
                    + PstPaySlip.TBL_PAY_SLIP + " AS SLIP"
                    + " INNER JOIN " + PstPaySlipComp.TBL_PAY_SLIP_COMP + " AS COMP "
                    + " ON SLIP." + PstPaySlip.fieldNames[PstPaySlip.FLD_PAY_SLIP_ID]
                    + " = COMP." + PstPaySlipComp.fieldNames[PstPaySlipComp.FLD_PAY_SLIP_ID]
                    + " INNER JOIN " + PstPayComponent.TBL_PAY_COMPONENT + " AS PAY"
                    + " ON COMP." + PstPaySlipComp.fieldNames[PstPaySlipComp.FLD_COMP_CODE]
                    + " = PAY." + PstPayComponent.fieldNames[PstPayComponent.FLD_COMP_CODE]
                    + " WHERE SLIP." + PstPaySlip.fieldNames[PstPaySlip.FLD_PERIOD_ID]
                    + " = " + oidPeriod
                    + " AND SLIP." + PstPaySlip.fieldNames[PstPaySlip.FLD_EMPLOYEE_ID]
                    + " = " + employee_id
                    + " AND PAY." + PstPayComponent.fieldNames[PstPayComponent.FLD_COMP_TYPE]
                    + " = " + PstPayComponent.TYPE_BENEFIT
                    + (where != null && where.length() > 0 ? where : "");
            //System.out.println("SQL getSumSalary" + sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                sumSalary = rs.getDouble(1);
            }
            rs.close();
            return sumSalary;
        } catch (Exception e) {
            return 0;
        } finally {
            DBResultSet.close(dbrs);
        }
    }

    public static double getSumSalaryDeduction(long oidPeriod, long employee_id) {
        DBResultSet dbrs = null;
        double sumSalary = 0;
        try {
            String sql = "SELECT SUM(COMP." + PstPaySlipComp.fieldNames[PstPaySlipComp.FLD_COMP_VALUE] + ") FROM "
                    + PstPaySlip.TBL_PAY_SLIP + " AS SLIP"
                    + " INNER JOIN " + PstPaySlipComp.TBL_PAY_SLIP_COMP + " AS COMP "
                    + " ON SLIP." + PstPaySlip.fieldNames[PstPaySlip.FLD_PAY_SLIP_ID]
                    + " = COMP." + PstPaySlipComp.fieldNames[PstPaySlipComp.FLD_PAY_SLIP_ID]
                    + " INNER JOIN " + PstPayComponent.TBL_PAY_COMPONENT + " AS PAY"
                    + " ON COMP." + PstPaySlipComp.fieldNames[PstPaySlipComp.FLD_COMP_CODE]
                    + " = PAY." + PstPayComponent.fieldNames[PstPayComponent.FLD_COMP_CODE]
                    + " WHERE SLIP." + PstPaySlip.fieldNames[PstPaySlip.FLD_PERIOD_ID]
                    + " = " + oidPeriod
                    + " AND SLIP." + PstPaySlip.fieldNames[PstPaySlip.FLD_EMPLOYEE_ID]
                    + " = " + employee_id
                    + " AND PAY." + PstPayComponent.fieldNames[PstPayComponent.FLD_COMP_TYPE]
                    + " = " + PstPayComponent.TYPE_DEDUCTION
                    + " AND " + PstPayComponent.fieldNames[PstPayComponent.FLD_TAX_ITEM]
                    + " IN (" + PstPayComponent.GAJI + "," + PstPayComponent.TUNJANGAN + "," + PstPayComponent.BONUS_THR + ")";
            //System.out.println("SQL getSumSalary" + sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                sumSalary = rs.getDouble(1);
            }
            rs.close();
            return sumSalary;
        } catch (Exception e) {
            return 0;
        } finally {
            DBResultSet.close(dbrs);
        }
    }

    public static double getSumSalaryDeduction(long oidPeriod, long employee_id, String where) {
        DBResultSet dbrs = null;
        double sumSalary = 0;
        try {
            String sql = "SELECT SUM(COMP." + PstPaySlipComp.fieldNames[PstPaySlipComp.FLD_COMP_VALUE] + ") FROM "
                    + PstPaySlip.TBL_PAY_SLIP + " AS SLIP"
                    + " INNER JOIN " + PstPaySlipComp.TBL_PAY_SLIP_COMP + " AS COMP "
                    + " ON SLIP." + PstPaySlip.fieldNames[PstPaySlip.FLD_PAY_SLIP_ID]
                    + " = COMP." + PstPaySlipComp.fieldNames[PstPaySlipComp.FLD_PAY_SLIP_ID]
                    + " INNER JOIN " + PstPayComponent.TBL_PAY_COMPONENT + " AS PAY"
                    + " ON COMP." + PstPaySlipComp.fieldNames[PstPaySlipComp.FLD_COMP_CODE]
                    + " = PAY." + PstPayComponent.fieldNames[PstPayComponent.FLD_COMP_CODE]
                    + " WHERE SLIP." + PstPaySlip.fieldNames[PstPaySlip.FLD_PERIOD_ID]
                    + " = " + oidPeriod
                    + " AND SLIP." + PstPaySlip.fieldNames[PstPaySlip.FLD_EMPLOYEE_ID]
                    + " = " + employee_id
                    + " AND PAY." + PstPayComponent.fieldNames[PstPayComponent.FLD_COMP_TYPE]
                    + " = " + PstPayComponent.TYPE_DEDUCTION
                    + (where != null && where.length() > 0 ? where : "");
            //System.out.println("SQL getSumSalary" + sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                sumSalary = rs.getDouble(1);
            }
            rs.close();
            return sumSalary;
        } catch (Exception e) {
            return 0;
        } finally {
            DBResultSet.close(dbrs);
        }
    }

    public static double getSumSalaryTotal(long oidPeriod, long employee_id) {
        return getSumSalaryBenefit(oidPeriod, employee_id) - getSumSalaryDeduction(oidPeriod, employee_id);
    }

    /**
     * mencari payslip berdasarkan period yg ada create by satrya 2013-08-18
     *
     * @param currentPeriodId
     * @return
     */
    public static Hashtable getOidPayslipByPeriod(long selectedPeriod) {
        Hashtable lists = new Hashtable();
        if (selectedPeriod == 0) {
            return lists;
        }
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT * FROM " + TBL_PAY_SLIP;
            sql = sql + " WHERE " + PstPaySlip.fieldNames[PstPaySlip.FLD_PERIOD_ID] + "=" + selectedPeriod;

            dbrs = DBHandler.execQueryResult(sql);
            //System.out.println("SQL LIST Pay Slip"+sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                PaySlip paySlip = new PaySlip();
                resultToObject(rs, paySlip);
                lists.put(paySlip.getEmployeeId(), paySlip);
            }
            rs.close();
            return lists;

        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
            return lists;
        }

    }
/*
    public double getValuemapping(String fromdate, String todate, String employeeId, String salaryComp) {
        DBResultSet dbrs = null;
        double nilai = 0;
        String test = "";
        Employee employee = new Employee();
        try {
            employee = PstEmployee.fetchExc(Long.valueOf(employeeId));
        } catch (Exception e) {
        }
        try {
            String sql = " SELECT * FROM " + PstValue_Mapping.TBL_VALUE_MAPPING + " WHERE "
                    + PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_COMP_CODE] + " = \"" + salaryComp + "\" "
                    + " AND ((" + PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_END_DATE]
                    + " >= \"" + fromdate+" 00:00:00" + "\") OR (END_DATE = \"0000-00-00  00:00:00\")  OR ( END_DATE IS NULL ) )";
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            int count = 0;
            while (rs.next()) {
                // Employee employee = PstEmployee.fetchExc(employeeId);

                long VmCompanyId = rs.getLong(PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_COMPANY_ID]);
                long VmDivisionId = rs.getLong(PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_DIVISION_ID]);
                long VmDepartmentId = rs.getLong(PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_DEPARTMENT_ID]);
                long VmSectionId = rs.getLong(PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_SECTION_ID]);
                long VmLevelId = rs.getLong(PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_LEVEL_ID]);
                long VmMaritalId = rs.getLong(PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_MARITAL_ID]);
                double VmLengthOfService = rs.getDouble(PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_LENGTH_OF_SERVICE]);
                long VmEmpCategoryId = rs.getLong(PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_EMPLOYEE_CATEGORY]);
                long VmPositionId = rs.getLong(PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_POSITION_ID]);
                long VmEmployeeId = rs.getLong(PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_EMPLOYEE_ID]);
                double VmValue = rs.getDouble(PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_VALUE]);
                long VmGradeId = rs.getLong(PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_GRADE]);
                int VmSex = rs.getInt(PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_SEX]);

                java.util.Date today = new java.util.Date();
                boolean nilaitf = true;

                if ((VmCompanyId != 0) && (VmCompanyId > 0)) {
                    if (VmCompanyId != employee.getCompanyId()) {
                        nilaitf = false;
                    } else {
                        setFieldKey(PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_COMPANY_ID]);
                        setValueKey(""+VmCompanyId);
                    }
                }

                if ((VmDivisionId != 0) && (VmDivisionId > 0)) {
                    if (VmDivisionId != employee.getDivisionId()) {
                        nilaitf = false;
                    } else {
                        setFieldKey(PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_DIVISION_ID]);
                        setValueKey(""+VmDivisionId);
                    }
                }
                if ((VmDepartmentId != 0) && (VmDepartmentId > 0)) {
                    if (VmDepartmentId != employee.getDepartmentId()) {
                        nilaitf = false;
                    } else {
                        setFieldKey(PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_DEPARTMENT_ID]);
                        setValueKey(""+VmDepartmentId);
                    }
                }
                if ((VmSectionId != 0) && (VmSectionId > 0)) {
                    if (VmSectionId != employee.getSectionId()) {
                        nilaitf = false;
                    } else {
                        setFieldKey(PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_SECTION_ID]);
                        setValueKey(""+VmSectionId);
                    }
                }
                if ((VmPositionId != 0) && (VmPositionId > 0)) {
                    if (VmPositionId != employee.getPositionId()) {
                        nilaitf = false;
                    } else {
                        setFieldKey(PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_POSITION_ID]);
                        setValueKey(""+VmPositionId);
                    }
                }
                if ((VmGradeId != 0) && (VmGradeId > 0)) {
                    if (VmGradeId != employee.getGradeLevelId()) {
                        nilaitf = false;
                    } else {
                        setFieldKey(PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_GRADE]);
                        setValueKey(""+VmGradeId);
                    }
                }
                if ((VmEmpCategoryId != 0) && (VmEmpCategoryId > 0)) {
                    if (VmEmpCategoryId != employee.getEmpCategoryId()) {
                        nilaitf = false;
                    } else {
                        setFieldKey(PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_EMPLOYEE_CATEGORY]);
                        setValueKey(""+VmEmpCategoryId);
                    }
                }
                if ((VmLevelId != 0) && (VmLevelId > 0)) {
                    if (VmLevelId != employee.getLevelId()) {
                        nilaitf = false;
                    } else {
                        setFieldKey(PstValue_Mapping.fieldNames[PstValue_Mapping.FLD_LEVEL_ID]);
                        setValueKey(""+VmLevelId);
                    }
                }
                if ((VmMaritalId != 0) && (VmMaritalId > 0)) {
                    if (VmMaritalId != employee.getMaritalId()) {
                        nilaitf = false;
                    }
                }
                if ((VmEmployeeId != 0) && (VmEmployeeId > 0)) {
                    if (VmEmployeeId != employee.getOID()) {
                        nilaitf = false;
                    }
                }

                if ((VmSex != -1) && (VmSex > -1)) {
                    if (VmSex != employee.getSex()) {
                        nilaitf = false;
                    }
                }


                if ((VmLengthOfService != 0) && (VmLengthOfService > 0)) {
                    double diff = today.getTime() - employee.getCommencingDate().getTime();
                    double yeardiff = diff / (1000 * 60 * 60 * 24 * 365);
                    if ((yeardiff != VmLengthOfService) || (yeardiff < VmLengthOfService)) {
                        nilaitf = false;
                    }
                }

                if (nilaitf) {
                    nilai = VmValue;
                }                
            }
            //rs.close();
            return nilai;
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return 0;
    }
*/
     public static String getDocumentComponent(Date fromdate, Date todate, long employeeId) {
        DBResultSet dbrs = null;
        String component = " ";
        Employee employee = new Employee();
        try {
            employee = PstEmployee.fetchExc(employeeId);
        } catch (Exception e) {}
        try {
            String sql = " SELECT `hedlm`."+PstEmpDocListMutation.fieldNames[PstEmpDocListMutation.FLD_PAY_COMPONENT]+" FROM " + PstEmpDocListMutation.TBL_EMP_DOC_LIST_MUTATION + " hedlm"
                    + " INNER JOIN "+PstEmpDoc.TBL_HR_EMP_DOC+" hed "
                    + " ON ( hed."+PstEmpDoc.fieldNames[PstEmpDoc.FLD_EMP_DOC_ID] +" = hedlm."+ PstEmpDocListMutation.fieldNames[PstEmpDocListMutation.FLD_EMP_DOC_ID] +" )" 
                    + " WHERE "
                    + " ("
                    + " ( hedlm." + PstEmpDocListMutation.fieldNames[PstEmpDocListMutation.FLD_WORK_FROM]
                    + " BETWEEN \"" + Formater.formatDate(fromdate, "yyyy-MM-dd  00:00:00") + "\" AND \"" + Formater.formatDate(todate, "yyyy-MM-dd  00:00:00") + "\" ) "
                    + " OR "
                    + " ( hedlm." + PstEmpDocListMutation.fieldNames[PstEmpDocListMutation.FLD_WORK_TO]
                    + " BETWEEN \"" + Formater.formatDate(fromdate, "yyyy-MM-dd  00:00:00") + "\" AND \"" + Formater.formatDate(todate, "yyyy-MM-dd  00:00:00") + "\" ) "
                    + " OR "
                    + " ( \"" + Formater.formatDate(fromdate, "yyyy-MM-dd  00:00:00") + "\" " 
                    + " BETWEEN hedlm." + PstEmpDocListMutation.fieldNames[PstEmpDocListMutation.FLD_WORK_FROM] + " AND  hedlm." + PstEmpDocListMutation.fieldNames[PstEmpDocListMutation.FLD_WORK_TO] + " ) "
                    + " OR "
                    + " ( \"" + Formater.formatDate(todate, "yyyy-MM-dd  00:00:00") + "\" " 
                    + " BETWEEN hedlm." + PstEmpDocListMutation.fieldNames[PstEmpDocListMutation.FLD_WORK_FROM] + " AND  hedlm." + PstEmpDocListMutation.fieldNames[PstEmpDocListMutation.FLD_WORK_TO] + " ) "
                    + " )"
                    + " AND "
                    + " (`hedlm`." + PstEmpDocListMutation.fieldNames[PstEmpDocListMutation.FLD_PAY_COMPONENT] + " IS NOT NULL OR `hedlm`." + PstEmpDocListMutation.fieldNames[PstEmpDocListMutation.FLD_PAY_COMPONENT] + " != \"\" ) "
                    + " AND `hedlm`.`EMPLOYEE_ID` = "+employeeId+""
                    + " ";
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            int count = 0;
            while (rs.next()) {
               
                component += rs.getString(PstEmpDocListMutation.fieldNames[PstEmpDocListMutation.FLD_PAY_COMPONENT])+" +";
                
            }
            //rs.close();
            component = component.substring(0,component.length()-1);
            return component;
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return component;
    }
     
    public static double getDocumentValue(Date fromdate, Date todate, long employeeId, long componentId) {
        DBResultSet dbrs = null;
        double component = 0;
        Employee employee = new Employee();
        try {
            employee = PstEmployee.fetchExc(employeeId);
        } catch (Exception e) {}
        try {
            String sql = " SELECT (`hedle`.COMP_VALUE * `hedle`.DAY_LENGTH) AS COMP_VALUE"
                    + " FROM hr_emp_doc_list_expense hedle "
                    + " INNER JOIN hr_emp_doc hed  ON (hed.EMP_DOC_ID = hedle.EMP_DOC_ID) "
                    + " WHERE "
                    + " ("
                    + "  hed.`DATE_OF_ISSUE` "
                    + " BETWEEN \"" + Formater.formatDate(fromdate, "yyyy-MM-dd  00:00:00") + "\" AND \"" + Formater.formatDate(todate, "yyyy-MM-dd  00:00:00") + "\" ) "
                    + " AND "
                    + " (`hedle`.COMPONENT_ID = "+componentId+" ) "
                    + " AND `hedle`.`EMPLOYEE_ID` = "+employeeId+""
                    + " ";
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            int count = 0;
            while (rs.next()) {
               
                component += rs.getDouble("COMP_VALUE");
                
            }
            //rs.close();
            return component;
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return component;
    }
	
	public static double getSumDocumentValueByObjectName(Date fromdate, Date todate, long employeeId, String objectName) {
        DBResultSet dbrs = null;
        double component = 0;
        Employee employee = new Employee();
        try {
            employee = PstEmployee.fetchExc(employeeId);
        } catch (Exception e) {}
        try {
            String sql = " SELECT SUM(COMP_VALUE) AS COMP_VALUE"
                    + " FROM hr_emp_doc_list_expense hedle "
                    + " INNER JOIN hr_emp_doc hed  ON (hed.EMP_DOC_ID = hedle.EMP_DOC_ID) "
                    + " WHERE "
                    + " ("
                    + "  hed.`DATE_OF_ISSUE` "
                    + " BETWEEN \"" + Formater.formatDate(fromdate, "yyyy-MM-dd  00:00:00") + "\" AND \"" + Formater.formatDate(todate, "yyyy-MM-dd  00:00:00") + "\" ) "
                    + " AND "
                    + " (`hedle`.OBJECT_NAME = '"+objectName+"' ) "
                    + " AND `hedle`.`EMPLOYEE_ID` = "+employeeId+""
                    + " ";
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            int count = 0;
            while (rs.next()) {
               
                component += rs.getDouble("COMP_VALUE");
                
            }
            //rs.close();
            return component;
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return component;
    }
    
     
     public static boolean getReadyDocComponent(Date fromdate, Date todate, long employeeId, String compCode) {
        DBResultSet dbrs = null;
        boolean component = false;
        Employee employee = new Employee();
        try {
            employee = PstEmployee.fetchExc(employeeId);
        } catch (Exception e) {}
        try {
            String sql = " SELECT `hedlm`."+PstEmpDocListMutation.fieldNames[PstEmpDocListMutation.FLD_PAY_COMPONENT]+" FROM " + PstEmpDocListMutation.TBL_EMP_DOC_LIST_MUTATION + " hedlm"
                    + " INNER JOIN "+PstEmpDoc.TBL_HR_EMP_DOC+" hed "
                    + " ON ( hed."+PstEmpDoc.fieldNames[PstEmpDoc.FLD_EMP_DOC_ID] +" = hedlm."+ PstEmpDocListMutation.fieldNames[PstEmpDocListMutation.FLD_EMP_DOC_ID] +" )" 
                    + " WHERE "
                    + " ("
                    + " ( hedlm." + PstEmpDocListMutation.fieldNames[PstEmpDocListMutation.FLD_WORK_FROM]
                    + " BETWEEN \"" + Formater.formatDate(fromdate, "yyyy-MM-dd  00:00:00") + "\" AND \"" + Formater.formatDate(todate, "yyyy-MM-dd  00:00:00") + "\" ) "
                    + " OR "
                    + " ( hedlm." + PstEmpDocListMutation.fieldNames[PstEmpDocListMutation.FLD_WORK_TO]
                    + " BETWEEN \"" + Formater.formatDate(fromdate, "yyyy-MM-dd  00:00:00") + "\" AND \"" + Formater.formatDate(todate, "yyyy-MM-dd  00:00:00") + "\" ) "
                    + " OR "
                    + " ( \"" + Formater.formatDate(fromdate, "yyyy-MM-dd  00:00:00") + "\" " 
                    + " BETWEEN hedlm." + PstEmpDocListMutation.fieldNames[PstEmpDocListMutation.FLD_WORK_FROM] + " AND  hedlm." + PstEmpDocListMutation.fieldNames[PstEmpDocListMutation.FLD_WORK_TO] + " ) "
                    + " OR "
                    + " ( \"" + Formater.formatDate(todate, "yyyy-MM-dd  00:00:00") + "\" " 
                    + " BETWEEN hedlm." + PstEmpDocListMutation.fieldNames[PstEmpDocListMutation.FLD_WORK_FROM] + " AND  hedlm." + PstEmpDocListMutation.fieldNames[PstEmpDocListMutation.FLD_WORK_TO] + " ) "
                    + " )"
                    + " AND "
                    + " (`hedlm`." + PstEmpDocListMutation.fieldNames[PstEmpDocListMutation.FLD_PAY_COMPONENT] + " IS NOT NULL OR `hedlm`." + PstEmpDocListMutation.fieldNames[PstEmpDocListMutation.FLD_PAY_COMPONENT] + " != \"\" ) "
                    + " AND `hedlm`.`EMPLOYEE_ID` = "+employeeId+""
                    + " AND "+PstEmpDocListMutation.fieldNames[PstEmpDocListMutation.FLD_PAY_COMPONENT]+" LIKE \"%"+compCode+"%\"";
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            int count = 0;
            while (rs.next()) {
               
                component = true;
                
            }
            return component;
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return component;
    }
    
    public static long getDayDocComponent(Date fromdate, Date todate, long employeeId, String compCode) {
        DBResultSet dbrs = null;
        long componentDay = 0;
        Employee employee = new Employee();
        try {
            employee = PstEmployee.fetchExc(employeeId);
        } catch (Exception e) {}
        try {
            String sql = " SELECT `hedlm`."+PstEmpDocListMutation.fieldNames[PstEmpDocListMutation.FLD_PAY_COMPONENT]+", `hedlm`."+PstEmpDocListMutation.fieldNames[PstEmpDocListMutation.FLD_WORK_FROM]+", `hedlm`."+PstEmpDocListMutation.fieldNames[PstEmpDocListMutation.FLD_WORK_TO]+" FROM " + PstEmpDocListMutation.TBL_EMP_DOC_LIST_MUTATION + " hedlm"
                    + " INNER JOIN "+PstEmpDoc.TBL_HR_EMP_DOC+" hed "
                    + " ON ( hed."+PstEmpDoc.fieldNames[PstEmpDoc.FLD_EMP_DOC_ID] +" = hedlm."+ PstEmpDocListMutation.fieldNames[PstEmpDocListMutation.FLD_EMP_DOC_ID] +" )" 
                    + " WHERE "
                    + " ("
                    + " ( hedlm." + PstEmpDocListMutation.fieldNames[PstEmpDocListMutation.FLD_WORK_FROM]
                    + " BETWEEN \"" + Formater.formatDate(fromdate, "yyyy-MM-dd  00:00:00") + "\" AND \"" + Formater.formatDate(todate, "yyyy-MM-dd  00:00:00") + "\" ) "
                    + " OR "
                    + " ( hedlm." + PstEmpDocListMutation.fieldNames[PstEmpDocListMutation.FLD_WORK_TO]
                    + " BETWEEN \"" + Formater.formatDate(fromdate, "yyyy-MM-dd  00:00:00") + "\" AND \"" + Formater.formatDate(todate, "yyyy-MM-dd  00:00:00") + "\" ) "
                    + " OR "
                    + " ( \"" + Formater.formatDate(fromdate, "yyyy-MM-dd  00:00:00") + "\" " 
                    + " BETWEEN hedlm." + PstEmpDocListMutation.fieldNames[PstEmpDocListMutation.FLD_WORK_FROM] + " AND  hedlm." + PstEmpDocListMutation.fieldNames[PstEmpDocListMutation.FLD_WORK_TO] + " ) "
                    + " OR "
                    + " ( \"" + Formater.formatDate(todate, "yyyy-MM-dd  00:00:00") + "\" " 
                    + " BETWEEN hedlm." + PstEmpDocListMutation.fieldNames[PstEmpDocListMutation.FLD_WORK_FROM] + " AND  hedlm." + PstEmpDocListMutation.fieldNames[PstEmpDocListMutation.FLD_WORK_TO] + " ) "
                    + " )"
                    + " AND "
                    + " (`hedlm`." + PstEmpDocListMutation.fieldNames[PstEmpDocListMutation.FLD_PAY_COMPONENT] + " IS NOT NULL OR `hedlm`." + PstEmpDocListMutation.fieldNames[PstEmpDocListMutation.FLD_PAY_COMPONENT] + " != \"\" ) "
                    + " AND `hedlm`.`EMPLOYEE_ID` = "+employeeId+""
                    + " AND "+PstEmpDocListMutation.fieldNames[PstEmpDocListMutation.FLD_PAY_COMPONENT]+" LIKE \"%"+compCode+"%\"";
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                Date fromD = rs.getDate(PstEmpDocListMutation.fieldNames[PstEmpDocListMutation.FLD_WORK_FROM]);
                Date toD = rs.getDate(PstEmpDocListMutation.fieldNames[PstEmpDocListMutation.FLD_WORK_TO]);
                
                long nilaiX = DateCalc.dayDifference(fromD, toD)+1;
                componentDay = componentDay+nilaiX;
                
            }
            return componentDay;
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return componentDay;
    }
    /**
     * Menghitung jumlah gaji real yang termasuk objeck pajak : Benefit ( DPP )
     * - Deduction (DPP) , diluar benefit dan potongan yang tidak masuk object
     * pajak
     *
     * @param oidPeriod
     * @param employee_id
     * @return
     */
    public static double getSumSalaryOfPeriod(long oidPeriod, long employee_id, String where) {
        double totalSal = 0;
        try {
            if (oidPeriod != 0) {
                PayPeriod tmpPayPeriod = PstPayPeriod.fetchExc(oidPeriod);
                //Period tmpPeriod = PstPeriod.fetchExc(oidPeriod);
                totalSal = totalSal + getSumSalaryBenefit(tmpPayPeriod.getOID(), employee_id, where)
                        - getSumSalaryDeduction(tmpPayPeriod.getOID(), employee_id, where);
            }
        } catch (Exception exc) {
            System.out.println("Exception getSumSalaryOfPeriod" + exc);
        }

        return totalSal;
    }

    /*public static double getSalaryOfPeriod(long oidPeriod, long employee_id){
     double totalSal= 0;
     try{            
     Period tmpPeriod = PstPeriod.fetchExc(oidPeriod);
     totalSal= totalSal + getSumSalaryBenefit(tmpPeriod.getOID(), employee_id)
     - getSumSalaryDeduction(tmpPeriod.getOID(), employee_id);                        
     }catch(Exception exc){
        
     }    
     return totalSal;
     }*/

    /*public static double getSumSalaryYearToPeriod(long oidPeriod, long employee_id){
     double totalSal= 0;
     try{            
     Vector periodList = getYearPeriodListToThisPeriod(oidPeriod);
     if(periodList!=null){
     for(int idx=0;idx< periodList.size();idx++){
     Period tmpPeriod = (Period)periodList.get(idx);
     totalSal= totalSal + getSumSalaryBenefit(tmpPeriod.getOID(), employee_id)
     - getSumSalaryDeduction(tmpPeriod.getOID(), employee_id);                        
     }
     }
     }catch(Exception exc){
        
     }    
     return totalSal;
     }
     */
    
    public static double getSumSalaryYearPeriodToPrev(long oidPeriod, long employee_id, String where) {
        double totalSal = 0;
        try {
            Vector periodList = getYearPeriodListFromThisPeriodToPrev(oidPeriod);
            String brutoPindahanComp = TaxCalculator.getComponentWithFormula("BRUTO_TRANSFER");
            if (periodList != null) {
                for (int idx = 0; idx < periodList.size(); idx++) {
                    PayPeriod tmpPayPeriod = (PayPeriod) periodList.get(idx);
                    double pindahan = getCompValue(employee_id, tmpPayPeriod, brutoPindahanComp);
                    if (pindahan > 0){
                        totalSal = totalSal + pindahan;
                        break;
                    } else {
                    //Period tmpPeriod = (Period)periodList.get(idx);
                    totalSal = totalSal + (getSumSalaryBenefit(tmpPayPeriod.getOID(), employee_id, where)
                            - getSumSalaryDeduction(tmpPayPeriod.getOID(), employee_id, where));
                    }
                }
            }
       
        } catch (Exception exc) {
            System.out.println("Exception getSumSalaryYearToPeriod" + exc);
        }
        return totalSal;
    }
    
    public static double getSumSalaryYearToPeriod(long oidPeriod, long employee_id, String where) {
        double totalSal = 0;
        try {
            Vector periodList = getYearPeriodListToThisPeriod(oidPeriod);
            if (periodList != null) {
                for (int idx = 0; idx < periodList.size(); idx++) {
                    PayPeriod tmpPayPeriod = (PayPeriod) periodList.get(idx);
                    //Period tmpPeriod = (Period)periodList.get(idx);
                    totalSal = totalSal + (getSumSalaryBenefit(tmpPayPeriod.getOID(), employee_id, where)
                            - getSumSalaryDeduction(tmpPayPeriod.getOID(), employee_id, where));
                }
            }
       
        } catch (Exception exc) {
            System.out.println("Exception getSumSalaryYearToPeriod" + exc);
        }
        return totalSal;
    }
    
    public static double getSumSalaryYearFromToPeriod(long oidPeriodAwal, long oidPeriodAkhir, long employee_id, String where) {
        double totalSal = 0;
        try {
            Vector periodList = getYearPeriodListFromToPeriod(oidPeriodAwal, oidPeriodAkhir);
            if (periodList != null) {
                for (int idx = 0; idx < periodList.size(); idx++) {
                    PayPeriod tmpPayPeriod = (PayPeriod) periodList.get(idx);
                    //Period tmpPeriod = (Period)periodList.get(idx);
                    totalSal = totalSal + (getSumSalaryBenefit(tmpPayPeriod.getOID(), employee_id, where)
                            - getSumSalaryDeduction(tmpPayPeriod.getOID(), employee_id, where));
                }
            }
       
        } catch (Exception exc) {
            System.out.println("Exception getSumSalaryYearToPeriod" + exc);
        }
        return totalSal;
    }    

    public static double getSumSalaryDeductionYearToPeriod(long oidPeriod, long employee_id, String where) {
        double totalSal = 0;
        try {
            Vector periodList = getYearPeriodListToThisPeriod(oidPeriod);
            if (periodList != null) {
                for (int idx = 0; idx < periodList.size(); idx++) {
                    PayPeriod tmpPayPeriod = (PayPeriod) periodList.get(idx);
                    //Period tmpPeriod = (Period)periodList.get(idx);
                    totalSal = totalSal + getSumSalaryDeduction(tmpPayPeriod.getOID(), employee_id, where);
                }
            }
        } catch (Exception exc) {
            System.out.println("Exception getSumSalaryYearToPeriod" + exc);
        }
        return totalSal;
    }
    
    public static Vector getListComponentOfPeriod(long periodId, long employeeId, String where){
        Vector result = new Vector(1, 1);
        DBResultSet dbrs = null;

        try {
            String sql = "SELECT PC." + PstPayComponent.fieldNames[PstPayComponent.FLD_COMP_NAME]
                    + ", PSC." + PstPaySlipComp.fieldNames[PstPaySlipComp.FLD_COMP_VALUE]
                    + ", PC." + PstPayComponent.fieldNames[PstPayComponent.FLD_COMP_TYPE]
                    + " FROM " + PstPayComponent.TBL_PAY_COMPONENT + " AS PC "
                    + " INNER JOIN " + PstPaySlipComp.TBL_PAY_SLIP_COMP + " AS PSC "
                    + " ON PC." + PstPayComponent.fieldNames[PstPayComponent.FLD_COMP_CODE]
                    + " = PSC." + PstPaySlipComp.fieldNames[PstPaySlipComp.FLD_COMP_CODE]
                    + " INNER JOIN " + PstPaySlip.TBL_PAY_SLIP + " AS PS "
                    + " ON PSC." + PstPaySlipComp.fieldNames[PstPaySlipComp.FLD_PAY_SLIP_ID]
                    + " = PS." + PstPaySlip.fieldNames[PstPaySlip.FLD_PAY_SLIP_ID]
                    + where
                    + " AND PS." + PstPaySlip.fieldNames[PstPaySlip.FLD_PERIOD_ID]
                    + " = " + periodId
                    + " AND PS." + PstPaySlip.fieldNames[PstPaySlip.FLD_EMPLOYEE_ID]
                    + " = " + employeeId
                    + " AND PSC." + PstPaySlipComp.fieldNames[PstPaySlipComp.FLD_COMP_VALUE]
                    + " > 0 ";

            //System.out.println("sql getEmpSlip: " + sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                Vector list = new Vector();
                PayComponent payComponent = new PayComponent();
                payComponent.setCompName(rs.getString(1));
                payComponent.setCompType(rs.getInt(3));
                list.add(payComponent);
                PaySlipComp paySlipComp = new PaySlipComp();
                paySlipComp.setCompValue(rs.getDouble(2));
                list.add(paySlipComp);
                result.add(list);
            }
            rs.close();
        } catch (Exception e) {
            System.out.println("err : " + e.toString());
        } finally {
            DBResultSet.close(dbrs);
            return result;
        }
    }

    /**
     * Menghitung jumlah gaji real yang termasuk objeck pajak : Benefit ( DPP )
     * - Deduction (DPP) , diluar benefit dan potongan yang tidak masuk object
     * pajak
     *
     * @param oidPeriod
     * @param employee_id
     * @return
     */
    /**
     * public static double getSumSalaryForTaxYearToPeriod(long oidPeriod, long
     * employee_id){ double totalSal= 0; try{ Period period =
     * PstPeriod.fetchExc(oidPeriod); if(period!=null){ Date startYear = null;
     *
     * if(period.getPayProcDateClose()!=null){ // PayProcDateClose adalah yang
     * menentukan pengakuan bulan pajak startYear = new
     * Date(period.getPayProcDateClose().getYear(), 0,1); } else{ // jika tidak
     * ada PayProcDateClose maka akan diakui sebagai pajak bulan akhir periode
     * startYear = new Date(period.getEndDate().getYear(), 0,1); } String where
     * =" YEAR("+PstPeriod.fieldNames[PstPeriod.FLD_PAY_PROC_DATE_CLOSE]+") = "+
     * (startYear.getYear()+1900) + " AND " +
     * PstPeriod.fieldNames[PstPeriod.FLD_PAY_PROC_DATE_CLOSE] + "<=\"" +
     * Formater.formatDate(period.getPayProcDateClose(),"yyyy-MM-dd
     * HH:mm:ss")+"\""; String order
     * =PstPeriod.fieldNames[PstPeriod.FLD_START_DATE]; Vector periodList =
     * PstPeriod.list(0, 12, where, order); if(periodList==null ||
     * periodList.size()<1){ where ="
     * YEAR("+PstPeriod.fieldNames[PstPeriod.FLD_END_DATE]+") = "+
     * (startYear.getYear()+1900) + " AND " +
     * PstPeriod.fieldNames[PstPeriod.FLD_END_DATE] + "<=\"" +
     * Formater.formatDate(period.getEndDate(),"yyyy-MM-dd HH:mm:ss")+"\"";
     * periodList = PstPeriod.list(0, 12, where, order); }
     *
     * if(periodList!=null){ for(int idx=0;idx< periodList.size();idx++){ Period
     * tmpPeriod = (Period)periodList.get(idx); totalSal= totalSal +
     * getSumSalaryBenefit(tmpPeriod.getOID(), employee_id) -
     * getSumSalaryDeduction(tmpPeriod.getOID(), employee_id); } }
     *
     * }
     * }catch(Exception exc){
     *
     * }
     * return totalSal; }
     *
     */
    /**
     * untuk menyimpan code component salary yang menampung pajak PPH21 Prepay
     * oleh karyawan , artinya yg dipotong duluan spt pajak PPH21 atas THR yang
     * dibagikan tidak berbarengan dengan gaji dan pajak PPH21 sudah dipotongkan
     * tapi tidak di refund
     */
    public static void loadPAY_COMP_SALARY_TAX_CODE_PREPAY() {
        String sPayComp = PstSystemProperty.getValueByName("PAY_COMP_SALARY_TAX_CODE_PREPAY");
        if (sPayComp == null || sPayComp.equalsIgnoreCase(PstSystemProperty.SYS_NOT_INITIALIZED)) {
            sPayComp = "";
        }
        Vector vComp = com.dimata.util.StringParser.parseGroup(sPayComp);
        PAY_COMP_SALARY_TAX_CODE_PREPAY = new Vector();
        if (vComp != null & vComp.size() > 0) {
            for (int iv = 0; iv < vComp.size(); iv++) {
                String[] aV = (String[]) vComp.get(iv);
                if (aV.length > 0) {
                    PAY_COMP_SALARY_TAX_CODE_PREPAY.add(aV[0]);
                }
            }
        }
    }

    /**
     * created by Kartika 1 July 2015
     *
     * @param oidPeriod
     * @param employee_id
     * @return
     */
    public static double getSumTaxYearToPreviousPeriod(long oidPeriod, long employee_id) {
        double totalSal = 0;
        try {
            PayPeriod payPeriod = PstPayPeriod.getPreviousPeriod(oidPeriod);
            PayPeriod currPer = null;
               try{
                currPer=PstPayPeriod.fetchExc(oidPeriod);
                if (currPer.getFirstPeriodOfTheYear() == 1){
                    return 0;
                }
               } catch (Exception exc){}
            String compCode = "";
            try {
                compCode = PstSystemProperty.getValueByNameWithStringNull("PPH21_COMP_CODE");
            } catch (Exception exc){
                
            }
            //Period period = PstPeriod.getPreviousPeriod(oidPeriod);
            if (payPeriod != null) {
                Vector periodList = getYearPeriodListToThisPeriod(payPeriod.getOID());
                if (periodList != null) {
                    if (PAY_COMP_SALARY_TAX_CODE_PREPAY == null) {
                        loadPAY_COMP_SALARY_TAX_CODE_PREPAY();
                    }
                    for (int idx = 0; idx < periodList.size(); idx++) {
                        PayPeriod tmpPayPeriod = (PayPeriod) periodList.get(idx);
                        // Period tmpPeriod = (Period)periodList.get(idx);
                        totalSal = totalSal + getTaxSalary(tmpPayPeriod.getOID(), employee_id, compCode);
                        if (PAY_COMP_SALARY_TAX_CODE_PREPAY != null && PAY_COMP_SALARY_TAX_CODE_PREPAY.size() > 0) {
                            for (int idxP = 0; idxP < PAY_COMP_SALARY_TAX_CODE_PREPAY.size(); idxP++) {
                                totalSal = totalSal + getTaxSalary(tmpPayPeriod.getOID(), employee_id, PAY_COMP_SALARY_TAX_CODE_PREPAY.get(idxP));
                            }
                        }
                    }
                }
            }
        } catch (Exception exc) {
        }
        return totalSal;
    }

    /**
     * Calculate tax prepay yang sudah dipotongkan kan sebelumnya seperti Pajak
     * atas THR created by Kartika 23 July 2015
     *
     * @param oidPeriod
     * @param employee_id
     * @return
     */
    public static double getTaxPrepayPeriod(long oidPeriod, long employee_id) {
        double totalSal = 0;
        try {
            if (oidPeriod != 0) {
                if (PAY_COMP_SALARY_TAX_CODE_PREPAY == null || PAY_COMP_SALARY_TAX_CODE_PREPAY.size() == 0) {
                    loadPAY_COMP_SALARY_TAX_CODE_PREPAY();
                }
                if (PAY_COMP_SALARY_TAX_CODE_PREPAY != null && PAY_COMP_SALARY_TAX_CODE_PREPAY.size() > 0) {
                    for (int idxP = 0; idxP < PAY_COMP_SALARY_TAX_CODE_PREPAY.size(); idxP++) {
                        System.out.println(PAY_COMP_SALARY_TAX_CODE_PREPAY.get(idxP));
                        String aComp = PAY_COMP_SALARY_TAX_CODE_PREPAY.get(idxP);
                        totalSal = totalSal + getTaxSalary(oidPeriod, employee_id, aComp);
                    }
                }
            }
        } catch (Exception exc) {
            System.out.println("EXC >> getSumTaxYearToPreviousPeriod : " + exc);
        }
        return totalSal;
    }
    
    public static Vector<Period> getYearPeriodListFromToPeriod(long oidPeriodAwal, long oidPeriodAkhir) {
        Vector periodList = null;
        try {
            PayPeriod payPeriodAwal = PstPayPeriod.fetchExc(oidPeriodAwal);
            PayPeriod payPeriodAkhir = PstPayPeriod.fetchExc(oidPeriodAkhir);
            //Period period = PstPeriod.fetchExc(oidPeriod);
                    // jika tidak ada PayProcDateClose maka akan diakui sebagai pajak bulan akhir periode
            String where = PstPayPeriod.fieldNames[PstPayPeriod.FLD_START_DATE] + " BETWEEN '" 
                            + Formater.formatDate(payPeriodAwal.getStartDate(), "yyyy-MM-dd") +"' AND '"
                            + Formater.formatDate(payPeriodAkhir.getEndDate(), "yyyy-MM-dd") +"'";
            String order = PstPeriod.fieldNames[PstPayPeriod.FLD_START_DATE];
            periodList = PstPayPeriod.list(0, 12, where, order);
            /*
             * startYear = new Date(payPeriod.getEndDate().getYear(), 0,1);
             where =" YEAR("+PstPeriod.fieldNames[PstPeriod.FLD_END_DATE]+") = "+ (startYear.getYear()+1900) +
             " AND " + PstPeriod.fieldNames[PstPeriod.FLD_END_DATE] + "<=\"" + 
             Formater.formatDate(payPeriod.getEndDate(),"yyyy-MM-dd HH:mm:ss")+"\"";
             periodList = PstPeriod.list(0, 12, where, order);
             */

        } catch (Exception exc) {
            System.out.println(exc);
        }
        return periodList;
    }

    public static Vector<Period> getYearPeriodListToThisPeriod(long oidPeriod) {
        Vector periodList = null;
        try {
            PayPeriod payPeriod = PstPayPeriod.fetchExc(oidPeriod);
            //Period period = PstPeriod.fetchExc(oidPeriod);
            if (payPeriod != null) {
                Date startYear = null;
                String where = "";
                String order = "";
                if (payPeriod.getPayProcDateClose() != null) {
                    // PayProcDateClose adalah yang menentukan pengakuan bulan pajak             
                    startYear = new Date(payPeriod.getPayProcDateClose().getYear(), 0, 1);
                    where = " YEAR(" + PstPayPeriod.fieldNames[PstPayPeriod.FLD_PAY_PROC_DATE_CLOSE] + ") = " + (startYear.getYear() + 1900)
                            + " AND " + PstPayPeriod.fieldNames[PstPayPeriod.FLD_PAY_PROC_DATE_CLOSE] + "<=\""
                            + Formater.formatDate(payPeriod.getPayProcDateClose(), "yyyy-MM-dd HH:mm:ss") + "\"";
                    order = PstPeriod.fieldNames[PstPayPeriod.FLD_START_DATE];
                    periodList = PstPayPeriod.list(0, 12, where, order);
                    /*
                     * where =" YEAR("+PstPeriod.fieldNames[PstPeriod.FLD_PAY_PROC_DATE_CLOSE]+") = "+ (startYear.getYear()+1900) +
                     " AND " + PstPeriod.fieldNames[PstPeriod.FLD_PAY_PROC_DATE_CLOSE] + "<=\"" + 
                     Formater.formatDate(payPeriod.getPayProcDateClose(),"yyyy-MM-dd HH:mm:ss")+"\"";
                     order =PstPeriod.fieldNames[PstPeriod.FLD_START_DATE];
                     periodList = PstPeriod.list(0, 12, where, order);
                
                     */
                } else {
                    // jika tidak ada PayProcDateClose maka akan diakui sebagai pajak bulan akhir periode
                    startYear = new Date(payPeriod.getEndDate().getYear(), 0, 1);
                    where = " YEAR(" + PstPayPeriod.fieldNames[PstPayPeriod.FLD_END_DATE] + ") = " + (startYear.getYear() + 1900)
                            + " AND " + PstPayPeriod.fieldNames[PstPayPeriod.FLD_END_DATE] + "<=\""
                            + Formater.formatDate(payPeriod.getEndDate(), "yyyy-MM-dd HH:mm:ss") + "\"";
                    periodList = PstPayPeriod.list(0, 12, where, order);
                    /*
                     * startYear = new Date(payPeriod.getEndDate().getYear(), 0,1);
                     where =" YEAR("+PstPeriod.fieldNames[PstPeriod.FLD_END_DATE]+") = "+ (startYear.getYear()+1900) +
                     " AND " + PstPeriod.fieldNames[PstPeriod.FLD_END_DATE] + "<=\"" + 
                     Formater.formatDate(payPeriod.getEndDate(),"yyyy-MM-dd HH:mm:ss")+"\"";
                     periodList = PstPeriod.list(0, 12, where, order);
                     */

                }
            }
        } catch (Exception exc) {
            System.out.println(exc);
        }
        return periodList;
    }
    
    public static Vector<Period> getYearPeriodListFromThisPeriodToPrev(long oidPeriod) {
        Vector periodList = null;
        try {
            PayPeriod payPeriod = PstPayPeriod.fetchExc(oidPeriod);
            //Period period = PstPeriod.fetchExc(oidPeriod);
            if (payPeriod != null) {
                Date startYear = null;
                String where = "";
                String order = "";
                if (payPeriod.getPayProcDateClose() != null) {
                    // PayProcDateClose adalah yang menentukan pengakuan bulan pajak             
                    startYear = new Date(payPeriod.getPayProcDateClose().getYear(), 0, 1);
                    where = " YEAR(" + PstPayPeriod.fieldNames[PstPayPeriod.FLD_PAY_PROC_DATE_CLOSE] + ") = " + (startYear.getYear() + 1900)
                            + " AND " + PstPayPeriod.fieldNames[PstPayPeriod.FLD_PAY_PROC_DATE_CLOSE] + "<=\""
                            + Formater.formatDate(payPeriod.getPayProcDateClose(), "yyyy-MM-dd HH:mm:ss") + "\"";
                    order = PstPeriod.fieldNames[PstPayPeriod.FLD_START_DATE] + " DESC";
                    periodList = PstPayPeriod.list(0, 12, where, order);
                    /*
                     * where =" YEAR("+PstPeriod.fieldNames[PstPeriod.FLD_PAY_PROC_DATE_CLOSE]+") = "+ (startYear.getYear()+1900) +
                     " AND " + PstPeriod.fieldNames[PstPeriod.FLD_PAY_PROC_DATE_CLOSE] + "<=\"" + 
                     Formater.formatDate(payPeriod.getPayProcDateClose(),"yyyy-MM-dd HH:mm:ss")+"\"";
                     order =PstPeriod.fieldNames[PstPeriod.FLD_START_DATE];
                     periodList = PstPeriod.list(0, 12, where, order);
                
                     */
                } else {
                    // jika tidak ada PayProcDateClose maka akan diakui sebagai pajak bulan akhir periode
                    startYear = new Date(payPeriod.getEndDate().getYear(), 0, 1);
                    where = " YEAR(" + PstPayPeriod.fieldNames[PstPayPeriod.FLD_END_DATE] + ") = " + (startYear.getYear() + 1900)
                            + " AND " + PstPayPeriod.fieldNames[PstPayPeriod.FLD_END_DATE] + "<=\""
                            + Formater.formatDate(payPeriod.getEndDate(), "yyyy-MM-dd HH:mm:ss") + "\"";
                    periodList = PstPayPeriod.list(0, 12, where, order);
                    /*
                     * startYear = new Date(payPeriod.getEndDate().getYear(), 0,1);
                     where =" YEAR("+PstPeriod.fieldNames[PstPeriod.FLD_END_DATE]+") = "+ (startYear.getYear()+1900) +
                     " AND " + PstPeriod.fieldNames[PstPeriod.FLD_END_DATE] + "<=\"" + 
                     Formater.formatDate(payPeriod.getEndDate(),"yyyy-MM-dd HH:mm:ss")+"\"";
                     periodList = PstPeriod.list(0, 12, where, order);
                     */

                }
            }
        } catch (Exception exc) {
            System.out.println(exc);
        }
        return periodList;
    }    

    public static double getTaxSalary(long oidPeriod, long employee_id, String taxCompCode) {
        DBResultSet dbrs = null;
        double sumSalary = 0;
        try {
            String sql = "SELECT SUM(COMP." + PstPaySlipComp.fieldNames[PstPaySlipComp.FLD_COMP_VALUE] + ") FROM "
                    + PstPaySlip.TBL_PAY_SLIP + " AS SLIP"
                    + " INNER JOIN " + PstPaySlipComp.TBL_PAY_SLIP_COMP + " AS COMP "
                    + " ON SLIP." + PstPaySlip.fieldNames[PstPaySlip.FLD_PAY_SLIP_ID]
                    + " = COMP." + PstPaySlipComp.fieldNames[PstPaySlipComp.FLD_PAY_SLIP_ID]
                    + " INNER JOIN " + PstPayComponent.TBL_PAY_COMPONENT + " AS PAY"
                    + " ON COMP." + PstPaySlipComp.fieldNames[PstPaySlipComp.FLD_COMP_CODE]
                    + " = PAY." + PstPayComponent.fieldNames[PstPayComponent.FLD_COMP_CODE]
                    + " WHERE SLIP." + PstPaySlip.fieldNames[PstPaySlip.FLD_PERIOD_ID]
                    + " = " + oidPeriod
                    + " AND SLIP." + PstPaySlip.fieldNames[PstPaySlip.FLD_EMPLOYEE_ID]
                    + " = " + employee_id
                    + " AND COMP." + PstPayComponent.fieldNames[PstPayComponent.FLD_COMP_CODE]
                    + " = '" + taxCompCode + "'";
            //System.out.println("SQL getSumSalary" + sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                sumSalary = rs.getDouble(1);
            }
            rs.close();
            return sumSalary;
        } catch (Exception e) {
            return 0;
        } finally {
            DBResultSet.close(dbrs);
        }
    }

    public static double getSumSalary(long oidPeriod, long employee_id, int paySlipType) {
        DBResultSet dbrs = null;
        double sumSalary = 0;
        try {
            String sql = "SELECT SUM(COMP." + PstPaySlipComp.fieldNames[PstPaySlipComp.FLD_COMP_VALUE] + ") FROM "
                    + PstPaySlip.TBL_PAY_SLIP + " AS SLIP"
                    + " INNER JOIN " + PstPaySlipComp.TBL_PAY_SLIP_COMP + " AS COMP "
                    + " ON SLIP." + PstPaySlip.fieldNames[PstPaySlip.FLD_PAY_SLIP_ID]
                    + " = COMP." + PstPaySlipComp.fieldNames[PstPaySlipComp.FLD_PAY_SLIP_ID]
                    + " INNER JOIN " + PstPayComponent.TBL_PAY_COMPONENT + " AS PAY"
                    + " ON COMP." + PstPaySlipComp.fieldNames[PstPaySlipComp.FLD_COMP_CODE]
                    + " = PAY." + PstPayComponent.fieldNames[PstPayComponent.FLD_COMP_CODE]
                    + " WHERE SLIP." + PstPaySlip.fieldNames[PstPaySlip.FLD_PERIOD_ID]
                    + " = " + oidPeriod
                    + " AND SLIP." + PstPaySlip.fieldNames[PstPaySlip.FLD_EMPLOYEE_ID]
                    + " = " + employee_id
                    + " AND PAY." + PstPayComponent.fieldNames[PstPayComponent.FLD_COMP_TYPE]
                    + " = " + PstPayComponent.TYPE_BENEFIT
                    + " AND " + PstPayComponent.fieldNames[PstPayComponent.FLD_TAX_ITEM]
                    + " IN (" + PstPayComponent.GAJI + "," + PstPayComponent.TUNJANGAN + "," + PstPayComponent.BONUS_THR + ")"
                    + " AND SLIP." + fieldNames[FLD_PAY_SLIP_TYPE] + "=" + paySlipType;
            System.out.println("SQL getSumSalary" + sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                sumSalary = rs.getDouble(1);
            }
            rs.close();
            return sumSalary;
        } catch (Exception e) {
            return 0;
        } finally {
            DBResultSet.close(dbrs);
        }
    }


    /* This method used to gen sum of employee's salary
     * @ param : employee_id
     * @ param : period_id
     * Created by Yunny
     */
    public static double getSumTotalSalary(long oidPeriod, long departmentId, long sectionId) {
        DBResultSet dbrs = null;
        double sumSalary = 0;
        try {
            String sql = "SELECT SUM(COMP." + PstPaySlipComp.fieldNames[PstPaySlipComp.FLD_COMP_VALUE] + ") FROM "
                    + PstPaySlip.TBL_PAY_SLIP + " AS SLIP"
                    + " INNER JOIN " + PstPaySlipComp.TBL_PAY_SLIP_COMP + " AS COMP "
                    + " ON SLIP." + PstPaySlip.fieldNames[PstPaySlip.FLD_PAY_SLIP_ID]
                    + " = COMP." + PstPaySlipComp.fieldNames[PstPaySlipComp.FLD_PAY_SLIP_ID]
                    + " INNER JOIN " + PstPayComponent.TBL_PAY_COMPONENT + " AS PAY"
                    + " ON COMP." + PstPaySlipComp.fieldNames[PstPaySlipComp.FLD_COMP_CODE]
                    + " = PAY." + PstPayComponent.fieldNames[PstPayComponent.FLD_COMP_CODE]
                    + " INNER JOIN " + PstEmployee.TBL_HR_EMPLOYEE + " AS EMP"
                    + " ON SLIP." + PstPaySlip.fieldNames[PstPaySlip.FLD_EMPLOYEE_ID]
                    + " = EMP." + PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID]
                    + " INNER JOIN " + PstOvt_Employee.TBL_OVT_EMPLOYEE + " AS OVT"
                    + " ON EMP." + PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_NUM]
                    + " = OVT." + PstOvt_Employee.fieldNames[PstOvt_Employee.FLD_EMPLOYEE_NUM]
                    + " WHERE SLIP." + PstPaySlip.fieldNames[PstPaySlip.FLD_PERIOD_ID]
                    + " = " + oidPeriod
                    + " AND PAY." + PstPayComponent.fieldNames[PstPayComponent.FLD_COMP_TYPE]
                    + " = " + PstPayComponent.TYPE_BENEFIT
                    + " AND " + PstPayComponent.fieldNames[PstPayComponent.FLD_TAX_ITEM]
                    + " IN (" + PstPayComponent.GAJI + "," + PstPayComponent.TUNJANGAN + "," + PstPayComponent.BONUS_THR + ")";
            String whereClause = "";

            if (departmentId != 0) {
                whereClause = whereClause + " EMP." + PstEmployee.fieldNames[PstEmployee.FLD_DEPARTMENT_ID]
                        + " = " + departmentId + " AND ";
            }
            if (sectionId != 0) {
                whereClause = whereClause + " EMP." + PstEmployee.fieldNames[PstEmployee.FLD_SECTION_ID]
                        + " = " + sectionId + " AND ";

            }
            if (whereClause != null && whereClause.length() > 0) {
                whereClause = " AND " + whereClause.substring(0, whereClause.length() - 4);
                sql = sql + whereClause;
                //sql = sql + " WHERE " + whereClause;
            }
            sql = sql + " GROUP BY OVT." + PstOvt_Employee.fieldNames[PstOvt_Employee.FLD_EMPLOYEE_NUM]
                    + ",COMP." + PstPaySlipComp.fieldNames[PstPaySlipComp.FLD_COMP_CODE];

            System.out.println("SQL getSumTotalSalary" + sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                sumSalary = rs.getDouble(1);
            }
            rs.close();
            return sumSalary;
        } catch (Exception e) {
            return 0;
        } finally {
            DBResultSet.close(dbrs);
        }
    }

    /**
     *
     * @param period : HR period
     * @param emp : employee
     * @param paySlip : payroll slip
     * @param salaryComp : salaryComponent
     * @param empSch : employee schedule in HR period
     * @param vctSchIDOff vector of ID schedule category of OFF Day: vctSchIDOff
     * = PstScheduleSymbol.getScheduleId(PstScheduleCategory.CATEGORY_OFF)
     * @param vAbsenReason : vector of absen reason
     * @param maxDateOfMonth : max Date of Month
     * @param procentasePresence : String Constant of percentage of presence :
     * in System Property
     * @param strAbsent : String Constant of absent : in System Property
     * @param salaryEmp : String Constant of salary employee : in System
     * Property
     * @param tot_idx : String Constant of total overtime index : in System
     * Property
     * @param tot_ovt : String Constant of total overtime : in System Property
     * @param strPresence : String Constant of presence : in System Property
     * @param strDayLate : String Constant of date late : in System Property
     * @param minOvtDuration : integer Constant of minimum overtime duration: in
     * System Property as String
     * @return
     */
    public static String calculatePaySlipComponent(
            //Period period, Period prevPeriod, Employee employee, PaySlip paySlip, SalaryLevelDetail salaryComp,
            PayPeriod payPeriod, PayPeriod prevPeriod, Employee employee, PaySlip paySlip, SalaryLevelDetail salaryComp,
            //EmpSchedule empSch,
            Vector vctSchIDOff, /*Vector<Reason> vAbsenReason,*/ int maxDateOfMonth,
            String procentasePresence, String strAbsent, String salaryEmp, String tot_idx, String tot_ovt, String strPresence,
            String strDayLate, double minOvtDuration,
            Vector<String> salComponent, I_PayrollCalculator payrollCalculator, Vector listPeriodDate, Pajak pajak, PayInput payInput, Vector Reason, Vector Position, Date startDate, Date endDate) {
        //priska menambahkan 20150807 leave config
        I_Leave leaveConfig = null;
        try {
            leaveConfig = (I_Leave) (Class.forName(PstSystemProperty.getValueByName("LEAVE_CONFIG")).newInstance());
        } catch (Exception e) {
            System.out.println("Exception : " + e.getMessage());
        }

        String formula = salaryComp.getFormula();
        if (checkString(formula, "& LT") > -1) {
            //update by priska 2015-01-20
            formula = formula.replaceAll("& LT", " < " );
        }
        if (checkString(formula, "& lt") > -1) {
            //update by priska 2015-01-20
            formula = formula.replaceAll("& lt", " < " );
        }
         if (checkString(formula, "&lt") > -1) {
            //update by priska 2015-01-20
            formula = formula.replaceAll("&lt", " < " );
        }
        double newTotalTax = 0;
        //cek component pada surat dahulu
        if (checkString(formula, GET_DOCUMENT_COMPONENT_VAL_MAPPING) > -1) {
            try{
            boolean nilai = getReadyDocComponent(payPeriod.getStartDate(), payPeriod.getEndDate(), employee.getOID(), salaryComp.getCompCode());
            if (nilai){
               long totdocDay = getDayDocComponent(payPeriod.getStartDate(), payPeriod.getEndDate(), employee.getOID(), salaryComp.getCompCode());
               formula = " GET_VALUE_MAPPING * "+totdocDay;
            }
            }catch (Exception e){}
        }
        
        if (checkString(formula, GET_DOC_VAL) > -1) {
            formula = formula.replaceAll(GET_DOC_VAL, "" + (getDocumentValue(payPeriod.getStartDate(), payPeriod.getEndDate(), employee.getOID(),salaryComp.getComponentId())));
        }
        
		if (checkString(formula, GET_DOC_VAL_LEAVE_ALLOWANCE) > -1) {
            formula = formula.replaceAll(GET_DOC_VAL_LEAVE_ALLOWANCE, "" + (getSumDocumentValueByObjectName(payPeriod.getStartDate(), payPeriod.getEndDate(), employee.getOID(),"PREVIOUS_BENEFIT")));
        }
		
        if (checkString(formula, GET_DOCUMENT_COMPONENT) > -1) {
            formula = formula.replaceAll(GET_DOCUMENT_COMPONENT, "" + (getDocumentComponent(payPeriod.getStartDate(), payPeriod.getEndDate(), employee.getOID())));
        }
        
        if (checkString(formula, GET_VALUE_MAPPING) > -1) {
            //update by priska 2015-01-20 getValueMappingTotal
            //formula = formula.replaceAll(GET_VALUE_MAPPING, "" + (getValuemapping(payPeriod.getStartDate(), payPeriod.getEndDate(), employee.getOID(), salaryComp)));
            /* Value Mapping process is updated by Hendra Putu | 2016-03-06 */
            String periodFrom = ""+payPeriod.getStartDate();
            String periodTo = ""+payPeriod.getEndDate();
            String employeeId = ""+employee.getOID();
            String salaryComponent = ""+salaryComp.getCompCode();
            ValueMappingProposional valueMapPro = new ValueMappingProposional();
            formula = formula.replaceAll(GET_VALUE_MAPPING, "" + (valueMapPro.getValueMappingTotal(periodFrom, periodTo, employeeId, salaryComponent)));
        }
        
        if (checkString(formula, GET_MATERNITY_LEAVE_DURATION) > -1){
            int day = getMaternityLeaveDuration(employee.getOID(), payPeriod);
            formula = formula.replaceAll(GET_MATERNITY_LEAVE_DURATION, "" + day);
        }
        
        if (checkString(formula, GET_UNPAID_LEAVE_DURATION) > -1){
            int day = getUnpaidLeaveDuration(employee.getOID(), payPeriod);
            formula = formula.replaceAll(GET_UNPAID_LEAVE_DURATION, "" + day);
        }
        
        if (checkString(formula, GET_LL_STOCK) > -1){
            LLStockManagement llStockManagement = PstLLStockManagement.getLlStockActive(employee.getOID());
            float qty = 0;
            if (llStockManagement.getOID()>0){
                qty = llStockManagement.getEntitled() + llStockManagement.getPrevBalance() - llStockManagement.getQtyUsed();
            }
            formula = formula.replaceAll(GET_LL_STOCK, "" + qty);
        }
        
        if (checkString(formula, GET_AL_STOCK) > -1){
            AlStockManagement alStockManagement = PstAlStockManagement.getAlStockManagement(employee.getOID());
            float qty = 0;
            if (alStockManagement.getOID()>0){
                qty = alStockManagement.getEntitled() + alStockManagement.getPrevBalance() - alStockManagement.getQtyUsed();
            }
            formula = formula.replaceAll(GET_AL_STOCK, "" + qty);
        }
        
        long propFormatDatePresent = -1;
        try {
            propFormatDatePresent = Long.parseLong(PstSystemProperty.getValueByName("FORMAT_DATE_PRESENT"));
        } catch (Exception ex) {

        }

        long propGPokok = -1;
        try {
            propGPokok = Long.parseLong(PstSystemProperty.getValueByName("OID_GAJIPOKOK"));
        } catch (Exception ex) {
            System.out.println("Execption Gaji Pokok: " + ex);
        }
        PayComponent payComponent123 = new PayComponent();
        if (propGPokok > 0){
        try {
            payComponent123 = PstPayComponent.fetchExc(propGPokok);
        } catch (Exception e) {
            System.out.print("properties gaji pokok tidak disetting");
        }
        }
        double dayTotalperPeriod = ((payPeriod.getEndDate().getTime() - payPeriod.getStartDate().getTime()) / (1000 * 60 * 60 * 24)) + 1;
		double totalHK = payPeriod.getDayInPeriod();

        //String salCompInFormula = salaryComp.getFormula();
        if (payPeriod == null || payPeriod.getOID() == 0) {
            //if (period == null || period.getOID() == 0) {
            return "selPeriod is null or not initialized";
        }

        if (paySlip == null || paySlip.getOID() == 0) {
            return "paySlip is null or not initialized";
        }

        /*if (empSch == null || empSch.getOID() == 0) {
         return "empSch is null or not initialized";
         }*/
        if (formula == null || formula.length() < 1) {
            return "empSch is null or not initialized";
        }

        String message = "";

        Vector vectComp = new Vector(1, 1);
        String formSQL = formula;

        formSQL = formSQL.replaceAll("%", "/100");

        //update by satrya 2014-05-14
        if (checkString(formula, PAY_COMP_REASON_IDX) > -1) {
//            if (listReason != null && listReason.size() > 0) {
//                for (int idxRes = 0; idxRes < listReason.size(); idxRes++) {
//                    Reason reason = (Reason) listReason.get(idxRes);
//                    payCode = FrmPayInput.fieldNames[FrmPayInput.FRM_FIELD_REASON_IDX] + "_" + reason.getNo() + "_" + payInput.getPeriodId() + "_" + payInput.getEmployeeId();
//                    if ((existPayInputId == null) || (existPayInputId.size() == 0) || existPayInputId != null && existPayInputId.size() > 0 && existPayInputId.containsKey("" + oidPaySlip + "_" + payCode + "_" + periodId + "_" + oidEmployee) == false) {
//                        pstPayGeneral = new PstPayInput(0);
//                    } else {
//                        if (existPayInputId != null && existPayInputId.size() > 0 && existPayInputId.containsKey("" + oidPaySlip + "_" + payCode + "_" + periodId + "_" + oidEmployee)) {
//                            long oidPayslip = (Long) existPayInputId.get("" + oidPaySlip + "_" + payCode + "_" + periodId + "_" + oidEmployee);
//                            pstPayGeneral = new PstPayInput(oidPayslip);
//                        }
//                    }
//                    pstPayGeneral.setLong(FLD_PAY_SLIP_ID, payInput.getPaySlipId());
//                    pstPayGeneral.setString(FLD_PAY_INPUT_CODE, FrmPayInput.fieldNames[FrmPayInput.FRM_FIELD_REASON_IDX] + "_" + reason.getNo() + "_" + payInput.getPeriodId() + "_" + payInput.getEmployeeId());
//                    pstPayGeneral.setDouble(FLD_PAY_INPUT_VALUE, payInput.getReasonIdx(reason.getNo(), payInput.getPeriodId(), payInput.getEmployeeId()));
//                    pstPayGeneral.setLong(FLD_PERIODE_ID, payInput.getPeriodId());
//                    pstPayGeneral.setLong(FLD_EMPLOYEE_ID, payInput.getEmployeeId());
//                    if ((existPayInputId == null) || (existPayInputId.size() == 0) || existPayInputId != null && existPayInputId.size() > 0 && existPayInputId.containsKey("" + oidPaySlip + "_" + payCode + "_" + periodId + "_" + oidEmployee) == false) {
//                        pstPayGeneral.insert();
//                    } else {
//                        if (existPayInputId != null && existPayInputId.size() > 0 && existPayInputId.containsKey("" + oidPaySlip + "_" + payCode + "_" + periodId + "_" + oidEmployee)) {
//                            pstPayGeneral.update();
//                        }
//                    }
//                    payCode = FrmPayInput.fieldNames[FrmPayInput.FRM_FIELD_REASON_IDX_ADJUSMENT] + "_" + reason.getNo() + "_" + payInput.getPeriodId() + "_" + payInput.getEmployeeId();
//                    if ((existPayInputId == null) || (existPayInputId.size() == 0) || existPayInputId != null && existPayInputId.size() > 0 && existPayInputId.containsKey("" + oidPaySlip + "_" + payCode + "_" + periodId + "_" + oidEmployee) == false) {
//                        pstPayGeneral = new PstPayInput(0);
//                    } else {
//                        if (existPayInputId != null && existPayInputId.size() > 0 && existPayInputId.containsKey("" + oidPaySlip + "_" + payCode + "_" + periodId + "_" + oidEmployee)) {
//                            long oidPayslip = (Long) existPayInputId.get("" + oidPaySlip + "_" + payCode + "_" + periodId + "_" + oidEmployee);
//                            pstPayGeneral = new PstPayInput(oidPayslip);
//                        }
//                    }
//                    pstPayGeneral.setLong(FLD_PAY_SLIP_ID, payInput.getPaySlipId());
//                    pstPayGeneral.setString(FLD_PAY_INPUT_CODE, FrmPayInput.fieldNames[FrmPayInput.FRM_FIELD_REASON_IDX_ADJUSMENT] + "_" + reason.getNo() + "_" + payInput.getPeriodId() + "_" + payInput.getEmployeeId());
//                    pstPayGeneral.setDouble(FLD_PAY_INPUT_VALUE, payInput.getReasonIdxAdjust(reason.getNo(), payInput.getPeriodId(), payInput.getEmployeeId()));
//                    pstPayGeneral.setLong(FLD_PERIODE_ID, payInput.getPeriodId());
//                    pstPayGeneral.setLong(FLD_EMPLOYEE_ID, payInput.getEmployeeId());
//                    if ((existPayInputId == null) || (existPayInputId.size() == 0) || existPayInputId != null && existPayInputId.size() > 0 && existPayInputId.containsKey("" + oidPaySlip + "_" + payCode + "_" + periodId + "_" + oidEmployee) == false) {
//                        pstPayGeneral.insert();
//                    } else {
//                        if (existPayInputId != null && existPayInputId.size() > 0 && existPayInputId.containsKey("" + oidPaySlip + "_" + payCode + "_" + periodId + "_" + oidEmployee)) {
//                            pstPayGeneral.update();
//                        }
//                    }
//
//
//                    payCode = FrmPayInput.fieldNames[FrmPayInput.FRM_FIELD_REASON_TIME] + "_" + reason.getNo() + "_" + payInput.getPeriodId() + "_" + payInput.getEmployeeId();
//                    if ((existPayInputId == null) || (existPayInputId.size() == 0) || existPayInputId != null && existPayInputId.size() > 0 && existPayInputId.containsKey("" + oidPaySlip + "_" + payCode + "_" + periodId + "_" + oidEmployee) == false) {
//                        pstPayGeneral = new PstPayInput(0);
//                    } else {
//                        if (existPayInputId != null && existPayInputId.size() > 0 && existPayInputId.containsKey("" + oidPaySlip + "_" + payCode + "_" + periodId + "_" + oidEmployee)) {
//                            long oidPayslip = (Long) existPayInputId.get("" + oidPaySlip + "_" + payCode + "_" + periodId + "_" + oidEmployee);
//                            pstPayGeneral = new PstPayInput(oidPayslip);
//                        }
//                    }
//                    pstPayGeneral.setLong(FLD_PAY_SLIP_ID, payInput.getPaySlipId());
//                    pstPayGeneral.setString(FLD_PAY_INPUT_CODE, FrmPayInput.fieldNames[FrmPayInput.FRM_FIELD_REASON_TIME] + "_" + reason.getNo() + "_" + payInput.getPeriodId() + "_" + payInput.getEmployeeId());
//                    pstPayGeneral.setDouble(FLD_PAY_INPUT_VALUE, payInput.getReasonTime(reason.getNo(), payInput.getPeriodId(), payInput.getEmployeeId()));
//                    pstPayGeneral.setLong(FLD_PERIODE_ID, payInput.getPeriodId());
//                    pstPayGeneral.setLong(FLD_EMPLOYEE_ID, payInput.getEmployeeId());
//                    if ((existPayInputId == null) || (existPayInputId.size() == 0) || existPayInputId != null && existPayInputId.size() > 0 && existPayInputId.containsKey("" + oidPaySlip + "_" + payCode + "_" + periodId + "_" + oidEmployee) == false) {
//                        pstPayGeneral.insert();
//                    } else {
//                        if (existPayInputId != null && existPayInputId.size() > 0 && existPayInputId.containsKey("" + oidPaySlip + "_" + payCode + "_" + periodId + "_" + oidEmployee)) {
//                            pstPayGeneral.update();
//                        }
//                    }
//                    payCode = FrmPayInput.fieldNames[FrmPayInput.FRM_FIELD_REASON_TIME_ADJUSMENT] + "_" + reason.getNo() + "_" + payInput.getPeriodId() + "_" + payInput.getEmployeeId();
//                    if ((existPayInputId == null) || (existPayInputId.size() == 0) || existPayInputId != null && existPayInputId.size() > 0 && existPayInputId.containsKey("" + oidPaySlip + "_" + payCode + "_" + periodId + "_" + oidEmployee) == false) {
//                        pstPayGeneral = new PstPayInput(0);
//                    } else {
//                        if (existPayInputId != null && existPayInputId.size() > 0 && existPayInputId.containsKey("" + oidPaySlip + "_" + payCode + "_" + periodId + "_" + oidEmployee)) {
//                            long oidPayslip = (Long) existPayInputId.get("" + oidPaySlip + "_" + payCode + "_" + periodId + "_" + oidEmployee);
//                            pstPayGeneral = new PstPayInput(oidPayslip);
//                        }
//                    }
//                    pstPayGeneral.setLong(FLD_PAY_SLIP_ID, payInput.getPaySlipId());
//                    pstPayGeneral.setString(FLD_PAY_INPUT_CODE, FrmPayInput.fieldNames[FrmPayInput.FRM_FIELD_REASON_TIME_ADJUSMENT] + "_" + reason.getNo() + "_" + payInput.getPeriodId() + "_" + payInput.getEmployeeId());
//                    pstPayGeneral.setDouble(FLD_PAY_INPUT_VALUE, payInput.getReasonTimeAdjust(reason.getNo(), payInput.getPeriodId(), payInput.getEmployeeId()));
//                    pstPayGeneral.setLong(FLD_PERIODE_ID, payInput.getPeriodId());
//                    pstPayGeneral.setLong(FLD_EMPLOYEE_ID, payInput.getEmployeeId());
//                    if ((existPayInputId == null) || (existPayInputId.size() == 0) || existPayInputId != null && existPayInputId.size() > 0 && existPayInputId.containsKey("" + oidPaySlip + "_" + payCode + "_" + periodId + "_" + oidEmployee) == false) {
//                        pstPayGeneral.insert();
//                    } else {
//                        if (existPayInputId != null && existPayInputId.size() > 0 && existPayInputId.containsKey("" + oidPaySlip + "_" + payCode + "_" + periodId + "_" + oidEmployee)) {
//                            pstPayGeneral.update();
//                        }
//                    }
//                }
//            }

            // double dateOk =  payrollCalculator.calculatePayrollFormula(PAY_COMP_DATE_OK, paySlip.getEmployeeId(),  employee.getDepartmentId(), payPeriod.getOID(), 31, PstEmpSchedule.STATUS_PRESENCE_OK );
            //formSQL = formSQL.replaceAll(PAY_COMP_DATE_OK, "" + dateOk);
            //update by satrya 2013-02-20
            formSQL = formSQL.replaceAll(PAY_COMP_DATE_OK, "" + paySlip.getInsentif());
        }

     
        
        if (checkString(formula, SalaryLevelDetail.DATE_LATE) > -1) { // untuk pengambilan nilai day late                    
            formSQL = formSQL.replaceAll(SalaryLevelDetail.DATE_LATE, "" + (paySlip.getDayLate() + payInput.getLateIdxAdjust()));
            //salCompInFormula = salCompInFormula.replaceAll(SalaryLevelDetail.DATE_LATE, "");
        }

        if (checkString(formula, GET_AGE) > -1) {
            //update by priska 2015-01-20
            Date newDate = new Date(); 
            double age = newDate.getYear() - employee.getBirthDate().getYear();  
            formSQL = formSQL.replaceAll(GET_AGE, "" + age);
            
        }
        
        if (checkString(formula, WORKDAYOP) > -1) {
            //update by priska 2016-01-11
            String WorkDayOp = "30";
            try {
                WorkDayOp = String.valueOf(PstSystemProperty.getValueByName("WORKDAYOP"));//menambahkan system properties
            } catch (Exception e) {
                System.out.println("Exeception WORKDAYOP:" + e);
            }
            formSQL = formSQL.replaceAll(WORKDAYOP, "" + WorkDayOp);
            
        }
        
        if (checkString(formula, WORKDAYBO) > -1) {
            //update by priska 2016-01-11
            String WorkDayBo = "30";
            try {
                WorkDayBo = String.valueOf(PstSystemProperty.getValueByName("WORKDAYBO"));//menambahkan system properties
            } catch (Exception e) {
                System.out.println("Exeception WORKDAYBO:" + e);
            }
            formSQL = formSQL.replaceAll(WORKDAYOP, "" + WorkDayBo);
            
        }
        
        if (checkString(formula, SalaryLevelDetail.DATE_ABSENT) > -1) { //untuk mengambil nilai absent                                                                                  
            formSQL = formSQL.replaceAll(SalaryLevelDetail.DATE_ABSENT, "" + paySlip.getDayAbsent() + payInput.getAbsenceIdxAdjust());
            //salCompInFormula = salCompInFormula.replaceAll(SalaryLevelDetail.DATE_ABSENT, "");
        }

        //untuk mengambil nilai day in period                                                          
        if (checkString(formula, SalaryLevelDetail.DAY_PERIOD) > -1) {
            formSQL = formSQL.replaceAll(SalaryLevelDetail.DAY_PERIOD, "" + payPeriod.getDayInPeriod());
            //salCompInFormula = salCompInFormula.replaceAll(SalaryLevelDetail.DAY_PERIOD, "");
        }

        //untuk mengambil nilai working day in period                                                          
        if (checkString(formula, SalaryLevelDetail.WORK_DAY_PERIOD) > -1) {
            formSQL = formSQL.replaceAll(SalaryLevelDetail.WORK_DAY_PERIOD, "" + payPeriod.getWorkDays());
            //salCompInFormula = salCompInFormula.replaceAll(SalaryLevelDetail.WORK_DAY_PERIOD, "");
        }

        
        //untuk mengambil nilai off schedule 
        if (checkString(formula, SalaryLevelDetail.DAY_OFF_SCHEDULE) > -1) {
            //int offDay = empSch.numberOfScheduleSymbol(vctSchIDOff);
            //formSQL = formSQL.replaceAll(SalaryLevelDetail.DAY_OFF_SCHEDULE, "" + payPeriod.getWorkDays());
            //update by satrya 2013-02-20
            formSQL = formSQL.replaceAll(SalaryLevelDetail.DAY_OFF_SCHEDULE, "" + paySlip.getDayOffSch());
            //salCompInFormula = salCompInFormula.replaceAll(SalaryLevelDetail.DAY_OFF_SCHEDULE, "");
        }

        //untuk mengambil nilai date overtime pada off schedule 
        if (checkString(formula, SalaryLevelDetail.TOTAL_DAY_OFF_OVERTIME) > -1) {
            //double tOvtDate = 0.0;
            /*if (empSch != null) {
             Vector dates = empSch.dateOfScheduleSymbol(vctSchIDOff, payPeriod.getStartDate());
             tOvtDate = PstOvt_Employee.getTotalDatesOverTm(dates, payPeriod.getOID(), employee.getEmployeeNum(), minOvtDuration);
             }
             formSQL = formSQL.replaceAll(SalaryLevelDetail.TOTAL_DAY_OFF_OVERTIME, String.valueOf(tOvtDate));*/
            //update by satrya 2013-02-20
            formSQL = formSQL.replaceAll(SalaryLevelDetail.TOTAL_DAY_OFF_OVERTIME, String.valueOf(paySlip.getTotDayOffOt()));
            //salCompInFormula = salCompInFormula.replaceAll(SalaryLevelDetail.TOTAL_DAY_OFF_OVERTIME, "");
        }

        //untuk mengambil nilai date overtime pada off schedule 
        if (checkString(formula, SalaryLevelDetail.OVTIME_MEAL_ALLOWANCE) > -1) {
            int ovMealQty = 0;
            //if (empSch != null){                               
            Vector obj_status = new Vector(1, 1);
            Vector val_status = new Vector(1, 1);
            Vector key_status = new Vector(1, 1);
            val_status.add("-1");
            key_status.add("- All -");

            val_status.add(String.valueOf(I_DocStatus.DOCUMENT_STATUS_DRAFT));
            key_status.add(I_DocStatus.fieldDocumentStatus[I_DocStatus.DOCUMENT_STATUS_DRAFT]);

            val_status.add(String.valueOf(I_DocStatus.DOCUMENT_STATUS_TO_BE_APPROVED));
            key_status.add(I_DocStatus.fieldDocumentStatus[I_DocStatus.DOCUMENT_STATUS_TO_BE_APPROVED]);

            val_status.add(String.valueOf(I_DocStatus.DOCUMENT_STATUS_FINAL));
            key_status.add(I_DocStatus.fieldDocumentStatus[I_DocStatus.DOCUMENT_STATUS_FINAL]);

            val_status.add(String.valueOf(I_DocStatus.DOCUMENT_STATUS_PROCEED));
            key_status.add(I_DocStatus.fieldDocumentStatus[I_DocStatus.DOCUMENT_STATUS_PROCEED]);

            val_status.add(String.valueOf(I_DocStatus.DOCUMENT_STATUS_CLOSED));
            key_status.add(I_DocStatus.fieldDocumentStatus[I_DocStatus.DOCUMENT_STATUS_CLOSED]);

            val_status.add(String.valueOf(I_DocStatus.DOCUMENT_STATUS_CANCELLED));
            key_status.add(I_DocStatus.fieldDocumentStatus[I_DocStatus.DOCUMENT_STATUS_CANCELLED]);

            //hidden by satrya 2014-05-14 karena sdh ngambil di payslip ovMealQty = PstOvertimeDetail.countOvertimeDetail(employee.getOID(), payPeriod.getStartDate(), payPeriod.getEndDate(),
            //        Overtime.ALLOWANCE_FOOD, -1, PstOvertimeDetail.sDocStValforValidOvDetail);
            // }
            formSQL = formSQL.replaceAll(SalaryLevelDetail.OVTIME_MEAL_ALLOWANCE, String.valueOf(paySlip.getMealAllowanceMoneyByForm() + paySlip.getMealAllowanceMoneyAdj()));
            //salCompInFormula = salCompInFormula.replaceAll(SalaryLevelDetail.OVTIME_MEAL_ALLOWANCE, "");
        }

        // untuk mengambil nilai status absensi dan reason                             
                /* belum di implementasi
         if (checkString(formula,SalaryLevelDetail.SCH_STS_RSN)>-1) {                                        
         String sTemp = "";
         if (payCom.length() > SalaryLevelDetail.SCH_STS_RSN.length()) {
         payCom.substring(SalaryLevelDetail.SCH_STS_RSN.length() + 1);// get data code_Schedulestatus_reason                                        
         String sSchStatus = sTemp.substring(0, sTemp.indexOf("_"));
         String sSchReason = sTemp.substring(sTemp.indexOf("_") + 1, sTemp.length());
         // lanjutkan dengan code tertentu
         compCalculated = true;
         }
         } */
//        if (vAbsenReason != null && vAbsenReason.size() > 0 && checkString(formula, SalaryLevelDetail.ABSENT_RSN) > -1) {
//            String sTemp = "";
//            int sumRsn = 0;
//
//            for (int idx = 0; idx < vAbsenReason.size(); idx++) {
//                Reason reason = (Reason) vAbsenReason.get(idx);
//                if (formula.indexOf(SalaryLevelDetail.ABSENT_RSN + "_" + reason.getNo()) > -1) {
//                    try {
//                        Vector vctSt = new Vector();
//                        vctSt.add(new Integer(PstEmpSchedule.STATUS_PRESENCE_ABSENCE));
//                        Vector vctReason = new Vector();
//                        Integer iRsn = new Integer(reason.getNo());
//                        vctReason.add(iRsn);
//                        //update by satrya 2013-02-20
//                        boolean cekAwalPayPeriod = true;
//                        Date dtPeriodNew = null;// tujuannya mendapatkan endDate period baru
//                        int diffDay = 0;
//                        if (listPeriodDate != null && listPeriodDate.size() > 0) {
//                            for (int ix = 0; ix < listPeriodDate.size(); ix++) {
//                                Period period = (Period) listPeriodDate.get(ix);
//                                // melakukan cek periode attendance
//                                if (cekAwalPayPeriod && ((listPeriodDate.size() - 1) == 0)) {
//                                    //artinya jika user memilih tanggal 1 desember s/d 15 desember tpi masih 1 periode januari
//                                    diffDay = PstPresence.DATEDIFF(payPeriod.getEndDate(), payPeriod.getStartDate());
//                                    dtPeriodNew = payPeriod.getStartDate();
//                                    //endPeriodNew = payPeriod.getEndDate();
//                                    cekAwalPayPeriod = false;
//                                    listPeriodDate.remove(ix);
//                                    ix = ix - 1;
//                                } else if (cekAwalPayPeriod) {
//                                    //jika user memilih tanggal 15 desember s/d 19 januari 2013, tpi periode yg ada 15 desmeber s/d 20 desember
//                                    diffDay = PstPresence.DATEDIFF(period.getEndDate(), payPeriod.getStartDate());
//                                    dtPeriodNew = payPeriod.getStartDate();
//                                    // endPeriodNew = period.getEndDate();
//                                    cekAwalPayPeriod = false;
//                                    listPeriodDate.remove(ix);
//                                    ix = ix - 1;
//                                } else if (((listPeriodDate.size() - 1) == 0)) {
//                                    //kelanjutan dari yg di atas
//                                    diffDay = PstPresence.DATEDIFF(payPeriod.getEndDate(), period.getStartDate());
//                                    dtPeriodNew = period.getStartDate();
//                                    //endPeriodNew = payPeriod.getEndDate();
//                                    listPeriodDate.remove(ix);
//                                    ix = ix - 1;
//                                } else {
//                                    diffDay = PstPresence.DATEDIFF(period.getEndDate(), period.getStartDate());
//                                    dtPeriodNew = period.getStartDate();
//                                    //endPeriodNew = period.getEndDate();
//                                    listPeriodDate.remove(ix);
//                                    ix = ix - 1;
//                                }
//                                EmpSchedule empSch = PstEmpSchedule.getEmpSchedule(employee.getOID(), period.getOID(), diffDay, dtPeriodNew);
//
//                                int sumRsnX = empSch.getSumStatusDisp(employee.getOID(), payPeriod.getOID(), diffDay, vctSt, vctReason, dtPeriodNew);
//                                sumRsn = sumRsn + sumRsnX;
//                            }
//                        }
//                        //sumRsn = PstEmpSchedule.sumStatusDisp(employee.getOID(), payPeriod.getOID(), maxDateOfMonth, vctSt, vctReason);
//
//                    } catch (Exception exc) {
//                        System.out.println("payroll-process : ABSENT_RSN : " + exc);
//                    }
//                    formSQL = formSQL.replaceAll(SalaryLevelDetail.ABSENT_RSN + "_" + reason.getNo(), "" + sumRsn);
//                    //salCompInFormula = salCompInFormula.replaceAll(SalaryLevelDetail.ABSENT_RSN + "_" + reason.getNo(), "");
//                }
//            }
//        }
//        if (checkString(formula, SalaryLevelDetail.DAYWORK_LESS_MNT) > -1) {
//            try {
//                int idxStart = formula.indexOf("" + SalaryLevelDetail.DAYWORK_LESS_MNT);
//                int idxOf_ = formula.indexOf("_", idxStart);
//                int idxEnd = formula.indexOf(" ", idxStart);
//                String workDayLess_min = formula.substring(idxStart, idxEnd);
//                String dayWork = formula.substring(idxEnd);
//                int dayLessWork = 0;
//                if (idxStart < idxOf_ && idxOf_ < idxEnd) { // there is  DAYWORK_LESS_MNT_###                             
//                    Integer iMinMinutes = new Integer(formula.substring(idxOf_ + 1, idxEnd));
//                    long lMaxMIN = (iMinMinutes.longValue() * 60L * 1000L) - 1L;
//                    boolean cekAwalPayPeriod = true;
//                    Date dtPeriodNew = null;// tujuannya mendapatkan endDate period baru
//                    int diffDay = 0;
//                    if (listPeriodDate != null && listPeriodDate.size() > 0) {
//                        for (int ix = 0; ix < listPeriodDate.size(); ix++) {
//                            Period period = (Period) listPeriodDate.get(ix);
//                            // melakukan cek periode attendance
//                            if (cekAwalPayPeriod && ((listPeriodDate.size() - 1) == 0)) {
//                                //artinya jika user memilih tanggal 1 desember s/d 15 desember tpi masih 1 periode januari
//                                diffDay = PstPresence.DATEDIFF(payPeriod.getEndDate(), payPeriod.getStartDate());
//                                dtPeriodNew = payPeriod.getStartDate();
//                                //endPeriodNew = payPeriod.getEndDate();
//                                cekAwalPayPeriod = false;
//                                listPeriodDate.remove(ix);
//                                ix = ix - 1;
//                            } else if (cekAwalPayPeriod) {
//                                //jika user memilih tanggal 15 desember s/d 19 januari 2013, tpi periode yg ada 15 desmeber s/d 20 desember
//                                diffDay = PstPresence.DATEDIFF(period.getEndDate(), payPeriod.getStartDate());
//                                dtPeriodNew = payPeriod.getStartDate();
//                                // endPeriodNew = period.getEndDate();
//                                cekAwalPayPeriod = false;
//                                listPeriodDate.remove(ix);
//                                ix = ix - 1;
//                            } else if (((listPeriodDate.size() - 1) == 0)) {
//                                //kelanjutan dari yg di atas
//                                diffDay = PstPresence.DATEDIFF(payPeriod.getEndDate(), period.getStartDate());
//                                dtPeriodNew = period.getStartDate();
//                                //endPeriodNew = payPeriod.getEndDate();
//                                listPeriodDate.remove(ix);
//                                ix = ix - 1;
//                            } else {
//                                diffDay = PstPresence.DATEDIFF(period.getEndDate(), period.getStartDate());
//                                dtPeriodNew = period.getStartDate();
//                                //endPeriodNew = period.getEndDate();
//                                listPeriodDate.remove(ix);
//                                ix = ix - 1;
//                            }
//                            EmpSchedule empSch = PstEmpSchedule.getEmpSchedule(employee.getOID(), period.getOID(), diffDay, dtPeriodNew);
//                            int dayLessWorkX = empSch.getNumberDatePresentDuration(1L, lMaxMIN, PstEmpSchedule.STATUS_PRESENCE_OK, 1, 1, diffDay, dtPeriodNew);  // get date that status present OK but work hour is less then maxMinutes
//                            dayLessWork = dayLessWork + dayLessWorkX;
//                        }
//                    }
//
//                }
//                formSQL = formSQL.replaceAll(workDayLess_min, "" + dayLessWork);
//                //salCompInFormula = salCompInFormula.replaceAll(workDayLess_min, "");
//            } catch (Exception exc) {
//                System.out.println("payroll-process : DAYWORK_LESS_MINUTES : " + exc);
//            }
//        }
        if (checkString(formula, SalaryLevelDetail.DATE_PRESENT) > -1) {
            // formSQL = formSQL.replaceAll(SalaryLevelDetail.DATE_PRESENT, "" + paySlip.getDayPresent() + payInput.getPresenceOntimeIdxAdjust());
            if (propFormatDatePresent == 1) {
                formSQL = formSQL.replaceAll(SalaryLevelDetail.DATE_PRESENT, "" + (Formater.formatNumber((paySlip.getDayPresent() + payInput.getPresenceOntimeIdxAdjust()), "#,##")));
            } else {
                formSQL = formSQL.replaceAll(SalaryLevelDetail.DATE_PRESENT, "" + (paySlip.getDayPresent()) + payInput.getPresenceOntimeIdxAdjust());
            }

            //salCompInFormula = salCompInFormula.replaceAll(SalaryLevelDetail.DATE_PRESENT, "");
        } // kondisi untuk tunjangan ekspor(khusus intimas)

        // untyk presence
        if (checkString(formula, procentasePresence) > -1) {
            double procenPresence = (paySlip.getProcentasePresence() / 100);
            formSQL = formSQL.replaceAll(procentasePresence, "" + procenPresence);
            //salCompInFormula = salCompInFormula.replaceAll(procentasePresence, "");
        }

        if (checkString(formula, salaryEmp) > -1) {
            double sumSalary = PstPaySlip.getSumSalary(payPeriod.getOID(), employee.getOID());
            formSQL = formSQL.replaceAll(salaryEmp, "" + sumSalary);
            //salCompInFormula = salCompInFormula.replaceAll(salaryEmp, "");
        }
        ///untuk prosess menghitung total_idx
        //untuk prosess menghitung upah lembur yg di byr uang
        //disini tidak mendapatkan nilai priska 20150922
        if (checkString(formula, tot_idx) > -1) {

            //update by satrya 2014-02-07 double total_idx = PstOvertimeDetail.getCalculateTotIdx(paySlip.getEmployeeId(),OvertimeDetail.PAID_BY_SALARY, payPeriod.getStartDate(),payPeriod.getEndDate())+ paySlip.getOvIdxAdj();
            //
            formSQL = formSQL.replaceAll(tot_idx, "" + (paySlip.getOvertimeIdxByForm() + paySlip.getOvIdxAdj()));
            //salCompInFormula = salCompInFormula.replaceAll(tot_idx, "");
        }

        if (checkString(formula, PAY_PERIOD_NAME) > -1) {
            formSQL = formSQL.replaceAll(PAY_PERIOD_NAME, "\"" + payPeriod.getPeriod() + "\"");
            formSQL = formSQL.replaceAll("[$]", "\"");
        }
        
        
        if (checkString(formula,GET_INSENTIF_CASHIER) > -1) {
            // formSQL = formSQL.replaceAll(SalaryLevelDetail.DATE_PRESENT, "" + paySlip.getDayPresent() + payInput.getPresenceOntimeIdxAdjust());
               formSQL = formSQL.replaceAll(GET_INSENTIF_CASHIER, "" + getSeniorOrSupervisor(employee.getOID(), employee.getSectionId(), employee.getDepartmentId()));
            
        }

        if (checkString(formula, PAY_COMP_SALARY_TAX) > -1) {
            Pajak pajak1 = new Pajak();
            if (!employee.getNpwp().equals("000000000000000")){
                 pajak1 = pajak;
            } 
            double total_tax = 0.0;
            String clientName = PstSystemProperty.getValueByName("CLIENT_NAME");
                                                         
            if (clientName.equals("BPD")){
                total_tax = TaxCalculator.calcSalaryTaxBPD(paySlip.getEmployeeId(), payPeriod, prevPeriod, pajak1);
            } else {
                total_tax = TaxCalculator.calcSalaryTax(paySlip.getEmployeeId(), payPeriod, prevPeriod, pajak1);
            }
                  // total_tax = TaxCalculator.calcSalaryTax(paySlip.getEmployeeId(), payPeriod, prevPeriod, pajak1);
            formSQL = formSQL.replaceAll(PAY_COMP_SALARY_TAX, "" + total_tax);
            newTotalTax = total_tax;
        }
        
        if (checkString(formula, PAY_COMP_SALARY_TAX_SECOND_SLIP) > -1) {
            Pajak pajak1 = new Pajak();
            if (!employee.getNpwp().equals("000000000000000")){
                 pajak1 = pajak;
            } 
            double total_tax = 0.0;
            String clientName = PstSystemProperty.getValueByName("CLIENT_NAME");
                                                         
            if (clientName.equals("BPD")){
                total_tax = TaxCalculator.calcSalaryTaxBPD(paySlip.getEmployeeId(), payPeriod, prevPeriod, pajak1);
            } else {
                total_tax = TaxCalculator.calcSalaryTax(paySlip.getEmployeeId(), payPeriod, prevPeriod, pajak1);
            }
                  // total_tax = TaxCalculator.calcSalaryTax(paySlip.getEmployeeId(), payPeriod, prevPeriod, pajak1);
            formSQL = formSQL.replaceAll(PAY_COMP_SALARY_TAX_SECOND_SLIP, "" + total_tax);
            newTotalTax = total_tax;
        }

        
        if (checkString(formula, PAY_COMP_SALARY_EMP_ENDYEAR_TAX) > -1) {
            double total_tax = TaxCalculator.calcSalaryTax(paySlip.getEmployeeId(), payPeriod, prevPeriod, pajak, null, true);
            formSQL = formSQL.replaceAll(PAY_COMP_SALARY_EMP_ENDYEAR_TAX, "" + total_tax);
            newTotalTax = total_tax;
        }

        if (checkString(formula, PAY_COMP_SALARY_EMP_PREV_ENDYEAR_TAX) > -1) {
            double total_tax = TaxCalculator.calcSalaryTax(paySlip.getEmployeeId(), payPeriod, prevPeriod, pajak, null, true, 1);
            formSQL = formSQL.replaceAll(PAY_COMP_SALARY_EMP_PREV_ENDYEAR_TAX, "" + total_tax);
            newTotalTax = total_tax;
        }

        String sComp = checkStringStart(formula, PAY_COMP_WO_COMP_SALARY_EMP_TAX);
        if (sComp != null && sComp.length() > 0) {
            Vector vComps = listComponent(PAY_COMP_WO_COMP_SALARY_EMP_TAX, sComp, COMP_SPLIT_BY);
            double total_tax = TaxCalculator.calcSalaryTax(paySlip.getEmployeeId(), payPeriod, prevPeriod, pajak, vComps);
            formSQL = formSQL.replaceAll(/*PAY_COMP_SALARY_TAX*/sComp, "" + total_tax);
            newTotalTax = total_tax;
        }

        sComp = checkStringStart(formula, PAY_COMP_WO_COMP_SALARY_EMP_ENDYEAR_TAX);
        if (sComp != null && sComp.length() > 0) {
            Vector vComps = listComponent(PAY_COMP_WO_COMP_SALARY_EMP_ENDYEAR_TAX, sComp, COMP_SPLIT_BY);
            double total_tax = TaxCalculator.calcSalaryTax(paySlip.getEmployeeId(), payPeriod, prevPeriod, pajak, vComps, true);
            formSQL = formSQL.replaceAll(/*PAY_COMP_SALARY_TAX*/sComp, "" + total_tax);
            newTotalTax = total_tax;
        }

        sComp = checkStringStart(formula, PAY_COMP_WO_COMP_SALARY_EMP_PREV_ENDYEAR_TAX);
        if (sComp != null && sComp.length() > 0) {
            Vector vComps = listComponent(PAY_COMP_WO_COMP_SALARY_EMP_PREV_ENDYEAR_TAX, sComp, COMP_SPLIT_BY);
            double total_tax = TaxCalculator.calcSalaryTax(paySlip.getEmployeeId(), payPeriod, prevPeriod, pajak, vComps, true, 1);
            formSQL = formSQL.replaceAll(/*PAY_COMP_SALARY_TAX*/sComp, "" + total_tax);
            newTotalTax = total_tax;
        }

        if (checkString(formula, PAY_COMP_SALARY_TAX_NON_CONT_MONTHLY) > -1) { // update by kartika 2014-11-10
            double total_tax = TaxCalculator.calcSalaryTax_NonContinueMonthly(paySlip.getEmployeeId(), payPeriod, prevPeriod, pajak);
            formSQL = formSQL.replaceAll(PAY_COMP_SALARY_TAX_NON_CONT_MONTHLY, "" + total_tax);
        }

        
        
        
        if (checkString(formula, PAY_COMP_SALARY_PREV2_TAX_NON_CONT_MONTHLY) > -1) { // update by kartika 2015-06-29
            double total_tax = TaxCalculator.calcSalaryTax_NonContinueMonthly(paySlip.getEmployeeId(), payPeriod, prevPeriod, pajak);
            formSQL = formSQL.replaceAll(PAY_COMP_SALARY_PREV2_TAX_NON_CONT_MONTHLY, "" + total_tax);
        }

        if (checkString(formula, PAY_COMP_CALC_MEALS_ALLOWANCE) > -1) {
            //update by satrya 2014-02-07double number_of_meals = PstOvertimeDetail.calcMealsAllowance(paySlip.getEmployeeId(), payPeriod.getOID(), I_DocStatus.DOCUMENT_STATUS_PROCEED,payPeriod.getStartDate(),payPeriod.getEndDate() );
            formSQL = formSQL.replaceAll(PAY_COMP_CALC_MEALS_ALLOWANCE, "" + (paySlip.getMealAllowanceMoneyByForm() + paySlip.getMealAllowanceMoneyAdj()));
        }

        if (checkString(formula, PAY_COMP_GR_UP_SALARY_TAX) > -1) {
            
            String gUPComponent = TaxCalculator.getComponentWithFormula("SALARY_GR_UP_TAX");
            double nilaiGUPTax = TaxCalculator.getGrossUpValue(employee.getOID(), payPeriod, gUPComponent);
            formSQL = formSQL.replaceAll(PAY_COMP_GR_UP_SALARY_TAX, "" + nilaiGUPTax);
        }
        
        if (checkString(formula, PAY_COMP_SECOND_SLIP_GR_UP_SALARY_TAX) > -1) {
            
            String gUPComponent = TaxCalculator.getComponentWithFormula(PAY_COMP_SECOND_SLIP_GR_UP_SALARY_TAX);
            double nilaiGUPTax = TaxCalculator.getGrossUpValueByPayslip(employee.getOID(), paySlip.getOID(), gUPComponent);
            formSQL = formSQL.replaceAll(PAY_COMP_GR_UP_SALARY_TAX, "" + nilaiGUPTax);
        }
        
        if (checkString(formula, SALARY_TAX_NON_RUTIN) > -1) {
            
            String taxNonRutinComp = TaxCalculator.getComponentWithFormula("SALARY_TAX_NON_RUTIN");
            double nilaiTaxNonRutin = TaxCalculator.getTaxNonRutinValue(employee.getOID(), payPeriod, taxNonRutinComp);
            formSQL = formSQL.replaceAll(PAY_COMP_GR_UP_SALARY_TAX, "" + nilaiTaxNonRutin);
        }
        
        if (checkString(formula, SECOND_SLIP_SALARY_TAX_NON_RUTIN) > -1) {
            
            String taxNonRutinComp = TaxCalculator.getComponentWithFormula(SECOND_SLIP_SALARY_TAX_NON_RUTIN);
            double nilaiTaxNonRutin = TaxCalculator.getTaxNonRutinValueByPayslip(employee.getOID(), paySlip.getOID(), taxNonRutinComp);
            formSQL = formSQL.replaceAll(SECOND_SLIP_SALARY_TAX_NON_RUTIN, "" + nilaiTaxNonRutin);
        }
        
        if (checkString(formula, PAY_COMP_DATE_OK) > -1) {

            // double dateOk =  payrollCalculator.calculatePayrollFormula(PAY_COMP_DATE_OK, paySlip.getEmployeeId(),  employee.getDepartmentId(), payPeriod.getOID(), 31, PstEmpSchedule.STATUS_PRESENCE_OK );
            //formSQL = formSQL.replaceAll(PAY_COMP_DATE_OK, "" + dateOk);
            //update by satrya 2013-02-20
            formSQL = formSQL.replaceAll(PAY_COMP_DATE_OK, "" + paySlip.getInsentif());
        }
        if (checkString(formula, GET_VALUE_MAPPING) > -1) {
            //update by priska 2015-01-20
            //formSQL = formSQL.replaceAll(GET_VALUE_MAPPING, "" + (getValuemapping(payPeriod.getStartDate(), payPeriod.getEndDate(), employee.getOID(), salaryComp)));
            /* Value Mapping process is updated by Hendra Putu | 2016-03-06 */
            
            String periodFrom = ""+payPeriod.getStartDate();
            String periodTo = ""+payPeriod.getEndDate();
            String employeeId = ""+employee.getOID();
            String salaryComponent = ""+salaryComp.getCompCode();
            ValueMappingProposional valueMapPro = new ValueMappingProposional();
            formSQL = formSQL.replaceAll(GET_VALUE_MAPPING, "" + (valueMapPro.getValueMappingTotal(periodFrom, periodTo, employeeId, salaryComponent)));
        }

        if (checkString(formula, PAY_COMP_LATE_EARLY) > -1) {
            //update by priska 2015-03-20
            formSQL = formSQL.replaceAll(PAY_COMP_LATE_EARLY, "" + (payInput.getLateEarlyIdx() + payInput.getLateEarlyIdxAdjust()));

        }

        if (checkString(formula, PAY_COMP_EARLY_HOME) > -1) {
            //update by priska 2015-03-20
            formSQL = formSQL.replaceAll(PAY_COMP_EARLY_HOME, "" + (payInput.getEarlyHomeIdx() + payInput.getEarlyHomeIdxAdjust()));

        }

        if (checkString(formula, PAY_COMP_BENEFIT_PART_ONE) > -1) {
            // BENEFIT_PART_1
            double amount = getBenefitEmployee(paySlip.getPeriodId(), employee.getOID(), 1);
            formSQL = formSQL.replaceAll(PAY_COMP_BENEFIT_PART_ONE, "" + amount);
        }

        if (checkString(formula, PAY_COMP_BENEFIT_PART_TWO) > -1) {
            // BENEFIT_PART_2
            double amount = getBenefitEmployee(paySlip.getPeriodId(), employee.getOID(), 2);
            formSQL = formSQL.replaceAll(PAY_COMP_BENEFIT_PART_TWO, "" + amount);
        }
        if (checkString(formula, GET_DAY_PAY_PERIOD) > -1) {
            //update by priska 2015-03-20
            formSQL = formSQL.replaceAll(GET_DAY_PAY_PERIOD, " " + totalHK);
        }

        if (checkString(formula, PAY_COMP_REWARD_PUNISHMENT) > -1) {
            //update by priska 2015-01-20
            formSQL = formSQL.replaceAll(PAY_COMP_REWARD_PUNISHMENT, "" + (PstRewardAndPunishmentDetail.gettotalrewardpunishment(payPeriod.getStartDate(), payPeriod.getEndDate(), employee.getOID())));
        }
        double nilai = PstRewardAndPunishmentDetail.gettotalrewardpunishment(payPeriod.getStartDate(), payPeriod.getEndDate(), employee.getOID());
        if (checkString(formula, PAY_COMP_DATE_OK_WITH_LEAVE) > -1) {

            //double dateOk = PstEmpSchedule.getStatusPresence(paySlip.getEmployeeId(), payPeriod.getOID(), 31, PstEmpSchedule.STATUS_PRESENCE_OK ,null);//di buat nyull dahulu, 20130218
            //formSQL = formSQL.replaceAll(PAY_COMP_DATE_OK_WITH_LEAVE, "" + dateOk);
            //update by satrya 2013-02-20
            formSQL = formSQL.replaceAll(PAY_COMP_DATE_OK_WITH_LEAVE, "" + (paySlip.getDaysOkWithLeave() + payInput.getPresenceOntimeIdxAdjust()));
        }

        //priska
        if (checkString(formula, NPWP) > -1) {
            formSQL = formSQL.replaceAll(NPWP, "" + (getNPWP(employee.getOID())));
        }
        
        //priska
        if (checkString(formula, RESIGN_STATUS) > -1) {
            formSQL = formSQL.replaceAll(RESIGN_STATUS, "" + (employee.getResigned()));
        }
        
        if (checkString(formula, GET_LOS) > -1) {
            formSQL = formSQL.replaceAll(GET_LOS, "" + (get_LOS(employee.getCommencingDate())));
        }
        if (checkString(formula, MEMBER_OF_BPJS_KESEHATAN) > -1) {
            boolean nilaiBPJSKesehatan = false;
            if (employee.getMemOfBpjsKesahatan()==1){
              nilaiBPJSKesehatan = true;  
            }
            formSQL = formSQL.replaceAll(MEMBER_OF_BPJS_KESEHATAN, "" + nilaiBPJSKesehatan);
        }
         if (checkString(formula, MEMBER_OF_BPJS_KETENAGAKERJAAN) > -1) {
              boolean nilaiBPJSKetenagakerjaan = false;
            if (employee.getMemOfBpjsKetenagaKerjaan()==1){
              nilaiBPJSKetenagakerjaan = true;  
            }
            formSQL = formSQL.replaceAll(MEMBER_OF_BPJS_KETENAGAKERJAAN, "" + nilaiBPJSKetenagakerjaan);
        }
        //priska 2015-0723
        if (checkString(formula, UNPAID_LEAVE) > -1) {
            formSQL = formSQL.replaceAll(UNPAID_LEAVE, "" + paySlip.getDayUnpaidLv());
        }

        //priska
        if (checkString(formula, PAY_COMP_DATE_ONLY_IN) > -1) {

            formSQL = formSQL.replaceAll(PAY_COMP_DATE_ONLY_IN, "" + (payInput.getOnlyInIdx() + payInput.getOnlyInIdxAdjust()));
        }
        if (checkString(formula, PAY_COMP_DATE_ONLY_OUT) > -1) {

            formSQL = formSQL.replaceAll(PAY_COMP_DATE_ONLY_OUT, "" + (payInput.getOnlyOutIdx() + payInput.getOnlyOutIdxAdjust()));
        }
        if (checkString(formula, PAY_COMP_NIGHT_ALLOWANCE_IDX) > -1) {
            //update by Hendra 2015-01-24
            //formSQL = formSQL.replaceAll(PAY_COMP_NIGHT_ALLOWANCE_IDX, "" + PstEmpSchedule.);
        }

        if (checkString(formula, GET_AL_ALLOWANCE) > -1) {
            //update by Priska 20150807
			String whereAL = PstLeaveApplication.fieldNames[PstLeaveApplication.FLD_AL_ALLOWANCE]+"= 1 AND "
					+ PstLeaveApplication.fieldNames[PstLeaveApplication.FLD_SUBMISSION_DATE]+" LIKE '%"+(payPeriod.getEndDate().getYear()+1900)+"%' AND "
                                        + PstLeaveApplication.fieldNames[PstLeaveApplication.FLD_EMPLOYEE_ID]+" = '"+employee.getOID()+"'";
			Vector listAl = PstLeaveApplication.list(0, 0, whereAL, "");
			LeaveApplication leaveApplication = new LeaveApplication();
			int al = 0;
			if (listAl.size()>0){
				leaveApplication = (LeaveApplication) listAl.get(0);
                                String whereEmpDoc = PstEmpDoc.fieldNames[PstEmpDoc.FLD_LEAVE_APPLICATION_ID] + " = "+leaveApplication.getOID()+ " AND "
                                        + PstEmpDoc.fieldNames[PstEmpDoc.FLD_DATE_OF_ISSUE]+" BETWEEN '"+Formater.formatDate(payPeriod.getStartDate(), "yyyy-MM-dd")+"' AND "
                                        + "'"+Formater.formatDate(payPeriod.getEndDate(), "yyyy-MM-dd")+"'";
                                Vector listEmpDoc = PstEmpDoc.list(0, 0, whereEmpDoc, "");
                                if (listEmpDoc.size() > 0){
                                    //if (leaveApplication.getPaySlipId() == 0 || leaveApplication.getPaySlipId() == paySlip.getOID()){
					leaveApplication.setPaySlipId(paySlip.getOID());
					try {
						PstLeaveApplication.updateExc(leaveApplication);
					} catch (Exception exc){}
					al = 1;
                                    //}   
                                }
				
			}
            formSQL = formSQL.replaceAll(GET_AL_ALLOWANCE, " " + al);
        }
        
        if (checkString(formula, GET_PERIODE_BEFORE_COMPONENT_VALUE) > -1) {;
            formSQL = formSQL.replaceAll(GET_PERIODE_BEFORE_COMPONENT_VALUE, " " + getBeforePeriodeComponentValue(payPeriod, employee.getOID(), salaryComp.getCompCode()));
        }
        
        if (checkString(formula, GET_ELIGIBLE_LEAVE) > -1) {;
            formSQL = formSQL.replaceAll(GET_ELIGIBLE_LEAVE, " " + SessLeaveApplication.getAlEligbleDay(employee.getOID()));
        }
        
        if (checkString(formula, GET_LL_ALLOWANCE) > -1) {;
            //update by Priska 20150807
			String whereLL = PstLeaveApplication.fieldNames[PstLeaveApplication.FLD_LL_ALLOWANCE]+"= 1 AND "
					+ PstLeaveApplication.fieldNames[PstLeaveApplication.FLD_SUBMISSION_DATE]+" LIKE '%"+(payPeriod.getEndDate().getYear()+1900)+"%'AND "
                                        + PstLeaveApplication.fieldNames[PstLeaveApplication.FLD_EMPLOYEE_ID]+" = '"+employee.getOID()+"'";
			Vector listLl = PstLeaveApplication.list(0, 0, whereLL, "");
			LeaveApplication leaveApplication = new LeaveApplication();
			int ll = 0;
			if (listLl.size()>0){
				leaveApplication = (LeaveApplication) listLl.get(0);
				String whereEmpDoc = PstEmpDoc.fieldNames[PstEmpDoc.FLD_LEAVE_APPLICATION_ID] + " = "+leaveApplication.getOID()+ " AND "
                                        + PstEmpDoc.fieldNames[PstEmpDoc.FLD_DATE_OF_ISSUE]+" BETWEEN '"+Formater.formatDate(payPeriod.getStartDate(), "yyyy-MM-dd")+"' AND "
                                        + "'"+Formater.formatDate(payPeriod.getEndDate(), "yyyy-MM-dd")+"'";
                                Vector listEmpDoc = PstEmpDoc.list(0, 0, whereEmpDoc, "");
                                if (listEmpDoc.size() > 0){
                                    //if (leaveApplication.getPaySlipId() == 0 || leaveApplication.getPaySlipId() == paySlip.getOID()){
					leaveApplication.setPaySlipId(paySlip.getOID());
					try {
						PstLeaveApplication.updateExc(leaveApplication);
					} catch (Exception exc){}
					ll = 1;
                                    //}   
                                }
			}
            formSQL = formSQL.replaceAll(GET_LL_ALLOWANCE, " " + ll);
        }

        if (checkString(formula, tot_ovt) > -1) {
            double total_ovt = PstOvt_Employee.getTotOvtDuration(paySlip.getOID());
            formSQL = formSQL.replaceAll(tot_ovt, "" + (total_ovt + payInput.getOtIdxPaidSalary()));
            //salCompInFormula = salCompInFormula.replaceAll(tot_ovt, "");
        }
        
        if (checkString(formula, GET_HUTANG) > -1) {
            // dedy 20160305
            long dedId = PstPayComponent.getIdName(salaryComp.getCompCode());
            double angsuran = 0;
            Vector listAngsuran = PstArApItem.getTotalAngsuranWithEmp(employee.getOID(), startDate, endDate, dedId);
            if(listAngsuran.size() > 0) {
                ArApItem arapIt = (ArApItem)listAngsuran.get(0);
                angsuran = arapIt.getAngsuran(); 
                /*  20160311 - mengubah status menjadi close stelah diproses
                  arapIt.setArApItemStatus(1);
                try{
                    long oid = PstArApItem.updateExc(arapIt);
                } catch(Exception ec) {

                }*/
            }
            formSQL = formSQL.replaceAll(GET_HUTANG, " " + angsuran);
            
        }

      //  Hashtable symbol = PstScheduleSymbol.getScheduleS(); 
        //  Hashtable schedule = PstScheduleCategory.getScheduleCat();
        //  long oidcat = schedule(0);
//        String oidcat = "504404556096403856" ;
//        String where = (PstScheduleSymbol.FLD_SCHEDULE_CATEGORY_ID = Long.valueOf(oidcat));
//        Vector symbolP = PstScheduleSymbol.listAll();
//        for (int i =0 ; i < symbolP.size(); i++){
//            ScheduleSymbol scheduleSymbol = (ScheduleSymbol) symbolP.get(i);
//            String sSymbol = "SCHEDULE_SYMBOL_"+String.valueOf(scheduleSymbol.getSymbol());
//            if (checkString(formula, sSymbol) > -1) {
//                formSQL = formSQL.replaceAll(sSymbol, "" + (paySlip.getDaysOkWithLeave() + payInput.getPresenceOntimeIdxAdjust()));
//            }
//        }
        
        
        if (formula.contains(GET_SCHEDULE_SYMBOL)){
            int i=0;
            while(true){
                int found = formula.indexOf(GET_SCHEDULE_SYMBOL, i);
                if (found == -1) break;
                int start = found + 20; // start of actual symbol
                int end = formula.indexOf(" ", start);
                String symbol = "";
                
                try {
                    if (end == -1){
                        symbol = formula.substring(start, formula.length());
                    } else {
                        symbol = formula.substring(start, end);                        
                    }
                } catch (Exception exc){
                    System.out.println(exc.toString());
                }
                long oid = PstScheduleSymbol.getScheduleId(symbol);
                ScheduleSymbol scheduleSymbol = new ScheduleSymbol();
                try {
                    scheduleSymbol = PstScheduleSymbol.fetchExc(oid);
                } catch (Exception exc){
                    System.out.println("Exception on PstPayslip GET_SCHEDULE_SYMBOL :" + exc.toString());
                }
                
                long tot = 0;
                for (int k = 0; k < listPeriodDate.size(); k++) {
                    Period period = (Period) listPeriodDate.get(k);
                    tot = tot + PstEmpSchedule.sumScheduleSymbolPerEmployee(period.getOID(), employee.getOID(), startDate, endDate, scheduleSymbol.getOID(), k, listPeriodDate.size());
                }
                formSQL = formSQL.replaceAll(GET_SCHEDULE_SYMBOL+symbol, "" + (tot));
                if (end == -1){
                    i = formula.length()+1;
                } else {
                    i= end+1;    
                }
                
            }
        }
        
        if (formula.contains(GET_POTONGAN_KREDIT)){
            String whereConfig = PstPayConfigPotongan.fieldNames[PstPayConfigPotongan.FLD_EMPLOYEE_ID]+"="+employee.getOID();
            whereConfig += " AND " + PstPayConfigPotongan.fieldNames[PstPayConfigPotongan.FLD_VALID_STATUS]+"=1";
            whereConfig += " AND " + PstPayConfigPotongan.fieldNames[PstPayConfigPotongan.FLD_COMPONENT_ID]+"= "+ salaryComp.getComponentId();
            Vector payConfigList = PstPayConfigPotongan.list(0, 0, whereConfig, "");
            if (payConfigList != null && payConfigList.size()>0){
                PayConfigPotongan configPot = (PayConfigPotongan)payConfigList.get(0);
                formSQL = formSQL.replaceAll(GET_POTONGAN_KREDIT, "" + configPot.getAngsuranPerbulan());

            }
        }
        
        if (formula.contains(GET_WITHOUT_LEAVE_SCHEDULE_SYMBOL)){
            int i=0;
            while(true){
                int found = formula.indexOf(GET_WITHOUT_LEAVE_SCHEDULE_SYMBOL, i);
                if (found == -1) break;
                int start = found + 34; // start of actual symbol
                int end = formula.indexOf(" ", start);
                String symbol = "";
                
                try {
                    if (end == -1){
                        symbol = formula.substring(start, formula.length());
                    } else {
                        symbol = formula.substring(start, end);                        
                    }
                } catch (Exception exc){
                    System.out.println(exc.toString());
                }
                long oid = PstScheduleSymbol.getScheduleId(symbol);
                ScheduleSymbol scheduleSymbol = new ScheduleSymbol();
                try {
                    scheduleSymbol = PstScheduleSymbol.fetchExc(oid);
                } catch (Exception exc){
                    System.out.println("Exception on PstPayslip GET_WITHOUT_LEAVE_SCHEDULE_SYMBOL :" + exc.toString());
                }
                
                long tot = 0;
                for (int k = 0; k < listPeriodDate.size(); k++) {
                    Period period = (Period) listPeriodDate.get(k);
                    tot = tot + PstEmpSchedule.sumScheduleSymbolPerEmployeeWOLeave(period.getOID(), employee.getOID(), startDate, endDate, scheduleSymbol.getOID(), k, listPeriodDate.size());
                }
                formSQL = formSQL.replaceAll(GET_WITHOUT_LEAVE_SCHEDULE_SYMBOL+symbol, "" + (tot));
                if (end == -1){
                    i = formula.length()+1;
                } else {
                    i= end+1;    
                }
                
            }
        }
        
		if (formula.contains(GET_WITHOUT_LEAVE_SCHEDULE_SYMBOL)){
            int i=0;
            while(true){
                int found = formula.indexOf(GET_WITHOUT_LEAVE_SCHEDULE_SYMBOL, i);
                if (found == -1) break;
                int start = found + 34; // start of actual symbol
                int end = formula.indexOf(" ", start);
                String symbol = "";
                
                try {
                    if (end == -1){
                        symbol = formula.substring(start, formula.length());
                    } else {
                        symbol = formula.substring(start, end);                        
                    }
                } catch (Exception exc){
                    System.out.println(exc.toString());
                }
                long oid = PstScheduleSymbol.getScheduleId(symbol);
                ScheduleSymbol scheduleSymbol = new ScheduleSymbol();
                try {
                    scheduleSymbol = PstScheduleSymbol.fetchExc(oid);
                } catch (Exception exc){
                    System.out.println("Exception on PstPayslip GET_WITHOUT_LEAVE_SCHEDULE_SYMBOL :" + exc.toString());
                }
                
                long tot = 0;
                for (int k = 0; k < listPeriodDate.size(); k++) {
                    Period period = (Period) listPeriodDate.get(k);
                    tot = tot + PstEmpSchedule.sumScheduleSymbolPerEmployeeWOLeave(period.getOID(), employee.getOID(), startDate, endDate, scheduleSymbol.getOID(), k, listPeriodDate.size());
                }
                formSQL = formSQL.replaceAll(GET_WITHOUT_LEAVE_SCHEDULE_SYMBOL+symbol, "" + (tot));
                if (end == -1){
                    i = formula.length()+1;
                } else {
                    i= end+1;    
                }
                
            }
        }
		
		if (formula.contains(GET_SCH_MEAL_ALLOWANCE_WITH_DURATION)){
			double total = 0;
			int workDays = 0;
			if (payPeriod.getStartDate() != null && payPeriod.getEndDate() != null) {
				
				ValueMappingProposional valueMapPro = new ValueMappingProposional();
				double valMapping = valueMapPro.getValueMappingTotal(""+payPeriod.getStartDate(), ""+payPeriod.getEndDate(), ""+employee.getOID(), salaryComp.getCompCode());
				
				
				Date fromDate = payPeriod.getStartDate();
				Date toDate = payPeriod.getEndDate();
				if (fromDate.getTime() > toDate.getTime()) {
					Date tempFromDate = fromDate;
					Date tempToDate = toDate;
					fromDate = tempToDate;
					toDate = tempFromDate;
				}
				
				long diffStartToFinish = toDate.getTime() - fromDate.getTime();
				int itDate = Integer.parseInt(String.valueOf(diffStartToFinish / 86400000));
				for (int i = 0; i <= itDate; i++) {
					if (workDays >= payPeriod.getWorkDays()){
						continue;
					}
					Date selectedDate = new Date(fromDate.getTime() + i * 1000L * 60 * 60 * 24);
					
					Vector listAttendanceRecordDailly = SessEmpSchedule.listEmpPresenceDaily(0, selectedDate, selectedDate, 0, employee.getEmployeeNum(), employee.getFullName(), "", 0, 0,null,0,"",0,0,0);
					if (listAttendanceRecordDailly.size() > 0){
						PresenceReportDaily presenceReportDaily = (PresenceReportDaily) listAttendanceRecordDailly.get(0);

						Date dtActualIn1st = (Date) presenceReportDaily.getActualIn1st();
						Date dtActualOut1st = (Date) presenceReportDaily.getActualOut1st();
						Date dtSchldIn1st = (Date) presenceReportDaily.getScheduleIn1st();
						Date dtSchldOut1st = (Date) presenceReportDaily.getScheduleOut1st();
						int status = presenceReportDaily.getPresenceStatus();
						
						long diffIn = 0;
						long diffOut = 0;
						long diffMendahului = 0;
						
						if (dtActualIn1st != null && dtSchldIn1st != null){
							diffIn = dtSchldIn1st.getTime() - dtActualIn1st.getTime();
						}
						
						if (dtActualOut1st != null && dtSchldOut1st != null){
							diffOut = dtActualOut1st.getTime() - dtSchldOut1st.getTime();
						}
						
						String batasMendahului = "13:00:00";
						String strMendahului = Formater.formatDate(selectedDate, "yyyy-MM-dd")+" "+batasMendahului;
						try {
							SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
							Date dtMendahului = format.parse(strMendahului);
							if (dtActualOut1st != null){
								diffMendahului = dtActualOut1st.getTime() - dtMendahului.getTime();
							}
						} catch (Exception exc){}
						
						ScheduleSymbol scheduleSymbol = new ScheduleSymbol();
						try {
							scheduleSymbol = PstScheduleSymbol.fetchExc(presenceReportDaily.getScheduleId1());
						} catch (Exception exc){}
						
                                                double workTime = scheduleSymbol.getWorkDuration();
                                                
						switch(scheduleSymbol.getPerhitunganUangMakan()){
							case PstScheduleSymbol.UANG_MAKAN_FULL:
								
								Calendar c = Calendar.getInstance();
								c.setTime(selectedDate);
								boolean PH = false;
								if (Calendar.SATURDAY != c.get(Calendar.DAY_OF_WEEK) && Calendar.SUNDAY != c.get(Calendar.DAY_OF_WEEK)){
									PH = PstPublicHolidays.isPublicHoliday(employee, selectedDate);
									if (PH){
										continue;
									}
								} else {
									continue;
								}
								
								total = total + valMapping;
								workDays++;
								break;
								
							case PstScheduleSymbol.UANG_MAKAN_BY_TIME:
								workDays++;
								if (dtActualIn1st == null){
									total = total + 0;
								} else if (diffIn < 0 && dtActualOut1st == null){
									if (dtSchldOut1st!=null){
										long diffMinutes = TimeUnit.MILLISECONDS.toMinutes(dtSchldOut1st.getTime() - dtActualIn1st.getTime());//(dtSchldOut1st.getTime() - dtActualIn1st.getTime()) / (60 * 1000) % 60;
										double value = (valMapping - ((25.0/100.0) * valMapping)) * ((diffMinutes - 60.0) / workTime);
										total = total + (Math.round(value) * (50.0/100.0));
									}
								} else if (dtActualOut1st == null){
									total = total + (valMapping * (50.0/100.0));
								} else if (diffMendahului < 0){
									total = total + 0;
								} else if (diffIn < 0 && diffOut < 0){
									if (dtSchldOut1st!=null){
										long diffMinutes = TimeUnit.MILLISECONDS.toMinutes(dtActualOut1st.getTime() - dtActualIn1st.getTime());//(dtSchldOut1st.getTime() - dtActualIn1st.getTime()) / (60 * 1000) % 60;
										double value = ((valMapping - ((25.0/100.0) * valMapping)) * ((diffMinutes - 60.0) / workTime)) * (50.0 /100.0);
										total = total + Math.round(value);
									}
								} else if (diffIn < 0 && diffOut >= 0){
									if (dtSchldOut1st!=null){
										long diffMinutes = TimeUnit.MILLISECONDS.toMinutes(dtSchldOut1st.getTime() - dtActualIn1st.getTime());//(dtSchldOut1st.getTime() - dtActualIn1st.getTime()) / (60 * 1000) % 60;
										double value = (valMapping - ((25.0/100.0) * valMapping)) * ((diffMinutes - 60.0) / workTime);
										total = total + Math.round(value);
									}
								}  else if (diffOut < 0){
									total = total + (valMapping * (50.0/100.0));
								} else {
									total = total + valMapping;
								}
								break;
								
							case PstScheduleSymbol.UANG_MAKAN_FAKULTATIF:
                                                               workDays++;
								if (dtActualIn1st != null || dtActualOut1st != null){
									total = total + valMapping;
								}
								break;
								
							case PstScheduleSymbol.UANG_MAKAN_JAM_MURNI:
								workDays++;
								if (dtActualIn1st == null){
									total = total + 0;
								} else if (diffIn < 0 && dtActualOut1st == null){
									if (dtSchldOut1st!=null){
										long diffMinutes = TimeUnit.MILLISECONDS.toMinutes(dtSchldOut1st.getTime() - dtActualIn1st.getTime());//(dtSchldOut1st.getTime() - dtActualIn1st.getTime()) / (60 * 1000) % 60;
										double value = (valMapping - ((25.0/100.0) * valMapping)) * ((diffMinutes - 60.0) / workTime);
										total = total + (Math.round(value) * (50.0/100.0));
									}
								} else if (dtActualOut1st == null){
									total = total + (valMapping * (50.0/100.0));
								} else if (diffMendahului < 0){
									total = total + 0;
								} else if (diffIn < 0 && diffOut < 0){
									total = total + 0;
								} else if (diffIn < 0 && diffOut >= 0){
									if (dtSchldOut1st!=null){
										long diffMinutes = TimeUnit.MILLISECONDS.toMinutes(dtSchldOut1st.getTime() - dtActualIn1st.getTime());//(dtSchldOut1st.getTime() - dtActualIn1st.getTime()) / (60 * 1000) % 60;
										double value = (valMapping - ((25.0/100.0) * valMapping)) * ((diffMinutes - 60.0) / workTime);
										total = total + Math.round(value);
									}
								}  else if (diffOut < 0){
									total = total + 0;
								} else {
									total = total + valMapping;
								}
								break;
                                                                
                                                        case PstScheduleSymbol.UANG_MAKAN_NO_REST:
								workDays++;
								if (dtActualIn1st == null){
									total = total + 0;
								} else if (diffIn < 0 && dtActualOut1st == null){
									if (dtSchldIn1st!=null){
										long diffMinutes = TimeUnit.MILLISECONDS.toMinutes(dtActualIn1st.getTime() - dtSchldIn1st.getTime());//(dtSchldOut1st.getTime() - dtActualIn1st.getTime()) / (60 * 1000) % 60;
										double value = (valMapping - ((25.0/100.0) * valMapping)) * ((workTime - diffMinutes) / workTime);
										total = total + (Math.round(value) * (50.0/100.0));
									}
								} else if (dtActualOut1st == null){
									total = total + (valMapping * (50.0/100.0));
								} else if (diffMendahului < 0){
									total = total + 0;
								} else if (diffIn < 0 && diffOut < 0){
									total = total + 0;
								} else if (diffIn < 0 && diffOut >= 0){
									if (dtSchldIn1st!=null){
										long diffMinutes = TimeUnit.MILLISECONDS.toMinutes(dtActualIn1st.getTime() - dtSchldIn1st.getTime());//(dtSchldOut1st.getTime() - dtActualIn1st.getTime()) / (60 * 1000) % 60;
										double value = (valMapping - ((25.0/100.0) * valMapping)) * ((workTime - diffMinutes) / workTime);
										total = total + Math.round(value);
									}
								}  else if (diffOut < 0){
									total = total + (valMapping * (50.0/100.0));
								} else {
									total = total + valMapping;
								}
								break;
						}
						
						
						
					}
				}
			}
			formSQL = formSQL.replaceAll(GET_SCH_MEAL_ALLOWANCE_WITH_DURATION, "" + (total));
		}
		
		if (formula.contains(GET_WITH_DAY_OFF_WITHOUT_LEAVE_SCHEDULE_SYMBOL)){
            int i=0;
            while(true){
                int found = formula.indexOf(GET_WITH_DAY_OFF_WITHOUT_LEAVE_SCHEDULE_SYMBOL, i);
                if (found == -1) break;
                int start = found + 47; // start of actual symbol
                int end = formula.indexOf(" ", start);
                String symbol = "";
                
                try {
                    if (end == -1){
                        symbol = formula.substring(start, formula.length());
                    } else {
                        symbol = formula.substring(start, end);                        
                    }
                } catch (Exception exc){
                    System.out.println(exc.toString());
                }
                long oid = PstScheduleSymbol.getScheduleId(symbol);
                ScheduleSymbol scheduleSymbol = new ScheduleSymbol();
                try {
                    scheduleSymbol = PstScheduleSymbol.fetchExc(oid);
                } catch (Exception exc){
                    System.out.println("Exception on PstPayslip GET_WITH_DAY_OFF_WITHOUT_LEAVE_SCHEDULE_SYMBOL :" + exc.toString());
                }
                
                long tot = 0;
                for (int k = 0; k < listPeriodDate.size(); k++) {
                    Period period = (Period) listPeriodDate.get(k);
                    tot = tot + PstEmpSchedule.sumScheduleSymbolPerEmployeeWOLeaveWithOff(period.getOID(), employee.getOID(), startDate, endDate, scheduleSymbol.getOID(), k, listPeriodDate.size());
                }
                formSQL = formSQL.replaceAll(GET_WITH_DAY_OFF_WITHOUT_LEAVE_SCHEDULE_SYMBOL+symbol, "" + (tot));
                if (end == -1){
                    i = formula.length()+1;
                } else {
                    i= end+1;    
                }
                
            }
        }
        
        if (formula.contains(GET_COMPONENT_VALUE)){
            int i=0;
            while(true){
                int found = formula.indexOf(GET_COMPONENT_VALUE, i);
                if (found == -1) break;
                int start = found + 20; // start of actual symbol
                int end = formula.indexOf(" ", start);
                String payCom = "";
                
                try {
                    if (end == -1){
                        payCom = formula.substring(start, formula.length());
                    } else {
                        payCom = formula.substring(start, end);                        
                    }
                } catch (Exception exc){
                    System.out.println(exc.toString());
                }
                
                
                double compValue = PstPaySlipComp.getCompValueEmployeeDouble(employee.getOID(), payPeriod.getOID(), payCom);
                formSQL = formSQL.replaceAll(GET_COMPONENT_VALUE+payCom, "" + compValue);
                if (end == -1){
                    i = formula.length()+1;
                } else {
                    i= end+1;    
                }
                
            }
        }
        
        if (formula.contains(GET_PREV_PERIOD_COMP_VALUE)){
            int i=0;
            while(true){
                int found = formula.indexOf(GET_PREV_PERIOD_COMP_VALUE, i);
                if (found == -1) break;
                int start = found + 27; // start of actual symbol
                int end = formula.indexOf(" ", start);
                String payCom = "";
                
                try {
                    if (end == -1){
                        payCom = formula.substring(start, formula.length());
                    } else {
                        payCom = formula.substring(start, end);                        
                    }
                } catch (Exception exc){
                    System.out.println(exc.toString());
                }
                
                
                double compValue = PstPaySlipComp.getCompValueEmployeeDouble(employee.getOID(), prevPeriod.getOID(), payCom);
                formSQL = formSQL.replaceAll(GET_PREV_PERIOD_COMP_VALUE+payCom, "" + compValue);
                if (end == -1){
                    i = formula.length()+1;
                } else {
                    i= end+1;    
                }
                
            }
        }
        
        /* update by priska 2015-03-05 */
//        Vector symbolP = PstScheduleSymbol.listAll();
//        for (int i = 0; i < symbolP.size(); i++) {
//            ScheduleSymbol scheduleSymbol = (ScheduleSymbol) symbolP.get(i);
//            String sSymbol = "" + String.valueOf(scheduleSymbol.getSymbol());
//            if (checkString(formula, sSymbol) > -1) {
//                long tot = 0;
//                for (int k = 0; k < listPeriodDate.size(); k++) {
//                    Period period = (Period) listPeriodDate.get(k);
//                    tot = tot + PstEmpSchedule.sumScheduleSymbolPerEmployee(period.getOID(), employee.getOID(), startDate, endDate, scheduleSymbol.getOID(), k, listPeriodDate.size());
//
//                }
//
//                formSQL = formSQL.replaceAll(sSymbol, "" + (tot));
//            } else if (checkString (formula, sSymbol+"_WITHOUT_LEAVE") >-1) {
//                long tot = 0;
//                for (int k = 0; k < listPeriodDate.size(); k++) {
//                    Period period = (Period) listPeriodDate.get(k);
//                    tot = tot + PstEmpSchedule.sumScheduleSymbolPerEmployeeWOLeave(period.getOID(), employee.getOID(), startDate, endDate, scheduleSymbol.getOID(), k, listPeriodDate.size());
//
//                }
//
//                formSQL = formSQL.replaceAll(sSymbol+"_WITHOUT_LEAVE", "" + (tot));
//            }
//        }
        
        if (formula.contains("GET_VALUE_MAPPING_RAPEL")){
            String payComp = "";
            try {
                payComp = formula.replace("= GET_VALUE_MAPPING_RAPEL_", "");
            } catch (Exception exc){
                
            }
            
            if (!payComp.equals("")) {
                ValueMappingProposional valueMapPro = new ValueMappingProposional();
                double compRapel = valueMapPro.getRapelValMap(employee.getOID(), payComp, payPeriod.getOID());
                String strCompValue = String.valueOf(compRapel);
                formSQL = formSQL.toUpperCase().replaceAll("GET_VALUE_MAPPING_RAPEL_"+payComp, "" + compRapel);
            }
        }
        
        if (formula.contains("GET_RAPEL")){
            String payComp = "";
            try {
                payComp = formula.replace("= GET_RAPEL_", "");
            } catch (Exception exc){
                
            }
            
            if (!payComp.equals("")) {
                ValueMappingProposional valueMapPro = new ValueMappingProposional();
                double compRapel = valueMapPro.getRapel(employee.getOID(), payComp, payPeriod.getOID());
                String strCompValue = String.valueOf(compRapel);
                formSQL = formSQL.toUpperCase().replaceAll("GET_RAPEL_"+payComp, "" + compRapel);
            }
        }
        
        if (formula.contains("GET_OVERTIME_PERIOD")){
            int startDay = 0;
            int endDay = 0;
			String strStartDay = "";
			String strEndDay = "";
            try {
				strStartDay = formula.substring(formula.indexOf("START#")+6, formula.lastIndexOf("#_"));
                startDay = Integer.valueOf(formula.substring(formula.indexOf("START#")+6, formula.lastIndexOf("#_")));
            } catch (Exception exc){

            }
            
            try {
				strEndDay = formula.substring(formula.indexOf("END#")+4, formula.lastIndexOf("#"));
                endDay = Integer.valueOf(formula.substring(formula.indexOf("END#")+4, formula.lastIndexOf("#")));                
            } catch (Exception exc){

            }
            
            Calendar calStart = Calendar.getInstance();
            calStart.setTime(payPeriod.getStartDate());
            if (startDay > endDay){
                calStart.add(Calendar.MONTH, -1);
            }
            calStart.set(Calendar.DAY_OF_MONTH, startDay);
            
            Calendar calEnd = Calendar.getInstance();
            calEnd.setTime(payPeriod.getEndDate());
            calEnd.set(Calendar.DAY_OF_MONTH, endDay);
            
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            String strStart = sdf.format(calStart.getTime());
            String strEnd = sdf.format(calEnd.getTime());
            double value = PstOvertimeDetail.getOvertimeTotal(employee.getOID(), strStart, strEnd);
            formSQL = formSQL.toUpperCase().replaceAll("GET_OVERTIME_PERIOD_START#"+strStartDay+"#_END#"+strEndDay+"#", ""+value);
            
        }
        
//        if (salComponent != null && salComponent.size() > 0) {
//            for (int is = 0; is < salComponent.size(); is++) {
//                String payCom = (String) salComponent.get(is);
//                if (payCom != null && payCom.length() > 1) {
//                    double compValuePrev = PstPaySlipComp.getCompValueEmployeeDouble(employee.getOID(), prevPeriod.getOID(), payCom);
//                    String strCompValue = String.valueOf(compValuePrev);
//                    formSQL = formSQL.toUpperCase().replaceAll("GET_PREV_PERIOD_"+payCom, "" + compValuePrev);
//                    
//                }
//            }
//        }
//
//        if (salComponent != null && salComponent.size() > 0) {
//            for (int is = 0; is < salComponent.size(); is++) {
//                String payCom = (String) salComponent.get(is);
//                if (payCom != null && payCom.length() > 1) {
//                    //int countComp = PstPaySlipComp.countCodeComponent(payCom);
//                    //if (countComp> 0) {
//                    double compValue = PstPaySlipComp.getCompValueEmployeeDouble(employee.getOID(), payPeriod.getOID(), payCom);
//                    String strCompValue = String.valueOf(compValue);
//                    formSQL = formSQL.toUpperCase().replaceAll(payCom, "" + compValue);
//                    //} else {
//                    //message= message + "Comp. Code not found : "+payCom;
//                    //}
//                }
//            }
//        }
        /*
         Vector vectToken = new Vector();
         StringTokenizer tokenSpace = new StringTokenizer(salCompInFormula, "");
         while (tokenSpace.hasMoreTokens()) {
         String compToken = (String) tokenSpace.nextToken();
         StringTokenizer token = new StringTokenizer(salCompInFormula, "=");
         while (token.hasMoreTokens()) {
         compToken = (String) token.nextToken();
         StringTokenizer tokenFormula2 = new StringTokenizer(compToken, "(");
         while (tokenFormula2.hasMoreTokens()) {
         compToken = (String) tokenFormula2.nextToken();
         StringTokenizer tokenFormula3 = new StringTokenizer(compToken, ")");
         while (tokenFormula3.hasMoreTokens()) {
         compToken = (String) tokenFormula3.nextToken();
         StringTokenizer tokenFormula4 = new StringTokenizer(compToken, "*");
         while (tokenFormula4.hasMoreTokens()) {
         compToken = (String) tokenFormula4.nextToken();
         StringTokenizer tokenFormula5 = new StringTokenizer(compToken, "/");
         while (tokenFormula5.hasMoreTokens()) {
         compToken = (String) tokenFormula5.nextToken();
         StringTokenizer tokenFormula6 = new StringTokenizer(compToken, "+");
         while (tokenFormula6.hasMoreTokens()) {
         compToken = (String) tokenFormula6.nextToken();
         StringTokenizer tokenFormula = new StringTokenizer(compToken, "-");
         while (tokenFormula.hasMoreTokens()) {
         compToken = (String) tokenFormula.nextToken();
         vectToken.add(compToken);
         //System.out.println("vectToken "+vectToken);
         }
         }
         }
         }
         }
         }
         }
         }

         if (vectToken.size() > 1) { // jika token masih ada 
         //untuk pengambilan komponent             
         for (int ixt = 0; ixt < vectToken.size(); ixt++) {
         String payCom = (String) vectToken.get(ixt);
         if (payCom.length() > 1) {
         String payCompSpace = PstPaySlipComp.getCodeComponent(payCom);
         if (payCompSpace.length() > 0) {
         double compValue = PstPaySlipComp.getCompValueEmployeeDouble(employee.getOID(), period.getOID(), payCom);
         String strCompValue = String.valueOf(compValue);
         formSQL = formSQL.replaceAll(payCom, "" + payCom);
         }
         }

         }
         }
         * */

//        int proporsional = PstPayComponent.getProporsional(salaryComp.getCompCode());
//
//        if (proporsional == PstPayComponent.YES_PROPORSIONAL_BY_WORKDAYS) {
//            formula = formula + " / " + dayTotalperPeriod + "  *  DATE_PRESENT ";
//        } else if (proporsional == PstPayComponent.YES_PROPORSIONAL_BY_COMENCING_AND_RESIGNED) {
//            Date getcommencingdate = employee.getCommencingDate();
//            Date getresignedate = employee.getResignedDate();
//            if ((getcommencingdate != null && payPeriod.getStartDate() != null && payPeriod.getEndDate() != null) && (((getcommencingdate.getTime() >= payPeriod.getStartDate().getTime()) && (getcommencingdate.getTime() <= payPeriod.getEndDate().getTime())))) {
//                long daytime = payPeriod.getEndDate().getTime() - getcommencingdate.getTime();
//                double dayD = daytime / (1000 * 60 * 60 * 24);
//
//                formSQL = " " + formSQL + " / " + dayTotalperPeriod + " * " + (dayD + 1);
//
//            } else if (((getresignedate != null && payPeriod.getStartDate() != null && payPeriod.getEndDate() != null)) && (((getresignedate.getTime() >= payPeriod.getStartDate().getTime()) && (getresignedate.getTime() <= payPeriod.getEndDate().getTime())))) {
//                long daytime = getresignedate.getTime() - payPeriod.getStartDate().getTime();
//                double dayD = daytime / (1000 * 60 * 60 * 24);
//                formSQL = " " + formSQL + " / " + dayTotalperPeriod + " * " + (dayD + 1);
//
//            }
//        }

        // lempar ke MySQL
        // System.out.println("formSQL  " + salaryComp.getFormula() + " >> " + formSQL);
        formSQL = formSQL.trim();
        if (formSQL.startsWith("=")) {
            formSQL = formSQL.substring(1);
        }
        String tmpMessage = "";
        double compFormValue = PstPaySlipComp.getCompFormValue(formSQL, tmpMessage);
        message = message + "/" + tmpMessage;
       // if (compFormValue < 0.0) {  /// component gaji hanya positif : nanti sbg penambah atau pengurang dari tipe componentnya
        //     compFormValue = 0.0;
        // }
        String strSubCompValue = "";
        int countPaySlip = getCountPaySlip(payPeriod.getOID(), employee.getOID());
        // hasil ecexute mysql simpan ke tabel pay_slip_comp
        PaySlipComp paySlipComp = new PaySlipComp();
        
        long paySlipId = 0;
        if (countPaySlip > 1){
            boolean isSecondPayslip = PstPayComponent.isSecondPayslip(salaryComp.getCompCode());
            if (isSecondPayslip){
                long oidSecondPaySlip = getSecondPaySlipId(payPeriod.getOID(), employee.getOID());
                paySlipComp.setPaySlipId(oidSecondPaySlip);
                paySlipId = oidSecondPaySlip;
            } else {
               paySlipComp.setPaySlipId(paySlip.getOID()); 
               paySlipId = paySlip.getOID();
            }
        } else {
           paySlipComp.setPaySlipId(paySlip.getOID());   
           paySlipId = paySlip.getOID();
        }

        paySlipComp.setCompCode(salaryComp.getCompCode());
        if (salaryComp.getCompCode().equals("PPH21")) {
            compFormValue = newTotalTax;
        }
        //Add by Gunadi 05/08/2016
        int typeOfDecimalFormat = 0;
        String whereClause = PstPayComponent.fieldNames[PstPayComponent.FLD_COMP_CODE]+"='"+salaryComp.getCompCode()+"'";
        Vector listComponent = PstPayComponent.list(0, 1, whereClause, "");
        if (listComponent != null && listComponent.size()>0){
            PayComponent payComp = (PayComponent)listComponent.get(0);
            typeOfDecimalFormat = payComp.getDecimalFormat();
        }
        
        switch(typeOfDecimalFormat){
            case 0:
                break;
            case 1:
                compFormValue = customFormat("###.#", compFormValue);
                break;
            case 2:
                compFormValue = customFormat("###.##", compFormValue);
                break; 
            case 3:
                compFormValue = customFormat("###.###", compFormValue);
                break;
            case 4:
                compFormValue = convertInteger(0, compFormValue);
                break;
            case 5:
                compFormValue = convertInteger(-1, compFormValue);
                break;
            case 6:
                compFormValue = convertInteger(-2, compFormValue);
                break; 
            case 7:
                compFormValue = convertInteger(-3, compFormValue);
                break;
        }
        
        paySlipComp.setCompValue(compFormValue);
        String whereSlip = PstPaySlipComp.fieldNames[PstPaySlipComp.FLD_PAY_SLIP_ID] + "=" + paySlipId
                + " AND " + PstPaySlipComp.fieldNames[PstPaySlipComp.FLD_COMP_CODE] + "='" + salaryComp.getCompCode().trim() + "'";
        Vector vectSlipComp = PstPaySlipComp.list(0, 0, whereSlip, "");

        try {
            if (vectSlipComp.size() == 0) {
                PstPaySlipComp.insertExc(paySlipComp);
            } else if (vectSlipComp.size() > 0) {
                PstPaySlipComp.updateValueComp(compFormValue, whereSlip);
            }
        } catch (Exception e) {
            System.out.println("ERR" + e.toString());
        }
        return message;

    }

    /**
     * Check apakah ada dalam components yang merupakan component rumus
     * standard/terdifinisi di harisma
     *
     * @param components
     * @return
     */
    public static int checkComponentFormula(Vector components) {
        int found = -1;
        if (components != null) {
            for (int i = 0; i < components.size(); i++) {
                try {
                    String comp = ((String) components.get(i)).trim();
                    if (PAY_COMP_SALARY_TAX.equalsIgnoreCase(comp)) {
                        return i;
                    }
                    if (PAY_COMP_SALARY_TAX_NON_CONT_MONTHLY.equalsIgnoreCase(comp)) {
                        return i;
                    }
                    if (PAY_COMP_OVERTIME_IDX.equalsIgnoreCase(comp)) {
                        return i;
                    }
                } catch (Exception exc) {
                    System.out.println();
                }
            }
        }
        return found;
    }

    public static int checkString(String strObject, String toCheck) {
        if (toCheck == null || strObject == null) {
            return -1;
        }
        if (strObject.startsWith("=")) {
            strObject = strObject.substring(1);
        }

        String[] parts = strObject.split(" ");
        if (parts.length > 0) {
            for (int i = 0; i < parts.length; i++) {
                String p = parts[i];
                if (toCheck.trim().equalsIgnoreCase(p.trim())) {
                    return i;
                };
            }
        }
        return -1;
    }

    public static Vector listComponent(String compName, String formulaPart, String sPartBy) {
        Vector vLsitComp = null;
        if (compName == null || formulaPart == null) {
            return null;
        }
        compName = compName.trim();
        formulaPart = formulaPart.trim();
        if (formulaPart.startsWith(compName)) {
            String[] parts = formulaPart.split(sPartBy);
            if (parts.length > 0) {
                vLsitComp = new Vector();
                for (int i = 1; i < parts.length; i++) {
                    vLsitComp.add(parts[i]);
                }
            }
        }
        return vLsitComp;
    }

    public static String checkStringStart(String strObject, String toCheck) {
        if (toCheck == null || strObject == null) {
            return null;
        }
        if (strObject.startsWith("=")) {
            strObject = strObject.substring(1);
        }

        String[] parts = strObject.split(" ");
        if (parts.length > 0) {
            for (int i = 0; i < parts.length; i++) {
                String p = parts[i];
                if (p.trim().startsWith(toCheck.trim())) {
                    return p.trim();
                };
            }
        }
        return null;
    }

    /**
     * create by satrya 2014-02-07
     *
     * @param note
     * @param oidPayslip
     */
    public synchronized static void updateNote(String note, long oidPayslip) {
        try {
            String sql = " UPDATE " + PstPaySlip.TBL_PAY_SLIP
                    + " SET " + PstPaySlip.fieldNames[PstPaySlip.FLD_NOTE_ADMIN] + "=\"" + note + "\""
                    + " WHERE " + PstPaySlip.fieldNames[PstPaySlip.FLD_PAY_SLIP_ID] + "=" + oidPayslip;

            int i = DBHandler.execUpdate(sql);

        } catch (Exception e) {
            System.out.println("Exception " + e.toString());
        }

    }

    public static Hashtable<String, String> prevPrivateNotePaySlip(long departmentName, long companyId, long divisionId, String levelCode, long sectionName, String searchNrFrom, String searchNrTo, String searchName, long periodId, int dataStatus, int isChekedRadioButtonSearchNr, String searchNr) {
        DBResultSet dbrs = null;
        Hashtable hashListPrivNote = new Hashtable();

        if (departmentName == 0 && levelCode.equals("") && sectionName == 0 && searchNrFrom == null && searchNrTo == null && searchName == null && periodId == 0 && dataStatus == 0) {
            return hashListPrivNote;
        }
        try {
            String sql = " SELECT distinct "
                    + " PAY." + PstPaySlip.fieldNames[PstPaySlip.FLD_PAY_SLIP_ID]
                    + ", PAY." + PstPaySlip.fieldNames[PstPaySlip.FLD_PRIVATE_NOTE]
                    + " FROM " + PstEmployee.TBL_HR_EMPLOYEE + " AS EMP"
                    + " INNER JOIN " + PstPaySlip.TBL_PAY_SLIP + " AS PAY"
                    + " ON EMP." + PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID]
                    + " = PAY." + PstPaySlip.fieldNames[PstPaySlip.FLD_EMPLOYEE_ID]
                    + " INNER JOIN " + PstPayEmpLevel.TBL_PAY_EMP_LEVEL + " AS LEV"
                    + " ON EMP." + PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID]
                    + " = LEV." + PstPayEmpLevel.fieldNames[PstPayEmpLevel.FLD_EMPLOYEE_ID]
                    + " INNER JOIN " + PstPosition.TBL_HR_POSITION + " AS POS ON EMP." + PstEmployee.fieldNames[PstEmployee.FLD_POSITION_ID]
                    + " = POS." + PstPosition.fieldNames[PstPosition.FLD_POSITION_ID]
                    + " WHERE EMP." + PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID] + "!=0"
                    + " AND LEV." + PstPayEmpLevel.fieldNames[PstPayEmpLevel.FLD_STATUS_DATA]
                    + "=" + PstPayEmpLevel.CURRENT
                    + " AND EMP." + PstEmployee.fieldNames[PstEmployee.FLD_RESIGNED] + "=" + PstEmployee.STS_COMMING;

            String whereClause = "";

            if (departmentName > 0) {
                whereClause = whereClause + " EMP." + PstEmployee.fieldNames[PstEmployee.FLD_DEPARTMENT_ID]
                        + " = " + departmentName + " AND ";
            }

            if (levelCode != null && !levelCode.equals("") && !levelCode.equals("0")) {
                whereClause = whereClause + " LEV." + PstPayEmpLevel.fieldNames[PstPayEmpLevel.FLD_LEVEL_CODE]
                        + " LIKE '%" + levelCode.trim() + "%' AND ";
            }

            if (sectionName > 0) {
                whereClause = whereClause + " EMP." + PstEmployee.fieldNames[PstEmployee.FLD_SECTION_ID]
                        + " = " + sectionName + " AND ";

            }

            //update by satrya 2014-02-03
            if (companyId != 0) {
                whereClause = whereClause + " EMP." + PstEmployee.fieldNames[PstEmployee.FLD_COMPANY_ID]
                        + " = " + companyId + " AND ";
            }
            //update by satrya 2014-02-03
            if (divisionId != 0) {
                whereClause = whereClause + " EMP." + PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID]
                        + " = " + divisionId + " AND ";
            }
            if (periodId != 0) {
                whereClause = whereClause + " PAY." + PstPaySlip.fieldNames[PstPaySlip.FLD_PERIOD_ID]
                        + " = " + periodId + " AND ";

            }

            if (isChekedRadioButtonSearchNr == 1) {
                if (searchNr != null && searchNr.length() > 0) {
                    if (searchNr != null && searchNr != "") {
                        //                sql = sql + " AND " + PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_NUM]
                        //                        + " = " + "\"" + empNumId.trim() + "\"";//penambahan trima
                        Vector vectNum = logicParser(searchNr);
                        sql = sql + " AND ";
                        if (vectNum != null && vectNum.size() > 0) {
                            sql = sql + " (";
                            for (int i = 0; i < vectNum.size(); i++) {
                                String str = (String) vectNum.get(i);
                                if (!LogicParser.isInSign(str) && !LogicParser.isInLogEnglish(str)) {
                                    sql = sql + " EMP." + PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_NUM]
                                            + " LIKE '%" + str.trim() + "%' ";
                                } else {
                                    sql = sql + str.trim();
                                }
                            }
                            sql = sql + ")";
                        }

                    }
                }
            } else {
                if ((searchNrFrom != null) && (searchNrFrom.length() > 0)) {
                    if (searchNrTo == null || searchNrTo.length() == 0) {
                        searchNrTo = searchNrFrom;
                    }
                    Vector vectNrFrom = logicParser(searchNrFrom);
                    if (vectNrFrom != null && vectNrFrom.size() > 0) {
                        whereClause = whereClause + " (";
                        for (int i = 0; i < vectNrFrom.size(); i++) {
                            String str = (String) vectNrFrom.get(i);
                            if (!LogicParser.isInSign(str) && !LogicParser.isInLogEnglish(str)) {
                                whereClause = whereClause + " EMP." + PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_NUM]
                                        + " BETWEEN '" + searchNrFrom + "' AND '" + searchNrTo + "'";
                            } else {
                                whereClause = whereClause + str.trim();
                            }
                        }
                        whereClause = whereClause + ") AND ";
                    }

                }
            }

            if ((searchName != null) && (searchName.length() > 0)) {
                Vector vectName = logicParser(searchName);
                if (vectName != null && vectName.size() > 0) {
                    whereClause = whereClause + " (";
                    for (int i = 0; i < vectName.size(); i++) {
                        String str = (String) vectName.get(i);
                        if (!LogicParser.isInSign(str) && !LogicParser.isInLogEnglish(str)) {
                            whereClause = whereClause + " EMP." + PstEmployee.fieldNames[PstEmployee.FLD_FULL_NAME]
                                    + " LIKE '%" + str.trim() + "%' ";
                        } else {
                            whereClause = whereClause + str.trim();
                        }
                    }
                    whereClause = whereClause + ") AND ";
                }

            }

            if (dataStatus < 2) {
                whereClause = whereClause + " PAY." + PstPaySlip.fieldNames[PstPaySlip.FLD_STATUS]
                        + " = " + dataStatus + " AND ";

            }

            if (whereClause != null && whereClause.length() > 0) {
                whereClause = " AND " + whereClause.substring(0, whereClause.length() - 4);
                sql = sql + whereClause;
                //sql = sql + " WHERE " + whereClause;
            }

            sql = sql + " GROUP BY EMP." + PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID];

            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                String privNote = rs.getString(PstPaySlip.fieldNames[PstPaySlip.FLD_PRIVATE_NOTE]);
                hashListPrivNote.put("" + (rs.getLong(PstPaySlip.fieldNames[PstPaySlip.FLD_PAY_SLIP_ID])), privNote == null ? "" : privNote.trim());
            }

        } catch (Exception e) {
            System.out.println("\t Exception on  searchEmployee : " + e);
        } finally {
            DBResultSet.close(dbrs);
            return hashListPrivNote;
        }

    }

    /**
     * Keterangan: untuk melampilkan list pay slip ot idx salary dan ot
     * allowance money create by satrya 2014-05-06
     *
     * @param selectedDateFrom
     * @param selectedDateTo
     * @param getListEmployeeId
     * @return
     */
    public static Hashtable listPaySlip(Date selectedDateFrom, Date selectedDateTo, String getListEmployeeId) {
        Hashtable hashListPayInput = new Hashtable();
        if (selectedDateFrom == null || selectedDateTo == null || getListEmployeeId == null || getListEmployeeId.length() == 0) {
            return hashListPayInput;
        }
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT * FROM " + TBL_PAY_SLIP
                    + " WHERE (" + fieldNames[FLD_OV_IDX_PAID_SALARY_ADJUSMENT_DATE] + " BETWEEN \"" + Formater.formatDate(selectedDateFrom, "yyyy-MM-dd") + "\" AND \"" + Formater.formatDate(selectedDateTo, "yyyy-MM-dd") + "\" OR " + fieldNames[FLD_OV_MEAL_ALLOWANCE_MONEY_ADJ_DATE] + " BETWEEN \"" + Formater.formatDate(selectedDateFrom, "yyyy-MM-dd") + "\" AND \"" + Formater.formatDate(selectedDateTo, "yyyy-MM-dd") + "\") "
                    + " AND " + fieldNames[FLD_EMPLOYEE_ID] + " IN(" + getListEmployeeId + ")";

            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                double valueAdjOtIdx = rs.getDouble(fieldNames[FLD_OV_IDX_ADJUSTMENT]);
                double valueAdjMealAllowance = rs.getDouble(fieldNames[FLD_MEAL_ALLOWANCE_MONEY_ADJUSMENT]);
                String sOtIdxAdj = (fieldNames[FLD_OV_IDX_ADJUSTMENT]) + "_" + rs.getLong(fieldNames[FLD_EMPLOYEE_ID]) + "_" + rs.getDate(fieldNames[FLD_OV_IDX_PAID_SALARY_ADJUSMENT_DATE]);
                String sOtMealsAllowanceAdj = (fieldNames[FLD_MEAL_ALLOWANCE_MONEY_ADJUSMENT]) + "_" + rs.getLong(fieldNames[FLD_EMPLOYEE_ID]) + "_" + rs.getDate(fieldNames[FLD_OV_MEAL_ALLOWANCE_MONEY_ADJ_DATE]);
                hashListPayInput.put(sOtIdxAdj, valueAdjOtIdx);
                hashListPayInput.put(sOtMealsAllowanceAdj, valueAdjMealAllowance);
            }

            rs.close();

        } catch (Exception e) {
        } finally {
            DBResultSet.close(dbrs);
            return hashListPayInput;
        }
    }
    /*
     * Date : 2015-03-09
     * Author : Hendra Putu
     */

    public static double getBenefitEmployee(long periodId, long employeeId, int part) {
        double amount = 0;
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT pay_period.PERIOD_ID, hr_employee.EMPLOYEE_ID, ";
            sql += " pay_benefit_period_emp.AMOUNT_PART_1, ";
            sql += " pay_benefit_period_emp.AMOUNT_PART_2 FROM pay_benefit_period_emp ";
            sql += " INNER JOIN hr_employee ON pay_benefit_period_emp.EMPLOYEE_ID=hr_employee.EMPLOYEE_ID ";
            sql += " INNER JOIN pay_benefit_period ON pay_benefit_period_emp.BENEFIT_PERIOD_ID=pay_benefit_period.BENEFIT_PERIOD_ID ";
            sql += " INNER JOIN pay_period ON pay_benefit_period.PERIOD_ID=pay_period.PERIOD_ID ";
            sql += " WHERE pay_period.PERIOD_ID=" + periodId + " AND hr_employee.EMPLOYEE_ID=" + employeeId + " ";

            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                if (part == 1) {
                    amount = rs.getDouble(PstBenefitPeriodEmp.fieldNames[PstBenefitPeriodEmp.FLD_AMOUNT_PART_1]);
                } else {
                    amount = rs.getDouble(PstBenefitPeriodEmp.fieldNames[PstBenefitPeriodEmp.FLD_AMOUNT_PART_2]);
                }
            }
            rs.close();
            return amount;

        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return amount;
    }

    
    /*
     * Date : 2015-12-17
     * Author : Ganki Priska
     */

    public static Date getFirstPayslipDate( long employeeId, String tahun) {
        Date dateS = null;
        DBResultSet dbrs = null;
        try {
            String sql = " SELECT pp.`END_DATE` FROM  `pay_slip` ps ";
                    sql = sql + "INNER JOIN `pay_period` pp ON pp.`PERIOD_ID` = ps.`PERIOD_ID`"; 
                    sql = sql + "WHERE ps.`EMPLOYEE_ID` = " + employeeId + " AND pp.`PAY_SLIP_DATE` LIKE '%" + tahun + "%' ORDER BY pp.`START_DATE` DESC ";

            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
               dateS = rs.getDate(1);
            }
            rs.close();
            return dateS;

        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return dateS;
    }
    
    public static Date getEndPayslipDate( long employeeId, String Tahun ) {
        Date dateS = null;
        DBResultSet dbrs = null;
        try {
            String sql = " SELECT pp.`END_DATE` FROM  `pay_slip` ps ";
                    sql = sql + "INNER JOIN `pay_period` pp ON pp.`PERIOD_ID` = ps.`PERIOD_ID`"; 
                    sql = sql + "WHERE ps.`EMPLOYEE_ID` = " + employeeId + " AND pp.`PAY_SLIP_DATE` LIKE '%" + Tahun + "%' ORDER BY pp.`START_DATE` ASC ";

            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
               dateS = rs.getDate(1);
            }
            rs.close();
            return dateS;

        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return dateS;
    }
    
    
    
       public static Long getLastPaySlipPeriodId( long employeeId, String Tahun ) {
        long periodId = 0;
        DBResultSet dbrs = null;
        try {
            String sql = " SELECT pp.PERIOD_ID FROM  `pay_slip` ps ";
                    sql = sql + "INNER JOIN `pay_period` pp ON pp.`PERIOD_ID` = ps.`PERIOD_ID`"; 
                    sql = sql + "WHERE ps.`EMPLOYEE_ID` = " + employeeId + " AND pp.`PAY_SLIP_DATE` LIKE '%" + Tahun + "%' ORDER BY pp.`START_DATE` ASC ";

            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
               periodId = rs.getLong(1);
            }
            rs.close();
            return periodId;

        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return periodId;
    }
    
    public static int getJumlahPayslip( long employeeId, String Tahun ) {
        int nilai = 0;
        DBResultSet dbrs = null;
        try {
            String sql = " SELECT  COUNT(pp.`START_DATE`) FROM  `pay_slip` ps ";
                    sql = sql + "INNER JOIN `pay_period` pp ON pp.`PERIOD_ID` = ps.`PERIOD_ID`"; 
                    sql = sql + "WHERE ps.`EMPLOYEE_ID` = " + employeeId + " AND pp.`PAY_SLIP_DATE` LIKE '%" + Tahun + "%' ORDER BY pp.`START_DATE` DESC ";

            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
               nilai = rs.getInt(1);
            }
            if (nilai > 12){
                nilai =12;
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
    
    public static int getJumlahPayslip( long employeeId, PayPeriod payPeriod ) {
        int nilai = 0;
        int tahun = payPeriod.getEndDate().getYear()+1900;
        DBResultSet dbrs = null;
        try {
            String sql = " SELECT  COUNT(pp.`START_DATE`) FROM  `pay_slip` ps ";
                    sql = sql + "INNER JOIN `pay_period` pp ON pp.`PERIOD_ID` = ps.`PERIOD_ID`"; 
                    sql = sql + "WHERE ps.`EMPLOYEE_ID` = " + employeeId + " AND pp.`PAY_SLIP_DATE` LIKE '%" + tahun + "%' AND   pp.`PAY_SLIP_DATE` <= '"  + payPeriod.getEndDate() +  "' ORDER BY pp.`START_DATE` DESC ";

            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
               nilai = rs.getInt(1);
            }
            if (nilai > 12){
                nilai =12;
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
    
    public static Vector<PayComponentValue> getAllDetailSalary(long oidPeriod, long employee_id, String where, String orderBy) {
        DBResultSet dbrs = null;
        Vector<PayComponentValue> vDetailSum = new Vector<PayComponentValue>();
        try {
            String sql = "SELECT PAY.* " //+", LEV." + PstSalaryLevelDetail.fieldNames[PstSalaryLevelDetail.FLD_TAKE_HOME_PAY]+ ",LEV." + PstSalaryLevelDetail.fieldNames[PstSalaryLevelDetail.FLD_FORMULA]
                    + " , COMP." + PstPaySlipComp.fieldNames[PstPaySlipComp.FLD_COMP_VALUE] + " FROM "
                    + PstPaySlip.TBL_PAY_SLIP + " AS SLIP"
                    + " INNER JOIN " + PstPaySlipComp.TBL_PAY_SLIP_COMP + " AS COMP "
                    + " ON SLIP." + PstPaySlip.fieldNames[PstPaySlip.FLD_PAY_SLIP_ID]
                    + " = COMP." + PstPaySlipComp.fieldNames[PstPaySlipComp.FLD_PAY_SLIP_ID]
                    + " INNER JOIN " + PstPayComponent.TBL_PAY_COMPONENT + " AS PAY"
                    + " ON COMP." + PstPaySlipComp.fieldNames[PstPaySlipComp.FLD_COMP_CODE]
                    + " = PAY." + PstPayComponent.fieldNames[PstPayComponent.FLD_COMP_CODE]
                  /*  + " LEFT JOIN " + PstSalaryLevelDetail.TBL_PAY_LEVEL_COM + " AS LEV"
                    + " ON COMP." + PstPaySlipComp.fieldNames[PstPaySlipComp.FLD_COMP_CODE]
                    + " = LEV." + PstPayComponent.fieldNames[PstPayComponent.FLD_COMP_CODE]*/
                    + " WHERE SLIP." + PstPaySlip.fieldNames[PstPaySlip.FLD_PERIOD_ID]
                    + " = " + oidPeriod
                    + " AND SLIP." + PstPaySlip.fieldNames[PstPaySlip.FLD_EMPLOYEE_ID]
                    + " = " + employee_id
                    + (where != null && where.length() > 0 ? (" AND "+ where ): "")
                    + ( (orderBy==null || orderBy.length()<1) ? (" ORDER BY " + PstPayComponent.fieldNames[PstPayComponent.FLD_COMP_TYPE] + "," + PstPayComponent.fieldNames[PstPayComponent.FLD_COMP_CODE] ): orderBy);
            //System.out.println("SQL getSumSalary" + sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                PayComponentValue payComponent = new PayComponentValue();
                payComponent.setOID(rs.getLong(PstPayComponent.fieldNames[PstPayComponent.FLD_COMPONENT_ID]));
                payComponent.setCompCode(rs.getString(PstPayComponent.fieldNames[PstPayComponent.FLD_COMP_CODE]));
                payComponent.setCompType(rs.getInt(PstPayComponent.fieldNames[PstPayComponent.FLD_COMP_TYPE]));
                payComponent.setSortIdx(rs.getInt(PstPayComponent.fieldNames[PstPayComponent.FLD_SORT_IDX]));
                payComponent.setCompName(rs.getString(PstPayComponent.fieldNames[PstPayComponent.FLD_COMP_NAME]));
                payComponent.setYearAccumlt(rs.getInt(PstPayComponent.fieldNames[PstPayComponent.FLD_YEAR_ACCUMLT]));
                payComponent.setPayPeriod(rs.getInt(PstPayComponent.fieldNames[PstPayComponent.FLD_PAY_PERIOD]));
                payComponent.setUsedInForml(rs.getInt(PstPayComponent.fieldNames[PstPayComponent.FLD_USED_IN_FORML]));
                payComponent.setTaxItem(rs.getInt(PstPayComponent.fieldNames[PstPayComponent.FLD_TAX_ITEM]));
                payComponent.setTypeTunjangan(rs.getInt(PstPayComponent.fieldNames[PstPayComponent.FLD_TYPE_TUNJANGAN]));
                //update by satrya 2013-01-24
                payComponent.setPayslipGroupId(rs.getLong(PstPayComponent.fieldNames[PstPayComponent.FLD_PAYSLIP_GROUP_ID]));
                //update by satrya 20130206
                payComponent.setShowpayslip(rs.getInt(PstPayComponent.fieldNames[PstPayComponent.FLD_SHOW_PAYSLIP]));
                //update by satrya 2014-12-30
                payComponent.setShowinreports(rs.getInt(PstPayComponent.fieldNames[PstPayComponent.FLD_SHOW_IN_REPORTS]));
                payComponent.setProporsionalCalculate(rs.getInt(PstPayComponent.fieldNames[PstPayComponent.FLD_PROPORSIONAL_CALCULATE]));
                //Kartika 2015-09-02 / 20
                payComponent.setTaxRptGroup(rs.getInt(PstPayComponent.fieldNames[PstPayComponent.FLD_TAX_RPT_GROUP]));
                payComponent.setCheckValue(rs.getDouble(PstPaySlipComp.fieldNames[PstPaySlipComp.FLD_COMP_VALUE])); // payComponent.setTakeHomePay(rs.getInt(PstSalaryLevelDetail.fieldNames[PstSalaryLevelDetail.FLD_TAKE_HOME_PAY]));
               // payComponent.setFormula(rs.getString(PstSalaryLevelDetail.fieldNames[PstSalaryLevelDetail.FLD_FORMULA]));
                vDetailSum.add(payComponent);
            }
            rs.close();
            return vDetailSum;
        } catch (Exception e) {
            return null;
        } finally {
            DBResultSet.close(dbrs);
        }
    }

    /* Update by Hendra Putu | 2016-08-12 */
    public static void generatePaySlip(long periodId, Vector listEmpLevel, JspWriter output) {
        PayPeriod periodGenerate = new PayPeriod();
		PayPeriod prevGeneratePeriod = new PayPeriod();
        if (periodId != 0) {
            try {
                periodGenerate = PstPayPeriod.fetchExc(periodId);
				prevGeneratePeriod = PstPayPeriod.getPreviousPayPeriod(periodId);
            } catch (Exception e) {
            }
        }
        if (listEmpLevel != null && listEmpLevel.size() > 0) {
            for (int i = 0; i < listEmpLevel.size(); i++) {
                Long empId = (Long) listEmpLevel.get(i);                
                
                
                Employee employee = new Employee();
                try {
                    employee = PstEmployee.fetchExc(empId);
                } catch (Exception e) {
                    System.out.println(e.toString());
                }
                try {
                    output.print("<div>["+(i+1)+"] NRK : "+employee.getEmployeeNum()+"</div>");
                } catch (IOException e) {
                    System.out.println(e.toString());
                }
                String companyName = "";
                String divisionName = "";
                String departmentName = "";
                String sectionName = "";
                String positionName = "";
                String gradeCode = "";
//==============================================================================
                String dateFrom = ""+periodGenerate.getStartDate();
                String dateTo  = ""+periodGenerate.getEndDate();
                String[] arrDFrom = dateFrom.split("-");
                String[] arrDTo = dateTo.split("-");
                int intPeriodFrom = Integer.valueOf(arrDFrom[0] + arrDFrom[1] + arrDFrom[2]);
                int intPeriodTo = Integer.valueOf(arrDTo[0] + arrDTo[1] + arrDTo[2]);
                String strBiner = "";
                int[] biner = new int[8];
				Vector listComponent = PstPayComponent.list(0, 0, "", "");
				if (periodGenerate.getFirstPeriodOfTheYear() == 1){
                String whereClause = PstCareerPath.fieldNames[PstCareerPath.FLD_EMPLOYEE_ID]+"="+employee.getOID();
                whereClause += " AND ("+PstCareerPath.fieldNames[PstCareerPath.FLD_HISTORY_TYPE]+"="+PstCareerPath.CAREER_TYPE;
					whereClause += " OR "+PstCareerPath.fieldNames[PstCareerPath.FLD_HISTORY_TYPE]+"="+PstCareerPath.PEJABAT_SEMENTARA_TYPE;
					whereClause += " OR "+PstCareerPath.fieldNames[PstCareerPath.FLD_HISTORY_TYPE]+"="+PstCareerPath.OJT_TYPE +")";
					whereClause += " AND ("+PstCareerPath.fieldNames[PstCareerPath.FLD_WORK_TO]+" BETWEEN '"+dateFrom+"' AND '"+dateTo+"' ";
					whereClause += " OR "+PstCareerPath.fieldNames[PstCareerPath.FLD_WORK_TO]+" = '"+Formater.formatDate(prevGeneratePeriod.getEndDate(),
									"yyyy")+"-12-31')";
					Vector listCareer = PstCareerPath.listView(0, 0, whereClause, "");
					if (listCareer != null && listCareer.size()>0){
						CareerPath careerPrev = (CareerPath) listCareer.get(0);
						String whereNextCareer = PstCareerPath.fieldNames[PstCareerPath.FLD_EMPLOYEE_ID]+"="+employee.getOID();
						whereNextCareer += " AND "+PstCareerPath.fieldNames[PstCareerPath.FLD_HISTORY_GROUP]+"="+PstCareerPath.RIWAYAT_JABATAN;
						whereNextCareer += " AND ("+PstCareerPath.fieldNames[PstCareerPath.FLD_HISTORY_TYPE]+"="+PstCareerPath.CAREER_TYPE;
						whereNextCareer += " OR "+PstCareerPath.fieldNames[PstCareerPath.FLD_HISTORY_TYPE]+"="+PstCareerPath.PEJABAT_SEMENTARA_TYPE;
						whereNextCareer += " OR "+PstCareerPath.fieldNames[PstCareerPath.FLD_HISTORY_TYPE]+"="+PstCareerPath.OJT_TYPE+")";
						whereNextCareer += " AND "+PstCareerPath.fieldNames[PstCareerPath.FLD_WORK_FROM]+" = DATE_ADD('"+careerPrev.getWorkTo()+"', INTERVAL 1 DAY)";
						Vector listCareerNow = PstCareerPath.list(0, 0, whereNextCareer, "");
						if (listCareerNow.size()>0){
							CareerPath careerNow = (CareerPath) listCareerNow.get(0);
							companyName = careerNow.getCompany();
                            divisionName = careerNow.getDivision();
                            departmentName = careerNow.getDepartment();
                            sectionName = careerNow.getSection();
                            positionName = careerNow.getPosition();
                            gradeCode = getGradeCode(careerNow.getGradeLevelId());
						} else {
							try {
								Company company = PstCompany.fetchExc(employee.getCompanyId());
								Division divisi = PstDivision.fetchExc(employee.getDivisionId());
								Department depart = PstDepartment.fetchExc(employee.getDepartmentId());
								Section sect = PstSection.fetchExc(employee.getSectionId());
								Position pos = PstPosition.fetchExc(employee.getPositionId());
								companyName = company.getCompany();
								divisionName = divisi.getDivision();
								departmentName = depart.getDepartment();
								sectionName = sect.getSection();
								positionName = pos.getPosition();
								gradeCode = getGradeCode(employee.getGradeLevelId());
							} catch(Exception e){
								System.out.println("cari ke databank =>"+e.toString());
							}
						}
					}
				} else {
				
					String whereClause = PstCareerPath.fieldNames[PstCareerPath.FLD_EMPLOYEE_ID]+"="+employee.getOID();
					whereClause += " AND "+PstCareerPath.fieldNames[PstCareerPath.FLD_HISTORY_GROUP]+"="+PstCareerPath.RIWAYAT_JABATAN;
					whereClause += " AND ("+PstCareerPath.fieldNames[PstCareerPath.FLD_HISTORY_TYPE]+"="+PstCareerPath.CAREER_TYPE;
					whereClause += " OR "+PstCareerPath.fieldNames[PstCareerPath.FLD_HISTORY_TYPE]+"="+PstCareerPath.PEJABAT_SEMENTARA_TYPE;
					whereClause += " OR "+PstCareerPath.fieldNames[PstCareerPath.FLD_HISTORY_TYPE]+"="+PstCareerPath.OJT_TYPE+ ")";
                String orderBy = PstCareerPath.fieldNames[PstCareerPath.FLD_WORK_FROM];
                Vector listCareer = PstCareerPath.list(0, 0, whereClause, orderBy);
                if (listCareer != null && listCareer.size()>0){
                    for(int c = 0; c < listCareer.size(); c++){
                        CareerPath career = (CareerPath)listCareer.get(c);
                        String workFrom = ""+career.getWorkFrom();
                        String workTo = ""+career.getWorkTo();
                        String[] arrWorkFrom = workFrom.split("-");
                        String[] arrWorkTo = workTo.split("-");
                        int intWorkFrom = Integer.valueOf(arrWorkFrom[0] + arrWorkFrom[1] + arrWorkFrom[2]);
                        int intWorkTo = Integer.valueOf(arrWorkTo[0] + arrWorkTo[1] + arrWorkTo[2]);
                        for(int b=0; b<biner.length; b++){
                            biner[b] = 0;
                        }
                        strBiner = "";
                        if (intWorkFrom > intPeriodFrom){
                            biner[0] = 1;
                        } else { /* intWorkFrom < intPeriodFrom */
                            biner[1] = 1;
                        }
                        if (intWorkFrom > intPeriodTo){
                            biner[2] = 1;
                        } else { /* intWorkFrom < intPeriodTo */
                            biner[3] = 1;
                        }

                        if (intWorkTo > intPeriodFrom){
                            biner[4] = 1;
                        } else { /* intWorkTo < intPeriodFrom */
                            biner[5] = 1;
                        }
                        if (intWorkTo > intPeriodTo){
                            biner[6] = 1;
                        } else { /* intWorkTo < intPeriodTo */
                            biner[7] = 1;
                        }

                        for(int b=0; b<biner.length; b++){
                            strBiner = strBiner + biner[b];
                        }
                        if (strBiner.equals("10011001")){
                            /*
                             * Pf ===================== Pt
                             *      Sd =========== Ed
                             */
                            companyName = career.getCompany();
                            divisionName = career.getDivision();
                            departmentName = career.getDepartment();
                            sectionName = career.getSection();
                            positionName = career.getPosition();
                            gradeCode = getGradeCode(career.getGradeLevelId());
                            break;
                        }
                        if (strBiner.equals("01011010")){
                            /*
                             *      Pf ======= Pt
                             * Sd ================== Ed
                             */
                            companyName = career.getCompany();
                            divisionName = career.getDivision();
                            departmentName = career.getDepartment();
                            sectionName = career.getSection();
                            positionName = career.getPosition();
                            gradeCode = getGradeCode(career.getGradeLevelId());
                            break;
                        }
                        if (strBiner.equals("10011010")){
                            /* 
                             * Pf ================== Pt
                             *          Sd ================ Ed
                             */
                            companyName = career.getCompany();
                            divisionName = career.getDivision();
                            departmentName = career.getDepartment();
                            sectionName = career.getSection();
                            positionName = career.getPosition();
                            gradeCode = getGradeCode(career.getGradeLevelId());
                            break;
                        }
                        if (strBiner.equals("01011001")){
                            /*
                             *          Pf ============ Pt
                             * Sd ============= Ed
                             */
                            companyName = career.getCompany();
                            divisionName = career.getDivision();
                            departmentName = career.getDepartment();
                            sectionName = career.getSection();
                            positionName = career.getPosition();
                            gradeCode = getGradeCode(career.getGradeLevelId());
                            break;
                        }
                        if (strBiner.equals("01010101")){
                            /*
                             *              Pf ========== Pt
                             * Sd ===== Ed
                             */
                            //output = "<div>Kondisi ke-5:</div>";
                            //output += "<div>Cari ke databank</div>";
                            try {
                                Company company = PstCompany.fetchExc(employee.getCompanyId());
                                Division divisi = PstDivision.fetchExc(employee.getDivisionId());
                                Department depart = PstDepartment.fetchExc(employee.getDepartmentId());
                                Section sect = PstSection.fetchExc(employee.getSectionId());
                                Position pos = PstPosition.fetchExc(employee.getPositionId());
                                companyName = company.getCompany();
                                divisionName = divisi.getDivision();
                                departmentName = depart.getDepartment();
                                sectionName = sect.getSection();
                                positionName = pos.getPosition();
                                gradeCode = getGradeCode(employee.getGradeLevelId());
                            } catch(Exception e){
                                System.out.println("cari ke databank =>"+e.toString());
                            }
                        }
                        if (strBiner.equals("10101010")){
                            /* 
                             * Pf ========== Pt
                             *                  Sd ========= Ed
                             */
                            ///output  = "<div>Kondisi ke-6:</div>";
                        }
                    }
                } else {
                    /* Jika karir history kosong, maka ambil karir sekarang */
                    try {
                        Company company = PstCompany.fetchExc(employee.getCompanyId());
                        Division divisi = PstDivision.fetchExc(employee.getDivisionId());
                        Department depart = PstDepartment.fetchExc(employee.getDepartmentId());
                        Section sect = PstSection.fetchExc(employee.getSectionId());
                        Position pos = PstPosition.fetchExc(employee.getPositionId());
                        companyName = company.getCompany();
                        divisionName = divisi.getDivision();
                        departmentName = depart.getDepartment();
                        sectionName = sect.getSection();
                        positionName = pos.getPosition();
                        gradeCode = getGradeCode(employee.getGradeLevelId());
                    } catch(Exception e){
                        System.out.println("cari ke databank =>"+e.toString());
                }
                }
				}
//==============================================================================
                /* proses insert ke paySlip dan paySlipComponent */

                PaySlip paySlip = new PaySlip();
                paySlip.setEmployeeId(employee.getOID());
                paySlip.setPeriodId(periodGenerate.getOID());
                if (employee.getCommencingDate() != null){
                paySlip.setCommencDate(employee.getCommencingDate());
                } else {
                    paySlip.setCommencDate(periodGenerate.getStartDate());
                }
                
                paySlip.setPaySlipDate(periodGenerate.getPaySlipDate());
                paySlip.setCompCode(companyName);
                paySlip.setDivision(divisionName);
                paySlip.setDepartment(departmentName);
                paySlip.setSection(sectionName);
                paySlip.setPosition(positionName);
                paySlip.setGradeCode(gradeCode);
                
                try {
                    long oidPaySlip = getPaySlipId(periodGenerate.getOID(), employee.getOID());
                    if (oidPaySlip != 0) {
                        /* update paySlip */
                        paySlip.setOID(oidPaySlip);
                        Date now = new Date();
                        paySlip.setStatus(0);
                        paySlip.setPaidStatus(0);
                        paySlip.setPaySlipDate(now);
                        paySlip.setDayPresent(0);
                        paySlip.setDayPaidLv(0);
                        paySlip.setDayAbsent(0);
                        paySlip.setDayUnpaidLv(0);
                        paySlip.setNote("-");
                        if (employee.getCommencingDate() != null){
                            paySlip.setCommencDate(employee.getCommencingDate());
                        } else {
                            paySlip.setCommencDate(periodGenerate.getStartDate());
                        }
                        paySlip.setPaymentType(0);
                        paySlip.setBankId(0);
                        paySlip.setPaySlipType(0);
                        paySlip.setDayLate(0);
                        paySlip.setProcentasePresence(0);
                        paySlip.setOvIdxAdj(0);
                        paySlip.setPrivateNote("-");
                        paySlip.setMealAllowanceMoneyByForm(0);
                        paySlip.setMealAllowanceMoneyAdj(0);
                        paySlip.setOvertimeIdxByForm(0);
                        paySlip.setNoteAdmin("-");
                        paySlip.setOvIdxPaidBySalaryAdjDt(now);
                        paySlip.setOvAllowanceMoneyAdjDt(now);
                        long oidUp = updateExc(paySlip);
                        /* cek jumlah componen di pay slip component */
                        String whereClause = PstPaySlipComp.fieldNames[PstPaySlipComp.FLD_PAY_SLIP_ID]+"="+oidPaySlip;
                        Vector listPaySlipComp = PstPaySlipComp.list(0, 0, whereClause, "");
                        /* gak usah di kosongkan */
//                        if (listPaySlipComp != null && listComponent != null){
//                            try {
//                                long oidDelete = PstPaySlipComp.deleteByPaySlipId(oidPaySlip);
//                            } catch (Exception e){
//                                System.out.print("delete payslipcomp=>"+e.toString());
//                            }
//                            if (listPaySlipComp.size() != listComponent.size()){
//                                for (int com = 0; com < listComponent.size(); com++) {
//                                    PayComponent payComp = (PayComponent) listComponent.get(com);
//                                    PaySlipComp paySlipCompData = new PaySlipComp();
//                                    paySlipCompData.setCompCode(payComp.getCompCode());
//                                    paySlipCompData.setCompValue(0);
//                                    paySlipCompData.setPaySlipId(oidPaySlip);
//                                    try {
//                                        long oidPaySlipComp = PstPaySlipComp.insertExc(paySlipCompData);
//                                    } catch(Exception e){
//                                        System.out.print("insert payslipcomp=>"+e.toString());
//                                    }
//                                }
//                            }
//                        }
                    } else {
                        /* insert paySlip */
                        long oid = insertExc(paySlip);
                        if (listComponent != null && listComponent.size() > 0) {
                            for (int com = 0; com < listComponent.size(); com++) {
                                PayComponent payComp = (PayComponent) listComponent.get(com);
                                PaySlipComp paySlipCompData = new PaySlipComp();
                                paySlipCompData.setCompCode(payComp.getCompCode());
                                paySlipCompData.setCompValue(0);
                                paySlipCompData.setPaySlipId(oid);
                                long oidPaySlipComp = PstPaySlipComp.insertExc(paySlipCompData);
                            }
                        }
                    }
                    
                } catch (Exception e) {
                    System.out.println("generatePaySlip: insertExcWithDetail : " + e.toString());
                }
                
                //Membuat PaySlip lagi jika Karyawan Mutasi
                long oidSecondSlipDiv = 0;
                try {
                    oidSecondSlipDiv = Long.valueOf(PstSystemProperty.getValueByName("SECOND_SLIP_DIVISION_ID"));
                } catch (Exception e){
                    System.out.println("oidSecondSlipDiv : " + e.toString());
                }
                
                String wherePrev = "WHERE "+PstCareerPath.fieldNames[PstCareerPath.FLD_WORK_FROM]+" BETWEEN '"+Formater.formatDate(periodGenerate.getStartDate(), "yyyy-MM-dd")+"'"
                                + " AND '"+Formater.formatDate(periodGenerate.getEndDate(), "yyyy-MM-dd")+"' AND "+PstCareerPath.fieldNames[PstCareerPath.FLD_EMPLOYEE_ID]+" = "+empId
                                + " AND "+PstCareerPath.fieldNames[PstCareerPath.FLD_DIVISION_ID]+" = "+oidSecondSlipDiv;
                Vector listCareerMBT = PstCareerPath.listCareerUnionDatabank(wherePrev);
                
                if (listCareerMBT.size()>0){
                    String companyNameMBT = "";
                    String divisionNameMBT = "";
                    String departmentNameMBT = "";
                    String sectionNameMBT = "";
                    String positionNameMBT = "";
                    String gradeCodeMBT = "";
                    for (int x=0; x < listCareerMBT.size(); x++){
                        CareerPath careerPath = (CareerPath) listCareerMBT.get(i);
                        if (careerPath.getDivisionId() == oidSecondSlipDiv){
                            
                            try {
                                Company company = PstCompany.fetchExc(careerPath.getCompanyId());
                                Division divisi = PstDivision.fetchExc(careerPath.getDivisionId());
                                Department depart = PstDepartment.fetchExc(careerPath.getDepartmentId());
                                Section sect = PstSection.fetchExc(careerPath.getSectionId());
                                Position pos = PstPosition.fetchExc(careerPath.getPositionId());
                                companyNameMBT = company.getCompany();
                                divisionNameMBT = divisi.getDivision();
                                departmentNameMBT = depart.getDepartment();
                                sectionNameMBT = sect.getSection();
                                positionNameMBT = pos.getPosition();
                                gradeCodeMBT = getGradeCode(employee.getGradeLevelId());
                            } catch(Exception e){
                                System.out.println("cari ke databank =>"+e.toString());
                            }
                            
                            
                            PaySlip paySlipMBT = new PaySlip();
                            paySlipMBT.setEmployeeId(employee.getOID());
                            paySlipMBT.setPeriodId(periodGenerate.getOID());
                            if (employee.getCommencingDate() != null){
                            paySlipMBT.setCommencDate(employee.getCommencingDate());
                            } else {
                                paySlipMBT.setCommencDate(periodGenerate.getStartDate());
                            }

                            paySlipMBT.setPaySlipDate(periodGenerate.getPaySlipDate());
                            paySlipMBT.setCompCode(companyNameMBT);
                            paySlipMBT.setDivision(divisionNameMBT);
                            paySlipMBT.setDepartment(departmentNameMBT);
                            paySlipMBT.setSection(sectionNameMBT);
                            paySlipMBT.setPosition(positionNameMBT);
                            paySlipMBT.setGradeCode(gradeCodeMBT);

                            try {
                                long oid = insertExc(paySlipMBT);
                                String[] strOidSecondSlipGroup = null;
                                try {
                                    strOidSecondSlipGroup = PstSystemProperty.getValueByNameWithStringNull("OID_GROUP_SECOND_SLIP").split(",");
                                } catch (Exception e){
                                    System.out.println("oidSecondSlipDiv : " + e.toString());
                                }
                                long oidPaySlip = getSecondPaySlipId(periodGenerate.getOID(), employee.getOID());
                                if (oidPaySlip != 0) {
                                    /* update paySlip */
                                    paySlipMBT.setOID(oidPaySlip);
                                    Date now = new Date();
                                    paySlipMBT.setStatus(0);
                                    paySlipMBT.setPaidStatus(0);
                                    paySlipMBT.setPaySlipDate(now);
                                    paySlipMBT.setDayPresent(0);
                                    paySlipMBT.setDayPaidLv(0);
                                    paySlipMBT.setDayAbsent(0);
                                    paySlipMBT.setDayUnpaidLv(0);
                                    paySlipMBT.setNote("-");
                                    if (employee.getCommencingDate() != null){
                                        paySlipMBT.setCommencDate(employee.getCommencingDate());
                                    } else {
                                        paySlipMBT.setCommencDate(periodGenerate.getStartDate());
                                    }
                                    paySlipMBT.setPaymentType(0);
                                    paySlipMBT.setBankId(0);
                                    paySlipMBT.setPaySlipType(0);
                                    paySlipMBT.setDayLate(0);
                                    paySlipMBT.setProcentasePresence(0);
                                    paySlipMBT.setOvIdxAdj(0);
                                    paySlipMBT.setPrivateNote("-");
                                    paySlipMBT.setMealAllowanceMoneyByForm(0);
                                    paySlipMBT.setMealAllowanceMoneyAdj(0);
                                    paySlipMBT.setOvertimeIdxByForm(0);
                                    paySlipMBT.setNoteAdmin("-");
                                    paySlipMBT.setOvIdxPaidBySalaryAdjDt(now);
                                    paySlipMBT.setOvAllowanceMoneyAdjDt(now);
                                    long oidUp = updateExc(paySlipMBT);
                                    /* cek jumlah componen di pay slip component */
                                    String whereClause = PstPaySlipComp.fieldNames[PstPaySlipComp.FLD_PAY_SLIP_ID]+"="+oidPaySlip;
                                    Vector listPaySlipComp = PstPaySlipComp.list(0, 0, whereClause, "");

                                    if (listPaySlipComp != null && listComponent != null){
                                        try {
                                            long oidDelete = PstPaySlipComp.deleteByPaySlipId(oidPaySlip);
                                        } catch (Exception e){
                                            System.out.print("delete payslipcomp=>"+e.toString());
                                        }
                                        if (listPaySlipComp.size() != listComponent.size()){
                                            for (int com = 0; com < listComponent.size(); com++) {
                                                PayComponent payComp = (PayComponent) listComponent.get(com);
                                                if (strOidSecondSlipGroup.length>0 && strOidSecondSlipGroup != null){
                                                    for (int slip=0;slip<strOidSecondSlipGroup.length;slip++){
                                                        if (payComp.getPayslipGroupId() == Long.valueOf(strOidSecondSlipGroup[slip])){
                                                            PaySlipComp paySlipCompData = new PaySlipComp();
                                                            paySlipCompData.setCompCode(payComp.getCompCode());
                                                            paySlipCompData.setCompValue(0);
                                                            paySlipCompData.setPaySlipId(oidPaySlip);
                                                            try {
                                                                long oidPaySlipComp = PstPaySlipComp.insertExc(paySlipCompData);
                                                            } catch(Exception e){
                                                                System.out.print("insert payslipcomp=>"+e.toString());
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                } else {
                                    /* insert paySlip */
                                    if (listComponent != null && listComponent.size() > 0) {
                                        for (int com = 0; com < listComponent.size(); com++) {
                                            PayComponent payComp = (PayComponent) listComponent.get(com);
                                            if (strOidSecondSlipGroup.length>0 && strOidSecondSlipGroup != null){
                                                for (int slip=0;slip<strOidSecondSlipGroup.length;slip++){
                                                    if (payComp.getPayslipGroupId() == Long.valueOf(strOidSecondSlipGroup[slip])){
                                                        PaySlipComp paySlipCompData = new PaySlipComp();
                                                        paySlipCompData.setCompCode(payComp.getCompCode());
                                                        paySlipCompData.setCompValue(0);
                                                        paySlipCompData.setPaySlipId(oid);
                                                        long oidPaySlipComp = PstPaySlipComp.insertExc(paySlipCompData);
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }

                            } catch (Exception e) {
                                System.out.println("generatePaySlip: insertExcWithDetail : " + e.toString()+ "in Employee :"+empId);
                            }
                            
                        }
                    }
                    
                }
                
                
                System.out.println("["+(i+1)+"] NRK : "+employee.getEmployeeNum());
            }
        }
    }

    public static String getGradeCode(long gradeId){
        String str = "-";
        try {
            GradeLevel grade = PstGradeLevel.fetchExc(gradeId);
            str = grade.getCodeLevel();
        } catch(Exception e){
            System.out.println(e.toString());
        }
        return str;
    }
    
    public static Vector srcPaySlipByPeriod(long oidEmp, String dateOv) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT ps.* FROM " + PstPaySlip.TBL_PAY_SLIP + " ps "
                    + "INNER JOIN pay_period pp "
                    + "ON ps.PERIOD_ID = pp.PERIOD_ID "
                    + "WHERE ps.employee_id='" + oidEmp + "' && '" + dateOv + "' BETWEEN pp.START_DATE AND pp.END_DATE;";

            dbrs = DBHandler.execQueryResult(sql);
            //System.out.println("SQL LIST Pay Slip"+sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                PaySlip paySlip = new PaySlip();
                resultToObject(rs, paySlip);
                lists.add(paySlip);
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
    
    public static Vector srcPaySlipByComp(long periodId, String compCode) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT ps.* FROM " + PstPaySlip.TBL_PAY_SLIP + " ps "
                    + "INNER JOIN pay_slip_comp pc "
                    + "ON ps.PAY_SLIP_ID = pc.PAY_SLIP_ID "
                    + "WHERE pc.COMP_CODE='" + compCode + "' AND pc.COMP_VALUE > 0 AND ps.PERIOD_ID =  " + periodId;

            dbrs = DBHandler.execQueryResult(sql);
            //System.out.println("SQL LIST Pay Slip"+sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                PaySlip paySlip = new PaySlip();
                resultToObject(rs, paySlip);
                lists.add(paySlip);
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
    
	public static Vector srcPaySlipByEmp(String where) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT ps.* FROM " + PstPaySlip.TBL_PAY_SLIP + " ps "
                    + "INNER JOIN hr_employee emp "
                    + "ON ps.EMPLOYEE_ID = emp.EMPLOYEE_ID "
                    + "WHERE " + where ;

            dbrs = DBHandler.execQueryResult(sql);
            //System.out.println("SQL LIST Pay Slip"+sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                PaySlip paySlip = new PaySlip();
                resultToObject(rs, paySlip);
                lists.add(paySlip);
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
    
    /* Update By Hendra Putu | Aug 2016 */
    public static String insertOrUpdateByExcel(Vector<PaySlip> listOfPaySlip){
        String output = "";
        String whereClause = "";
        String whereIn = "";
        int incComp = 0;
        int incRow = 0;
        String empStr = "";
        Employee emp = new Employee();
        for (int i = 0; i < listOfPaySlip.size(); i++) {
            PaySlip paySlip = (PaySlip) listOfPaySlip.get(i);
            /* mengecek apakah ada oid paySlip sesuai period id dan employee id */
            long oid = getPaySlipId(paySlip.getPeriodId(), paySlip.getEmployeeId());
            long oidSecondSlip = getSecondPaySlipId(paySlip.getPeriodId(), paySlip.getEmployeeId());
            
            //cek payslip group
            String[] strOidPayGroupSecondSlip = null;
            try{
                strOidPayGroupSecondSlip = PstSystemProperty.getValueByNameWithStringNull("OID_GROUP_SECOND_SLIP").split(",");
            } catch (Exception exc){}

            if (oid != 0){
                /* UPDATE PaySlipComp */
                if (paySlip.getPaySlipCompSize() > 0){                    
                    for (int in = 0; in < paySlip.getPaySlipCompSize(); in++) {
                        PaySlipComp slipCompFrXLS = (PaySlipComp) paySlip.getPaySlipComps().get(in);
                    whereClause = PstPaySlipComp.fieldNames[PstPaySlipComp.FLD_PAY_SLIP_ID]+"="+oid+" AND ";
                        whereClause+= PstPaySlipComp.fieldNames[PstPaySlipComp.FLD_COMP_CODE]+"='"+slipCompFrXLS.getCompCode()+"'";
                    Vector listPaySlipFromDB = PstPaySlipComp.list(0, 0, whereClause, "");
                    if (listPaySlipFromDB != null && listPaySlipFromDB.size()>0){
                            PaySlipComp slipFromDB = (PaySlipComp)listPaySlipFromDB.get(0);
                            if (slipCompFrXLS.getCompCode().equals(slipFromDB.getCompCode())){
                                    PaySlipComp newSlipComp = new PaySlipComp();
                                newSlipComp.setCompCode(slipCompFrXLS.getCompCode());
                                newSlipComp.setCompValue(slipCompFrXLS.getCompValue());
                                if (strOidPayGroupSecondSlip.length > 0 && strOidPayGroupSecondSlip != null){
                                    String whereComp = PstPayComponent.fieldNames[PstPayComponent.FLD_COMP_CODE] + " = '"+slipFromDB.getCompCode()+"'";
                                    Vector listComp = PstPayComponent.list(0, 0, whereComp, "");
                                    if (listComp.size() > 0){
                                        PayComponent payComp = (PayComponent) listComp.get(0);
                                        for (int slip=0; slip<strOidPayGroupSecondSlip.length;slip++){
                                            if (payComp.getPayslipGroupId() == Long.valueOf(strOidPayGroupSecondSlip[slip])){
                                                newSlipComp.setPaySlipId(oidSecondSlip);
                                                break;
                                            } else {
                                                newSlipComp.setPaySlipId(oid);
                                            }
                                        }
                                    }
                                } else {
                                    newSlipComp.setPaySlipId(oid);
                                }
                                    newSlipComp.setOID(slipFromDB.getOID());
                                    try {
                                        long oidUpdate = PstPaySlipComp.updateExc(newSlipComp);
                                        if (oidUpdate != 0){
                                            incComp++;
                                        }
                                    } catch(Exception e){
                                        System.out.println("insertOrUpdateByExcel: "+e.toString());
                                    }
                                }
                        } else {
                            /* Kondisi jika komponen baru, atau belum ada pada saat generate */
                            PaySlipComp newSlipComp = new PaySlipComp();
                            newSlipComp.setCompCode(slipCompFrXLS.getCompCode());
                            newSlipComp.setCompValue(slipCompFrXLS.getCompValue());
                            if (strOidPayGroupSecondSlip.length > 0 && strOidPayGroupSecondSlip != null){
                                    String whereComp = PstPayComponent.fieldNames[PstPayComponent.FLD_COMP_CODE] + " = '"+slipCompFrXLS.getCompCode()+"'";
                                    Vector listComp = PstPayComponent.list(0, 0, whereComp, "");
                                    if (listComp.size() > 0){
                                        PayComponent payComp = (PayComponent) listComp.get(0);
                                        for (int slip=0; slip<strOidPayGroupSecondSlip.length;slip++){
                                            if (payComp.getPayslipGroupId() == Long.valueOf(strOidPayGroupSecondSlip[slip])){
                                                newSlipComp.setPaySlipId(oidSecondSlip);
                                                break;
                                            } else {
                                                newSlipComp.setPaySlipId(oid);
                                            }
                                        }
                                    }
                                } else {
                                    newSlipComp.setPaySlipId(oid);
                                }
                            try {
                                long oidInsert = PstPaySlipComp.insertExc(newSlipComp);
                                if (oidInsert != 0){
                                    incComp++;
                            }
                            } catch(Exception e){
                                System.out.println("insertOrUpdateByExcel: "+e.toString());
                        }
                    }
                }
                } /* end if (paySlip.getPaySlipCompSize() > 0) */
                if (incComp > 0){
                    incRow++;
                }
            } else {
                /* INSERT PaySlip */
                try {
                    emp = PstEmployee.fetchExc(paySlip.getEmployeeId());
                    empStr += emp.getEmployeeNum()+"; ";
                } catch(Exception e){
                    System.out.println(e.toString());
            }
                
        }
        }
        output += "<div>&nbsp;</div>";
        output += "<div>Data Komponen yg berhasil di-update = " + incComp + "</div>";
        output += "<div>Data per-karyawan yg berhasil di-update = " + incRow + "</div>";
        output += "<div>Gagal update = "+ (listOfPaySlip.size() - incRow) +"</div>";
        output += "<div>Karyawan yang belum mempunyai pay slip pada period bersangkutan = "+empStr+"</div>";
        return output;
    }
    
    public static double getCompValue(long employeeId, PayPeriod payPeriod, String component) {
        double compValue = 0;
        DBResultSet dbrs = null;

        try {

            String sql = "SELECT PAY." + PstPaySlipComp.fieldNames[PstPaySlipComp.FLD_COMP_VALUE]
                    + " FROM " + PstPaySlipComp.TBL_PAY_SLIP_COMP + " AS PAY"
                    + " INNER JOIN " + PstPaySlip.TBL_PAY_SLIP + " AS SLIP"
                    + " ON PAY." + PstPaySlipComp.fieldNames[PstPaySlipComp.FLD_PAY_SLIP_ID]
                    + " = SLIP." + PstPaySlip.fieldNames[PstPaySlip.FLD_PAY_SLIP_ID]
                    + " WHERE SLIP." + PstPaySlip.fieldNames[PstPaySlip.FLD_PERIOD_ID] + "=" + payPeriod.getOID()
                    + " AND SLIP." + PstPaySlip.fieldNames[PstPaySlip.FLD_EMPLOYEE_ID] + "=" + employeeId
                    + " AND PAY." + PstPaySlipComp.fieldNames[PstPaySlipComp.FLD_COMP_CODE] + "= \"" + component + "\"";

            //System.out.println("SQL PstPaySlipComp.getOtherDeduction"+sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                compValue = rs.getDouble(1);
            }

            rs.close();
            return compValue;
        } catch (Exception e) {
            return 0;
        } finally {
            DBResultSet.close(dbrs);
        }


    }
    
    public static int getMaternityLeaveDuration(long employeeId, PayPeriod payPeriod){
        int jumlah = 0;
        DBResultSet dbrs = null;
        try {
            
            String sqlAL = "SELECT "
                            + "al.* "
                        + "FROM "
                            + "hr_al_stock_taken al "
                        + "INNER JOIN hr_leave_application lv "
                        + "on al.`LEAVE_APPLICATION_ID` = lv.`LEAVE_APPLICATION_ID` "
                        + "WHERE lv.`TYPE_LEAVE_CATEGORY` = 1 AND "
                        + "('"+Formater.formatDate(payPeriod.getStartDate(), "yyyy-MM-dd")+" 00:00:00' BETWEEN al.`TAKEN_DATE` AND  al.`TAKEN_FINNISH_DATE` "
                        + " OR '"+Formater.formatDate(payPeriod.getEndDate(), "yyyy-MM-dd")+" 00:00:00' BETWEEN al.`TAKEN_DATE` AND  al.`TAKEN_FINNISH_DATE` ) AND lv.DOC_STATUS IN (2,3) AND lv.employee_id = "+employeeId;
            dbrs = DBHandler.execQueryResult(sqlAL);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                AlStockTaken alStockTaken = new AlStockTaken();
                PstAlStockTaken.resultToObject(rs, alStockTaken);
                Calendar calStart = Calendar.getInstance();
                Calendar calEnd = Calendar.getInstance();
                if (payPeriod.getStartDate().before(alStockTaken.getTakenDate())){
                    calStart.setTime(alStockTaken.getTakenDate());
                } else {
                    calStart.setTime(payPeriod.getStartDate());
                }
                
                if (payPeriod.getEndDate().after(alStockTaken.getTakenFinnishDate())){
                    calEnd.setTime(alStockTaken.getTakenFinnishDate());
                } else {
                    calEnd.setTime(payPeriod.getEndDate());
                }
                
                int startDate = PstCareerPath.getConvertDateToInt(Formater.formatDate(calStart.getTime(), "yyyy-MM-dd"));
                int endDate = PstCareerPath.getConvertDateToInt(Formater.formatDate(calEnd.getTime(), "yyyy-MM-dd"));
                jumlah = endDate - startDate + 1;
            }

            rs.close();
            
            String sqlLl = "SELECT "
                            + "ll.* "
                        + "FROM "
                            + "hr_ll_stock_taken ll "
                        + "INNER JOIN hr_leave_application lv "
                        + "on ll.`LEAVE_APPLICATION_ID` = lv.`LEAVE_APPLICATION_ID` "
                        + "WHERE lv.`TYPE_LEAVE_CATEGORY` = 1 AND "
                       + "('"+Formater.formatDate(payPeriod.getStartDate(), "yyyy-MM-dd")+" 00:00:00' BETWEEN ll.`TAKEN_DATE` AND  ll.`TAKEN_FINNISH_DATE` "
                        + " OR '"+Formater.formatDate(payPeriod.getEndDate(), "yyyy-MM-dd")+" 00:00:00' BETWEEN ll.`TAKEN_DATE` AND  ll.`TAKEN_FINNISH_DATE` ) AND lv.DOC_STATUS IN (2,3) AND lv.employee_id = "+employeeId;
            dbrs = DBHandler.execQueryResult(sqlLl);
            rs = dbrs.getResultSet();

            while (rs.next()) {
                LlStockTaken llStockTaken = new LlStockTaken();
                PstLlStockTaken.resultToObject(rs, llStockTaken);
                Calendar calStart = Calendar.getInstance();
                Calendar calEnd = Calendar.getInstance();
                if (payPeriod.getStartDate().before(llStockTaken.getTakenDate())){
                    calStart.setTime(llStockTaken.getTakenDate());
                } else {
                    calStart.setTime(payPeriod.getStartDate());
                }
                
                if (payPeriod.getEndDate().after(llStockTaken.getTakenFinnishDate())){
                    calEnd.setTime(llStockTaken.getTakenFinnishDate());
                } else {
                    calEnd.setTime(payPeriod.getEndDate());
                }
                
                int startDate = PstCareerPath.getConvertDateToInt(Formater.formatDate(calStart.getTime(), "yyyy-MM-dd"));
                int endDate = PstCareerPath.getConvertDateToInt(Formater.formatDate(calEnd.getTime(), "yyyy-MM-dd"));
                jumlah = endDate - startDate + 1;
            }

            if (jumlah > 30){
                jumlah = 30;
            }
            
            rs.close();
            
        } catch (Exception e) {
            return 0;
        } finally {
            DBResultSet.close(dbrs);
        }
        
        return jumlah;
    }
    
    public static int getUnpaidLeaveDuration(long employeeId, PayPeriod payPeriod){
        int jumlah = 0;
        DBResultSet dbrs = null;
        String oidUnpaidLeave = PstSystemProperty.getValueByName("OID_UNPAID_LEAVE");
        try {
            
            String sqlAL = "SELECT "
                            + "sl.* "
                        + "FROM "
                            + "hr_special_unpaid_leave_taken sl "
                        + "INNER JOIN hr_leave_application lv "
                        + "on sl.`LEAVE_APPLICATION_ID` = lv.`LEAVE_APPLICATION_ID` "
                        + "WHERE "
                        + "('"+Formater.formatDate(payPeriod.getStartDate(), "yyyy-MM-dd")+" 00:00:00' BETWEEN sl.`TAKEN_DATE` AND  sl.`TAKEN_FINNISH_DATE` "
                        + " OR '"+Formater.formatDate(payPeriod.getEndDate(), "yyyy-MM-dd")+" 00:00:00' BETWEEN sl.`TAKEN_DATE` AND  sl.`TAKEN_FINNISH_DATE`"
                        + " OR sl.`TAKEN_DATE` BETWEEN '"+Formater.formatDate(payPeriod.getStartDate(), "yyyy-MM-dd")+" 00:00:00' AND '"+Formater.formatDate(payPeriod.getEndDate(), "yyyy-MM-dd")+" 00:00:00' "
                        + " OR sl.`TAKEN_FINNISH_DATE` BETWEEN '"+Formater.formatDate(payPeriod.getStartDate(), "yyyy-MM-dd")+" 00:00:00' AND '"+Formater.formatDate(payPeriod.getEndDate(), "yyyy-MM-dd")+" 00:00:00' "
                        + ") AND lv.DOC_STATUS IN (2,3) AND lv.employee_id = "+employeeId+" AND sl.`SCHEDULED_ID` = "+oidUnpaidLeave;
            dbrs = DBHandler.execQueryResult(sqlAL);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                SpecialUnpaidLeaveTaken sl = new SpecialUnpaidLeaveTaken();
                PstSpecialUnpaidLeaveTaken.resultToObject(rs, sl);
                Calendar calStart = Calendar.getInstance();
                Calendar calEnd = Calendar.getInstance();
                if (payPeriod.getStartDate().before(sl.getTakenDate())){
                    calStart.setTime(sl.getTakenDate());
                } else {
                    calStart.setTime(payPeriod.getStartDate());
                }
                
                if (payPeriod.getEndDate().after(sl.getTakenFinnishDate())){
                    calEnd.setTime(sl.getTakenFinnishDate());
                } else {
                    calEnd.setTime(payPeriod.getEndDate());
                }
                
                int startDate = PstCareerPath.getConvertDateToInt(Formater.formatDate(calStart.getTime(), "yyyy-MM-dd"));
                int endDate = PstCareerPath.getConvertDateToInt(Formater.formatDate(calEnd.getTime(), "yyyy-MM-dd"));
                jumlah = endDate - startDate + 1;
            }

            rs.close();
            
            if (jumlah > 30){
                jumlah = 30;
            }
            
        } catch (Exception e) {
            return 0;
        } finally {
            DBResultSet.close(dbrs);
        }
        
        return jumlah;
    }
    
}

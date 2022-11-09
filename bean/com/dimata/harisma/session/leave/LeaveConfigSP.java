
package com.dimata.harisma.session.leave;

import com.dimata.harisma.entity.attendance.AlStockTaken;
import com.dimata.harisma.entity.attendance.DpStockManagement;
import com.dimata.harisma.entity.attendance.DpStockTaken;
import com.dimata.harisma.entity.attendance.LlStockTaken;
import com.dimata.harisma.entity.attendance.PstAlStockTaken;
import com.dimata.harisma.entity.attendance.PstEmpSchedule;
import com.dimata.harisma.entity.attendance.PstLlStockTaken;
import com.dimata.harisma.entity.employee.Employee;
import com.dimata.harisma.entity.employee.PstEmployee;
import com.dimata.harisma.entity.leave.AlAutomaticStart;
import com.dimata.harisma.utility.service.presence.RunAutomaticEntileAl;
import com.dimata.harisma.entity.leave.I_Leave;
import com.dimata.harisma.entity.leave.LeaveAlClosing;
import com.dimata.harisma.entity.leave.LeaveApplication;
import com.dimata.harisma.entity.leave.LeaveConfigurationParameter;
import com.dimata.harisma.entity.leave.PstSpecialUnpaidLeaveTaken;
import com.dimata.harisma.entity.masterdata.Department;
import com.dimata.harisma.entity.masterdata.Division;
import com.dimata.harisma.entity.masterdata.EmpCategory;
import com.dimata.harisma.entity.masterdata.Level;
import com.dimata.harisma.entity.masterdata.MappingPosition;
import com.dimata.harisma.entity.masterdata.PstDepartment;
import com.dimata.harisma.entity.masterdata.PstDivision;
import com.dimata.harisma.entity.masterdata.PstEmpCategory;
import com.dimata.harisma.entity.masterdata.PstLevel;
import com.dimata.harisma.entity.masterdata.PstMappingPosition;
import com.dimata.harisma.entity.masterdata.PstPeriod;
import com.dimata.harisma.entity.masterdata.PstPosition;
import com.dimata.harisma.entity.masterdata.PstPublicHolidays;
import com.dimata.harisma.entity.masterdata.PstScheduleCategory;
import com.dimata.harisma.entity.masterdata.PstScheduleSymbol;
import com.dimata.harisma.entity.masterdata.PstSection;
import com.dimata.harisma.entity.masterdata.PstTopPosition;
import com.dimata.harisma.entity.masterdata.PublicHolidays;
import com.dimata.harisma.entity.masterdata.ScheduleCategory;
import com.dimata.harisma.entity.masterdata.ScheduleSymbol;
import com.dimata.harisma.entity.masterdata.Section;
import com.dimata.harisma.entity.search.SrcLeaveAppAlClosing;
import com.dimata.harisma.session.attendance.SessEmpSchedule;
import com.dimata.system.entity.*;
import com.dimata.qdep.db.DBException;
import com.dimata.qdep.db.DBHandler;
import com.dimata.qdep.db.DBResultSet;
import com.dimata.util.DateCalc;
import com.dimata.util.Formater;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Vector;

/**
 *
 * @author bayu
 */

public class LeaveConfigSP implements I_Leave {

    private final int minTimeToHasDP = 4; //Dalam jam
    private final int iDayAYear = 365;
    
    private int iEntitleType = AL_ENTITLE_BY_COMMENCING;
    private int iALEarnedBy = AL_EARNED_BY_TOTAL;

    private boolean isALStockMinus  = false;
    private boolean isLLStockMinus  = false;

    //update by satrya 2012-10-08
     private boolean isDPStockMinus  = false;
    private int iALExpirationDay = iDayAYear;
    private int iALExpWarning = 60;
    private int iMinLLTakenAnual = 0;
    private int iMaxLLTakenAnual = 365;// no limit
    private int iLLExpirationDay = iDayAYear * 5;// 5 years
    private int iLLExpWarning = 6*30 ; // 6 months

    /* in month, minimal berapa bulan bekerja untuk mendapatkan stock AL, kasus di nikko pada awal bekerja sudah memiliki stock cuti */
    private int iMinWorkToGetAnual      = 0; // month
    /* in month, minimal berapa bulan bekerja untuk boleh mengambil cuti, kasus di nikko,cuti boleh diambil setelah bekerja 3 bulan, walaupun pada awal bekerja sudah mempunyai stock cuti */
    private int iMinWorkCanGetAnnual    = 12; //month

    /*Tanggal dan bulan closing jika memakai Leave by Period*/
    private int iDateClosingAnnual; //Tanggal closing
    private int iMonthClosingAnnual; //Bulan closing

    /* Periode untuk mendapatkan entitle Al , dimana mendapatkan al ketika awal periode yaitu 26 Januari*/
    private int date    = 0;
    private int month   = 0;

    /* Untuk mengecek batas tanggal untu menentukan periode bulanan, seperti bila limit adalah 17,
     * kemudian karyawan tersebut masuk tanggal 15,karena 15 kurang dari 17 maka akan dapat periode bulana pada bulan sekarang,
     * Sedangkan bila commencing date adalah 19, karena 19 lebih besar dari 17, maka periode bulanan yang didapt adalah periode berikutnya
     */
    private int dateLimit   = 15; /* bulan januari */   

    public static final int LEVEL_A = 0;
    public static final int LEVEL_B = 1;
    public static final int LEVEL_C = 2;
    public static final int LEVEL_D = 3;
    public static final int LEVEL_E = 4;
    
    private final String[] strLevels = {
        "Level A",
        "Level B",
        "Level C",
        "Level D",
        "Level E"
    };
    
    public static final int CATEGORY_APPRENTICESHIP     = 0;
    public static final int CATEGORY_CONTRACTUAL        = 1;
    public static final int CATEGORY_DAILY_WORKER	= 2;
    public static final int CATEGORY_PERMANENT          = 3;
    public static final int CATEGORY_SEMI_PERMANENT     = 4;	
    public static final int CATEGORY_TRAINEE            = 5;     
    
    private final String[] strCategory = {
        "APPRENTICESHIP",
        "CONTRACTUAL",	
        "DAILY WORKER",	
        "PERMANENT",	
        "SEMI PERMANENT",	
        "TRAINEE"
    };
      
    private static final int[] iIntervalLLs = {
        5*12,
        8*12
    };
    
    private static final int[] iIntervalAL = {
        1 * 12
    };
    
    //AL Standard
    private int[][] iALEntitles = {
            //"APPRENTICESHIP","CONTRACTUAL","DAILY WORKER","PERMANENT","SEMI PERMANENT","TRAINEE"
            {0, 12, 0, 12, 0, 0}, //Level A
            {0, 12, 0, 12, 0, 0}, //Level B
            {0, 12, 0, 12, 0, 0}, //Level C
            {0, 12, 0, 12, 0, 0}, //Level D
            {0, 12, 0, 12, 0, 0}  //Level E
        };
    //AL ketika memperoleh LL
    private int[][] iALEntitlesByLL = {
            //"APPRENTICESHIP","CONTRACTUAL","DAILY WORKER","PERMANENT","SEMI PERMANENT","TRAINEE"
            {0, 12, 0, 12, 0, 0}, //Level A
            {0, 12, 0, 12, 0, 0}, //Level B
            {0, 12, 0, 12, 0, 0}, //Level C
            {0, 12, 0, 12, 0, 0}, //Level D
            {0, 12, 0, 12, 0, 0}  //Level E
        };
    //LL Default
    private int[][][] iLLEntitles = {
            //"APPRENTICESHIP","CONTRACTUAL","DAILY WORKER","PERMANENT","SEMI PERMANENT","TRAINEE"
            //"In 5 Year","In 8 Year"
            {{0,0}, {26,2}, {0,0}, {26,2}, {0,0}, {0,0}}, //Level A
            {{0,0}, {26,2}, {0,0}, {26,2}, {0,0}, {0,0}}, //Level B
            {{0,0}, {26,2}, {0,0}, {26,2}, {0,0}, {0,0}}, //Level C
            {{0,0}, {26,2}, {0,0}, {26,2}, {0,0}, {0,0}}, //Level D
            {{0,0}, {26,2}, {0,0}, {26,2}, {0,0}, {0,0}}  //Level E
        };
    
    private int[][][] iLLValidity = {
            //"APPRENTICESHIP","CONTRACTUAL","DAILY WORKER","PERMANENT","SEMI PERMANENT","TRAINEE"
            //"In 5 Year","In 8 Year"
            {{0,0}, {5*12,2*12}, {0,0}, {0,0}, {5*12,2*12}, {0,0}}, //Level A
            {{0,0}, {5*12,2*12}, {0,0}, {0,0}, {5*12,2*12}, {0,0}}, //Level B
            {{0,0}, {5*12,2*12}, {0,0}, {0,0}, {5*12,2*12}, {0,0}}, //Level C
            {{0,0}, {5*12,2*12}, {0,0}, {0,0}, {5*12,2*12}, {0,0}}, //Level D
            {{0,0}, {5*12,2*12}, {0,0}, {0,0}, {5*12,2*12}, {0,0}}  //Level E
        };
    
    
    //DP Standard
    private int[] iDPStandardEntitle = {
            1, //Level A
            1, //Level B
            1, //Level C
            2, //Level D
            2  //Level E
    };

    private int[] iDPHolidayOffEntitle = {
            1, //Level A
            1, //Level B
            1, //Level C
            1, //Level D
            1  //Level E
    };
    
    private int[] iDPHolidayPresentEntitle = {
            1, //Level A
            1, //Level B
            1, //Level C
            2, //Level D
            2  //Level E
    };

    private int[] iDPBirthdayOffEntitle = {
            1, //Level A
            1, //Level B
            1, //Level C
            1, //Level D
            1  //Level E
    };
    
    private int[] iDPBirthdayPresentEntitle = {
            1, //Level A
            1, //Level B
            1, //Level C
            2, //Level D
            2  //Level E
    };
    
    private int[] iDpValidity = {
            3, //Level A
            3, //Level B
            3, //Level C
            3, //Level D
            3  //Level E
    };
    
    int[] approvalNeed = {
        3, //Level A
        3, //Level B
        3, //Level C
        3, //Level D
        3, //Level E
    };

  
    //Konstruktor
    public LeaveConfigSP() {
        /*//Type entitle, cara penentuan AL dan LL
        iEntitleType = AL_ENTITLE_BY_COMMENCING;
        
        //Waktu hidup AL sampai Expired
        iALExpirationDay = 0;
        //Tempo waktu kemunculan warning message sebelum AL Expired
        iALExpWarning = 30; //DEf 1 bln
        
        //Minimal LL yang bisa diambil dalam setahun       
        iMinLLTakenAnual = 8;
        //Maksimal LL yang bisa diambil dalam setahun
        iMaxLLTakenAnual = 26;
        //Waktu hidup LL sampai Expired
        iLLExpirationDay = 5*iDayAYear; //Def 3 tahun
        //Waktu hidup LL sampai Expired
        iLLExpWarning = 3*30; //Def 3 bulan
        */
        System.out.println("\nCONFIG ::::::: " + PstSystemProperty.getValueByName("LEAVE_CONFIG"));
        System.out.println(" => Entitle Type      : "+AL_ENTITLE_TYPE[iEntitleType]);
        System.out.println(" => AL Expiration Day : "+iALExpirationDay);
        System.out.println(" => AL Exp Warning    : "+iALExpWarning);
        System.out.println(" => Min LL Taken Anual: "+iMinLLTakenAnual);
        System.out.println(" => Max LL Taken Anual: "+iMaxLLTakenAnual);
        System.out.println(" => LL Expiration Day : "+iLLExpirationDay);
        System.out.println(" => LL Exp Warning    : "+iLLExpWarning);
      //  System.out.println(" => AL getALEntitleAnualLeave(Sample) : "+getALEntitleAnualLeave("Level B","DAILY WORKER"));
      //  System.out.println(" => LL getLLEntile(Sample)            : "+getLLEntile("Level B","CONTRACTUAL",iIntervalLLs[INTERVAL_LL_8_YEAR])+"\n");
        Date dt = new Date();
        dt.setDate(20);
        dt.setMonth(0);
        dt.setYear(2008-1900);
     //   System.out.println(" => DP getDPEntitleByDate(Sample)            : "+getDPEntitleByDate("7008",dt)+"\n");
        //Test
        //getDPEntitleByDate("7005",new Date());
    }
    
     /**
     * Set type of AL earned
     * @param al_earn_by  : AL_EARNED_BY_TOTAL=0 or  AL_EARNED_PER_MONTH=1;
     */
    public void setALEarnedBy(int al_earn_by ){
        iALEarnedBy = al_earn_by;
    }
    
    /**
     * get type of AL earned
     * @return
     */
    public int getAlEarnedBy(){
        return iALEarnedBy;
    }
    
    /**
     * set if AL stock can be minus ( more AL is taken by employee then earned )
     * @param ALminus
     */
    public void setALStockMinus(boolean ALminus){
        isALStockMinus = ALminus;
    }
    
    /**
     * get AL stock minus configuration
     * @return boolean
     */
    public boolean getALStockMinus(AlStockTaken alStockTaken){
        return isALStockMinus;
    }
    
     public boolean getALStockMinus(float eligible,long oidEmployee) {
         return isALStockMinus;
     }

    /**
     * set if LL stock can be minus ( more LL is taken by employee then earned )
     * @param ALminus
     */
    public void setLLStockMinus(boolean LLminus) {
        isLLStockMinus = LLminus;
    }

    /**
     * get AL stock minus configuration
     * @return boolean
     */
    public boolean getLLStockMinus(LlStockTaken llStockTaken,I_Leave leave,float eligbleDay) {
        return isLLStockMinus;
    }
     public boolean getLLStockMinus(float eligbleDay){
          return isLLStockMinus;
     }
     

    //update by satrya 2012-10-08   
    /**
     * @param isDPStockMinus the isDPStockMinus to set
     */
    public void setDPStockMinus(boolean DPminus) {
        isDPStockMinus = DPminus;
    }
        /**
     * @return the isDPStockMinus
     */
    public boolean getDPStockMinus(Vector listal,long oidEmployee,DpStockTaken dpStockTaken,float dpTakenPrev) {
        return isDPStockMinus;
    }

    
    
    public int[] getIntervalALinMonths() {
        return iIntervalAL;
    }
    
    /**
     * @descr Method for getting number of AL depending on employee Level and Employee type
     * @param level
     * @param employeeType
     * @return
     */
    public float getALEntitleAnualLeave(String level, String employeeType, int LoSMonth, Date commencingDate, Date checkDate){
        int iEntitleAL = 0;
        int iLevel = getIndexLevel(level);
        int iType = getIndexType(employeeType);
        iEntitleAL = iALEntitles[iLevel][iType];
        return iEntitleAL;
    }
     /**
     * @descr Method for getting number of AL depending on employee Level and Employee type
     * @param level
     * @param employeeType
     * @return
     */
    public float getALEntitleAnualLeaveAlaCommecingPeriode(LeaveAlClosing leaveAlClosing) {
        int iEntitleAL = 0;
        try {
            Date entDtCommencing = Formater.formatDate(leaveAlClosing.getCommencingDate(), "yyyy-MM-dd");
            
            Date entDtCommencingPlusOneYears = (Date) entDtCommencing.clone();
            entDtCommencingPlusOneYears.setYear(entDtCommencingPlusOneYears.getYear()+1);
            
            Date entDtCommencingPlusOneYearsPlus1JanuaryInNewYears = (Date) entDtCommencingPlusOneYears.clone(); //mencari entitle kedua dimana nilainya diambil dari 1 januari dua tahun depan setelah commencing dikurang satu tahun entitle setelah commencing
            entDtCommencingPlusOneYearsPlus1JanuaryInNewYears.setYear(entDtCommencingPlusOneYearsPlus1JanuaryInNewYears.getYear()+1);
            entDtCommencingPlusOneYearsPlus1JanuaryInNewYears.setMonth(0);
            entDtCommencingPlusOneYearsPlus1JanuaryInNewYears.setDate(1);
            
            Date  entDtClosing = Formater.formatDate(leaveAlClosing.getEntitledDate(), "yyyy-MM-dd");
            if   (entDtClosing != null){
                try {
                 entDtClosing = Formater.formatDate(leaveAlClosing.getEntitledDate(), "yyyy-MM-dd");
                }catch (Exception e){}
            } else {
                entDtClosing = Formater.formatDate(leaveAlClosing.getCommencingDate(), "yyyy-MM-dd");
            }
            
            if (entDtClosing.getTime() == entDtCommencing.getTime()){
                iEntitleAL = DateCalc.monthDifference(entDtCommencingPlusOneYears, entDtCommencingPlusOneYearsPlus1JanuaryInNewYears);
            } else {
                iEntitleAL = 12;
            }   
          
          
        } catch (Exception exc) {
            
            System.out.println(exc);
        }
        return iEntitleAL;
    }
    /**
     * @descr set configuration for AL number entitling for employee depending on Level and type of employee
     * @param level
     * @param employeeType
     * @param numberAL
     */
    public void setALEntitleAnualLeave(String level, String employeeType, int numberAL){
        int iLevel = getIndexLevel(level);
        int iType = getIndexType(employeeType);
        iALEntitles[iLevel][iType] = numberAL;
    }
    
    
    /**
     * @descr setter method for configuration of AL entetling period the value shall be AL_ENTITLE_BY_COMMENCING or AL_ENTITLE_ANUAL
     * @param al_entitle_by
     */
    public void setALEntitleBy(int al_entitle_by){
        iEntitleType = al_entitle_by;                
    }
    /**
     * @descr getter method for configuration of AL entetling period. the return value will be AL_ENTITLE_BY_COMMENCING or AL_ENTITLE_ANUAL 
     * @return
     */
    public int getALEntitleBy(){        
        return iEntitleType;
    }
    
    /**
     * @descr set configuration for expiration days of AL after retreating of entitling date. 
     * @param days
     */
    public void setALExpirationDay(int days){
        iALExpirationDay = days;
    }
    /**
     * @descr get configuration for expiration days of AL after retreating of entitling date. 
     * @return
     */
    public int getALExpirationDay(){
        return iALExpirationDay;
    }
    
    /**
     * @descr set configuration for warning days before AL for employee expired 
     * @param days
     */
    public void setALExpWarning(int days){
        iALExpWarning = days;
    }
    /**
     * @descr get configuration for warning days before AL for employee expired 
     * @param days
     */
    public int getALExpWarning(){
        return iALExpWarning;
    }
    

    /**
     * @descr Method for getting number of AL during LL entetling depending on employee Level and Employee type
     * @param level
     * @param employeeType
     * @return
     */
    public int getALEntitlebyLL(String level, String employeeType){
        int iEntitleAL = 0;
        int iLevel = getIndexLevel(level);
        int iType = getIndexType(employeeType);
        iEntitleAL = iALEntitlesByLL[iLevel][iType];
        return iEntitleAL;
    }
    
    /**
     * @descr set configuration for AL number entitling for employee DURING LL ENTETLING depending on Level and type of employee
     * @param level
     * @param employeeType
     * @param numberAL
     */
    public void setALEntitleLL(String level, String employeeType, int numberAL){
        int iLevel = getIndexLevel(level);
        int iType = getIndexType(employeeType);
        iALEntitles[iLevel][iType] = numberAL;
    }
    
     //priska 20150805 menambahkan al & ll Allowance
    public boolean getALallowance(LeaveApplication leaveApplication){
        return false;
    }
    public boolean getLLallowance(LeaveApplication leaveApplication){
        return false;
    }
    //priska 20150807
    public boolean getALallowanceByPeriode(long periodeId, long employeeId){
        return false;
    }
    public boolean getLLallowanceByPeriode(long periodeId, long employeeId){
        return false;
    }
    /**
     * menset jumlah minimal LL yang boleh di ambil dalam satu tahun
     *
     */
    public void setMinLLTakenAnual(int minLL){
        iMinLLTakenAnual = minLL;
    }
    
    /**
     * mengambil jumlah minimal LL yang boleh di ambil dalam satu tahun
     *
     */
    public int getMinLLTakenAnual(){
         return iMinLLTakenAnual;
    }
    
    
    /**
     * menset jumlah maximum LL yang boleh di ambil dalam satu tahun
     *
     */
    public void setMaxLLTakenAnual(int minLL){
        iMaxLLTakenAnual = minLL;
    }
    
    /**
     * mengambil jumlah maximum LL yang boleh di ambil dalam satu tahun
     *
     */
    public int getMaxLLTakenAnual(){
        return iMaxLLTakenAnual;
    }    
  
    
        /**
     * @descr set configuration for expiration days of LL after retreating of entitling date. 
     * @param days
     */
    public void setLLExpirationDay(int days){
        iLLExpirationDay = days;
    }
    /**
     * @descr get configuration for expiration days of LL after retreating of entitling date. 
     * @return
     */
    public int getLLExpirationDay(){
        return iLLExpirationDay;
    }
    
    
    /**
     * @descr set configuration for warning days before LL expiration for employee expires
     * @param days
     */
    public void setLLExpWarning(int days){
        iLLExpWarning = days;
    }
    
    /**
     * @descr get configuration for warning days before LL for employee  expires
     * @param days
     */
    public int getLLExpWarning(){
        return iLLExpWarning;
    }
    
    /**
     * @descr menset konfigurasi list dari jangka waktu dan jumlah LL yang diperoleh ( bisa lebih dari satu setting : e.g.  : 5 tahun = 26  , 7 tahun = 2 ) tergantung dari Level karyawan.
     * @param level
     * @param employeeType
     * @param monthsLoS : Length of service in months 
     * @param numberLL
     * @param validMonths : length of validity in months
     */
    public void setLLEntitle(String level, String employeeType, int monthsLoS, int numberLL) {
        int iLevel = getIndexLevel(level);
        int iType = getIndexType(employeeType);
        int indexMonth = -1;
        for(int i = 0;i<iIntervalLLs.length;i++){
            if(monthsLoS == iIntervalLLs[i]){
                indexMonth = i;
                break;
            }
        }
        if(iLevel>=0 && iType >=0 && indexMonth>=0){
            iLLEntitles[iLevel][iType][indexMonth] = numberLL;
        }
    }

    /**
     * @descr get konfigurasi list dari jangka waktu dan jumlah LL yang diperoleh ( bisa lebih dari satu setting : e.g.  : 5 tahun = 26  , 7 tahun = 2 ) tergantung dari Level karyawan.
     * @param level
     * @param employeeType
     * @param monthsLoS : Length of service in months 
     * @param numberLL
     */
    public int getLLEntile(String level, String employeeType, int monthsLoS) {
        int iLevel = getIndexLevel(level);
        int iType = getIndexType(employeeType);
        int indexMonth = -1;
        for(int i = 0;i<iIntervalLLs.length;i++){
            if(monthsLoS == iIntervalLLs[i]){
                indexMonth = i;
                break;
            }
        }
        if(iLevel>=0 && iType >=0 && indexMonth>=0){
            return iLLEntitles[iLevel][iType][indexMonth];
        } 
        return 0;
    }
    

    
    /**
     * @param set standard DP entitle based on employee level
     * @param level
     * @param dpDays
     */
    public void setDPStandardEntitle(String level, int dpDays){
        int iLevel = getIndexLevel(level);
        iDPStandardEntitle[iLevel] = dpDays;
    }
    
    /**
     * @descr get standard DP entitle based on employee level
     * @param level
     * @return
     */
    public int getDPStandardEntitle(String level){
        int iEntitleDP = 0;
        int iLevel = getIndexLevel(level);
        iEntitleDP = iDPStandardEntitle[iLevel];
        return iEntitleDP;
    }

    
    /**
     * @descr getDP entitle for a specific employee on a specific date
     * Level E-D : 2 hak DP
     * Level C ke atas sampai A: 1
     * Public holiday , jatuh pada day off
                 * kalau libur ( schedule off ) : dapat pengganti 1
                 * kalau dia di set masuk : dapat pengganti 3
          * di tambah BirthDay :
                  * kalau dia libur : dapat pengganti 2
                  * kalau dia masuk : dapat pengganti 4
     * @param payNum
     * @param date
     * @return
     */
    public int getDPEntitleByDate(String payNum, Date date,LeaveConfigurationParameter leaveConfigurationParameter){
            int iDPEntitleByDate = 0;
            Employee employee = new Employee();
            employee = PstEmployee.getEmployeeByNum(payNum);

            //Cek kondisi
            boolean boolScheduleOff = false;
            boolean boolPresent = false;
            boolean boolPublicHoliday = false;
            boolean boolBirthDay = false;

            boolScheduleOff = isScheduleOff(employee, date,leaveConfigurationParameter);
            boolPresent = isPresent(employee, date);
            boolPublicHoliday = isPublicHoliday(employee, date);
            boolBirthDay = isBirthDay(employee, date);

            System.out.println("\nEMPLOYEE STATUS :::::: "+payNum+" at date :"+date);
            System.out.println("  => ScheduleOff    :"+boolScheduleOff);
            System.out.println("  => Present        :"+boolPresent);
            System.out.println("  => PublicHoliday  :"+boolPublicHoliday);
            System.out.println("  => BirthDay       :"+boolBirthDay+"\n");
            
            //Mengecek level employee
            int iDefEntitleDP = 0;
            String strLevel = "";
            long lLevelId = 0;
            try {
                lLevelId = employee.getLevelId();
                Level objLevel = new Level();
                objLevel = (Level) PstLevel.fetchExc(lLevelId);
                strLevel = objLevel.getLevel();
            } catch (DBException ex) {
                ex.printStackTrace();
            }
            
            if (boolScheduleOff) {
                if (boolPresent) {
                    iDPEntitleByDate += getDPStandardEntitle(strLevel); 
                    if (boolPublicHoliday) {
                        iDPEntitleByDate +=  iDPHolidayPresentEntitle[getIndexLevel(strLevel)] ;
                    }
                    if (boolBirthDay) {
                        iDPEntitleByDate += iDPBirthdayPresentEntitle[getIndexLevel(strLevel)] ;
                    }
                } else {
                    if (boolPublicHoliday) {
                        iDPEntitleByDate += iDPHolidayOffEntitle[getIndexLevel(strLevel)] ;;
                    }
                    if (boolBirthDay) {
                        iDPEntitleByDate += iDPBirthdayOffEntitle[getIndexLevel(strLevel)] ;
                    }
                }
            } else {
                if (boolPresent) {
                    if (boolPublicHoliday) {
                        iDPEntitleByDate += iDPHolidayPresentEntitle[getIndexLevel(strLevel)] ;
                    }
                    if (boolBirthDay) {
                        iDPEntitleByDate += iDPBirthdayPresentEntitle[getIndexLevel(strLevel)] ;
                    }
                } else {
                    //Belum didefinisikan
                    //if (boolPublicHoliday) {
                    //    iDPEntitleByDate += iDPHolidayOffEntitle[getIndexLevel(strLevel)] ;;
                    //}
                    if (boolBirthDay) {
                        iDPEntitleByDate += iDPBirthdayOffEntitle[getIndexLevel(strLevel)] ;
                    }
                }
            }

            return iDPEntitleByDate;
    }
    
    /**
     * @param mengambil masa aktif dari dp per level
     * @param level
     */
    public int getDpValidity(String levelArg){
        int level = getIndexLevel(levelArg);
        return iDpValidity[level];
    }
    
    
    //Add by artha
    /**
     * @desc mengambil nilai index dari level employee
     * @param 
     */
    public int getIndexLevel(String level){
        int index = -1;
        for(int i=0;i<strLevels.length;i++){
           // System.out.println("LEVEl ::: "+level + " >< "+strLevels[i]);
            if(level.equals(strLevels[i])){
                index = i;
                break;
            }
        }
        return index;
    }
    /**
     * @desc mengambil nilai index dari type employee
     * @param 
     */
    public int getIndexType(String type){
        int index = -1;
        for(int i=0;i<strCategory.length;i++){
          //  System.out.println("CATEGORY ::: "+type + " >< "+strCategory[i]);
            if(type.equals(strCategory[i])){
                index = i;
                break;
            }
        }
        return index;
    }
       
    //Untuk mengecek kondisi pada penentuan DP
    /**
     * @desc mengecek apakah employee DO atau tidak, jika DO maka akan diset True jika tidak maka di set false
     * @param employee Employee
     * @param date Date
     * @return boolean
     */
    public boolean isScheduleOff(Employee employee, Date date,LeaveConfigurationParameter leaveConfigurationParameter) {
            boolean status = false;

            //Cek apakah employee ada jadwal pada tgl tersebut?
            ScheduleSymbol scheduleSymbol = new ScheduleSymbol();
            long lScheduleSymbolId = 0;
            lScheduleSymbolId = SessEmpSchedule.getScheduleId(employee.getOID(), date);

            try {
                scheduleSymbol = (ScheduleSymbol) PstScheduleSymbol.fetchExc(lScheduleSymbolId);
            } catch (DBException ex) {
                ex.printStackTrace();
            }

            long lScheduleCategoryId = 0;
            lScheduleCategoryId = scheduleSymbol.getScheduleCategoryId();
            if (lScheduleCategoryId > 0) {
                ScheduleCategory scheduleCategory = new ScheduleCategory();
                try {
                    scheduleCategory = (ScheduleCategory) PstScheduleCategory.fetchExc(lScheduleCategoryId);
                } catch (DBException ex) {
                    System.out.println("[ERROR] com.dimata.harisma.session.leave.SPLeaveConfig isScheduleOff :::: " + ex.toString());
                }

                //Cek apakah employee day off atau tidak
                //Day Off
                if (scheduleCategory.getCategoryType() == PstScheduleCategory.CATEGORY_OFF) {
                    return true;
                }
            }
            return status;
    }

    /**
     * @desc mengecek apakah employee hadir pd tgl tsb
     * @param employee Employee
     * @param date Date
     * @return boolean
     */
    public boolean isPresent(Employee employee, Date date){
        boolean status = false;
        int intervalDate = 0;
        //Cek apakah employee hadir pada tgl tersebut?
      //  Date dActualPresentIn = (Date)SessEmpSchedule.getTimeIn(employee.getOID(),date);
      //  Date dActualPresentOut = (Date)SessEmpSchedule.getTimeOut(date,employee.getOID()
        Date dActualPresentIn = new Date();
        Date dActualPresentOut = new Date();
       
        DBResultSet dbrs = null;
        long periodId = PstPeriod.getPeriodIdBySelectedDate(date);
        try{
            String sFieldIn = "IN"+date.getDate();
            String sFieldOut = "OUT"+date.getDate();


            String sql = " SELECT "+sFieldIn+","+sFieldOut+" FROM "+PstEmpSchedule.TBL_HR_EMP_SCHEDULE
                    +" WHERE "+PstEmpSchedule.fieldNames[PstEmpSchedule.FLD_EMPLOYEE_ID]+"="+employee.getOID()
                    +" AND "+PstEmpSchedule.fieldNames[PstEmpSchedule.FLD_PERIOD_ID]+"="+periodId;
            System.out.println("SQL Mencari  jam masuk dan keluar :::::: "+sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while(rs.next()){
                dActualPresentIn = rs.getTime(1);
                dActualPresentOut = rs.getTime(2);
            }

            } catch (Exception e) {
        } finally {
            DBResultSet.close(dbrs);
        }
         
        
        long lTimeIn = 0;
        long lTimeOut = 0;
        System.out.println("::::::::::: IN  :::::"+ dActualPresentIn);
        System.out.println("::::::::::: OUT :::::"+ dActualPresentOut);
        
        if(dActualPresentIn != null){
            lTimeIn = dActualPresentIn.getTime();
        }
        if(dActualPresentOut != null){
            lTimeOut = dActualPresentOut.getTime();
        }
        
     /*   if(Formater.formatDate(dActualPresentIn, "yyyy-MM-dd 00:00:00").equals(
           Formater.formatDate(date, "yyyy-MM-dd 00:00:00"))){
            if(Formater.formatDate(new Date(), "yyyy-MM-dd 00:00:00").equals(
            Formater.formatDate(date, "yyyy-MM-dd 00:00:00"))){
                intervalDate = (int)((lTimeOut-lTimeIn)/(1000));//Menjadi jam
            }else{
                if(!Formater.formatDate(new Date(), "yyyy-MM-dd 00:00:00").equals(
                Formater.formatDate(dActualPresentOut, "yyyy-MM-dd 00:00:00"))){
                    intervalDate = (int)((lTimeOut-lTimeIn)/(1000));
                }
            }
        }
      * */
        intervalDate = (int)((lTimeOut-lTimeIn)/(1000*60*60));
        
        System.out.println("::::::::::: INTERVAL :::::"+ intervalDate);
        if(intervalDate>=iMinLLTakenAnual){
            status = true;
        }
        return status;
    }
    
    /**
     * @desc mengecek apakah employee mendapat public holiday pada tgl tertentu
     * @param employee Employee
     * @param date Date
     * @return boolean
     */
    public boolean isPublicHoliday(Employee employee, Date date){
        boolean status = false;
        //Apakah tgl tersebut merupakan hari libur?
        Vector vPublicHolidays = new Vector();
        vPublicHolidays = PstPublicHolidays.getHolidayByDate(date);
        if(vPublicHolidays.size()>0){
            for(int i=0;i<vPublicHolidays.size();i++){
                PublicHolidays publicHolidays = new PublicHolidays();
                publicHolidays = (PublicHolidays)vPublicHolidays.get(i);
                if(publicHolidays.getiHolidaySts() == 1 || publicHolidays.getiHolidaySts() == employee.getReligionId()){
                    return true;
                }
            }
        }
        return status;
    }
    
    /**
     * @desc mengecek apakah employee sedang ulang tahun pada tgl tertentu
     * @param employee Employee
     * @param date Date
     * @return boolean
     */
    public boolean isBirthDay(Employee employee, Date date){
        boolean status = false;
        if(employee.getBirthDate().getDate() == date.getDate() &&
           employee.getBirthDate().getMonth() == date.getMonth()){
            return true;
        }
        return status;
    }


    /**
     * @descr get konfigurasi list dari jangka waktu validity LL ( misal yang didapat setiap 5 tahun valid 4 tahun)tergantung dari Level karyawan.
     * @param level
     * @param employeeType
     * @param monthsLoS : Length of service in months 
     * @param numberLL
     * @return range of months of validity of LL
     */
    public int getLLValidityMonths(String level, String employeeType, int monthsLoS){
        int iLevel = getIndexLevel(level);
        int iType = getIndexType(employeeType);
        int indexMonth = -1;
        for(int i = 0;i<iIntervalLLs.length;i++){
            if(monthsLoS == iIntervalLLs[i]){
                indexMonth = i;
                break;
            }
        }
        if(iLevel>=0 && iType >=0 && indexMonth>=0){
            return iLLValidity[iLevel][iType][indexMonth];
        } 
        return 0;
    }

    
    /**
     * @descr menset konfigurasi list dari jangka waktu dan jumlah LL yang diperoleh ( bisa lebih dari satu setting : e.g.  : 5 tahun = 26  , 7 tahun = 2 ) tergantung dari Level karyawan.
     * @param level
     * @param employeeType
     * @param monthsLoS : Length of service in months 
     * @param numberLL
     * @param validMonths : length of validity in months
     */
    public void setLLEntitle(String level, String employeeType, int monthsLoS, int numberLL, int validMonths) {
        int iLevel = getIndexLevel(level);
        int iType = getIndexType(employeeType);
        int indexMonth = -1;
        for(int i = 0;i<iIntervalLLs.length;i++){
            if(monthsLoS == iIntervalLLs[i]){
                indexMonth = i;
                break;
            }
        }
        if(iLevel>=0 && iType >=0 && indexMonth>=0){
            iLLEntitles[iLevel][iType][indexMonth] = numberLL;
            iLLValidity[iLevel][iType][indexMonth] = validMonths;
        }
    }
    
    /**
     * @desc menambil level employee per id employee
     *      - level yang dimaksud adalah level kerja/type
     * @param employee id
     * @return string dari level
     */
    public String getLevel(long employeeId){
       Level objLevel = new Level();
       try{
           Employee objEmployee = PstEmployee.fetchExc(employeeId);
           objLevel = PstLevel.fetchExc(objEmployee.getLevelId());
           return objLevel.getLevel();
       }catch(Exception ex){
           System.out.println("SPLeaveConfig.getLevel employee Not Found ");
           return "";
       }
    }
    
    /**
     * @desc mengabil employee category per employee id
     * @param employee id
     * @return String dari category
     */
    public String getCategory(long employeeId){
        EmpCategory objEmpCategory = new EmpCategory();
        try {
            Employee objEmployee = PstEmployee.fetchExc(employeeId);
            objEmpCategory = PstEmpCategory.fetchExc(objEmployee.getEmpCategoryId());
            return objEmpCategory.getEmpCategory();
        } catch (DBException ex) {
            System.out.println("[ERROR] SPLeaveConfig.getCategory ::: "+ex.toString());
            return "";
        }
    }

    public String[] getStrLevels() {
        return strLevels;
    }

    public String[] getStrCategory() {
        return strCategory;
    }

    public int[] getIntervalLLinMonths() {
        return iIntervalLLs;
    }

    public int getMaxApproval(long employeeId) {
        int maxApporval = 0;
        try{
            String empLevel = getLevel(employeeId);
            int iLevel = getIndexLevel(empLevel);
            maxApporval = approvalNeed[iLevel];
        }catch(Exception ex){}
        return maxApporval;
    }
    
    public int getMaxLeaveApprovalLevel(){
        int maxApporval = 0;
        try {
            for(int i=0; i < approvalNeed.length; i++ ){
                if(maxApporval< approvalNeed[i]){
                   maxApporval=approvalNeed[i];
                }
            }
        } catch (Exception ex) {
        }
        return maxApporval;        
    }    
    
public boolean isLeaveApprovalLevel(int level){
        try {
            for(int i=0; i < approvalNeed.length; i++ ){
                if(level==approvalNeed[i]){
                   return true;
                }
            }
        } catch (Exception ex) {
        }        
        return false;
    }
    
    public int getDistributionBy(){
        int Distribution = 0;      
        
        
        return Distribution;
    }
    
    public Vector getManagerApproval(long employeeId) {

        Employee employee = new Employee();
        Department department = new Department();

        try {
            employee = PstEmployee.fetchExc(employeeId);
        } catch (Exception e) {
            System.out.println("EXCEPTION " + e.toString());
        }

        try {
            department = PstDepartment.fetchExc(employee.getDepartmentId());
        } catch (Exception e) {
            System.out.println("EXCEPTION " + e.toString());
        }

        Vector listEmp = new Vector();

        listEmp = listDepartmentApproval(department.getOID(), employee.getOID());

        if (listEmp != null && listEmp.size() > 0) {

            return listEmp;
        }

        return null;
    }
    
    
    /**
     * //update by priska 20150807
     * @param employeeId
     * @return
     */
 public Vector getApprovalEmployeeTopLink(long employeeId, int typeOfLink) {
        Vector listEmployee = new Vector();
        String whereClause  = "HE." + PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID] + " = "+employeeId+" AND HMP."+ PstTopPosition.fieldNames[PstTopPosition.FLD_TYPE_OF_LINK] + " = "+typeOfLink ;
        String listTopLink = PstTopPosition.listEmployeeTopPositionId(0, 0, whereClause, "");
        if (listTopLink.length() > 0 ){
           listTopLink = listTopLink.substring(0, (listTopLink.length() - 1 ));
        }
        Employee employee = new Employee();
        try {
            employee = PstEmployee.fetchExc(employeeId);
        } catch (Exception e) {
            
        }
        Vector listEmployeeSectionTopLink = PstEmployee.listEmployeeApprovalTopLink(0, 0, " POSITION_ID IN ("+listTopLink+")" , "", employee.getSectionId(), employee.getDepartmentId() , employee.getDivisionId());
        Vector listEmployeeDepartmentTopLink = PstEmployee.listEmployeeApprovalTopLink(0, 0, " POSITION_ID IN ("+listTopLink+")" , "", 0 ,employee.getDepartmentId(), employee.getDivisionId());
        Vector listEmployeeDivisionTopLink = PstEmployee.listEmployeeApprovalTopLink(0, 0, " POSITION_ID IN ("+listTopLink+")" , "", 0,0, 0);
        
        if (listEmployeeSectionTopLink.size() != 0 || listEmployeeSectionTopLink.size() > 0 ){
            listEmployee = listEmployeeSectionTopLink;
        } else if (listEmployeeDepartmentTopLink.size() != 0 || listEmployeeDepartmentTopLink.size() > 0 ){
            listEmployee = listEmployeeDepartmentTopLink;
        } else if (listEmployeeDivisionTopLink.size() != 0 || listEmployeeDivisionTopLink.size() > 0){ 
            listEmployee = listEmployeeDivisionTopLink;
        } else {
          //  employee.setFullName("Tidak Employee yang di set pada top Link");
          //  listEmployee.add(employee);
        }
        return listEmployee;
    }
    
     /**
     * //update by priska 20150807
     * @param employeeId
     * @return
     */
 public Vector getApprovalEmployeeTopLinkByLevel(long employeeId, int typeOfLink,int levelPoint, String status) {
       String byLevelId = "";
       try{
       Level levelX = new Level();
       levelX = PstLevel.getLevelByPoint(levelPoint);
       byLevelId = byLevelId +levelX.getOID();
       }catch(Exception e){} 
       
        Vector listEmployee = new Vector();
        String whereClause  = "HE." + PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID] + " = "+employeeId+" AND HMP."+ PstMappingPosition.fieldNames[PstMappingPosition.FLD_TYPE_OF_LINK] + " = "+typeOfLink+" AND HP." + PstPosition.fieldNames[PstPosition.FLD_LEVEL_ID] + " IN ("+byLevelId+")" ;
        String listTopLink = PstMappingPosition.listEmployeeTopPositionId(0, 0, whereClause, "");
        if (listTopLink.length() > 0 ){
           listTopLink = listTopLink.substring(0, (listTopLink.length() - 1 ));
        }
        Employee employee = new Employee();
        try {
            employee = PstEmployee.fetchExc(employeeId);
        } catch (Exception e) {
            
        }
        Vector listEmployeeDivisionTopLink      = new Vector();
               listEmployeeDivisionTopLink      = PstEmployee.listEmployeeApprovalTopLink(0, 0, " POSITION_ID IN ("+listTopLink+")" , "", 0,0, 0);
        
        if (listEmployeeDivisionTopLink.size() != 0 || listEmployeeDivisionTopLink.size() > 0){ 
            listEmployee = listEmployeeDivisionTopLink;
        }
        return listEmployee;
    }
 
 public int getApprovalEmployeeLeaveStatus(long employeeId){
        int status = 0;
      
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Date dtNow = new Date();
        String dateNow = sdf.format(dtNow);

        String whereAL = "'"+ dateNow +"' BETWEEN DATE_FORMAT(" + PstAlStockTaken.fieldNames[PstAlStockTaken.FLD_TAKEN_DATE] + ", '%Y-%m-%d')"
                        + " AND DATE_FORMAT(" + PstAlStockTaken.fieldNames[PstAlStockTaken.FLD_TAKEN_FINNISH_DATE] + ", '%Y-%m-%d') AND "
                        + ""+ PstAlStockTaken.fieldNames[PstAlStockTaken.FLD_EMPLOYEE_ID] + " = "+employeeId+"";
        String whereLL = "'"+ dateNow +"' BETWEEN DATE_FORMAT(" + PstLlStockTaken.fieldNames[PstLlStockTaken.FLD_TAKEN_DATE] + ", '%Y-%m-%d')"
                        + " AND DATE_FORMAT(" + PstLlStockTaken.fieldNames[PstLlStockTaken.FLD_TAKEN_FINNISH_DATE] + ", '%Y-%m-%d') AND "
                        + ""+ PstLlStockTaken.fieldNames[PstLlStockTaken.FLD_EMPLOYEE_ID] + " = "+employeeId+"";
        String whereSL = "'"+ dateNow +"' BETWEEN DATE_FORMAT(" + PstSpecialUnpaidLeaveTaken.fieldNames[PstSpecialUnpaidLeaveTaken.FLD_TAKEN_DATE] + ", '%Y-%m-%d')"
                        + " AND DATE_FORMAT(" + PstSpecialUnpaidLeaveTaken.fieldNames[PstSpecialUnpaidLeaveTaken.FLD_TAKEN_FINNISH_DATE] + ", '%Y-%m-%d') AND "
                        + ""+ PstSpecialUnpaidLeaveTaken.fieldNames[PstSpecialUnpaidLeaveTaken.FLD_EMPLOYEE_ID] + " = "+employeeId+"";

        Vector listEmpLeaveAL = PstAlStockTaken.list(0, 0, whereAL, "");
        Vector listEmpLeaveLL = PstLlStockTaken.list(0, 0, whereLL, "");
        Vector listEmpLeaveSL = PstSpecialUnpaidLeaveTaken.list(0, 0, whereSL, "");
        
        if (listEmpLeaveAL.size() > 0 || listEmpLeaveLL.size() > 0 || listEmpLeaveSL.size() > 0){
            status = 1;
        }
      
        return status;
  }
  
  public Vector getApprovalEmployeeReplacement(long employeeId, long empApprovalId, int levelPoint, int typeOfLink, long divisionId){
        Vector listEmployee = new Vector();

        Employee employee = new Employee();
        try {
            employee = PstEmployee.fetchExc(employeeId);
        } catch (Exception exc){
            
        }
        
        
        String byLevelId = "";
        try{
        Vector vLevel = PstLevel.getAllLevelByPoint(levelPoint);

        for (int xx = 0; xx < vLevel.size(); xx++ ){
            Level levelX = (Level) vLevel.get(xx);
            byLevelId = byLevelId +levelX.getOID()+",";
        }
            byLevelId = byLevelId.substring(0,byLevelId.length()-1);
            //byLevelId = byLevelId +"10003";
        }catch(Exception e){} 

         String whereClause  = "HE." + PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID] + " = "+employeeId+" AND HMP."+ PstMappingPosition.fieldNames[PstMappingPosition.FLD_TYPE_OF_LINK] + " = "+typeOfLink+" AND HP." + PstPosition.fieldNames[PstPosition.FLD_LEVEL_ID] + " IN ("+byLevelId+")" ;
         String listTopLink = PstMappingPosition.listEmployeeTopPositionId(0, 0, whereClause, "");
         if (listTopLink.length() > 0 ){
            listTopLink = listTopLink.substring(0, (listTopLink.length() - 1 ));
         }
         
         String inReplacement = "";
         String whereReplacement = "" +PstMappingPosition.fieldNames[PstMappingPosition.FLD_DOWN_POSITION_ID] + " IN ("+ listTopLink + ")"
                            + " AND " +PstMappingPosition.fieldNames[PstMappingPosition.FLD_TYPE_OF_LINK] + " = 8 "; 
        Vector listReplacement = PstMappingPosition.list(0, 0, whereReplacement, "");
        if(listReplacement.size() > 0){
            for (int i=0; i < listReplacement.size(); i++){
                MappingPosition map = (MappingPosition) listReplacement.get(i);
                inReplacement = inReplacement + "," + map.getUpPositionId();
            }
        } else {
            String whereUpReplacement = "" +PstMappingPosition.fieldNames[PstMappingPosition.FLD_DOWN_POSITION_ID] + " IN ("+ listTopLink + ")"
                    + " AND " +PstMappingPosition.fieldNames[PstMappingPosition.FLD_TYPE_OF_LINK] + " = 3 "; 
            Vector listUpReplacement = PstMappingPosition.list(0, 0, whereUpReplacement, "");
            if(listUpReplacement.size() > 0){
                for (int i=0; i < listUpReplacement.size(); i++){
                    MappingPosition map = (MappingPosition) listUpReplacement.get(i);
                    inReplacement = inReplacement + "," + map.getUpPositionId();
                }
            }
        }
        if(!(inReplacement.equals(""))){
            inReplacement = inReplacement.substring(1);
        }
        
        Vector listEmployeeReplacement = new Vector();
        if ((!inReplacement.equals(""))){
            listEmployeeReplacement      = PstEmployee.listEmployeeApprovalTopLink(0, 0, " POSITION_ID IN ("+inReplacement+")  AND `DIVISION_ID` = "+employee.getDivisionId() , "", 0,0, 0);
            if (listEmployeeReplacement.size() == 0){
                listEmployeeReplacement = PstEmployee.listEmployeeApprovalTopLink(0, 0, " POSITION_ID IN ("+inReplacement+")", "", 0,0, 0);
            }
        }

        if (listEmployeeReplacement.size() != 0 || listEmployeeReplacement.size() > 0){ 
            listEmployee = listEmployeeReplacement;
        }
      
         return listEmployee;
  }
 
 public Vector getApprovalEmployeeTopLinkByLevelDivision(long employeeId, int typeOfLink,int levelPoint, String status) {
       String byLevelId = "";
       try{
       Level levelX = new Level();
       levelX = PstLevel.getLevelByPoint(levelPoint);
       byLevelId = byLevelId +levelX.getOID();
       }catch(Exception e){} 
       
        Vector listEmployee = new Vector();
        String whereClause  = "HE." + PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID] + " = "+employeeId+" AND HMP."+ PstMappingPosition.fieldNames[PstMappingPosition.FLD_TYPE_OF_LINK] + " = "+typeOfLink+" AND HP." + PstPosition.fieldNames[PstPosition.FLD_LEVEL_ID] + " IN ("+byLevelId+")" ;
        String listTopLink = PstMappingPosition.listEmployeeTopPositionId(0, 0, whereClause, "");
        if (listTopLink.length() > 0 ){
           listTopLink = listTopLink.substring(0, (listTopLink.length() - 1 ));
        }
        Employee employee = new Employee();
        try {
            employee = PstEmployee.fetchExc(employeeId);
        } catch (Exception e) {
            
        }
        Vector listEmployeeDivisionTopLink      = new Vector();
               listEmployeeDivisionTopLink      = PstEmployee.listEmployeeApprovalTopLink(0, 0, " POSITION_ID IN ("+listTopLink+")" , "", 0,0, 0);
        
        if (listEmployeeDivisionTopLink.size() != 0 || listEmployeeDivisionTopLink.size() > 0){ 
            listEmployee = listEmployeeDivisionTopLink;
        }
        return listEmployee;
    }
 
 public Vector getApprovalEmployeeTopLinkByLevelMultipleEmp(String employeeId, int typeOfLink,int levelPoint) {
       String byLevelId = "";
       try{
       Vector vLevel = PstLevel.getAllLevelByPoint(levelPoint);
       
       for (int xx = 0; xx < vLevel.size(); xx++ ){
           Level levelX = (Level) vLevel.get(xx);
           byLevelId = byLevelId +levelX.getOID()+",";
       }
           byLevelId = byLevelId.substring(0,byLevelId.length()-1);
           //byLevelId = byLevelId +"10003";
       }catch(Exception e){} 
       
        Vector listEmployee = new Vector();
        String whereClause  = "HE." + PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID] + " IN ("+employeeId+") AND HMP."+ PstMappingPosition.fieldNames[PstMappingPosition.FLD_TYPE_OF_LINK] + " = "+typeOfLink+" AND HP." + PstPosition.fieldNames[PstPosition.FLD_LEVEL_ID] + " IN ("+byLevelId+")" ;
        String listTopLink = PstMappingPosition.listEmployeeTopPositionId(0, 0, whereClause, "");
        if (listTopLink.length() > 0 ){
           listTopLink = listTopLink.substring(0, (listTopLink.length() - 1 ));
        }
     
        Vector listEmployeeDivisionTopLink      = new Vector();
               listEmployeeDivisionTopLink      = PstEmployee.listEmployeeApprovalTopLink(0, 0, " POSITION_ID IN ("+listTopLink+")" , "", 0,0, 0);
        
        if (listEmployeeDivisionTopLink.size() != 0 || listEmployeeDivisionTopLink.size() > 0){ 
            listEmployee = listEmployeeDivisionTopLink;
        }
        return listEmployee;
    }   
 
    /**
     * 
     * @param employeeId
     * @return
     */
    public Vector getApprovalDepartmentHead(long employeeId) {

        Employee employee = new Employee();        
        Section section = new Section();
        Department department = new Department();
        Division division = new Division();

        try {
            employee = PstEmployee.fetchExc(employeeId);
        } catch (Exception e) {
            System.out.println("EXCEPTION " + e.toString());
        }

        try {
            section = PstSection.fetchExc(employee.getSectionId());
        } catch (Exception e) {
            System.out.println("EXCEPTION " + e.toString());
        }

        try {
            department = PstDepartment.fetchExc(employee.getDepartmentId());
        } catch (Exception e) {
            System.out.println("EXCEPTION " + e.toString());
        }
     
        try {
            division = PstDivision.fetchExc(employee.getDivisionId());
        } catch (Exception e) {
            System.out.println("EXCEPTION " + e.toString());
        }

        Vector listEmpDepartment = new Vector();

        Vector listEmpDivision = new Vector();

        Vector listEmployee = new Vector();

        listEmployee = listSectionApproval(department.getOID(), section.getOID(), employee.getOID());

        listEmpDepartment = listDepartmentApproval(department.getOID(), employee.getOID());

        listEmpDivision = listDivisionApproval(division.getOID(), employee.getOID());

        if (listEmployee == null || listEmployee.size() <= 0) {

            listEmployee = new Vector();

        }

        if (listEmpDepartment != null && listEmpDepartment.size() > 0) {

            for (int i = 0; i < listEmpDepartment.size(); i++) {

                Employee objEmployee = new Employee();

                objEmployee = (Employee) listEmpDepartment.get(i);

                listEmployee.add(objEmployee);

            }

        }

        if (listEmpDivision != null && listEmpDivision.size() > 0) {

            for (int i = 0; i < listEmpDivision.size(); i++) {

                Employee objEmployee = new Employee();

                objEmployee = (Employee) listEmpDivision.get(i);

                listEmployee.add(objEmployee);

            }
        }

        if (listEmployee != null && listEmployee.size() > 0) {

            return listEmployee;

        } else {

            return null;

        }
    
    }

    public Vector listSectionApproval(long departmentId, long sectionId, long employee_id){

        DBResultSet dbrs = null;
        Vector result = new Vector();

        try {

            String sql = "SELECT EMP." + PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID] + "," +
                    " EMP." + PstEmployee.fieldNames[PstEmployee.FLD_FULL_NAME] + " FROM " +
                    PstEmployee.TBL_HR_EMPLOYEE + " EMP INNER JOIN " + PstSection.TBL_HR_SECTION + " SEC ON " +
                    " EMP." + PstEmployee.fieldNames[PstEmployee.FLD_SECTION_ID] + " = SEC." +
                    PstSection.fieldNames[PstSection.FLD_SECTION_ID] + " INNER JOIN " +
                    PstPosition.TBL_HR_POSITION + " POS ON EMP." + PstEmployee.fieldNames[PstEmployee.FLD_POSITION_ID] + " = POS." +
                    PstPosition.fieldNames[PstPosition.FLD_POSITION_ID] + " INNER JOIN " +
                    PstLevel.TBL_HR_LEVEL + " LEV ON EMP." + PstEmployee.fieldNames[PstEmployee.FLD_LEVEL_ID] + " = LEV." +
                    PstLevel.fieldNames[PstLevel.FLD_LEVEL_ID] + " WHERE EMP." +
                    PstEmployee.fieldNames[PstEmployee.FLD_DEPARTMENT_ID] + " = " + departmentId + " AND EMP." +
                    PstEmployee.fieldNames[PstEmployee.FLD_SECTION_ID] + " = " + sectionId + " AND POS." +
                    PstPosition.fieldNames[PstPosition.FLD_DISABLED_APP_UNDER_SUPERVISOR] + " = " + PstPosition.DISABLED_APP_UNDER_SUPERVISOR_FALSE + " AND ( POS." +
                    PstPosition.fieldNames[PstPosition.FLD_POSITION_LEVEL] + " = " + PstPosition.LEVEL_MANAGER + " OR POS." +
                    PstPosition.fieldNames[PstPosition.FLD_POSITION_LEVEL] + " = " + PstPosition.LEVEL_SUPERVISOR +
                    " ) AND EMP."+
                    PstEmployee.fieldNames[PstEmployee.FLD_RESIGNED]+" = "+PstEmployee.NO_RESIGN;

            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {

                Employee employee = new Employee();
                employee.setOID(rs.getLong(PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID]));
                employee.setFullName(rs.getString(PstEmployee.fieldNames[PstEmployee.FLD_FULL_NAME]));
                result.add(employee);

            }

            if (result != null && result.size() > 0) {
                return result;
            } else {
                return null;
            }

        } catch (Exception e) {
            System.out.println("EXCEPTION " + e.toString());
        } finally {
            DBResultSet.close(dbrs);
        }

        return null;

    }

    public Vector listDepartmentApproval(long departmentId, long employee_id) {

        DBResultSet dbrs = null;
        Vector result = new Vector();

        try {

            String sql = "SELECT EMP." + PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID] +
                    ", EMP." + PstEmployee.fieldNames[PstEmployee.FLD_FULL_NAME] + " FROM " +
                    PstEmployee.TBL_HR_EMPLOYEE + " EMP INNER JOIN " +
                    PstPosition.TBL_HR_POSITION + " POS ON EMP." + PstEmployee.fieldNames[PstEmployee.FLD_POSITION_ID] + " = POS." +
                    PstPosition.fieldNames[PstPosition.FLD_POSITION_ID] + " INNER JOIN " +
                    PstLevel.TBL_HR_LEVEL + " LEV ON EMP." + PstEmployee.fieldNames[PstEmployee.FLD_LEVEL_ID] + " = LEV." +
                    PstLevel.fieldNames[PstLevel.FLD_LEVEL_ID] + " WHERE EMP." +
                    PstEmployee.fieldNames[PstEmployee.FLD_DEPARTMENT_ID] + " = " + departmentId + " AND POS." +
                    PstPosition.fieldNames[PstPosition.FLD_DISABLED_APP_DEPT_SCOPE] + " = " + PstPosition.DISABLED_APP_DEPT_SCOPE_FALSE + " AND POS." +
                    PstPosition.fieldNames[PstPosition.FLD_POSITION_LEVEL] + " = " + PstPosition.LEVEL_MANAGER + " AND EMP." +                    
                    PstEmployee.fieldNames[PstEmployee.FLD_RESIGNED] + " = " + PstEmployee.NO_RESIGN;

            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                Employee employee = new Employee();
                employee.setOID(rs.getLong(PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID]));
                employee.setFullName(rs.getString(PstEmployee.fieldNames[PstEmployee.FLD_FULL_NAME]));
                result.add(employee);
            }

            if (result != null && result.size() > 0) {
                return result;
            } else {
                return null;
            }


        } catch (Exception e) {
            System.out.println("EXCEPTION " + e.toString());
        } finally{
          
            try{
                DBResultSet.close(dbrs);
            }catch(Exception E){
                System.out.println("[exception] "+E.toString());
            }
                    
        }

        return null;
    }

    public Vector listDivisionApproval(long division_id, long employee_id) {

        DBResultSet dbrs = null;
        Vector result = new Vector();

        try {

            String sql = "SELECT EMP." + PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID] +
                    ", EMP." + PstEmployee.fieldNames[PstEmployee.FLD_FULL_NAME] + " FROM " +
                    PstEmployee.TBL_HR_EMPLOYEE + " EMP INNER JOIN " + PstPosition.TBL_HR_POSITION +
                    " POS ON EMP." + PstEmployee.fieldNames[PstEmployee.FLD_POSITION_ID] + " = POS." +
                    PstPosition.fieldNames[PstPosition.FLD_POSITION_ID] + " INNER JOIN " +
                    PstLevel.TBL_HR_LEVEL + " LEV ON EMP." + PstEmployee.fieldNames[PstEmployee.FLD_LEVEL_ID] + " = LEV." +
                    PstLevel.fieldNames[PstLevel.FLD_LEVEL_ID] + " WHERE EMP." +
                    PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID] + " = " + division_id + " AND POS." +
                    PstPosition.fieldNames[PstPosition.FLD_DISABLED_APP_DIV_SCOPE] + " = " + PstPosition.DISABLED_APP_DIV_SCOPE_FALSE + " AND POS." +
                    PstPosition.fieldNames[PstPosition.FLD_POSITION_LEVEL] + " = " + PstPosition.LEVEL_MANAGER + " AND EMP." +                    
                    PstEmployee.fieldNames[PstEmployee.FLD_RESIGNED] + " = " + PstEmployee.NO_RESIGN;

            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                Employee employee = new Employee();
                employee.setOID(rs.getLong(PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID]));
                employee.setFullName(rs.getString(PstEmployee.fieldNames[PstEmployee.FLD_FULL_NAME]));
                result.add(employee);
            }

            if (result != null && result.size() > 0) {
                return result;
            } else {
                return null;
            }


        } catch (Exception e) {
            System.out.println("EXCEPTION " + e.toString());
        }finally{
            try{
                DBResultSet.close(dbrs);
            }catch(Exception E){
                System.out.println("[exception] "+E.toString());
            }
        }

        return null;
    }
    
        public Vector listDirut(){
        DBResultSet dbrs = null;
        Vector result = new Vector();
        
        long oidDirut = Long.parseLong(PstSystemProperty.getValueByName("OID_DIRUT_POSITION"));
        
        try {
            
            String sql = "SELECT EMP." + PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID]
                    +" FROM " + PstEmployee.TBL_HR_EMPLOYEE + " EMP INNER JOIN "
                    + PstPosition.TBL_HR_POSITION + " POS ON EMP." + PstEmployee.fieldNames[PstEmployee.FLD_POSITION_ID] + " = POS."
                    + PstPosition.fieldNames[PstPosition.FLD_POSITION_ID]
                    + " WHERE POS." + PstPosition.fieldNames[PstPosition.FLD_POSITION_ID] + " = " + oidDirut;
            
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                Employee employee = new Employee();
                employee.setOID(rs.getLong(PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID]));
                employee.setFullName(rs.getString(PstEmployee.fieldNames[PstEmployee.FLD_FULL_NAME]));
                employee.setEmailAddress(rs.getString(PstEmployee.fieldNames[PstEmployee.FLD_EMAIL_ADDRESS]));
                result.add(employee);
            }
            
            if (result != null && result.size() > 0) {
                return result;
            } else {
                return null;
            }
            
        } catch (Exception e) {
            System.out.println("EXCEPTION " + e.toString());
        } finally {
            DBResultSet.close(dbrs);
        }
         
        
        return null;
    }
   
    public Vector listSDMApproval(long employee_id) {
        DBResultSet dbrs = null;
        Vector result = new Vector();
        
        long hr_department = Long.parseLong(PstSystemProperty.getValueByName("OID_HRD_DEPARTMENT"));
        int kadivLevelRank = Integer.parseInt(PstSystemProperty.getValueByName("KADIV_LEVEL_RANK"));
        
        try {
            
            String sql = "SELECT EMP." + PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID] + ","
                    + " EMP." + PstEmployee.fieldNames[PstEmployee.FLD_FULL_NAME] + ","
                    + " EMP." + PstEmployee.fieldNames[PstEmployee.FLD_EMAIL_ADDRESS]
                    +" FROM " + PstEmployee.TBL_HR_EMPLOYEE + " EMP INNER JOIN "
                    + PstDepartment.TBL_HR_DEPARTMENT + " DEP ON EMP." + PstEmployee.fieldNames[PstEmployee.FLD_DEPARTMENT_ID] + " = DEP."
                    + PstDepartment.fieldNames[PstDepartment.FLD_DEPARTMENT_ID] + " INNER JOIN " + PstLevel.TBL_HR_LEVEL + " LVL ON EMP."
                    + PstEmployee.fieldNames[PstEmployee.FLD_LEVEL_ID] + " = LVL." +PstLevel.fieldNames[PstLevel.FLD_LEVEL_ID]
                    + " WHERE DEP." + PstDepartment.fieldNames[PstDepartment.FLD_DEPARTMENT_ID] + " = " + hr_department + " AND "
                    + " LVL." + PstLevel.fieldNames[PstLevel.FLD_LEVEL_RANK] + " = " + kadivLevelRank ;
            
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                Employee employee = new Employee();
                employee.setOID(rs.getLong(PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID]));
                employee.setFullName(rs.getString(PstEmployee.fieldNames[PstEmployee.FLD_FULL_NAME]));
                employee.setEmailAddress(rs.getString(PstEmployee.fieldNames[PstEmployee.FLD_EMAIL_ADDRESS]));
                result.add(employee);
            }
            
            if (result != null && result.size() > 0) {
                return result;
            } else {
                long oidDirut = Long.parseLong(PstSystemProperty.getValueByName("OID_DIRUT_POSITION"));

                try {

                    String sql2 = "SELECT EMP." + PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID]+ ","
                            + " EMP." + PstEmployee.fieldNames[PstEmployee.FLD_FULL_NAME] + ","
                            + " EMP." + PstEmployee.fieldNames[PstEmployee.FLD_EMAIL_ADDRESS]
                            +" FROM " + PstEmployee.TBL_HR_EMPLOYEE + " EMP INNER JOIN "
                            + PstPosition.TBL_HR_POSITION + " POS ON EMP." + PstEmployee.fieldNames[PstEmployee.FLD_POSITION_ID] + " = POS."
                            + PstPosition.fieldNames[PstPosition.FLD_POSITION_ID]
                            + " WHERE POS." + PstPosition.fieldNames[PstPosition.FLD_POSITION_ID] + " = " + oidDirut;

                    dbrs = DBHandler.execQueryResult(sql2);
                    ResultSet rs2 = dbrs.getResultSet();

                    while (rs2.next()) {
                        Employee employee = new Employee();
                        employee.setOID(rs2.getLong(PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID]));
                        employee.setFullName(rs2.getString(PstEmployee.fieldNames[PstEmployee.FLD_FULL_NAME]));
                        employee.setEmailAddress(rs2.getString(PstEmployee.fieldNames[PstEmployee.FLD_EMAIL_ADDRESS]));
                        result.add(employee);
                    }

                    if (result != null && result.size() > 0) {
                        return result;
                    } else {
                        return null;
                    }

                } catch (Exception e) {
                    System.out.println("EXCEPTION " + e.toString());
                } finally {
                    DBResultSet.close(dbrs);
                }
            }
            
        } catch (Exception e) {
            System.out.println("EXCEPTION " + e.toString());
        } finally {
            DBResultSet.close(dbrs);
        }
         
        
        return null;
        
    }

    public Vector listHRManager(long employee_id){

        DBResultSet dbrs = null;
        Vector result = new Vector();

        long hr_department = Long.parseLong(PstSystemProperty.getValueByName("OID_HRD_DEPARTMENT"));

        try {

            String sql = "SELECT EMP." + PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID] +
                    ", EMP." + PstEmployee.fieldNames[PstEmployee.FLD_FULL_NAME] + " FROM " +
                    PstEmployee.TBL_HR_EMPLOYEE + " EMP INNER JOIN " +
                    PstPosition.TBL_HR_POSITION + " POS ON EMP." + PstEmployee.fieldNames[PstEmployee.FLD_POSITION_ID] + " = POS." +
                    PstPosition.fieldNames[PstPosition.FLD_POSITION_ID] + " INNER JOIN " +
                    PstLevel.TBL_HR_LEVEL + " LEV ON EMP." + PstEmployee.fieldNames[PstEmployee.FLD_LEVEL_ID] + " = LEV." +
                    PstLevel.fieldNames[PstLevel.FLD_LEVEL_ID] + " WHERE EMP." +
                    PstEmployee.fieldNames[PstEmployee.FLD_DEPARTMENT_ID] + " = " + hr_department + " AND POS." +
                    PstPosition.fieldNames[PstPosition.FLD_DISABLED_APP_DEPT_SCOPE] + " = " + PstPosition.DISABLED_APP_DEPT_SCOPE_FALSE + " AND POS." +
                    PstPosition.fieldNames[PstPosition.FLD_POSITION_LEVEL] + " = " + PstPosition.LEVEL_MANAGER + " AND EMP." +                    
                    PstEmployee.fieldNames[PstEmployee.FLD_RESIGNED] + " = " + PstEmployee.NO_RESIGN;

            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                Employee employee = new Employee();
                employee.setOID(rs.getLong(PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID]));
                employee.setFullName(rs.getString(PstEmployee.fieldNames[PstEmployee.FLD_FULL_NAME]));
                result.add(employee);
            }

            if (result != null && result.size() > 0) {
                return result;
            } else {
                return null;
            }


        }catch (Exception e) {
            System.out.println("EXCEPTION " + e.toString());
        }finally{
            try{
                DBResultSet.close(dbrs);
            }catch(Exception E){
                System.out.println("EXCEPTION "+E.toString());
            }        
        }

        return null;
    }
    
    /**
     * @Desc Untuk mendapatkan periode dari entitle
     * 1. JIka type entitle by annual/ by periode maka akan direturn periodenya
     * 2. Sedangkan jika by commencing date maka akan direturn null
     * @return
     */
    public int getDatePeriod(){
        if(date!= 0){
            return date;
        }else{
            return 0;
        }
    }
    
    public int getMonthPeriod(){
        if(month!=0){
            return month;
        }else{
            return 0;
        }
    }    
    
    /**
     * @Author  Roy Andika
     * @Desc    Untuk mendapatkan waktu minimum bekerja karyawan mempunyai stock cuti
     * @return
     */
    public int getMinimalWorkAL(){
        if(iMinWorkToGetAnual!= 0){
            return iMinWorkToGetAnual;
        }else{
            return 0;
        }
    }

    /**
     * @Author  Roy Andika
     * @Desc    Untuk mendapatkan waktu minimum karyawan itu bekerja boleh mengambil AL
     * @return
     */
    public int getMinimalWorkCanTakeAL(){
        if(iMinWorkCanGetAnnual!= 0){
            return iMinWorkCanGetAnnual;
        }else{
            return 0;
        }
    }

     /* Untuk mendapatkan tanggal closing jika menggunakan Leave by Period */
    public int getDateClosingAnnual(){
        if(iDateClosingAnnual >=0 ){
            return iDateClosingAnnual;
        }else{
            return 0;
        }
    }

    /* Untuk mendapatkan bulan closing jika menggunakan Leave by Period */
    public int getMonthClosingAnnual(){
        if(iMonthClosingAnnual >=0 ){
            return iMonthClosingAnnual;
        }else{
            return 0;
        }
    }
   
     /**
     * @Desc Untuk mendapatkan limit date peride bulanan
     * Untuk mengecek batas tanggal untu menentukan periode bulanan, seperti bila limit adalah 17,
     * kemudian karyawan tersebut masuk tanggal 15,karena 15 kurang dari 17 maka akan dapat periode bulana pada bulan sekarang,
     * Sedangkan bila commencing date adalah 19, karena 19 lebih besar dari 17, maka periode bulanan yang didapt adalah periode berikutnya
     * @return
     */
    public int getLimitPeriode(){

        return dateLimit;

    }

    /**
     * @Author  Roy Andika
     * @param   leaveConfig
     * @param   entDt
     * @Desc    Untuk mendapatkan perhitungan stock Al dari setiap employee
     * @return
     */
    
    public float getQtyEntitle(Date entDt, String level, String employeeType, Date commencingDate){
        return getALEntitleAnualLeave(level, employeeType,0,null,null);
    }

    /**
     * @Author  Roy Andika
     * @param   leaveConfig
     * @param   DtCommencing
     * @Desc    Untuk mendapatakan date entitle pertama bagi yang menggunakan konfigurasi leave menggunakan periode
     * @return
     */
    public Date getEntitle_I(Date DtCommencing, String level, String employeeType){
        return null;
    }

     /**
     * @Author  Roy Andika
     * @Desc    Untuk mendapatakan Priode start dan end bila menggunakan periode
     * @param   commancingDate, dtStartm, leaveConfig
     * @return
     */
    public Date getPeriode(Date commancingDate, int dtStart) {

        int tgl = commancingDate.getDate();
        int mont = commancingDate.getMonth() + 1;
        int year = commancingDate.getYear() + 1900;

        String date = "";

        if (tgl >= 1 && tgl < dtStart) { //1 periode mulai dari tgl 26 sampai 25

            int tglPeriode = dtStart;
            int monPeriode = mont;
            int yearPeriode = year;

            date = "" + yearPeriode + "-" + monPeriode + "-" + tglPeriode;

        } else if (tgl >= dtStart) {

            int tglPeriode = dtStart;
            int monthPeriod;
            int yearPeriode;

            if (mont == 12) { /* Bila sudah bulan desember, maka bulan kembali ke januari dan tahun bertambah 1 */

                monthPeriod = 1;
                yearPeriode = year + 1;

            } else {

                monthPeriod = mont + 1;
                yearPeriode = year;
            }

            date = "" + yearPeriode + "-" + monthPeriod + "-" + tglPeriode;

        }

        try {
            Date tmp = Formater.formatDate(date, "yyyy-MM-dd");
            return tmp;
        } catch (Exception e) {
            System.out.println("Exception " + e.toString());
        }
        return null;
    }

    /**
     * @Author  Roy Andika
     * @Desc
     * @param   yer
     * @param   dtPeriod
     * @return
     */
    public Date getPeriodeClosing(Date yer, int dtPeriod) {

        Date cmDate = SessLeaveApplication.DATE_ADD(yer, 12);

        int diff = 0;

        diff = SessLeaveClosing.DATEDIFF(cmDate, new Date());

        if (diff > 0) { //jika belum satu tahun, maka entitle yang digunakan adalah commencing date.

            return yer;

        } else {

            int date = cmDate.getDate();
            int month = cmDate.getMonth() + 1;
            int year = cmDate.getYear() + 1900;

            int dateP = 0;
            int mnthP = 0;
            int yerP = 0;

            if (date < dtPeriod) {

                dateP = dtPeriod;
                mnthP = month;
                yerP = year;

            } else {
                dateP = dtPeriod;
                if (month == 12) {
                    mnthP = 1;
                    yerP = year + 1;
                } else {
                    mnthP = month + 1;
                    yerP = year;
                }
            }

            String tmp = "" + yerP + "-" + mnthP + "-" + dateP;
            Date perDate = new Date();

            try {

                perDate = Formater.formatDate(tmp, "yyyy-MM-dd");
                return perDate;

            } catch (Exception e) {
                System.out.println("Exception " + e.toString());
            }
        }
        return null;
    }

    /**
     * @Author  Roy Andika
     * @param   leaveConfig
     */
    public void procesGetEntitleAutomatic(){

    }

    /**
     * @Author  Roy Andika
     * @Desc    Untuk mendapatkan periode closing bulanan
     */
    public Date getPeriodMonth(){
        return null;
    }
    
    public String getFormatLeave(){
        return "#,###";        
    }
    
    public float getHourOneWorkday(){
       return 8f;// 1 hari kerja = 8 jam   
    } 
    
    public String setAutoALEntitle(Date startDate){
        //public String setAutoALEntitle(Date startDate){
     return "";    
    }

    public Vector<Employee> overtimeRequester(long overtimeId) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public Vector<Employee> overtimeApprover(long overtimeId) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public Vector<Employee> overtimeFinalApprover(long overtimeId) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public boolean getAutomaticDPStockTaken() {
        return true;
    }
    public String setAutoALEntitle(Date startDate, long employeeId) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public boolean getDPUnpaidIsNull() {
        return true;
    }

    public boolean getDPEligibleMinus(float eligbleDay) {
        if(eligbleDay > 0){
            return true;
        }else{
            return false;
        }
    }

    public boolean getDPExpired() {
      return true;
    }

    public boolean getDPStockMinus(DpStockManagement dpStockManagement, DpStockTaken dpStockTaken) {
       if(dpStockManagement.getiDpQty()<dpStockTaken.getTakenQty()){
           return true;
       }else{
           return false;
       }
    }

    public boolean getDPPaidPayable() {
        return false;
    }

    public boolean getLLShowEntile2() {
        return true;
    }
    
     public String setAutoLLEntitle(Date startDate,I_Leave leave) {
        return "";
    }

    
    public Vector getAlValExtend() {
        Vector vectValExtend = new Vector();
        vectValExtend.add(""+EXTEND_12_MONTH);
        vectValExtend.add(""+EXTEND_6_MONTH);
        vectValExtend.add(""+EXTEND_3_MONTH);
        vectValExtend.add(""+EXTEND_2_MONTH);
        vectValExtend.add(""+EXTEND_1_MONTH);
        return  vectValExtend;     
    }

    public Vector getAlKeyExtend() {
       Vector vectListExtend = new Vector();
         vectListExtend.add("12 MONTH");
         vectListExtend.add("6 MONTH");
         vectListExtend.add("3 MONTH");
         vectListExtend.add("2 MONTH");
         vectListExtend.add("1 MONTH");
       return vectListExtend;
    }
    
    public Vector listgetEmployeeActiveByPeriode(SrcLeaveAppAlClosing objSrcLeaveAppAlClosing, I_Leave leaveConfig) {
      Vector listEmployeeActiveByPeriod = SessLeaveClosing.getEmployeeActiveByPeriode(objSrcLeaveAppAlClosing,leaveConfig);
      return listEmployeeActiveByPeriod;
    }
    
    
    public boolean getConfigurationDpMinus() {
        return true;
    }
    
    public boolean isMessageUseAdvanceMinusLimit() {
        return false;
    }

    public Vector listHRManagerSendEmail(long employee_id, String oidEmpHr) {
        DBResultSet dbrs = null;
        Vector result = new Vector();

        long hr_department = Long.parseLong(PstSystemProperty.getValueByName("OID_HRD_DEPARTMENT"));

        try {

            String sql = "SELECT EMP." + PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID] +
                    ", EMP." + PstEmployee.fieldNames[PstEmployee.FLD_FULL_NAME] + " FROM " +
                    PstEmployee.TBL_HR_EMPLOYEE + " EMP INNER JOIN " +
                    PstPosition.TBL_HR_POSITION + " POS ON EMP." + PstEmployee.fieldNames[PstEmployee.FLD_POSITION_ID] + " = POS." +
                    PstPosition.fieldNames[PstPosition.FLD_POSITION_ID] + " INNER JOIN " +
                    PstLevel.TBL_HR_LEVEL + " LEV ON EMP." + PstEmployee.fieldNames[PstEmployee.FLD_LEVEL_ID] + " = LEV." +
                    PstLevel.fieldNames[PstLevel.FLD_LEVEL_ID] + " WHERE EMP." +
                    PstEmployee.fieldNames[PstEmployee.FLD_DEPARTMENT_ID] + " = " + hr_department + " AND POS." +
                    PstPosition.fieldNames[PstPosition.FLD_DISABLED_APP_DEPT_SCOPE] + " = " + PstPosition.DISABLED_APP_DEPT_SCOPE_FALSE + " AND POS." +
                    PstPosition.fieldNames[PstPosition.FLD_POSITION_LEVEL] + " = " + PstPosition.LEVEL_MANAGER + " AND EMP." +                    
                    PstEmployee.fieldNames[PstEmployee.FLD_RESIGNED] + " = " + PstEmployee.NO_RESIGN;

            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                Employee employee = new Employee();
                employee.setOID(rs.getLong(PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID]));
                employee.setFullName(rs.getString(PstEmployee.fieldNames[PstEmployee.FLD_FULL_NAME]));
                result.add(employee);
            }

            if (result != null && result.size() > 0) {
                return result;
            } else {
                return null;
            }


        }catch (Exception e) {
            System.out.println("EXCEPTION " + e.toString());
        }finally{
            try{
                DBResultSet.close(dbrs);
            }catch(Exception E){
                System.out.println("EXCEPTION "+E.toString());
            }        
        }

        return null;
    }
     public float getAlExtraAl(String level, String employeeType, int LoSDays, Date commencingDate, Date checkDate) {
       
        float iEntitleALExtra = 0;
        return iEntitleALExtra;
    }

    public Date getAlExtraDateAl(float extraAl, Date commercingDate) {
        Date extraAlDate=null;
        return extraAlDate;
    }
    
    public int getConfigurationSendMail() {
        return I_Leave.LEAVE_CONFIG_SEND_EMAIL_CREATE_DEP_HEAD;
    }
    
    public int getConfigurationLeaveApprovall() {
        return I_Leave.LEAVE_CONFIG_AFTER_APPROVALL_HRD_NO_EXECUTE;
    }
    
    public int getConfigurationLeaveDpTakenLong() {
        return I_Leave.LEAVE_CONFIG_REQUEST_DP_TAKEN_NOT_LONG;
    }
    
    public boolean getDPStockMinus(DpStockTaken dpStockTaken, float residueSystem, float dpTakenPrev) {
       if((dpStockTaken.getTakenQty() > (residueSystem + dpTakenPrev))){
           return true;
       }else{
           return false;
       }
    }
    
    public boolean CanNotChangeApproval() {
        return false;
    }
    
     public boolean getBalanceNotCalculationDpExpired() {
        return false;
    }
     public boolean isLeaveApplicationIsDay() {
        return I_Leave.LEAVE_APPLICATION_IS_DAY;
    }

}

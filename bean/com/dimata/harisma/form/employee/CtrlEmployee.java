/* 
 * Ctrl Name  		:  CtrlEmployee.java 
 * Created on 	:  [date] [time] AM/PM 
 * 
 * @author  		: karya 
 * @version  		: 01 
 */
/**
 * *****************************************************************
 * Class Description : [project description ... ] Imput Parameters : [input
 * parameter ...] Output : [output ...] 
 *******************************************************************
 */
package com.dimata.harisma.form.employee;
/* java package */

import com.dimata.common.entity.contact.ContactList;
import com.dimata.common.entity.contact.PstContactList;
import com.dimata.harisma.entity.admin.AppUser;
import com.dimata.harisma.entity.admin.PstAppUser;
import java.util.Date;
import javax.servlet.*;
import javax.servlet.http.*;
/* dimata package */
import com.dimata.util.*;
import com.dimata.util.lang.*;
/* qdep package */
import com.dimata.qdep.system.*;
import com.dimata.qdep.form.*;
import com.dimata.qdep.db.*;
/* project package */
//import com.dimata.harisma.db.*;
import com.dimata.harisma.entity.employee.*;
import com.dimata.harisma.entity.locker.*;
import com.dimata.harisma.form.locker.*;
import com.dimata.harisma.entity.attendance.*;
import com.dimata.harisma.entity.log.I_LogHistory;
import com.dimata.harisma.entity.log.LogSysHistory;
import com.dimata.harisma.entity.log.PstLogSysHistory;
import com.dimata.harisma.entity.masterdata.Company;
import com.dimata.harisma.entity.masterdata.Department;
import com.dimata.harisma.entity.masterdata.Division;
import com.dimata.harisma.entity.masterdata.EmpCategory;
import com.dimata.harisma.entity.masterdata.GradeLevel;
import com.dimata.harisma.entity.masterdata.Level;
import com.dimata.harisma.entity.masterdata.LockerLocation;
import com.dimata.harisma.entity.masterdata.Marital;
import com.dimata.harisma.entity.masterdata.Position;
import com.dimata.harisma.entity.masterdata.PstCompany;
import com.dimata.harisma.entity.masterdata.PstDepartment;
import com.dimata.harisma.entity.masterdata.PstDivision;
import com.dimata.harisma.entity.masterdata.PstEmpCategory;
import com.dimata.harisma.entity.masterdata.PstGradeLevel;
import com.dimata.harisma.entity.masterdata.PstLevel;
import com.dimata.harisma.entity.masterdata.PstLockerLocation;
import com.dimata.harisma.entity.masterdata.PstMarital;
import com.dimata.harisma.entity.masterdata.PstPosition;
import com.dimata.harisma.entity.masterdata.PstRace;
import com.dimata.harisma.entity.masterdata.PstReligion;
import com.dimata.harisma.entity.masterdata.PstResignedReason;
import com.dimata.harisma.entity.masterdata.PstSection;
import com.dimata.harisma.entity.masterdata.Race;
import com.dimata.harisma.entity.masterdata.Religion;
import com.dimata.harisma.entity.masterdata.ResignedReason;
import com.dimata.harisma.entity.masterdata.Section;
import com.dimata.harisma.session.employee.SessEmployee;
import com.dimata.harisma.session.leave.SessLeaveClosing;
import com.dimata.harisma.session.log.SessHistoryLog;
import com.dimata.qdep.entity.Entity;
import com.dimata.system.entity.system.PstSystemProperty;
import java.sql.*;
import java.util.Vector;
import org.apache.jasper.tagplugins.jstl.core.Catch;

public class CtrlEmployee extends Control implements I_Language {

    public static int RSLT_OK = 0;
    public static int RSLT_UNKNOWN_ERROR = 1;
    public static int RSLT_EST_CODE_EXIST = 2;
    public static int RSLT_FORM_INCOMPLETE = 3;
    public static int RSLT_EMPLYEE_NUM_EXIST = 4;
    public static String[][] resultText = {
        {"Berhasil", "Tidak dapat diproses", "NoPerkiraan sudah ada", "Data tidak lengkap", " employee number sudah ada"},
        {"Succes", "Can not process", "Estimation code exist", "Data incomplete", "Employee number exist"}};
    private int start;
    private String msgString;
    private Employee employee;
    private PstEmployee pstEmployee;
    private FrmEmployee frmEmployee;
    //locker;
    private Locker locker;
    private PstLocker pstLocker;
    private FrmLocker frmLocker;
    //mutation
    private FrmEmployeeMutation frmEmployeeMutation;
    
    int language = LANGUAGE_DEFAULT;

    public CtrlEmployee(HttpServletRequest request) {
        msgString = "";
        employee = new Employee();
        locker = new Locker();
        try {
            pstEmployee = new PstEmployee(0);
            pstLocker = new PstLocker(0);
        } catch (Exception e) {
            ;
        }

        frmEmployee = new FrmEmployee(request, employee);

        frmLocker = new FrmLocker(request, locker);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_DBExceptionInfo.MULTIPLE_ID:
                this.frmEmployee.addError(frmEmployee.FRM_FIELD_EMPLOYEE_ID, resultText[language][RSLT_EST_CODE_EXIST]);
                return resultText[language][RSLT_EST_CODE_EXIST];
            default:
                return resultText[language][RSLT_UNKNOWN_ERROR];
        }
    }

    private int getControlMsgId(int msgCode) {
        switch (msgCode) {
            case I_DBExceptionInfo.MULTIPLE_ID:
                return RSLT_EST_CODE_EXIST;
            default:
                return RSLT_UNKNOWN_ERROR;
        }
    }

    public int getLanguage() {
        return language;
    }

    public void setLanguage(int language) {
        this.language = language;
    }

    public Employee getEmployee() {
        return employee;
    }

    public FrmEmployee getForm() {
        return frmEmployee;
    }

    public Locker getLocker() {
        return locker;
    }

    public FrmLocker getFormLocker() {
        return frmLocker;
    }
    
    public FrmEmployeeMutation getFormMutation() {
        return frmEmployeeMutation;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidEmployee, HttpServletRequest request, String loginName, long userId) {

        String MachineFnSpot = "";
        String updateNeedApproval = PstSystemProperty.getValueByName("UPDATE_DATA_NEED_APPROVAL");
        try {
            MachineFnSpot = PstSystemProperty.getValueByName("MACHINE_FN_SPOT");
        } catch (Exception e) {
            MachineFnSpot = "";
            System.out.println("Exception " + e.toString());
        }

        msgString = "";
        String tmpBarcodeNumber = "";
        String tmpFullName = "";
        int excCode = I_DBExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        /* Prepare data (configurasi log system) */
        int sysLog = Integer.parseInt(String.valueOf(PstSystemProperty.getPropertyLongbyName("SET_USER_ACTIVITY_LOG")));
        String logField = "";
        String logPrev = "";
        String logCurr = "";
        Date nowDate = new Date();
        AppUser appUser = new AppUser();
        Employee emp = new Employee();
        try {
            appUser = PstAppUser.fetch(userId);
            emp = PstEmployee.fetchExc(appUser.getEmployeeId());
        } catch(Exception e){
            System.out.println("Get AppUser: userId: "+e.toString());
        }
        /* End Prepare data (configurasi log system) */
        switch (cmd) {
            case Command.ADD:
                break;

            case Command.SAVE:
                Employee prevEmployee = null;
                if (oidEmployee != 0) {
                    try {
                        employee = PstEmployee.fetchExc(oidEmployee);
                        if(sysLog == 1){
                            prevEmployee = PstEmployee.fetchExc(oidEmployee);
                            
                        }
                            
                        tmpBarcodeNumber = employee.getBarcodeNumber();
                        tmpFullName = employee.getFullName();
                    } catch (Exception exc) {
                        System.out.println("Exception Save Employee " + exc);
                    }
                }
                String[] SelectedValues = FRMQueryString.requestStringValues(request, "medicalinfo");// 2015-01-12 update by Hendra McHen
                if(SelectedValues == null){
                    SelectedValues = new String[1];
                }//
                frmEmployee.setSelectedValues(SelectedValues);// 2015-01-12 update by Hendra McHen
                frmEmployee.requestEntityObject(employee);
                if (frmEmployee.errorSize() > 0) {
                    msgString = FRMMessage.getMsg(FRMMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }
                if (employee.getResigned() == PstEmployee.YES_RESIGN) {
                    employee.setLockerId(0);
                    //update by satrya 2012-11-08
                    //employee.setBarcodeNumber(null);
                    //employee.setBarcodeNumber(null);
                }

                // ---- untuk bali dynasty karena tidak memakai locker maka di comment ----
                // get Request Value Of  Locker
                frmLocker.requestEntityObject(locker);
                locker.setOID(employee.getLockerId());
                long locationidX = 0;
                try {
                    locationidX = FRMQueryString.requestLong(request, "LOCKER_LOCATION");
                } catch (Exception ex) {
                    System.out.println("Exception LOCKER_LOCATION not Set" + ex);
                }
                locker.setLocationId(locationidX);
                //locker.setLocationId(employee.getLockerId());
                //locker.setOID(employee.getLockerId());

                //System.out.println("PstEmployee.checkLocker(locker) : " + PstEmployee.checkLocker(locker));
                String strIsCheck = "0";
                try {
                    strIsCheck = PstSystemProperty.getValueByName("LOCKER_MANY_USER");
                } catch (Exception ex) {
                    System.out.println("Exception LOCKER_MANY_USER not Set" + ex);
                }

                if (strIsCheck.equals("0")) { // satu locaker satu pemakai
                    //Dimatikan untuk di hardrock
                    // if(PstEmployee.checkLocker(locker)){
                    //     msgString = "Locker has been used by another employee";
                    //     return RSLT_FORM_INCOMPLETE ;
                    // }
                }

                if ((locker.getLocationId() != 0) && (locker.getLockerNumber() != null && locker.getLockerNumber().length() > 0)) {
                    try {
                        if (locker.getOID() == 0) {
                            long oid = pstLocker.insertExc(locker);
                            employee.setLockerId(oid);
                        } else {
                            System.out.println("++++" + locker.getOID());
                            long oid = PstLocker.updateLocker(locker);
                        }

                    } catch (DBException dbexc) {
                        System.out.println("Error saat save :"+dbexc);
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                        return getControlMsgId(excCode);
                    } catch (Exception exc) {
                        System.out.println("Error saat save :"+exc);
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                        return getControlMsgId(I_DBExceptionInfo.UNKNOWN);
                    }
                }

                /* pengecekan untuk employee number yang sama */
                String where = PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_NUM] + " = \"" + employee.getEmployeeNum() + "\" AND " + PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID] + " != " + employee.getOID();

                Vector resultEmp = new Vector();

                try {
                    resultEmp = PstEmployee.list(0, 0, where, null);
                } catch (Exception e) {
                    System.out.println("[Exc] " + e.toString());
                }

                if (resultEmp != null && resultEmp.size() > 0) {
                    msgString = FRMMessage.getMsg(FRMMessage.MSG_EMP_NUM_IN_EXIST);
                    return RSLT_EMPLYEE_NUM_EXIST;
                }

                /* Untuk pengecekan barcode number */
                Vector resultEmpBarcode = new Vector();
                //update by satrya 2012-11-09
                if (employee.getBarcodeNumber() != null) {
                    String whereBarcode = PstEmployee.fieldNames[PstEmployee.FLD_BARCODE_NUMBER] + " = " + "\"" + employee.getBarcodeNumber() + "\"" + " AND " + PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID] + " != " + employee.getOID();
                    try {
                        resultEmpBarcode = PstEmployee.list(0, 0, whereBarcode, null);
                    } catch (Exception e) {
                        System.out.println("Exc " + e.toString());
                    }
                }
                if (resultEmpBarcode != null && resultEmpBarcode.size() > 0) {
                    msgString = FRMMessage.getMsg(FRMMessage.MSG_BARCODE_IN_EXIST);
                    return RSLT_EMPLYEE_NUM_EXIST;
                }

                /* Pengecekan untuk menghindari pin yang sama 
                
                 String wherePin = PstEmployee.fieldNames[PstEmployee.FLD_EMP_PIN] + " = " + employee.getEmpPin() + " AND " + PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID] + " != " + employee.getOID() + " AND ( " + PstEmployee.fieldNames[PstEmployee.FLD_EMP_PIN] + " is not null OR " + PstEmployee.fieldNames[PstEmployee.FLD_EMP_PIN] + " != '' ) ";

                 Vector resultEmpPin = new Vector();

                 try {
                 resultEmpPin = PstEmployee.list(0, 0, wherePin, null);
                 } catch (Exception e) {
                 System.out.println("Exc " + e.toString());
                 }

                 if (resultEmpPin != null && resultEmpPin.size() > 0) {
                 msgString = FRMMessage.getMsg(FRMMessage.MSG_PIN_IN_EXIST);
                 return RSLT_EMPLYEE_NUM_EXIST;
                 }
                 */
                employee.getEnd_contract();
                if (employee.getOID() == 0) {
                    try {

                        long oid = 0;
                        if (updateNeedApproval.equals("1") && appUser.getAdminStatus() == 0){
                            oid = pstEmployee.insertExcPending(this.employee);
                            this.employee.setOID(oid);
                        } else {
                            oid = pstEmployee.insertExc(this.employee);
                        }

                        if (oid != 0) {
                            boolean isValid = true;
                            if (sysLog == 1) { /* kondisi jika sysLog == 1, maka proses di bawah ini dijalankan*/
                                String whereLog = PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_QUERY]+" = '"+pstEmployee.getQuery()+"' "
                                        + " AND "+PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_LOG_STATUS]+" = 0";
                                Vector listLog = PstLogSysHistory.list(0, 0, whereLog, "");
                                if (listLog.size()>0){
                                    isValid = false;
                                }
                                
                                if (request != null && isValid) {
                                    request.setAttribute("InsertEmployee", this.employee);
                                    request.setAttribute("query", pstEmployee.getQuery());
                                    SessHistoryLog.insertNDeleteEmployee(request);
                                }
                                
                            }
                            
                            //buatkan save carrer path
                            
                             
                             String whereClause = PstCareerPath.fieldNames[PstCareerPath.FLD_EMPLOYEE_ID] + " = " + oid;   
                             Vector listcareerpath = PstCareerPath.listcheckcareer(0, 0, whereClause, null);
                                                        
                            if ((listcareerpath.size()==0) &&(this.employee.getEnd_contract()!=null)){
                                
                               
                                CareerPath careerPath= new CareerPath();
                                careerPath.setEmployeeId(oid);
                                careerPath.setCompanyId(this.employee.getCompanyId());
                                careerPath.setCompany(PstCareerPath.getCompany(String.valueOf(this.employee.getCompanyId()).toString()));
                                careerPath.setDepartmentId(this.employee.getDepartmentId());
                                careerPath.setDepartment(PstCareerPath.getDepartment(String.valueOf(this.employee.getDepartmentId()).toString()));
                                careerPath.setPositionId(this.employee.getPositionId());
                                careerPath.setPosition(PstCareerPath.getDepartment(String.valueOf(this.employee.getDepartmentId()).toString()));
                                careerPath.setSectionId(this.employee.getSectionId());
                                careerPath.setSection(PstCareerPath.getSection(String.valueOf(this.employee.getSectionId()).toString()));
                                careerPath.setWorkFrom(this.employee.getCommencingDate());
                                careerPath.setWorkTo(this.employee.getEnd_contract());
                                careerPath.setSalary(0);
                                careerPath.setDescription("First carrier");
                                careerPath.setEmpCategoryId(this.employee.getEmpCategoryId());
                                careerPath.setEmpCategory(PstCareerPath.getCategory(String.valueOf(this.employee.getEmpCategoryId()).toString()));
                              //  careerPath.set(this.employee.getCompanyId());
                                careerPath.setDivisionId(this.employee.getDivisionId());
                                careerPath.setDivision(PstCareerPath.getDivision(String.valueOf(this.employee.getDivisionId()).toString()));
                                careerPath.setLevelId(this.employee.getLevelId());
                                careerPath.setLevel(PstCareerPath.getLevel(String.valueOf(this.employee.getLevelId()).toString()));
                                careerPath.setLocationId(this.employee.getLocationId());
                                careerPath.setLocation(PstCareerPath.getLocation(String.valueOf(this.employee.getLocationId()).toString()));
                               //hilangkan sementara karena  metode masuk ke carier path untuk karyawan baru itu salah 20151212 
                                //  PstCareerPath.insertExc(careerPath);
                            }
                            if (updateNeedApproval.equals("1") && appUser.getAdminStatus() == 0){
                                if (!isValid){
                                    msgString = FRMMessage.getMsg(FRMMessage.MSG_EXIST_ON_VALIDATION);
                                } else {
                                    msgString = FRMMessage.getMsg(FRMMessage.MSG_ON_VALIDATION);
                                }
                            } else {
                                msgString = FRMMessage.getMsg(FRMMessage.MSG_SAVED);
                            }
                            //Untuk Nikko karena database ada 2, jadi setiap ada perubahan di database yang satu, akan mengupdate data base yang lain
                            try {

                                String db_backup_url = PstSystemProperty.getValueByName("DB_BACKUP_URL");
                                String db_backup_usr = PstSystemProperty.getValueByName("DB_BACKUP_USR");
                                String db_backup_psd = PstSystemProperty.getValueByName("DB_BACKUP_PSWD");

                                /* Pengecekan kelengkapan konfigurasi di system property */
                                if (db_backup_url.compareTo(PstSystemProperty.SYS_NOT_INITIALIZED) != 0
                                        && db_backup_usr.compareTo(PstSystemProperty.SYS_NOT_INITIALIZED) != 0
                                        && db_backup_psd.compareTo(PstSystemProperty.SYS_NOT_INITIALIZED) != 0) {

                                    try {
                                        Class.forName("com.mysql.jdbc.Driver");
                                        System.out.println("Driver Found");
                                    } catch (ClassNotFoundException e) {
                                        javax.swing.JOptionPane.showMessageDialog(null, "Driver Not Found " + e.toString());
                                    }

                                    Connection con = null;
                                    Statement stmt = null;
                                    try {

                                        con = DriverManager.getConnection(db_backup_url, db_backup_usr, db_backup_psd);

                                        String strBirthDate = "";
                                        if (this.employee.getBirthDate() != null) {
                                            try {
                                                strBirthDate = Formater.formatDate(this.employee.getBirthDate(), "yyyy-MM-dd");
                                            } catch (Exception E) {
                                                System.out.println("[exc] Parsing Commencing Date" + E.toString());
                                                msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                                            }
                                        }

                                        String strEndContract = "";
                                        if (this.employee.getEnd_contract() != null) {
                                            try {
                                                strEndContract = Formater.formatDate(this.employee.getEnd_contract(), "yyyy-MM-dd");
                                            } catch (Exception E) {
                                                System.out.println("[exc] Parsing Commencing Date" + E.toString());
                                                msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                                            }
                                        }
                                        
                                        String strCommencingDate = "";
                                        if (this.employee.getCommencingDate() != null) {
                                            try {
                                                strCommencingDate = Formater.formatDate(this.employee.getCommencingDate(), "yyyy-MM-dd");
                                            } catch (Exception E) {
                                                System.out.println("[exc] Parsing Commencing Date" + E.toString());
                                                msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                                            }
                                        }

                                        String sql = "INSERT INTO " + PstEmployee.TBL_HR_EMPLOYEE
                                                + " (" + PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID] + ","
                                                + PstEmployee.fieldNames[PstEmployee.FLD_COMPANY_ID] + ","
                                                + PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID] + ","
                                                + PstEmployee.fieldNames[PstEmployee.FLD_DEPARTMENT_ID] + ","
                                                + PstEmployee.fieldNames[PstEmployee.FLD_POSITION_ID] + ","
                                                + PstEmployee.fieldNames[PstEmployee.FLD_SECTION_ID] + ","
                                                + PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_NUM] + ","
                                                + PstEmployee.fieldNames[PstEmployee.FLD_EMP_CATEGORY_ID] + ","
                                                + PstEmployee.fieldNames[PstEmployee.FLD_LEVEL_ID] + ","
                                                + PstEmployee.fieldNames[PstEmployee.FLD_FULL_NAME] + ","
                                                + PstEmployee.fieldNames[PstEmployee.FLD_ADDRESS] + ","
                                                + PstEmployee.fieldNames[PstEmployee.FLD_SEX] + ","
                                                + PstEmployee.fieldNames[PstEmployee.FLD_BIRTH_PLACE] + ","
                                                + PstEmployee.fieldNames[PstEmployee.FLD_BIRTH_DATE] + ","
                                                + PstEmployee.fieldNames[PstEmployee.FLD_RELIGION_ID] + ","
                                                + PstEmployee.fieldNames[PstEmployee.FLD_BLOOD_TYPE] + ","
                                                + PstEmployee.fieldNames[PstEmployee.FLD_COMMENCING_DATE] + ","
                                                + PstEmployee.fieldNames[PstEmployee.FLD_RESIGNED] + ","
                                                + PstEmployee.fieldNames[PstEmployee.FLD_RESIGNED_DESC] + ","
                                                + PstEmployee.fieldNames[PstEmployee.FLD_RESIGNED_REASON_ID] + ","
                                                + PstEmployee.fieldNames[PstEmployee.FLD_BARCODE_NUMBER] + ","
                                                + PstEmployee.fieldNames[PstEmployee.FLD_EMP_PIN] + ","
                                                + PstEmployee.fieldNames[PstEmployee.FLD_TAX_REG_NR] + ","
                                                + PstEmployee.fieldNames[PstEmployee.FLD_RACE] + ","
                                                + PstEmployee.fieldNames[PstEmployee.FLD_MARITAL_ID] + ","//Gede_15Nov2011{
                                                + PstEmployee.fieldNames[PstEmployee.FLD_FATHER] + ","
                                                + PstEmployee.fieldNames[PstEmployee.FLD_MOTHER] + ","
                                                + PstEmployee.fieldNames[PstEmployee.FLD_PARENTS_ADDRESS] + ","
                                                + PstEmployee.fieldNames[PstEmployee.FLD_NAME_EMG] + ","
                                                + PstEmployee.fieldNames[PstEmployee.FLD_PHONE_EMG] + ","
                                                + PstEmployee.fieldNames[PstEmployee.FLD_ADDRESS_EMG] + "," //}
                                                //Gede_27Nov2011{
                                                + PstEmployee.fieldNames[PstEmployee.FLD_HOD_EMPLOYEE_ID] +","//}
                                                //Ganki_27okt2014{
                                                + PstEmployee.fieldNames[PstEmployee.FLD_LOCATION_ID] +","
                                                + PstEmployee.fieldNames[PstEmployee.FLD_END_CONTRACT] +","
                                                + PstEmployee.fieldNames[PstEmployee.FLD_WORK_ASSIGN_COMPANY_ID] +","
                                                + PstEmployee.fieldNames[PstEmployee.FLD_WORK_ASSIGN_DIVISION_ID] +","
                                                + PstEmployee.fieldNames[PstEmployee.FLD_WORK_ASSIGN_DEPARTMENT_ID] +","
                                                + PstEmployee.fieldNames[PstEmployee.FLD_WORK_ASSIGN_SECTION_ID] +","
                                                + PstEmployee.fieldNames[PstEmployee.FLD_WORK_ASSIGN_POSITION_ID] +
                                                
                                                " ) VALUES ( "
                                                + oid + ","
                                                + this.employee.getCompanyId() + ","
                                                + this.employee.getDivisionId() + ","
                                                + this.employee.getDepartmentId() + ","
                                                + this.employee.getPositionId() + ","
                                                + this.employee.getSectionId() + ","
                                                + "'" + this.employee.getEmployeeNum() + "',"
                                                + this.employee.getEmpCategoryId() + ","
                                                + this.employee.getLevelId() + ","
                                                + "'" + this.employee.getFullName() + "',"
                                                + "'" + this.employee.getAddress() + "',"
                                                + this.employee.getSex() + ","
                                                + "'" + this.employee.getBirthPlace() + "',"
                                                + "'" + strBirthDate + "',"
                                                + this.employee.getReligionId() + ","
                                                + "'" + this.employee.getBloodType() + "',"
                                                + "'" + strCommencingDate + "',"
                                                + this.employee.getResigned() + ","
                                                + "'" + this.employee.getResignedDesc() + "',"
                                                + this.employee.getResignedReasonId() + ","
                                                + "'" + this.employee.getBarcodeNumber() + "',"
                                                + "'" + this.employee.getEmpPin() + "',"
                                                + "'" + this.employee.getTaxRegNr() + "',"
                                                + this.employee.getRace() + ","
                                                + +this.employee.getMaritalId() + ","//Gede_15Nov2011{
                                                + "'" + this.employee.getFather() + "',"
                                                + "'" + this.employee.getMother() + "',"
                                                + "'" + this.employee.getParentsAddress() + "'"
                                                + "'" + this.employee.getNameEmg() + "',"
                                                + "'" + this.employee.getPhoneEmg() + "',"
                                                + "'" + this.employee.getAddressEmg() + "',"//}
                                                //Gede_27Nov2011{
                                                + "'" + this.employee.getHodEmployeeId() + "',"//}
                                                //Ganki_27okt2014{
                                                + this.employee.getLocationId() + ","
                                                + "'" + strEndContract  + "',"
                                                + this.employee.getWorkassigncompanyId() +","
                                                + this.employee.getWorkassigndivisionId() +","
                                                + this.employee.getWorkassigndepartmentId() +","
                                                + this.employee.getWorkassignsectionId() +","
                                                + this.employee.getWorkassignpositionId() +"')";//}


                                        
                                        
                                        stmt = con.createStatement();
                                        stmt.executeUpdate(sql);

                                    } catch (Exception E) {
                                        System.out.println("[exception] INSERT INTO DATABASE BACKUP " + E.toString());
                                    } finally {
                                        try {
                                            stmt.close();
                                            con.close();
                                        } catch (Exception e) {
                                            System.out.println("EXCEPTION " + e.toString());
                                            msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                                        }
                                    }
                                }

                            } catch (Exception E) {
                                System.out.println("EXCEPTION " + E.toString());
                                msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                            }

                            /* Pengecekan untuk Database Finger Spot ( Exist or not )*/
                            if (!MachineFnSpot.equals("") && MachineFnSpot.equals("ok")) {

                                SessEmployee.insertUserInfo(this.employee.getBarcodeNumber(), this.employee.getFullName());

                            }

                        }

                        /**
                         * using in aiso to set employee to be contact
                         * PstContactList pstContactList = new PstContactList();
                         * if(employee.getIsAssignToAccounting()){ long
                         * oidContact =
                         * pstContactList.insertEmployeeToContact(this.employee);
                         * }else{ long oidContact =
                         * pstContactList.deleteEmployeeFromContact(oidEmployee);
                         * }
                         */
                        //on add new employee -- add also to leave stock
                        /*
                         if (oid != 0) {
                         LeaveStock stock = new LeaveStock();
                         stock.setEmployeeId(oid);
                         PstLeaveStock.insertExc(stock);
                         }
                         */
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                        return getControlMsgId(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                        return getControlMsgId(I_DBExceptionInfo.UNKNOWN);
                    }
                } else {
                    try {

                        long oid = 0;
                        if (updateNeedApproval.equals("1") && appUser.getAdminStatus() == 0){
                            oid = pstEmployee.updateExcPending(this.employee);
                            this.employee.setOID(oid);
                        } else {
                            oid = pstEmployee.updateExc(this.employee);
                        }
                        // logHistory
                        
                        boolean isValid = true;
                        if (sysLog == 1) {
                            
                            /* Inisialisasi logField dengan menggambil field EmpEducation */
                            /* Tips: ambil data field dari persistent */
                            String whereLog = PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_QUERY]+" = \""+pstEmployee.getQuery()+"\" "
                                        + " AND "+PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_LOG_STATUS]+" = 0";
                            Vector listLog = PstLogSysHistory.list(0, 0, whereLog, "");
                            if (listLog.size()>0){
                                isValid = false;
                            }
                            if (request != null & isValid) {
                                request.setAttribute("currData", this.employee);
                                request.setAttribute("prevData", prevEmployee);
                                request.setAttribute("query", pstEmployee.getQuery());
                                SessHistoryLog.updateEmployee(request);
                            }
                            employee = PstEmployee.fetchExc(oid);

                        }

                        /* Bila Proses yang dilakukan adalah edit */
                        if (oid != 0) {
                            
                            
                            String whereClause = PstCareerPath.fieldNames[PstCareerPath.FLD_EMPLOYEE_ID] + " = " + oid;   
                             Vector listcareerpath = PstCareerPath.listcheckcareer(0, 0, whereClause, null);
                                                        
                            if ((listcareerpath.size()==0) &&(this.employee.getEnd_contract()!=null)){
                                
                               
                                CareerPath careerPath= new CareerPath();
                                careerPath.setEmployeeId(oid);
                                careerPath.setCompanyId(this.employee.getCompanyId());
                                careerPath.setCompany(PstCareerPath.getCompany(String.valueOf(this.employee.getCompanyId()).toString()));
                                careerPath.setDepartmentId(this.employee.getDepartmentId());
                                careerPath.setDepartment(PstCareerPath.getDepartment(String.valueOf(this.employee.getDepartmentId()).toString()));
                                careerPath.setPositionId(this.employee.getPositionId());
                                careerPath.setPosition(PstCareerPath.getDepartment(String.valueOf(this.employee.getDepartmentId()).toString()));
                                careerPath.setSectionId(this.employee.getSectionId());
                                careerPath.setSection(PstCareerPath.getSection(String.valueOf(this.employee.getSectionId()).toString()));
                                careerPath.setWorkFrom(this.employee.getCommencingDate());
                                careerPath.setWorkTo(this.employee.getEnd_contract());
                                careerPath.setSalary(0);
                                careerPath.setDescription("First carrier");
                                careerPath.setEmpCategoryId(this.employee.getEmpCategoryId());
                                careerPath.setEmpCategory(PstCareerPath.getCategory(String.valueOf(this.employee.getEmpCategoryId()).toString()));
                              //  careerPath.set(this.employee.getCompanyId());
                                careerPath.setDivisionId(this.employee.getDivisionId());
                                careerPath.setDivision(PstCareerPath.getDivision(String.valueOf(this.employee.getDivisionId()).toString()));
                                careerPath.setLevelId(this.employee.getLevelId());
                                careerPath.setLevel(PstCareerPath.getLevel(String.valueOf(this.employee.getLevelId()).toString()));
                                careerPath.setLocationId(this.employee.getLocationId());
                                careerPath.setLocation(PstCareerPath.getLocation(String.valueOf(this.employee.getLocationId()).toString()));
                                //salah metode karena kariawan baru seharusnya belum masuk ke carrier path 20151212
                                //PstCareerPath.insertExc(careerPath);
                            }
                            
                            if (updateNeedApproval.equals("1") && appUser.getAdminStatus() == 0){
                                if (isValid){
                                    msgString = FRMMessage.getMsg(FRMMessage.MSG_ON_VALIDATION);
                                } else {
                                    msgString = FRMMessage.getMsg(FRMMessage.MSG_EXIST_ON_VALIDATION);
                                }
                            } else {
                                msgString = FRMMessage.getMsg(FRMMessage.MSG_UPDATED);
                            }
                            try {

                                String db_backup_url = PstSystemProperty.getValueByName("DB_BACKUP_URL");
                                String db_backup_usr = PstSystemProperty.getValueByName("DB_BACKUP_USR");
                                String db_backup_psd = PstSystemProperty.getValueByName("DB_BACKUP_PSWD");

                                /* Pengecekan kelengkapan konfigurasi di system property */
                                if (db_backup_url.compareTo(PstSystemProperty.SYS_NOT_INITIALIZED) != 0
                                        && db_backup_usr.compareTo(PstSystemProperty.SYS_NOT_INITIALIZED) != 0
                                        && db_backup_psd.compareTo(PstSystemProperty.SYS_NOT_INITIALIZED) != 0) {

                                    try {
                                        Class.forName("com.mysql.jdbc.Driver");
                                        System.out.println("Driver Found");
                                    } catch (ClassNotFoundException e) {
                                        javax.swing.JOptionPane.showMessageDialog(null, "Driver Not Found " + e.toString());
                                    }

                                    Connection con = null;
                                    Statement stmt = null;
                                    try {

                                        con = DriverManager.getConnection(db_backup_url, db_backup_usr, db_backup_psd);

                                        String strBirthDate = "";
                                        if (this.employee.getBirthDate() != null) {
                                            try {
                                                strBirthDate = Formater.formatDate(this.employee.getBirthDate(), "yyyy-MM-dd");
                                            } catch (Exception E) {
                                                System.out.println("[exc] Parsing Commencing Date" + E.toString());
                                                msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                                            }
                                        }
                                        
                                        String strEndContract = "";
                                        if (this.employee.getEnd_contract() != null) {
                                            try {
                                                strEndContract = Formater.formatDate(this.employee.getEnd_contract(), "yyyy-MM-dd");
                                            } catch (Exception E) {
                                                System.out.println("[exc] Parsing Commencing Date" + E.toString());
                                                msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                                            }
                                        }
                                        

                                        String strCommencingDate = "";
                                        if (this.employee.getCommencingDate() != null) {
                                            try {
                                                strCommencingDate = Formater.formatDate(this.employee.getCommencingDate(), "yyyy-MM-dd");
                                            } catch (Exception E) {
                                                System.out.println("[exc] Parsing Commencing Date" + E.toString());
                                                msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                                            }
                                        }

                                        String sql = "UPDATE " + PstEmployee.TBL_HR_EMPLOYEE + " SET "
                                                + PstEmployee.fieldNames[PstEmployee.FLD_COMPANY_ID] + " = " + this.employee.getCompanyId() + ","
                                                + PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID] + " = " + this.employee.getDivisionId() + ","
                                                + PstEmployee.fieldNames[PstEmployee.FLD_DEPARTMENT_ID] + " = " + this.employee.getDepartmentId() + ","
                                                + PstEmployee.fieldNames[PstEmployee.FLD_POSITION_ID] + " = " + this.employee.getPositionId() + ","
                                                + PstEmployee.fieldNames[PstEmployee.FLD_SECTION_ID] + " = " + this.employee.getSectionId() + ","
                                                + PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_NUM] + " = '" + this.employee.getEmployeeNum() + "',"
                                                + PstEmployee.fieldNames[PstEmployee.FLD_EMP_CATEGORY_ID] + " = " + this.employee.getEmpCategoryId() + ","
                                                + PstEmployee.fieldNames[PstEmployee.FLD_LEVEL_ID] + " = " + this.employee.getLevelId() + ","
                                                + PstEmployee.fieldNames[PstEmployee.FLD_FULL_NAME] + " = '" + this.employee.getFullName() + "',"
                                                + PstEmployee.fieldNames[PstEmployee.FLD_ADDRESS] + " = '" + this.employee.getAddress() + "',"
                                                + PstEmployee.fieldNames[PstEmployee.FLD_SEX] + " = " + this.employee.getSex() + ","
                                                + PstEmployee.fieldNames[PstEmployee.FLD_BIRTH_PLACE] + "= '" + this.employee.getBirthPlace() + "',"
                                                + PstEmployee.fieldNames[PstEmployee.FLD_BIRTH_DATE] + " = '" + strBirthDate + "',"
                                                + PstEmployee.fieldNames[PstEmployee.FLD_RELIGION_ID] + " = " + this.employee.getReligionId() + ","
                                                + PstEmployee.fieldNames[PstEmployee.FLD_BLOOD_TYPE] + " = '" + this.employee.getBloodType() + "',"
                                                + PstEmployee.fieldNames[PstEmployee.FLD_COMMENCING_DATE] + " = '" + strCommencingDate + "',"
                                                + PstEmployee.fieldNames[PstEmployee.FLD_RESIGNED] + " = " + this.employee.getResigned() + ","
                                                + PstEmployee.fieldNames[PstEmployee.FLD_RESIGNED_DESC] + " = '" + this.employee.getResignedDesc() + "',"
                                                + PstEmployee.fieldNames[PstEmployee.FLD_RESIGNED_REASON_ID] + " = " + this.employee.getResignedReasonId() + ","
                                                + PstEmployee.fieldNames[PstEmployee.FLD_TAX_REG_NR] + " = '" + this.employee.getTaxRegNr() + "',"
                                                + PstEmployee.fieldNames[PstEmployee.FLD_BARCODE_NUMBER] + " = '" + this.employee.getBarcodeNumber() + "',"
                                                + PstEmployee.fieldNames[PstEmployee.FLD_EMP_PIN] + " = '" + this.employee.getEmpPin() + "' " //Gede_15Nov2011{
                                                + PstEmployee.fieldNames[PstEmployee.FLD_FATHER] + " = '" + this.employee.getFather() + "',"
                                                + PstEmployee.fieldNames[PstEmployee.FLD_MOTHER] + " = '" + this.employee.getMother() + "',"
                                                + PstEmployee.fieldNames[PstEmployee.FLD_PARENTS_ADDRESS] + " = '" + this.employee.getParentsAddress() + "',"
                                                + PstEmployee.fieldNames[PstEmployee.FLD_NAME_EMG] + " = '" + this.employee.getNameEmg() + "',"
                                                + PstEmployee.fieldNames[PstEmployee.FLD_PHONE_EMG] + " = '" + this.employee.getPhoneEmg() + "',"
                                                + PstEmployee.fieldNames[PstEmployee.FLD_ADDRESS_EMG] + " = '" + this.employee.getAddressEmg() + "',"
                                                + PstEmployee.fieldNames[PstEmployee.FLD_HOD_EMPLOYEE_ID] + " = " + this.employee.getHodEmployeeId() + ","
                                                + PstEmployee.fieldNames[PstEmployee.FLD_LOCATION_ID] + " = " + this.employee.getLocationId() + ","
                                                + PstEmployee.fieldNames[PstEmployee.FLD_END_CONTRACT] + " = '" + this.employee.getEnd_contract() + "',"
                                                + PstEmployee.fieldNames[PstEmployee.FLD_WORK_ASSIGN_COMPANY_ID] + " = " + this.employee.getWorkassigncompanyId() + ","
                                                + PstEmployee.fieldNames[PstEmployee.FLD_WORK_ASSIGN_DIVISION_ID] + " = " + this.employee.getWorkassigndivisionId() + ","
                                                + PstEmployee.fieldNames[PstEmployee.FLD_WORK_ASSIGN_DEPARTMENT_ID] + " = " + this.employee.getWorkassigndepartmentId() + ","
                                                + PstEmployee.fieldNames[PstEmployee.FLD_WORK_ASSIGN_SECTION_ID] + " = " + this.employee.getWorkassignsectionId() + ","
                                                + PstEmployee.fieldNames[PstEmployee.FLD_WORK_ASSIGN_POSITION_ID] + " = " + this.employee.getWorkassignpositionId() + ","
                                                
                                                + " WHERE " + PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID] + " = " + oid;

                                        stmt = con.createStatement();
                                        stmt.executeUpdate(sql);

                                    } catch (Exception E) {
                                        System.out.println("[exception] UPDATE INTO DATABASE BACKUP " + E.toString());
                                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                                    } finally {
                                        try {
                                            stmt.close();
                                            con.close();
                                        } catch (Exception e) {
                                            System.out.println("EXCEPTION " + e.toString());
                                            msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                                        }
                                    }
                                }

                            } catch (Exception E) {
                                System.out.println("EXCEPTION " + E.toString());
                                msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                            }

                        }


                        /* Pengecekan bila ada perubahan barcode number, karena akan mengupdate database finger spot */
                        boolean updateBarcode = true;
                        boolean upMachine = false;

                        /* Penegcekan untuk mesin, apakah ada database mesin atau tidak */
                        //update by satrya 2012-11-09
                        if (employee.getBarcodeNumber() != null) {
                            if (!tmpBarcodeNumber.equals(employee.getBarcodeNumber()) && oid != 0) {

                                if (!MachineFnSpot.equals("") && MachineFnSpot.equals("ok")) {

                                    updateBarcode = SessEmployee.updateBarcodeAtt2010(tmpBarcodeNumber, employee.getBarcodeNumber(), employee.getFullName());
                                    upMachine = true;

                                }
                            }
                        }

                        if (!tmpFullName.equals(employee.getFullName()) && oid != 0 && updateBarcode == true) {

                            if (!MachineFnSpot.equals("") && MachineFnSpot.equals("ok")) {

                                SessEmployee.updateFullNameAtt2010(employee.getBarcodeNumber(), employee.getFullName());
                                upMachine = true;

                            }

                        }

                        if (upMachine) {
                            msgString = FRMMessage.getMsg(FRMMessage.MSG_UPDATE_DB_MACHINE);
                            return RSLT_FORM_INCOMPLETE;
                        }

                    } catch (DBException dbexc) {
                        System.out.println("Masuk 9:"+dbexc);
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        System.out.println("Masuk 10:"+exc);
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.EDIT:
                if (oidEmployee != 0) {
                    try {
                        employee = PstEmployee.fetchExc(oidEmployee);
                        if (employee.getLockerId() != 0) {
                            locker = PstLocker.fetchExc(employee.getLockerId());
                        }
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.ASK:
                if (oidEmployee != 0) {
                    try {
                        employee = PstEmployee.fetchExc(oidEmployee);
                        if (employee.getLockerId() != 0) {
                            locker = PstLocker.fetchExc(employee.getLockerId());
                        }
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.DELETE:
                System.out.println("oidEmployee " + oidEmployee);
                if (oidEmployee != 0) {
                    try {

                        Employee objEmployee = new Employee();

                        try {
                            objEmployee = PstEmployee.fetchExc(oidEmployee);
                            
                            logField = PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID]+";";
                            logField += PstEmployee.fieldNames[PstEmployee.FLD_DEPARTMENT_ID]+";";
                            logField += PstEmployee.fieldNames[PstEmployee.FLD_POSITION_ID]+";";
                            logField += PstEmployee.fieldNames[PstEmployee.FLD_SECTION_ID]+";";
                            logField += PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_NUM]+";";
                            logField += PstEmployee.fieldNames[PstEmployee.FLD_EMP_CATEGORY_ID]+";";
                            logField += PstEmployee.fieldNames[PstEmployee.FLD_LEVEL_ID]+";";
                            logField += PstEmployee.fieldNames[PstEmployee.FLD_FULL_NAME]+";";
                            logField += PstEmployee.fieldNames[PstEmployee.FLD_ADDRESS]+";";
                            logField += PstEmployee.fieldNames[PstEmployee.FLD_PHONE]+";";
                            logField += PstEmployee.fieldNames[PstEmployee.FLD_HANDPHONE]+";";
                            logField += PstEmployee.fieldNames[PstEmployee.FLD_POSTAL_CODE]+";";
                            logField += PstEmployee.fieldNames[PstEmployee.FLD_SEX]+";";
                            logField += PstEmployee.fieldNames[PstEmployee.FLD_BIRTH_PLACE]+";";
                            logField += PstEmployee.fieldNames[PstEmployee.FLD_BIRTH_DATE]+";";
                            logField += PstEmployee.fieldNames[PstEmployee.FLD_RELIGION_ID]+";";
                            logField += PstEmployee.fieldNames[PstEmployee.FLD_BLOOD_TYPE]+";";
                            logField += PstEmployee.fieldNames[PstEmployee.FLD_ASTEK_NUM]+";";
                            logField += PstEmployee.fieldNames[PstEmployee.FLD_ASTEK_DATE]+";";
                            logField += PstEmployee.fieldNames[PstEmployee.FLD_MARITAL_ID]+";";
                            logField += PstEmployee.fieldNames[PstEmployee.FLD_LOCKER_ID]+";";
                            logField += PstEmployee.fieldNames[PstEmployee.FLD_COMMENCING_DATE]+";";
                            logField += PstEmployee.fieldNames[PstEmployee.FLD_RESIGNED]+";";
                            logField += PstEmployee.fieldNames[PstEmployee.FLD_RESIGNED_DATE]+";";
                            logField += PstEmployee.fieldNames[PstEmployee.FLD_BARCODE_NUMBER]+";";
                            logField += PstEmployee.fieldNames[PstEmployee.FLD_RESIGNED_REASON_ID]+";";
                            logField += PstEmployee.fieldNames[PstEmployee.FLD_RESIGNED_DESC]+";";
                            logField += PstEmployee.fieldNames[PstEmployee.FLD_BASIC_SALARY]+";";
                            logField += PstEmployee.fieldNames[PstEmployee.FLD_ASSIGN_TO_ACCOUNTING]+";";
                            logField += PstEmployee.fieldNames[PstEmployee.FLD_DIVISION_ID]+";";
                            logField += PstEmployee.fieldNames[PstEmployee.FLD_CURIER]+";";
                            logField += PstEmployee.fieldNames[PstEmployee.FLD_INDENT_CARD_NR]+";";
                            logField += PstEmployee.fieldNames[PstEmployee.FLD_INDENT_CARD_VALID_TO]+";";
                            logField += PstEmployee.fieldNames[PstEmployee.FLD_TAX_REG_NR]+";";
                            logField += PstEmployee.fieldNames[PstEmployee.FLD_ADDRESS_FOR_TAX]+";";
                            logField += PstEmployee.fieldNames[PstEmployee.FLD_NATIONALITY_TYPE]+";";
                            logField += PstEmployee.fieldNames[PstEmployee.FLD_EMAIL_ADDRESS]+";";
                            logField += PstEmployee.fieldNames[PstEmployee.FLD_CATEGORY_DATE]+";";
                            logField += PstEmployee.fieldNames[PstEmployee.FLD_LEAVE_STATUS]+";";
                            logField += PstEmployee.fieldNames[PstEmployee.FLD_EMP_PIN]+";";
                            logField += PstEmployee.fieldNames[PstEmployee.FLD_RACE]+";";
                            logField += PstEmployee.fieldNames[PstEmployee.FLD_ADDRESS_PERMANENT]+";";
                            logField += PstEmployee.fieldNames[PstEmployee.FLD_PHONE_EMERGENCY]+";";
                            logField += PstEmployee.fieldNames[PstEmployee.FLD_COMPANY_ID]+";";
                            logField += PstEmployee.fieldNames[PstEmployee.FLD_FATHER]+";";
                            logField += PstEmployee.fieldNames[PstEmployee.FLD_MOTHER]+";";
                            logField += PstEmployee.fieldNames[PstEmployee.FLD_PARENTS_ADDRESS]+";";
                            logField += PstEmployee.fieldNames[PstEmployee.FLD_NAME_EMG]+";";
                            logField += PstEmployee.fieldNames[PstEmployee.FLD_PHONE_EMG]+";";
                            logField += PstEmployee.fieldNames[PstEmployee.FLD_ADDRESS_EMG]+";";
                            logField += PstEmployee.fieldNames[PstEmployee.FLD_HOD_EMPLOYEE_ID]+";";
                            logField += PstEmployee.fieldNames[PstEmployee.FLD_ADDR_COUNTRY_ID]+";";
                            logField += PstEmployee.fieldNames[PstEmployee.FLD_ADDR_PROVINCE_ID]+";";
                            logField += PstEmployee.fieldNames[PstEmployee.FLD_ADDR_REGENCY_ID]+";";
                            logField += PstEmployee.fieldNames[PstEmployee.FLD_ADDR_SUBREGENCY_ID]+";";
                            logField += PstEmployee.fieldNames[PstEmployee.FLD_ADDR_PMNT_COUNTRY_ID]+";";
                            logField += PstEmployee.fieldNames[PstEmployee.FLD_ADDR_PMNT_PROVINCE_ID]+";";
                            logField += PstEmployee.fieldNames[PstEmployee.FLD_ADDR_PMNT_REGENCY_ID]+";";
                            logField += PstEmployee.fieldNames[PstEmployee.FLD_ADDR_PMNT_SUBREGENCY_ID]+";";
                            logField += PstEmployee.fieldNames[PstEmployee.FLD_ID_CARD_ISSUED_BY]+";";
                            logField += PstEmployee.fieldNames[PstEmployee.FLD_ID_CARD_BIRTH_DATE]+";";
                            logField += PstEmployee.fieldNames[PstEmployee.FLD_TAX_MARITAL_ID]+";";
                            logField += PstEmployee.fieldNames[PstEmployee.FLD_NO_REKENING]+";";
                            logField += PstEmployee.fieldNames[PstEmployee.FLD_GRADE_LEVEL_ID]+";";
                            logField += PstEmployee.fieldNames[PstEmployee.FLD_LOCATION_ID]+";";
                            logField += PstEmployee.fieldNames[PstEmployee.FLD_END_CONTRACT]+";";
                            logField += PstEmployee.fieldNames[PstEmployee.FLD_WORK_ASSIGN_COMPANY_ID]+";";
                            logField += PstEmployee.fieldNames[PstEmployee.FLD_WORK_ASSIGN_DIVISION_ID]+";";
                            logField += PstEmployee.fieldNames[PstEmployee.FLD_WORK_ASSIGN_DEPARTMENT_ID]+";";
                            logField += PstEmployee.fieldNames[PstEmployee.FLD_WORK_ASSIGN_SECTION_ID]+";";
                            logField += PstEmployee.fieldNames[PstEmployee.FLD_WORK_ASSIGN_POSITION_ID]+";";
                            logField += PstEmployee.fieldNames[PstEmployee.FLD_ID_CARD_TYPE]+";";
                            logField += PstEmployee.fieldNames[PstEmployee.FLD_NPWP]+";";
                            logField += PstEmployee.fieldNames[PstEmployee.FLD_BPJS_NO]+";";
                            logField += PstEmployee.fieldNames[PstEmployee.FLD_BPJS_DATE]+";";
                            logField += PstEmployee.fieldNames[PstEmployee.FLD_SHIO]+";";
                            logField += PstEmployee.fieldNames[PstEmployee.FLD_ELEMEN]+";";
                            logField += PstEmployee.fieldNames[PstEmployee.FLD_IQ]+";";
                            logField += PstEmployee.fieldNames[PstEmployee.FLD_EQ]+";";
                            logField += PstEmployee.fieldNames[PstEmployee.FLD_PROBATION_END_DATE]+";";
                            logField += PstEmployee.fieldNames[PstEmployee.FLD_STATUS_PENSIUN_PROGRAM]+";";
                            logField += PstEmployee.fieldNames[PstEmployee.FLD_START_DATE_PENSIUN]+";";
                            logField += PstEmployee.fieldNames[PstEmployee.FLD_PRESENCE_CHECK_PARAMETER]+";";
                            logField += PstEmployee.fieldNames[PstEmployee.FLD_MEDICAL_INFO]+";";
                            logField += PstEmployee.fieldNames[PstEmployee.FLD_DANA_PENDIDIKAN]+";";
                            logField += PstEmployee.fieldNames[PstEmployee.FLD_PAYROLL_GROUP]+";";
                            logField += PstEmployee.fieldNames[PstEmployee.FLD_PROVIDER_ID]+";";
                            logField += PstEmployee.fieldNames[PstEmployee.FLD_MEMBER_OF_KESEHATAN]+";";
                            logField += PstEmployee.fieldNames[PstEmployee.FLD_MEMBER_OF_KETENAGAKERJAAN]+";";
                            logField += PstEmployee.fieldNames[PstEmployee.FLD_EMP_DOC_ID]+";";
                            logField += PstEmployee.fieldNames[PstEmployee.FLD_HISTORY_GROUP]+";";
                            logField += PstEmployee.fieldNames[PstEmployee.FLD_HISTORY_TYPE]+";";
                            /* prev */
                            logPrev = ""+objEmployee.getOID()+";";
                            logPrev += ""+objEmployee.getDepartmentId()+";";
                            logPrev += ""+objEmployee.getPositionId()+";";
                            logPrev += ""+objEmployee.getSectionId()+";";
                            logPrev += "'"+objEmployee.getEmployeeNum()+"';";
                            logPrev += ""+objEmployee.getEmpCategoryId()+";";
                            logPrev += ""+objEmployee.getLevelId()+";";
                            logPrev += "'"+objEmployee.getFullName()+"';";
                            logPrev += "'"+objEmployee.getAddress()+"';";
                            logPrev += "'"+objEmployee.getPhone()+"';";
                            logPrev += "'"+objEmployee.getHandphone()+"';";
                            logPrev += ""+objEmployee.getPostalCode()+";";
                            logPrev += ""+objEmployee.getSex()+";";
                            logPrev += "'"+objEmployee.getBirthPlace()+"';";
                            logPrev += "'"+objEmployee.getBirthDate()+"';";
                            logPrev += ""+objEmployee.getReligionId()+";";
                            logPrev += "'"+objEmployee.getBloodType()+"';";
                            logPrev += "'"+objEmployee.getAstekNum()+"';";
                            logPrev += "'"+objEmployee.getAstekDate()+"';";
                            logPrev += ""+objEmployee.getMaritalId()+";";
                            logPrev += ""+objEmployee.getTaxMaritalId()+";";
                            logPrev += ""+objEmployee.getLockerId()+";";
                            logPrev += "'"+objEmployee.getCommencingDate()+"';";
                            logPrev += ""+objEmployee.getResigned()+";";
                            logPrev += "'"+objEmployee.getResignedDate()+"';";
                            logPrev += "'"+objEmployee.getBarcodeNumber()+"';";
                            logPrev += ""+objEmployee.getResignedReasonId()+";";
                            logPrev += "'"+objEmployee.getResignedDesc()+"';";
                            logPrev += ""+objEmployee.getBasicSalary()+";";
                            logPrev += ""+objEmployee.getIsAssignToAccounting()+";";
                            logPrev += ""+objEmployee.getDivisionId()+";";
                            logPrev += "'"+objEmployee.getCurier()+"';";
                            logPrev += "'"+objEmployee.getIndentCardNr()+"';";
                            logPrev += "'"+objEmployee.getIndentCardValidTo()+"';";
                            logPrev += "'"+objEmployee.getTaxRegNr()+"';";
                            logPrev += "'"+objEmployee.getAddressForTax()+"';";
                            logPrev += ""+objEmployee.getNationalityType()+";";
                            logPrev += "'"+objEmployee.getEmailAddress()+"';";
                            logPrev += "'"+objEmployee.getCategoryDate()+"';";
                            logPrev += ""+objEmployee.getLeaveStatus()+";";
                            logPrev += "'"+objEmployee.getEmpPin()+"';";
                            logPrev += ""+objEmployee.getRace()+";";
                            logPrev += "'"+objEmployee.getAddressPermanent()+"';";
                            logPrev += "'"+objEmployee.getPhoneEmergency()+"';";
                            logPrev += ""+objEmployee.getCompanyId()+";";
                            logPrev += ""+objEmployee.getAddrCountryId()+";";
                            logPrev += ""+objEmployee.getAddrProvinceId()+";";
                            logPrev += ""+objEmployee.getAddrRegencyId()+";";
                            logPrev += ""+objEmployee.getAddrSubRegencyId()+";";
                            logPrev += ""+objEmployee.getAddrPmntCountryId()+";";
                            logPrev += ""+objEmployee.getAddrPmntProvinceId()+";";
                            logPrev += ""+objEmployee.getAddrPmntRegencyId()+";";
                            logPrev += ""+objEmployee.getAddrPmntSubRegencyId()+";";
                            logPrev += "'"+objEmployee.getIndentCardIssuedBy()+"';";
                            logPrev += "'"+objEmployee.getIndentCardBirthDate()+"';";
                            logPrev += "'"+objEmployee.getNoRekening()+"';";
                            logPrev += ""+objEmployee.getGradeLevelId()+";";
                            logPrev += ""+objEmployee.getCountIdx()+";";
                            logPrev += ""+objEmployee.getLocationId()+";";
                            logPrev += "'"+objEmployee.getEnd_contract()+"';";
                            logPrev += ""+objEmployee.getWorkassigncompanyId()+";";
                            logPrev += ""+objEmployee.getWorkassigndivisionId()+";";
                            logPrev += ""+objEmployee.getWorkassigndepartmentId()+";";
                            logPrev += ""+objEmployee.getWorkassignsectionId()+";";
                            logPrev += ""+objEmployee.getWorkassignpositionId()+";";
                            logPrev += "'"+objEmployee.getIdcardtype()+"';";
                            logPrev += "'"+objEmployee.getNpwp()+"';";
                            logPrev += "'"+objEmployee.getBpjs_no()+"';";
                            logPrev += "'"+objEmployee.getBpjs_date()+"';";
                            logPrev += "'"+objEmployee.getShio()+"';";
                            logPrev += "'"+objEmployee.getElemen()+"';";
                            logPrev += "'"+objEmployee.getIq()+"';";
                            logPrev += "'"+objEmployee.getEq()+"';";
                            logPrev += "'"+objEmployee.getProbationEndDate()+"';";
                            logPrev += ""+objEmployee.getStatusPensiunProgram()+";";
                            logPrev += "'"+objEmployee.getStartDatePensiun()+"';";
                            logPrev += ""+objEmployee.getPresenceCheckParameter()+";";
                            logPrev += "'"+objEmployee.getMedicalInfo()+"';";
                            logPrev += ""+objEmployee.getDanaPendidikan()+";";
                            logPrev += ""+objEmployee.getPayrollGroup()+";";
                            logPrev += ""+objEmployee.getProviderID()+";";
                            logPrev += ""+objEmployee.getMemOfBpjsKesahatan()+";";
                            logPrev += ""+objEmployee.getMemOfBpjsKetenagaKerjaan()+";";
                            logPrev += ""+objEmployee.getEmpDocId()+";";
                            logPrev += ""+objEmployee.getHistoryGroup()+";";
                            logPrev += ""+objEmployee.getHistoryType()+";";
                            
                        } catch (Exception e) {
                            System.out.println("Exception " + e.toString());
                        }

                        long oid = PstEmpLanguage.deleteByEmployee(oidEmployee);
                        oid = PstFamilyMember.deleteByEmployee(oidEmployee);
                        oid = PstExperience.deleteByEmployee(oidEmployee);

                        oid = PstCareerPath.deleteByEmployee(oidEmployee);
                        oid = PstEmpSalary.deleteByEmployee(oidEmployee);
                        oid = PstEmpSchedule.deleteByEmployee(oidEmployee);
                        oid = PstLeave.deleteByEmployee(oidEmployee);
                        oid = PstDayOfPayment.deleteByEmployee(oidEmployee);
                        oid = PstPresence.deleteByEmployee(oidEmployee);
                        oid = PstLocker.deleteByEmployee(oidEmployee);
                        oid = PstEmployee.deleteExc(oidEmployee);
                        
                        // logHistory
                        if (sysLog == 1) {

                            String className = employee.getClass().getName();

                            LogSysHistory logSysHistory = new LogSysHistory();

                            String reqUrl = request.getRequestURI().toString() + "?employee_oid=" + oidEmployee;

                            logSysHistory.setLogDocumentId(0);
                            logSysHistory.setLogUserId(userId);
                            logSysHistory.setApproverId(userId);
                            logSysHistory.setLogLoginName(loginName);
                            logSysHistory.setLogDocumentNumber("");
                            logSysHistory.setLogDocumentType(PstEmployee.TBL_HR_EMPLOYEE); //entity
                            logSysHistory.setLogUserAction("DELETE"); // command
                            logSysHistory.setLogOpenUrl(reqUrl); // locate jsp
                            logSysHistory.setLogUpdateDate(nowDate);
                            logSysHistory.setApproveDate(nowDate);
                            logSysHistory.setLogApplication(I_LogHistory.SYSTEM_NAME[I_LogHistory.SYSTEM_HAIRISMA]); // interface
                            logSysHistory.setLogDetail(logField); // apa yang dirubah
                            logSysHistory.setLogPrev(logPrev);
                            logSysHistory.setLogCurr(logPrev);
                            logSysHistory.setLogStatus(0);
                            logSysHistory.setLogModule("Data Pribadi");
                            logSysHistory.setLogEditedUserId(employee.getOID());
                            logSysHistory.setCompanyId(emp.getCompanyId());
                            logSysHistory.setDivisionId(emp.getDivisionId());
                            logSysHistory.setDepartmentId(emp.getDepartmentId());
                            logSysHistory.setSectionId(emp.getSectionId());

                            PstLogSysHistory.insertExc(logSysHistory);

                        }


                        /*Untuk penghapusan data di database backup untuk kasus NIKKO*/
                        try {

                            String db_backup_url = PstSystemProperty.getValueByName("DB_BACKUP_URL");
                            String db_backup_usr = PstSystemProperty.getValueByName("DB_BACKUP_USR");
                            String db_backup_psd = PstSystemProperty.getValueByName("DB_BACKUP_PSWD");

                            if (db_backup_url.compareTo(PstSystemProperty.SYS_NOT_INITIALIZED) != 0
                                    && db_backup_usr.compareTo(PstSystemProperty.SYS_NOT_INITIALIZED) != 0
                                    && db_backup_psd.compareTo(PstSystemProperty.SYS_NOT_INITIALIZED) != 0) {

                                try {
                                    Class.forName("com.mysql.jdbc.Driver");
                                    System.out.println("Driver Found");
                                } catch (ClassNotFoundException e) {
                                    javax.swing.JOptionPane.showMessageDialog(null, "Driver Not Found " + e.toString());
                                }

                                Connection con = null;
                                Statement stmt = null;
                                try {

                                    con = DriverManager.getConnection(db_backup_url, db_backup_usr, db_backup_psd);

                                    String sql = "DELETE FROM " + PstEmployee.TBL_HR_EMPLOYEE + " WHERE "
                                            + PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID] + " = " + oidEmployee;

                                    stmt = con.createStatement();
                                    stmt.executeUpdate(sql);

                                } catch (Exception E) {
                                    System.out.println("[exception] UPDATE INTO DATABASE BACKUP " + E.toString());
                                } finally {
                                    try {
                                        stmt.close();
                                        con.close();
                                    } catch (Exception e) {
                                        System.out.println("EXCEPTION " + e.toString());
                                    }
                                }
                            }

                        } catch (Exception E) {

                            System.out.println("[exception] " + E.toString());

                        }

                        /* Penghapusan untuk data pada database mesin finger spot*/

                        if (objEmployee.getOID() != 0) {
                            if (!MachineFnSpot.equals("") && MachineFnSpot.equals("ok")) {
                                SessEmployee.delDbFingerSpot(objEmployee.getBarcodeNumber());
                            }
                        }

                        if (oid != 0) {
                            msgString = FRMMessage.getMessage(FRMMessage.MSG_DELETED);
                            excCode = RSLT_OK;
                        } else {
                            msgString = FRMMessage.getMessage(FRMMessage.ERR_DELETED);
                            excCode = RSLT_FORM_INCOMPLETE;
                        }

                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            default:

        }
        return rsCode;
    }
}

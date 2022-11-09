/* 
 * Ctrl Name  		:  CtrlEmpLanguage.java 
 * Created on 	:  [date] [time] AM/PM 
 * 
 * @author  		: karya 
 * @version  		: 01 
 */
/**
 * *****************************************************************
 * Class Description : [project description ... ] Imput Parameters : [input
 * parameter ...] Output : [output ...] 
 ******************************************************************
 */
package com.dimata.harisma.form.employee;

/* java package */
import com.dimata.harisma.entity.admin.AppUser;
import com.dimata.harisma.entity.admin.PstAppUser;
import java.util.*;
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
import com.dimata.harisma.entity.log.I_LogHistory;
import com.dimata.harisma.entity.log.LogSysHistory;
import com.dimata.harisma.entity.log.PstLogSysHistory;
import com.dimata.harisma.entity.masterdata.EmployeeCompetency;
import com.dimata.harisma.entity.masterdata.Language;
import com.dimata.harisma.entity.masterdata.PstCompetency;
import com.dimata.harisma.entity.masterdata.PstEmployeeCompetency;
import com.dimata.harisma.entity.masterdata.PstLanguage;
import static com.dimata.harisma.form.employee.CtrlExperience.RSLT_OK;
import com.dimata.harisma.session.log.SessHistoryLog;
import com.dimata.system.entity.PstSystemProperty;

public class CtrlEmpLanguage extends Control implements I_Language {

    public static int RSLT_OK = 0;
    public static int RSLT_UNKNOWN_ERROR = 1;
    public static int RSLT_EST_CODE_EXIST = 2;
    public static int RSLT_FORM_INCOMPLETE = 3;
    public static String[][] resultText = {
        {"Berhasil", "Tidak dapat diproses", "NoPerkiraan sudah ada", "Data tidak lengkap"},
        {"Succes", "Can not process", "Estimation code exist", "Data incomplete"}
    };
    private int start;
    private String msgString;
    private EmpLanguage empLanguage;
    private PstEmpLanguage pstEmpLanguage;
    private FrmEmpLanguage frmEmpLanguage;
    int language = LANGUAGE_DEFAULT;

    public CtrlEmpLanguage(HttpServletRequest request) {
        msgString = "";
        empLanguage = new EmpLanguage();
        try {
            pstEmpLanguage = new PstEmpLanguage(0);
        } catch (Exception e) {;
        }
        frmEmpLanguage = new FrmEmpLanguage(request, empLanguage);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_DBExceptionInfo.MULTIPLE_ID:
                this.frmEmpLanguage.addError(frmEmpLanguage.FRM_FIELD_EMP_LANGUAGE_ID, resultText[language][RSLT_EST_CODE_EXIST]);
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

    public EmpLanguage getEmpLanguage() {
        return empLanguage;
    }

    public FrmEmpLanguage getForm() {
        return frmEmpLanguage;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidEmpLanguage, long oidEmployee, HttpServletRequest request, String loginName, long userId) {
        msgString = "";
        int excCode = I_DBExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        /* Prepare data (configurasi log system) */
        int sysLog = Integer.parseInt(String.valueOf(com.dimata.system.entity.system.PstSystemProperty.getPropertyLongbyName("SET_USER_ACTIVITY_LOG")));
        String updateNeedApproval = PstSystemProperty.getValueByName("UPDATE_DATA_NEED_APPROVAL");
        String logField = "";
        String logPrev = "";
        String logCurr = "";
        Date nowDate = new Date();
        AppUser appUser = new AppUser();
        Employee emp = new Employee();
        try {
            appUser = PstAppUser.fetch(userId);
            emp = PstEmployee.fetchExc(appUser.getEmployeeId());
        } catch (Exception e) {
            System.out.println("Get AppUser: userId: " + e.toString());
        }
        /* End Prepare data (configurasi log system) */

        switch (cmd) {
            case Command.ADD:
                break;

            case Command.SAVE:
                EmpLanguage prevEmployeeLang = null;
                if (oidEmpLanguage != 0) {
                    try {
                        empLanguage = PstEmpLanguage.fetchExc(oidEmpLanguage);

                        if (sysLog == 1) {
                            prevEmployeeLang = PstEmpLanguage.fetchExc(oidEmpLanguage);

                        }

                    } catch (Exception exc) {
                    }
                }

                empLanguage.setOID(oidEmpLanguage);
                frmEmpLanguage.requestEntityObject(empLanguage);
                empLanguage.setEmployeeId(oidEmployee);

                if (frmEmpLanguage.errorSize() > 0) {
                    msgString = FRMMessage.getMsg(FRMMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (empLanguage.getOID() == 0) {
                    try {
                        long oid = 0;
                        boolean isValid = true;
                        if (updateNeedApproval.equals("1") && appUser.getAdminStatus() == 0){
                            oid = pstEmpLanguage.insertExcPending(this.empLanguage);
                            this.empLanguage.setOID(oid);
                            String whereLog = PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_QUERY]+" = \""+pstEmpLanguage.getQuery()+"\" "
                                + " AND "+PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_LOG_STATUS]+" = 0";
                            Vector listLog = PstLogSysHistory.list(0, 0, whereLog, "");
                            if (listLog.size()>0){
                                isValid = false;
                            }
                            if (isValid){
                                request.setAttribute("insert", this.empLanguage);
                                request.setAttribute("query", pstEmpLanguage.getQuery());
                                SessHistoryLog.insertNDeleteLanguage(request);
                            }
                        } else {
                            oid = pstEmpLanguage.insertExc(this.empLanguage);
                        }
                        if (updateNeedApproval.equals("1") && appUser.getAdminStatus() == 0){
                            if (isValid){
                                msgString = FRMMessage.getMsg(FRMMessage.MSG_ON_VALIDATION);
                            } else {
                                msgString = FRMMessage.getMsg(FRMMessage.MSG_EXIST_ON_VALIDATION);
                            }
                        } else {
                            msgString = FRMMessage.getMsg(FRMMessage.MSG_SAVED);
                        }
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
                        boolean isValid = true;
                        if (updateNeedApproval.equals("1") && appUser.getAdminStatus() == 0){
                            oid = pstEmpLanguage.updateExcPending(this.empLanguage);
                            this.empLanguage.setOID(oid);
                            String whereLog = PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_QUERY]+" = \""+pstEmpLanguage.getQuery()+"\" "
                                + " AND "+PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_LOG_STATUS]+" = 0";
                            Vector listLog = PstLogSysHistory.list(0, 0, whereLog, "");
                            if (listLog.size()>0){
                                isValid = false;
                            }
                            if (isValid){
                                request.setAttribute("currData", this.empLanguage);
                                request.setAttribute("prevData", prevEmployeeLang);
                                request.setAttribute("query", pstEmpLanguage.getQuery());
                                SessHistoryLog.updateLanguage(request);
                            }
                        } else {
                            oid = pstEmpLanguage.updateExc(this.empLanguage);
                        }
                        if (updateNeedApproval.equals("1") && appUser.getAdminStatus() == 0){
                            if (isValid){
                                msgString = FRMMessage.getMsg(FRMMessage.MSG_ON_VALIDATION);
                            } else {
                                msgString = FRMMessage.getMsg(FRMMessage.MSG_EXIST_ON_VALIDATION);
                            }
                        } else {
                            msgString = FRMMessage.getMessage(FRMMessage.MSG_UPDATED);
                        }
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }

                }
                break;

            case Command.EDIT:
                if (oidEmpLanguage != 0) {
                    try {
                        empLanguage = PstEmpLanguage.fetchExc(oidEmpLanguage);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.ASK:
                if (oidEmpLanguage != 0) {
                    try {
                        empLanguage = PstEmpLanguage.fetchExc(oidEmpLanguage);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.DELETE:
                if (oidEmpLanguage != 0) {
                    try {
                        long oid = 0;
                        EmpLanguage empLanguage = PstEmpLanguage.fetchExc(oidEmpLanguage);
                        boolean isValid = true;
                        if (updateNeedApproval.equals("1") && appUser.getAdminStatus() == 0){
                            oid = PstEmpLanguage.deleteExcPending(oidEmpLanguage);
                            String whereLog = PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_QUERY]+" = \""+pstEmpLanguage.getQuery()+"\" "
                                + " AND "+PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_LOG_STATUS]+" = 0";
                            Vector listLog = PstLogSysHistory.list(0, 0, whereLog, "");
                            if (listLog.size()>0){
                                isValid = false;
                            }
                            if (isValid){
                                request.setAttribute("delete", empLanguage);
                                request.setAttribute("query", pstEmpLanguage.getQuery());
                                SessHistoryLog.insertNDeleteLanguage(request);
                            }
                        } else {
                            oid = PstEmpLanguage.deleteExc(oidEmpLanguage);
                        }
                        if (oid != 0) {
                            if (updateNeedApproval.equals("1") && appUser.getAdminStatus() == 0){
                                if (isValid){
                                    msgString = FRMMessage.getMsg(FRMMessage.MSG_ON_VALIDATION);
                                } else {
                                    msgString = FRMMessage.getMsg(FRMMessage.MSG_EXIST_ON_VALIDATION);
                                }
                            } else {
                                msgString = FRMMessage.getMessage(FRMMessage.MSG_DELETED);
                            }
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

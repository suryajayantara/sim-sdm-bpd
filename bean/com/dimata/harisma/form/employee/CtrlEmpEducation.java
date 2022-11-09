/* 
 * Ctrl Name  		:  CtrlEmpEducation.java 
 * Created on 	:  [date] [time] AM/PM 
 * 
 * @author  		:  [authorName] 
 * @version  		:  [version] 
 */
/**
 * *****************************************************************
 * Class Description : [project description ... ] Imput Parameters : [input
 * parameter ...] Output : [output ...] 
 ******************************************************************
 */
package com.dimata.harisma.form.employee;
 
/* java package */
import com.dimata.common.entity.contact.ContactList;
import com.dimata.common.entity.contact.PstContactList;
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
import com.dimata.harisma.entity.log.LogFeature;
import com.dimata.harisma.entity.log.LogSysHistory;
import com.dimata.harisma.entity.log.MessageLog;
import com.dimata.harisma.entity.log.PstLogSysHistory;
import com.dimata.harisma.entity.log.PstMessageLog;
import com.dimata.harisma.entity.masterdata.Education;
import com.dimata.harisma.entity.masterdata.PstEducation;
import com.dimata.harisma.session.log.SessHistoryLog;
import com.dimata.system.entity.system.PstSystemProperty;

public class CtrlEmpEducation extends Control implements I_Language {

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
    private EmpEducation empEducation;
    private PstEmpEducation pstEmpEducation;
    private FrmEmpEducation frmEmpEducation;
    int language = LANGUAGE_DEFAULT;

    public CtrlEmpEducation(HttpServletRequest request) {
        msgString = "";
        empEducation = new EmpEducation();
        try {
            pstEmpEducation = new PstEmpEducation(0);
        } catch (Exception e) {;
        }
        frmEmpEducation = new FrmEmpEducation(request, empEducation);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_DBExceptionInfo.MULTIPLE_ID:
                this.frmEmpEducation.addError(frmEmpEducation.FRM_FIELD_EMP_EDUCATION_ID, resultText[language][RSLT_EST_CODE_EXIST]);
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

    public EmpEducation getEmpEducation() {
        return empEducation;
    }

    public FrmEmpEducation getForm() {
        return frmEmpEducation;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidEmpEducation, long oidEmployee, HttpServletRequest request, String loginName, long userId) {
        msgString = "";
        int excCode = I_DBExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        /* Prepare data (configurasi log system) */
        LogFeature logFeature = new LogFeature();
        logFeature.setSysLog();
        logFeature.setEmployee(userId);
        String logField = "";
        String logPrev = "";
        String logCurr = "";
        String logModule = "Employee Education";
        String tblName = PstEmpEducation.TBL_HR_EMP_EDUCATION;
        String url = request.getRequestURI().toString();
        String actionName = "";
        String updateNeedApproval = com.dimata.system.entity.PstSystemProperty.getValueByName("UPDATE_DATA_NEED_APPROVAL");
        AppUser appUser = new AppUser();
        Employee emp = new Employee();
        try {
            appUser = PstAppUser.fetch(userId);
            emp = PstEmployee.fetchExc(appUser.getEmployeeId());
        } catch (Exception e) {
            System.out.println("Get AppUser: userId: " + e.toString());
        }
        switch (cmd) {
            case Command.ADD:
                break;

            case Command.SAVE:
                EmpEducation prevEmpEducation = null;
                if (oidEmpEducation != 0) {
                    try {
                        empEducation = PstEmpEducation.fetchExc(oidEmpEducation);
                        if (logFeature.getSysLog() != 0) {
                            prevEmpEducation = PstEmpEducation.fetchExc(oidEmpEducation);
                        }
                    } catch (Exception exc) {
                        System.out.println("getEmpEdu=>"+exc.toString());
                    }
                }
                empEducation.setOID(oidEmpEducation);
                frmEmpEducation.requestEntityObject(empEducation);
                empEducation.setEmployeeId(oidEmployee);

                if (frmEmpEducation.errorSize() > 0) {
                    msgString = FRMMessage.getMsg(FRMMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (empEducation.getOID() == 0) {
                    try {
                        long oid = 0;
                        boolean isValid = true;
                        if (updateNeedApproval.equals("1") && appUser.getAdminStatus() == 0){
                            oid = pstEmpEducation.insertExcPending(this.empEducation);
                            this.empEducation.setOID(oid);
                            String whereLog = PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_QUERY]+" = \""+pstEmpEducation.getQuery()+"\" "
                                + " AND "+PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_LOG_STATUS]+" = 0";
                            Vector listLog = PstLogSysHistory.list(0, 0, whereLog, "");
                            if (listLog.size()>0){
                                isValid = false;
                            }
                            if (isValid){
                                request.setAttribute("insert", this.empEducation);
                                request.setAttribute("query", pstEmpEducation.getQuery());
                                SessHistoryLog.insertNDeleteEducation(request);
                            }
                        } else {
                            oid = pstEmpEducation.insertExc(this.empEducation);
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
                            oid = pstEmpEducation.updateExcPending(this.empEducation);
                            this.empEducation.setOID(oid);
                            String whereLog = PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_QUERY]+" = \""+pstEmpEducation.getQuery()+"\" "
                                + " AND "+PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_LOG_STATUS]+" = 0";
                            Vector listLog = PstLogSysHistory.list(0, 0, whereLog, "");
                            if (listLog.size()>0){
                                isValid = false;
                            }
                            if (isValid){
                                request.setAttribute("currData", this.empEducation);
                                request.setAttribute("prevData", prevEmpEducation);
                                request.setAttribute("query", pstEmpEducation.getQuery());
                                SessHistoryLog.updateEducation(request);
                            }
                        } else {
                            oid = pstEmpEducation.updateExc(this.empEducation);
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
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }

                }
                break;

            case Command.EDIT:
                if (oidEmpEducation != 0) {
                    try {
                        empEducation = PstEmpEducation.fetchExc(oidEmpEducation);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.ASK:
                if (oidEmpEducation != 0) {
                    try {
                        empEducation = PstEmpEducation.fetchExc(oidEmpEducation);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.DELETE:
                if (oidEmpEducation != 0) {
                    try {
                        EmpEducation empEdukasi = PstEmpEducation.fetchExc(oidEmpEducation);
                        long oid = 0;
                        boolean isValid = true;
                        if (updateNeedApproval.equals("1") && appUser.getAdminStatus() == 0){
                            oid = PstEmpEducation.deleteExcPending(oidEmpEducation);
                            String whereLog = PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_QUERY]+" = \""+pstEmpEducation.getQuery()+"\" "
                                + " AND "+PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_LOG_STATUS]+" = 0";
                            Vector listLog = PstLogSysHistory.list(0, 0, whereLog, "");
                            if (listLog.size()>0){
                                isValid = false;
                            }
                            if (isValid){
                                request.setAttribute("delete", empEdukasi);
                                request.setAttribute("query", pstEmpEducation.getQuery());
                                SessHistoryLog.insertNDeleteEducation(request);
                            }
                        } else {
                            oid = PstEmpEducation.deleteExc(oidEmpEducation);
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

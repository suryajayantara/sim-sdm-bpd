/* 
 * Ctrl Name  		:  CtrlExperience.java 
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
import com.dimata.harisma.entity.log.LogSysHistory;
import com.dimata.harisma.entity.log.PstLogSysHistory;
import com.dimata.harisma.entity.masterdata.PstLanguage;
import com.dimata.harisma.session.log.SessHistoryLog;
import com.dimata.system.entity.PstSystemProperty;

public class CtrlExperience extends Control implements I_Language {

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
    private Experience experience;
    private PstExperience pstExperience;
    private FrmExperience frmExperience;
    int language = LANGUAGE_DEFAULT;

    public CtrlExperience(HttpServletRequest request) {
        msgString = "";
        experience = new Experience();
        try {
            pstExperience = new PstExperience(0);
        } catch (Exception e) {;
        }
        frmExperience = new FrmExperience(request, experience);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_DBExceptionInfo.MULTIPLE_ID:
                this.frmExperience.addError(frmExperience.FRM_FIELD_WORK_HISTORY_PAST_ID, resultText[language][RSLT_EST_CODE_EXIST]);
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

    public Experience getExperience() {
        return experience;
    }

    public FrmExperience getForm() {
        return frmExperience;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidExperience, long oidEmployee, HttpServletRequest request, String loginName, long userId) {
        msgString = "";
        int excCode = I_DBExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        int sysLog = Integer.parseInt(String.valueOf(PstSystemProperty.getPropertyLongbyName("SET_USER_ACTIVITY_LOG")));
        String updateNeedApproval = com.dimata.system.entity.PstSystemProperty.getValueByName("UPDATE_DATA_NEED_APPROVAL");
        //long sysLog = 1;
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
            System.out.println("Get AppUser: userId");
        }
        /* End Prepare data (configurasi log system) */
        switch (cmd) {
            case Command.ADD:
                break;

            case Command.SAVE:
                Experience prevExperience = null;
                if (oidExperience != 0) {
                    try {
                        experience = PstExperience.fetchExc(oidExperience);

                        if (sysLog == 1) {
                            prevExperience = PstExperience.fetchExc(oidExperience);

                        }

                    } catch (Exception exc) {
                    }
                }

                experience.setOID(oidExperience);

                frmExperience.requestEntityObject(experience);

                experience.setEmployeeId(oidEmployee);

                if (frmExperience.errorSize() > 0) {
                    msgString = FRMMessage.getMsg(FRMMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (experience.getOID() == 0) {
                    try {
                        long oid = 0;
                        boolean isValid = true;
                        if (updateNeedApproval.equals("1") && appUser.getAdminStatus() == 0){
                            oid = pstExperience.insertExcPending(this.experience);
                            this.experience.setOID(oid);
                            String whereLog = PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_QUERY]+" = \""+pstExperience.getQuery()+"\" "
                                + " AND "+PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_LOG_STATUS]+" = 0";
                            Vector listLog = PstLogSysHistory.list(0, 0, whereLog, "");
                            if (listLog.size()>0){
                                isValid = false;
                            }
                            if (isValid) {
                                request.setAttribute("insert", this.experience);
                                request.setAttribute("query", pstExperience.getQuery());
                                SessHistoryLog.insertNDeleteWorkHistory(request);
                            }
                        } else {
                            oid = pstExperience.insertExc(this.experience);
                        }
                        if (updateNeedApproval.equals("1") && appUser.getAdminStatus() == 0){
                            if (isValid) {
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
                            oid = pstExperience.updateExcPending(this.experience);
                            this.experience.setOID(oid);
                            String whereLog = PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_QUERY]+" = \""+pstExperience.getQuery()+"\" "
                                + " AND "+PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_LOG_STATUS]+" = 0";
                            Vector listLog = PstLogSysHistory.list(0, 0, whereLog, "");
                            if (listLog.size()>0){
                                isValid = false;
                            }
                            if (isValid) {
                                request.setAttribute("currData", this.experience);
                                request.setAttribute("prevData", prevExperience);
                                request.setAttribute("query", pstExperience.getQuery());
                                SessHistoryLog.updateWorkHistory(request);
                            }
                        } else {
                            oid = pstExperience.updateExc(this.experience);
                        }
                        if (updateNeedApproval.equals("1") && appUser.getAdminStatus() == 0){
                            if (isValid) {
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
                if (oidExperience != 0) {
                    try {
                        experience = PstExperience.fetchExc(oidExperience);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.ASK:
                if (oidExperience != 0) {
                    try {
                        experience = PstExperience.fetchExc(oidExperience);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.DELETE:
                if (oidExperience != 0) {
                    try {
                        Experience experience = PstExperience.fetchExc(oidExperience);
                        long oid = 0;
                        boolean isValid = true;
                        if (updateNeedApproval.equals("1") && appUser.getAdminStatus() == 0){
                            oid = PstExperience.deleteExcPending(oidExperience);
                            String whereLog = PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_QUERY]+" = \""+pstExperience.getQuery()+"\" "
                                + " AND "+PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_LOG_STATUS]+" = 0";
                            Vector listLog = PstLogSysHistory.list(0, 0, whereLog, "");
                            if (listLog.size()>0){
                                isValid = false;
                            }
                            if (isValid) {
                                request.setAttribute("delete", experience);
                                request.setAttribute("query", pstExperience.getQuery());
                                SessHistoryLog.insertNDeleteWorkHistory(request);
                            }
                        } else {
                            oid = PstExperience.deleteExc(oidExperience);
                        }
                        
                        if (oid != 0) {
                            if (updateNeedApproval.equals("1") && appUser.getAdminStatus() == 0){
                                if (isValid) {
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

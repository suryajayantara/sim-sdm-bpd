package com.dimata.harisma.form.employee;

// import java
import com.dimata.harisma.entity.admin.AppUser;
import com.dimata.harisma.entity.admin.PstAppUser;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;

// import dimata
import com.dimata.util.*;
import com.dimata.util.lang.*;

// import qdep
import com.dimata.qdep.db.*;
import com.dimata.qdep.form.*;
import com.dimata.qdep.system.*;

// import project
import com.dimata.harisma.entity.employee.*;
import com.dimata.harisma.entity.log.I_LogHistory;
import com.dimata.harisma.entity.log.LogSysHistory;
import com.dimata.harisma.entity.log.PstLogSysHistory;
import com.dimata.harisma.entity.masterdata.*;
import com.dimata.harisma.session.log.SessHistoryLog;
import com.dimata.system.entity.PstSystemProperty;

/**
 *
 * @author bayu
 */
public class CtrlEmpWarning extends Control implements I_Language {

    public static int RSLT_OK = 0;
    public static int RSLT_UNKNOWN_ERROR = 1;
    public static int RSLT_EST_CODE_EXIST = 2;
    public static int RSLT_FORM_INCOMPLETE = 3;

    public static String[][] resultText = {
        {"Berhasil", "Tidak dapat diproses", "Kode sudah ada", "Data tidak lengkap"},
        {"Success", "Can not process", "Code exist", "Data incomplete"}
    };

    private int start;
    private String msgString;
    private int language;
    private EmpWarning warning;
    private PstEmpWarning pstWarning;
    private FrmEmpWarning frmWarning;

    public CtrlEmpWarning(HttpServletRequest request) {
        msgString = "";
        language = LANGUAGE_DEFAULT;
        warning = new EmpWarning();

        try {
            pstWarning = new PstEmpWarning(0);
        } catch (Exception e) {
        }

        frmWarning = new FrmEmpWarning(request, warning);
    }

    public int getStart() {
        return start;
    }

    public String getMessage() {
        return msgString;
    }

    public EmpWarning getEmpWarning() {
        return warning;
    }

    public FrmEmpWarning getForm() {
        return frmWarning;
    }

    public int getLanguage() {
        return language;
    }

    public void setLanguage(int language) {
        this.language = language;
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_DBExceptionInfo.MULTIPLE_ID:
                frmWarning.addError(frmWarning.FRM_FIELD_EMPLOYEE_ID, resultText[language][RSLT_EST_CODE_EXIST]);
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

    public int action(int cmd, long oid, HttpServletRequest request, String loginName, long userId) {
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
        switch (cmd) {
            case Command.ADD:
                break;

            case Command.EDIT:
                if (oid != 0) {
                    try {
                        warning = PstEmpWarning.fetchExc(oid);

                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.SAVE:
                EmpWarning prevEmpWarning = null;
                if (oid != 0) {
                    try {
                        warning = PstEmpWarning.fetchExc(oid);
                        prevEmpWarning = PstEmpWarning.fetchExc(oid);
                    } catch (Exception exc) {
                    }
                }

                frmWarning.requestEntityObject(warning);

                if (frmWarning.errorSize() > 0) {
                    msgString = FRMMessage.getMsg(FRMMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (warning.getOID() == 0) {    // insert
                    try {
                        boolean isValid = true;
                        if (updateNeedApproval.equals("1") && appUser.getAdminStatus() == 0){
                            oid = pstWarning.insertExcPending(this.warning);
                            this.warning.setOID(oid);
                            String whereLog = PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_QUERY]+" = \""+pstWarning.getQuery()+"\" "
                                + " AND "+PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_LOG_STATUS]+" = 0";
                            Vector listLog = PstLogSysHistory.list(0, 0, whereLog, "");
                            if (listLog.size()>0){
                                isValid = false;
                            }
                            if (isValid) {
                                request.setAttribute("insert", this.warning);
                                request.setAttribute("query", pstWarning.getQuery());
                                SessHistoryLog.insertNDeleteWarning(request);
                            }
                        } else {
                            oid = pstWarning.insertExc(this.warning);
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
                        boolean isValid = true;
                        if (updateNeedApproval.equals("1") && appUser.getAdminStatus() == 0){
                            oid = pstWarning.updateExcPending(this.warning);
                            this.warning.setOID(oid);
                            String whereLog = PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_QUERY]+" = \""+pstWarning.getQuery()+"\" "
                                + " AND "+PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_LOG_STATUS]+" = 0";
                            Vector listLog = PstLogSysHistory.list(0, 0, whereLog, "");
                            if (listLog.size()>0){
                                isValid = false;
                            }
                            if (isValid) {
                                request.setAttribute("currData", this.warning);
                                request.setAttribute("prevData", prevEmpWarning);
                                request.setAttribute("query", pstWarning.getQuery());
                                SessHistoryLog.updateWarning(request);
                            }
                        } else {
                            oid = pstWarning.updateExc(this.warning);
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

            case Command.ASK:
                if (oid != 0) {
                    try {
                        msgString = FRMMessage.getMessage(FRMMessage.MSG_ASKDEL);
                        warning = PstEmpWarning.fetchExc(oid);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.DELETE:
                if (oid != 0) {
                    try {
                        EmpWarning empWarning = PstEmpWarning.fetchExc(oid);
                        boolean isValid = true;
                        if (updateNeedApproval.equals("1") && appUser.getAdminStatus() == 0){
                            oid = PstEmpWarning.deleteExcPending(oid);
                            String whereLog = PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_QUERY]+" = \""+pstWarning.getQuery()+"\" "
                                + " AND "+PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_LOG_STATUS]+" = 0";
                            Vector listLog = PstLogSysHistory.list(0, 0, whereLog, "");
                            if (listLog.size()>0){
                                isValid = false;
                            }
                            if (isValid) {
                                request.setAttribute("delete", empWarning);
                                request.setAttribute("query", pstWarning.getQuery());
                                SessHistoryLog.insertNDeleteWarning(request);
                            }
                        } else {
                            oid = PstEmpWarning.deleteExc(oid);
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
        }

        return rsCode;
    }
}

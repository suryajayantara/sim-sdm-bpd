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
import com.dimata.harisma.entity.masterdata.PstReprimand;
import com.dimata.harisma.entity.masterdata.Reprimand;
import com.dimata.harisma.session.log.SessHistoryLog;
import com.dimata.system.entity.PstSystemProperty;

/**
 *
 * @author bayu
 */
public class CtrlEmpReprimand extends Control implements I_Language {
    
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
    private EmpReprimand reprimand;
    private PstEmpReprimand pstReprimand;
    private FrmEmpReprimand frmReprimand;    
    
    public CtrlEmpReprimand(HttpServletRequest request) {
        msgString = "";        
        language = LANGUAGE_DEFAULT;
        reprimand = new EmpReprimand();
        
        try {
            pstReprimand = new PstEmpReprimand(0);
        } catch (Exception e) {
        }
        
        frmReprimand = new FrmEmpReprimand(request, reprimand);
    }
    
    public int getStart() {
        return start;
    }
    
    public String getMessage() {
        return msgString;
    }
    
    public EmpReprimand getEmpReprimand() {
        return reprimand;
    }
    
    public FrmEmpReprimand getForm() {
        return frmReprimand;
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
                frmReprimand.addError(frmReprimand.FRM_FIELD_EMPLOYEE_ID, resultText[language][RSLT_EST_CODE_EXIST]);
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
                        reprimand = PstEmpReprimand.fetchExc(oid);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {                        
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;
            
            
            
            case Command.SAVE:
                EmpReprimand prevEmpReprimand = null;
                if (oid != 0) {
                    try {
                        reprimand = PstEmpReprimand.fetchExc(oid);
                        prevEmpReprimand = PstEmpReprimand.fetchExc(oid);
                    } catch (Exception exc) {
                    }
                }
                
                frmReprimand.requestEntityObject(reprimand);
                
                if (frmReprimand.errorSize() > 0) {
                    msgString = FRMMessage.getMsg(FRMMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }
                
                if (reprimand.getOID() == 0) {    // insert
                    try {
                        boolean isValid = true;
                        if (updateNeedApproval.equals("1") && appUser.getAdminStatus() == 0){
                            oid = pstReprimand.insertExcPending(this.reprimand);
                            this.reprimand.setOID(oid);
                            String whereLog = PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_QUERY]+" = \""+pstReprimand.getQuery()+"\" "
                                + " AND "+PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_LOG_STATUS]+" = 0";
                            Vector listLog = PstLogSysHistory.list(0, 0, whereLog, "");
                            if (listLog.size()>0){
                                isValid = false;
                            }
                            if (isValid){
                                request.setAttribute("insert", this.reprimand);
                                request.setAttribute("query", pstReprimand.getQuery());
                                SessHistoryLog.insertNDeleteReprimand(request);
                            }
                        } else {
                            oid = pstReprimand.insertExc(this.reprimand);
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
                    
                } else {                      // update
                    try {
                        boolean isValid = true;
                        if (updateNeedApproval.equals("1") && appUser.getAdminStatus() == 0){
                            oid = pstReprimand.updateExcPending(this.reprimand);
                            this.reprimand.setOID(oid);
                            String whereLog = PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_QUERY]+" = \""+pstReprimand.getQuery()+"\" "
                                + " AND "+PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_LOG_STATUS]+" = 0";
                            Vector listLog = PstLogSysHistory.list(0, 0, whereLog, "");
                            if (listLog.size()>0){
                                isValid = false;
                            }
                            if (isValid) {
                                request.setAttribute("currData", this.reprimand);
                                request.setAttribute("prevData", prevEmpReprimand);
                                request.setAttribute("query", pstReprimand.getQuery());
                                SessHistoryLog.updateReprimand(request);
                            }
                        } else {
                            oid = pstReprimand.updateExc(this.reprimand);
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
                        reprimand = PstEmpReprimand.fetchExc(oid);
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
                        EmpReprimand empReprimand = PstEmpReprimand.fetchExc(oid);
                        boolean isValid = true;
                        if (updateNeedApproval.equals("1") && appUser.getAdminStatus() == 0){
                            oid = PstEmpReprimand.deleteExcPending(oid);
                            String whereLog = PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_QUERY]+" = \""+pstReprimand.getQuery()+"\" "
                                + " AND "+PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_LOG_STATUS]+" = 0";
                            Vector listLog = PstLogSysHistory.list(0, 0, whereLog, "");
                            if (listLog.size()>0){
                                isValid = false;
                            }
                            if (isValid){
                                request.setAttribute("delete", empReprimand);
                                request.setAttribute("query", pstReprimand.getQuery());
                                SessHistoryLog.insertNDeleteReprimand(request);
                            }
                        } else {
                            oid = PstEmpReprimand.deleteExc(oid);
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
        }
        
        return rsCode;
    }
}

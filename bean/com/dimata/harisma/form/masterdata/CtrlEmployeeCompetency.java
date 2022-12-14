/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.form.masterdata;

import com.dimata.harisma.entity.admin.AppUser;
import com.dimata.harisma.entity.admin.PstAppUser;
import com.dimata.harisma.entity.employee.PstEmployee;
import com.dimata.harisma.entity.log.I_LogHistory;
import com.dimata.harisma.entity.log.LogSysHistory;
import com.dimata.harisma.entity.log.PstLogSysHistory;
import javax.servlet.http.*;
import com.dimata.util.*;
import com.dimata.util.lang.*;
import com.dimata.qdep.system.*;
import com.dimata.qdep.form.*;
import com.dimata.qdep.db.*;
import com.dimata.harisma.entity.masterdata.*;
import com.dimata.harisma.entity.employee.*;
import com.dimata.harisma.session.log.SessHistoryLog;
import com.dimata.system.entity.PstSystemProperty;
import java.util.Date;
import java.util.Vector;

/*
 Description : Controll EmployeeCompetency
 Date : Tue Oct 06 2015
 Author : Hendra Putu
 */
public class CtrlEmployeeCompetency extends Control implements I_Language {

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
    private EmployeeCompetency entEmployeeCompetency;
    private PstEmployeeCompetency pstEmployeeCompetency;
    private FrmEmployeeCompetency frmEmployeeCompetency;
    int language = LANGUAGE_DEFAULT;

    public CtrlEmployeeCompetency(HttpServletRequest request) {
        msgString = "";
        entEmployeeCompetency = new EmployeeCompetency();
        try {
            pstEmployeeCompetency = new PstEmployeeCompetency(0);
        } catch (Exception e) {;
        }
        frmEmployeeCompetency = new FrmEmployeeCompetency(request, entEmployeeCompetency);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_DBExceptionInfo.MULTIPLE_ID:
                this.frmEmployeeCompetency.addError(frmEmployeeCompetency.FRM_FIELD_EMPLOYEE_COMP_ID, resultText[language][RSLT_EST_CODE_EXIST]);
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

    public EmployeeCompetency getEmployeeCompetency() {
        return entEmployeeCompetency;
    }

    public FrmEmployeeCompetency getForm() {
        return frmEmployeeCompetency;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidEmployeeCompetency, HttpServletRequest request, String loginName, long userId) {
        msgString = "";
        int excCode = I_DBExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        int sysLog = Integer.parseInt(String.valueOf(PstSystemProperty.getPropertyLongbyName("SET_USER_ACTIVITY_LOG")));
        String updateNeedApproval = PstSystemProperty.getValueByName("UPDATE_DATA_NEED_APPROVAL");
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

            case Command.SAVE:
                EmployeeCompetency prevEmployeeComp = null;
                if (oidEmployeeCompetency != 0) {
                    try {
                        entEmployeeCompetency = PstEmployeeCompetency.fetchExc(oidEmployeeCompetency);
                        
                        if(sysLog == 1 || updateNeedApproval.equals("1")){
                            prevEmployeeComp = PstEmployeeCompetency.fetchExc(oidEmployeeCompetency);
                            
                        }
                    } catch (Exception exc) {
                    }
                }

                frmEmployeeCompetency.requestEntityObject(entEmployeeCompetency);

                if (frmEmployeeCompetency.errorSize() > 0) {
                    msgString = FRMMessage.getMsg(FRMMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (entEmployeeCompetency.getOID() == 0) {
                    try {
                        long oid = 0;
                        boolean isValid = true;
                        if (updateNeedApproval.equals("1") && appUser.getAdminStatus() == 0){
                            oid = pstEmployeeCompetency.insertExcPending(this.entEmployeeCompetency);
                            this.entEmployeeCompetency.setOID(oid);
                            String whereLog = PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_QUERY]+" = \""+pstEmployeeCompetency.getQuery()+"\" "
                                + " AND "+PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_LOG_STATUS]+" = 0";
                            Vector listLog = PstLogSysHistory.list(0, 0, whereLog, "");
                            if (listLog.size()>0){
                                isValid = false;
                            }
                            if (isValid) {
                                request.setAttribute("insert", this.entEmployeeCompetency);
                                request.setAttribute("query", pstEmployeeCompetency.getQuery());
                                SessHistoryLog.insertNDeleteCompetency(request);
                            }
                        } else {
                            oid = pstEmployeeCompetency.insertExc(this.entEmployeeCompetency);
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
                            oid = pstEmployeeCompetency.updateExcPending(this.entEmployeeCompetency);
                            this.entEmployeeCompetency.setOID(oid);
                            String whereLog = PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_QUERY]+" = \""+pstEmployeeCompetency.getQuery()+"\" "
                                + " AND "+PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_LOG_STATUS]+" = 0";
                            Vector listLog = PstLogSysHistory.list(0, 0, whereLog, "");
                            if (listLog.size()>0){
                                isValid = false;
                            }
                            if (isValid) {
                                request.setAttribute("currData", this.entEmployeeCompetency);
                                request.setAttribute("prevData", prevEmployeeComp);
                                request.setAttribute("query", pstEmployeeCompetency.getQuery());
                                SessHistoryLog.updateCompetency(request);
                            }
                        } else {
                            oid = pstEmployeeCompetency.updateExc(this.entEmployeeCompetency);
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
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }

                }
                break;

            case Command.EDIT:
                if (oidEmployeeCompetency != 0) {
                    try {
                        entEmployeeCompetency = PstEmployeeCompetency.fetchExc(oidEmployeeCompetency);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.ASK:
                if (oidEmployeeCompetency != 0) {
                    try {
                        entEmployeeCompetency = PstEmployeeCompetency.fetchExc(oidEmployeeCompetency);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.DELETE:
                if (oidEmployeeCompetency != 0) {
                    try{
                        EmployeeCompetency empCompetency = PstEmployeeCompetency.fetchExc(oidEmployeeCompetency);
                        boolean isValid = true;
                        long oid = 0;
                        if (updateNeedApproval.equals("1") && appUser.getAdminStatus() == 0){
                            oid = PstEmployeeCompetency.deleteExcPending(oidEmployeeCompetency);
                            String whereLog = PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_QUERY]+" = \""+pstEmployeeCompetency.getQuery()+"\" "
                                + " AND "+PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_LOG_STATUS]+" = 0";
                            Vector listLog = PstLogSysHistory.list(0, 0, whereLog, "");
                            if (listLog.size()>0){
                                isValid = false;
                            }
                            if (isValid) {
                                request.setAttribute("delete", this.entEmployeeCompetency);
                                request.setAttribute("query", pstEmployeeCompetency.getQuery());
                                SessHistoryLog.insertNDeleteCompetency(request);
                            }
                        } else {
                            oid = PstEmployeeCompetency.deleteExc(oidEmployeeCompetency);
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

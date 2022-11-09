/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.form.employee;

import com.dimata.harisma.entity.admin.AppUser;
import com.dimata.harisma.entity.admin.PstAppUser;
import com.dimata.harisma.entity.employee.EmpAssessment;
import com.dimata.harisma.entity.employee.Employee;
import com.dimata.harisma.entity.employee.PstEmpAssessment;
import com.dimata.harisma.entity.employee.PstEmployee;
import com.dimata.harisma.entity.log.PstLogSysHistory;
import javax.servlet.http.*;
import com.dimata.util.*;
import com.dimata.util.lang.*;
import com.dimata.qdep.system.*;
import com.dimata.qdep.form.*;
import com.dimata.qdep.db.*;
import com.dimata.harisma.entity.masterdata.*;
import com.dimata.harisma.session.log.SessHistoryLog;
import com.dimata.system.entity.PstSystemProperty;
import java.util.Vector;

/**
 *
 * @author gndiw
 */
public class CtrlEmpAssessment extends Control implements I_Language {

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
    private EmpAssessment entEmpAssessment;
    private PstEmpAssessment pstEmpAssessment;
    private FrmEmpAssessment frmEmpAssessment;
    int language = LANGUAGE_DEFAULT;

    public CtrlEmpAssessment(HttpServletRequest request) {
        msgString = "";
        entEmpAssessment = new EmpAssessment();
        try {
            pstEmpAssessment = new PstEmpAssessment(0);
        } catch (Exception e) {;
        }
        frmEmpAssessment = new FrmEmpAssessment(request, entEmpAssessment);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_DBExceptionInfo.MULTIPLE_ID:
                this.frmEmpAssessment.addError(frmEmpAssessment.FRM_FIELD_EMP_ASSESSMENT_ID, resultText[language][RSLT_EST_CODE_EXIST]);
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

    public EmpAssessment getEmpAssessment() {
        return entEmpAssessment;
    }

    public FrmEmpAssessment getForm() {
        return frmEmpAssessment;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidEmpAssessment, long userId, String userName) {
        return action(cmd, oidEmpAssessment, userId, userName, null);
    }
    
    public int action(int cmd, long oidEmpAssessment, long userId, String userName, HttpServletRequest request) {
        msgString = "";
        int excCode = I_DBExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        String updateNeedApproval = PstSystemProperty.getValueByName("UPDATE_DATA_NEED_APPROVAL");
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
                EmpAssessment prevData = new EmpAssessment();
                if (oidEmpAssessment != 0) {
                    try {
                        entEmpAssessment = PstEmpAssessment.fetchExc(oidEmpAssessment);
                        prevData = PstEmpAssessment.fetchExc(oidEmpAssessment);
                    } catch (Exception exc) {
                    }
                }

                frmEmpAssessment.requestEntityObject(entEmpAssessment);

                if (frmEmpAssessment.errorSize() > 0) {
                    msgString = FRMMessage.getMsg(FRMMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (entEmpAssessment.getOID() == 0) {
                    try {
                        long oid = 0;
                        boolean isValid = true;
                        if (updateNeedApproval.equals("1") && appUser.getAdminStatus() == 0){
                            oid = pstEmpAssessment.insertExcPending(this.entEmpAssessment);
                            this.entEmpAssessment.setOID(oid);
                            String whereLog = PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_QUERY]+" = \""+pstEmpAssessment.getQuery()+"\" "
                                + " AND "+PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_LOG_STATUS]+" = 0";
                            Vector listLog = PstLogSysHistory.list(0, 0, whereLog, "");
                            if (listLog.size()>0){
                                isValid = false;
                            }
                            if (isValid){
                                request.setAttribute("insert", this.entEmpAssessment);
                                request.setAttribute("query", pstEmpAssessment.getQuery());
                                SessHistoryLog.insertNDeleteAssessment(request);
                            }
                        } else {
                            oid = pstEmpAssessment.insertExc(this.entEmpAssessment);
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
                            oid = pstEmpAssessment.updateExcPending(this.entEmpAssessment);
                            this.entEmpAssessment.setOID(oid);
                            String whereLog = PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_QUERY]+" = \""+pstEmpAssessment.getQuery()+"\" "
                                + " AND "+PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_LOG_STATUS]+" = 0";
                            Vector listLog = PstLogSysHistory.list(0, 0, whereLog, "");
                            if (listLog.size()>0){
                                isValid = false;
                            }
                            if (isValid){
                                request.setAttribute("currData", this.entEmpAssessment);
                                request.setAttribute("prevData", prevData);
                                request.setAttribute("query", pstEmpAssessment.getQuery());
                                SessHistoryLog.updateAssessment(request);
                            }
                        } else {
                            oid = pstEmpAssessment.updateExc(this.entEmpAssessment);
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
                if (oidEmpAssessment != 0) {
                    try {
                        entEmpAssessment = PstEmpAssessment.fetchExc(oidEmpAssessment);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.ASK:
                if (oidEmpAssessment != 0) {
                    try {
                        entEmpAssessment = PstEmpAssessment.fetchExc(oidEmpAssessment);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.DELETE:
                if (oidEmpAssessment != 0) {
                    try {
                        long oid = 0;
                        EmpAssessment empAssessment = PstEmpAssessment.fetchExc(oidEmpAssessment);
                        boolean isValid = true;
                        if (updateNeedApproval.equals("1") && appUser.getAdminStatus() == 0){
                            oid = PstEmpAssessment.deleteExcPending(oidEmpAssessment);
                            String whereLog = PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_QUERY]+" = \""+pstEmpAssessment.getQuery()+"\" "
                                + " AND "+PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_LOG_STATUS]+" = 0";
                            Vector listLog = PstLogSysHistory.list(0, 0, whereLog, "");
                            if (listLog.size()>0){
                                isValid = false;
                            }
                            if (isValid){
                                request.setAttribute("delete", empAssessment);
                                request.setAttribute("query", pstEmpAssessment.getQuery());
                                SessHistoryLog.insertNDeleteAssessment(request);
                            }
                        } else {
                            oid = PstEmpAssessment.deleteExc(oidEmpAssessment);
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
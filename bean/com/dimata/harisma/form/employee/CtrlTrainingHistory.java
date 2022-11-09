/* 
 * Ctrl Name  		:  CtrlTrainingHistory.java 
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

import com.dimata.gui.jsp.ControlDate;
import com.dimata.harisma.entity.admin.AppUser;
import com.dimata.harisma.entity.admin.PstAppUser;
import com.dimata.harisma.entity.employee.*;
import com.dimata.harisma.entity.log.I_LogHistory;
import com.dimata.harisma.entity.log.LogSysHistory;
import com.dimata.harisma.entity.log.PstLogSysHistory;
import com.dimata.harisma.entity.masterdata.*;
import com.dimata.harisma.session.log.SessHistoryLog;
import javax.servlet.http.*;
import com.dimata.util.*;
import com.dimata.util.lang.*;
import com.dimata.qdep.system.*;
import com.dimata.qdep.form.*;
import com.dimata.qdep.db.*;
import com.dimata.system.entity.PstSystemProperty;
import java.util.Date;
import java.util.Vector;

/*
 Description : Controll TrainingHistory
 Date : Thu Oct 08 2015
 Author : Hendra Putu
 */
public class CtrlTrainingHistory extends Control implements I_Language {

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
    private TrainingHistory entTrainingHistory;
    private PstTrainingHistory pstTrainingHistory;
    private FrmTrainingHistory frmTrainingHistory;
    int language = LANGUAGE_DEFAULT;

    public CtrlTrainingHistory(HttpServletRequest request) {
        msgString = "";
        entTrainingHistory = new TrainingHistory();
        try {
            pstTrainingHistory = new PstTrainingHistory(0);
        } catch (Exception e) {;
        }
        frmTrainingHistory = new FrmTrainingHistory(request, entTrainingHistory);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_DBExceptionInfo.MULTIPLE_ID:
                this.frmTrainingHistory.addError(frmTrainingHistory.FRM_FIELD_TRAINING_HISTORY_ID, resultText[language][RSLT_EST_CODE_EXIST]);
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

    public TrainingHistory getTrainingHistory() {
        return entTrainingHistory;
    }

    public FrmTrainingHistory getForm() {
        return frmTrainingHistory;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidTrainingHistory, HttpServletRequest request, String loginName, long userId) {
      return action(cmd, oidTrainingHistory,  request,  loginName, userId,0,0);
    }
    
    public int action(int cmd, long oidTrainingHistory, HttpServletRequest request, String loginName, long userId, double minPoint, double maxPoint) {
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

            case Command.SAVE:
                TrainingHistory prevTrainHistory = null;
                if (oidTrainingHistory != 0) {
                    try {
                        entTrainingHistory = PstTrainingHistory.fetchExc(oidTrainingHistory);
                        prevTrainHistory = PstTrainingHistory.fetchExc(oidTrainingHistory);
                    } catch (Exception exc) {
                    }
                }
                
                frmTrainingHistory.requestEntityObject(entTrainingHistory);
                Date timeStart = ControlDate.getTime(FrmTrainingHistory.fieldNames[FrmTrainingHistory.FRM_FIELD_START_TIME], request);
                Date timeEnd = ControlDate.getTime(FrmTrainingHistory.fieldNames[FrmTrainingHistory.FRM_FIELD_END_TIME], request);
                entTrainingHistory.setStartTime(timeStart);
                entTrainingHistory.setEndTime(timeEnd);

                if (frmTrainingHistory.errorSize() > 0) {
                    msgString = FRMMessage.getMsg(FRMMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }
                
                if ( minPoint!=maxPoint &&  (entTrainingHistory.getPoint()< minPoint || entTrainingHistory.getPoint()> maxPoint  ) ){
                    msgString = FRMMessage.getMsg(FRMMessage.MSG_DATA_OUT_OF_RANGE) + " : POINT " ;
                    return RSLT_FORM_INCOMPLETE;
                }
                

                if (entTrainingHistory.getOID() == 0) {
                    try {
                        long oid = 0;
                        boolean isValid = true;
                        if (updateNeedApproval.equals("1") && appUser.getAdminStatus() == 0){
                            oid = pstTrainingHistory.insertExcPending(this.entTrainingHistory);
                            this.entTrainingHistory.setOID(oid);
                            String whereLog = PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_QUERY]+" = \""+pstTrainingHistory.getQuery()+"\" "
                                + " AND "+PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_LOG_STATUS]+" = 0";
                            Vector listLog = PstLogSysHistory.list(0, 0, whereLog, "");
                            if (listLog.size()>0){
                                isValid = false;
                            }
                            if (isValid){
                                request.setAttribute("insert", this.entTrainingHistory);
                                request.setAttribute("query", pstTrainingHistory.getQuery());
                                SessHistoryLog.insertNDeleteTraining(request);
                            }
                        } else {
                            oid = pstTrainingHistory.insertExc(this.entTrainingHistory);
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
                            oid = pstTrainingHistory.updateExcPending(this.entTrainingHistory);
                            this.entTrainingHistory.setOID(oid);
                            String whereLog = PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_QUERY]+" = \""+pstTrainingHistory.getQuery()+"\" "
                                + " AND "+PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_LOG_STATUS]+" = 0";
                            Vector listLog = PstLogSysHistory.list(0, 0, whereLog, "");
                            if (listLog.size()>0){
                                isValid = false;
                            }
                            if (isValid) {
                                request.setAttribute("currData", this.entTrainingHistory);
                                request.setAttribute("prevData", prevTrainHistory);
                                request.setAttribute("query", pstTrainingHistory.getQuery());
                                SessHistoryLog.updateTraining(request);
                            }
                        } else {
                            oid = pstTrainingHistory.updateExc(this.entTrainingHistory);
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
                if (oidTrainingHistory != 0) {
                    try {
                        entTrainingHistory = PstTrainingHistory.fetchExc(oidTrainingHistory);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.ASK:
                if (oidTrainingHistory != 0) {
                    try {
                        entTrainingHistory = PstTrainingHistory.fetchExc(oidTrainingHistory);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.DELETE:
                if (oidTrainingHistory != 0) {
                    try {
                        boolean isValid = true;
                        entTrainingHistory = PstTrainingHistory.fetchExc(oidTrainingHistory);
                        long oid = 0;
                        if (updateNeedApproval.equals("1") && appUser.getAdminStatus() == 0){
                            oid = PstTrainingHistory.deleteExcPending(oidTrainingHistory);
                            String whereLog = PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_QUERY]+" = \""+pstTrainingHistory.getQuery()+"\" "
                                + " AND "+PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_LOG_STATUS]+" = 0";
                            Vector listLog = PstLogSysHistory.list(0, 0, whereLog, "");
                            if (listLog.size()>0){
                                isValid = false;
                            }
                            if (isValid) {
                                request.setAttribute("delete", entTrainingHistory);
                                request.setAttribute("query", pstTrainingHistory.getQuery());
                                SessHistoryLog.insertNDeleteTraining(request);
                            }
                        } else {
                            oid = PstTrainingHistory.deleteExc(oidTrainingHistory);
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

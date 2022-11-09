/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.form.outsource;

/**
 *
 * @author dimata005
 */
//public class CtrlOutSourcePlan {
//    
//}
import com.dimata.harisma.entity.outsource.OutSourcePlan;
import com.dimata.harisma.entity.outsource.PstOutSourcePlan;
import javax.servlet.http.*;
import com.dimata.util.*;
import com.dimata.util.lang.*;
import com.dimata.qdep.system.*;
import com.dimata.qdep.form.*;
import com.dimata.qdep.db.*;

/*
 Description : Controll OutSourcePlan
 Date : Mon Sep 14 2015
 Author : opie-eyek
 */
public class CtrlOutSourcePlan extends Control implements I_Language {

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
    private OutSourcePlan entOutSourcePlan;
    private PstOutSourcePlan pstOutSourcePlan;
    private FrmOutSourcePlan frmOutSourcePlan;
    int language = LANGUAGE_DEFAULT;

    public CtrlOutSourcePlan(HttpServletRequest request) {
        msgString = "";
        entOutSourcePlan = new OutSourcePlan();
        try {
            pstOutSourcePlan = new PstOutSourcePlan(0);
        } catch (Exception e) {;
        }
        frmOutSourcePlan = new FrmOutSourcePlan(request, entOutSourcePlan);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_DBExceptionInfo.MULTIPLE_ID:
                this.frmOutSourcePlan.addError(frmOutSourcePlan.FRM_FIELD_OUTSOURCEPLANID, resultText[language][RSLT_EST_CODE_EXIST]);
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

    public OutSourcePlan getOutSourcePlan() {
        return entOutSourcePlan;
    }

    public FrmOutSourcePlan getForm() {
        return frmOutSourcePlan;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidOutSourcePlan) {
        msgString = "";
        int excCode = I_DBExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case Command.ADD:
                break;

            case Command.SAVE:
                if (oidOutSourcePlan != 0) {
                    try {
                        entOutSourcePlan = PstOutSourcePlan.fetchExc(oidOutSourcePlan);
                    } catch (Exception exc) {
                    }
                }

                frmOutSourcePlan.requestEntityObject(entOutSourcePlan);

                if (frmOutSourcePlan.errorSize() > 0) {
                    msgString = FRMMessage.getMsg(FRMMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (entOutSourcePlan.getOID() == 0) {
                    try {
                        long oid = pstOutSourcePlan.insertExc(this.entOutSourcePlan);
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
                        long oid = pstOutSourcePlan.updateExc(this.entOutSourcePlan);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }

                }
                break;

            case Command.EDIT:
                if (oidOutSourcePlan != 0) {
                    try {
                        entOutSourcePlan = PstOutSourcePlan.fetchExc(oidOutSourcePlan);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.ASK:
                if (oidOutSourcePlan != 0) {
                    try {
                        entOutSourcePlan = PstOutSourcePlan.fetchExc(oidOutSourcePlan);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.DELETE:
                if (oidOutSourcePlan != 0) {
                    try {
                        long oid = PstOutSourcePlan.deleteExc(oidOutSourcePlan);
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
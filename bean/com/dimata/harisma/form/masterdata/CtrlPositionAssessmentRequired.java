/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.form.masterdata;

import javax.servlet.http.*;
import com.dimata.util.*;
import com.dimata.util.lang.*;
import com.dimata.qdep.system.*;
import com.dimata.qdep.form.*;
import com.dimata.qdep.db.*;
import com.dimata.harisma.entity.masterdata.*;

/**
 *
 * @author gndiw
 */
public class CtrlPositionAssessmentRequired extends Control implements I_Language {

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
    private PositionAssessmentRequired entPositionAssessmentRequired;
    private PstPositionAssessmentRequired pstPositionAssessmentRequired;
    private FrmPositionAssessmentRequired frmPositionAssessmentRequired;
    int language = LANGUAGE_DEFAULT;

    public CtrlPositionAssessmentRequired(HttpServletRequest request) {
        msgString = "";
        entPositionAssessmentRequired = new PositionAssessmentRequired();
        try {
            pstPositionAssessmentRequired = new PstPositionAssessmentRequired(0);
        } catch (Exception e) {;
        }
        frmPositionAssessmentRequired = new FrmPositionAssessmentRequired(request, entPositionAssessmentRequired);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_DBExceptionInfo.MULTIPLE_ID:
                this.frmPositionAssessmentRequired.addError(frmPositionAssessmentRequired.FRM_FIELD_POS_COMP_REQ_ID, resultText[language][RSLT_EST_CODE_EXIST]);
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

    public PositionAssessmentRequired getPositionAssessmentRequired() {
        return entPositionAssessmentRequired;
    }

    public FrmPositionAssessmentRequired getForm() {
        return frmPositionAssessmentRequired;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidPositionAssessmentRequired) {
        msgString = "";
        int excCode = I_DBExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case Command.ADD:
                break;

            case Command.SAVE:
                if (oidPositionAssessmentRequired != 0) {
                    try {
                        entPositionAssessmentRequired = PstPositionAssessmentRequired.fetchExc(oidPositionAssessmentRequired);
                    } catch (Exception exc) {
                    }
                }

                frmPositionAssessmentRequired.requestEntityObject(entPositionAssessmentRequired);

                if (frmPositionAssessmentRequired.errorSize() > 0) {
                    msgString = FRMMessage.getMsg(FRMMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (entPositionAssessmentRequired.getOID() == 0) {
                    try {
                        long oid = pstPositionAssessmentRequired.insertExc(this.entPositionAssessmentRequired);
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
                        long oid = pstPositionAssessmentRequired.updateExc(this.entPositionAssessmentRequired);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }

                }
                break;

            case Command.EDIT:
                if (oidPositionAssessmentRequired != 0) {
                    try {
                        entPositionAssessmentRequired = PstPositionAssessmentRequired.fetchExc(oidPositionAssessmentRequired);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.ASK:
                if (oidPositionAssessmentRequired != 0) {
                    try {
                        entPositionAssessmentRequired = PstPositionAssessmentRequired.fetchExc(oidPositionAssessmentRequired);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.DELETE:
                if (oidPositionAssessmentRequired != 0) {
                    try {
                        long oid = PstPositionAssessmentRequired.deleteExc(oidPositionAssessmentRequired);
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
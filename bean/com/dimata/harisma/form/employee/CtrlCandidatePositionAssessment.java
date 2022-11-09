/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.form.employee;

import javax.servlet.http.*;
import com.dimata.util.*;
import com.dimata.util.lang.*;
import com.dimata.qdep.system.*;
import com.dimata.qdep.form.*;
import com.dimata.qdep.db.*;
import com.dimata.harisma.entity.employee.*;

/**
 *
 * @author gndiw
 */
public class CtrlCandidatePositionAssessment extends Control implements I_Language {

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
    private CandidatePositionAssessment entCandidatePositionAssessment;
    private PstCandidatePositionAssessment pstCandidatePositionAssessment;
    private FrmCandidatePositionAssessment frmCandidatePositionAssessment;
    int language = LANGUAGE_DEFAULT;

    public CtrlCandidatePositionAssessment(HttpServletRequest request) {
        msgString = "";
        entCandidatePositionAssessment = new CandidatePositionAssessment();
        try {
            pstCandidatePositionAssessment = new PstCandidatePositionAssessment(0);
        } catch (Exception e) {;
        }
        frmCandidatePositionAssessment = new FrmCandidatePositionAssessment(request, entCandidatePositionAssessment);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_DBExceptionInfo.MULTIPLE_ID:
                this.frmCandidatePositionAssessment.addError(frmCandidatePositionAssessment.FRM_FIELD_CAND_POS_ASS_ID, resultText[language][RSLT_EST_CODE_EXIST]);
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

    public CandidatePositionAssessment getCandidatePositionAssessment() {
        return entCandidatePositionAssessment;
    }

    public FrmCandidatePositionAssessment getForm() {
        return frmCandidatePositionAssessment;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidCandidatePositionAssessment, long userId, String userName) {
        msgString = "";
        int excCode = I_DBExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case Command.ADD:
                break;

            case Command.SAVE:
                if (oidCandidatePositionAssessment != 0) {
                    try {
                        entCandidatePositionAssessment = PstCandidatePositionAssessment.fetchExc(oidCandidatePositionAssessment);
                    } catch (Exception exc) {
                    }
                }

                frmCandidatePositionAssessment.requestEntityObject(entCandidatePositionAssessment);

                if (frmCandidatePositionAssessment.errorSize() > 0) {
                    msgString = FRMMessage.getMsg(FRMMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (entCandidatePositionAssessment.getOID() == 0) {
                    try {
                        long oid = pstCandidatePositionAssessment.insertExc(this.entCandidatePositionAssessment);
                        msgString = FRMMessage.getMessage(FRMMessage.MSG_SAVED);
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
                        long oid = pstCandidatePositionAssessment.updateExc(this.entCandidatePositionAssessment);
                        msgString = FRMMessage.getMessage(FRMMessage.MSG_UPDATED);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }

                }
                break;

            case Command.EDIT:
                if (oidCandidatePositionAssessment != 0) {
                    try {
                        entCandidatePositionAssessment = PstCandidatePositionAssessment.fetchExc(oidCandidatePositionAssessment);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.ASK:
                if (oidCandidatePositionAssessment != 0) {
                    try {
                        entCandidatePositionAssessment = PstCandidatePositionAssessment.fetchExc(oidCandidatePositionAssessment);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.DELETE:
                if (oidCandidatePositionAssessment != 0) {
                    try {
                        long oid = PstCandidatePositionAssessment.deleteExc(oidCandidatePositionAssessment);
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
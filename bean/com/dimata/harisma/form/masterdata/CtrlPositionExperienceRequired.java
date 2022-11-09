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
 * @author Acer
 */
public class CtrlPositionExperienceRequired extends Control implements I_Language {

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
    private PositionExperienceRequired entPositionExperienceRequired;
    private PstPositionExperienceRequired pstPositionExperienceRequired;
    private FrmPositionExperienceRequired frmPositionExperienceRequired;
    int language = LANGUAGE_DEFAULT;

    public CtrlPositionExperienceRequired(HttpServletRequest request) {
        msgString = "";
        entPositionExperienceRequired = new PositionExperienceRequired();
        try {
            pstPositionExperienceRequired = new PstPositionExperienceRequired(0);
        } catch (Exception e) {;
        }
        frmPositionExperienceRequired = new FrmPositionExperienceRequired(request, entPositionExperienceRequired);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_DBExceptionInfo.MULTIPLE_ID:
                this.frmPositionExperienceRequired.addError(frmPositionExperienceRequired.FRM_FIELD_POS_EXPERIENCE_REQ_ID, resultText[language][RSLT_EST_CODE_EXIST]);
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

    public PositionExperienceRequired getPositionExperienceRequired() {
        return entPositionExperienceRequired;
    }

    public FrmPositionExperienceRequired getForm() {
        return frmPositionExperienceRequired;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidPositionExperienceRequired) {
        msgString = "";
        int excCode = I_DBExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case Command.ADD:
                break;

            case Command.SAVE:
                if (oidPositionExperienceRequired != 0) {
                    try {
                        entPositionExperienceRequired = PstPositionExperienceRequired.fetchExc(oidPositionExperienceRequired);
                    } catch (Exception exc) {
                    }
                }

                frmPositionExperienceRequired.requestEntityObject(entPositionExperienceRequired);

                if (frmPositionExperienceRequired.errorSize() > 0) {
                    msgString = FRMMessage.getMsg(FRMMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (entPositionExperienceRequired.getOID() == 0) {
                    try {
                        long oid = pstPositionExperienceRequired.insertExc(this.entPositionExperienceRequired);
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
                        long oid = pstPositionExperienceRequired.updateExc(this.entPositionExperienceRequired);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }

                }
                break;

            case Command.EDIT:
                if (oidPositionExperienceRequired != 0) {
                    try {
                        entPositionExperienceRequired = PstPositionExperienceRequired.fetchExc(oidPositionExperienceRequired);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.ASK:
                if (oidPositionExperienceRequired != 0) {
                    try {
                        entPositionExperienceRequired = PstPositionExperienceRequired.fetchExc(oidPositionExperienceRequired);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.DELETE:
                if (oidPositionExperienceRequired != 0) {
                    try {
                        long oid = PstPositionExperienceRequired.deleteExc(oidPositionExperienceRequired);
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

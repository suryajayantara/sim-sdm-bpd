/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.form.masterdata;

import com.dimata.harisma.entity.masterdata.FrmKpiGroupPosition;
import com.dimata.harisma.entity.masterdata.KpiGroupPosition;
import com.dimata.harisma.entity.masterdata.PstKpiGroupPosition;
import com.dimata.qdep.db.DBException;
import com.dimata.qdep.form.Control;
import com.dimata.qdep.form.FRMMessage;
import com.dimata.qdep.system.I_DBExceptionInfo;
import com.dimata.util.Command;
import com.dimata.util.lang.I_Language;
import javax.servlet.http.HttpServletRequest;

/**
 *
 * @author keys
 */
public class CtrlKpiGroupPosition extends Control implements I_Language {
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
private KpiGroupPosition entKpiGroupPosition;
private PstKpiGroupPosition pstKpiTypeCompany;
private FrmKpiGroupPosition frmKpiGroupPosition;
int language = LANGUAGE_DEFAULT;

    public CtrlKpiGroupPosition(HttpServletRequest request) {
        msgString = "";
        entKpiGroupPosition = new KpiGroupPosition();
        try {
            pstKpiTypeCompany = new PstKpiGroupPosition(0);
        } catch (Exception e) {;
        }
        frmKpiGroupPosition = new FrmKpiGroupPosition(request, entKpiGroupPosition);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_DBExceptionInfo.MULTIPLE_ID:
                this.frmKpiGroupPosition.addError(frmKpiGroupPosition.FRM_FIELD_KPI_GROUP_DIVISON_ID, resultText[language][RSLT_EST_CODE_EXIST]);
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

    public KpiGroupPosition getKpiTypePosition() {
        return entKpiGroupPosition;
    }

    public FrmKpiGroupPosition getForm() {
        return frmKpiGroupPosition;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
}

    public int action(int cmd, long oidKpiGroupPosition, long userId, String userName) {
        msgString = "";
        int excCode = I_DBExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case Command.ADD:
                break;

            case Command.SAVE:
                if (oidKpiGroupPosition != 0) {
                    try {
                        entKpiGroupPosition = PstKpiGroupPosition.fetchExc(oidKpiGroupPosition);
                    } catch (Exception exc) {
                    }
                }

                frmKpiGroupPosition.requestEntityObject(entKpiGroupPosition);

                
                if (frmKpiGroupPosition.errorSize() > 0) {
                    msgString = FRMMessage.getMsg(FRMMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (entKpiGroupPosition.getOID() == 0) {
                    try {
                        long oid = pstKpiTypeCompany.insertExc(this.entKpiGroupPosition);
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
                        long oid = pstKpiTypeCompany.updateExc(this.entKpiGroupPosition);
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
                if (oidKpiGroupPosition != 0) {
                    try {
                        entKpiGroupPosition = PstKpiGroupPosition.fetchExc(oidKpiGroupPosition);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.ASK:
                if (oidKpiGroupPosition != 0) {
                    try {
                        entKpiGroupPosition = PstKpiGroupPosition.fetchExc(oidKpiGroupPosition);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.DELETE:
                if (oidKpiGroupPosition != 0) {
                    try {
                        long oid = PstKpiGroupPosition.deleteExc(oidKpiGroupPosition);
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

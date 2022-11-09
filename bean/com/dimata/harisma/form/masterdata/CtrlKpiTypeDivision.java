/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.form.masterdata;

import com.dimata.harisma.entity.masterdata.KpiTypeDivision;
import com.dimata.harisma.entity.masterdata.PstKpiTypeDivision;

import com.dimata.qdep.db.DBException;
import com.dimata.qdep.form.Control;
import com.dimata.qdep.form.FRMMessage;
import com.dimata.qdep.system.I_DBExceptionInfo;
import com.dimata.util.Command;
import com.dimata.util.lang.I_Language;
import static com.dimata.util.lang.I_Language.LANGUAGE_DEFAULT;
import javax.servlet.http.HttpServletRequest;

/**
 *
 * @author User
 */
public class CtrlKpiTypeDivision extends Control implements I_Language {
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
private KpiTypeDivision entKpiTypeDivision;
private PstKpiTypeDivision pstKpiTypeDivision;
private FrmKpiTypeDivision frmKpiTypeDivision;
int language = LANGUAGE_DEFAULT;

    public CtrlKpiTypeDivision(HttpServletRequest request) {
        msgString = "";
        entKpiTypeDivision = new KpiTypeDivision();
        try {
            pstKpiTypeDivision = new PstKpiTypeDivision(0);
        } catch (Exception e) {;
        }
        frmKpiTypeDivision = new FrmKpiTypeDivision(request, entKpiTypeDivision);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_DBExceptionInfo.MULTIPLE_ID:
                this.frmKpiTypeDivision.addError(frmKpiTypeDivision.FRM_FIELD_KPI_TYPE_DIVISION_ID, resultText[language][RSLT_EST_CODE_EXIST]);
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

    public KpiTypeDivision getKpiTypeDivision() {
        return entKpiTypeDivision;
    }

    public FrmKpiTypeDivision getForm() {
        return frmKpiTypeDivision;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
}

    public int action(int cmd, long oidKpiTypeDivision, long userId, String userName) {
        msgString = "";
        int excCode = I_DBExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case Command.ADD:
                break;

            case Command.SAVE:
                if (oidKpiTypeDivision != 0) {
                    try {
                        entKpiTypeDivision = PstKpiTypeDivision.fetchExc(oidKpiTypeDivision);
                    } catch (Exception exc) {
                    }
                }

                frmKpiTypeDivision.requestEntityObject(entKpiTypeDivision);

                if (frmKpiTypeDivision.errorSize() > 0) {
                    msgString = FRMMessage.getMsg(FRMMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (entKpiTypeDivision.getOID() == 0) {
                    try {
                        long oid = pstKpiTypeDivision.insertExc(this.entKpiTypeDivision);
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
                        long oid = pstKpiTypeDivision.updateExc(this.entKpiTypeDivision);
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
                if (oidKpiTypeDivision != 0) {
                    try {
                        entKpiTypeDivision = PstKpiTypeDivision.fetchExc(oidKpiTypeDivision);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.ASK:
                if (oidKpiTypeDivision != 0) {
                    try {
                        entKpiTypeDivision = PstKpiTypeDivision.fetchExc(oidKpiTypeDivision);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.DELETE:
                if (oidKpiTypeDivision != 0) {
                    try {
                        long oid = PstKpiTypeDivision.deleteExc(oidKpiTypeDivision);
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

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.form.masterdata;

import com.dimata.harisma.entity.masterdata.KpiGroupDivision;
import com.dimata.harisma.entity.masterdata.PstKpiGroupDivision;
import com.dimata.qdep.form.*;
import com.dimata.qdep.system.*;
import com.dimata.qdep.db.*;
import com.dimata.util.Command;
import com.dimata.util.lang.I_Language;
import javax.servlet.http.HttpServletRequest;

/**
 *
 * @author keys
 */
public class CtrlKpiGroupDivision extends Control implements I_Language {
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
private KpiGroupDivision entKpiGroupDivision;
private PstKpiGroupDivision pstKpiTypeCompany;
private FrmKpiGroupDivision frmKpiGroupDivision;
int language = LANGUAGE_DEFAULT;

    public CtrlKpiGroupDivision(HttpServletRequest request) {
        msgString = "";
        entKpiGroupDivision = new KpiGroupDivision();
        try {
            pstKpiTypeCompany = new PstKpiGroupDivision(0);
        } catch (Exception e) {;
        }
        frmKpiGroupDivision = new FrmKpiGroupDivision(request, entKpiGroupDivision);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_DBExceptionInfo.MULTIPLE_ID:
                this.frmKpiGroupDivision.addError(frmKpiGroupDivision.FRM_FIELD_KPI_GROUP_DIVISON_ID, resultText[language][RSLT_EST_CODE_EXIST]);
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

    public KpiGroupDivision getKpiGrupDivision() {
        return entKpiGroupDivision;
    }

    public FrmKpiGroupDivision getForm() {
        return frmKpiGroupDivision;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
}

    public int action(int cmd, long oidKpiGroupDivision, long userId, String userName) {
        msgString = "";
        int excCode = I_DBExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case Command.ADD:
                break;

            case Command.SAVE:
                if (oidKpiGroupDivision != 0) {
                    try {
                        entKpiGroupDivision = PstKpiGroupDivision.fetchExc(oidKpiGroupDivision);
                    } catch (Exception exc) {
                    }
                }

                frmKpiGroupDivision.requestEntityObject(entKpiGroupDivision);

                
                if (frmKpiGroupDivision.errorSize() > 0) {
                    msgString = FRMMessage.getMsg(FRMMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (entKpiGroupDivision.getOID() == 0) {
                    try {
                        long oid = pstKpiTypeCompany.insertExc(this.entKpiGroupDivision);
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
                        long oid = pstKpiTypeCompany.updateExc(this.entKpiGroupDivision);
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
                if (oidKpiGroupDivision != 0) {
                    try {
                        entKpiGroupDivision = PstKpiGroupDivision.fetchExc(oidKpiGroupDivision);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.ASK:
                if (oidKpiGroupDivision != 0) {
                    try {
                        entKpiGroupDivision = PstKpiGroupDivision.fetchExc(oidKpiGroupDivision);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.DELETE:
                if (oidKpiGroupDivision != 0) {
                    try {
                        long oid = PstKpiGroupDivision.deleteExc(oidKpiGroupDivision);
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

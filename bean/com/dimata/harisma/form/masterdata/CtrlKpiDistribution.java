/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.form.masterdata;

/**
 *
 * @author User
 */
import javax.servlet.http.*;
import com.dimata.util.*;
import com.dimata.util.lang.*;
import com.dimata.qdep.system.*;
import com.dimata.qdep.form.*;
import com.dimata.qdep.db.*;
import com.dimata.harisma.entity.masterdata.*;

/*
Description : Controll KpiDistribution
Date : Mon Oct 31 2022
Author : SURYAWAN
 */
public class CtrlKpiDistribution extends Control implements I_Language {

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
    private KpiDistribution entKpiDistribution;
    private PstKpiDistribution pstKpiDistribution;
    private FrmKpiDistribution frmKpiDistribution;
    int language = LANGUAGE_DEFAULT;

    public CtrlKpiDistribution(HttpServletRequest request) {
        msgString = "";
        entKpiDistribution = new KpiDistribution();
        try {
            pstKpiDistribution = new PstKpiDistribution(0);
        } catch (Exception e) {;
        }
        frmKpiDistribution = new FrmKpiDistribution(request, entKpiDistribution);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_DBExceptionInfo.MULTIPLE_ID:
                this.frmKpiDistribution.addError(frmKpiDistribution.FRM_FIELD_KPI_DISTRIBUTION_ID, resultText[language][RSLT_EST_CODE_EXIST]);
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

    public KpiDistribution getKpiDistribution() {
        return entKpiDistribution;
    }

    public FrmKpiDistribution getForm() {
        return frmKpiDistribution;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidKpiDistribution) {
        msgString = "";
        int excCode = I_DBExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case Command.ADD:
                break;

            case Command.SAVE:
                if (oidKpiDistribution != 0) {
                    try {
                        entKpiDistribution = PstKpiDistribution.fetchExc(oidKpiDistribution);
                    } catch (Exception exc) {
                    }
                }

                frmKpiDistribution.requestEntityObject(entKpiDistribution);

                if (frmKpiDistribution.errorSize() > 0) {
                    msgString = FRMMessage.getMsg(FRMMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (entKpiDistribution.getOID() == 0) {
                    try {
                        long oid = pstKpiDistribution.insertExc(this.entKpiDistribution);
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
                        long oid = pstKpiDistribution.updateExc(this.entKpiDistribution);
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
                if (oidKpiDistribution != 0) {
                    try {
                        entKpiDistribution = PstKpiDistribution.fetchExc(oidKpiDistribution);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.ASK:
                if (oidKpiDistribution != 0) {
                    try {
                        entKpiDistribution = PstKpiDistribution.fetchExc(oidKpiDistribution);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.DELETE:
                if (oidKpiDistribution != 0) {
                    try {
                        long oid = PstKpiDistribution.deleteExc(oidKpiDistribution);
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

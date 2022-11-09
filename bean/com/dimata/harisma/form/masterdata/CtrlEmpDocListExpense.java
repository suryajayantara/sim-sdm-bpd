/*
 * To change this template, choose Tools | Templates
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

/*
 Description : Controll EmpDocListExpense
 Date : Thu Feb 16 2017
 Author : Gunadi
 */
public class CtrlEmpDocListExpense extends Control implements I_Language {

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
    private EmpDocListExpense entEmpDocListExpense;
    private PstEmpDocListExpense pstEmpDocListExpense;
    private FrmEmpDocListExpense frmEmpDocListExpense;
    int language = LANGUAGE_DEFAULT;

    public CtrlEmpDocListExpense(HttpServletRequest request) {
        msgString = "";
        entEmpDocListExpense = new EmpDocListExpense();
        try {
            pstEmpDocListExpense = new PstEmpDocListExpense(0);
        } catch (Exception e) {;
        }
        frmEmpDocListExpense = new FrmEmpDocListExpense(request, entEmpDocListExpense);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_DBExceptionInfo.MULTIPLE_ID:
                this.frmEmpDocListExpense.addError(frmEmpDocListExpense.FRM_FIELD_EMP_DOC_LIST_EXPENSE_ID, resultText[language][RSLT_EST_CODE_EXIST]);
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

    public EmpDocListExpense getEmpDocListExpense() {
        return entEmpDocListExpense;
    }

    public FrmEmpDocListExpense getForm() {
        return frmEmpDocListExpense;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidEmpDocListExpense) {
        msgString = "";
        int excCode = I_DBExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case Command.ADD:
                break;

            case Command.SAVE:
                if (oidEmpDocListExpense != 0) {
                    try {
                        entEmpDocListExpense = PstEmpDocListExpense.fetchExc(oidEmpDocListExpense);
                    } catch (Exception exc) {
                    }
                }

                frmEmpDocListExpense.requestEntityObject(entEmpDocListExpense);

                if (frmEmpDocListExpense.errorSize() > 0) {
                    msgString = FRMMessage.getMsg(FRMMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (entEmpDocListExpense.getOID() == 0) {
                    try {
                        long oid = pstEmpDocListExpense.insertExc(this.entEmpDocListExpense);
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
                        long oid = pstEmpDocListExpense.updateExc(this.entEmpDocListExpense);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }

                }
                break;

            case Command.EDIT:
                if (oidEmpDocListExpense != 0) {
                    try {
                        entEmpDocListExpense = PstEmpDocListExpense.fetchExc(oidEmpDocListExpense);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.ASK:
                if (oidEmpDocListExpense != 0) {
                    try {
                        entEmpDocListExpense = PstEmpDocListExpense.fetchExc(oidEmpDocListExpense);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.DELETE:
                if (oidEmpDocListExpense != 0) {
                    try {
                        long oid = PstEmpDocListExpense.deleteExc(oidEmpDocListExpense);
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
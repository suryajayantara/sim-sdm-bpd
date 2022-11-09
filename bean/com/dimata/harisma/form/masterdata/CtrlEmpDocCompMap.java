/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.form.masterdata;

/**
 *
 * @author keys
 */
import javax.servlet.http.*;
import com.dimata.util.*;
import com.dimata.util.lang.*;
import com.dimata.qdep.system.*;
import com.dimata.qdep.form.*;
import com.dimata.qdep.db.*;
import com.dimata.harisma.entity.masterdata.*;

/*
Description : Controll EmpDocCompMap
Date : Mon Nov 22 2021
Author : eri
*/

public class CtrlEmpDocCompMap extends Control implements I_Language {
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
    private EmpDocCompMap entEmpDocCompMap;
    private PstEmpDocCompMap pstEmpDocCompMap;
    private FrmEmpDocCompMap frmEmpDocCompMap;
    int language = LANGUAGE_DEFAULT;

    public CtrlEmpDocCompMap(HttpServletRequest request) {
        msgString = "";
        entEmpDocCompMap = new EmpDocCompMap();
        try {
            pstEmpDocCompMap = new PstEmpDocCompMap(0);
        } catch (Exception e) {;
        }
        frmEmpDocCompMap = new FrmEmpDocCompMap(request, entEmpDocCompMap);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_DBExceptionInfo.MULTIPLE_ID:
                this.frmEmpDocCompMap.addError(frmEmpDocCompMap.FRM_FIELD_DOC_COMP_MAP_ID, resultText[language][RSLT_EST_CODE_EXIST]);
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

    public EmpDocCompMap getEmpDocCompMap() {
        return entEmpDocCompMap;
    }

    public FrmEmpDocCompMap getForm() {
        return frmEmpDocCompMap;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidEmpDocCompMap) {
        msgString = "";
        int excCode = I_DBExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case Command.ADD:
                break;

            case Command.SAVE:
                if (oidEmpDocCompMap != 0) {
                    try {
                        entEmpDocCompMap = PstEmpDocCompMap.fetchExc(oidEmpDocCompMap);
                    } catch (Exception exc) {
                    }
                }

                frmEmpDocCompMap.requestEntityObject(entEmpDocCompMap);

                if (frmEmpDocCompMap.errorSize() > 0) {
                    msgString = FRMMessage.getMsg(FRMMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (entEmpDocCompMap.getOID() == 0) {
                    try {
                        long oid = pstEmpDocCompMap.insertExc(this.entEmpDocCompMap);
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
                        long oid = pstEmpDocCompMap.updateExc(this.entEmpDocCompMap);
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
                if (oidEmpDocCompMap != 0) {
                    try {
                        entEmpDocCompMap = PstEmpDocCompMap.fetchExc(oidEmpDocCompMap);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.ASK:
                if (oidEmpDocCompMap != 0) {
                    try {
                        entEmpDocCompMap = PstEmpDocCompMap.fetchExc(oidEmpDocCompMap);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.DELETE:
                if (oidEmpDocCompMap != 0) {
                    try {
                        long oid = PstEmpDocCompMap.deleteExc(oidEmpDocCompMap);
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
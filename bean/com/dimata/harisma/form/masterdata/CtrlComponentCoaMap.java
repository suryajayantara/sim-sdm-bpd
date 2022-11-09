/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.form.masterdata;

/**
 *
 * @author Dimata 007
 */
import javax.servlet.http.*;
import com.dimata.util.*;
import com.dimata.util.lang.*;
import com.dimata.qdep.system.*;
import com.dimata.qdep.form.*;
import com.dimata.qdep.db.*;
import com.dimata.harisma.entity.masterdata.*;

/*
 Description : Controll ComponentCoaMap
 Date : Wed Jul 06 2016
 Author : Hendra McHen
 */
public class CtrlComponentCoaMap extends Control implements I_Language {

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
    private ComponentCoaMap entComponentCoaMap;
    private PstComponentCoaMap pstComponentCoaMap;
    private FrmComponentCoaMap frmComponentCoaMap;
    int language = LANGUAGE_DEFAULT;

    public CtrlComponentCoaMap(HttpServletRequest request) {
        msgString = "";
        entComponentCoaMap = new ComponentCoaMap();
        try {
            pstComponentCoaMap = new PstComponentCoaMap(0);
        } catch (Exception e) {;
        }
        frmComponentCoaMap = new FrmComponentCoaMap(request, entComponentCoaMap);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_DBExceptionInfo.MULTIPLE_ID:
                this.frmComponentCoaMap.addError(frmComponentCoaMap.FRM_FIELD_COMPONENT_COA_MAP_ID, resultText[language][RSLT_EST_CODE_EXIST]);
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

    public ComponentCoaMap getComponentCoaMap() {
        return entComponentCoaMap;
    }

    public FrmComponentCoaMap getForm() {
        return frmComponentCoaMap;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidComponentCoaMap) {
        msgString = "";
        int excCode = I_DBExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case Command.ADD:
                break;

            case Command.SAVE:
                if (oidComponentCoaMap != 0) {
                    try {
                        entComponentCoaMap = PstComponentCoaMap.fetchExc(oidComponentCoaMap);
                    } catch (Exception exc) {
                    }
                }

                frmComponentCoaMap.requestEntityObject(entComponentCoaMap);

                if (frmComponentCoaMap.errorSize() > 0) {
                    msgString = FRMMessage.getMsg(FRMMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (entComponentCoaMap.getOID() == 0) {
                    try {
                        long oid = pstComponentCoaMap.insertExc(this.entComponentCoaMap);
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
                        long oid = pstComponentCoaMap.updateExc(this.entComponentCoaMap);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }

                }
                break;

            case Command.EDIT:
                if (oidComponentCoaMap != 0) {
                    try {
                        entComponentCoaMap = PstComponentCoaMap.fetchExc(oidComponentCoaMap);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.ASK:
                if (oidComponentCoaMap != 0) {
                    try {
                        entComponentCoaMap = PstComponentCoaMap.fetchExc(oidComponentCoaMap);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.DELETE:
                if (oidComponentCoaMap != 0) {
                    try {
                        long oid = PstComponentCoaMap.deleteExc(oidComponentCoaMap);
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
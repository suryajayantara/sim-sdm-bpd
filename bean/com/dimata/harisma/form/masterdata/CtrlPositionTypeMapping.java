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
public class CtrlPositionTypeMapping  extends Control implements I_Language {

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
    private PositionTypeMapping entPositionTypeMapping;
    private PstPositionTypeMapping pstPositionTypeMapping;
    private FrmPositionTypeMapping frmPositionTypeMapping;
    int language = LANGUAGE_DEFAULT;

    public CtrlPositionTypeMapping(HttpServletRequest request) {
        msgString = "";
        entPositionTypeMapping = new PositionTypeMapping();
        try {
            pstPositionTypeMapping = new PstPositionTypeMapping(0);
        } catch (Exception e) {;
        }
        frmPositionTypeMapping = new FrmPositionTypeMapping(request, entPositionTypeMapping);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_DBExceptionInfo.MULTIPLE_ID:
                this.frmPositionTypeMapping.addError(frmPositionTypeMapping.FRM_FIELD_POSITION_TYPE_MAPPING_ID, resultText[language][RSLT_EST_CODE_EXIST]);
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

    public PositionTypeMapping getPositionTypeMapping() {
        return entPositionTypeMapping;
    }

    public FrmPositionTypeMapping getForm() {
        return frmPositionTypeMapping;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidPositionTypeMapping, long userId, String userName) {
        msgString = "";
        int excCode = I_DBExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case Command.ADD:
                break;

            case Command.SAVE:
                if (oidPositionTypeMapping != 0) {
                    try {
                        entPositionTypeMapping = PstPositionTypeMapping.fetchExc(oidPositionTypeMapping);
                    } catch (Exception exc) {
                    }
                }

                frmPositionTypeMapping.requestEntityObject(entPositionTypeMapping);

                if (frmPositionTypeMapping.errorSize() > 0) {
                    msgString = FRMMessage.getMsg(FRMMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (entPositionTypeMapping.getOID() == 0) {
                    try {
                        long oid = pstPositionTypeMapping.insertExc(this.entPositionTypeMapping);
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
                        long oid = pstPositionTypeMapping.updateExc(this.entPositionTypeMapping);
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
                if (oidPositionTypeMapping != 0) {
                    try {
                        entPositionTypeMapping = PstPositionTypeMapping.fetchExc(oidPositionTypeMapping);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.ASK:
                if (oidPositionTypeMapping != 0) {
                    try {
                        entPositionTypeMapping = PstPositionTypeMapping.fetchExc(oidPositionTypeMapping);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.DELETE:
                if (oidPositionTypeMapping != 0) {
                    try {
                        long oid = PstPositionTypeMapping.deleteExc(oidPositionTypeMapping);
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
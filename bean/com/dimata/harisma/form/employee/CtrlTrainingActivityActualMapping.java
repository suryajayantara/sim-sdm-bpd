/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.form.employee;

/**
 *
 * @author Gunadi
 */
import javax.servlet.http.*;
import com.dimata.util.*;
import com.dimata.util.lang.*;
import com.dimata.qdep.system.*;
import com.dimata.qdep.form.*;
import com.dimata.qdep.db.*;
import com.dimata.harisma.entity.employee.*;

public class CtrlTrainingActivityActualMapping extends Control implements I_Language {

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
    private TrainingActivityActualMapping entTrainingActivityActualMapping;
    private PstTrainingActivityActualMapping pstTrainingActivityActualMapping;
    private FrmTrainingActivityActualMapping frmTrainingActivityActualMapping;
    int language = LANGUAGE_DEFAULT;

    public CtrlTrainingActivityActualMapping(HttpServletRequest request) {
        msgString = "";
        entTrainingActivityActualMapping = new TrainingActivityActualMapping();
        try {
            pstTrainingActivityActualMapping = new PstTrainingActivityActualMapping(0);
        } catch (Exception e) {;
        }
        frmTrainingActivityActualMapping = new FrmTrainingActivityActualMapping(request, entTrainingActivityActualMapping);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_DBExceptionInfo.MULTIPLE_ID:
                this.frmTrainingActivityActualMapping.addError(frmTrainingActivityActualMapping.FRM_FIELD_TRAINING_ACTIVITY_ACTUAL_MAPPING_ID, resultText[language][RSLT_EST_CODE_EXIST]);
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

    public TrainingActivityActualMapping getTrainingActivityActualMapping() {
        return entTrainingActivityActualMapping;
    }

    public FrmTrainingActivityActualMapping getForm() {
        return frmTrainingActivityActualMapping;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidTrainingActivityActualMapping) {
        msgString = "";
        int excCode = I_DBExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case Command.ADD:
                break;

            case Command.SAVE:
                if (oidTrainingActivityActualMapping != 0) {
                    try {
                        entTrainingActivityActualMapping = PstTrainingActivityActualMapping.fetchExc(oidTrainingActivityActualMapping);
                    } catch (Exception exc) {
                    }
                }

                frmTrainingActivityActualMapping.requestEntityObject(entTrainingActivityActualMapping);

                if (frmTrainingActivityActualMapping.errorSize() > 0) {
                    msgString = FRMMessage.getMsg(FRMMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (entTrainingActivityActualMapping.getOID() == 0) {
                    try {
                        long oid = pstTrainingActivityActualMapping.insertExc(this.entTrainingActivityActualMapping);
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
                        long oid = pstTrainingActivityActualMapping.updateExc(this.entTrainingActivityActualMapping);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }

                }
                break;

            case Command.EDIT:
                if (oidTrainingActivityActualMapping != 0) {
                    try {
                        entTrainingActivityActualMapping = PstTrainingActivityActualMapping.fetchExc(oidTrainingActivityActualMapping);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.ASK:
                if (oidTrainingActivityActualMapping != 0) {
                    try {
                        entTrainingActivityActualMapping = PstTrainingActivityActualMapping.fetchExc(oidTrainingActivityActualMapping);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.DELETE:
                if (oidTrainingActivityActualMapping != 0) {
                    try {
                        long oid = PstTrainingActivityActualMapping.deleteExc(oidTrainingActivityActualMapping);
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
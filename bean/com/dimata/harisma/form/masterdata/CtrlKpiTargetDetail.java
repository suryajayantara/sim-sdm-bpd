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
import java.util.Vector;

/*
Description : Controll KpiTargetDetail
Date : Tue Nov 26 2019
Author : Gunadi
 */
/**
 *
 * @author IanRizky
 */
public class CtrlKpiTargetDetail extends Control implements I_Language {

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
    private KpiTargetDetail entKpiTargetDetail;
    private PstKpiTargetDetail pstKpiTargetDetail;
    private FrmKpiTargetDetail frmKpiTargetDetail;
    int language = LANGUAGE_DEFAULT;

    public CtrlKpiTargetDetail(HttpServletRequest request) {
        msgString = "";
        entKpiTargetDetail = new KpiTargetDetail();
        try {
            pstKpiTargetDetail = new PstKpiTargetDetail(0);
        } catch (Exception e) {;
        }
        frmKpiTargetDetail = new FrmKpiTargetDetail(request, entKpiTargetDetail);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_DBExceptionInfo.MULTIPLE_ID:
                this.frmKpiTargetDetail.addError(frmKpiTargetDetail.FRM_FIELD_KPI_TARGET_DETAIL_ID, resultText[language][RSLT_EST_CODE_EXIST]);
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

    public KpiTargetDetail getKpiTargetDetail() {
        return entKpiTargetDetail;
    }

    public FrmKpiTargetDetail getForm() {
        return frmKpiTargetDetail;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidKpiTargetDetail, HttpServletRequest request) {
        msgString = "";
        int excCode = I_DBExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case Command.ADD:
                break;

            case Command.SAVE:
                if (oidKpiTargetDetail != 0) {
                    try {
                        entKpiTargetDetail = PstKpiTargetDetail.fetchExc(oidKpiTargetDetail);
                    } catch (Exception exc) {
                    }
                }

                frmKpiTargetDetail.requestEntityObject(entKpiTargetDetail);

                if (frmKpiTargetDetail.errorSize() > 0) {
                    msgString = FRMMessage.getMsg(FRMMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (entKpiTargetDetail.getOID() == 0) {
                    try {
                        long oid = pstKpiTargetDetail.insertExc(this.entKpiTargetDetail);
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
                        long oid = pstKpiTargetDetail.updateExc(this.entKpiTargetDetail);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.EDIT:
                if (oidKpiTargetDetail != 0) {
                    try {
                        entKpiTargetDetail = PstKpiTargetDetail.fetchExc(oidKpiTargetDetail);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.ASK:
                if (oidKpiTargetDetail != 0) {
                    try {
                        entKpiTargetDetail = PstKpiTargetDetail.fetchExc(oidKpiTargetDetail);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.DELETE:
                if (oidKpiTargetDetail != 0) {
                    try {
                        long oid = PstKpiTargetDetail.deleteExc(oidKpiTargetDetail);
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

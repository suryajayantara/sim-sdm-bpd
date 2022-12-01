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
import java.util.Vector;

/*
Description : Controll KpiSettingList
Date : Thu Nov 03 2022
Author : SURYAWAN
 */
public class CtrlKpiSettingList extends Control implements I_Language {

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
    private KpiSettingList entKpiSettingList;
    private PstKpiSettingList pstKpiSettingList;
    private FrmKpiSettingList frmKpiSettingList;
    int language = LANGUAGE_DEFAULT;

    public CtrlKpiSettingList(HttpServletRequest request) {
        msgString = "";
        entKpiSettingList = new KpiSettingList();
        try {
            pstKpiSettingList = new PstKpiSettingList(0);
        } catch (Exception e) {;
        }
        frmKpiSettingList = new FrmKpiSettingList(request, entKpiSettingList);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_DBExceptionInfo.MULTIPLE_ID:
                this.frmKpiSettingList.addError(frmKpiSettingList.FRM_FIELD_KPI_SETTING_LIST_ID, resultText[language][RSLT_EST_CODE_EXIST]);
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

    public KpiSettingList getKpiSettingList() {
        return entKpiSettingList;
    }

    public FrmKpiSettingList getForm() {
        return frmKpiSettingList;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }
 
    public int action(int cmd, long oidKpiSettingList, HttpServletRequest request) {
        msgString = "";

        int excCode = I_DBExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case Command.ADD:
                break;

            case Command.SAVE:
                if (oidKpiSettingList != 0) {
                    try {
                        entKpiSettingList = PstKpiSettingList.fetchExc(oidKpiSettingList);
                    } catch (Exception exc) {
                    }
                }

                frmKpiSettingList.requestEntityObject(entKpiSettingList);

                if (frmKpiSettingList.errorSize() > 0) {
                    msgString = FRMMessage.getMsg(FRMMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (entKpiSettingList.getOID() == 0) {
                    try {
//                        PstKpiSettingList.deleteByKpiSetting(this.entKpiSettingType.getKpiSettingId());
                        
                        Vector<Long> vOidKpiList = frmKpiSettingList.getvOidKpiList();
                          if (vOidKpiList != null){
                              for(int i = 0 ; i < vOidKpiList.size();i++){
                              KpiSettingList objKpiSettingList = new KpiSettingList();
                              objKpiSettingList.setKpiSettingId(entKpiSettingList.getKpiSettingId());
                              objKpiSettingList.setKpiDistributionId(entKpiSettingList.getKpiDistributionId());
                              objKpiSettingList.setKpiListId(vOidKpiList.get(i));
                              objKpiSettingList.setKpiGroupId(entKpiSettingList.getKpiGroupId());
                              PstKpiSettingList.insertExc(objKpiSettingList);
                              }
                          }
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
                        long oid = pstKpiSettingList.updateExc(this.entKpiSettingList);
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
                if (oidKpiSettingList != 0) {
                    try {
                        entKpiSettingList = PstKpiSettingList.fetchExc(oidKpiSettingList);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.ASK:
                if (oidKpiSettingList != 0) {
                    try {
                        entKpiSettingList = PstKpiSettingList.fetchExc(oidKpiSettingList);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.DELETE:
                if (oidKpiSettingList != 0) {
                    try {
                        long oid = PstKpiSettingList.deleteExc(oidKpiSettingList);
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

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
Description : Controll KpiSetting
Date : Sat Sep 17 2022
Author : Suryawan
 */
public class CtrlKpiSetting extends Control implements I_Language {

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
    private KpiSetting entKpiSetting;
    private PstKpiSetting pstKpiSetting;
    private FrmKpiSetting frmKpiSetting;
    private long oidKpiSetting;
    int language = LANGUAGE_DEFAULT;

    public CtrlKpiSetting(HttpServletRequest request) {
        msgString = "";
        entKpiSetting = new KpiSetting();
        try {
            pstKpiSetting = new PstKpiSetting(0);
        } catch (Exception e) {;
        }
        frmKpiSetting = new FrmKpiSetting(request, entKpiSetting);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_DBExceptionInfo.MULTIPLE_ID:
                this.frmKpiSetting.addError(frmKpiSetting.FRM_FIELD_KPI_SETTING_ID, resultText[language][RSLT_EST_CODE_EXIST]);
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

    public KpiSetting getKpiSetting() {
        return entKpiSetting;
    }

    public FrmKpiSetting getForm() {
        return frmKpiSetting;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public long getOidKpiSetting() {
        return oidKpiSetting;
    }

    public int action(int cmd, long oidKpiSetting, HttpServletRequest request) {
        msgString = "";
        int excCode = I_DBExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case Command.ADD:
                break;

            case Command.SAVE:
                if (oidKpiSetting != 0) {
                    try {
                        entKpiSetting = PstKpiSetting.fetchExc(oidKpiSetting);

                    } catch (Exception exc) {
                    }
                }

                frmKpiSetting.requestEntityObject(entKpiSetting);

                if (frmKpiSetting.errorSize() > 0) {
                    msgString = FRMMessage.getMsg(FRMMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (entKpiSetting.getOID() == 0) {
                    try {
                        long oid = pstKpiSetting.insertExc(this.entKpiSetting);
                        this.oidKpiSetting = oid;
                        Vector<Long> vOidPosition = frmKpiSetting.getvOidPosition();
                        if (vOidPosition != null) {
                            for (int uu = 0; uu < vOidPosition.size(); uu++) {
                                KpiSettingPosition objMapKpiSettingPosition = new KpiSettingPosition();
                                objMapKpiSettingPosition.setKpiSettingId(oid);
                                objMapKpiSettingPosition.setPositionId(vOidPosition.get(uu));
                                PstKpiSettingPosition.insertExc(objMapKpiSettingPosition);
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
                        PstKpiSettingPosition.deleteByKpiSettingId(this.entKpiSetting.getOID());
                        this.oidKpiSetting = oidKpiSetting;
                        Vector<Long> vOidPosition = frmKpiSetting.getvOidPosition();
                        if (vOidPosition != null) {
                            for (int uu = 0; uu < vOidPosition.size(); uu++) {
                                KpiSettingPosition objMapKpiSettingPosition = new KpiSettingPosition();
                                objMapKpiSettingPosition.setKpiSettingId(oidKpiSetting);
                                objMapKpiSettingPosition.setPositionId(vOidPosition.get(uu));
                                PstKpiSettingPosition.insertExc(objMapKpiSettingPosition);
                            }
                        }

                        long oid = pstKpiSetting.updateExc(this.entKpiSetting);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }

                }
                break;
            case Command.EDIT:
                if (oidKpiSetting != 0) {
                    try {
                        entKpiSetting = PstKpiSetting.fetchExc(oidKpiSetting);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.ASK:
                if (oidKpiSetting != 0) {
                    try {
                        entKpiSetting = PstKpiSetting.fetchExc(oidKpiSetting);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.DELETE:
                if (oidKpiSetting != 0) {
                    try {
                        /*contoh menghapus child dulu baru ke parent*/
                        PstKpiSettingPosition kpiSettingPosition = new PstKpiSettingPosition();
                        PstKpiSettingType kpiSettingType = new PstKpiSettingType();
                        PstKpiSettingGroup kpiSettingGroup = new PstKpiSettingGroup();
                        PstKpiSettingList kpiSettingList = new PstKpiSettingList();
                        long settingList = kpiSettingList.deleteKpiListByKpiSetting(oidKpiSetting);
                        long settingGroup = kpiSettingGroup.deleteGroupByKpiSetting(oidKpiSetting);
                        long status = kpiSettingPosition.deleteByKpiSettingId(oidKpiSetting);
                        long settingType = kpiSettingType.deleteByKpiSetting(oidKpiSetting);
                        if (status != 0 && settingType !=0 && settingGroup !=0 && settingList !=0) {
                                long oid = PstKpiSetting.deleteExc(oidKpiSetting);
                            if (oid != 0) {
                                msgString = FRMMessage.getMessage(FRMMessage.MSG_DELETED);
                                excCode = RSLT_OK;
                            } else {
                                msgString = FRMMessage.getMessage(FRMMessage.ERR_DELETED);
                                excCode = RSLT_FORM_INCOMPLETE;
                            }
                  
                        }else {
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

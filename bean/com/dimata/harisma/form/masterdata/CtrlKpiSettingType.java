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
Description : Controll KpiSettingType
Date : Fri Sep 23 2022
Author : SURYAWAN
 */
public class CtrlKpiSettingType extends Control implements I_Language {

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
    private KpiSettingType entKpiSettingType;
    private PstKpiSettingType pstKpiSettingType;
    private FrmKpiSettingType frmKpiSettingType;
    private long oidKpiSettingType;
    int language = LANGUAGE_DEFAULT;

    public CtrlKpiSettingType(HttpServletRequest request) {
        msgString = "";
        entKpiSettingType = new KpiSettingType();
        try {
            pstKpiSettingType = new PstKpiSettingType(0);
        } catch (Exception e) {;
        }
        frmKpiSettingType = new FrmKpiSettingType(request, entKpiSettingType);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_DBExceptionInfo.MULTIPLE_ID:
                this.frmKpiSettingType.addError(frmKpiSettingType.FRM_FIELD_KPI_SETTING_TYPE_ID, resultText[language][RSLT_EST_CODE_EXIST]);
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

    public KpiSettingType getKpiSettingType() {
        return entKpiSettingType;
    }

    public FrmKpiSettingType getForm() {
        return frmKpiSettingType;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidKpiSettingType, HttpServletRequest request) {
        msgString = "";
        int excCode = I_DBExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case Command.ADD:
                break;

            case Command.SAVE:
                if (oidKpiSettingType != 0) {
                    try {
                        entKpiSettingType = PstKpiSettingType.fetchExc(oidKpiSettingType);
                    } catch (Exception exc) {
                   }
                }  
                    

                frmKpiSettingType.requestEntityObject(entKpiSettingType);
                
                if (frmKpiSettingType.errorSize() > 0) {
                    msgString = FRMMessage.getMsg(FRMMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }
                
                if (entKpiSettingType.getOID() == 0) {
                    try { 
                        /*ini berfungsi untuk menyimpan data multiple, dengan 1 jsp tetapi isi beberapa form dengan table berbeda dari form yang lain*/
                        //long oid = pstKpiSettingType.insertExc(this.entKpiSettingType);
//                        PstKpiSettingType.deleteByKpiSetting(this.entKpiSettingType.getKpiSettingId());
                        Vector<Long> vOidKpiType = frmKpiSettingType.getvOidKpiType();
                          if (vOidKpiType != null){
                              for(int ux = 0 ; ux < vOidKpiType.size();ux++){
                                  KpiSettingType objKpiSettingType = new KpiSettingType();
                                  objKpiSettingType.setKpiSettingId(entKpiSettingType.getKpiSettingId());
                                  objKpiSettingType.setKpiTypeId(vOidKpiType.get(ux));
                                  PstKpiSettingType.insertExc(objKpiSettingType);
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
//                        PstKpiSettingType.deleteByKpiSetting(this.entKpiSettingType.getOID());
                        this.oidKpiSettingType = oidKpiSettingType;
                        Vector<Long> vOidKpiType = frmKpiSettingType.getvOidKpiType();
                        if (vOidKpiType != null) {
                            for (int uu = 0; uu < vOidKpiType.size(); uu++) {
                                KpiSettingType objMapKpiSettingType = new KpiSettingType();
                                objMapKpiSettingType.setKpiSettingId(entKpiSettingType.getKpiSettingId());
                                objMapKpiSettingType.setKpiTypeId(vOidKpiType.get(uu));
                                PstKpiSettingType.insertExc(objMapKpiSettingType);
                            }
                        }
                        
                        long oid = pstKpiSettingType.updateExc(this.entKpiSettingType);
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
                if (oidKpiSettingType != 0) {
                    try {
                        entKpiSettingType = PstKpiSettingType.fetchExc(oidKpiSettingType);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.ASK:
                if (oidKpiSettingType != 0) {
                    try {
                        entKpiSettingType = PstKpiSettingType.fetchExc(oidKpiSettingType);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;
            case Command.POST:
                if (oidKpiSettingType != 0){
                    try{
                        entKpiSettingType = PstKpiSettingType.fetchExc(oidKpiSettingType);
                    }catch (Exception exc){
                      
                    }
                }
               break;
            case Command.DELETE:
                if (oidKpiSettingType != 0) {
                    try {
                        long oid = PstKpiSettingType.deleteExc(oidKpiSettingType);
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

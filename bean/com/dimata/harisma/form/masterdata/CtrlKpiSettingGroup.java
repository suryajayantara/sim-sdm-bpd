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
Description : Controll KpiSettingGroup
Date : Sat Sep 17 2022
Author : Suryawan
 */
public class CtrlKpiSettingGroup extends Control implements I_Language {

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
    private KpiSettingGroup entKpiSettingGroup;
    private KpiSettingType entKpiSettingType;
    private PstKpiSettingGroup pstKpiSettingGroup;
    private FrmKpiSettingGroup frmKpiSettingGroup;
    private long oidKpiSettingGroup;
    int language = LANGUAGE_DEFAULT;

    public CtrlKpiSettingGroup(HttpServletRequest request) {
        msgString = "";
        entKpiSettingGroup = new KpiSettingGroup();
        try {
            pstKpiSettingGroup = new PstKpiSettingGroup(0);
        } catch (Exception e) {;
        }
        frmKpiSettingGroup = new FrmKpiSettingGroup(request, entKpiSettingGroup);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_DBExceptionInfo.MULTIPLE_ID:
                this.frmKpiSettingGroup.addError(frmKpiSettingGroup.FRM_FIELD_KPI_SETTING_GROUP_ID, resultText[language][RSLT_EST_CODE_EXIST]);
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
    
    public KpiSettingGroup getKpiSettingGroup() {
        return entKpiSettingGroup;
    }

    public FrmKpiSettingGroup getForm() {
        return frmKpiSettingGroup;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidKpiSettingGroup, HttpServletRequest request ) {
        msgString = "";
        int excCode = I_DBExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case Command.ADD:
                break;

            case Command.SAVE:
                if (oidKpiSettingGroup != 0) {
                    try {
                        entKpiSettingGroup = PstKpiSettingGroup.fetchExc(oidKpiSettingGroup);
                    } catch (Exception exc) { 
                    }
                }

                frmKpiSettingGroup.requestEntityObject(entKpiSettingGroup);

                if (frmKpiSettingGroup.errorSize() > 0) {
                    msgString = FRMMessage.getMsg(FRMMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (entKpiSettingGroup.getOID() == 0) {
                    try {
                        long oidKpiType = FRMQueryString.requestLong(request, FrmKpiSettingType.fieldNames[FrmKpiSettingType.FRM_FIELD_KPI_TYPE_ID]);
                        Vector<Long> vOidKpiGroup = frmKpiSettingGroup.getvOidKpiGroup();
                          if (vOidKpiGroup != null){
                              for(int ux = 0 ; ux < vOidKpiGroup.size();ux++){
                                  KpiSettingGroup objKpiSettingGroup = new KpiSettingGroup();
                                  objKpiSettingGroup.setKpiSettingId(entKpiSettingGroup.getKpiSettingId());
                                  objKpiSettingGroup.setKpiGroupId(vOidKpiGroup.get(ux));
                                  PstKpiSettingGroup.insertExc(objKpiSettingGroup);

                                  String query = PstKpiSettingType.fieldNames[PstKpiSettingType.FLD_KPI_SETTING_ID] + " = " + objKpiSettingGroup.getKpiSettingId() + " AND " + PstKpiSettingType.fieldNames[PstKpiSettingType.FLD_KPI_TYPE_ID] + " = " + oidKpiType;
                                  Vector vKpiSettingType = PstKpiSettingType.list(0, 1, query, "");
                                  for(int j = 0; j < vKpiSettingType.size(); j++){
                                      KpiSettingType entKpiSettingType = (KpiSettingType) vKpiSettingType.get(j);
                                      if(entKpiSettingType.getKpiGroupId() == 0){
                                          entKpiSettingType.setKpiGroupId(objKpiSettingGroup.getKpiGroupId());
                                          PstKpiSettingType.updateExc(entKpiSettingType);
                                      } else {
                                          entKpiSettingType.setKpiSettingId(entKpiSettingGroup.getKpiSettingId());
                                          entKpiSettingType.setKpiTypeId(oidKpiType);
                                          entKpiSettingType.setKpiGroupId(objKpiSettingGroup.getKpiGroupId());
                                          PstKpiSettingType.insertExc(entKpiSettingType);
                                      }
                                  }
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
                        this.oidKpiSettingGroup = oidKpiSettingGroup;
                        Vector<Long> vOidKpiGroup = frmKpiSettingGroup.getvOidKpiGroup();
                          if (vOidKpiGroup != null){
                              for(int ux = 0 ; ux < vOidKpiGroup.size();ux++){
                              KpiSettingGroup objKpiSettingGroup = new KpiSettingGroup();
                              objKpiSettingGroup.setKpiSettingId(entKpiSettingGroup.getKpiSettingId());
                              objKpiSettingGroup.setKpiGroupId(vOidKpiGroup.get(ux));
                              PstKpiSettingGroup.insertExc(objKpiSettingGroup);
                              }
                          }
                        long oid = pstKpiSettingGroup.updateExc(this.entKpiSettingGroup);
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
                if (oidKpiSettingGroup != 0) {
                    try {
                        entKpiSettingGroup = PstKpiSettingGroup.fetchExc(oidKpiSettingGroup);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.ASK:
                if (oidKpiSettingGroup != 0) {
                    try {
                        entKpiSettingGroup = PstKpiSettingGroup.fetchExc(oidKpiSettingGroup);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.DELETE:
                if (oidKpiSettingGroup != 0) {
                    try {
                        PstKpiSettingGroup pstkpiSettingGroup = new PstKpiSettingGroup();
                        long kpiSettingGroup = PstKpiSettingGroup.deleteByKpiGroup(oidKpiSettingGroup);
                        if (kpiSettingGroup != 0) {
                            long oid = PstKpiSettingGroup.deleteExc(oidKpiSettingGroup);
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

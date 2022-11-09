/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.form.masterdata;

/**
 *
 * @author Utk
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
Description : Controll Notification
Date : Fri Jun 19 2020
Author : ERI_YUDI
*/

public class CtrlNotification extends Control implements I_Language {
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
private Notification entNotification;
private PstNotification pstNotification;
private PstNotificationMapping pstNotificationMapping;
private PstNotificationMappingDivision pstNotificationMappingDivision;
private FrmNotification frmNotification;
int language = LANGUAGE_DEFAULT;

public CtrlNotification(HttpServletRequest request) {
    msgString = "";
    entNotification = new Notification();
        try {
        pstNotification = new PstNotification(0);
        } catch (Exception e) {;
        }
    frmNotification = new FrmNotification(request, entNotification); 
    
}

private String getSystemMessage(int msgCode) {
    switch (msgCode) {
    case I_DBExceptionInfo.MULTIPLE_ID:
    this.frmNotification.addError(frmNotification.FRM_FIELD_NOTIFICATION_ID, resultText[language][RSLT_EST_CODE_EXIST]);
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

public Notification getNotification() {
return entNotification;
}

public FrmNotification getForm() {
return frmNotification;
}

public String getMessage() {
return msgString;
}

public int getStart() {
return start;
}

public int action(int cmd, long oidNotification,HttpServletRequest request) {
    msgString = "";
    int excCode = I_DBExceptionInfo.NO_EXCEPTION;
    int rsCode = RSLT_OK;
    switch (cmd) {
    case Command.ADD:
break;

case Command.SAVE:
    if (oidNotification != 0) {
    try {
    entNotification = PstNotification.fetchExc(oidNotification);
    } catch (Exception exc) {
    }
    }
    
    frmNotification.requestEntityObject(entNotification);
    
    if (frmNotification.errorSize() > 0) {
        msgString = FRMMessage.getMsg(FRMMessage.MSG_INCOMPLATE);
        return RSLT_FORM_INCOMPLETE;
    }

    if (entNotification.getOID() == 0) {
        try {
            long oid = pstNotification.insertExc(this.entNotification);
         
               String[] userList = FRMQueryString.requestStringValues(request, "user_id");
                for(int u = 0 ; u < userList.length ; u++){
                    NotificationMapping notificationMapping = new NotificationMapping();
                    notificationMapping.setNotificationId(oid);
                    notificationMapping.setUserId(Long.valueOf(userList[u]));
                    long oidMapping = PstNotificationMapping.insertExc(notificationMapping);
                }
                
                String[] divisionList = FRMQueryString.requestStringValues(request, "division_id");
                for(int u = 0 ; u < divisionList.length ; u++){
                    NotificationMappingDivision notificationMapping = new NotificationMappingDivision();
                    notificationMapping.setNotificationId(oid);
                    notificationMapping.setDivisionId(Long.valueOf(divisionList[u]));
                    long oidMapping = PstNotificationMappingDivision.insertExc(notificationMapping);
                }
                
            
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
    long oid = pstNotification.updateExc(this.entNotification);
    Vector listNotifMap = (Vector) pstNotificationMapping.list(0,0," "+PstNotificationMapping.fieldNames[PstNotificationMapping.FLD_NOTIFICATION_ID]+" = "+oidNotification,"");
    if(listNotifMap.size() > 0){
    int status = pstNotificationMapping.deleteExcByNotificationOid(oidNotification);
    }
    int status = pstNotificationMappingDivision.deleteExcByNotificationOid(oidNotification);
    //status 0 = success , 1 = failed
     String[] userList = FRMQueryString.requestStringValues(request, "user_id");
        for(int u = 0 ; u < userList.length ; u++){
            NotificationMapping notificationMapping = new NotificationMapping();
            notificationMapping.setNotificationId(oid);
            notificationMapping.setUserId(Long.valueOf(userList[u]));
            long oidMapping = PstNotificationMapping.insertExc(notificationMapping);
        }
        String[] divisionList = FRMQueryString.requestStringValues(request, "division_id");
            for(int u = 0 ; u < divisionList.length ; u++){
                NotificationMappingDivision notificationMapping = new NotificationMappingDivision();
                notificationMapping.setNotificationId(oid);
                notificationMapping.setDivisionId(Long.valueOf(divisionList[u]));
                long oidMapping = PstNotificationMappingDivision.insertExc(notificationMapping);
            }
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
    if (oidNotification != 0) {
    try {
    entNotification = PstNotification.fetchExc(oidNotification);
    } catch (DBException dbexc) {
    excCode = dbexc.getErrorCode();
    msgString = getSystemMessage(excCode);
    } catch (Exception exc) {
    msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
    }
    }
break;

case Command.ASK:
    if (oidNotification != 0) {
    try {
    entNotification = PstNotification.fetchExc(oidNotification);
    } catch (DBException dbexc) {
    excCode = dbexc.getErrorCode();
    msgString = getSystemMessage(excCode);
    } catch (Exception exc) {
    msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
    }
    }
break;

case Command.DELETE:
    if (oidNotification != 0) {
    try {
    long oid = PstNotification.deleteExc(oidNotification);
    Vector listNotifMap = (Vector) pstNotificationMapping.list(0,0," "+PstNotificationMapping.fieldNames[PstNotificationMapping.FLD_NOTIFICATION_ID]+" = "+oidNotification,"");
    int status = 0;
    if(listNotifMap.size() > 0){
     status = pstNotificationMapping.deleteExcByNotificationOid(oidNotification);
    }
    if (oid != 0 && status == 0) {
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
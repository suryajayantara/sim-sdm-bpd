/* 
 * Ctrl Name  		:  CtrlFamilyMember.java 
 * Created on 	:  [date] [time] AM/PM 
 * 
 * @author  		: lkarunia
 * @version  		: 01 
 */
/**
 * *****************************************************************
 * Class Description : [project description ... ] Imput Parameters : [input
 * parameter ...] Output : [output ...] 
 ******************************************************************
 */
package com.dimata.harisma.form.employee;

/* java package */
import com.dimata.harisma.entity.admin.AppUser;
import com.dimata.harisma.entity.admin.PstAppUser;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
/* dimata package */
import com.dimata.util.*;
import com.dimata.util.lang.*;
/* qdep package */
import com.dimata.qdep.system.*;
import com.dimata.qdep.form.*;
import com.dimata.qdep.db.*;
/* project package */
//import com.dimata.harisma.db.*;
import com.dimata.harisma.entity.employee.*;
import com.dimata.harisma.entity.log.I_LogHistory;
import com.dimata.harisma.entity.log.LogSysHistory;
import com.dimata.harisma.entity.log.PstLogSysHistory;
import com.dimata.harisma.entity.masterdata.PstDivision;
import com.dimata.harisma.entity.masterdata.PstPosition;
import com.dimata.harisma.session.log.SessHistoryLog;
import com.dimata.system.entity.system.PstSystemProperty;

public class CtrlFamilyMember extends Control implements I_Language {

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
    private FamilyMember familyMember;
    private PstFamilyMember pstFamilyMember;
    private FrmFamilyMember frmFamilyMember;
    int language = LANGUAGE_DEFAULT;

    public CtrlFamilyMember(HttpServletRequest request) {
        msgString = "";
        familyMember = new FamilyMember();
        try {
            pstFamilyMember = new PstFamilyMember(0);
        } catch (Exception e) {;
        }
        frmFamilyMember = new FrmFamilyMember(request, familyMember);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_DBExceptionInfo.MULTIPLE_ID:
                this.frmFamilyMember.addError(frmFamilyMember.FRM_FIELD_FAMILY_MEMBER_ID, resultText[language][RSLT_EST_CODE_EXIST]);
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

    public FamilyMember getFamilyMember() {
        return familyMember;
    }

    public FrmFamilyMember getForm() {
        return frmFamilyMember;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidEmployee, Vector famMember, HttpServletRequest request, String loginName, long userId) {
        return action(cmd, oidEmployee, famMember, request, loginName, userId, 0);
    }
    
    public int action(int cmd, long oidEmployee, Vector famMember, HttpServletRequest request, String loginName, long userId, long oidFamilyMember) {
        msgString = "";
        int excCode = I_DBExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        /* Prepare data (configurasi log system) */
        int sysLog = Integer.parseInt(String.valueOf(PstSystemProperty.getPropertyLongbyName("SET_USER_ACTIVITY_LOG")));
        String updateNeedApproval = PstSystemProperty.getValueByName("UPDATE_DATA_NEED_APPROVAL");
        String logField = "";
        String logPrev = "";
        String logCurr = "";
        Date nowDate = new Date();
        AppUser appUser = new AppUser();
        Employee emp = new Employee();
        try {
            appUser = PstAppUser.fetch(userId);
            emp = PstEmployee.fetchExc(appUser.getEmployeeId());
        } catch (Exception e) {
            System.out.println("Get AppUser: userId: " + e.toString());
        }
        /* End Prepare data (configurasi log system) */

        switch (cmd) {
            case Command.ADD:
                break;

            case Command.SAVE:
                
                if (oidEmployee != 0 && (famMember != null && famMember.size() > 0)) {
                    // Hashtable<String, FamilyMember> hPrevMember = new Hashtable();
                    Vector prevMember = PstFamilyMember.list(0, 0, "EMPLOYEE_ID=" + oidEmployee, PstFamilyMember.fieldNames[PstFamilyMember.FLD_RELATIONSHIP] + "," + PstFamilyMember.fieldNames[PstFamilyMember.FLD_BIRTH_DATE] + " ASC");
                    /*for(int j=0;j<prevMember.size();j++){
                     FamilyMember fam = (FamilyMember)prevMember.get(j);
                                        
                     hPrevMember.put(fam.getFullName(), fam);
                     }
                     */
                    /* Enumeration numHash;
                                    
                     numHash = hPrevMember.keys();
                                    
                     while(numHash.hasMoreElements()){
                                        
                     }*/
                    String empName = PstEmployee.getEmployeeName(oidEmployee);
                    //PstFamilyMember.deleteByEmployee(oidEmployee);

                    for (int i = 0; i < famMember.size(); i++) {
                        FamilyMember fam = (FamilyMember) famMember.get(i);
                        fam.setEmployeeId(oidEmployee);

                        /* FamilyMember prevFam = hPrevMember.get(fam.getFullName());
                         */
                        if (fam.getFullName().length() > 0) {
                            try {
                                
                                if (fam.getOID() > 0){
                                    FamilyMember prevFam = PstFamilyMember.fetchExc(fam.getOID());
                                    if (!String.valueOf(fam.getAddress()).equals(String.valueOf(prevFam.getAddress())) 
                                            || !String.valueOf(fam.getBirtPlace()).equals(String.valueOf(prevFam.getBirtPlace()))
                                            || !Formater.formatDate(fam.getBirthDate(), "yyyy-MM-dd").equals(Formater.formatDate(prevFam.getBirthDate(), "yyyy-MM-dd")) 
                                            || !String.valueOf(fam.getBpjsNum()).equals(String.valueOf(prevFam.getBpjsNum()))
                                            || !String.valueOf(fam.getCardId()).equals(String.valueOf(prevFam.getCardId()))
                                            || fam.getEducationId() != prevFam.getEducationId()
                                            || !String.valueOf(fam.getFullName()).equals(String.valueOf(prevFam.getFullName()))
                                            || !String.valueOf(fam.getJob()).equals(String.valueOf(prevFam.getJob()))
                                            || !String.valueOf(fam.getJobPlace()).equals(String.valueOf(prevFam.getJobPlace()))
                                            || !String.valueOf(fam.getJobPosition()).equals(String.valueOf(prevFam.getJobPosition()))
                                            || fam.getNoTelp() != prevFam.getNoTelp() 
                                            || fam.getRelationType() != prevFam.getRelationType()
                                            || !String.valueOf(fam.getRelationship()).equals(String.valueOf(prevFam.getRelationship()))
                                            || fam.getReligionId() != prevFam.getReligionId()){
                                        
                                        try {
                                            long oid = 0;
                                            boolean isValid = true;
                                            if (updateNeedApproval.equals("1") && appUser.getAdminStatus() == 0){
                                                oid = pstFamilyMember.updateExcPending(fam);
                                                String whereLog = PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_QUERY]+" = \""+pstFamilyMember.getQuery()+"\" "
                                                    + " AND "+PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_LOG_STATUS]+" = 0";
                                                Vector listLog = PstLogSysHistory.list(0, 0, whereLog, "");
                                                if (listLog.size()>0){
                                                    isValid = false;
                                                }
                                                if (isValid) {
                                                    request.setAttribute("currData", fam);
                                                    request.setAttribute("prevData", prevFam);
                                                    request.setAttribute("query", pstFamilyMember.getQuery());
                                                    SessHistoryLog.updateFamily(request);
                                                }
                                            } else {
                                                oid = pstFamilyMember.updateExc(fam);
                                            }
                                            if (updateNeedApproval.equals("1") && appUser.getAdminStatus() == 0){
                                                if (isValid) {
                                                    msgString = FRMMessage.getMsg(FRMMessage.MSG_ON_VALIDATION);
                                                } else {
                                                    msgString = FRMMessage.getMsg(FRMMessage.MSG_EXIST_ON_VALIDATION);
                                                }
                                            } else {
                                                msgString = FRMMessage.getMsg(FRMMessage.MSG_UPDATED);
                                            }
                                        } catch (DBException dbexc) {
                                            excCode = dbexc.getErrorCode();
                                            msgString = getSystemMessage(excCode);
                                        } catch (Exception exc) {
                                            msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                                        }
                                        
                                    }
                                } else {
                                    try {
                                        long oid = 0;
                                        boolean isValid = true;
                                        if (updateNeedApproval.equals("1") && appUser.getAdminStatus() == 0){
                                            oid = pstFamilyMember.insertExcPending(fam);
                                            fam.setOID(oid);
                                            String whereLog = PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_QUERY]+" = \""+pstFamilyMember.getQuery()+"\" "
                                                + " AND "+PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_LOG_STATUS]+" = 0";
                                            Vector listLog = PstLogSysHistory.list(0, 0, whereLog, "");
                                            if (listLog.size()>0){
                                                isValid = false;
                                            }
                                            if (isValid) {
                                                request.setAttribute("insert", fam);
                                                request.setAttribute("query", pstFamilyMember.getQuery());
                                                SessHistoryLog.insertNDeleteFamily(request);
                                            }
                                        } else {
                                            oid = pstFamilyMember.insertExc(fam);
                                        }
                                        if (updateNeedApproval.equals("1") && appUser.getAdminStatus() == 0){
                                            if (isValid) {
                                                msgString = FRMMessage.getMsg(FRMMessage.MSG_ON_VALIDATION);
                                            } else {
                                                msgString = FRMMessage.getMsg(FRMMessage.MSG_EXIST_ON_VALIDATION);
                                            }
                                        } else {
                                            msgString = FRMMessage.getMsg(FRMMessage.MSG_SAVED);
                                        }
                                    } catch (DBException dbexc) {
                                        excCode = dbexc.getErrorCode();
                                        msgString = getSystemMessage(excCode);
                                        return getControlMsgId(excCode);
                                    } catch (Exception exc) {
                                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                                        return getControlMsgId(I_DBExceptionInfo.UNKNOWN);
                                    }
                                }
                                
                                
                                /* if(sysLog == 1 && i < prevMember.size()){
                                 if(prevFam.getFullName() != null){
                                 logDetail = logDetail+" Fullname : "+prevFam.getFullName()+" >> "+fam.getFullName()+" UPDATE </br>";

                                 String className = prevFam.getClass().getName();

                                 LogSysHistory logSysHistory = new LogSysHistory();

                                 String reqUrl = request.getRequestURI().toString()+"?employee_oid="+oidEmployee;

                                 logSysHistory.setLogDocumentId(0);
                                 logSysHistory.setLogUserId(userId);
                                 logSysHistory.setLogLoginName(loginName);
                                 logSysHistory.setLogDocumentNumber("");
                                 logSysHistory.setLogDocumentType(className); //entity
                                 logSysHistory.setLogUserAction("UPDATE"); // command
                                 logSysHistory.setLogOpenUrl(reqUrl); // locate jsp
                                 logSysHistory.setLogUpdateDate(nowDate);
                                 logSysHistory.setLogApplication(I_LogHistory.SYSTEM_NAME[I_LogHistory.SYSTEM_HAIRISMA]); // interface
                                 logSysHistory.setLogDetail(logDetail); // apa yang dirubah
                                 logSysHistory.setStatus(0);

                                 PstLogSysHistory.insertExc(logSysHistory);
                                 }
                                 }*/

                            } catch (Exception e) {
                                System.out.println("Exception e : " + e.toString());
                            }
                        } else {

                            // logHistory deleted
//                            try {
//                                if (sysLog == 1 && i < prevMember.size()) {
//
//                                    FamilyMember prevfam = (FamilyMember) prevMember.get(i);
//
//                                    if (!prevfam.getFullName().equals("")) {
//                                        logField = logField + " Family : " + prevfam.getFullName() + " DELETED from Employee : " + empName + " </br>";
//                                    }
//
//                                    String className = prevfam.getClass().getName();
//
//                                    LogSysHistory logSysHistory = new LogSysHistory();
//
//                                    String reqUrl = request.getRequestURI().toString() + "?employee_oid=" + oidEmployee;
//
//                                    logSysHistory.setLogDocumentId(0);
//                                    logSysHistory.setLogUserId(userId);
//                                    logSysHistory.setLogLoginName(loginName);
//                                    logSysHistory.setLogDocumentNumber("");
//                                    logSysHistory.setLogDocumentType(className); //entity
//                                    logSysHistory.setLogUserAction("DELETE"); // command
//                                    logSysHistory.setLogOpenUrl(reqUrl); // locate jsp
//                                    logSysHistory.setLogUpdateDate(nowDate);
//                                    logSysHistory.setLogApplication(I_LogHistory.SYSTEM_NAME[I_LogHistory.SYSTEM_HAIRISMA]); // interface
//                                    logSysHistory.setLogDetail(logField); // apa yang dirubah
//                                    logSysHistory.setLogStatus(0);
//
//                                    PstLogSysHistory.insertExc(logSysHistory);
//
//                                }
//                            } catch (Exception e) {
//                                System.out.println("Exception e : " + e.toString());
//                            }
                        }
                    }
                } else {
                    msgString = FRMMessage.getMsg(FRMMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                /*  familyMember.setOID(oidFamilyMember);
                 familyMember.setEmployeeId(oidEmployee);

                 frmFamilyMember.requestEntityObject(familyMember);

                 if((frmFamilyMember.errorSize()>0)||(familyMember.getEmployeeId()==0)) {
                 msgString = FRMMessage.getMsg(FRMMessage.MSG_INCOMPLATE);
                 return RSLT_FORM_INCOMPLETE ;
                 }

                 if(familyMember.getOID()==0){
                 try{
                 long oid = pstFamilyMember.insertExc(this.familyMember);
                 }catch(DBException dbexc){
                 excCode = dbexc.getErrorCode();
                 msgString = getSystemMessage(excCode);
                 return getControlMsgId(excCode);
                 }catch (Exception exc){
                 msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                 return getControlMsgId(I_DBExceptionInfo.UNKNOWN);
                 }

                 }else{
                 try {
                 long oid = pstFamilyMember.updateExc(this.familyMember);
                 }catch (DBException dbexc){
                 excCode = dbexc.getErrorCode();
                 msgString = getSystemMessage(excCode);
                 }catch (Exception exc){
                 msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN); 
                 }

                 }    */
                break;

            case Command.EDIT:
                /*	if (oidFamilyMember != 0) {
                 try {
                 familyMember = PstFamilyMember.fetchExc(oidFamilyMember);
                 } catch (DBException dbexc){
                 excCode = dbexc.getErrorCode();
                 msgString = getSystemMessage(excCode);
                 } catch (Exception exc){ 
                 msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                 }
                 }  */
                break;

            case Command.ASK:
                /*	if (oidFamilyMember != 0) {
                 try {
                 familyMember = PstFamilyMember.fetchExc(oidFamilyMember);
                 } catch (DBException dbexc){
                 excCode = dbexc.getErrorCode();
                 msgString = getSystemMessage(excCode);
                 } catch (Exception exc){ 
                 msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                 }
                 }  */
                break;

            case Command.DELETE:
                if (oidFamilyMember != 0) {
                    try {
                        FamilyMember familyMember = PstFamilyMember.fetchExc(oidFamilyMember);
                        long oid = 0;
                        boolean isValid = true;
                        if (updateNeedApproval.equals("1") && appUser.getAdminStatus() == 0){
                            oid = PstFamilyMember.deleteExcPending(oidFamilyMember);
                            String whereLog = PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_QUERY]+" = \""+pstFamilyMember.getQuery()+"\" "
                                + " AND "+PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_LOG_STATUS]+" = 0";
                            Vector listLog = PstLogSysHistory.list(0, 0, whereLog, "");
                            if (listLog.size()>0){
                                isValid = false;
                            }
                            if (isValid) {
                                request.setAttribute("delete", familyMember);
                                request.setAttribute("query", pstFamilyMember.getQuery());
                                SessHistoryLog.insertNDeleteFamily(request);
                            }
                        } else {
                            oid = PstFamilyMember.deleteExc(oidFamilyMember);
                        }
                        
                        if (oid != 0) {
                            if (updateNeedApproval.equals("1") && appUser.getAdminStatus() == 0){
                                if (isValid) {
                                    msgString = FRMMessage.getMsg(FRMMessage.MSG_ON_VALIDATION);
                                } else {
                                    msgString = FRMMessage.getMsg(FRMMessage.MSG_EXIST_ON_VALIDATION);
                                }
                            } else {
                                msgString = FRMMessage.getMessage(FRMMessage.MSG_DELETED);
                            }
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

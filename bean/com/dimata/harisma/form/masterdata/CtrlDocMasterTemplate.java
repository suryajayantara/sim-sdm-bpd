/* Created on 	:  30 September 2011 [time] AM/PM
 *
 * @author  	:  Priska
 * @version  	:  [version]
 */

/*******************************************************************
 * Class Description 	: CtrlCompany
 * Imput Parameters 	: [input parameter ...]
 * Output 		: [output ...]
 *******************************************************************/

package com.dimata.harisma.form.masterdata;

/**
 *
 * @author Priska
 */
/* java package */
import com.dimata.harisma.entity.admin.AppUser;
import com.dimata.harisma.entity.admin.PstAppUser;
import com.dimata.harisma.entity.employee.Employee;
import com.dimata.harisma.entity.employee.PstEmployee;
import com.dimata.harisma.entity.log.I_LogHistory;
import com.dimata.harisma.entity.log.LogSysHistory;
import com.dimata.harisma.entity.log.PstLogSysHistory;
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
import com.dimata.harisma.entity.masterdata.*;
import com.dimata.system.entity.PstSystemProperty;
import java.sql.*;

public class CtrlDocMasterTemplate extends Control implements I_Language{
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
    private DocMasterTemplate docMasterTemplate;
    private PstDocMasterTemplate pstDocMasterTemplate;
    private FrmDocMasterTemplate frmDocMasterTemplate;
    int language = LANGUAGE_DEFAULT;

    public CtrlDocMasterTemplate(HttpServletRequest request) {
        msgString = "";
        docMasterTemplate = new DocMasterTemplate();
        try {
            pstDocMasterTemplate = new PstDocMasterTemplate(0);
        } catch (Exception e) {
            ;
        }
        frmDocMasterTemplate = new FrmDocMasterTemplate(request, docMasterTemplate);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_DBExceptionInfo.MULTIPLE_ID:
                this.frmDocMasterTemplate.addError(frmDocMasterTemplate.FRM_FIELD_DOC_MASTER_TEMPLATE_ID, resultText[language][RSLT_EST_CODE_EXIST]);
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

    public DocMasterTemplate getdDocMasterTemplate() {
        return docMasterTemplate;
    }

    public FrmDocMasterTemplate getForm() {
        return frmDocMasterTemplate;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidDocMasterTemplate, HttpServletRequest request, String loginName, long userId) {
        msgString = "";
        int excCode = I_DBExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        
        int sysLog = Integer.parseInt(String.valueOf(PstSystemProperty.getPropertyLongbyName("SET_USER_ACTIVITY_LOG")));
        //long sysLog = 1;
        String logField = "";
        String logPrev = "";
        String logCurr = "";
        java.util.Date nowDate = new java.util.Date();
        AppUser appUser = new AppUser();
        Employee emp = new Employee();
        try {
            appUser = PstAppUser.fetch(userId);
            emp = PstEmployee.fetchExc(appUser.getEmployeeId());
        } catch(Exception e){
            System.out.println("Get AppUser: userId");
        }
        /* End Prepare data (configurasi log system) */
        
        switch (cmd) {
            case Command.ADD:
                break;

          case Command.SAVE :
				if(oidDocMasterTemplate != 0){
					try{
						docMasterTemplate = PstDocMasterTemplate.fetchExc(oidDocMasterTemplate);
					}catch(Exception exc){
					}
				}

				frmDocMasterTemplate.requestEntityObject(docMasterTemplate);

				if(frmDocMasterTemplate.errorSize()>0) {
					msgString = FRMMessage.getMsg(FRMMessage.MSG_INCOMPLATE);
					return RSLT_FORM_INCOMPLETE ;
				}

				if(docMasterTemplate.getOID()==0){
					try{
						long oid = pstDocMasterTemplate.insertExc(this.docMasterTemplate);
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
						long oid = pstDocMasterTemplate.updateExc(this.docMasterTemplate);
					}catch (DBException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					}catch (Exception exc){
						msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN); 
					}

				}
				break;

			case Command.EDIT :
				if (oidDocMasterTemplate != 0) {
					try {
						docMasterTemplate = PstDocMasterTemplate.fetchExc(oidDocMasterTemplate);
					} catch (DBException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
					}
				}
				break;

			case Command.ASK :
				if (oidDocMasterTemplate != 0) {
					try {
						docMasterTemplate = PstDocMasterTemplate.fetchExc(oidDocMasterTemplate);
					} catch (DBException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
					}
				}
				break;


			case Command.DELETE :
				if (oidDocMasterTemplate != 0){
					try{
                                            
                                            //save ke log history
                                            DocMasterTemplate docMasterTemplate = PstDocMasterTemplate.fetchExc(oidDocMasterTemplate);
                                            logField = PstDocMasterTemplate.fieldNames[PstDocMasterTemplate.FLD_DOC_MASTER_ID]+";";
                                            logField += PstDocMasterTemplate.fieldNames[PstDocMasterTemplate.FLD_DOC_MASTER_TEMPLATE_ID]+";";
                                            logField += PstDocMasterTemplate.fieldNames[PstDocMasterTemplate.FLD_TEMPLATE_FILE_NAME]+";";
                                            logField += PstDocMasterTemplate.fieldNames[PstDocMasterTemplate.FLD_TEMPLATE_TITLE]+";";
                                            
                                            logPrev = ""+docMasterTemplate.getDoc_master_id()+";";
                                            logPrev += ""+docMasterTemplate.getOID()+";";
                                            logPrev += ""+docMasterTemplate.getTemplate_filename()+";";
                                            logPrev += ""+docMasterTemplate.getTemplate_title()+";";

                                            /*Curr*/
                                            logCurr  = "-;";
                                            logCurr += "-;";
                                            logCurr += "-;";
                                            logCurr += "-;";

                                            if (sysLog == 1) {
                                   
                                    
                                            String className = docMasterTemplate.getClass().getName();

                                            LogSysHistory logSysHistory = new LogSysHistory();

                                            String reqUrl = request.getRequestURI().toString();


                                            logSysHistory.setLogDocumentId(0);
                                            logSysHistory.setLogUserId(userId);
                                            logSysHistory.setApproverId(userId);
                                            logSysHistory.setApproveDate(nowDate);
                                            logSysHistory.setLogLoginName(loginName);
                                            logSysHistory.setLogDocumentNumber("");
                                            logSysHistory.setLogDocumentType(className); //entity
                                            logSysHistory.setLogUserAction("DELETE"); // command
                                            logSysHistory.setLogOpenUrl(reqUrl); // locate jsp
                                            logSysHistory.setLogUpdateDate(nowDate);
                                            logSysHistory.setLogApplication(I_LogHistory.SYSTEM_NAME[I_LogHistory.SYSTEM_HAIRISMA]); // interface
                                            logSysHistory.setLogDetail(logField); // apa yang dirubah
                                            logSysHistory.setLogStatus(0); /* 0 == draft */
                                            logSysHistory.setLogPrev(logPrev);
                                            logSysHistory.setLogCurr(logCurr);
                                            logSysHistory.setLogModule("Doc Master Template"); /* nama sub module*/
                                            logSysHistory.setCompanyId(emp.getCompanyId());
                                            logSysHistory.setDivisionId(emp.getDivisionId());
                                            logSysHistory.setDepartmentId(emp.getDepartmentId());
                                            logSysHistory.setSectionId(emp.getSectionId());
                                            logSysHistory.setLogEditedUserId(emp.getOID());
                                            PstLogSysHistory.insertExc(logSysHistory);
                                            }
                                            
						long oid = PstDocMasterTemplate.deleteExc(oidDocMasterTemplate);
						if(oid!=0){
							msgString = FRMMessage.getMessage(FRMMessage.MSG_DELETED);
							excCode = RSLT_OK;
						}else{
							msgString = FRMMessage.getMessage(FRMMessage.ERR_DELETED);
							excCode = RSLT_FORM_INCOMPLETE;
						}
					}catch(DBException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					}catch(Exception exc){	
						msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
					}
				}
				break;

			default :

		}
		return rsCode;
	}
}

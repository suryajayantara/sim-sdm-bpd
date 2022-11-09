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
import com.dimata.harisma.entity.search.SrcEmployee;
import com.dimata.harisma.session.employee.SessEmployee;
import com.dimata.system.entity.PstSystemProperty;
import java.sql.*;

public class CtrlEmpDocField extends Control implements I_Language{
    public static int RSLT_OK = 0;
    public static int RSLT_UNKNOWN_ERROR = 1;
    public static int RSLT_EST_CODE_EXIST = 2;
    public static int RSLT_FORM_INCOMPLETE = 3;
    public static int RSLT_FORM_DATE_OUT_OF_RANGE = 4;
    public static String[][] resultText = {
        {"Berhasil", "Tidak dapat diproses", "NoPerkiraan sudah ada", "Data tidak lengkap"},
        {"Succes", "Can not process", "Estimation code exist", "Data incomplete"}
    };
    private int start;
    private String msgString;
    private EmpDocField empDocField;
    private PstEmpDocField pstEmpDocField;
    private FrmEmpDocField frmEmpDocField;
    int language = LANGUAGE_DEFAULT;

    public CtrlEmpDocField(HttpServletRequest request) {
        msgString = "";
        empDocField = new EmpDocField();
        try {
            pstEmpDocField = new PstEmpDocField(0);
        } catch (Exception e) {
            ;
        }
        frmEmpDocField = new FrmEmpDocField(request, empDocField);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_DBExceptionInfo.MULTIPLE_ID:
                this.frmEmpDocField.addError(frmEmpDocField.FRM_FIELD_EMP_DOC_FIELD_ID, resultText[language][RSLT_EST_CODE_EXIST]);
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

    public EmpDocField getdEmpDocField() {
        return empDocField;
    }

    public FrmEmpDocField getForm() {
        return frmEmpDocField;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }
   public int action(int cmd, long oidEmpDocField) {
        msgString = "";
        int excCode = I_DBExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case Command.ADD:
                break;

          case Command.SAVE :
				if(oidEmpDocField != 0){
					try{
						empDocField = pstEmpDocField.fetchExc(oidEmpDocField);
					}catch(Exception exc){
					}
				}

				frmEmpDocField.requestEntityObject(empDocField);

				if(frmEmpDocField.errorSize()>0) {
					msgString = FRMMessage.getMsg(FRMMessage.MSG_INCOMPLATE);
					return RSLT_FORM_INCOMPLETE ;
				}
                                
                                try{
                                    boolean useDateValidation = false;
                                    String listSuratDenganValidasi = PstSystemProperty.getValueByName("VALIDASI_INPUT_TANGGAL_SURAT");
                                    String listSurat[] = listSuratDenganValidasi.split(",");
                                    for(int x = 0 ; x < listSurat.length; x++){
//                                       EmpDoc objEmpDoc = (EmpDoc) PstEmpDoc.fetchExc(empDocField.getEmp_doc_id()) ;
                                       DocMaster objDocMaster = (DocMaster) PstDocMaster.getDocMasterByEmpDocId(empDocField.getEmp_doc_id());
                                       if(objDocMaster.getDoc_title().equals(listSurat[x])){
                                           useDateValidation = true;
                                       }
                                    }
                                    if(useDateValidation){
                                        if(empDocField.getObject_type() == 1){
                                              String dateStartPeriodS =  Formater.formatDate(new java.util.Date(), "yyyy-MM-dd");
                                              java.util.Date dateStartPeriod =  Formater.formatDate(dateStartPeriodS, "yyyy-MM-dd");
                                              java.util.Date dateTanggalInput =  Formater.formatDate(empDocField.getValue(), "yyyy-MM-dd");
                                             try{
                                                 dateStartPeriod.setDate(1);
                                             }catch (Exception exc){
                                                 System.out.println("Exc :"+exc);
                                             }
                                             boolean tanggalInvalid = dateTanggalInput.before(dateStartPeriod) ;
                                             if(tanggalInvalid){
                                                 msgString = FRMMessage.getMsg(FRMMessage.MSG_DATA_OUT_OF_RANGE);
                                                 return RSLT_FORM_DATE_OUT_OF_RANGE ; 
                                             }
                                        }  
                                    }
                                     
                                }catch(Exception e){
                                    System.out.println("Error get Sysprop :"+e);
              
                                } 
                               

				if(empDocField.getOID()==0){
					try{
						long oid = pstEmpDocField.insertExc(this.empDocField);
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
						long oid = pstEmpDocField.updateExc(this.empDocField);
					}catch (DBException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					}catch (Exception exc){
						msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN); 
					}

				}
				break;

			case Command.EDIT :
				if (oidEmpDocField != 0) {
					try {
						empDocField = pstEmpDocField.fetchExc(oidEmpDocField);
					} catch (DBException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
					}
				}
				break;

			case Command.ASK :
				if (oidEmpDocField != 0) {
					try {
						empDocField = pstEmpDocField.fetchExc(oidEmpDocField);
					} catch (DBException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
					}
				}
				break;


			case Command.DELETE :
				if (oidEmpDocField != 0){
					try{
						long oid = PstEmpDoc.deleteExc(oidEmpDocField);
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

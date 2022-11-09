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

/**
 *
 * @author IanRizky
 */
public class CtrlKpiTargetDetailEmployee extends Control implements I_Language {

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
	private KpiTargetDetailEmployee entKpiTargetDetailEmployee;
	private PstKpiTargetDetailEmployee pstKpiTargetDetailEmployee;
	private FrmKpiTargetDetailEmployee frmKpiTargetDetailEmployee;
	int language = LANGUAGE_DEFAULT;

	public CtrlKpiTargetDetailEmployee(HttpServletRequest request) {
		msgString = "";
		entKpiTargetDetailEmployee = new KpiTargetDetailEmployee();
		try {
			pstKpiTargetDetailEmployee = new PstKpiTargetDetailEmployee(0);
		} catch (Exception e) {;
		}
		frmKpiTargetDetailEmployee = new FrmKpiTargetDetailEmployee(request, entKpiTargetDetailEmployee);
	}

	private String getSystemMessage(int msgCode) {
		switch (msgCode) {
			case I_DBExceptionInfo.MULTIPLE_ID:
				this.frmKpiTargetDetailEmployee.addError(frmKpiTargetDetailEmployee.FRM_FIELD_KPI_TARGET_DETAIL_EMPLOYEE_ID, resultText[language][RSLT_EST_CODE_EXIST]);
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

	public KpiTargetDetailEmployee getKpiTargetDetailEmployee() {
		return entKpiTargetDetailEmployee;
	}

	public FrmKpiTargetDetailEmployee getForm() {
		return frmKpiTargetDetailEmployee;
	}

	public String getMessage() {
		return msgString;
	}

	public int getStart() {
		return start;
	}

	public int action(int cmd, long oidKpiTargetDetailEmployee) {
		msgString = "";
		int excCode = I_DBExceptionInfo.NO_EXCEPTION;
		int rsCode = RSLT_OK;
		switch (cmd) {
			case Command.ADD:
				break;

			case Command.SAVE:
				if (oidKpiTargetDetailEmployee != 0) {
					try {
						entKpiTargetDetailEmployee = PstKpiTargetDetailEmployee.fetchExc(oidKpiTargetDetailEmployee);
					} catch (Exception exc) {
					}
				}

				frmKpiTargetDetailEmployee.requestEntityObject(entKpiTargetDetailEmployee);

				if (frmKpiTargetDetailEmployee.errorSize() > 0) {
					msgString = FRMMessage.getMsg(FRMMessage.MSG_INCOMPLATE);
					return RSLT_FORM_INCOMPLETE;
				}

				if (entKpiTargetDetailEmployee.getOID() == 0) {
					try {
						long oid = pstKpiTargetDetailEmployee.insertExc(this.entKpiTargetDetailEmployee);
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
						long oid = pstKpiTargetDetailEmployee.updateExc(this.entKpiTargetDetailEmployee);
					} catch (DBException dbexc) {
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc) {
						msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
					}

				}
				break;

			case Command.EDIT:
				if (oidKpiTargetDetailEmployee != 0) {
					try {
						entKpiTargetDetailEmployee = PstKpiTargetDetailEmployee.fetchExc(oidKpiTargetDetailEmployee);
					} catch (DBException dbexc) {
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc) {
						msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
					}
				}
				break;

			case Command.ASK:
				if (oidKpiTargetDetailEmployee != 0) {
					try {
						entKpiTargetDetailEmployee = PstKpiTargetDetailEmployee.fetchExc(oidKpiTargetDetailEmployee);
					} catch (DBException dbexc) {
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc) {
						msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
					}
				}
				break;

			case Command.DELETE:
				if (oidKpiTargetDetailEmployee != 0) {
					try {
						long oid = PstKpiTargetDetailEmployee.deleteExc(oidKpiTargetDetailEmployee);
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
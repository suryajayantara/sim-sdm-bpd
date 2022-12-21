/* Created on 	:  30 September 2011 [time] AM/PM
 *
 * @author  	:  Priska
 * @version  	:  [version]
 */
/** *****************************************************************
 * Class Description 	: CtrlCompany
 * Imput Parameters 	: [input parameter ...]
 * Output 		: [output ...]
 ****************************************************************** */
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
import com.dimata.system.entity.PstSystemProperty;
import static com.dimata.util.lang.I_Language.LANGUAGE_DEFAULT;
import java.sql.*;

public class CtrlKPI_Type extends Control implements I_Language {

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
    private KPI_Type kPI_Type;
    private PstKPI_Type pstKPI_Type;
    private FrmKPI_Type frmKPI_Type;
    int language = LANGUAGE_DEFAULT;

    public CtrlKPI_Type(HttpServletRequest request) {
        msgString = "";
        kPI_Type = new KPI_Type();
        try {
            pstKPI_Type = new PstKPI_Type(0);
        } catch (Exception e) {
            ;
        }
        frmKPI_Type = new FrmKPI_Type(request, kPI_Type);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_DBExceptionInfo.MULTIPLE_ID:
                this.frmKPI_Type.addError(frmKPI_Type.FRM_FIELD_KPI_TYPE_ID, resultText[language][RSLT_EST_CODE_EXIST]);
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

    public KPI_Type getdKPI_Type() {
        return kPI_Type;
    }

    public FrmKPI_Type getForm() {
        return frmKPI_Type;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidKPI_Type, HttpServletRequest request) {
        msgString = "";
        int excCode = I_DBExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case Command.ADD:
                break;

            case Command.SAVE:
                if (oidKPI_Type != 0) {
                    try {
                        kPI_Type = PstKPI_Type.fetchExc(oidKPI_Type);
                        kPI_Type.setKpi_type_id(kPI_Type.getOID());
                    } catch (Exception exc) {
                    }
                }

                frmKPI_Type.requestEntityObject(kPI_Type);

                if (frmKPI_Type.errorSize() > 0) {
                    msgString = FRMMessage.getMsg(FRMMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (kPI_Type.getOID() == 0) {
                    try {
                        long oid = pstKPI_Type.insertExc(this.kPI_Type);
                        PstKPITypeCompany.deleteByKPITypeId(oid);
                        String oid_company[] = FRMQueryString.requestStringValues(request, "company");
                        String companiesOID = "(";
                        if (oid_company != null) {
                            for (int uu = 0; uu < oid_company.length; uu++) {
                                KPITypeCompany objMapKpiTypeComp = new KPITypeCompany();
                                objMapKpiTypeComp.setKpiTypeId(oid);
                                objMapKpiTypeComp.setCompanyId(Long.parseLong(oid_company[uu]));
                                PstKPITypeCompany.insertExc(objMapKpiTypeComp);
                                companiesOID = "" + oid_company[uu];
                                if((uu + 1) != oid_company.length){
                                    companiesOID += ",";
                                } else {
                                    companiesOID += ")";
                                }
                            }
                        }

                        PstKpiTypeDivision.deleteByKPITypeId(oid);
                        String oid_division[] = FRMQueryString.requestStringValues(request, "division");
                        if (oid_division != null) {
                            for (int ux = 0; ux < oid_division.length; ux++) {
                                KpiTypeDivision objMapKpiTypeDiv = new KpiTypeDivision();
                                objMapKpiTypeDiv.setKpiTypeId(oid);
                                objMapKpiTypeDiv.setDivisionId(Long.parseLong(oid_division[ux]));
                                PstKpiTypeDivision.insertExc(objMapKpiTypeDiv);
                            }
                        } else {
                            Vector vDivision = PstDivision.list(
                                    0, 
                                    0, 
                                    PstDivision.fieldNames[PstDivision.FLD_VALID_STATUS] + " = " + PstDivision.VALID_ACTIVE +
                                    " AND " + PstDivision.fieldNames[PstDivision.FLD_COMPANY_ID] + " IN " + companiesOID , 
                                    ""
                            );
                            for (int i = 0; i < vDivision.size(); i++) {
                                Division entDivision = (Division) vDivision.get(i);
                                KpiTypeDivision objMapKpiTypeDiv = new KpiTypeDivision();
                                objMapKpiTypeDiv.setKpiTypeId(oid);
                                objMapKpiTypeDiv.setDivisionId(entDivision.getOID());
                                PstKpiTypeDivision.insertExc(objMapKpiTypeDiv);
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
                        PstKPITypeCompany.deleteByKPITypeId(this.kPI_Type.getOID());
                        String oid_company[] = FRMQueryString.requestStringValues(request, "company");
                        String companiesOID = "(";
                        if (oid_company != null) {
                            for (int uu = 0; uu < oid_company.length; uu++) {
                                KPITypeCompany objMapKpiTypeComp = new KPITypeCompany();
                                objMapKpiTypeComp.setKpiTypeId(this.kPI_Type.getOID());
                                objMapKpiTypeComp.setCompanyId(Long.parseLong(oid_company[uu]));
                                PstKPITypeCompany.insertExc(objMapKpiTypeComp);
                                companiesOID += "" + oid_company[uu];
                                if((uu + 1) != oid_company.length){
                                    companiesOID += ",";
                                } else {
                                    companiesOID += ")";
                                }
                            }
                        }

                        PstKPITypeDivsion.deleteByKPITypeId(this.kPI_Type.getOID());
                        String oid_division[] = FRMQueryString.requestStringValues(request, "division");
                        if (oid_division != null) {
                            for (int xx = 0; xx < oid_division.length; xx++) {
                                KpiTypeDivision objMapKPITypeDivision = new KpiTypeDivision();
                                objMapKPITypeDivision.setKpiTypeId(this.kPI_Type.getOID());
                                objMapKPITypeDivision.setDivisionId(Long.parseLong(oid_division[xx]));
                                PstKPITypeDivsion.insertExc(objMapKPITypeDivision);
                            }
                        } else {
                            Vector vDivision = PstDivision.list(
                                    0, 
                                    0, 
                                    PstDivision.fieldNames[PstDivision.FLD_VALID_STATUS] + " = " + PstDivision.VALID_ACTIVE +
                                    " AND " + PstDivision.fieldNames[PstDivision.FLD_COMPANY_ID] + " IN " + companiesOID , 
                                    ""
                            );
                            for (int i = 0; i < vDivision.size(); i++) {
                                Division entDivision = (Division) vDivision.get(i);
                                KpiTypeDivision objMapKpiTypeDiv = new KpiTypeDivision();
                                objMapKpiTypeDiv.setKpiTypeId(this.kPI_Type.getOID());
                                objMapKpiTypeDiv.setDivisionId(entDivision.getOID());
                                PstKpiTypeDivision.insertExc(objMapKpiTypeDiv);
                            }
                        }

                        long oid = pstKPI_Type.updateExc(this.kPI_Type);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }

                }
                break;

            case Command.EDIT:
                if (oidKPI_Type != 0) {
                    try {
                        kPI_Type = PstKPI_Type.fetchExc(oidKPI_Type);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.ASK:
                if (oidKPI_Type != 0) {
                    try {
                        kPI_Type = PstKPI_Type.fetchExc(oidKPI_Type);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.DELETE:
                if (oidKPI_Type != 0) {
                    try {
                        PstKPITypeCompany.deleteByKPITypeId(oidKPI_Type);
                        PstKPITypeDivsion.deleteByKPITypeId(this.kPI_Type.getOID());
                        long oid = PstKPI_Type.deleteExc(oidKPI_Type);
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

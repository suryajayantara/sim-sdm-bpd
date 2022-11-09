/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.log;

import com.dimata.qdep.entity.Entity;
import java.util.Date;

public class LogSysHistory extends Entity {

    private long logDocumentId = 0;
    private long logUserId = 0;
    private String logLoginName = "";
    private String logDocumentNumber = "";
    private String logDocumentType = "";
    private String logUserAction = "";
    private String logOpenUrl = "";
    private Date logUpdateDate = null;
    private String logApplication = "";
    private String logDetail = "";
    private int logStatus = 0;
    private long approverId = 0;
    private Date approveDate = null;
    private String approverNote = "";
    private String logPrev = "";
    private String logCurr = "";
    private String logModule = "";
    private long logEditedUserId = 0;
    /* Update by Hendra Putu | 20160517 */
    private long companyId = 0;
    private long divisionId = 0;
    private long departmentId = 0;
    private long sectionId = 0;
    private long approver1 = 0;
    private long approver2 = 0;
    private long approver3 = 0;
    private long approver4 = 0;
    private long approver5 = 0;
    private long approver6 = 0;
    private Date approve1Date = null;
    private Date approve2Date = null;
    private Date approve3Date = null;
    private Date approve4Date = null;
    private Date approve5Date = null;
    private Date approve6Date = null;
    private String query = "";
    

    public long getLogDocumentId() {
        return logDocumentId;
    }

    public void setLogDocumentId(long logDocumentId) {
        this.logDocumentId = logDocumentId;
    }

    public long getLogUserId() {
        return logUserId;
    }

    public void setLogUserId(long logUserId) {
        this.logUserId = logUserId;
    }

    public String getLogLoginName() {
        return logLoginName;
    }

    public void setLogLoginName(String logLoginName) {
        this.logLoginName = logLoginName;
    }

    public String getLogDocumentNumber() {
        return logDocumentNumber;
    }

    public void setLogDocumentNumber(String logDocumentNumber) {
        this.logDocumentNumber = logDocumentNumber;
    }

    public String getLogDocumentType() {
        return logDocumentType;
    }

    public void setLogDocumentType(String logDocumentType) {
        this.logDocumentType = logDocumentType;
    }

    public String getLogUserAction() {
        return logUserAction;
    }

    public void setLogUserAction(String logUserAction) {
        this.logUserAction = logUserAction;
    }

    public String getLogOpenUrl() {
        return logOpenUrl;
    }

    public void setLogOpenUrl(String logOpenUrl) {
        this.logOpenUrl = logOpenUrl;
    }

    public Date getLogUpdateDate() {
        return logUpdateDate;
    }

    public void setLogUpdateDate(Date logUpdateDate) {
        this.logUpdateDate = logUpdateDate;
    }

    public String getLogApplication() {
        return logApplication;
    }

    public void setLogApplication(String logApplication) {
        this.logApplication = logApplication;
    }

    public String getLogDetail() {
        return logDetail;
    }

    public void setLogDetail(String logDetail) {
        this.logDetail = logDetail;
    }

    public int getLogStatus() {
        return logStatus;
    }

    public void setLogStatus(int logStatus) {
        this.logStatus = logStatus;
    }

    public long getApproverId() {
        return approverId;
    }

    public void setApproverId(long approverId) {
        this.approverId = approverId;
    }

    public Date getApproveDate() {
        return approveDate;
    }

    public void setApproveDate(Date approveDate) {
        this.approveDate = approveDate;
    }

    public String getApproverNote() {
        return approverNote;
    }

    public void setApproverNote(String approverNote) {
        this.approverNote = approverNote;
    }

    public String getLogPrev() {
        return logPrev;
    }

    public void setLogPrev(String logPrev) {
        this.logPrev = logPrev;
    }

    public String getLogCurr() {
        return logCurr;
    }

    public void setLogCurr(String logCurr) {
        this.logCurr = logCurr;
    }

    public String getLogModule() {
        return logModule;
    }

    public void setLogModule(String logModule) {
        this.logModule = logModule;
    }

    /**
     * @return the logEditedUserId
     */
    public long getLogEditedUserId() {
        return logEditedUserId;
    }

    /**
     * @param logEditedUserId the logEditedUserId to set
     */
    public void setLogEditedUserId(long logEditedUserId) {
        this.logEditedUserId = logEditedUserId;
    }

    /**
     * @return the companyId
     */
    public long getCompanyId() {
        return companyId;
    }

    /**
     * @param companyId the companyId to set
     */
    public void setCompanyId(long companyId) {
        this.companyId = companyId;
    }

    /**
     * @return the divisionId
     */
    public long getDivisionId() {
        return divisionId;
    }

    /**
     * @param divisionId the divisionId to set
     */
    public void setDivisionId(long divisionId) {
        this.divisionId = divisionId;
    }

    /**
     * @return the departmentId
     */
    public long getDepartmentId() {
        return departmentId;
    }

    /**
     * @param departmentId the departmentId to set
     */
    public void setDepartmentId(long departmentId) {
        this.departmentId = departmentId;
    }

    /**
     * @return the sectionId
     */
    public long getSectionId() {
        return sectionId;
    }

    /**
     * @param sectionId the sectionId to set
     */
    public void setSectionId(long sectionId) {
        this.sectionId = sectionId;
    }

    /**
     * @return the approver1
     */
    public long getApprover1() {
        return approver1;
    }

    /**
     * @param approver1 the approver1 to set
     */
    public void setApprover1(long approver1) {
        this.approver1 = approver1;
    }

    /**
     * @return the approver2
     */
    public long getApprover2() {
        return approver2;
    }

    /**
     * @param approver2 the approver2 to set
     */
    public void setApprover2(long approver2) {
        this.approver2 = approver2;
    }

    /**
     * @return the approver3
     */
    public long getApprover3() {
        return approver3;
    }

    /**
     * @param approver3 the approver3 to set
     */
    public void setApprover3(long approver3) {
        this.approver3 = approver3;
    }

    /**
     * @return the approver4
     */
    public long getApprover4() {
        return approver4;
    }

    /**
     * @param approver4 the approver4 to set
     */
    public void setApprover4(long approver4) {
        this.approver4 = approver4;
    }

    /**
     * @return the approver5
     */
    public long getApprover5() {
        return approver5;
    }

    /**
     * @param approver5 the approver5 to set
     */
    public void setApprover5(long approver5) {
        this.approver5 = approver5;
    }

    /**
     * @return the approver6
     */
    public long getApprover6() {
        return approver6;
    }

    /**
     * @param approver6 the approver6 to set
     */
    public void setApprover6(long approver6) {
        this.approver6 = approver6;
    }

    /**
     * @return the approve1Date
     */
    public Date getApprove1Date() {
        return approve1Date;
    }

    /**
     * @param approve1Date the approve1Date to set
     */
    public void setApprove1Date(Date approve1Date) {
        this.approve1Date = approve1Date;
    }

    /**
     * @return the approve2Date
     */
    public Date getApprove2Date() {
        return approve2Date;
    }

    /**
     * @param approve2Date the approve2Date to set
     */
    public void setApprove2Date(Date approve2Date) {
        this.approve2Date = approve2Date;
    }

    /**
     * @return the approve3Date
     */
    public Date getApprove3Date() {
        return approve3Date;
    }

    /**
     * @param approve3Date the approve3Date to set
     */
    public void setApprove3Date(Date approve3Date) {
        this.approve3Date = approve3Date;
    }

    /**
     * @return the approve4Date
     */
    public Date getApprove4Date() {
        return approve4Date;
    }

    /**
     * @param approve4Date the approve4Date to set
     */
    public void setApprove4Date(Date approve4Date) {
        this.approve4Date = approve4Date;
    }

    /**
     * @return the approve5Date
     */
    public Date getApprove5Date() {
        return approve5Date;
    }

    /**
     * @param approve5Date the approve5Date to set
     */
    public void setApprove5Date(Date approve5Date) {
        this.approve5Date = approve5Date;
    }

    /**
     * @return the approve6Date
     */
    public Date getApprove6Date() {
        return approve6Date;
    }

    /**
     * @param approve6Date the approve6Date to set
     */
    public void setApprove6Date(Date approve6Date) {
        this.approve6Date = approve6Date;
    }

    /**
     * @return the query
     */
    public String getQuery() {
        return query;
    }

    /**
     * @param query the query to set
     */
    public void setQuery(String query) {
        this.query = query;
    }
}

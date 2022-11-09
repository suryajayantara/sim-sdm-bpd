/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.masterdata;

import com.dimata.qdep.entity.Entity;
import java.util.Date;

/**
 *
 * @author GUSWIK
 */
public class KPI_Employee_Achiev extends Entity{
      
        private long kpiListId;
        private Date startDate;
        private Date  endDate;
        private long  employeeId;
        private Date  entryDate;
        private double achievement;
		private Date achievDate;
		private String achievProof;
		private int achievType;
		private long approval1 = 0;
		private Date approvalDate1 = null;
		private long approval2 = 0;
		private Date approvalDate2 = null;
		private long approval3 = 0;
		private Date approvalDate3 = null;
		private long approval4 = 0;
		private Date approvalDate4 = null;
		private long approval5 = 0;
		private Date approvalDate5 = null;
		private long approval6 = 0;
		private Date approvalDate6 = null;
		private int status = 0;
		private long targetId = 0;
		private String achievNote = "";

    /**
     * @return the kpiListId
     */
    public long getKpiListId() {
        return kpiListId;
    }

    /**
     * @param kpiListId the kpiListId to set
     */
    public void setKpiListId(long kpiListId) {
        this.kpiListId = kpiListId;
    }

    /**
     * @return the startDate
     */
    public Date getStartDate() {
        return startDate;
    }

    /**
     * @param startDate the startDate to set
     */
    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    /**
     * @return the endDate
     */
    public Date getEndDate() {
        return endDate;
    }

    /**
     * @param endDate the endDate to set
     */
    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    /**
     * @return the employeeId
     */
    public long getEmployeeId() {
        return employeeId;
    }

    /**
     * @param employeeId the employeeId to set
     */
    public void setEmployeeId(long employeeId) {
        this.employeeId = employeeId;
    }

    /**
     * @return the entryDate
     */
    public Date getEntryDate() {
        return entryDate;
    }

    /**
     * @param entryDate the entryDate to set
     */
    public void setEntryDate(Date entryDate) {
        this.entryDate = entryDate;
    }

    /**
     * @return the achievement
     */
    public double getAchievement() {
        return achievement;
    }

    /**
     * @param achievement the achievement to set
     */
    public void setAchievement(double achievement) {
        this.achievement = achievement;
    }

	/**
	 * @return the achievDate
	 */
	public Date getAchievDate() {
		return achievDate;
	}

	/**
	 * @param achievDate the achievDate to set
	 */
	public void setAchievDate(Date achievDate) {
		this.achievDate = achievDate;
	}

	/**
	 * @return the achievProof
	 */
	public String getAchievProof() {
		return achievProof;
	}

	/**
	 * @param achievProof the achievProof to set
	 */
	public void setAchievProof(String achievProof) {
		this.achievProof = achievProof;
	}

	/**
	 * @return the achievType
	 */
	public int getAchievType() {
		return achievType;
	}

	/**
	 * @param achievType the achievType to set
	 */
	public void setAchievType(int achievType) {
		this.achievType = achievType;
	}

	/**
	 * @return the approval1
	 */
	public long getApproval1() {
		return approval1;
	}

	/**
	 * @param approval1 the approval1 to set
	 */
	public void setApproval1(long approval1) {
		this.approval1 = approval1;
	}

	/**
	 * @return the approvalDate1
	 */
	public Date getApprovalDate1() {
		return approvalDate1;
	}

	/**
	 * @param approvalDate1 the approvalDate1 to set
	 */
	public void setApprovalDate1(Date approvalDate1) {
		this.approvalDate1 = approvalDate1;
	}

	/**
	 * @return the approval2
	 */
	public long getApproval2() {
		return approval2;
	}

	/**
	 * @param approval2 the approval2 to set
	 */
	public void setApproval2(long approval2) {
		this.approval2 = approval2;
	}

	/**
	 * @return the approvalDate2
	 */
	public Date getApprovalDate2() {
		return approvalDate2;
	}

	/**
	 * @param approvalDate2 the approvalDate2 to set
	 */
	public void setApprovalDate2(Date approvalDate2) {
		this.approvalDate2 = approvalDate2;
	}

	/**
	 * @return the approval3
	 */
	public long getApproval3() {
		return approval3;
	}

	/**
	 * @param approval3 the approval3 to set
	 */
	public void setApproval3(long approval3) {
		this.approval3 = approval3;
	}

	/**
	 * @return the approvalDate3
	 */
	public Date getApprovalDate3() {
		return approvalDate3;
	}

	/**
	 * @param approvalDate3 the approvalDate3 to set
	 */
	public void setApprovalDate3(Date approvalDate3) {
		this.approvalDate3 = approvalDate3;
	}

	/**
	 * @return the approval4
	 */
	public long getApproval4() {
		return approval4;
	}

	/**
	 * @param approval4 the approval4 to set
	 */
	public void setApproval4(long approval4) {
		this.approval4 = approval4;
	}

	/**
	 * @return the approvalDate4
	 */
	public Date getApprovalDate4() {
		return approvalDate4;
	}

	/**
	 * @param approvalDate4 the approvalDate4 to set
	 */
	public void setApprovalDate4(Date approvalDate4) {
		this.approvalDate4 = approvalDate4;
	}

	/**
	 * @return the approval5
	 */
	public long getApproval5() {
		return approval5;
	}

	/**
	 * @param approval5 the approval5 to set
	 */
	public void setApproval5(long approval5) {
		this.approval5 = approval5;
	}

	/**
	 * @return the approvalDate5
	 */
	public Date getApprovalDate5() {
		return approvalDate5;
	}

	/**
	 * @param approvalDate5 the approvalDate5 to set
	 */
	public void setApprovalDate5(Date approvalDate5) {
		this.approvalDate5 = approvalDate5;
	}

	/**
	 * @return the approval6
	 */
	public long getApproval6() {
		return approval6;
	}

	/**
	 * @param approval6 the approval6 to set
	 */
	public void setApproval6(long approval6) {
		this.approval6 = approval6;
	}

	/**
	 * @return the approvalDate6
	 */
	public Date getApprovalDate6() {
		return approvalDate6;
	}

	/**
	 * @param approvalDate6 the approvalDate6 to set
	 */
	public void setApprovalDate6(Date approvalDate6) {
		this.approvalDate6 = approvalDate6;
	}

	/**
	 * @return the status
	 */
	public int getStatus() {
		return status;
	}

	/**
	 * @param status the status to set
	 */
	public void setStatus(int status) {
		this.status = status;
	}

	/**
	 * @return the targetId
	 */
	public long getTargetId() {
		return targetId;
	}

	/**
	 * @param targetId the targetId to set
	 */
	public void setTargetId(long targetId) {
		this.targetId = targetId;
	}

	/**
	 * @return the achievNote
	 */
	public String getAchievNote() {
		return achievNote;
	}

	/**
	 * @param achievNote the achievNote to set
	 */
	public void setAchievNote(String achievNote) {
		this.achievNote = achievNote;
	}
}

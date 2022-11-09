/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.masterdata;

import com.dimata.qdep.entity.Entity;
import java.util.Date;

/**
 *
 * @author IanRizky
 */
public class KpiTarget extends Entity {



	private Date createDate = null;
	private String title = "";
	private int statusDoc = 0;
	private long companyId = 0;
	private long divisionId = 0;
        private long positionId = 0;
	private long departmentId = 0;
	private long sectionId = 0;
	private int countIdx = 0;
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
	private long authorId = 0;
	private int tahun = 0;

	public Date getCreateDate() {
		return createDate;
	}

	public void setCreateDate(Date createDate) {
		this.createDate = createDate;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public int getStatusDoc() {
		return statusDoc;
	}

	public void setStatusDoc(int statusDoc) {
		this.statusDoc = statusDoc;
	}

	public long getCompanyId() {
		return companyId;
	}

	public void setCompanyId(long companyId) {
		this.companyId = companyId;
	}

	public long getDivisionId() {
		return divisionId;
	}

	public void setDivisionId(long divisionId) {
		this.divisionId = divisionId;
	}

	public long getDepartmentId() {
		return departmentId;
	}

	public void setDepartmentId(long departmentId) {
		this.departmentId = departmentId;
	}

	public long getSectionId() {
		return sectionId;
	}

	public void setSectionId(long sectionId) {
		this.sectionId = sectionId;
	}

	public int getCountIdx() {
		return countIdx;
	}

	public void setCountIdx(int countIdx) {
		this.countIdx = countIdx;
	}

	public long getApproval1() {
		return approval1;
	}

	public void setApproval1(long approval1) {
		this.approval1 = approval1;
	}

	public Date getApprovalDate1() {
		return approvalDate1;
	}

	public void setApprovalDate1(Date approvalDate1) {
		this.approvalDate1 = approvalDate1;
	}

	public long getApproval2() {
		return approval2;
	}

	public void setApproval2(long approval2) {
		this.approval2 = approval2;
	}

	public Date getApprovalDate2() {
		return approvalDate2;
	}

	public void setApprovalDate2(Date approvalDate2) {
		this.approvalDate2 = approvalDate2;
	}

	public long getApproval3() {
		return approval3;
	}

	public void setApproval3(long approval3) {
		this.approval3 = approval3;
	}

	public Date getApprovalDate3() {
		return approvalDate3;
	}

	public void setApprovalDate3(Date approvalDate3) {
		this.approvalDate3 = approvalDate3;
	}

	public long getApproval4() {
		return approval4;
	}

	public void setApproval4(long approval4) {
		this.approval4 = approval4;
	}

	public Date getApprovalDate4() {
		return approvalDate4;
	}

	public void setApprovalDate4(Date approvalDate4) {
		this.approvalDate4 = approvalDate4;
	}

	public long getApproval5() {
		return approval5;
	}

	public void setApproval5(long approval5) {
		this.approval5 = approval5;
	}

	public Date getApprovalDate5() {
		return approvalDate5;
	}

	public void setApprovalDate5(Date approvalDate5) {
		this.approvalDate5 = approvalDate5;
	}

	public long getApproval6() {
		return approval6;
	}

	public void setApproval6(long approval6) {
		this.approval6 = approval6;
	}

	public Date getApprovalDate6() {
		return approvalDate6;
	}

	public void setApprovalDate6(Date approvalDate6) {
		this.approvalDate6 = approvalDate6;
	}

	/**
	 * @return the authorId
	 */
	public long getAuthorId() {
		return authorId;
	}

	/**
	 * @param authorId the authorId to set
	 */
	public void setAuthorId(long authorId) {
		this.authorId = authorId;
	}

	/**
	 * @return the tahun
	 */
	public int getTahun() {
		return tahun;
	}

	/**
	 * @param tahun the tahun to set
	 */
	public void setTahun(int tahun) {
		this.tahun = tahun;
	}
        
            /**
     * @return the positionId
     */
    public long getPositionId() {
        return positionId;
    }

    /**
     * @param positionId the positionId to set
     */
    public void setPositionId(long positionId) {
        this.positionId = positionId;
    }

}
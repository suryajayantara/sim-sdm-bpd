/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.session.employee;

import java.util.Date;

/**
 *
 * @author Kartika
 */
public class EmployeeCandidate {
    private long employeeId = 0;
    private String payrollNumber ="";
    private String fullName = "";
    private Date commecingDate = null;
    private long companyId =0;
    private String company ="";
    private long divisionId =0;
    private String division ="";
    private long departmentId=0;
    private String department=""; 
    private long sectionId= 0;
    private String section="";
    private long currPositionId=0;
    private String currPosition ="";
    private String gradeCode ="";
    private int gradeRank =0;
    private float LengthOfService = 0.0f;
    private float workHistoryLength =0.0f;
    private float currentPosLength =0.0f;
    private float sumCompetencyScore =0.0f;
    private String educationCode ="";
    private float educationScore =0.0f;
    private int educationLevel =0;
	private float total = 0;
	private float positionLength = 0;

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
     * @return the payrollNumber
     */
    public String getPayrollNumber() {
        return payrollNumber;
    }

    /**
     * @param payrollNumber the payrollNumber to set
     */
    public void setPayrollNumber(String payrollNumber) {
        this.payrollNumber = payrollNumber;
    }

    /**
     * @return the fullName
     */
    public String getFullName() {
        return fullName;
    }

    /**
     * @param fullName the fullName to set
     */
    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    /**
     * @return the commecingDate
     */
    public Date getCommecingDate() {
        return commecingDate;
    }

    /**
     * @param commecingDate the commecingDate to set
     */
    public void setCommecingDate(Date commecingDate) {
        this.commecingDate = commecingDate;
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
     * @return the company
     */
    public String getCompany() {
        return company;
    }

    /**
     * @param company the company to set
     */
    public void setCompany(String company) {
        this.company = company;
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
     * @return the division
     */
    public String getDivision() {
        return division;
    }

    /**
     * @param division the division to set
     */
    public void setDivision(String division) {
        this.division = division;
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
     * @return the department
     */
    public String getDepartment() {
        return department;
    }

    /**
     * @param department the department to set
     */
    public void setDepartment(String department) {
        this.department = department;
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
     * @return the section
     */
    public String getSection() {
        return section;
    }

    /**
     * @param section the section to set
     */
    public void setSection(String section) {
        this.section = section;
    }

    /**
     * @return the currPositionId
     */
    public long getCurrPositionId() {
        return currPositionId;
    }

    /**
     * @param currPositionId the currPositionId to set
     */
    public void setCurrPositionId(long currPositionId) {
        this.currPositionId = currPositionId;
    }

    /**
     * @return the currPosition
     */
    public String getCurrPosition() {
        return currPosition;
    }

    /**
     * @param currPosition the currPosition to set
     */
    public void setCurrPosition(String currPosition) {
        this.currPosition = currPosition;
    }

    /**
     * @return the gradeCode
     */
    public String getGradeCode() {
        return gradeCode;
    }

    /**
     * @param gradeCode the gradeCode to set
     */
    public void setGradeCode(String gradeCode) {
        this.gradeCode = gradeCode;
    }

    /**
     * @return the gradeRank
     */
    public int getGradeRank() {
        return gradeRank;
    }

    /**
     * @param gradeRank the gradeRank to set
     */
    public void setGradeRank(int gradeRank) {
        this.gradeRank = gradeRank;
    }

    /**
     * @return the LengthOfService
     */
    public float getLengthOfService() {
        return LengthOfService;
    }

    /**
     * @param LengthOfService the LengthOfService to set
     */
    public void setLengthOfService(float LengthOfService) {
        this.LengthOfService = LengthOfService;
    }

    /**
     * @return the workHistoryLength
     */
    public float getWorkHistoryLength() {
        return workHistoryLength;
    }

    /**
     * @param workHistoryLength the workHistoryLength to set
     */
    public void setWorkHistoryLength(float workHistoryLength) {
        this.workHistoryLength = workHistoryLength;
    }

    /**
     * @return the currentPosLength
     */
    public float getCurrentPosLength() {
        return currentPosLength;
    }

    /**
     * @param currentPosLength the currentPosLength to set
     */
    public void setCurrentPosLength(float currentPosLength) {
        this.currentPosLength = currentPosLength;
    }

    /**
     * @return the sumCompetencyScore
     */
    public float getSumCompetencyScore() {
        return sumCompetencyScore;
    }

    /**
     * @param sumCompetencyScore the sumCompetencyScore to set
     */
    public void setSumCompetencyScore(float sumCompetencyScore) {
        this.sumCompetencyScore = sumCompetencyScore;
    }

    /**
     * @return the educationCode
     */
    public String getEducationCode() {
        return educationCode;
    }

    /**
     * @param educationCode the educationCode to set
     */
    public void setEducationCode(String educationCode) {
        this.educationCode = educationCode;
    }

    /**
     * @return the educationScore
     */
    public float getEducationScore() {
        return educationScore;
    }

    /**
     * @param educationScore the educationScore to set
     */
    public void setEducationScore(float educationScore) {
        this.educationScore = educationScore;
    }

    /**
     * @return the educationLevel
     */
    public int getEducationLevel() {
        return educationLevel;
    }

    /**
     * @param educationLevel the educationLevel to set
     */
    public void setEducationLevel(int educationLevel) {
        this.educationLevel = educationLevel;
    }

	/**
	 * @return the total
	 */
	public float getTotal() {
		return total;
	}

	/**
	 * @param total the total to set
	 */
	public void setTotal(float total) {
		this.total = total;
	}

	/**
	 * @return the positionLength
	 */
	public float getPositionLength() {
		return positionLength;
	}

	/**
	 * @param positionLength the positionLength to set
	 */
	public void setPositionLength(float positionLength) {
		this.positionLength = positionLength;
	}
}

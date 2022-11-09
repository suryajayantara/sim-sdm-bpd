/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.dimata.harisma.entity.employee.appraisal;

import com.dimata.qdep.entity.Entity;
import java.util.Date;

/**
 *
 * @author artha
 */
public class AppraisalMain extends Entity{
    private long employeeId;
    private long empPositionId;
    private long empDepartmentId;
    private long empLevelId;
    private long assesorId;
    private long assesorPositionId;
    private Date dateAssumedPosition;
    private Date dateOfAssessment;
    private Date dateOfLastAssessment;
    private Date dateOfNextAssessment;
    private Date dateJoinedHotel;
    private int totalAssessment;;
    private double totalScore;
    private double scoreAverage;
    private long divisionHeadId;
    private Date employeeSignDate;
    private Date assessorSignDate;
    private Date divisionHeadSignDate;
    
    private long approval1Id = 0;
    private Date timeApproval1 = new Date();
    private long approval2Id = 0;
    private Date timeApproval2 = new Date();
    private long approval3Id = 0;
    private Date timeApproval3 = new Date();
    private long approval4Id = 0;
    private Date timeApproval4 = new Date();
    private long approval5Id = 0;
    private Date timeApproval5 = new Date();
    private long approval6Id = 0;
    private Date timeApproval6 = new Date();
    
    private Date dataPeriodFrom;
    private Date dataPeriodTo;

    public Date getAssessorSignDate() {
        return assessorSignDate;
    }

    public void setAssessorSignDate(Date assessorSignDate) {
        this.assessorSignDate = assessorSignDate;
    }

    public long getDivisionHeadId() {
        return divisionHeadId;
    }

    public void setDivisionHeadId(long divisionHeadId) {
        this.divisionHeadId = divisionHeadId;
    }

    public Date getDivisionHeadSignDate() {
        return divisionHeadSignDate;
    }

    public void setDivisionHeadSignDate(Date divisionHeadSignDate) {
        this.divisionHeadSignDate = divisionHeadSignDate;
    }

    public Date getEmployeeSignDate() {
        return employeeSignDate;
    }

    public void setEmployeeSignDate(Date employeeSignDate) {
        this.employeeSignDate = employeeSignDate;
    }
    

    
    
    
    public double getScoreAverage() {
        return scoreAverage;
    }

    public void setScoreAverage(double scoreAverage) {
        this.scoreAverage = scoreAverage;
    }

    public double getTotalScore() {
        return totalScore;
    }

    public void setTotalScore(double totalScore) {
        this.totalScore = totalScore;
    }
    
    public int getTotalAssessment() {
        return totalAssessment;
    }

    public void setTotalAssessment(int totalAssessment) {
        this.totalAssessment = totalAssessment;
    }

    public Date getDateJoinedHotel() {
        return dateJoinedHotel;
    }

    public void setDateJoinedHotel(Date dateJoinedHotel) {
        this.dateJoinedHotel = dateJoinedHotel;
    }
    
    public long getAssesorId() {
        return assesorId;
    }

    public void setAssesorId(long assesorId) {
        this.assesorId = assesorId;
    }

    public long getAssesorPositionId() {
        return assesorPositionId;
    }

    public void setAssesorPositionId(long assesorPositionId) {
        this.assesorPositionId = assesorPositionId;
    }

    public Date getDateAssumedPosition() {
        return dateAssumedPosition;
    }

    public void setDateAssumedPosition(Date dateAssumedPosition) {
        this.dateAssumedPosition = dateAssumedPosition;
    }

    public Date getDateOfAssessment() {
        return dateOfAssessment;
    }

    public void setDateOfAssessment(Date dateOfAssessment) {
        this.dateOfAssessment = dateOfAssessment;
    }

    public Date getDateOfLastAssessment() {
        return dateOfLastAssessment;
    }

    public void setDateOfLastAssessment(Date dateOfLastAssessment) {
        this.dateOfLastAssessment = dateOfLastAssessment;
    }

    public Date getDateOfNextAssessment() {
        return dateOfNextAssessment;
    }

    public void setDateOfNextAssessment(Date dateOfNextAssessment) {
        this.dateOfNextAssessment = dateOfNextAssessment;
    }

    public long getEmpDepartmentId() {
        return empDepartmentId;
    }

    public void setEmpDepartmentId(long empDepartmentId) {
        this.empDepartmentId = empDepartmentId;
    }

    public long getEmpLevelId() {
        return empLevelId;
    }

    public void setEmpLevelId(long empLevelId) {
        this.empLevelId = empLevelId;
    }

    public long getEmpPositionId() {
        return empPositionId;
    }

    public void setEmpPositionId(long empPositionId) {
        this.empPositionId = empPositionId;
    }

    public long getEmployeeId() {
        return employeeId;
    }

    public void setEmployeeId(long employeeId) {
        this.employeeId = employeeId;
    }

    /**
     * @return the approval1Id
     */
    public long getApproval1Id() {
        return approval1Id;
    }

    /**
     * @param approval1Id the approval1Id to set
     */
    public void setApproval1Id(long approval1Id) {
        this.approval1Id = approval1Id;
    }

    /**
     * @return the timeApproval1
     */
    public Date getTimeApproval1() {
        return timeApproval1;
    }

    /**
     * @param timeApproval1 the timeApproval1 to set
     */
    public void setTimeApproval1(Date timeApproval1) {
        this.timeApproval1 = timeApproval1;
    }

    /**
     * @return the approval2Id
     */
    public long getApproval2Id() {
        return approval2Id;
    }

    /**
     * @param approval2Id the approval2Id to set
     */
    public void setApproval2Id(long approval2Id) {
        this.approval2Id = approval2Id;
    }

    /**
     * @return the timeApproval2
     */
    public Date getTimeApproval2() {
        return timeApproval2;
    }

    /**
     * @param timeApproval2 the timeApproval2 to set
     */
    public void setTimeApproval2(Date timeApproval2) {
        this.timeApproval2 = timeApproval2;
    }

    /**
     * @return the approval3Id
     */
    public long getApproval3Id() {
        return approval3Id;
    }

    /**
     * @param approval3Id the approval3Id to set
     */
    public void setApproval3Id(long approval3Id) {
        this.approval3Id = approval3Id;
    }

    /**
     * @return the timeApproval3
     */
    public Date getTimeApproval3() {
        return timeApproval3;
    }

    /**
     * @param timeApproval3 the timeApproval3 to set
     */
    public void setTimeApproval3(Date timeApproval3) {
        this.timeApproval3 = timeApproval3;
    }

    /**
     * @return the approval4Id
     */
    public long getApproval4Id() {
        return approval4Id;
    }

    /**
     * @param approval4Id the approval4Id to set
     */
    public void setApproval4Id(long approval4Id) {
        this.approval4Id = approval4Id;
    }

    /**
     * @return the timeApproval4
     */
    public Date getTimeApproval4() {
        return timeApproval4;
    }

    /**
     * @param timeApproval4 the timeApproval4 to set
     */
    public void setTimeApproval4(Date timeApproval4) {
        this.timeApproval4 = timeApproval4;
    }

    /**
     * @return the approval5Id
     */
    public long getApproval5Id() {
        return approval5Id;
    }

    /**
     * @param approval5Id the approval5Id to set
     */
    public void setApproval5Id(long approval5Id) {
        this.approval5Id = approval5Id;
    }

    /**
     * @return the timeApproval5
     */
    public Date getTimeApproval5() {
        return timeApproval5;
    }

    /**
     * @param timeApproval5 the timeApproval5 to set
     */
    public void setTimeApproval5(Date timeApproval5) {
        this.timeApproval5 = timeApproval5;
    }

    /**
     * @return the approval6Id
     */
    public long getApproval6Id() {
        return approval6Id;
    }

    /**
     * @param approval6Id the approval6Id to set
     */
    public void setApproval6Id(long approval6Id) {
        this.approval6Id = approval6Id;
    }

    /**
     * @return the timeApproval6
     */
    public Date getTimeApproval6() {
        return timeApproval6;
    }

    /**
     * @param timeApproval6 the timeApproval6 to set
     */
    public void setTimeApproval6(Date timeApproval6) {
        this.timeApproval6 = timeApproval6;
    }

    /**
     * @return the dataPeriodFrom
     */
    public Date getDataPeriodFrom() {
        return dataPeriodFrom;
    }

    /**
     * @param dataPeriodFrom the dataPeriodFrom to set
     */
    public void setDataPeriodFrom(Date dataPeriodFrom) {
        this.dataPeriodFrom = dataPeriodFrom;
    }

    /**
     * @return the dataPeriodTo
     */
    public Date getDataPeriodTo() {
        return dataPeriodTo;
    }

    /**
     * @param dataPeriodTo the dataPeriodTo to set
     */
    public void setDataPeriodTo(Date dataPeriodTo) {
        this.dataPeriodTo = dataPeriodTo;
    }
    
    
    
}

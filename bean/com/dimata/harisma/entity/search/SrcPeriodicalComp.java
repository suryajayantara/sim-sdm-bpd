/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.search;

/* package java */ 
import java.util.Date;
import java.util.Vector;

/**
 *
 * @author Gunadi
 */
public class SrcPeriodicalComp {
    private String empNum = "";
    private String fullName = "";
    private long periodFrom = 0;
    private long periodTo = 0;
    private Vector arrCompany= new Vector();
    private Vector arrDivision = new Vector();
    private Vector arrDepartment = new Vector();
    private Vector arrSection = new Vector();
    private Vector arrPosition = new Vector();
    private long componentId = 0;
    private int statusResign = 0;
    private long compareCompId = 0;
    private Vector arrComponent = new Vector();

    /**
     * @return the empNum
     */
    public String getEmpNum() {
        return empNum;
    }

    /**
     * @param empNum the empNum to set
     */
    public void setEmpNum(String empNum) {
        this.empNum = empNum;
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
     * @return the periodFrom
     */
    public long getPeriodFrom() {
        return periodFrom;
    }

    /**
     * @param periodFrom the periodFrom to set
     */
    public void setPeriodFrom(long periodFrom) {
        this.periodFrom = periodFrom;
    }

    /**
     * @return the periodTo
     */
    public long getPeriodTo() {
        return periodTo;
    }

    /**
     * @param periodTo the periodTo to set
     */
    public void setPeriodTo(long periodTo) {
        this.periodTo = periodTo;
    }
    
      /**
     * @return the arrCompany
     */
    public String[] getArrCompany(int idx) {
         if(idx>=arrCompany.size()){
            return null;
        }
        return (String[])arrCompany.get(idx); 
    }

    /**
     * @param arrCompany the arrCompany to set
     */
    public void addArrCompany(String[]  arrCompany) {
        this.arrCompany.add(arrCompany);
    }
    
    
       /**
     * @return the arrDivision
     */
    public String[] getArrDivision(int idx) {
         if(idx>=arrDivision.size()){
            return null;
        }
        return (String[])arrDivision.get(idx); 
    }

    /**
     * @param arrDivision the arrDivision to set
     */
    public void addArrDivision(String[]  arrDivision) {
        this.arrDivision.add(arrDivision);
    }
    
     /**
     * @return the arrDepartment
     */
    public String[] getArrDepartment(int idx) {
         if(idx>=arrDivision.size()){
            return null;
        }
        return (String[])arrDepartment.get(idx); 
    }

    /**
     * @param arrDepartment the arrDepartment to set
     */
    public void addArrDepartment(String[]  arrDepartment) {
        this.arrDepartment.add(arrDepartment);
    }
    
    
     /**
     * @return the arrSection
     */
    public String[] getArrSection(int idx) {
         if(idx>=arrSection.size()){
            return null;
        }
        return (String[])arrSection.get(idx); 
    }

    /**
     * @param arrSection the arrSection to set
     */
    public void addArrSection(String[]  arrSection) {
        this.arrSection.add(arrSection);
    }
    
      /**
     * @return the arrPosition
     */
    public String[] getArrPosition(int idx) {
         if(idx>=arrPosition.size()){
            return null;
        }
        return (String[])arrPosition.get(idx); 
    }

    /**
     * @param arrPosition the arrPosition to set
     */
    public void addArrPosition(String[]  arrPosition) {
        this.arrPosition.add(arrPosition);
    }    

    /**
     * @return the componentId
     */
    public long getComponentId() {
        return componentId;
    }

    /**
     * @param componentId the componentId to set
     */
    public void setComponentId(long componentId) {
        this.componentId = componentId;
    }

    /**
     * @return the statusResign
     */
    public int getStatusResign() {
        return statusResign;
    }

    /**
     * @param statusResign the statusResign to set
     */
    public void setStatusResign(int statusResign) {
        this.statusResign = statusResign;
    }

    /**
     * @return the compareCompId
     */
    public long getCompareCompId() {
        return compareCompId;
    }

    /**
     * @param compareCompId the compareCompId to set
     */
    public void setCompareCompId(long compareCompId) {
        this.compareCompId = compareCompId;
    }
    
    
      /**
     * @return the arrComponent
     */
    public String[] getArrComponent(int idx) {
         if(idx>=arrComponent.size()){
            return null;
        }
        return (String[])arrComponent.get(idx); 
    }

    /**
     * @param arrComponent the arrComponent to set
     */
    public void addArrComponent(String[]  arrComponent) {
        this.arrComponent.add(arrComponent);
    }    
       
}

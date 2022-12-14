/*
 * NightShiftDaily.java
 *
 * Created on June 1, 2004, 3:36 PM
 */

package com.dimata.harisma.session.lateness;

import java.util.Date;


/**
 *
 * @author  gede
 */
public class LatenessDaily {
    
    /** Holds value of property empNum. */
    private String empNum;    
    
    /** Holds value of property empName. */
    private String empName;
    
    /** Holds value of property schldSymbol. */
    private String schldSymbol;
    
    /** Holds value of property schldIn. */
    private Date schldIn;
    
    /** Holds value of property schldOut. */
    private Date schldOut;
    
    /** Holds value of property actualIn. */
    private Date actualIn;
    
    /** Holds value of property actualOut. */
    private Date actualOut;
    
    private Date actualInII;

    /** Holds value of property actualOut. */
    private Date actualOutII;
    private long schSymbolId;

    private int catType;
    private long depId;
    private int shiftIdI;
    private int shiftIdII;
    
    //update by satrya 2012-11-10
    private long empId;
    private Date selectedDate;

    public int getShiftIdI() {
        return this.shiftIdI;
    }
    public void setShiftIdI(int shiftIdI) {
        this.shiftIdI = shiftIdI;
    }

    public int getShiftIdII() {
        return this.shiftIdII;
    }
    public void setShiftIdII(int shiftIdII) {
        this.shiftIdII = shiftIdII;
    }

    public long getDepId() {
        return this.depId;
    }
    public void setDepId(long depId) {
        this.depId = depId;
    }

    public int getCatType() {
        return this.catType;
    }
    public void setCatType(int catType) {
        this.catType = catType;
    }

    public long getSchSymbolId() {
        return this.schSymbolId;
    }
    public void setSchSymbolId(long schSymbolId) {
        this.schSymbolId = schSymbolId;
    }


    public String getEmpNum() {
        return this.empNum;
    }
    public void setEmpNum(String empNum) {
        this.empNum = empNum;
    }
    
    public String getEmpName() {
        return this.empName;
    }
    public void setEmpName(String empName) {
        this.empName = empName;
    }
    
    public String getSchldSymbol() {
        return this.schldSymbol;
    }
    public void setSchldSymbol(String schldSymbol) {
        this.schldSymbol = schldSymbol;
    }
    
    public Date getSchldIn() {
        return this.schldIn;
    }
    public void setSchldIn(Date schldIn) {
        this.schldIn = schldIn;
    }

    public Date getSchldOut() {
        return this.schldOut;
    }
    public void setSchldOut(Date schldOut) {
        this.schldOut = schldOut;
    }

    public Date getActualIn() {
        return this.actualIn;
    }
    public void setActualIn(Date actualIn) {
        this.actualIn = actualIn;
    }
    
    public Date getActualInII() {
        return this.actualInII;
    }
    public void setActualInII(Date actualInII) {
        this.actualInII = actualInII;
    }

    public Date getActualOut() {
        return this.actualOut;
    }
    public void setActualOut(Date actualOut) {
        this.actualOut = actualOut;
    }

    public Date getActualOutII() {
        return this.actualOutII;
    }
    public void setActualOutII(Date actualOutII) {
        this.actualOutII = actualOutII;
    }

    /**
     * @return the empId
     */
    public long getEmpId() {
        return empId;
    }

    /**
     * @param empId the empId to set
     */
    public void setEmpId(long empId) {
        this.empId = empId;
    }

    /**
     * @return the selectedDate
     */
    public Date getSelectedDate() {
        return selectedDate;
    }

    /**
     * @param selectedDate the selectedDate to set
     */
    public void setSelectedDate(Date selectedDate) {
        this.selectedDate = selectedDate;
    }
}

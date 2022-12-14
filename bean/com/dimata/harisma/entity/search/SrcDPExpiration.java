/*

 * SrcLeaveDP.java

 *

 * Created on September 8, 2004, 9:36 AM

 */


package com.dimata.harisma.entity.search;



// import package core java

import java.util.Date;



/**

 *

 * @author  gedhy

 */

public class SrcDPExpiration

{

    

    /** Holds value of property empNum. */

    private String empNum = "";

    

    /** Holds value of property empName. */

    private String empName =  "";

    

    /** Holds value of property empCatId. */

    private long empCatId = 0;

    

    /** Holds value of property empDeptId. */

    private long empDeptId = 0;

    

    /** Holds value of property empSectionId. */

    private long empSectionId = 0;

    

    /** Holds value of property empPosId. */

    private long empPosId = 0;

    

    /** Holds value of property leavePeriod. */

    private Date leavePeriod;

    

    /** Holds value of property periodChecked. */

    private boolean periodChecked = true;

    

     /** Holds value of property periodChecked. */

    private long empLevelId = 0;

    

    //add by artha

    private long periodId = 0;

    

    private int expirationPeriod = 0;



    private Date startDate;

    

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public int getExpirationPeriod() {

        return expirationPeriod;

    }



    public void setExpirationPeriod(int expirationPeriod) {

        this.expirationPeriod = expirationPeriod;

    }

    

    /** Creates a new instance of SrcLeaveDP */

    public SrcDPExpiration() {

    }



    public long getPeriodId() {

        return periodId;

    }



    public void setPeriodId(long periodId) {

        this.periodId = periodId;

    }

    

    /** Getter for property empNum.

     * @return Value of property empNum.

     *

     */

    public String getEmpNum() {

        return this.empNum;

    }

    

    /** Setter for property empNum.

     * @param empNum New value of property empNum.

     *

     */

    public void setEmpNum(String empNum) {

        this.empNum = empNum;

    }

    

    /** Getter for property empName.

     * @return Value of property empName.

     *

     */

    public String getEmpName() {

        return this.empName;

    }

    

    /** Setter for property empName.

     * @param empName New value of property empName.

     *

     */

    public void setEmpName(String empName) {

        this.empName = empName;

    }

    

    /** Getter for property empCatId.

     * @return Value of property empCatId.

     *

     */

    public long getEmpCatId() {

        return this.empCatId;

    }

    

    /** Setter for property empCatId.

     * @param empCatId New value of property empCatId.

     *

     */

    public void setEmpCatId(long empCatId) {

        this.empCatId = empCatId;

    }

    

    /** Getter for property empDeptId.

     * @return Value of property empDeptId.

     *

     */

    public long getEmpDeptId() {

        return this.empDeptId;

    }

    

    /** Setter for property empDeptId.

     * @param empDeptId New value of property empDeptId.

     *

     */

    public void setEmpDeptId(long empDeptId) {

        this.empDeptId = empDeptId;

    }

    

    /** Getter for property empSectionId.

     * @return Value of property empSectionId.

     *

     */

    public long getEmpSectionId() {

        return this.empSectionId;

    }

    

    /** Setter for property empSectionId.

     * @param empSectionId New value of property empSectionId.

     *srcLeaveDP.getEmpDeptId()

     */

    public void setEmpSectionId(long empSectionId) {

        this.empSectionId = empSectionId;

    }

    

    /** Getter for property empPosId.

     * @return Value of property empPosId.

     *

     */

    public long getEmpPosId() {

        return this.empPosId;

    }

    

    /** Setter for property empPosId.

     * @param empPosId New value of property empPosId.

     *

     */

    public void setEmpPosId(long empPosId) {

        this.empPosId = empPosId;

    }

    

    /** Getter for property dpPeriod.

     * @return Value of property dpPeriod.

     *

     */

    public Date getLeavePeriod() {

        return this.leavePeriod;

    }

    

    /** Setter for property dpPeriod.

     * @param dpPeriod New value of property dpPeriod.

     *

     */

    public void setLeavePeriod(Date leavePeriod) {

        this.leavePeriod = leavePeriod;

    }

    

    /** Getter for property periodChecked.

     * @return Value of property periodChecked.

     *

     */

    public boolean isPeriodChecked() {

        return this.periodChecked;

    }

    

    /** Setter for property periodChecked.

     * @param periodChecked New value of property periodChecked.

     *

     */

    public void setPeriodChecked(boolean periodChecked) {

        this.periodChecked = periodChecked;

    }

    

    /**

     * Getter for property empLevelId.

     * @return Value of property empLevelId.

     */

    public long getEmpLevelId() {

        return empLevelId;

    }

    

    /**

     * Setter for property empLevelId.

     * @param empLevelId New value of property empLevelId.

     */

    public void setEmpLevelId(long empLevelId) {

        this.empLevelId = empLevelId;

    }

    

}


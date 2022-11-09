
/* Created on 	:  [date] [time] AM/PM 
 * 
 * @author  	:  [authorName] 
 * @version  	:  [version] 
 */
/**
 * *****************************************************************
 * Class Description : [project description ... ] Imput Parameters : [input
 * parameter ...] Output : [output ...] 
 ******************************************************************
 */
package com.dimata.harisma.entity.masterdata; 
 
/* package java */ 
import java.util.Date;

/* package qdep */
import com.dimata.qdep.entity.*;

public class Section extends Entity { 

    private long departmentId;
	private String section = "";
	private String description = "";
    /* Add Field By Hendra Putu | 2015-02-20*/
    private String sectionLinkTo = "";
    private int validStatus = 0;
    private Date validStart = null;
    private Date validEnd = null;
    /*add by Eri Yudi 2021-07-31 untuk mapping kompetensi berdasarkan kelas sub unit*/
    private int levelSection = 0;
    
    public String getSection() {
		return section; 
	} 

    public void setSection(String section) {
        if (section == null) {
			section = ""; 
		} 
		this.section = section; 
	}

    public long getDepartmentId() {
		return departmentId;
	} 

    public void setDepartmentId(long departmentId) {
		this.departmentId = departmentId;
	}

    public String getDescription() {
		return description; 
	} 

    public void setDescription(String description) {
        if (description == null) {
			description = ""; 
		} 
		this.description = description; 
	} 

    /**
     * @return the sectionLinkTo
     */
    public String getSectionLinkTo() {
        return sectionLinkTo;
}

    /**
     * @param sectionLinkTo the sectionLinkTo to set
     */
    public void setSectionLinkTo(String sectionLinkTo) {
        this.sectionLinkTo = sectionLinkTo;
    }

    /**
     * @return the validStatus
     */
    public int getValidStatus() {
        return validStatus;
    }

    /**
     * @param validStatus the validStatus to set
     */
    public void setValidStatus(int validStatus) {
        this.validStatus = validStatus;
    }

    /**
     * @return the validStart
     */
    public Date getValidStart() {
        return validStart;
    }

    /**
     * @param validStart the validStart to set
     */
    public void setValidStart(Date validStart) {
        this.validStart = validStart;
    }

    /**
     * @return the validEnd
     */
    public Date getValidEnd() {
        return validEnd;
    }

    /**
     * @param validEnd the validEnd to set
     */
    public void setValidEnd(Date validEnd) {
        this.validEnd = validEnd;
    }
    
        /**
     * @return the levelSection
     */
    public int getLevelSection() {
        return levelSection;
    }

    /**
     * @param levelSection the levelSection to set
     */
    public void setLevelSection(int levelSection) {
        this.levelSection = levelSection;
    }

}

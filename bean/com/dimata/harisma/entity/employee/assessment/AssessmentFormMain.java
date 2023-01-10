/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.dimata.harisma.entity.employee.assessment;

import com.dimata.qdep.entity.Entity;

/**
 *
 * @author Artha
 */
public class AssessmentFormMain extends Entity{
    private String title;
    private String subtitle;
    private String title_L2;
    private String subtitle_L2;
    private String mainData;
    private String note;
    private long groupRankId;
    private int periodeAppraisalMonth;
    // private long formMainIdGroup;
     
    private String[] sGroupRankId;
    private String[] sAssFormMainid;

    public long getGroupRankId() {
        return groupRankId;
    }

    public void setGroupRankId(long groupRankId) {
        this.groupRankId = groupRankId;
    }
    
    public String getMainData() {
        return mainData;
    }

    public void setMainData(String mainData) {
        this.mainData = mainData;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public String getSubtitle() {
        return subtitle;
    }

    public void setSubtitle(String subtitle) {
        this.subtitle = subtitle;
    }

    public String getSubtitle_L2() {
        return subtitle_L2;
    }

    public void setSubtitle_L2(String subtitle_L2) {
        this.subtitle_L2 = subtitle_L2;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getTitle_L2() {
        return title_L2;
    }

    public void setTitle_L2(String title_L2) {
        this.title_L2 = title_L2;
    }

    /**
     * @return the sGroupRankId
     */
    public String[] getsGroupRankId() {
        return sGroupRankId;
    }

    /**
     * @param sGroupRankId the sGroupRankId to set
     */
    public void setsGroupRankId(String[] sGroupRankId) {
        this.sGroupRankId = sGroupRankId;
    }
   
    public String[] getsAssFormMainId() {
        return sAssFormMainid;
    }

    /**
     * @param sGroupRankId the sGroupRankId to set
     */
    public void setsAssFormMainId(String[] sAssFormMainid) {
        this.sAssFormMainid = sAssFormMainid;
    }
    
    public int getPeriodeAppraisalMonth() {
        return periodeAppraisalMonth;
    }

    /**
     * @param sGroupRankId the sGroupRankId to set
     */
    public void setPeriodeAppraisalMonth(int periodeAppraisalMonth) {
        this.periodeAppraisalMonth = periodeAppraisalMonth;
    }
    
}

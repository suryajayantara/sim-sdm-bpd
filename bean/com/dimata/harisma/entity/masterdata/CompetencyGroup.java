/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.masterdata;

import com.dimata.qdep.entity.Entity;

/**
 *
 * @author Dimata 007
 */
public class CompetencyGroup extends Entity {
    private String groupName = "";
    private String note = "";
    private long competencyTypeId = 0;

    /**
     * @return the groupName
     */
    public String getGroupName() {
        return groupName;
    }

    /**
     * @param groupName the groupName to set
     */
    public void setGroupName(String groupName) {
        this.groupName = groupName;
    }

    /**
     * @return the note
     */
    public String getNote() {
        return note;
    }

    /**
     * @param note the note to set
     */
    public void setNote(String note) {
        this.note = note;
    }

    /**
     * @return the competencyTypeId
     */
    public long getCompetencyTypeId() {
        return competencyTypeId;
    }

    /**
     * @param competencyTypeId the competencyTypeId to set
     */
    public void setCompetencyTypeId(long competencyTypeId) {
        this.competencyTypeId = competencyTypeId;
    }
}

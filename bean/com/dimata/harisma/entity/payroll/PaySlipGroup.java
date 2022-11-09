/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.payroll;

import com.dimata.qdep.entity.Entity;

/**
 *
 * @author Satrya Ramayu
 */
public class PaySlipGroup extends Entity{
    private String groupName;
    private String groupDesc;
    private int showAll;

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
     * @return the groupDesc
     */
    public String getGroupDesc() {
        return groupDesc;
    }

    /**
     * @param groupDesc the groupDesc to set
     */
    public void setGroupDesc(String groupDesc) {
        this.groupDesc = groupDesc;
    }

    /**
     * @return the showAll
     */
    public int getShowAll() {
        return showAll;
    }

    /**
     * @param showAll the showAll to set
     */
    public void setShowAll(int showAll) {
        this.showAll = showAll;
    }
    
}

/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.masterdata;

/**
 *
 * @author User
 */
import com.dimata.qdep.entity.Entity;

public class PositionLevel  extends Entity{
    
    private long levelId = 0;
    private long positionId = 0;

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

    /**
     * @return the levelId
     */
    public long getLevelId() {
        return levelId;
    }

    /**
     * @param levelId the levelId to set
     */
    public void setLevelId(long levelId) {
        this.levelId = levelId;
    }
}

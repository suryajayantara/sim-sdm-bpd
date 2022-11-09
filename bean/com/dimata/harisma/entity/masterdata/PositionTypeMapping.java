/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.masterdata;

import com.dimata.qdep.entity.Entity;

/**
 *
 * @author gndiw
 */
public class PositionTypeMapping extends Entity {

    private long levelId = 0;
    private long positionTypeId = 0;

    public long getPositionTypeId() {
        return positionTypeId;
    }

    public void setPositionTypeId(long positionTypeId) {
        this.positionTypeId = positionTypeId;
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
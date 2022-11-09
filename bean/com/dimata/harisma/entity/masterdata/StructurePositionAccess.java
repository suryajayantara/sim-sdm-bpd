/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package com.dimata.harisma.entity.masterdata;

/* package qdep */
import com.dimata.qdep.entity.*;

/**
 *
 * @author dimata005
 */
public class StructurePositionAccess extends Entity {
    private long templateId = 0;
    private long positionId = 0;

    /**
     * @return the templateId
     */
    public long getTemplateId() {
        return templateId;
    }

    /**
     * @param templateId the templateId to set
     */
    public void setTemplateId(long templateId) {
        this.templateId = templateId;
    }

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
}

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.masterdata;

/**
 *
 * @author Acer
 */

/* package qdep */
import com.dimata.qdep.entity.*;

public class OutSourceIndicator extends Entity {
    
    private String indicatorName = "";

    /**
     * @return the indicatorName
     */
    public String getIndicatorName() {
        return indicatorName;
    }

    /**
     * @param indicatorName the indicatorName to set
     */
    public void setIndicatorName(String indicatorName) {
        this.indicatorName = indicatorName;
    }
    
}

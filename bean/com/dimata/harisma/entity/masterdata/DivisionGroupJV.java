/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.masterdata;

/**
 *
 * @author gndiw
 */

import com.dimata.qdep.entity.Entity;

public class DivisionGroupJV extends Entity {
    
    private String divisionGroupCode = "";

    /**
     * @return the divisionGroup
     */
    public String getDivisionGroupCode() {
        return divisionGroupCode;
    }

    /**
     * @param divisionGroup the divisionGroup to set
     */
    public void setDivisionGroup(String divisionGroupCode) {
        this.divisionGroupCode = divisionGroupCode;
    }
    
}

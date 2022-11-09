/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.employee;

import com.dimata.qdep.entity.Entity;

/**
 *
 * @author gndiw
 */
public class EmpPowerCharacter extends Entity {

    private long powerCharacterId = 0;
    private long employeeId = 0;
    private int index = 0;
    private long secondCharacterId = 0;

    public long getPowerCharacterId() {
        return powerCharacterId;
    }

    public void setPowerCharacterId(long powerCharacterId) {
        this.powerCharacterId = powerCharacterId;
    }

    public long getEmployeeId() {
        return employeeId;
    }

    public void setEmployeeId(long employeeId) {
        this.employeeId = employeeId;
    }

    public int getIndex() {
        return index;
    }

    public void setIndex(int index) {
        this.index = index;
    }

    /**
     * @return the secondCharacterId
     */
    public long getSecondCharacterId() {
        return secondCharacterId;
    }

    /**
     * @param secondCharacterId the secondCharacterId to set
     */
    public void setSecondCharacterId(long secondCharacterId) {
        this.secondCharacterId = secondCharacterId;
    }

}
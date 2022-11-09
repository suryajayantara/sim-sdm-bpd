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
public class CandidatePositionPower extends Entity {

    private long candidateMainId = 0;
    private long positionId = 0;
    private long firstPowerCharacterId = 0;
    private long secondPowerCharacterId = 0;

    public long getCandidateMainId() {
        return candidateMainId;
    }

    public void setCandidateMainId(long candidateMainId) {
        this.candidateMainId = candidateMainId;
    }

    public long getPositionId() {
        return positionId;
    }

    public void setPositionId(long positionId) {
        this.positionId = positionId;
    }

    public long getFirstPowerCharacterId() {
        return firstPowerCharacterId;
    }

    public void setFirstPowerCharacterId(long firstPowerCharacterId) {
        this.firstPowerCharacterId = firstPowerCharacterId;
    }

    public long getSecondPowerCharacterId() {
        return secondPowerCharacterId;
    }

    public void setSecondPowerCharacterId(long secondPowerCharacterId) {
        this.secondPowerCharacterId = secondPowerCharacterId;
    }

}
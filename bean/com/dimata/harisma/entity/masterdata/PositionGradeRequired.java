/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.masterdata;

import com.dimata.qdep.entity.Entity;

/**
 *
 * @author Kartika
 */
public class PositionGradeRequired extends Entity {
    private long positionId;
    private GradeLevel gradeMinimum; // only to view complete
    private GradeLevel gradeMaximum; // only to view complete
    private String note="";
    

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
     * @return the gradeMinimum
     */
    public GradeLevel getGradeMinimum() {
        return gradeMinimum;
    }

    /**
     * @param gradeMinimum the gradeMinimum to set
     */
    public void setGradeMinimum(GradeLevel gradeMinimum) {
        this.gradeMinimum = gradeMinimum;
    }

    /**
     * @return the gradeMaximum
     */
    public GradeLevel getGradeMaximum() {
        return gradeMaximum;
    }

    /**
     * @param gradeMaximum the gradeMaximum to set
     */
    public void setGradeMaximum(GradeLevel gradeMaximum) {
        this.gradeMaximum = gradeMaximum;
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
}

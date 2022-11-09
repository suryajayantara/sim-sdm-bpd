/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.employee;

import com.dimata.harisma.entity.masterdata.*;
import com.dimata.qdep.entity.Entity;

/**
 *
 * @author Kartika
 */
public class CandidateGradeRequired extends Entity {
    private long candidateMainId =0;
    private GradeLevel gradeMinimum; // only to view complete
    private GradeLevel gradeMaximum; // only to view complete
    private long positionId =0;
    private int kondisi = 0;

  

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
     * @return the candidateMainId
     */
    public long getCandidateMainId() {
        return candidateMainId;
    }

    /**
     * @param candidateMainId the candidateMainId to set
     */
    public void setCandidateMainId(long candidateMainId) {
        this.candidateMainId = candidateMainId;
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

    /**
     * @return the kondisi
     */
    public int getKondisi() {
        return kondisi;
    }

    /**
     * @param kondisi the kondisi to set
     */
    public void setKondisi(int kondisi) {
        this.kondisi = kondisi;
    }


}

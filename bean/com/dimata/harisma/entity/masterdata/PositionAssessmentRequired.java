/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.masterdata;

import com.dimata.qdep.entity.Entity;
import java.util.Date;

/**
 *
 * @author gndiw
 */
public class PositionAssessmentRequired extends Entity {
    private long positionId = 0;
    private long assessmentId = 0;
    private float scoreReqMin = 0;
    private float scoreReqRecommended = 0;
    private String note = "";
    private int reTrainOrSertfcReq = 0;
    private Date validStart = new Date();
    private Date validEnd = new Date();

    /**
     * @return the assessmentId
     */
    public long getAssessmentId() {
        return assessmentId;
    }

    /**
     * @param competencyId the competencyId to set
     */
    public void setAssessmentId(long assessmentId) {
        this.assessmentId = assessmentId;
    }

    /**
     * @return the scoreReqMin
     */
    public float getScoreReqMin() {
        return scoreReqMin;
    }

    /**
     * @param scoreReqMin the scoreReqMin to set
     */
    public void setScoreReqMin(float scoreReqMin) {
        this.scoreReqMin = scoreReqMin;
    }

    /**
     * @return the scoreReqRecommended
     */
    public float getScoreReqRecommended() {
        return scoreReqRecommended;
    }

    /**
     * @param scoreReqRecommended the scoreReqRecommended to set
     */
    public void setScoreReqRecommended(float scoreReqRecommended) {
        this.scoreReqRecommended = scoreReqRecommended;
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
     * @return the reTrainOrSertfcReq
     */
    public int getReTrainOrSertfcReq() {
        return reTrainOrSertfcReq;
    }

    /**
     * @param reTrainOrSertfcReq the reTrainOrSertfcReq to set
     */
    public void setReTrainOrSertfcReq(int reTrainOrSertfcReq) {
        this.reTrainOrSertfcReq = reTrainOrSertfcReq;
    }

    /**
     * @return the validStart
     */
    public Date getValidStart() {
        return validStart;
    }

    /**
     * @param validStart the validStart to set
     */
    public void setValidStart(Date validStart) {
        this.validStart = validStart;
    }

    /**
     * @return the validEnd
     */
    public Date getValidEnd() {
        return validEnd;
    }

    /**
     * @param validEnd the validEnd to set
     */
    public void setValidEnd(Date validEnd) {
        this.validEnd = validEnd;
    }
}

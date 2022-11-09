/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.masterdata;
import com.dimata.qdep.entity.Entity;
/**
 *
 * @author IanRizky
 */
public class KpiListPosition extends Entity{
	private long kpiId = 0 ;
	private long positionId = 0 ;

	/**
	 * @return the kpiId
	 */
	public long getKpiId() {
		return kpiId;
	}

	/**
	 * @param kpiId the kpiId to set
	 */
	public void setKpiId(long kpiId) {
		this.kpiId = kpiId;
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

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
public class DocMasterSign extends Entity {
	
	private long docMasterSignId; 
	private long docMasterId ;
	private int signIndex ;
	private long positionId ;
	private long employeeId ;
	private long signForDivisionId ;

	/**
	 * @return the docMasterSignId
	 */
	public long getDocMasterSignId() {
		return docMasterSignId;
	}

	/**
	 * @param docMasterSignId the docMasterSignId to set
	 */
	public void setDocMasterSignId(long docMasterSignId) {
		this.docMasterSignId = docMasterSignId;
	}

	/**
	 * @return the docMasterId
	 */
	public long getDocMasterId() {
		return docMasterId;
	}

	/**
	 * @param docMasterId the docMasterId to set
	 */
	public void setDocMasterId(long docMasterId) {
		this.docMasterId = docMasterId;
	}

	/**
	 * @return the signIndex
	 */
	public int getSignIndex() {
		return signIndex;
	}

	/**
	 * @param signIndex the signIndex to set
	 */
	public void setSignIndex(int signIndex) {
		this.signIndex = signIndex;
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
	 * @return the employeeId
	 */
	public long getEmployeeId() {
		return employeeId;
	}

	/**
	 * @param employeeId the employeeId to set
	 */
	public void setEmployeeId(long employeeId) {
		this.employeeId = employeeId;
	}

	/**
	 * @return the signForDivisionId
	 */
	public long getSignForDivisionId() {
		return signForDivisionId;
	}

	/**
	 * @param signForDivisionId the signForDivisionId to set
	 */
	public void setSignForDivisionId(long signForDivisionId) {
		this.signForDivisionId = signForDivisionId;
	}
	
}

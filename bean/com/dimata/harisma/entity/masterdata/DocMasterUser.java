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
public class DocMasterUser extends Entity {
	
	private long docMasterId = 0;
	private long userId = 0;

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
	 * @return the userId
	 */
	public long getUserId() {
		return userId;
	}

	/**
	 * @param userId the userId to set
	 */
	public void setUserId(long userId) {
		this.userId = userId;
	}
	
}

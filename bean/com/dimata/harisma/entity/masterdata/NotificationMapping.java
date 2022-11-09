/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.masterdata;

/**
 *
 * @author Utk
 */
import com.dimata.qdep.entity.Entity;

public class NotificationMapping extends Entity {

private long notificationId = 0;
private long userId = 0;

public long getNotificationId(){
return notificationId;
}

public void setNotificationId(long notificationId){
this.notificationId = notificationId;
}

public long getUserId(){
return userId;
}

public void setUserId(long userId){
this.userId = userId;
}

}
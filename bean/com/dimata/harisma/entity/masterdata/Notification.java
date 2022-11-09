/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.masterdata;

import com.dimata.qdep.entity.Entity;

public class Notification extends Entity {

private long notificationId = 0;
private int notificationType = 0;
private int notificationDays = 0;
private int notificationStatus = 0;
private int specialCase = 0;

public long getNotificationId(){
return notificationId;
}

public void setNotificationId(long notificationId){
this.notificationId = notificationId;
}

public int getNotificationType(){
return notificationType;
}

public void setNotificationType(int notificationType){
this.notificationType = notificationType;
}

public int getNotificationDays(){
return notificationDays;
}

public void setNotificationDays(int notificationDays){
this.notificationDays = notificationDays;
}

public int getNotificationStatus(){
return notificationStatus;
}

public void setNotificationStatus(int notificationStatus){
this.notificationStatus = notificationStatus;
}

    /**
     * @return the specialCase
     */
    public int getSpecialCase() {
        return specialCase;
    }

    /**
     * @param specialCase the specialCase to set
     */
    public void setSpecialCase(int specialCase) {
        this.specialCase = specialCase;
    }

}
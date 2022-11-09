/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.form.masterdata;

import com.dimata.harisma.entity.masterdata.Notification;
import com.dimata.qdep.form.FRMHandler;
import com.dimata.qdep.form.I_FRMInterface;
import com.dimata.qdep.form.I_FRMType;
import javax.servlet.http.HttpServletRequest;

public class FrmNotification extends FRMHandler implements I_FRMInterface, I_FRMType {
  private Notification entNotification;
  public static final String FRM_NAME_NOTIFICATION = "FRM_NOTIFICATION";
  public static final int FRM_FIELD_NOTIFICATION_ID = 0;
  public static final int FRM_FIELD_NOTIFICATION_TYPE = 1;
  public static final int FRM_FIELD_NOTIFICATION_DAYS = 2;
  public static final int FRM_FIELD_NOTIFICATION_STATUS = 3;
  public static final int FRM_FIELD_SPECIAL_CASE = 4;
  

public static String[] fieldNames = {
    "FRM_FIELD_NOTIFICATION_ID",
    "FRM_FIELD_NOTIFICATION_TYPE",
    "FRM_FIELD_NOTIFICATION_DAYS",
    "FRM_FIELD_NOTIFICATION_STATUS",
    "FRM_FIELD_SPECIAL_CASE"
};

public static int[] fieldTypes = {
    TYPE_LONG,
    TYPE_INT,
    TYPE_INT,
    TYPE_INT,
    TYPE_INT
};

public FrmNotification() {
}

public FrmNotification(Notification entNotification) {
   this.entNotification = entNotification;
}

public FrmNotification(HttpServletRequest request, Notification entNotification) {
   super(new FrmNotification(entNotification), request);
   this.entNotification = entNotification;
}

public String getFormName() {
   return FRM_NAME_NOTIFICATION;
}

public int[] getFieldTypes() {
   return fieldTypes;
}

public String[] getFieldNames() {
   return fieldNames;
}

public int getFieldSize() {
   return fieldNames.length;
}

public Notification getEntityObject() {
   return entNotification;
}

public void requestEntityObject(Notification entNotification) {
   try {
        this.requestParam();
        entNotification.setNotificationId(getLong(FRM_FIELD_NOTIFICATION_ID));
        entNotification.setNotificationType(getInt(FRM_FIELD_NOTIFICATION_TYPE));
        entNotification.setNotificationDays(getInt(FRM_FIELD_NOTIFICATION_DAYS));
        entNotification.setNotificationStatus(getInt(FRM_FIELD_NOTIFICATION_STATUS));
        entNotification.setSpecialCase(getInt(FRM_FIELD_SPECIAL_CASE));
   } catch (Exception e) {
        System.out.println("Error on requestEntityObject : " + e.toString());
   }
}

}
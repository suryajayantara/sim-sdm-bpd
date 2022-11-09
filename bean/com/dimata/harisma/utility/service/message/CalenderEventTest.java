/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.utility.service.message;

/**
 *
 * @author Gunadi
 */
import java.util.ArrayList;
import java.util.Date;

import com.google.api.client.util.DateTime;
import com.google.api.services.calendar.Calendar;
import com.google.api.services.calendar.model.Event;
import com.google.api.services.calendar.model.EventAttendee;
import com.google.api.services.calendar.model.EventDateTime;
import java.io.IOException;
public class CalenderEventTest {

    public static void testSend() throws IOException{
        // TODO Auto-generated method stub
        Event event = new Event();
        Calendar service =null;

        event.setSummary("Calendar Testing");
        event.setLocation("US");
        event.setDescription("Desired description");

        ArrayList<EventAttendee> attendees = new ArrayList<EventAttendee>();
        EventAttendee evAttende = new EventAttendee();
        attendees.add(new EventAttendee().setEmail("gunadiwirawan94@gmail.com"));
        // ...
        event.setAttendees(attendees);


        // set the number of days
        java.util.Calendar startCal = java.util.Calendar.getInstance();
        startCal.set(java.util.Calendar.MONTH, 1);
        startCal.set(java.util.Calendar.DATE, 6);
        startCal.set(java.util.Calendar.HOUR_OF_DAY, 9);
        startCal.set(java.util.Calendar.MINUTE, 0);
        Date startDate = startCal.getTime();

        java.util.Calendar endCal = java.util.Calendar.getInstance();
        endCal.set(java.util.Calendar.MONTH, 1);
        endCal.set(java.util.Calendar.DATE, 6);
        endCal.set(java.util.Calendar.HOUR_OF_DAY, 18);
        endCal.set(java.util.Calendar.MINUTE, 0);
        Date endDate = endCal.getTime();


        DateTime start = new DateTime(startDate);
        event.setStart(new EventDateTime().setDateTime(start));
        DateTime end = new DateTime(endDate);
        event.setEnd(new EventDateTime().setDateTime(end));
        event.setLocation("Dimata");

        service = new GoogleService().configure();
        Event createdEvent = service.events().insert("primary", event).execute();

        System.out.println("Data is :"+createdEvent.getId()); 
    }
}  
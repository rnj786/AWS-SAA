package com.example.eventsrsvp.model;

import java.time.LocalDate;

import com.fasterxml.jackson.annotation.JsonFormat;

import software.amazon.awssdk.enhanced.dynamodb.mapper.annotations.DynamoDbBean;
import software.amazon.awssdk.enhanced.dynamodb.mapper.annotations.DynamoDbPartitionKey;

@DynamoDbBean
public class EventsRSVP {
    private String eventId;
    private String eventName;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate eventDate;
    private String rsvpEmail;
    private int headcount;
    private String dietaryRestrictions;

    public EventsRSVP() {}

    @DynamoDbPartitionKey
    public String getEventId() { return eventId; }
    public void setEventId(String eventId) { this.eventId = eventId; }
    public String getEventName() { return eventName; }
    public void setEventName(String eventName) { this.eventName = eventName; }
    public LocalDate getEventDate() { return eventDate; }
    public void setEventDate(LocalDate eventDate) { this.eventDate = eventDate; }
    public String getRsvpEmail() { return rsvpEmail; }
    public void setRsvpEmail(String rsvpEmail) { this.rsvpEmail = rsvpEmail; }
    public int getHeadcount() { return headcount; }
    public void setHeadcount(int headcount) { this.headcount = headcount; }
    public String getDietaryRestrictions() { return dietaryRestrictions; }
    public void setDietaryRestrictions(String dietaryRestrictions) { this.dietaryRestrictions = dietaryRestrictions; }
}

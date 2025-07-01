package com.example.eventsrsvp.repository;

import com.example.eventsrsvp.model.EventsRSVP;
import java.util.List;

public interface EventsRSVPRepository {
    EventsRSVP save(EventsRSVP event);
    EventsRSVP findById(String eventId);
    List<EventsRSVP> findAll();
    EventsRSVP update(EventsRSVP event);
    void deleteById(String eventId);
}

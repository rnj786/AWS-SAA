package com.example.eventsrsvp.service;

import com.example.eventsrsvp.model.EventsRSVP;
import com.example.eventsrsvp.repository.EventsRSVPRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class EventsRSVPService {
    @Autowired
    private EventsRSVPRepository repository;

    public EventsRSVP createEvent(EventsRSVP event) {
        return repository.save(event);
    }
    public EventsRSVP getEvent(String eventId) {
        return repository.findById(eventId);
    }
    public List<EventsRSVP> getAllEvents() {
        return repository.findAll();
    }
    public EventsRSVP updateEvent(EventsRSVP event) {
        return repository.update(event);
    }
    public void deleteEvent(String eventId) {
        repository.deleteById(eventId);
    }
}

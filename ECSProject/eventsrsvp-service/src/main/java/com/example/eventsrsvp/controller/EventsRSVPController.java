package com.example.eventsrsvp.controller;

import com.example.eventsrsvp.model.EventsRSVP;
import com.example.eventsrsvp.service.EventsRSVPService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/events")
public class EventsRSVPController {
    @Autowired
    private EventsRSVPService service;

    @PostMapping
    public ResponseEntity<EventsRSVP> createEvent(@RequestBody EventsRSVP event) {
        return ResponseEntity.ok(service.createEvent(event));
    }

    @GetMapping("/{id}")
    public ResponseEntity<EventsRSVP> getEvent(@PathVariable String id) {
        return ResponseEntity.ok(service.getEvent(id));
    }

    @GetMapping
    public ResponseEntity<List<EventsRSVP>> getAllEvents() {
        return ResponseEntity.ok(service.getAllEvents());
    }

    @PutMapping
    public ResponseEntity<EventsRSVP> updateEvent(@RequestBody EventsRSVP event) {
        return ResponseEntity.ok(service.updateEvent(event));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteEvent(@PathVariable String id) {
        service.deleteEvent(id);
        return ResponseEntity.noContent().build();
    }
}

package com.example.eventsrsvp.controller;

import com.example.eventsrsvp.model.EventsRSVP;
import com.example.eventsrsvp.service.EventsRSVPService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import java.time.LocalDate;
import java.util.Arrays;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;
import static org.hamcrest.Matchers.*;

@WebMvcTest(EventsRSVPController.class)
public class EventsRSVPControllerTest {
    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private EventsRSVPService service;

    private EventsRSVP sampleEvent;

    @BeforeEach
    void setup() {
        sampleEvent = new EventsRSVP();
        sampleEvent.setEventId("test-event-001");
        sampleEvent.setEventName("Test Event");
        sampleEvent.setEventDate(LocalDate.parse("2025-07-01"));
        sampleEvent.setRsvpEmail("testuser@example.com");
        sampleEvent.setHeadcount(3);
        sampleEvent.setDietaryRestrictions("Vegetarian");
    }

    @Test
    void testCreateEvent() throws Exception {
        Mockito.when(service.createEvent(any(EventsRSVP.class))).thenReturn(sampleEvent);
        String json = """
        {
          \"eventId\": \"test-event-001\",
          \"eventName\": \"Test Event\",
          \"eventDate\": \"2025-07-01\",
          \"rsvpEmail\": \"testuser@example.com\",
          \"headcount\": 3,
          \"dietaryRestrictions\": \"Vegetarian\"
        }
        """;
        mockMvc.perform(post("/api/events")
                .contentType(MediaType.APPLICATION_JSON)
                .content(json))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.eventId", is("test-event-001")))
                .andExpect(jsonPath("$.eventName", is("Test Event")));
    }

    @Test
    void testGetEventById() throws Exception {
        Mockito.when(service.getEvent(eq("test-event-001"))).thenReturn(sampleEvent);
        mockMvc.perform(get("/api/events/test-event-001"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.eventId", is("test-event-001")));
    }

    @Test
    void testGetAllEvents() throws Exception {
        Mockito.when(service.getAllEvents()).thenReturn(Arrays.asList(sampleEvent));
        mockMvc.perform(get("/api/events"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$[0].eventId", is("test-event-001")));
    }

    @Test
    void testUpdateEvent() throws Exception {
        Mockito.when(service.updateEvent(any(EventsRSVP.class))).thenReturn(sampleEvent);
        String json = """
        {
          \"eventId\": \"test-event-001\",
          \"eventName\": \"Test Event\",
          \"eventDate\": \"2025-07-01\",
          \"rsvpEmail\": \"testuser@example.com\",
          \"headcount\": 3,
          \"dietaryRestrictions\": \"Vegetarian\"
        }
        """;
        mockMvc.perform(put("/api/events")
                .contentType(MediaType.APPLICATION_JSON)
                .content(json))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.eventId", is("test-event-001")));
    }

    @Test
    void testDeleteEvent() throws Exception {
        Mockito.doNothing().when(service).deleteEvent(eq("test-event-001"));
        mockMvc.perform(delete("/api/events/test-event-001"))
                .andExpect(status().isNoContent());
    }
}

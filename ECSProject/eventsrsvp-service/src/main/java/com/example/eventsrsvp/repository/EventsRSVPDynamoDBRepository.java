package com.example.eventsrsvp.repository;

import com.example.eventsrsvp.model.EventsRSVP;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Repository;
import software.amazon.awssdk.enhanced.dynamodb.DynamoDbEnhancedClient;
import software.amazon.awssdk.enhanced.dynamodb.DynamoDbTable;
import software.amazon.awssdk.enhanced.dynamodb.TableSchema;
import software.amazon.awssdk.services.dynamodb.DynamoDbClient;
import software.amazon.awssdk.services.dynamodb.model.DynamoDbException;
import jakarta.annotation.PostConstruct;
import java.util.ArrayList;
import java.util.List;

@Repository
public class EventsRSVPDynamoDBRepository implements EventsRSVPRepository {
    private final DynamoDbEnhancedClient enhancedClient;
    private DynamoDbTable<EventsRSVP> table;

    @Value("${aws.dynamodb.table}")
    private String tableName;

    public EventsRSVPDynamoDBRepository() {
        this.enhancedClient = DynamoDbEnhancedClient.builder()
                .dynamoDbClient(DynamoDbClient.create())
                .build();
    }

    @PostConstruct
    public void init() {
        this.table = enhancedClient.table(tableName, TableSchema.fromBean(EventsRSVP.class));
    }

    @Override
    public EventsRSVP save(EventsRSVP event) {
        table.putItem(event);
        return event;
    }

    @Override
    public EventsRSVP findById(String eventId) {
        return table.getItem(r -> r.key(k -> k.partitionValue(eventId)));
    }

    @Override
    public List<EventsRSVP> findAll() {
        List<EventsRSVP> results = new ArrayList<>();
        table.scan().items().forEach(results::add);
        return results;
    }

    @Override
    public EventsRSVP update(EventsRSVP event) {
        table.putItem(event);
        return event;
    }

    @Override
    public void deleteById(String eventId) {
        table.deleteItem(r -> r.key(k -> k.partitionValue(eventId)));
    }
}

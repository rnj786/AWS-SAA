#!/bin/bash
# Usage: ./test_eventsrsvp_api.sh <API_BASE_URL>
# Example: ./test_eventsrsvp_api.sh https://<api-id>.execute-api.us-west-2.amazonaws.com

#API_URL = https://bj7cwd92f8.execute-api.us-west-2.amazonaws.com
API_URL=$1
if [ -z "$API_URL" ]; then
  echo "Usage: $0 <API_BASE_URL>"
  exit 1
fi

# Sample data
event_id="test-event-002"
event_name="Test Event"
event_date="2025-07-01"
rsvp_email="testuser@example.com"
headcount=3
dietary_restrictions="Vegetarian"

# POST - Create Event
echo "\nPOST /api/events"
curl -s -X POST "$API_URL/api/events" \
  -H "Content-Type: application/json" \
  -d @- <<EOF | jq
{
  "eventId": "$event_id",
  "eventName": "$event_name",
  "eventDate": "$event_date",
  "rsvpEmail": "$rsvp_email",
  "headcount": $headcount,
  "dietaryRestrictions": "$dietary_restrictions"
}
EOF

# GET - Get Event by ID
echo "\nGET /api/events/$event_id"
curl -s "$API_URL/api/events/$event_id" | jq

# GET - List All Events
echo "\nGET /api/events"
curl -s "$API_URL/api/events" | jq

# PUT - Update Event
event_name_update="Test Event Updated"
headcount_update=5
echo "\nPUT /api/events"
curl -s -X PUT "$API_URL/api/events" \
  -H "Content-Type: application/json" \
  -d @- <<EOF | jq
{
  "eventId": "$event_id",
  "eventName": "$event_name_update",
  "eventDate": "$event_date",
  "rsvpEmail": "$rsvp_email",
  "headcount": $headcount_update,
  "dietaryRestrictions": "$dietary_restrictions"
}
EOF

# DELETE - Delete Event
echo "\nDELETE /api/events/$event_id"
#curl -s -X DELETE "$API_URL/api/events/$event_id" | jq

// Google Apps Script for Google Forms: submit RSVP to API Gateway
// Replace API_URL with your deployed API endpoint
const API_URL = 'https://bj7cwd92f8.execute-api.us-west-2.amazonaws.com/api/events';

function onFormSubmit(e) {
  if (!e || !e.response) {
    Logger.log('onFormSubmit: event or event.response is undefined. Event object: ' + JSON.stringify(e));
    return;
  }
  var itemResponses = e.response.getItemResponses();
  // Adjust indices based on your form structure
  var eventId = itemResponses[0].getResponse();
  var eventName = itemResponses[1].getResponse();
  var rawDate = itemResponses[2].getResponse();
  var rsvpEmail = itemResponses[3].getResponse();
  var headcount = parseInt(itemResponses[4].getResponse(), 10);
  var dietaryRestrictions = itemResponses[5].getResponse();

  // Format date as yyyy-MM-dd
  var eventDate = rawDate;
  if (rawDate) {
    var dateObj = new Date(rawDate);
    if (!isNaN(dateObj.getTime())) {
      var yyyy = dateObj.getFullYear();
      var mm = String(dateObj.getMonth() + 1).padStart(2, '0');
      var dd = String(dateObj.getDate()).padStart(2, '0');
      eventDate = yyyy + '-' + mm + '-' + dd;
    }
  }

  var payload = {
    eventId: eventId,
    eventName: eventName,
    eventDate: eventDate,
    rsvpEmail: rsvpEmail,
    headcount: headcount,
    dietaryRestrictions: dietaryRestrictions
  };
  var options = {
    method: 'post',
    contentType: 'application/json',
    payload: JSON.stringify(payload),
    muteHttpExceptions: true
  };
  var response = UrlFetchApp.fetch(API_URL, options);
  Logger.log(response.getContentText());
}

function setupTrigger() {
  var form = FormApp.getActiveForm();
  ScriptApp.newTrigger('onFormSubmit')
    .forForm(form)
    .onFormSubmit()
    .create();
}

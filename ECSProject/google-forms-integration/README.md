# Google Forms Integration for EventsRSVP

This integration allows you to capture EventsRSVP fields from a Google Form and submit them as API requests to your API Gateway endpoint.

### Final form link https://docs.google.com/forms/d/e/1FAIpQLSeGhfdkXhHGuUefuwoFy7f948KZCyuxxLCWi0Ha7Q4crGTvgw/viewform


## Steps

1. **Create a Google Form**
   - Add fields for: Event ID, Event Name, Event Date, RSVP Email, Headcount, Dietary Restrictions.

2. **Set Up Google Apps Script**
   - In the Google Form, go to Extensions > Apps Script.
   - Replace the default code with the provided script (`submitToApi.js`).
   - Update the `API_URL` in the script to your API Gateway endpoint (e.g., `https://<api-id>.execute-api.<region>.amazonaws.com/prod/api/events`).

3. **Deploy the Script**
   - Click Deploy > New deployment.
   - Select type: Web app.
   - Set who has access: Anyone (or as needed).
   - Deploy and authorize the script.

4. **Test the Integration**
   - Submit the Google Form.
   - Check your API and DynamoDB for the new RSVP entry.

## Files
- `submitToApi.js`: Google Apps Script to send form responses to your API.

## Troubleshooting

If your Google Form script is not submitting to API Gateway:

1. **Check Script Logs**
   - In Apps Script, go to View > Logs after a form submission.
   - Look for errors or the API response.

2. **Check API Gateway Logs**
   - In AWS Console, check API Gateway and Lambda logs for incoming requests and errors.

3. **Validate API URL**
   - Ensure `API_URL` in `submitToApi.js` is correct and points to the deployed endpoint.

4. **Check Required Fields**
   - Make sure all required fields are present and mapped correctly in the script.

5. **Date Format**
   - Confirm the date is formatted as `yyyy-MM-dd` in the payload.

6. **API Gateway CORS**
   - If you switch to client-side JS, ensure CORS is enabled on your API Gateway.
   - For Apps Script, CORS is not an issue.

7. **API Gateway Authorization**
   - If your API requires an API key or authorization, add the necessary headers in the script.

8. **Network Issues**
   - Ensure the API Gateway endpoint is public and not restricted by VPC or security group rules.

9. **Test with curl/Postman**
   - Try submitting a sample payload to the API Gateway using curl or Postman to isolate if the issue is with the script or the API.

If you see errors in the logs, include the error message for more targeted help.

---

**Note:** You may need to adjust CORS settings on your API Gateway to allow requests from Google Forms if you use client-side JS. This script uses server-side Apps Script, so CORS is not an issue.

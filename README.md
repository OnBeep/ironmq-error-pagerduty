# ironmq-error-pagerduty
Basic IronWorker to translate from IronMQ Errors to PagerDuty Incidents

# Usage
This tool is intended to serve the following use case: `subject_queue` -> `error_queue` (push) -> IronWorker (this) -> PagerDuty

Since IronWorkers do not have access to Header values, and the `name` field for Push Queue subscribers is not editable from the HUD, the best option seems to be having an IronWorker per PagerDuty "incident key".

So, if you want to distinguish your PD Incidents per subject queue, you'll need to have an IronWorker per subject, where you set the `pagerduty_incident_key` to be indicative of the subject queue.

If you are okay with aggregating errors from several subject queues into one PD Incident grouping, then you'll just set up one IronWorker with a `pagerduty_incident_key` indicating the aggregation.

# Config
This worker expects these values are configured for it, via the HUD Dashboard:
```json
{
    "pagerduty_api_key": "EXAMPLE_KEY",
    "pagerduty_service_key": "ANOTHER_EXAMPLE_KEY",
    "pagerduty_subdomain": "EXAMPLE_SUBDOMAIN",
    "pagerduty_incident_key": "EXAMPLE_INCIDENT_KEY"
}
```

# Payload
This worker expects the standard IronMQ Error message as payload:
```json
{
  "source_message_id": "6287988621459144854",
  "body": "Example contents of a queue message",
  "subscribers": [
    {
      "name": "",
      "url": "http://example.com/no-way/no-how",
      "code": 500,
      "msg": "Post http://example.com/no-way/no-how: dial tcp: lookup example.com on 127.0.0.1:80: no such host"
    }
  ]
}
```

# Result
This will create/update a PagerDuty Incident. The incident name look like
"Queue Error for example_incident_key".

# Testing

You can test the container locally with Docker by calling `make test`

# Deploying

Similarly as above, if you have properly configured your local environment
with iron client, you can run `make deploy` to package your worker for upload

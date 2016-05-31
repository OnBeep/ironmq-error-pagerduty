import pygerduty

from iron_worker import *

config = IronWorker.config()
pdapi = config['pagerduty_api_key']
pdsvc = config['pagerduty_service_key']
pdsub = config['pagerduty_subdomain']
pdinc = config['pagerduty_incident_key']

payload = IronWorker.payload()
# Error payloads are expected to look like the following:
# {
#   "source_message_id": "6287988621459144854",
#   "body": "Example contents of a queue message",
#   "subscribers": [
#     {
#       "name": "",
#       "url": "http://example.com/no-way/no-how",
#       "code": 500,
#       "msg": "Post http://example.com/no-way/no-how: dial tcp: lookup example.com on 127.0.0.1:80: no such host"
#     }
#   ]
# }

desc = 'Queue Error for %s' % pdinc
pagerduty = pygerduty.PagerDuty(pdsub, api_token=pdapi)
pagerduty.trigger_incident(
    pdsvc,
    desc,
    incident_key=pdinc,
    details=payload)

import json,os

# Load the JSON file
file_path = 'PayloadBodyChecker_500_2.json'
with open(file_path, 'r') as file:
    data = json.load(file)

# Extract the body from the request_sequence
request_sequence = data['request_sequence']
for request in request_sequence:
    if 'replay_request' in request:
        replay_request = request['replay_request']
        break

# Find the start of the body
#print(replay_request)
body_start = replay_request.find('{')
body = replay_request[body_start:]

print(body)
# Construct the curl command
curl_command = f"""curl -X POST http://127.0.0.18:8000/namf-evts/v1/subscriptions \
-H "Accept: application/json" \
-H "Host: amf:8000" \
-H "Content-Type: application/json" \
-d '{body}'"""
os.system(curl_command)
#print(curl_command)

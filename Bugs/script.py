import json, os

# Load the JSON file
file_path = './InvalidValueChecker_connection_closed_1.json'
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

body = ""
hostname = "10.100.200.2"
#print(body)
# Construct the curl command
curl_command = f"curl -X PUT http://"+hostname+":8000/nf-instances/D0at>\x0bVA1CM -H \"Accept: application/json\" -H \"Content-Type: application/json\" -d '{body}'"
os.system(curl_command)
#print(curl_command)

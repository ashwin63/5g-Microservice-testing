#!/bin/bash

# Execute the restler/Restler test command
echo "Restler Compile started" >> /RESTler/restler_log
/RESTler/restler/Restler compile --api_spec /RESTler/json/swagger.json 
/RESTler/restler/Restler test --grammar_file /RESTler/Compile/grammar.py --dictionary_file /RESTler/Compile/dict.json --no_ssl >> restler_log

echo "Restler Test Passed" >> /RESTler/restler_log
# Check if the command was successful

if [ $? -eq 0 ]; then
    # If successful, execute the restler/Restler fuzz command
    echo "Restler Fuzz started" >> /RESTler/restler_log
    /RESTler/restler/Restler fuzz --grammar_file /RESTler/Compile/grammar.py --dictionary_file /RESTler/Compile/dict.json --no_ssl
    echo "Restler Fuzz Finished" >> /RESTler/restler_log
else
    # If the test command failed, enter an infinite loop
    echo "Restler Test failed" >> /RESTler/restler_log
    while true; do
        sleep 1
    done
fi

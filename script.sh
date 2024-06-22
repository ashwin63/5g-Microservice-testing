#!/bin/bash

# Execute the restler/Restler test command
echo "Restler Compile started" >> restler_log
/RESTler/restler/Restler compile --api_spec config.json 
/RESTler/restler/Restler test --grammar_file Compile/grammar.py --dictionary_file Compile/dict.json --no_ssl >> restler_log

echo "Restler Test Passed" >> restler_log
# Check if the command was successful

if [ $? -eq 0 ]; then
    # If successful, execute the restler/Restler fuzz command
    echo "Restler Fuzz started" >> restler_log
    /RESTler/restler/Restler fuzz --grammar_file Compile/grammar.py --dictionary_file Compile/dict.json --no_ssl
    echo "Restler Fuzz Finished" >> restler_log
else
    # If the test command failed, enter an infinite loop
    echo "Restler Test failed" >> restler_log
    while true; do
        sleep 1
    done
fi

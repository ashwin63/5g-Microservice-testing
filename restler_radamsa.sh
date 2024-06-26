#!/bin/bash
# Define the default filename
filename="swagger.json"
# Check for command line arguments and assign to filename if present
if [ $# -gt 0 ]; then
    filename="$1"
fi
#install radamsa
apk add make
apk add gcc
apk add wget
apk add clang
git clone https://gitlab.com/akihe/radamsa.git
cd /RESTler/json/radamsa
make
make install
cd /RESTler/json
# Execute the restler/Restler test command
echo "Restler Compile started" >> /RESTler/json/restler_log
/RESTler/restler/Restler compile --api_spec /RESTler/json/"$filename" 
/RESTler/restler/Restler test --grammar_file /RESTler/json/Compile/grammar.py --dictionary_file /RESTler/json/Compile/dict.json --settings /RESTler/json/settings.json --no_ssl

#echo "Restler Test Passed" >> /RESTler/restler_log
# Check if the command was successful

if [ $? -eq 0 ]; then
    # If successful, execute the restler/Restler fuzz command
    echo "Restler Fuzz started" >> /RESTler/json/restler_log
    /RESTler/restler/Restler fuzz --grammar_file /RESTler/json/Compile/grammar.py --dictionary_file /RESTler/json/Compile/dict.json --settings /RESTler/json/settings.json --no_ssl
    echo "Restler Fuzz Finished" >> /RESTler/json/restler_log
else
    # If the test command failed, enter an infinite loop
    echo "Restler Test failed" >> /RESTler/json/restler_log
fi

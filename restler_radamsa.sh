#!/bin/bash
#install radamsa
apk add make
apk add gcc
apk add wget
apk add clang
git clone https://gitlab.com/akihe/radamsa.git
cd /RESTler/json/radamsa
make
make install
# Execute the restler/Restler test command
echo "Restler Compile started" >> /RESTler/json/restler_log
/RESTler/restler/Restler compile --api_spec /RESTler/json/swagger.json 
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

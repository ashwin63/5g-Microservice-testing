#!/bin/bash
# Define the default filename
# first argument filename 
# -r => uses radamsa
# -i => reinstalls restler
filename="swagger.json"
radamsa=false

# Check for command line arguments and assign to filename if present
if [ $# -gt 0 ]; then
    filename="$1"
    echo "Filename: $filename"
fi

# Check for -r flag
if [ "$2" == '-r' ]; then
    radamsa=true
    echo "Radamsa: $radamsa"
fi
if [ "$3" == '-i' ]; then
    apk add dotnet6-sdk
    mkdir RESTLER_modified
    cd RESTLER_modified
    git clone https://github.com/ashwin63/restler-fuzzer.git
    cd restler-fuzzer
    git pull
    cd ..
    mkdir restler_bin
    python ./restler-fuzzer/build-restler.py --dest_dir /RESTler/json/RESTLER_modified/restler_bin
fi
#install radamsa
if $radamsa
then
    apk add make
    apk add gcc
    apk add wget
    apk add clang
    git clone https://gitlab.com/akihe/radamsa.git
    cd /RESTler/json/radamsa
    make
    make install
fi
cd /RESTler/json/RESTLER_modified/
# Execute the restler/Restler test command
echo "Restler Compile started" >> /RESTler/json/RESTLER_modified/restler_log
/RESTler/json/RESTLER_modified/restler_bin/restler/Restler compile --api_spec /RESTler/json/"$filename" 
if $radamsa 
then 
    /RESTler/json/RESTLER_modified/restler_bin/restler/Restler test --grammar_file /RESTler/json/RESTLER_modified/Compile/grammar.py --dictionary_file  /RESTler/json/RESTLER_modified/Compile/dict.json --settings  /RESTler/json/settings.json --no_ssl
else
    /RESTler/json/RESTLER_modified/restler_bin/restler/Restler test --grammar_file  /RESTler/json/RESTLER_modified/Compile/grammar.py --dictionary_file  /RESTler/json/RESTLER_modified/Compile/dict.json --no_ssl
fi
#echo "Restler Test Passed" >> /RESTler/restler_log
# Check if the command was successful

if [ $? -eq 0 ]; then
    # If successful, execute the restler/Restler fuzz command
    echo "Restler Fuzz started" >> /RESTler/json/restler_log
    if $radamsa 
    then
        echo "using radamsa"
         /RESTler/json/RESTLER_modified/restler_bin/restler/Restler  fuzz --grammar_file  /RESTler/json/RESTLER_modified/Compile/grammar.py --dictionary_file   /RESTler/json/RESTLER_modified/Compile/dict.json --settings /RESTler/json/settings.json --no_ssl
    else
        echo " Starting fuzzing with default dictionary"
         /RESTler/json/RESTLER_modified/restler_bin/restler/Restler  fuzz --grammar_file  /RESTler/json/RESTLER_modified/Compile/grammar.py --dictionary_file  /RESTler/json/RESTLER_modified/dict.json --no_ssl
    fi
    echo "Restler Fuzz Finished" >> /RESTler/json/restler_log
else
    # If the test command failed, enter an infinite loop
    echo "Restler Test failed" >> /RESTler/json/restler_log
fi

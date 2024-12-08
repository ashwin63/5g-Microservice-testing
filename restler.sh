#!/bin/bash
# Define the default filename
# first argument filename 
# -r => uses radamsa
# -i => reinstalls restler
FILENAME="smf_pdu_session.json"
RESTLER_DIR="/RESTler/modified_restler"
RESTLER_BIN_DIR="${RESTLER_DIR}/restler_bin"
API_FILE_PATH="${RESTLER_DIR}/5g-Microservice-testing/apis/${FILENAME}"
SETTINGS_FILE_PATH="${RESTLER_DIR}/5g-Microservice-testing/settings.json"
RESULTS_DIR="/results/${FILENAME}_results"
RESULTS_FILE="${RESULTS_DIR}/results.out"
radamsa=false

# Check for -r flag
if [ "$1" == '-r' ]; then
    radamsa=true
    echo "Radamsa: $radamsa"
fi
if [ "$2" == '-i' ]; then
    apk add dotnet6-sdk
    apk add git
    apk add nano
    mkdir $RESTLER_DIR
    mkdir $RESULTS_DIR
    cd $RESTLER_DIR
    git clone https://github.com/ashwin63/restler-fuzzer.git
    git clone https://github.com/ashwin63/5g-Microservice-testing.git
    cd restler-fuzzer
    git pull
    cd ..
    mkdir $RESTLER_BIN_DIR
    python ./restler-fuzzer/build-restler.py --dest_dir $RESTLER_BIN_DIR
fi
#install radamsa
if $radamsa
then
    apk add make
    apk add gcc
    apk add wget
    apk add clang
    git clone https://gitlab.com/akihe/radamsa.git
    cd $RESTLER_DIR/radamsa
    make
    make install
fi
cd $RESTLER_DIR
# Execute the restler/Restler test command
echo "Restler Compile started" >> $RESULTS_FILE
$RESTLER_BIN_DIR/restler/Restler compile --api_spec $API_FILE_PATH 
if $radamsa 
then 
    $RESTLER_BIN_DIR/restler/Restler test --grammar_file $RESTLER_DIR/Compile/grammar.py --dictionary_file  $RESTLER_DIR/Compile/dict.json --settings  $SETTINGS_FILE_PATH --no_ssl
else
    $RESTLER_BIN_DIR/restler/Restler test --grammar_file  $RESTLER_DIR/Compile/grammar.py --dictionary_file  $RESTLER_DIR/Compile/dict.json --no_ssl
fi
#echo "Restler Test Passed" >> /RESTler/restler_log
# Check if the command was successful

if [ $? -eq 0 ]; then
    # If successful, execute the restler/Restler fuzz command
    echo "Restler Fuzz started" >> $RESULTS_FILE
    if $radamsa 
    then
        echo "using radamsa"
         $RESTLER_BIN_DIR/restler/Restler  fuzz --grammar_file  $RESTLER_DIR/Compile/grammar.py --dictionary_file   $RESTLER_DIR/Compile/dict.json --settings $SETTINGS_FILE_PATH --no_ssl  --time_budget 2
    else
        echo " Starting fuzzing with default dictionary"
         $RESTLER_BIN_DIR/restler/Restler  fuzz --grammar_file  $RESTLER_DIR/Compile/grammar.py --dictionary_file  $RESTLER_DIR/Compile/dict.json --no_ssl --time_budget 2
    fi
    echo "Restler Fuzz Finished" >> $RESULTS_FILE
    cp -rf $RESTLER_DIR/Fuzz/RestlerResults/* $RESULTS_DIR/
else
    # If the test command failed, enter an infinite loop
    echo "Restler Test failed" >> $RESULTS_FILE
fi

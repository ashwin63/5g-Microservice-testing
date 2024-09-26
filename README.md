# 5G Microservice Testing

## Setting Up Targets

### free5gc-compose
`git clone https://github.com/free5gc/free5gc-compose.git`
`cd free5gc-compose`
`docker compose -f docker-compose.yaml up`

### open5gs
`git clone https://github.com/herlesupreeth/docker_open5gs.git`
`cd docker_open5gs`
`docker compose -f sa-deploy.yaml`

## Setting Up Restler
`git clone https://github.com/microsoft/restler-fuzzer.git`
`cd restler-fuzzer`
Place the Setup/restler.yaml file here
`docker compose -f Setup/restler.yaml up`

## Running Restler
- Make sure target is up and running and test it using curl
`docker exec -it RESTLER_CONTAINER_NAME sh`
`sh restler.sh [arguments]`
- Add nohup to run the script in background
- Arguments:
1st argument => -i flag -> This argument uses the new Feddback mechanism implemented Restler
2nd argument => -r flag -> This argument uses radamsa to test and fuzzz.
This restler.sh Installs radamsa, Compiles grammar file passed to it, runs Restler Test and runs Restler Fuzz.
- To Test/ Replay a testcase, use Bugs/script.py

### Radamsa
Implemented random generation of integer numbers in generator.py utilized in settings file

### References
API specification : https://github.com/free5gc/openapi
API's on swagger : https://github.com/jdegre/5GC_APIs

## Setting Up Evomaster
`docker compose -f Setup/evomaster.yaml up`

## Running Evomaster
`docker exec -it EVOMASTER_CONTAINER_NAME sh`
`wget https://github.com/WebFuzzing/EvoMaster/releases/download/v3.2.0/evomaster_3.2.0_amd64.deb`
`dpkg -i evomaster_3.2.0_amd64.deb`
`export PATH="$PATH:/opt/evomaster/bin"`
`evomaster --blackBox true --bbSwaggerUrl file:/restler_server.yaml --bbTargetUrl http://amf:8000 --outputFormat PYTHON_UNITTEST --maxTime 24h --ratePerMinute 60 `

## Setting Up foREST
`docker compose -f Setup/forest.yaml up`

## Running foREST
`nohup python3 foREST.py --api_file_path /5g-Microservice-testing/apis/amf_event_exposure.yaml --out_put ./output --settings_file ./setting.json --time_budget 10 &`

### Results

## Vulnerabilities Found

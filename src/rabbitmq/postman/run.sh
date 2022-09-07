#!/bin/bash

# Declare variable
REPORT_PATH=/cache/rabbitmq
[ -d ${REPORT_PATH} ] && rm -rf ${REPORT_PATH}
mkdir ${REPORT_PATH}

# Declare function
function execcase() {
    newman run ${1} -e ${2} \
        --insecure \
        --delay-request 1000 \
        -r cli,htmlextra,json,json-summary \
        --reporter-htmlextra-export ${REPORT_PATH}/${1%.*}-extra.html \
        --reporter-summary-json-export ${REPORT_PATH}/${1%.*}-summary.json \
        --reporter-json-export ${REPORT_PATH}/${1%.*}.json
}

# Wait rabbitmq server statup
sleep 5s

# Execute test-case
execcase rabbitmq-agent.json rabbitmq-env.json

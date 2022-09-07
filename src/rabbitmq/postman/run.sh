#!/bin/bash

# Declare variable
REPORT_PATH=/cache/rabbitmq
[ -d ${REPORT_PATH} ] && rm -rf ${REPORT_PATH}
mkdir ${REPORT_PATH}

# Declare function
function execcase() {
    DELAY=200
    [ -z ${3} ] && DELAY=${3}
    newman run ${1} -e ${2} \
        --insecure \
        --delay-request ${3} \
        -r cli,htmlextra,json,json-summary \
        --reporter-htmlextra-export ${REPORT_PATH}/${1%.*}-extra.html \
        --reporter-summary-json-export ${REPORT_PATH}/${1%.*}-summary.json \
        --reporter-json-export ${REPORT_PATH}/${1%.*}.json
}

# Wait rabbitmq server statup

# Execute test-case
execcase rabbitmq-amqp.json rabbitmq-env.json
execcase rabbitmq-agent.json rabbitmq-env.json 1500

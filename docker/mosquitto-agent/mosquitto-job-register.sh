#!/bin/bash
echo "`date` - start job register" > /root/mosquitto-job-register.log
while true;
do
    find "/root/" -follow -iname mosquitto-sub-request-*.cmd -type f -print | sort -V | while read -r f; do
        echo "`date` - Launching ${f}" >> /root/mosquitto-job-register.log
        source ${f}
        rm ${f}
    done
    sleep 1
done

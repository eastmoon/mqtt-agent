# ------------------- execute script -------------------
# ref: https://curl.se/docs/mqtt.html
# ref: https://gist.github.com/jforge/c783e47c430a897a7bddb95b64f8fcc0

## Mosquitto use
curl -d '{ "value": "scanning" }' mqtt://mosquitto:1883/home/bedroom/temp --output - --trace -

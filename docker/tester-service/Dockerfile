FROM postman/newman:alpine

RUN npm install -g newman-reporter-html newman-reporter-htmlextra newman-reporter-json-summary

ENTRYPOINT  ["tail", "-f", "/dev/null"]

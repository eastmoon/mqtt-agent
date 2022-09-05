@echo off
setlocal
setlocal enabledelayedexpansion

:: ------------------- execute script -------------------
@rem build locale converter image
::docker build -t mqtt-testers %cd%\docker\testers
docker build -t mosquitto-agent %cd%\docker\mosquitto-agent

@rem create cache

@rem create environment file
if EXIST %cd%\docker\.env (
    del %cd%\docker\.env
)
echo PROJECT_NAME=mqtt-tester > %cd%\docker\.env
echo SOURCE_CODE_VOLUME=%cd%\src >> %cd%\docker\.env

@rem execute converter
docker-compose -f %cd%\docker\docker-compose.yml up -d
docker exec -ti -w "/usr/share/nginx/html/cgi-bin" mqtt-test-nginx-service bash
docker-compose -f %cd%\docker\docker-compose.yml down

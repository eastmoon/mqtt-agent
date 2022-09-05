@echo off
setlocal
setlocal enabledelayedexpansion

:: ------------------- execute script -------------------
@rem build locale converter image
docker build -t tester-service %cd%\docker\tester-service
docker build -t mosquitto-agent %cd%\docker\mosquitto-agent

@rem create cache
if NOT EXIST %cd%\cache (
    mkdir %cd%\cache
)

@rem create environment file
if EXIST %cd%\docker\.env (
    del %cd%\docker\.env
)
echo PROJECT_NAME=mqtt-tester > %cd%\docker\.env
echo SOURCE_CODE_VOLUME=%cd%\src >> %cd%\docker\.env
echo CACHE_VOLUME=%cd%\cache >> %cd%\docker\.env

@rem execute converter
docker-compose -f %cd%\docker\docker-compose-mosquitto.yml up -d
docker exec -ti -w "/app" mqtt-agent-tester-service sh -c "source mosquitto-run.sh"
docker-compose -f %cd%\docker\docker-compose-mosquitto.yml down

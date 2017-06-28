#!/bin/bash

[ $MARATHON ] || { echo "please export MARATHON=<marathon_address_no_port>" && exit 1; }
JSON='
{
 "id": "demo-app-2",
 "mem": 16,
 "cpus": 0.1,
 "instances": 1,
 "container": {
   "type": "DOCKER",
   "docker": {
     "image": "registry.corp.mobile.de/techhack2017/demo-app:master.20170628193015.205e9d.prod",
     "network": "BRIDGE",
     "portMappings": [
        { "containerPort": 80, "hostPort": 0, "protocol": "tcp" }
     ]
   }
 },
 "env": {
   "SERVICE_TAGS" : "haproxy",
   "SERVICE_NAME" : "demo-app-2"
 },
 "healthChecks": [
   {
     "path": "/",
     "portIndex": 0,
     "protocol": "HTTP",
     "gracePeriodSeconds": 30,
     "intervalSeconds": 10,
     "timeoutSeconds": 30,
     "maxConsecutiveFailures": 3
   }
 ]
}
'
curl -X PUT -H "Content-Type: application/json" http://${MARATHON}:8080/v2/apps/demo-app-2?force=true -d "$JSON"

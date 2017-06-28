#!/bin/bash
[ $MARATHON ] || { echo "please export MARATHON=<marathon_address_no_port>" && exit 1; }
curl -X DELETE -H "Content-Type: application/json" http://${MARATHON}:8080/v2/apps/demo-app-2?force=true >/dev/null 2>&1

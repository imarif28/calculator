#!/bin/bash
set -x

NODE_IP=$(kubectl --context kind-production get nodes -o jsonpath='{ $.items[0].status.addresses[?(@.type=="InternalIP")].address }')
NODE_PORT=$(kubectl --context kind-production get svc calculator-service -o=jsonpath='{.spec.ports[0].nodePort}')
./gradlew smokeTest -Dcalculator.url=http://${NODE_IP}:${NODE_PORT}
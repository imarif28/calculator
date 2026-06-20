#!/bin/bash
set -x

NODE_IP=$(kubectl --context kind-staging get nodes -o jsonpath='{ $.items[0].status.addresses[?(@.type=="InternalIP")].address }')
NODE_PORT=$(kubectl --context kind-staging get svc calculator-service -o=jsonpath='{.spec.ports[0].nodePort}')
./gradlew acceptanceTest -Dcalculator.url=http://${NODE_IP}:${NODE_PORT}
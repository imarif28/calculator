#!/bin/bash
set -x

# Kita gunakan environment staging untuk performance test
NODE_IP=$(kubectl --context kind-staging get nodes -o jsonpath='{ $.items[0].status.addresses[?(@.type=="InternalIP")].address }')
NODE_PORT=$(kubectl --context kind-staging get svc calculator-service -o=jsonpath='{.spec.ports[0].nodePort}')
ENDPOINT="${NODE_IP}:${NODE_PORT}"
N=100

echo "Memulai performance test pada http://${ENDPOINT}/sum?a=1&b=2 sebanyak ${N} kali..."

START=$(date +%s)
for i in $(seq ${N}); do
    # -s: silent, -o /dev/null: sembunyikan body response, -w: ambil http status code
    STATUS=$(curl -s -o /dev/null -w "%{http_code}" "http://${ENDPOINT}/sum?a=1&b=2")
    
    if [ "$STATUS" != "200" ]; then
        echo "Error: Mendapat status HTTP $STATUS pada request ke-$i"
        exit 1
    fi
done
END=$(date +%s)

RUNTIME=$((END-START))
AVG=$((RUNTIME/N))

echo "Total waktu: ${RUNTIME} detik."
echo "Rata-rata waktu per request: ${AVG} detik (dibulatkan ke bawah)."

if [ ${AVG} -lt 1 ]; then
    echo "Test Sukses: Rata-rata waktu respons di bawah 1 detik."
    exit 0
else
    echo "Test Gagal: Rata-rata waktu respons melebihi batas 1 detik."
    exit 1
fi

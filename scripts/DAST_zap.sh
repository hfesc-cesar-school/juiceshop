#!/bin/bash

CONTAINER_NAME=localhost
CONTAINER_PORT=4000
ZAP_CONTAINER_NAME=zap

ZAP_INFO=0
ZAP_LOW=1
ZAP_MEDIUM=2
ZAP_HIGH=3
ZAP_NONE=4

just _info "🔧 Starting application..."
just start

just _info "⏳ Waiting for application to be UP..."
until curl -s -L http://localhost:${CONTAINER_PORT} | grep -q "OWASP Node Goat"; do
  sleep 3
done
just _info "✅ application is UP!"

just _info "🕵️‍♂️ Scanning with OWASP ZAP..."

# For a deeper scanning, use zap-full-scan.py instead of zap-baseline.py...
docker run --rm --network host --name ${ZAP_CONTAINER_NAME} \
    -v ./reports/zap:/zap/wrk/:rw \
    -v ./scripts/zap.context:/zap/wrk/zap.context \
      ghcr.io/zaproxy/zaproxy:stable zap-baseline.py \
      -t http://${CONTAINER_NAME}:${CONTAINER_PORT} \
      -n /zap/wrk/zap.context \
      -U "admin" \
      -r zap_report.html \
      -l WARN

SCAN_RESULT=$?
just _info "${SCAN_RESULT}"

just _info "🧼 Stopping application..."
just stop

if [ ${SCAN_RESULT} -ne 0 ]; then
    just _error "❌ ZAP found vulnerabilities. Commit blocked!"
    exit 1
fi

just _info "✅ No vulnerabilities found! You are allowed to commi

# Check the scan result and set the exit code accordingly
if [ ${SCAN_RESULT} -eq ${ZAP_INFO} ]; then
    just _info "🟢 No vulnerabilities found, but some information messages were generated."
elif [ ${SCAN_RESULT} -eq ${ZAP_LOW} ]; then
    just _info "🟡 Low vulnerabilities found. Please review the report."
elif [ ${SCAN_RESULT} -eq ${ZAP_MEDIUM} ]; then
    just _warning "🟠 Medium vulnerabilities found. Please review the report."
elif [ ${SCAN_RESULT} -eq ${ZAP_HIGH} ]; then
    just _error "🔴 High vulnerabilities found. Commit blocked!"
    exit 1
fit!"
exit 0
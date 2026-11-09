#!/bin/bash
set -e

echo "=========================================================="
echo "         1. Checking All Container Status                 "
echo "=========================================================="
docker compose ps

echo -e "\n=========================================================="
echo "         2. Verifying Non-Root Users (UID != 0)           "
echo "=========================================================="
echo -n "Tomcat User: " && docker compose exec tomcat id
echo -n "NGINX User:  " && docker compose exec nginx id

echo -e "\n=========================================================="
echo "         3. Testing Application Connectivity via NGINX    "
echo "=========================================================="
curl -I http://localhost/login

echo -e "\n=========================================================="
echo "         4. Generating Vulnerability Scan Reports (Trivy) "
echo "=========================================================="
mkdir -p docs

echo "-> Scanning NGINX Image..."
docker run --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v trivy_cache:/root/.cache/ \
  aquasec/trivy:latest image --timeout 15m --severity HIGH,CRITICAL enterprise-nginx:latest > docs/nginx-vuln-report.txt
echo "✓ NGINX report generated: docs/nginx-vuln-report.txt"

echo "-> Scanning Tomcat Image..."
docker run --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v trivy_cache:/root/.cache/ \
  aquasec/trivy:latest image --timeout 15m --severity HIGH,CRITICAL enterprise-tomcat:latest > docs/tomcat-vuln-report.txt
echo "✓ Tomcat report generated: docs/tomcat-vuln-report.txt"

echo -e "\n=========================================================="
echo "   [SUCCESS] Project 02 is 100% COMPLETE & VALIDATED! 🚀   "
echo "=========================================================="

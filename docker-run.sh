#!/usr/bin/env bash
set -e

IMAGE="pegasus-checker:latest"

if ! docker images | grep -q pegasus-checker; then
echo "[+] Building image..."
docker build -t $IMAGE .
fi

echo "[+] Running Pegasus Checker container"
docker run -it --rm \
--net=host \
--device /dev/bus/usb:/dev/bus/usb \
-v $(pwd):/app \
$IMAGE
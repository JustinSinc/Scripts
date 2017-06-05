#!/usr/bin/env bash
$(docker ps --format "{{.ID}}" | sed 's/^/docker rm -f /g' | sed 's/^$/d/' ) > /dev/null 2>&1

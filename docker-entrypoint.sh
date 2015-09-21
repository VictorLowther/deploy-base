#!/bin/bash
set -e
set -x

consul agent --join consul --config-dir /etc/consul.d --data-dir /data &

answer=""
# We need consul to converge on a leader.
# This can take a little time, so we ask for
# leader status.  The leader status returns
# nothing, a string that says no leader, or
# the leader IP:port pair.  The default port
# is 8300 for server communication.
while [[ $answer != *:8300* ]]; do
  sleep 1
  answer=`curl http://localhost:8500/v1/status/leader`
  echo "Waiting for consul leader: $answer"
done

# Just about everything wants an IP address.
IP=`ip addr show eth0 | grep inet | grep -v inet6 | awk '{ print $2 }' | awk -F/ '{ print $1 }'`

# Now that consul is up, run whatever commands we want the system to run.
for cmd in /usr/local/entrypoint.d/*.sh; do
    [[ -x $cmd ]] || continue
    . "$cmd"
done

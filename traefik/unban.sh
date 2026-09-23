#!/bin/sh
# Remove CrowdSec bans for the given IPs or CIDR ranges
#
# usage: ./unban.sh 1.2.3.4 [192.0.2.0/24 ...]
#
# The traefik bouncer picks up the change within its update interval (60s)

if [ $# -eq 0 ]; then
    echo "usage: $0 <ip|cidr> [<ip|cidr> ...]" >&2
    exit 1
fi

for target in "$@"; do
    case "$target" in
        */*) flag=--range ;;
        *) flag=--ip ;;
    esac

    echo "== $target"
    docker exec crowdsec cscli decisions list $flag "$target"
    docker exec crowdsec cscli decisions delete $flag "$target"
done

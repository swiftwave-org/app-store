#!/bin/sh

set -e

# Get the username and password from environment variables
AUTH_USERNAME="${AUTH_USERNAME:-}"
AUTH_PASSWORD="${AUTH_PASSWORD:-}"

# Check if both variables are set
if [ -z "$AUTH_USERNAME" ] || [ -z "$AUTH_PASSWORD" ]; then
   echo "Error: AUTH_USERNAME and AUTH_PASSWORD environment variables must be set."
   exit 1
fi

# Run the htpasswd command with the specified username and password
htpasswd -nbB "$AUTH_USERNAME" "$AUTH_PASSWORD" > /auth/htpasswd

case "$1" in
    *.yaml|*.yml) set -- registry serve "$@" ;;
    serve|garbage-collect|help|-*) set -- registry "$@" ;;
esac

exec "$@"
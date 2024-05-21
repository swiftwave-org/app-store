# !/bin/bash

set -e

# Get MARIADB_DEFAULT_HOST from environment variable
MARIADB_DEFAULT_HOST="${MARIADB_DEFAULT_HOST:-}"

# Raise error if MARIADB_DEFAULT_HOST is not set
if [ -z "$MARIADB_DEFAULT_HOST" ]; then
    echo "Error: MARIADB_DEFAULT_HOST environment variable must be set."
    exit 1
fi

# Set MARIADB_DEFAULT_HOST
bench set-mariadb-host "$MARIADB_DEFAULT_HOST"

# Run supervisord
supervisord
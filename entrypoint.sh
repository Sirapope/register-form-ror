#!/bin/sh
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /rails/tmp/pids/server.pid

# Run database migrations
rails db:migrate

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
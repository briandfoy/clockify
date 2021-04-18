#!/bin/sh


CLOCKIFY_USER_JSON=$( curl -H "X-Api-Key: $CLOCKIFY_API_KEY" -s https://api.clockify.me/api/v1/user )
CLOCKIFY_USER=$( jq -r .id <<< "$CLOCKIFY_USER_JSON" )
CLOCKIFY_WORKSPACE='5b634056b0798703574fe8f5'

echo "USER: $CLOCKIFY_USER"
echo "WORKSPACE: $CLOCKIFY_WORKSPACE"

URL="https://api.clockify.me/api/v1/workspaces/$CLOCKIFY_WORKSPACE/user/$CLOCKIFY_USER/time-entries"

echo "URL: $URL";

set -x
curl -L -H "X-Api-Key: $CLOCKIFY_API_KEY" "$URL"

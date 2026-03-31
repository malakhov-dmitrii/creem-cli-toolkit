#!/bin/bash
# Generate checkout links for ALL products
SUCCESS_URL=${1:-"https://myapp.com/thanks"}

creem products list --json | jq -r '.items[] | .id' | while read pid; do
  URL=$(creem checkouts create --product "$pid" --success-url "$SUCCESS_URL" --json | jq -r '.checkoutUrl')
  NAME=$(creem products get "$pid" --json | jq -r '.name')
  echo "$NAME: $URL"
done

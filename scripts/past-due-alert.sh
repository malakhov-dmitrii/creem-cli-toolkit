#!/bin/bash
# Alert: find all past-due subscriptions with customer info
PAST_DUE=$(creem subs list --status past_due --json | jq '.items | length')

if [ "$PAST_DUE" -gt 0 ]; then
  echo "WARNING: $PAST_DUE subscription(s) past due:"
  creem subs list --status past_due --json | jq -r '.items[] | "  \(.customer.email // "unknown") — \(.product.name // "unknown")"'
else
  echo "All clear — no past-due subscriptions"
fi

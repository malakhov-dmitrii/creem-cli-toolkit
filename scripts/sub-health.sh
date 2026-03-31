#!/bin/bash
# Subscription health: count by status
for status in active trialing past_due paused canceled expired; do
  COUNT=$(creem subs list --status $status --json | jq '.items | length')
  echo "$status: $COUNT"
done

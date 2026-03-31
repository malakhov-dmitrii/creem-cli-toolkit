#!/bin/bash
# Calculate Monthly Recurring Revenue from active subscriptions
creem subs list --status active --json 2>/dev/null | jq '[.items[] | .product.price] | add / 100'

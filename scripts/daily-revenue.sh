#!/bin/bash
# Daily revenue + sub count logger
# Add to crontab: 0 9 * * * /path/to/daily-revenue.sh
REVENUE=$(creem txn list --json | jq '[.items[] | select(.status=="paid") | .amount] | add / 100')
SUBS=$(creem subs list --status active --json | jq '.items | length')
echo "$(date +%Y-%m-%d) | Revenue: \$$REVENUE | Active subs: $SUBS" >> ~/creem-daily.log

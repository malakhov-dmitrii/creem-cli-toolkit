#!/bin/bash
# Product pricing table (tab-separated, spreadsheet-friendly)
echo -e "Name\tPrice\tBilling"
creem products list --json 2>/dev/null | jq -r '.items[] | [.name, "$\(.price/100)", .billingPeriod] | @tsv'

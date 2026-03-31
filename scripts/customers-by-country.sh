#!/bin/bash
# Customer count by country
creem customers list --json 2>/dev/null | jq '
  [.items[] | .country]
  | group_by(.) | map({country: .[0], count: length})
  | sort_by(-.count)'

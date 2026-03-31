#!/bin/bash
# Customer count by country
creem customers list --json | jq '
  [.items[] | .country]
  | group_by(.) | map({country: .[0], count: length})
  | sort_by(-.count)'

#!/bin/bash
# Revenue breakdown by product
creem txn list --json | jq '
  [.items[] | select(.status=="paid")]
  | group_by(.description)
  | map({
      product: .[0].description,
      total: ([.[].amount] | add / 100),
      count: length
    })
  | sort_by(-.total)'

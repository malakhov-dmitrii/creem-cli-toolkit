#!/bin/bash
# Generate checkout link and copy to clipboard
# Usage: ./checkout-link.sh <product_id> [success_url]
PRODUCT=${1:?Usage: checkout-link.sh <product_id> [success_url]}
SUCCESS_URL=${2:-"https://myapp.com/thanks"}

URL=$(creem checkouts create --product "$PRODUCT" --success-url "$SUCCESS_URL" --json 2>/dev/null | jq -r '.checkoutUrl')
echo "$URL"

# Copy to clipboard (macOS)
if command -v pbcopy &>/dev/null; then
  echo -n "$URL" | pbcopy
  echo "(copied to clipboard)"
fi

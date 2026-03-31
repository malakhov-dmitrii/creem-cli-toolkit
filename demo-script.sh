#!/bin/bash
# Creem CLI Power Tool — Demo Script
# Run each section step by step while recording screen

set -e

echo "============================================"
echo "  Creem CLI — Developer Power Tool Demo"
echo "============================================"
echo ""

# -----------------------------------------------
# PART 1: Install & Setup
# -----------------------------------------------
echo "--- Part 1: Install & Setup ---"
echo ""

# Install
# brew tap armitage-labs/creem
# brew install creem
creem --version

# Login with test key
# creem login --api-key creem_test_xxx
creem whoami

echo ""
echo "--- Part 2: Store Overview ---"
echo ""

# -----------------------------------------------
# PART 2: Explore your store
# -----------------------------------------------

# Products (table view — default)
creem products list

# Products (JSON — for scripting)
creem products list --json | jq '.items | length'
echo "^ total products in store"

# Customers
creem customers list

# Active subscriptions
creem subs list --status active

# Transactions
creem txn list --limit 5

echo ""
echo "--- Part 3: CLI + jq Pipelines ---"
echo ""

# -----------------------------------------------
# PART 3: Power scripting with --json + jq
# -----------------------------------------------

# Calculate MRR from active subscriptions
echo "Monthly Recurring Revenue:"
creem subs list --status active --json | jq '
  [.items[] | .product.price] | add / 100
' | xargs printf "$%.2f/mo\n"

# List customers by country
echo ""
echo "Customers by country:"
creem customers list --json | jq '
  [.items[] | .country] | group_by(.) | map({country: .[0], count: length}) | sort_by(-.count)
'

# Find high-value transactions
echo ""
echo "Transactions over $20:"
creem txn list --json | jq '
  [.items[] | select(.amount > 2000)] | map({id: .id, amount: (.amount/100), status: .status})
'

# Quick product pricing table
echo ""
echo "Product pricing:"
creem products list --json | jq -r '
  .items[] | "\(.name)\t$\(.price/100)\t\(.billingPeriod)"
'

echo ""
echo "--- Part 4: Checkout Links ---"
echo ""

# -----------------------------------------------
# PART 4: Generate checkout links from terminal
# -----------------------------------------------

# Create a checkout session
PRODUCT_ID=$(creem products list --json | jq -r '.items[0].id')
echo "Creating checkout for product: $PRODUCT_ID"
creem checkouts create --product "$PRODUCT_ID" --success-url "https://example.com/thanks" --json | jq '{url: .checkoutUrl, id: .id}'

echo ""
echo "--- Part 5: AI Agent with MCP ---"
echo ""

# -----------------------------------------------
# PART 5: MCP Server for AI Agents
# -----------------------------------------------

echo "Start MCP server for Claude/Cursor:"
echo "  npx -y --package creem -- mcp start --api-key \$CREEM_API_KEY --server-index 1"
echo ""
echo "Add to Claude Desktop config (~/.claude/settings.json):"
cat <<'CONFIG'
{
  "mcpServers": {
    "creem": {
      "command": "npx",
      "args": ["-y", "--package", "creem", "--", "mcp", "start",
               "--api-key", "creem_test_xxx",
               "--server-index", "1"]
    }
  }
}
CONFIG

echo ""
echo "Then ask Claude: 'Show me my active subscriptions and calculate MRR'"
echo "Claude uses MCP tools: subscriptions-search, stats-get-metrics-summary"
echo ""
echo "============================================"
echo "  Demo complete!"
echo "============================================"

---
title: "3 Ways to Control Your SaaS Payments Without Opening a Dashboard"
published: false
description: "Creem CLI, jq pipelines, and MCP for AI agents — manage products, subscriptions, checkout links, and revenue from your terminal"
tags: cli, saas, ai, tutorial
cover_image:
---

I manage a SaaS on [Creem](https://creem.io). I used to have the dashboard open all day. Now I don't open it at all.

The Creem CLI gives you three increasingly powerful ways to manage payments: direct commands, `--json | jq` pipelines for automation, and an MCP server that lets Claude or Cursor manage your store through natural language. Here's the full playbook.

## Setup (2 minutes)

```bash
brew tap armitage-labs/creem
brew install creem
creem login --api-key creem_test_xxx
creem whoami
```

Switch between test and live:

```bash
creem config set environment test   # test-api.creem.io
creem config set environment live   # api.creem.io
creem config show                   # verify current state
```

## Level 1: Direct Commands

Every resource — products, subscriptions, customers, transactions, discounts — is a subcommand:

```bash
creem products list              # Table view
creem subs list --status active  # Filter subscriptions
creem customers list             # All customers
creem txn list --limit 5         # Recent transactions
creem discounts get --code LAUNCH20  # Look up a discount
```

Run any resource command without a subcommand for an interactive TUI:

```bash
creem products     # Navigate with j/k, select with Enter
creem subs         # Same for subscriptions
creem customers    # Browse and inspect
```

The TUI is keyboard-driven — `j`/`k` to scroll, `/` to search, Enter to view details. Perfect for quick lookups.

### Create Resources

```bash
# New product
creem products create \
  --name "Pro Plan" \
  --price 2900 \
  --billing-type recurring \
  --billing-period every-month

# Checkout link (copy to clipboard)
creem checkouts create \
  --product prod_xxx \
  --success-url "https://myapp.com/thanks" \
  --json | jq -r '.checkoutUrl' | pbcopy
```

### Subscription Lifecycle

The full lifecycle without opening a browser:

```bash
creem subs list --status active       # Who's paying?
creem subs get sub_xxx                # Details + billing dates
creem subs pause sub_xxx              # Pause billing
creem subs resume sub_xxx             # Resume
creem subs cancel sub_xxx             # Cancel (end of period)
creem subs cancel sub_xxx --mode immediate  # Cancel now
```

## Level 2: `--json | jq` Pipelines

Every command supports `--json`. The response shape is always `{ items: [...] }`. This makes the CLI fully composable with jq, shell scripts, and cron.

**Calculate MRR:**

```bash
creem subs list --status active --json | jq '
  [.items[] | .product.price] | add / 100
'
# 125
```

**Revenue by product:**

```bash
creem txn list --json | jq '
  [.items[] | select(.status=="paid")]
  | group_by(.description)
  | map({
      product: .[0].description,
      total: ([.[].amount] | add / 100),
      count: length
    })
  | sort_by(-.total)
'
```

**Customers by country:**

```bash
creem customers list --json | jq '
  [.items[] | .country]
  | group_by(.) | map({country: .[0], count: length})
  | sort_by(-.count)
'
```

**High-value transactions (over $20):**

```bash
creem txn list --json | jq '
  [.items[] | select(.amount > 2000)]
  | map({id: .id, amount: (.amount/100), status: .status})
'
```

**Product pricing table (tab-separated for spreadsheets):**

```bash
creem products list --json | jq -r '
  .items[] | [.name, "$\(.price/100)", .billingPeriod] | @tsv
'
# Starter    $9     every-month
# Pro        $29    every-month
# Enterprise $99    every-month
# Lifetime   $49    once
```

**Find all past-due subscriptions with customer emails:**

```bash
creem subs list --status past_due --json | jq '
  .items[] | {sub: .id, email: .customer.email, product: .product.name, since: .currentPeriodEndDate}
'
```

**Bulk generate checkout links for all products:**

```bash
creem products list --json | jq -r '.items[] | .id' | while read pid; do
  URL=$(creem checkouts create --product "$pid" --success-url "https://myapp.com/thanks" --json | jq -r '.checkoutUrl')
  NAME=$(creem products get "$pid" --json | jq -r '.name')
  echo "$NAME: $URL"
done
```

**Daily revenue cron job:**

```bash
#!/bin/bash
# Add to crontab: 0 9 * * * ~/daily-revenue.sh
REVENUE=$(creem txn list --json | jq '[.items[] | select(.status=="paid") | .amount] | add / 100')
SUBS=$(creem subs list --status active --json | jq '.items | length')
echo "$(date +%Y-%m-%d) | Revenue: \$$REVENUE | Active subs: $SUBS" >> ~/creem-daily.log
```

**Count subscriptions by status:**

```bash
for status in active trialing past_due paused canceled; do
  COUNT=$(creem subs list --status $status --json | jq '.items | length')
  echo "$status: $COUNT"
done
```

## Level 3: AI Agent via MCP Server

This is where it gets wild. The `creem` npm package ships with an MCP server — 22 tools that any MCP-compatible AI agent can call directly via the Creem SDK (not shelling out to the CLI like some custom solutions).

**Setup for Claude Code / Claude Desktop:**

Add to your MCP config:

```json
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
```

For Cursor, same format in `.cursor/mcp.json`.

**What the AI can do:**

| You say | MCP tool called |
|---------|----------------|
| You say | MCP tool called |
|---------|----------------|
| "Show me all active subscriptions" | `subscriptions-search-subscriptions` |
| "Create a 20% discount for the Pro plan" | `discounts-create` |
| "Generate a checkout link for Enterprise" | `checkouts-create` |
| "Pause Bob's subscription" | `subscriptions-pause` |
| "Activate this license key" | `licenses-activate` |
| "Upgrade to the Enterprise plan" | `subscriptions-upgrade` |

The MCP server exposes tools the CLI doesn't have. `discounts-create` and `discounts-delete` are MCP-only — the CLI can read discounts but can't create them. `licenses-activate/deactivate/validate` and `subscriptions-upgrade` are also MCP-only. Through MCP, your AI agent has full CRUD access to your store.

All 22 tools:

```
products-get, products-create, products-search
customers-list, customers-retrieve, customers-generate-billing-links
subscriptions-get, subscriptions-cancel, subscriptions-update,
  subscriptions-upgrade, subscriptions-pause, subscriptions-resume,
  subscriptions-search-subscriptions
checkouts-retrieve, checkouts-create
licenses-activate, licenses-deactivate, licenses-validate
discounts-get, discounts-create, discounts-delete
transactions-get-by-id, transactions-search
stats-get-metrics-summary
```

Creem is one of the first payment platforms with native agent support. Their onboarding spec at [creem.io/SKILL.md](https://creem.io/SKILL.md) describes 7 routing workflows for AI agents — from selling products to managing subscriptions to handling support tickets.

## Bonus: Migrate from Lemon Squeezy

Switching? One command:

```bash
creem migrate lemon-squeezy
```

Preview first with `--dry-run`:

```bash
creem migrate lemon-squeezy --dry-run
```

Or export the migration plan as JSON for review:

```bash
creem migrate lemon-squeezy --json > migration-plan.json
```

Skip discounts if you want to recreate them manually:

```bash
creem migrate lemon-squeezy --exclude-discounts
```

The wizard maps your products, pricing, and billing periods. No CSV exports, no manual data entry.

## When to Use What

| Task | CLI | `--json \| jq` | MCP Agent |
|------|-----|----------------|-----------|
| Quick lookup | `creem subs get id` | — | "Show sub X" |
| Bulk analysis | — | `jq 'group_by...'` | "Analyze churn" |
| Shell scripts | `creem txn list` | pipe to jq | — |
| CI/CD | CLI commands | parse output | — |
| Checkout links | `creem checkouts create` | `\| jq .url \| pbcopy` | "Create checkout" |
| Revenue metrics | — | jq math | jq + `transactions-search` |
| Create discounts | — | — | `discounts-create` (MCP-only) |
| License management | — | — | `licenses-activate/validate` (MCP-only) |
| Migration | `creem migrate` | `--json > plan.json` | — |

Three interfaces, one payment platform. Use each where it's strongest.

## Get Started

```bash
brew tap armitage-labs/creem && brew install creem
creem login
creem products list
```

Terminal to payments in 2 minutes. No dashboard required.

---

*Built for the [Creem Scoops](https://creem.io/scoops) bounty program. CLI v0.1.3, MCP server via [creem](https://www.npmjs.com/package/creem) v1.4.4.*

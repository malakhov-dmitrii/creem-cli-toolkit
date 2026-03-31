---
name: creem-cli
description: "Creem CLI command reference — manage SaaS payments, subscriptions, and customers from terminal"
---

# Creem CLI Reference

Use `creem` CLI to manage your Creem store. All commands support `--json` for machine-readable output.

## Auth & Config

```bash
creem login --api-key <key>     # Authenticate
creem logout                     # Clear credentials
creem whoami                     # Show current auth
creem config show                # Show all config
creem config set environment test|live  # Switch API endpoint
creem config set output_format json|table  # Default output format
```

## Products

```bash
creem products list [--page N] [--limit N]  # List products
creem products get <id>                      # Get by ID
creem products create --name <name> --price <cents> --billing-type recurring|onetime [--billing-period every-month|every-year|once]
creem products                               # Interactive TUI browser
```

## Subscriptions

```bash
creem subs list [--status active|trialing|paused|past_due|expired|canceled|scheduled_cancel] [--page N]
creem subs get <id>                          # Get details
creem subs cancel <id> [--mode scheduled|immediate]
creem subs pause <id>                        # Pause billing
creem subs resume <id>                       # Resume
creem subs                                   # Interactive TUI
```

## Customers

```bash
creem customers list [--page N] [--limit N]
creem customers get <id>
creem customers get --email <email>
creem customers billing <id>                 # Generate billing portal link
creem customers                              # Interactive TUI
```

## Checkouts

```bash
creem checkouts create --product <id> [--success-url <url>]
creem checkouts get <id>
```

## Transactions

```bash
creem txn list [--limit N] [--page N] [--customer <id>] [--product <id>]
creem txn get <id>
creem txn                                    # Interactive TUI
```

## Discounts

```bash
creem discounts get <id>
creem discounts get --code <code>
```

## Migration

```bash
creem migrate lemon-squeezy                  # Interactive wizard
creem migrate lemon-squeezy --dry-run        # Preview only
creem migrate lemon-squeezy --json > plan.json  # Export plan
creem migrate lemon-squeezy --exclude-discounts # Skip discounts
```

## Safety Rules

- All amounts are in **minor units** (cents): 2900 = $29.00
- Test keys start with `creem_test_`, live keys with `creem_`
- Default environment is `test` — always verify with `creem whoami`
- Use `--json 2>/dev/null` to suppress spinner text in scripts
- Never expose API keys in chat or logs

## jq Patterns

```bash
# MRR
creem subs list --status active --json 2>/dev/null | jq '[.items[] | .product.price] | add / 100'

# Pricing table
creem products list --json 2>/dev/null | jq -r '.items[] | [.name, "$\(.price/100)", .billingPeriod] | @tsv'

# Checkout link to clipboard
creem checkouts create --product <id> --success-url <url> --json 2>/dev/null | jq -r '.checkoutUrl' | pbcopy
```

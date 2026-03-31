# creem-cli-toolkit

[![Creem CLI](https://img.shields.io/badge/Creem_CLI-v0.1.3-blue)](https://docs.creem.io/code/cli) [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

Shell scripts, jq recipes, MCP configs, and a Claude Code skill for managing your [Creem](https://creem.io) SaaS payments from the terminal.

## What's Inside

```
scripts/               # Ready-to-use shell scripts
  mrr.sh               # Calculate MRR from active subscriptions
  revenue-by-product.sh # Revenue breakdown by product
  customers-by-country.sh # Customer count by country
  sub-health.sh        # Subscription count by status
  pricing-table.sh     # Export product pricing as TSV
  checkout-link.sh     # Generate checkout URL + copy to clipboard
  daily-revenue.sh     # Daily revenue logger (cron-friendly)
  bulk-checkouts.sh    # Generate checkout links for all products
  past-due-alert.sh    # Alert on past-due subscriptions
mcp-configs/           # Ready-to-paste AI agent configs
  claude-code.json     # For Claude Code / Claude Desktop
  cursor.json          # For Cursor
skill/                 # Claude Code skill
  SKILL.md             # Full Creem CLI command reference
article.md             # dev.to article source
demo-script.sh         # Video demo script
```

## Quick Start

```bash
# Install Creem CLI
brew tap armitage-labs/creem && brew install creem
creem login --api-key creem_test_xxx

# Clone this toolkit
git clone https://github.com/malakhov-dmitrii/creem-cli-toolkit
cd creem-cli-toolkit

# Run any script
chmod +x scripts/*.sh
./scripts/mrr.sh          # $125
./scripts/sub-health.sh   # active: 5, trialing: 0, ...
./scripts/pricing-table.sh # Name  Price  Billing
```

## MCP Setup (AI Agent)

Copy the config for your AI client:

**Claude Code / Claude Desktop:**
```bash
cat mcp-configs/claude-code.json
# Add to ~/.claude/settings.json or claude_desktop_config.json
```

**Cursor:**
```bash
cp mcp-configs/cursor.json .cursor/mcp.json
```

Replace `YOUR_CREEM_API_KEY` with your actual key. 22 MCP tools available.

## Claude Code Skill

Install the skill for CLI command reference in Claude Code:

```bash
cp skill/SKILL.md ~/.claude/skills/creem-cli/SKILL.md
```

## Article & Video

- [Read the tutorial](https://dev.to/hennessy811/3-ways-to-control-your-saas-payments-without-opening-a-dashboard)
- [Watch the demo](https://youtube.com/watch?v=PLACEHOLDER)

## License

MIT

**Bounty:** 05 — CREEM CLI as Developer Power Tool

**What it is:**
Video + article covering three levels of terminal-based SaaS management with Creem: direct CLI commands, `--json | jq` pipeline scripting, and AI agent integration via MCP server.

**Article:** https://dev.to/hennessy811/3-ways-to-control-your-saas-payments-without-opening-a-dashboard-20o2
**Video:** https://youtu.be/td6hwGfLvxQ

**What's covered:**
- Install & config (`brew tap/install`, `creem login`, environment switching)
- Direct commands for products, subscriptions, customers, transactions, discounts
- Interactive TUI mode (j/k navigation, search, detail view)
- Full subscription lifecycle (pause, resume, cancel, immediate cancel)
- Checkout link generation piped to clipboard
- 10+ `--json | jq` recipes: MRR calculation, revenue by product, customers by country, sub count by status, bulk checkout generation, daily revenue cron, high-value transaction filter, pricing table export
- AI agent via MCP server — 24 tools for Claude/Cursor (full tool list included)
- MCP-only features: `stats-get-metrics-summary` (revenue trends, time-series), `discounts-create`
- Migration from Lemon Squeezy (`creem migrate` with --dry-run, --json, --exclude-discounts)
- Comparison table: CLI vs jq pipelines vs MCP agent

**Key angle:** Three levels of power — commands for quick ops, pipes for automation, AI for natural language. No demo app required, zero setup beyond `brew install creem`.

Built with: Creem CLI v0.1.3, Creem MCP Server (npm creem v1.4.4), jq, Claude Code

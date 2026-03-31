# Video Script — Creem CLI Power Tool (10-12 min)

Setup before recording:
- Terminal: dark theme, font 16pt+, clean prompt
- Split terminal ready (Cmd+D in iTerm)
- `creem whoami` should work (already logged in)
- Tab with Claude Code open (MCP creem connected)
- Close all other apps, notifications off

---

## INTRO (0:00 — 0:30)

**[Screen: terminal, empty]**

SAY:
> "Creem has a CLI that most people don't know about. But if you're running a SaaS on Creem, the CLI turns your terminal into a full payments control center. I'm going to show you three levels of power — direct commands, jq pipelines for automation, and an MCP server that lets Claude manage your store."

TYPE:
```
creem --version
creem whoami
```

---

## PART 1: Direct Commands (0:30 — 2:30)

**[Screen: terminal]**

SAY:
> "Level one — direct commands. Every resource is a subcommand."

TYPE:
```
creem products list
```

SAY:
> "Table view by default. Six products — starter, pro, enterprise, lifetime, and a couple of custom ones."

TYPE:
```
creem subs list --status active
```

SAY:
> "Five active subscriptions. You can filter by any status — active, trialing, past_due, paused, canceled."

TYPE:
```
creem customers list
```

SAY:
> "Four customers. Now let me show you the interactive mode — just run the command without a subcommand."

TYPE:
```
creem products
```

**[Navigate with j/k, select a product with Enter, show details, press q to exit]**

SAY:
> "j and k to scroll, Enter to view details, q to go back. Keyboard-driven, no mouse needed."

TYPE:
```
creem checkouts create --product prod_1CqUBve5mBwFXcE9i02GJw --success-url "https://example.com/thanks"
```

SAY:
> "Checkout link created. You'd normally pipe this to the clipboard but let me show you that in level two."

---

## PART 2: jq Pipelines (2:30 — 5:30)

SAY:
> "Level two — every command supports --json. Pipe through jq and you get instant analytics."

**MRR:**

TYPE:
```
creem subs list --status active --json | jq '[.items[] | .product.price] | add / 100'
```

SAY:
> "125 dollars MRR. One line, real-time from the API. Let me show a few more."

**Pricing table:**

TYPE:
```
creem products list --json | jq -r '.items[] | [.name, "$\(.price/100)", .billingPeriod] | @tsv'
```

SAY:
> "Product pricing as a tab-separated table. Paste it into a spreadsheet or pipe it anywhere."

**Customers by country:**

TYPE:
```
creem customers list --json | jq '[.items[] | .country] | group_by(.) | map({country: .[0], count: length}) | sort_by(-.count)'
```

SAY:
> "Customers grouped by country. Three from Serbia, one from the US."

**Subscription health:**

TYPE:
```
for status in active trialing past_due paused canceled; do COUNT=$(creem subs list --status $status --json | jq '.items | length'); echo "$status: $COUNT"; done
```

SAY:
> "Subscription health check — count by every status in one command. You can throw this in a cron job."

**Checkout link to clipboard:**

TYPE:
```
creem checkouts create --product prod_1CqUBve5mBwFXcE9i02GJw --success-url "https://example.com/thanks" --json | jq -r '.checkoutUrl' | pbcopy
```

SAY:
> "Checkout URL piped straight to clipboard. Now I can paste it in Slack, email, wherever."

**Show the toolkit repo:**

TYPE:
```
ls scripts/
```

SAY:
> "I packaged all of these as ready-to-use scripts in the toolkit repo. MRR calculation, revenue by product, sub health, checkout links, daily revenue cron, past-due alerts — all copy-paste ready."

---

## PART 3: Migration (5:30 — 6:30)

SAY:
> "Quick bonus — if you're migrating from Lemon Squeezy, one command."

TYPE:
```
creem migrate lemon-squeezy --help
```

SAY:
> "Interactive wizard, or dry-run to preview, or export the plan as JSON. You can even exclude discounts. Nobody else covered this."

---

## PART 4: MCP Server + AI Agent (6:30 — 9:30)

SAY:
> "Level three — this is the real power. Creem ships an MCP server with 22 tools. That means Claude, Cursor, or any MCP client can manage your store through natural language."

**Show the config:**

TYPE:
```
cat mcp-configs/claude-code.json
```

SAY:
> "This is the config. Copy it into your Claude Code settings, replace the API key, and you're connected. I have configs for Cursor too."

**Switch to Claude Code with MCP connected:**

SAY:
> "I've already got it connected. Let me ask Claude to do some work."

**Type in Claude Code chat:**
```
Show me all active subscriptions and calculate the total MRR
```

**[Wait for Claude to call MCP tools and respond]**

SAY:
> "Claude called subscriptions-search, got the data, and calculated MRR. No scripting needed — natural language to real API calls."

**Type in Claude Code:**
```
Create a checkout link for the Pro plan with success URL https://myapp.com/thanks
```

**[Wait for response]**

SAY:
> "Checkout created through MCP. Claude used the checkouts-create tool. The MCP server also has tools the CLI doesn't — like discounts-create, licenses-activate, and subscriptions-upgrade. Twenty-two tools total, all calling the Creem SDK directly — not shelling out to the CLI."

**Show the skill:**

TYPE (back in terminal):
```
cat skill/SKILL.md | head -30
```

SAY:
> "I also made a Claude Code skill with the full command reference — install it and Claude knows every flag, every pattern, including the safety rules around minor units and test mode."

---

## PART 5: Comparison + Outro (9:30 — 10:30)

SAY:
> "So three levels. CLI commands for quick lookups. jq pipelines for automation and scripting. MCP for natural language and AI workflows. They're complementary — use each where it's strongest."

SAY:
> "Everything I showed is in the toolkit repo — nine scripts, MCP configs for Claude and Cursor, a Claude Code skill, and the full article on dev.to. Links in the description."

SAY:
> "If you're building on Creem, give it a try. Star the repo if it's useful."

**[Show repo URL in terminal:]**

TYPE:
```
echo "https://github.com/malakhov-dmitrii/creem-cli-toolkit"
```

SAY:
> "Thanks for watching."

---

## Post-recording checklist:
- [ ] Upload to YouTube (title: "3 Ways to Control Your SaaS Payments From Terminal — Creem CLI Power Tool")
- [ ] Description: repo link, article link, timestamps
- [ ] Give me the YouTube link to update README + Discord

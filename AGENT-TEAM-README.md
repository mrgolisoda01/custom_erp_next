# ERPNext 7-Agent Delivery Team for Claude Code

Seven specialised Claude Code subagents that take a requirement from a Claude artifact all the way to a live ERPNext deployment — with human checkpoints where they matter.

| # | Agent | What it does |
|---|---|---|
| 1 | `erpnext-analyser` | Read-only impact analysis of ERPNext / Frappe for each task, recommends the "ERPNext way" |
| 2 | `senior-developer` | Maps the entire codebase first, then implements in the custom app; fixes defects |
| 3 | `senior-tester` | No-compromise QA: functional, negative, boundary, roles, docstatus, ledgers, regression, migration |
| 4 | `delivery-documenter` | Release notes, user guide, technical doc, change log, traceability matrix, handover checklist |
| 5 | `senior-devops` | Staging → UAT → production with backup, maintenance mode, smoke tests, rollback |
| 6 | `requirements-analyst` | Turns Claude artifacts into a spec; every doubt becomes a question for you |
| 7 | `planner-scheduler` | Runs only on your approved Agent 6 spec; splits into tasks, schedules, restarts the cycle |

## Important: how Claude Code subagents actually work
Subagents cannot call each other and cannot talk to you directly. So the **main Claude Code session is the orchestrator**: `CLAUDE.md` tells it the order, the hard gates, and that only it asks you questions. The slash commands below drive each stage.

## Setup (10 minutes)
1. Copy everything in this folder (including the hidden `.claude/` folder and `.gitignore`) into the root of your ERPNext **custom app repo** — the folder you open Claude Code in. If a `CLAUDE.md` already exists there, append this one to it.
2. Fill in `workflow/project-config.md` — especially the **bench command prefix** (bench runs on Linux; on Windows that usually means WSL, Docker, or SSH to a dev server).
3. `cp workflow/environments.env.example workflow/environments.env` and fill in staging / production hosts. Make sure `ssh <host> "bench version"` works without a password.
4. Start Claude Code in that folder and run `/agents` — you should see all 7 agents listed.
5. On Windows, `scripts/deploy.sh` runs in Git Bash (which Claude Code uses) or WSL.

## Daily use
```
/intake requirements/inbox/my-artifact.html   Agent 6 → questions to you → you approve → Agent 7 plans
/build REQ-001                                Agents 1 → (your OK) → 2 → 3, rework loop max 3 rounds
/document REQ-001                             Agent 4
/deploy staging REQ-001                       Agent 5 → you do UAT
/deploy production REQ-001                    you approve → Agent 5 goes live → Agent 7 picks next REQ
/status [REQ-001]                             board view
/pipeline requirements/inbox/my-artifact.html all of the above, stopping at every human gate
```

## Where you stay in control
- Agent 6 never guesses — unanswered questions block planning.
- Agent 7 refuses to run until you approve the spec.
- No code is written until you OK the analyser's approach and scope for each task.
- A task is done only on a tester PASS with evidence; 3 failed rounds escalates to you.
- Production needs your explicit "Approve now" in chat; `.claude/settings.json` also asks before `git push` and the production deploy command, and blocks force-push / drop-site.

## Files
```
CLAUDE.md                      orchestrator rules and hard gates
.claude/agents/*.md            the 7 agents
.claude/commands/*.md          /intake /plan /build /document /deploy /pipeline /status
.claude/settings.json          permission guardrails
workflow/project-config.md     your stack, sites, branches, roles   ← fill in
workflow/environments.env      deploy hosts (not committed)        ← fill in
workflow/BOARD.md              live status board
scripts/deploy.sh              bench-over-SSH deploy with backup + approval check
requirements/inbox/            drop Claude artifacts here
work/<REQ-ID>/                 everything produced per requirement
```

## Tuning
- Model per agent: change `model: inherit` in an agent file to `opus` (deeper reasoning, e.g. developer/tester) or `sonnet` / `haiku` (cheaper, e.g. documenter).
- Using frappe_docker or Frappe Cloud? Set the deploy method in `project-config.md`; the DevOps agent follows that instead of `deploy.sh`.

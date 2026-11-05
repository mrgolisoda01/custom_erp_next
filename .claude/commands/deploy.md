---
description: Agent 5 - deploy a requirement to staging or production
argument-hint: <staging|production> <REQ-ID>
---
Target environment: $1. Requirement: $2.

**staging**
1. Check that `work/$2/docs/deployment-notes.md` exists (gate G4). If not, stop and suggest `/document $2`.
2. Invoke **senior-devops** for staging.
3. Show me the result from `work/$2/deploy/staging.md` and the UAT checklist from `work/$2/docs/handover-checklist.md`. Ask me to do UAT and tell you when it is signed off.

**production**
1. Check that `work/$2/deploy/staging.md` shows STAGING-OK. If not, stop.
2. Ask me with AskUserQuestion: "Deploy $2 to PRODUCTION now?" — show the tag, backup plan, expected downtime and rollback plan. Options: Approve now / Not yet.
3. Only if I choose Approve now: ask me the maintenance window if not already known, then create `workflow/approvals/$2.production.approved` containing my answer, the date / time and the maintenance window. Never create this file without my explicit approval in this chat.
4. Invoke **senior-devops** for production. Show me the result from `work/$2/deploy/production.md`.
5. On success, invoke **planner-scheduler** to close $2 and report the next APPROVED requirement in the queue.

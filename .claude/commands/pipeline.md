---
description: Run the whole 7-agent cycle for one requirement, stopping only at human gates
argument-hint: <source file(s) in requirements/inbox | REQ-ID>
---
Run the full delivery cycle for: $ARGUMENTS

Follow `CLAUDE.md` exactly, including every hard gate (G1–G7):
1. Intake (Agent 6) as in `/intake` — clarify with me until READY-FOR-APPROVAL, then get my approval. Skip if the REQ is already APPROVED.
2. Plan (Agent 7) as in `/plan`.
3. Build loop (Agents 1 → 2 → 3) as in `/build`, with my OK on each task's approach before coding.
4. Documentation (Agent 4) as in `/document`.
5. Staging (Agent 5) as in `/deploy staging`, then wait for my UAT sign-off.
6. Production (Agent 5) as in `/deploy production` — only after my explicit approval.
7. Agent 7 closes the REQ and reports the next approved requirement; ask me whether to start it.

At every human gate, stop and wait. Between gates, give me one line per step.

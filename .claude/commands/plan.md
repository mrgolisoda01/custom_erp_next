---
description: Agent 7 - plan and schedule an APPROVED requirement
argument-hint: <REQ-ID>
---
Invoke **planner-scheduler** for $1.

- If it returns `BLOCKED`, show me the reason and stop (suggest `/intake $1` to finish clarification).
- Otherwise read `work/$1/plan.md`, show me the task table, the execution order and the risks, and ask whether to start `/build $1`.

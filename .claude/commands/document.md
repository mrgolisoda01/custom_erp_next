---
description: Agent 4 - produce the full delivery documentation for a requirement
argument-hint: <REQ-ID>
---
Invoke **delivery-documenter** for $1.

- If it returns `BLOCKED`, show me which tasks are not passed and stop.
- If it reports DOC-GAP items, show them to me and ask how to resolve each one before continuing.
- Otherwise list the files created in `work/$1/docs/`, show anything I must supply (screenshots, sign-off names), update `workflow/BOARD.md`, and suggest `/deploy staging $1`.

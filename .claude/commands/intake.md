---
description: Agent 6 - gather a new requirement from Claude artifacts or files and clarify every doubt with you
argument-hint: <file(s) in requirements/inbox, or pasted text> [REQ-ID to continue]
---
Run the requirement intake loop for: $ARGUMENTS

1. If no source was given, list the files in `requirements/inbox/` and ask me which ones to use (AskUserQuestion). If I pasted text, first save it to `requirements/inbox/<YYYY-MM-DD>-pasted.md`.
2. Invoke the **requirements-analyst** subagent with the source paths and the REQ-ID (if continuing an existing one).
3. Read `work/<REQ-ID>/questions.md`. Ask me the OPEN questions with AskUserQuestion — max 4 per round, using the analyst's options (I can always type my own answer). Never answer on my behalf.
4. Pass my exact answers back to **requirements-analyst**. Repeat steps 2–4 until `requirement.md` shows `Status: READY-FOR-APPROVAL`.
5. Show me a short summary: goal, FR count, the AC list, out of scope. Ask: "Approve <REQ-ID> for planning?" with options Approve / Request changes.
6. Only if I choose Approve: set `Status: APPROVED` in `requirement.md`, add "Approved by human on <date>" to its revision history, update `workflow/BOARD.md`, then invoke **planner-scheduler** for this REQ.
7. Show me the task table and execution order from `plan.md` and ask whether to start `/build <REQ-ID>`.

---
description: Run the analyse, develop, test loop (Agents 1, 2, 3) for the tasks of a requirement
argument-hint: <REQ-ID> [task e.g. T2]
---
Execute the tasks of $1 in the order written in `work/$1/plan.md` (only task $2 if given). Stop if `plan.md` does not exist — suggest `/plan $1`.

For each task that is not DONE:
1. **erpnext-analyser** → `tasks/<Tn>-analysis.md`. If it returns open questions or BLOCKED, ask me (AskUserQuestion), pass my exact answers back, re-run.
2. Show me a short summary: approach chosen, files to be touched, risk. **Wait for my OK** before any code change. If I ask for changes, re-run the analyser with my feedback.
3. **senior-developer** → if it returns `NEEDS-CLARIFICATION`, ask me and re-run with my answers.
4. **senior-tester** → read the verdict in `tasks/<Tn>-test.md`:
   - PASS → task DONE, move to the next task.
   - FAIL → send the test report path to **senior-developer** to fix all defects, then **senior-tester** again. Maximum 3 rework rounds; on the next failure stop and escalate to me with the open defect list.
   - BLOCKED → tell me exactly what is needed.
5. After each task, update `workflow/BOARD.md` and tell me one line: task, verdict, rounds.

When all tasks are DONE, say so and suggest `/document $1`.

# Project Config — fill this in before the first run

Every agent reads this file. Replace each `<...>` value. Leave a line as `UNKNOWN` if you don't know yet — agents will ask instead of guessing.

## Stack

- ERPNext version: 16.37.0 (branch `version-16`, commit af63cde) — verified on the WSL bench on 05-11-2026
- Frappe version: 16.36.1 (branch `version-16`, commit 97a5dd9) — verified on 05-11-2026
- Custom app name: safc_custom_erp
- Custom app git repo: https://github.com/mrgolisoda01/custom_erp_next.git
- Custom app status: CREATED on 05-11-2026 with `bench new-app` (v0.0.1, branch `develop`), installed on `erp.localhost`. Lives at `/home/dev/frappe-bench/apps/safc_custom_erp` in WSL. Local branches `develop`, `staging`, `main`; remote `origin` points at the repo above. Pushed to GitHub on 05-11-2026; `develop` is the default branch. Repo is PUBLIC.
- Python version on bench: 3.14.7 (`~/frappe-bench/env/bin/python` in WSL). Windows has 3.14.8 but the bench never uses it.
- Node version on bench: v22.22.1
- Test base class: `from frappe.tests import IntegrationTestCase` (and `UnitTestCase`) — import verified on this bench on 05-11-2026

## Where bench runs (how agents execute bench commands)

- Bench command prefix: when Claude Code runs INSIDE WSL (recommended, open it in the app folder): `cd ~/frappe-bench && bench ...`. When Claude Code runs on Windows: `wsl -d Ubuntu -- bash -lc "cd ~/frappe-bench && bench ..."`. Node comes from nvm (v24.21.0, with yarn); `~/.profile` loads nvm so login and tool shells can run `bench build`. Docker Desktop and the frappe_docker clone at `E:/sabari/ERP/frappe_docker` are NOT used.
- Local bench path: `/home/dev/frappe-bench` inside WSL Ubuntu (Linux user `dev`; from Windows Explorer `//wsl.localhost/Ubuntu/home/dev/frappe-bench`). The agent team now lives inside the app repo at `apps/safc_custom_erp`; the copy under `E:/sabari/ERP_Custom_Agents` is the original export and no longer the working copy.
- Dev site (developer works here): erp.localhost (decided by Sabari-dev on 05-11-2026). Apps installed 05-11-2026 to mirror production: frappe 16.36.1, erpnext 16.37.0, hrms 16.53.1, india_compliance 16.11.0, safc_custom_erp. Production runs slightly older hrms (16.20.1) and india_compliance (16.10.0); same major version.
- Bench services: `bench migrate`, `install-app` and tests need Redis (ports 11000 queue, 13000 cache) and MariaDB running. Before a build session run `cd ~/frappe-bench && bench start` in a separate WSL terminal, or at minimum `redis-server config/redis_queue.conf --daemonize yes` and the same for `redis_cache.conf`. A `Connection refused ... :11000` error means this was skipped.
- Test site (tester works here): erp.localhost — same site as dev (decided 05-11-2026)

## Branches

- Integration branch (features merge here): develop
- Staging branch: staging
- Production branch: main
- Merge method: PR review on GitHub — the developer pushes `feature/<REQ-ID>-<Tn>-<name>` and opens a PR to `develop`; Sabari-dev reviews and merges (decided 05-11-2026)

## Environments

- Deploy method: NOT SET UP YET (decided 05-11-2026). Production is Frappe Cloud, so the eventual method is frappe-cloud: the partner must add the `safc_custom_erp` GitHub repo to the site's bench group once, then each release is a push to `main` plus a deploy from the Frappe Cloud dashboard. Staging = a Frappe Cloud staging site or none. — no staging or production server exists. Agents stop after `/document`; `/deploy` must not be run until this line names a method (bench-over-ssh | docker | frappe-cloud | manual) and `workflow/environments.env` is filled in.
- Staging URL: UNKNOWN — typed as https://staging.erp_safc.com but an underscore is not a valid hostname and it does not resolve (checked 05-11-2026); `staging.safc.com` does resolve. Fix when the server exists.
- Production URL: UNKNOWN — intended https://erp.safc.com, does not resolve in public DNS as of 05-11-2026. Fix when the server exists.
- Hosts, paths and sites for deploy.sh live in `workflow/environments.env` (never commit that file).
- Production test-data rule: smoke tests are read-only; any test document must be created in company "TEST CO" and cancelled
- Default maintenance window: after 9 PM IST

## Business context

- Companies in ERPNext: 88 companies (franchise model). Default company: Mr.GoliSoda. SOUTH ASIAN FOODS CORPORATION (SAFC) is one of them. Verified on the live site 05-11-2026.
- Key roles: Sales User, Sales Manager, Accounts User, Stock User, plus 13 custom roles on the live site (Finance Manager, Finance Team, Operation Head, State Head, Store Incharge, Purchase Manager (Goli Soda), Logistics & Warehouse Manager, HR Manager(Golisoda), Senior HR Executive, Senior MIS Executive, Expense Creator, Employee Self Service, Technicians)
- Language / locale: English, INR, Asia/Kolkata, DD-MM-YYYY
- GST / tax rules that always apply: `UNKNOWN`

## Live production site (read-only inventory taken 05-11-2026)

- URL: https://golisoda.m.frappe.cloud — Frappe Cloud, partner-hosted. Dashboard login (cloud.frappe.io) is held by the partner.
- Apps: frappe 16.36.1, erpnext 16.37.0, india_compliance 16.10.0, hrms 16.20.1, frappe_assistant_core 3.0.0, golisoda 0.0.1, franchise_agreement 0.0.1.
- Existing custom apps: `golisoda` (modules: golisoda, Collection Management, Franchise Daily Profit) and `franchise_agreement`. Their git repos are connected to the Frappe Cloud bench; access to those repos is PENDING (ask the partner). DECIDED 05-11-2026 (Sabari-dev): Option B — all new work goes into `safc_custom_erp` as a separate app. Agents treat `golisoda` and `franchise_agreement` as read-only black boxes: never modify them; integrate through hooks, custom fields and APIs only; when a requirement needs a change inside them, flag it as BLOCKED for the partner.
- Hand-made customisations not in any app: ~413 Custom Fields without module, 427 Property Setters, 7 Client Scripts, 6 Server Scripts (Item Sync, Sales Invoice Sync, Stock Entry Sync are the Yolo integration), 6 Print Formats, 2 Workflows (Purchase Order active, Expense Claim inactive), 13 custom Roles. Candidates for export as fixtures.
- Data volume: 9,132 Sales Invoices, 2,207 Sales Orders, 1,358 Purchase Orders, 948 Purchase Invoices, 1,442 Customers, 658 Items, 446 Warehouses, 185 Employees, 88 Companies.
- Backup for the dev site: not downloadable from the desk Backups page; needs the Frappe Cloud dashboard (database backup + backup encryption key). PENDING from the partner.
- Rule: everything on this site is read-only for agents; no document is created, changed or cancelled there.

## Coding standards

- Linters / formatters: pre-commit with ruff, eslint and prettier, as generated by `bench new-app` in `.pre-commit-config.yaml` (run `pre-commit install` once in the app folder)
- Commit message format: `<REQ-ID> <Tn>: <what>`
- Anything else the team always follows: `UNKNOWN`

## Human contacts

- Requirement approver: Sabari-dev
- UAT sign-off: Sabari-dev
- Production approver: Sabari-dev

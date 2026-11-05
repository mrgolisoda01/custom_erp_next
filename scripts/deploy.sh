#!/usr/bin/env bash
# Usage: bash scripts/deploy.sh <staging|production> <REQ-ID>
# Deploys the custom app to a Frappe Bench over SSH.
# Settings come from workflow/environments.env (copy from environments.env.example).
set -euo pipefail

ENVIRONMENT="${1:-}"
REQ_ID="${2:-}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ENV_FILE="$ROOT/workflow/environments.env"
LOG_FILE="$ROOT/workflow/deployments.log"

die() { echo "ERROR: $*" >&2; exit 1; }
now() { date +%Y-%m-%d_%H:%M:%S; }

[[ "$ENVIRONMENT" == "staging" || "$ENVIRONMENT" == "production" ]] || die "first argument must be staging or production"
[[ "$REQ_ID" =~ ^REQ-[0-9]+$ ]] || die "second argument must be a REQ-ID such as REQ-001"
[[ -f "$ENV_FILE" ]] || die "missing $ENV_FILE (copy workflow/environments.env.example and fill it in)"
# shellcheck disable=SC1090
source "$ENV_FILE"

if [[ "$ENVIRONMENT" == "staging" ]]; then
  SSH_TARGET="$STAGING_SSH"; BENCH_PATH="$STAGING_BENCH_PATH"; SITE="$STAGING_SITE"; BRANCH="$STAGING_BRANCH"
else
  APPROVAL="$ROOT/workflow/approvals/${REQ_ID}.production.approved"
  [[ -f "$APPROVAL" ]] || die "no production approval file: $APPROVAL"
  [[ -f "$ROOT/work/$REQ_ID/deploy/staging.md" ]] || die "no staging record for $REQ_ID - deploy to staging first"
  SSH_TARGET="$PROD_SSH"; BENCH_PATH="$PROD_BENCH_PATH"; SITE="$PROD_SITE"; BRANCH="$PROD_BRANCH"
fi

trap 'echo "[$(now)] FAILED $ENVIRONMENT $REQ_ID - check output above; site may still be in maintenance mode" | tee -a "$LOG_FILE"' ERR

echo "[$(now)] START $ENVIRONMENT $REQ_ID branch=$BRANCH site=$SITE" | tee -a "$LOG_FILE"

ssh "$SSH_TARGET" bash -s -- "$BENCH_PATH" "$SITE" "$APP_NAME" "$BRANCH" <<'REMOTE' 2>&1 | tee -a "$LOG_FILE"
set -euo pipefail
BENCH_PATH="$1"; SITE="$2"; APP="$3"; BRANCH="$4"
cd "$BENCH_PATH"

echo "== commit before deploy (rollback point)"
git -C "apps/$APP" rev-parse HEAD

echo "== backup with files"
bench --site "$SITE" backup --with-files
ls -lt "sites/$SITE/private/backups" | head -n 5

echo "== pull $BRANCH"
git -C "apps/$APP" fetch origin
git -C "apps/$APP" checkout "$BRANCH"
git -C "apps/$APP" pull --ff-only origin "$BRANCH"
echo "deployed commit: $(git -C "apps/$APP" rev-parse HEAD)"

echo "== maintenance mode on"
bench --site "$SITE" set-maintenance-mode on

echo "== migrate"
bench --site "$SITE" migrate

echo "== build"
bench build --app "$APP"
bench --site "$SITE" clear-cache

echo "== maintenance mode off"
bench --site "$SITE" set-maintenance-mode off

echo "== restart"
bench restart

echo "== done"
REMOTE

echo "[$(now)] END $ENVIRONMENT $REQ_ID OK" | tee -a "$LOG_FILE"

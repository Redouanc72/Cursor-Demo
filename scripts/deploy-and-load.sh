#!/usr/bin/env bash
# =============================================================================
# Lunar Basecamp Outfitters — Deploy and Load Script
# =============================================================================
# Deploys all metadata to a scratch org, loads sample data, and assigns
# the Lunar_Basecamp_Admin permission set.
#
# Usage:
#   ./scripts/deploy-and-load.sh [scratch-org-alias]
#   ORG_ALIAS=my-org ./scripts/deploy-and-load.sh
#
# Default org: Cursor Demo (if no alias provided)
# =============================================================================

set -e

# Configuration
ORG_ALIAS="${1:-${ORG_ALIAS:-Cursor Demo}}"
SOURCE_PATH="force-app/main/default"
DATA_PLAN="data/sample-data-plan.json"
PERMSET_NAME="Lunar_Basecamp_Admin"
DEPLOY_WAIT=10

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info()  { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn()  { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Change to project root (script may be run from any directory)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$PROJECT_ROOT"

echo "============================================================================="
echo "  Lunar Basecamp Outfitters — Deploy and Load"
echo "============================================================================="
echo "  Org Alias:    $ORG_ALIAS"
echo "  Source Path:  $SOURCE_PATH"
echo "  Data Plan:    $DATA_PLAN"
echo "============================================================================="
echo ""

# -----------------------------------------------------------------------------
# Step 1: Verify target org exists and is accessible
# -----------------------------------------------------------------------------
log_info "Step 1: Verifying target org..."
if ! sf org display -o "$ORG_ALIAS" &>/dev/null; then
    log_error "Org '$ORG_ALIAS' not found or not authorized."
    log_error "Run: sf org list"
    exit 1
fi
log_info "Org verified. Proceeding with deployment."
echo ""

# -----------------------------------------------------------------------------
# Step 2: Deploy metadata
# -----------------------------------------------------------------------------
log_info "Step 2: Deploying metadata to $ORG_ALIAS..."
if sf project deploy start -d "$SOURCE_PATH" -o "$ORG_ALIAS" --wait "$DEPLOY_WAIT"; then
    log_info "Deployment completed successfully."
else
    DEPLOY_EXIT=$?
    log_error "Deployment FAILED (exit code: $DEPLOY_EXIT)"
    log_error "Fix deployment errors before proceeding. No rollback performed."
    log_error "Run: sf project deploy start -d $SOURCE_PATH -o $ORG_ALIAS --wait $DEPLOY_WAIT"
    exit $DEPLOY_EXIT
fi
echo ""

# -----------------------------------------------------------------------------
# Step 3: Load sample data (optional — continues on failure)
# -----------------------------------------------------------------------------
log_info "Step 3: Loading sample data..."
if [[ ! -f "$DATA_PLAN" ]]; then
    log_warn "Data plan not found: $DATA_PLAN"
    log_warn "Skipping data load. Use scripts/apex/createLunarDemoData.apex for sample data."
else
    if sf data import tree --plan "$DATA_PLAN" -o "$ORG_ALIAS"; then
        log_info "Sample data loaded successfully."
    else
        DATA_EXIT=$?
        log_warn "Data import failed (exit code: $DATA_EXIT)"
        log_warn "Metadata was deployed successfully. You can:"
        log_warn "  - Fix data files and re-run: sf data import tree --plan $DATA_PLAN -o $ORG_ALIAS"
        log_warn "  - Or use Apex: sf apex run --file scripts/apex/createLunarDemoData.apex -o $ORG_ALIAS"
        log_warn "Continuing to permission set assignment..."
    fi
fi
echo ""

# -----------------------------------------------------------------------------
# Step 4: Assign permission set
# -----------------------------------------------------------------------------
log_info "Step 4: Assigning permission set $PERMSET_NAME to current user..."
if sf org assign permset -n "$PERMSET_NAME" -o "$ORG_ALIAS"; then
    log_info "Permission set assigned successfully."
else
    PERMSET_EXIT=$?
    log_error "Permission set assignment FAILED (exit code: $PERMSET_EXIT)"
    log_error "Ensure the permission set exists and you have access."
    log_error "Run manually: sf org assign permset -n $PERMSET_NAME -o $ORG_ALIAS"
    exit $PERMSET_EXIT
fi
echo ""

# -----------------------------------------------------------------------------
# Success summary
# -----------------------------------------------------------------------------
echo "============================================================================="
echo -e "  ${GREEN}Deployment complete.${NC}"
echo "============================================================================="
echo "  Next steps:"
echo "    1. Activate the Pre_Expedition_Safety_Check flow (Setup → Flows)"
echo "    2. Open org: sf org open -o $ORG_ALIAS"
echo "    3. If data load was skipped, run: sf apex run --file scripts/apex/createLunarDemoData.apex -o $ORG_ALIAS"
echo "============================================================================="

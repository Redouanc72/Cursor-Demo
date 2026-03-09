# Lunar Basecamp Outfitters — Salesforce DX Project

Salesforce implementation for **Lunar Basecamp Outfitters**, managing lunar hiking expeditions, gear inventory, and explorer certifications.

## Project Overview

This org includes:

- **Custom objects**: Lunar Explorer, Gear Item, Expedition Booking, Safety Certification, and Expedition Gear (junction)
- **Flows**: Pre-Expedition Safety Check (record-triggered when booking status → Confirmed)
- **Permission sets**: Lunar Basecamp Admin, Lunar Basecamp Outfitters Full Access
- **LWC**: Mission Control dashboard (`lunarExpeditionDashboard`) — expedition cards, map, charts, auto-refresh
- **Sample data**: Scripts and data plan for tree import

## Prerequisites

- [Salesforce CLI](https://developer.salesforce.com/tools/sfdxcli) (sf) v2
- Authorized Dev Hub and target org (scratch org or sandbox)

## Setup: Scratch Org Creation

1. **Create a scratch org** (from project root):

   ```bash
   sf org create scratch -f config/project-scratch-def.json -a lunar-basecamp -d 30
   ```

2. **Deploy and load** (metadata, sample data, permission set):

   ```bash
   ./scripts/deploy-and-load.sh lunar-basecamp
   ```

   Or with default alias (e.g. `Cursor Demo`):

   ```bash
   ./scripts/deploy-and-load.sh
   ```

3. **Open the org**:

   ```bash
   sf org open -o lunar-basecamp
   ```

4. **Activate the Pre-Expedition Safety Check flow** in Setup → Flows, then add the **Mission Control** LWC to an App or Home page via Lightning App Builder.

## Deployment Steps

### Deploy metadata only

```bash
sf project deploy start -d force-app/main/default -o <alias> --wait 10
```

### Load sample data (after deploy)

```bash
sf data import tree --plan data/sample-data-plan.json -o <alias>
```

### Assign permission set

```bash
sf org assign permset -n Lunar_Basecamp_Admin -o <alias>
```

### One-shot: deploy + data + permset

```bash
./scripts/deploy-and-load.sh <scratch-org-alias>
```

## Git and GitHub

This project is a Git repository with an initial commit. `.gitignore` excludes `.sfdx/`, `.sf/`, `.vscode/`, `node_modules/`, `coverage/`, `.DS_Store`, `*.log`, `.localdevserver/`, and scratch org config overrides.

### Push to GitHub

1. **Create a new repository on GitHub**
   - Name: `lunar-basecamp-outfitters-sfdc`
   - Description: `Salesforce implementation for Lunar Basecamp Outfitters - managing lunar hiking expeditions, gear inventory, and explorer certifications`
   - Do **not** initialize with a README (this repo already has one).

2. **Point the remote to your repo** (replace `YOUR_GITHUB_USERNAME` with your GitHub username or org):

   ```bash
   git remote set-url origin https://github.com/YOUR_GITHUB_USERNAME/lunar-basecamp-outfitters-sfdc.git
   ```

3. **Push the main branch**:

   ```bash
   git push -u origin main
   ```

## License

Proprietary — Lunar Basecamp Outfitters.

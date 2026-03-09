# Context Backup — Mon Mar 9, 2026

## Session Summary

### Connected Salesforce Orgs
| Alias | Username | Org ID | Role |
|---|---|---|---|
| 🌳 agentforce *(Default DevHub)* | redouan-agentforce-dx@salesforce.com | 00Dfj000005T1x8EAC | Connected |
| 🍁 Cursor Demo *(Default Org)* | storm.c0d0cf44413371@salesforce.com | 00DWs00000MY2E2MAL | Connected |
| SecurityOrg | storm.b9c645f6514c27@salesforce.com | 00DJ9000002FTI9MAO | Connected |
| Sophie's Grantsmaking Org | redouan.cherkaoui.ab93cde86d@salesforce.com | 00DJ9000002FQICMA4 | Connected |

---

### Apex Test Results — Cursor Demo Org
- **Test Run ID:** 707Ws000018q3zY
- **Total Tests:** 242
- **Passed:** 148 (61%)
- **Failed:** 94 (39%)
- **Outcome:** Failed

#### Failing Test Classes & Root Causes

**1. Unsupported Language — B2B Commerce tests**
- Affected classes: `B2BSyncPricingTest`, `B2BPaymentControllerTest`, and related B2B Commerce classes
- Error: `INVALID_INPUT: The selected language isn't currently supported. Add it to your supported languages`
- Fix: Go to Commerce > Store Settings > Languages and add/activate the default language (English)

**2. Duplicate Username — B2B Featured Products tests**
- Affected class: `B2B_FeaturedProducts_ControllerTest` (10+ methods)
- Error: `DUPLICATE_USERNAME: Duplicate Username`
- Root cause: `B2B_FeaturedProducts_ControllerTestUtils.createUser` hardcodes a username that already exists
- Fix: Make test username unique (e.g. append random suffix or org ID)

#### Passing Test Classes (examples)
- `LightningControllerTest` ✅
- `ExecuteSOQLTest` ✅ (all 14 tests)
- `TriggerHandler_Test` ✅
- `DBM25ControllerTest` ✅
- `MetadataServiceTest` ✅

---

### Java / Apex Language Server Issue
- **Error:** `Unable to activate the Apex Language Server — Unable to locate a Java Runtime`
- **Cause:** Java was not installed (`/usr/local/bin/java` was just a Salesforce internal shim)
- **Fix:** Installed **Azul Zulu JDK 21** via `brew install --cask zulu@21`
- **Status:** JDK installed at `/Library/Java/JavaVirtualMachines/zulu-21.jdk`
- **Remaining step:** Run `java -version` in terminal (will prompt for sudo password once to remove a warning file), then restart Cursor

---

## Workspace
- **Path:** `/Users/redouan.cherkaoui/Agentforce DX/Demos/Cursor Development Org/Cursor Development`
- **Salesforce CLI version:** 2.123.1 (update available: 2.125.2)
- **API Version:** sfdx-project.json in workspace root

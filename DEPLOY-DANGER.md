# ⚠️ DEPLOY WARNING — READ FIRST

## The bug that cost us days

This repo at `/Users/dougbrown/Desktop/Claude/branch-manager/` (remote: `smartlawnny-cloud/branch-manager`) is **NOT** what gets deployed to peekskilltree.com/branchmanager/.

**The actual deploy repo is:**
- Local path: `/Users/dougbrown/Desktop/peekskilltree-deploy/`
- Remote: `smartlawnny-cloud/peekskilltree.com`
- The `/branchmanager/` subfolder there is what gets served.

Until Apr 19 2026 we pushed ~40 commits to this source repo that never reached the deploy repo. Doug saw stale "old yellow box" versions on his phone for days because the deploy copy was frozen at an old commit.

## From now on — one of these, pick ONE

### Option A (current, recommended for speed): work in the deploy repo directly
```bash
cd /Users/dougbrown/Desktop/peekskilltree-deploy/branchmanager
# edit files here
git add -A && git commit -m "..."
git push
```
This source repo becomes reference-only. DON'T edit files here.

### Option B: keep source-of-truth here, auto-sync
Run after every commit in this repo:
```bash
./sync-to-deploy.sh
```
This rsyncs the working tree to `/Users/dougbrown/Desktop/peekskilltree-deploy/branchmanager/` and creates a commit there. Still two pushes — easy to forget.

## Claude: default behavior

In any new session on Branch Manager, FIRST check where the user expects edits to land. If uncertain, edit in `/Users/dougbrown/Desktop/peekskilltree-deploy/branchmanager/` because that's what actually deploys. Only edit this repo if the user explicitly says "source repo."

## Verifying a deploy actually landed

After pushing:
```bash
curl -s "https://peekskilltree.com/branchmanager/version.json?t=$(date +%s)" | head -3
```
Should return JSON with a `version` field matching what you just committed. If 404 or stale, GitHub Pages hasn't rebuilt yet (give it 30-120 sec) or the push went to the wrong repo.

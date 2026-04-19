#!/usr/bin/env bash
# One-shot sync from source branch-manager repo → peekskilltree.com deploy repo.
# Usage:  ./sync-to-deploy.sh "commit message"
set -euo pipefail

MSG="${1:-Sync from source repo}"
SRC="/Users/dougbrown/Desktop/Claude/branch-manager"
DST="/Users/dougbrown/Desktop/peekskilltree-deploy/branchmanager"

if [[ ! -d "$DST" ]]; then
  echo "ERROR: deploy dir not found at $DST"
  exit 1
fi

echo "→ rsyncing $SRC → $DST (excluding .git, .claude, node_modules, Pods)"
rsync -a --delete \
  --exclude='.git' \
  --exclude='.claude' \
  --exclude='node_modules' \
  --exclude='mobile/node_modules' \
  --exclude='ios/App/Pods' \
  --exclude='DEPLOY-DANGER.md' \
  --exclude='sync-to-deploy.sh' \
  "$SRC/" "$DST/"

cd /Users/dougbrown/Desktop/peekskilltree-deploy
if git diff --quiet && git diff --cached --quiet; then
  echo "→ No changes to commit in deploy repo."
  exit 0
fi

echo "→ Committing + pushing deploy repo"
git add -A
git commit -m "$MSG"
git push

echo ""
echo "✓ Done. Verify in ~60s with:"
echo "  curl -s \"https://peekskilltree.com/branchmanager/version.json?t=\$(date +%s)\""

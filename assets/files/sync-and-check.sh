#!/bin/bash
# sync-and-check.sh — Overleaf/Git sync with reference checking
# Usage: ./sync-and-check.sh
# Pulls latest changes from remote, checks references, and pushes only if clean.

# Pull from Overleaf/remote
git pull origin master

# Run check
./check_latex_refs.sh main.tex > ref_check.log

# If clean, push changes
if [ $(grep -c "^  " ref_check.log) -eq 0 ]; then
    git add .
    git commit -m "Update: references checked"
    git push origin master
else
    echo "Unreferenced items found. Fix before pushing."
    cat ref_check.log
fi

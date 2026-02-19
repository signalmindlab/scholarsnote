#!/bin/bash
# latex-pre-commit-hook.sh — Git pre-commit hook for LaTeX reference checking
# Installation: copy this file to .git/hooks/pre-commit and make it executable
#   cp latex-pre-commit-hook.sh .git/hooks/pre-commit
#   chmod +x .git/hooks/pre-commit

# Run check
./check_latex_refs.sh main.tex > ref_check.log

# Count unreferenced items
UNREFERENCED=$(grep -c "^  " ref_check.log)

if [ $UNREFERENCED -gt 0 ]; then
    echo "Warning: $UNREFERENCED unreferenced items found"
    cat ref_check.log

    read -p "Continue commit? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

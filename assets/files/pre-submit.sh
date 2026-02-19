#!/bin/bash
# pre-submit.sh — Pre-submission checklist for LaTeX manuscripts
# Usage: ./pre-submit.sh
# Requires: check_latex_refs.sh in the same directory

echo "Pre-submission Checklist"
echo "========================"

# 1. Reference check
echo "1. Checking references..."
./check_latex_refs.sh manuscript.tex > ref_audit.log

# 2. Count issues
ISSUES=$(grep -c "^  " ref_audit.log)
if [ $ISSUES -eq 0 ]; then
    echo "   No unreferenced items"
else
    echo "   $ISSUES unreferenced items found"
    cat ref_audit.log
fi

# 3. Check compilation
echo "2. Checking compilation..."
pdflatex -interaction=nonstopmode manuscript.tex > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "   Compiles successfully"
else
    echo "   Compilation errors found"
fi

# 4. Check bibliography
echo "3. Checking bibliography..."
bibtex manuscript > /dev/null 2>&1
echo "   Bibliography processed"

echo "========================"
echo "Checklist complete!"

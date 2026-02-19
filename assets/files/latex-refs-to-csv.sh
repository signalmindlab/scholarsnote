#!/bin/bash
# latex-refs-to-csv.sh — Export unreferenced LaTeX items to CSV
# Usage: ./latex-refs-to-csv.sh manuscript.tex
# Requires: check_latex_refs.sh in the same directory

TEXFILE=$1
OUTFILE="${TEXFILE%.tex}_unreferenced.csv"

# Run the check and extract unreferenced items
./check_latex_refs.sh "$TEXFILE" > /tmp/ref_check.log

# Create CSV header
echo "Type,Label" > "$OUTFILE"

# Extract and format
grep "^  tab:" /tmp/ref_check.log | sed 's/^  /table,/' >> "$OUTFILE"
grep "^  fig:" /tmp/ref_check.log | sed 's/^  /figure,/' >> "$OUTFILE"
grep "^  eq:"  /tmp/ref_check.log | sed 's/^  /equation,/' >> "$OUTFILE"
grep "^  sec:" /tmp/ref_check.log | sed 's/^  /section,/' >> "$OUTFILE"

echo "CSV exported to: $OUTFILE"

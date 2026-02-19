#!/bin/bash
# check_latex_refs.sh — LaTeX Reference Checker
# Finds unused labels and missing citations while ignoring commented code.
# Supports: \ref, \autoref, \Autoref, \cref, \Cref, \vref, \pageref,
#           \nameref, \labelcref, \eqref (and multi-key cleveref calls)
# Usage: ./check_latex_refs.sh <latex_file.tex>

if [ $# -eq 0 ]; then
    echo "Usage: $0 <latex_file.tex>"
    exit 1
fi

TEXFILE=$1

if [ ! -f "$TEXFILE" ]; then
    echo "Error: File not found: $TEXFILE"
    exit 1
fi

# ---------------------------------------------------------------------------
# Remove comments in two steps:
#   Step 1: Remove lines that start with % (including leading whitespace)
#   Step 2: Remove inline comments — everything after an unescaped %
# ---------------------------------------------------------------------------
TEXCONTENT=$(grep -v '^\s*%' "$TEXFILE" | sed 's/\([^\\]\)%.*$/\1/')

echo "Checking references in: $TEXFILE"
echo "========================================"

# ---------------------------------------------------------------------------
# Build a unified pattern that matches ALL major reference commands.
# Supported commands:
#   \ref, \autoref, \Autoref, \cref, \Cref, \vref, \pageref,
#   \nameref, \labelcref, \eqref
# Also handles multi-key calls such as \cref{fig:a,fig:b,fig:c}.
# ---------------------------------------------------------------------------
# Extract every label key that appears inside any of these ref commands,
# splitting comma-separated keys (used by cleveref) into individual entries.
ALL_REFS=$(echo "$TEXCONTENT" \
    | grep -oP '\\(auto|Auto|c|C|v|page|name|labelc|eq)?ref\{[^}]+\}' \
    | grep -oP '\{[^}]+\}' \
    | tr -d '{}' \
    | tr ',' '\n' \
    | sed 's/^[[:space:]]*//' \
    | sed 's/[[:space:]]*$//' \
    | grep -v '^$' \
    | awk '!seen[$0]++')

# Helper: extract refs for a given prefix from ALL_REFS
refs_for_prefix() {
    local prefix="$1"
    echo "$ALL_REFS" | grep "^${prefix}:" | sed "s/^${prefix}://" | awk '!seen[$0]++'
}

# ---------------------------------------------------------------------------
# TABLES
# ---------------------------------------------------------------------------
echo -e "\n=== TABLES ==="
TAB_LABELS=$(echo "$TEXCONTENT" | grep -oP '\\label\{tab:\K[^}]+')
TAB_LABELS_UNIQ=$(echo "$TAB_LABELS" | awk '!seen[$0]++')
TAB_REFS=$(refs_for_prefix "tab")
TAB_COUNT=$(echo "$TAB_LABELS_UNIQ" | grep -v '^$' | wc -l)
TABREF_COUNT=$(echo "$TAB_REFS" | grep -v '^$' | wc -l)

echo "Total labels: $TAB_COUNT"
echo "Total refs:   $TABREF_COUNT"
echo "Unreferenced tables:"
while IFS= read -r label; do
    [ -z "$label" ] && continue
    if ! echo "$TAB_REFS" | grep -qx "$label"; then
        echo "  tab:$label"
    fi
done <<< "$TAB_LABELS_UNIQ"

# ---------------------------------------------------------------------------
# FIGURES
# ---------------------------------------------------------------------------
echo -e "\n=== FIGURES ==="
FIG_LABELS=$(echo "$TEXCONTENT" | grep -oP '\\label\{fig:\K[^}]+')
FIG_LABELS_UNIQ=$(echo "$FIG_LABELS" | awk '!seen[$0]++')
FIG_REFS=$(refs_for_prefix "fig")
FIG_COUNT=$(echo "$FIG_LABELS_UNIQ" | grep -v '^$' | wc -l)
FIGREF_COUNT=$(echo "$FIG_REFS" | grep -v '^$' | wc -l)

echo "Total labels: $FIG_COUNT"
echo "Total refs:   $FIGREF_COUNT"
echo "Unreferenced figures:"
while IFS= read -r label; do
    [ -z "$label" ] && continue
    if ! echo "$FIG_REFS" | grep -qx "$label"; then
        echo "  fig:$label"
    fi
done <<< "$FIG_LABELS_UNIQ"

# ---------------------------------------------------------------------------
# EQUATIONS
# ---------------------------------------------------------------------------
echo -e "\n=== EQUATIONS ==="
EQ_LABELS=$(echo "$TEXCONTENT" | grep -oP '\\label\{eq:\K[^}]+')
EQ_LABELS_UNIQ=$(echo "$EQ_LABELS" | awk '!seen[$0]++')
EQ_REFS=$(refs_for_prefix "eq")
EQ_COUNT=$(echo "$EQ_LABELS_UNIQ" | grep -v '^$' | wc -l)
EQREF_COUNT=$(echo "$EQ_REFS" | grep -v '^$' | wc -l)

echo "Total labels: $EQ_COUNT"
echo "Total refs:   $EQREF_COUNT"
echo "Unreferenced equations:"
while IFS= read -r label; do
    [ -z "$label" ] && continue
    if ! echo "$EQ_REFS" | grep -qx "$label"; then
        echo "  eq:$label"
    fi
done <<< "$EQ_LABELS_UNIQ"

# ---------------------------------------------------------------------------
# SECTIONS
# ---------------------------------------------------------------------------
echo -e "\n=== SECTIONS ==="
SEC_LABELS=$(echo "$TEXCONTENT" | grep -oP '\\label\{sec:\K[^}]+')
SEC_LABELS_UNIQ=$(echo "$SEC_LABELS" | awk '!seen[$0]++')
SEC_REFS=$(refs_for_prefix "sec")
SEC_COUNT=$(echo "$SEC_LABELS_UNIQ" | grep -v '^$' | wc -l)
SECREF_COUNT=$(echo "$SEC_REFS" | grep -v '^$' | wc -l)

echo "Total labels: $SEC_COUNT"
echo "Total refs:   $SECREF_COUNT"
echo "Unreferenced sections:"
while IFS= read -r label; do
    [ -z "$label" ] && continue
    if ! echo "$SEC_REFS" | grep -qx "$label"; then
        echo "  sec:$label"
    fi
done <<< "$SEC_LABELS_UNIQ"

# ---------------------------------------------------------------------------
# CITATIONS
# Supports: \cite, \citep, \citet, \citealt, \citealp, \citeauthor,
#           \citeyear, \citeyearpar, \citenum, \parencite, \textcite,
#           \footcite, \autocite (biblatex), and multi-key calls.
# Detects bibliography from \bibliography{} and \addbibresource{} (biblatex).
# ---------------------------------------------------------------------------
echo -e "\n=== CITATIONS ==="

BIBFILE=$(echo "$TEXCONTENT" | grep -oP '\\bibliography\{\K[^}]+' | head -1)
if [ -z "$BIBFILE" ]; then
    BIBFILE=$(echo "$TEXCONTENT" | grep -oP '\\addbibresource\{\K[^}]+' | head -1)
fi

if [ -n "$BIBFILE" ]; then
    [[ "$BIBFILE" != *.bib ]] && BIBFILE="${BIBFILE}.bib"

    if [ -f "$BIBFILE" ]; then
        echo "Using bibliography file: $BIBFILE"

        BIB_ENTRIES=$(grep -oP '@\w+\{\K[^,]+' "$BIBFILE" | awk '!seen[$0]++')

        # Match all common cite commands; split comma-separated keys
        CITATIONS=$(echo "$TEXCONTENT" \
            | grep -oP '\\cite(p|t|alt|alp|author|year|yearpar|num|s)?\*?\{[^}]+\}|\\(parencite|textcite|footcite|autocite)\*?\{[^}]+\}' \
            | grep -oP '\{[^}]+\}' \
            | tr -d '{}' \
            | tr ',' '\n' \
            | sed 's/^[[:space:]]*//' \
            | sed 's/[[:space:]]*$//' \
            | grep -v '^$' \
            | awk '!seen[$0]++')

        BIB_COUNT=$(echo "$BIB_ENTRIES" | grep -v '^$' | wc -l)
        CITE_UNIQ=$(echo "$CITATIONS" | grep -v '^$' | wc -l)

        echo "Total bib entries:  $BIB_COUNT"
        echo "Unique cited keys:  $CITE_UNIQ"

        echo "Uncited bibliography entries:"
        while IFS= read -r entry; do
            [ -z "$entry" ] && continue
            if ! echo "$CITATIONS" | grep -qx "$entry"; then
                echo "  $entry"
            fi
        done <<< "$BIB_ENTRIES"

        echo "Missing bibliography entries (cited but not in .bib):"
        while IFS= read -r cite; do
            [ -z "$cite" ] && continue
            if ! echo "$BIB_ENTRIES" | grep -qx "$cite"; then
                echo "  $cite"
            fi
        done <<< "$CITATIONS"
    else
        echo "Bibliography file not found: $BIBFILE"
    fi
else
    echo "No bibliography file found in document"
fi

echo -e "\n========================================"
echo "Check complete!"

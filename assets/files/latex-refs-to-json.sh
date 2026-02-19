#!/bin/bash
# latex-refs-to-json.sh — Export unreferenced LaTeX items to JSON
# Usage: ./latex-refs-to-json.sh manuscript.tex
# Requires: check_latex_refs.sh in the same directory

TEXFILE=$1

if [ $# -eq 0 ]; then
    echo "Usage: $0 <latex_file.tex>"
    exit 1
fi

TEXCONTENT=$(grep -v '^\s*%' "$TEXFILE" | sed 's/\([^\\]\)%.*$/\1/')

refs_for_prefix() {
    local prefix="$1"
    echo "$ALL_REFS" | grep "^${prefix}:" | sed "s/^${prefix}://" | awk '!seen[$0]++'
}

ALL_REFS=$(echo "$TEXCONTENT" \
    | grep -oP '\\(auto|Auto|c|C|v|page|name|labelc|eq)?ref\{[^}]+\}' \
    | grep -oP '\{[^}]+\}' \
    | tr -d '{}' \
    | tr ',' '\n' \
    | sed 's/^[[:space:]]*//' \
    | grep -v '^$' \
    | awk '!seen[$0]++')

build_json_array() {
    local prefix="$1"
    local labels="$2"
    local refs
    refs=$(refs_for_prefix "$prefix")
    comm -23 <(echo "$labels" | sort) <(echo "$refs" | sort) \
        | awk '{printf "\"%s\",", $0}' | sed 's/,$//'
}

TAB_LABELS=$(echo "$TEXCONTENT" | grep -oP '\\label\{tab:\K[^}]+' | awk '!seen[$0]++')
FIG_LABELS=$(echo "$TEXCONTENT" | grep -oP '\\label\{fig:\K[^}]+' | awk '!seen[$0]++')
EQ_LABELS=$(echo  "$TEXCONTENT" | grep -oP '\\label\{eq:\K[^}]+'  | awk '!seen[$0]++')
SEC_LABELS=$(echo "$TEXCONTENT" | grep -oP '\\label\{sec:\K[^}]+' | awk '!seen[$0]++')

cat << EOF
{
  "file": "$TEXFILE",
  "timestamp": "$(date -Iseconds)",
  "unreferenced": {
    "tables":    [$(build_json_array "tab" "$TAB_LABELS")],
    "figures":   [$(build_json_array "fig" "$FIG_LABELS")],
    "equations": [$(build_json_array "eq"  "$EQ_LABELS")],
    "sections":  [$(build_json_array "sec" "$SEC_LABELS")]
  }
}
EOF

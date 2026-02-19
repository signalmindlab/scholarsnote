---
title: "LaTeX Reference Checker: Bash Script to Find Unused Labels and Missing Citations"
date: 2026-01-03 10:00:00 +0900
categories: [LaTeX, Tools, Research]
tags: [latex, bash, academic-writing, productivity, script]
description: "A robust bash script that audits LaTeX documents to find unreferenced figures, tables, equations, and citation issues while ignoring commented code."
author: Md Abdus Samad
---

When preparing research manuscripts, it is common to accumulate unused labels, orphaned citations, and commented-out content. This bash script provides a comprehensive audit of your LaTeX document, identifying unreferenced figures, tables, equations, and sections, unused bibliography entries, and missing citations -- all while properly ignoring commented lines. The script preserves the sequence in which labels appear in your document, making it easier to locate and manage them.

## The Problem

During manuscript development, you might encounter:

- **Unreferenced labels** — `\label{fig:old_analysis}` defined but never cited; clutters the document and confuses reviewers.
- **Commented labels counted** — `% \label{tab:removed}` still detected by naive checks; produces false positives.
- **Missing citations** — `\cite{smith2023}` used in the text but absent from the `.bib` file; causes compilation errors.
- **Unused bibliography entries** — references added but never cited; inflates the reference count.

Manual checking across 50+ pages with multiple revisions becomes impractical.

## The Solution

### Features

- **Comment-aware**: Ignores both full-line and inline comments
- **Sequence-preserving**: Shows labels in document order
- **Comprehensive**: Checks figures, tables, equations, sections, and citations
- **All major reference commands**: Supports all standard variants — `\ref`, `\autoref`,
  `\Autoref`, `\cref`, `\Cref`, `\vref`, `\pageref`, `\nameref`, `\labelcref`, `\eqref`
- **Multi-key refs**: Handles `\cref{fig:a,fig:b}` style calls (cleveref)
- **biblatex support**: Detects `\addbibresource{}` in addition to `\bibliography{}`
- **Broad citation coverage**: Covers natbib (`\cite`, `\citep`, `\citet`, `\citealt`,
  `\citealp`, `\citeauthor`, `\citeyear`) and biblatex (`\parencite`, `\textcite`,
  `\footcite`, `\autocite`) including starred variants
- **Lightweight**: Pure bash, no dependencies
- **Fast**: Processes typical manuscripts in less than one second

## Installation and Usage

Follow these three simple steps to start using the reference checker:

1. **Download the script** - Download `check_latex_refs.sh` (link below) and save it in your LaTeX project directory
2. **Make it executable** - Run `chmod +x check_latex_refs.sh` in your terminal
3. **Run the checker** - Execute `./check_latex_refs.sh manuscript.tex` (replace with your filename)

### Step 1: Download the Script

[**Download check_latex_refs.sh**](/assets/files/check_latex_refs.sh){: .btn .btn-primary }

Save the file as `check_latex_refs.sh` in the same directory as your LaTeX file.

### Step 2: Make it Executable

Open your terminal (Bash/CMD/PowerShell), navigate to your project directory, and run:

```bash
chmod +x check_latex_refs.sh
```

This command gives the script permission to run on your system.

### Step 3: Run the Checker

Execute the script with your LaTeX file:

```bash
./check_latex_refs.sh manuscript.tex
```

Replace `manuscript.tex` with your actual LaTeX filename. The script will analyze your document and display a comprehensive report of all references.

## Example Output

Here is what the script reports for a typical manuscript:

```
Checking references in: paper.tex
========================================

=== TABLES ===
Total labels: 11
Total refs:   8
Unreferenced tables:
  tab:appendix_data
  tab:extra_results
  tab:summary_stats

=== FIGURES ===
Total labels: 6
Total refs:   6
Unreferenced figures:

=== EQUATIONS ===
Total labels: 15
Total refs:   12
Unreferenced equations:
  eq:supplementary
  eq:variance
  eq:alt_form

=== SECTIONS ===
Total labels: 4
Total refs:   3
Unreferenced sections:
  sec:future_work

=== CITATIONS ===
Using bibliography file: references.bib
Total bib entries:  45
Unique cited keys:  38
Uncited bibliography entries:
  smith2020old
  jones2019unused
  brown2018extra
Missing bibliography entries (cited but not in .bib):
  nguyen2023missing

========================================
Check complete!
```

The script detects references made with `\ref{fig:one}`, `\autoref{tab:results}`, `\cref{eq:main}`, `\eqref{eq:energy}`, or even `\cref{fig:a,fig:b}` -- all are counted correctly.

## Technical Deep Dive

### How It Works

#### 1. Comment Removal

The script uses a two-step approach to handle comments:

```bash
# Step 1: Remove lines starting with %
# Step 2: Remove inline comments but preserve \%
TEXCONTENT=$(grep -v '^\s*%' "$TEXFILE" | sed 's/\([^\\]\)%.*$/\1/')
```

The order matters. Full-line comments must be removed first, then inline comments.

**Test cases:**

| LaTeX Code | Processed As |
|------------|--------------|
| `\label{fig:test}` | Included |
| `% \label{fig:old}` | Excluded |
| `Text \ref{fig:a} % comment` | `\ref{fig:a}` included |
| `50\% efficiency` | `\%` preserved |

#### 2. Sequence Preservation

Uses `awk '!seen[$0]++'` to remove duplicates while maintaining order:

```bash
# Traditional approach (loses order)
sort -u

# Our approach (preserves order)
awk '!seen[$0]++'
```

**Why this matters:**

If your document has:
```latex
\section{Methods}        % Line 50
\label{fig:workflow}     % Line 65

\section{Results}        % Line 150
\label{fig:accuracy}     % Line 170

\section{Appendix}       % Line 300
\label{fig:extra}        % Line 310 (unreferenced)
```

The output shows `fig:extra` in document order (not alphabetically sorted), making it easier to locate.

#### 3. Unified Reference Pattern

All reference commands are captured in one pass using a single regex, then split by prefix:

```bash
ALL_REFS=$(echo "$TEXCONTENT" \
    | grep -oP '\\(auto|Auto|c|C|v|page|name|labelc|eq)?ref\{[^}]+\}' \
    | grep -oP '\{[^}]+\}' \
    | tr -d '{}' \
    | tr ',' '\n' \          # split multi-key: \cref{fig:a,fig:b}
    | sed 's/^[[:space:]]*//' \
    | grep -v '^$' \
    | awk '!seen[$0]++')
```

Labels are then filtered per section using a helper:

```bash
refs_for_prefix() {
    local prefix="$1"
    echo "$ALL_REFS" | grep "^${prefix}:" | sed "s/^${prefix}://" | awk '!seen[$0]++'
}
```

**Supported reference commands:**

| Command | Package | Notes |
|---------|---------|-------|
| `\ref{...}` | Standard LaTeX | Basic cross-reference |
| `\autoref{...}` | hyperref | Adds type name automatically |
| `\Autoref{...}` | hyperref | Sentence-initial capitalised form |
| `\cref{...}` | cleveref | Smart reference with type |
| `\Cref{...}` | cleveref | Capitalised form |
| `\vref{...}` | varioref | Adds page information |
| `\pageref{...}` | Standard LaTeX | Page number only |
| `\nameref{...}` | hyperref | Uses section name |
| `\labelcref{...}` | cleveref | Label-only reference |
| `\eqref{...}` | amsmath | Equation reference with parentheses |

**Multi-key cleveref calls are handled automatically:**

```latex
% All three labels are detected as referenced:
\cref{fig:workflow,fig:accuracy,tab:results}
```

**Examples:**

Labels detected:
- `\label{tab:results}` extracts `results`
- `\label{fig:analysis_2023}` extracts `analysis_2023`
- `\label{eq:main_theorem}` extracts `main_theorem`
- `\label{sec:introduction}` extracts `introduction`

References detected:
- `\ref{fig:diagram}` → matches `diagram`
- `\autoref{tab:results}` → matches `results`
- `\Cref{fig:workflow}` → matches `workflow`
- `\eqref{eq:einstein}` → matches `einstein`
- `\cref{fig:a,fig:b}` → matches both `a` and `b`

Not matched (correctly excluded):
- `% \label{tab:old}` (filtered by comment removal)

#### 4. Citation Coverage

The citation section captures all common natbib and biblatex commands, including multi-key calls:

```bash
NATBIB='\\cite(p|t|alt|alp|author|year|yearpar|num|s)?\*?\{[^}]+\}'
BIBLATEX='\\(parencite|textcite|footcite|autocite)\*?\{[^}]+\}'
CITATIONS=$(echo "$TEXCONTENT" \
    | grep -oP "$NATBIB|$BIBLATEX" \
    | grep -oP '\{[^}]+\}' \
    | tr -d '{}' \
    | tr ',' '\n' \
    | ...)
```

**Supported citation commands:**

| Command | Package |
|---------|---------|
| `\cite`, `\citep`, `\citet` | natbib |
| `\citealt`, `\citealp` | natbib |
| `\citeauthor`, `\citeyear`, `\citeyearpar` | natbib |
| `\citenum`, `\cites` | natbib / misc |
| `\parencite`, `\textcite` | biblatex |
| `\footcite`, `\autocite` | biblatex |
| Starred variants (`\citep*` etc.) | natbib |

Bibliography detection supports both:
- `\bibliography{references}` (natbib / BibTeX)
- `\addbibresource{references.bib}` (biblatex)

## Advanced Usage

### 1. Check Multiple Files

Create `check_all.sh`:

```bash
#!/bin/bash

for file in *.tex; do
    echo "File: $file"
    ./check_latex_refs.sh "$file"
    echo ""
done
```

### 2. Generate Timestamped Reports

```bash
# Create dated log
./check_latex_refs.sh paper.tex > "audit_$(date +%Y%m%d_%H%M%S).log"

# Compare before/after revision
./check_latex_refs.sh paper.tex > before_revision.log
# ... make changes ...
./check_latex_refs.sh paper.tex > after_revision.log
diff before_revision.log after_revision.log
```

### 3. Git Pre-commit Hook

Download and copy to `.git/hooks/pre-commit`, then run `chmod +x .git/hooks/pre-commit`:

[**Download latex-pre-commit-hook.sh**](/assets/files/latex-pre-commit-hook.sh)

### 4. Makefile Integration

Download and save as `Makefile` in your project directory:

[**Download latex-Makefile**](/assets/files/latex-Makefile)

**Usage:**
```bash
make              # Compile and check
make check        # Run reference check only
make audit        # Generate timestamped audit
```

### 5. Pre-submission Checklist Script

Download and run `./pre-submit.sh` from your project directory:

[**Download pre-submit.sh**](/assets/files/pre-submit.sh)

## Extensions and Customizations

### Add Line Numbers

Modify the unreferenced item display to show line numbers:

```bash
while IFS= read -r label; do
    if ! echo "$TAB_REFS" | grep -qx "$label"; then
        LINE=$(grep -n "\\label{tab:$label}" "$TEXFILE" | cut -d: -f1)
        echo "  tab:$label (line $LINE)"
    fi
done <<< "$TAB_LABELS_UNIQ"
```

**Output:**
```
Unreferenced tables:
  tab:appendix_data (line 145)
  tab:extra_results (line 203)
```

### Color Output

Add ANSI color codes for better visibility:

```bash
# Add at top of script (after shebang)
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Use in output
echo -e "${BLUE}=== TABLES ===${NC}"
echo "Total labels: $TAB_COUNT"
echo "Total refs:   $TABREF_COUNT"

if [ "$TAB_COUNT" -eq "$TABREF_COUNT" ]; then
    echo -e "${GREEN}All tables referenced${NC}"
else
    echo -e "${RED}Unreferenced tables:${NC}"
    while IFS= read -r label; do
        if ! echo "$TAB_REFS" | grep -qx "$label"; then
            echo -e "  ${YELLOW}tab:$label${NC}"
        fi
    done <<< "$TAB_LABELS_UNIQ"
fi
```

### Export to CSV

[**Download latex-refs-to-csv.sh**](/assets/files/latex-refs-to-csv.sh)

```bash
./latex-refs-to-csv.sh manuscript.tex
```

### JSON Output

[**Download latex-refs-to-json.sh**](/assets/files/latex-refs-to-json.sh)

```bash
./latex-refs-to-json.sh manuscript.tex
```

## Workflow Integration Examples

### 1. Continuous Integration (CI)

Download and place at `.github/workflows/latex-check.yml` in your repository:

[**Download latex-check.yml**](/assets/files/latex-check.yml)

### 2. VS Code Task

Download and place at `.vscode/tasks.json` in your project:

[**Download vscode-tasks.json**](/assets/files/vscode-tasks.json)

### 3. Overleaf/Git Sync

Download and run `./sync-and-check.sh` from your project directory:

[**Download sync-and-check.sh**](/assets/files/sync-and-check.sh)

## Comparison with Alternatives

**This script**
: Fast, comment-aware, preserves label order, broad ref/cite command support
: ⚠ Single file only
: Best for: quick audits, CI/CD pipelines

**`refcheck` package**
: LaTeX-integrated; adds visual markers in the PDF margin
: ⚠ Requires recompilation; clutters the PDF output
: Best for: checking during active writing

**`chktex`**
: Comprehensive linting with many rule-based checks
: ⚠ Verbose output; steep learning curve
: Best for: deep style and syntax analysis

**VS Code LaTeX Workshop**
: Real-time feedback integrated directly in the editor
: ⚠ Editor-specific; no batch or CI support
: Best for: active editing sessions

**Python scripts**
: Highly flexible; can produce HTML reports and custom output
: ⚠ Slower; requires a Python environment
: Best for: custom or complex workflows

## Real-World Case Study

### Initial State

Manuscript for journal submission with 8 months of revisions:

```
=== TABLES ===
Total labels: 8
Total refs:   7
Unreferenced tables:
  tab:correlation_matrix

=== FIGURES ===
Total labels: 12
Total refs:   12

=== EQUATIONS ===
Total labels: 6
Total refs:   6

=== CITATIONS ===
Total bib entries: 67
Uncited bibliography entries:
  lecun2015deep
  goodfellow2016deep
  chollet2017deep
  bishop2006pattern
  murphy2012machine
  hastie2009elements
  james2013introduction
  vapnik1995nature
  cover2006elements
```

### Actions Taken

1. **Moved** `tab:correlation_matrix` to supplementary materials
2. **Removed** 9 unused deep learning references (leftover from earlier drafts)
3. **Cleaned up** bibliography from 67 to 58 entries
4. **Verified** all remaining citations were relevant

### Final State

```
=== TABLES ===
Total labels: 7
Total refs:   7
Unreferenced tables:

=== CITATIONS ===
Total bib entries: 58
Uncited bibliography entries:
```

**Time saved:** Approximately 30 minutes of manual checking
**Outcome:** Clean submission, no reviewer comments about references

## Limitations and Workarounds

### Current Limitations

1. **Single file only**: Does not traverse `\input{}` or `\include{}` commands
2. **Standard prefixes**: Assumes `tab:`, `fig:`, `eq:`, `sec:` conventions
3. **Citation commands**: Does not cover every possible custom cite command

### Workarounds

**For multi-file projects:**
```bash
# Combine files first
cat main.tex chapter*.tex appendix.tex > combined.tex
./check_latex_refs.sh combined.tex
rm combined.tex
```

**For custom prefixes:**
```bash
# Modify the refs_for_prefix calls in the script
# Example: change tab: to tbl:
TAB_REFS=$(refs_for_prefix "tbl")
```

**For additional citation commands:**

Open `check_latex_refs.sh` and extend the `CITATIONS` grep pattern:
```bash
# Add your custom command, e.g. \mycite
grep -oP '\\(cite...|mycite)\*?\{[^}]+\}'
```

## Troubleshooting

### Issue: Script shows no output

**Solution:**
```bash
# Check file exists and has content
ls -la manuscript.tex
wc -l manuscript.tex

# Check for labels
grep "\\label{" manuscript.tex | head -5

# Run with debug mode
bash -x check_latex_refs.sh manuscript.tex
```

### Issue: Bibliography not found

**Solution:**
```bash
# Check bibliography command exists
grep "bibliography" manuscript.tex

# Verify .bib file location
ls -la *.bib

# Check file permissions
ls -la references.bib
```

### Issue: Commented lines still appear

**Solution:**
```bash
# Check sed version
sed --version

# Try alternative comment removal
TEXCONTENT=$(grep -v '^\s*%' "$TEXFILE" | sed 's/[^\\]%.*$//')

# Or use Perl
TEXCONTENT=$(perl -pe 's/([^\\])%.*$/$1/' "$TEXFILE")
```

### Issue: Special characters in labels

**Solution:**
```bash
# Escape special characters in grep
grep -oP '\\label\{tab:\K[^}]+' | sed 's/[._-]//g'

# Or use simpler pattern
grep "\\label{tab:" | cut -d'{' -f2 | cut -d'}' -f1
```

### Issue: False positives

**Solution:**
```bash
# Check if label actually exists in source
grep -n "label{tab:problematic}" manuscript.tex

# Verify it's not in a comment
grep "tab:problematic" manuscript.tex | grep -v "^%"
```

## Performance Optimization

For very large documents (>10,000 lines):

```bash
# Use parallel processing for multiple files
find . -name "*.tex" | parallel ./check_latex_refs.sh {}

# Cache intermediate results
TEXCONTENT=$(sed 's/\([^\\]\)%.*$/\1/' "$TEXFILE" | tee /tmp/cleaned.tex)

# Use faster grep alternatives
# Install ripgrep: sudo apt install ripgrep
rg -oP '\\label\{tab:\K[^}]+' "$TEXFILE"
```

---

## How to Cite

> Samad, M. A. (2026). LaTeX reference checker: Bash script to find unused labels and missing citations. *ScholarsNote*. <https://www.scholarsnote.org/posts/latex-label-prefix-guide-blog/>

**BibTeX:**

```bibtex
@misc{samad2026latexrefchecker,
  author       = {Samad, Md Abdus},
  title        = {LaTeX Reference Checker: Bash Script to Find
                  Unused Labels and Missing Citations},
  year         = {2026},
  month        = jan,
  howpublished = {ScholarsNote},
  url          = {https://www.scholarsnote.org/posts/latex-label-prefix-guide-blog/},
  note         = {Accessed: 2026-01-03}
}
```

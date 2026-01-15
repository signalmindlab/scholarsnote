---
title: "LaTeX Reference Checker: Technical Deep Dive"
date: 2026-01-03
author: "ScholarNote"
categories: [LaTeX, Tools, Technical]
tags: [latex, bash, regex, scripting, technical-guide]
description: "Deep technical analysis of the LaTeX reference checker: comment handling, regex patterns, and sequence preservation algorithms"
featured: false
---

## Technical Deep Dive

### How It Works

#### 1. Comment Removal

The script uses a two-step approach to handle comments:

```bash
# Step 1: Remove lines starting with %
# Step 2: Remove inline comments but preserve \%
TEXCONTENT=$(grep -v '^\s*%' "$TEXFILE" | sed 's/\([^\\]\)%.*$/\1/')
```

**Important:** The order matters! We must remove full-line comments **first**, then handle inline comments.

**Test cases:**

| LaTeX Code | Processed As |
|------------|--------------|
| `\label{fig:test}` | ✓ Included |
| `% \label{fig:old}` | ✗ Excluded |
| `Text \ref{fig:a} % comment` | ✓ `\ref{fig:a}` included |
| `50\% efficiency` | ✓ `\%` preserved |

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

#### 3. Pattern Matching

Uses Perl-compatible regex with `grep -oP`:

```bash
# For tables and figures: catches both \ref and \autoref
grep -oP '\\(auto)?ref\{tab:\K[^}]+'

# For equations: catches \ref, \autoref, and \eqref
grep -oP '\\((auto|eq))?ref\{eq:\K[^}]+'
```

**Breakdown:**
- `\\(auto)?ref\{tab:` - Match `\ref{tab:` or `\autoref{tab:`
- `\\((auto|eq))?ref\{eq:` - Match `\ref{eq:`, `\autoref{eq:`, or `\eqref{eq:`
- `\K` - Discard everything matched so far
- `[^}]+` - Capture everything until `}`

**Supported reference commands:**
- `\ref{...}` - Standard LaTeX reference
- `\autoref{...}` - Automatic reference from hyperref package
- `\eqref{...}` - Equation reference (for equations only)

**Examples:**

Labels detected:
- `\label{tab:results}` → extracts `results`
- `\label{fig:analysis_2023}` → extracts `analysis_2023`
- `\label{eq:main_theorem}` → extracts `main_theorem`

References detected:
- `\ref{fig:diagram}` → matches `diagram`
- `\autoref{tab:results}` → matches `results`
- `\eqref{eq:einstein}` → matches `einstein`

Not matched:
- `% \label{tab:old}` (filtered by comment removal)
- `\label{sec:intro}` (different prefix - use section extension)

---

*For the complete LaTeX Reference Checker guide, see the [main blog post](https://scholarsnote.org/latex-reference-checker-bash/).*

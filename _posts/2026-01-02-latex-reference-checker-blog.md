---
title: "Finding Unreferenced Tables, Figures, and Equations, References in LaTeX Documents"
date: 2026-01-02
author: "scholarsnote"
categories: [LaTeX, Academic Writing, Productivity]
tags: [latex, bash, grep, research, manuscript-preparation]
description: "A simple bash command-line approach to identify unreferenced floats and elements in your LaTeX manuscripts before submission"
---

## The Problem

When writing academic papers in LaTeX, it's easy to create tables, figures, equations, algorithms, theorems, or other labeled elements and forget to reference them in the text. Journal reviewers often flag this issue, and some journals explicitly require that all floats be cited. Manually tracking all your `\label{}` and `\ref{}` commands becomes tedious, especially in long manuscripts with multiple element types.

## The Solution: grep + comm

Using simple bash commands, you can automatically find unreferenced elements in seconds. Here's how it works.

## Basic Concept

The approach uses two steps:

1. **Extract all labels** from your document (e.g., `\label{tab:results}`)
2. **Extract all references** (e.g., `\ref{tab:results}` or `\autoref{tab:results}`)
3. **Compare them** to find labels without corresponding references

## Quick Example: Checking Tables

```bash
# Count total table labels
grep -o '\\label{tab:[^}]*}' paper.tex | wc -l

# Count total table references
grep -oE '\\(auto)?ref\{tab:[^}]*\}' paper.tex | wc -l

# Find unreferenced tables
comm -23 <(grep -o '\\label{tab:[^}]*}' paper.tex | sed 's/.*{\(.*\)}/\1/' | sort -u) \
         <(grep -oE '\\(auto)?ref\{tab:[^}]*\}' paper.tex | sed 's/.*{\(.*\)}/\1/' | sort -u)
```

**Output example:**
```
11  # total labels
8   # total references
tab:summary    # unreferenced!
tab:appendix1  # unreferenced!
tab:extra      # unreferenced!
```

## All Reference Types You Can Check

This approach works for **any labeled element** in LaTeX. Here are the most common types:

### Standard Floats
- **Tables:** `tab:` - `\label{tab:results}`
- **Figures:** `fig:` - `\label{fig:architecture}`
- **Algorithms:** `alg:` - `\label{alg:sorting}`
- **Code Listings:** `lst:` - `\label{lst:python_code}`

### Document Structure
- **Sections:** `sec:` - `\label{sec:introduction}`
- **Subsections:** `subsec:` or `ssec:` - `\label{subsec:background}`
- **Chapters:** `chap:` - `\label{chap:methodology}` (books/theses)
- **Appendices:** `app:` or `appx:` - `\label{app:proofs}`

### Mathematical Environments (amsthm)
- **Theorems:** `thm:` - `\label{thm:convergence}`
- **Lemmas:** `lem:` - `\label{lem:helper}`
- **Propositions:** `prop:` - `\label{prop:uniqueness}`
- **Corollaries:** `cor:` - `\label{cor:result}`
- **Definitions:** `def:` - `\label{def:term}`
- **Remarks:** `rem:` - `\label{rem:note}`
- **Examples:** `ex:` - `\label{ex:case1}`

### Specialized Elements
- **Assumptions/Hypotheses:** `hyp:` - `\label{hyp:normality}`
- **Conjectures:** `conj:` - `\label{conj:hypothesis}`
- **Claims:** `claim:` - `\label{claim:bounds}`
- **Notations:** `nota:` - `\label{nota:symbols}`
- **Equations:** `eq:` - `\label{eq:einstein}`
- **List items:** `item:` - `\label{item:first}`
- **Algorithm lines:** `line:` - `\label{line:init}`

### Quick check for any type
```bash
# Replace PREFIX with your label type
grep -o '\\label{PREFIX:[^}]*}' paper.tex | wc -l
```

## Understanding the comm -23 Command

The `comm` command compares two sorted files:

- `comm -1`: suppress lines unique to file 1
- `comm -2`: suppress lines unique to file 2
- `comm -3`: suppress lines common to both

**`comm -23`** shows only lines in file 1 that are NOT in file 2 — perfect for finding labels without references!

### How it works:

```
Labels (file1):     References (file2):     comm -23 output:
tab:results         tab:results             tab:summary  ← unreferenced
tab:summary         tab:demo                tab:extra    ← unreferenced
tab:demo            tab:demo
tab:extra
```

## Extending to All Reference Types

The same approach works for any LaTeX element with a label. Here's how to check additional types:

### Theorems and Mathematical Environments
```bash
# Theorems
comm -23 <(grep -o '\\label{thm:[^}]*}' paper.tex | sed 's/.*{\(.*\)}/\1/' | sort -u) \
         <(grep -oE '\\(auto)?ref\{thm:[^}]*\}' paper.tex | sed 's/.*{\(.*\)}/\1/' | sort -u)

# Lemmas
comm -23 <(grep -o '\\label{lem:[^}]*}' paper.tex | sed 's/.*{\(.*\)}/\1/' | sort -u) \
         <(grep -oE '\\(auto)?ref\{lem:[^}]*\}' paper.tex | sed 's/.*{\(.*\)}/\1/' | sort -u)

# Definitions
comm -23 <(grep -o '\\label{def:[^}]*}' paper.tex | sed 's/.*{\(.*\)}/\1/' | sort -u) \
         <(grep -oE '\\(auto)?ref\{def:[^}]*\}' paper.tex | sed 's/.*{\(.*\)}/\1/' | sort -u)
```

### Code Listings
```bash
comm -23 <(grep -o '\\label{lst:[^}]*}' paper.tex | sed 's/.*{\(.*\)}/\1/' | sort -u) \
         <(grep -oE '\\(auto)?ref\{lst:[^}]*\}' paper.tex | sed 's/.*{\(.*\)}/\1/' | sort -u)
```

### Appendices
```bash
# Standard app: prefix
comm -23 <(grep -o '\\label{app:[^}]*}' paper.tex | sed 's/.*{\(.*\)}/\1/' | sort -u) \
         <(grep -oE '\\(auto)?ref\{app:[^}]*\}' paper.tex | sed 's/.*{\(.*\)}/\1/' | sort -u)

# Alternative appx: prefix
comm -23 <(grep -o '\\label{appx:[^}]*}' paper.tex | sed 's/.*{\(.*\)}/\1/' | sort -u) \
         <(grep -oE '\\(auto)?ref\{appx:[^}]*\}' paper.tex | sed 's/.*{\(.*\)}/\1/' | sort -u)
```

## Understanding the comm -23 Command

The `comm` command compares two sorted files:

- `comm -1`: suppress lines unique to file 1
- `comm -2`: suppress lines unique to file 2
- `comm -3`: suppress lines common to both

**`comm -23`** shows only lines in file 1 that are NOT in file 2 — perfect for finding labels without references!

### How it works:

```
Labels (file1):     References (file2):     comm -23 output:
tab:results         tab:results             tab:summary  ← unreferenced
tab:summary         tab:demo                tab:extra    ← unreferenced
tab:demo            tab:demo
tab:extra
```

## Complete Reference Checker Script

Here's a comprehensive script to check all common LaTeX elements **including citations**:

```bash
#!/bin/bash
# save as check_refs.sh

FILE="${1:-paper.tex}"
BIBFILE="${2}"  # Optional: specify .bib file

echo "Checking references in: $FILE"
echo "========================================"

echo -e "\n=== TABLES ==="
echo "Total labels: $(grep -o '\\label{tab:[^}]*}' "$FILE" | wc -l)"
echo "Total refs: $(grep -oE '\\(auto)?ref\{tab:[^}]*\}' "$FILE" | wc -l)"
echo "Unreferenced tables:"
comm -23 <(grep -o '\\label{tab:[^}]*}' "$FILE" | sed 's/.*{\(.*\)}/\1/' | sort -u) \
         <(grep -oE '\\(auto)?ref\{tab:[^}]*\}' "$FILE" | sed 's/.*{\(.*\)}/\1/' | sort -u)

echo -e "\n=== FIGURES ==="
echo "Total labels: $(grep -o '\\label{fig:[^}]*}' "$FILE" | wc -l)"
echo "Total refs: $(grep -oE '\\(auto)?ref\{fig:[^}]*\}' "$FILE" | wc -l)"
echo "Unreferenced figures:"
comm -23 <(grep -o '\\label{fig:[^}]*}' "$FILE" | sed 's/.*{\(.*\)}/\1/' | sort -u) \
         <(grep -oE '\\(auto)?ref\{fig:[^}]*\}' "$FILE" | sed 's/.*{\(.*\)}/\1/' | sort -u)

echo -e "\n=== EQUATIONS ==="
echo "Total labels: $(grep -o '\\label{eq:[^}]*}' "$FILE" | wc -l)"
echo "Total refs: $(grep -oE '\\(auto|eq)?ref\{eq:[^}]*\}' "$FILE" | wc -l)"
echo "Unreferenced equations:"
comm -23 <(grep -o '\\label{eq:[^}]*}' "$FILE" | sed 's/.*{\(.*\)}/\1/' | sort -u) \
         <(grep -oE '\\(auto|eq)?ref\{eq:[^}]*\}' "$FILE" | sed 's/.*{\(.*\)}/\1/' | sort -u)

echo -e "\n=== ALGORITHMS ==="
echo "Total labels: $(grep -o '\\label{alg:[^}]*}' "$FILE" | wc -l)"
echo "Total refs: $(grep -oE '\\(auto)?ref\{alg:[^}]*\}' "$FILE" | wc -l)"
echo "Unreferenced algorithms:"
comm -23 <(grep -o '\\label{alg:[^}]*}' "$FILE" | sed 's/.*{\(.*\)}/\1/' | sort -u) \
         <(grep -oE '\\(auto)?ref\{alg:[^}]*\}' "$FILE" | sed 's/.*{\(.*\)}/\1/' | sort -u)

echo -e "\n=== SECTIONS ==="
echo "Total labels: $(grep -o '\\label{sec:[^}]*}' "$FILE" | wc -l)"
echo "Total refs: $(grep -oE '\\(auto)?ref\{sec:[^}]*\}' "$FILE" | wc -l)"
echo "Unreferenced sections:"
comm -23 <(grep -o '\\label{sec:[^}]*}' "$FILE" | sed 's/.*{\(.*\)}/\1/' | sort -u) \
         <(grep -oE '\\(auto)?ref\{sec:[^}]*\}' "$FILE" | sed 's/.*{\(.*\)}/\1/' | sort -u)

echo -e "\n=== CITATIONS ==="

# Auto-detect .bib file if not specified
if [ -z "$BIBFILE" ]; then
    BIBFILE=$(grep -oP '\\(bibliography|addbibresource)\{\K[^}]+' "$FILE" | head -1)
    if [ -n "$BIBFILE" ] && [[ ! "$BIBFILE" =~ \.bib$ ]]; then
        BIBFILE="${BIBFILE}.bib"
    fi
fi

if [ -n "$BIBFILE" ] && [ -f "$BIBFILE" ]; then
    echo "Using bibliography file: $BIBFILE"
    
    echo "Total bib entries: $(grep -c '^@' "$BIBFILE")"
    echo "Total citation commands: $(grep -oE '\\(cite|citep|citet|autocite|textcite|parencite)[*]?\{[^}]*\}' "$FILE" | wc -l)"
    
    CITED_KEYS=$(grep -oE '\\cite[a-z]*[*]?\{[^}]*\}' "$FILE" | \
                 sed 's/.*{\(.*\)}/\1/' | tr ',' '\n' | \
                 sed 's/^[[:space:]]*//;s/[[:space:]]*$//' | sort -u)
    
    echo "Unique cited keys: $(echo "$CITED_KEYS" | grep -v '^$' | wc -l)"
    
    BIB_KEYS=$(grep '^@' "$BIBFILE" | sed 's/@[^{]*{\([^,]*\).*/\1/' | sort -u)
    
    echo -e "\nUncited bibliography entries:"
    comm -23 <(echo "$BIB_KEYS") <(echo "$CITED_KEYS")
    
    echo -e "\nMissing bibliography entries (cited but not in .bib):"
    comm -13 <(echo "$BIB_KEYS") <(echo "$CITED_KEYS")
else
    echo "No bibliography file found"
    echo "Specify .bib file: $0 paper.tex references.bib"
fi

echo -e "\n========================================"
echo "Check complete!"
```

## Usage

### Make it executable:
```bash
chmod +x check_refs.sh
```

### Run it:
```bash
# Check default paper.tex (auto-detects .bib file)
./check_refs.sh

# Check specific file with auto-detected .bib
./check_refs.sh manuscript.tex

# Specify both .tex and .bib files
./check_refs.sh paper.tex references.bib
```

### Sample output:
```
Checking references in: paper.tex
========================================

=== TABLES ===
Total labels: 11
Total refs: 8
Unreferenced tables:
tab:appendix_data
tab:extra_results
tab:summary_stats

=== FIGURES ===
Total labels: 6
Total refs: 6
Unreferenced figures:

=== EQUATIONS ===
Total labels: 15
Total refs: 12
Unreferenced equations:
eq:supplementary
eq:variance
eq:alt_form

=== CITATIONS ===
Using bibliography file: references.bib
Total bib entries: 45
Total citation commands: 52
Unique cited keys: 38

Uncited bibliography entries:
smith2020old
jones2019unused
brown2018extra

Missing bibliography entries (cited but not in .bib):
nguyen2023missing

========================================
Check complete!
```

## Quick One-Liners

For rapid checks without creating a script:

```bash
# Tables
echo "Tables: $(grep -o '\\label{tab:[^}]*}' paper.tex | wc -l) labels, \
$(grep -oE '\\(auto)?ref\{tab:[^}]*\}' paper.tex | wc -l) refs"

# Figures
echo "Figures: $(grep -o '\\label{fig:[^}]*}' paper.tex | wc -l) labels, \
$(grep -oE '\\(auto)?ref\{fig:[^}]*\}' paper.tex | wc -l) refs"

# Equations (includes \eqref)
echo "Equations: $(grep -o '\\label{eq:[^}]*}' paper.tex | wc -l) labels, \
$(grep -oE '\\(auto|eq)?ref\{eq:[^}]*\}' paper.tex | wc -l) refs"
```

## How It Works: Breaking Down the Command

Let's dissect the table-checking command:

```bash
comm -23 <(grep -o '\\label{tab:[^}]*}' paper.tex | sed 's/.*{\(.*\)}/\1/' | sort -u) \
         <(grep -oE '\\(auto)?ref\{tab:[^}]*\}' paper.tex | sed 's/.*{\(.*\)}/\1/' | sort -u)
```

### Step by step:

1. **`grep -o '\\label{tab:[^}]*}'`** - Find all table labels
   - `-o`: only matching part
   - `\\label{tab:[^}]*}`: matches `\label{tab:anything}`

2. **`sed 's/.*{\(.*\)}/\1/'`** - Extract just the label name
   - Converts `\label{tab:results}` → `tab:results`

3. **`sort -u`** - Sort and remove duplicates

4. **Repeat for `\ref` and `\autoref`**

5. **`comm -23`** - Show labels that aren't referenced

## Customization Tips

### Different label prefixes

If your document uses different naming conventions:

```bash
# For 'table:' instead of 'tab:'
grep -o '\\label{table:[^}]*}' paper.tex

# For 'figure:' instead of 'fig:'
grep -o '\\label{figure:[^}]*}' paper.tex
```

### Check multiple files

```bash
# Check all .tex files in directory
for f in *.tex; do
    echo "=== $f ==="
    ./check_refs.sh "$f"
done
```

### Include \cref from cleveref package

```bash
grep -oE '\\(auto|c)?ref\{tab:[^}]*\}' paper.tex
```

## When to Use This

✅ **Before journal submission** - Ensure all floats are cited  
✅ **After major revisions** - Check if you removed references but not labels  
✅ **During collaborative writing** - Verify all contributors cited their additions  
✅ **For supplementary materials** - Confirm appendix elements are referenced  
✅ **Bibliography cleanup** - Remove uncited references before submission  
✅ **Catching missing citations** - Find citation keys not in your .bib file  
✅ **Multi-author projects** - Ensure everyone's references are included  

## Common Issues and Solutions

### Issue: Getting false positives

**Problem:** Labels in comments are being counted

**Solution:** Filter out commented lines first:
```bash
grep -v '^%' paper.tex | grep -o '\\label{tab:[^}]*}'
```

### Issue: Multi-file documents

**Problem:** Main file uses `\input{}` or `\include{}`

**Solution:** Concatenate first or check each file:
```bash
cat main.tex chapters/*.tex | grep -o '\\label{tab:[^}]*}' | wc -l
```

### Issue: Labels in separate files

**Problem:** Figures defined in `figures.tex` but referenced in `main.tex`

**Solution:** Check all files together:
```bash
# Labels from all files
grep -o '\\label{fig:[^}]*}' *.tex | sed 's/.*{\(.*\)}/\1/' | sort -u > labels.txt

# Refs from all files  
grep -oE '\\(auto)?ref\{fig:[^}]*\}' *.tex | sed 's/.*{\(.*\)}/\1/' | sort -u > refs.txt

# Compare
comm -23 labels.txt refs.txt
```

## Integration with Overleaf

Since Overleaf provides a Git interface, you can:

1. Clone your Overleaf project locally
2. Run the reference checker
3. Fix unreferenced elements
4. Push back to Overleaf

```bash
git clone https://git.overleaf.com/your-project-id
cd your-project-name
./check_refs.sh main.tex
# Fix issues
git add .
git commit -m "Fixed unreferenced floats"
git push
```

## VS Code Integration

Add this to your VS Code tasks (`.vscode/tasks.json`):

```json
{
    "version": "2.0.0",
    "tasks": [
        {
            "label": "Check LaTeX References",
            "type": "shell",
            "command": "./check_refs.sh ${file}",
            "group": "test",
            "presentation": {
                "echo": true,
                "reveal": "always",
                "panel": "new"
            }
        }
    ]
}
```

Run with: `Ctrl+Shift+P` → `Tasks: Run Task` → `Check LaTeX References`

## Checking Citations

Beyond tables, figures, and equations, you also want to ensure your bibliography is complete and clean. Here's how to check citations:

### Basic Citation Counts

```bash
# Count total citation commands
grep -oE '\\(cite|citep|citet|autocite|textcite|parencite)[*]?\{[^}]*\}' paper.tex | wc -l

# Count unique cited keys
grep -oE '\\cite[a-z]*[*]?\{[^}]*\}' paper.tex | \
sed 's/.*{\(.*\)}/\1/' | tr ',' '\n' | sort -u | grep -v '^$' | wc -l

# Count entries in .bib file
grep -c '^@' references.bib
```

### Find Uncited Bibliography Entries

These are entries in your `.bib` file that you never cite in the text:

```bash
comm -23 \
  <(grep '^@' references.bib | sed 's/@[^{]*{\([^,]*\).*/\1/' | sort -u) \
  <(grep -oE '\\cite[a-z]*[*]?\{[^}]*\}' paper.tex | \
    sed 's/.*{\(.*\)}/\1/' | tr ',' '\n' | sort -u)
```

**Output example:**
```
smith2020old
jones2019unused
brown2018extra
```

These entries can be removed to clean up your bibliography.

### Find Missing Bibliography Entries

Even more critical — citations in your text that don't exist in your `.bib` file:

```bash
comm -13 \
  <(grep '^@' references.bib | sed 's/@[^{]*{\([^,]*\).*/\1/' | sort -u) \
  <(grep -oE '\\cite[a-z]*[*]?\{[^}]*\}' paper.tex | \
    sed 's/.*{\(.*\)}/\1/' | tr ',' '\n' | sort -u)
```

**Output example:**
```
nguyen2023missing
patel2024notfound
```

This will cause LaTeX compilation errors — you need to add these to your `.bib` file!

### Understanding the Citation Pattern

The regex `\\cite[a-z]*[*]?\{[^}]*\}` matches:
- `\cite{key}` - Basic citation
- `\citep{key}` - Parenthetical (natbib)
- `\citet{key}` - Textual (natbib)
- `\autocite{key}` - Auto citation (biblatex)
- `\textcite{key}` - Text citation (biblatex)
- `\parencite{key}` - Parenthetical (biblatex)
- All with optional `*` variant

### Handling Multi-key Citations

Citations like `\cite{key1,key2,key3}` are properly handled:

```bash
# The tr ',' '\n' splits comma-separated keys
grep -oE '\\cite\{[^}]*\}' paper.tex | \
sed 's/.*{\(.*\)}/\1/' | \
tr ',' '\n' | \
sed 's/^[[:space:]]*//;s/[[:space:]]*$//' | \
sort -u
```

### Complete Citation Summary

Quick one-liner for full statistics:

```bash
echo "Bib entries: $(grep -c '^@' references.bib)"
echo "Cite commands: $(grep -oE '\\cite[a-z]*\{[^}]*\}' paper.tex | wc -l)"
echo "Unique keys: $(grep -oE '\\cite[a-z]*\{[^}]*\}' paper.tex | sed 's/.*{\(.*\)}/\1/' | tr ',' '\n' | sort -u | grep -v '^$' | wc -l)"
```

### Updated Complete Script

The enhanced script includes citation checking:

```bash
./check_refs_with_citations.sh paper.tex references.bib

# Or auto-detect .bib file from \bibliography{} command
./check_refs_with_citations.sh paper.tex
```

**Sample output:**
```
=== CITATIONS ===
Using bibliography file: references.bib
Total bib entries: 45
Total citation commands: 52
Unique cited keys: 38

Uncited bibliography entries:
smith2020old
jones2019unused
brown2018extra

Missing bibliography entries (cited but not in .bib):
nguyen2023missing
```

### Citation Check Best Practices

**Before submission:**
1. Run citation check to find missing entries
2. Add missing entries to `.bib` file
3. Remove uncited entries (optional - some journals accept extras)
4. Verify key names match exactly (case-sensitive!)

**Common issues:**
- Typos in citation keys (`smith2023` vs `smith2024`)
- Case sensitivity (`Smith2023` vs `smith2023`)
- Special characters in keys (use alphanumeric + underscore only)
- Multiple `.bib` files (check all of them)

## Conclusion

This simple bash-based approach saves time and prevents embarrassing submission mistakes. No need for complex LaTeX parsers or specialized tools — just `grep`, `sed`, `sort`, and `comm`.

The script works on Linux, macOS, and Windows (via WSL or Git Bash). Add it to your pre-submission checklist!

## Additional Resources

- [LaTeX Label and Reference Best Practices](https://en.wikibooks.org/wiki/LaTeX/Labels_and_Cross-referencing)
- [GNU grep Manual](https://www.gnu.org/software/grep/manual/)
- [comm Command Documentation](https://man7.org/linux/man-pages/man1/comm.1.html)

---

**Found this helpful?** Check out more LaTeX productivity tips on [ScholarNote.org](https://scholarnote.org) and [blog.drabdus.info](https://blog.drabdus.info), follow [ScholarNote](https://www.facebook.com/scholarsnote)
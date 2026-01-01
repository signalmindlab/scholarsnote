---
title: "Finding Unreferenced Tables, Figures, and Equations in LaTeX Documents"
date: 2026-01-02
author: "Scholarsnote"
categories: [LaTeX, Academic Writing, Productivity]
tags: [latex, bash, grep, research, manuscript-preparation]
description: "A simple bash command-line approach to identify unreferenced floats and elements in your LaTeX manuscripts before submission"
---

## The Problem

When writing academic papers in LaTeX, it's easy to create tables, figures, equations, or algorithms and forget to reference them in the text. Journal reviewers often flag this issue, and some journals explicitly require that all floats be cited. Manually tracking all your `\label{}` and `\ref{}` commands becomes tedious, especially in long manuscripts.

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

Here's a comprehensive script to check all common LaTeX elements:

```bash
#!/bin/bash
# save as check_refs.sh

FILE="${1:-paper.tex}"

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
# Check default paper.tex
./check_refs.sh

# Check specific file
./check_refs.sh manuscript.tex
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

## Conclusion

This simple bash-based approach saves time and prevents embarrassing submission mistakes. No need for complex LaTeX parsers or specialized tools — just `grep`, `sed`, `sort`, and `comm`.

The script works on Linux, macOS, and Windows (via WSL or Git Bash). Add it to your pre-submission checklist!

## Additional Resources

- [LaTeX Label and Reference Best Practices](https://en.wikibooks.org/wiki/LaTeX/Labels_and_Cross-referencing)
- [GNU grep Manual](https://www.gnu.org/software/grep/manual/)
- [comm Command Documentation](https://man7.org/linux/man-pages/man1/comm.1.html)

---

**Found this helpful?** Check out more LaTeX productivity tips on [ScholarNote.org](https://scholarnote.org) and [blog.drabdus.info](https://blog.drabdus.info), follow [ScholarNote](https://www.facebook.com/scholarsnote)

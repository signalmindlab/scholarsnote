---
title: "LaTeX Citation Key Replacement: PowerShell Script to Convert Numeric Citations"
description: "A practical PowerShell script for researchers to automate the conversion of numeric citations to proper citation keys in LaTeX documents."
date: 2026-01-01 10:00:00 +0900
categories: [Research, LaTeX]
tags: [latex, powershell, automation, academic-writing, bibliography-management, citation-management]
author: Md Abdus Samad
pin: false
---

When working across reference managers, collaborators, or export tools, LaTeX documents often end up with numeric citations such as `\cite{1}`, `\cite{2}` that do not match the proper citation keys in the `.bib` file. Manually replacing each citation in a large manuscript is tedious and error-prone. This PowerShell script automates the entire process: it reads a user-defined number-to-key mapping, replaces every numeric citation in the `.tex` file, and writes the result to a new file — leaving the original untouched.

## The Problem

During manuscript preparation, a mismatch between citation format and bibliography keys is common:

- **Numeric citations in `.tex`** — `\cite{1}`, `\cite{2}` do not compile with named `.bib` keys.
- **Named keys in `.bib`** — `smith2023keyword` causes undefined citation warnings when the `.tex` uses numbers.
- **Manual replacement** — Ctrl+H per citation is time-consuming and introduces errors.
- **Large reference lists** — 50–100+ citations make the manual approach impractical.

## The Solution

### Features

- **Interactive file selection**: Opens a file browser to select your `.tex` file — no command-line path needed
- **Mapping-based replacement**: Define each number-to-key pair once in a simple hashtable
- **Regex-powered**: Handles all `\cite{N}` occurrences in a single pass
- **Non-destructive**: Saves output as `yourfile_updated.tex`; original is never modified
- **Warning on missing keys**: Reports unmapped citation numbers without stopping
- **Preview on completion**: Shows a sample of the replaced citation keys

## Installation and Usage

Follow these steps to use the citation replacement script:

1. **Download the script** — Download `replace-citations.ps1` (link below) and save it anywhere on your PC
2. **Edit the mapping** — Open the script in any text editor and update the `$citationMap` section
3. **Run the script** — Right-click the file and choose **Run with PowerShell**

### Step 1: Download the Script

[**Download replace-citations.ps1**](/assets/files/replace-citations.ps1){: .btn .btn-primary }

Open the downloaded file in any text editor (Notepad, VS Code, etc.) and update the `$citationMap` section with your own number-to-key pairs before running.

### Step 2: Edit the Citation Mapping

Look up each citation number in your `.bib` file and add the corresponding key to the mapping. For example, if your `.bib` file contains:

```bibtex
%1
@article{smith2023keyword,
  author = {Smith, John and Lee, Jane},
  title  = {Title of the First Paper},
  year   = {2023}
}

%2
@inproceedings{doe2024analysis,
  author    = {Doe, Alice and Park, James},
  title     = {Title of the Second Paper},
  booktitle = {Proceedings of the Conference Name},
  year      = {2024}
}
```

Edit the `$citationMap` block in the script accordingly:

```powershell
$citationMap = @{
    '1' = 'smith2023keyword'
    '2' = 'doe2024analysis'
    # add more entries as needed
}
```

> Always wrap citation numbers in single quotes: `'1'`, not `1`.
{: .prompt-tip }

### Step 3: One-Time PowerShell Setup

If you have not run a PowerShell script before, enable script execution once:

1. Press `Windows + X` and click **Windows PowerShell (Admin)**
2. Run: `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser`
3. Press `Y` and Enter

This is a one-time step and does not need to be repeated.

### Step 4: Run the Script

Right-click `replace-citations.ps1` and choose **Run with PowerShell**, or run from a terminal:

```powershell
.\replace-citations.ps1
```

A file browser opens — select your `.tex` file. The script processes it and saves the result as `yourfile_updated.tex` in the same folder.

> Always keep a backup of your original `.tex` file before running any automated replacement, especially for final thesis or dissertation submissions.
{: .prompt-warning }

## Example Output

After running the script, the terminal displays a summary:

```
Please select your LaTeX file...
Selected: C:\Projects\paper\manuscript.tex

Processing file...
Found 52 numeric citations

✓ Replacement complete!
Output: C:\Projects\paper\manuscript_updated.tex

Preview of replacements:
  \cite{smith2023keyword}
  \cite{doe2024analysis}
  \cite{lee2024algorithms}
```

## Before and After

**Before (`manuscript.tex`):**

```latex
Recent advances have been studied \cite{1}\cite{2}.
Further results confirmed the methodology \cite{2}.
```

**After (`manuscript_updated.tex`):**

```latex
Recent advances have been studied \cite{smith2023keyword}\cite{doe2024analysis}.
Further results confirmed the methodology \cite{doe2024analysis}.
```

> Back-to-back citations like `\cite{A}\cite{B}` can be merged into `\cite{A,B}` for cleaner output (e.g., [1,2] instead of [1][2]).
{: .prompt-tip }

## Technical Deep Dive

### How It Works

#### 1. The Citation Mapping

```powershell
$citationMap = @{
    '1' = 'smith2023keyword'
    '2' = 'doe2024analysis'
}
```

The hashtable acts as a lookup dictionary. For each numeric citation found in the document, the script looks up the corresponding key and substitutes it.

#### 2. The Regex Pattern

```powershell
$pattern = '\\cite\{(\d+)\}'
```

| Component | Meaning |
|-----------|---------|
| `\\cite` | Matches the literal text `\cite` |
| `\{` and `\}` | Matches the surrounding curly braces |
| `(\d+)` | Captures one or more digits as the citation number |

#### 3. The Replacement Logic

```powershell
$result = [regex]::Replace($content, $pattern, {
    param($match)
    $number = $match.Groups[1].Value
    $key    = $citationMap[$number]
    if ($key) { return "\cite{$key}" }
    else {
        Write-Host "Warning: No mapping for citation $number" -ForegroundColor Yellow
        return $match.Value
    }
})
```

For each match, the script extracts the captured number, looks it up in the hashtable, and returns the replacement. If a number has no mapping, the original citation is preserved and a warning is printed.

## Scaling to Large Reference Lists

The mapping supports any number of entries. Add one line per citation:

```powershell
$citationMap = @{
    '1'   = 'smith2023keyword'
    '2'   = 'doe2024analysis'
    '50'  = 'lee2024algorithms'
    '100' = 'wang2023method'
}
```

The script processes all entries in a single pass regardless of document size.

## Troubleshooting

**"Scripts are disabled on this system"**
Execution policy not set. Run as Admin:
```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

**Nothing got replaced**
Citations may have spaces: `\cite{ 1 }`. Remove spaces inside braces in the `.tex` file.

**"Warning: No mapping for citation X"**
Number X is not in `$citationMap`. Add the entry, or leave it — the original citation is preserved.

**Output file not found**
The file browser was cancelled. Re-run and select a file when the dialog opens.

## Best Practices

- **Test first**: Run the script on a short sample file before applying it to a full manuscript
- **Verify the mapping**: A wrong number-to-key assignment produces incorrect citations silently
- **Use descriptive keys**: Prefer `smith2023keyword` over `ref1` for long-term readability
- **No duplicate keys**: Each citation number must map to exactly one unique key

---

## How to Cite

> Samad, M. A. (2026). LaTeX citation key replacement: PowerShell script to convert numeric citations. *ScholarsNote*. <https://www.scholarsnote.org/posts/latex-citation-automation-blog/>

**BibTeX:**

```bibtex
@misc{samad2026latexcitation,
  author       = {Samad, Md Abdus},
  title        = {LaTeX Citation Key Replacement: PowerShell
                  Script to Convert Numeric Citations},
  year         = {2026},
  month        = jan,
  howpublished = {ScholarsNote},
  url          = {https://www.scholarsnote.org/posts/latex-citation-automation-blog/},
  note         = {Accessed: 2026-01-01}
}
```

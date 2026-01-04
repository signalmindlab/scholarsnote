---
title: "Git Commands Cheatsheet: Renaming Overleaf Projects"
date: 2025-01-04
author: "Scholarsnote"
categories: [Git, LaTeX, Overleaf]
tags: [git-bash, overleaf, latex-workflow, quick-reference, productivity]
description: "Quick reference guide for renaming and organizing Overleaf Git repositories with essential Git Bash commands"
featured: true
---

## Overview

When you sync an Overleaf project with Git, Overleaf uses its internal project ID as the default folder name - something like `Project_ID`. This creates an unorganized workspace that's difficult to navigate. This cheatsheet provides quick commands to rename and reorganize your Overleaf Git repositories into a clean, logical structure.

**Key Benefits:**
- Meaningful project names instead of cryptic IDs
- Organized folder structure for multiple projects
- No disruption to Git synchronization
- Better integration with VS Code and LaTeX Workshop

---

## The Problem

After cloning Overleaf projects, you end up with:

| Issue | Example | Impact |
|-------|---------|--------|
| Cryptic folder names | `Project_ID/` | Can't identify projects at a glance |
| Nested in parent folder | `overleaf-projects/Project_ID/` | Extra navigation steps |
| No logical organization | All projects in one folder | Difficult to manage multiple papers |
| Hard to track in terminal | Long, meaningless paths | Slower workflow |

**Before:**
```
Documents/
└── overleaf-projects/
    ├── Project_ID_1/
    ├── Project_ID_2/
    └── Project_ID_3/
```

**After:**
```
Documents/Research/
├── journal-papers/
│   └── signal-processing-2025/
├── conference-papers/
│   └── ieee-icc-2025/
└── thesis-chapters/
    └── chapter-01-introduction/
```

---

## Quick Commands

### Basic Rename

```bash
# Current location: ~/Documents/overleaf-projects
$ mv Project_ID my-research-paper
```

### Move to Parent Directory

```bash
# Current location: ~/Documents/overleaf-projects
$ mv my-research-paper ..
```

### Rename + Move (One Command)

```bash
# Current location: ~/Documents/overleaf-projects
$ mv Project_ID ~/Documents/my-research-paper
```

### Verify Git Connection

```bash
# Current location: ~/Documents/my-research-paper
$ git status
$ git remote -v
$ git pull
$ git push
```

---

## Complete Workflow

### Step 1: Navigate to Projects Folder

```bash
# Current location: ~
$ cd ~/Documents/overleaf-projects
```

### Step 2: Check Current Projects

```bash
# Current location: ~/Documents/overleaf-projects
$ ls
Project_ID/
```

### Step 3: Rename the Project

```bash
# Current location: ~/Documents/overleaf-projects
$ mv Project_ID ai-applications-paper
```

### Step 4: Move to Research Folder

```bash
# Current location: ~/Documents/overleaf-projects
$ mv ai-applications-paper ~/Documents/Research/journal-papers/
```

### Step 5: Navigate to New Location

```bash
# Current location: ~/Documents/overleaf-projects
$ cd ~/Documents/Research/journal-papers/ai-applications-paper
```

### Step 6: Verify Git Works

```bash
# Current location: ~/Documents/Research/journal-papers/ai-applications-paper
$ git status
$ git remote -v
```

**Expected output:**
```
On branch master
Your branch is up to date with 'origin/master'.

nothing to commit, working tree clean

origin  https://git.overleaf.com/Project_ID (fetch)
origin  https://git.overleaf.com/Project_ID (push)
```

---

## Organizing Multiple Projects

### Create Folder Structure

```bash
# Current location: ~
$ mkdir -p ~/Documents/Research/{journal-papers,conference-papers,thesis-chapters}
```

### Move Projects to Categories

```bash
# Current location: ~/Documents/overleaf-projects
$ mv Project_ID_1 ~/Documents/Research/journal-papers/signal-processing-paper
$ mv Project_ID_2 ~/Documents/Research/conference-papers/deep-learning-study
$ mv Project_ID_3 ~/Documents/Research/thesis-chapters/chapter-01
```

### Verify Organization

```bash
# Current location: ~/Documents/overleaf-projects
$ cd ~/Documents/Research

# Current location: ~/Documents/Research
$ ls -la
drwxr-xr-x journal-papers/
drwxr-xr-x conference-papers/
drwxr-xr-x thesis-chapters/
```

### Check Individual Projects

```bash
# Current location: ~/Documents/Research
$ cd journal-papers/signal-processing-paper

# Current location: ~/Documents/Research/journal-papers/signal-processing-paper
$ git status
```

---

## Naming Conventions

### Good vs Bad Names

| ✅ Good | ❌ Bad | Reason |
|---------|--------|--------|
| `ieee-conference-2025` | `project1` | Descriptive and specific |
| `nature-paper-2025` | `my project` | No spaces, includes year |
| `thesis-chapter-03` | `New Folder (1)` | Follows pattern, no special chars |
| `acm-submission-jan` | `finalFINALv2` | Professional naming |
| `deep-learning-survey` | `Untitled` | Topic-based identification |

### Recommended Pattern

**Format:** `[venue/journal]-[topic]-[year]`

**Examples:**
- `ieee-transactions-signal-processing-2025`
- `nature-communications-ai-2025`
- `icml-reinforcement-learning-2024`
- `phd-thesis-chapter-02-methodology`
- `grant-proposal-nsf-2025`

---

## Recommended Folder Structure

```
~/Documents/Research/
├── journal-papers/
│   ├── ieee-transactions-2025/
│   ├── nature-communications-2025/
│   ├── elsevier-applied-science-2024/
│   └── springer-jmlr-2025/
├── conference-papers/
│   ├── icc-2025-submission/
│   ├── globecom-2025-paper/
│   ├── wcnc-2024-published/
│   └── cvpr-2025-workshop/
├── thesis-chapters/
│   ├── chapter-01-introduction/
│   ├── chapter-02-literature-review/
│   ├── chapter-03-methodology/
│   ├── chapter-04-experiments/
│   └── chapter-05-conclusion/
├── grant-proposals/
│   ├── nsf-proposal-2025/
│   └── research-foundation-grant/
└── technical-reports/
    ├── quarterly-report-q1-2025/
    └── annual-review-2024/
```

---

## Batch Operations

### Rename Multiple Projects

```bash
# Current location: ~/Documents/overleaf-projects
$ ls
Project_ID_1/
Project_ID_2/
Project_ID_3/

$ mv Project_ID_1 medical-imaging-analysis
$ mv Project_ID_2 network-optimization-study
$ mv Project_ID_3 machine-learning-survey
```

### Automated Loop (Advanced)

```bash
# Current location: ~/Documents/overleaf-projects
$ for dir in */; do
    echo "Found project: $dir"
    # Add your renaming logic here
done
```

---

## VS Code Integration

### Open Project in VS Code

```bash
# Current location: ~
$ cd ~/Documents/Research/journal-papers/ai-applications-paper

# Current location: ~/Documents/Research/journal-papers/ai-applications-paper
$ code .
```

**Result:** VS Code opens with full Git support and LaTeX Workshop integration

### Add to Workspace

After renaming, add the project to your VS Code workspace:

1. Open VS Code
2. File → Add Folder to Workspace
3. Navigate to renamed project folder
4. LaTeX Workshop automatically detects configuration

---

## Troubleshooting

### Issue: Permission Denied

**Problem:**
```bash
# Current location: ~/Documents/overleaf-projects
$ mv Project_ID my-paper
mv: cannot move 'Project_ID': Permission denied
```

**Solution:**
1. Close VS Code or any editor accessing the folder
2. Close File Explorer windows showing the folder
3. Close any terminal windows in that directory
4. Try the command again

**Check what's using the folder:**
```bash
# On Linux/Mac
$ lsof +D ~/Documents/overleaf-projects/Project_ID

# On Windows Git Bash
$ tasklist | grep -i "code\|explorer"
```

### Issue: Directory Not Empty

**Problem:**
```bash
# Current location: ~/Documents
$ mv overleaf-projects/my-paper .
mv: cannot move 'overleaf-projects/my-paper' to './my-paper': Directory not empty
```

**Solution:**
```bash
# Current location: ~/Documents
$ mv -f overleaf-projects/my-paper .
```

Or remove the existing directory first:
```bash
# Current location: ~/Documents
$ rm -rf my-paper
$ mv overleaf-projects/my-paper .
```

### Issue: Git Remote URL Verification

**Check configuration:**
```bash
# Current location: ~/Documents/my-research-paper
$ cat .git/config
```

**Look for:**
```ini
[remote "origin"]
    url = https://git.overleaf.com/Project_ID
    fetch = +refs/heads/*:refs/remotes/origin/*
```

**The URL should still point to your Overleaf project** - it doesn't change when you rename the local folder.

### Issue: Changes Not Syncing

**Verify remote connection:**
```bash
# Current location: ~/Documents/my-research-paper
$ git remote -v
origin  https://git.overleaf.com/Project_ID (fetch)
origin  https://git.overleaf.com/Project_ID (push)

$ git fetch
$ git status
```

**If fetch fails:**
```bash
# Check network connection
$ ping google.com

# Check Git configuration
$ git config --list

# Re-authenticate if needed
$ git config credential.helper store
$ git pull
```

---

## Command Reference

### Essential Git Commands

| Command | Purpose | Usage Example |
|---------|---------|---------------|
| `git status` | Check repository status | `git status` |
| `git remote -v` | View remote URLs | `git remote -v` |
| `git pull` | Sync from Overleaf | `git pull origin master` |
| `git push` | Push to Overleaf | `git push origin master` |
| `git log` | View commit history | `git log --oneline` |
| `git branch` | List branches | `git branch -a` |

### Navigation Commands

| Command | Purpose | Usage Example |
|---------|---------|---------------|
| `cd` | Change directory | `cd ~/Documents` |
| `pwd` | Print working directory | `pwd` |
| `ls` | List contents | `ls -la` |
| `mkdir` | Create directory | `mkdir -p path/to/folder` |
| `mv` | Move/rename | `mv old new` |
| `cp` | Copy files | `cp -r source dest` |

### File Management Commands

| Command | Purpose | Usage Example |
|---------|---------|---------------|
| `ls -la` | Detailed listing | `ls -la ~/Documents` |
| `tree` | Show tree structure | `tree -L 2` |
| `find` | Find files | `find . -name "*.tex"` |
| `du -sh` | Directory size | `du -sh ~/Documents/Research` |

---

## One-Line Solutions

### Rename Only
```bash
$ cd ~/Documents/overleaf-projects && mv Project_ID my-research-paper
```

### Rename + Move to Documents
```bash
$ mv ~/Documents/overleaf-projects/Project_ID ~/Documents/my-research-paper
```

### Rename + Move to Research Folder
```bash
$ mv ~/Documents/overleaf-projects/Project_ID ~/Documents/Research/journal-papers/my-paper-2025
```

### Create Structure + Move
```bash
$ mkdir -p ~/Documents/Research/journal-papers && mv ~/Documents/overleaf-projects/Project_ID ~/Documents/Research/journal-papers/signal-processing-2025
```

---

## Verification Checklist

After renaming/moving, verify:

- [ ] Navigate to new location successfully
- [ ] `git status` shows no errors
- [ ] `git remote -v` shows correct Overleaf URL
- [ ] `git pull` works without issues
- [ ] `git push` works without issues
- [ ] VS Code/LaTeX Workshop recognizes the project
- [ ] All `.tex`, `.bib`, and figure files are present
- [ ] LaTeX compilation works as expected

**Quick verification script:**
```bash
# Current location: ~/Documents/my-research-paper
$ git status && git remote -v && echo "✓ Git OK"
```

---

## Advanced Tips

### Create Alias for Quick Navigation

Add to `~/.bashrc` or `~/.bash_profile`:

```bash
alias research='cd ~/Documents/Research'
alias journals='cd ~/Documents/Research/journal-papers'
alias conferences='cd ~/Documents/Research/conference-papers'
```

**Usage:**
```bash
$ research
$ journals
$ ls
ieee-transactions-2025/  nature-communications-2025/
```

### Git Bash Prompt Customization

Show current directory in prompt:

```bash
# Add to ~/.bashrc
export PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
```

### Tab Completion

Enable bash completion for faster navigation:

```bash
# On Ubuntu/Debian
$ sudo apt install bash-completion

# On macOS
$ brew install bash-completion
```

---

## Performance Tips

### For Large Projects

**Use shallow clone to save space:**
```bash
$ git clone --depth=1 https://git.overleaf.com/Project_ID
```

**Compress .git folder:**
```bash
# Current location: ~/Documents/my-research-paper
$ git gc --aggressive --prune=now
```

### For Multiple Projects

**Batch verify all repositories:**
```bash
# Current location: ~/Documents/Research
$ find . -name ".git" -type d -execdir git status \;
```

**Batch pull updates:**
```bash
# Current location: ~/Documents/Research
$ find . -name ".git" -type d -execdir git pull \;
```

---

## Key Takeaways

✅ **Git configuration is independent** of folder name  
✅ **Remote URL stays unchanged** after renaming  
✅ **Always verify** with `git status` after moving  
✅ **Close all programs** accessing the folder before renaming  
✅ **Use meaningful names** for better organization  
✅ **Create logical folder structure** for multiple projects  
✅ **Folder structure doesn't affect** Git synchronization  
✅ **VS Code automatically recognizes** renamed Git repositories  

---

## Real-World Case Study

### Initial State

PhD student with 15 Overleaf projects:

```
~/Documents/overleaf-projects/
├── Project_ID_1/
├── Project_ID_2/
├── Project_ID_3/
├── Project_ID_4/
├── Project_ID_5/
├── Project_ID_6/
... (9 more)
```

**Problem:** Wasted 5-10 minutes daily searching for the right project

### Actions Taken

```bash
# 1. Create structure
$ mkdir -p ~/Documents/Research/{journal-papers,conference-papers,thesis-chapters,coursework}

# 2. Rename and categorize
$ cd ~/Documents/overleaf-projects
$ mv Project_ID_1 ~/Documents/Research/thesis-chapters/chapter-01-introduction
$ mv Project_ID_2 ~/Documents/Research/journal-papers/ieee-transactions-2024
$ mv Project_ID_3 ~/Documents/Research/conference-papers/icml-2024
# ... continue for all projects

# 3. Remove old folder
$ cd ..
$ rmdir overleaf-projects
```

### Final State

```
~/Documents/Research/
├── journal-papers/
│   ├── ieee-transactions-2024/
│   └── nature-communications-2025/
├── conference-papers/
│   ├── icml-2024-published/
│   ├── neurips-2024-submission/
│   └── cvpr-2025-workshop/
├── thesis-chapters/
│   ├── chapter-01-introduction/
│   ├── chapter-02-literature/
│   ├── chapter-03-methodology/
│   └── chapter-04-experiments/
└── coursework/
    ├── machine-learning-final/
    └── optimization-project/
```

**Time saved:** 5 minutes/day × 250 working days = **~21 hours/year**  
**Outcome:** Instant project identification, faster workflow, reduced stress

---

## Related Resources

- [Overleaf Git Integration Documentation](https://www.overleaf.com/learn/how-to/Using_Git_and_GitHub)
- [Git Basics - Working with Remotes](https://git-scm.com/book/en/v2/Git-Basics-Working-with-Remotes)
- [Pro Git Book (Free)](https://git-scm.com/book/en/v2)
- [LaTeX Workshop VS Code Extension](https://marketplace.visualstudio.com/items?itemName=James-Yu.latex-workshop)

---

## License

MIT License - Free to use, modify, and distribute.

---

## Citation

If you find this cheatsheet useful in your research workflow:

```bibtex
@misc{git_overleaf_cheatsheet_2025,
  title={Git Commands Cheatsheet: Renaming Overleaf Projects},
  author={Scholarsnote},
  year={2026},
  url={https://www.scholarsnote.org/git-overleaf-rename-cheatsheet/},
  note={Accessed: 2026-01-04}
}
```

---

**Last updated:** January 4, 2025  
**Tested on:** Ubuntu 20.04+, macOS 12+, Git Bash (Windows)  
**Author:** Dr. Abdus Samad  
**Website:** [scholarsnote.org](https://www.scholarsnote.org/)

---

*This guide is part of our LaTeX productivity series. Follow for more tips on academic writing workflows.*

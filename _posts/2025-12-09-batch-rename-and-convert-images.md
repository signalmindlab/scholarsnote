---
title: "Batch Rename TIFF Files and Convert Images to TIFF on Windows"
date: 2025-01-15 12:00:00 +0900
categories: [Guides, Automation]
tags: [windows, powershell, imagemagick, batch-renaming, tiff]
description: "A simple Windows-only guide for batch renaming TIFF files and converting JPG/JPEG/PNG images to TIFF using PowerShell and ImageMagick."
---

Managing large sets of figures or images often becomes tedious when filenames are inconsistent or when a specific format such as TIFF is required for publication, archiving, or processing tools.  
This guide shows how to perform two common tasks **easily and automatically** on **Windows**:

1. **Batch renaming TIFF files**
2. **Batch converting all JPG/JPEG/PNG images to TIFF**

Everything is done using **PowerShell** and **ImageMagick**, both free and easy to use.

---

## 🔄 1. Batch Rename Numeric TIFF Files to “Fig X.tiff”

If your folder includes names like:

```
7.tiff
8.tiff
Fig 1.tiff
Fig 2.tiff
9.tiff
```

…and you want to rename only the plain-number files (e.g., `7.tiff → Fig 7.tiff`), while leaving already-correct names unchanged, run this PowerShell command in that folder:

```powershell
Get-ChildItem *.tiff | Where-Object {
    $_.BaseName -match '^\d+$'
} | Rename-Item -NewName {
    "Fig " + $_.Name
}
```

### ✔ What this command does
- Renames only files whose names consist of digits (e.g., `7.tiff`, `8.tiff`)
- Leaves files like `Fig 1.tiff` untouched
- Works instantly inside the chosen directory
- No installation required—PowerShell is built into Windows

---

## 🖼️ 2. Batch Convert JPG/JPEG/PNG to TIFF Using ImageMagick

To convert your image folder to TIFF format, install **ImageMagick** if you haven’t already:

👉 https://imagemagick.org

Once installed, open PowerShell in your folder and run:

```powershell
Get-ChildItem *.jpg, *.jpeg, *.png | ForEach-Object {
    $output = $_.BaseName + ".tiff"
    magick $_.FullName $output
}
```

### ✔ What this command does
- Converts every `.jpg`, `.jpeg`, and `.png` file to `.tiff`
- Keeps the same base name  
  (e.g., `photo.jpg` → `photo.tiff`)
- Works on an entire folder automatically

---

## 🎨 Optional: Higher-Quality TIFF Settings

### Use LZW compression (recommended for publication)
```powershell
magick input.jpg -compress lzw output.tiff
```

### Create 16-bit TIFF files (useful for scientific figures)
```powershell
magick input.png -depth 16 output.tiff
```

---

## ✅ Summary

This Windows-only guide covered:

- How to **batch rename numeric TIFF files** to `Fig X.tiff`
- How to **automatically convert JPG/JPEG/PNG images to TIFF**
- Optional enhancements like compression and bit-depth

These tools speed up figure preparation for academic manuscripts, large-scale labeling tasks, archiving workflows, and more.

If you'd like, I can also generate:

- A **downloadable `.ps1` script** that performs all steps at once  
- A **version of this guide with screenshots**  
- A **Chirpy-compatible TOC**, optimized headings, or metadata

Just ask!

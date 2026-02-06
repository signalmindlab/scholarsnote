---
title: "Batch Rename TIFF Files and Convert Images to TIFF on Windows"
date: 2025-01-15 12:00:00 +0900
categories: [Guides, Automation]
tags: [windows, powershell, imagemagick, batch-renaming, tiff]
description: "A practical guide for batch renaming TIFF files and converting JPG, JPEG, and PNG images to TIFF format on Windows using PowerShell and ImageMagick."
author: Md Abdus Samad
doi: "10.59350/XXXXXXXX-XXXXX"
---

Anyone who has dealt with a large collection of images knows the frustration of inconsistent filenames and incompatible formats. Whether you are preparing figures for a journal submission, organizing an image archive, or feeding files into a processing pipeline, having everything named properly and saved in the right format matters more than most people realize. TIFF remains a widely expected format in academic publishing and scientific workflows, yet converting and renaming files one by one is neither practical nor a good use of your time.

This post walks through two straightforward tasks that come up regularly on Windows machines: renaming TIFF files in bulk so they follow a consistent naming pattern, and converting JPG, JPEG, or PNG images into TIFF format automatically. Both tasks rely on tools already available or freely downloadable -- PowerShell, which ships with every modern Windows installation, and ImageMagick, an open-source command-line utility for image processing.

---

## 1. Batch Rename Numeric TIFF Files to "Fig X.tiff"

Suppose your folder contains a mix of filenames like these:

```
7.tiff
8.tiff
Fig 1.tiff
Fig 2.tiff
9.tiff
```

You want to rename only the bare-number files (for example, turning `7.tiff` into `Fig 7.tiff`) while leaving the already-correct names as they are. The following PowerShell command handles this in one step:

```powershell
Get-ChildItem *.tiff | Where-Object {
    $_.BaseName -match '^\d+$'
} | Rename-Item -NewName {
    "Fig " + $_.Name
}
```

### What this command does

- It picks out only those files whose names are purely numeric (such as `7.tiff` or `8.tiff`).
- Files that already carry a proper prefix, like `Fig 1.tiff`, are left untouched.
- The operation runs instantly within the directory where you execute it.
- No additional software is needed since PowerShell is built into Windows.

---

## 2. Batch Convert JPG, JPEG, and PNG to TIFF Using ImageMagick

For format conversion, you will need ImageMagick installed on your machine. It is free and available from <https://imagemagick.org>. Once it is set up, open PowerShell in the folder containing your images and run:

```powershell
Get-ChildItem *.jpg, *.jpeg, *.png | ForEach-Object {
    $output = $_.BaseName + ".tiff"
    magick $_.FullName $output
}
```

### What this command does

- It converts every `.jpg`, `.jpeg`, and `.png` file in the folder to `.tiff` format.
- Each output file keeps the same base name as the original (for instance, `photo.jpg` becomes `photo.tiff`).
- The entire folder is processed automatically in a single pass.

---

## 3. Optional: Higher-Quality TIFF Settings

Depending on your requirements, you may want to adjust compression or bit depth during conversion.

### LZW compression (commonly recommended for publication)

```powershell
magick input.jpg -compress lzw output.tiff
```

### 16-bit TIFF output (useful for scientific figures)

```powershell
magick input.png -depth 16 output.tiff
```

These options can be combined with the batch conversion loop shown above by modifying the `magick` command inside the `ForEach-Object` block.

---

## How to Cite

If you use or refer to this guide in your work, please cite it as follows:

> Samad, M. A. (2025). Batch rename TIFF files and convert images to TIFF on Windows. *ScholarsNote*. <https://doi.org/10.59350/XXXXXXXX-XXXXX>

**BibTeX:**

```bibtex
@misc{samad2025batchtiff,
  author       = {Samad, Md Abdus},
  title        = {Batch Rename TIFF Files and Convert Images to TIFF on Windows},
  year         = {2025},
  month        = jan,
  howpublished = {ScholarsNote},
  url          = {https://www.scholarsnote.org/posts/batch-rename-tiff-files-and-convert-images-to-tiff-on-windows/},
  doi          = {10.59350/XXXXXXXX-XXXXX},
  note         = {Accessed: 2025-01-15}
}
```

---
title: "Creating Professional Image Collages with ImageMagick: A Complete Guide"
date: 2026-01-24
author: "ScholarsNote"
categories: [Guides, Tools]
tags: [imagemagick, figures, academic-writing, image-processing, automation]
description: "Learn how to create professional academic image collages with labeled subfigures using ImageMagick's command-line tools, plus metadata removal techniques for privacy and clean output."
---

Image collages are essential for academic papers, presentations, and technical documentation. In this tutorial, you'll learn how to create a professional 2x1 grid collage with labeled subfigures using ImageMagick's command-line tools.

## What We'll Create

A collage layout with:
- **Top row**: Two images side by side (labeled a and b)
- **Bottom row**: One centered image (labeled c)
- Labels positioned below each image
- Consistent spacing between images
- High resolution output (1500 DPI)
- Clean borders and professional appearance

## Prerequisites

- ImageMagick installed on your system
- Three source images: `Fig_1x.png`, `Fig_1y.png`, `Fig_1z.png`

## The Complete Command

```bash
magick Fig_1x.png -background white -gravity center -extent "%[fx:w]x%[fx:h+200]" -pointsize 80 -gravity South -annotate +0+20 '(a)' a_labeled.png && magick Fig_1y.png -background white -gravity center -extent "%[fx:w]x%[fx:h+200]" -pointsize 80 -gravity South -annotate +0+20 '(b)' b_labeled.png && magick Fig_1z.png -background white -gravity center -extent "%[fx:w]x%[fx:h+200]" -pointsize 80 -gravity South -annotate +0+20 '(c)' c_labeled.png && magick a_labeled.png b_labeled.png +append -background white -gravity center -extent "%[fx:w+20]x%[fx:h]" top_row.png && magick c_labeled.png -background white -gravity center -extent "%[fx:max(w,3000)]x%[fx:h]" bottom_row.png && magick top_row.png bottom_row.png -background white -append -gravity center -extent "%[fx:w]x%[fx:h+20]" -resize 3000x3000\> temp_collage.png && magick temp_collage.png -trim +repage -bordercolor white -border 50 -density 1500 -units PixelsPerInch Fig_1_collage.png
```

## Breaking Down the Command

### Step 1: Add Labels to Each Image

```bash
magick Fig_1x.png -background white -gravity center -extent "%[fx:w]x%[fx:h+200]" -pointsize 80 -gravity South -annotate +0+20 '(a)' a_labeled.png
```

**What's happening:**
- `-extent "%[fx:w]x%[fx:h+200]"`: Adds 200 pixels of white space below the image
- `-pointsize 80`: Sets the label font size to 80 points
- `-gravity South`: Positions text at the bottom center
- `-annotate +0+20 '(a)'`: Places the label "(a)" 20 pixels from the bottom

This process repeats for figures b and c.

### Step 2: Create the Top Row

```bash
magick a_labeled.png b_labeled.png +append -background white -gravity center -extent "%[fx:w+20]x%[fx:h]" top_row.png
```

**What's happening:**
- `+append`: Combines images horizontally (side by side)
- `-extent "%[fx:w+20]x%[fx:h]"`: Adds 20 pixels horizontal gap between images

### Step 3: Prepare the Bottom Row

```bash
magick c_labeled.png -background white -gravity center -extent "%[fx:max(w,3000)]x%[fx:h]" bottom_row.png
```

**What's happening:**
- Centers the single bottom image with proper width matching

### Step 4: Combine Rows and Finalize

```bash
magick top_row.png bottom_row.png -background white -append -gravity center -extent "%[fx:w]x%[fx:h+20]" -resize 3000x3000\> temp_collage.png
```

**What's happening:**
- `-append`: Stacks images vertically
- `-extent "%[fx:w]x%[fx:h+20]"`: Adds 20 pixels vertical gap between rows
- `-resize 3000x3000\>`: Ensures maximum dimension is 3000 pixels (only shrinks if larger)

### Step 5: Final Touch-ups

```bash
magick temp_collage.png -trim +repage -bordercolor white -border 50 -density 1500 -units PixelsPerInch Fig_1_collage.png
```

**What's happening:**
- `-trim +repage`: Removes excess white space from edges
- `-border 50`: Adds clean 50-pixel white border around the entire collage
- `-density 1500 -units PixelsPerInch`: Sets output to high-resolution 1500 DPI

## Customization Options

### Adjust Label Position

Change the annotate offset to move labels:
```bash
-annotate +0+40 '(a)'  # Further from image
-annotate +0+10 '(a)'  # Closer to image
```

### Modify Label Size

```bash
-pointsize 60   # Smaller labels
-pointsize 100  # Larger labels
```

### Change Spacing Between Images

```bash
-extent "%[fx:w+40]x%[fx:h]"  # 40px horizontal gap
-extent "%[fx:w]x%[fx:h+40]"  # 40px vertical gap
```

### Adjust Border Size

```bash
-border 100  # Thicker border
-border 20   # Thinner border
```

---

# Removing Metadata from Images with ImageMagick

When publishing images, especially for academic or professional use, you may want to remove metadata (EXIF data, GPS coordinates, camera settings, software information, etc.) for privacy or to reduce file size.

## Why Remove Metadata?

- **Privacy**: EXIF data can contain location information, timestamps, and device details
- **File Size**: Removing metadata reduces file size
- **Clean Output**: Professional publications often require clean images without embedded metadata
- **Security**: Prevents unintended information disclosure

## Quick Metadata Removal

### Remove Metadata from Single Image

```bash
magick input.png -strip output.png
```

### Remove Metadata from Multiple Images

```bash
magick Fig_1x.png -strip Fig_1x.png
magick Fig_1y.png -strip Fig_1y.png
magick Fig_1z.png -strip Fig_1z.png
```

### In-Place Metadata Removal (Overwrite Original)

```bash
magick mogrify -strip *.png
```

**Warning**: This overwrites original files. Make backups first!

## Integrate Stripping into Collage Creation

Add `-strip` to your collage command to ensure the final output has no metadata:

```bash
magick temp_collage.png -trim +repage -bordercolor white -border 50 -density 1500 -units PixelsPerInch -strip Fig_1_collage.png
```

## Verify Metadata Removal

### Method 1: Using ImageMagick

```bash
magick identify -verbose Fig_1_collage.png | head -50
```

Stripped images show minimal information (just dimensions, format, and basic properties).

### Method 2: Using ExifTool (if installed)

```bash
exiftool Fig_1_collage.png
```

Output should show very minimal metadata:
```
ExifTool Version Number         : 12.40
File Name                       : Fig_1_collage.png
Directory                       : .
File Size                       : 2.3 MB
File Modification Date/Time     : 2026:01:24 10:30:00
File Type                       : PNG
```

### Method 3: Compare File Sizes

```bash
ls -lh original.png stripped.png
```

The stripped version is typically smaller.

### Method 4: Count Metadata Lines

```bash
# Before stripping
magick identify -verbose original.png | wc -l

# After stripping
magick identify -verbose stripped.png | wc -l
```

Stripped images will have significantly fewer lines of output.

## What Gets Removed with -strip?

The `-strip` option removes:
- EXIF data (camera settings, timestamps)
- GPS coordinates
- Thumbnail images
- Color profiles (ICC profiles)
- Comments and annotations
- Software information
- Copyright metadata
- XMP data
- IPTC data

## When NOT to Strip Metadata

Don't remove metadata if you need:
- Color profiles for accurate color reproduction
- Copyright information for attribution
- Camera settings for photography analysis
- GPS data for mapping applications

## Selective Metadata Removal

If you want to keep color profiles but remove other metadata:

```bash
magick input.png -define png:exclude-chunks=date,time input.png
```

Or preserve only specific metadata:

```bash
magick input.png -strip -set comment "My custom description" output.png
```

## Batch Processing Script

For processing many images at once:

```bash
#!/bin/bash
for img in *.png; do
    magick "$img" -strip "cleaned_$img"
done
```

This creates new files with the `cleaned_` prefix.

---

## Conclusion

With ImageMagick, you have powerful control over both image composition and metadata management. The collage command creates professional multi-panel figures perfect for academic publications, while the `-strip` option ensures your images are clean and privacy-safe.

**Key Takeaways:**
- Use `-extent` and `-annotate` for precise label positioning
- Use `+append` for horizontal and `-append` for vertical combinations
- Always set appropriate DPI with `-density` for print quality
- Use `-strip` to remove all metadata from final outputs
- Verify metadata removal with `identify -verbose` or `exiftool`

Happy image processing!

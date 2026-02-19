# replace-citations.ps1 — LaTeX Citation Replacement Script
# Replaces \cite{number} with \cite{citationkey}
# Usage: .\replace-citations.ps1
# Edit the $citationMap below before running.

# Create the citation mapping (add as many as you need)
$citationMap = @{
    '1' = 'smith2023keyword'
    '2' = 'doe2024analysis'
    # '3' = 'your_next_key_here'
}

# Interactive file selection
Write-Host "Please select your LaTeX file..." -ForegroundColor Cyan
Add-Type -AssemblyName System.Windows.Forms

$openFileDialog = New-Object System.Windows.Forms.OpenFileDialog
$openFileDialog.Filter = "LaTeX files (*.tex)|*.tex|All files (*.*)|*.*"
$openFileDialog.Title = "Select your LaTeX file"

if ($openFileDialog.ShowDialog() -eq 'OK') {
    $inputFile = $openFileDialog.FileName
    $outputFile = $inputFile -replace '\.tex$', '_updated.tex'

    Write-Host "Selected: $inputFile" -ForegroundColor Green
} else {
    Write-Host "No file selected. Exiting." -ForegroundColor Red
    exit
}

# Read the file
Write-Host "`nProcessing file..." -ForegroundColor Cyan
$content = Get-Content $inputFile -Raw

# Count citations
$beforeCount = ([regex]::Matches($content, '\\cite\{\d+\}')).Count
Write-Host "Found $beforeCount numeric citations" -ForegroundColor Yellow

# Replace citations using regex
$pattern = '\\cite\{(\d+)\}'
$result = [regex]::Replace($content, $pattern, {
    param($match)
    $number = $match.Groups[1].Value
    $key = $citationMap[$number]

    if ($key) {
        return "\cite{$key}"
    } else {
        Write-Host "Warning: No mapping for citation $number" -ForegroundColor Yellow
        return $match.Value
    }
})

# Save the result
$result | Set-Content $outputFile -NoNewline

# Show results
Write-Host "`n✓ Replacement complete!" -ForegroundColor Green
Write-Host "Output: $outputFile" -ForegroundColor Green

Write-Host "`nPreview of replacements:" -ForegroundColor Magenta
$matches = [regex]::Matches($result, '\\cite\{[a-z]+\d{4}[a-z]+\}') | Select-Object -First 3
foreach ($m in $matches) {
    Write-Host "  $($m.Value)" -ForegroundColor White
}

# Audio Generator Script for KeyboardBaby (PowerShell)
# Generates pronunciation audio files for multiple languages using espeak-ng
# 
# Requirements:
#   - espeak-ng: Download from https://github.com/espeak-ng/espeak-ng/releases
#   - ffmpeg: Download from https://ffmpeg.org/download.html or use: winget install ffmpeg
#
# Usage:
#   .\generate_audio.ps1

param(
    [string[]]$Languages = @("de", "fr", "it", "es")
)

$ErrorActionPreference = "Stop"

# Base directory
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ProjectRoot = Split-Path -Parent $ScriptDir
$SoundDir = Join-Path $ProjectRoot "sound"

Write-Host "========================================================================" -ForegroundColor Cyan
Write-Host "Audio File Generator for KeyboardBaby" -ForegroundColor Cyan
Write-Host "Generating pronunciation files for multiple languages..." -ForegroundColor Cyan
Write-Host "========================================================================" -ForegroundColor Cyan
Write-Host ""

# Language names mapping
$LanguageNames = @{
    "de" = "German"
    "fr" = "French"
    "it" = "Italian"
    "es" = "Spanish"
}

# Check for required tools
function Test-Requirements {
    $missing = $false
    
    # Check for espeak-ng
    try {
        $null = Get-Command espeak-ng -ErrorAction Stop
        Write-Host "✓ espeak-ng found" -ForegroundColor Green
    }
    catch {
        Write-Host "✗ espeak-ng not found" -ForegroundColor Red
        Write-Host "  Download from: https://github.com/espeak-ng/espeak-ng/releases" -ForegroundColor Yellow
        $missing = $true
    }
    
    # # Check for ffmpeg
    # try {
    #     $null = Get-Command ffmpeg -ErrorAction Stop
    #     Write-Host "✓ ffmpeg found" -ForegroundColor Green
    # }
    # catch {
    #     Write-Host "✗ ffmpeg not found" -ForegroundColor Red
    #     Write-Host "  Install with: winget install ffmpeg" -ForegroundColor Yellow
    #     Write-Host "  Or download from: https://ffmpeg.org/download.html" -ForegroundColor Yellow
    #     $missing = $true
    # }
    
    # if ($missing) {
    #     Write-Host ""
    #     Write-Host "Note: If you cannot install these tools, consider:" -ForegroundColor Yellow
    #     Write-Host "  1. Using the Python script: python scripts\generate_audio.py"
    #     Write-Host "  2. Downloading from free resources (see sound\AUDIO_SOURCES.md)"
    #     Write-Host "  3. Recording manually"
    #     exit 1
    # }
    
    Write-Host ""
}

# Generate audio file using espeak-ng
function New-AudioFile {
    param(
        [string]$Character,
        [string]$LanguageCode,
        [string]$LanguageName,
        [string]$OutputFile
    )
    
    # Skip if file exists and is not empty
    if ((Test-Path $OutputFile) -and ((Get-Item $OutputFile).Length -gt 0)) {
        # Check if it's a placeholder (compare with English version)
        $enFile = Join-Path $SoundDir "en\$Character.mp3"
        if (Test-Path $enFile) {
            $outputSize = (Get-Item $OutputFile).Length
            $enSize = (Get-Item $enFile).Length
            
            # If sizes match, it's probably a placeholder
            if ($outputSize -eq $enSize) {
                Write-Host "⟳ Replacing placeholder for $LanguageName $Character" -ForegroundColor Yellow
            }
            else {
                Write-Host "⊘ Skipping $LanguageName $Character (already exists)" -ForegroundColor Gray
                return 2
            }
        }
        else {
            Write-Host "⊘ Skipping $LanguageName $Character (already exists)" -ForegroundColor Gray
            return 2
        }
    }
    
    # Create temporary WAV file
    $tempWav = [System.IO.Path]::GetTempFileName() + ".wav"
    
    try {
        # Generate speech with espeak-ng
        $espeakArgs = @("-v", $LanguageCode, "-w", $tempWav, $Character)
        $espeakProcess = Start-Process -FilePath "espeak-ng" -ArgumentList $espeakArgs -NoNewWindow -Wait -PassThru
        
        if ($espeakProcess.ExitCode -eq 0) {
            # Convert WAV to MP3 with good quality
            $ffmpegArgs = @("-i", $tempWav, "-acodec", "libmp3lame", "-ab", "128k", "-ar", "44100", "-y", $OutputFile)
            $ffmpegProcess = Start-Process -FilePath "ffmpeg" -ArgumentList $ffmpegArgs -NoNewWindow -Wait -PassThru -RedirectStandardError NUL
            
            if ($ffmpegProcess.ExitCode -eq 0) {
                Write-Host "✓ Generated $LanguageName audio for: $Character" -ForegroundColor Green
                Remove-Item $tempWav -ErrorAction SilentlyContinue
                return 0
            }
            else {
                Write-Host "✗ Failed to convert $LanguageName audio for $Character" -ForegroundColor Red
                Remove-Item $tempWav -ErrorAction SilentlyContinue
                return 1
            }
        }
        else {
            Write-Host "✗ Failed to generate $LanguageName audio for $Character" -ForegroundColor Red
            Remove-Item $tempWav -ErrorAction SilentlyContinue
            return 1
        }
    }
    catch {
        Write-Host "✗ Error generating $LanguageName audio for $Character : $_" -ForegroundColor Red
        Remove-Item $tempWav -ErrorAction SilentlyContinue
        return 1
    }
}

# Generate all audio files for a language
function New-LanguageAudio {
    param(
        [string]$LanguageCode,
        [string]$LanguageName
    )
    
    $outputDir = Join-Path $SoundDir $LanguageCode
    
    Write-Host "----------------------------------------------------------------------" -ForegroundColor Cyan
    Write-Host "$LanguageName ($LanguageCode)" -ForegroundColor Cyan
    Write-Host "----------------------------------------------------------------------" -ForegroundColor Cyan
    
    if (-not (Test-Path $outputDir)) {
        Write-Host "Error: Directory $outputDir does not exist!" -ForegroundColor Red
        return
    }
    
    $generated = 0
    $skipped = 0
    $failed = 0
    
    # Generate numbers 0-9
    for ($i = 0; $i -le 9; $i++) {
        $outputFile = Join-Path $outputDir "$i.mp3"
        $result = New-AudioFile -Character $i.ToString() -LanguageCode $LanguageCode -LanguageName $LanguageName -OutputFile $outputFile
        
        if ($result -eq 0) { $generated++ }
        elseif ($result -eq 2) { $skipped++ }
        else { $failed++ }
    }
    
    # Generate letters A-Z
    for ($i = 65; $i -le 90; $i++) {
        $letter = [char]$i
        $outputFile = Join-Path $outputDir "$letter.mp3"
        $result = New-AudioFile -Character $letter -LanguageCode $LanguageCode -LanguageName $LanguageName -OutputFile $outputFile
        
        if ($result -eq 0) { $generated++ }
        elseif ($result -eq 2) { $skipped++ }
        else { $failed++ }
    }
    
    Write-Host ""
    Write-Host "Summary for $LanguageName :" -ForegroundColor Cyan
    Write-Host "  ✓ Generated: $generated files" -ForegroundColor Green
    if ($skipped -gt 0) {
        Write-Host "  ⊘ Skipped: $skipped files" -ForegroundColor Gray
    }
    if ($failed -gt 0) {
        Write-Host "  ✗ Failed: $failed files" -ForegroundColor Red
    }
    Write-Host ""
}

# Main execution
function Main {
    Write-Host "Checking requirements..." -ForegroundColor Cyan
    Test-Requirements
    
    Write-Host "Starting audio generation..." -ForegroundColor Cyan
    Write-Host ""
    
    foreach ($langCode in $Languages) {
        if ($LanguageNames.ContainsKey($langCode)) {
            $langName = $LanguageNames[$langCode]
            New-LanguageAudio -LanguageCode $langCode -LanguageName $langName
        }
        else {
            Write-Host "Warning: Unknown language code '$langCode', skipping..." -ForegroundColor Yellow
        }
    }
    
    Write-Host "========================================================================" -ForegroundColor Cyan
    Write-Host "Generation complete!" -ForegroundColor Cyan
    Write-Host "========================================================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Cyan
    Write-Host "  1. Test the audio files by opening index.html"
    Write-Host "  2. Select a language from the dropdown"
    Write-Host "  3. Press keys to hear the pronunciations"
    Write-Host ""
}

# Run main function
Main

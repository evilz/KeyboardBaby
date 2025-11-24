# Audio Generator Script for KeyboardBaby (PowerShell + Piper)
# Generates pronunciation audio files for multiple languages using Piper (neural TTS)
#
# Requirements:
#   - Python 3 + piper-tts : pip install piper-tts
#   - ffmpeg : winget install ffmpeg   (ou l'installer depuis le site officiel)
#
# Usage:
#   .\generate_audio_piper.ps1
#   .\generate_audio_piper.ps1 -Languages fr,it

param(
    [string[]]$Languages = @("de", "fr", "it", "es")
)

$ErrorActionPreference = "Stop"

# Base directory
$ScriptDir   = Split-Path -Parent $MyInvocation.MyCommand.Path
$ProjectRoot = Split-Path -Parent $ScriptDir
$SoundDir    = Join-Path $ProjectRoot "sound"

Write-Host "========================================================================" -ForegroundColor Cyan
Write-Host "Audio File Generator for KeyboardBaby (Piper Neural TTS)" -ForegroundColor Cyan
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

# Piper model names per language (change if tu préfères d'autres voix)
# Ces modèles sont des exemples qui existent dans piper-voices
$PiperModels = @{
    "de" = "de_DE-thorsten-medium"
    "fr" = "fr_FR-upmc-medium"
    "it" = "it_IT-paola-medium"
    "es" = "es_ES-sharvard-medium"
}

# Check for required tools
function Test-Requirements {
    $missing = $false
    
    # Check for piper
    # try {
    #     $null = Get-Command piper -ErrorAction Stop
    #     Write-Host "✓ piper found" -ForegroundColor Green
    # }
    # catch {
    #     Write-Host "✗ piper not found" -ForegroundColor Red
    #     Write-Host "  Install with: pip install piper-tts" -ForegroundColor Yellow
    #     $missing = $true
    # }
    
    # Check for ffmpeg
    try {
        $null = Get-Command ffmpeg -ErrorAction Stop
        Write-Host "✓ ffmpeg found" -ForegroundColor Green
    }
    catch {
        Write-Host "✗ ffmpeg not found" -ForegroundColor Red
        Write-Host "  Install with: winget install ffmpeg" -ForegroundColor Yellow
        $missing = $true
    }
    
    if ($missing) {
        Write-Host ""
        Write-Host "Please install the missing tools and retry." -ForegroundColor Yellow
        exit 1
    }
    
    Write-Host ""
}

# Generate audio file using Piper + ffmpeg
function New-AudioFile {
    param(
        [string]$Character,
        [string]$LanguageCode,
        [string]$LanguageName,
        [string]$ModelName,
        [string]$OutputFile
    )
    
    # Skip if file exists and is not empty
    if ((Test-Path $OutputFile) -and ((Get-Item $OutputFile).Length -gt 0)) {
        Write-Host "⊘ Skipping $LanguageName $Character (already exists)" -ForegroundColor Gray
        return 2
    }
    
    # Temporary WAV file
    $tempWav = [System.IO.Path]::GetTempFileName() + ".wav"
    
    try {
        # Use Piper CLI:
        # echo "A" | piper --model fr_FR-upmc-medium --output_file temp.wav
        $piperCmd = "echo $Character | piper --model $ModelName --output_file `"$tempWav`""
        
        $piperProcess = Start-Process -FilePath "cmd.exe" `
                                      -ArgumentList "/c $piperCmd" `
                                      -NoNewWindow -Wait -PassThru
        
        if ($piperProcess.ExitCode -eq 0 -and (Test-Path $tempWav)) {
            # Convert WAV to MP3 with good quality (upscale to 44100 Hz if needed)
            $ffmpegArgs = @("-i", $tempWav, "-acodec", "libmp3lame", "-ab", "128k", "-ar", "44100", "-y", $OutputFile)
            $ffmpegProcess = Start-Process -FilePath "ffmpeg" `
                                           -ArgumentList $ffmpegArgs `
                                           -NoNewWindow -Wait -PassThru `
                                           -RedirectStandardError NUL
            
            if ($ffmpegProcess.ExitCode -eq 0) {
                Write-Host "✓ Generated $LanguageName audio for: $Character" -ForegroundColor Green
                Remove-Item $tempWav -ErrorAction SilentlyContinue
                return 0
            }
            else {
                Write-Host "✗ Failed to convert $LanguageName audio for $Character (ffmpeg)" -ForegroundColor Red
                Remove-Item $tempWav -ErrorAction SilentlyContinue
                return 1
            }
        }
        else {
            Write-Host "✗ Failed to generate $LanguageName audio for $Character (piper)" -ForegroundColor Red
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
        [string]$LanguageName,
        [string]$ModelName
    )
    
    $outputDir = Join-Path $SoundDir $LanguageCode
    
    Write-Host "----------------------------------------------------------------------" -ForegroundColor Cyan
    Write-Host "$LanguageName ($LanguageCode) – Model: $ModelName" -ForegroundColor Cyan
    Write-Host "----------------------------------------------------------------------" -ForegroundColor Cyan
    
    if (-not (Test-Path $outputDir)) {
        New-Item -ItemType Directory -Path $outputDir | Out-Null
    }
    
    $generated = 0
    $skipped = 0
    $failed = 0
    
    # Generate numbers 0-9
    for ($i = 0; $i -le 9; $i++) {
        $outputFile = Join-Path $outputDir "$i.mp3"
        $result = New-AudioFile -Character $i.ToString() `
                                -LanguageCode $LanguageCode `
                                -LanguageName $LanguageName `
                                -ModelName $ModelName `
                                -OutputFile $outputFile
        
        if ($result -eq 0) { $generated++ }
        elseif ($result -eq 2) { $skipped++ }
        else { $failed++ }
    }
    
    # Generate letters A-Z
    for ($i = 65; $i -le 90; $i++) {
        $letter = [char]$i
        $outputFile = Join-Path $outputDir "$letter.mp3"
        $result = New-AudioFile -Character $letter `
                                -LanguageCode $LanguageCode `
                                -LanguageName $LanguageName `
                                -ModelName $ModelName `
                                -OutputFile $outputFile
        
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
        if ($LanguageNames.ContainsKey($langCode) -and $PiperModels.ContainsKey($langCode)) {
            $langName  = $LanguageNames[$langCode]
            $modelName = $PiperModels[$langCode]
            New-LanguageAudio -LanguageCode $langCode -LanguageName $langName -ModelName $modelName
        }
        else {
            Write-Host "Warning: Unknown or unconfigured language code '$langCode', skipping..." -ForegroundColor Yellow
        }
    }
    
    Write-Host "========================================================================" -ForegroundColor Cyan
    Write-Host "Generation complete!" -ForegroundColor Cyan
    Write-Host "========================================================================" -ForegroundColor Cyan
    Write-Host ""
}

# Run main function
Main

#!/bin/bash

# Audio Generator Script for KeyboardBaby
# Generates pronunciation audio files for multiple languages using espeak-ng
# 
# Requirements:
#   - espeak-ng: sudo apt-get install espeak-ng
#   - ffmpeg: sudo apt-get install ffmpeg
#
# Usage:
#   ./generate_audio.sh

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Base directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
SOUND_DIR="$PROJECT_ROOT/sound"

echo "========================================================================"
echo "Audio File Generator for KeyboardBaby"
echo "Generating pronunciation files for multiple languages..."
echo "========================================================================"
echo ""

# Check for required tools
check_requirements() {
    local missing=0
    
    if ! command -v espeak-ng &> /dev/null; then
        echo -e "${RED}✗ espeak-ng not found${NC}"
        echo "  Install with: sudo apt-get install espeak-ng"
        missing=1
    else
        echo -e "${GREEN}✓ espeak-ng found${NC}"
    fi
    
    if ! command -v ffmpeg &> /dev/null; then
        echo -e "${RED}✗ ffmpeg not found${NC}"
        echo "  Install with: sudo apt-get install ffmpeg"
        missing=1
    else
        echo -e "${GREEN}✓ ffmpeg found${NC}"
    fi
    
    if [ $missing -eq 1 ]; then
        echo ""
        echo -e "${YELLOW}Note: If you cannot install these tools, consider:${NC}"
        echo "  1. Using the Python script: python3 scripts/generate_audio.py"
        echo "  2. Downloading from free resources (see sound/AUDIO_SOURCES.md)"
        echo "  3. Recording manually"
        exit 1
    fi
    echo ""
}

# Generate audio file using espeak-ng
generate_audio() {
    local char="$1"
    local lang="$2"
    local lang_name="$3"
    local output_file="$4"
    
    # Skip if file exists and is not empty
    if [ -f "$output_file" ] && [ -s "$output_file" ]; then
        # Check if it's a placeholder (compare with English version)
        local en_file="$SOUND_DIR/en/${char}.mp3"
        if [ -f "$en_file" ]; then
            # Use portable file size check
            local output_size=$(wc -c < "$output_file")
            local en_size=$(wc -c < "$en_file")
            
            # If sizes match, it's probably a placeholder
            if [ "$output_size" -eq "$en_size" ]; then
                echo -e "${YELLOW}⟳ Replacing placeholder for ${lang_name} ${char}${NC}"
            else
                echo -e "⊘ Skipping ${lang_name} ${char} (already exists)"
                return 2
            fi
        else
            echo -e "⊘ Skipping ${lang_name} ${char} (already exists)"
            return 2
        fi
    fi
    
    # Create temporary WAV file securely
    local temp_wav=$(mktemp /tmp/keyboard_baby_${lang}_XXXXXX.wav)
    
    # Generate speech with espeak-ng
    # Use language-specific voice settings
    if espeak-ng -v "${lang}" -w "$temp_wav" "$char" 2>/dev/null; then
        # Convert WAV to MP3 with good quality
        if ffmpeg -i "$temp_wav" -acodec libmp3lame -ab 128k -ar 44100 -y "$output_file" &>/dev/null; then
            echo -e "${GREEN}✓ Generated ${lang_name} audio for: ${char}${NC}"
            rm -f "$temp_wav"
            return 0
        else
            echo -e "${RED}✗ Failed to convert ${lang_name} audio for ${char}${NC}"
            rm -f "$temp_wav"
            return 1
        fi
    else
        echo -e "${RED}✗ Failed to generate ${lang_name} audio for ${char}${NC}"
        rm -f "$temp_wav"
        return 1
    fi
}

# Main generation function
generate_all() {
    local lang_code="$1"
    local lang_name="$2"
    local output_dir="$SOUND_DIR/$lang_code"
    
    echo "----------------------------------------------------------------------"
    echo "$lang_name ($lang_code)"
    echo "----------------------------------------------------------------------"
    
    if [ ! -d "$output_dir" ]; then
        echo -e "${RED}Error: Directory $output_dir does not exist!${NC}"
        return 1
    fi
    
    local generated=0
    local skipped=0
    local failed=0
    
    # Generate numbers 0-9
    for i in {0..9}; do
        result=$(generate_audio "$i" "$lang_code" "$lang_name" "$output_dir/${i}.mp3"; echo $?)
        if [ "$result" -eq 0 ]; then
            ((generated++))
        elif [ "$result" -eq 2 ]; then
            ((skipped++))
        else
            ((failed++))
        fi
    done
    
    # Generate letters A-Z
    for letter in {A..Z}; do
        result=$(generate_audio "$letter" "$lang_code" "$lang_name" "$output_dir/${letter}.mp3"; echo $?)
        if [ "$result" -eq 0 ]; then
            ((generated++))
        elif [ "$result" -eq 2 ]; then
            ((skipped++))
        else
            ((failed++))
        fi
    done
    
    echo ""
    echo "Summary for $lang_name:"
    echo "  ✓ Generated: $generated files"
    if [ $skipped -gt 0 ]; then
        echo "  ⊘ Skipped: $skipped files"
    fi
    if [ $failed -gt 0 ]; then
        echo -e "  ${RED}✗ Failed: $failed files${NC}"
    fi
    echo ""
    
    return 0
}

# Main script execution
main() {
    echo "Checking requirements..."
    check_requirements
    
    echo "Starting audio generation..."
    echo ""
    
    # Generate German audio
    generate_all "de" "German"
    
    # Generate French audio
    generate_all "fr" "French"
    
    # Generate Italian audio
    generate_all "it" "Italian"
    
    # Generate Spanish audio
    generate_all "es" "Spanish"
    
    echo "========================================================================"
    echo "Generation complete!"
    echo "========================================================================"
    echo ""
    echo "Next steps:"
    echo "  1. Test the audio files by opening index.html"
    echo "  2. Select German or French from the language dropdown"
    echo "  3. Press keys to hear the pronunciations"
    echo ""
}

# Run main function
main

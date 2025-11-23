#!/usr/bin/env python3
"""
Generate German and French pronunciation audio files using Google Text-to-Speech.

Requirements:
    pip install gTTS

Usage:
    python3 generate_audio.py

This script will generate MP3 files for:
- Numbers 0-9 in German and French
- Letters A-Z in German and French

The files will be saved in the sound/de/ and sound/fr/ directories.
"""

import os
import sys
from pathlib import Path

try:
    from gtts import gTTS
except ImportError:
    print("Error: gTTS library not found.")
    print("Please install it using: pip install gTTS")
    sys.exit(1)

# Get the script's directory and navigate to project root
script_dir = Path(__file__).parent
project_root = script_dir.parent
sound_dir = project_root / "sound"

# Language configurations
languages = {
    'de': {'name': 'German', 'code': 'de'},
    'fr': {'name': 'French', 'code': 'fr'}
}

# Characters to generate
numbers = [str(i) for i in range(10)]
letters = [chr(i) for i in range(ord('A'), ord('Z') + 1)]
characters = numbers + letters

def generate_audio(char, lang_code, lang_name):
    """Generate audio file for a character in a specific language."""
    output_dir = sound_dir / lang_code
    output_path = output_dir / f"{char}.mp3"
    
    # Skip if file already exists and is not empty
    if output_path.exists() and output_path.stat().st_size > 0:
        print(f"⊘ Skipping {lang_name} {char} (already exists)")
        return True
    
    try:
        # Create gTTS object
        # For numbers, we want the number name
        # For letters, we want the letter name
        tts = gTTS(text=char, lang=lang_code, slow=False)
        
        # Save the audio file
        tts.save(str(output_path))
        print(f"✓ Generated {lang_name} audio for: {char}")
        return True
    except Exception as e:
        print(f"✗ Failed to generate {lang_name} audio for {char}: {e}")
        return False

def main():
    """Main function to generate all audio files."""
    print("=" * 70)
    print("Audio File Generator for KeyboardBaby")
    print("Generating German and French pronunciation files...")
    print("=" * 70)
    print()
    
    # Check if sound directories exist
    for lang_code in languages.keys():
        lang_dir = sound_dir / lang_code
        if not lang_dir.exists():
            print(f"Error: Directory {lang_dir} does not exist!")
            print("Please run this script from the project root.")
            sys.exit(1)
    
    total_generated = 0
    total_skipped = 0
    total_failed = 0
    
    for lang_code, lang_info in languages.items():
        lang_name = lang_info['name']
        print(f"\n{lang_name} ({lang_code})")
        print("-" * 70)
        
        for char in characters:
            result = generate_audio(char, lang_code, lang_name)
            if result:
                if (sound_dir / lang_code / f"{char}.mp3").stat().st_size > 0:
                    total_generated += 1
                else:
                    total_skipped += 1
            else:
                total_failed += 1
    
    print()
    print("=" * 70)
    print("Summary:")
    print(f"  ✓ Successfully generated: {total_generated} files")
    if total_skipped > 0:
        print(f"  ⊘ Skipped (already exist): {total_skipped} files")
    if total_failed > 0:
        print(f"  ✗ Failed: {total_failed} files")
    print("=" * 70)
    print()
    
    if total_failed > 0:
        print("Note: Some files failed to generate. This might be due to:")
        print("  - No internet connection (gTTS requires internet)")
        print("  - Network restrictions or firewall blocking Google TTS")
        print("  - Rate limiting from Google")
        print()
        print("You can try:")
        print("  1. Running the script again later")
        print("  2. Using a different network connection")
        print("  3. Manually downloading audio files (see sound/AUDIO_SOURCES.md)")
        sys.exit(1)
    else:
        print("✓ All audio files generated successfully!")
        print()
        print("Next steps:")
        print("  1. Test the audio files by opening index.html in a browser")
        print("  2. Select German or French from the language dropdown")
        print("  3. Press keys to hear the pronunciations")

if __name__ == "__main__":
    main()

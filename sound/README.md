# Sound Files

This directory contains pronunciation audio files for different languages.

## Directory Structure

- `en/` - English pronunciation sounds ✅
- `de/` - German pronunciation sounds ⚠️ (currently using English placeholders)
- `fr/` - French pronunciation sounds ⚠️ (currently using English placeholders)

## Getting Audio Files

The German (`de`) and French (`fr`) directories currently contain copies of the English sounds as placeholders. These should be replaced with proper German and French pronunciations recorded by native speakers.

### Quick Start

**Option 1 - Generate using script:**
```bash
pip install gTTS
python3 ../scripts/generate_audio.py
```

**Option 2 - Download from free resources:**
See [`AUDIO_SOURCES.md`](AUDIO_SOURCES.md) for detailed information about free German and French pronunciation resources.

## Required Files

Each directory should contain:
- **Number sounds**: 0.mp3 through 9.mp3 (10 files)
- **Letter sounds**: A.mp3 through Z.mp3 (26 files)
- **Emoji sounds**: Various emoji character .mp3 files (same across all languages)

**Total per language**: 36 pronunciation files (numbers + letters) + emoji files

## File Specifications

- Format: MP3
- Bitrate: 128 kbps or higher
- Duration: 0.5-2 seconds
- Quality: Clear native speaker pronunciation


# Audio File Sources for German and French

This document provides information on where to obtain German and French pronunciation audio files for KeyboardBaby.

## Current Status

- ✅ English audio files are complete
- ⚠️ German audio files are English placeholders (need replacement)
- ⚠️ French audio files are English placeholders (need replacement)

## Required Audio Files

For each language, you need:
- **Numbers**: 0.mp3 through 9.mp3 (10 files)
- **Letters**: A.mp3 through Z.mp3 (26 files)
- **Emojis**: Same emoji files as English (already copied)

**Total**: 36 pronunciation files per language

## Free Audio Resources

### German Pronunciation Audio

1. **Light Bulb Languages** (Free for educational use)
   - German Alphabet: https://www.lightbulblanguages.co.uk/resources-ge-sound-files.htm
   - German Numbers: https://www.lightbulblanguages.co.uk/resources-ge-sound-files.htm

2. **Phrase Guides** (Free MP3 downloads by native speakers)
   - German Audio: https://phraseguides.com/German/audio.php

3. **MyLanguages.org** (Free German audio lessons)
   - German Alphabet & Numbers: https://www.mylanguages.org/german_audio.php

### French Pronunciation Audio

1. **Phrase Guides** (Free MP3 downloads by native speakers)
   - French Audio: https://phraseguides.com/French/audio.php

2. **Omniglot** (Native speaker recordings)
   - French pronunciation: https://www.omniglot.com/soundfiles/

### Multi-Language Resources

1. **50Languages.com** (Creative Commons license)
   - MP3 Lessons for German and French: https://www.50languages.com/language-mp3

## Audio File Specifications

When obtaining or creating audio files, ensure they meet these requirements:

- **Format**: MP3 (`.mp3` extension)
- **Bitrate**: 128 kbps or higher
- **Sample Rate**: 44.1 kHz recommended
- **Duration**: 0.5-2 seconds per file (short and clear)
- **Quality**: Clear pronunciation by native speakers
- **Volume**: Normalized to avoid clipping
- **Naming**: Match the character exactly (e.g., `A.mp3`, `0.mp3`)

## Installation Instructions

### Option 1: Manual Download

1. Visit one of the resources above
2. Download the audio files for letters (A-Z) and numbers (0-9)
3. Convert to MP3 format if necessary
4. Rename files to match the required naming (A.mp3, B.mp3, etc.)
5. Place files in the appropriate directory:
   - German: `sound/de/`
   - French: `sound/fr/`

### Option 2: Generate Using Text-to-Speech (Local)

If you have Python and internet access, you can use the included generator script:

```bash
# Install required library
pip install gTTS

# Run the generator script
python3 scripts/generate_audio.py
```

This will generate German and French pronunciation files using Google Text-to-Speech.

### Option 3: Record Yourself

If you're a native speaker or have access to one:

1. Use recording software (Audacity, phone recorder, etc.)
2. Record clear pronunciations of each letter and number
3. Export as MP3 files
4. Name them correctly (A.mp3, B.mp3, 0.mp3, etc.)
5. Place in `sound/de/` or `sound/fr/`

## Directory Structure

After installation, your sound directory should look like:

```
sound/
├── README.md
├── de/
│   ├── 0.mp3 (German: "null")
│   ├── 1.mp3 (German: "eins")
│   ├── ...
│   ├── A.mp3 (German: "Ah")
│   ├── B.mp3 (German: "Bay")
│   └── ...
├── en/
│   └── [existing English files]
└── fr/
    ├── 0.mp3 (French: "zéro")
    ├── 1.mp3 (French: "un")
    ├── ...
    ├── A.mp3 (French: "Ah")
    ├── B.mp3 (French: "Bay")
    └── ...
```

## Contributing

If you create or obtain high-quality German or French pronunciation files, please consider:

1. Sharing them with the project
2. Ensuring you have the rights to distribute them
3. Documenting the source/license
4. Creating a pull request with the audio files

## License Considerations

- Only use audio files that are free for educational/open-source use
- Creative Commons licensed audio is preferred
- Always check and respect the original source's license terms
- If generating TTS audio, check the TTS service's terms of use

## Testing

After adding new audio files:

1. Open `index.html` in a browser
2. Select the German or French language from the dropdown
3. Press keys A-Z and 0-9
4. Verify that pronunciations sound natural and clear
5. Check that all files load without errors (check browser console)

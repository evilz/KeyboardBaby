# Keyboard Baby 👶⌨️

A fun, educational web application for babies and toddlers to learn letters, numbers, and sounds by pressing keys on the keyboard.

## Features

- 🎨 Colorful animated letters and numbers appear on screen when keys are pressed
- 🔊 Audio pronunciation of letters and numbers
- 🌍 **Multi-language support:**
  - 🇬🇧 English
  - 🇩🇪 German (Deutsch)
  - 🇫🇷 French (Français)
  - 🇮🇹 Italian (Italiano)
  - 🇪🇸 Spanish (Español)
- 😊 Fun emoji animations for special keys
- 📱 Responsive design that works on various screen sizes

## Usage

### Basic Usage

Simply open `index.html` in a web browser and start pressing keys on your keyboard. Each key press will:
1. Display an animated letter, number, or emoji
2. Play the pronunciation sound in the selected language
3. Show colorful backgrounds with smooth animations

### Language Selection

#### Using the UI
Click the language selector dropdown in the top-right corner to switch between languages:
- 🇬🇧 English
- 🇩🇪 Deutsch (German)
- 🇫🇷 Français (French)
- 🇮🇹 Italiano (Italian)
- 🇪🇸 Español (Spanish)

#### Using URL Parameters
You can also set the language via URL parameter:
- English: `index.html?lang=en`
- German: `index.html?lang=de`
- French: `index.html?lang=fr`
- Italian: `index.html?lang=it`
- Spanish: `index.html?lang=es`

## Sound Files

Sound files are organized by language in the `sound/` directory:
- `sound/en/` - English pronunciations ✅
- `sound/de/` - German pronunciations ⚠️ (currently placeholders)
- `sound/fr/` - French pronunciations ⚠️ (currently placeholders)
- `sound/it/` - Italian pronunciations ⚠️ (currently placeholders)
- `sound/es/` - Spanish pronunciations ⚠️ (currently placeholders)

**Note:** German, French, Italian, and Spanish sound files are currently placeholders using English audio. 

### Getting Audio Files for Non-English Languages

To replace the placeholder audio files with proper native pronunciations, you have several options:

1. **Use the shell script** (Linux/macOS, offline, requires espeak-ng + ffmpeg):
   ```bash
   # Install dependencies (Debian/Ubuntu)
   sudo apt-get install espeak-ng ffmpeg
   
   # Run the generator
   chmod +x scripts/generate_audio.sh
   ./scripts/generate_audio.sh
   ```

2. **Use the PowerShell script** (Windows, offline, requires espeak-ng + ffmpeg):
   ```powershell
   # Install dependencies (using winget)
   winget install ffmpeg
   # Download espeak-ng from: https://github.com/espeak-ng/espeak-ng/releases
   
   # Run the generator
   .\scripts\generate_audio.ps1
   ```

3. **Use the Python script** (cross-platform, requires internet connection):
   ```bash
   pip install gTTS
   python3 scripts/generate_audio.py
   ```

4. **Download from free resources**:
   - See [`sound/AUDIO_SOURCES.md`](sound/AUDIO_SOURCES.md) for a list of free pronunciation resources
   - Resources include Light Bulb Languages, Phrase Guides, and 50Languages.com

5. **Record yourself** (if you're a native speaker):
   - Record clear pronunciations of letters A-Z and numbers 0-9
   - Export as MP3 files following the specifications below
   - Place in the appropriate language directory (`sound/de/`, `sound/fr/`, `sound/it/`, or `sound/es/`)

### Audio File Specifications

When contributing audio files for new languages, please follow these guidelines:
- **Format:** MP3 (`.mp3` extension)
- **Bitrate:** 128 kbps or higher
- **Sample Rate:** 44.1 kHz recommended
- **Duration:** 0.5-2 seconds per file (short and clear)
- **Quality:** Clear pronunciation by native speakers
- **Volume:** Normalized to avoid clipping
- **Naming:** Match the character exactly (e.g., `A.mp3`, `0.mp3`, `🐵.mp3`)

## Contributing

Contributions are welcome! Particularly needed:
- Native German pronunciation recordings for letters and numbers
- Native French pronunciation recordings for letters and numbers
- Native Italian pronunciation recordings for letters and numbers
- Native Spanish pronunciation recordings for letters and numbers

## License

Feel free to use and modify this project for educational purposes!

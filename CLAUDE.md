# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a SwiftUI iOS app called "JLPT 日语学习" - a Japanese Language Proficiency Test (JLPT) vocabulary learning application focused on audio-based learning. The app covers JLPT levels N5 through N1 and emphasizes listening practice to improve memory and pronunciation.

## Architecture

**App Entry Point**: `jlptApp.swift` - Contains the main `@main` app struct

**Core Views**:
- **ContentView.swift** - Main screen with JLPT level selection grid (N5-N1)
- **VocabularyListView.swift** - Lists vocabulary words for selected JLPT level
- **VocabularyDetailView.swift** - Detailed view with word info, audio controls, and example sentences

**Data Models** (`Models.swift`):
- `JLPTLevel` enum - N5 through N1 levels with color coding and descriptions
- `Vocabulary` struct - Word, reading, meaning, part of speech, level, examples
- `ExampleSentence` struct - Japanese sentences with readings and Chinese translations
- `VocabularyStore` class - ObservableObject managing vocabulary data

**Audio System** (`AudioManager.swift`):
- AVAudioPlayer integration for MP3 file playback
- Text-to-speech fallback using Japanese voices
- Audio controls: play, pause, stop, repeat
- Real-time playback status tracking

## Key Features

- **JLPT Vocabulary**: Organized by levels N5-N1 with sample words
- **Audio Learning**: Each word and example sentence has audio playback capability
- **Beautiful UI**: Modern SwiftUI interface with level-specific color coding
- **Japanese Support**: Proper display of kanji, hiragana, katakana with readings
- **Example Sentences**: Contextual usage examples with translations

## Development Commands

**Building and Running:**
- This is an Xcode project that requires Xcode for full functionality
- The project uses SwiftUI and targets iOS
- Dependencies: AVFoundation for audio, no external packages

**Testing:**
- Unit tests: Located in `jlptTests/jlptTests.swift`
- UI tests: Located in `jlptUITests/`
- Uses Swift Testing framework (import Testing)

## Color Scheme

- N5 (初级): Green
- N4 (初中级): Blue  
- N3 (中级): Orange
- N2 (中高级): Purple
- N1 (高级): Red

## Extension Points

- Add more vocabulary data to `VocabularyStore.loadSampleData()`
- Add actual audio files to app bundle and reference in `audioFileName` properties
- Implement progress tracking and study statistics
- Add quiz/test modes for vocabulary practice
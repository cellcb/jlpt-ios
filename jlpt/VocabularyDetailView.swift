import SwiftUI

struct VocabularyDetailView: View {
    let vocabulary: Vocabulary
    @ObservedObject var audioManager: AudioManager
    @State private var selectedTab: Int = 0
    
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                VStack(spacing: 15) {
                    Text(vocabulary.word)
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.primary)
                    
                    Text(vocabulary.reading)
                        .font(.title2)
                        .foregroundColor(.secondary)
                    
                    AudioControlView(
                        audioFileName: vocabulary.audioFileName ?? vocabulary.word,
                        displayText: vocabulary.word,
                        audioManager: audioManager
                    )
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(levelColor.opacity(0.1))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(levelColor.opacity(0.3), lineWidth: 2)
                        )
                )
                
                VStack(spacing: 15) {
                    HStack {
                        Text("含义")
                            .font(.headline)
                            .foregroundColor(.primary)
                        Spacer()
                    }
                    
                    Text(vocabulary.meaning)
                        .font(.title3)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack {
                        Text(vocabulary.partOfSpeech)
                            .font(.caption)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(levelColor.opacity(0.2))
                            .foregroundColor(levelColor)
                            .cornerRadius(8)
                        
                        Spacer()
                        
                        Text(vocabulary.level.rawValue)
                            .font(.caption)
                            .fontWeight(.bold)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(levelColor)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(UIColor.systemBackground))
                        .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
                )
                
                if !vocabulary.examples.isEmpty {
                    VStack(spacing: 15) {
                        HStack {
                            Text("例句")
                                .font(.headline)
                                .foregroundColor(.primary)
                            Spacer()
                        }
                        
                        ForEach(vocabulary.examples) { example in
                            ExampleSentenceView(
                                example: example,
                                audioManager: audioManager,
                                levelColor: levelColor
                            )
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(UIColor.systemBackground))
                            .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
                    )
                }
            }
            .padding()
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [levelColor.opacity(0.05), Color.clear]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
    
    var levelColor: Color {
        switch vocabulary.level {
        case .n5: return .green
        case .n4: return .blue
        case .n3: return .orange
        case .n2: return .purple
        case .n1: return .red
        }
    }
}

struct AudioControlView: View {
    let audioFileName: String
    let displayText: String
    @ObservedObject var audioManager: AudioManager
    
    var isCurrentAudio: Bool {
        audioManager.currentAudio == audioFileName
    }
    
    var body: some View {
        HStack(spacing: 20) {
            Button(action: {
                if isCurrentAudio && audioManager.isPlaying {
                    audioManager.pauseAudio()
                } else if isCurrentAudio && !audioManager.isPlaying {
                    audioManager.resumeAudio()
                } else {
                    audioManager.playAudio(fileName: audioFileName)
                }
            }) {
                Image(systemName: isCurrentAudio && audioManager.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                    .font(.system(size: 44))
                    .foregroundColor(.blue)
            }
            .scaleEffect(isCurrentAudio && audioManager.isPlaying ? 1.1 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: audioManager.isPlaying)
            
            Button(action: {
                audioManager.stopAudio()
            }) {
                Image(systemName: "stop.circle")
                    .font(.system(size: 32))
                    .foregroundColor(.secondary)
            }
            .opacity(isCurrentAudio ? 1.0 : 0.5)
            
            Button(action: {
                audioManager.playAudio(fileName: audioFileName)
            }) {
                Image(systemName: "repeat.circle")
                    .font(.system(size: 32))
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct ExampleSentenceView: View {
    let example: ExampleSentence
    @ObservedObject var audioManager: AudioManager
    let levelColor: Color
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text(example.japanese)
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    Text(example.reading)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text(example.chinese)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button(action: {
                    if let audioFileName = example.audioFileName {
                        audioManager.playAudio(fileName: audioFileName)
                    } else {
                        audioManager.playAudio(fileName: example.japanese)
                    }
                }) {
                    Image(systemName: audioManager.isPlaying && audioManager.currentAudio == (example.audioFileName ?? example.japanese) ? "speaker.wave.2.fill" : "speaker.wave.2")
                        .font(.title3)
                        .foregroundColor(levelColor)
                }
                .buttonStyle(BorderlessButtonStyle())
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(levelColor.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(levelColor.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

#Preview {
    NavigationView {
        VocabularyDetailView(
            vocabulary: Vocabulary(
                word: "こんにちは",
                reading: "こんにちは",
                meaning: "你好",
                partOfSpeech: "感叹词",
                level: .n5,
                examples: [
                    ExampleSentence(
                        japanese: "こんにちは、元気ですか。",
                        reading: "こんにちは、げんきですか。",
                        chinese: "你好，你好吗？",
                        audioFileName: nil
                    )
                ],
                audioFileName: nil
            ),
            audioManager: AudioManager()
        )
    }
}
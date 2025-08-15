import SwiftUI

struct VocabularyListView: View {
    let level: JLPTLevel
    let vocabularyStore: VocabularyStore
    @ObservedObject var audioManager: AudioManager
    
    var vocabularies: [Vocabulary] {
        vocabularyStore.vocabularies(for: level)
    }
    
    var body: some View {
        List(vocabularies) { vocabulary in
            NavigationLink(
                destination: VocabularyDetailView(
                    vocabulary: vocabulary,
                    audioManager: audioManager
                )
            ) {
                VocabularyRowView(vocabulary: vocabulary, audioManager: audioManager)
            }
        }
        .navigationTitle("\(level.rawValue) \(level.description)")
        .navigationBarTitleDisplayMode(.large)
        .background(Color(UIColor.systemGroupedBackground))
    }
}

struct VocabularyRowView: View {
    let vocabulary: Vocabulary
    @ObservedObject var audioManager: AudioManager
    
    var body: some View {
        HStack(spacing: 15) {
            VStack(alignment: .leading, spacing: 4) {
                Text(vocabulary.word)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(vocabulary.reading)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text(vocabulary.meaning)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(vocabulary.partOfSpeech)
                    .font(.caption2)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(levelColor.opacity(0.2))
                    .foregroundColor(levelColor)
                    .cornerRadius(4)
            }
            
            Spacer()
            
            Button(action: {
                if let audioFileName = vocabulary.audioFileName {
                    audioManager.playAudio(fileName: audioFileName)
                } else {
                    audioManager.playAudio(fileName: vocabulary.word)
                }
            }) {
                Image(systemName: audioManager.isPlaying && audioManager.currentAudio == (vocabulary.audioFileName ?? vocabulary.word) ? "speaker.wave.2.fill" : "speaker.wave.2")
                    .font(.title2)
                    .foregroundColor(levelColor)
                    .scaleEffect(audioManager.isPlaying && audioManager.currentAudio == (vocabulary.audioFileName ?? vocabulary.word) ? 1.2 : 1.0)
                    .animation(.easeInOut(duration: 0.2), value: audioManager.isPlaying)
            }
            .buttonStyle(BorderlessButtonStyle())
        }
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(UIColor.systemBackground))
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

#Preview {
    NavigationView {
        VocabularyListView(
            level: .n5,
            vocabularyStore: VocabularyStore(),
            audioManager: AudioManager()
        )
    }
}
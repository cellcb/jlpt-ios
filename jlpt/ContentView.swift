//
//  ContentView.swift
//  jlpt
//
//  Created by Bo Cheng on 2025/8/16.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var vocabularyStore = VocabularyStore()
    @StateObject private var audioManager = AudioManager()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                VStack(spacing: 10) {
                    Image(systemName: "book.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.blue)
                    
                    Text("JLPT 日语学习")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text("通过听力练习提高记忆力")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 20) {
                    ForEach(JLPTLevel.allCases, id: \.id) { level in
                        NavigationLink(destination: VocabularyListView(level: level, vocabularyStore: vocabularyStore, audioManager: audioManager)) {
                            JLPTLevelCard(level: level, vocabularyStore: vocabularyStore)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                
                Spacer()
            }
            .padding()
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .navigationBarHidden(true)
        }
        .environmentObject(vocabularyStore)
        .environmentObject(audioManager)
    }
}

struct JLPTLevelCard: View {
    let level: JLPTLevel
    let vocabularyStore: VocabularyStore
    
    var vocabularyCount: Int {
        vocabularyStore.vocabularies(for: level).count
    }
    
    var body: some View {
        VStack(spacing: 15) {
            ZStack {
                Circle()
                    .fill(levelColor)
                    .frame(width: 80, height: 80)
                
                Text(level.rawValue)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            
            VStack(spacing: 5) {
                Text(level.description)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text("\(vocabularyCount) 个单词")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 25)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(UIColor.systemBackground))
                .shadow(color: levelColor.opacity(0.3), radius: 8, x: 0, y: 4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(levelColor.opacity(0.3), lineWidth: 1)
        )
    }
    
    var levelColor: Color {
        switch level {
        case .n5: return .green
        case .n4: return .blue
        case .n3: return .orange
        case .n2: return .purple
        case .n1: return .red
        }
    }
}

#Preview {
    ContentView()
}

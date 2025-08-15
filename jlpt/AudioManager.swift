import Foundation
import AVFoundation
import Combine

class AudioManager: NSObject, ObservableObject {
    private var audioPlayer: AVAudioPlayer?
    @Published var isPlaying: Bool = false
    @Published var currentAudio: String = ""
    
    override init() {
        super.init()
        setupAudioSession()
    }
    
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to setup audio session: \(error)")
        }
    }
    
    func playAudio(fileName: String) {
        guard let path = Bundle.main.path(forResource: fileName, ofType: "mp3") else {
            print("Audio file \(fileName).mp3 not found")
            playTextToSpeech(text: fileName)
            return
        }
        
        let url = URL(fileURLWithPath: path)
        
        do {
            audioPlayer?.stop()
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self
            audioPlayer?.play()
            
            isPlaying = true
            currentAudio = fileName
        } catch {
            print("Failed to play audio: \(error)")
            playTextToSpeech(text: fileName)
        }
    }
    
    private func playTextToSpeech(text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "ja-JP")
        utterance.rate = 0.5
        
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
        
        isPlaying = true
        currentAudio = text
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(text.count) * 0.2) {
            self.isPlaying = false
            self.currentAudio = ""
        }
    }
    
    func stopAudio() {
        audioPlayer?.stop()
        isPlaying = false
        currentAudio = ""
    }
    
    func pauseAudio() {
        audioPlayer?.pause()
        isPlaying = false
    }
    
    func resumeAudio() {
        audioPlayer?.play()
        isPlaying = true
    }
}

extension AudioManager: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying = false
        currentAudio = ""
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print("Audio decode error: \(error?.localizedDescription ?? "Unknown error")")
        isPlaying = false
        currentAudio = ""
    }
}
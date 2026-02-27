//
//  AudioPlayerManager.swift
//  Quester
//
//  Created by lucy randall on 2/27/26.
//

import AVFoundation
import Observation

@Observable
class AudioPlayerManager: NSObject, AVAudioPlayerDelegate {
    var currentTrack: Track?
    var isPlaying = false
    var currentTime: Double = 0
    var duration: Double = 0
    var volume: Double = 1.0
    
    private var audioPlayer: AVAudioPlayer?
    private var displayLink: CADisplayLink?
    
    override init() {
        super.init()
        setupAudioSession()
    }
    
    private func setupAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback, mode: .default, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("Failed to set up audio session: \(error)")
        }
    }
    
    func playTrack(_ track: Track) {
        currentTrack = track
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: track.fileURL)
            audioPlayer?.delegate = self
            audioPlayer?.volume = Float(volume)
            audioPlayer?.play()
            isPlaying = true
            
            // Start updating time
            startDisplayLink()
        } catch {
            print("Failed to initialize audio player: \(error)")
            isPlaying = false
        }
    }
    
    func pause() {
        audioPlayer?.pause()
        isPlaying = false
        stopDisplayLink()
    }
    
    func resume() {
        audioPlayer?.play()
        isPlaying = true
        startDisplayLink()
    }
    
    func togglePlayPause() {
        if isPlaying {
            pause()
        } else {
            resume()
        }
    }
    
    func seek(to time: Double) {
        audioPlayer?.currentTime = time
        currentTime = time
    }
    
    func setVolume(_ volume: Double) {
        self.volume = volume
        audioPlayer?.volume = Float(volume)
    }
    
    private func startDisplayLink() {
        stopDisplayLink()
        displayLink = CADisplayLink(
            target: self,
            selector: #selector(updateTime)
        )
        displayLink?.preferredFramesPerSecond = 30
        displayLink?.add(to: .main, forMode: .common)
    }
    
    private func stopDisplayLink() {
        displayLink?.invalidate()
        displayLink = nil
    }
    
    @objc private func updateTime() {
        if let player = audioPlayer {
            currentTime = player.currentTime
            duration = player.duration
        }
    }
    
    // MARK: - AVAudioPlayerDelegate
    
    nonisolated func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        DispatchQueue.main.async {
            self.isPlaying = false
            self.currentTime = 0
            self.stopDisplayLink()
        }
    }
    
    deinit {
        stopDisplayLink()
    }
}

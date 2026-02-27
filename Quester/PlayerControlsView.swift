//
//  PlayerControlsView.swift
//  Quester
//
//  Created by lucy randall on 2/27/26.
//

import SwiftUI

struct PlayerControlsView: View {
    @Bindable var player: AudioPlayerManager
    
    var body: some View {
        VStack(spacing: 16) {
            // Track Info
            if let track = player.currentTrack {
                VStack(spacing: 8) {
                    Text(track.title)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .lineLimit(1)
                    
                    Text(track.artist)
                        .font(.subheading)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
            } else {
                VStack(spacing: 8) {
                    Text("No Track Selected")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("Add music to get started")
                        .font(.subheading)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
            }
            
            // Time Slider
            if player.currentTrack != nil {
                VStack(spacing: 6) {
                    Slider(
                        value: $player.currentTime,
                        in: 0...max(player.duration, 1),
                        onEditingChanged: { editing in
                            if !editing {
                                player.seek(to: player.currentTime)
                            }
                        }
                    )
                    
                    HStack {
                        Text(formatTime(player.currentTime))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                        Spacer()
                        
                        Text(formatTime(player.duration))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            
            // Controls
            HStack(spacing: 24) {
                Button(action: { player.pause() }) {
                    Image(systemName: "backward.fill")
                        .font(.system(size: 18))
                }
                .help("Previous")
                
                Button(action: { player.togglePlayPause() }) {
                    Image(systemName: player.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .font(.system(size: 44))
                }
                .help(player.isPlaying ? "Pause" : "Play")
                
                Button(action: { player.pause() }) {
                    Image(systemName: "forward.fill")
                        .font(.system(size: 18))
                }
                .help("Next")
            }
            .frame(maxWidth: .infinity)
            
            // Volume Control
            HStack(spacing: 8) {
                Image(systemName: "speaker.fill")
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
                
                Slider(
                    value: $player.volume,
                    in: 0...1
                )
                .onChange(of: player.volume) { oldValue, newValue in
                    player.setVolume(newValue)
                }
                
                Image(systemName: "speaker.wave.3.fill")
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
            }
        }
        .padding(20)
        .background(Color(nsColor: .controlBackgroundColor))
        .cornerRadius(12)
    }
    
    private func formatTime(_ seconds: Double) -> String {
        let total = Int(seconds)
        let minutes = total / 60
        let secs = total % 60
        return String(format: "%d:%02d", minutes, secs)
    }
}

#Preview {
    VStack {
        PlayerControlsView(player: AudioPlayerManager())
    }
    .frame(width: 300)
    .padding()
}

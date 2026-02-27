//
//  ContentView.swift
//  Quester
//
//  Created by lucy randall on 2/27/26.
//

import SwiftUI
import SwiftData
import UniformTypeIdentifiers
import AVFoundation

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(AudioPlayerManager.self) private var player
    @Query private var tracks: [Track]
    
    @State private var selectedTrack: Track?
    @State private var isImporting = false

    var body: some View {
        NavigationSplitView {
            VStack {
                List(tracks, id: \.self, selection: $selectedTrack) { track in
                    TrackRowView(track: track, isPlaying: player.currentTrack?.id == track.id && player.isPlaying)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            player.playTrack(track)
                        }
                }
                .listStyle(.plain)
                
                HStack(spacing: 8) {
                    Button(action: { isImporting = true }) {
                        Label("Add Music", systemImage: "plus.circle.fill")
                    }
                    
                    if selectedTrack != nil {
                        Button(action: deleteSelectedTrack) {
                            Label("Remove", systemImage: "minus.circle.fill")
                        }
                        .foregroundStyle(.red)
                    }
                    
                    Spacer()
                }
                .padding(12)
            }
            #if os(macOS)
            .navigationSplitViewColumnWidth(min: 200, ideal: 280)
            #endif
        } detail: {
            if player.currentTrack != nil {
                VStack(spacing: 24) {
                    Spacer()
                    
                    PlayerControlsView(player: player)
                        .frame(maxWidth: 400)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(nsColor: .windowBackgroundColor))
            } else {
                VStack(spacing: 16) {
                    Image(systemName: "music.note")
                        .font(.system(size: 64))
                        .foregroundStyle(.secondary)
                    
                    Text("Select a Track to Play")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("Choose a song from your library to get started")
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(nsColor: .windowBackgroundColor))
            }
        }
        .fileImporter(
            isPresented: $isImporting,
            allowedContentTypes: [.audio, .mp3, .wav, .m4a],
            onCompletion: handleImport
        )
    }
    
    private func deleteSelectedTrack() {
        if let track = selectedTrack {
            modelContext.delete(track)
            if player.currentTrack?.id == track.id {
                player.pause()
            }
            selectedTrack = nil
        }
    }
    
    private func handleImport(_ result: Result<[URL], Error>) {
        switch result {
        case .success(let urls):
            for url in urls {
                let asset = AVAsset(url: url)
                let duration = CMTimeGetSeconds(asset.duration)
                
                let track = Track(
                    title: url.deletingPathExtension().lastPathComponent,
                    artist: "Unknown Artist",
                    duration: duration,
                    fileURL: url
                )
                
                modelContext.insert(track)
            }
        case .failure(let error):
            print("Import error: \(error)")
        }
    }
}

struct TrackRowView: View {
    let track: Track
    let isPlaying: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            if isPlaying {
                Image(systemName: "waveform")
                    .font(.system(size: 14))
                    .foregroundStyle(.blue)
                    .frame(width: 20)
            } else {
                Image(systemName: "music.note")
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)
                    .frame(width: 20)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(track.title)
                    .font(.body)
                    .fontWeight(isPlaying ? .semibold : .regular)
                    .lineLimit(1)
                
                Text(track.artist)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
            
            Spacer()
            
            Text(formatDuration(track.duration))
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 8)
    }
    
    private func formatDuration(_ seconds: Double) -> String {
        let total = Int(seconds)
        let minutes = total / 60
        let secs = total % 60
        return String(format: "%d:%02d", minutes, secs)
    }
}

#Preview {
    ContentView()
        .environment(AudioPlayerManager())
}


#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}

//
//  QuesterApp.swift
//  Quester
//
//  Created by lucy randall on 2/27/26.
//

import SwiftUI
import SwiftData

@main
struct QuesterApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Track.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    @State private var audioPlayer = AudioPlayerManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(audioPlayer)
        }
        .modelContainer(sharedModelContainer)
    }
}

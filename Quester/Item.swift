//
//  Track.swift
//  Quester
//
//  Created by lucy randall on 2/27/26.
//

import Foundation
import SwiftData

@Model
final class Track {
    var title: String
    var artist: String
    var duration: Double
    var fileURL: URL
    var dateAdded: Date
    
    init(title: String, artist: String, duration: Double, fileURL: URL) {
        self.title = title
        self.artist = artist
        self.duration = duration
        self.fileURL = fileURL
        self.dateAdded = Date()
    }
}

//
//  UTTypeExtension.swift
//  Quester
//
//  Created by lucy randall on 2/27/26.
//

import UniformTypeIdentifiers

extension UTType {
    static let mp3 = UTType(filenameExtension: "mp3") ?? .audio
    static let wav = UTType(filenameExtension: "wav") ?? .audio
    static let m4a = UTType(filenameExtension: "m4a") ?? .audio
    static let flac = UTType(filenameExtension: "flac") ?? .audio
    static let aac = UTType(filenameExtension: "aac") ?? .audio
}

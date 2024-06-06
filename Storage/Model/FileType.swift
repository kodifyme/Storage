//
//  FileType.swift
//  Storage
//
//  Created by KOДИ on 31.05.2024.
//

import UIKit
import Firebase

struct FileExtensions {
    static let mp3 = ".mp3"
    static let mp4 = "mp4"
    static let wav = ".wav"
    static let txt = ".txt"
    static let jpg = ".jpg"
    static let jpeg = ".jpeg"
    static let png = ".png"
    static let pdf = ".pdf"
}

enum FileType {
    case text
    case image
    case pdf
    case media
    case other
    
    init(fileRef: StorageReference) {
        self = FileType.fileType(for: fileRef)
    }
    
    private static func fileType(for fileRef: StorageReference) -> FileType {
        if fileRef.name.hasSuffix(FileExtensions.mp3) || fileRef.name.hasSuffix(FileExtensions.wav) || fileRef.name.hasSuffix(FileExtensions.mp4) {
            return .media
        } else if fileRef.name.hasSuffix(FileExtensions.txt) {
            return .text
        } else if fileRef.name.hasSuffix(FileExtensions.jpg) || fileRef.name.hasSuffix(FileExtensions.png) || fileRef.name.hasSuffix(FileExtensions.jpeg) {
            return .image
        } else if fileRef.name.hasSuffix(FileExtensions.pdf) {
            return .pdf
        } else {
            return .other
        }
    }
}

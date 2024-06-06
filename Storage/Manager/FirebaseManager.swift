//
//  FileContentManager.swift
//  Storage
//
//  Created by KOДИ on 30.05.2024.
//

import UIKit
import FirebaseStorage
import AVKit

struct FileSize {
    static let textFileSize: Int64 = 1 * 1024 * 1024
    static let imageFileSize: Int64 = 10 * 1024 * 1024
}

typealias Completion = (Result<Data, Error>) -> Void

class FirebaseManager {
    
    static let shared = FirebaseManager()
    
    private var storageRef: StorageReference
    
    private init() {
        storageRef = Storage.storage().reference()
    }
    
    func displayTextFile(from reference: StorageReference, completion: @escaping Completion) {
        reference.getData(maxSize: FileSize.textFileSize) { data, error in
            guard let data, error == nil else {
                return completion(.failure(error!))
            }
            completion(.success(data))
        }
    }
    
    func displayImageFile(from reference: StorageReference, completion: @escaping Completion) {
        reference.getData(maxSize: FileSize.imageFileSize) { data, error in
            guard let data, error == nil else {
                return completion(.failure(error!))
            }
            completion(.success(data))
        }
    }
    
    func displayPDFFile(from reference: StorageReference, completion: @escaping Completion) {
        reference.getData(maxSize: FileSize.imageFileSize) { data, error in
            guard let data, error == nil else {
                return completion(.failure(error!))
            }
            completion(.success(data))
        }
    }
    
    func playMediaFile(from reference: StorageReference, completion: @escaping (Result<URL,Error>) -> Void) {
        reference.downloadURL { url, error in
            guard let url, error == nil else {
                return completion(.failure(error!))
            }
            completion(.success(url))
        }
    }
    
    func deleteFile(from reference: StorageReference) {
        reference.delete { _ in }
    }
    
    func fetchStorageContents(at path: String, completion: @escaping (Result<[StorageReference], Error>) -> Void) {
        let reference = storageRef.child(path)
        storageRef.listAll { result, error in
            if let error {
                return completion(.failure(error))
            }
            completion(.success((result?.prefixes ?? []) + (result?.items ?? [])))
        }
    }
}

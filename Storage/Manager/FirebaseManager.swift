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

typealias CompletionHandler<T> = (Result<T, Error>) -> Void

class FirebaseManager {
    
    let rootPath = "gs://storage-7898f.appspot.com/"
    
    static let shared = FirebaseManager()
    
    var storageRef: StorageReference
    
    private init() {
        storageRef = Storage.storage().reference(forURL: rootPath)
        
    }
    
    func displayTextFile(from reference: StorageReference, completion: @escaping CompletionHandler<Data>) {
        reference.getData(maxSize: FileSize.textFileSize) { data, error in
            guard let data, error == nil else {
                return completion(.failure(error!))
            }
            completion(.success(data))
        }
    }
    
    func displayImageFile(from reference: StorageReference, completion: @escaping CompletionHandler<Data>) {
        reference.getData(maxSize: FileSize.imageFileSize) { data, error in
            guard let data, error == nil else {
                return completion(.failure(error!))
            }
            completion(.success(data))
        }
    }
    
    func displayPDFFile(from reference: StorageReference, completion: @escaping CompletionHandler<Data>) {
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
    
    func fetchContents(for fileRef: StorageReference, completion: @escaping CompletionHandler<[StorageReference]>) {
        fileRef.listAll { result, error in
            if let error {
                completion(.failure(error))
            } else {
                completion(.success((result?.prefixes ?? []) + (result?.items ?? [])))
            }
        }
    }
    
    func fetchStorageContents(at path: String, completion: @escaping CompletionHandler<[StorageReference]>) {
        let reference = path.isEmpty ? storageRef : storageRef.child(path)
        fetchContents(for: reference, completion: completion)
    }
}

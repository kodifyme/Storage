//
//  FileContentManager.swift
//  Storage
//
//  Created by KOДИ on 30.05.2024.
//

import UIKit
import FirebaseStorage
import PDFKit
import AVKit

class FileContentManager {
    static let shared = FileContentManager()
    
    private init() {}
    
    func displayTextFile(from reference: StorageReference, in viewController: ContentViewController) {
        reference.getData(maxSize: 1 * 1024 * 1024) { data, error in
            guard let data, error == nil else {
                print("Error fetching text file: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            if let text = String(data: data, encoding: .utf8) {
                let textView = UITextView()
                textView.text = text
                viewController.view.addSubview(textView)
                viewController.setupConstraints(for: textView)
            }
        }
    }
    
    func displayImageFile(from reference: StorageReference, in viewController: ContentViewController) {
        reference.getData(maxSize: 10 * 1024 * 1024) { data, error in
            guard let data, error == nil else {
                print("Error fetching image file: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            if let image = UIImage(data: data) {
                let imageView = UIImageView()
                imageView.contentMode = .scaleAspectFit
                imageView.image = image
                viewController.view.addSubview(imageView)
                viewController.setupConstraints(for: imageView)
            }
        }
    }
    
    func displayPDFFile(from reference: StorageReference, in viewController: ContentViewController) {
        reference.getData(maxSize: 10 * 1024 * 1024) { data, error in
            guard let data, error == nil else {
                print("Error fetching PDF file: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            let pdfView = PDFView()
            pdfView.document = PDFDocument(data: data)
            viewController.view.addSubview(pdfView)
            viewController.setupConstraints(for: pdfView)
        }
    }
    
    func playAudioFile(from reference: StorageReference, in viewController: UIViewController) {
        reference.downloadURL { url, error in
            guard let url, error == nil else {
                print("Error fetching audio URL: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            let player = AVPlayer(url: url)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            viewController.present(playerViewController, animated: true)
        }
    }
    
    func playVideoFile(from reference: StorageReference, in viewController: UIViewController) {
        reference.downloadURL { url, error in
            guard let url, error == nil else {
                print("Error fetching video URL: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            let player = AVPlayer(url: url)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            viewController.present(playerViewController, animated: true)
        }
    }
    
    func deleteFile(from reference: StorageReference) {
        reference.delete { error in
            guard error != nil else { return }
        }
    }
}

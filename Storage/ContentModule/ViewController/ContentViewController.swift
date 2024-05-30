//
//  ContentViewController.swift
//  Storage
//
//  Created by KOДИ on 30.05.2024.
//

import UIKit
import FirebaseStorage

class ContentViewController: UIViewController {
    
    private let fileContnent = FileContentManager.shared
    let fileRef: StorageReference
    
    init(fileRef: StorageReference) {
        self.fileRef = fileRef
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupView()
    }
    
    private func setupNavigationBar() {
        title = "Content"
        navigationItem.largeTitleDisplayMode = .never
    }
    
    private func setupView() {
        view.backgroundColor = .white
        displayContent(for: fileRef)
    }
    
    private func displayContent(for reference: StorageReference) {
        if reference.name.hasSuffix(".txt") {
            fileContnent.displayTextFile(from: reference, in: self)
        } else if reference.name.hasSuffix(".jpg") || reference.name.hasSuffix(".png") || reference.name.hasSuffix(".jpeg"){
            fileContnent.displayImageFile(from: reference, in: self)
        } else if reference.name.hasSuffix(".pdf") {
            fileContnent.displayPDFFile(from: reference, in: self)
        } else if reference.name.hasSuffix(".mp3") || reference.name.hasSuffix(".wav") {
            fileContnent.playAudioFile(from: reference, in: self)
        } else if reference.name.hasSuffix(".mp4") {
            fileContnent.playVideoFile(from: reference, in: self)
        }
    }
}

//MARK: - Constraints
extension ContentViewController {
    func setupConstraints(for view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            view.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

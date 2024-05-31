//
//  StorageViewController.swift
//  Storage
//
//  Created by KOДИ on 27.05.2024.
//

import UIKit
import FirebaseStorage

protocol StorageViewControllerDelegate: AnyObject {
    func updateItems(items: [StorageReference])
}

class StorageViewController: UIViewController {
    
    private let fileContnent = FileContentManager.shared
    private var storageRef: StorageReference!
    
    weak var delegate: StorageViewControllerDelegate?
    
    private lazy var storageView: StorageView = {
        let view = StorageView()
        view.delegate = self
        delegate = view
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupView()
        setupConstraints()
        
        storageRef = Storage.storage().reference()
        fetchStorageContents()
    }
    
    private func setupNavigationBar() {
        title = "Storage"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupView() {
        view.addSubview(storageView)
    }
    
    private func fetchStorageContents() {
        storageRef.listAll { result, error in
            if let error = error {
                print(error)
                return
            }
            self.delegate?.updateItems(items: result?.items ?? [])
        }
    }
}

//MARK: - StorageViewDelegate
extension StorageViewController: StorageViewDelegate {
    func didSelectFile(_ fileRef: StorageReference) {
        if fileRef.name.hasSuffix(".mp3") || fileRef.name.hasSuffix(".wav") {
            fileContnent.playAudioFile(from: fileRef, in: self)
        } else if fileRef.name.hasSuffix(".mp4") {
            fileContnent.playVideoFile(from: fileRef, in: self)
        } else {
            navigationController?.pushViewController(ContentViewController(fileRef: fileRef), animated: true)
        }
    }
}

//MARK: - Constraints
private extension StorageViewController {
    func setupConstraints() {
        NSLayoutConstraint.activate([
            storageView.topAnchor.constraint(equalTo: view.topAnchor),
            storageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            storageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            storageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

//
//  StorageViewController.swift
//  Storage
//
//  Created by KOДИ on 27.05.2024.
//

import UIKit
import FirebaseStorage

class StorageViewController: UIViewController {
    
    private let storageView = StorageView()
    private var storageRef: StorageReference!
    
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
        storageRef.listAll { (result, error) in
            if let error = error {
                print(error)
                return
            }
            self.storageView.items = result!.items
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

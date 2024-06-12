//
//  StorageViewController.swift
//  Storage
//
//  Created by KOДИ on 27.05.2024.
//

import UIKit
import FirebaseStorage
import AVKit

protocol StorageViewControllerDelegate: AnyObject {
    func updateItems(items: [StorageReference])
}

class StorageViewController: UIViewController {
    
    private let firebaseManager = FirebaseManager.shared
    
    weak var delegate: StorageViewControllerDelegate?
    private var currentPath = ""
    
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
        fetchStorageContents()
    }
    
    private func setupNavigationBar() {
        title = "Storage"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(didTapBack))
        updateBackButtonVisibility()
    }
    
    private func setupView() {
        view.addSubview(storageView)
    }
    
    private func fetchStorageContents() {
        print("------      Fetching contents at path: \(currentPath) -----------")
        firebaseManager.fetchStorageContents(at: currentPath) { result in
            switch result {
            case .success(let items):
                self.delegate?.updateItems(items: items)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func updateBackButtonVisibility() {
        navigationItem.leftBarButtonItem?.isEnabled = !currentPath.isEmpty
    }
    
    @objc private func didTapBack() {
        if !currentPath.isEmpty {
            currentPath = (currentPath as NSString).deletingLastPathComponent
            fetchStorageContents()
            updateBackButtonVisibility()
        }
    }
}

//MARK: - StorageViewDelegate
extension StorageViewController: StorageViewDelegate {
    func didSelectFile(_ fileRef: StorageReference) {
        let fileType = FileType(fileRef: fileRef)
        switch fileType {
        case .media:
            firebaseManager.playMediaFile(from: fileRef) { result in
                switch result {
                case .success(let url):
                    let player = AVPlayer(url: url)
                    let playerViewController = AVPlayerViewController()
                    playerViewController.player = player
                    self.present(playerViewController, animated: true)
                case .failure(let error):
                    print(error)
                }
            }
        case .other:
            currentPath = fileRef.fullPath
            firebaseManager.fetchStorageContents(at: currentPath) { result in
                switch result {
                case .success(let items):
                    self.delegate?.updateItems(items: items)
                    self.updateBackButtonVisibility()
                case .failure(let error):
                    print(error)
                }
            }
        default:
            navigationController?.pushViewController(ContentViewController(fileRef: fileRef), animated: true)
        }
    }
    
    func deleteFile(_ fileRef: FirebaseStorage.StorageReference) {
        firebaseManager.deleteFile(from: fileRef)
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

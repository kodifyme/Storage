//
//  ContentViewController.swift
//  Storage
//
//  Created by KOДИ on 30.05.2024.
//

import UIKit
import FirebaseStorage
import PDFKit

class ContentViewController: UIViewController {
    
    private let firebaseManager = FirebaseManager.shared
    private let fileRef: StorageReference
    
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
        let fileType = FileType(fileRef: reference)
        switch fileType {
        case .text:
            firebaseManager.displayTextFile(from: reference) { result in
                switch result {
                case .success(let data):
                    if let text = String(data: data, encoding: .utf8) {
                        let textView = UITextView()
                        textView.text = text
                        self.view.addSubview(textView)
                        self.setupConstraints(for: textView)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        case .image:
            firebaseManager.displayImageFile(from: reference) { result in
                switch result {
                case .success(let data):
                    if let image = UIImage(data: data) {
                        let imageView = UIImageView()
                        imageView.contentMode = .scaleAspectFit
                        imageView.image = image
                        self.view.addSubview(imageView)
                        self.setupConstraints(for: imageView)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        case .pdf:
            firebaseManager.displayPDFFile(from: reference) { result in
                switch result {
                case .success(let data):
                    let pdfView = PDFView()
                    pdfView.document = PDFDocument(data: data)
                    self.view.addSubview(pdfView)
                    self.setupConstraints(for: pdfView)
                case .failure(let error):
                    print(error)
                }
            }
        case .media, .folder:
            break
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

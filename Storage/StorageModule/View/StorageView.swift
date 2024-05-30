//
//  StorageView.swift
//  Storage
//
//  Created by KOДИ on 28.05.2024.
//

import UIKit
import FirebaseStorage

protocol StorageViewDelegate: AnyObject {
    func didSelectFile(_ fileRef: StorageReference)
}

class StorageView: UIView {
    
    weak var delegate: StorageViewDelegate?
    
    var items: [StorageReference] = [] {
        didSet {
            storageTableView.reloadData()
        }
    }
    
    private lazy var storageTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setDelegates()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(storageTableView)
    }
    
    private func setDelegates() {
        storageTableView.dataSource = self
        storageTableView.delegate = self
    }
}

//MARK: - UITableViewDataSource
extension StorageView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = items[indexPath.row]
        cell.textLabel?.text = item.name
        return cell
    }
}

//MARK: - UITableViewDelegate
extension StorageView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.didSelectFile(items[indexPath.row])
    }
}

//MARK: - Constraints
private extension StorageView {
    func setupConstraints() {
        NSLayoutConstraint.activate([
            storageTableView.topAnchor.constraint(equalTo: topAnchor),
            storageTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            storageTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            storageTableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

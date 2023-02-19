//
//  HomeVC.swift
//  PorttoAssignment
//
//  Created by 薛宇振 on 2023/2/19.
//

import Foundation
import UIKit

class ListVC: UIViewController, Coordinating {
    
    // MARK: - Properties
    var coordinator: Coordinator?
    private let viewModel = ListViewModel()
    
    // MARK: - UI Component
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(ListCell.self, forCellWithReuseIdentifier: ListCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    lazy var amountLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "$100"
        label.font = UIFont.systemFont(ofSize: 40)
        label.textAlignment = .left
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        setupConstraints()
    }
    
    private func setupConstraints() {
        view.addSubview(amountLabel)
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            amountLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            amountLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            amountLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            amountLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: amountLabel.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        
    }
}

extension ListVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let rowViewModel =
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCell.identifier, for: indexPath)
        if let cell = cell as? CellConfigurable {
            cell.setup(viewModel: )
        }
        cell.layoutIfNeeded()
        return cell
    }
    
    
    
}

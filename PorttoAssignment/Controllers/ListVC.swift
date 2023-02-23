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
    private var cellData: [Assets] = []
    
    // MARK: - UI Component
    
    lazy var collectionView: UICollectionView = {
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: screenWidth / 2 - 10, height: 150)
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(ListCell.self, forCellWithReuseIdentifier: ListCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Loading..."
        label.font = UIFont.systemFont(ofSize: 40)
        label.textAlignment = .left
        return label
    }()
    
    lazy var loadingIdicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    // MARK: - Lift Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "List"
        view.backgroundColor = .white
        setupConstraints()
        setupBinders()
        viewModel.getList()        
        Task {
            let newValue = await viewModel.getBalence() ?? "0"
            amountLabel.text = "$ \(newValue)"
        }
    }
    
    // MARK: - Private Func
    
    private func setupConstraints() {
        view.addSubview(amountLabel)
        view.addSubview(collectionView)
        view.addSubview(loadingIdicator)
        NSLayoutConstraint.activate([
            loadingIdicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIdicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            amountLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            amountLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            amountLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            amountLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: amountLabel.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setLoading(isLoading: Bool) {
        if isLoading {
            self.loadingIdicator.startAnimating()
        } else {
            self.loadingIdicator.stopAnimating()
        }
    }
    
    private func setupBinders() {                
        
        viewModel.isLoading.bind { [weak self] isLoading in
            self?.setLoading(isLoading: isLoading)
        }
        
        viewModel.listValue.bind { [weak self] listValue in
            if !listValue.isEmpty {
                self?.cellData.append(contentsOf: listValue)
                self?.collectionView.reloadData()                
            }
        }
        
        viewModel.getListErrorDescription.bind { error in
            if let error = error {
                print("get list error:", error.debugDescription)
            }
        }
    }
}

// MARK: - Extension
extension ListVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.cellData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCell.identifier, for: indexPath)
        let data = cellData[indexPath.row]
        let cellDataModel = ListCellDataModel(title: data.name, image: AsyncImage(url: data.imageUrl))
        if let cell = cell as? CellConfigurable
        {
            cell.setup(dataModel: cellDataModel)
        }
        cell.layoutIfNeeded()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (loadingIdicator.isAnimating) {
            return
        }
        if indexPath.row == cellData.count - 1 {
            viewModel.getList()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let event = ListEvent.navigationToCollection(assets: cellData[indexPath.row])
        coordinator?.eventOccurred(with: event)
    }
    
}

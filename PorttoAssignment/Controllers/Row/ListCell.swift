//
//  HomeCell.swift
//  PorttoAssignment
//
//  Created by 薛宇振 on 2023/2/19.
//

import UIKit

class ListCell: UICollectionViewCell, CellConfigurable {
    
    static let identifier = "HomeCell"
    
    var viewModel: ListCellViewModel?
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var label: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    func setup(viewModel: RowViewModel) {
        guard let viewModel = viewModel as? ListCellViewModel else {
            return
        }
        self.viewModel = viewModel
        
    }
    
    
    private func setupConstraints() {
        contentView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        ])
    }
}

//
//  ListCell.swift
//  PorttoAssignment
//
//  Created by 薛宇振 on 2023/2/19.
//

import WebKit
import UIKit

class ListCell: UICollectionViewCell, CellConfigurable {
    
    // MARK: - Properties
    
    static let identifier = "ListCell"
    private var dataModel: ListCellDataModel?
    private var prepareReuse = false
    
    // MARK: - UI Component
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.contentMode = .scaleAspectFit
        webView.backgroundColor = .clear
        webView.isHidden = true
        webView.navigationDelegate = self
        webView.scrollView.delegate = self
        webView.isUserInteractionEnabled = false
        return webView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    // MARK: - Lift Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
        webView.scrollView.setContentOffset(.init(x: 1000, y: 1000), animated: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Internal Func
    
    func setup(dataModel: RowViewModel) {
        guard let dataModel = dataModel as? ListCellDataModel else {
            return
        }
        self.dataModel = dataModel
        self.nameLabel.text = dataModel.name
        
        dataModel.image.startDownload()
        
        dataModel.image.completeDownload = { [weak self] (image, url) in
            
            if (image == nil && url == URL(string: "nil")) {
                self?.imageView.isHidden = false
                self?.webView.isHidden = true
                self?.imageView.image = UIImage(named: "placeholderImage")
            } else if (image == nil) {
                self?.webView.isHidden = false
                self?.imageView.isHidden = true
                self?.webView.load(URLRequest(url: url))
                self?.webView.scrollView.layoutIfNeeded()
            } else {
                self?.imageView.isHidden = false
                self?.webView.isHidden = true
                self?.imageView.image = image
            }
        }
        
        setNeedsLayout()
    }
    
    // MARK: - private Func
    
    private func setupConstraints() {
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(webView)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            imageView.heightAnchor.constraint(equalToConstant: 100),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            webView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            webView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            webView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            webView.heightAnchor.constraint(equalToConstant: 100),
            webView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = UIImage(named: "placeholderImage")
        dataModel?.image.completeDownload = nil
    }
        
}

extension ListCell: WKNavigationDelegate, UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        webView.scrollView.setContentOffset(.init(x: webView.scrollView.contentSize.width / 5.5, y: webView.scrollView.contentSize.height / 5), animated: false)
    }
}

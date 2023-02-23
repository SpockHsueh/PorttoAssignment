//
//  CollectionVC.swift
//  PorttoAssignment
//
//  Created by 薛宇振 on 2023/2/20.
//

import Foundation
import UIKit
import WebKit

class CollectionVC: UIViewController, Coordinating {
    
    // MARK: - Properties
    
    var coordinator: Coordinator?
    var viewModel: CollectionViewModel?
    var permalink: URL?
    
    // MARK: - UI Component
    
    private let scrollStackViewContainer: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        view.distribution = .fill
        return view
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .white
        return scrollView
    }()
    
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
        webView.scrollView.isScrollEnabled = false
        webView.contentMode = .scaleAspectFit
        webView.backgroundColor = .clear
        webView.isHidden = true
        return webView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 25)
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    lazy var linkButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(linkButtonPressed), for: .touchUpInside)
        button.setTitle("Open permalink", for: .normal)
        button.setTitleColor(UIColor.gray, for: .normal)
        return button
    }()
    
    // MARK: - Lift Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupConstraints()
        setupBinders()
        viewModel?.setup()
    }
    
    deinit {
        print("CollectionVC deinit")
        let event = CollectionEvent.navigationToList
        coordinator?.eventOccurred(with: event)
    }
    
    // MARK: - Private Func
    
    @objc private func linkButtonPressed() {
        
        guard let permalink = permalink else {
            return
        }

        let event = CollectionEvent.navigationToWebView(url: permalink)
        coordinator?.eventOccurred(with: event)
    }
    
    private func setupBinders() {
        guard let viewModel = viewModel else {
            return
        }
        
        viewModel.pageValue.bind { [weak self] data in
            if let data = data {
                self?.nameLabel.text = data.name
                self?.descriptionLabel.text = data.description
                self?.title = data.collection.name
                self?.permalink = URL(string: data.permalink)
            }
        }
        
        viewModel.image.bind { [weak self] asyncImage in
            
            guard let asyncImage = asyncImage else {
                return
            }
            
            asyncImage.startDownload()
            asyncImage.completeDownload = { (image, url) in
                
                if (image == nil && url == URL(string: "nil")) {
                    self?.imageView.isHidden = false
                    self?.webView.isHidden = true
                    self?.imageView.image = UIImage(named: "placeholderImage")
                    self?.resizeImage(image: image)
                    
                } else if (image == nil) {
                    self?.webView.isHidden = false
                    self?.imageView.isHidden = true
                    self?.webView.load(URLRequest(url: url))
                    self?.resizeWebView()
                    
                } else {
                    self?.imageView.isHidden = false
                    self?.webView.isHidden = true
                    self?.imageView.image = image
                    self?.resizeImage(image: image)
                }
                self?.scrollStackViewContainer.sizeToFit()
                self?.view.layoutIfNeeded()
            }
        }
    }
    
    private func resizeWebView() {
        let myWebViewWidth = scrollStackViewContainer.frame.width - 160
        let myWebViewHeight = CGFloat(100)
        let myViewWidth = scrollStackViewContainer.frame.width
        
        let ratio = myViewWidth / myWebViewWidth
        let scaledHeight = myWebViewHeight * ratio
        webView.heightAnchor.constraint(equalToConstant: scaledHeight).isActive = true
    }
        
    private func resizeImage(image: UIImage?) {
        let myImageWidth = scrollStackViewContainer.frame.width - 160
        let myImageHeight = CGFloat(100)
        let myViewWidth = scrollStackViewContainer.frame.width
        
        let ratio = myViewWidth/myImageWidth
        let scaledHeight = myImageHeight * ratio
        imageView.heightAnchor.constraint(equalToConstant: scaledHeight).isActive = true
    }
    
    private func setupConstraints() {
        
        let margins = view.layoutMarginsGuide
        view.addSubview(scrollView)
        view.addSubview(linkButton)
        scrollView.addSubview(scrollStackViewContainer)
        
        NSLayoutConstraint.activate([
            
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: margins.topAnchor, constant: 30),
            scrollView.bottomAnchor.constraint(equalTo: linkButton.topAnchor, constant: 5),
            
            scrollStackViewContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            scrollStackViewContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            scrollStackViewContainer.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollStackViewContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            scrollStackViewContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            linkButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            linkButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            linkButton.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -10),
        ])
        
        configureContainerView()
    }
    
    private func configureContainerView() {
        scrollStackViewContainer.addArrangedSubview(imageView)
        scrollStackViewContainer.addArrangedSubview(webView)
        scrollStackViewContainer.addArrangedSubview(nameLabel)
        scrollStackViewContainer.addArrangedSubview(descriptionLabel)
    }
    
}

//
//  AsyncImage.swift
//  PorttoAssignment
//
//  Created by 薛宇振 on 2023/2/20.
//

import Foundation
import UIKit

class AsyncImage {
        
    private var imageStore: UIImage?
    private var placeholder: UIImage
    private let imageDownloadHelper: ImageDownloadHelperProtocol
    private var isDownloading: Bool = false
    let url: URL
    var image: UIImage {
        return self.imageStore ?? placeholder
    }
    var completeDownload: ((UIImage?, URL) -> Void)?

    init(url: String,
         placeholderImage: UIImage = #imageLiteral(resourceName: "placeholderImage") ,
         imageDownloadHelper: ImageDownloadHelperProtocol = DownloadImage()) {
        self.url = URL(string: url)!
        self.placeholder = placeholderImage
        self.imageDownloadHelper = imageDownloadHelper
    }
    
    func startDownload() {
        if imageStore != nil {
            completeDownload?(image, url)
        } else {
            if isDownloading { return }
            isDownloading = true
            imageDownloadHelper.download(url: url, completion: { [weak self] (image, response, error, url) in
                self?.imageStore = image
                self?.isDownloading = false
                DispatchQueue.main.async {
                    self?.completeDownload?(image, url)
                }
            })
        }
    }
}

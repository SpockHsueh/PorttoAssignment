//
//  DownloadImage.swift
//  PorttoAssignment
//
//  Created by 薛宇振 on 2023/2/20.
//

import Foundation
import UIKit

protocol ImageDownloadHelperProtocol {
    func download(url: URL, completion: @escaping (UIImage?, URLResponse?, Error?, URL) -> ())
}

class DownloadImage: ImageDownloadHelperProtocol {
    
    let urlSession: URLSession = URLSession.shared

    static var shared: DownloadImage = {
        return DownloadImage()
    }()
    
    func download(url: URL, completion: @escaping (UIImage?, URLResponse?, Error?, URL) -> ()) {
        urlSession.dataTask(with: url) { data, response, error in
            if let data = data {
                completion(UIImage(data: data), response, error, url)
            } else {
                completion(nil, response, error, url)
            }
        }.resume()
    }
}

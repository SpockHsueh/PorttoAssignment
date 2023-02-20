//
//  ListModel.swift
//  PorttoAssignment
//
//  Created by 薛宇振 on 2023/2/19.
//

import Foundation

struct ListModel: Codable {
    let assets: [Assets]
}

struct Assets: Codable {
    let imageUrl: String
    let name: String
    let description: String
    let permalink: String
    
    enum CodingKeys: String, CodingKey {
        case imageUrl = "image_url"
        case name
        case description
        case permalink
    }
}


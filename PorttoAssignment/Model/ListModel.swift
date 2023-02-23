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
    let collection: Collection
    
    enum CodingKeys: String, CodingKey {
        case imageUrl = "image_url"
        case name
        case description
        case permalink
        case collection
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.imageUrl = try values.decodeIfPresent(String.self, forKey: .imageUrl)
              ?? "nil"
        self.name = try values.decodeIfPresent(String.self, forKey: .name)
              ?? "nil"
        self.description = try values.decodeIfPresent(String.self, forKey: .description)
              ?? "nil"
        self.permalink = try values.decodeIfPresent(String.self, forKey: .permalink)
              ?? "nil"
        self.collection = try values.decodeIfPresent(Collection.self, forKey: .collection) ?? Collection(name: "nil")
    }
    
    struct Collection: Codable {
        let name: String
    }
}

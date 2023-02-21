//
//  CollectionViewModel.swift
//  PorttoAssignment
//
//  Created by 薛宇振 on 2023/2/20.
//

import Foundation
import UIKit

class CollectionViewModel {
    var pageValue: ObserableObject<Assets?> = ObserableObject(nil)
    var image: ObserableObject<AsyncImage?> = ObserableObject(nil)
    private var assets: Assets?
    
    init(data: Assets?) {
        self.assets = data
    }
    
    func setup() {
        guard let assets = assets else {
            return
        }

        pageValue.value = assets
        self.image.value = AsyncImage(url: assets.imageUrl)
    }
}

//
//  ListCellDataModel.swift
//  PorttoAssignment
//
//  Created by 薛宇振 on 2023/2/20.
//

import Foundation

class ListCellDataModel: ViewModelPressible, RowViewModel {
    var cellPressed: (() -> Void)?
    let name: String
    let image: AsyncImage
    
    init(title: String, image: AsyncImage) {
        self.name = title
        self.image = image
    }
}

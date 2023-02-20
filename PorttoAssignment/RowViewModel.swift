//
//  RowViewModel.swift
//  PorttoAssignment
//
//  Created by 薛宇振 on 2023/2/19.
//

import Foundation

protocol RowViewModel {}

protocol CellConfigurable {
    func setup(dataModel: RowViewModel)
}

protocol ViewModelPressible {
    var cellPressed: (()-> Void)? { get set }
}

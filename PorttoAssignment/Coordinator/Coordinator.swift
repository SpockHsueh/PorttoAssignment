//
//  Coordinator.swift
//  PorttoAssignment
//
//  Created by 薛宇振 on 2023/2/19.
//

import Foundation
import UIKit

protocol Event {}

enum ListEvent: Event {
    case navigationToCollection(assets: Assets)
}

enum CollectionEvent: Event {
    case navigationToList
    case navigationToWebView(url: URL)
}

protocol Coordinator: AnyObject {
    var parentCoordinator: Coordinator? { get set }
    var children: [Coordinator] { get set }
    var navigationController: UINavigationController? { get set }
    func start()
    func eventOccurred(with type: Event)
}

protocol Coordinating {
    var coordinator: Coordinator? { get set }
}

extension Coordinator {
    func childDidFinish(_ coordinator : Coordinator){
        for (index, child) in children.enumerated() {
            if child === coordinator {
                children.remove(at: index)
                break
            }
        }
    }
}

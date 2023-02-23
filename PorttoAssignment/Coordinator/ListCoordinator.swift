//
//  ListCoordinator.swift
//  PorttoAssignment
//
//  Created by 薛宇振 on 2023/2/19.
//

import Foundation
import UIKit

class ListCoordinator: Coordinator {
    
    var parentCoordinator: Coordinator?
    
    var children: [Coordinator] = []
    
    var navigationController: UINavigationController?
    
    func start() {
        var vc: UIViewController & Coordinating = ListVC()
        vc.coordinator = self
        navigationController?.setViewControllers([vc], animated: false)
    }
    
    func eventOccurred(with type: Event) {
        guard let type = type as? ListEvent else {
            return
        }
        
        switch type {
        case .navigationToCollection(let assets):
            let collectionCoordinator = CollectionCoordinator()
            collectionCoordinator.parentCoordinator = self
            collectionCoordinator.assets = assets
            collectionCoordinator.navigationController = navigationController
            children.append(collectionCoordinator)
            collectionCoordinator.start()
        }
    }
    
    deinit {
        print("ListCoordinator deinit")
    }
}


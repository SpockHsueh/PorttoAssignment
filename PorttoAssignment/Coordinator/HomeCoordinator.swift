//
//  HomeCoordinator.swift
//  PorttoAssignment
//
//  Created by 薛宇振 on 2023/2/19.
//

import Foundation
import UIKit

class HomeCoordinator: Coordinator {
    
    var parentCoordinator: Coordinator?
    
    var children: [Coordinator] = []
    
    var navigationController: UINavigationController?
    
    func start() {
        var vc: UIViewController & Coordinating = ListVC()
        vc.coordinator = self
        navigationController?.setViewControllers([vc], animated: false)
    }
    
    func eventOccurred(with type: Event) {
        
    }
    
    deinit {
        print("HomeCoordinator deinit")
    }
}


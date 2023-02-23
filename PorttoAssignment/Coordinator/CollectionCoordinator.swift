//
//  CollectionCoordinator.swift
//  PorttoAssignment
//
//  Created by 薛宇振 on 2023/2/20.
//

import Foundation
import UIKit

class CollectionCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    
    var children: [Coordinator] = []
    
    var navigationController: UINavigationController?
    
    var assets: Assets?
    
    func start() {
        let vc = CollectionVC()
        vc.coordinator = self
        vc.viewModel = CollectionViewModel(data: assets)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func eventOccurred(with type: Event) {
        guard let type = type as? CollectionEvent else {
            return
        }
        
        switch type {
        case .navigationToList:
            parentCoordinator?.childDidFinish(self)
        case .navigationToWebView(let url):
            UIApplication.shared.open(url)
        }
    }
    
    deinit {
        print("CollectionCoordinator deinit")
    }
}

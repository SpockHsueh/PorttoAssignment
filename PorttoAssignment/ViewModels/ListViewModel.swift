//
//  ListViewModel.swift
//  PorttoAssignment
//
//  Created by 薛宇振 on 2023/2/19.
//

import Foundation

class ListViewModel {
    
    var listValue: ObserableObject<[Assets]> = ObserableObject([])
    var getListErrorDescription: ObserableObject<String?> = ObserableObject(nil)
    
    func getList(offset: Int = 0, linit: Int = 20) {
        GetListService.getList(offset: offset, limit: linit) { [weak self] listRes in
            switch listRes {
            case .failure(let error):
                var errorMessage = ""
                switch error {
                case .unexpectedError(let error):
                    errorMessage = error
                case .invalidURL: errorMessage = "Invalid URL"
                case .missingData: errorMessage = "Missing Data"
                }
                self?.getListErrorDescription.value = errorMessage
            case .success(let value):
                self?.listValue.value = value.assets
            }
        }
    }
}

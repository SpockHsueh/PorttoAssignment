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
    var isLoading: ObserableObject<Bool> = ObserableObject(false)
    var currentPage: Int = 0
    
    func getList(offset: Int? = nil, linit: Int = 20) {
        isLoading.value = true
        if let offset = offset {
            currentPage = offset
        }
        GetListService.getList(offset: currentPage, limit: linit) { [weak self] listRes in
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
            self?.isLoading.value = false
            self?.currentPage += 1
        }
    }
}

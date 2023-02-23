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
    private var currentPage: Int = 0
    private let getListService: GetListServiceProtocol.Type
    private let we3Service: Web3ServiceProtocol.Type
    
    init(getListService: GetListServiceProtocol.Type, we3Service: Web3ServiceProtocol.Type) {
        self.getListService = getListService
        self.we3Service = we3Service
    }
    
    func getList(offset: Int? = nil, linit: Int = 20) {
                
        isLoading.value = true
        
        if let offset = offset {
            currentPage = offset
        }
        
        getListService.getList(offset: currentPage, limit: linit) { [weak self] listRes in
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
                self?.isLoading.value = false
            case .success(let value):
                self?.listValue.value = value.assets
            }
            self?.isLoading.value = false
            self?.currentPage += 1
        }
    }
    
    func getBalence() async -> String? {
        return await we3Service.getAddressBalance()
    }
}

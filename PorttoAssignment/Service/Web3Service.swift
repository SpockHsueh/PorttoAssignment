//
//  Web3Service.swift
//  PorttoAssignment
//
//  Created by 薛宇振 on 2023/2/21.
//

import Foundation
import web3

struct Web3Service {
    
    static func getAddressBalance() async -> String? {
        
        guard let clientURL = URL(string: "https://mainnet.infura.io/v3/b9e1fcbbab854c90b9d07846167ab453") else {
            return nil
        }
        
        let client = EthereumHttpClient(url: clientURL)
        
        do {
            let balance = try await client.eth_getBalance(address: "0x85fD692D2a075908079261F5E351e7fE0267dB02", block: .Latest)
            return String(balance)
        } catch {
            print(error)
            return nil
        }
    }
}

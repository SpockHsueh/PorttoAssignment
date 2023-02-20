//
//  GetListService.swift
//  PorttoAssignment
//
//  Created by 薛宇振 on 2023/2/19.
//

import Foundation

struct GetListService {
    
    enum GetListError: Error {
        case invalidURL
        case missingData
        case unexpectedError(error: String)
    }
    
    static func getList(offset: Int = 0,
                        limit:Int = 20,
                        completion: @escaping (Result<ListModel, GetListError>) -> Void) {
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "testnets-api.opensea.io"
        components.path = "/api/v1/assets"

        components.queryItems = [
            URLQueryItem(name: "owner", value: "0x85fD692D2a075908079261F5E351e7fE0267dB02"),
            URLQueryItem(name: "offset", value: String(offset)),
            URLQueryItem(name: "limit", value: String(limit))
        ]
                                
        guard let url = components.url else {
            DispatchQueue.main.async {
                completion(.failure(GetListError.invalidURL))
            }
            return
        }
        print(url)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
//        request.addValue("vqYuKPOkLQLYHhk4QTGsGKFwATT4mBIGREI2m8eD", forHTTPHeaderField: "X-Parse-Application-Id")
        
        print(request)
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(GetListError.unexpectedError(error: error.localizedDescription)))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(GetListError.missingData))
                }
                return
            }
            
            let response = response as! HTTPURLResponse
            let status = response.statusCode
            
            guard (200...299).contains(status) else {
                
                if let errorJson = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? Dictionary<String,Any> {
                    if let error = errorJson["owner"] as? [String] {
                        DispatchQueue.main.async {
                            completion(.failure(GetListError.unexpectedError(error: error.first ?? "some error")))
                        }
                    }
                }
                return
            }
            
            do {
                let listResult = try JSONDecoder().decode(ListModel.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(listResult))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(GetListError.unexpectedError(error: error.localizedDescription)))
                }
            }
            
        }.resume()
        
    }
}

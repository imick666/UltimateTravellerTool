//
//  HTTPClient.swift
//  UltimateTravellerTool
//
//  Created by mickael ruzel on 29/06/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import Foundation

final class HTTPClient {
    
    //MARK: - PROPERTIES
    private let httpRequest: HTTPRequest
    
    //MARK: - INITIALIZER
    init(httpRequest: HTTPRequest = HTTPRequest()) {
        self.httpRequest = httpRequest
    }
    
    //MARK: - METHODES
    func requestJson<T: Decodable>(baseUrl: URL, parameters: [(String, Any)]?, callback: @escaping ((Result<T, NetworkError>) -> Void)) {

        httpRequest.request(baseUrl: baseUrl, parameters: parameters) { (data, response, error) in
            guard response != nil else {
                callback(.failure(.noConnection))
                return
            }
            guard let response = response, response.statusCode == 200 else {
                callback(.failure(.badResponse))
                return
            }
            guard let data = data, error == nil else {
                callback(.failure(.noData))
                return
            }
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                callback(.success(decodedData))
            } catch {
                callback(.failure(.dataUndecodable))
            }
        }
    }
    
    func requestData(baseUrl: URL, parameters: [(String, Any)]?, callback: @escaping ((Result<Data, NetworkError>) -> Void)) {
        httpRequest.request(baseUrl: baseUrl, parameters: parameters) { (data, response, error) in
            guard response != nil else {
                callback(.failure(.noConnection))
                return
            }
            guard let response = response, response.statusCode == 200 else {
                callback(.failure(.badResponse))
                return
            }
            guard let data = data, error == nil else {
                callback(.failure(.noData))
                return
            }
            callback(.success(data))
        }
    }
}

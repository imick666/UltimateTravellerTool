//
//  HTTPRequest.swift
//  UltimateTravellerTool
//
//  Created by mickael ruzel on 29/06/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import Foundation

/**
 Make a generic Http Request
 */
final class HTTPRequest {
    
    typealias httpResponse = (Data?, HTTPURLResponse?, Error?) -> Void
    
    private let session: URLSession
    private var task: URLSessionDataTask?
    
    init(session: URLSession = URLSession(configuration: .default)) {
        self.session = session
    }
    
    // MARK : - Methodes

    /**
    - Parameters:
        - baseUrl: Base URL without query items.
        - parameters: Query items in tuple with (key, value).
        - callback: A CALLBACK.
     */
    func request(baseUrl: URL, bodyQuery: [String: Any]?, parameters: [(String, Any)]?, callback: @escaping httpResponse) {
        
        let url = encodeUrl(baseUrl: baseUrl, parameters: parameters)
        let body = encodeBody(query: bodyQuery)
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = body
        
        Logger(url: url).show()
        
        task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            guard let response = response as? HTTPURLResponse else {
                callback(data, nil, error)
                return
            }
            callback(data, response, error)
        })
        task?.resume()
    }
    
    private func encodeUrl(baseUrl: URL, parameters: [(String, Any)]?) -> URL {
        guard var urlComponent = URLComponents(url: baseUrl, resolvingAgainstBaseURL: false), let parameters = parameters, !parameters.isEmpty else {
            return baseUrl
        }
        
        urlComponent.queryItems = [URLQueryItem]()
        for (key, value) in parameters {
            let queryItems = URLQueryItem(name: key, value: "\(value)")
            urlComponent.queryItems?.append(queryItems)
        }
        
        guard let url = urlComponent.url else { return baseUrl }
        return url
    }
    
    private func encodeBody(query: [String: Any]?) -> Data? {
        guard query != nil else {
            return nil
        }
        
        let jsonData = try? JSONSerialization.data(withJSONObject: query!)
        return jsonData
    }
}

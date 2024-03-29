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
     Create and lunch HTTPRequest
    - parameter  baseUrl: Base URL without query items.
    - parameter parameters: Query items in tuple with (key, value).
    - parameter callback: A callback containning the data, response and error
     */
    func request(baseUrl: URL, parameters: [(String, Any)]?, callback: @escaping httpResponse) {
        
        let url = encodeUrl(baseUrl: baseUrl, parameters: parameters)
        
        Logger(url: url).show()
        
        task = session.dataTask(with: url, completionHandler: { (data, response, error) in
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
}

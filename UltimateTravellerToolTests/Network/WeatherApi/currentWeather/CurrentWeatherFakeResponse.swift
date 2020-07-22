//
//  CurrentWeatherFakeResponse.swift
//  UltimateTravellerToolTests
//
//  Created by mickael ruzel on 22/07/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import Foundation

final class CurrentWeatherFakeResponse {
    
    private init() {}
    
    static let badUrlResponse = HTTPURLResponse(url: URL(string: "google.fr")!, statusCode: 500, httpVersion: nil, headerFields: nil)
    static let goodUrlResponse = HTTPURLResponse(url: URL(string: "google.fr")!, statusCode: 200, httpVersion: nil, headerFields: nil)
    
    class FakeError: Error { }
    static let fakeError = FakeError()
    
    private var goodData: Data {
        let bundle = Bundle(for: CurrentWeatherFakeResponse.self)
        guard let url = bundle.url(forResource: "CurrentWeather", withExtension: "json") else {
            return Data()
        }
        do {
            let data = try Data(contentsOf: url)
            return data
        } catch {
            return Data()
        }
        
    }
    
    private var badData: Data {
        let string = "coucou"
        let data = string.data(using: .utf8)
        return data!
    }
    
    static let incorrectData = CurrentWeatherFakeResponse().badData
    static let correctData = CurrentWeatherFakeResponse().goodData
}

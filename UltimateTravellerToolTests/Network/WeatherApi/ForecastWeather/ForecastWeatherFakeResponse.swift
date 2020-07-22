//
//  ForecastWeatherFakeResponse.swift
//  UltimateTravellerToolTests
//
//  Created by mickael ruzel on 22/07/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import Foundation

final class ForecastWeatherFakeResponse {
    
    private init() { }
    
    static let badResponse = HTTPURLResponse(url: URL(string: "google.fr")!, statusCode: 500, httpVersion: nil, headerFields: nil)
    static let goodResponse = HTTPURLResponse(url: URL(string: "google.fr")!, statusCode: 200, httpVersion: nil, headerFields: nil)
    
    class FakeError: Error { }
    static let fakeError = FakeError()
    
    private var goodData: Data {
        let bundle = Bundle(for: ForecastWeatherFakeResponse.self)
        guard let url = bundle.url(forResource: "ForecastWeather", withExtension: "json") else {
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
    
    static let correctData = ForecastWeatherFakeResponse().goodData
    static let incorrectData = ForecastWeatherFakeResponse().badData
}

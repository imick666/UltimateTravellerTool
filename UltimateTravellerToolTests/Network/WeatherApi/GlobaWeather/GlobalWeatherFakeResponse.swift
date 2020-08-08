//
//  GlobalWeatherFakeResponse.swift
//  UltimateTravellerToolTests
//
//  Created by mickael ruzel on 28/07/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import Foundation

class GlobalWeatherFakeResponse {
    static let goodResponse = HTTPURLResponse(url: URL(string: "google.fr")!, statusCode: 200, httpVersion: nil, headerFields: nil)
    static let basResponse = HTTPURLResponse(url: URL(string: "google.fr")!, statusCode: 500, httpVersion: nil, headerFields: nil)
    
    class FakeError: Error { }
    static let fakError = FakeError()
    
    private var goodData: Data? {
        let bundle = Bundle(for: GlobalWeatherFakeResponse.self)
        guard let url = bundle.url(forResource: "rain", withExtension: "png") else { return nil }
        let data = try? Data(contentsOf: url)
        return data
    }
    
    private var badData: Data? {
        let string = "testKO"
        let data = string.data(using: .utf8)
        return data
    }
    
    static let correctData = GlobalWeatherFakeResponse().goodData
    static let incorrectData = GlobalWeatherFakeResponse().badData
}

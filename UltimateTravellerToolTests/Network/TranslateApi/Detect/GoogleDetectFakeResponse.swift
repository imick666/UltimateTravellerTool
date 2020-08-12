//
//  GoogleDetectFakeResponse.swift
//  UltimateTravellerToolTests
//
//  Created by mickael ruzel on 12/08/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import Foundation

class GoogleDetectFakeResponse {
    static let goodResponse = HTTPURLResponse(url: URL(string: "google.fr")!, statusCode: 200, httpVersion: nil, headerFields: nil)
    static let badResponse = HTTPURLResponse(url: URL(string: "google.fr")!, statusCode: 500, httpVersion: nil, headerFields: nil)
    
    class FakeError: Error { }
    static let fakeError = FakeError()
    
    private var goodData: Data? {
        let bundle = Bundle(for: GoogleDetectFakeResponse.self)
        guard let url = bundle.url(forResource: "GoogleTranslateDetectResult", withExtension: "json") else {
            return nil
        }
        let data = try? Data(contentsOf: url)
        return data
    }
    
    private var badData: Data? {
        let string = "Test"
        let data = string.data(using: .utf8)
        return data
    }
    
    static let correctData = GoogleDetectFakeResponse().goodData
    static let incorrectData = GoogleDetectFakeResponse().badData
    
}

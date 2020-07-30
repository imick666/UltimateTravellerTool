//
//  GooglePlacesFakeResponse.swift
//  UltimateTravellerToolTests
//
//  Created by mickael ruzel on 30/07/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import Foundation

class GooglePlacesFakeResponse {
    static let badResponse = HTTPURLResponse(url: URL(string: "google.fr")!, statusCode: 500, httpVersion: nil, headerFields: nil)
    static let goodResponse = HTTPURLResponse(url: URL(string: "google.fr")!, statusCode: 200, httpVersion: nil, headerFields: nil)
    
    class FakeError: Error { }
    static let fakeError = FakeError()
    
    private var goodData: Data {
        let bundle = Bundle(for: GooglePlacesFakeResponse.self)
        let url = bundle.url(forResource: "GooglePlaces", withExtension: "json")
        let data = try! Data(contentsOf: url!)
        return data
    }
    private var badData: Data {
        let string = "cestok"
        let data = string.data(using: .utf8)!
        return data
    }
    
    static let correctData = GooglePlacesFakeResponse().goodData
    
    static let incorrectData = GooglePlacesFakeResponse().badData
}

//
//  CurrenciesFakeResponse.swift
//  UltimateTravellerToolTests
//
//  Created by mickael ruzel on 29/06/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import Foundation

final class CurrenciesFakeResponseData {
    private let url = URL(string: "test")!
    static let goodResponse = HTTPURLResponse(url: URL(string: "test")!, statusCode: 200, httpVersion: nil, headerFields: nil)
    static let badResponse = HTTPURLResponse(url: URL(string: "test")!, statusCode: 500, httpVersion: nil, headerFields: nil)
    
    class FakeError: Error { }
    static let fakeError = FakeError()
    
    static var correctData: Data {
        let bundle = Bundle(for: CurrenciesFakeResponseData.self)
        guard let url = bundle.url(forResource: "CurrenciesFakeData", withExtension: "json") else {
            return Data()
        }
        do {
            let data = try Data(contentsOf: url)
            return data
        } catch {
            return Data()
        }
    }
    
    static var incorrectData: Data {
        guard let data = "Test".data(using: .utf8) else { return Data() }
        do {
            let json = try JSONEncoder().encode(data)
            return json
        } catch {
            return Data()
        }
    }
}

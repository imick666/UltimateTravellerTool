//
//  CurrenciesTest.swift
//  UltimateTravellerToolTests
//
//  Created by mickael ruzel on 29/06/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import XCTest
@testable import UltimateTravellerTool

class CurrenciesTest: XCTestCase {
    
    func testBadHttpResponse() {
        
        let session = FakeUrlSession(fakeData: nil, fakeResponse: CurrenciesFakeResponseData.badResponse, fakeError: nil)
        let request = HTTPRequest(session: session)
        let client = HTTPClient(httpRequest: request)
        let currencies = CurrenciesService(httpClient: client)
        let expectation = XCTestExpectation(description: "Wait For Queu Change")
        
        currencies.getCurrencies { (result) in
            guard case .failure(let error) = result else {
                XCTFail("testBadHttpResponse FAILED")
                return
            }
            expectation.fulfill()
            XCTAssertEqual(error, NetworkError.badResponse)
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testError() {
        let session = FakeUrlSession(fakeData: nil, fakeResponse: CurrenciesFakeResponseData.goodResponse, fakeError: CurrenciesFakeResponseData.fakeError)
        let request = HTTPRequest(session: session)
        let client = HTTPClient(httpRequest: request)
        let currencies = CurrenciesService(httpClient: client)
        let expectation = XCTestExpectation(description: "Wait For Queu Change")
        
        currencies.getCurrencies { (result) in
            guard case .failure(let error) = result else {
                XCTFail("testError FAILED")
                return
            }
            expectation.fulfill()
            XCTAssertEqual(error, NetworkError.noData)
        }
        
        wait(for: [expectation], timeout: 0.01)
    }

    func testIncorrectData() {
        let session = FakeUrlSession(fakeData: CurrenciesFakeResponseData.incorrectData, fakeResponse: CurrenciesFakeResponseData.goodResponse, fakeError: nil)
        let request = HTTPRequest(session: session)
        let client = HTTPClient(httpRequest: request)
        let currencies = CurrenciesService(httpClient: client)
        let expectation = XCTestExpectation(description: "Wait For Queu Change")
        
        currencies.getCurrencies { (result) in
            guard case .failure(let error) = result else {
                XCTFail("testIncorrectData FAILED")
                return
            }
            expectation.fulfill()
            XCTAssertEqual(error, NetworkError.dataUndecodable)
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testCorrectData() {
        let session = FakeUrlSession(fakeData: CurrenciesFakeResponseData.correctData, fakeResponse: CurrenciesFakeResponseData.goodResponse, fakeError: nil)
        let request = HTTPRequest(session: session)
        let client = HTTPClient(httpRequest: request)
        let currencies = CurrenciesService(httpClient: client)
        let expectation = XCTestExpectation(description: "Wait For Queu Change")
        
        currencies.getCurrencies { (result) in
            guard case .success(let data) = result else {
                XCTFail("testCorrectData FAILED")
                return
            }
            expectation.fulfill()
            XCTAssertNotNil(data)
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testConvertOneEurosInEuros() {
        let currencies = CurrenciesService()
        let amount = "1"
        let rateOne = 1.00
        let rateTow = 1.00
        
        let result = currencies.convertCurrencies(from: rateOne, to: rateTow, amount: amount)
        
        XCTAssertEqual(result, "1.00")
    }
}

//
//  TranslateTest.swift
//  UltimateTravellerToolTests
//
//  Created by mickael ruzel on 08/08/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import XCTest
@testable import UltimateTravellerTool

class TranslateTest: XCTestCase {

    let expectation = XCTestExpectation(description: "Wait for queue")
    
    func createClient(with session: FakeUrlSession) -> GoogleTranslateService {
        let request = HTTPRequest(session: session)
        let client = HTTPClient(httpRequest: request)
        let api = GoogleTranslateService(client: client)
        return api
    }
    
    func testBadResponse() {
        let session = FakeUrlSession(fakeData: nil, fakeResponse: TranslateApiFakeResponse.badResponse, fakeError: nil)
        let api = createClient(with: session)
        
        api.translateText(parameters: nil) { (result) in
            guard case .failure(let error) = result else {
                XCTFail()
                return
            }
            self.expectation.fulfill()
            XCTAssertEqual(error, NetworkError.badResponse)
        }
        wait(for: [expectation], timeout: 0.01)
        
    }
    
    func testGoodResponseWithError() {
        let session = FakeUrlSession(fakeData: nil, fakeResponse: TranslateApiFakeResponse.goodResponse, fakeError: TranslateApiFakeResponse.fakeError)
        let api = createClient(with: session)
        
        api.translateText(parameters: nil) { (result) in
            guard case .failure(let error) = result else {
                XCTFail()
                return
            }
            self.expectation.fulfill()
            XCTAssertNotNil(error)
        }
        
        wait(for: [expectation], timeout: 0.01)
    }

    func testGoodResponseNoData() {
        let session = FakeUrlSession(fakeData: nil, fakeResponse: TranslateApiFakeResponse.goodResponse, fakeError: nil)
        let api = createClient(with: session)
        
        api.translateText(parameters: nil) { (result) in
            guard case .failure(let error) = result else {
                XCTFail()
                return
            }
            self.expectation.fulfill()
            XCTAssertEqual(error, NetworkError.noData)
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGoodResponseIncorrectData() {
        let session = FakeUrlSession(fakeData: TranslateApiFakeResponse.incorrectData, fakeResponse: TranslateApiFakeResponse.goodResponse, fakeError: nil)
        let api = createClient(with: session)
        
        api.translateText(parameters: nil) { (result) in
            guard case .failure(let error) = result else {
                XCTFail()
                return
            }
            self.expectation.fulfill()
            XCTAssertEqual(error, NetworkError.dataUndecodable)
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGoodResponseCorrectData() {
        let session = FakeUrlSession(fakeData: TranslateApiFakeResponse.correctData, fakeResponse: TranslateApiFakeResponse.goodResponse, fakeError: nil)
        let api = createClient(with: session)
        
        api.translateText(parameters: nil) { (result) in
            guard case .success(let data) = result else {
                if case .failure(let error) = result {
                    XCTFail(error.description)
                }
                return
            }
            self.expectation.fulfill()
            XCTAssertNotNil(data)
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
}

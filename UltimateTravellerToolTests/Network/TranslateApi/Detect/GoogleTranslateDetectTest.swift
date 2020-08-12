//
//  GoogleTranslateDetectTest.swift
//  UltimateTravellerToolTests
//
//  Created by mickael ruzel on 12/08/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import XCTest
@testable import UltimateTravellerTool

class GoogleTranslateDetectTest: XCTestCase {
    
    typealias FakeReponse = GoogleDetectFakeResponse
    
    let expectation = XCTestExpectation(description: "wait for queue")
    
    func createClient(_ session: FakeUrlSession) -> GoogleTranslateService {
        let request = HTTPRequest(session: session)
        let client = HTTPClient(httpRequest: request)
        let api = GoogleTranslateService(client: client)
        return api
    }
    
    func testBadReponse() {
        let session = FakeUrlSession(fakeData: nil, fakeResponse: FakeReponse.badResponse, fakeError: nil)
        let api = createClient(session)
        api.detectLanguage(query: []) { (result) in
            guard case .failure(let error) = result else {
                XCTFail()
                return
            }
            self.expectation.fulfill()
            XCTAssertEqual(error, NetworkError.badResponse)
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGoodReponseWithError() {
        let session = FakeUrlSession(fakeData: nil, fakeResponse: FakeReponse.goodResponse, fakeError: FakeReponse.fakeError)
        let api = createClient(session)
        api.detectLanguage(query: []) { (result) in
            guard case .failure(let error) = result else {
                XCTFail()
                return
            }
            self.expectation.fulfill()
            XCTAssertNotNil(error)
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testNoData() {
        let session = FakeUrlSession(fakeData: nil, fakeResponse: FakeReponse.goodResponse, fakeError: nil)
        let api = createClient(session)
        api.detectLanguage(query: []) { (result) in
            guard case .failure(let error) = result else {
                XCTFail()
                return
            }
            self.expectation.fulfill()
            XCTAssertEqual(error, NetworkError.noData)
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testIncorrectData() {
        let session = FakeUrlSession(fakeData: FakeReponse.incorrectData, fakeResponse: FakeReponse.goodResponse, fakeError: nil)
        let api = createClient(session)
        api.detectLanguage(query: []) { (result) in
            guard case .failure(let error) = result else {
                XCTFail()
                return
            }
            self.expectation.fulfill()
            XCTAssertEqual(error, NetworkError.dataUndecodable)
        }
        
        wait(for: [expectation], timeout: 0.01)
    }

    func testGoodData() {
        let session = FakeUrlSession(fakeData: FakeReponse.correctData, fakeResponse: FakeReponse.goodResponse, fakeError: nil)
        let api = createClient(session)
        api.detectLanguage(query: []) { (result) in
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

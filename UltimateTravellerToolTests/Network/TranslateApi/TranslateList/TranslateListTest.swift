//
//  TranslateListTest.swift
//  UltimateTravellerToolTests
//
//  Created by mickael ruzel on 08/08/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import XCTest
@testable import UltimateTravellerTool

class TranslateListTest: XCTestCase {
    
    let expectation = XCTestExpectation(description: "Wait for queue")
    
    func createClient(with session: FakeUrlSession) -> GoogleTranslateService {
        let request = HTTPRequest(session: session)
        let client = HTTPClient(httpRequest: request)
        let api = GoogleTranslateService(client: client)
        return api
    }
    
    func testNoConnection() {
        let session = FakeUrlSession(fakeData: nil, fakeResponse: nil, fakeError: nil)
        let api = createClient(with: session)
        
        api.getLinguageList { (result) in
            guard case .failure(let error) = result else {
                XCTFail()
                return
            }
            self.expectation.fulfill()
            XCTAssertEqual(error, NetworkError.noConnection)
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testBadResponse() {
        let session = FakeUrlSession(fakeData: nil, fakeResponse: TranslateListApiFakeResponse.badResponse, fakeError: nil)
        let api = createClient(with: session)
        api.getLinguageList { (result) in
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
        let session = FakeUrlSession(fakeData: nil, fakeResponse: TranslateListApiFakeResponse.goodResponse, fakeError: TranslateListApiFakeResponse.fakeError)
        let api = createClient(with: session)
        
        api.getLinguageList { (result) in
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
        let session = FakeUrlSession(fakeData: nil, fakeResponse: TranslateListApiFakeResponse.goodResponse, fakeError: nil)
        let api = createClient(with: session)
        
        api.getLinguageList { (result) in
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
        let session = FakeUrlSession(fakeData: TranslateListApiFakeResponse.incorrectData, fakeResponse: TranslateListApiFakeResponse.goodResponse, fakeError: nil)
        let api = createClient(with: session)
        
        api.getLinguageList { (result) in
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
        let session = FakeUrlSession(fakeData: TranslateListApiFakeResponse.correctData, fakeResponse: TranslateListApiFakeResponse.goodResponse, fakeError: nil)
        let api = createClient(with: session)
        
        api.getLinguageList { (result) in
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

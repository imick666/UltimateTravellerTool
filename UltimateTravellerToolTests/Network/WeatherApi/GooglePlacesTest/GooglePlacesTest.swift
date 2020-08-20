//
//  GooglePlacesTest.swift
//  UltimateTravellerToolTests
//
//  Created by mickael ruzel on 30/07/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import XCTest
@testable import UltimateTravellerTool

class GooglePlacesTest: XCTestCase {
    let expectation = XCTestExpectation(description: "wait for queue")
    
    func createGooglePlace(session: FakeUrlSession) -> GooglePlacesService {
        let request = HTTPRequest(session: session)
        let client = HTTPClient(httpRequest: request)
        let place = GooglePlacesService(client: client)
        return place
    }

    func testNoResponse() {
        let session = FakeUrlSession(fakeData: nil, fakeResponse: nil, fakeError: nil)
        let places = createGooglePlace(session: session)
        
        places.getCitiesName(q: "") { (result) in
            guard case .failure(let error) = result else {
                XCTFail()
                return
            }
            self.expectation.fulfill()
            XCTAssertEqual(error, NetworkError.noConnection)
        }
    }
    
    func testBadResponse() {
        let session = FakeUrlSession(fakeData: nil, fakeResponse: GooglePlacesFakeResponse.badResponse, fakeError: nil)
        let places = createGooglePlace(session: session)
        
        places.getCitiesName(q: "") { (result) in
            guard case .failure(let error) = result else {
                XCTFail()
                return
            }
            self.expectation.fulfill()
            XCTAssertEqual(error, NetworkError.badResponse)
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func tesGoodResponseWithError() {
        let session = FakeUrlSession(fakeData: nil, fakeResponse: GooglePlacesFakeResponse.goodResponse, fakeError: GooglePlacesFakeResponse.fakeError)
        let places = createGooglePlace(session: session)
        
        places.getCitiesName(q: "") { (result) in
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
        let session = FakeUrlSession(fakeData: nil, fakeResponse: GooglePlacesFakeResponse.goodResponse, fakeError: nil)
        let places = createGooglePlace(session: session)
        
        places.getCitiesName(q: "") { (result) in
            guard case .failure(let error) = result else {
                XCTFail()
                return
            }
            self.expectation.fulfill()
            XCTAssertEqual(error, NetworkError.noData)
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testDataIncorrect() {
        let session = FakeUrlSession(fakeData: GooglePlacesFakeResponse.incorrectData, fakeResponse: GooglePlacesFakeResponse.goodResponse, fakeError: nil)
        let places = createGooglePlace(session: session)
        
        places.getCitiesName(q: "") { (result) in
            guard case .failure(let error) = result else {
                XCTFail()
                return
            }
            self.expectation.fulfill()
            XCTAssertEqual(error, NetworkError.dataUndecodable)
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testDataCorrect() {
        let session = FakeUrlSession(fakeData: GooglePlacesFakeResponse.correctData, fakeResponse: GooglePlacesFakeResponse.goodResponse, fakeError: nil)
        let places = createGooglePlace(session: session)
        
        places.getCitiesName(q: "") { (result) in
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

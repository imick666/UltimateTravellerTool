//
//  CurrentWeatherTest.swift
//  UltimateTravellerToolTests
//
//  Created by mickael ruzel on 22/07/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import XCTest
@testable import UltimateTravellerTool

class CurrentWeatherTest: XCTestCase {

    private func createWeatherService(session: FakeUrlSession) -> CurrentWeatherService {
        let request = HTTPRequest(session: session)
        let client = HTTPClient(httpRequest: request)
        let currentWeather = CurrentWeatherService(client: client)
        return currentWeather
    }
    
    func testBadUrlResponse() {
        let expectation = XCTestExpectation(description: "wait for queue")
        let session = FakeUrlSession(fakeData: nil, fakeResponse: CurrentWeatherFakeResponse.badUrlResponse, fakeError: nil)
        let currentWeather = createWeatherService(session: session)
        
        currentWeather.getCurrentWeather(parameters: [("lat", "3.10"), ("lon", "-100")]) { (result) in
            guard case .failure(let error) = result else {
                XCTFail("testBadUrlResponseFailed")
                return
            }
            expectation.fulfill()
            XCTAssertEqual(error, NetworkError.badResponse)
        }
        
        wait(for: [expectation], timeout: 0.01)
    }

    func testGoodUrlResponseWithError() {
        let expectation = XCTestExpectation(description: "wait for queue")
        let session = FakeUrlSession(fakeData: nil, fakeResponse: CurrentWeatherFakeResponse.goodUrlResponse, fakeError: CurrentWeatherFakeResponse.fakeError)
        let currentWeather = createWeatherService(session: session)
        
        currentWeather.getCurrentWeather(parameters: [("lon", "3.10"), ("lat", "-100")]) { (result) in
            guard case .failure(let error) = result else {
                XCTFail("testGoodUrlResponseWithError Failed")
                return
            }
            expectation.fulfill()
            XCTAssertNotNil(error)
        }
        
        wait(for: [expectation], timeout: 0.01)
        
    }
    
    func testNoData() {
        let expactation = XCTestExpectation(description: "wait for queue")
        let session = FakeUrlSession(fakeData: nil, fakeResponse: CurrentWeatherFakeResponse.goodUrlResponse, fakeError: nil)
        let currentWeather = createWeatherService(session: session)
        
        currentWeather.getCurrentWeather(parameters: []) { (result) in
            guard case .failure(let error) = result else {
                XCTFail()
                return
            }
            expactation.fulfill()
            XCTAssertEqual(error, NetworkError.noData)
        }
        
        wait(for: [expactation], timeout: 0.01)
    }
    
    func testIncorrectData() {
        let expectation = XCTestExpectation(description: "wait for queue")
        let session = FakeUrlSession(fakeData: CurrentWeatherFakeResponse.incorrectData, fakeResponse: CurrentWeatherFakeResponse.goodUrlResponse, fakeError: nil)
        let currentWeather = createWeatherService(session: session)
        
        currentWeather.getCurrentWeather(parameters: []) { (result) in
            guard case .failure(let error) = result else {
                XCTFail()
                return
            }
            expectation.fulfill()
            XCTAssertEqual(error, NetworkError.dataUndecodable)
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testCorrectData() {
        let expectation = XCTestExpectation(description: "wait for queu")
        let session = FakeUrlSession(fakeData: CurrentWeatherFakeResponse.correctData, fakeResponse: CurrentWeatherFakeResponse.goodUrlResponse, fakeError: nil)
        let currentWeather = createWeatherService(session: session)
        
        currentWeather.getCurrentWeather(parameters: []) { (result) in
            guard case .success(let data) = result else {
                XCTFail()
                return
            }
            expectation.fulfill()
            XCTAssertNotNil(data)
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
}

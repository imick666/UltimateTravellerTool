//
//  ForecastWeatherTest.swift
//  UltimateTravellerToolTests
//
//  Created by mickael ruzel on 22/07/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import XCTest
@testable import UltimateTravellerTool

class ForecastWeatherTest: XCTestCase {
    
    let expectation = XCTestExpectation(description: "Wait for queue")
    
    private func createClient(session: FakeUrlSession) -> WeatherService {
        let request = HTTPRequest(session: session)
        let client = HTTPClient(httpRequest: request)
        let forecastWeather = WeatherService(client: client)
        
        return forecastWeather
    }

    func testBadReponse() {
        let session = FakeUrlSession(fakeData: nil, fakeResponse: ForecastWeatherFakeResponse.badResponse, fakeError: nil)
        let forecastWeather = createClient(session: session)

        forecastWeather.getForecastWeather(parameters: []) { (result) in
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
        let session = FakeUrlSession(fakeData: nil, fakeResponse: ForecastWeatherFakeResponse.goodResponse, fakeError: ForecastWeatherFakeResponse.fakeError)
        let forecastWeather = createClient(session: session)
        
        forecastWeather.getForecastWeather(parameters: []) { (result) in
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
        let session = FakeUrlSession(fakeData: nil, fakeResponse: ForecastWeatherFakeResponse.goodResponse, fakeError: nil)
        let forecastWeather = createClient(session: session)
        
        forecastWeather.getForecastWeather(parameters: []) { (result) in
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
        let session = FakeUrlSession(fakeData: ForecastWeatherFakeResponse.incorrectData, fakeResponse: ForecastWeatherFakeResponse.goodResponse, fakeError: nil)
        let forecastWeather = createClient(session: session)
        
        forecastWeather.getForecastWeather(parameters: []) { (result) in
            guard case .failure(let error) = result else {
                XCTFail()
                return
            }
            self.expectation.fulfill()
            XCTAssertEqual(error, NetworkError.dataUndecodable)
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testCorrectData() {
        let session = FakeUrlSession(fakeData: ForecastWeatherFakeResponse.correctData, fakeResponse: ForecastWeatherFakeResponse.goodResponse, fakeError: nil)
        let forecastWeather = createClient(session: session)
        
        forecastWeather.getForecastWeather(parameters: []) { (result) in
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

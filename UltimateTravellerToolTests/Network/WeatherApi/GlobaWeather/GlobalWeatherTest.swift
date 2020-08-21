//
//  GlobalWeatherTest.swift
//  UltimateTravellerToolTests
//
//  Created by mickael ruzel on 23/07/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import XCTest
@testable import UltimateTravellerTool

class GlobalWeatherTest: XCTestCase {
    
    let expactation = XCTestExpectation(description: "Wait for queue")
    
    // MARK: - SetUp
    
    func createCurrentClient(session: FakeUrlSession) -> CurrentWeatherService {
        let request = HTTPRequest(session: session)
        let client = HTTPClient(httpRequest: request)
        let currentWeather = CurrentWeatherService(client: client)
        return currentWeather
    }
    
    func createForecastClient(session: FakeUrlSession) -> WeatherService{
        let request = HTTPRequest(session: session)
        let client = HTTPClient(httpRequest: request)
        let forecastWeather = WeatherService(client: client)
        return forecastWeather
    }
    
    func createGlobalClient(currentSession: CurrentWeatherService, forecastSession: WeatherService) -> GlobalWeatherService {
        let globalWeather = GlobalWeatherService(currentWeather: currentSession, forecastWeather: forecastSession)
        return globalWeather
    }
    
    func createGlobalClientForIcon(globalSession: FakeUrlSession) -> GlobalWeatherService {
        let request = HTTPRequest(session: globalSession)
        let client = HTTPClient(httpRequest: request)
        let globalWeather = GlobalWeatherService(client: client)
        return globalWeather
    }
    
    // MARK: - Tests || Current Weather Error
    
    func testCurrentWeatherNoConnection() {
        let currentSession = FakeUrlSession(fakeData: nil, fakeResponse: nil, fakeError: nil)
        let forecastSession = FakeUrlSession(fakeData: nil, fakeResponse: nil, fakeError: nil)
        let currentWeather = createCurrentClient(session: currentSession)
        let forecastWeather = createForecastClient(session: forecastSession)
        let globalWeather = createGlobalClient(currentSession: currentWeather, forecastSession: forecastWeather)
        
        globalWeather.getGlobalWeather(parameters: []) { (result) in
            guard case .failure(let error) = result else {
                XCTFail()
                return
            }
            self.expactation.fulfill()
            XCTAssertEqual(error, NetworkError.noConnection)
        }
        
        wait(for: [expactation], timeout: 0.01)
    }
    
    func testCurrentWeatherBadResponse() {
        let currentSession = FakeUrlSession(fakeData: nil, fakeResponse: CurrentWeatherFakeResponse.badUrlResponse, fakeError: nil)
        let forecastSession = FakeUrlSession(fakeData: nil, fakeResponse: nil, fakeError: nil)
        let currentWeather = createCurrentClient(session: currentSession)
        let forecastWeather = createForecastClient(session: forecastSession)
        let globalWeather = createGlobalClient(currentSession: currentWeather, forecastSession: forecastWeather)
        
        globalWeather.getGlobalWeather(parameters: []) { (result) in
            guard case .failure(let error) = result else {
                XCTFail()
                return
            }
            self.expactation.fulfill()
            XCTAssertEqual(error, NetworkError.badResponse)
        }
        
        wait(for: [expactation], timeout: 0.01)
        
    }
    
    func testCurrentWeatherGoodResponseWithError() {
        let currentSession = FakeUrlSession(fakeData: nil, fakeResponse: CurrentWeatherFakeResponse.goodUrlResponse, fakeError: CurrentWeatherFakeResponse.fakeError)
        let forecastSession = FakeUrlSession(fakeData: nil, fakeResponse: nil, fakeError: nil)
        let currentWeather = createCurrentClient(session: currentSession)
        let forecastWeatehr = createForecastClient(session: forecastSession)
        let globalWeather = createGlobalClient(currentSession: currentWeather, forecastSession: forecastWeatehr)
        
        globalWeather.getGlobalWeather(parameters: []) { (result) in
            guard case .failure(let error) = result else {
                XCTFail()
                return
            }
            self.expactation.fulfill()
            XCTAssertNotNil(error)
            XCTAssertEqual(error, NetworkError.noData)
        }
        
        wait(for: [expactation], timeout: 0.01)
    }
    
    func testCurrentWeatherNoData() {
        let currentSession = FakeUrlSession(fakeData: nil, fakeResponse: CurrentWeatherFakeResponse.goodUrlResponse, fakeError: nil)
        let forecastSession = FakeUrlSession(fakeData: nil, fakeResponse: nil, fakeError: nil)
        let currentWeather = createCurrentClient(session: currentSession)
        let forecastWeatehr = createForecastClient(session: forecastSession)
        let globalWeather = createGlobalClient(currentSession: currentWeather, forecastSession: forecastWeatehr)
        
        globalWeather.getGlobalWeather(parameters: []) { (result) in
            guard case .failure(let error) = result else {
                XCTFail()
                return
            }
            self.expactation.fulfill()
            XCTAssertEqual(error, NetworkError.noData)
        }
        
        wait(for: [expactation], timeout: 0.01)
    }
    
    func testCurrentWeatherIncorrectData() {
        let currentSession = FakeUrlSession(fakeData: CurrentWeatherFakeResponse.incorrectData, fakeResponse: CurrentWeatherFakeResponse.goodUrlResponse, fakeError: nil)
        let forecastSession = FakeUrlSession(fakeData: nil, fakeResponse: nil, fakeError: nil)
        let currentWeather = createCurrentClient(session: currentSession)
        let forecastWeatehr = createForecastClient(session: forecastSession)
        let globalWeather = createGlobalClient(currentSession: currentWeather, forecastSession: forecastWeatehr)
        
        globalWeather.getGlobalWeather(parameters: []) { (result) in
            guard case .failure(let error) = result else {
                XCTFail()
                return
            }
            self.expactation.fulfill()
            XCTAssertEqual(error, NetworkError.dataUndecodable)
        }
        
        wait(for: [expactation], timeout: 0.01)
    }
    
    // MARK: - Test || Forecast Weather Error || Current All Good
    
    func testForecastWeatherNoConnection() {
        let currentSession = FakeUrlSession(fakeData: CurrentWeatherFakeResponse.correctData, fakeResponse: CurrentWeatherFakeResponse.goodUrlResponse, fakeError: nil)
        let forecastSession = FakeUrlSession(fakeData: nil, fakeResponse: nil, fakeError: nil)
        let currentWeather = createCurrentClient(session: currentSession)
        let forecastWeatehr = createForecastClient(session: forecastSession)
        let globalWeather = createGlobalClient(currentSession: currentWeather, forecastSession: forecastWeatehr)
        
        globalWeather.getGlobalWeather(parameters: []) { (result) in
            guard case .failure(let error) = result else {
                XCTFail()
                return
            }
            self.expactation.fulfill()
            XCTAssertEqual(error, NetworkError.noConnection)
        }
        
        wait(for: [expactation], timeout: 0.01)
    }
    
    func testForecastWeatherBadResponse() {
        let currentSession = FakeUrlSession(fakeData: CurrentWeatherFakeResponse.correctData, fakeResponse: CurrentWeatherFakeResponse.goodUrlResponse, fakeError: nil)
        let forecastSession = FakeUrlSession(fakeData: nil, fakeResponse: ForecastWeatherFakeResponse.badResponse, fakeError: nil)
        let currentWeather = createCurrentClient(session: currentSession)
        let forecastWeather = createForecastClient(session: forecastSession)
        let globalWeather = createGlobalClient(currentSession: currentWeather, forecastSession: forecastWeather)
        
        globalWeather.getGlobalWeather(parameters: []) { (result) in
            guard case .failure(let error) = result else {
                XCTFail()
                return
            }
            self.expactation.fulfill()
            XCTAssertEqual(error, NetworkError.badResponse)
        }
        
        wait(for: [expactation], timeout: 0.01)
        
    }
    
    func testForecastWeatherGoodResponseWithError() {
        let currentSession = FakeUrlSession(fakeData: CurrentWeatherFakeResponse.correctData, fakeResponse: CurrentWeatherFakeResponse.goodUrlResponse, fakeError: nil)
        let forecastSession = FakeUrlSession(fakeData: nil, fakeResponse: ForecastWeatherFakeResponse.goodResponse, fakeError: ForecastWeatherFakeResponse.fakeError)
        let currentWeather = createCurrentClient(session: currentSession)
        let forecastWeatehr = createForecastClient(session: forecastSession)
        let globalWeather = createGlobalClient(currentSession: currentWeather, forecastSession: forecastWeatehr)
        
        globalWeather.getGlobalWeather(parameters: []) { (result) in
            guard case .failure(let error) = result else {
                XCTFail()
                return
            }
            self.expactation.fulfill()
            XCTAssertNotNil(error)
            XCTAssertEqual(error, NetworkError.noData)
        }
        
        wait(for: [expactation], timeout: 0.01)
    }
    
    func testForecastWeatherNoData() {
        let currentSession = FakeUrlSession(fakeData: CurrentWeatherFakeResponse.correctData, fakeResponse: CurrentWeatherFakeResponse.goodUrlResponse, fakeError: nil)
        let forecastSession = FakeUrlSession(fakeData: nil, fakeResponse: ForecastWeatherFakeResponse.goodResponse, fakeError: nil)
        let currentWeather = createCurrentClient(session: currentSession)
        let forecastWeatehr = createForecastClient(session: forecastSession)
        let globalWeather = createGlobalClient(currentSession: currentWeather, forecastSession: forecastWeatehr)
        
        globalWeather.getGlobalWeather(parameters: []) { (result) in
            guard case .failure(let error) = result else {
                XCTFail()
                return
            }
            self.expactation.fulfill()
            XCTAssertEqual(error, NetworkError.noData)
        }
        
        wait(for: [expactation], timeout: 0.01)
    }
    
    func testForecastWeatherIncorrectData() {
        let currentSession = FakeUrlSession(fakeData: CurrentWeatherFakeResponse.correctData, fakeResponse: CurrentWeatherFakeResponse.goodUrlResponse, fakeError: nil)
        let forecastSession = FakeUrlSession(fakeData: ForecastWeatherFakeResponse.incorrectData, fakeResponse: ForecastWeatherFakeResponse.goodResponse, fakeError: nil)
        let currentWeather = createCurrentClient(session: currentSession)
        let forecastWeatehr = createForecastClient(session: forecastSession)
        let globalWeather = createGlobalClient(currentSession: currentWeather, forecastSession: forecastWeatehr)
        
        globalWeather.getGlobalWeather(parameters: []) { (result) in
            guard case .failure(let error) = result else {
                XCTFail()
                return
            }
            self.expactation.fulfill()
            XCTAssertEqual(error, NetworkError.dataUndecodable)
        }
        
        wait(for: [expactation], timeout: 0.01)
    }
    
    // MARK: - Test || All Is Good
    
    func testAllIsGood() {
        let currentSession = FakeUrlSession(fakeData: CurrentWeatherFakeResponse.correctData, fakeResponse: CurrentWeatherFakeResponse.goodUrlResponse, fakeError: nil)
        let forecastSession = FakeUrlSession(fakeData: ForecastWeatherFakeResponse.correctData, fakeResponse: ForecastWeatherFakeResponse.goodResponse, fakeError: nil)
        let currentWeather = createCurrentClient(session: currentSession)
        let forecastWeatehr = createForecastClient(session: forecastSession)
        let globalWeather = createGlobalClient(currentSession: currentWeather, forecastSession: forecastWeatehr)
        
        globalWeather.getGlobalWeather(parameters: []) { (result) in
            guard case .success(let data) = result else {
                XCTFail()
                return
            }
            self.expactation.fulfill()
            XCTAssertNotNil(data)
        }
        
        wait(for: [expactation], timeout: 0.01)
    }
    
    // MARK: - Get Icon Test
    
    func testGetIconNoResponse() {
        let session = FakeUrlSession(fakeData: nil, fakeResponse: nil, fakeError: nil)
        let globalWeather = createGlobalClientForIcon(globalSession: session)
        
        globalWeather.getIcon(id: "") { (result) in
            guard case .failure(let error) = result else {
                XCTFail()
                return
            }
            self.expactation.fulfill()
            XCTAssertEqual(error, NetworkError.noConnection)
        }
        
        wait(for: [expactation], timeout: 0.01)
    }
    
    func testGetIconBadResponse() {
        let session = FakeUrlSession(fakeData: nil, fakeResponse: GlobalWeatherFakeResponse.basResponse, fakeError: nil)
        let globalWeather = createGlobalClientForIcon(globalSession: session)
        
        globalWeather.getIcon(id: "") { (result) in
            guard case .failure(let error) = result else {
                XCTFail()
                return
            }
            self.expactation.fulfill()
            XCTAssertEqual(error, NetworkError.badResponse)
        }
        
        wait(for: [expactation], timeout: 0.01)
    }
    
    func testGetIconGoodResponseWithError() {
        let session = FakeUrlSession(fakeData: nil, fakeResponse: GlobalWeatherFakeResponse.goodResponse, fakeError: GlobalWeatherFakeResponse.fakError)
        let globalWeather = createGlobalClientForIcon(globalSession: session)
        
        globalWeather.getIcon(id: "") { (result) in
            guard case .failure(let error) = result else {
                XCTFail()
                return
            }
            self.expactation.fulfill()
            XCTAssertNotNil(error)
        }
        
        wait(for: [expactation], timeout: 0.01)
    }
    
    func testGetIconNoData() {
        let session = FakeUrlSession(fakeData: nil, fakeResponse: GlobalWeatherFakeResponse.goodResponse, fakeError: nil)
        let globalWeather = createGlobalClientForIcon(globalSession: session)
        
        globalWeather.getIcon(id: "") { (result) in
            guard case .failure(let error) = result else {
                XCTFail()
                return
            }
            self.expactation.fulfill()
            XCTAssertEqual(error, NetworkError.noData)
        }
        
        wait(for: [expactation], timeout: 0.01)
    }
    
    func testGetIconIncorrectData() {
        let session = FakeUrlSession(fakeData: GlobalWeatherFakeResponse.incorrectData, fakeResponse: GlobalWeatherFakeResponse.goodResponse, fakeError: nil)
        let globalWeather = createGlobalClientForIcon(globalSession: session)
        
        globalWeather.getIcon(id: "") { (result) in
            guard case .success(let data) = result else {
                XCTFail()
                return
            }
            self.expactation.fulfill()
            XCTAssertNil(UIImage(data: data))
        }
        
        wait(for: [expactation], timeout: 0.01)
    }
    
    func testGetIconCorrectData() {
        let session = FakeUrlSession(fakeData: GlobalWeatherFakeResponse.correctData, fakeResponse: GlobalWeatherFakeResponse.goodResponse, fakeError: nil)
        let globalWeather = createGlobalClientForIcon(globalSession: session)
        
        globalWeather.getIcon(id: "") { (result) in
            guard case .success(let data) = result else {
                XCTFail()
                return
            }
            self.expactation.fulfill()
            XCTAssertNotNil(UIImage(data: data))
        }
        
        wait(for: [expactation], timeout: 0.01)
    }
}


    

//
//  FakeUrlSession.swift
//  UltimateTravellerToolTests
//
//  Created by mickael ruzel on 29/06/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import Foundation

class FakeUrlSession: URLSession {
    
    private var fakeData: Data?
    private var fakeResponse: URLResponse?
    private var fakeError: Error?
    
    init(fakeData: Data?, fakeResponse: URLResponse?, fakeError: Error?) {
        self.fakeData = fakeData
        self.fakeResponse = fakeResponse
        self.fakeError = fakeError
    }
    
    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let task = FakeURLSessionDataTask(fakeData: fakeData, fakeResponse: fakeResponse, fakeError: fakeError, completionHandler: completionHandler)
        return task
    }
}

class FakeURLSessionDataTask: URLSessionDataTask {
    var completionHandler: ((Data?, URLResponse?, Error?) -> Void)?
    
    var fakeData: Data?
    var fakeResponse: URLResponse?
    var fakeError: Error?
    
    init(fakeData: Data?, fakeResponse: URLResponse?, fakeError: Error?, completionHandler: ((Data?, URLResponse?, Error?) -> Void)?) {
        self.fakeData = fakeData
        self.fakeResponse = fakeResponse
        self.fakeError = fakeError
        self.completionHandler = completionHandler
    }
    
    override func resume() {
        completionHandler?(fakeData, fakeResponse, fakeError)
    }
    
    override func cancel() { }
}

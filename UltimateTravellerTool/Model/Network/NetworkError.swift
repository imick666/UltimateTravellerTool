//
//  NetworkError.swift
//  UltimateTravellerTool
//
//  Created by mickael ruzel on 29/06/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import Foundation

enum NetworkError: Error, CustomStringConvertible {
    case noData, badResponse, dataUndecodable, badUrl, noConnection
    
    var description: String {
        switch self {
        case .badResponse:
            return "Response is incorrect"
        case .noData:
            return "No data"
        case .dataUndecodable:
            return "Data undecodable"
        case .badUrl:
            return "bad URL"
        case .noConnection:
            return "No Connection"
        }
    }
}

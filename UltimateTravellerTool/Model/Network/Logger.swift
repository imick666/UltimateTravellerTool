//
//  Logger.swift
//  UltimateTravellerTool
//
//  Created by mickael ruzel on 02/07/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import Foundation

struct Logger {
    
    // MARK : - Properties
    
    var url: URL
    private var request : URLRequest {
        return URLRequest(url: url)
    }
    
    // MARK : - Methodes
    
    func show() {
        defer {
            print("\n *****************     End     ****************** \n")
        }
        
        guard let httpMethod = request.httpMethod else { return }
        guard let stringUrl = request.url?.absoluteString else { return }
        guard let urlComponent = NSURLComponents(string: stringUrl) else { return }
        guard let host = urlComponent.host else { return }
        guard let path = urlComponent.path else { return }
        let querry = urlComponent.query ?? String()
        
        let logOutput = """
        ** HTTP Method : \(httpMethod)
        ** URL : \(stringUrl)
        ** Host : \(host)
        ** path : \(path)
        ** Querry : \(querry)
        """
        
        print("\n ***************** Request info ***************** \n")
        print(logOutput)
        
    }
}

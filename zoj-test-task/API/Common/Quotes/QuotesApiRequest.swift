//
//  QuotesApiRequest.swift
//  zoj-test-task
//
//  Created by didarkam on 10/2/19.
//  Copyright © 2019 testteam. All rights reserved.
//

import Foundation

struct QuotesApiRequest: ApiRequest {
    
    let root = "https://opinionated-quotes-api.gigalixirapp.com/v1"
    let path: String
    let query: [String:CustomStringConvertible]
    let method: HTTPMethod
    let contentType: HTTPRequestContentType
    var body: Data?
    
    init(path: String, query: [String:CustomStringConvertible] = [:], method: HTTPMethod = .GET) {
        self.path = path
        self.query = query
        self.method = method
        self.contentType = .text
        self.body = nil
    }
}

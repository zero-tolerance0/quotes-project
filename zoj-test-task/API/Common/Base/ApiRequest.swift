//
//  ApiRequest.swift
//  zoj-test-task
//
//  Created by didarkam on 10/2/19.
//  Copyright © 2019 testteam. All rights reserved.
//

import Foundation

enum HTTPMethod : String {
    case GET = "GET"
}

enum HTTPRequestContentType: CustomStringConvertible {
    case text
    case json
    case formUrlEncoded
    
    var description: String {
        switch self {
        case .text: return ""
        case .json: return "application/json"
        case .formUrlEncoded: return "application/x-www-form-urlencoded"
        }
    }
}

protocol ApiRequest {
    var root: String { get }
    var query: [String:CustomStringConvertible] { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var contentType: HTTPRequestContentType { get }
    var body: Data? { get }
}

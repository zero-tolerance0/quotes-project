//
//  Quote.swift
//  zoj-test-task
//
//  Created by didarkam on 10/2/19.
//  Copyright © 2019 testteam. All rights reserved.
//

import Foundation

public struct Quote: Codable {
    let tags: [String]?
    let lang: String?
    let author: String?
    let quote: String?
}

struct MyResponse: Codable {
    let quotes: [Quote]
}

//
//  QuotesApi.swift
//  zoj-test-task
//
//  Created by didarkam on 10/3/19.
//  Copyright © 2019 testteam. All rights reserved.
//

import Foundation
import RxSwift

public protocol QuotesListApi {
    
    func getQuotes() -> Observable<Result<[Quote], Error>>
}

final class MyQuotesListApi: QuotesListApi {
    
    private let apiClient: ApiClient
    
    init(apiClient: ApiClient) {
        self.apiClient = apiClient
    }
    
    func getQuotes() -> Observable<Result<[Quote], Error>> {
        let quotesApiRequest = QuotesApiRequest(path: "/quotes", query: ["rand":"t","n":"10"], method: .GET)
        return apiClient.requestJSON(quotesApiRequest)
    }
}

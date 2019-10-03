//
//  ApiClient1.swift
//  zoj-test-task
//
//  Created by didarkam on 10/2/19.
//  Copyright © 2019 testteam. All rights reserved.
//
import Foundation
import RxSwift

protocol ApiClient {
    func requestJSON(_ apiRequest: ApiRequest) -> Observable<Result<[Quote], Error>>
}

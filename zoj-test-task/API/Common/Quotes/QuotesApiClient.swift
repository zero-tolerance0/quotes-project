//
//  ApiClient.swift
//  zoj-test-task
//
//  Created by didarkam on 10/2/19.
//  Copyright © 2019 testteam. All rights reserved.
//
import Foundation
import RxSwift

final class QuotesApiClient: ApiClient {
    
    private let headers: [String:String]
    private let urlSession: URLSession
    
    init () {
        self.headers = [:]
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.httpCookieAcceptPolicy = .never
        sessionConfig.httpShouldSetCookies = false
        self.urlSession = URLSession(configuration: sessionConfig)
    }
    
    func requestJSON(_ apiRequest: ApiRequest) -> Observable<Result<[Quote], Error>>{
        let request = makeURLRequest(apiRequest)
        return Observable.create({ (observer) -> Disposable in
            let task: URLSessionTask
            task = self.urlSession.dataTask(with: request) { (data, response, error) in
                
                if let error = error {
                    observer.onError(error)
                    return
                }
                
                guard let data = data else {return}
                
                do {
                    let decoder = JSONDecoder()
                    let authRsp = try decoder.decode(MyResponse.self, from: data)
                    observer.onNext(.success(authRsp.quotes))
                    observer.onCompleted()
                } catch let jsonError {
                    print(jsonError.localizedDescription)
                    observer.onError(jsonError)
                    return
                }
                }
                task.resume()
            return Disposables.create {
                task.cancel()
            }
        })
    }
    
    private func makeURLRequest(_ apiRequest: ApiRequest) -> URLRequest {
        
        var urlComponents = URLComponents(string: apiRequest.root + apiRequest.path)!
        urlComponents.queryItems = apiRequest.query.map { URLQueryItem(name: $0, value: "\($1)") }
        
        let url = urlComponents.url!
        
        var request = URLRequest(url: url)
        request.httpMethod = apiRequest.method.rawValue
        
        var headers: [String: String] = self.headers
        
        if apiRequest.contentType != .text {
            headers["Content-Type"] = String(describing: apiRequest.contentType)
        }
        
        headers.forEach { request.addValue($1, forHTTPHeaderField: $0) }
        
        request.httpBody = apiRequest.body as Data?
        
        return request
    }
}

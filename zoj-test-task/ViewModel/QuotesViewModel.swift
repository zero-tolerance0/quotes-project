//
//  QuotesViewModel.swift
//  zoj-test-task
//
//  Created by didarkam on 10/3/19.
//  Copyright © 2019 testteam. All rights reserved.
//

import Foundation
import RxSwift

public protocol QuotesViewModeller {

    var quotes: Variable<[Quote]> { get }
    func refresh() -> Void
}

class QuotesViewModel: QuotesViewModeller {
    
    var quotes: Variable<[Quote]> = Variable([])
    let quotesListApi: QuotesListApi
    let disposeBag = DisposeBag()
    var timer: DispatchSourceTimer?

    init(quotesListApi: QuotesListApi) {
        self.quotesListApi = quotesListApi
        self.startTimer()
    }
    
    //MARK: --count 10 sec from now
    func refresh()-> Void {
        timer?.cancel()
        timer = nil
        startTimer()
    }
    
    private func startTimer() {
        let queue = DispatchQueue(label: "ru.testteam.timer", attributes: .concurrent)
        
        // cancel previous timer if any
        timer?.cancel()
        
        timer = DispatchSource.makeTimerSource(queue: queue)
        
        timer?.schedule(deadline: .now(), repeating: .seconds(10), leeway: .milliseconds(100))
        
        timer?.setEventHandler { [weak self] in
            print(Date())
            self?.getQuotes()
        }
        
        timer?.resume()
    }
    
    func getQuotes() -> Void{
        let quotesObservable = quotesListApi.getQuotes()
        quotesObservable.subscribe(onNext: { (result) in
            switch result {
            case .success(let quotes):
                self.quotes.value = quotes
            case .failure(let err):
                print("Failed to fetch quotes with err \(err.localizedDescription)")
            }
        }, onError: { (err) in
            print("Quotes request failed with error \(err.localizedDescription)")
        }, onCompleted: {
            print("Quotes request completed")
        }) {
            print("Quotes request disposed")
        }.disposed(by: disposeBag)
    }
}

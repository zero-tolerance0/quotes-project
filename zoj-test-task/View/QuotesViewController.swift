//
//  ViewController.swift
//  zoj-test-task
//
//  Created by didarkam on 10/2/19.
//  Copyright © 2019 testteam. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class QuotesViewController: UIViewController {
    
    var viewModel: QuotesViewModeller
    
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var quotesTableView: UITableView!
    var refreshControl: UIRefreshControl!
    
    convenience init() {
        self.init(nibName:nil, bundle:nil)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let apiClient = QuotesApiClient()
        let quotesListApi = MyQuotesListApi(apiClient: apiClient)
        self.viewModel = QuotesViewModel(quotesListApi: quotesListApi)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        let apiClient = QuotesApiClient()
        let quotesListApi = MyQuotesListApi(apiClient: apiClient)
        self.viewModel = QuotesViewModel(quotesListApi: quotesListApi)
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK: -- setup refresh control
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        quotesTableView.addSubview(refreshControl)
        
        bindViews()
    }
    
    func bindViews(){
        //MARK: -- bind refresh control
        refreshControl
            .rx.controlEvent(UIControlEvents.valueChanged)
            .subscribe(onNext: { [weak self] in
                //Put your hide activity code here
                self?.viewModel.refresh()
                self?.refreshControl.endRefreshing()
                }, onError: { (err) in
                    print("refresh control failed with err \(err)")
            }, onCompleted: {
                print("refresh control completed")
            }, onDisposed: {
                print("refresh control disposed")
            })
            .disposed(by: disposeBag)
        
        //MARK: -- bind table view
        viewModel.quotes.asObservable().bind(to: quotesTableView.rx.items(cellIdentifier: "quoteCell", cellType: QuoteCell.self)) { (index, quote, cell) in
            let author = quote.author ?? ""
            let quote = quote.quote ?? ""
            cell.quoteLabel.text = "\(author): \n\(quote)"
            }.disposed(by: disposeBag)
    }
}

//
//  ViewController.swift
//  GitSearch
//
//  Created by jc.kim on 2/26/21.
//

import RxCocoa
import RxSwift
import UIKit


class SearchListViewController: UIViewController {
    
    let viewModel = UserListViewModel()
    var disposeBag = DisposeBag()
    
    private var paging = 1
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.autocapitalizationType = .none
        tableView.dataSource = nil
        
        setupBindings()
    }
    
    // MARK: - UI Binding

    func setupBindings() {
        
        viewModel.userObservable
            .asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(cellIdentifier: UserListTableViewCell.reuseIdentifier, cellType: UserListTableViewCell.self)) { _, item, cell in
                cell.setData(item)
            }
            .disposed(by: disposeBag)
        
        
        searchBar.rx.text.orEmpty
            .map{($0, self.paging)}
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .asDriver(onErrorJustReturn: ("", 1))
            .drive(viewModel.searchBarObservable)
            .disposed(by: disposeBag)
        
        
        
        let usersCount = viewModel.userObservable.map{$0.count - 1}
        let prefetchRows = tableView.rx.prefetchRows.map{$0.last?.row ?? 0}
        
        Observable.combineLatest(usersCount, prefetchRows,
                                 resultSelector: { $0 == $1 })
            .filter{$0 == true}
            .do(onNext:{ _ in self.paging += 1})
            .observe(on: MainScheduler.instance)
            .map{_ in (self.searchBar.text ?? "", self.paging)}
            .observe(on: ConcurrentDispatchQueueScheduler(qos: .default))
            .bind(to: viewModel.searchBarObservable)
            .disposed(by: disposeBag)
        
        
        tableView.rx.modelSelected(User.self)
            .map{URL(string:"https://github.com/\($0.name)")}
            .do(onNext: viewModel.openURL)
            .subscribe()
            .disposed(by: disposeBag)
            
    }
    
    
    // MARK: - InterfaceBuilder Links
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
}


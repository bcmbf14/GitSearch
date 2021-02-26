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
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.autocapitalizationType = .none
        
        
        
        tableView.dataSource = nil
        //        tableView.delegate = nil
        
        viewModel.userObservable
            .asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(cellIdentifier: UserListTableViewCell.reuseIdentifier, cellType: UserListTableViewCell.self)) { index, item, cell in
                
//                item//menu
                
                cell.setData(item)
            }
            .disposed(by: disposeBag)
        
        
        searchBar.rx.text.orEmpty
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .asDriver(onErrorJustReturn: "")
            .drive(viewModel.searchBarObservable)
            .disposed(by: disposeBag)
       
        
        viewModel.userObservable
            .asDriver(onErrorJustReturn: [])
//            .debug()
            .map{$0.count > 0}
//            .startWith(false)
            .drive(emptyLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        
        
        let b = tableView.contentSize.height + tableView.frame.size.height + 100
        
        
        tableView.rx.contentOffset
            .map { $0.y - b }
//            .debug()
            .subscribe(onNext: { s in
                print(s)
            })
            
        
        
//        func scrollViewDidScroll(_ scrollView: UIScrollView) {
//          let height: CGFloat = scrollView.frame.size.height
        
        
//          let contentYOffset: CGFloat = scrollView.contentOffset.y
//          let scrollViewHeight: CGFloat = scrollView.contentSize.height
        
        
//          let distanceFromBottom: CGFloat = scrollViewHeight - contentYOffset
//
//          if distanceFromBottom < height {
//            self.addData()
//          }
//        }
       
            
        
//        let refreshControl = UIRefreshControl()
//
//        tableView.refreshControl = refreshControl
//
//        refreshControl.rx.controlEvent(.valueChanged)
//            .debug()
//            .disposed(by: disposeBag)
        
        
        
//        viewModel.userObservable
////            .asDriver(onErrorJustReturn: [])
//            .map { $0.count > 0 }
//            .observe(on: MainScheduler.instance)
//            .subscribe(onNext: { b in
//
//                self.tableView.refreshControl?.isHidden = b
//            })
        
        
            
            
//            .drive(tableView.refreshControl?.rx.isHidden)

        
        
    }
    
    
    
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        guard let id = segue.identifier,
    //              id == "DetailViewController",
    //              let detailVC = segue.destination as? DetailViewController,
    //              let data = sender as? Member else {
    //            return
    //        }
    //        detailVC.data = data
    //    }
}


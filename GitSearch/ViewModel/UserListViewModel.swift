//
//  UserListViewModel.swift
//  GitSearch
//
//  Created by jc.kim on 2/26/21.
//

import Foundation
import RxSwift
import RxRelay

class UserListViewModel {
    
    let userObservable = BehaviorRelay<[User]>(value: [])
    let searchBarObservable = BehaviorRelay(value: ("",1))
    
    private var totalUsers = [User]()
    
    var disposeBag = DisposeBag()
    
    init() {
        searchBarObservable
            .flatMap{APIService.requestUsersList($0, $1)}
            .map(appendUserList)
            .bind(to: userObservable)
            .disposed(by: disposeBag)
    }
    
    
    private func appendUserList(_ users: [User]) -> [User]{
        self.totalUsers.append(contentsOf: users)
        return totalUsers
    }
    
    func openURL(_ url:URL?) {
        guard let url = url else { return print("invalid URL")}
        UIApplication.shared.open(url, options: [:])
    }
    
}

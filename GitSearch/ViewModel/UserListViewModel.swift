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
    
    var userObservable = BehaviorRelay<[User]>(value: [])
    
    let searchBarObservable = BehaviorRelay(value: "")
    
    
    var disposeBag = DisposeBag()
    
    
    
    init() {
        //        _ = APIService.loadMembers()
        //            .take(1)
        //            .bind(to: userObservable)
        
        //Observable<[User]>
        searchBarObservable.flatMap{APIService.loadMembers($0)}
//            .debug()
            .take(1)
            .bind(to: userObservable)
            .disposed(by: disposeBag)
        
                
                
            
    }
            
        
        
        
        
        
        
        
        //2개의 옵저버블을 받아와서 새로운 모델로..
        //        Observable.zip(aa, bb)
        //            .debug()
        
        //
        
        
        //            .debug()
        //            .bind(to: userObservable)
        //            .disposed(by: disposeBag)
        
       
    
    
}

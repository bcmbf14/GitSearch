//
//  APIService.swift
//  GitSearch
//
//  Created by jc.kim on 2/26/21.
//

import Foundation
import RxSwift


let MEMBER_LIST_URL = "https://api.github.com/search/users"
let REPOSITORY_COUNT_URL = "https://api.github.com/users"

class APIService {
    static func loadMembers(_ keyword: String = "",_ page: Int = 1,_ perPage: Int = 20) -> Observable<[User]> {
        
        return Observable.create { emitter in
            let parameters = [
                "q":keyword,
                "page":"\(page)",
                "per_page":"\(perPage)"
            ]
            
            var components = URLComponents(string: MEMBER_LIST_URL)!
            
            components.queryItems = parameters.map { URLQueryItem(name: $0, value: $1) }
            components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
            
            let request = URLRequest(url: components.url!)
            
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                if let error = error {
                    emitter.onError(error)
                    return
                }
                
                guard let data = data,
                      let members = try? JSONDecoder().decode(SearchResult.self, from: data) else {
                    emitter.onCompleted()
                    return
                }
            
            
//                var menus = [Menu](){
//                    didSet{
//                        print(menus)
//                    }
//                }
//
//
//            members.items.forEach { item in
//                fetchAllMenus(item.url!) { (result) in
//                    print("#2", #function)
//                    switch result {
//                    case .success(let user):
//                        let menu = Menu(login: item.login, avatarUrl: item.avatarUrl, publicRepos: user.publicRepos)
//                        print(menu)
//                        menus.append(menu)
//
//                    case .failure(let err):
//                        print(error)
//                    }
//                }
                
               
//            }
                
                
                emitter.onNext(members.items)
                emitter.onCompleted()
                
               
            }
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    static func loadSingleUser(_ url: String = "") -> Observable<SingleUser> {
        
        return Observable.create { emitter in
            
            let task = URLSession.shared.dataTask(with: URL(string: url)!) { data, _, error in
                if let error = error {
                    emitter.onError(error)
                    return
                }
                
                guard let data = data,
                      let singleUser = try? JSONDecoder().decode(SingleUser.self, from: data) else {
                    emitter.onCompleted()
                    return
                }
                
                emitter.onNext(singleUser)
                emitter.onCompleted()
            }
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    static func fetchAllMenus(_ url:String = "", onComplete: @escaping (Result<SingleUser, Error>) -> Void) {
        URLSession.shared.dataTask(with: URL(string: url)!) { data, res, err in
            if let err = err {
                onComplete(.failure(err))
                return
            }
            
            guard let data = data,
                  let singleUser = try? JSONDecoder().decode(SingleUser.self, from: data) else {
                return
            }
            
            onComplete(.success(singleUser))
        }.resume()
    }
}


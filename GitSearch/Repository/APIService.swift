//
//  APIService.swift
//  GitSearch
//
//  Created by jc.kim on 2/26/21.
//

import Foundation
import RxSwift


let MEMBER_LIST_URL = "https://api.github.com/search/users"

class APIService {
    static func requestUsersList(_ keyword: String = "",_ page: Int,_ perPage: Int = 20) -> Observable<[User]> {
        
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
            
                emitter.onNext(members.items)
                emitter.onCompleted()
            }
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
    }
}


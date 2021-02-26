//
//  SingleUser.swift
//  GitSearch
//
//  Created by jc.kim on 2/26/21.
//

import Foundation

struct SingleUser: Decodable {
    let publicRepos: Int
    
    enum CodingKeys: String, CodingKey {
        case publicRepos = "public_repos"
    }
}






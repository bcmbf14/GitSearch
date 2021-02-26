//
//  User.swift
//  GitSearch
//
//  Created by jc.kim on 2/26/21.
//

import Foundation

struct User: Decodable {
    let login: String
    let avatarUrl: String?
    let url: String?
    
    enum CodingKeys: String, CodingKey {
        case login
        case avatarUrl = "avatar_url"
        case url
    }
}

extension User: Equatable {
    
}



struct Menu {
    var login: String
    var avatarUrl: String?
    var publicRepos: Int
}


extension Menu {
    static func fromMenuItems(item: User, repos: Int) -> Menu {
        return Menu(login: item.login, avatarUrl: item.avatarUrl, publicRepos: repos)
    }
}


//
//  User.swift
//  GitSearch
//
//  Created by jc.kim on 2/26/21.
//

import Foundation

struct User: Decodable {
    let name: String
    let imageUrl: String?
    let singleUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case name = "login"
        case imageUrl = "avatar_url"
        case singleUrl = "url"
    }
}



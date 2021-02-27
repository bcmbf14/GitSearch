//
//  SearchResult.swift
//  GitSearch
//
//  Created by jc.kim on 2/26/21.
//

import Foundation

struct SearchResult: Decodable {
  let totalCount: Int
  let incompleteResults: Bool
  let items: [User]
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items
    }
}




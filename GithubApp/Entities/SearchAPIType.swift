//
//  SearchAPIType.swift
//  GithubApp
//
//  Created by jiniz.ll on 2022/08/03.
//

import Foundation

enum Items: Decodable {
    case users([User])
    case repositories([Repository])
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode([User].self) {
            self = .users(x)
            return
        }
        if let x = try? container.decode([Repository].self) {
            self = .repositories(x)
            return
        }
        throw DecodingError.typeMismatch(Items.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Items"))
    }
}

struct Item: Decodable {
    let items: String
}

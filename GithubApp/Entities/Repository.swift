//
//  Repository.swift
//  GithubApp
//
//  Created by jiniz.ll on 2022/07/08.
//

import Foundation

struct Repository: Decodable {
    
    let id: Int
    let fullname: String
    let description: String
    let stargazersCount: Int
    let language: String
    
    enum CodingKeys: String, CodingKey {
        case id, fullname, description, language
        case stargazersCount = "stargazers_count"
    }
}

//
//  User.swift
//  GithubApp
//
//  Created by jiniz.ll on 2022/06/09.
//

import Foundation

struct User: Decodable {
    let id: Int
    let login: String
    let avatarUrl: String
    let reposUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id, login
        case avatarUrl = "avatar_url"
        case reposUrl = "repos_url"
    }
}

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
    let avatarURL: String
    let reposURL: String
    
    enum CodingKeys: String, CodingKey {
        case id, login
        case avatarURL = "avatar_url"
        case reposURL = "repos_url"
    }
}

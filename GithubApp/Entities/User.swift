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
    
    init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try values.decode(Int.self, forKey: .id)
        self.login = try values.decode(String.self, forKey: .login)
        self.avatarURL = try values.decode(String.self, forKey: .avatarURL)
        self.reposURL = try values.decode(String.self, forKey: .reposURL)
    }
}

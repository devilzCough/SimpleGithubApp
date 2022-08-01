//
//  Repository.swift
//  GithubApp
//
//  Created by jiniz.ll on 2022/07/08.
//

import Foundation

struct Repository: Decodable {
    
    let id: Int?
    let fullname: String?
    let description: String?
    let stargazersCount: Int?
    let language: String?
    
    enum CodingKeys: String, CodingKey {
        case id, fullname, description, language
        case stargazersCount = "stargazers_count"
    }
    
    init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try? values.decode(Int?.self, forKey: .id)
        self.fullname = try? values.decode(String?.self, forKey: .fullname)
        self.description = try? values.decode(String?.self, forKey: .description)
        self.stargazersCount = try? values.decode(Int?.self, forKey: .stargazersCount)
        self.language = try? values.decode(String?.self, forKey: .language)
    }
}

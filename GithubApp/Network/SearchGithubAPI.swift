//
//  SearchGithubAPI.swift
//  GithubApp
//
//  Created by jiniz.ll on 2022/07/08.
//

import Foundation

enum GithubAPI: String, CaseIterable {
    
    case user = "/search/users"
    case repository = "/search/repositories"
    
    var path: String {
        return self.rawValue
    }
    
    var name: String {
        switch self {
        case .user: return "User"
        case .repository: return "Repository"
        }
    }
}

struct SearchGithubAPI {
    
    static let scheme = "https"
    static let host = "api.github.com"
    
    func search(query: String, type: GithubAPI) -> URLComponents {
        var components = URLComponents()
        components.scheme = SearchGithubAPI.scheme
        components.host = SearchGithubAPI.host
        components.path = type.path
        
        components.queryItems = [
            URLQueryItem(name: "q", value: query)
        ]
        
        return components
    }
}

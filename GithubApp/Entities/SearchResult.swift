//
//  SearchResult.swift
//  GithubApp
//
//  Created by jiniz.ll on 2022/07/08.
//

import Foundation

struct SearchResult: Decodable {
    let users: [User]
    let repositories: [Repository]
}

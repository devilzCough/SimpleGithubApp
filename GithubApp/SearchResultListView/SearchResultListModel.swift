//
//  SearchResultListModel.swift
//  GithubApp
//
//  Created by jiniz.ll on 2022/08/08.
//

import Foundation

struct SearchResultListModel {
 
    func itemsToCellData(_ items: Items) -> [SectionOfSearchResult] {
        
        switch items {
        case .users(let data):
            let result = data
                .map { user in
                    GithubResultItem.user(result: user)
                }
            return [SectionOfSearchResult(model: GithubResultSection.user.title, items: result)]
        case .repositories(let data):
            let result = data
                .map { repository in
                    GithubResultItem.repository(result: repository)
                }
            return [SectionOfSearchResult(model: GithubResultSection.repository.title, items: result)]
        }
    }
}

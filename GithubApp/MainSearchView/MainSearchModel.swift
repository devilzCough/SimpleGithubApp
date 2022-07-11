//
//  MainModel.swift
//  GithubApp
//
//  Created by jiniz.ll on 2022/07/08.
//

import Foundation
import RxSwift

struct MainSearchModel {
    
    let network = SearchGithubNetwork.shared
    
    func search(_ query: String, _ type: GithubAPI) -> Single<Result<[User], SearchNetworkError>> {
        
        return network.searchList(about: query, with: type)
    }
    
    func getSearchValue(_ result: Result<[User], SearchNetworkError>) -> [User]? {
        
        guard case .success(let value) = result else {
            return nil
        }
        return value
    }
    
    func getSearchError(_ result: Result<[User], SearchNetworkError>) -> String? {
        
        guard case .failure(let error) = result else {
            return nil
        }
        return error.localizedDescription
    }
}

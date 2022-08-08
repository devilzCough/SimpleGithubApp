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
    
    func search(_ query: String) -> Single<Result<Items, SearchNetworkError>> {
        
        let result = Observable.from(GithubAPI.allCases)
            .concatMap { api in
                network.searchList(about: query, type: api)
            }
            .asSingle()
        
        return result
    }
    
    func getSearchValue(_ result: Result<Items, SearchNetworkError>) -> Items? {
        
        guard case .success(let value) = result else {
            return nil
        }
        return value
    }
    
    func getSearchError(_ result: Result<Items, SearchNetworkError>) -> String? {
        
        guard case .failure(let error) = result else {
            return nil
        }
        return error.localizedDescription
    }
}

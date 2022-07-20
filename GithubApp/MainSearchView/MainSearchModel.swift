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
    
    func search(_ query: String, _ type: GithubAPI) async throws ->  Single<Result<[SectionOfSearchResult], SearchNetworkError>> {
        
        let searchResult = PublishSubject<[SectionOfSearchResult]>()
        
        var sectionResult: [SectionOfSearchResult] = []
        
        for api in GithubAPI.allCases {
            let result = network.searchList(about: query, type: api)
            guard let item = try await getSearchValue(result.value) else { return .just(.failure(.networkError)) }
            sectionResult.append(SectionOfSearchResult(model: api.section, items: item))
        }
//

//        var result = network.searchList(about: query, type: .user)
//        guard let item = try await getSearchValue(result.value) else { return .just(.failure(.networkError)) }
//        sectionResult.append(SectionOfSearchResult(model: .user, items: item))
//
//        result = network.searchList(about: query, type: .repository)
//        guard let item = try await getSearchValue(result.value) else { return .just(.failure(.networkError)) }
//        sectionResult.append(SectionOfSearchResult(model: .repository, items: item))
        
//        return network.searchList(about: query, type: type)
    }
    
    func getSearchValue(_ result: Result<[TableViewItem], SearchNetworkError>) -> [TableViewItem]? {
        
        guard case .success(let value) = result else {
            return nil
        }
        return value
    }
    
    func getSearchError(_ result: Result<[TableViewItem], SearchNetworkError>) -> String? {
        
        guard case .failure(let error) = result else {
            return nil
        }
        return error.localizedDescription
    }
}

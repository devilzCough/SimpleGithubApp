//
//  SearchGithubNetwork.swift
//  GithubApp
//
//  Created by jiniz.ll on 2022/07/07.
//

import Foundation
import RxSwift

enum SearchNetworkError: Error {
    case invalidURL
    case invalidJSON
    case networkError
    case cannotParseData
}

class SearchGithubNetwork {
    
    static let shared = SearchGithubNetwork()
    
    private let session = URLSession(configuration: .default)
    private let githubAPI = SearchGithubAPI()
    
    private init() {
        
    }
    
    func searchList(about query: String, type api: GithubAPI) -> Single<Result<Items, SearchNetworkError>> {
            
        guard let url = githubAPI.search(query: query, type: api).url else {
            return .just(.failure(.invalidURL))
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        return session.rx.data(request: request)
            .map({ data in
                do {
                    let result = try JSONDecoder().decode(APIResult.self, from: data)
                    return .success(result.items)
                } catch {
                    return .failure(.cannotParseData)
                }
            })
            .catch({ _ in
                    .just(.failure(.networkError))
            })
            .asSingle()
    }
    
    private func decode(_ data: Data, type api: GithubAPI) throws -> GithubResultItem? {

        do {
            switch api {
            case .user:
                let item = try JSONDecoder().decode(User.self, from: data)
                return GithubResultItem.user(result: item)
            case .repository:
                let item = try JSONDecoder().decode(Repository.self, from: data)
                return GithubResultItem.repository(result: item)
            }
        }
    }
}

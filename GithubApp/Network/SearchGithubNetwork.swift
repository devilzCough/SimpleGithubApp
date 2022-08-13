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
    case missingToken
}

class SearchGithubNetwork {
    
    static let shared = SearchGithubNetwork()
    
    private let session = URLSession(configuration: .default)
    private let githubAPI = SearchGithubAPI()
    
//    private let keys: NSDictionary?
    private var token: String?
    
    private init() {
        if let path = Bundle.main.path(forResource: "Keys", ofType: "plist"),
           let keys = NSDictionary(contentsOfFile: path) {
            token = keys["githubAPIAuthorization"] as? String
        }
    }
    
    func searchList(about query: String, type api: GithubAPI) -> Single<Result<Items, SearchNetworkError>> {
        
        guard let token = token else {
            return .just(.failure(.missingToken))
        }
            
        guard let url = githubAPI.search(query: query, type: api).url else {
            return .just(.failure(.invalidURL))
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("token \(token)", forHTTPHeaderField: "Authorization")
        
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
}

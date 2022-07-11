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
}

class SearchGithubNetwork {
    
    static let shared = SearchGithubNetwork()
    
    private let session = URLSession(configuration: .default)
    private let githubAPI = SearchGithubAPI()
    
    private init() {
        
    }
    
    func searchList(about query: String, with api: GithubAPI) -> Single<Result<[User], SearchNetworkError>> {

        guard let url = githubAPI.search(query: query, type: api).url else {
            return .just(.failure(.invalidURL))
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        return session.rx.data(request: request)
            .map { data -> [[String: Any]] in
                    guard let json = try? JSONSerialization.jsonObject(with: data),
                          let result = json as? [String: Any],
                          let items = result["items"] as? [[String: Any]] else { return [] }
                    return items
            }
            .filter { result in
                return result.count > 0
            }
            .map { objects in
                let result =  objects.compactMap { dic -> User? in
                    guard let id = dic["id"] as? Int,
                          let login = dic["login"] as? String,
                          let avatarUrl = dic["avatar_url"] as? String,
                          let reposUrl = dic["repos_url"] as? String else {
                        return nil
                    }
                    return User(id: id, login: login, avatarURL: avatarUrl, reposURL: reposUrl)
                }
                return .success(result)
            }
            .catch { _ in
                    .just(.failure(.networkError))
            }
            .asSingle()
    }
}

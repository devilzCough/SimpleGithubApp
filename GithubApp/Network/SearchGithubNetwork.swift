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
    
    func searchList(about query: String, type api: GithubAPI) -> Single<Result<[SectionOfSearchResult], SearchNetworkError>> {
            
        guard let url = githubAPI.search(query: query, type: api).url else {
            return .just(.failure(.invalidURL))
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        return session.rx.data(request: request)
            .compactMap { data -> Data? in
                guard let json = try? JSONSerialization.jsonObject(with: data),
                      let result = json as? [String: Any],
                      let items = result["items"] else { return nil }
                return items as? Data
            }
            .map { objects in
                do {
                    let items = try objects.compactMap { item -> GithubResultItem? in
                        let data = Data([item])
                        switch api {
                        case .user:
                            let item = try JSONDecoder().decode(User.self, from: data)
                            return GithubResultItem.user(result: item)
                        case .repository:
                            let item = try JSONDecoder().decode(Repository.self, from: data)
                            return GithubResultItem.repository(result: item)
                        }
                    }
                    
                    let result = [SectionOfSearchResult(model: api.section, items: items)]
                    
                    return .success(result)
                }
                catch {
                    return .failure(.invalidJSON)
                }
                
            }
            .catch { _ in
                    .just(.failure(.networkError))
            }
            .asSingle()
    }
}

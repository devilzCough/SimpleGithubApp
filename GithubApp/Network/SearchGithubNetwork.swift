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
    
    func searchList(about query: String, type api: GithubAPI) -> Single<Result<[TableViewItem], SearchNetworkError>> {
            
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
                    let results = try objects.compactMap { item -> TableViewItem? in
                        let data = Data([item])
                        switch api {
                        case .user:
                            let result = try JSONDecoder().decode(User.self, from: data)
                            return TableViewItem.user(result: result)
                        case .repository:
                            let result = try JSONDecoder().decode(Repository.self, from: data)
                            return TableViewItem.repository(result: result)
                        }
                    }
                    return .success(results)
                }
                catch {
                    return .failure(.invalidJSON)
                }
                
            }
            .catch { _ in
                    .just(.failure(.networkError))
            }
            .asSingle()
        
        
        
//        return session.rx.data(request: request as URLRequest)
//            .map { data in
//                do {
//                    let blogData = try JSONDecoder().decode(KakaoBlog.self, from: data)
//                    return .success(blogData)
//                } catch {
//                    return .failure(.invalidJSON)
//                }
//            }
//            .catch { _ in
//                    .just(.failure(.networkError))
//            }
//            .asSingle()
    }
}

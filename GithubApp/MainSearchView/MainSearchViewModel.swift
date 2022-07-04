//
//  MainSearchViewModel.swift
//  GithubApp
//
//  Created by jiniz.ll on 2022/07/04.
//

import Foundation
import RxSwift
import RxCocoa

enum GithubAPI: String, CaseIterable {
    
    case user = "https://api.github.com/search/users?q="
    case repository = "https://api.github.com/search/repositories?q="
    
    var url: String {
        return self.rawValue
    }
    
    var name: String {
        switch self {
        case .user: return "User"
        case .repository: return "Repository"
        }
    }
}

struct MainSearchViewModel {
    
    let disposeBag = DisposeBag()
    
    let searchBarViewModel = SearchBarViewModel()
    let searchResultListViewModel = SearchResultListViewModel()
    
    init() {
        
        let searchResult = searchBarViewModel.shouldLoadResult
            .flatMapLatest { [self] (query, type) in
                fetch(about: type, of: query)
            }
            .share()
        
        searchResult
            .bind(to: searchResultListViewModel.searchResultData)
            .disposed(by: disposeBag)
    }
    
    func fetch(about api: GithubAPI, of query: String) -> Observable<[User]> {
        
        let result = Observable.of(query)
            .map { query -> URL in
                return URL(string: api.url + "\(query)")!
            }
            .map { url -> URLRequest in
                var request = URLRequest(url: url)
                request.httpMethod = "GET"
                return request
            }
            .flatMap { request -> Observable<(response: HTTPURLResponse, data: Data)> in
                return URLSession.shared.rx.response(request: request)
            }
            .filter { response, _ in
                return 200..<300 ~= response.statusCode
            }
            .map { _, data -> [[String: Any]] in
                guard let json = try?  JSONSerialization.jsonObject(with: data),
                      let result = json as? [String: Any],
                      let items = result["items"] as? [[String: Any]] else { return [] }
                return items
            }
            .filter { result in
                return result.count > 0
            }
            .map { objects in
                return objects.compactMap { dic -> User? in
                    guard let id = dic["id"] as? Int,
                          let login = dic["login"] as? String,
                          let avatarUrl = dic["avatar_url"] as? String,
                          let reposUrl = dic["repos_url"] as? String else {
                        return nil
                    }
                    return User(id: id, login: login, avatarUrl: avatarUrl, reposUrl: reposUrl)
                }
            }
        
        return result
    }
}

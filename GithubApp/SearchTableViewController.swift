//
//  SearchTableViewController.swift
//  GithubApp
//
//  Created by jiniz.ll on 2022/06/02.
//

import UIKit
import RxSwift
import RxCocoa

enum GithubAPI: String {
    case user = "https://api.github.com/search/users?q="
    
    var url: String {
        return self.rawValue
    }
}

class SearchTableViewController: UITableViewController {
    
    private var input = "jin"
    
    private let users = BehaviorSubject<[User]>(value: [])
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        attribute()
        configure()
        
        fetch(about: .user, of: input)
    }
    
    private func attribute() {
        
        navigationItem.searchController = SearchBar()
        
        navigationItem.title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configure() {
        tableView.register(UserResultCell.self, forCellReuseIdentifier: "UserTableViewCell")
        tableView.rowHeight = 100
    }

    func fetch(about api: GithubAPI, of query: String) {
        Observable.of(query)
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
            .subscribe(onNext: { [weak self] newUsers in
                self?.users.onNext(newUsers)
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            })
            .disposed(by: disposeBag)
    }
}

extension SearchTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        do {
            return try users.value().count
        } catch {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell", for: indexPath) as? UserResultCell else { return UITableViewCell() }
        

        var user: User? {
            do {
                return try users.value()[indexPath.row]
            } catch {
                return nil
            }
        }
        
        cell.user = user
        return cell
    }
}

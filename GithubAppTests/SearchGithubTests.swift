//
//  GithubAppTests.swift
//  GithubAppTests
//
//  Created by jiniz.ll on 2022/06/02.
//

import XCTest
import Nimble
import RxSwift
@testable import GithubApp

class SearchGithubTests: XCTestCase {
    
    var userResults: APIResult!
    var userItems: Items!
    
    var repositoryResult: APIResult!
    var repositoryItems: Items!

    override func setUp() {

        self.userResults = userList
        self.userItems = userResults.items
        
        self.repositoryResult = repositoryList
        self.repositoryItems = repositoryResult.items
    }
    
    /*
    let searchResultListModel = SearchResultListModel()
    let searchResultData = PublishSubject<Items>()
    
    
    func test_itemsToCellData() async {
        
        let items: [String: Observable<Items>] = [
            "users" : Observable.of(userItems),
            "repositories": Observable.of(repositoryItems)
        ]
        
        let totalItems = Observable.from(items.keys)
            .concatMap { api in
                items[api]!
            }

        totalItems
            .bind(to: searchResultData)
        
        let cellData = searchResultData
            .map(self.searchResultListModel.itemsToCellData)
        
    }
    */
    
    func test_loadData() {

        switch self.userItems {
            
        case .users(let users):
            expect(users.count).to(
                equal(30),
                description: "\(users.count)"
            )
            
            expect(users[0].login).to(
                equal("jin"),
                description: users[0].login
            )
        default:
            print("userItem Decoding Test")
        }
        
        switch self.repositoryItems {
            
        case .repositories(let repositories):
            expect(repositories.count).to(
                equal(30),
                description: "\(repositories.count)"
            )
            
            expect(repositories[0].fullname).to(
                equal("jina-ai/jina"),
                description: repositories[0].fullname
            )
        default:
            print("repositoryItem Decoding Test")
        }
    }
}

//
//  GithubAppTests.swift
//  GithubAppTests
//
//  Created by jiniz.ll on 2022/06/02.
//

import XCTest
import Nimble
@testable import GithubApp

class SearchGithubTests: XCTestCase {
    
    var results: APIResult!
    var userItems: Items!
    

    override func setUp() {

        self.results = userList
        self.userItems = results.items
    }
    
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
        case .repositories(let items):
            expect(items.count).to(
                equal(30),
                description: "\(items.count)"
            )
        case .none:
            print("no data type")
        }
    }
}

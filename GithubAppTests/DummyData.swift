//
//  DummyData.swift
//  GithubAppTests
//
//  Created by jiniz.ll on 2022/08/08.
//

import Foundation

@testable import GithubApp

var userList: [User] = Dummy().load("usersDummy.json")
var repositoryList: [Repository] = Dummy().load("repositoryDummy.json")

class Dummy {
    
    func load<T: Decodable>(_ fileName: String) -> T {
        
        let data: Data
        let bundle = Bundle(for: type(of: self))
        
        guard let file = bundle.url(forResource: fileName, withExtension: nil) else {
            fatalError("\(fileName)을 main bundle에서 불러올 수 없습니다.")
        }
        
        do {
            data = try Data(contentsOf: file)
        } catch {
            fatalError("\(fileName)을 main bundle에서 불러올 수 없습니다. \(error)")
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            fatalError("\(fileName)을 \(T.self)로 파싱할 수 없습니다.")
        }
    }
}

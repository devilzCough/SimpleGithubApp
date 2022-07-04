//
//  SearchResultListViewModel.swift
//  GithubApp
//
//  Created by jiniz.ll on 2022/07/04.
//

import Foundation
import RxSwift
import RxCocoa

struct SearchResultListViewModel {
    
    // SearchViewController 에서 네트워크 작업 -> SearchResultListView
    let searchResultData = PublishSubject<[User]>()
    // 받아온 데이터를 View에서 사용하기 위함
    let cellData: Driver<[User]>
    
    init() {
        self.cellData = searchResultData
            .asDriver(onErrorJustReturn: [])
    }
}

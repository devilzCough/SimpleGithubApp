//
//  SearchBarViewModel.swift
//  GithubApp
//
//  Created by jiniz.ll on 2022/06/24.
//

import Foundation
import RxSwift
import RxCocoa

struct SearchBarViewModel {
    
    let queryText = PublishRelay<String?>()
    let queryType = PublishRelay<GithubAPI>()
    
    let searchButtonTapped = PublishRelay<Void>()
    
    // -> SearchVC
    let shouldLoadResult: Observable<(String, GithubAPI)>
    
    init() {
        
        shouldLoadResult = searchButtonTapped
            .withLatestFrom(
                Observable.combineLatest(queryText, queryType) { text, type -> (String, GithubAPI) in
                    return (text ?? "", type)
                }
            ) { $1 }
            .filter { !($0.0.isEmpty) }
            .distinctUntilChanged() { $0.0 }
    }
}

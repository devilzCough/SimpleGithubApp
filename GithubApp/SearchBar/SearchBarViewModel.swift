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
    let queryType = PublishRelay<String>()
    
    let searchButtonTapped = PublishRelay<Void>()
    
    // -> SearchVC
    let shouldLoadResult: Observable<(String, String)>
    
    init() {
        
        shouldLoadResult = searchButtonTapped
            .withLatestFrom(
                Observable.combineLatest(queryText, queryType) { text, type -> (String, String) in
                    return (text ?? "", type)
                }
            ) { $1 }
            .filter { !($0.0.isEmpty) }
            .distinctUntilChanged() { $0.0 }
    }
}

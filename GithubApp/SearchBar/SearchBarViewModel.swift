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
    
    let searchButtonTapped = PublishRelay<Void>()
    
    // -> SearchVC
    let shouldLoadResult: Observable<String>
    
    init() {
        
        shouldLoadResult = searchButtonTapped
            .withLatestFrom(queryText) { $1 ?? "" }
            .filter { !$0.isEmpty }
            .distinctUntilChanged()
    }
}

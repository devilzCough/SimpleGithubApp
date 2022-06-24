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
        
        // 검색을 했을 때, 그 결과를 MainVC 로 내보내야 함
        shouldLoadResult = searchButtonTapped
            // $0(Void), $1(query: String) -> String
            .withLatestFrom(queryText) { $1 ?? "" }
            // query가 비어있지 않다면 패스
            .filter { !$0.isEmpty }
            // 이전과 동일한 값은 내보내지 않음
            .distinctUntilChanged()
            // queryType과 합쳐서 내보냄
            .withLatestFrom(queryType) { ($0, $1) }
    }
}

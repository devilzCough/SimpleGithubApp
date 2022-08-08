//
//  MainSearchViewModel.swift
//  GithubApp
//
//  Created by jiniz.ll on 2022/07/04.
//

import Foundation
import RxSwift
import RxCocoa

struct MainSearchViewModel {
    
    let disposeBag = DisposeBag()
    
    let searchBarViewModel = SearchBarViewModel()
    let searchResultListViewModel = SearchResultListViewModel()
    
    private let items = PublishSubject<Items>()
    
    init(model: MainSearchModel = MainSearchModel()) {
        
        let searchResult = searchBarViewModel.shouldLoadResult
            .flatMapLatest(model.search)
            .share()
        
        let searchValue = searchResult
            .compactMap(model.getSearchValue)

        let searchError = searchResult
            .compactMap(model.getSearchError)
        
        searchValue
            .bind(to: items)
            .disposed(by: disposeBag)
        
        searchValue
            .bind(to: searchResultListViewModel.searchResultData)
            .disposed(by: disposeBag)
    }
}

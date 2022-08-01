//
//  SearchBar.swift
//  GithubApp
//
//  Created by jiniz.ll on 2022/06/24.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class SearchBar: UISearchController {
    
    let disposeBag = DisposeBag()
    
    override init(searchResultsController: UIViewController? = nil) {
        super.init(searchResultsController: searchResultsController)
        
        attribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel: SearchBarViewModel) {
        
        // 검색 내용을 queryText로
        self.searchBar.rx.text
            .bind(to: viewModel.queryText)
            .disposed(by: disposeBag)
        
        // 키보드에서 보여지는 search 버튼 클릭시, searchButtonTapped로
        self.searchBar.rx.searchButtonClicked
            .asObservable()
            .bind(to: viewModel.searchButtonTapped)
            .disposed(by: disposeBag)
        
        // 키보드의 검색 버튼 클릭 시, 키보드가 내려가도록
        // searchBar.rx.endEdting이 제공되지 않아 extension으로 구현
        viewModel.searchButtonTapped
            .asSignal()
            .emit(to: self.searchBar.rx.endEditing)
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        self.searchBar.placeholder = "Search"
    }
}

extension Reactive where Base: UISearchBar {
    var endEditing: Binder<Void> {
        return Binder(base) { base, _ in
            base.endEditing(true)
        }
    }
}

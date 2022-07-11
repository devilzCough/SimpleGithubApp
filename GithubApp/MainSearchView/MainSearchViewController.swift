//
//  SearchTableViewController.swift
//  GithubApp
//
//  Created by jiniz.ll on 2022/06/02.
//

import UIKit
import RxSwift
import RxCocoa

class MainSearchViewController: UIViewController {
    
    let searchBar = SearchBar()
    let resultTableView = SearchResultListView()
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        attribute()
        layout()
    }
    
    func bind(_ viewModel: MainSearchViewModel) {
        searchBar.bind(viewModel.searchBarViewModel)
        resultTableView.bind(viewModel.searchResultListViewModel)
    }
    
    private func attribute() {
        
        view.backgroundColor = .white
        navigationItem.searchController = searchBar
        
        navigationItem.title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func layout() {
        
        view.addSubview(resultTableView)
        
        resultTableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

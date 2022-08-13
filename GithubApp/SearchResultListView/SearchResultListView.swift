//
//  SearchResultListView.swift
//  GithubApp
//
//  Created by jiniz.ll on 2022/07/04.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

typealias SectionOfSearchResult = SectionModel<String, GithubResultItem>

enum GithubResultSection: String {
    case user = "User"
    case repository = "Repository"
    
    var title: String {
        return self.rawValue
    }
}

enum GithubResultItem {
    
    case user(result: User)
    case repository(result: Repository)
}

class SearchResultListView: UITableView {
    
    let disposeBag = DisposeBag()
    
    private lazy var searchResultDataSource = RxTableViewSectionedReloadDataSource<SectionOfSearchResult>(configureCell: configureCell)
    private lazy var configureCell: RxTableViewSectionedReloadDataSource<SectionOfSearchResult>.ConfigureCell = { [unowned self] (dataSource, tableView, indexPath, item) in
        switch item {
        case .user(let data):
            return self.configureUserCell(user: data, at: indexPath)
        case .repository(let data):
            return self.configureRepositoryCell(repository: data, at: indexPath)
        }
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        attribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel: SearchResultListViewModel) {
        
        viewModel.cellData
            .drive(self.rx.items(dataSource: searchResultDataSource))
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        self.backgroundColor = .white
        self.register(UserResultCell.self, forCellReuseIdentifier: UserResultCell.identifier)
        self.register(RepositoryResultCell.self, forCellReuseIdentifier: RepositoryResultCell.identifier)
        self.separatorStyle = .singleLine
        self.rowHeight = 100
        
        searchResultDataSource.titleForHeaderInSection = { dataSource, index in
            return dataSource.sectionModels[index].model
        }
    }
}

extension SearchResultListView {
    func configureUserCell(user: User, at indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.dequeueReusableCell(withIdentifier: UserResultCell.identifier, for: indexPath) as? UserResultCell else {
            return UITableViewCell()
        }
        
        cell.configureData(user)
        return cell
    }
    
    func configureRepositoryCell(repository: Repository, at indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.dequeueReusableCell(withIdentifier: RepositoryResultCell.identifier, for: indexPath) as? RepositoryResultCell else {
            return UITableViewCell()
        }
        
        cell.configureData(repository)
        return cell
    }
}

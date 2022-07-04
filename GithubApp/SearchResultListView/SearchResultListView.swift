//
//  SearchResultListView.swift
//  GithubApp
//
//  Created by jiniz.ll on 2022/07/04.
//

import UIKit
import RxSwift
import RxCocoa

class SearchResultListView: UITableView {
    
    let disposeBag = DisposeBag()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        attribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel: SearchResultListViewModel) {
        
        // 받아온 데이터 -> 테이블 뷰 셀에 바인딩
        viewModel.cellData
            .drive(self.rx.items) { tableView, row, data in
                let indexPath = IndexPath(row: row, section: 0)
                guard let cell = tableView.dequeueReusableCell(withIdentifier: UserResultCell.identifier, for: indexPath) as? UserResultCell else { return UITableViewCell() }
                cell.configureData(data)
                return cell
            }
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        self.backgroundColor = .white
        self.register(UserResultCell.self, forCellReuseIdentifier: UserResultCell.identifier)
        self.separatorStyle = .singleLine
        self.rowHeight = 100
    }
}

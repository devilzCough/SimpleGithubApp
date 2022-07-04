//
//  UserTableViewCell.swift
//  GithubApp
//
//  Created by jiniz.ll on 2022/06/08.
//

import UIKit
import SnapKit

class UserResultCell: UITableViewCell {
    
    let profileImageView = UIImageView()
    let nameLabel = UILabel()
    let repositoryLabel = UILabel()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        [
            profileImageView,
            nameLabel, repositoryLabel
        ].forEach {
            contentView.addSubview($0)
        }
        
        profileImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalTo(self)
            $0.width.equalTo(self.snp.height).multipliedBy(0.7)
            $0.height.equalTo(profileImageView.snp.width)
        }
        
        nameLabel.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(15)
            $0.centerY.equalTo(self).offset(-18)
            $0.trailing.equalToSuperview().offset(20)
        }
        
        repositoryLabel.snp.makeConstraints {
            $0.leading.equalTo(nameLabel)
            $0.centerY.equalTo(self).offset(18)
            $0.trailing.equalTo(nameLabel)
        }
    }
    
    func configureData(_ user: User) {
        
        profileImageView.image = UIImage(systemName: "star")
        nameLabel.text = user.login
        repositoryLabel.text = "Number of repos : 3"
    }
}
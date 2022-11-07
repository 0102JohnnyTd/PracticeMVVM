//
//  UserListCell.swift
//  PracticeMVVM
//
//  Created by Johnny Toda on 2022/11/07.
//

import UIKit

final class UserListCell: UITableViewCell {
    // ユーザーアイコンを表示
    private var iconView: UIImageView!

    // ユーザー名を表示
    private var nameLabel: UILabel!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpIconView()
        setUpNameLabel()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Viewに追加したオブジェクトのサイズを設定
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutIconView()
        layoutNameLabel()
    }

    // ユーザーアイコン用のImageViewを生成し,viewに追加
    private func setUpIconView() {
        iconView = UIImageView()
        iconView.clipsToBounds = true
        contentView.addSubview(iconView)
    }

    // ユーザー名用のUILabelを生成し、viewに追加
    private func setUpNameLabel() {
        nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 15)
        contentView.addSubview(nameLabel)
    }

    // iconViewのサイズを設定
    private func layoutIconView() {
        iconView.frame = CGRect(x: 15, y: 15, width: 45, height: 45)
        iconView.layer.cornerRadius = iconView.frame.size.width / 2
    }

    // nameLabelのサイズを設定
    private func layoutNameLabel() {
        nameLabel.frame = CGRect(x: iconView.frame.maxX + 15, y: iconView.frame.origin.y, width: contentView.frame.width - iconView.frame.maxX - 15 * 2, height: 15)
    }

    // 取得したユーザーデータをオブジェクトにセット
    private func configure(name: String, icon: UIImage) {
        nameLabel.text = name
        iconView.image = icon
    }
}

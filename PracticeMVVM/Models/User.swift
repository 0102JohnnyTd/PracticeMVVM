//
//  User.swift
//  PracticeMVVM
//
//  Created by Johnny Toda on 2022/11/03.
//

import Foundation

// ハードコーディング対策としてenumでkeyを管理
   // ❓それぞれのkeyが複数回使用されない可能性が高い本ケースにおいては本当に必要なのだろうか
private enum Attribute {
    static let id = "id"
    static let name = "name"
    static let iconURL = "avatar_url"
    static let webURL = "html_url"
}

// ユーザーのモデルを定義
final class User {
    let id: Int
    let name: String
    let iconURL: String
    let webURL: String

    init(attributes: [String: Any]) {
        id = attributes[Attribute.id] as! Int
        name = attributes[Attribute.name] as! String
        iconURL = attributes[Attribute.iconURL] as! String
        webURL = attributes[Attribute.webURL] as! String
    }
}


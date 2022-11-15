//
//  User.swift
//  PracticeMVVM
//
//  Created by Johnny Toda on 2022/11/03.
//

import Foundation

//// ハードコーディング対策としてenumでkeyを管理
//   // ❓それぞれのkeyが複数回使用されない可能性が高い本ケースにおいては本当に必要なのだろうか
//private enum Attribute {
//    static let id = "id"
//    static let name = "login"
//    static let iconURL = "avatar_url"
//    static let webURL = "html_url"
//}
//
//// JSONSeriaLizationはclassを使用
//// ユーザーのモデルを定義
//final class User {
//    let id: Int
//    let name: String
//    let iconURL: String
//    let webURL: String
//
//    init(attributes: [String: Any]) {
//        id = attributes[Attribute.id] as! Int
//        name = attributes[Attribute.name] as! String
//        iconURL = attributes[Attribute.iconURL] as! String
//        webURL = attributes[Attribute.webURL] as! String
//    }
//}

// JSONDecoderは構造体を使用
// ユーザーのモデルを定義
struct User: Codable {
    let id: Int
    let name: String
    let iconURL: String
    let webURL: String

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "login"
        case iconURL = "avatar_url"
        case webURL = "html_url"
    }
}

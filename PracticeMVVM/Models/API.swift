//
//  API.swift
//  PracticeMVVM
//
//  Created by Johnny Toda on 2022/11/04.
//

import Foundation

// コード量も増え、可読性も逆に下がりそうな気がしたのでコメントアウト
// private enum ErrorMessage {
//    static let unkwown = "不明なエラーです"
//    static let invalidURL = "無効なURLです"
//    static let invalidResponse = "フォーマットが無効なレスポンスを受け取りました"
// }

// エラー内容ごとにメッセージ発生時に返すメッセージを列挙
enum APIError: Error, CustomStringConvertible {
    case unknown
    case invalidURL
    case invalidResponse

    var description: String {
        switch self {
        case .unknown: return "不明なエラーです"
        case .invalidURL: return "無効なURLです"
        case .invalidResponse: return "フォーマットが無効なレスポンスを受け取りました"
        }
    }
}

final class API {
    // 通信用のURL
    private let usersURL = "https://api.github.com/users"

    // 🍏レスポンスデータをパース(以下のJSONDecoderを使ったやり方はエラーが発生する)
    func decodeUsersData(success: @escaping ([User]) -> Void, failure: @escaping (Error) -> Void) {
        fetchUsers(success: { data in
            // レスポンスデータの内容を出力
//            print(#function, data, String(data: data, encoding: .utf8)!)
            do {
                let users = try JSONDecoder().decode([User].self, from: data)
                DispatchQueue.main.async {
                    success(users)
                }
            } catch {
                print(#function, error)
                DispatchQueue.main.async {
                    failure(APIError.invalidResponse)
                }
            }
        }, failure: { failure($0) })
    }

    
    // 🍏旧式のパース
//    func serializeUsersData(success: @escaping ([User]) -> Void, failire: @escaping (Error) -> Void) {
//        fetchUsers(success: { data in
//            var users = [User]()
//            do {
//                // なぜ配列でキャストしたのだろうか。
//                let jsons = try JSONSerialization.jsonObject(with: data, options: []) as! [[String: Any]]
//                print("jsonsの中身: \(jsons)")
//                jsons.forEach { json in
//                    // print("jsonの中身: \(json)")
//                    // Usersモデル
//                    let user = User(attributes: json)
//                    users.append(user)
//                }
//                DispatchQueue.main.async {
//                    success(users)
//                }
//                print(jsons)
//            } catch {
//                DispatchQueue.main.async {
//                    failire(APIError.invalidResponse)
//                }
//            }
//        }) { failire($0) }
//    }

    // gitHubユーザーのデータを取得
    private func fetchUsers(success: @escaping (Data) -> Void, failure: @escaping (Error) -> Void) {
        let requestURL = URL(string: usersURL)
        guard let url = requestURL else {
            failure(APIError.invalidURL)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10

        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {  
                DispatchQueue.main.async {
                    failure(error)
                }
                return
            }
            guard let data = data else {
                DispatchQueue.main.async {
                    failure(APIError.unknown)
                }
                return
            }
            // 引数Successクロージャに渡す配列を定義
            success(data)
        }
        task.resume()
    }
}

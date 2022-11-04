//
//  API.swift
//  PracticeMVVM
//
//  Created by Johnny Toda on 2022/11/04.
//

import Foundation

// コード量も増え、可読性も逆に下がりそうな気がしたのでコメントアウト
//private enum ErrorMessage {
//    static let unkwown = "不明なエラーです"
//    static let invalidURL = "無効なURLです"
//    static let invalidResponse = "フォーマットが無効なレスポンスを受け取りました"
//}

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

    // API通信を実行してからGitHubのユーザーデータを取得
    func fetchUsers(success: @escaping ([User]) -> Void, failure: @escaping (Error) -> Void) {
        // ❓ハードコーディングの観点からURLを格納したプロパティを定義して指定してるが、ここでしか使用しないならやはり不要な気も。。
        let requestURL = URL(string: usersURL)
        guard let url = requestURL else {
            failure(APIError.invalidURL)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
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
            guard let jsonOptional = try? JSONSerialization.jsonObject(with: data, options: []),
                  let json = jsonOptional as? [[String: Any]]
            else {
                DispatchQueue.main.async {
                    failure(APIError.invalidResponse)
                }
                return
            }
            var users = [User]()
            json.forEach {
                let user = User(attributes: $0)
                users.append(user)
            }
            DispatchQueue.main.async {
                success(users)
            }
        }
        task.resume()
    }
}

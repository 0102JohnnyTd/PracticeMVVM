//
//  ImageDownloader.swift
//  PracticeMVVM
//
//  Created by Johnny Toda on 2022/11/05.
//

import Foundation
import UIKit

final class ImageDownloader {
    // キャッシュした画像を保管しておくプロパティ
    var cacheImage: UIImage?

    // 画像をダウンロード
    func downloadImage(imageURL: String, succeess: @escaping (UIImage) -> Void, failure: @escaping (Error) -> Void) {
        // キャッシュが存在する場合はそれをクロージャに渡して実行
        if let cacheImage = cacheImage {
            succeess(cacheImage)
        }
        // リクエストを作成
        var request = URLRequest(url: URL(string: imageURL)!)
        request.httpMethod = "GET"

        // 通信タスクを作成
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            // エラーがあればそれをクロージャに渡して実行
            if let error = error {
                DispatchQueue.main.async {
                    failure(error)
                }
                return
            }
            // dataがnilの場合、unknownエラーをクロージャに渡して実行
            guard let data = data else {
                DispatchQueue.main.async {
                    failure(APIError.unknown)
                }
                return
            }
            // dataからUIImageを生成し、クロージャに渡して実行
            guard let imageFromData = UIImage(data: data) else {
                // 生成に失敗した場合、unknownエラーをクロージャに渡して実行
                DispatchQueue.main.async {
                    failure(APIError.unknown)
                }
                return
            }
            DispatchQueue.main.async {
                succeess(imageFromData)
            }
            // 画像をキャッシュ
            self.cacheImage = imageFromData
        }
        // 実行
        task.resume()
    }
}

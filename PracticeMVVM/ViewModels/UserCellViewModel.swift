//
//  UserCellViewModel.swift
//  PracticeMVVM
//
//  Created by Johnny Toda on 2022/11/05.
//

import Foundation
import UIKit

// ダウンロード進捗状況をenumで管理
enum ImageDownloadProgress {
    case loading(UIImage)
    case finish(UIImage)
    case error
}

final class UserCellViewModel {
    // ユーザーを保持
    private var user: User

    // userを引数としてinit
    init(user: User) {
        self.user = user
    }

    // モデルImageDownloader型のインスタンスを保持
    private let imageDownloader = ImageDownloader()

    // ダウンロード中か否かを識別するプロパティ
    private var isLoading = false

    // 通信で取得したユーザー名を返す
    var userName: String {
        user.name
    }

    // セルを選択時に必要となるURL
    var webURL: URL {
        URL(string: user.webURL)!
    }

    // 画像のダウンロードを実行
    func downloadImage(progress: @escaping (ImageDownloadProgress) -> Void) {
        // if isLoadingだけだとfalseならreturnするって感じになるのかな。
        if isLoading == true {
            return
        }
        isLoading = true

        // グレー色のUIIMageを生成
        let loadingImage = UIImage(color: .gray, size: CGSize(width: 45, height: 45))!

        // loading状態を表す画像をクロージャに渡して実行
        progress(.loading(loadingImage))

        // 画像をダウンロード
        imageDownloader.downloadImage(imageURL: user.iconURL, succeess: { image in
            progress(.finish(image))
            self.isLoading = false
        }) { error in
            progress(.error)
            self.isLoading = false
        }
    }
}

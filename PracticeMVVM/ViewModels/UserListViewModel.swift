//
//  UserListViewModel.swift
//  PracticeMVVM
//
//  Created by Johnny Toda on 2022/11/05.
//

import Foundation

// 各通信状況をenumで定義
enum ViewModelState {
    case loading
    case finish
    case error(Error)
}

final class UserListViewModel {
    // 通信状況を保持し、ViewControllerに対して通知する役割を担う
    var stateDidUpdate: ((ViewModelState) -> Void)?

    // userの配列
    private var users: [User] = []

    // UserCellViewModelの配列
    var cellModels: [UserCellViewModel] = []

    // モデルAPIクラスのインスタンスを保持
    let api = API()

    // API通信を実行してユーザーデータを取得
    func fetchUsers() {
        stateDidUpdate?(.loading)
        users.removeAll()

        api.fetchUsers(success: { (users) in
            self.users.append(contentsOf: users)
            users.forEach {
                let cellViewModel = UserCellViewModel(user: $0)
                self.cellModels.append(cellViewModel)

                // 通信完了の通知を送る
                self.stateDidUpdate?(.finish)
            }
        }) {
            // 通信失敗の通知を送る
            self.stateDidUpdate?(.error($0))
        }
    }

    // numberOfRowsInSectionで必要なアウトプット
    func usersCount() -> Int {
        users.count
    }
}

//
//  UserListViewController.swift
//  PracticeMVVM
//
//  Created by Johnny Toda on 2022/11/07.
//

import UIKit
import SafariServices

final class UserListViewController: UIViewController {
    fileprivate var viewModel: UserListViewModel!
    fileprivate var tableView: UITableView!
    fileprivate var refreshControl: UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        setUpRefreshControl()
        setUpViewModel()
        viewModel.fetchUsers()
    }

    // TableViewを生成し、画面に表示する設定
    private func setUpTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UserListCell.self, forCellReuseIdentifier: UserListCell.identifier)
        view.addSubview(tableView)
    }

    // RefreshControlを生成し、画面に表示する設定
    private func setUpRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlValueDidChange(sender:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    // リフレッシュ時、ユーザー情報を取得
    @objc func refreshControlValueDidChange(sender: UIRefreshControl) {
        viewModel.fetchUsers()
    }

    // UserListViewModelを生成
    private func setUpViewModel() {
        viewModel = UserListViewModel()
        viewModel.stateDidUpdate = { [weak self] state in
            switch state {
            // 通信中はtableViewを操作不可にする
            case .loading:
                self?.tableView.isUserInteractionEnabled = false
            // 通信完了後はtableViewを操作可能にし、更新を行う。
            case .finish:
                self?.tableView.isUserInteractionEnabled = true
                self?.tableView.reloadData()
                self?.refreshControl.endRefreshing()
            // エラーが発生した場合はエラーを知らせるAlertを表示
            case .error(let error):
                self?.tableView.isUserInteractionEnabled = true
                self?.refreshControl.endRefreshing()
                self?.showErrorAlert(error: error)
            }
        }
    }

    // エラーをユーザーに知らせるアラート
    private func showErrorAlert(error: Error) {
        let alertController = UIAlertController(title: error.localizedDescription, message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(alertController, animated: true)
    }

    private func showUserPage(userURL: URL) {
        let webVC = SFSafariViewController(url: userURL)
        navigationController?.pushViewController(webVC, animated: true)
    }
}

extension UserListViewController: UITableViewDelegate, UITableViewDataSource {
    // セルの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
    // UserListViewModelで定義したusersCountメソッドを呼び出してCellの数を決める
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.usersCount()
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserListCell.identifier, for: indexPath) as! UserListCell

        let cellViewModel = viewModel.cellModels[indexPath.row]

        // Cellのオブジェクトに取得したデータをセット
        cell.setName(name: cellViewModel.userName)
        cellViewModel.downloadImage { (progress) in
            switch progress {
            case .loading(let uiImage):
                cell.setImage(icon: uiImage)
                break
            case .finish(let uiImage):
                cell.setImage(icon: uiImage)
                break
            case .error:
                break
            }
        }
        return cell
    }

    // Cellをタップ時、各ユーザーの詳細ページに遷移
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#function)
        let cellViewModel = viewModel.cellModels[indexPath.row]
        let userURL = cellViewModel.webURL
        showUserPage(userURL: userURL)
    }
}
